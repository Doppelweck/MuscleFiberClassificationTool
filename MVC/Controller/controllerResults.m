classdef controllerResults < handle
    %controllerResults   Controller of the Results-MVC (Model-View-Controller).
    %Controls the communication and data exchange between the view
    %instance and the model instance. Connected to the Analyze
    %Controllers to communicate with the Analyze-MVC and to
    %exchange data between them.
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
        
        mainFigure; %handle to main figure.
        mainCardPanel; %handle to card panel in the main figure.
        mainCardPanelResults; %handle to card panel selection 3 in the main figure.
        viewResultsHandle; %hande to viewResults instance.
        modelResultsHandle; %hande to modelResults instance.
        controllerAnalyzeHandle; %handle to controllerAnalyze instance.
        
    end
    
    methods
        
        function obj = controllerResults(mainFigure,mainCardPanel,viewResultsH,modelResultsH)
            % Constuctor of the controllerResults class. Initialize the
            % callback and listener functions to observes the corresponding
            % View objects. Saves the needed handles of the corresponding
            % View and Model in the properties.
            %
            %   obj = controllerResults(mainFigure,mainCardPanel,viewResultsH,modelResultsH)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           mainFigure:     Handle to main figure.
            %           mainCardPanel:  Handle to main card panel.
            %           viewAnalyzeH:   Hande to viewResults instance.
            %           modelAnalyzeH:  Hande to modelResults instance.
            %
            %       - Output:
            %           obj:            Handle to controllerResults object.
            %
            
            obj.mainFigure =mainFigure;
            obj.mainCardPanel =mainCardPanel;
            
            obj.viewResultsHandle = viewResultsH;
            
            obj.modelResultsHandle = modelResultsH;
            
            obj.mainCardPanelResults = obj.viewResultsHandle.panelResults;
            
            obj.addMyCallback();
            
            obj.addMyListener();
        end
        
        function addMyCallback(obj)
            % Set callback functions to several button objects in the
            % viewResults instance.
            %
            %   addMyCallbacks(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Callback',@obj.backAnalyzeModeEvent);
            set(obj.viewResultsHandle.B_Save,'Callback',@obj.saveResultsEvent);
            set(obj.viewResultsHandle.B_NewPic,'Callback',@obj.newPictureEvent);
            set(obj.viewResultsHandle.B_CloseProgramm,'Callback',@obj.closeProgramEvent);
            set(obj.viewResultsHandle.B_SaveOpenDir,'Callback',@obj.openSaveDirectory);
        end
        
        function addWindowCallbacks(obj)
            % Set callback functions of the main figure
            %
            %   addWindowCallbacks(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            
            set(obj.mainFigure,'WindowButtonMotionFcn','');
            set(obj.mainFigure,'WindowButtonDownFcn','');
            set(obj.mainFigure,'ButtonDownFcn','');
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);
            set(obj.mainFigure,'ResizeFcn','');
            
        end
        
        function addMyListener(obj)
            % add listeners to the several button objects in the
            % viewResults instance and value objects or handles in the
            % modelResults.
            %
            %   addMyListener(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            
            addlistener(obj.modelResultsHandle,'InfoMessage', 'PostSet',@obj.updateInfoLogEvent);
            
        end
        
        function startResultsMode(obj,Data,InfoText)
            % Called by the controllerAnalyze instance when the user change
            % the program state to Results-mode. Saves all nessessary Data
            % from the Analyze model into the Result model.
            %
            %   startResultsMode(obj,Data,InfoText);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to controllerResults object.
            %           Data:    Cell Array that contains the file- and
            %               pathnames of the RGB. Also contains all analyze
            %               parameters:
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
            %               Data{23}: FarredRedDistRed
            %               Data{24}: ColorValueActive
            %               Data{25}: ColorValue
            %               Data{26}: XScale in ?m/pixel
            %               Data{27}: YScale in ?m/pixel
            %               Data{28}: min Points per Cluster
            %               Data{29}: 1/2 Hybrid Fibers allowed
            %               Data{30}: 2ax Hybrid Fibers allowed
            %               Data{31}: Binary Mask image
            %           InfoText:   Info text log.
            %
            
            try
            % Set PicData Properties in the Results Model
            obj.modelResultsHandle.FileName = Data{1};
            obj.modelResultsHandle.PathName = Data{2};
            obj.modelResultsHandle.PicPRGBFRPlanes = Data{3};
            obj.modelResultsHandle.PicPRGBPlanes = Data{4};
            obj.modelResultsHandle.Stats = Data{5};
            obj.modelResultsHandle.LabelMat = Data{6};
            
            % Set Analyze parameters in the Results Model
            obj.modelResultsHandle.AnalyzeMode = Data{7};
            
            obj.modelResultsHandle.AreaActive = Data{8};
            obj.modelResultsHandle.MinAreaPixel = Data{9};
            obj.modelResultsHandle.MaxAreaPixel = Data{10};
            
            obj.modelResultsHandle.AspectRatioActive = Data{11};
            obj.modelResultsHandle.MinAspectRatio = Data{12};
            obj.modelResultsHandle.MaxAspectRatio = Data{13};
            
            obj.modelResultsHandle.RoundnessActive = Data{14};
            obj.modelResultsHandle.MinRoundness = Data{15};

            obj.modelResultsHandle.BlueRedThreshActive = Data{16};
            obj.modelResultsHandle.BlueRedThresh = Data{17};
            obj.modelResultsHandle.BlueRedDistBlue = Data{18};
            obj.modelResultsHandle.BlueRedDistRed = Data{19};
            
            obj.modelResultsHandle.FarredRedThreshActive = Data{20};
            obj.modelResultsHandle.FarredRedThresh = Data{21};
            obj.modelResultsHandle.FarredRedDistFarred = Data{22};
            obj.modelResultsHandle.FarredRedDistRed = Data{23};
            
            obj.modelResultsHandle.ColorValueActive = Data{24};
            obj.modelResultsHandle.ColorValue = Data{25};
            
            obj.modelResultsHandle.XScale = Data{26};
            obj.modelResultsHandle.YScale = Data{27};
            
            obj.modelResultsHandle.minPointsPerCluster = Data{28};
            
            obj.modelResultsHandle.Hybrid12FiberActive = Data{29};
            obj.modelResultsHandle.Hybrid2axFiberActive = Data{30};
            
            obj.modelResultsHandle.PicBW = Data{31};
            
            set(obj.viewResultsHandle.B_InfoText, 'String', InfoText);
            set(obj.viewResultsHandle.B_InfoText, 'Value' , length(obj.viewResultsHandle.B_InfoText.String));
            
            % set panel title to filename and path
            Titel = [obj.modelResultsHandle.PathName obj.modelResultsHandle.FileName];
            obj.viewResultsHandle.panelResults.Title = Titel;
            
            appDesignChanger(obj.mainCardPanel,getSettingsValue('Style'));
            %change the card panel to selection 3: results mode
            obj.mainCardPanel.Selection = 3;
            
            obj.busyIndicator(1);
            
            %change the figure callbacks for the results mode
            obj.addWindowCallbacks()
            
            obj.modelResultsHandle.InfoMessage = '*** Start Result mode ***';
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','off');
            set(obj.viewResultsHandle.B_Save,'Enable','off');
            set(obj.viewResultsHandle.B_NewPic,'Enable','off');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','off');
            set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','off');
            appDesignElementChanger(obj.mainCardPanel);
            %show results data in the GUI
            appDesignChanger(obj.mainCardPanel,getSettingsValue('Style'));
            obj.modelResultsHandle.startResultMode();
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','on');
            set(obj.viewResultsHandle.B_Save,'Enable','on');
            set(obj.viewResultsHandle.B_NewPic,'Enable','on');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','on');
            appDesignElementChanger(obj.mainCardPanel);
            appDesignChanger(obj.mainCardPanel,getSettingsValue('Style'));
            obj.busyIndicator(0);
            
            
            %Check if a resultsfolder for the file already exist
            % Dlete file extension in the results folder before save
            [pathstr,name,ext] = fileparts([obj.modelResultsHandle.PathName obj.modelResultsHandle.FileName]);
            
            % Save dir is the same as the dir from the selected Pic
            SaveDir = [obj.modelResultsHandle.PathName name '_RESULTS'];
            
            % Check if reslut folder already exist.
            if exist( SaveDir ,'dir') == 7
                % Reslut folder already exist.
                %User can open that directory
                obj.modelResultsHandle.SavePath = SaveDir;
                set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','on');
            else
                % create new folder to save results
                set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','off');

            end
            
            catch
                obj.errorMessage(lasterror);
            end
            appDesignElementChanger(obj.mainCardPanel);
        end
        
        function backAnalyzeModeEvent(obj,~,~)
            % Callback function of the back analyze mode button in the GUI.
            % Clears the data in the results model and change the state of
            % the program to the analyze mode. Refresh the figure callbacks
            % for the analyze mode.
            %
            %   backAnalyzeModeEvent(obj,~,~);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            
            obj.modelResultsHandle.InfoMessage = ' ';
            
            % set log text from Result GUI to Analyze GUI
            obj.controllerAnalyzeHandle.setInfoTextView(get(obj.viewResultsHandle.B_InfoText, 'String'));
            
            %change the card panel to selection 2: analyze mode
            obj.mainCardPanel.Selection = 2;
            
            %change the figure callbacks for the analyze mode
            obj.controllerAnalyzeHandle.addWindowCallbacks();
            
            obj.controllerAnalyzeHandle.modelAnalyzeHandle.InfoMessage = '*** Back to Analyze mode ***';
        end
        
        function saveResultsEvent(obj,~,~)
            % Callback function of the save data button in the GUI.
            % Check wich data should be saved and calls the saveResults()
            % function in the model.
            %
            %   saveResultsEvent(obj,~,~);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            try
            obj.modelResultsHandle.SaveFiberTable = obj.viewResultsHandle.B_SaveFiberTable.Value;
            obj.modelResultsHandle.SaveScatterAll = obj.viewResultsHandle.B_SaveScatterAll.Value;
            obj.modelResultsHandle.SavePlots = obj.viewResultsHandle.B_SavePlots.Value;
            obj.modelResultsHandle.SaveHisto = obj.viewResultsHandle.B_SaveHisto.Value;
            obj.modelResultsHandle.SavePicProcessed = obj.viewResultsHandle.B_SavePicProc.Value;
            obj.modelResultsHandle.SavePicGroups = obj.viewResultsHandle.B_SavePicGroups.Value;
            obj.modelResultsHandle.SaveBinaryMask = obj.viewResultsHandle.B_SaveBinaryMask.Value;
            
            obj.busyIndicator(1);
            if ( obj.modelResultsHandle.SaveFiberTable || ...
                 obj.modelResultsHandle.SaveScatterAll || ...
                 obj.modelResultsHandle.SavePlots || ...
                 obj.modelResultsHandle.SavePicProcessed || ...
                 obj.modelResultsHandle.SaveBinaryMask || ...
                 obj.modelResultsHandle.SavePicGroups)
                    
                
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','off');
            set(obj.viewResultsHandle.B_Save,'Enable','off');
            set(obj.viewResultsHandle.B_NewPic,'Enable','off');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','off');
            set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','off');
            appDesignElementChanger(obj.mainCardPanel);
            %Save results
            obj.modelResultsHandle.saveResults();
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','on');
            set(obj.viewResultsHandle.B_Save,'Enable','on');
            set(obj.viewResultsHandle.B_NewPic,'Enable','on');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','on');
            set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','on');
            else
                obj.modelResultsHandle.InfoMessage = '- no data is selected for saving';
                obj.modelResultsHandle.InfoMessage = '- no data has been saved';
            end
            obj.busyIndicator(0);
            appDesignElementChanger(obj.mainCardPanel);
            [y,Fs] = audioread('filling-your-inbox.mp3');
            sound(y*0.4,Fs);
            catch
                obj.errorMessage(lasterror);
            end
            appDesignElementChanger(obj.mainCardPanel);
        end
        
        function showInfoInTableGUI(obj)
            % Shows the fibertype data and the statistc data in the
            % corresponding table in the GUI.
            %
            %   showInfoInTableGUI(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            try
                
            obj.viewResultsHandle.B_TableMain.RowName = [];
            obj.viewResultsHandle.B_TableMain.ColumnName = {'No.',  sprintf('XPos |(\x3BCm)'), sprintf('YPos |(\x3BCm)'),...
                sprintf('Area |(\x3BCm^2)'), sprintf('min Area Cross|Section (\x3BCm^2)'), sprintf('max Area Cross|Section (\x3BCm^2)')...
                sprintf('Perimeter |(\x3BCm)'), sprintf('Diameter|min (\x3BCm)'), sprintf('Diameter|max (\x3BCm)'), 'Roundness' ...
                sprintf('Aspect|Ratio'), sprintf('Color|Value'), sprintf('mean|Red'), sprintf('mean|Green'), ...
                sprintf('mean|Blue'), sprintf('mean|Farred'), 'Blue/Red', 'Farred/Red',...
                'Main|Group', 'Fiber|Type'};

            obj.viewResultsHandle.B_TableMain.Data = obj.modelResultsHandle.StatsMatData;
            pos = round((obj.viewResultsHandle.B_TableMain.Position(3)-20-35-40-40)/17);
            obj.viewResultsHandle.B_TableMain.ColumnWidth={45 45 45 60 100 100 'auto'};
            
            obj.viewResultsHandle.B_TableStatistic.RowName = [];
%             obj.viewResultsHandle.B_TableStatistic.ColumnWidth={180 'auto'};
            obj.viewResultsHandle.B_TableStatistic.ColumnName = {'Name of parameter','Value of parameter'};
            obj.viewResultsHandle.B_TableStatistic.Data = obj.modelResultsHandle.StatisticMat;
            pos = obj.viewResultsHandle.B_TableStatistic.Position(3);
            obj.viewResultsHandle.B_TableStatistic.ColumnWidth={pos/2 pos/2-20};
            catch
                obj.errorMessage(lasterror);
            end
        end
        
        function showAxesFiberCountGUI(obj)
            obj.modelResultsHandle.InfoMessage = '   - plot data into GUI axes...';
            
            AnalyzeMode = obj.modelResultsHandle.AnalyzeMode;
            
            % Define costom color map
            ColorMapMain(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapMain(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapMain(3,:) = [255 51 51]; % Red Fiber Type 2
            ColorMapMain(4,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapMain(5,:) = [51 255 51]; % Green Collagen
            ColorMapMain = ColorMapMain/255;
            
            ColorMapAll(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapAll(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapAll(3,:) = [255 51 51]; % Red Fiber Type 2x
            ColorMapAll(4,:) = [255 255 51]; % Yellow Fiber Type 2a
            ColorMapAll(5,:) = [255 153 51]; % orange Fiber Type 2ax
            ColorMapAll(6,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapAll(7,:) = [51 255 51]; % Green Collagen
            ColorMapAll = ColorMapAll/255;
            
            % Define costom fonts
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 12*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Plot Count Numbers in Axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.modelResultsHandle.InfoMessage = '      - plot number of types...';
            
            % make Axes for Count Data the current Axes
%             axes(obj.viewResultsHandle.hACount);
            % clear old Data in current Axes
            cla(obj.viewResultsHandle.hACount);
            drawnow;
            hText=[];   
            if AnalyzeMode == 1 || AnalyzeMode == 3 || AnalyzeMode == 5 || AnalyzeMode == 7 %tripple labeling
                B = [obj.modelResultsHandle.NoTyp1 obj.modelResultsHandle.NoTyp12h ...
                    obj.modelResultsHandle.NoTyp2 obj.modelResultsHandle.NoTyp0];
                
                x = 1:length(B);
                for b = 1 : length(B)
                    hold(obj.viewResultsHandle.hACount, 'on');
                    % Plot one single bar as a separate bar series.
                    handleToThisBarSeries = bar(obj.viewResultsHandle.hACount,x(b), B(b), 'BarWidth', 0.9);
                    % Apply the color to this bar series.
                    set(handleToThisBarSeries,'FaceColor', ColorMapMain(b,:));
                    % Place text atop the bar
                    barTopper = sprintf('%d',B(b));
                    text(obj.viewResultsHandle.hACount,x(b), B(b), barTopper,'HorizontalAlignment','center',...
                        'VerticalAlignment','bottom', 'FontSize', 15,'Tag','areaPlotTextRsults');
                end
                
                l1 = legend(obj.viewResultsHandle.hACount,'Type 1','Type 12h','Type 2','undefind',...
                    'Location','Best');
                set(obj.viewResultsHandle.hACount,'XTickLabel',{'Type 1','Type 12h','Type 2','undefind'},'FontUnits','normalized','Fontsize',0.03);
                set(obj.viewResultsHandle.hACount,'XTick',[1 2 3 4]);
                
            else %quad labeling
                B = [obj.modelResultsHandle.NoTyp1 obj.modelResultsHandle.NoTyp12h ...
                    obj.modelResultsHandle.NoTyp2x obj.modelResultsHandle.NoTyp2a ...
                    obj.modelResultsHandle.NoTyp2ax obj.modelResultsHandle.NoTyp0];
                
                x = 1:length(B);
                for b = 1 : length(B)
                    hold(obj.viewResultsHandle.hACount, 'on');
                    % Plot one single bar as a separate bar series.
                    handleToThisBarSeries = bar(obj.viewResultsHandle.hACount,x(b), B(b), 'BarWidth', 0.9);
                    % Apply the color to this bar series.
                    set(handleToThisBarSeries,'FaceColor', ColorMapAll(b,:));
                    % Place text atop the bar
                    barTopper = sprintf('%d',B(b));
                    text(obj.viewResultsHandle.hACount,x(b), B(b), barTopper,'HorizontalAlignment','center',...
                        'VerticalAlignment','bottom', 'FontSize', 15,'Tag','areaPlotTextRsults');
                end
                
                l1 = legend(obj.viewResultsHandle.hACount,'Type 1','Type 12h','Type 2x','Type 2a','Type 2ax','undefind',...
                    'Location','Best');
                set(obj.viewResultsHandle.hACount,'XTickLabel',{'Type 1','Type 12h','Type 2x','Type 2a','Type 2ax','undefind'},'FontUnits','normalized','Fontsize',0.03);
                set(obj.viewResultsHandle.hACount,'XTick',[1 2 3 4 5 6]);
                
            end
            
            ylim(obj.viewResultsHandle.hACount,[0 ceil((max(B)+round(max(B)/10))/10)*10]);
            l1.FontSize=fontSizeM;
            
            set(l1,'Tag','LegendNumberPlot');
            set(obj.viewResultsHandle.hACount,'FontUnits','normalized','Fontsize',0.03);

            ylabel(obj.viewResultsHandle.hACount,'Numbers','FontUnits','normalized','Fontsize',0.045);
            title(obj.viewResultsHandle.hACount,['Number of fiber types (Total: ' num2str(sum(B)) ')'],'FontUnits','normalized','Fontsize',0.06)
            
            grid(obj.viewResultsHandle.hACount, 'on');
            hold(obj.viewResultsHandle.hACount, 'off');
        end
        
        function showAxesFiberAreaGUI(obj)
            AnalyzeMode = obj.modelResultsHandle.AnalyzeMode;
            
            % Define costom color map
            ColorMapMain(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapMain(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapMain(3,:) = [255 51 51]; % Red Fiber Type 2
            ColorMapMain(4,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapMain(5,:) = [51 255 51]; % Green Collagen
            ColorMapMain = ColorMapMain/255;
            
            ColorMapAll(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapAll(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapAll(3,:) = [255 51 51]; % Red Fiber Type 2x
            ColorMapAll(4,:) = [255 255 51]; % Yellow Fiber Type 2a
            ColorMapAll(5,:) = [255 153 51]; % orange Fiber Type 2ax
            ColorMapAll(6,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapAll(7,:) = [51 255 51]; % Green Collagen
            ColorMapAll = ColorMapAll/255;
            
            % Define costom fonts
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 12*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            end
            obj.modelResultsHandle.InfoMessage = '      - plot area...';

            cla(obj.viewResultsHandle.hAArea);
            
            B_main = [obj.modelResultsHandle.AreaType1PC obj.modelResultsHandle.AreaType12hPC ...
                obj.modelResultsHandle.AreaType2PC obj.modelResultsHandle.AreaType0PC ...
                obj.modelResultsHandle.AreaNoneObjPC];
            
            B = [obj.modelResultsHandle.AreaType1PC obj.modelResultsHandle.AreaType12hPC ...
                obj.modelResultsHandle.AreaType2xPC obj.modelResultsHandle.AreaType2aPC ...
                obj.modelResultsHandle.AreaType2axPC obj.modelResultsHandle.AreaType0PC ...
                obj.modelResultsHandle.AreaNoneObjPC];
            
            if AnalyzeMode == 1 || AnalyzeMode == 3 || AnalyzeMode == 5 || AnalyzeMode == 7 %tripple labeling
                
                tempColorMap = ColorMapMain;
                tempColorMap(B_main == 0,:)=[];
                bMain = B_main;
                bMain(B_main == 0)=[];
                
                StringLegend = {'Type 1','Type 12h','Type 2','undefind','Collagen'};
                tempString = StringLegend;
                tempString(B_main == 0)=[];

                if ~isempty(StringLegend)
                    hPie = pie(obj.viewResultsHandle.hAArea,bMain);
                    obj.viewResultsHandle.hAArea.Colormap = tempColorMap;
                    l2 = legend(obj.viewResultsHandle.hAArea,tempString,'Location','Best');
                    set(l2,'Tag','LegendAreaPlot');
                    l2.FontSize=fontSizeM;
                    title(obj.viewResultsHandle.hAArea,'Area of fiber types','FontUnits','normalized','Fontsize',0.06)
                end
                
            else %Quad labeling was active during calssification 
                
                tempColorMap = ColorMapAll;
                tempColorMap(B == 0,:)=[];
                bMain = B;
                bMain(B == 0)=[];
                
                StringLegend = {'Type 1','Type 12h','Type 2x','Type 2a','Type 2ax','undefind','Collagen'};
                tempString = StringLegend;
                tempString(B == 0)=[];

                if ~isempty(StringLegend)
                    hPie = pie(obj.viewResultsHandle.hAArea,bMain);
                    obj.viewResultsHandle.hAArea.Colormap = tempColorMap;
                    l2 = legend(obj.viewResultsHandle.hAArea,tempString,'Location','Best');
                    set(l2,'Tag','LegendAreaPlot');
                    l2.FontSize=fontSizeM;
                    title(obj.viewResultsHandle.hAArea,'Area of fiber types','FontUnits','normalized','Fontsize',0.06)
                end
            end       
        end
        
        function showAxesScatterBlueRedGUI(obj)
            AnalyzeMode = obj.modelResultsHandle.AnalyzeMode;
            
            % Define costom color map
            ColorMapMain(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapMain(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapMain(3,:) = [255 51 51]; % Red Fiber Type 2
            ColorMapMain(4,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapMain(5,:) = [51 255 51]; % Green Collagen
            ColorMapMain = ColorMapMain/255;
            
            ColorMapAll(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapAll(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapAll(3,:) = [255 51 51]; % Red Fiber Type 2x
            ColorMapAll(4,:) = [255 255 51]; % Yellow Fiber Type 2a
            ColorMapAll(5,:) = [255 153 51]; % orange Fiber Type 2ax
            ColorMapAll(6,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapAll(7,:) = [51 255 51]; % Green Collagen
            ColorMapAll = ColorMapAll/255;
            
            % Define costom fonts
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 12*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            end
             obj.modelResultsHandle.InfoMessage = '      - plot scatter...';
            
            %clear axes
            cla(obj.viewResultsHandle.hAScatterBlueRed)
%             axes(obj.viewResultsHandle.hAScatterBlueRed);
            set(obj.viewResultsHandle.hAScatterBlueRed,'FontUnits','normalized','Fontsize',0.03);
            LegendString={};
            PosColorRed =13;
            PosColorBlue =15;
            PosColorFarRed =16;
            PosColorGreen =14;
            % Type 1 Fibers (blue)
            if ~isempty(obj.modelResultsHandle.StatsMatDataT1)
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,PosColorRed)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,PosColorBlue)); %meanBlue Values
                hScat(1) = scatter(obj.viewResultsHandle.hAScatterBlueRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(1,:)); 
                LegendString{end+1} = 'Type 1';
            end
            
            
            hold(obj.viewResultsHandle.hAScatterBlueRed, 'on');
            
            % Type 12h Fibers (magenta)
            if ~isempty(obj.modelResultsHandle.StatsMatDataT12h)
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,PosColorRed)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,PosColorBlue)); %meanBlue Values
                hScat(2) = scatter(obj.viewResultsHandle.hAScatterBlueRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(2,:));
                LegendString{end+1} = 'Type 12h';
            end
            
            if AnalyzeMode == 1 || AnalyzeMode == 3 || AnalyzeMode == 5 || AnalyzeMode == 7 %tripple labeling
                % Type 2 Fibers
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2(:,PosColorBlue)); %meanBlue Values
                    hScat(3) = scatter(obj.viewResultsHandle.hAScatterBlueRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(3,:));
                    LegendString{end+1} = 'Type 2';
                end
                
            else %quad labeling
                % Type 2x Fibers
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2x)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorBlue)); %meanBlue Values
                    hScat(3) = scatter(obj.viewResultsHandle.hAScatterBlueRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(3,:));
                    LegendString{end+1} = 'Type 2x';
                end
                
                % Type 2a Fibers
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2a)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorBlue)); %meanBlue Values
                    hScat(3) = scatter(obj.viewResultsHandle.hAScatterBlueRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(4,:));
                    LegendString{end+1} = 'Type 2a';
                end
                
                % Type 2ax Fibers
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2ax)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorBlue)); %meanBlue Values
                    hScat(3) = scatter(obj.viewResultsHandle.hAScatterBlueRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(5,:));
                    LegendString{end+1} = 'Type 2ax';
                end
            end
            
            if obj.modelResultsHandle.AnalyzeMode == 1 || obj.modelResultsHandle.AnalyzeMode == 2
                % Color-Based Classification
                
                %find max Red value of all Type 2 fibers
                Rmax1 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorRed)));
                Rmax2 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorRed)));
                Rmax3 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorRed)));
                Rmax = max([Rmax1,Rmax2,Rmax3]);
                
                if isempty(Rmax)
                    % if Rmax is empty (no Red Fibers detected) Rmax is the
                    % largest Red Value of all fibers
                    Rmax = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,PosColorRed)));
                end
                
                R = [0 2*Rmax]; %Red value vector
                
                if obj.modelResultsHandle.BlueRedThreshActive
                    
                    % BlueRedThreshActive Parameter is active, plot
                    % classification functions
                    
                    BlueRedTh = obj.modelResultsHandle.BlueRedThresh;
                    BlueRedDistB = obj.modelResultsHandle.BlueRedDistBlue;
                    BlueRedDistR = obj.modelResultsHandle.BlueRedDistRed;
                    
                    % creat classification function line obj
                    f_BRthresh =  BlueRedTh * R; %Blue/Red thresh fcn
                    f_Bdist = BlueRedTh * R / (1-BlueRedDistB); %blue dist fcn
                    f_Rdist = BlueRedTh * R * (1-BlueRedDistR); %red dist fcn
                    
                    plot(obj.viewResultsHandle.hAScatterBlueRed,R,f_Bdist,'b');
                    LegendString{end+1} = ['f_{Bdist}(R) = ' num2str(BlueRedTh) ' * R / (1-' num2str(BlueRedDistB) ')'];

                    plot(obj.viewResultsHandle.hAScatterBlueRed,R,f_Rdist,'r');
                    LegendString{end+1}= ['f_{Rdist}(R) = ' num2str(BlueRedTh) ' * R * (1-' num2str(BlueRedDistR) ')'];
                    
                    plot(obj.viewResultsHandle.hAScatterBlueRed,R,f_BRthresh,'k');
                    LegendString{end+1}= ['f_{BRthresh}(R) = ' num2str(BlueRedTh) ' * R'];
                    
                else
                    BlueRedTh = 1;
                    BlueRedDistB = 0;
                    BlueRedDistR = 0;
                    f_BRthresh =  BlueRedTh * R; %Blue/Red thresh fcn
                    plot(obj.viewResultsHandle.hAScatterBlueRed,R,f_BRthresh,'k');
                    LegendString{end+1} = ['BRthresh(R) = R (not active)'];
                    
                    
                end
                
                if obj.modelResultsHandle.AnalyzeMode == 1
                    title(obj.viewResultsHandle.hAScatterBlueRed,{'Color-Based Triple Labeling (Main Groups)'},'FontUnits','normalized','Fontsize',0.06);
                elseif obj.modelResultsHandle.AnalyzeMode == 2
                    title(obj.viewResultsHandle.hAScatterBlueRed,{'Color-Based Quad Labeling (Main Groups)'},'FontUnits','normalized','Fontsize',0.06);
                end
                
            elseif obj.modelResultsHandle.AnalyzeMode == 3
                title(obj.viewResultsHandle.hAScatterBlueRed,'Cluster-Based Triple Labeling (Main Groups)','FontUnits','normalized','Fontsize',0.06);
            elseif obj.modelResultsHandle.AnalyzeMode == 4
                title(obj.viewResultsHandle.hAScatterBlueRed,'Cluster-Based Quad Labeling (Main Groups)','FontUnits','normalized','Fontsize',0.06);
            elseif obj.modelResultsHandle.AnalyzeMode == 5 || obj.modelResultsHandle.AnalyzeMode == 6
                title(obj.viewResultsHandle.hAScatterBlueRed,'Manual Classification (Main Groups)','FontUnits','normalized','Fontsize',0.06);
            elseif obj.modelResultsHandle.AnalyzeMode == 7   
                title(obj.viewResultsHandle.hAScatterBlueRed,'No Classification (Main Groups)','FontUnits','normalized','Fontsize',0.06);
            end
            
            if ~isempty(LegendString)
                l3 = legend(obj.viewResultsHandle.hAScatterBlueRed,LegendString,'Location','Best');
                set(l3,'Tag','LegendScatterPlotBlueRed');
                l3.FontSize=fontSizeM;
            end
            
            maxBlueValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,PosColorBlue)));
            maxRedValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,PosColorRed)));
            maxLim =  max([maxBlueValue maxRedValue])+50;
            ylabel(obj.viewResultsHandle.hAScatterBlueRed,'y: mean Blue (B)','FontUnits','normalized','Fontsize',0.045);
            xlabel(obj.viewResultsHandle.hAScatterBlueRed,'x: mean Red (R)','FontUnits','normalized','Fontsize',0.045);    
            ylim(obj.viewResultsHandle.hAScatterBlueRed,[ 0 maxLim ] );
            xlim(obj.viewResultsHandle.hAScatterBlueRed,[ 0 maxLim ] );
            set(obj.viewResultsHandle.hAScatterBlueRed,'xtick',[0:20:maxLim*2]);
            set(obj.viewResultsHandle.hAScatterBlueRed,'ytick',[0:20:maxLim*2]);
            
            grid(obj.viewResultsHandle.hAScatterBlueRed, 'on');
            hold(obj.viewResultsHandle.hAScatterBlueRed, 'off');
        end
        
        function showAxesScatterFarredRedGUI(obj)
            AnalyzeMode = obj.modelResultsHandle.AnalyzeMode;
            
            % Define costom color map
            ColorMapMain(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapMain(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapMain(3,:) = [255 51 51]; % Red Fiber Type 2
            ColorMapMain(4,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapMain(5,:) = [51 255 51]; % Green Collagen
            ColorMapMain = ColorMapMain/255;
            
            ColorMapAll(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapAll(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapAll(3,:) = [255 51 51]; % Red Fiber Type 2x
            ColorMapAll(4,:) = [255 255 51]; % Yellow Fiber Type 2a
            ColorMapAll(5,:) = [255 153 51]; % orange Fiber Type 2ax
            ColorMapAll(6,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapAll(7,:) = [51 255 51]; % Green Collagen
            ColorMapAll = ColorMapAll/255;
            
            % Define costom fonts
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 12*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            end
            
            cla(obj.viewResultsHandle.hAScatterFarredRed);
%             axes(obj.viewResultsHandle.hAScatterFarredRed);
            set(obj.viewResultsHandle.hAScatterFarredRed,'FontUnits','normalized','Fontsize',0.03);
            LegendString = {};
            PosColorRed =13;
            PosColorBlue =15;
            PosColorFarRed =16;
            PosColorGreen =14;
            
            hold(obj.viewResultsHandle.hAScatterFarredRed, 'on');
            
            if AnalyzeMode == 1 || AnalyzeMode == 3 || AnalyzeMode == 5 || AnalyzeMode == 7 %tripple labeling
                % Type 2 Fibers
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2(:,PosColorFarRed)); %meanBlue Values
                    hScat(3) = scatter(obj.viewResultsHandle.hAScatterFarredRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(3,:));
                    LegendString{end+1} = 'Type 2';
                end
                
            else %quad labeling
                
                % Type 2x Fibers
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2x)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorFarRed)); %meanFarred Values
                    hScatFRR(1) = scatter(obj.viewResultsHandle.hAScatterFarredRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(3,:));
                    LegendString{end+1} = 'Type 2x';
                end
                
                % Type 2a Fibers
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2a)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorFarRed)); %meanFarred Values
                    hScatFRR(2) = scatter(obj.viewResultsHandle.hAScatterFarredRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(4,:));
                    LegendString{end+1} = 'Type 2a';
                end
                
                % Type 2ax Fibers
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2ax)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorFarRed)); %meanFarred Values
                    hScatFRR(3) = scatter(obj.viewResultsHandle.hAScatterFarredRed,x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(5,:));
                    LegendString{end+1} = 'Type 2ax';
                end
            end
            hold(obj.viewResultsHandle.hAScatterFarredRed, 'on');
            
            if obj.modelResultsHandle.AnalyzeMode == 1 || obj.modelResultsHandle.AnalyzeMode == 2
                % Color-Based Classification
                
                Rmax1 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorRed)));
                Rmax2 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorRed)));
                Rmax3 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorRed)));
                
                Rmax = max([Rmax1,Rmax2,Rmax3]);
                R = [0 2*Rmax]; %Red value vector
                
                if obj.modelResultsHandle.FarredRedThreshActive
                    % Color-Based Classification
                    % FarredRedThreshActive Parameter is active, plot
                    % classification functions
                FarredRedTh = obj.modelResultsHandle.FarredRedThresh;
                FarredRedDistFR = obj.modelResultsHandle.FarredRedDistFarred;
                FarredRedDistR = obj.modelResultsHandle.FarredRedDistRed;
                
                % creat classification function line obj
                f_FRRthresh =  FarredRedTh * R; %Blue/Red thresh fcn
                f_FRdist = FarredRedTh * R / (1-FarredRedDistFR); %farred dist fcn
                f_Rdist = FarredRedTh * R * (1-FarredRedDistR); %red dist fcn
                
                plot(obj.viewResultsHandle.hAScatterFarredRed,R,f_FRdist,'y');
                LegendString{end+1} = ['f_{FRdist}(R) = ' num2str(FarredRedTh) ' * R / (1-' num2str(FarredRedDistFR) ')'];

                plot(obj.viewResultsHandle.hAScatterFarredRed,R,f_Rdist,'r');
                LegendString{end+1} = ['f_{Rdist}(R) = ' num2str(FarredRedTh) ' * R * (1-' num2str(FarredRedDistR) ')'];
                
                plot(obj.viewResultsHandle.hAScatterFarredRed,R,f_FRRthresh,'k');
                LegendString{end+1} = ['f_{BRthresh}(R) = ' num2str(FarredRedTh) ' * R'];
                elseif ~obj.modelResultsHandle.FarredRedThreshActive && obj.modelResultsHandle.AnalyzeMode == 2
                    % creat classification function line obj
                FarredRedTh = 1;
                f_BRthresh =  FarredRedTh * R; %Blue/Red thresh fcn
                LegendString{end+1} = ['f_{FRthresh}(R) = R (not active)'];
                hold(obj.viewResultsHandle.hAScatterFarredRed, 'on');
                plot(obj.viewResultsHandle.hAScatterFarredRed,R,f_BRthresh,'k');
                    
                end
                
                
                if obj.modelResultsHandle.AnalyzeMode == 1
                    title(obj.viewResultsHandle.hAScatterFarredRed,{'Color-Based Triple Labeling (Type-2 Subgroups)'},'FontUnits','normalized','Fontsize',0.06);
                elseif obj.modelResultsHandle.AnalyzeMode == 2
                    title(obj.viewResultsHandle.hAScatterFarredRed,{'Color-Based Quad Labeling (Type-2 Subgroups)'},'FontUnits','normalized','Fontsize',0.06);
                end
                
            elseif obj.modelResultsHandle.AnalyzeMode == 3
                title(obj.viewResultsHandle.hAScatterFarredRed,'Cluster-Based Triple Labeling (Type-2 Subgroups)','FontUnits','normalized','Fontsize',0.06);
            elseif obj.modelResultsHandle.AnalyzeMode == 4
                title(obj.viewResultsHandle.hAScatterFarredRed,'Cluster-Based Quad Labeling (Type-2 Subgroups)','FontUnits','normalized','Fontsize',0.06);
            elseif obj.modelResultsHandle.AnalyzeMode == 5 || obj.modelResultsHandle.AnalyzeMode == 6
                title(obj.viewResultsHandle.hAScatterFarredRed,'Manual Classification (Type-2 Subgroups)','FontUnits','normalized','Fontsize',0.06);
            elseif obj.modelResultsHandle.AnalyzeMode == 7   
                title(obj.viewResultsHandle.hAScatterFarredRed,'No Classification (Type-2 Subgroups)','FontUnits','normalized','Fontsize',0.06);
            end
                maxFarredValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,14)));
                maxRedValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,PosColorRed)));
                maxLim =max([maxFarredValue maxRedValue])+50;
                ylabel(obj.viewResultsHandle.hAScatterFarredRed,'y: mean Farred (FR)','FontUnits','normalized','Fontsize',0.045);
                xlabel(obj.viewResultsHandle.hAScatterFarredRed,'x: mean Red (R)','FontUnits','normalized','Fontsize',0.045); 
                
                ylim(obj.viewResultsHandle.hAScatterFarredRed,[ 0 maxLim ] );
                xlim(obj.viewResultsHandle.hAScatterFarredRed,[ 0 maxLim ] );
                set(obj.viewResultsHandle.hAScatterFarredRed,'xtick',[0:20:maxLim*2]);
                set(obj.viewResultsHandle.hAScatterFarredRed,'ytick',[0:20:maxLim*2]);
                
                if ~isempty(LegendString)
                    l4 = legend(obj.viewResultsHandle.hAScatterFarredRed,LegendString,'Location','Best');
                    set(l4,'Tag','LegendScatterPlotFarredRed');
                    l4.FontSize=fontSizeM;
                end
                    
                grid(obj.viewResultsHandle.hAScatterFarredRed, 'on');
                hold(obj.viewResultsHandle.hAScatterFarredRed, 'off');
                
        end
        
        function showAxesScatterAllGUI(obj)
            % Shows the fibertype data and the statistc data in the
            % corresponding axes in the GUI. Including area statistics
            % plot, number of fiber types plot, scatter plot fiber types
            % and scatter plot all objects.
            %
            %   showAxesDataInGUI(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
                
            
            
           AnalyzeMode = obj.modelResultsHandle.AnalyzeMode;
            
            % Define costom color map
            ColorMapMain(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapMain(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapMain(3,:) = [255 51 51]; % Red Fiber Type 2
            ColorMapMain(4,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapMain(5,:) = [51 255 51]; % Green Collagen
            ColorMapMain = ColorMapMain/255;
            
            ColorMapAll(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMapAll(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMapAll(3,:) = [255 51 51]; % Red Fiber Type 2x
            ColorMapAll(4,:) = [255 255 51]; % Yellow Fiber Type 2a
            ColorMapAll(5,:) = [255 153 51]; % orange Fiber Type 2ax
            ColorMapAll(6,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMapAll(7,:) = [51 255 51]; % Green Collagen
            ColorMapAll = ColorMapAll/255;
            
            % Define costom fonts
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 12*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 12; % Font size medium
                fontSizeB = 16; % Font size big
            end
            
            cla(obj.viewResultsHandle.hAScatterAll);
            LegendString={};
            PosColorRed =13;
            PosColorBlue =15;
            PosColorFarRed =16;
            PosColorGreen =14;
            
            if ~isempty(obj.modelResultsHandle.StatsMatDataT1)
            x = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,PosColorRed)); %meanRed Values
            y = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,PosColorBlue)); %meanBlue Values
            z = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,PosColorFarRed)); %meanFarred Values
            scatter3(obj.viewResultsHandle.hAScatterAll,x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(1,:));
            LegendString{end+1} = 'Type 1';
            end
            hold(obj.viewResultsHandle.hAScatterAll, 'on');
            if ~isempty(obj.modelResultsHandle.StatsMatDataT12h)
            x = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,PosColorRed)); %meanRed Values
            y = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,PosColorBlue)); %meanBlue Values
            z = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,PosColorFarRed)); %meanFarred Values
            scatter3(obj.viewResultsHandle.hAScatterAll,x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(2,:));
            LegendString{end+1} = 'Type 12h';
            end
            hold(obj.viewResultsHandle.hAScatterAll, 'on');
            
            if AnalyzeMode == 1 || AnalyzeMode == 3 || AnalyzeMode == 5 || AnalyzeMode == 7 %tripple labeling
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2(:,PosColorBlue)); %meanBlue Values
                    z = cell2mat(obj.modelResultsHandle.StatsMatDataT2(:,PosColorFarRed)); %meanFarred Values
                    scatter3(obj.viewResultsHandle.hAScatterAll,x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(3,:));
                    LegendString{end+1} = 'Type 2';
                end
                hold(obj.viewResultsHandle.hAScatterAll, 'on');
            else
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2x)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorBlue)); %meanBlue Values
                    z = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,PosColorFarRed)); %meanFarred Values
                    scatter3(obj.viewResultsHandle.hAScatterAll,x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(3,:));
                    LegendString{end+1} = 'Type 2x';
                end
                hold(obj.viewResultsHandle.hAScatterAll, 'on');
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2a)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorBlue)); %meanBlue Values
                    z = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,PosColorFarRed)); %meanFarred Values
                    scatter3(obj.viewResultsHandle.hAScatterAll,x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(4,:));
                    LegendString{end+1} = 'Type 2a';
                end
                hold(obj.viewResultsHandle.hAScatterAll, 'on');
                if ~isempty(obj.modelResultsHandle.StatsMatDataT2ax)
                    x = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorRed)); %meanRed Values
                    y = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorBlue)); %meanBlue Values
                    z = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,PosColorFarRed)); %meanFarred Values
                    scatter3(obj.viewResultsHandle.hAScatterAll,x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMapAll(5,:));
                    LegendString{end+1} = 'Type 2ax';
                end
            end
            hold(obj.viewResultsHandle.hAScatterAll, 'on');
            title(obj.viewResultsHandle.hAScatterAll,{'Scatter Plot all Fiber Types'},'FontUnits','normalized','Fontsize',0.05);
            hold(obj.viewResultsHandle.hAScatterAll, 'on');
            
            if ~isempty(LegendString)
                l5 = legend(obj.viewResultsHandle.hAScatterAll,LegendString,'Location','Best');
                set(l5,'Tag','LegendScatterPlotAll');
                l5.FontSize = fontSizeM;
            end
            
            hold(obj.viewResultsHandle.hAScatterAll, 'on');
            zlabel(obj.viewResultsHandle.hAScatterAll,'z: mean Farred','FontSize',12);
            ylabel(obj.viewResultsHandle.hAScatterAll,'y: mean Blue','FontSize',12);
            xlabel(obj.viewResultsHandle.hAScatterAll,'x: mean Red','FontSize',12);
            
            maxBlueValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,PosColorBlue)));
            maxRedValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,PosColorRed)));
            maxFarredValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,PosColorFarRed)));
            
            maxLim = max([maxFarredValue maxRedValue maxBlueValue])+50;
            
            ylim(obj.viewResultsHandle.hAScatterAll,[ 0 maxLim ] );
            xlim(obj.viewResultsHandle.hAScatterAll,[ 0 maxLim ] );
            zlim(obj.viewResultsHandle.hAScatterAll,[ 0 maxLim ] );
            set(obj.viewResultsHandle.hAScatterAll,'xtick',[0:20:maxLim*2]);
            set(obj.viewResultsHandle.hAScatterAll,'ytick',[0:20:maxLim*2]);
            set(obj.viewResultsHandle.hAScatterAll,'ztick',[0:20:maxLim*2]);
            
            grid(obj.viewResultsHandle.hAScatterAll, 'on');
            hold(obj.viewResultsHandle.hAScatterAll, 'off');
            appDesignChanger(obj.mainCardPanel,getSettingsValue('Style'));
        end
        
        function showPicProcessedGUI(obj)
            % Shows the proceesed images and the color plane image in the  
            % corresponding axes in the GUI. 
            %
            %   showPicProcessedGUI(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            
            if ismac
                fontSizeS = 12; % Font size small
                fontSizeM = 14; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 12*0.75; % Font size small
                fontSizeM = 14*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 12; % Font size small
                fontSizeM = 14; % Font size medium
                fontSizeB = 16; % Font size big
            end
            
            obj.modelResultsHandle.InfoMessage = '   - load Processed images into GUI';
            obj.modelResultsHandle.InfoMessage = '      - load RGB image';
            
            %Show proccesd image with all planes
            % get axes in the analyze GUI with rgb image
            axesPicAnalyze = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hAP;
            %get boundaries
            hBounds = findobj(axesPicAnalyze,'Type','hggroup');
            if isempty(hBounds)
            hBounds = findobj(axesPicAnalyze,'Type','line');
            end
            % get axes in the results GUI
            axesResultsPicProc = obj.viewResultsHandle.hAPProcessed;
            % show RGB image with farred plane
%             axes(axesResultsPicProc)
            
            AMode = obj.modelResultsHandle.AnalyzeMode;
            
            if AMode == 1 || AMode == 3 || AMode == 5 || AMode == 7
                imshow(obj.modelResultsHandle.PicPRGBPlanes,'Parent',axesResultsPicProc);
            elseif AMode == 2 || AMode == 4 || AMode == 6 
                imshow(obj.modelResultsHandle.PicPRGBFRPlanes,'Parent',axesResultsPicProc);
            end
            
            copyobj(hBounds ,axesResultsPicProc);
            hold(axesResultsPicProc, 'on');
            %Show labels
            obj.modelResultsHandle.InfoMessage = '         - show labels...';
            
            %plot labels in the image
            for k = 1:size(obj.modelResultsHandle.Stats,1)
                hold(axesResultsPicProc, 'on');
                c = obj.modelResultsHandle.Stats(k).Centroid;
                text(axesResultsPicProc,c(1)/obj.modelResultsHandle.XScale, c(2)/obj.modelResultsHandle.YScale, sprintf('%d', k),'Color','g', ...
                    'HorizontalAlignment', 'center', 'FontWeight','bold',...
                    'VerticalAlignment', 'middle','FontSize',fontSizeB,...
                    'Clipping','on','Tag','fiberLabelsProcessed');
            end
            axis(axesResultsPicProc, 'image');
            axis(axesResultsPicProc, 'on');
            hold(axesResultsPicProc, 'off');
            lhx=xlabel(axesResultsPicProc, sprintf('x/\x3BCm'),'Fontsize',fontSizeM);
            lhy=ylabel(axesResultsPicProc, sprintf('y/\x3BCm'),'Fontsize',fontSizeM);
            set(lhx, 'Units', 'Normalized', 'Position', [1 0]);
            maxPixelX = size(obj.modelResultsHandle.PicPRGBFRPlanes,2);
            Xvalue = obj.modelResultsHandle.XScale;
            axesResultsPicProc.XTick = [0:100:maxPixelX];
            axesResultsPicProc.XTickLabel = axesResultsPicProc.XTick*Xvalue;
            maxPixelY = size(obj.modelResultsHandle.PicPRGBFRPlanes,1);
            Yvalue = obj.modelResultsHandle.YScale;
            axesResultsPicProc.YTick = [0:100:maxPixelY];
            axesResultsPicProc.YTickLabel = axesResultsPicProc.XTick*Yvalue;
            t=title(axesResultsPicProc,['Total Area = ' num2str(obj.modelResultsHandle.AreaPic) ' ' sprintf('\x3BCm^2') ' = ' num2str(obj.modelResultsHandle.AreaPic*(10^(-6))) ' mm^2']);
            set(t,'FontUnits','normalized','Fontsize',0.02);
           
        end
        
        function showPicGroupsGUI(obj)
            % Shows the proceesed images and the color plane image in the  
            % corresponding axes in the GUI. 
            %
            %   showPicProcessedGUI(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            if ismac
                fontSizeS = 12; % Font size small
                fontSizeM = 14; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 12*0.75; % Font size small
                fontSizeM = 14*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 12; % Font size small
                fontSizeM = 14; % Font size medium
                fontSizeB = 16; % Font size big
            end
            
            obj.modelResultsHandle.InfoMessage = '   - load Group image into GUI';
            obj.modelResultsHandle.InfoMessage = '      - load RGB image';
            
%             GroupStats=obj.modelResultsHandle.findFiberGroups();
            %get Fiber Group Stats from Result Model
            GroupStats=obj.modelResultsHandle.GroupStats;
            %get axes in the results GUI
            axesResultsGroups = obj.viewResultsHandle.hAPGroups;
            % show RGB image with farred plane
%             axes(axesResultsGroups)
            
            AMode = obj.modelResultsHandle.AnalyzeMode;
            
            if AMode == 1 || AMode == 3 || AMode == 5 || AMode == 7
                imshow(obj.modelResultsHandle.PicPRGBPlanes,'Parent',axesResultsGroups);
            elseif AMode == 2 || AMode == 4 || AMode == 6 
                imshow(obj.modelResultsHandle.PicPRGBFRPlanes,'Parent',axesResultsGroups);
            end
            
            obj.modelResultsHandle.InfoMessage = '      - load Group image';
            hold(axesResultsGroups, 'on');
            himage = imshow(GroupStats.Lrgb,'Parent',axesResultsGroups);
            himage.AlphaData = 0.5;
            
            obj.modelResultsHandle.InfoMessage = '      - show Group boundaries';
            
            obj.modelResultsHandle.InfoMessage = '         - show Type 1 Groups';
            if ~isempty(GroupStats.BoundT1)
                hold(axesResultsGroups, 'on');
                visboundaries(axesResultsGroups,GroupStats.BoundT1,'Color','b','LineWidth', 2)
                n=max(max(GroupStats.LabelT1));
                tempStats=regionprops('struct',GroupStats.LabelT1,'Centroid');
                for i=1:1:n
%                     Vec=unique(GroupStats.LabelMat(GroupStats.LabelT1==i));
%                     Vec(Vec==0)=[];
                    NoObj=GroupStats.NoObjT1(i);
                    c=tempStats(i).Centroid;
%                     py = GroupStats.BoundT1{i,1}(1,1);
%                     px = GroupStats.BoundT1{i,1}(1,2);
%                     py = tempStats(i).Extrema(1,2);
%                     px = tempStats(i).Extrema(1,1);
                    hold(axesResultsGroups, 'on');
                    text(axesResultsGroups,c(1), c(2), sprintf('%d', NoObj),'Color','w', ...
                    'HorizontalAlignment', 'center', 'EdgeColor','b', ...
                    'BackgroundColor','b','Margin',1,...
                    'LineWidth', 2,'FontWeight','bold',...
                    'VerticalAlignment', 'middle','FontSize',fontSizeB,...
                    'Clipping','on','Tag','fiberLabelsProcessed');
                end
            end
            
            obj.modelResultsHandle.InfoMessage = '         - show Type 12h Groups';
            if ~isempty(GroupStats.BoundT12h)
                hold(axesResultsGroups, 'on');
                visboundaries(axesResultsGroups,GroupStats.BoundT12h,'Color','m','LineWidth', 2)
                n=max(max(GroupStats.LabelT12h));
                tempStats=regionprops('struct',GroupStats.LabelT12h,'Centroid');
                for i=1:1:n
%                     Vec=unique(GroupStats.LabelMat(GroupStats.LabelT12h==i));
%                     Vec(Vec==0)=[];
                    NoObj=GroupStats.NoObjT12h(i);
                    c=tempStats(i).Centroid;
                    hold(axesResultsGroups, 'on');
                    text(axesResultsGroups,c(1), c(2), sprintf('%d', NoObj),'Color','k', ...
                    'HorizontalAlignment', 'center', 'EdgeColor','m', ...
                    'BackgroundColor','m','Margin',1,...
                    'LineWidth', 2,'FontWeight','bold',...
                    'VerticalAlignment', 'middle','FontSize',fontSizeB,...
                    'Clipping','on','Tag','fiberLabelsProcessed');
                end
            end
            
            if AMode == 1 || AMode == 3 || AMode == 5 || AMode == 7 %tripple labeling. only shoe Type 2 fibers (no subgroups)
                
                obj.modelResultsHandle.InfoMessage = '         - show Type 2 Groups';
                if ~isempty(GroupStats.BoundT2)
                    hold(axesResultsGroups, 'on');
                    visboundaries(axesResultsGroups,GroupStats.BoundT2,'Color','r','LineWidth', 2)
                    n=max(max(GroupStats.LabelT2));
                    tempStats=regionprops('struct',GroupStats.LabelT2,'Centroid');
                    for i=1:1:n
                        %                     Vec=unique(GroupStats.LabelMat(GroupStats.LabelT2x==i));
                        %                     Vec(Vec==0)=[];
                        NoObj=GroupStats.NoObjT2(i);
                        c=tempStats(i).Centroid;
                        hold(axesResultsGroups, 'on');
                        text(axesResultsGroups,axesResultsGroups,c(1), c(2), sprintf('%d', NoObj),'Color','k', ...
                            'HorizontalAlignment', 'center', 'EdgeColor','r', ...
                            'BackgroundColor','r','Margin',1,...
                            'LineWidth', 2,'FontWeight','bold',...
                            'VerticalAlignment', 'middle','FontSize',fontSizeB,...
                            'Clipping','on','Tag','fiberLabelsProcessed');
                    end
                end
                
            else %quad labeling. show Type 2 fiber subgroups
                
                obj.modelResultsHandle.InfoMessage = '         - show Type 2x Groups';
                if ~isempty(GroupStats.BoundT2x)
                    hold(axesResultsGroups, 'on');
                    visboundaries(axesResultsGroups,GroupStats.BoundT2x,'Color','r','LineWidth', 2)
                    n=max(max(GroupStats.LabelT2x));
                    tempStats=regionprops('struct',GroupStats.LabelT2x,'Centroid');
                    for i=1:1:n
                        %                     Vec=unique(GroupStats.LabelMat(GroupStats.LabelT2x==i));
                        %                     Vec(Vec==0)=[];
                        NoObj=GroupStats.NoObjT2x(i);
                        c=tempStats(i).Centroid;
                        hold(axesResultsGroups, 'on');
                        text(axesResultsGroups,c(1), c(2), sprintf('%d', NoObj),'Color','k', ...
                            'HorizontalAlignment', 'center', 'EdgeColor','r', ...
                            'BackgroundColor','r','Margin',1,...
                            'LineWidth', 2,'FontWeight','bold',...
                            'VerticalAlignment', 'middle','FontSize',fontSizeB,...
                            'Clipping','on','Tag','fiberLabelsProcessed');
                    end
                end
                
                obj.modelResultsHandle.InfoMessage = '         - show Type 2a Groups';
                if ~isempty(GroupStats.BoundT2a)
                    hold(axesResultsGroups, 'on');
                    visboundaries(axesResultsGroups,GroupStats.BoundT2a,'Color','y','LineWidth', 2)
                    n=max(max(GroupStats.LabelT2a));
                    tempStats=regionprops('struct',GroupStats.LabelT2a,'Centroid');
                    for i=1:1:n
                        %                     Vec=unique(GroupStats.LabelMat(GroupStats.LabelT2a==i));
                        %                     Vec(Vec==0)=[];
                        NoObj=GroupStats.NoObjT2a(i);
                        c=tempStats(i).Centroid;
                        hold(axesResultsGroups, 'on');
                        text(axesResultsGroups,c(1), c(2), sprintf('%d', NoObj),'Color','k', ...
                            'HorizontalAlignment', 'center', 'EdgeColor','y', ...
                            'BackgroundColor','y','Margin',1,...
                            'LineWidth', 2,'FontWeight','bold',...
                            'VerticalAlignment', 'middle','FontSize',fontSizeB,...
                            'Clipping','on','Tag','fiberLabelsProcessed');
                    end
                end
                
                obj.modelResultsHandle.InfoMessage = '         - show Type 2ax Groups';
                if ~isempty(GroupStats.BoundT2ax)
                    hold(axesResultsGroups, 'on');
                    visboundaries(axesResultsGroups,GroupStats.BoundT2ax,'Color',[255/255 100/255 0],'LineWidth', 2)
                    n=max(max(GroupStats.LabelT2ax));
                    tempStats=regionprops('struct',GroupStats.LabelT2ax,'Centroid');
                    for i=1:1:n
                        %                     Vec=unique(GroupStats.LabelMat(GroupStats.LabelT2ax==i));
                        %                     Vec(Vec==0)=[];
                        NoObj=GroupStats.NoObjT2ax(i);
                        c=tempStats(i).Centroid;
                        hold(axesResultsGroups, 'on');
                        text(axesResultsGroups,c(1), c(2), sprintf('%d', NoObj),'Color','k', ...
                            'HorizontalAlignment', 'center', 'EdgeColor',[255/255 100/255 0], ...
                            'BackgroundColor',[255/255 100/255 0],'Margin',1,...
                            'LineWidth', 2,'FontWeight','bold',...
                            'VerticalAlignment', 'middle','FontSize',fontSizeB,...
                            'Clipping','on','Tag','fiberLabelsProcessed');
                    end
                end
            end
            textObj = findobj(axesResultsGroups,'Type','text');
            uistack(textObj,'top');
            
            axis(axesResultsGroups, 'image');
            axis(axesResultsGroups, 'on');
            hold(axesResultsGroups, 'off');
            lhx=xlabel(axesResultsGroups, sprintf('x/\x3BCm'),'Fontsize',fontSizeM);
            lhy=ylabel(axesResultsGroups, sprintf('y/\x3BCm'),'Fontsize',fontSizeM);
            set(lhx, 'Units', 'Normalized', 'Position', [1 0]);
            maxPixelX = size(obj.modelResultsHandle.PicPRGBFRPlanes,2);
            Xvalue = obj.modelResultsHandle.XScale;
            axesResultsGroups.XTick = [0:100:maxPixelX];
            axesResultsGroups.XTickLabel = axesResultsGroups.XTick*Xvalue;
            maxPixelY = size(obj.modelResultsHandle.PicPRGBFRPlanes,1);
            Yvalue = obj.modelResultsHandle.YScale;
            axesResultsGroups.YTick = [0:100:maxPixelY];
            axesResultsGroups.YTickLabel = axesResultsGroups.XTick*Yvalue;
            t=title(axesResultsGroups,['Image with Fiber-Type-Groups highlighted and number of objects within each Group.']);
            set(t,'FontUnits','normalized','Fontsize',0.02)
            
        end
        
        function showHistogramGUI(obj)
            % Shows the Histogram plots in the  
            % corresponding axes in the GUI. 
            %
            %   showPicProcessedGUI(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            
            obj.modelResultsHandle.InfoMessage = '   - show Histograms...';
             if ismac
                fontSizeS = 12; % Font size small
                fontSizeM = 14; % Font size medium
                fontSizeB = 16; % Font size big
            elseif ispc
                fontSizeS = 12*0.75; % Font size small
                fontSizeM = 14*0.75; % Font size medium
                fontSizeB = 16*0.75; % Font size big
            else
                fontSizeS = 12; % Font size small
                fontSizeM = 14; % Font size medium
                fontSizeB = 16; % Font size big
            end
            
            %find all objects that are not classified as undefined Type 0
            tempStats = obj.modelResultsHandle.Stats([obj.modelResultsHandle.Stats.FiberTypeMainGroup]>0);
            
            if ~isempty(tempStats)
            %%%%%%%%% Area Histogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.modelResultsHandle.InfoMessage = '      - plot Area Histogram';
            
            cla(obj.viewResultsHandle.hAAreaHist);
           
            h = histfit(obj.viewResultsHandle.hAAreaHist,[tempStats.Area],50);
            if(size(tempStats,1)>1)
                binWidth = num2str(abs(h(1).XEndPoints(2)-h(1).XEndPoints(1)));
            else
                binWidth = 'only 1 bin';
            end
            ylim(obj.viewResultsHandle.hAAreaHist,[0 ceil( max(h(1).YData)*1.1 / 5 ) * 5]);
            mu=mean([tempStats.Area]);
            sigma=std([tempStats.Area]);
            xline(obj.viewResultsHandle.hAAreaHist,[mu - sigma mu mu + sigma],'--r',{num2str(mu - sigma),num2str(mu),num2str(mu + sigma)},'LineWidth', 1);

            set(obj.viewResultsHandle.hAAreaHist,'FontUnits','normalized','Fontsize',0.03);
            title(obj.viewResultsHandle.hAAreaHist,'Area Histogram','FontUnits','normalized','Fontsize',0.06);
            xlabel(obj.viewResultsHandle.hAAreaHist,['Area in \mum^2 ( Bin width: ' binWidth ' \mum^2 )'],'FontUnits','normalized','Fontsize',0.045);
            ylabel(obj.viewResultsHandle.hAAreaHist,'Frequency','FontUnits','normalized','Fontsize',0.045);
            grid(obj.viewResultsHandle.hAAreaHist, 'on');
            l1=legend(obj.viewResultsHandle.hAAreaHist,"Histogram",sprintf( ['Gaussian:\n-m: ' num2str(mu) '\n-std: ' num2str(sigma) ] ));
            l1.FontSize=fontSizeM;

            %%%%%%%%% Aspect Ratio Histogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.modelResultsHandle.InfoMessage = '      - plot Aspect Ratio Histogram';
            
            cla(obj.viewResultsHandle.hAAspectHist);
            
            h = histfit(obj.viewResultsHandle.hAAspectHist,[tempStats.AspectRatio],50);
            if(size(tempStats,1)>1)
                binWidth = num2str(abs(h(1).XEndPoints(2)-h(1).XEndPoints(1)));
            else
                binWidth = 'only 1 bin';
            end
            ylim(obj.viewResultsHandle.hAAspectHist,[0 ceil( max(h(1).YData)*1.1 / 5 ) * 5]);
            mu=mean([tempStats.AspectRatio]);
            sigma=std([tempStats.AspectRatio]);
            xline(obj.viewResultsHandle.hAAspectHist,[mu - sigma mu mu + sigma],'--r',{num2str(mu - sigma),num2str(mu),num2str(mu + sigma)},'LineWidth', 1);
            
            set(obj.viewResultsHandle.hAAspectHist,'FontUnits','normalized','Fontsize',0.03);
            title(obj.viewResultsHandle.hAAspectHist,'Aspect Ratio Histogram','FontUnits','normalized','Fontsize',0.06);
            xlabel(obj.viewResultsHandle.hAAspectHist,['Aspect Ratio ( Bin width: ' binWidth ' )'],'FontUnits','normalized','Fontsize',0.045);
            ylabel(obj.viewResultsHandle.hAAspectHist,'Frequency','FontUnits','normalized','Fontsize',0.045);
            grid(obj.viewResultsHandle.hAAspectHist, 'on');
            l2=legend(obj.viewResultsHandle.hAAspectHist,"Histogram",sprintf( ['Gaussian:\n-m: ' num2str(mu) '\n-std: ' num2str(sigma) ] ));
            l2.FontSize=fontSizeM;
            
            %%%%%%%%% Diameters Histogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.modelResultsHandle.InfoMessage = '      - plot Diameter Histogram';
            
            cla(obj.viewResultsHandle.hADiaHist);
         
            h = histfit(obj.viewResultsHandle.hADiaHist,[tempStats.minDiameter],50);
            if(size(tempStats,1)>1)
                binWidth = num2str(abs(h(1).XEndPoints(2)-h(1).XEndPoints(1)));
            else
                binWidth = 'only 1 bin';
            end
            ylim(obj.viewResultsHandle.hADiaHist,[0 ceil( max(h(1).YData)*1.1 / 5 ) * 5]);
            mu=mean([tempStats.minDiameter]);
            sigma=std([tempStats.minDiameter]);
            xline(obj.viewResultsHandle.hADiaHist,[mu - sigma mu mu + sigma],'--r',{num2str(mu - sigma),num2str(mu),num2str(mu + sigma)},'LineWidth', 1);
            
            set(obj.viewResultsHandle.hADiaHist,'FontUnits','normalized','Fontsize',0.03);
            title(obj.viewResultsHandle.hADiaHist,'Diameter Histogram, minimum Fertet-Diameter (Breadth) ','FontUnits','normalized','Fontsize',0.06);
            xlabel(obj.viewResultsHandle.hADiaHist,['Diameters in \mum ( Bin width: ' binWidth ' \mum )'] ,'FontUnits','normalized','Fontsize',0.045);
            ylabel(obj.viewResultsHandle.hADiaHist,'Frequency','FontUnits','normalized','Fontsize',0.045);
            grid(obj.viewResultsHandle.hADiaHist, 'on');
            l3=legend(obj.viewResultsHandle.hADiaHist,"Histogram",sprintf( ['Gaussian:\n-m: ' num2str(mu) '\n-std: ' num2str(sigma) ] ));
            l3.FontSize=fontSizeM;
            
            %%%%%%%%% Roundness Histogram %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.modelResultsHandle.InfoMessage = '      - plot Roundness Histogram';
            
            cla(obj.viewResultsHandle.hARoundHist);

            h = histfit(obj.viewResultsHandle.hARoundHist,[tempStats.Roundness],50);
            if(size(tempStats,1)>1)
                binWidth = num2str(abs(h(1).XEndPoints(2)-h(1).XEndPoints(1)));
            else
                binWidth = 'only 1 bin';
            end
            ylim(obj.viewResultsHandle.hARoundHist,[0 ceil( max(h(1).YData)*1.1 / 5 ) * 5]);
            mu=mean([tempStats.Roundness]);
            sigma=std([tempStats.Roundness]);
            xline(obj.viewResultsHandle.hARoundHist,[mu - sigma mu mu + sigma],'--r',{num2str(mu - sigma),num2str(mu),num2str(mu + sigma)},'LineWidth', 1);
            
            set(obj.viewResultsHandle.hARoundHist,'FontUnits','normalized','Fontsize',0.03);
            title(obj.viewResultsHandle.hARoundHist,'Roundness Histogram','FontUnits','normalized','Fontsize',0.06);
            xlabel(obj.viewResultsHandle.hARoundHist,['Roundness ( Bin width: ' binWidth ' )'],'FontUnits','normalized','Fontsize',0.045);
            ylabel(obj.viewResultsHandle.hARoundHist,'Frequency','FontUnits','normalized','Fontsize',0.045);
            grid(obj.viewResultsHandle.hARoundHist, 'on');
            l4=legend(obj.viewResultsHandle.hARoundHist,"Histogram",sprintf( ['Gaussian:\n-m: ' num2str(mu) '\n-std: ' num2str(sigma) ] ));
            l4.FontSize=fontSizeM;
            else
                obj.modelResultsHandle.InfoMessage = '      - ERROR: No Data for Histogram';
            end
            
        end
                
        function updateInfoLogEvent(obj,src,evnt)
            % Listener callback function of the InfoMessage propertie in
            % the model. Is called when InfoMessage string changes. Appends
            % the text in InfoMessage to the log text in the GUI.
            %
            %   updateInfoLogEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResult object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            InfoText = cat(1, get(obj.viewResultsHandle.B_InfoText, 'String'), {obj.modelResultsHandle.InfoMessage});
            set(obj.viewResultsHandle.B_InfoText, 'String', InfoText);
            set(obj.viewResultsHandle.B_InfoText, 'Value' , length(obj.viewResultsHandle.B_InfoText.String));
            drawnow;
            pause(0.02)
        end
        
        function newPictureEvent(obj,~,~)
            % Callback of the New Pic button in the GUI. Get back to the edit
            % mode and call the newPictureEvent function to select a new
            % image for further processing.
            %
            %   newPictureEvent(obj,~,~);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResul object
            %
            
            choice = questdlg({'Are you sure you want to open a new file? ','All unsaved data will be lost.'},...
                'New File', ...
                'Yes','No','No');
            
            switch choice
                case 'Yes'
                    %clear Data
                    obj.clearData();
                    
                    obj.backAnalyzeModeEvent();
                    obj.controllerAnalyzeHandle.newPictureEvent;
                case 'No'
                    obj.modelResultsHandle.InfoMessage = '   - closing program canceled';
                otherwise
                    obj.modelResultsHandle.InfoMessage = '   - closing program canceled';  
            end
        end
        
        function clearData(obj)
            % Clears all data in the model. Set the ResultsUpdateStatus to
            % false.
            %
            %   saveResults(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            
            %clear Data
            obj.modelResultsHandle.Stats = [];
            obj.modelResultsHandle.LabelMat = [];
            obj.viewResultsHandle.B_TableMain.Data = {};
            obj.viewResultsHandle.B_TableStatistic.Data = {};
            obj.modelResultsHandle.FileName = [];
            obj.modelResultsHandle.PathName = [];
            obj.modelResultsHandle.PicPRGBFRPlanes = [];
            obj.modelResultsHandle.PicPRGBPlanes = [];
            obj.modelResultsHandle.Stats = [];
            obj.modelResultsHandle.LabelMat = [];
            obj.modelResultsHandle.AnalyzeMode = [];
            obj.modelResultsHandle.AreaActive = [];
            obj.modelResultsHandle.MinAreaPixel = [];
            obj.modelResultsHandle.MaxAreaPixel = [];
            obj.modelResultsHandle.AspectRatioActive = [];
            obj.modelResultsHandle.MinAspectRatio = [];
            obj.modelResultsHandle.MaxAspectRatio = [];
            obj.modelResultsHandle.RoundnessActive = [];
            obj.modelResultsHandle.MinRoundness = [];
            obj.modelResultsHandle.BlueRedThreshActive = [];
            obj.modelResultsHandle.BlueRedThresh = [];
            obj.modelResultsHandle.BlueRedDistBlue = [];
            obj.modelResultsHandle.BlueRedDistRed = [];
            obj.modelResultsHandle.FarredRedThreshActive = [];
            obj.modelResultsHandle.FarredRedThresh = [];
            obj.modelResultsHandle.FarredRedDistFarred = [];
            obj.modelResultsHandle.FarredRedDistFarred = [];
            obj.modelResultsHandle.FarredRedDistRed = [];
            obj.modelResultsHandle.ColorValueActive = [];
            obj.modelResultsHandle.ColorValue = [];
            
            
            obj.modelResultsHandle.NoOfObjects = [];
            obj.modelResultsHandle.NoTyp1 = [];
            obj.modelResultsHandle.NoTyp12h = [];
            obj.modelResultsHandle.NoTyp2a = [];
            obj.modelResultsHandle.NoTyp2x = [];
            obj.modelResultsHandle.NoTyp2ax = [];
            obj.modelResultsHandle.NoTyp0 = [];
            
            obj.modelResultsHandle.AreaPic = [];
            obj.modelResultsHandle.AreaType1 = [];
            obj.modelResultsHandle.AreaType2a = [];
            obj.modelResultsHandle.AreaType2x = [];
            obj.modelResultsHandle.AreaType2ax = [];
            obj.modelResultsHandle.AreaType12h = [];
            obj.modelResultsHandle.AreaType0 = [];
            obj.modelResultsHandle.AreaFibers = [];
            obj.modelResultsHandle.AreaNoneObj = [];
            
            obj.modelResultsHandle.AreaType1PC = [];
            obj.modelResultsHandle.AreaType12hPC = [];
            obj.modelResultsHandle.AreaType2aPC = [];
            obj.modelResultsHandle.AreaType2xPC = [];
            obj.modelResultsHandle.AreaType2axPC = [];
            obj.modelResultsHandle.AreaType0PC = [];
            obj.modelResultsHandle.AreaFibersPC = [];
            obj.modelResultsHandle.AreaNoneObjPC = [];
            
            obj.modelResultsHandle.AreaMinMax = [];
            obj.modelResultsHandle.AreaMinMaxObj = [];
            obj.modelResultsHandle.AreaMinMaxT1 = [];
            obj.modelResultsHandle.AreaMinMaxObjT1 = [];
            obj.modelResultsHandle.AreaMinMaxT12h = [];
            obj.modelResultsHandle.AreaMinMaxObjT12h = [];
            obj.modelResultsHandle.AreaMinMaxT2a = [];
            obj.modelResultsHandle.AreaMinMaxObjT2a = [];
            obj.modelResultsHandle.AreaMinMaxT2x = [];
            obj.modelResultsHandle.AreaMinMaxObjT2x = [];
            obj.modelResultsHandle.AreaMinMaxT2ax = [];
            obj.modelResultsHandle.AreaMinMaxObjT2ax = [];
            
            % Clear PicRGB and Boundarie Objects if exist
            if ~isempty(obj.viewResultsHandle.hAPProcessed.Children)
                handleChild = allchild(obj.viewResultsHandle.hAPProcessed);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAPProcessed);
            end
            
            % Clear PicRGB and Boundarie Objects if exist
            if ~isempty(obj.viewResultsHandle.hAPGroups.Children)
                handleChild = allchild(obj.viewResultsHandle.hAPGroups);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAPGroups);
            end
            
            % Clear area plot if exist
            if ~isempty(obj.viewResultsHandle.hAArea.Children)
                handleChild = allchild(obj.viewResultsHandle.hAArea);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAArea);
            end
            
            % Clear count plot if exist
            if ~isempty(obj.viewResultsHandle.hACount.Children)
                handleChild = allchild(obj.viewResultsHandle.hACount);
                delete(handleChild);
                reset(obj.viewResultsHandle.hACount);
            end
            
            % Clear scatter plot Blue Red if exist
            if ~isempty(obj.viewResultsHandle.hAScatterBlueRed.Children)
                handleChild = allchild(obj.viewResultsHandle.hAScatterBlueRed);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAScatterBlueRed);
            end
            
            % Clear scatter all plot if exist
            if ~isempty(obj.viewResultsHandle.hAScatterFarredRed.Children)
                handleChild = allchild(obj.viewResultsHandle.hAScatterFarredRed);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAScatterFarredRed);
            end
            
            % Clear scatter all plot if exist
            if ~isempty(obj.viewResultsHandle.hAScatterAll.Children)
                handleChild = allchild(obj.viewResultsHandle.hAScatterAll);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAScatterAll);
            end
            
            % Clear Histogramm Area if exist
            if ~isempty(obj.viewResultsHandle.hAAreaHist.Children)
                handleChild = allchild(obj.viewResultsHandle.hAAreaHist);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAAreaHist);
            end
            
            % Clear Histogramm AspectRatio if exist
            if ~isempty(obj.viewResultsHandle.hAAspectHist.Children)
                handleChild = allchild(obj.viewResultsHandle.hAAspectHist);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAAspectHist);
            end
            
            % Clear Histogramm Diameter if exist
            if ~isempty(obj.viewResultsHandle.hADiaHist.Children)
                handleChild = allchild(obj.viewResultsHandle.hADiaHist);
                delete(handleChild);
                reset(obj.viewResultsHandle.hADiaHist);
            end
            
            % Clear Histogramm Rondness if exist
            if ~isempty(obj.viewResultsHandle.hARoundHist.Children)
                handleChild = allchild(obj.viewResultsHandle.hARoundHist);
                delete(handleChild);
                reset(obj.viewResultsHandle.hARoundHist);
            end
            
            %Delete Legends
            lTemp = findobj('Tag','LegendAreaPlot');
            delete(lTemp);
            lTemp = findobj('Tag','LegendNumberPlot');
            delete(lTemp);
            lTemp = findobj('Tag','LegendScatterPlotBlueRed');
            delete(lTemp);
            lTemp = findobj('Tag','LegendScatterPlotFarredRed');
            delete(lTemp);
            lTemp = findobj('Tag','LegendScatterPlotAll');
            delete(lTemp);
            
            obj.modelResultsHandle.ResultUpdateStaus = false;
        end
        
        function openSaveDirectory(obj,~,~)
            % Callback of the open save directory button in the GUI. Opens
            % the directory where the files are saved. Is the same
            % directory in which the RGB image lies.
            %
            %   openSaveDirectory(obj,~,~);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResult object
            %
            try
                
                if exist(obj.modelResultsHandle.SavePath,'dir') == 7
                    
                    if ismac
                        obj.modelResultsHandle.InfoMessage = '   - open save directory';
                        path = obj.modelResultsHandle.SavePath;
                        
                        % transforl space char into mac compatible '/ ' char
                        path = strrep(path,' ','\ ');
                        unix(['open ' path]);
                        
                    elseif ispc
                        obj.modelResultsHandle.InfoMessage = '   - open save directory';
                        winopen(obj.modelResultsHandle.SavePath);
                    else
                        obj.modelResultsHandle.InfoMessage = '   - Error while opening save directory';
                    end
                else
                    obj.modelResultsHandle.InfoMessage = '   - save directory dont exist';
                    obj.modelResultsHandle.InfoMessage = '      - no data has been saved';
                    obj.modelResultsHandle.InfoMessage = '      - press Save button to saving data and creating directory';
                end
                
            catch
                obj.errorMessage(lasterror);
            end
            
        end
        
        function busyIndicator(obj,status)
            % See: http://undocumentedmatlab.com/blog/animated-busy-spinning-icon
            
            
            if status
                %create indicator object and disable GUI elements
                
                figHandles = findobj('Type','figure');
                set(figHandles,'pointer','watch');
                %find all objects that are enabled and disable them
                obj.modelResultsHandle.busyObj = findall(figHandles, '-property', 'Enable','-and','Enable','on',...
                    '-and','-not','style','listbox','-and','-not','style','text','-and','-not','Type','uitable');
                set( obj.modelResultsHandle.busyObj, 'Enable', 'off')
                appDesignElementChanger(obj.mainCardPanel);
                try
                    % R2010a and newer
                    iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
                    iconsSizeEnums = javaMethod('values',iconsClassName);
                    SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
                    obj.modelResultsHandle.busyIndicator = com.mathworks.widgets.BusyAffordance(SIZE_32x32, 'busy...');  % icon, label
                catch
                    % R2009b and earlier
                    redColor   = java.awt.Color(1,0,0);
                    blackColor = java.awt.Color(0,0,0);
                    obj.modelResultsHandle.busyIndicator = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
                end
                
                obj.modelResultsHandle.busyIndicator.setPaintsWhenStopped(false);  % default = false
                obj.modelResultsHandle.busyIndicator.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
                javacomponent(obj.modelResultsHandle.busyIndicator.getComponent, [10,10,80,80], obj.mainFigure);
                obj.modelResultsHandle.busyIndicator.start;

            else
                %delete indicator object and disable GUI elements
                
                if ~isempty(obj.modelResultsHandle.busyIndicator)
                obj.modelResultsHandle.busyIndicator.stop;
                [hjObj, hContainer] = javacomponent(obj.modelResultsHandle.busyIndicator.getComponent, [10,10,80,80], obj.mainFigure);
                delete(hContainer) ;
                obj.modelResultsHandle.busyIndicator = [];
                end
                
                figHandles = findobj('Type','figure');
                set(figHandles,'pointer','arrow');
                
                if ~isempty(obj.modelResultsHandle.busyObj)
                    valid = isvalid(obj.modelResultsHandle.busyObj);
                    obj.modelResultsHandle.busyObj(~valid)=[];
                set( obj.modelResultsHandle.busyObj, 'Enable', 'on')
                end
            end
            appDesignElementChanger(obj.mainCardPanel);
        end
        
        function errorMessage(obj,ErrorInfo)
            Text = [];
            Text{1,1} = ErrorInfo.message;
            Text{2,1} = '';
            
            if any(strcmp('stack',fieldnames(ErrorInfo)))
                
                for i=1:size(ErrorInfo.stack,1)
                    
                    Text{end+1,1} = [ErrorInfo.stack(i).file];
                    Text{end+1,1} = [ErrorInfo.stack(i).name];
                    Text{end+1,1} = ['Line: ' num2str(ErrorInfo.stack(i).line)];
                    Text{end+1,1} = '------------------------------------------';
                    
                end
                
            end
            
            mode = struct('WindowStyle','modal','Interpreter','tex');
            beep
            uiwait(errordlg(Text,'ERROR: Results-Mode',mode));
            
            workbar(1.5,'delete workbar','delete workbar',obj.mainFigure);
            obj.busyIndicator(0);
        end
        
        function closeProgramEvent(obj,~,~)
            % Colose Request function of the main figure and callback
            % function of the close button in the GUI.
            %
            %   closeProgramEvent(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResult object
            %
            winState=get(obj.mainFigure,'WindowState');
            choice = questdlg({'Are you sure you want to quit? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            if strcmp(winState,'maximized')
                set(obj.mainFigure,'WindowState','maximized');
            end
            
            switch choice
                case 'Yes'
                    
                    delete(obj.viewResultsHandle);
                    delete(obj.modelResultsHandle);
                    delete(obj.mainCardPanel);
                    
                    %find all objects
                    object_handles = findall(obj.mainFigure);
                    %delete objects
                    delete(object_handles);
                    %find all figures and delete them
                    figHandles = findobj('Type','figure');
                    delete(figHandles);
                case 'No'
                obj.modelResultsHandle.InfoMessage = '   - closing program canceled';
                otherwise
                obj.modelResultsHandle.InfoMessage = '   - closing program canceled';   
            end
        
        end
       
        function delete(obj)
            %deconstructor
            delete(obj);
        end
        
    end
    
end

