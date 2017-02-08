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
        
        FileName; %Filename of the selected file.
        PathName; %Directory path of the selected file.
        PicPRGBFRPlanes; %RGB image created from the red blue green and far red color plane images.
        handlePicRGB; %handle to RGB image.
        PicBW; %Binary image.
        PicPlaneGreen; %Green identified color plane image.
        PicPlaneBlue; %Blue identified color plane image.
        PicPlaneRed; %Red identified color plane image.
        PicPlaneFarRed; %Farred identified color plane image.
        PicPRGBPlanes; %RGB image created from the red blue and green color plane images.
        
        FiberInfo = {}; %Cell array that contains the data that are shown in the fiber information table.
        BoundarieMat; %Array that contains all boundaries of the fiber objects.
        LabelMat; %Label array of all fiber objects.
        PicInvertBW; %iInverted binary image. Used for labeling the objects.
        handleInfoAxes; %Handle to axes that is shown in the fiber information panel.
        oldValueMinArea; %Min area from previous calculation. If the value changed the objects must be labeled again.
        oldValueXScale; %XScale from previous calculation. If the value changed the objects must be labeled again.
        oldValueYScale; %XScale from previous calculation. If the value changed the objects must be labeled again.
        
        AnalyzeMode; %Indicates the selected analyze mode.
        
        AreaActive; %Indicates if Area parameter is used for classification.
        MinArea; %Minimal allowed Area in ?m^2 based on th X and YScale factors. Is used for classification. Smaller Objects will be removed from binary mask.
        MaxArea; %Maximal allowed Area in ?m^2 based on th X and YScale factors. Is used for classification. Larger Objects will be classified as Type 0.
        
        AspectRatioActive; %Indicates if AspectRatio parameter is used for classification.
        MinAspectRatio; %Minimal allowed AspectRatio. Is used for classification. Objects with smaller AspectRatio will be classified as Type 0.
        MaxAspectRatio; %Minimal allowed AspectRatio. Is used for classification. Objects with larger AspectRatio will be classified as Type 0.
        
        RoundnessActive; %Indicates if Roundness parameter is used for classification.
        MinRoundness; %Minimal allowed Roundness. Is used for classification. Objects with smaller Roundness will be classified as Type 0.
        
        ColorValueActive; %Indicates if ColorValue parameter is used for classification.
        ColorValue; %Minimal allowed ColorValue. Is used for classification. Objects with smaller ColorValue will be classified as Type 0.
        
        BlueRedThreshActive; %Indicates if Blue/Red Threshold parameter is used for classification.
        BlueRedThresh;
        BlueRedDistBlue;
        BlueRedDistRed;
        
        FarredRedThreshActive; %Indicates if Farred/Red Threshold parameter is used for classification.
        FarredRedThresh;
        FarredRedDistFarred;
        FarredRedDistRed;
        
        XScale; %Inicates the um/pixels in X direction to change values in micro meter
        YScale; %Inicates the um/pixels in Y direction to change values in micro meter
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
            
            if isempty(obj.Stats) || ~isequal(obj.oldValueMinArea,obj.MinArea) ...
                    || ~isequal(obj.oldValueXScale,obj.XScale) || ~isequal(obj.oldValueYScale,obj.YScale)
                % Calculation runs the first time or changes at binary
                % mask by user
                
                % label all objects in the binary mask
                obj.labelingObjects();
                
                obj.calculateDiameters();
                
                % calculate roundness for each fiber objects
                obj.calculateRoundness();
                
                % calculate aspect ratio for each fiber objects
                obj.calculateAspectRatio();
                
                % calculate color features for each fiber objects
                obj.calculatingFiberColor();
            else
                obj.InfoMessage = '   - object labeling alreaey done';
                obj.InfoMessage = '   - calculating Diameters already done';
                obj.InfoMessage = '   - calculating Roundness already done';
                obj.InfoMessage = '   - calculating Aspect Ratio already done';
                obj.InfoMessage = '   - calculating Fiber Color already done';
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
            
            obj.oldValueXScale = obj.XScale;
            obj.oldValueYScale = obj.YScale;
            
            obj.InfoMessage = '   - labeling objects...';
            
            obj.PicInvertBW = ~obj.PicBW;
            
            % Fill holes in the binary image
            obj.PicInvertBW = imfill(obj.PicInvertBW,8,'holes');
            
            if obj.AreaActive
                % Remove all objects that are smaller than the MinArea
                % value
                obj.InfoMessage = ['      - remove objects smaller than ' num2str(obj.MinArea) ' ' sprintf(' \x3BCm') '^2'];
                obj.oldValueMinArea = obj.MinArea;
                
                %convert area in ?m^2 to pixels. must be a positiv integer
                AreaPixel = ceil(obj.MinArea/(obj.XScale*obj.YScale));
                
                obj.PicInvertBW = bwareaopen(obj.PicInvertBW,AreaPixel,4);
            else
                % Remove single pixels
                obj.PicInvertBW = bwareaopen(obj.PicInvertBW,1,4);
            end
            
            [obj.BoundarieMat,obj.LabelMat] = bwboundaries(obj.PicInvertBW,4,'noholes');
            
            obj.InfoMessage = '      - measure properties of image objects';
            
            % calculate all region properties
            obj.Stats = regionprops('struct',obj.LabelMat,'Area','Perimeter','Centroid','BoundingBox','MajorAxisLength','MinorAxisLength','Solidity');
            
            obj.InfoMessage = ['         - transform Area from pixel^2 in ' sprintf(' \x3BCm') '^2'];
            obj.InfoMessage = ['            -XScale: ' num2str(obj.XScale) sprintf(' \x3BCm/pixel')];
            obj.InfoMessage = ['            -YScale: ' num2str(obj.YScale) sprintf(' \x3BCm/pixel')];
            for i=1:1:size(obj.Stats,1)
                % save Boundaries in Stats Struct
                obj.Stats(i).Area = obj.Stats(i).Area *obj.XScale *obj.YScale;
            end
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
        
        function calculateDiameters(obj)
            %             [obj.Stats(:).minDia] = deal(0);
            %             [obj.Stats(:).maxDia] = deal(0);
            
            noObjects = size(obj.Stats,1);
%             tempPicBW = size(obj.LabelMat);
            minDia =[];
            maxDia = [];
            
            %             figure(10)
            %             fig = imshow([]);
            
            
            % get oject for diameter measurment
%             BoundBox =   obj.Stats(i).BoundingBox;
%             
%             % create image that contains current object
%             tempPicBW = obj.LabelMat==i;
%             tic;
%             [y origPos]= imcrop(tempPicBW,[BoundBox(1) BoundBox(2) BoundBox(3) BoundBox(4)]);
            
            %                 ind = find(y);
            %                 [yind,xind]=ind2sub(size(y),ind);
            %                 v = cat(1,xind',yind');
            %                 c=minBoundingBox(v);
            
            %                 figure(42);
            %                 hold off,  imshow(y);
            %                 hold on,   plot(c(1,[1:end 1]),c(2,[1:end 1]),'r');
            
            %extend y mat
            %                 lext = max(origPos);
            %                 yext = wextend(2,'zpd',uint8(y),lext);
            %                 yext = logical(yext);
            %                 figure(10);
            %                 h = imshow(y);
            %                 rectLine=[];
            y = obj.LabelMat;
            for j=0:1:180/5
                
                maskRot = imrotate(y,j*5,'nearest','loose');
                stats = regionprops(y,'BoundingBox');
                
                for i=1:1:noObjects
                    boundBox = stats(i).BoundingBox;
                    minDia(i,j+1)= min([boundBox(3)*obj.XScale boundBox(4)*obj.YScale ]);
                    maxDia(i,j+1)= max([boundBox(3)*obj.XScale boundBox(4)*obj.YScale ]);
%                     rectLine = rectangle('Position',[stats.BoundingBox],'EdgeColor','r','LineWidth',2);
                end
                
                %             obj.Stats(i).MinorAxisLength = min(minDia);
                %             obj.Stats(i).MajorAxisLength = max(minDia);
                
                percent = j/(180/5);
                workbar(percent,'Please Wait...calculating diameters','Diameters');
            end
            
            for k=1:1:noObjects
                obj.Stats(k).MinorAxisLength = min(minDia(k,:));
                obj.Stats(k).MajorAxisLength = max(maxDia(k,:));
                percent = k/noObjects;
                workbar(percent,'Please Wait...saving diameters','Find min and max Diameters');
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
            [obj.Stats(:).ColorRatioFarredRed] = deal(0);
            
            nObjects = size(obj.Stats,1);
            
            % convert original RGB image to HSV colormodel
            PicRGB_HSV = rgb2hsv(obj.handlePicRGB.CData);
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
                
                obj.Stats(i).ColorRed = meanRed;
                obj.Stats(i).ColorGreen = meanGreen;
                obj.Stats(i).ColorBlue = meanBlue;
                obj.Stats(i).ColorFarRed = meanFarRed;
                obj.Stats(i).ColorHue = meanColorH;
                obj.Stats(i).ColorValue = meanColorV;
                obj.Stats(i).ColorRatioFarredRed = meanFarRed/meanRed;
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
            hold on
            for i=1:1:nObjects
                %select boundarie color for diffrent fiber types
                switch obj.Stats(i).FiberType
                    case 'undefined'
                        % Type 0
                        Color = 'w';
                    case 'Type 1'
                        Color = 'b';
                    case 'Type 2x'
                        Color = 'r';
                    case 'Type 2a'
                        Color = 'y';    
                    case 'Type 2ax'
                        Color = [255/255 165/255 0]; %orange
                    case 'Type 12h'
                        % Type 3
                        Color = 'm';
                    otherwise
                        % error
                        Color = 'k';
                end
                
                
                
                htemp = visboundaries(axesh,obj.Stats(i).Boundarie,'Color',Color,'LineWidth',2);
                % Tag every Boundarie Line Object with his own Label number
                % to find them later for manipualtion
                set(htemp,'Tag',['boundLabel ' num2str(i)])
                
                percent = i/nObjects;
                if i == 1
                    % get workbar in foreground
                    pause(0.1)
                end
                workbar(percent,'Please Wait...ploting boundaries','Boundaries');
            end
            hold off
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
            
            %Number of main fiber types (numerical)
            NoMainFibtype1 = 0; % (blue) type 1 fiber
            NoMainFibtype2 = 0; % (red) type 2x and 2a combined
            NoMainFibtype3 = 0; % (magenta) type 12h fiber (1 2 hybrid)
            NoMainFibtype0 = 0; % (white) undefind fiber types
            
            %Number of specific fiber types
            NoFibtype1 = 0; % (blue) type 1 fiber
            NoFibtype2x = 0; % (red) type 2x fiber (no far red)
            NoFibtype2a = 0; % (yellow) type 2a fiber (far red)
            NoFibtype2ax = 0; % (orange)type 2ax fiber (2a 2x hybrid)
            NoFibtype12h = 0; % (magenta)type 12h fiber (1 2x hybrid)
            NoFibtype0 = 0; % (white) undefind fiber
            
            % Add Fields for FiberTypes to Stats Struct and set all values to
            % zero
            [obj.Stats(:).FiberTypeMainGroup] = deal(0);
            
            [obj.Stats(:).FiberType] = deal('');

            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Color-Based labeling
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if obj.AnalyzeMode == 1 || obj.AnalyzeMode == 2
                % Color-Based triple labeling
                %Use gren red and blue plane for fiber type classification.
                %seaarch for type 1 2x and 12h (type 1 2 hybrid) fibers
                
                for i=1:1:nObjects
                    
                    if obj.AreaActive && ( obj.Stats(i).Area > obj.MaxArea )
                        
                        % Object Area is to big. FiberType 0: No Fiber (white)
                        obj.Stats(i).FiberTypeMainGroup = 0;
                        obj.Stats(i).FiberType = 'undefined';
                        NoFibtype0 = NoFibtype0+1;
                        
                    elseif obj.AspectRatioActive && ( obj.Stats(i).AspectRatio < obj.MinAspectRatio || ...
                            obj.Stats(i).AspectRatio > obj.MaxAspectRatio )
                        
                        % ApsectRatio is to small or to great.
                        % FiberType 0: No Fiber (white)
                        obj.Stats(i).FiberTypeMainGroup = 0;
                        obj.Stats(i).FiberType = 'undefined';
                        NoFibtype0 = NoFibtype0+1;
                        
                    elseif obj.RoundnessActive && ( obj.Stats(i).Roundness < obj.MinRoundness )
                        
                        % Object Roundness is to small. FiberType 0: No Fiber (white))
                        obj.Stats(i).FiberTypeMainGroup = 0;
                        obj.Stats(i).FiberType = 'undefined';
                        NoFibtype0 = NoFibtype0+1;
                        
                    elseif obj.ColorValueActive && ( obj.Stats(i).ColorValue < obj.ColorValue )
                        
                        % Object ColorValue is to small. FiberType 0: No Fiber (white))
                        obj.Stats(i).FiberTypeMainGroup = 0;
                        obj.Stats(i).FiberType = 'undefined';
                        NoFibtype0 = NoFibtype0+1;
                        
                    elseif obj.BlueRedThreshActive
                        %Blue Red thresh is active. Searchinf for Type 1 2
                        %and 12 hybrid fibers
                        if obj.Stats(i).ColorRatioBlueRed >= obj.BlueRedThresh
                            
                            %Check for Limit Blue
                            if obj.Stats(i).ColorRatioBlueRed  < obj.BlueRedThresh/(1 - obj.BlueRedDistBlue)
                                % Type 1 2 hybrid
                                obj.Stats(i).FiberTypeMainGroup = 3;
                                obj.Stats(i).FiberType = 'Type 12h';
                                NoFibtype12h = NoFibtype12h+1;
                            else
                                % Type 1 fiber
                                obj.Stats(i).FiberTypeMainGroup = 1;
                                obj.Stats(i).FiberType = 'Type 1';
                                NoFibtype1 = NoFibtype1+1;
                                
                            end
                            
                        elseif obj.Stats(i).ColorRatioBlueRed < obj.BlueRedThresh
                            
                            %Check for Limit Blue
                            if obj.Stats(i).ColorRatioBlueRed  > obj.BlueRedThresh*(1 - obj.BlueRedDistRed)
                                % Type 1 2 hybrid (magenta)
                                obj.Stats(i).FiberTypeMainGroup = 3;
                                obj.Stats(i).FiberType = 'Type 12h';
                                NoFibtype12h = NoFibtype12h+1;
                            else
                                % Type 2 fiber (red)
                                % If Color-based quad labeling is active 
                                % check type 2 fibers
                                if obj.AnalyzeMode == 2
                                    % Color-Based quad labeling is active
                                    %Use green red farred and blue plane for fiber type classification.
                                    %seaarch for type 1 2x 2a 12h (type 1 2 hybrid) fibers and
                                    %2ax (type 2a 2x hybrid)
                                    if obj.FarredRedThreshActive
                                        % Farred/Red Thresh is active 
                                        if obj.Stats(i).ColorRatioFarredRed >= obj.FarredRedThresh
                                            %Check for Limit FarRed
                                            if obj.Stats(i).ColorRatioFarredRed  < obj.FarredRedThresh/(1 - obj.FarredRedDistFarred)
                                                % Type 2ax fiber (orange hybrid 2a 2x fiber)
                                                obj.Stats(i).FiberTypeMainGroup = 2;
                                                obj.Stats(i).FiberType = 'Type 2ax';
                                                NoFibtype2ax = NoFibtype2ax+1;
                                            else
                                                % Type 2a fiber 
                                                obj.Stats(i).FiberTypeMainGroup = 2;
                                                obj.Stats(i).FiberType = 'Type 2a';
                                                NoFibtype2a = NoFibtype2a+1;
                                                
                                            end
                                        elseif obj.Stats(i).ColorRatioFarredRed < obj.FarredRedThresh
                                            if obj.Stats(i).ColorRatioFarredRed  > obj.FarredRedThresh*(1 - obj.FarredRedDistFarred)
                                                % Type 2ax fiber (orange hybrid 2a 2x fiber)
                                                obj.Stats(i).FiberTypeMainGroup = 2;
                                                obj.Stats(i).FiberType = 'Type 2ax';
                                                NoFibtype2ax = NoFibtype2ax+1;
                                            else
                                                % Type 2x fiber 
                                                obj.Stats(i).FiberTypeMainGroup = 2;
                                                obj.Stats(i).FiberType = 'Type 2x';
                                                NoFibtype2x = NoFibtype2x+1;
                                                
                                            end
                                        end
                                    else % Farred/Red Thresh is not active
                                        if obj.Stats(i).ColorRatioBlueRed  <= 1
                                            % Type 2x fiber 
                                            obj.Stats(i).FiberTypeMainGroup = 2;
                                            obj.Stats(i).FiberType = 'Type 2x';
                                            NoFibtype2x = NoFibtype2x+1;
                                        elseif obj.Stats(i).ColorRatioBlueRed  > 1
                                            % Type 2a fiber
                                            obj.Stats(i).FiberTypeMainGroup = 2;
                                            obj.Stats(i).FiberType = 'Type 2a';
                                            NoFibtype2a = NoFibtype2a+1;
                                            
                                        end
                                    end
                                else
                                    obj.Stats(i).FiberTypeMainGroup = 2;
                                    obj.Stats(i).FiberType = 'Type 2x';
                                    NoFibtype2a = NoFibtype2a+1;
                                end
                            end
                        end
                        
                    elseif ~obj.BlueRedThreshActive
                        %Blue Red thresh is not active. Searching for Type
                        %1 and 2 fibers
                        if obj.Stats(i).ColorRatioBlueRed >= 1
                            % Type 1 fiber (blue)
                            obj.Stats(i).FiberTypeMainGroup = 1;
                            obj.Stats(i).FiberType = 'Type 1';
                            NoFibtype1 = NoFibtype1+1;
                        elseif obj.Stats(i).ColorRatioBlueRed < 1
                            % Type 2 fiber (red)
                                % If Color-based quad labeling is active 
                                % check type 2 fibers
                                if obj.AnalyzeMode == 2
                                    % Color-Based quad labeling is active
                                    %Use green red farred and blue plane for fiber type classification.
                                    %seaarch for type 1 2x 2a 12h (type 1 2 hybrid) fibers and
                                    %2ax (type 2a 2x hybrid)
                                    if obj.FarredRedThreshActive
                                        % Farred/Red Thresh is active 
                                        if obj.Stats(i).ColorRatioFarredRed >= obj.FarredRedThresh
                                            %Check for Limit FarRed
                                            if obj.Stats(i).ColorRatioBlueRed  < obj.FarredRedThresh/(1 - obj.FarredRedDistFarred)
                                                % Type 2ax fiber (orange hybrid 2a 2x fiber)
                                                obj.Stats(i).FiberTypeMainGroup = 2;
                                                obj.Stats(i).FiberType = 'Type 2ax';
                                                NoFibtype2ax = NoFibtype2ax+1;
                                            else
                                                % Type 2a fiber 
                                                obj.Stats(i).FiberTypeMainGroup = 2;
                                                obj.Stats(i).FiberType = 'Type 2a';
                                                NoFibtype2a = NoFibtype2a+1;
                                                
                                            end
                                        elseif obj.Stats(i).ColorRatioFarredRed < obj.FarredRedThresh
                                            if obj.Stats(i).ColorRatioFarredRed  > obj.FarredRedThresh*(1 - obj.FarredRedDistFarred)
                                                % Type 2ax fiber (orange hybrid 2a 2x fiber)
                                                obj.Stats(i).FiberTypeMainGroup = 2;
                                                obj.Stats(i).FiberType = 'Type 2ax';
                                                NoFibtype2ax = NoFibtype2ax+1;
                                            else
                                                % Type 2x fiber 
                                                obj.Stats(i).FiberTypeMainGroup = 2;
                                                obj.Stats(i).FiberType = 'Type 2x';
                                                NoFibtype2x = NoFibtype2x+1;
                                                
                                            end
                                        end
                                    else % Farred/Red Thresh is not active
                                        if obj.Stats(i).ColorRatioBlueRed  <= 1
                                            % Type 2x fiber 
                                            obj.Stats(i).FiberTypeMainGroup = 2;
                                            obj.Stats(i).FiberType = 'Type 2x';
                                            NoFibtype2x = NoFibtype2x+1;
                                        elseif obj.Stats(i).ColorRatioBlueRed  > 1
                                            % Type 2a fiber
                                            obj.Stats(i).FiberTypeMainGroup = 2;
                                            obj.Stats(i).FiberType = 'Type 2a';
                                            NoFibtype2a = NoFibtype2a+1;
                                            
                                        end
                                    end
                                else
                                    obj.Stats(i).FiberTypeMainGroup = 2;
                                    obj.Stats(i).FiberType = 'Type 2x';
                                    NoFibtype2a = NoFibtype2a+1;
                                end
                        else
                            obj.Stats(i).FiberTypeMainGroup = 0;
                            obj.Stats(i).FiberType = 'undefined';
                            NoFibtype0 = NoFibtype0+1;
                        end
                        
                    else
                        %Error Code
                        obj.Stats(i).FiberType = 'Error';
                        obj.InfoMessage = '! ERROR in specifyFiberType() FUNCTION!';
                    end
                    
                    percent =   i/nObjects;
                    workbar(percent,'Please Wait...specifing Fiber-Type','Fiber-Type');
                    
                end
            
                
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%% Custer-Based quad labeling
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            elseif obj.AnalyzeMode == 3    
                
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
                    
                    if obj.AreaActive && ( obj.Stats(i).Area > obj.MaxArea )
                        
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
            
            obj.InfoMessage = ['         - ' num2str(NoFibtype1) ' Type-1 fibers were found (blue)'];
            
            obj.InfoMessage = ['         - ' num2str(NoFibtype2a) ' Type-2 fibers were found (red)'];
            
            obj.InfoMessage = ['         - ' num2str(NoFibtype2x) ' Type-3 fibers were found (magenta)'];
            
            obj.InfoMessage = ['         - ' num2str(NoFibtype0) ' Type-0 fibers were found (white)'];
            
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
            
            switch newFiberType %Fiber Type
                case 1
                    %Fiber Type 1 (blue)
                    newFiberType = 'Type 1';
                case 2
                    %Fiber Type 12h (hybird fiber) (magenta)
                    newFiberType = 'Type 12h';
                case 3
                    %Fiber Type 2x (red)
                    newFiberType = 'Type 2x';
                case 4
                    %Fiber Type 2a (yellow)
                    newFiberType = 'Type 2a';
                case 5
                    %Fiber Type 2ax (orange)
                    newFiberType = 'Type 2ax'; 
                case 6
                    %Fiber Type 0 (white)
                    newFiberType = 'undefined';
            end
            
            
            %get old fiber type
            oldFiberType = obj.Stats(labelNo).FiberType;
            
            if strcmp(newFiberType,oldFiberType)
                % Fiber Type hasn't changed
            else
                
                %Set SavedStatus in results model to false if a new analyze
                %were running or a fiber type hase changed and clear old
                %results data.
                obj.controllerAnalyzeHandle.controllerResultsHandle.clearData();
                
                % Fiber Type has changed
                
                %get axes with RGB image
                axesh = obj.handlePicRGB.Parent;
                
                %select boundarie color depending on the new fiber type
                switch newFiberType
                    case 'undefined'
                        % Type 0
                        Color = 'w';
                    case 'Type 1'
                        Color = 'b';
                    case 'Type 2x'
                        Color = 'r';
                    case 'Type 2a'
                        Color = 'y';    
                    case 'Type 2ax'
                        Color = [255/255 165/255 0]; %orange
                    case 'Type 12h'
                        % Type 3
                        Color = 'm';
                    otherwise
                        % error
                        Color = 'k';
                end
                
                % change finer type
                obj.Stats(labelNo).FiberType = newFiberType;
                
                % find old boundarie and delete them
                htemp = findobj('Tag',['boundLabel ' num2str(labelNo)]);
                delete(htemp);
                
                % plot new boundarie
                htemp = visboundaries(axesh,obj.Stats(labelNo).Boundarie,'Color',Color,'LineWidth',2);
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
            %               Data{3}: RGB image create from color plane
            %               images red green blue and farred.  
            %               Data{4}: RGB image create from color plane
            %               images red green and blue.            
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
            %               Data{16}: BlueRedThreshActive
            %               Data{17}: BlueRedThresh
            %               Data{18}: BlueRedDistBlue
            %               Data{19}: BlueRedDistRed
            %               Data{20}: FarredRedThreshActive
            %               Data{21}: FarredRedThresh
            %               Data{22}: FarredRedDistFarred
            %               Data{23}: oFarredRedDistRed
            %               Data{24}: ColorValueActive
            %               Data{25}: ColorValue
            %               Data{26}: XScale in ?m/pixel
            %               Data{27}: YScale in ?m/pixel
            %               
            
            Data{1} = obj.FileName;
            Data{2} = obj.PathName;
            Data{3} = obj.PicPRGBFRPlanes;
            Data{4} = obj.PicPRGBPlanes;
            Data{5} = obj.Stats;
            Data{6} = obj.LabelMat;
            
            % Analyze Parameter
            Data{7} = obj.AnalyzeMode;
            Data{8} = obj.AreaActive;
            Data{9} = obj.MinArea;
            Data{10} = obj.MaxArea;
            
            Data{11} = obj.AspectRatioActive;
            Data{12} = obj.MinAspectRatio;
            Data{13} = obj.MaxAspectRatio;
            
            Data{14} = obj.RoundnessActive;
            Data{15} = obj.MinRoundness;
            
            Data{16} = obj.BlueRedThreshActive;
            Data{17} = obj.BlueRedThresh;
            Data{18} = obj.BlueRedDistBlue;
            Data{19} = obj.BlueRedDistRed;
            
            Data{20} = obj.FarredRedThreshActive;
            Data{21} = obj.FarredRedThresh;
            Data{22} = obj.FarredRedDistFarred;
            Data{23} = obj.FarredRedDistRed;
            
            Data{24} = obj.ColorValueActive;
            Data{25} = obj.ColorValue;
            
            Data{26} = obj.XScale;
            Data{27} = obj.YScale;
            
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
            %               Info{5}: BlueRed ratio
            %               Info{6}: FarredRed ratio
            %               Info{7}: mean Red
            %               Info{8}: mean Green
            %               Info{9}: mean Blue
            %               Info{10}: mean Farred
            %               Info{11}: color Value
            %               Info{12}: FiberType
            %               Info{13}: Cropped image of fiber type
            %               Info{14}: Boundarie of object
            
            PosOut = obj.checkPosition(Pos);
            
            
            if ~obj.CalculationRunning &&...
                    ( ~isnan(PosOut(1)) && ~isnan(PosOut(2)) ) &&...
                    ~isempty(obj.Stats)
                
                Label = obj.LabelMat(PosOut(2),PosOut(1));
                
                if (Label > 0)
                    %fiber object were selected
                    
                    BoundBox =   round(obj.Stats(Label).BoundingBox);
                    
                    [y origPos]= imcrop(obj.PicPRGBFRPlanes,[BoundBox(1) BoundBox(2) BoundBox(3) BoundBox(4)]);
                    Bound = obj.Stats(Label).Boundarie;
                    Bound{1,1}(:,1) = Bound{1,1}(:,1)-origPos(2);
                    Bound{1,1}(:,2) = Bound{1,1}(:,2)-origPos(1);
                    
                    obj.FiberInfo{1} = num2str(Label);
                    obj.FiberInfo{2} = num2str(obj.Stats(Label).Area);
                    obj.FiberInfo{3} = num2str(obj.Stats(Label).AspectRatio);
                    obj.FiberInfo{4} = num2str(obj.Stats(Label).Roundness);
                    obj.FiberInfo{5} = num2str(obj.Stats(Label).ColorRatioBlueRed);
                    obj.FiberInfo{6} = num2str(obj.Stats(Label).ColorRatioFarredRed);
                    obj.FiberInfo{7} = num2str(obj.Stats(Label).ColorRed);
                    obj.FiberInfo{8} = num2str(obj.Stats(Label).ColorGreen);
                    obj.FiberInfo{9} = num2str(obj.Stats(Label).ColorBlue);
                    obj.FiberInfo{10} = num2str(obj.Stats(Label).ColorFarRed);
                    obj.FiberInfo{11} = num2str(obj.Stats(Label).ColorValue);
                    obj.FiberInfo{12} = obj.Stats(Label).FiberType;
                    
                    obj.FiberInfo{13} = y;
                    obj.FiberInfo{14} = Bound;
                    Info = obj.FiberInfo;

                else
                    %click in the background
                    Info = obj.FiberInfo;
                    
                end
                
            else
                obj.FiberInfo{1} = '-';
                obj.FiberInfo{2} = '-';
                obj.FiberInfo{3} = '-';
                obj.FiberInfo{4} = '-';
                obj.FiberInfo{5} = '-';
                obj.FiberInfo{6} = '-';
                obj.FiberInfo{7} = '-';
                obj.FiberInfo{8} = '-';
                obj.FiberInfo{9} = '-';
                obj.FiberInfo{10} = '-';
                obj.FiberInfo{11} = '-';
                obj.FiberInfo{12} = '-';
                
                obj.FiberInfo{13} = [];
                obj.FiberInfo{14} = [];
                
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
            
            if PosX > size(obj.PicPRGBFRPlanes,2)
                PosX = NaN;
            end
            
            if PosY > size(obj.PicPRGBFRPlanes,1)
                PosY = NaN;
            end
            
            PosOut = [PosX PosY];
        end
        
        function delete(obj)
            %deconstructor
        end
        
    end
    
end

