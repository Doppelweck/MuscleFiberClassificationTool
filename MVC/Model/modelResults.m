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
        SaveHisto; %Indicates whether the Histogram plots should be saved.
        SavePicProcessed; %Indicates whether the processed image with Farred should be saved.
        SavePicGroups; %Indicates whether the processed image without Farred should be saved.
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
        
        minPointsPerCluster;
        
        Hybrid12FiberActive;
        Hybrid2axFiberActive;
        
        NoOfObjects; %Number of objects.
        NoTyp1; %Number of Type 1 fibers.
        NoTyp12h; %Number of Type 12 hybeid fibers.
        NoTyp2; %Number of Type 2 fibers.
        NoTyp2a; %Number of Type 2a fibers.
        NoTyp2x; %Number of Type 2x fibers.
        NoTyp2ax; %Number of Type 2ax fibers.
        NoTyp0; %Number of Type 0 fibers (undefind).
        
        AreaPic; % Total area of the RGB image.
        AreaType1; % Total area of all type 1 fibers.
        AreaType2; % Total area of all type 2 fibers.
        AreaType2a; % Total area of all type 2a fibers.
        AreaType2x; % Total area of all type 2x fibers.
        AreaType2ax; % Total area of all type 2ax (2a 2x hybrid) fibers.
        AreaType12h; % Total area of all type 3 (1 2 hybrid) fibers.
        AreaType0; % Total area of all type 0 fibers.
        AreaFibers; % Total area of all fiber objects.
        AreaNoneObj; % Total area that contains no objects (Collagen).
        
        AreaType1PC; % Area of all type 1 fibers in percent.
        AreaType12hPC; % Aarea of all type 12 hybrid fibers in percent.
        AreaType2PC; % Aarea of all type 2 hybrid fibers in percent.
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
        AreaMinMaxT2; %Vector, contains the [min max] area in pixel of all Type 2 hybrid fibers.
        AreaMinMaxObjT2; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of all Type 2 hybrid fibers.
        AreaMinMaxT2a; %Vector, contains the [min max] area in pixel of Type 2a fibers.
        AreaMinMaxObjT2a; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 2a fibers.
        AreaMinMaxT2x; %Vector, contains the [min max] area in pixel of Type 2x fibers.
        AreaMinMaxObjT2x; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 2x fibers.
        AreaMinMaxT2ax; %Vector, contains the [min max] area in pixel of Type 2ax fibers.
        AreaMinMaxObjT2ax; %Vector, concontainsteins the [lmin lmax] label of the objects with the min max area in pixel of Type 2ax fibers.
        
        XScale; %Inicates the um/pixels in X direction to change values in micro meter.
        YScale; %Inicates the um/pixels in Y direction to change values in micro meter.
        
        Stats; %Data struct of all fiber objets and all fiber datas
        GroupStats;
        StatsMatData; %Cell Array, Contains the data of all fiber objets that are shown in the object table in the GUI.
        % [Label Area XPos YPos minDiameter maxDiameter Perimeter Roundness ...
        %  AspectRatio ColorHue VolorValue Red Green Blue FarRed ...
        %  Blue/Red Farred/Red MainType Type]
        StatsMatDataT1; % Contains the data of all type 1 fiber objets.
        StatsMatDataT12h; % Contains the data of all type 12 hybrid fiber objets.
        StatsMatDataT2; % Contains the data of all type 2 fiber objets. 
        StatsMatDataT2a; % Contains the data of all type 2a fiber objets.
        StatsMatDataT2x; % Contains the data of all type 2x fiber objets.
        StatsMatDataT2ax; % Contains the data of all type 2ax fiber objets.
        StatsMatDataT0; % Contains the data of all type 0 undefined fiber objets.
        
        StatisticMat; % Contains the statistc data af the ruslts.
        
        busyIndicator; %Java object in the left bottom corner that shows whether the program is busy.
        busyObj; %All objects that are enabled during the calculation.
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
            
            obj.findFiberGroups();
            
            obj.controllerResultsHandle.showAxesDataInGUI();
            
            obj.controllerResultsHandle.showInfoInTableGUI();
            
            obj.controllerResultsHandle.showHistogramGUI();
            
            obj.controllerResultsHandle.showPicProcessedGUI();
            
            obj.controllerResultsHandle.showPicGroupsGUI();
            
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
%             tempCell = rmfield(tempCell,'Solidity');
            %remove field AreaMaxCS (max Area Cross Section)
%             tempCell = rmfield(tempCell,'AreaMaxCS');

            %order Fields for Excel Sheet and GUI Table
            tempCell=orderfields(tempCell, {'Area','AreaMinCS','AreaMaxCS', 'Perimeter', 'minDiameter',...
                'maxDiameter','Roundness','AspectRatio','ColorValue',...
                'ColorRed','ColorGreen','ColorBlue','ColorFarRed',...
                'ColorRatioBlueRed','ColorRatioFarredRed','FiberTypeMainGroup',...
                'FiberType'});
            
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
            obj.StatsMatData = cat(2, LabelNo,FCPX,FCPY,tempCell);
            
            % Create CellArray only for Type 1 Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,end), 'Type 1');
            Index = find(IndexC==1);
            obj.StatsMatDataT1 = obj.StatsMatData(Index,:);
            
            % Create CellArray only for Type 12h Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,end), 'Type 12h');
            Index = find(IndexC==1);
            obj.StatsMatDataT12h = obj.StatsMatData(Index,:);
            
            % Create CellArray only for Type 2 Fiber objects
            IndexC = find( [obj.StatsMatData{:,end-1}] == 2 );
            obj.StatsMatDataT2 = obj.StatsMatData(IndexC,:);
            
            % Create CellArray only for Type 2a Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,end), 'Type 2a');
            Index = find(IndexC==1);
            obj.StatsMatDataT2a = obj.StatsMatData(Index,:);
            
            % Create CellArray only for Type 2a Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,end), 'Type 2x');
            Index = find(IndexC==1);
            obj.StatsMatDataT2x = obj.StatsMatData(Index,:);
            
            % Create CellArray only for Type 2a Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,end), 'Type 2ax');
            Index = find(IndexC==1);
            obj.StatsMatDataT2ax = obj.StatsMatData(Index,:);
          
            % Create CellArray only for Type 0 undifined Fiber objects
            IndexC = strcmp(obj.StatsMatData(:,end), 'undefined');
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
            
            obj.InfoMessage = '   - calculate fiber type areas...';
            %Area Image in um^2
            obj.AreaPic = size(obj.PicPRGBFRPlanes,1) * size(obj.PicPRGBFRPlanes,2) * obj.XScale * obj.YScale;
            obj.AreaType1 = 0;
            obj.AreaType2 = 0;
            obj.AreaType2a = 0;
            obj.AreaType2x = 0;
            obj.AreaType2ax = 0;
            obj.AreaType12h = 0;
            obj.AreaType0 = 0;
            obj.AreaFibers = 0;
            
            obj.AreaType1PC = 0;
            obj.AreaType2PC = 0;
            obj.AreaType2aPC = 0;
            obj.AreaType2xPC = 0;
            obj.AreaType2axPC = 0;
            obj.AreaType12hPC = 0;
            obj.AreaType0PC = 0;

            %Total area of all Type-1 fibers.
            IsType1 = find( strcmp({obj.Stats.FiberType} , 'Type 1') );
            obj.AreaType1 = sum([obj.Stats(IsType1).Area]);
            %Total area of all Type-12h fibers.
            IsType12h = find( strcmp({obj.Stats.FiberType} , 'Type 12h') );
            obj.AreaType12h = sum([obj.Stats(IsType12h).Area]);
            %Total area of all Type-2 fibers.
            IsType2 = find( [obj.Stats.FiberTypeMainGroup] == 2 );
            obj.AreaType2 = sum([obj.Stats(IsType2).Area]);
            %Total area of all Type-2a fibers.
            IsType2a = find( strcmp({obj.Stats.FiberType} , 'Type 2a') );
            obj.AreaType2a = sum([obj.Stats(IsType2a).Area]);
            %Total area of all Type-2ax fibers.
            IsType2ax = find( strcmp({obj.Stats.FiberType} , 'Type 2ax') );
            obj.AreaType2ax = sum([obj.Stats(IsType2ax).Area]);
            %Total area of all Type-2x fibers.
            IsType2x = find( strcmp({obj.Stats.FiberType} , 'Type 2x') );
            obj.AreaType2x = sum([obj.Stats(IsType2x).Area]);
            %Total area of all Type-0 fibers.
            IsType0 = find( strcmp({obj.Stats.FiberType} , 'undefined') );
            obj.AreaType0 = sum([obj.Stats(IsType0).Area]);
            
            % Total area of all fiber objects including Type 0
            obj.AreaFibers = obj.AreaType1+obj.AreaType12h+obj.AreaType2+obj.AreaType0;
            % Total area that consists no Objects. Collagen (green)
            obj.AreaNoneObj = obj.AreaPic - obj.AreaFibers;
            
            % Calculate area in percent of Fibertypes related to the original image
            obj.AreaType1PC = obj.AreaType1/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType1PC) ' % of the image consists of Type 1 fibers'];
            
            obj.AreaType12hPC = obj.AreaType12h/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType12hPC) ' % of the image consists of Type 12 hybrid fibers'];
            
            obj.AreaType2PC = obj.AreaType2/obj.AreaPic * 100;
            obj.InfoMessage = ['      - ' num2str(obj.AreaType2PC) ' % of the image consists of Type 2 fibers'];
            
            if obj.AnalyzeMode == 2 || obj.AnalyzeMode == 4 || obj.AnalyzeMode == 6
                obj.AreaType2xPC = obj.AreaType2x/obj.AreaPic * 100;
                obj.InfoMessage = ['         - ' num2str(obj.AreaType2xPC) ' % of the image consists of Type 2x fibers'];
                
                obj.AreaType2aPC = obj.AreaType2a/obj.AreaPic * 100;
                obj.InfoMessage = ['         - ' num2str(obj.AreaType2aPC) ' % of the image consists of Type 2a fibers'];
                
                obj.AreaType2axPC = obj.AreaType2ax/obj.AreaPic * 100;
                obj.InfoMessage = ['         - ' num2str(obj.AreaType2axPC) ' % of the image consists of Type 2ax fibers'];
            end
            
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
            obj.InfoMessage = '   - find min and max areas';
            if ~isempty(obj.StatsMatDataT1)
                obj.AreaMinMaxT1(1) = min(cell2mat(obj.StatsMatDataT1(:,4)));
                obj.AreaMinMaxObjT1(1) = cell2mat(obj.StatsMatDataT1( find([obj.StatsMatDataT1{:,4}]==obj.AreaMinMaxT1(1),1) ,1));
                obj.AreaMinMaxT1(2) = max(cell2mat(obj.StatsMatDataT1(:,4)));
                obj.AreaMinMaxObjT1(2) = cell2mat(obj.StatsMatDataT1( find([obj.StatsMatDataT1{:,4}]==obj.AreaMinMaxT1(2),1) ,1));
            else
                obj.AreaMinMaxT1 = '--';
                obj.AreaMinMaxObjT1 = '--';

            end
            
            if ~isempty(obj.StatsMatDataT12h)
                obj.AreaMinMaxT12h(1) = min(cell2mat(obj.StatsMatDataT12h(:,4)));
                obj.AreaMinMaxObjT12h(1) = cell2mat(obj.StatsMatDataT12h( find([obj.StatsMatDataT12h{:,4}]==obj.AreaMinMaxT12h(1),1) ,1));
                obj.AreaMinMaxT12h(2) = max(cell2mat(obj.StatsMatDataT12h(:,4)));
                obj.AreaMinMaxObjT12h(2) = cell2mat(obj.StatsMatDataT12h( find([obj.StatsMatDataT12h{:,4}]==obj.AreaMinMaxT12h(2),1) ,1));
            else
                obj.AreaMinMaxT12h = '--';
                obj.AreaMinMaxObjT12h = '--';

            end
            
            if ~isempty(obj.StatsMatDataT2)
                obj.AreaMinMaxT2(1) = min(cell2mat(obj.StatsMatDataT2(:,4)));
                obj.AreaMinMaxObjT2(1) = cell2mat(obj.StatsMatDataT2( find([obj.StatsMatDataT2{:,4}]==obj.AreaMinMaxT2(1),1) ,1));
                obj.AreaMinMaxT2(2) = max(cell2mat(obj.StatsMatDataT2(:,4)));
                obj.AreaMinMaxObjT2(2) = cell2mat(obj.StatsMatDataT2( find([obj.StatsMatDataT2{:,4}]==obj.AreaMinMaxT2(2),1) ,1));
            else
                obj.AreaMinMaxT2a = '--';
                obj.AreaMinMaxObjT2a = '--';

            end
            
            if ~isempty(obj.StatsMatDataT2a)
                obj.AreaMinMaxT2a(1) = min(cell2mat(obj.StatsMatDataT2a(:,4)));
                obj.AreaMinMaxObjT2a(1) = cell2mat(obj.StatsMatDataT2a( find([obj.StatsMatDataT2a{:,4}]==obj.AreaMinMaxT2a(1),1) ,1));
                obj.AreaMinMaxT2a(2) = max(cell2mat(obj.StatsMatDataT2a(:,4)));
                obj.AreaMinMaxObjT2a(2) = cell2mat(obj.StatsMatDataT2a( find([obj.StatsMatDataT2a{:,4}]==obj.AreaMinMaxT2a(2),1) ,1));
            else
                obj.AreaMinMaxT2a = '--';
                obj.AreaMinMaxObjT2a = '--';

            end
            
            if ~isempty(obj.StatsMatDataT2x)
                obj.AreaMinMaxT2x(1) = min(cell2mat(obj.StatsMatDataT2x(:,4)));
                obj.AreaMinMaxObjT2x(1) = cell2mat(obj.StatsMatDataT2x( find([obj.StatsMatDataT2x{:,4}]==obj.AreaMinMaxT2x(1),1) ,1));
                obj.AreaMinMaxT2x(2) = max(cell2mat(obj.StatsMatDataT2x(:,4)));
                obj.AreaMinMaxObjT2x(2) = cell2mat(obj.StatsMatDataT2x( find([obj.StatsMatDataT2x{:,4}]==obj.AreaMinMaxT2x(2),1) ,1));
            else
                obj.AreaMinMaxT2x = '--';
                obj.AreaMinMaxObjT2x = '--';

            end
            
            if ~isempty(obj.StatsMatDataT2ax)
                obj.AreaMinMaxT2ax(1) = min(cell2mat(obj.StatsMatDataT2ax(:,4)));
                obj.AreaMinMaxObjT2ax(1) = cell2mat(obj.StatsMatDataT2ax( find([obj.StatsMatDataT2ax{:,4}]==obj.AreaMinMaxT2ax(1),1) ,1));
                obj.AreaMinMaxT2ax(2) = max(cell2mat(obj.StatsMatDataT2ax(:,4)));
                obj.AreaMinMaxObjT2ax(2) = cell2mat(obj.StatsMatDataT2ax( find([obj.StatsMatDataT2ax{:,4}]==obj.AreaMinMaxT2ax(2),1) ,1));
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
            
            obj.NoTyp1 = 0;
            obj.NoTyp12h = 0;
            obj.NoTyp2 = 0;
            obj.NoTyp2x = 0;
            obj.NoTyp2a = 0;
            obj.NoTyp2ax = 0;
            
            % Number of Fiber Objects
            obj.NoOfObjects = size(obj.Stats,1); %all objects

            obj.NoTyp1 = size(obj.StatsMatDataT1,1); % Type 1
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp1) ' Type 1 fibers'];
            
            obj.NoTyp12h = size(obj.StatsMatDataT12h,1); % Type 12h
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp12h) ' Type 12 hybrid fibers'];
            
            obj.NoTyp2 = size(obj.StatsMatDataT2,1); % Type 12h
            obj.InfoMessage = ['      - ' num2str(obj.NoTyp2) ' Type 2 fibers'];
            
            if obj.AnalyzeMode == 2 || obj.AnalyzeMode == 4 || obj.AnalyzeMode == 6 
                %quad labeling was active during classification
                obj.NoTyp2a = size(obj.StatsMatDataT2a,1); % Type 2a
                obj.InfoMessage = ['         - ' num2str(obj.NoTyp2a) ' Type 2a fibers'];
                
                obj.NoTyp2x = size(obj.StatsMatDataT2x,1); % Type 2x
                obj.InfoMessage = ['         - ' num2str(obj.NoTyp2x) ' Type 2x fibers'];
                
                obj.NoTyp2ax = size(obj.StatsMatDataT2ax,1); % Type 2ax
                obj.InfoMessage = ['         - ' num2str(obj.NoTyp2ax) ' Type 2ax fibers'];
            end
            
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
            obj.InfoMessage = '   - create statistic cell array';
            obj.StatisticMat = {}; 
            
            obj.StatisticMat{end+1,1} = 'Analyze Mode:';
            switch obj.AnalyzeMode
                case 1
                    obj.StatisticMat{end,2} =  'Color-Based triple labeling';
                case 2
                    obj.StatisticMat{end,2} =  'Color-Based quad labeling';
                case 3
                    obj.StatisticMat{end,2} =  'OPTICS-Cluster-Based triple labeling';
                case 4
                    obj.StatisticMat{end,2} =  'OPTICS-Cluster-Based quad labeling';
                case 5
                    obj.StatisticMat{end,2} =  'Manual Classification triple labeling';
                case 6
                    obj.StatisticMat{end,2} =  'Manual Classification quad labeling'; 
                case 7
                    obj.StatisticMat{end,2} =  'Collagen/dystrophin'; 
            end

            obj.StatisticMat{end+1,1} = 'Searching for:';
            switch obj.AnalyzeMode
                case 1
                    obj.StatisticMat{end,2} =  'Type 1 2 12h fibers';
                case 2
                    obj.StatisticMat{end,2} =  'Type 1 12h 2x 2a 2ax fibers';
                case 3
                    obj.StatisticMat{end,2} =  'Type 1 2 12h fibers';
                case 4
                    obj.StatisticMat{end,2} =  'Type 1 12h 2x 2a 2ax fibers';
                case 5
                    obj.StatisticMat{end,2} =  'Type 1 2 12h fibers (manual)';
                case 6
                    obj.StatisticMat{end,2} =  'Type 1 12h 2x 2a 2ax fibers (manual)';
                case 7
                    obj.StatisticMat{end,2} =  'No Classification'; 
            end
            
            obj.StatisticMat{end+1,1} = sprintf('Para min Area (\x3BCm^2):');
            if obj.AreaActive
                obj.StatisticMat{end,2} =  obj.MinAreaPixel;
            else
                obj.StatisticMat{end,2} =  'not active';
            end
            obj.StatisticMat{end+1,1} = sprintf('Para max Area (\x3BCm^2):');
            if obj.AreaActive
                obj.StatisticMat{end,2} =  obj.MaxAreaPixel;
            else
                obj.StatisticMat{end,2} =  'not active';
            end
            
            obj.StatisticMat{end+1,1} = 'Para min Aspect Ratio:';
            if obj.AspectRatioActive
                obj.StatisticMat{end,2} =  obj.MinAspectRatio;
            else
                obj.StatisticMat{end,2} =  'not active';
            end
            obj.StatisticMat{end+1,1} = 'Para max Aspect Ratio:';
            if obj.AspectRatioActive
                obj.StatisticMat{end,2} =  obj.MaxAspectRatio;
            else
                obj.StatisticMat{end,2} =  'not active';
            end
            
            obj.StatisticMat{end+1,1} = 'Para min Roundness:';
            if obj.RoundnessActive
                obj.StatisticMat{end,2} =  obj.MinRoundness;
            else
                obj.StatisticMat{end,2} =  'not active';
            end
            
            obj.StatisticMat{end+1,1} = 'Para min Color-Value:';
            if obj.ColorValueActive
                obj.StatisticMat{end,2} =  obj.ColorValue;
            else
                obj.StatisticMat{end,2} =  'not active';
            end
            
            obj.StatisticMat{end+1,1} = 'Para Blue/Red thresh:';
            obj.StatisticMat{end+1,1} = 'Para Blue distance:';
            obj.StatisticMat{end+1,1} = 'Para Red distance:';
            
            if obj.BlueRedThreshActive
                obj.StatisticMat{end-2,2} =  obj.BlueRedThresh;
                obj.StatisticMat{end-1,2} =  obj.BlueRedDistBlue;
                obj.StatisticMat{end,2} =  obj.BlueRedDistRed;
            else
                obj.StatisticMat{end-2,2} = 'not active';
                obj.StatisticMat{end-1,2} = 'not active';
                obj.StatisticMat{end,2} = 'not active';
            end
            
            obj.StatisticMat{end+1,1} = 'Para Farred/Red thresh:';
            obj.StatisticMat{end+1,1} = 'Para Farred distance:';
            obj.StatisticMat{end+1,1} = 'Para Red distance:';
            
            if obj.FarredRedThreshActive
                obj.StatisticMat{end-2,2} = obj.FarredRedThresh;
                obj.StatisticMat{end-1,2} = obj.FarredRedDistFarred;
                obj.StatisticMat{end,2} = obj.FarredRedDistRed;
            else
                obj.StatisticMat{end-2,2} = 'not active';
                obj.StatisticMat{end-1,2} = 'not active';
                obj.StatisticMat{end,2} = 'not active';
            end
            
            obj.StatisticMat{end+1,1} = 'Para min Points per Cluster:';
            obj.StatisticMat{end,2} = obj.minPointsPerCluster;
            
            obj.StatisticMat{end+1,1} = 'Para Cluster 1/2 Hybrid Fibers:';
            
            if obj.Hybrid12FiberActive && (obj.AnalyzeMode == 3 || obj.AnalyzeMode == 4)
                obj.StatisticMat{end,2} = '12h Fibers allowed';
            elseif ~obj.Hybrid12FiberActive && (obj.AnalyzeMode == 3 || obj.AnalyzeMode == 4)
                obj.StatisticMat{end,2} = '12h Fibers not allowed';
            else
               obj.StatisticMat{end,2} = 'not active'; 
            end
            
            obj.StatisticMat{end+1,1} = 'Para Cluster 2ax Hybrid Fibers:';
            if obj.Hybrid2axFiberActive && (obj.AnalyzeMode == 3 || obj.AnalyzeMode == 4)
                obj.StatisticMat{end,2} = '2ax Fibers allowed';
            elseif ~obj.Hybrid12FiberActive && (obj.AnalyzeMode == 3 || obj.AnalyzeMode == 4)
                obj.StatisticMat{end,2} = '2ax Fibers not allowed';
            else
               obj.StatisticMat{end,2} = 'not active'; 
            end
            
            
            obj.StatisticMat{end+1,1} = sprintf('XScale in \x3BCm/pixel:');
            obj.StatisticMat{end,2} =  obj.XScale;

            obj.StatisticMat{end+1,1} = sprintf('XScale in \x3BCm/pixel:');
            obj.StatisticMat{end,2} =  obj.YScale;
            
            obj.StatisticMat{end+1,1} = 'Number objects:';
            obj.StatisticMat{end,2} =  obj.NoOfObjects;

            obj.StatisticMat{end+1,1} = 'Number Type 1:';
            obj.StatisticMat{end,2} =  obj.NoTyp1;
           
            obj.StatisticMat{end+1,1} = 'Number Type 12h:';
            obj.StatisticMat{end,2} =  obj.NoTyp12h;
            
            obj.StatisticMat{end+1,1} = 'Number all Type 2:';
            obj.StatisticMat{end,2} =  obj.NoTyp2;
           
            obj.StatisticMat{end+1,1} = 'Number Type 2a:';
            obj.StatisticMat{end,2} =  obj.NoTyp2a;
            
            obj.StatisticMat{end+1,1} = 'Number Type 2x:';
            obj.StatisticMat{end,2} =  obj.NoTyp2x;
            
            obj.StatisticMat{end+1,1} = 'Number Type 2ax:';
            obj.StatisticMat{end,2} =  obj.NoTyp2ax;
           
            obj.StatisticMat{end+1,1} = 'Number undefined:';
            obj.StatisticMat{end,2} =  obj.NoTyp0;
            
            obj.StatisticMat{end+1,1} =  sprintf('Area Type 1 (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaType1;

            obj.StatisticMat{end+1,1} =  sprintf('Area Type 12h (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaType12h;
            
            obj.StatisticMat{end+1,1} =  sprintf('Area all Type 2 (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaType2;
           
            obj.StatisticMat{end+1,1} =  sprintf('Area Type 2a (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaType2a;
          
            obj.StatisticMat{end+1,1} =  sprintf('Area Type 2x (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaType2x;
         
            obj.StatisticMat{end+1,1} =  sprintf('Area Type 2ax (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaType2ax;
           
            obj.StatisticMat{end+1,1} = sprintf('Area Collagen (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaNoneObj;
            
            obj.StatisticMat{end+1,1} = 'Area Type 1 (%):';
            obj.StatisticMat{end,2} =  obj.AreaType1PC;
            
            obj.StatisticMat{end+1,1} = 'Area Type 12h (%):';
            obj.StatisticMat{end,2} =  obj.AreaType12hPC;
            
            obj.StatisticMat{end+1,1} = 'Area all Type 2 (%):';
            obj.StatisticMat{end,2} =  obj.AreaType2PC;
            
            obj.StatisticMat{end+1,1} = 'Area Type 2a (%):';
            obj.StatisticMat{end,2} =  obj.AreaType2aPC;
            
            obj.StatisticMat{end+1,1} = 'Area Type 2x (%):';
            obj.StatisticMat{end,2} =  obj.AreaType2xPC;
            
            obj.StatisticMat{end+1,1} = 'Area Type 2ax (%):';
            obj.StatisticMat{end,2} =  obj.AreaType2axPC;
            
            obj.StatisticMat{end+1,1} = 'Area Collagen (%):';
            obj.StatisticMat{end,2} =  obj.AreaNoneObjPC;
            
            obj.StatisticMat{end+1,1} =  sprintf('Smallest Area (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMax(1);
          
            obj.StatisticMat{end+1,1} = 'Smallest Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObj(1);
          
            obj.StatisticMat{end+1,1} =  sprintf('Largest Area (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMax(2);
          
            obj.StatisticMat{end+1,1} = 'Largest Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObj(2);
            
            obj.StatisticMat{end+1,1} = sprintf('Smallest Area T1 (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT1(1);

            obj.StatisticMat{end+1,1} = 'Smallest T1 Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT1(1);

            obj.StatisticMat{end+1,1} = sprintf('Largest Area T1 (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT1(2);
            
            obj.StatisticMat{end+1,1} = 'Largest T1 Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT1(2);

            obj.StatisticMat{end+1,1} = sprintf('Smallest Area T12h (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT12h(1);
            
            obj.StatisticMat{end+1,1} = 'Smallest T12h Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT12h(1);
           
            obj.StatisticMat{end+1,1} = sprintf('Largest Area T12h (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT12h(2);
            
            obj.StatisticMat{end+1,1} = 'Largest T12h Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT12h(2);
            
            
            obj.StatisticMat{end+1,1} = sprintf('Smallest Area T2 (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT2(1);

            obj.StatisticMat{end+1,1} = 'Smallest T2 Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT2(1);
    
            obj.StatisticMat{end+1,1} = sprintf('Largest Area T2 (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT2(2);
            
            obj.StatisticMat{end+1,1} = 'Largest T2 Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT2(2);
            
    
            obj.StatisticMat{end+1,1} = sprintf('Smallest Area T2a (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT2a(1);

            obj.StatisticMat{end+1,1} = 'Smallest T2a Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT2a(1);
    
            obj.StatisticMat{end+1,1} = sprintf('Largest Area T2a (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT2a(2);
            
            obj.StatisticMat{end+1,1} = 'Largest T2a Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT2a(2);
            
            obj.StatisticMat{end+1,1} = sprintf('Smallest Area T2x (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT2x(1);
            
            obj.StatisticMat{end+1,1} = 'Smallest T2x Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT2x(1);
           
            obj.StatisticMat{end+1,1} = sprintf('Largest Area T2x (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT2x(2);
           
            obj.StatisticMat{end+1,1} = 'Largest T2x Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT2x(2);
            
            obj.StatisticMat{end+1,1} = sprintf('Smallest Area T2ax (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT2ax(1);
           
            obj.StatisticMat{end+1,1} = 'Smallest T2ax Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT2ax(1);
           
            obj.StatisticMat{end+1,1} = sprintf('Largest Area T2ax (\x3BCm^2):');
            obj.StatisticMat{end,2} =  obj.AreaMinMaxT2ax(2);
            
            obj.StatisticMat{end+1,1} = 'Largest T2ax Fiber:';
            obj.StatisticMat{end,2} =  obj.AreaMinMaxObjT2ax(2);
            
        end
        
        function findFiberGroups(obj)
            obj.InfoMessage = '   - searching for fiber type groups...';
            
            se = strel('disk',2);
            Imag = obj.LabelMat; %get Label Mat
            
            obj.InfoMessage = '      - create convex hull';
            BW_C = zeros(size(obj.LabelMat));
            for i=1:1:size(obj.Stats,1)
                % seperate centroid in X and Y values
                FCPX = round(obj.Stats(i).Centroid(1));
                FCPY = round(obj.Stats(i).Centroid(2));
                BW_C(FCPY,FCPX)=1;
            end
            BW_C=bwconvhull(BW_C);
            
            
            BW = zeros(size(obj.LabelMat));
            BW(obj.LabelMat>0)=1;
            Hull = BW_C | BW;
%             Hull = bwconvhull(HullC);
            Hull = imdilate(Hull,se);
            
            obj.InfoMessage = '      - lable space withount fibers';
            Imag(Hull==0)=max(max(Imag))+1;
            ImagDist = bwdist(Imag); %Dist transform
          
            
%             figure(9)
%             imshow(Hull,[])
            obj.InfoMessage = '      - minimize collagen thickness';
            I_WS=watershed(ImagDist); 
%             I_BW=ones(size(I_WS));
%             I_BW(I_WS==0)=0; %Binary Mat without Collagen thiknes
%             
%             
%             [I_Bound,I_Label] = bwboundaries(I_BW,8,'noholes');
%             I_Label = I_Label*(-1); %Set all Labels negativ
%             
%             figure()
%             imshow(Imag,[])
            I_Label = double(I_WS)*(-1);
            n = max(max(obj.LabelMat)); %No. of Objects
            
            obj.InfoMessage = '      - rearrange labels';
            for i=1:1:n %rearrange Labels
                Value = unique( I_Label(Imag==i));
                I_Label(I_Label==Value)=i;
            end
%             figure()
%             imshow(I_Label)
%             figure(10)
%             imshow(Imag)
%             CH = bwconvhull(Imag);
%             figure(11)
%             imshow(CH)
% %             CH= activecontour(Imag,CH,100,'edge');
%             I_Label(CH==0)=0;
%             
%             figure(12)
%             imshow(CH)
            obj.InfoMessage = '      - searching for fiber type groups...';
            IsType1 = find( strcmp({obj.Stats.FiberType} , 'Type 1') );
            IsType12h = find( strcmp({obj.Stats.FiberType} , 'Type 12h') );
            IsType2 = find( strcmp({obj.Stats.FiberType} , 'Type 2') );
            IsType2a = find( strcmp({obj.Stats.FiberType} , 'Type 2a') );
            IsType2ax = find( strcmp({obj.Stats.FiberType} , 'Type 2ax') );
            IsType2x = find( strcmp({obj.Stats.FiberType} , 'Type 2x') );
            IsType0 = find( strcmp({obj.Stats.FiberType} , 'undefined') );
            
            LrgbT1 = [];
            LrgbT12h = [];
            LrgbT2x = [];
            LrgbT2a = [];
            LrgbT2ax = [];
            
            
            
%             
%             IsType1 = find([obj.Stats.FiberTypeMainGroup] == 1);
%             IsType2 = find([obj.Stats.FiberTypeMainGroup] == 2);
%             IsType3 = find([obj.Stats.FiberTypeMainGroup] == 3);
%             IBWT1=[];
%             IBWT2=[];
%             IBWT3=[];
            se = strel('disk',1);
            
            %%%%%%%%%%%%%%%%%%%%% Type-1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if ~isempty(IsType1)
                obj.InfoMessage = '         - find Type-1 groups';
                IBWT1=zeros(size(I_Label));  
                for i=1:1:size(IsType1,2)
                    IBWT1(I_Label==IsType1(i))=1;
                end
                IBWT1_C=imclose(IBWT1,se);
%                 IBWT1 = bwmorph(IBWT1_C,'thin',2);
                [BWT1_Bound,BWT1_Label] = bwboundaries(IBWT1_C,8,'noholes');
                LrgbT1(:,:,1)=IBWT1_C*0;
                LrgbT1(:,:,2)=IBWT1_C*0;
                LrgbT1(:,:,3)=IBWT1_C*1;
                
                nG = max(max(BWT1_Label)); %find number of fiber type groups
                NoObj = [];
                for i=1:1:nG
                    %Find number of fibers within each group
                    Vec=unique(obj.LabelMat(BWT1_Label==i));
                    Vec(Vec==0)=[];
                    NoObj(i)=length(Vec);
                end
                
                %Store Data in GroupStats
                obj.GroupStats.BoundT1 = BWT1_Bound;
                obj.GroupStats.LabelT1 = BWT1_Label;
                obj.GroupStats.NoObjT1 = NoObj;
                
            else
                LrgbT1(:,:,1)=zeros(size(I_Label));
                LrgbT1(:,:,2)=zeros(size(I_Label));
                LrgbT1(:,:,3)=zeros(size(I_Label)); 
                
                obj.GroupStats.BoundT1 = [];
                obj.GroupStats.LabelT1 = [];
                obj.GroupStats.NoObjT1 = [];
            end
            
            %%%%%%%%%%%%%%%%%%%%% Type-12h %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if ~isempty(IsType12h)
                obj.InfoMessage = '         - find Type-12h groups';
                IBWT12h=zeros(size(I_Label));   
                for i=1:1:size(IsType12h,2)
                    IBWT12h(I_Label==IsType12h(i))=1;
                end
                IBWT12h_C=imclose(IBWT12h,se);
%                 IBWT12h = bwmorph(IBWT12h_C,'thin',2);
                [BWT12h_Bound,BWT12h_Label] = bwboundaries(IBWT12h_C,8,'noholes');
                LrgbT12h(:,:,1)=IBWT12h_C*1;
                LrgbT12h(:,:,2)=IBWT12h_C*0;
                LrgbT12h(:,:,3)=IBWT12h_C*1;
                
                nG = max(max(BWT12h_Label)); %find number of fiber type groups
                NoObj = [];
                for i=1:1:nG
                    %Find number of fibers within each group
                    Vec=unique(obj.LabelMat(BWT12h_Label==i));
                    Vec(Vec==0)=[];
                    NoObj(i)=length(Vec);
                end
                
                %Store Data in GroupStats
                obj.GroupStats.BoundT12h = BWT12h_Bound;
                obj.GroupStats.LabelT12h = BWT12h_Label;
                obj.GroupStats.NoObjT12h = NoObj;
                
            else
                LrgbT12h(:,:,1)=zeros(size(I_Label));
                LrgbT12h(:,:,2)=zeros(size(I_Label));
                LrgbT12h(:,:,3)=zeros(size(I_Label));
                
                obj.GroupStats.BoundT12h = [];
                obj.GroupStats.LabelT12h = [];
                obj.GroupStats.NoObjT12h = [];
            end
            
             %%%%%%%%%%%%%%%%%%%%% Type-2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if ~isempty(IsType2)
                obj.InfoMessage = '         - find Type-2 groups';
                IBWT2=zeros(size(I_Label));  
                for i=1:1:size(IsType2,2)
                    IBWT2(I_Label==IsType2(i))=1;
                end
                IBWT2_C=imclose(IBWT2,se);
%                 IBWT2 = bwmorph(IBWT2_C,'thin',2);
                [BWT2_Bound,BWT2_Label] = bwboundaries(IBWT2_C,8,'noholes');
                LrgbT2(:,:,1)=IBWT2_C*1;
                LrgbT2(:,:,2)=IBWT2_C*0;
                LrgbT2(:,:,3)=IBWT2_C*0;
                
                nG = max(max(BWT2_Label)); %find number of fiber type groups
                NoObj = [];
                for i=1:1:nG
                    %Find number of fibers within each group
                    Vec=unique(obj.LabelMat(BWT2_Label==i));
                    Vec(Vec==0)=[];
                    NoObj(i)=length(Vec);
                end
                
                %Store Data in GroupStats
                obj.GroupStats.BoundT2 = BWT2_Bound;
                obj.GroupStats.LabelT2 = BWT2_Label;
                obj.GroupStats.NoObjT2 = NoObj;
                
                
            else
                LrgbT2(:,:,1)=zeros(size(I_Label));
                LrgbT2(:,:,2)=zeros(size(I_Label));
                LrgbT2(:,:,3)=zeros(size(I_Label)); 
                
                obj.GroupStats.BoundT2 = [];
                obj.GroupStats.LabelT2 = [];
                obj.GroupStats.NoObjT2 = [];
                
            end
            
            %%%%%%%%%%%%%%%%%%%%% Type-2x %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if ~isempty(IsType2x)
                obj.InfoMessage = '         - find Type-2x groups';
                IBWT2x=zeros(size(I_Label));  
                for i=1:1:size(IsType2x,2)
                    IBWT2x(I_Label==IsType2x(i))=1;
                end
                IBWT2x_C=imclose(IBWT2x,se);
%                 IBWT2x = bwmorph(IBWT2x_C,'thin',2);
                [BWT2x_Bound,BWT2x_Label] = bwboundaries(IBWT2x_C,8,'noholes');
                LrgbT2x(:,:,1)=IBWT2x_C*1;
                LrgbT2x(:,:,2)=IBWT2x_C*0;
                LrgbT2x(:,:,3)=IBWT2x_C*0;
                
                nG = max(max(BWT2x_Label)); %find number of fiber type groups
                NoObj = [];
                for i=1:1:nG
                    %Find number of fibers within each group
                    Vec=unique(obj.LabelMat(BWT2x_Label==i));
                    Vec(Vec==0)=[];
                    NoObj(i)=length(Vec);
                end
                
                %Store Data in GroupStats
                obj.GroupStats.BoundT2x = BWT2x_Bound;
                obj.GroupStats.LabelT2x = BWT2x_Label;
                obj.GroupStats.NoObjT2x = NoObj;
                
                
            else
                LrgbT2x(:,:,1)=zeros(size(I_Label));
                LrgbT2x(:,:,2)=zeros(size(I_Label));
                LrgbT2x(:,:,3)=zeros(size(I_Label)); 
                
                obj.GroupStats.BoundT2x = [];
                obj.GroupStats.LabelT2x = [];
                obj.GroupStats.NoObjT2x = [];
                
            end
            %%%%%%%%%%%%%%%%%%%%% Type-2a %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if ~isempty(IsType2a)
                obj.InfoMessage = '         - find Type-2a groups';
                IBWT2a=zeros(size(I_Label));  
                for i=1:1:size(IsType2a,2)
                    IBWT2a(I_Label==IsType2a(i))=1;
                end
                IBWT2a_C=imclose(IBWT2a,se);
%                 IBWT2a = bwmorph(IBWT2a_C,'thin',2);
                [BWT2a_Bound,BWT2a_Label] = bwboundaries(IBWT2a_C,8,'noholes');
                LrgbT2a(:,:,1)=IBWT2a_C*1;
                LrgbT2a(:,:,2)=IBWT2a_C*1;
                LrgbT2a(:,:,3)=IBWT2a_C*0;
                
                nG = max(max(BWT2a_Label)); %find number of fiber type groups
                NoObj = [];
                for i=1:1:nG
                    %Find number of fibers within each group
                    Vec=unique(obj.LabelMat(BWT2a_Label==i));
                    Vec(Vec==0)=[];
                    NoObj(i)=length(Vec);
                end
                
                %Store Data in GroupStats
                obj.GroupStats.BoundT2a = BWT2a_Bound;
                obj.GroupStats.LabelT2a = BWT2a_Label;
                obj.GroupStats.NoObjT2a = NoObj;
                
            else
                LrgbT2a(:,:,1)=zeros(size(I_Label));
                LrgbT2a(:,:,2)=zeros(size(I_Label));
                LrgbT2a(:,:,3)=zeros(size(I_Label)); 
                
                obj.GroupStats.BoundT2a = [];
                obj.GroupStats.LabelT2a = [];
                obj.GroupStats.NoObjT2a = [];
            end
            %%%%%%%%%%%%%%%%%%%%% Type-2ax %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            if ~isempty(IsType2ax)
                obj.InfoMessage = '         - find Type-2ax groups';
                IBWT2ax=zeros(size(I_Label));  
                for i=1:1:size(IsType2ax,2)
                    IBWT2ax(I_Label==IsType2ax(i))=1;
                end
                IBWT2ax_C=imclose(IBWT2ax,se);
%                 IBWT2ax = bwmorph(IBWT2ax_C,'thin',2);
                [BWT2ax_Bound,BWT2ax_Label] = bwboundaries(IBWT2ax_C,8,'noholes');
                LrgbT2ax(:,:,1)=IBWT2ax_C*1;
                LrgbT2ax(:,:,2)=IBWT2ax_C*100/255;
                LrgbT2ax(:,:,3)=IBWT2ax_C*0;
                
                nG = max(max(BWT2ax_Label)); %find number of fiber type groups
                NoObj = [];
                for i=1:1:nG
                    %Find number of fibers within each group
                    Vec=unique(obj.LabelMat(BWT2ax_Label==i));
                    Vec(Vec==0)=[];
                    NoObj(i)=length(Vec);
                end
                
                %Store Data in GroupStats
                obj.GroupStats.BoundT2ax = BWT2ax_Bound;
                obj.GroupStats.LabelT2ax = BWT2ax_Label;
                obj.GroupStats.NoObjT2ax = NoObj;
                 
            else
                LrgbT2ax(:,:,1)=zeros(size(I_Label));
                LrgbT2ax(:,:,2)=zeros(size(I_Label));
                LrgbT2ax(:,:,3)=zeros(size(I_Label)); 
                
                obj.GroupStats.BoundT2ax = [];
                obj.GroupStats.LabelT2ax = [];
                obj.GroupStats.NoObjT2ax = [];
            end
            
            
            if obj.AnalyzeMode == 1 || obj.AnalyzeMode == 3 || obj.AnalyzeMode == 5 || obj.AnalyzeMode == 7
                Lrgb = LrgbT1+LrgbT12h+LrgbT2;
            else 
                Lrgb = LrgbT1+LrgbT12h+LrgbT2x+LrgbT2a+LrgbT2ax;
            end
            
            obj.GroupStats.Lrgb = Lrgb;
            obj.GroupStats.LabelMat = obj.LabelMat;
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
            SaveDir = [obj.PathName fileName '_RESULTS'];
            obj.InfoMessage = ['   -' obj.PathName fileName '_RESULTS'];
            
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
            SaveDir = fullfile(SaveDir,[fileName '_RESULTS' time]);
            mkdir(SaveDir);
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save image processed
            if obj.SavePicProcessed
                obj.InfoMessage = '      - saving image processed...';
                
                try
                    picName ='';
                    % save picture as vector graphics
                    picName = [fileName '_image_processed' time '.pdf'];
                    fullFileName = fullfile(SaveDir,picName);
                    saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hAPProcessed,fullFileName);
                    obj.InfoMessage = '         - image has been saved as .pdf vector grafic';
                catch
                    warning('Problem while saving Image as .pdf. Image could not be saved.');
                    obj.InfoMessage = 'ERROR: Image could not be saved as .pdf vector grafic';
                    
                    % save picture as tif file
                    f = figure('Units','normalized','Visible','off','ToolBar','none','MenuBar', 'none','Color','w');
                    h = copyobj(obj.controllerResultsHandle.viewResultsHandle.hAPProcessed,f);
                    SizeFig = size(obj.PicPRGBFRPlanes)/max(size(obj.PicPRGBFRPlanes));
                    set(f,'Position',[0 0 SizeFig(1) SizeFig(2)])
                    set(h,'Units','normalized');
                    h.Position = [0 0 1 1];
                    h.DataAspectRatioMode = 'auto';
                    
                    picName ='';
                    frame = getframe(f);
                    frame=frame.cdata;
                    picName = [fileName '_image_processed' time '.tif'];
                    oldPath = pwd;
                    cd(SaveDir)
                    imwrite(frame,picName)
                    cd(oldPath)
                    picName ='';
                    close(f);
                    obj.InfoMessage = '         - image has been saved as .tif';
                end
                picName ='';
                
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save image with fiber type groups
            if obj.SavePicGroups
                obj.InfoMessage = '      - saving image with fiber groups...';
                
                try
                    % save picture as vector graphics
                    picName ='';
                    picName = [fileName '_image_groups' time '.pdf'];
                    fullFileName = fullfile(SaveDir,picName);
                    saveTightFigureOrAxes(obj.controllerResultsHandle.viewResultsHandle.hAPGroups,fullFileName);
                    obj.InfoMessage = '         - image has been saved as .pdf vector grafic';
                catch
                    warning('Problem while saving Image as .pdf. Image could not be saved.');
                    obj.InfoMessage = 'ERROR: Image could not be saved as .pdf vector grafic';
                    
                    % save picture as tif file
                    f = figure('Units','normalized','Visible','off','ToolBar','none','MenuBar', 'none','Color','w');
                    h = copyobj(obj.controllerResultsHandle.viewResultsHandle.hAPGroups,f);
                    SizeFig = size(obj.PicPRGBPlanes)/max(size(obj.PicPRGBPlanes));
                    set(f,'Position',[0 0 SizeFig(1) SizeFig(2)])
                    set(h,'Units','normalized');
                    h.Position = [0 0 1 1];
                    h.DataAspectRatioMode = 'auto';
                    
                    picName ='';
                    frame = getframe(f);
                    frame=frame.cdata;
                    picName = [fileName '_image_groups' time '.tif'];
                    oldPath = pwd;
                    cd(SaveDir)
                    imwrite(frame,picName)
                    cd(oldPath)
                    picName ='';
                    close(f);
                    obj.InfoMessage = '         - image has been saved as .tif';
                end
                picName ='';
                
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
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save Histograms
            if obj.SaveHisto
                
                obj.InfoMessage = '      - saving Histograms plots...';
                
                obj.InfoMessage = '         - saving Area histogram as .pdf';
                picName = [fileName '_processed_AreaHisto' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                fTemp = figure('Visible','off');
                copyobj(obj.controllerResultsHandle.viewResultsHandle.hAAreaHist,fTemp);
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '         - saving AspectRatio histogram as .pdf';
                picName = [fileName '_processed_AspectRatioHisto' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                fTemp = figure('Visible','off');
                copyobj(obj.controllerResultsHandle.viewResultsHandle.hAAspectHist,fTemp);
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '         - saving Diameter histogram as .pdf';
                picName = [fileName '_processed_DiameterHisto' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                fTemp = figure('Visible','off');
                copyobj(obj.controllerResultsHandle.viewResultsHandle.hADiaHist,fTemp);
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '         - saving Roundness histogram as .pdf';
                picName = [fileName '_processed_RoundnessHisto' time '.pdf'];
                fullFileName = fullfile(SaveDir,picName);
                fTemp = figure('Visible','off');
                copyobj(obj.controllerResultsHandle.viewResultsHandle.hARoundHist,fTemp);
                saveTightFigureOrAxes(fTemp,fullFileName);
                picName ='';
                delete(fTemp)
                
                obj.InfoMessage = '   - saving Histograms complete';
                
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % save Scatter all
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
                
                %Get infos from the file name
                [pathstr,name,ext] = fileparts(obj.FileName);
                %split string into parts

                strComp = strsplit(name,{' ','-','_'});
                
                %dialog input box parameter
                prompt = {'Date','Animal code','Muscle code','Image number','Microscope magnification','treated/control'};
                dlg_title = 'Completion of the Excel table';
                num_lines = [1,50];
                defaultans = {};
                for i=1:1:size(prompt,2)
                    if i <= size(strComp,2)
                        defaultans{1,i}=strComp{1,i};
                    else
                        defaultans{1,i}='';
                    end
                end
                options.Resize='off';
                options.WindowStyle='normal';
                answer = inputdlg(prompt,dlg_title,num_lines,defaultans,options)';
                
                if isempty(answer)
                    answer = cell(1,size(prompt,2));
                end
                
                InfoAnimal = cell(size(obj.StatsMatData,1),size(prompt,2));
                InfoAnimalT1 = cell(size(obj.StatsMatDataT1,1),size(prompt,2));
                InfoAnimalT12h = cell(size(obj.StatsMatDataT12h,1),size(prompt,2));
                InfoAnimalT2 = cell(size(obj.StatsMatDataT2,1),size(prompt,2));
                InfoAnimalT2x = cell(size(obj.StatsMatDataT2x,1),size(prompt,2));
                InfoAnimalT2a = cell(size(obj.StatsMatDataT2a,1),size(prompt,2));
                InfoAnimalT2ax = cell(size(obj.StatsMatDataT2ax,1),size(prompt,2));

                
                for i=1:1:size(prompt,2)
                    [InfoAnimal{:,i}] = deal(answer{1,i});
                    [InfoAnimalT1{:,i}] = deal(answer{1,i});
                    [InfoAnimalT12h{:,i}] = deal(answer{1,i});
                    [InfoAnimalT2{:,i}] = deal(answer{1,i});
                    [InfoAnimalT2x{:,i}] = deal(answer{1,i});
                    [InfoAnimalT2a{:,i}] = deal(answer{1,i});
                    [InfoAnimalT2ax{:,i}] = deal(answer{1,i});
                end
                
                Header = {'Label' sprintf('XPos (\x3BCm)') sprintf('YPos (\x3BCm)')... 
                    sprintf('Area (\x3BCm^2)') sprintf('min Cross Section Area (\x3BCm^2)'),sprintf('max Cross Section Area (\x3BCm^2)')...
                    sprintf('Perimeter (\x3BCm)') sprintf('minDiameter (\x3BCm)') ...
                    sprintf('maxDiameter (\x3BCm)')  'Roundness' ...
                    'AspectRatio' 'ColorValue' 'meanRed' 'meanGreen' ...
                    'meanBlue' 'meanFarred' 'Blue/Red' 'Farred/Red'...
                    'FiberMainGroup' 'FiberType'};
                
                %add animal informations to header
                Header = cat(2,prompt,Header);
                
                CellFiberTable = cat(1,Header,cat(2,InfoAnimal,obj.StatsMatData));
                CellFiberTableT1 = cat(1,Header,cat(2,InfoAnimalT1,obj.StatsMatDataT1));
                CellFiberTableT12h = cat(1,Header,cat(2,InfoAnimalT12h,obj.StatsMatDataT12h));
                CellFiberTableT2 = cat(1,Header,cat(2,InfoAnimalT2,obj.StatsMatDataT2));
                CellFiberTableT2x = cat(1,Header,cat(2,InfoAnimalT2x,obj.StatsMatDataT2x));
                CellFiberTableT2a = cat(1,Header,cat(2,InfoAnimalT2a,obj.StatsMatDataT2a));
                CellFiberTableT2ax = cat(1,Header,cat(2,InfoAnimalT2ax,obj.StatsMatDataT2ax));
                
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
                    
                    fullFileName = fullfile(SaveDir,xlsfileName);
%                     oldPath = pwd;
%                     cd(SaveDir);
                    
                    obj.InfoMessage = '            - write all fiber types ';
                    sheetName = 'Fyber Types';
                    startRange = 'B2';
                    % undocumented function from the file exchange Matlab Forum
                    % for creating .xlsx files on a macintosh OS
                    status = xlwrite(fullFileName, CellFiberTable , sheetName, startRange);
                    
                    sheetName = 'Statistics';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write statistic table ';
                    status = xlwrite(fullFileName, obj.StatisticMat , sheetName, startRange);
                    
                    
                    sheetName = 'Type 1';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 1 fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT1 , sheetName, startRange);
                    
                    sheetName = 'Type 12h';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 12h fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT12h , sheetName, startRange);
                    
                    sheetName = 'Type 2';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2 fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT2 , sheetName, startRange);
                    
                    sheetName = 'Type 2x';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2x fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT2x , sheetName, startRange);
                    
                    sheetName = 'Type 2a';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2a fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT2a , sheetName, startRange);
                    
                    sheetName = 'Type 2ax';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2ax fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT2ax , sheetName, startRange);
                    
%                     cd(oldPath);
                    
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

%                     oldPath = pwd;
%                     cd(SaveDir);
                    fullFileName = fullfile(SaveDir,xlsfileName);
                    
                    obj.InfoMessage = '            - write all fiber types ';
                    sheetName = 'Fyber Types';
                    startRange = 'B2';
                    % undocumented function from the file exchange Matlab Forum
                    % for creating .xlsx files on a macintosh OS
                    status = xlwrite(fullFileName, CellFiberTable , sheetName, startRange);
                    
                    sheetName = 'Statistics';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write statistic table ';
                    status = xlwrite(fullFileName, obj.StatisticMat , sheetName, startRange);
                    
                    
                    sheetName = 'Type 1';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 1 fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT1 , sheetName, startRange);
                    
                    sheetName = 'Type 12h';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 12h fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT12h , sheetName, startRange);
                    
                    sheetName = 'Type 2';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2 fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT2 , sheetName, startRange);
                    
                    sheetName = 'Type 2x';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2x fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT2x , sheetName, startRange);
                    
                    sheetName = 'Type 2a';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2a fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT2a , sheetName, startRange);
                    
                    sheetName = 'Type 2ax';
                    startRange = 'B2';
                    obj.InfoMessage = '            - write Type 2ax fibers ';
                    status = xlwrite(fullFileName, CellFiberTableT2ax , sheetName, startRange);
                    
%                     cd(oldPath);
                    
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

