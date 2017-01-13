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
            set(obj.mainFigure,'ButtonDownFcn','');
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);

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
        
        function startResultsModeEvent(obj,Data,InfoText)
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
            %           InfoText:   Info text log.
            %
            
            % Set PicData Properties in the Results Model
            obj.modelResultsHandle.FileNamesRGB = Data{1};
            obj.modelResultsHandle.PathNames = Data{2};
            obj.modelResultsHandle.PicRGB = Data{3};
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
            
            obj.modelResultsHandle.ColorDistanceActive = Data{16};
            obj.modelResultsHandle.MinColorDistance = Data{17};
            
            obj.modelResultsHandle.ColorValueActive = Data{18};
            obj.modelResultsHandle.ColorValue = Data{19};

            
            set(obj.viewResultsHandle.B_InfoText, 'String', InfoText);
            set(obj.viewResultsHandle.B_InfoText, 'Value' , length(obj.viewResultsHandle.B_InfoText.String));
            
            % set panel title to filename and path
            Titel = [obj.modelResultsHandle.PathNames obj.modelResultsHandle.FileNamesRGB];
            obj.viewResultsHandle.panelResults.Title = Titel;
            
           
            %change the card panel to selection 3: results mode
            obj.mainCardPanel.Selection = 3;
            
            %change the figure callbacks for the results mode
            obj.addWindowCallbacks()
            
            obj.modelResultsHandle.InfoMessage = '*** Start Result mode ***';
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','off');
            set(obj.viewResultsHandle.B_Save,'Enable','off');
            set(obj.viewResultsHandle.B_NewPic,'Enable','off');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','off');
            set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','off');
            
            %show results data in the GUI
            obj.modelResultsHandle.startResultMode();
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','on');
            set(obj.viewResultsHandle.B_Save,'Enable','on');
            set(obj.viewResultsHandle.B_NewPic,'Enable','on');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','on');
            
            %Check if a resultsfolder for the image already exist
            % Dlete file extension .tif in the results folder before save
            fileNameRGB = obj.modelResultsHandle.FileNamesRGB;
            LFN = length(obj.modelResultsHandle.FileNamesRGB);
            fileNameRGB(LFN)='';
            fileNameRGB(LFN-1)='';
            fileNameRGB(LFN-2)='';
            fileNameRGB(LFN-3)='';
            % Save dir is the same as the dir from the selected Pic
            SaveDir = [obj.modelResultsHandle.PathNames obj.modelResultsHandle.FileNamesRGB '_RESULTS']; 
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
            
            obj.modelResultsHandle.SaveFiberTable = obj.viewResultsHandle.B_SaveFiberTable.Value;
            obj.modelResultsHandle.SaveStatisticTable = obj.viewResultsHandle.B_SaveStatisticTable.Value;
            obj.modelResultsHandle.SavePlots = obj.viewResultsHandle.B_SavePlots.Value;
            obj.modelResultsHandle.SavePicProcessed = obj.viewResultsHandle.B_SaveAnaPicture.Value;
            obj.modelResultsHandle.SavePlanePicture = obj.viewResultsHandle.B_SavePlanePicture.Value;
            
            
            if ( obj.modelResultsHandle.SaveFiberTable || ...
                 obj.modelResultsHandle.SaveStatisticTable || ...
                 obj.modelResultsHandle.SavePlots || ...
                 obj.modelResultsHandle.SavePicProcessed || ...
                 obj.modelResultsHandle.SavePlanePicture)
                    
                
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','off');
            set(obj.viewResultsHandle.B_Save,'Enable','off');
            set(obj.viewResultsHandle.B_NewPic,'Enable','off');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','off');
            set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','off');
            
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
            
            obj.viewResultsHandle.B_TableMain.Data = obj.modelResultsHandle.StatsMatData;
            obj.viewResultsHandle.B_TableStatistic.Data = obj.modelResultsHandle.StatisticMat;
            
        end
        
        function showAxesDataInGUI(obj)
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
            
            obj.modelResultsHandle.InfoMessage = '   - plot data into GUI axes...';
            
            % Define costom color map
            ColorMap(1,:) = [.25 .55 .79]; % Blue Fiber Type 1
            ColorMap(2,:) = [.9 .1 .14]; % Red Fiber Type 2
            ColorMap(3,:) = [.9 .27 .82]; % Magenta Fiber Type 3
            ColorMap(4,:) = [.9 .9 .9]; % Grey Fiber Type 0
            ColorMap(5,:) = [0 1 0]; % Green No Fiber Objects
            
            % Plot Count Numbers in Axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.modelResultsHandle.InfoMessage = '      - plot number of types...';

            
            B = [obj.modelResultsHandle.NoTyp1 obj.modelResultsHandle.NoTyp2 ...
                obj.modelResultsHandle.NoTyp3 obj.modelResultsHandle.NoTyp0];
            
            x = 1:length(B);
            % make Axes for Count Data the current Axes
            axes(obj.viewResultsHandle.hACount);
            % clear old Data in current Axes
            cla(obj.viewResultsHandle.hACount)
            
           
            for b = 1 : length(B)
                hold on;
                % Plot one single bar as a separate bar series.
                handleToThisBarSeries(b) = bar(x(b), B(b), 'BarWidth', 0.9);
                % Apply the color to this bar series.
                set(handleToThisBarSeries(b),'FaceColor', ColorMap(b,:));
                % Place text atop the bar
                barTopper = sprintf('%d',B(b));
                hText(b) = text(x(b)-0.1, B(b), barTopper,'HorizontalAlignment','center',...
                    'VerticalAlignment','bottom', 'FontSize', 15);
                
            end
            
            % get highest position of text objects
            maxTextPos = max(max([hText.Position]));
            
            ylim([0 maxTextPos+20]);
            
            set(gca,'XTickLabel',{'Type 1','Type 2','Type 3','Type 0'},'FontSize', 12);
            set(gca,'XTick',[1 2 3 4]);
            ylabel('Numbers');
            title('Number of fiber types','FontSize',16)
            l(1) = legend('Type 1','Type 2','Type 3','Type 0 (no fiber)',...
                    'Location','Best');
            set(l(1),'Tag','LegendNumberPlot');
            grid on
            hold off
            
            % Plot Area in Axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.modelResultsHandle.InfoMessage = '      - plot area...';
            
            % make Axes for Count Data the current Axes
            cla(obj.viewResultsHandle.hAArea)
            axes(obj.viewResultsHandle.hAArea);
            
            
            B = [obj.modelResultsHandle.AreaType1PC obj.modelResultsHandle.AreaType2PC ...
                obj.modelResultsHandle.AreaType3PC obj.modelResultsHandle.AreaType0PC obj.modelResultsHandle.AreaNoneObjPC];
            
            B(B==0) = 0.01; % Values of 0 cause an Error
            
            hPie = pie(B);
            
            set(hPie(1),'facecolor',ColorMap(1,:));
            set(hPie(3),'facecolor',ColorMap(2,:));
            set(hPie(5),'facecolor',ColorMap(3,:));
            set(hPie(7),'facecolor',ColorMap(4,:));
            set(hPie(9),'facecolor',ColorMap(5,:));
            
            title('Area of fiber types','FontSize',16)
            l(2) = legend('Type 1','Type 2','Type 3','Type 0','No objects','Location','Best');
            set(l(2),'Tag','LegendAreaPlot');
            
            % Plot Scatter Classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.modelResultsHandle.InfoMessage = '      - plot scatter...';
            
            %clear axes
            cla(obj.viewResultsHandle.hAScatter)
            axes(obj.viewResultsHandle.hAScatter);
            
            % Type 1 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT1)
                x = 0;
                y = 0;
                hScat(1) = scatter(x,y,0.1,'b','Marker','none');
            else
                x = obj.modelResultsHandle.StatsMatDataT1(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT1(:,12); %meanBlue Values
                hScat(1) = scatter(x,y,20,'b');
            end
            
            
            hold on
            
            % Type 2 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT2)
                x = 0;
                y = 0;
                hScat(2) = scatter(x,y,0.1,'r','Marker','none');
            else
                x = obj.modelResultsHandle.StatsMatDataT2(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT2(:,12); %meanBlue Values
                hScat(2) = scatter(x,y,20,'r');
            end
            
            
            % Type 3 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT3)
                x = 0;
                y = 0;
                hScat(3) = scatter(x,y,0.1,'m','Marker','none');
            else
                x = obj.modelResultsHandle.StatsMatDataT3(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT3(:,12); %meanBlue Values
                hScat(3) = scatter(x,y,20,'m');
            end
            
            
            ylabel('mean Blue','FontSize',12);
            xlabel('mean Red','FontSize',12);
            xlim([0 Inf] );
            ylim([0 Inf] );
            
            if obj.modelResultsHandle.AnalyzeMode == 1
                title('ScatterPlot Color-Distance Classification','FontSize',16);
                
                Rmax = max(obj.modelResultsHandle.StatsMatDataT2(:,10));
                
                if isempty(Rmax)
                    % if Rmax is empty (no Red Fibers detected) Rmax is the
                    % largest Red Value of all fibers
                    Rmax = max(obj.modelResultsHandle.StatsMatData(:,10));
                end
                
                if obj.modelResultsHandle.ColorDistanceActive
                    ColorDis = obj.modelResultsHandle.MinColorDistance;
                    if ColorDis == 1
                        % ColorDis of 1 would create a pole in 
                        % R(B) = R/(1-ColorDis)
                        ColorDis = 0.999;
                        Rmax = max(obj.modelResultsHandle.StatsMatData(:,10));
                    end
                else
                    ColorDis = 0;
                end
                
                R = [0:Rmax/10:Rmax];
                B = R/(1-ColorDis);
                if B(end) > 255
                    ylim([0 255] );
                end
                
                plot(R,B,'b');
                text1 = ['B(R) = R/(1-' num2str(ColorDis) ')'];
                legendText1 = char({'Upper limit color Distance' text1});
                
                R = [0:Rmax/10:Rmax];
                B = (1-ColorDis)*R;
                plot(R,B,'r');
                text2 = ['B(R) = R*(1-' num2str(ColorDis) ')'];
                legendText2 = char({'Lower limit color Distance' text2});
%                 text(R(end-2),B(end-2),['\rightarrow B(R) = R*(1-' num2str(ColorDis) ')'],'HorizontalAlignment','left')
                
                l(3) = legend('Type 1','Type 2','Type 3',legendText1,...
                    legendText2,'Location','Best');
                set(l(3),'Tag','LegendScatterPlot');
                
                
            elseif obj.modelResultsHandle.AnalyzeMode == 2
                title('ScatterPlot Color-Cluster Classification, 2 Clusters','FontSize',16);
                l(3) = legend('Type 1','Type 2','Location','Best');
                set(l(3),'Tag','LegendScatterPlot');
            elseif obj.modelResultsHandle.AnalyzeMode == 3
                title('ScatterPlot Color-Cluster Classification, 3 Clusters','FontSize',16);
                l(3) = legend('Type 1','Type 2','Type 3','Location','Best');
                set(l(3),'Tag','LegendScatterPlot');
            end
            grid on
            hold off
            
            
            % Plot Scatter All objects plot
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cla(obj.viewResultsHandle.hAScatterAll);
            axes(obj.viewResultsHandle.hAScatterAll);
            
            % Type 1 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT1)
                x = 0;
                y = 0;
                z = 0;
                hScatAll(1) = scatter3(x,y,z,0.1,'b','Marker','none');
            else
                x = obj.modelResultsHandle.StatsMatDataT1(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT1(:,12); %meanBlue Values
                z = obj.modelResultsHandle.StatsMatDataT1(:,13); %meanFarRed Values
                hScatAll(1) = scatter3(x,y,z,20,'b');
            end
            
            
            hold on
            
            % Type 2 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT2)
                x = 0;
                y = 0;
                z = 0;
                hScatAll(2) = scatter3(x,y,0.1,'r','Marker','none');
            else
                x = obj.modelResultsHandle.StatsMatDataT2(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT2(:,12); %meanBlue Values
                z = obj.modelResultsHandle.StatsMatDataT2(:,13); %meanFarRed Values
                hScatAll(2) = scatter3(x,y,z,20,'r');
            end
            
            
            % Type 3 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT3)
                x = 0;
                y = 0;
                z = 0;
                hScatAll(3) = scatter3(x,y,0.1,'m','Marker','none');
            else
                x = obj.modelResultsHandle.StatsMatDataT3(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT3(:,12); %meanBlue Values
                z = obj.modelResultsHandle.StatsMatDataT3(:,13); %meanFarRed Values
                hScatAll(3) = scatter3(x,y,z,20,'m');
            end
            
            % Type 0 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT0)
                x = 0;
                y = 0;
                z = 0;
                hScatAll(4) = scatter3(x,y,0.1,'k','Marker','none');
            else
                x = obj.modelResultsHandle.StatsMatDataT0(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT0(:,12); %meanBlue Values
                z = obj.modelResultsHandle.StatsMatDataT0(:,13); %meanFarRed Values
                hScatAll(4) = scatter3(x,y,z,20,'k');
            end
            
            ylabel('mean Blue','FontSize',12);
            xlabel('mean Red','FontSize',12);
            zlabel('mean FarRed','FontSize',12);
            xlim([0 Inf] );
            ylim([0 Inf] );
            zlim([0 Inf] );
            title('ScatterPlot all Objects (Type 1,2,3,0)','FontSize',16);
            grid on
            hold off
            l(4) = legend('Type 1','Type 2','Type 3','Type 0 (no fiber)',...
                    'Location','Best');
                set(l(4),'Tag','LegendScatterAllPlot');
            obj.modelResultsHandle.InfoMessage = '   - plot data into GUI complete';
        end
        
        function showPicProcessedGUI(obj)
            % Shows the proceesed images ande the color plane image in the  
            % corresponding axes in the GUI. 
            %
            %   showPicProcessedGUI(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerResults object.
            %
            
            obj.modelResultsHandle.InfoMessage = '   - load images into GUI';
            
            %Show proccesd image
            % get axes in the analyze GUI with rgb image
            axesPicAnalyze = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hAP;
            % get axes in the results GUI
            axesResults = obj.viewResultsHandle.hAPProcessed;
            % copy axes childs from analyze to results GUI
            obj.modelResultsHandle.showPicProcessedGUI(axesPicAnalyze,axesResults);
            
            obj.modelResultsHandle.InfoMessage = '      - load color plane into GUI...';
            %Show color-plane image 
            %make axes for color plane the current axes
            axes(obj.viewResultsHandle.hAPColorPlane);
            %show image
            imshow(obj.modelResultsHandle.PicPRGBPlanes);
            
            obj.modelResultsHandle.InfoMessage = '   - load images complete';
            
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
            pause(0.05)
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
            
            choice = questdlg({'Are you sure you want to open a new picture? ','All unsaved data will be lost.'},...
                'Close Program', ...
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
            obj.modelResultsHandle.FileNamesRGB = [];
            obj.modelResultsHandle.PathNames = [];
            obj.modelResultsHandle.PicRGB = [];
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
            obj.modelResultsHandle.ColorDistanceActive = [];
            obj.modelResultsHandle.MinColorDistance = [];
            obj.modelResultsHandle.ColorValueActive = [];
            obj.modelResultsHandle.ColorValue = [];
            
            % Clear PicRGB and Boundarie Objects if exist
            if isfield(obj.modelResultsHandle.handlePicRGB,'Parent')
                handleChild = allchild(obj.modelResultsHandle.handlePicRGB.Parent);
                delete(handleChild);
            end
            
            % Clear PicColorPlane if exist
            if ~isempty(obj.viewResultsHandle.hAPColorPlane.Children)
                handleChild = allchild(obj.viewResultsHandle.hAPColorPlane);
                delete(handleChild);
            end
            
            % Clear area plot if exist
            if ~isempty(obj.viewResultsHandle.hAArea.Children)
                handleChild = allchild(obj.viewResultsHandle.hAArea);
                delete(handleChild);
            end
            
            % Clear count plot if exist
            if ~isempty(obj.viewResultsHandle.hACount.Children)
                handleChild = allchild(obj.viewResultsHandle.hACount);
                delete(handleChild);
            end
            
            % Clear scatter plot if exist
            if ~isempty(obj.viewResultsHandle.hAScatter.Children)
                handleChild = allchild(obj.viewResultsHandle.hAScatter);
                delete(handleChild);
            end
            
            % Clear scatter all plot if exist
            if ~isempty(obj.viewResultsHandle.hAScatterAll.Children)
                handleChild = allchild(obj.viewResultsHandle.hAScatterAll);
                delete(handleChild);
            end
            
            %Delete Legends
            lTemp = findobj('Tag','LegendAreaPlot');
            delete(lTemp);
            lTemp = findobj('Tag','LegendNumberPlot');
            delete(lTemp);
            lTemp = findobj('Tag','LegendScatterPlot');
            delete(lTemp);
            lTemp = findobj('Tag','LegendScatterAllPlot');
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
            choice = questdlg({'Are you sure you want to quit? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            
            switch choice
                case 'Yes'
                    
                    delete(obj.viewResultsHandle);
                    delete(obj.modelResultsHandle);
                    delete(obj.mainCardPanel);
                    
                    figHandles = findall(0,'Type','figure');
                    object_handles = findall(figHandles);
                    delete(object_handles);
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

