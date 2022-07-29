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
        
        Hybrid12FiberActive;
        Hybrid2axFiberActive;
        
        minPointsPerCluster;
        
        ClusterData;
        
        XScale; %Inicates the um/pixels in X direction to change values in micro meter
        YScale; %Inicates the um/pixels in Y direction to change values in micro meter
        CalculationRunning; %Indicates if any caluclation is still running.
        
        Stats; % Data struct of all fiber objets.
        
        ManualClassifyMode; %Inicates whether to classify main fiber types or for specify type 2 subgroups 
        
        busyIndicator; %Java object in the left bottom corner that shows whether the program is busy.
        busyObj; %All objects that are enabled during the calculation.
        
        
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
            obj.FiberInfo{8} = '-';
            obj.FiberInfo{9} = '-';
            obj.FiberInfo{10} = '-';
            obj.FiberInfo{11} = '-';
            obj.FiberInfo{12} = '-';
            
            obj.FiberInfo{13} = [];
            obj.FiberInfo{14} = [];
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
                
                % calculate Perimeter for each fiber object
                obj.calcultePerimeter();
                
                % calculate Diameter for each fiber object
                obj.calculateDiameters();
                
                % calculate roundness for each fiber object
                obj.calculateRoundness();
                
                % calculate aspect ratio for each fiber object
                obj.calculateAspectRatio();
                
                % calculate color features for each fiber object
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
            obj.controllerAnalyzeHandle.plotBoundaries();
            
            workbar(1,'completed','completed',obj.controllerAnalyzeHandle.mainFigure);
            
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
            obj.oldValueMinArea = obj.MinArea;
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
                %convert area in ?m^2 to pixels. must be a positive integer
                AreaPixel = ceil(obj.MinArea/(obj.XScale*obj.YScale));
                
                obj.PicInvertBW = bwareaopen(obj.PicInvertBW,AreaPixel,8);
            else
                % Remove single pixels
                obj.InfoMessage = ['      - remove single pixels'];
                obj.PicInvertBW = bwareaopen(obj.PicInvertBW,1,8);
            end
            
            [obj.BoundarieMat,obj.LabelMat] = bwboundaries(obj.PicInvertBW,4,'noholes');
            
            obj.InfoMessage = '      - measure properties of image objects';
            
            % calculate region properties
            obj.Stats = regionprops('struct',obj.LabelMat,'Area','Centroid','BoundingBox');
            
            obj.InfoMessage = ['         - transform Area from pixel^2 in ' sprintf(' \x3BCm') '^2'];
            obj.InfoMessage = ['            -XScale: ' num2str(obj.XScale) sprintf(' \x3BCm/pixel')];
            obj.InfoMessage = ['            -YScale: ' num2str(obj.YScale) sprintf(' \x3BCm/pixel')];
            for i=1:1:size(obj.Stats,1)
                % convert Area from pixel^2 in um^2
                obj.Stats(i).Area = obj.Stats(i).Area *obj.XScale *obj.YScale;
                obj.Stats(i).Centroid(1) = obj.Stats(i).Centroid(1) *obj.XScale;
                obj.Stats(i).Centroid(2) = obj.Stats(i).Centroid(2) *obj.YScale;
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
        
        function calcultePerimeter(obj)
            % Calculates the Perimeter for each fiber object. 
            %
            %   calculatePerimeter(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            % Add Field Perimeter to Stats Struct and set all Values to
            % zero
            
            obj.InfoMessage = '   - calculating perimeter...';
            
            [obj.Stats(:).Perimeter] = deal(0);
            for i=1:1:size(obj.Stats,1)
                
                
                d = diff(obj.BoundarieMat{i});
                d(:,2)=d(:,2).*obj.XScale;
                d(:,1)=d(:,1).*obj.YScale;
                d = d.^2;
                obj.Stats(i).Perimeter = sum(sqrt(sum(d,2))); 
                
                percent = (i-0.1)/size(obj.Stats,1);
                workbar(percent,'Please Wait...calculating perimeter','Permimeter',obj.controllerAnalyzeHandle.mainFigure); 
%                 pause(0.00001)
            end
            
%             peri = regionprops('struct',obj.LabelMat,'Perimeter','Area');
%             PeriOwn = [[obj.Stats.Area]' [obj.Stats.Perimeter]'];
%             PeriMatL= [[peri.Area]' [peri.Perimeter]'];
%             [Y,I]=sort(PeriOwn(:,1));
%             PeriOwnSort = PeriOwn(I,:);
%             [Y,I]=sort(PeriMatL(:,1));
%             PeriMatLSort = PeriMatL(I,:);
%             figure
%             
%             Err = (PeriMatLSort(:,2)-PeriOwnSort(:,2))/PeriMatLSort(:,2);
%             
%             plot(PeriOwnSort(:,1),Err);
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
            [obj.Stats(:).AreaMinCS] = deal(0);
            [obj.Stats(:).AreaMaxCS] = deal(0);
            
            for i=1:1:size(obj.Stats,1)
                
                % Surface of a circle with maxDiameter as diameter;
                A_Cmax = obj.Stats(i).maxDiameter^2 * pi / 4;
                
                % Surface of a circle with minDiameter as diameter;
                A_Cmin = obj.Stats(i).minDiameter^2 * pi / 4;
                
                % Surface of fiber object
                A_Fiber = obj.Stats(i).Area;
                
                % Similarity between fiber object surface and maxDiameter
                % circle surface
                Ratiomax = A_Fiber/A_Cmax;
                
                % Similarity between fiber object surface and minDiameter
                % circle surface
                Ratiomin = A_Fiber/A_Cmin;
                
                % Roundenss. Normalized distance between Ratiomax and Ratiomin
%                 obj.Stats(i).Roundness = 1 - (abs( Ratiomax -  Ratiomin))/max([Ratiomax  Ratiomin]);
                obj.Stats(i).Roundness =A_Fiber/A_Cmax;
                obj.Stats(i).AreaMaxCS = A_Cmax;
                obj.Stats(i).AreaMinCS = A_Cmin;
                percent = (i-0.1)/size(obj.Stats,1);
                workbar(percent,'Please Wait...calculating roundness','Roundness',obj.controllerAnalyzeHandle.mainFigure);
%                 pause(0.0001)
            end
        end
        
        function calculateDiameters(obj)
            
            obj.InfoMessage = '   - calculating diameters...';
            % Add Field maxDiameter and minDiameter to Stats Struct and set all 
            % Values to zero.
            [obj.Stats(:).maxDiameter] = deal(0);
            [obj.Stats(:).minDiameter] = deal(0);


            noObjects = size(obj.Stats,1);
%             tempPicBW = size(obj.LabelMat);
            minDia =[];
            maxDia = [];
            
            L = obj.LabelMat;
            angleStep = 1;
            angle=90;
            for j=0:1:angle/angleStep
                
                maskRot = imrotate(L,j*angleStep,'nearest','loose');

                stats = regionprops(maskRot,'BoundingBox');
%                 figure()
%                 imshow(maskRot)
                if noObjects == size(stats,1)
                    for i=1:1:noObjects
                        
                        b = stats(i).BoundingBox;
                        minDia(i,j+1)= min([b(3)*obj.XScale b(4)*obj.YScale ]);
                        maxDia(i,j+1)= max([b(3)*obj.XScale b(4)*obj.YScale ]);
%                     hold on 
%                     rectLine = rectangle('Position',stats(i).BoundingBox,'EdgeColor','r','LineWidth',2);
                    end
                else
                    for i=1:1:noObjects
                        % To fill up the min max vectors
                        
                        minDia(i,j+1)= Inf;
                        maxDia(i,j+1)= -Inf;
%                     hold on 
%                     rectLine = rectangle('Position',stats(i).BoundingBox,'EdgeColor','r','LineWidth',2);
                    end
                end
                
                
                
                percent = (abs(j-0.1))/(angle/angleStep);
                workbar(percent,'Please Wait...calculating diameters','Diameters',obj.controllerAnalyzeHandle.mainFigure);
%                 pause(0.00001)
            end
            
            obj.InfoMessage = '      - find min and max diameters...';
            for k=1:1:noObjects
                obj.Stats(k).minDiameter = min(minDia(k,:));
                obj.Stats(k).maxDiameter = max(maxDia(k,:));
                percent = (k-0.1)/noObjects;
                workbar(percent,'Please Wait...saving diameters','Find min and max Diameters',obj.controllerAnalyzeHandle.mainFigure);
%                 pause(0.00001)
            end
            
        end
        
        function calculateAspectRatio(obj)
            % Calculates the aspect ratio for each fiber object. Aspect
            % ratio is the ration between the maxDiameter and the
            % minDiameter.
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
                obj.Stats(i).AspectRatio = obj.Stats(i).maxDiameter/obj.Stats(i).minDiameter;
                percent = (i-0.1)/nObjects;
                workbar(percent,'Please Wait...calculating aspect ratio','Aspect Ratio',obj.controllerAnalyzeHandle.mainFigure);
%                 pause(0.00001)
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
            
            meanRed = regionprops(obj.LabelMat,obj.PicPlaneRed,'MeanIntensity');
            meanFarRed = regionprops(obj.LabelMat,obj.PicPlaneFarRed,'MeanIntensity');
            meanBlue = regionprops(obj.LabelMat,obj.PicPlaneBlue,'MeanIntensity');
            meanGreen = regionprops(obj.LabelMat,obj.PicPlaneGreen,'MeanIntensity');
            
            
            % Add color feature fields  to Stats Struct
            [obj.Stats(:).ColorValue] = deal(0); %Value-channel of HSV colormodel
            [obj.Stats(:).ColorRed] = deal(meanRed.MeanIntensity);
            [obj.Stats(:).ColorGreen] = deal(meanGreen.MeanIntensity);
            [obj.Stats(:).ColorBlue] = deal(meanBlue.MeanIntensity);
            [obj.Stats(:).ColorFarRed] = deal(meanFarRed.MeanIntensity);
            [obj.Stats(:).ColorRatioBlueRed] = deal(0);
            [obj.Stats(:).ColorRatioFarredRed] = deal(0);
            
            nObjects = size(obj.Stats,1);

            for i=1:1:nObjects

                obj.Stats(i).ColorRatioBlueRed = obj.Stats(i).ColorBlue/obj.Stats(i).ColorRed;
                obj.Stats(i).ColorRatioFarredRed = obj.Stats(i).ColorFarRed/obj.Stats(i).ColorRed;
                obj.Stats(i).ColorValue = max([obj.Stats(i).ColorRed obj.Stats(i).ColorBlue obj.Stats(i).ColorFarRed])/255;
                percent =   (i-0.1)/nObjects;
                workbar(percent,'Please Wait...calculating fiber color','Fiber-Color',obj.controllerAnalyzeHandle.mainFigure);
                
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
            
            % Add Fields for FiberTypes to Stats Struct and set all values to
            % zero
            [obj.Stats(:).FiberTypeMainGroup] = deal(0);
            
            [obj.Stats(:).FiberType] = deal('');
            
            %perform pre classification
            obj.preClassification();

            if obj.AnalyzeMode == 1 || obj.AnalyzeMode == 2
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Color-Based labeling
                %Color-Based triple or quad labeling
                %Use green red and blue plane for fiber type classification.
                %seaarch for type 1 2x and 12h (type 1 2 hybrid) fibers
                obj.classifyCOLOR();
            
                
              
            elseif obj.AnalyzeMode == 3  || obj.AnalyzeMode == 4
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %OPTICS-Custer-Based labeling
                % OPTICS-Custer-Based labeling
                % AnalyzeMode=3: OPTICS tripple labeling
                % AnalyzeMode=4: OPTICS quad labeling
                obj.classifyOPTICS();
            
                
            elseif obj.AnalyzeMode == 5 || obj.AnalyzeMode == 6
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Manual labeling 
                obj.classifyMANUAL(); 
                
            elseif  obj.AnalyzeMode == 7   
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %No classification only propertie calculation
                obj.classifyNONE();
            end
            
        end

        function preClassification(obj)
            noElements = size(obj.Stats,1);

            %find all fiber types that are undefined (out of the
            %parameter range).
            obj.InfoMessage = '      - run Pre-Classification...';
            obj.InfoMessage = '         - find objects that are out of parameter range';
            for i=1:1:noElements
                percent=(i-0.1)/noElements;
                workbar(percent,'Please Wait...pre-classification','Pre-Classification',obj.controllerAnalyzeHandle.mainFigure);
                
                if obj.AreaActive && ( obj.Stats(i).Area > obj.MaxArea )
                    
                    % Object Area is to big. FiberType 0: No Fiber (white)
                    obj.Stats(i).FiberTypeMainGroup = 0;
                    obj.Stats(i).FiberType = 'undefined';
                    
                    
                elseif obj.AspectRatioActive && ( obj.Stats(i).AspectRatio < obj.MinAspectRatio || ...
                        obj.Stats(i).AspectRatio > obj.MaxAspectRatio )
                    
                    % ApsectRatio is to small or to great.
                    % FiberType 0: No Fiber (white)
                    obj.Stats(i).FiberTypeMainGroup = 0;
                    obj.Stats(i).FiberType = 'undefined';
                    
                    
                elseif obj.RoundnessActive && ( obj.Stats(i).Roundness < obj.MinRoundness )
                    
                    % Object Roundness is to small. FiberType 0: No Fiber (white))
                    obj.Stats(i).FiberTypeMainGroup = 0;
                    obj.Stats(i).FiberType = 'undefined';
                    
                    
                elseif obj.ColorValueActive && ( obj.Stats(i).ColorValue < obj.ColorValue )
                    
                    % Object ColorValue is to small. FiberType 0: No Fiber
                    % (white).
                    obj.Stats(i).FiberTypeMainGroup = 0;
                    obj.Stats(i).FiberType = 'undefined';
                    
                else
                    
                end
            end
        end
        
        function classifyOPTICS(obj)
            
            obj.InfoMessage = '      - use OPTICS clustering';
            noElements = size(obj.Stats,1);
            
            obj.ClusterData.ReachPlotMain = [];
            obj.ClusterData.EpsilonMain = [];
            obj.ClusterData.ReachPlotSub = [];
            obj.ClusterData.EpsilonSub = [];

            obj.InfoMessage = '         - create temp stats struct';
            %create temp stats with label number for further
            %processing that contains only fibers that are not
            %undefined
            obj.InfoMessage = '         - prepare Data for clustering';
            tempStats = obj.Stats;
            [tempStats.Label] = deal(0);
            [tempStats.DistZero] = deal(0);
            
            for i=1:1:noElements
                tempStats(i).Label = i;
                tempStats(i).DistZero = sqrt(tempStats(i).ColorRed^2 + tempStats(i).ColorBlue^2);
            end
            
            for i=noElements:-1:1
                if strcmp(tempStats(i).FiberType , 'undefined');
                    tempStats(i) = [];
                end
            end
            workbar(0.99,'Please Wait...pre-classification','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
            obj.InfoMessage = '         - get min points of cluster';
            %Get Minimum amount of cluster points from User
            inputSuccses = false;
            minPoints = 2;
            while ~inputSuccses && ~isempty(tempStats)
                beep
                prompt = {['Minimum amount of cluster points: Range: 2 - ' num2str(size(tempStats,1))]};
                dlg_title = 'Input';
                num_lines = 1;
                defaultans = {num2str(ceil(noElements*0.05))};
                answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
                
                if isempty(answer)
                    inputSuccses = false;
                else
                    minPoints = str2num(answer{1});
                    
                    if isscalar(minPoints) && isreal(minPoints) && ~isnan(minPoints) ...
                            && minPoints <= size(tempStats,1) && minPoints>1
                        inputSuccses = true;
                    else
                        inputSuccses = false;
                    end
                end
            end
            
            if ~isempty(tempStats)
            
            obj.minPointsPerCluster=minPoints;
            
            if obj.Hybrid12FiberActive
                % 12-Hybrid Fibers allowed
                maxCluster = 3;
            else
                maxCluster = 2;
            end
            
            % Classify the main fiber type groups 1 2 3
           
            X(:,1) = [tempStats.ColorRed]';
            X(:,2) = [tempStats.ColorBlue]';

            [RD,CD,order] = optics(X,minPoints);
            Class = zeros(size(tempStats,1),1);
            Cluster = 0;
            searchForClusters = true;
            
            obj.InfoMessage = '      - start clustering main fiber types';
            obj.InfoMessage = '         - searching for clusters...';
            
            ReachPlot = RD(order);
            
            pks = findpeaks(ReachPlot);
            pks(end+1) = max(ReachPlot);
            
            ReachPlot(end+1)=max(ReachPlot);
            ReachValues = sort(unique(pks));
            epsilon = ReachValues(1);
            posReach=1;
            while searchForClusters
                Cluster = 0;
                Class(order(1)) = Cluster;
                newCluster=true;
                for i=1:1:size(tempStats,1)
                    
                    if ReachPlot(i+1) < epsilon %found new cluster
                        if ReachPlot(i+1) == epsilon
                            disp(epsilon)
                        end
                        
                        if newCluster
                            Cluster = Cluster +1;
                            newCluster = false;
                        end
                       Class(order(i)) = Cluster;
                        
%                     if ReachPlot(i) >= epsilon && ReachPlot(i+1) < ReachPlot(i) && ReachPlot(i-1) <= ReachPlot(i) && min(ReachPlot(1:i)) < ReachPlot(i)
% %                     if RD(order(i)) > epsilon && RD(order(i+1)) < RD(order(i))
%                         Cluster = Cluster+1;
%                         Class(order(i)) = Cluster;
                    else
%                         Class(order(i)) = Cluster;
                            if ~newCluster
                                %Endpoint of a Cluster. The Value i belongs
                                %to that cluster
                                Class(order(i)) = Cluster;
                            end
                            newCluster = true;
                            Class(order(i)) = 0; %Noise
                    end
                    
                end
                
                if Cluster > maxCluster
%                     epsilon = epsilon + 1;
                    posReach = posReach+1;
                    epsilon = ReachValues(posReach);
                    searchForClusters = true;
%                     disp([epsilon Cluster])
                else
%                     list = unique(Class);
%                     [n, index] = histc(Class, list);
                    ClassNoNoise = Class(Class~=0);
                    n =  histcounts(ClassNoNoise);
                    if length(n(n>=minPoints)) == length(n) && sum(Class(:)==0) < length(Class)*(0.3) %nnz(Class)/length(n)
                        searchForClusters = false;
                    else
%                         epsilon = epsilon + 1;
                        posReach = posReach+1;
                        epsilon = ReachValues(posReach);
%                         disp([epsilon Cluster min(n)])
                        searchForClusters = true;
                    end
                    
                end
            end %end while searchForClusters
            obj.InfoMessage = ['         - ' num2str(Cluster) ' clusters were found'];
            
            obj.ClusterData.ReachPlotMain = ReachPlot;
            obj.ClusterData.EpsilonMain = epsilon;
            
%             
%             f0=figure();
%             bar(ReachPlot)
%             title({['Reachability-Distance-Plot (P_{min} = ' num2str(minPoints) ')'],...
%                 ['Found Clusters = ' num2str(Cluster)] })
%             hold on
%             plot(get(gca,'xlim'), [epsilon epsilon],'Color','g','LineWidth',2);
%             pks = findpeaks(ReachPlot);
%             disp(epsilon)
%             set(gca,'xlim',[0 length(ReachPlot)])
%             grid on
%             set(f0,'Position',[100,100,250,200]);
%             saveFigure(f0,['ReachPlotPmin' num2str(minPoints) '.pdf'])
% 
%             f1=figure('Color',[1 1 1],'InvertHardcopy','off')
%             hold on
%             bar(Clus1(:,1),Clus1(:,2),'FaceColor','b','EdgeColor','none','LineWidth',1)
%             hold on
%             bar(Noise(:,1),Noise(:,2),'FaceColor','k','EdgeColor','none','LineWidth',1)
%             hold on
%             bar(Clus2(:,1),Clus2(:,2),'FaceColor','r','EdgeColor','none','LineWidth',1)
% %             hold on
% %             bar(Clus3(:,1),Clus3(:,2),'FaceColor','r','EdgeColor','none')
%              hold on
%              set(gca,'xlim',[0 size(ReachPlot,2)])
%             plot(get(gca,'xlim'), [epsilon epsilon],'Color','g','LineWidth',2);
%             title('Reachability-Distance fiber type main group (P_{min} = 9)')
%             grid on
%             xlabel('Cluster order of datapoints O','FontSize',12);
%             ylabel('Distance R_D','FontSize',12);
%             set(gca, 'LooseInset', [0,0,0,0]);
%             legend({'Noise','Type 1','Type 2 (all)',['\delta = ' num2str(epsilon)]},'Location','best')
%             ylim([ 0 Inf ] );
%             xlim([ 0 Inf]  );
% %             XTick = [0:100:size(ReachPlot,2)];
%             set(gca,'xTicklabel',{0:100:size(ReachPlot,2)}) 
%             grid on
%             set(f1,'Position',[100,100,400,270]);
%             saveFigure(f1,['ReachPlotMain.pdf']);
% %             
%             f2=figure('Color',[1 1 1],'InvertHardcopy','off')
%             color = [[0 0 0];[0 0 1];[255 51 255]/255;[1 0 0]];
%             
%             Nx = [tempStats(Class==0).ColorRed];
%             Ny = [tempStats(Class==0).ColorBlue];
%             C1x= [tempStats(Class==1).ColorRed];
%             C1y =[tempStats(Class==1).ColorBlue];
%             C2x= [tempStats(Class==2).ColorRed];
%             C2y =[tempStats(Class==2).ColorBlue];
%             C3x= [tempStats(Class==3).ColorRed];
%             C3y =[tempStats(Class==3).ColorBlue];
%            
%                 hold on
%                 scatter(Nx,Ny,20,[224 224 224]/255,'filled','MarkerEdgeColor','k')
%                 hold on
%                 scatter(C1x,C1y,20,[0 0 1],'filled','MarkerEdgeColor','k')
%                 hold on
% %                 scatter(C2x,C2y,20,[255 51 255]/255,'filled','MarkerEdgeColor','k')
%                 hold on
%                 scatter(C2x,C2y,20,[1 0 0],'filled','MarkerEdgeColor','k')
% 
%             grid on
%             title({'Fiber Type main group classification'; '(Type-1, all Type-2, Type-12h)'})
%             ylabel('y: mean Blue (B)','FontSize',12);
%             xlabel('x: mean Red (R)','FontSize',12);
%             legend({'Noise','Type 1','Type 2 (all)'},'Location','best')
%             set(gca, 'LooseInset', [0,0,0,0]);
%             yl=get(gca,'ylim');
%             xl=get(gca,'xlim');
%             ylim([ 0 yl(2) ] );
%             xlim([ 0 xl(2) ] );
%            set(f2,'Position',[100,100,400,270]);
%            saveFigure(f2,['ScatterPlotMain.pdf']); 
           
            obj.InfoMessage = '         - determine cluster focus';
            
            NoiseObj = Class==0;
            NoNoise = Class~=0;
            tempX=X;
            tempX(NoiseObj,:)=Inf;
            [IDX,D] = knnsearch(tempX,X(NoiseObj,:));
            Class(NoiseObj)=Class(IDX);

            
            %Claculate cluster Core points
            if Cluster == 1
                workbar(0.99,'Please Wait...identify Clusters','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                if mean([tempStats.ColorBlue]) > mean([tempStats.ColorRed])
                    [tempStats.FiberType] = deal('Type 1');
                    [tempStats.FiberTypeMainGroup] = deal(1);
                else
                    [tempStats.FiberType] = deal('Type 2');
                    [tempStats.FiberTypeMainGroup] = deal(2);
                end
                
            elseif Cluster == 2
                noElementsWc = sum(Class(:)==0);
                
                    %Core Cluster 1
                    C1xV = [tempStats(Class==1).ColorRed]';
                    C1yV = [tempStats(Class==1).ColorBlue]';
                    C1x = [sum(C1xV)/length(C1xV) 1];
                    C1y = [sum(C1yV)/length(C1yV) 1];
                
                    %Core Cluster 2
                    C2xV = [tempStats(Class==2).ColorRed]';
                    C2yV = [tempStats(Class==2).ColorBlue]';
                    C2x = [sum(C2xV)/length(C2xV) 2];
                    C2y = [sum(C2yV)/length(C2yV) 2];
                
                 while sum(Class(:)==0)>0
                    percent = 1-((sum(Class(:)==0)-0.9)/(noElementsWc));
                    workbar(percent,'Please Wait...match undefined to nearest cluster','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);    
               
                    idx = find(Class==0, 1, 'first'); %get index of first 0 element
                    Nx = tempStats(idx).ColorRed;
                    Ny = tempStats(idx).ColorBlue;
                    %find nearest Cluster core
                    distC1 = pdist([Nx,Ny;C1x(1),C1y(1)],'euclidean');
                    distC2 = pdist([Nx,Ny;C2x(1),C2y(1)],'euclidean');
                    distAll=[distC1 distC2];
                    idxC = find(distAll==min(distAll),1,'first');
                    Class(idx)=idxC; 
                 end

                obj.InfoMessage = '         - identify clusters'; 
                workbar(0.99,'Please Wait...identify clusters','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                %gradient of corepoint
                dC=[];
                dC(1,:) = [C1y(1)/C1x(1) 1];
                dC(2,:) = [C2y(1)/C2x(1) 2];
                
                %sort from samllest to greatest gradient
                [values, order] = sort(dC(:,1));
                sortedmatrix = dC(order,:);
                
                [tempStats(Class==sortedmatrix(1,2)).FiberTypeMainGroup] = deal(2);
                [tempStats(Class==sortedmatrix(1,2)).FiberType] = deal('Type 2');
                [tempStats(Class==sortedmatrix(2,2)).FiberTypeMainGroup] = deal(1);
                [tempStats(Class==sortedmatrix(2,2)).FiberType] = deal('Type 1');
                
            elseif Cluster == 3
                noElementsWc = sum(Class(:)==0);
                
                    %Core Cluster 1
                    C1xV = [tempStats(Class==1).ColorRed]';
                    C1yV = [tempStats(Class==1).ColorBlue]';
                    C1x = [sum(C1xV)/length(C1xV) 1];
                    C1y = [sum(C1yV)/length(C1yV) 1];
                
                    %Core Cluster 2
                    C2xV = [tempStats(Class==2).ColorRed]';
                    C2yV = [tempStats(Class==2).ColorBlue]';
                    C2x = [sum(C2xV)/length(C2xV) 2];
                    C2y = [sum(C2yV)/length(C2yV) 2];
                
                    %Core Cluster 3
                    C3xV = [tempStats(Class==3).ColorRed]';
                    C3yV = [tempStats(Class==3).ColorBlue]';
                    C3x = [sum(C3xV)/length(C3xV) 3];
                    C3y = [sum(C3yV)/length(C3yV) 3];
                    
                while sum(Class(:)==0)>0
                    percent = 1-((sum(Class(:)==0)-0.9)/(noElementsWc));
                    workbar(percent,'Please Wait...match undefined to nearest cluster','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                
                    idx = find(Class==0, 1, 'first'); %get index of first 0 element
                    Nx = tempStats(idx).ColorRed;
                    Ny = tempStats(idx).ColorBlue;
                    %find nearest Cluster core
                    distC1 = pdist([Nx,Ny;C1x(1),C1y(1)],'euclidean');
                    distC2 = pdist([Nx,Ny;C2x(1),C2y(1)],'euclidean');
                    distC3 = pdist([Nx,Ny;C3x(1),C3y(1)],'euclidean');
                    distAll = [distC1 distC2 distC3];
                    idxC = find(distAll==min(distAll),1,'first');
                    Class(idx)=idxC;
                end

                workbar(0.99,'Please Wait...identify Clusters','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                %gradient of corepoint
                dC=[];
                dC(1,:) = [C1y(1)/C1x(1) 1];
                dC(2,:) = [C2y(1)/C2x(1) 2];
                dC(3,:) = [C3y(1)/C3x(1) 3];
                
                %sort from samllest to greatest gradient
                [values, order] = sort(dC(:,1));
                sortedmatrix = dC(order,:);
                
                [tempStats(Class==sortedmatrix(1,2)).FiberTypeMainGroup] = deal(2);
                [tempStats(Class==sortedmatrix(2,2)).FiberTypeMainGroup] = deal(3);
                [tempStats(Class==sortedmatrix(2,2)).FiberType] = deal('Type 12h');
                [tempStats(Class==sortedmatrix(3,2)).FiberTypeMainGroup] = deal(1);
                [tempStats(Class==sortedmatrix(3,2)).FiberType] = deal('Type 1');
                
            else
              obj.InfoMessage = 'ERROR in OPTICS Classify Fcn Main Fiber Types';  
            end
            
            %write Data from tempStats in main Stats structure
            for i=1:1:size(tempStats,1)
                percent = (i-0.01)/size(tempStats,1);
                workbar(percent,'Please Wait...save Cluster data','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                obj.Stats(tempStats(i).Label).FiberTypeMainGroup = tempStats(i).FiberTypeMainGroup;
                obj.Stats(tempStats(i).Label).FiberType = tempStats(i).FiberType;
            end
            

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Classify the Type 2 subgroups
            IsType2 = find([obj.Stats.FiberTypeMainGroup] == 2);
            if obj.AnalyzeMode == 4 && ~isempty(obj.PicPlaneFarRed) ...
                    && max(max(obj.PicPlaneFarRed)) > 0 ...
                    && ~isempty(IsType2)
                
                obj.InfoMessage = '      - start clustering fiber type 2 subgroups';
                
                %OPTICS quad labeling if FaredPlane exist and contains
                %non zero elements
                
                %create temp stats with label number for further
                %processing that contains only fibers that are
                %claasified as main fiber type 2
                
               
                 obj.InfoMessage = '         - prepare Data for clustering';
                tempStats = obj.Stats;
                [tempStats.Label] = deal(0);
                
                for i=1:1:noElements
                    tempStats(i).Label = i;
                end
                
                for i=noElements:-1:1
                    if tempStats(i).FiberTypeMainGroup ~= 2;
                        tempStats(i) = [];
                    end
                end
                
                % Classify the fiber types 2a 2x 2ax
                
                X=[];
                X(:,1) = [tempStats.ColorRed]';
                X(:,2) = [tempStats.ColorFarRed]';
                
                if minPoints > size(X,1)
                    minPoints = size(X,1);
                end
                
                if obj.Hybrid2axFiberActive
                % 12-Hybrid Fibers allowed
                    maxCluster = 3;
                else
                    maxCluster = 2;
                end
                
                
                [RD,CD,order] = optics(X,minPoints);
                Class = zeros(size(tempStats,1),1);
%                 Cluster = 0;
                searchForClusters = true;
                
                obj.InfoMessage = '      - start clustering type 2 fiber subgroups';
                obj.InfoMessage = '         - searching for clusters...';
                
                RD(end+1)=max(RD);
                ReachPlot = RD(order);
                ReachPlot(end+1)=max(ReachPlot);
                
                
                [pks, locs] = findpeaks(ReachPlot);
                pks(end+1) = max(ReachPlot);
                
                ReachValues = sort(unique(pks));
                epsilon = ReachValues(1);
                posReach=1;
                
                while searchForClusters
                    Cluster = 0;
                    Class(order(1)) = Cluster;
                newCluster=true;
                for i=1:1:size(tempStats,1)
                    
                    if ReachPlot(i+1) < epsilon %found new cluster
                        if newCluster
                            Cluster = Cluster +1;
                            newCluster = false;
                        end
                       Class(order(i)) = Cluster;
                        
%                     if ReachPlot(i) >= epsilon && ReachPlot(i+1) < ReachPlot(i) && ReachPlot(i-1) <= ReachPlot(i) && min(ReachPlot(1:i)) < ReachPlot(i)
% %                     if RD(order(i)) > epsilon && RD(order(i+1)) < RD(order(i))
%                         Cluster = Cluster+1;
%                         Class(order(i)) = Cluster;
                    else
%                         Class(order(i)) = Cluster;
                            if ~newCluster
                                %Endpoint of a Cluster. The Value i belongs
                                %to that cluster
                                Class(order(i)) = Cluster;
                            end
                            newCluster = true;
                            Class(order(i)) = 0; %Noise
                    end
                    
                end
                
                    if Cluster > maxCluster
                        posReach = posReach+1;
                        epsilon = ReachValues(posReach);
                        searchForClusters = true;
                    else
%                         list = unique(Class);
                        ClassNoNoise = Class(Class~=0);
                        n =  histcounts(ClassNoNoise);
                        if length(n(n>=minPoints)) == length(n) && sum(Class(:)==0) < length(Class)*(0.3)
                            searchForClusters = false;
                        else
                            posReach = posReach+1;
                            epsilon = ReachValues(posReach);
                            searchForClusters = true;
                        end
                    end
                end %end while searchForClusters
                
                obj.ClusterData.ReachPlotSub = ReachPlot;
                obj.ClusterData.EpsilonSub = epsilon;
                
%             figure
%             bar(ReachPlot)
%             hold on
%             plot(get(gca,'xlim'), [epsilon epsilon]);
%             
%                 f0=figure();
%             bar(ReachPlot)
%             title({['Reachability-Distance-Plot (P_{min} = ' num2str(minPoints) ')'],...
%                 ['Found Clusters = ' num2str(Cluster)] })
%             hold on
%             plot(get(gca,'xlim'), [epsilon epsilon],'Color','g','LineWidth',2);
%             pks = findpeaks(ReachPlot);
%             disp(epsilon)
%             set(gca,'xlim',[0 length(ReachPlot)])
%             grid on
%             set(f0,'Position',[100,100,250,200]);
%             saveFigure(f0,['ReachPlotPmin' num2str(minPoints) '.pdf'])
            
%             
%             f3=figure('Color',[1 1 1],'InvertHardcopy','off')
%             bar(Noise(:,1),Noise(:,2),'FaceColor','k','EdgeColor','none')
%             hold on
%             bar(Clus1(:,1),Clus1(:,2),'FaceColor','r','EdgeColor','none')
%             hold on
%             bar(Clus2(:,1),Clus2(:,2),'FaceColor',[255/255 100/255 0],'EdgeColor','none')
%             hold on
%             bar(Clus3(:,1),Clus3(:,2),'FaceColor','y','EdgeColor','none')
%              hold on
%              set(gca,'xlim',[0 length(ReachPlot)])
%             plot(get(gca,'xlim'), [epsilon epsilon],'Color','g','LineWidth',2);
%             title('Reachability-Distance type 2 subgroup (P_{min} = 9)')
%             grid on
%             xlabel('Cluster order of datapoints O','FontSize',12);
%             ylabel('Distance R_D','FontSize',12);
%             ylim([ 0 Inf ] );
%             xlim([ 0 Inf ] );
%             set(gca, 'LooseInset', [0,0,0,0]);
%             legend({'Noise','Type 2x','Type 2ax','Type 2a',['\delta = ' num2str(epsilon)]},'Location','best')
%             set(f3,'Position',[100,100,400,270]);
%            saveFigure(f3,['ReachPlotSub.pdf']);
% 
%             f4=figure('Color',[1 1 1],'InvertHardcopy','off')
%             color = [[0 0 0];[0 0 1];[255 51 255]/255;[1 0 0]];
%             
%             Nx = [tempStats(Class==0).ColorRed];
%             Ny = [tempStats(Class==0).ColorFarRed];
%             C1x= [tempStats(Class==1).ColorRed];
%             C1y =[tempStats(Class==1).ColorFarRed];
%             C2x= [tempStats(Class==2).ColorRed];
%             C2y =[tempStats(Class==2).ColorFarRed];
%             C3x= [tempStats(Class==3).ColorRed];
%             C3y =[tempStats(Class==3).ColorFarRed];
%            
%                 hold on
%                 scatter(Nx,Ny,20,[224 224 224]/255,'filled','MarkerEdgeColor','k')
%                 hold on
%                 scatter(C1x,C1y,20,[1 0 0],'filled','MarkerEdgeColor','k')
%                 hold on
%                 scatter(C2x,C2y,20,[255/255 100/255 0],'filled','MarkerEdgeColor','k')
%                 hold on
%                 scatter(C3x,C3y,20,'y','filled','MarkerEdgeColor','k')
% % 
%             grid on
%             title({'Fiber Type-2 subgroup classification' ;'(Type-2x, Type-2ax, Type-2a)'})
%             ylabel('y: mean FarRed (FR)','FontSize',12);
%             xlabel('x: mean Red (R)','FontSize',12);
%             legend({'Noise','Type 2x','Type 2ax','Type 2a'},'Location','best')
%             set(gca, 'LooseInset', [0,0,0,0]);
%             yl=get(gca,'ylim');
%             xl=get(gca,'xlim');
%             ylim([ 0 yl(2) ] );
%             xlim([ 0 xl(2) ] );
%            set(f4,'Position',[100,100,400,270]);    
%             saveFigure(f4,['ScatterPlotSub.pdf']);
            
            NoiseObj = Class==0;
            NoNoise = Class~=0;
            tempX=X;
            tempX(NoiseObj,:)=Inf;
            [IDX,D] = knnsearch(tempX,X(NoiseObj,:));
            Class(NoiseObj)=Class(IDX);

                obj.InfoMessage = ['         - ' num2str(Cluster) ' clusters were found'];
                
                obj.InfoMessage = '         - determine cluster focus';
                %Claculate cluster Core points
                if Cluster == 1
                    workbar(0.99,'Please Wait...identify Clusters','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                    if mean([tempStats.ColorFarRed]) > mean([tempStats.ColorRed])
                        [tempStats([tempStats.FiberTypeMainGroup]==2).FiberType] = deal('Type 2a');
                    else
                        [tempStats([tempStats.FiberTypeMainGroup]==2).FiberType] = deal('Type 2x');
                    end
                    
                elseif Cluster == 2
                    noElementsWc = sum(Class(:)==0);
                    
                        %Core Cluster 1
                        C1xV = [tempStats(Class==1).ColorRed]';
                        C1yV = [tempStats(Class==1).ColorFarRed]';
                        C1x = [sum(C1xV)/length(C1xV) 1];
                        C1y = [sum(C1yV)/length(C1yV) 1];
                    
                        %Core Cluster 2
                        C2xV = [tempStats(Class==2).ColorRed]';
                        C2yV = [tempStats(Class==2).ColorFarRed]';
                        C2x = [sum(C2xV)/length(C2xV) 2];
                        C2y = [sum(C2yV)/length(C2yV) 2];
                   while sum(Class(:)==0)>0
                        percent = 1-((sum(Class(:)==0)-0.9)/(noElementsWc));
                        workbar(percent,'Please Wait...match undefined to nearest cluster','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                        idx = find(Class==0, 1, 'first'); %get index of first 0 element
                        Nx = tempStats(idx).ColorRed;
                        Ny = tempStats(idx).ColorFarRed;
                        %find nearest Cluster core
                        distC1 = pdist([Nx,Ny;C1x(1),C1y(1)],'euclidean');
                        distC2 = pdist([Nx,Ny;C2x(1),C2y(1)],'euclidean');
                        distAll=[distC1 distC2];
                        idxC = find(distAll==min(distAll),1,'first');
                        Class(idx)=idxC;
                    end
                    pause(0.1)
                    obj.InfoMessage = '         - identify clusters'; 
                    workbar(0.99,'Please Wait...identify clusters','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                    %gradient of corepoint
                    dC=[];
                    dC(1,:) = [C1y(1)/C1x(1) 1];
                    dC(2,:) = [C2y(1)/C2x(1) 2];
                    
                    %sort from samllest to greatest gradient
                    [values, order] = sort(dC(:,1));
                    sortedmatrix = dC(order,:);
                    
                    [tempStats(Class==sortedmatrix(1,2)).FiberTypeMainGroup] = deal(2);
                    [tempStats(Class==sortedmatrix(1,2)).FiberType] = deal('Type 2x');
                    [tempStats(Class==sortedmatrix(2,2)).FiberTypeMainGroup] = deal(2);
                    [tempStats(Class==sortedmatrix(2,2)).FiberType] = deal('Type 2a');
                    
                elseif Cluster == 3
                    noElementsWc = sum(Class(:)==0);
                    
                        %Core Cluster 1
                        C1xV = [tempStats(Class==1).ColorRed]';
                        C1yV = [tempStats(Class==1).ColorFarRed]';
                        C1x = [sum(C1xV)/length(C1xV) 1];
                        C1y = [sum(C1yV)/length(C1yV) 1];
                
                        %Core Cluster 2
                        C2xV = [tempStats(Class==2).ColorRed]';
                        C2yV = [tempStats(Class==2).ColorFarRed]';
                        C2x = [sum(C2xV)/length(C2xV) 2];
                        C2y = [sum(C2yV)/length(C2yV) 2];
                
                        %Core Cluster 3
                        C3xV = [tempStats(Class==3).ColorRed]';
                        C3yV = [tempStats(Class==3).ColorFarRed]';
                        C3x = [sum(C3xV)/length(C3xV) 3];
                        C3y = [sum(C3yV)/length(C3yV) 3];
                
                    while sum(Class(:)==0)>0
                        percent = 1-((sum(Class(:)==0)-0.9)/(noElementsWc));
                        workbar(percent,'Please Wait...match undefined to nearest cluster','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                        idx = find(Class==0, 1, 'first'); %get index of first 0 element
                        Nx = tempStats(idx).ColorRed;
                        Ny = tempStats(idx).ColorFarRed;
                        %find nearest Cluster core
                        distC1 = pdist([Nx,Ny;C1x(1),C1y(1)],'euclidean');
                        distC2 = pdist([Nx,Ny;C2x(1),C2y(1)],'euclidean');
                        distC3 = pdist([Nx,Ny;C3x(1),C3y(1)],'euclidean');
                        distAll = [distC1 distC2 distC3];
                        idxC = find(distAll==min(distAll),1,'first');
                        Class(idx)=idxC;
                    end
                    
                    workbar(0.99,'Please Wait...identify Clusters','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                    %gradient of corepoint
                    dC=[];
                    dC(1,:) = [C1y(1)/C1x(1) 1];
                    dC(2,:) = [C2y(1)/C2x(1) 2];
                    dC(3,:) = [C3y(1)/C3x(1) 3];
                    
                    %sort from samllest to greatest gradient
                    [values, order] = sort(dC(:,1));
                    sortedmatrix = dC(order,:);
                    
                    [tempStats(Class==sortedmatrix(1,2)).FiberTypeMainGroup] = deal(2);
                    [tempStats(Class==sortedmatrix(1,2)).FiberType] = deal('Type 2x');
                    [tempStats(Class==sortedmatrix(2,2)).FiberTypeMainGroup] = deal(2);
                    [tempStats(Class==sortedmatrix(2,2)).FiberType] = deal('Type 2ax');
                    [tempStats(Class==sortedmatrix(3,2)).FiberTypeMainGroup] = deal(2);
                    [tempStats(Class==sortedmatrix(3,2)).FiberType] = deal('Type 2a');
                else
                    obj.InfoMessage = 'ERROR in OPTICS Classify Fcn Fiber Type Subgroups';
                end  %end if cluster
            else
                %Quad labeling could not be performed. All Main Type 2 fibers
                %are classified as Type 2 (all Type 2) fiber
                if obj.AnalyzeMode == 4
                    %Quad was active but no Farred Information. All Type 2
                    %Fibers are 2x
                    [tempStats([tempStats.FiberTypeMainGroup]==2).FiberType] = deal('Type 2x');
                else
                    %Quad was not active. No Type 2 specification
                    [tempStats([tempStats.FiberTypeMainGroup]==2).FiberType] = deal('Type 2');
                end
            end
            
            %write Data from tempStats in main Stats structure
            for i=1:1:size(tempStats,1)
                percent = (i-0.01)/size(tempStats,1);
                workbar(percent,'Please Wait...save Cluster data','OPTICS-Clustering',obj.controllerAnalyzeHandle.mainFigure);
                obj.Stats(tempStats(i).Label).FiberTypeMainGroup = tempStats(i).FiberTypeMainGroup;
                obj.Stats(tempStats(i).Label).FiberType = tempStats(i).FiberType;
            end
            
            else
                obj.InfoMessage = 'ERROR: No Objects to be analyzed';
            end
            
            
        end
        
        function classifyCOLOR(obj)
            nObjects = size(obj.Stats,1);
            
            % Classify Fiber Type main groups 
            for i=1:1:nObjects
                percent =   (i-0.1)/nObjects;
                workbar(percent,'Please Wait...classify Fiber-Type main groups','Fiber-Type main groups',obj.controllerAnalyzeHandle.mainFigure);
                if strcmp(obj.Stats(i).FiberType , 'undefined')
                    %do nothing. Go to next Fiber
                elseif obj.BlueRedThreshActive
                    %Blue/Red thresh is active. Searching for Type 1 2 and
                    %12 hybrid fibers.
                    if obj.Stats(i).ColorRatioBlueRed >= obj.BlueRedThresh/(1 - obj.BlueRedDistBlue)
                        obj.Stats(i).FiberTypeMainGroup = 1;
                        obj.Stats(i).FiberType = 'Type 1';
                    elseif obj.Stats(i).ColorRatioBlueRed <= obj.BlueRedThresh*(1 - obj.BlueRedDistRed)
                        obj.Stats(i).FiberTypeMainGroup = 2;
                        obj.Stats(i).FiberType = 'Type 2';
                    else
                        % Type 1 2 hybrid
                        obj.Stats(i).FiberTypeMainGroup = 3;
                        obj.Stats(i).FiberType = 'Type 12h';
                    end
                else
                    %Blue Red thresh is not active. Searching only for Type
                    %1 and 2 fibers.
                    if obj.Stats(i).ColorRatioBlueRed >= 1
                        % Type 1 fiber (blue)
                        obj.Stats(i).FiberTypeMainGroup = 1;
                        obj.Stats(i).FiberType = 'Type 1';
                    else
                        % Type 2 fiber (red)
                        obj.Stats(i).FiberTypeMainGroup = 2;
                        obj.Stats(i).FiberType = 'Type 2';
                    end
                end
                        
            end %End for loop
            
            if obj.AnalyzeMode == 2 %Color quad labeling is active
                % Specify Fiber Type 2 subgroups
                for i=1:1:nObjects
                    percent =   (i-0.1)/nObjects;
                    workbar(percent,'Please Wait...sepcify Fiber-Type 2 subgroups','Fiber-Type 2 subgroups',obj.controllerAnalyzeHandle.mainFigure);
                    if obj.Stats(i).FiberTypeMainGroup == 2
                        if obj.FarredRedThreshActive
                            % Farred/Red Thresh is active. Searching for
                            % Type 2x 2a and 2ax hybrid fibers.
                            if obj.Stats(i).ColorRatioFarredRed  >= obj.FarredRedThresh/(1 - obj.FarredRedDistFarred)
                                obj.Stats(i).FiberTypeMainGroup = 2;
                                obj.Stats(i).FiberType = 'Type 2a';
                            elseif obj.Stats(i).ColorRatioFarredRed  <= obj.FarredRedThresh*(1 - obj.FarredRedDistFarred)
                                obj.Stats(i).FiberTypeMainGroup = 2;
                                obj.Stats(i).FiberType = 'Type 2x';
                            else
                                obj.Stats(i).FiberTypeMainGroup = 2;
                                obj.Stats(i).FiberType = 'Type 2ax';
                            end
                        else
                            % Farred/Red Thresh is not active. Searching
                            % only for Type 2x and 2a fibers.
                            if obj.Stats(i).ColorRatioFarredRed  >= 1
                                obj.Stats(i).FiberTypeMainGroup = 2;
                                obj.Stats(i).FiberType = 'Type 2a';
                            else 
                                obj.Stats(i).FiberTypeMainGroup = 2;
                                obj.Stats(i).FiberType = 'Type 2x';
                            end
                        end
                        
                    else
                        %No Type 2 fiber. Go to next fiber.
                    end
                end
            
            end
            
        end
        
        function classifyCOLOR1(obj)
            
            nObjects = size(obj.Stats,1);
            for i=1:1:nObjects
                
                if strcmp(obj.Stats(i).FiberType , 'undefined')
                    %do nothing. Go to next Fiber
                    
                elseif obj.BlueRedThreshActive
                    %Blue Red thresh is active. Searchinf for Type 1 2
                    %and 12 hybrid fibers
                    if obj.Stats(i).ColorRatioBlueRed >= obj.BlueRedThresh
                        
                        %Check for Limit Blue
                        if obj.Stats(i).ColorRatioBlueRed  < obj.BlueRedThresh/(1 - obj.BlueRedDistBlue)
                            % Type 1 2 hybrid
                            obj.Stats(i).FiberTypeMainGroup = 3;
                            obj.Stats(i).FiberType = 'Type 12h';
                            
                        else
                            % Type 1 fiber
                            obj.Stats(i).FiberTypeMainGroup = 1;
                            obj.Stats(i).FiberType = 'Type 1';
                            
                        end
                        
                    elseif obj.Stats(i).ColorRatioBlueRed < obj.BlueRedThresh
                        
                        %Check for Limit Blue
                        if obj.Stats(i).ColorRatioBlueRed  > obj.BlueRedThresh*(1 - obj.BlueRedDistRed)
                            % Type 1 2 hybrid (magenta)
                            obj.Stats(i).FiberTypeMainGroup = 3;
                            obj.Stats(i).FiberType = 'Type 12h';
                            
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
                                            
                                        else
                                            % Type 2a fiber
                                            obj.Stats(i).FiberTypeMainGroup = 2;
                                            obj.Stats(i).FiberType = 'Type 2a';
                                            
                                        end
                                    elseif obj.Stats(i).ColorRatioFarredRed < obj.FarredRedThresh
                                        if obj.Stats(i).ColorRatioFarredRed  > obj.FarredRedThresh*(1 - obj.FarredRedDistFarred)
                                            % Type 2ax fiber (orange hybrid 2a 2x fiber)
                                            obj.Stats(i).FiberTypeMainGroup = 2;
                                            obj.Stats(i).FiberType = 'Type 2ax';
                                            
                                        else
                                            % Type 2x fiber
                                            obj.Stats(i).FiberTypeMainGroup = 2;
                                            obj.Stats(i).FiberType = 'Type 2x';
                                            
                                        end
                                    end
                                else % Farred/Red Thresh is not active
                                    if obj.Stats(i).ColorRatioBlueRed  <= 1
                                        % Type 2x fiber
                                        obj.Stats(i).FiberTypeMainGroup = 2;
                                        obj.Stats(i).FiberType = 'Type 2x';
                                        
                                    elseif obj.Stats(i).ColorRatioBlueRed  > 1
                                        % Type 2a fiber
                                        obj.Stats(i).FiberTypeMainGroup = 2;
                                        obj.Stats(i).FiberType = 'Type 2a';
                                        
                                        
                                    end
                                end
                            else
                                obj.Stats(i).FiberTypeMainGroup = 2;
                                obj.Stats(i).FiberType = 'Type 2x';
                                
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
                                        
                                    else
                                        % Type 2a fiber
                                        obj.Stats(i).FiberTypeMainGroup = 2;
                                        obj.Stats(i).FiberType = 'Type 2a';
                                        
                                        
                                    end
                                elseif obj.Stats(i).ColorRatioFarredRed < obj.FarredRedThresh
                                    if obj.Stats(i).ColorRatioFarredRed  > obj.FarredRedThresh*(1 - obj.FarredRedDistFarred)
                                        % Type 2ax fiber (orange hybrid 2a 2x fiber)
                                        obj.Stats(i).FiberTypeMainGroup = 2;
                                        obj.Stats(i).FiberType = 'Type 2ax';
                                        
                                    else
                                        % Type 2x fiber
                                        obj.Stats(i).FiberTypeMainGroup = 2;
                                        obj.Stats(i).FiberType = 'Type 2x';
                                        
                                    end
                                end
                            else % Farred/Red Thresh is not active
                                if obj.Stats(i).ColorRatioBlueRed  <= 1
                                    % Type 2x fiber
                                    obj.Stats(i).FiberTypeMainGroup = 2;
                                    obj.Stats(i).FiberType = 'Type 2x';
                                elseif obj.Stats(i).ColorRatioBlueRed  > 1
                                    % Type 2a fiber
                                    obj.Stats(i).FiberTypeMainGroup = 2;
                                    obj.Stats(i).FiberType = 'Type 2a';
                                    
                                end
                            end
                        else
                            obj.Stats(i).FiberTypeMainGroup = 2;
                            obj.Stats(i).FiberType = 'Type 2x';
                            
                        end
                    else
                        obj.Stats(i).FiberTypeMainGroup = 0;
                        obj.Stats(i).FiberType = 'undefined';
                        
                    end
                    
                else
                    %Error Code
                    obj.Stats(i).FiberType = 'Error';
                    obj.InfoMessage = '! ERROR in specifyFiberType() FUNCTION!';
                end
                
                percent =   (i-0.1)/nObjects;
                workbar(percent,'Please Wait...specifing Fiber-Type','Fiber-Type',obj.controllerAnalyzeHandle.mainFigure);
            end
        end
        
        function classifyMANUAL(obj)
            noElements = size(obj.Stats,1); %Number of fiber objects
            
            tempStats = obj.Stats; %save Stats strukt temporary
            [tempStats.Label] = deal(0);
            
            for i=1:1:noElements
                tempStats(i).Label = i;
            end
            
            for i=noElements:-1:1
                if strcmp(tempStats(i).FiberType , 'undefined');
                    tempStats(i) = [];
                end
            end
            
%             noElements = size(tempStats,1);
            % set all remaining fibers to undefiend
            [tempStats.Color] = deal(0);
            [tempStats.FiberType] = deal('undefined');
            [tempStats.FiberTypeMainGroup] = deal(0);
            
            %Open figure for manual calssification
            mainFig = obj.controllerAnalyzeHandle.mainFigure;
            obj.controllerAnalyzeHandle.viewAnalyzeHandle.showFigureManualClassify(mainFig);
            %get Handle if that figure
            fig = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hFMC;
            % set the close request functio of the figure for manual calssification
            set(fig,'CloseRequestFcn',@obj.endManualClassify);
            
            %get handle to Back Button manual fibers to choose main fiber
            %types
            hBackBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassBack;
            set(hBackBut,'Callback',@obj.backManualClassify);
            set(hBackBut,'Enable','off');
            
            %get handle to End Button to finish manual classification
            hEndBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassEnd;
            set(hEndBut,'Callback',@obj.endManualClassify);
            
            %get handle to Forward Button manual fibers to specify type 2
            %fibers only
            hForBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassForward;
            set(hForBut,'Callback',@obj.forwardManualClassify);
            set(hForBut,'Enable','off');
            
            %get handle to axes for manual classification
            hAM = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hAMC;
            axes(hAM)
            
            obj.ManualClassifyMode = 1; %Start with main Groups
            
            while isvalid(fig)
                %while figure exist
                Color=[];
                for i = 1:1:size(tempStats,1)
                    switch tempStats(i).FiberType
                        case 'Type 1'
                            Color(i,:)=[51 51 255]/255;
                        case 'Type 12h'
                            Color(i,:)=[255 51 255]/255;
                        case 'Type 2'
                            Color(i,:)=[255 51 51]/255;
                        case 'Type 2x'
                            Color(i,:)=[255 51 51]/255;    
                        case 'Type 2a'
                            Color(i,:)=[255 255 51]/255; % Yellow Fiber Type 2a
                        case 'Type 2ax'
                            Color(i,:) = [255 153 51]/255; % orange Fiber Type 2ax
                        otherwise
                            Color(i,:)=[224 224 224]/255;
                    end
                end
                
                if obj.ManualClassifyMode == 1 % For main fiber groups 1,2 and 12h
                    
                    figure(fig)
%                     InfoText = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualInfoText;
%                     String = 'Type 1 , Type 12h (1 2 hybrid), Type 2 (all Type 2 fibers)';
%                     set(InfoText,'String',String);
                    
                    axes(hAM);
                    if isempty(hAM.Children)
                    h = scatter([tempStats.ColorRed],[tempStats.ColorBlue],20,Color,'filled');
                    set(h,'MarkerEdgeColor','k')
                    if obj.AnalyzeMode == 1 || obj.AnalyzeMode == 3 || obj.AnalyzeMode == 5
                        title({'\fontsize{16}Triple labeling: Select a Area by clicking the mouse and choose fiber type:';...
                            ['\fontsize{16}Classify {\color{blue}Type 1 ','\color{magenta}Type 12h \color{red}Type 2}']},'interpreter','tex');
                    else
                        title({'\fontsize{16}Quad labeling: Select a Area by clicking the mouse and choose fiber type:';...
                            ['\fontsize{16}Classify {\color{blue}Type 1 ','\color{magenta}Type 12h \color{red}Type 2 (Type 2x is default during quad labeling)}']},'interpreter','tex');
                    end
                    ylabel('y: mean Blue (B)','FontSize',16);
                    xlabel('x: mean Red (R)','FontSize',16);
                    maxLim = max(max([[tempStats.ColorRed] [tempStats.ColorBlue]]));
                    ylim([ 0 maxLim+10 ] );
                    xlim([ 0 maxLim+10 ] );
                    daspect([1 1 1])
                    grid on
                    else
                    h.XData=[tempStats.ColorRed];
                    h.YData=[tempStats.ColorBlue];
                    h.CData = Color;    
                    end
                    
                    hPoly = impoly(hAM);
                    
                    if isvalid(fig) && obj.ManualClassifyMode == 1
                        if ~isempty(hAM.Children) && ~isempty(hPoly)
                            pos = getPosition(hPoly)
                            
                            [in,on] = inpolygon([tempStats.ColorRed],[tempStats.ColorBlue],pos(:,1),pos(:,2));
                            [s,v] = listdlg('PromptString','Select Fiber Type:',...
                                'SelectionMode','single',...
                                'ListString',{'Type 1 (blue)','Type 12h (magenta)','Type 2 (red)','undefined'},...
                                'ListSize',[160 160]);
                            
                            if ~isempty(s)
                                switch s
                                    case 1 %Type 1
                                        [tempStats(in).FiberType] = deal('Type 1');
                                        [tempStats(in).FiberTypeMainGroup] = deal(1);
                                    case 2 %Type 12h
                                        [tempStats(in).FiberType] = deal('Type 12h');
                                        [tempStats(in).FiberTypeMainGroup] = deal(3);
                                    case 3 %Type 2
                                        [tempStats(in).FiberType] = deal('Type 2');
                                        [tempStats(in).FiberTypeMainGroup] = deal(2);
                                    case 4 %Type 0
                                        [tempStats(in).FiberType] = deal('undefined');
                                        [tempStats(in).FiberTypeMainGroup] = deal(0);
                                end
                            end
                            
                            delete(hPoly)
                            type2Stats = tempStats([tempStats.FiberTypeMainGroup]==2);
                            
                            if isempty(type2Stats)
                                %get handle to Forward Button manual fibers to specify type 2
                                %fibers only
                                hForBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassForward;
                                set(hForBut,'Enable','off');
                            elseif ~isempty(type2Stats) && (obj.AnalyzeMode == 2 || obj.AnalyzeMode == 4 || obj.AnalyzeMode == 6)
                                %get handle to Forward Button manual fibers to specify type 2
                                %fibers only
                                hForBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassForward;
                                set(hForBut,'Enable','on');
                                % During quad labeling, every Type2 fiber
                                % will be first classified as Type-2x
                                [tempStats(strcmp({tempStats.FiberType},'Type 2')).FiberType] = deal('Type 2x');
                            end
                            
                        end
                    end
                    
                elseif obj.ManualClassifyMode == 2
                    
                    figure(fig)
%                     InfoText = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualInfoText;
%                     String = 'Type 2x , Type 2a, Type 2ax (2a 2x hybrid)';
%                     set(InfoText,'String',String);
                    
                    %Only show type 2 fibers
                    type2Stats = [];
                    type2Stats = tempStats([tempStats.FiberTypeMainGroup]==2);
                    Color = [];
                    
                    for i = 1:1:size(type2Stats,1)
                        switch type2Stats(i).FiberType
                            case 'Type 2x'
                                Color(i,:)=[255 51 51]/255; % Red Fiber Type 2x
                            case 'Type 2a'
                                Color(i,:)=[255 255 51]/255; % Yellow Fiber Type 2a
                            case 'Type 2ax'
                                Color(i,:) = [255 153 51]/255; % orange Fiber Type 2ax
                            otherwise
                                Color(i,:)=[224 224 224]/255;
                        end
                    end
                    
                    axes(hAM);
                    
                    if isempty(hAM.Children)
                        h = scatter([type2Stats.ColorRed],[type2Stats.ColorFarRed],20,Color,'filled');
                        set(h,'MarkerEdgeColor','k');
                        
                        title({'\fontsize{16}Select a Area by clicking the mouse and choose fiber type:';...
                            ['\fontsize{16}Classify {\color{red}Type 2x ','\color{yellow}Type 2a \color{orange}Type 2ax}']},'interpreter','tex');
                        ylabel('y: mean Farred (FR)','FontSize',16);
                        xlabel('x: mean Red (R)','FontSize',16);
                        
                        maxLim = max(max([[type2Stats.ColorRed] [type2Stats.ColorFarRed]]));
                        ylim([ 0 maxLim+10 ] );
                        xlim([ 0 maxLim+10 ] );
                        daspect([1 1 1])
                        grid on
                    else
                        h.XData=[type2Stats.ColorRed];
                        h.YData=[type2Stats.ColorFarRed];
                        h.CData = Color;
                    end
                    
                    hPoly = impoly(hAM);
                    
                    if isvalid(fig) && obj.ManualClassifyMode == 2
                        if ~isempty(hAM.Children) && ~isempty(hPoly)
                            pos = getPosition(hPoly);
                            
                            [in,on] = inpolygon([type2Stats.ColorRed],[type2Stats.ColorFarRed],pos(:,1),pos(:,2));
                            [s,v] = listdlg('PromptString','Select Fiber Type:',...
                                'SelectionMode','single',...
                                'ListString',{'Type 2x','Type 2a','Type 2ax','undefined'},...
                                'ListSize',[160 160]);
                            
                            if ~isempty(s)
                                switch s
                                    case 1
                                        [type2Stats(in).FiberType] = deal('Type 2x');
                                        [type2Stats(in).FiberTypeMainGroup] = deal(2);
                                    case 2
                                        [type2Stats(in).FiberType] = deal('Type 2a');
                                        [type2Stats(in).FiberTypeMainGroup] = deal(2);
                                    case 3
                                        [type2Stats(in).FiberType] = deal('Type 2ax');
                                        [type2Stats(in).FiberTypeMainGroup] = deal(2);
                                    case 4
                                        [type2Stats(in).FiberType] = deal('undefined');
                                        [type2Stats(in).FiberTypeMainGroup] = deal(0);
                                end
                            end
                            
                            delete(hPoly)
                            
                            for i=1:1:size(type2Stats,1)
                                tempStats([tempStats.Label]==type2Stats(i).Label).FiberType = type2Stats(i).FiberType;
                                tempStats([tempStats.Label]==type2Stats(i).Label).FiberTypeMainGroup = type2Stats(i).FiberTypeMainGroup;
                            end
                        end
                    end
                    
                else
                    %Error
                end
                  
            end%End while
            
            
            for i=1:1:size(tempStats,1)
                
                obj.Stats(tempStats(i).Label).FiberType = tempStats(i).FiberType;
                obj.Stats(tempStats(i).Label).FiberTypeMainGroup = tempStats(i).FiberTypeMainGroup;
                
            end
            
            
        end
        
        function classifyNONE(obj)
            [obj.Stats.FiberType] = deal('undefined');
            [obj.Stats.FiberTypeMainGroup] = deal(0);
        end
        
        function endManualClassify(obj,~,~)
            hAM = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hAMC;
            cla(hAM);
            fig = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hFMC;
            if ~isempty(fig)
                delete(fig)
            end
            fig = findobj('Tag','FigureManualClassify');
            if ~isempty(fig)
                delete(fig)
            end
        end
        
        function backManualClassify(obj,~,~)
            hAM = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hAMC;
            cla(hAM); 
            
            obj.ManualClassifyMode = 1;
            
            %get handle to Back Button manual fibers to choose main fiber
            %types
            hBackBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassBack;
            set(hBackBut,'Callback',@obj.backManualClassify);
            set(hBackBut,'Enable','off');
            
            %get handle to Forward Button manual fibers to specify type 2
            %fibers only
            hForBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassForward;
            set(hForBut,'Enable','on');
        end
        
        function forwardManualClassify(obj,eventdata, handles)
            ax = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hAMC;
            cla(ax);
            
            obj.ManualClassifyMode = 2;
            
            %get handle to Back Button manual fibers to choose main fiber
            %types
            hBackBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassBack;
            set(hBackBut,'Callback',@obj.backManualClassify);
            set(hBackBut,'Enable','on');
            
            %get handle to Forward Button manual fibers to specify type 2
            %fibers only
            hForBut = obj.controllerAnalyzeHandle.viewAnalyzeHandle.B_ManualClassForward;
            set(hForBut,'Enable','off');
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
            if obj.AnalyzeMode == 1 || obj.AnalyzeMode == 3 || obj.AnalyzeMode == 5 || obj.AnalyzeMode == 7
                %tripple labeling was active. Only type 1,2 and 12h fibers
                %allowed
                switch newFiberType %Fiber Type
                    case 1
                        %Fiber Type 1 (blue)
                        newFiberType = 'Type 1';
                        newFiberTypeMainGroup = 1;
                    case 2
                        %Fiber Type 12h (hybird fiber) (magenta)
                        newFiberType = 'Type 12h';
                        newFiberTypeMainGroup = 3;
                    case 3
                        %Fiber Type 2x (red)
                        newFiberType = 'Type 2';
                        newFiberTypeMainGroup = 2;
                    case 4
                        %Fiber Type 0 (white)
                        newFiberType = 'undefined';
                        newFiberTypeMainGroup = 0;
                end
                
            else
                %quad labeling was active, all fibers allowed
                switch newFiberType %Fiber Type
                    case 1
                        %Fiber Type 1 (blue)
                        newFiberType = 'Type 1';
                        newFiberTypeMainGroup = 1;
                    case 2
                        %Fiber Type 12h (hybird fiber) (magenta)
                        newFiberType = 'Type 12h';
                        newFiberTypeMainGroup = 3;
                    case 3
                        %Fiber Type 2x (red)
                        newFiberType = 'Type 2x';
                        newFiberTypeMainGroup = 2;
                    case 4
                        %Fiber Type 2a (yellow)
                        newFiberType = 'Type 2a';
                        newFiberTypeMainGroup = 2;
                    case 5
                        %Fiber Type 2ax (orange)
                        newFiberType = 'Type 2ax';
                        newFiberTypeMainGroup = 2;
                    case 6
                        %Fiber Type 0 (white)
                        newFiberType = 'undefined';
                        newFiberTypeMainGroup = 0;
                end
            end
            
            %get old fiber type
            oldFiberType = obj.Stats(labelNo).FiberType;
            
            if strcmp(newFiberType,oldFiberType)
                % Fiber Type hasn't changed
            else
                
                % If a Preview Results figure already exists,
                % delete it
                preFig = findobj('Tag','FigurePreResults');
                if ~isempty(preFig) && isvalid(preFig)
                    delete(preFig);
                end
                
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
                    case 'Type 2'
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
                obj.Stats(labelNo).FiberTypeMainGroup = newFiberTypeMainGroup;
                
                % find old boundarie and delete them
                htemp = findobj('Tag',['boundLabel ' num2str(labelNo)]);
                
                if strcmp(htemp.Type , 'line')
                    %Boundaire is a line object
                    plotline = true;
                else 
                    %Boundaire is a hggroup object
                    plotline = false;
                end
                delete(htemp);
                
                % plot new boundarie
                if plotline
                    htemp = line(axesh,obj.Stats(labelNo).Boundarie{1, 1}(:,2),obj.Stats(labelNo).Boundarie{1, 1}(:,1),'Color',Color,'LineWidth',2.5);
                else
                    htemp = visboundaries(axesh,obj.Stats(labelNo).Boundarie,'Color',Color,'LineWidth',2);
                end
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
            %               Data{28}: min Points per Cluster
            %               Data{29}: 1/2 Hybrid Fibers allowed
            %               Data{30}: 2ax Hybrid Fibers allowed
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
            
            Data{28} = obj.minPointsPerCluster;
            
            Data{29} = obj.Hybrid12FiberActive;
            Data{30} = obj.Hybrid2axFiberActive;
            
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
            %               Info{15}: Analyze Mode
            
            PosOut = obj.checkPosition(Pos);
            
            
            if ~obj.CalculationRunning &&...
                    ( ~isnan(PosOut(1)) && ~isnan(PosOut(2)) ) &&...
                    ~isempty(obj.Stats)
                
                Label = obj.LabelMat(PosOut(2),PosOut(1));
                
                if (Label > 0)
                    %fiber object were selected
                    
                    BoundBox =   round(obj.Stats(Label).BoundingBox);
                    
                   
                    [y origPos]= imcrop(obj.handlePicRGB.CData,[floor(BoundBox(1)) floor(BoundBox(2)) BoundBox(3)+1 BoundBox(4)+1]);
                    Bound = obj.Stats(Label).Boundarie;
                    Bound{1,1}(:,1) = Bound{1,1}(:,1)-origPos(2)+1;
                    Bound{1,1}(:,2) = Bound{1,1}(:,2)-origPos(1)+1;
                    
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
                    obj.FiberInfo{15} = obj.AnalyzeMode;
                    
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
                obj.FiberInfo{15} = [];
                
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

