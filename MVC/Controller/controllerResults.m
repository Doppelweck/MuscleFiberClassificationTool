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
            %           InfoText:   Info text log.
            %
            
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

            set(obj.viewResultsHandle.B_InfoText, 'String', InfoText);
            set(obj.viewResultsHandle.B_InfoText, 'Value' , length(obj.viewResultsHandle.B_InfoText.String));
            
            % set panel title to filename and path
            Titel = [obj.modelResultsHandle.PathName obj.modelResultsHandle.FileName];
            obj.viewResultsHandle.panelResults.Title = Titel;
            
           
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
            
            %show results data in the GUI
            obj.modelResultsHandle.startResultMode();
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','on');
            set(obj.viewResultsHandle.B_Save,'Enable','on');
            set(obj.viewResultsHandle.B_NewPic,'Enable','on');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','on');
            
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
            obj.modelResultsHandle.SaveScatterAll = obj.viewResultsHandle.B_SaveScatterAll.Value;
            obj.modelResultsHandle.SavePlots = obj.viewResultsHandle.B_SavePlots.Value;
            obj.modelResultsHandle.SavePicRGBFRProcessed = obj.viewResultsHandle.B_SavePicRGBFRProc.Value;
            obj.modelResultsHandle.SavePicRGBProcessed = obj.viewResultsHandle.B_SavePicRGBProc.Value;
            
            obj.busyIndicator(1);
            if ( obj.modelResultsHandle.SaveFiberTable || ...
                 obj.modelResultsHandle.SaveScatterAll || ...
                 obj.modelResultsHandle.SavePlots || ...
                 obj.modelResultsHandle.SavePicRGBFRProcessed || ...
                 obj.modelResultsHandle.SavePicRGBProcessed)
                    
                
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
            obj.busyIndicator(0);
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
            obj.viewResultsHandle.B_TableMain.RowName = [];
            obj.viewResultsHandle.B_TableMain.ColumnName = {'Label' sprintf('Area (\x3BCm^2)')...
                'XPos (pixel)' 'YPos (pixel)' sprintf('MajorAxis (\x3BCm)') sprintf('MinorAxis (\x3BCm)') 'Perimeter' 'Roundness' ...
                'AspectRatio' 'ColorHue' 'ColorValue' 'meanRed' 'meanGreen' ...
                'meanBlue' 'meanFarred' 'Blue/Red' 'Farred/Red'...
                'FiberMainGroup' 'FiberType'};
            obj.viewResultsHandle.B_TableMain.Data = obj.modelResultsHandle.StatsMatData;
            
            obj.viewResultsHandle.B_TableStatistic.RowName = [];
            obj.viewResultsHandle.B_TableStatistic.ColumnName = {'Name of parameter                   ','Value of parameter                   '};
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
            ColorMap(1,:) = [51 51 255]; % Blue Fiber Type 1
            ColorMap(2,:) = [255 51 255]; % Magenta Fiber Type 12h
            ColorMap(3,:) = [255 51 51]; % Red Fiber Type 2x
            ColorMap(4,:) = [255 255 51]; % Yellow Fiber Type 2a
            ColorMap(5,:) = [255 153 51]; % orange Fiber Type 2ax
            ColorMap(6,:) = [224 224 224]; % Grey Fiber Type undifiend
            ColorMap(7,:) = [51 255 51]; % Green Collagen
            ColorMap = ColorMap/255;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Plot Count Numbers in Axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.modelResultsHandle.InfoMessage = '      - plot number of types...';

            
            B = [obj.modelResultsHandle.NoTyp1 obj.modelResultsHandle.NoTyp12h ...
                obj.modelResultsHandle.NoTyp2x obj.modelResultsHandle.NoTyp2a ...
                obj.modelResultsHandle.NoTyp2ax obj.modelResultsHandle.NoTyp0];
            
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
            
            set(gca,'XTickLabel',{'Type 1','Type 12h','Type 2x','Type 2a','Type 2ax','undefind'},'FontSize', 12);
            set(gca,'XTick',[1 2 3 4 5 6]);
            ylabel('Numbers');
            title('Number of fiber types','FontSize',16)
            l(1) = legend('Type 1','Type 12h','Type 2x','Type 2a','Type 2ax','undefind',...
                    'Location','Best');
            set(l(1),'Tag','LegendNumberPlot');
            grid on
            hold off
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Plot Area in Axes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.modelResultsHandle.InfoMessage = '      - plot area...';
            
            % make Axes for Count Data the current Axes
            cla(obj.viewResultsHandle.hAArea)
            axes(obj.viewResultsHandle.hAArea);
            
            
            B = [obj.modelResultsHandle.AreaType1PC obj.modelResultsHandle.AreaType12hPC ...
                obj.modelResultsHandle.AreaType2xPC obj.modelResultsHandle.AreaType2aPC ...
                obj.modelResultsHandle.AreaType2axPC obj.modelResultsHandle.AreaType0PC ...
                obj.modelResultsHandle.AreaNoneObjPC];
            
%             B(B==0) = 0.001; % Values of 0 cause an Error
            
            hPie = pie(B);
            
            No = length(B);
            z =~(B == 0);
            j = 1:2:2*No;
            index = 0;
            for i = 1:No
                if(z(i) ~= 0)
                    index = index +1;
                    set(hPie(j(index)),'facecolor',ColorMap(i,:))
                end
            end
            
            StringLegend = {'Type 1','Type 12h','Type 2x','Type 2a','Type 2ax','undefind','Collagen'};
            StringLegend(z==0)=[];
            
            title('Area of fiber types','FontSize',16)
            l(2) = legend(StringLegend,...
                    'Location','Best');
            set(l(2),'Tag','LegendAreaPlot');
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Plot Scatter Blue/Red Classification %%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.modelResultsHandle.InfoMessage = '      - plot scatter...';
            
            %clear axes
            cla(obj.viewResultsHandle.hAScatterBlueRed)
            axes(obj.viewResultsHandle.hAScatterBlueRed);
            
            % Type 1 Fibers (blue)
            if isempty(obj.modelResultsHandle.StatsMatDataT1)
                x = 0;
                y = 0;
                hScat(1) = scatter(x,y,0.1,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(1,:),'Marker','none');
            else
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,12)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,14)); %meanBlue Values
                hScat(1) = scatter(x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(1,:)); 
            end
            
            
            hold on
            
            % Type 12h Fibers (magenta)
            if isempty(obj.modelResultsHandle.StatsMatDataT12h)
                x = 0;
                y = 0;
                hScat(2) = scatter(x,y,0.1,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(2,:),'Marker','none');
            else
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,12)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,14)); %meanBlue Values
                hScat(2) = scatter(x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(2,:));
            end
            
            
            % Type 2x Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT2x)
                x = 0;
                y = 0;
                hScat(3) = scatter(x,y,0.1,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(3,:),'Marker','none');
            else
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,12)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,14)); %meanBlue Values
                hScat(3) = scatter(x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(3,:));
            end
            
            % Type 2a Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT2a)
                x = 0;
                y = 0;
                hScat(3) = scatter(x,y,0.1,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(4,:),'Marker','none');
            else
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,12)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,14)); %meanBlue Values
                hScat(3) = scatter(x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(4,:));
            end
            
            % Type 2ax Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT2ax)
                x = 0;
                y = 0;
                hScat(3) = scatter(x,y,0.1,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(5,:),'Marker','none');
            else
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,12)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,14)); %meanBlue Values
                hScat(3) = scatter(x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(5,:));
            end
            
            ylabel('y: mean Blue (B)','FontSize',12);
            xlabel('x: mean Red (R)','FontSize',12);
            xlim([0 Inf] );
            ylim([0 Inf] );
            
            if obj.modelResultsHandle.AnalyzeMode == 1 || obj.modelResultsHandle.AnalyzeMode == 2
                % Color-Based Classification
                
                %find max Red value of all Type 2 fibers
                Rmax1 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,12)));
                Rmax2 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,12)));
                Rmax3 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,12)));
                Rmax = max([Rmax1,Rmax2,Rmax3]);
                
                if isempty(Rmax)
                    % if Rmax is empty (no Red Fibers detected) Rmax is the
                    % largest Red Value of all fibers
                    Rmax = max(obj.modelResultsHandle.StatsMatData(:,12));
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
                    
                    
                    
 
                    plot(R,f_Bdist,'b');
                    text1 = ['f_{Bdist}(R) = ' num2str(BlueRedTh) ' * R / (1-' num2str(BlueRedDistB) ')'];

                    plot(R,f_Rdist,'r');
                    text2 = ['f_{Rdist}(R) = ' num2str(BlueRedTh) ' * R * (1-' num2str(BlueRedDistR) ')'];
                    
                    plot(R,f_BRthresh,'k');
                    text3 = ['f_{BRthresh}(R) = ' num2str(BlueRedTh) ' * R'];
                    %                 text(R(end-2),B(end-2),['\rightarrow B(R) = R*(1-' num2str(ColorDis) ')'],'HorizontalAlignment','left')
                    
                    l(3) = legend('Type 1','Type 12h','Type 2x','Type 2a','Type 2ax',text1,...
                        text2,text3,'Location','Best');
                    set(l(3),'Tag','LegendScatterPlotBlueRed');
                    
%                     title({'Color-Based Classification triple labeling'},'FontSize',16);
                    
                else
                    BlueRedTh = 1;
                    BlueRedDistB = 0;
                    BlueRedDistR = 0;
                    f_BRthresh =  BlueRedTh * R; %Blue/Red thresh fcn
                    plot(R,f_BRthresh,'k');
                    text1 = ['BRthresh(R) = ' num2str(BlueRedTh) ' * R )'];
                    l(3) = legend('Type 1','Type 12h','Type 2x','Type 2a','Type 2ax',text1,'Location','Best');
                    set(l(3),'Tag','LegendScatterPlotBlueRed');
                end
                
                if obj.modelResultsHandle.AnalyzeMode == 1
                    title({'Color-Based Classification triple labeling'},'FontSize',16);
                elseif obj.modelResultsHandle.AnalyzeMode == 2
                    title({'Color-Based Classification quad labeling'},'FontSize',16);
                end
                
                
                maxBlueValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,14)));
                maxRedValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,12)));
                maxLim =  max([maxBlueValue maxRedValue])+50;
                
                ylim([ 0 maxLim ] );
                xlim([ 0 maxLim ] );
                set(gca,'xtick',[0:20:maxLim*2]);
                set(gca,'ytick',[0:20:maxLim*2]);
                
            elseif obj.modelResultsHandle.AnalyzeMode == 3
                title('ScatterPlot Color-Cluster Classification, 2 Clusters','FontSize',16);
                l(3) = legend('Type 1','Type 2','Location','Best');
            elseif obj.modelResultsHandle.AnalyzeMode == 4
                title('ScatterPlot Color-Cluster Classification, 3 Clusters','FontSize',16);
                l(3) = legend('Type 1','Type 2','Type 3','Location','Best');
            end
            
            grid on
            hold off
            

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Scatter Plot Farred/Red Classification %%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            cla(obj.viewResultsHandle.hAScatterFarredRed);
            axes(obj.viewResultsHandle.hAScatterFarredRed);
            
            hold on
            % Type 2x Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT2x)
                x = 0;
                y = 0;
                hScatFRR(1) = scatter(x,y,0.1,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(3,:),'Marker','none');
            else
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,12)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,15)); %meanFarred Values
                hScatFRR(1) = scatter(x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(3,:));

            end
            
            % Type 2a Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT2a)
                x = 0;
                y = 0;
                hScatFRR(2) = scatter(x,y,0.1,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(4,:),'Marker','none');
            else
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,12)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,15)); %meanFarred Values
                hScatFRR(2) = scatter(x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(4,:));
            end
            
            % Type 2ax Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT2ax)
                x = 0;
                y = 0;
                hScatFRR(3) = scatter(x,y,0.1,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(5,:),'Marker','none');
            else
                x = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,12)); %meanRed Values
                y = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,15)); %meanFarred Values
                hScatFRR(3) = scatter(x,y,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(5,:));
            end
            hold on
            
            ylabel('y: mean Farred(FR)','FontSize',12);
            xlabel('x: mean Red (R)','FontSize',12);
            
            
            if obj.modelResultsHandle.AnalyzeMode == 1 || obj.modelResultsHandle.AnalyzeMode == 2
                % Color-Based Classification
                
                Rmax1 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,12)));
                Rmax2 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,12)));
                Rmax3 = max(cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,12)));
                
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
                
                

                plot(R,f_FRdist,'y');
                text1 = ['f_{Bdist}(R) = ' num2str(FarredRedTh) ' * R / (1-' num2str(FarredRedDistFR) ')'];

                plot(R,f_Rdist,'r');
                text2 = ['f_{Rdist}(R) = ' num2str(FarredRedTh) ' * R * (1-' num2str(FarredRedDistR) ')'];
                
                plot(R,f_FRRthresh,'k');
                text3 = ['f_{BRthresh}(R) = ' num2str(FarredRedTh) ' * R'];

%                 text(R(end-2),B(end-2),['\rightarrow B(R) = R*(1-' num2str(ColorDis) ')'],'HorizontalAlignment','left')
                
                l(4) = legend('Type 2x','Type 2a','Type 2ax',text1,...
                    text2,text3,'Location','Best');
                    set(l(4),'Tag','LegendScatterPlotFarredRed');
                else
                    l(4) = legend('Type 2x','Location','Best');
                    set(l(4),'Tag','LegendScatterPlotFarredRed');
                end
                
                maxFarredValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,15)));
                maxRedValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,12)));
                maxLim =max([maxFarredValue maxRedValue])+50;
                
                ylim([ 0 maxLim ] );
                xlim([ 0 maxLim ] );
                set(gca,'xtick',[0:20:maxLim*2]);
                set(gca,'ytick',[0:20:maxLim*2]);
                
                if obj.modelResultsHandle.AnalyzeMode == 1
                    title({'Color-Based Classification triple labeling'},'FontSize',16);
                elseif obj.modelResultsHandle.AnalyzeMode == 2
                    title({'Color-Based Classification quad labeling'},'FontSize',16);
                end
                
                grid on
                hold off
                
            
            else
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Scatter Plot all Fiber objects %%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cla(obj.viewResultsHandle.hAScatterAll);
            axes(obj.viewResultsHandle.hAScatterAll);
            
            
            x = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,12)); %meanRed Values
            y = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,14)); %meanBlue Values
            z = cell2mat(obj.modelResultsHandle.StatsMatDataT1(:,15)); %meanFarred Values
            scatter3(x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(1,:));
            hold on
            x = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,12)); %meanRed Values
            y = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,14)); %meanBlue Values
            z = cell2mat(obj.modelResultsHandle.StatsMatDataT12h(:,15)); %meanFarred Values
            scatter3(x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(2,:));
            hold on
            x = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,12)); %meanRed Values
            y = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,14)); %meanBlue Values
            z = cell2mat(obj.modelResultsHandle.StatsMatDataT2x(:,15)); %meanFarred Values
            scatter3(x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(3,:));
            hold on
            x = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,12)); %meanRed Values
            y = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,14)); %meanBlue Values
            z = cell2mat(obj.modelResultsHandle.StatsMatDataT2a(:,15)); %meanFarred Values
            scatter3(x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(4,:));
            hold on
            x = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,12)); %meanRed Values
            y = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,14)); %meanBlue Values
            z = cell2mat(obj.modelResultsHandle.StatsMatDataT2ax(:,15)); %meanFarred Values
            scatter3(x,y,z,20,'MarkerEdgeColor','k','MarkerFaceColor',ColorMap(5,:));
            hold on
            title({'Scatter Plot all Fiber Types'},'FontSize',16);
            hold on
            l(5) = legend('Type 1','Type 12h','Type 2x','Type 2a','Type 2ax','Location','Best');
            set(l(5),'Tag','LegendScatterPlotAll');
            hold on
            zlabel('z: mean Farred','FontSize',12);
            ylabel('y: mean Blue','FontSize',12);
            xlabel('x: mean Red','FontSize',12);
            
            maxBlueValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,14)));
            maxRedValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,12)));
            maxFarredValue = max(cell2mat(obj.modelResultsHandle.StatsMatData(:,15)));
            
            maxLim = max([maxFarredValue maxRedValue maxBlueValue])+50;
            
            ylim([ 0 maxLim ] );
            xlim([ 0 maxLim ] );
            zlim([ 0 maxLim ] );
            set(gca,'xtick',[0:20:maxLim*2]);
            set(gca,'ytick',[0:20:maxLim*2]);
            set(gca,'ztick',[0:20:maxLim*2]);
            
            grid on
            hold off
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
            obj.modelResultsHandle.InfoMessage = '      - load RGB image with Farred plane';
            
            %Show proccesd image with all planes
            % get axes in the analyze GUI with rgb image
            axesPicAnalyze = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hAP;
            %get boundaries
            hBounds = findobj(axesPicAnalyze,'Type','hggroup');
            
            % get axes in the results GUI
            axesResultsRGBFR = obj.viewResultsHandle.hAPProcessedRGBFR;
            % show RGB image with farred plane
            axes(axesResultsRGBFR)
            imshow(obj.modelResultsHandle.PicPRGBFRPlanes);
            copyobj(hBounds ,axesResultsRGBFR);
            hold on
            %Show labels
            obj.modelResultsHandle.InfoMessage = '         - show labels...';
            
            %plot labels in the image
            for k = 1:size(obj.modelResultsHandle.Stats,1)
                hold on
                c = obj.modelResultsHandle.Stats(k).Centroid;
                text(c(1), c(2), sprintf('%d', k),'Color','g', ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'middle','FontSize',11);
            end
            axis image
            axis on
            hold off
            
            obj.modelResultsHandle.InfoMessage = '      - load RGB image without Farred plane';
            % get axes in the results GUI
            axesResultsRGBFR = obj.viewResultsHandle.hAPProcessedRGB;
            % show RGB image with farred plane
            axes(axesResultsRGBFR)
            imshow(obj.modelResultsHandle.PicPRGBPlanes);
            copyobj(hBounds ,axesResultsRGBFR);
            hold on
            %Show labels
            obj.modelResultsHandle.InfoMessage = '         - show labels...';
            
            %plot labels in the image
            for k = 1:size(obj.modelResultsHandle.Stats,1)
                hold on
                c = obj.modelResultsHandle.Stats(k).Centroid;
                text(c(1), c(2), sprintf('%d', k),'Color','g', ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'middle','FontSize',11);
            end
            axis image
            axis on
            hold off
            
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
            if ~isempty(obj.viewResultsHandle.hAPProcessedRGBFR.Children)
                handleChild = allchild(obj.viewResultsHandle.hAPProcessedRGBFR);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAPProcessedRGBFR);
            end
            
            % Clear PicRGB and Boundarie Objects if exist
            if ~isempty(obj.viewResultsHandle.hAPProcessedRGB.Children)
                handleChild = allchild(obj.viewResultsHandle.hAPProcessedRGB);
                delete(handleChild);
                reset(obj.viewResultsHandle.hAPProcessedRGB);
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
            
            %Delete Legends
            lTemp = findobj('Tag','LegendAreaPlot');
            delete(lTemp);
            lTemp = findobj('Tag','LegendNumberPlot');
            delete(lTemp);
            lTemp = findobj('Tag','LegendScatterPlotBlueRed');
            delete(lTemp);
            lTemp = findobj('Tag','LegendScatterPlotFarredRed');
            delete(lTemp);
            lTemp = findobj('Tag','LegendScatterAll');
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
        
        function busyIndicator(obj,status)
            % See: http://undocumentedmatlab.com/blog/animated-busy-spinning-icon
            
            
            if status
                %create indicator object and disable GUI elements
                
                figHandles = findobj('Type','figure');
                set(figHandles,'pointer','watch');
                %find all objects that are enabled and disable them
                obj.modelResultsHandle.busyObj = findall(figHandles, '-property', 'Enable','-and','Enable','on',...
                    '-and','-not','style','listbox','-and','-not','style','text');
                set( obj.modelResultsHandle.busyObj, 'Enable', 'off')
                
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

