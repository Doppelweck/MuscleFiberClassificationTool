classdef modelResults < handle
    %modelResults   Model of the results-MVC (Model-View-Controller). Runs
    %all nessesary calculations. Is connected and gets controlled by the
    %correspondening Controller.
    %The main tasks are:
    %   - calculate all area features.
    %   - calculate all fiber features.
    %   - transform Stats tabel to numerical structs
    %   - specify all fiber objects with the given parameters.
    %   - preparing the data to save.
    %   - save data.
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
       
        controllerResultsHandle; %hande to controllerResults instance.
        
    end
    
    properties
        FileName; %Filename of the selected file.
        PathName; %Directory path of the selected file.
        PicPRGBFRPlanes; %RGB image create from color plane images red green blue and farred.
        PicPRGBPlanes; %RGB image create from color plane images red green and blue.
        
        SaveFiberTable; %Indicates whether the fiber type table should be saved.
        SaveScatterAll; %Indicates whether the scatter plot with for all fibers should be saved.
        SavePlots; %Indicates whether the statistics plots should be saved.
        SavePicRGBFRProcessed; %Indicates whether the processed image should be saved.
        SavePicRGBProcessed; %Indicates whether the color-plane image should be saved.
        SavePath; % Save Path, same as the selected RGB image path.
        ResultUpdateStaus; %Indicates whether the GUI should be updated.
        
        LabelMat; %Label array of all fiber objects.
        
        %Analyze parameters
        AnalyzeMode; %Indicates the selected analyze mode.
        
        AreaActive; %Indicates if Area parameter is used for classification.
        MinAreaPixel; %Minimal allowed Area. Is used for classification. Smaller Objects will be removed from binary mask.
        MaxAreaPixel; %Maximal allowed Area. Is used for classification. Larger Objects will be classified as Type 0.
        
        AspectRatioActive; %Indicates if AspectRatio parameter is used for classification.
        MinAspectRatio; %Minimal allowed AspectRatio. Is used for classification. Objects with smaller AspectRatio will be classified as Type 0.
        MaxAspectRatio; %Minimal allowed AspectRatio. Is used for classification. Objects with larger AspectRatio will be classified as Type 0.
        
        RoundnessActive; %Indicates if Roundness parameter is used for classification.
        MinRoundness; %Minimal allowed Roundness. Is used for classification. Objects with smaller Roundness will be classified as Type 0.
        
        BlueRedThreshActive; %Indicates if Blue/Red Threshold parameter is used for classification.
        BlueRedThresh;
        BlueRedDistBlue;
        BlueRedDistRed;
        
        FarredRedThreshActive; %Indicates if Farred/Red Threshold parameter is used for classification.
        FarredRedThresh;
        FarredRedDistFarred;
        FarredRedDistRed;
        
        ColorValueActive; %Indicates if ColorValue parameter is used for classification.
        ColorValue; %Minimal allowed ColorValue. Is used for classification. Objects with smaller ColorValue will be classified as Type 0.
        
        NoOfObjects; %Number of objects.
        NoTyp1; %Number of Type 1 fibers.
        NoTyp12h; %Number of Type 12 hybeid fibers.
        NoTyp2a; %Number of Type 2a fibers.
        NoTyp2x; %Number of Type 2x fibers.
        NoTyp2ax; %Number of Type 2ax fibers.
        NoTyp0; %Number of Type 0 fibers (undefind).
        
        AreaPic; % Total area of the RGB image.
        AreaType1; % Total area of all type 1 fibers.
        AreaType2a; % Total area of all type 2a fibers.
        AreaType2x; % Total area of all type 2x fibers.
        AreaType2ax; % Total area of all type 2ax (2a 2x hybrid) fibers.
        AreaType12h; % Total area of all type 3 (1 2 hybrid) fibers.
        AreaType0; % Total area of all type 0 fibers.
        AreaFibers; % Total area of all fiber objects.
        AreaNoneObj; % Total area that contains no objects (Collagen).
        
        AreaType1PC; % Area of all type 1 fibers in percent.
        AreaType12hPC; % Aarea of all type 12 hybrid fibers in percent.
        AreaType2aPC; % Area of all type 1 fibers in percent.
        AreaType2xPC; % Area of all type 1 fibers in percent.
        AreaType2axPC; % Area of all type 1 fibers in percent.
        AreaType0PC; % Area of all type 0 fibers in percent.
        AreaFibersPC; % Area of all fiber objects in percent.
        AreaNoneObjPC; % Area that contains no objects in percent.
        
        AreaMinMax; %Vector, contains the [min max] area in pixel of all objects.
        AreaMinMaxObj; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of all objects.
        AreaMinMaxT1; %Vector, contains the [min max] area in pixel of Type 1 fibers.
        AreaMinMaxObjT1; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 1 fibers.
        AreaMinMaxT12h; %Vector, contains the [min max] area in pixel of Type 12 hybrid fibers.
        AreaMinMaxObjT12h; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 12 hybrid fibers.
        AreaMinMaxT2a; %Vector, contains the [min max] area in pixel of Type 2a fibers.
        AreaMinMaxObjT2a; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 2a fibers.
        AreaMinMaxT2x; %Vector, contains the [min max] area in pixel of Type 2x fibers.
        AreaMinMaxObjT2x; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 2x fibers.
        AreaMinMaxT2ax; %Vector, contains the [min max] area in pixel of Type 2ax fibers.
        AreaMinMaxObjT2ax; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 2ax fibers.
        
        XScale; %Inicates the um/pixels in X direction to change values in micro meter.
        YScale; %Inicates the um/pixels in Y direction to change values in micro meter.
        
        Stats; % Data struct of all fiber objets and all fiber datas
        
        StatsMatData; % Cell Array, Contains the data of all fiber objets that are shown in the object table in the GUI.
        % [Label Area XPos YPos MinorAxis MajorAxis Perimeter Roundness ...
        %  AspectRatio ColorHue VolorValue Red Green Blue FarRed ...
        %  Blue/Red Farred/Red MainType Type]
        StatsMatDataT1; % Contains the data of all type 1 fiber objets.
        StatsMatDataT12h; % Contains the data of all type 12 hybrid fiber objets.
        StatsMatDataT2a; % Contains the data of all type 2a fiber objets.
        StatsMatDataT2x; % Contains the data of all type 2x fiber objets.
        StatsMatDataT2ax; % Contains the data of all type 2ax fiber objets.
        StatsMatDataT0; % Contains the data of all type 0 undefined fiber objets.
        
        StatisticMat; % Contains the statistc data af the ruslts.
        
        
    end
    
    properties(SetObservable)
        
        InfoMessage;
        
    end
    
    methods
        
        function obj = modelResults()
            % Constuctor of the modelResults class.
            %
            %   obj = modelResults();
            %
            %   ARGUMENTS:
            %
            %       - Input
            %
            %       - Output
            %           obj:    Handle to modelResults object.
            %
            
            obj.ResultUpdateStaus = false;
             
        end
        
        function startResultMode(obj)
            % Called by the controller when the program change in the
            % rsults stage. Calls all culculation functions and GUI update
            % functions.
            %
            %   startResultMode(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            if obj.ResultUpdateStaus
                %nothing has changed. 
                obj.InfoMessage = '- No new analysis has been done';
                obj.InfoMessage = '- updating data is not necessary';
                obj.InfoMessage = '- updating GUI is not necessary';
            else
            obj.InfoMessage = '- updating GUI...';
            
            obj.transformDataStructToMatrix();
            
            obj.calculateFiberNubers();
            
            obj.calculateAreaFeatures();
            
            obj.createMatStatisticTable();
            
            obj.controllerResultsHandle.showAxesDataInGUI();
            
            obj.controllerResultsHandle.showInfoInTableGUI();
            
            obj.controllerResultsHandle.showPicProcessedGUI();
            
            obj.InfoMessage = '- updating GUI complete';
            
            obj.ResultUpdateStaus = true;
            end
        end
        
        function transformDataStructToMatrix(obj)
            % Ttransforms the Stats table in numerical data array. Creates
            % Array for each fiber type.
            %
            %   transformDataStructToMatrix(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            obj.InfoMessage = '   - transform data struct to Cell Array';
            obj.InfoMessage = '      - prepare data for GUI table';
            
            tempCell = obj.Stats;
            
            %remove field BoundingBox
            tempCell = rmfield(tempCell,'BoundingBox');
            %remove field Boundarie
            tempCell = rmfield(tempCell,'Boundarie');
            %remove field Centroid
            tempCell = rmfield(tempCell,'Centroid');
            %remove field Solidity
            tempCell = rmfield(tempCell,'Solidity');
            
            %transform struct to temporary cellarray
            tempCell = struct2cell(tempCell)';
            
            for i=1:1:size(obj.Stats,1)
                % seperate centroid in X and Y values
                FCPX(i,1) = round(obj.Stats(i).Centroid(1));
                FCPY(i,1) = round(obj.Stats(i).Centroid(2));
            end
            
            % Create X and Y Cell-Vector
            FCPX = mat2cell(FCPX,ones(size(obj.Stats,1),1),1);
            FCPY = mat2cell(FCPY,ones(size(obj.Stats,1),1),1);
            
            % Create Label No Cell-Vector
            LabelNo = [1:1:size(obj.Stats,1)]';
            LabelNo = mat2cell(LabelNo,ones(size(obj.Stats,1),1),1);
            
            %create Cell array
            obj.StatsMatData = cat(2, LabelNo,tempCell(:,1),FCPX,FCPY,tempCell(:,2:end) );
            
            % Create CellArray only for Type 1 Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,19), 'Type 1');
            Index = find(IndexC==1);
            obj.StatsMatDataT1 = obj.StatsMatData(Index,:);
            
            % Create CellArray only for Type 12h Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,19), 'Type 12h');
            Index = find(IndexC==1);
            obj.StatsMatDataT12h = obj.StatsMatData(Index,:);
            
            % Create CellArray only for Type 2a Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,19), 'Type 2a');
            Index = find(IndexC==1);
            obj.StatsMatDataT2a = obj.StatsMatData(Index,:);
            
            % Create CellArray only for Type 2a Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,19), 'Type 2x');
            Index = find(IndexC==1);
            obj.StatsMatDataT2x = obj.StatsMatData(Index,:);
            
            % Create CellArray only for Type 2a Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,19), 'Type 2ax');
            Index = find(IndexC==1);
            obj.StatsMatDataT2ax = obj.StatsMatData(Index,:);
          
            % Create CellArray only for Type 0 undifined Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,19), 'undefined');
            Index = find(IndexC==1);
            obj.StatsMatDataT0 = obj.StatsMatData(Index,:);
            
        end
        
        function calculateAreaFeatures(obj)
            % Claculate all area features.
            %
            %   calculateAreaFeatures(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.InfoMessage = '   - Calculate fiber type areas';
            obj.AreaPic = size(obj.PicPRGBFRPlanes,1) * size(obj.PicPRGBFRPlanes,2);
            obj.AreaType1 = 0;
            obj.AreaType2a = 0;
            obj.AreaType2x = 0;
            obj.AreaType2ax = 0;
            obj.AreaType12h = 0;
            obj.AreaType0 = 0;
            obj.AreaFibers = 0;
            
            obj.NoOfObjects = size(obj.Stats,1);
            
            for i=1:1:obj.NoOfObjects;
                
                switch obj.Stats(i).FiberType
                    case 'Type 1'
                        % Type1 Fiber (blue)
                        % Total area of all type 1 fibers
                        obj.AreaType1 = obj.AreaType1 + obj.Stats(i).Area;
                    case 'Type 12h'
                        %Type 12 hybrid fiber (between Red and Blue)
                        % Total area of all type 3 fibers
                        obj.AreaType12h = obj.AreaType12h + obj.Stats(i).Area;
                    case 'Type 2x'
                        % Type 2x fiber (red)
                        % Total area of all type 2x fibers
                        obj.AreaType2x = obj.AreaType2x + obj.Stats(i).Area;
                    case 'Type 2a'
                        % Type 2a fiber (yellow)
                        % Total area of all type 2a fibers
                        obj.AreaType2a = obj.AreaType2a + obj.Stats(i).Area;
                    case 'Type 2ax'
                        % Type 2ax fiber (orange)
                        % Total area of all type 2ax fibers
                        obj.AreaType2ax = obj.AreaType2ax + obj.Stats(i).Area;
                    case 'undefined'
                        % Type 0 fiber (white, no fiber)
                        % Total area of all undefined fibers
                        obj.AreaType0 = obj.AreaType0 + obj.Stats(i).Area;
                    otherwise
                        obj.InfoMessage = 'ERROR in calculateAreaFeatures() Fcn';
                end
                
            end
            
            % Total area of all fiber objects including Type 0
            obj.AreaFibers = obj.AreaType1+obj.AreaType12h+obj.AreaType2x+obj.AreaType2a+obj.AreaType2ax+obj.AreaType0;
            % Total area that consists no Objects. Collagen (green)
            obj.AreaNoneObj = obj.AreaPic - obj.AreaFibers;
            
            % Calculate area in percent of Fibertypes related to the original image
            obj.AreaType1PC = obj.AreaType1/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType1PC) ' % of the image consists of Type 1 fibers'];
            
            obj.AreaType12hPC = obj.AreaType12h/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType12hPC) ' % of the image consists of Type 12 hybrid fibers'];
            
            obj.AreaType2xPC = obj.AreaType2x/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType2xPC) ' % of the image consists of Type 2x fibers'];
            
            obj.AreaType2aPC = obj.AreaType2a/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType2aPC) ' % of the image consists of Type 2a fibers'];
            
            obj.AreaType2axPC = obj.AreaType2ax/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType2axPC) ' % of the image consists of Type 2ax fibers'];
            
            obj.AreaType0PC = obj.AreaType0/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType0PC) ' % of the image consists undefined fibers'];
            
            obj.AreaNoneObjPC = obj.AreaNoneObj/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaNoneObjPC) '% of the image consists Collagen'];
            
            % Find object with the smallest area
            obj.AreaMinMax(1) = min([obj.Stats.Area]);
            obj.AreaMinMaxObj(1) = find([obj.Stats.Area]==obj.AreaMinMax(1),1);
           
            % Find object with the largest area
            obj.AreaMinMax(2) = max([obj.Stats.Area]);
            obj.AreaMinMaxObj(2) = find([obj.Stats.Area]==obj.AreaMinMax(2),1);
           
            % Find samlest and largest Fiber of each Type
            
            if ~isempty(obj.StatsMatDataT1)
                obj.AreaMinMaxT1(1) = min(cell2mat(obj.StatsMatDataT1(:,2)));
                obj.AreaMinMaxObjT1(1) = cell2mat(obj.StatsMatDataT1( find([obj.StatsMatDataT1{:,2}]==obj.AreaMinMaxT1(1),1) ,1));
                obj.AreaMinMaxT1(2) = max(cell2mat(obj.StatsMatDataT1(:,2)));
                obj.AreaMinMaxObjT1(2) = cell2mat(obj.StatsMatDataT1( find([obj.StatsMatDataT1{:,2}]==obj.AreaMinMaxT1(2),1) ,1));
            else
                obj.AreaMinMaxT1 = '--';
                obj.AreaMinMaxObjT1 = '--';

            end
            
            if ~isempty(obj.StatsMatDataT12h)
                obj.AreaMinMaxT12h(1) = min(cell2mat(obj.StatsMatDataT12h(:,2)));
                obj.AreaMinMaxObjT12h(1) = cell2mat(obj.StatsMatDataT12h( find([obj.StatsMatDataT12h{:,2}]==obj.AreaMinMaxT12h(1),1) ,1));
                obj.AreaMinMaxT12h(2) = max(cell2mat(obj.StatsMatDataT12h(:,2)));
                obj.AreaMinMaxObjT12h(2) = cell2mat(obj.StatsMatDataT12h( find([obj.StatsMatDataT12h{:,2}]==obj.AreaMinMaxT12h(2),1) ,1));
            else
                obj.AreaMinMaxT12h = '--';
                obj.AreaMinMaxObjT12h = '--';

            end
            
            if ~isempty(obj.StatsMatDataT2a)
                obj.AreaMinMaxT2a(1) = min(cell2mat(obj.StatsMatDataT2a(:,2)));
                obj.AreaMinMaxObjT2a(1) = cell2mat(obj.StatsMatDataT2a( find([obj.StatsMatDataT2a{:,2}]==obj.AreaMinMaxT2a(1),1) ,1));
                obj.AreaMinMaxT2a(2) = max(cell2mat(obj.StatsMatDataT2a(:,2)));
                obj.AreaMinMaxObjT2a(2) = cell2mat(obj.StatsMatDataT2a( find([obj.StatsMatDataT2a{:,2}]==obj.AreaMinMaxT2a(2),1) ,1));
            else
                obj.AreaMinMaxT2a = '--';
                obj.AreaMinMaxObjT2a = '--';

            end
            
            if ~isempty(obj.StatsMatDataT2x)
                obj.AreaMinMaxT2x(1) = min(cell2mat(obj.StatsMatDataT2x(:,2)));
                obj.AreaMinMaxObjT2x(1) = cell2mat(obj.StatsMatDataT2x( find([obj.StatsMatDataT2x{:,2}]==obj.AreaMinMaxT2x(1),1) ,1));
                obj.AreaMinMaxT2x(2) = max(cell2mat(obj.StatsMatDataT2x(:,2)));
                obj.AreaMinMaxObjT2x(2) = cell2mat(obj.StatsMatDataT2x( find([obj.StatsMatDataT2x{:,2}]==obj.AreaMinMaxT2x(2),1) ,1));
            else
                obj.AreaMinMaxT2x = '--';
                obj.AreaMinMaxObjT2x = '--';

            end
            
            if ~isempty(obj.StatsMatDataT2ax)
                obj.AreaMinMaxT2ax(1) = min(cell2mat(obj.StatsMatDataT2ax(:,2)));
                obj.AreaMinMaxObjT2ax(1) = cell2mat(obj.StatsMatDataT2ax( find([obj.StatsMatDataT2ax{:,2}]==obj.AreaMinMaxT2ax(1),1) ,1));
                obj.AreaMinMaxT2ax(2) = max(cell2mat(obj.StatsMatDataT2ax(:,2)));
                obj.AreaMinMaxObjT2ax(2) = cell2mat(obj.StatsMatDataT2ax( find([obj.StatsMatDataT2ax{:,2}]==obj.AreaMinMaxT2ax(2),1) ,1));
            else
                obj.AreaMinMaxT2ax = '--';
                obj.AreaMinMaxObjT2ax = '--';

            end

        end
        
        function calculateFiberNubers(obj)
            % Claculate all fiber numbers.
            %
            %   calculateFiberFeatures(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.InfoMessage = '   - Calculate fiber type numbers';
            
            % Number of Fiber Objects
            obj.NoOfObjects = size(obj.Stats,1); %all objects

            obj.NoTyp1 = size(obj.StatsMatDataT1,1); % Type 1
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp1) ' Type 1 fibers'];
            
            obj.NoTyp12h = size(obj.StatsMatDataT12h,1); % Type 12h
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp12h) ' Type 12 hybrid fibers'];
            
            obj.NoTyp2a = size(obj.StatsMatDataT2a,1); % Type 2a
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp2a) ' Type 2a fibers'];
            
            obj.NoTyp2x = size(obj.StatsMatDataT2x,1); % Type 2x
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp2x) ' Type 2x fibers'];
            
            obj.NoTyp2ax = size(obj.StatsMatDataT2ax,1); % Type 2ax
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp2ax) ' Type 2ax fibers'];
            
            obj.NoTyp0 = size(obj.StatsMatDataT0,1); % Type 0 undefined
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp0) ' undefined fibers'];
        end
        
        function createMatStatisticTable(obj)
            % Create Cellarray that is shown in the statistic tab in the GUI.
            %
            %   createMatStatisticTable(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.StatisticMat = {}; 
            
            % 1. Row
            obj.StatisticMat{1,1} = 'Analyze Mode:';
            switch obj.AnalyzeMode
                case 1
                    obj.StatisticMat{1,2} =  'Color-Based triple labeling';
                case 2
                    obj.StatisticMat{1,2} =  'Color-Based quad labeling';
                case 3
                    obj.StatisticMat{1,2} =  'Cluster-Based';
            end
            
            % 2. Row
            obj.StatisticMat{2,1} = 'Searching for:';
            switch obj.AnalyzeMode
                case 1
                    obj.StatisticMat{2,2} =  '1 2 12h 2x fibers';
                case 2
                    obj.StatisticMat{2,2} =  '1 2 12h 2x 2a 2ax fibers';
                case 3
                    obj.StatisticMat{2,2} =  '1 2 fibers';
            end
            
            % 3. and 4. Row
            obj.StatisticMat{3,1} = sprintf('Para min area (\x3BCm^2):');
            obj.StatisticMat{4,1} = sprintf('Para max area (\x3BCm^2):');
            if obj.AreaActive
                obj.StatisticMat{3,2} =  obj.MinAreaPixel;
                obj.StatisticMat{4,2} =  obj.MaxAreaPixel;
            else
                obj.StatisticMat{3,2} =  'not active';
                obj.StatisticMat{4,2} =  'not active';
            end
            
            % 5. and 6. Row
            obj.StatisticMat{5,1} = 'Para min Asp.Ratio:';
            obj.StatisticMat{6,1} = 'Para max Asp.Ratio:';
            if obj.AspectRatioActive
                obj.StatisticMat{5,2} =  obj.MinAspectRatio;
                obj.StatisticMat{6,2} =  obj.MaxAspectRatio;
            else
                obj.StatisticMat{5,2} =  'not active';
                obj.StatisticMat{6,2} =  'not active';
            end
            
            % 7. Row
            obj.StatisticMat{7,1} = 'Para min Roundn.:';
            if obj.RoundnessActive
                obj.StatisticMat{7,2} =  obj.MinRoundness;
            else
                obj.StatisticMat{7,2} =  'not active';
            end
            
            % 8. 9. 10. Row
            obj.StatisticMat{8,1} = 'Para Blue/Red thresh:';
            obj.StatisticMat{9,1} = 'Para Blue dist:';
            obj.StatisticMat{10,1} = 'Para Red dist::';
            if obj.BlueRedThreshActive
                obj.StatisticMat{8,2} =  obj.BlueRedThresh;
                obj.StatisticMat{9,2} =  obj.BlueRedDistBlue;
                obj.StatisticMat{10,2} =  obj.BlueRedDistRed;
            else
                obj.StatisticMat{8,2} =  'not active';
                obj.StatisticMat{9,2} =  'not active';
                obj.StatisticMat{10,2} =  'not active';
            end
            
            % 11. 12. 13. Row
            obj.StatisticMat{11,1} = 'Para Farred/Red thresh:';
            obj.StatisticMat{12,1} = 'Para Farred dist:';
            obj.StatisticMat{13,1} = 'Para Red dist::';
            if obj.FarredRedThreshActive
                obj.StatisticMat{11,2} =  obj.FarredRedThresh;
                obj.StatisticMat{12,2} =  obj.FarredRedDistFarred;
                obj.StatisticMat{13,2} =  obj.FarredRedDistRed;
            else
                obj.StatisticMat{11,2} =  'not active';
                obj.StatisticMat{12,2} =  'not active';
                obj.StatisticMat{13,2} =  'not active';
            end
            
             % 14 Row
            obj.StatisticMat{14,1} = 'Para min ColorValue:';
            if obj.ColorValueActive
                obj.StatisticMat{14,2} =  obj.ColorValue;
            else
                obj.StatisticMat{14,2} =  'not active';
            end
            
            % 15 Row
            obj.StatisticMat{15,1} = sprintf('XScale in \x3BCm/pixel:');
            obj.StatisticMat{15,2} =  obj.XScale;
            % 16 Row
            obj.StatisticMat{16,1} = sprintf('XScale in \x3BCm/pixel:');
            obj.StatisticMat{16,2} =  obj.YScale;
            
            % 17 Row
            obj.StatisticMat{17,1} = 'Number objects:';
            obj.StatisticMat{17,2} =  obj.NoOfObjects;
            % 18 Row
            obj.StatisticMat{18,1} = 'Number Type 1:';
            obj.StatisticMat{18,2} =  obj.NoTyp1;
            % 19 Row
            obj.StatisticMat{19,1} = 'Number Type 12h:';
            obj.StatisticMat{19,2} =  obj.NoTyp12h;
            % 20 Row
            obj.StatisticMat{20,1} = 'Number Type 2a:';
            obj.StatisticMat{20,2} =  obj.NoTyp2a;
            % 21 Row
            obj.StatisticMat{21,1} = 'Number Type 2x:';
            obj.StatisticMat{21,2} =  obj.NoTyp2x;
            % 22 Row
            obj.StatisticMat{22,1} = 'Number Type 2ax:';
            obj.StatisticMat{22,2} =  obj.NoTyp2ax;
            % 23 Row
            obj.StatisticMat{23,1} = 'Number undefined:';
            obj.StatisticMat{23,2} =  obj.NoTyp0;
            
            % 24 Row
            obj.StatisticMat{24,1} =  sprintf('Area Type 1 (\x3BCm^2):');
            obj.StatisticMat{24,2} =  obj.AreaType1;
            % 25 Row
            obj.StatisticMat{25,1} =  sprintf('Area Type 12h (\x3BCm^2):');
            obj.StatisticMat{25,2} =  obj.AreaType12h;
            % 26 Row
            obj.StatisticMat{26,1} =  sprintf('Area Type 2a (\x3BCm^2):');
            obj.StatisticMat{26,2} =  obj.AreaType2a;
            % 27 Row
            obj.StatisticMat{27,1} =  sprintf('Area Type 2x (\x3BCm^2):');
            obj.StatisticMat{27,2} =  obj.AreaType2x;
            % 28 Row
            obj.StatisticMat{28,1} =  sprintf('Area Type 2ax (\x3BCm^2):');
            obj.StatisticMat{28,2} =  obj.AreaType2ax;
            % 29 Row
            obj.StatisticMat{29,1} = sprintf('Area Collagen (\x3BCm^2):');
            obj.StatisticMat{29,2} =  obj.AreaNoneObj;
            
            % 30 Row
            obj.StatisticMat{30,1} = 'Area Type 1 (%):';
            obj.StatisticMat{30,2} =  obj.AreaType1PC;
            % 31 Row
            obj.StatisticMat{31,1} = 'Area Type 12h (%):';
            obj.StatisticMat{31,2} =  obj.AreaType12hPC;
            % 32 Row
            obj.StatisticMat{32,1} = 'Area Type 2a (%):';
            obj.StatisticMat{32,2} =  obj.AreaType2aPC;
            % 33 Row
            obj.StatisticMat{33,1} = 'Area Type 2x (%):';
            obj.StatisticMat{33,2} =  obj.AreaType2xPC;
            % 34 Row
            obj.StatisticMat{34,1} = 'Area Type 2ax (%):';
            obj.StatisticMat{34,2} =  obj.AreaType2axPC;
            % 35 Row
            obj.StatisticMat{35,1} = 'Area Collagen (%):';
            obj.StatisticMat{35,2} =  obj.AreaNoneObjPC;
            
            % 36 Row
            obj.StatisticMat{36,1} =  sprintf('Smallest Area (\x3BCm^2):');
            obj.StatisticMat{36,2} =  obj.AreaMinMax(1);
            % 37 Row
            obj.StatisticMat{37,1} = 'Smallest Fiber:';
            obj.StatisticMat{37,2} =  obj.AreaMinMaxObj(1);
            % 38 Row
            obj.StatisticMat{38,1} =  sprintf('Largest Area (\x3BCm^2):');
            obj.StatisticMat{38,2} =  obj.AreaMinMax(2);
            % 39 Row
            obj.StatisticMat{39,1} = 'Largest Fiber:';
            obj.StatisticMat{39,2} =  obj.AreaMinMaxObj(2);
            
            % 40 Row
            obj.StatisticMat{40,1} = sprintf('Smallest Area T1 (\x3BCm^2):');
            obj.StatisticMat{40,2} =  obj.AreaMinMaxT1(1);
            % 41 Row
            obj.StatisticMat{41,1} = 'Smallest T1 Fiber:';
            obj.StatisticMat{41,2} =  obj.AreaMinMaxObjT1(1);
            % 42 Row
            obj.StatisticMat{42,1} = sprintf('Largest Area T1 (\x3BCm^2):');
            obj.StatisticMat{42,2} =  obj.AreaMinMaxT1(2);
            % 43 Row
            obj.StatisticMat{43,1} = 'Largest T1 Fiber:';
            obj.StatisticMat{43,2} =  obj.AreaMinMaxObjT1(2);
            
            % 44 Row
            obj.StatisticMat{44,1} = sprintf('Smallest Area T12h (\x3BCm^2):');
            obj.StatisticMat{44,2} =  obj.AreaMinMaxT12h(1);
            % 45 Row
            obj.StatisticMat{45,1} = 'Smallest T12h Fiber:';
            obj.StatisticMat{45,2} =  obj.AreaMinMaxObjT12h(1);
            % 46 Row
            obj.StatisticMat{46,1} = sprintf('Largest Area T12h (\x3BCm^2):');
            obj.StatisticMat{46,2} =  obj.AreaMinMaxT12h(2);
            % 47 Row
            obj.StatisticMat{47,1} = 'Largest T12h Fiber:';
            obj.StatisticMat{47,2} =  obj.AreaMinMaxObjT12h(2);
            
            % 48 Row
            obj.StatisticMat{48,1} = sprintf('Smallest Area T2a (\x3BCm^2):');
            obj.StatisticMat{48,2} =  obj.AreaMinMaxT2a(1);
            % 49 Row
            obj.StatisticMat{49,1} = 'Smallest T2a Fiber:';
            obj.StatisticMat{49,2} =  obj.AreaMinMaxObjT2a(1);
            % 50 Row
            obj.StatisticMat{50,1} = sprintf('Largest Area T2a (\x3BCm^2):');
            obj.StatisticMat{50,2} =  obj.AreaMinMaxT2a(2);
            % 51 Row
            obj.StatisticMat{51,1} = 'Largest T2a Fiber:';
            obj.StatisticMat{51,2} =  obj.AreaMinMaxObjT2a(2);
            
            % 52 Row
            obj.StatisticMat{52,1} = sprintf('Smallest Area T2x (\x3BCm^2):');
            obj.StatisticMat{52,2} =  obj.AreaMinMaxT2x(1);
            % 53 Row
            obj.StatisticMat{53,1} = 'Smallest T2x Fiber:';
            obj.StatisticMat{53,2} =  obj.AreaMinMaxObjT2x(1);
            % 54 Row
            obj.StatisticMat{54,1} = sprintf('Largest Area T2x (\x3BCm^2):');
            obj.StatisticMat{54,2} =  obj.AreaMinMaxT2x(2);
            % 55 Row
            obj.StatisticMat{55,1} = 'Largest T2x Fiber:';
            obj.StatisticMat{55,2} =  obj.AreaMinMaxObjT2x(2);
            
            % 56 Row
            obj.StatisticMat{56,1} = sprintf('Smallest Area T2ax (\x3BCm^2):');
            obj.StatisticMat{56,2} =  obj.AreaMinMaxT2ax(1);
            % 57 Row
            obj.StatisticMat{57,1} = 'Smallest T2ax Fiber:';
            obj.StatisticMat{57,2} =  obj.AreaMinMaxObjT2ax(1);
            % 58 Row
            obj.StatisticMat{58,1} = sprintf('Largest Area T2ax (\x3BCm^2):');
            obj.StatisticMat{58,2} =  obj.AreaMinMaxT2ax(2);
            % 59 Row
            obj.StatisticMat{59,1} = 'Largest T2ax Fiber:';
            obj.StatisticMat{59,2} =  obj.AreaMinMaxObjT2ax(2);
            
        end
        
        function saveResults(obj)
            % Prepares all data for saving. Creates cell array depending on
            % the save parameters that will be saved as excel sheet. Save
            % all axes depending on the save parameters.
            %
            %   saveResults(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelResults object.
            %
            
            obj.InfoMessage = ' ';
            obj.InfoMessage = '   - saving data in the same dir than the file was selected';
            
            %Cell arrays for saving data in excel sheet
            CellStatisticTable = {};
            CellFiberTable = {};
            
            %Current date and time
            time = datestr(now,'_yyyy_mm_dd_HHMM');
            
            % Dlete file extension
            [path,fileName,ext] = fileparts(obj.FileName);
            
            % Save dir is the same as the dir from the selected Pic
            SaveDir = [obj.PathName obj.FileName '_RESULTS'];
            obj.InfoMessage = ['   -' obj.PathName obj.FileName '_RESULTS'];
            
            % Check if reslut folder already exist.
            if exist( SaveDir ,'dir') == 7
                % Reslut folder already exist.
                obj.InfoMessage = '      - resluts folder allready excist';
                obj.InfoMessage = '      - add new results files to folder:';
                obj.InfoMessage = ['      - ' SaveDir];
                obj.SavePath = SaveDir;
            else
                % create new main folder to save results
                mkdir(SaveDir);
                obj.InfoMessage = '      - create resluts folder';
                obj.SavePath = SaveDir;
            end
            
            %Add folder with time and date in the main result folder.
            SaveDir = fullfile(SaveDir,[obj.FileName '_RESULTS' time]);
            mkdir(SaveDir);
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save image all color planes processed with boudaries
            if obj.SavePicRGBFRProcessed
                obj.InfoMessage = '      - saving image processed with Farred Plane...';
                
                % save picture as tif file
                f = figure('Units','normalized','Visible','off','ToolBar','none','MenuBar', 'none','Color','w');
                h = copyobj(obj.controllerResultsHandle.viewResultsHandle.hAPProcessedRGBFR,f);
                SizeFig = size(obj.PicPRGBFRPlanes)/max(size(obj.PicPRGBFRPlanes));
                set(f,'Position',[0 0 SizeFig(1) SizeFig(2)])
                set(h,'Units','normalized');
                h.Position = [0 0 1 1];
                h.DataAspectRatioMode = 'auto';
                
                picName ='';
                frame = getframe(f);
                frame=frame.cdata;
                picName = [fileName '_image_processed_withFR' time '.tif'];
                oldPath = pwd;
                cd(SaveDir)
                imwrite(frame,picName)
                cd(oldPath)
                picName ='';
                close(f);
                obj.InfoMessage = '         - image has been saved as .tif';
                
                % save picture as vector graphics
                picName = [fileName '_image_processed_withFR' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hAPProcessedRGBFR,fullFileName);
                picName ='';
                obj.InfoMessage = '         - image has been saved as .pdf vector grafic';
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save image all color planes processed with boudaries
            if obj.SavePicRGBProcessed
                obj.InfoMessage = '      - saving image processed without Farred Plane...';
                
                % save picture as tif file
                f = figure('Units','normalized','Visible','off','ToolBar','none','MenuBar', 'none','Color','w');
                h = copyobj(obj.controllerResultsHandle.viewResultsHandle.hAPProcessedRGB,f);
                SizeFig = size(obj.PicPRGBPlanes)/max(size(obj.PicPRGBPlanes));
                set(f,'Position',[0 0 SizeFig(1) SizeFig(2)])
                set(h,'Units','normalized');
                h.Position = [0 0 1 1];
                h.DataAspectRatioMode = 'auto';
                
                picName ='';
                frame = getframe(f);
                frame=frame.cdata;
                picName = [fileName '_image_processed_withoutFR' time '.tif'];
                oldPath = pwd;
                cd(SaveDir)
                imwrite(frame,picName)
                cd(oldPath)
                picName ='';
                close(f);
                obj.InfoMessage = '         - image has been saved as .tif';
                
                % save picture as vector graphics
                picName = [fileName '_image_processed_withoutFR' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hAPProcessedRGB,fullFileName);
                picName ='';
                obj.InfoMessage = '         - image has been saved as .pdf vector grafic';
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save axes StatisticsTab
            if obj.SavePlots
                obj.InfoMessage = '      - saving axes with statistics plots...';
                
                obj.InfoMessage = '         - saving area plot as .pdf';
                picName = [fileName '_processed_AreaPlot' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                
                fTemp = figure('Visible','off');
                lTemp = findobj('Tag','LegendAreaPlot');
                copyobj([lTemp,obj.controllerResultsHandle.viewResultsHandle.hAArea],fTemp);
                set(lTemp,'Location','best')
                
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '         - saving number of Fiber-Types as .pdf';
                picName = [fileName '_processed_NumberPlot' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                
                fTemp = figure('Visible','off');
                lTemp = findobj('Tag','LegendNumberPlot');
                copyobj([lTemp,obj.controllerResultsHandle.viewResultsHandle.hACount],fTemp);
                set(lTemp,'Location','best')
                
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '         - saving Scatter plot Blue over Red as .pdf';
                picName = [fileName '_processed_ScatterPlotBlueRed' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                
                fTemp = figure('Visible','off');
                lTemp = findobj('Tag','LegendScatterPlotBlueRed');
                copyobj([lTemp,obj.controllerResultsHandle.viewResultsHandle.hAScatterBlueRed],fTemp);
                set(lTemp,'Location','best')
                
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '         - saving Scatter plot Farred over Redas .pdf';
                picName = [fileName '_processed_ScatterPlotFarredRed' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                
                fTemp = figure('Visible','off');
                lTemp = findobj('Tag','LegendScatterPlotFarredRed');
                copyobj([lTemp,obj.controllerResultsHandle.viewResultsHandle.hAScatterFarredRed],fTemp);
                set(lTemp,'Location','best')
                
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '   - saving plots complete';
            end
            
            if obj.SaveScatterAll
                obj.InfoMessage = '      - saving Scatter all Fibers...';
                obj.InfoMessage = '         - saving Scatter plot Farred over Redas .pdf';
                picName = [fileName '_processed_ScatterPlotAll' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                
                fTemp = figure('Visible','off');
                lTemp = findobj('Tag','LegendScatterPlotAll');
                copyobj([lTemp,obj.controllerResultsHandle.viewResultsHandle.hAScatterAll],fTemp);
                set(lTemp,'Location','best')
                
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '   - saving Scatter complete';
                
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % create Cell Array with Fiber-Type Table
            if obj.SaveFiberTable
                obj.InfoMessage = '      - creating Fiber-Type struct';
                
                Header = {'Label' sprintf('Area (\x3BCm^2)') ...
                    'XPos (pixel)' 'YPos (pixel)' sprintf('MajorAxis (\x3BCm)') sprintf('MinorAxis (\x3BCm)') 'Perimeter (pixel)' 'Roundness' ...
                    'AspectRatio' 'ColorHue' 'ColorValue' 'meanRed' 'meanGreen' ...
                    'meanBlue' 'meanFarred' 'Blue/Red' 'Farred/Red'...
                    'FiberMainGroup' 'FiberType'};
                
                CellFiberTable = cat(1,Header,obj.StatsMatData);
                CellFiberTableT1 = cat(1,Header,obj.StatsMatDataT1);
                CellFiberTableT12h = cat(1,Header,obj.StatsMatDataT12h);
                CellFiberTableT2x = cat(1,Header,obj.StatsMatDataT2x);
                CellFiberTableT2a = cat(1,Header,obj.StatsMatDataT2a);
                CellFiberTableT2ax = cat(1,Header,obj.StatsMatDataT2ax);
                
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Save DataFile as xls file
            
            if ~isempty(CellFiberTable)
                obj.InfoMessage = '      - creating .xlsx file';
                
                if ismac
                    % OS is macintosh. xlswrite is not supported. Use
                    % undocumented function from the file exchange Matlab
                    % Forum for creating .xlsx files on a macintosh OS.
                    
                    obj.InfoMessage = '         - UNIX-Systems (macOS) dont support xlswrite() MatLab function';
                    obj.InfoMessage = '         - trying to create excel sheet with undocumented function...';
                    
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-ooxml-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-ooxml-schemas-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/xmlbeans-2.3.0.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/dom4j-1.6.1.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/stax-api-1.0.1.jar'];
                    javaaddpath(path);
                    
                    xlsfileName = [fileName '_processed' time '.xlsx'];
                    
                    
                    oldPath = pwd;
                    cd(SaveDir);
                    
                    obj.InfoMessage = '            - write all fiber types ';
                    sheetName = 'Fyber Types';
                    startRange = 'B2';
                    % undocumented function from the file exchange Matlab Forum
                    % for creating .xlsx files on a macintosh OS
                    status = xlwrite(xlsfileName, CellFiberTable , sheetName, startRange);
                    
                    sheetName = 'Statistics';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write statistic table ';
                    status = xlwrite(xlsfileName, obj.StatisticMat , sheetName, startRange);
                    
                    
                    sheetName = 'Type 1';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 1 fibers ';
                    status = xlwrite(xlsfileName, CellFiberTableT1 , sheetName, startRange);
                    
                    sheetName = 'Type 12h';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 12h fibers ';
                    status = xlwrite(xlsfileName, CellFiberTableT12h , sheetName, startRange);
                    
                    sheetName = 'Type 2x';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2x fibers ';
                    status = xlwrite(xlsfileName, CellFiberTableT2x , sheetName, startRange);
                    
                    sheetName = 'Type 2a';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2a fibers ';
                    status = xlwrite(xlsfileName, CellFiberTableT2a , sheetName, startRange);
                    
                    sheetName = 'Type 2ax';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2ax fibers ';
                    status = xlwrite(xlsfileName, CellFiberTableT2ax , sheetName, startRange);
                    
                    cd(oldPath);
                    
                    if status
                        obj.InfoMessage = '         - .xlxs file has been created';
                    else
                        obj.InfoMessage = '         - .xlxs file could not be created';
                        obj.InfoMessage = '         - creating .txt file instead...';
                        txtfileName = [fileName '_processed' time '.txt'];
                        oldPath = pwd;
                        cd(SaveDir)
                        fid=fopen(txtfileName,'a+');
                        % undocumented function from the file exchange Matlab Forum
                        % for creating .txt files.
                        cell2file(fid,DataFile,'EndOfLine','\r\n');
                        fclose(fid);
                        cd(oldPath)
                        obj.InfoMessage = '         - .txt file has been created';
                    end
                    
                elseif ispc

                    obj.InfoMessage = '         - trying to create excel sheet with undocumented function...';
                    
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-ooxml-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/poi-ooxml-schemas-3.8-20120326.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/xmlbeans-2.3.0.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/dom4j-1.6.1.jar'];
                    javaaddpath(path);
                    path = [pwd '/Functions/xlwrite_for_macOSX/poi_library/stax-api-1.0.1.jar'];
                    javaaddpath(path);
                    
                    xlsfileName = [fileName '_processed' time '.xlsx'];
                    sheetName = 'Fiber types';
                    startRange = 'B2';
                    oldPath = pwd;
                    cd(SaveDir);
                    
                    sheetName = 'Fyber Types';
                    startRange = 'B2';
                    
                    % undocumented function from the file exchange Matlab Forum
                    % for creating .xlsx files on a macintosh OS
                    status = xlwrite(xlsfileName, CellFiberTable , sheetName, startRange);
                    
                    sheetName = 'Statistics';
                    startRange = 'B2';
                    
                    status = xlwrite(xlsfileName, obj.StatisticMat , sheetName, startRange);
                    
                    
                    sheetName = 'Type 1';
                    startRange = 'B2';
                    
                    status = xlwrite(xlsfileName, CellFiberTableT1 , sheetName, startRange);
                    
                    sheetName = 'Type 12h';
                    startRange = 'B2';
                    
                    status = xlwrite(xlsfileName, CellFiberTableT12h , sheetName, startRange);
                    
                    sheetName = 'Type 2x';
                    startRange = 'B2';
                    
                    status = xlwrite(xlsfileName, CellFiberTableT2x , sheetName, startRange);
                    
                    sheetName = 'Type 2a';
                    startRange = 'B2';
                    
                    status = xlwrite(xlsfileName, CellFiberTableT2a , sheetName, startRange);
                    
                    sheetName = 'Type 2ax';
                    startRange = 'B2';
                    
                    status = xlwrite(xlsfileName, CellFiberTableT2ax , sheetName, startRange);
                    
                    cd(oldPath);
                    
                    if status
                        obj.InfoMessage = '         - .xlxs file has been created';
                    else
                        obj.InfoMessage = '         - .xlxs file could not be created';
                        obj.InfoMessage = '         - creating .txt file instead...';
                        txtfileName = [fileName '_processed' time '.txt'];
                        oldPath = pwd;
                        cd(SaveDir)
                        fid=fopen(txtfileName,'a+');
                        % undocumented function from the file exchange Matlab Forum
                        % for creating .txt files.
                        cell2file(fid,DataFile,'EndOfLine','\r\n');
                        fclose(fid);
                        cd(oldPath)
                        obj.InfoMessage = '         - .txt file has been created';
                    end
                end
                
            end
            obj.InfoMessage = '   - Saving data complete';
        end

        function delete(obj)
            %deconstructor
        end
        
    end
    
end

