classdef modelAnalyze < handle
    %modelAnalyze   Model of the analyze-MVC (Model-View-Controller). Runs
    %all nessesary calculations. Is connected and gets controlled by the
    %correspondening Controller.
    %The main tasks are:
    %   - labeling all objects that will be founded in the bianry mask.
    %   - calculate the roundness of all fiber objects.
    %   - calculate the aspect ration of all fiber objects.
    %   - calculate the color features of all fiber objects.
    %   - specify all fiber objects with the given parameters.
    %   - ploting all boundaries of all fiber objects.
    %   - allows user to change fiber type manualy.
    %
    %
    %======================================================================
    %
    % AUTHOR:           - Sebastian Friedrich,
    %                     Trier University of Applied Sciences, Germany
    %
    % SUPERVISOR:       - Prof. Dr.-Ing. K.P. Koch
    %                     Trier University of Applied Sciences, Germany
    %
    %                   - Mr Justin Perkins, BVetMed MS CertES Dip ECVS MRCVS
    %                     The Royal Veterinary College, Hertfordshire United Kingdom
    %
    % FIRST VERSION:    30.12.2016 (V1.0)
    %
    % REVISION:         none
    %
    %======================================================================
    %
    
    properties
        
        controllerAnalyzeHandle; %hande to controllerAnalyze instance.
        
        FileNamesRGB; %Filename of the selected RGB image.
        PathNames; %Directory path of the selected RGB image.
        PicRGB; %RGB image.
        handlePicRGB; %handle to RGB image.
        PicBW; %Binary image.
        PicPlaneGreen; %Green identified color plane image.
        PicPlaneBlue; %Blue identified color plane image.
        PicPlaneRed; %Red identified color plane image.
        PicPlaneFarRed; %Farred identified color plane image.
        PicPRGBPlanes; %RGB image created from the color plane images.
        
        FiberInfo = {}; %Cell array that contains the data that are shown in the fiber information table.
        BoundarieMat; %Array that contains all boundaries of the fiber objects.
        LabelMat; %Label array of all fiber objects.
        PicInvertBW; %iInverted binary image. Used for labeling the objects.
        handleInfoAxes; %Handle to axes that is shown in the fiber information panel.
        oldValueMinArea; %Min area from previous calculation. If the value changed the objects must be labeled again.
        
        AnalyzeMode; %Indicates the selected analyze mode.
        
        AreaActive; %Indicates if Area parameter is used for classification.
        MinAreaPixel; %Minimal allowed Area. Is used for classification. Smaller Objects will be removed from binary mask.
        MaxAreaPixel; %Maximal allowed Area. Is used for classification. Larger Objects will be classified as Type 0.
        
        AspectRatioActive; %Indicates if AspectRatio parameter is used for classification.
        MinAspectRatio; %Minimal allowed AspectRatio. Is used for classification. Objects with smaller AspectRatio will be classified as Type 0.
        MaxAspectRatio; %Minimal allowed AspectRatio. Is used for classification. Objects with larger AspectRatio will be classified as Type 0.
        
        RoundnessActive; %Indicates if Roundness parameter is used for classification.
        MinRoundness; %Minimal allowed Roundness. Is used for classification. Objects with smaller Roundness will be classified as Type 0.
        
        ColorDistanceActive; %Indicates if ColorDistance parameter is used for classification.
        MinColorDistance; %Minimal allowed ColorDistance. Is used for classification. Objects with smaller ColorDistance will be classified as Type 3.
        
        ColorValueActive; %Indicates if ColorValue parameter is used for classification.
        ColorValue; %Minimal allowed ColorValue. Is used for classification. Objects with smaller ColorValue will be classified as Type 0.
        
        CalculationRunning; %Indicates if any caluclation is still running.
        
        Stats; % Data struct of all fiber objets.
    end
    
    properties(SetObservable)
        
        InfoMessage; %Last info message in the GUI log text. Observed by the Controller.
        
    end
    
    methods
        
        function obj = modelAnalyze()
            % Constuctor of the modelAnalyze class.
            %
            %   obj = modelAnalyze();
            %
            %   ARGUMENTS:
            %
            %       - Input
            %
            %       - Output
            %           obj:    Handle to modelAnalyze object
            %
            
            % Don't execute showFiberInformation befor analyze was running.
            obj.CalculationRunning = true;
            
            % Show no Information in the fiber info panel befor analyze was
            % running.
            obj.FiberInfo{1} = '-';
            obj.FiberInfo{2} = '-';
            obj.FiberInfo{3} = '-';
            obj.FiberInfo{4} = '-';
            obj.FiberInfo{5} = '-';
            obj.FiberInfo{6} = '-';
            obj.FiberInfo{7} = '-';
            obj.FiberInfo{8} = [];
        end
        
        function startAnalysze(obj)
            % Check if the binary mask has changed and calls all necessary
            % functions for the clasification.
            %
            %   startAnalysze(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            % Don't execute showFiberInformation during calculation.
            obj.CalculationRunning = true;
            
            obj.InfoMessage = '- start analyzing';
            
            if isempty(obj.Stats) || ~isequal(obj.oldValueMinArea,obj.MinAreaPixel)
                % Calculation runs the first time or changes at binary
                % mask by user
                
                % label all objects in the binary mask
                obj.labelingObjects();
                
                % calculate roundness for each fiber objects
                obj.calculateRoundness();
                
                % calculate aspect ratio for each fiber objects
                obj.calculateAspectRatio();
                
                % calculate color features for each fiber objects
                obj.calculatingFiberColor();
            else
                obj.InfoMessage = '   - object labeling alreaey done';
                obj.InfoMessage = '   - calculating Roundness alreaey done';
                obj.InfoMessage = '   - calculating Aspect Ratio alreaey done';
                obj.InfoMessage = '   - calculating Fiber Color alreaey done';
            end
            
            % classify all fiber objects
            obj.specifyFiberType();
            
            % plot boundaries 
            obj.plotBoundaries();
            
            obj.InfoMessage = '- analyzing completed';
            
            obj.CalculationRunning = false;
            
        end
        
        function labelingObjects(obj)
            % Labels all objects and calculates all region properties for
            % each object. All data will be saved in the Stats table.
            %
            %   labelingObjects(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            obj.InfoMessage = '   - labeling objects...';
            
            obj.PicInvertBW = ~obj.PicBW;
            
            % Fill holes in the binary image
            obj.PicInvertBW = imfill(obj.PicInvertBW,8,'holes');
            
            if obj.AreaActive
                % Remove all objects that are smaller than the MinArea
                % value
                obj.InfoMessage = ['      - remove objects smaller than ' num2str(obj.MinAreaPixel) ' pixels'];
                obj.oldValueMinArea = obj.MinAreaPixel;
                
                obj.PicInvertBW = bwareaopen(obj.PicInvertBW,obj.MinAreaPixel,4);
            else
                % Remove single pixels
                obj.PicInvertBW = bwareaopen(obj.PicInvertBW,1,4);
            end
            
            [obj.BoundarieMat,obj.LabelMat] = bwboundaries(obj.PicInvertBW,4,'noholes');
            
            obj.InfoMessage = '      - measure properties of image objects';
            
            % calculate all region properties
            obj.Stats = regionprops('struct',obj.LabelMat,'Area','Perimeter','Centroid','BoundingBox','MajorAxisLength','MinorAxisLength','Solidity');
            
            % Add Field Boundarie to Stats Struct and set all Values to
            % zero
            [obj.Stats(:).Boundarie] = deal(0);
            
            obj.InfoMessage = '      - save boundaries';
            
            for i=1:1:size(obj.Stats,1)
                % save Boundaries in Stats Struct
                obj.Stats(i).Boundarie = mat2cell(obj.BoundarieMat{i,1},size(obj.BoundarieMat{i,1},1),size(obj.BoundarieMat{i,1},2));
            end
            
            obj.InfoMessage = ['      - ' num2str(length(obj.Stats)) ' objects was found'];
            
            
        end
        
        function calculateRoundness(obj)
            % Calculates the roundness for each fiber object. 
            %
            %   calculateRoundness(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            obj.InfoMessage = '   - calculating roundness...';
            
            % Add Field Roundness to Stats Struct ans set all Values to
            % zero
            [obj.Stats(:).Roundness] = deal(0);
            
            for i=1:1:size(obj.Stats,1)
                
                % Surface of a circle with MajorAxis as diameter;
                A_Cmax = obj.Stats(i).MajorAxisLength^2 * pi / 4;
                
                % Surface of a circle with MinorAxis as diameter;
                A_Cmin = obj.Stats(i).MinorAxisLength^2 * pi / 4;
                
                % Surface of fiber object
                A_Fiber = obj.Stats(i).Area;
                
                % Similarity between fiber object surface and MajorAxis
                % circle surface
                Ratiomax = A_Fiber/A_Cmax;
                
                % Similarity between fiber object surface and MinorAxis
                % circle surface
                Ratiomin = A_Fiber/A_Cmin;
                
                % Roundenss. Normalized distance between Ratiomax and Ratiomin
                obj.Stats(i).Roundness = 1 - (abs( Ratiomax -  Ratiomin))/max([Ratiomax  Ratiomin]);
            end
        end
        
        function calculateAspectRatio(obj)
            % Calculates the aspect ratio for each fiber object. Aspect
            % ratio is the ration between the MajorAxisLength and the
            % MinorAxisLength.
            %
            %   calculateAspectRatio(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            obj.InfoMessage = '   - calculating aspect ratio...';
            
            % Add Field AspectRation to Stats Struct and
            % set all values to zero
            [obj.Stats(:).AspectRatio] = deal(0);
            
            nObjects = size(obj.Stats,1);
            
            for i=1:1:nObjects
                obj.Stats(i).AspectRatio = obj.Stats(i).MajorAxisLength/obj.Stats(i).MinorAxisLength;
            end
            
        end
        
        function calculatingFiberColor(obj)
            % Calculates the color features for each fiber object:
            %   - mean Red Color from redColorPlane image
            %   - mean Green Color from greenColorPlane image
            %   - mean Blue Color from blueColorPlane image
            %   - mean Farred Color from farredColorPlane image
            %   - ratio meanBlue / meanRed
            %   - distance meanBlue / meanRed normalized
            %   - mean Color-Hue (HSV Colormodel) from RGB image
            %   - mean Color-Value (HSV Colormodel) from RGB image
            %
            %   calculatingFiberColor(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            obj.InfoMessage = '   - calculating fiber color...';
            
            % Add color feature fields  to Stats Struct and
            % set all values to zero
            [obj.Stats(:).ColorHue] = deal(0); %Hue-channel of HSV colormodel
            [obj.Stats(:).ColorValue] = deal(0); %Value-channel of HSV colormodel
            [obj.Stats(:).ColorRed] = deal(0);
            [obj.Stats(:).ColorGreen] = deal(0);
            [obj.Stats(:).ColorBlue] = deal(0);
            [obj.Stats(:).ColorFarRed] = deal(0);
            [obj.Stats(:).ColorRatioBlueRed] = deal(0);
            [obj.Stats(:).ColorDistBlueRed] = deal(0);
            
            nObjects = size(obj.Stats,1);
            
            % convert original RGB image to HSV colormodel
            PicRGB_HSV = rgb2hsv(obj.PicRGB);
            PicRGB_H = PicRGB_HSV(:,:,1); % H-channel of HSV image
            PicRGB_V = PicRGB_HSV(:,:,3); % V-channel of HSV image
            
            for i=1:1:nObjects
                %Calculates the color features for each fiber object
                
                meanColorH =   mean( PicRGB_H(obj.LabelMat == i) );
                meanColorV =   mean( PicRGB_V(obj.LabelMat == i) );
                meanRed = mean( obj.PicPlaneRed(obj.LabelMat == i) );
                meanFarRed = mean( obj.PicPlaneFarRed(obj.LabelMat == i) );
                meanBlue = mean( obj.PicPlaneBlue(obj.LabelMat == i) );
                meanGreen = mean( obj.PicPlaneGreen(obj.LabelMat == i) );
                
                maxC = max([meanRed meanBlue]);
                
                if maxC == 0
                    % Dividing by 0 is uncool
                    maxC = 1;
                end
                
                obj.Stats(i).ColorRed = meanRed;
                obj.Stats(i).ColorGreen = meanGreen;
                obj.Stats(i).ColorBlue = meanBlue;
                obj.Stats(i).ColorFarRed = meanFarRed;
                obj.Stats(i).ColorHue = meanColorH;
                obj.Stats(i).ColorValue = meanColorV;
                obj.Stats(i).ColorDistBlueRed = (meanBlue - meanRed)/maxC;
                obj.Stats(i).ColorRatioBlueRed = meanBlue/meanRed;
                
                percent =   i/nObjects;
                workbar(percent,'Please Wait...calculating fiber color','Fiber-Color');
                
            end
            
        end
        
        function plotBoundaries(obj)
            % Show boundaries in the RGB image after classification.
            %
            %   plotBoundaries(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            obj.InfoMessage = '   - plot boundaries...';
            
            %Make axes with rgb image the current axes
            axesh = obj.handlePicRGB.Parent;
            axes(axesh)
            
            % Find old Boundarie Objects and delete them
            hBounds = findobj(axesh,'Type','hggroup');
            delete(hBounds);
            
            nObjects = size(obj.Stats,1);
            
            for i=1:1:nObjects
                %select boundarie color for diffrent fiber types
                switch obj.Stats(i).FiberType
                    case 0
                        Color = 'w';
                    case 1
                        Color = 'b';
                    case 2
                        Color = 'r';
                    case 3
                        Color = 'm';
                    otherwise
                        Color = 'b';
                end
                
                hold on
                
                htemp = visboundaries(axesh,obj.Stats(i).Boundarie,'Color',Color,'LineWidth',0.1);
                % Tag every Boundarie Line Object with his own Label number
                % to find them later for manipualtion
                set(htemp,'Tag',['boundLabel ' num2str(i)])
                
                percent =   i/nObjects;
                if i == 1
                    % get workbar in foreground
                    pause(0.1)
                end
                workbar(percent,'Please Wait...ploting boundaries','ploting boundaries');
            end
            
        end
        
        function specifyFiberType(obj)
            % Specifiy the fiber types depending on the selected analyzing
            % mode and the selected parameters.
            %
            %   specifyFiberType(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            obj.InfoMessage = '   - specifying fiber type';
            
            nObjects = size(obj.Stats,1);
            
            %Number of fiber types
            fibtype1 = 0; % (blue)
            fibtype2 = 0; % (red)
            fibtype3 = 0; % (magenta)
            fibtype0 = 0; % (white)
            
            % Add Field FiberType to Stats Struct and set all values to
            % zero
            [obj.Stats(:).FiberType] = deal(0);
            
            if obj.AnalyzeMode == 1 % Color-Based classification
                
                for i=1:1:nObjects
                    %
                    if obj.AreaActive && ( obj.Stats(i).Area > obj.MaxAreaPixel )
                        
                        % Object Area is to big. FiberType 0: No Fiber (white)
                        obj.Stats(i).FiberType = 0;
                        fibtype0 = fibtype0+1;
                        
                    elseif obj.AspectRatioActive && ( obj.Stats(i).AspectRatio < obj.MinAspectRatio || ...
                            obj.Stats(i).AspectRatio > obj.MaxAspectRatio )
                        
                        % ApsectRatio is to small or to great.
                        % FiberType 0: No Fiber (white)
                        obj.Stats(i).FiberType = 0;
                        fibtype0 = fibtype0+1;
                        
                    elseif obj.RoundnessActive && ( obj.Stats(i).Roundness < obj.MinRoundness )
                        
                        % Object Roundness is to small. FiberType 0: No Fiber (white))
                        obj.Stats(i).FiberType = 0;
                        fibtype0 = fibtype0+1;
                        
                    elseif obj.ColorValueActive && ( obj.Stats(i).ColorValue < obj.ColorValue )
                        
                        % Color Value (V-Channel of HSV color room) is to samll
                        % FiberType 0: No Fiber (white)
                        obj.Stats(i).FiberType = 0;
                        fibtype0 = fibtype0+1;
                        
                    elseif obj.ColorDistanceActive && ( abs(obj.Stats(i).ColorDistBlueRed) < obj.MinColorDistance )
                        
                        % Absolute Value of color distance between Blue and Red is to small.
                        % FiberType 3 (magenta): Fiber between Typ 1 and Typ 2
                        obj.Stats(i).FiberType = 3;
                        fibtype3 = fibtype3+1;
                        
                    elseif obj.Stats(i).ColorDistBlueRed > 0
                        
                        % Color distance is smaller than 0. Negative values
                        % means Red Color is greater. Fiber Type 1 (blue)
                        obj.Stats(i).FiberType = 1;
                        fibtype1 = fibtype1+1;
                        
                    elseif obj.Stats(i).ColorDistBlueRed < 0
                        
                        % Color distance is greater than 0. Positive values
                        % means Blue Color is greater. FIber Type 2 (red)
                        obj.Stats(i).FiberType = 2;
                        fibtype2 = fibtype2+1;
                        
                    else
                        %Error Code
                        obj.Stats(i).FiberType = 'Error';
                        obj.InfoMessage = '! ERROR in specifyFiberType() FUNCTION!';
                    end
                    
                    percent =   i/nObjects;
                    workbar(percent,'Please Wait...specifing Fiber-Type','Fiber-Type');
                    
                end
                
            elseif obj.AnalyzeMode == 2 || obj.AnalyzeMode == 3 % Cluster-Based classification
                % Search for 2 or 3 Clusters
                NoOfClusters = obj.AnalyzeMode;
                
                Data(:,1) = [obj.Stats.ColorBlue];
                Data(:,2) = [obj.Stats.ColorRed];
                Data(:,3) = [obj.Stats.ColorGreen];
                Data(:,4) = [obj.Stats.ColorFarRed];
                Data(:,5) = [obj.Stats.ColorHue];
                Data(:,6) = [obj.Stats.ColorValue];
                
                [idx,C] = kmeans(Data,NoOfClusters,'Distance','cityblock');
                % C contains the cluster focus points.
                % C(1,1) meanBlue of cluster 1 focus point
                % C(1,2) meanRed of cluster 1 focus point
                % C(2,1) meanBlue of cluster 2 focus point
                % C(2,2) meanRed of cluster 2 focus point
                % and so on.
                
                for i=1:1:size(C,1) %No of Clusters
                    %Gradient between red and blue  of the cluster centers.
                    %Highest gradient should be blue cluster center, lowest
                    %red cluster center. 
                    colorGradient(i) = C(i,1)/C(i,2);
                end
                
                % Find ClusterCenter with highest Gradient.
                % Blue Cluster
                [rowB colB] = find( colorGradient == max(colorGradient) );
                
                % Find ClusterCenter with smallest Gradient.
                % Red Cluster
                [rowR colR] = find( colorGradient == min(colorGradient) );
                
                idx = idx*10;
                
                idx(idx==colB*10) = 1; % FiberType 1
                idx(idx==colR*10) = 2; % FiberType 2
                idx(idx>9) = 3; % Fibertype 3
                
                for i=1:1:nObjects
                    
                    if obj.AreaActive && ( obj.Stats(i).Area > obj.MaxAreaPixel )
                        
                        % Object Area is to big. FiberType 0: No Fiber (white)
                        obj.Stats(i).FiberType = 0;
                        fibtype0 = fibtype0+1;
                        
                    elseif obj.AspectRatioActive && ( obj.Stats(i).AspectRatio < obj.MinAspectRatio || ...
                            obj.Stats(i).AspectRatio > obj.MaxAspectRatio )
                        
                        % ApsectRatio is to small or to great.
                        % FiberType 0: No Fiber (white)
                        obj.Stats(i).FiberType = 0;
                        fibtype0 = fibtype0+1;
                        
                    elseif obj.RoundnessActive && ( obj.Stats(i).Roundness < obj.MinRoundness )
                        
                        % Object Roundness is to small. FiberType 0: No Fiber (white))
                        obj.Stats(i).FiberType = 0;
                        fibtype0 = fibtype0+1;
                        
                    elseif obj.ColorValueActive && ( obj.Stats(i).ColorValue < obj.ColorValue )
                        
                        % Color Value (V-Channel of HSV color room) is to samll
                        % FiberType 0: No Fiber (white)
                        obj.Stats(i).FiberType = 0;
                        fibtype0 = fibtype0+1;
                        
                    elseif idx(i) == 1
                        
                        % Cluster Type 1
                        obj.Stats(i).FiberType = 1;
                        fibtype1 = fibtype1+1;
                        
                    elseif idx(i) == 2
                        
                        % Cluster Type 2
                        obj.Stats(i).FiberType = 2;
                        fibtype2 = fibtype2+1;
                        
                    elseif idx(i) == 3
                        
                        % Cluster Type 3
                        obj.Stats(i).FiberType = 3;
                        fibtype3 = fibtype3+1;
                    end
                    
                end
                
            end
            
            obj.InfoMessage = ['      - ' num2str(nObjects) ' objects were found'];
            
            obj.InfoMessage = ['         - ' num2str(fibtype1) ' Type-1 fibers were found (blue)'];
            
            obj.InfoMessage = ['         - ' num2str(fibtype2) ' Type-2 fibers were found (red)'];
            
            obj.InfoMessage = ['         - ' num2str(fibtype3) ' Type-3 fibers were found (magenta)'];
            
            obj.InfoMessage = ['         - ' num2str(fibtype0) ' Type-0 fibers were found (white)'];
            
        end
        
        function manipulateFiberOK(obj,newFiberType,labelNo)
            % Called fom the manipulateFiberOK() callback function in the
            % controller. Changed the fiber type if the user has changed
            % them.
            %
            %   manipulateFiberShowInfoEvent(obj,~,~);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %           src:    source of the callback.
            %           evnt:   callback event data.
            %
            
            if newFiberType == 4
                % FIber-Type 0 (no Fiber) has the Value 4 in the pushup
                % menu object
                newFiberType = 0;
            end
            
            %get old fiber type
            oldFiberType = obj.Stats(labelNo).FiberType;
            
            if newFiberType == oldFiberType
                % Fiber Type hasn't changed
            else
                % Fiber Type has changed
                
                %get axes with RGB image
                axesh = obj.handlePicRGB.Parent;
                
                %select boundarie color depending on the new fiber type
                switch newFiberType
                    case 0
                        Color = 'w';
                    case 1
                        Color = 'b';
                    case 2
                        Color = 'r';
                    case 3
                        Color = 'm';
                    otherwise
                end
                
                % change finer type
                obj.Stats(labelNo).FiberType = newFiberType;
                
                % find old boundarie and delete them
                htemp = findobj('Tag',['boundLabel ' num2str(labelNo)]);
                delete(htemp);
                
                % plot new boundarie
                htemp = visboundaries(axesh,obj.Stats(labelNo).Boundarie,'Color',Color,'LineWidth',0.1);
                set(htemp,'Tag',['boundLabel ' num2str(labelNo)])
                obj.InfoMessage = ['   - Fiber-Type object No. ' num2str(labelNo) ' changed by user'];
            end
            
        end
        
        function Data = sendDataToController(obj)
            % Send image informations and analyze parameters to the
            % controller.
            %
            %   Data = sendDataToController(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            %       - Output
            %           Data:    Cell Array that contains the file- and
            %               pathnames of the RGB. Also contains all analyze
            %               parameters:
            %
            %               Data{1}: filename RGB image.
            %               Data{2}: path RGB image.
            %               Data{3}: RGB image.
            %               Data{4}: RGB image create from color plane
            %               images.            
            %               Data{5}: Stats table that contains all fiber
            %               informations.
            %               Data{6}: Label array of all fiber objects.
            %               Data{7}: Selected analyze-mode
            %               Data{8}: Area active parameter
            %               Data{9}: Area min value
            %               Data{10}: Area max value
            %               Data{11}: Aspect ratio active parameter
            %               Data{12}: Aspect ratio min value
            %               Data{13}: Aspect ratio max value
            %               Data{14}: Roundness active parameter
            %               Data{15}: Roundness value
            %               Data{16}: ColorDistance active parameter
            %               Data{17}: ColorDistance value
            %               Data{18}: ColorValue active parameter
            %               Data{19}: ColorValuee value
            %               
            
            Data{1} = obj.FileNamesRGB;
            Data{2} = obj.PathNames;
            Data{3} = obj.PicRGB;
            Data{4} = obj.PicPRGBPlanes;
            Data{5} = obj.Stats;
            Data{6} = obj.LabelMat;
            
            % Analyze Parameter
            Data{7} = obj.AnalyzeMode;
            Data{8} = obj.AreaActive;
            Data{9} = obj.MinAreaPixel;
            Data{10} = obj.MaxAreaPixel;
            
            Data{11} = obj.AspectRatioActive;
            Data{12} = obj.MinAspectRatio;
            Data{13} = obj.MaxAspectRatio;
            
            Data{14} = obj.RoundnessActive;
            Data{15} = obj.MinRoundness;
            
            Data{16} = obj.ColorDistanceActive;
            Data{17} = obj.MinColorDistance;
            
            Data{18} = obj.ColorValueActive;
            Data{19} = obj.ColorValue;
            
        end
        
        function Info = getFiberInfo(obj,Pos)
            % Send the fiber information at the seleccted position to the
            % controller to show the data in the fiber manipulation figure.
            %
            %   Info = getFiberInfo(obj,Pos);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object.
            %           Pos:    Cursor position in RGB image.
            %
            %       - Output
            %           Info:   Cell array that contains the data that are
            %               shown in the fiber information panel in the GUI.
            %               Info{1}: Label
            %               Info{2}: Area
            %               Info{3}: AspectRatio
            %               Info{4}: Roundness
            %               Info{5}: ColorDistBlueRed
            %               Info{6}: ColorValue
            %               Info{7}: FiberType
            %               Info{8}: Cropped image of fiber type
            %               Info{9}: Boundarie of object
            
            PosOut = obj.checkPosition(Pos);
            
            
            if ~obj.CalculationRunning &&...
                    ( ~isnan(PosOut(1)) && ~isnan(PosOut(2)) ) &&...
                    ~isempty(obj.Stats)
                
                Label = obj.LabelMat(PosOut(2),PosOut(1));
                
                if (Label > 0)
                    %fiber object were selected
                    
                    BoundBox =   round(obj.Stats(Label).BoundingBox);
                    
                    [y origPos]= imcrop(obj.PicRGB,[BoundBox(1) BoundBox(2) BoundBox(3) BoundBox(4)]);
                    Bound = obj.Stats(Label).Boundarie;
                    Bound{1,1}(:,1) = Bound{1,1}(:,1)-origPos(2);
                    Bound{1,1}(:,2) = Bound{1,1}(:,2)-origPos(1);
                    
                    obj.FiberInfo{1} = num2str(Label);
                    obj.FiberInfo{2} = num2str(obj.Stats(Label).Area);
                    obj.FiberInfo{3} = num2str(obj.Stats(Label).AspectRatio);
                    obj.FiberInfo{4} = num2str(obj.Stats(Label).Roundness);
                    obj.FiberInfo{5} = num2str(obj.Stats(Label).ColorDistBlueRed);
                    obj.FiberInfo{6} = num2str(obj.Stats(Label).ColorValue);
                    obj.FiberInfo{7} = num2str(obj.Stats(Label).FiberType);
                    
                    obj.FiberInfo{8} = y;
                    obj.FiberInfo{9} = Bound;
                    Info = obj.FiberInfo;

                else
                    %click in the background
                    Info = obj.FiberInfo;
                    
                end
                
            else
                obj.FiberInfo{1} = ' - ';
                obj.FiberInfo{2} = ' - ';
                obj.FiberInfo{3} = ' - ';
                obj.FiberInfo{4} = ' - ';
                obj.FiberInfo{5} = ' - ';
                obj.FiberInfo{6} = ' - ';
                obj.FiberInfo{7} = ' - ';
                obj.FiberInfo{8} = [];
                obj.FiberInfo{9} = [];
                Info = obj.FiberInfo;
                
            end
        end
        
        function PosOut = checkPosition(obj,PosIn)
            PosX = round(PosIn(1,1));
            PosY = round(PosIn(1,2));
            
            if PosX < 1
                PosX = NaN;
            end
            
            if PosY < 1
                PosY = NaN;
            end
            
            if PosX > size(obj.PicRGB,2)
                PosX = NaN;
            end
            
            if PosY > size(obj.PicRGB,1)
                PosY = NaN;
            end
            
            PosOut = [PosX PosY];
        end
        
        function delete(obj)
            %deconstructor
        end
        
    end
    
end

