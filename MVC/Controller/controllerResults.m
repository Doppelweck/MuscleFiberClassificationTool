classdef controllerResults < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mainFigure;
        mainCardPanel;
        viewResultsHandle;
        modelResultsHandle;
        controllerAnalyzeHandle;
    end
    
    methods
        function obj = controllerResults(mainFigure,mainCardPanel,viewResultsHandle,modelResultsHandle)
            
            obj.mainFigure =mainFigure;
            obj.mainCardPanel =mainCardPanel;
            
            obj.viewResultsHandle = viewResultsHandle;
            
            obj.modelResultsHandle = modelResultsHandle;
            
            obj.addMyCallback();
            
            obj.addMyListener();
        end
        
        function addMyCallback(obj)
%             set(obj.viewResultsHandle.hFR,'CloseRequestFcn',@obj.closeProgramEvent);
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Callback',@obj.backAnalyzeEvent);
            set(obj.viewResultsHandle.B_Save,'Callback',@obj.saveResultsEvent);
            set(obj.viewResultsHandle.B_NewPic,'Callback',@obj.newPictureEvent);
            set(obj.viewResultsHandle.B_CloseProgramm,'Callback',@obj.closeProgramEvent);
            set(obj.viewResultsHandle.B_SaveOpenDir,'Callback',@obj.openSaveDirectory);
        end
        
        function addWindowCallbacks(obj)
            set(obj.mainFigure,'WindowButtonMotionFcn','');
            set(obj.mainFigure,'ButtonDownFcn','');
%             set(obj.modelAnalyzeHandle.handlePicRGB,'ButtonDownFcn',@obj.manipulateFiberShowInfoEvent);
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);

        end
        
        function addMyListener(obj)
            addlistener(obj.modelResultsHandle,'InfoMessage', 'PostSet',@obj.updateInfoLogEvent);
        end
        
        function startResultsMode(obj,Data,InfoText)
%              set(obj.controllerAnalyzeHandle.viewAnalyzeHandle.hFP,'Visible','off');
            % Get all Data from AnalyzeController and save it in the
            % ResultModel properties
            obj.modelResultsHandle.FileNamesRGB = Data{1};
            obj.modelResultsHandle.PathNames = Data{2};
            obj.modelResultsHandle.PicRGB = Data{3};
            obj.modelResultsHandle.PicPRGBPlanes = Data{4};
            obj.modelResultsHandle.Stats = Data{5};
            obj.modelResultsHandle.LabelMat = Data{6};
            
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
            
            Titel = [obj.modelResultsHandle.PathNames obj.modelResultsHandle.FileNamesRGB];
            obj.viewResultsHandle.panelResults.Title = Titel;
            
           
%             set(obj.viewResultsHandle.hFR,'Visible','on');
%             figure(obj.viewResultsHandle.hFR);

            obj.mainCardPanel.Selection = 3;
            obj.addWindowCallbacks()
            
            obj.modelResultsHandle.InfoMessage = '*** Start Result mode ***';
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','off');
            set(obj.viewResultsHandle.B_Save,'Enable','off');
            set(obj.viewResultsHandle.B_NewPic,'Enable','off');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','off');
            set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','off');

            obj.modelResultsHandle.startResultMode();
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','on');
            set(obj.viewResultsHandle.B_Save,'Enable','on');
            set(obj.viewResultsHandle.B_NewPic,'Enable','on');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','on');
%             figure(obj.viewResultsHandle.hFR);
            
        end
        
        function backAnalyzeEvent(obj,~,~)
            
%             set(obj.viewResultsHandle.hFR,'Visible','off');
            
            
            obj.modelResultsHandle.InfoMessage = ' ';
            
            %clear Data
            obj.modelResultsHandle.Stats = [];
            obj.modelResultsHandle.LabelMat = [];
            obj.viewResultsHandle.B_TableMain.Data = {};
            obj.viewResultsHandle.B_TableStatistic.Data = {};
            
            % clear all axes in viewResult figure
            arrayfun(@cla,findall(obj.viewResultsHandle.hFR,'type','axes'))
            
            % Clear PicRGB and Boundarie Objects if exist
            if isfield(obj.modelResultsHandle.handlePicRGB,'Parent')
                handleChild = allchild(obj.modelResultsHandle.handlePicRGB.Parent);
                delete(handleChild);
            end
            
            % set log text from Result GUI to Analyze GUI
            obj.controllerAnalyzeHandle.setInfoTextView(get(obj.viewResultsHandle.B_InfoText, 'String'));
            
%             set(obj.controllerAnalyzeHandle.viewAnalyzeHandle.hFP,'Visible','on');
%             figure(obj.controllerAnalyzeHandle.viewAnalyzeHandle.hFP);
            
            obj.mainCardPanel.Selection = 2;
            obj.controllerAnalyzeHandle.addWindowCallbacks()
            obj.controllerAnalyzeHandle.modelAnalyzeHandle.InfoMessage = '*** Back to Analyze mode ***';
        end
        
        function saveResultsEvent(obj,~,~)
            
            obj.modelResultsHandle.SaveFiberTable = obj.viewResultsHandle.B_SaveFiberTable.Value;
            obj.modelResultsHandle.SaveStatisticTable = obj.viewResultsHandle.B_SaveStatisticTable.Value;
            obj.modelResultsHandle.SavePlots = obj.viewResultsHandle.B_SavePlots.Value;
            obj.modelResultsHandle.SavePicProcessed = obj.viewResultsHandle.B_SaveAnaPicture.Value;
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','off');
            set(obj.viewResultsHandle.B_Save,'Enable','off');
            set(obj.viewResultsHandle.B_NewPic,'Enable','off');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','off');
            set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','off');
            
            obj.modelResultsHandle.saveResults();
            
            set(obj.viewResultsHandle.B_BackAnalyze,'Enable','on');
            set(obj.viewResultsHandle.B_Save,'Enable','on');
            set(obj.viewResultsHandle.B_NewPic,'Enable','on');
            set(obj.viewResultsHandle.B_CloseProgramm,'Enable','on');
            set(obj.viewResultsHandle.B_SaveOpenDir,'Enable','on');
            
        end
        
        function showInfoInTableGUI(obj)
            obj.viewResultsHandle.B_TableMain.Data = obj.modelResultsHandle.StatsMatData;
            
            obj.viewResultsHandle.B_TableStatistic.Data = obj.modelResultsHandle.StatisticMat;
        end
        
        function showAxesDataInGUI(obj)
            
            obj.modelResultsHandle.InfoMessage = '   - Plot data into GUI axes...';
            
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
            legend('Type 1','Type 2','Type 3','Type 0','No Objects','Location','bestoutside');
            
            % Plot Scatter Classification %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.modelResultsHandle.InfoMessage = '      - plot scatter...';
            
            cla(obj.viewResultsHandle.hAScatter)
            axes(obj.viewResultsHandle.hAScatter);
            
            % Type 1 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT1)
                x = 0;
                y = 0;
                hScat(1) = scatter(x,y,0.1,'b');
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
                hScat(2) = scatter(x,y,0.1,'r');
            else
                x = obj.modelResultsHandle.StatsMatDataT2(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT2(:,12); %meanBlue Values
                hScat(2) = scatter(x,y,20,'r');
            end
            
            
            % Type 3 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT3)
                x = 0;
                y = 0;
                hScat(3) = scatter(x,y,0.1,'m');
            else
                x = obj.modelResultsHandle.StatsMatDataT3(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT3(:,12); %meanBlue Values
                hScat(3) = scatter(x,y,20,'m');
            end
            
            
            ylabel('mean Blue --->','FontSize',12);
            xlabel('mean Red --->','FontSize',12);
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
                legendText1 = char({'Upper limit color Distance', text1});
                
                R = [0:Rmax/10:Rmax];
                B = (1-ColorDis)*R;
                plot(R,B,'r');
                text2 = ['B(R) = R*(1-' num2str(ColorDis) ')'];
                legendText2 = char({'Lower limit color Distance', text2});
%                 text(R(end-2),B(end-2),['\rightarrow B(R) = R*(1-' num2str(ColorDis) ')'],'HorizontalAlignment','left')
                
                legend('Type 1','Type 2','Type 3',legendText1,...
                    legendText2,'Location','Best');
                
                
                
            elseif obj.modelResultsHandle.AnalyzeMode == 2
                title('ScatterPlot Color-Cluster Classification, 2 Clusters','FontSize',16);
                legend('Type 1','Type 2','Location','Best')
            elseif obj.modelResultsHandle.AnalyzeMode == 3
                title('ScatterPlot Color-Cluster Classification, 3 Clusters','FontSize',16);
                legend('Type 1','Type 2','Type 3','Location','Best')
            end
            grid on
            hold off
            
            
            % Plot 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            cla(obj.viewResultsHandle.hAScatterAll);
            axes(obj.viewResultsHandle.hAScatterAll);
            
            % Type 1 Fibers
            if isempty(obj.modelResultsHandle.StatsMatDataT1)
                x = 0;
                y = 0;
                z = 0;
                hScatAll(1) = scatter3(x,y,0.1,'b');
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
                hScatAll(2) = scatter3(x,y,0.1,'r');
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
                hScatAll(3) = scatter3(x,y,0.1,'m');
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
                hScatAll(4) = scatter3(x,y,0.1,'k');
            else
                x = obj.modelResultsHandle.StatsMatDataT0(:,10); %meanRed Values
                y = obj.modelResultsHandle.StatsMatDataT0(:,12); %meanBlue Values
                z = obj.modelResultsHandle.StatsMatDataT0(:,13); %meanFarRed Values
                hScatAll(4) = scatter3(x,y,z,20,'k');
            end
            
            ylabel('mean Blue --->','FontSize',12);
            xlabel('mean Red --->','FontSize',12);
            zlabel('mean FarRed --->','FontSize',12);
            xlim([0 Inf] );
            ylim([0 Inf] );
            zlim([0 Inf] );
            title('ScatterPlot all Objects (Type 1,2,3,0)','FontSize',16);
            grid on
            hold off
            legend('Type 1','Type 2','Type 3','Type 0 (no Fiber)',...
                    'Location','Best');
            obj.modelResultsHandle.InfoMessage = '   - Plot data into GUI complete';
        end
        
        function showPicProcessedGUI(obj)
            axesPicAnalyze = obj.controllerAnalyzeHandle.viewAnalyzeHandle.hAP;
            axesResults = obj.viewResultsHandle.hAPProcessed;
%             copyobj(axesPicAnalyze.Children ,obj.viewResultsHandle.hAPProcessed)
            
%             axes(obj.viewResultsHandle.hAPProcessed)
%             obj.modelResultsHandle.handlePicRGB = imshow(obj.modelResultsHandle.PicRGB);
            obj.modelResultsHandle.showPicProcessedGUI(axesPicAnalyze,axesResults);
        end
        
        function updateInfoLogEvent(obj,src,evnt)
            InfoText = cat(1, get(obj.viewResultsHandle.B_InfoText, 'String'), {obj.modelResultsHandle.InfoMessage});
            set(obj.viewResultsHandle.B_InfoText, 'String', InfoText);
            set(obj.viewResultsHandle.B_InfoText, 'Value' , length(obj.viewResultsHandle.B_InfoText.String));
            drawnow;
            pause(0.05)
        end
        
        function newPictureEvent(obj,~,~)
            choice = questdlg({'Are you sure you want to open a new picture? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            
            switch choice
                case 'Yes'
                obj.backAnalyzeEvent();
                obj.controllerAnalyzeHandle.newPictureEvent;
                case 'No'
                obj.modelResultsHandle.InfoMessage = '   - closing program canceled';
                otherwise
                obj.modelResultsHandle.InfoMessage = '   - closing program canceled';  
            end
        end
        
        function openSaveDirectory(obj,~,~)
            if ~isempty(obj.modelResultsHandle.SavePath)
                
                if ismac
                    obj.modelResultsHandle.InfoMessage = '   - open save directory';
                    path = obj.modelResultsHandle.SavePath;
                    
                    % transforl space char into mac compatible '/ ' char
                    path = strrep(path,' ','\ ');
                    unix(['open ' path]);
                    
                elseif ispc
                    obj.modelResultsHandle.InfoMessage = '   - open save directory';
                else
                    obj.modelResultsHandle.InfoMessage = '   - Error while opening save directory';
                end
            else
                obj.modelResultsHandle.InfoMessage = '   - no data has been saved';
            end
            
        end
        
        function closeProgramEvent(obj,~,~)
            
            choice = questdlg({'Are you sure you want to quit? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            
            switch choice
                case 'Yes'
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
            
        end
    end
end

