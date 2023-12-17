classdef viewResults < handle
    %viewResults   view of the results-MVC (Model-View-Controller).
    %Creates the third card panel in the main figure that shows the results  
    %after the classification. The viewResult class is called by  
    %the main.m file. Contains serveral buttons and uicontrol elements to 
    %select wich data will be saved.
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
        hFR; %handle to figure with Results and controls.
        panelControl; %handle to panel with controls.
        panelResults; %handle to panel with results.
        hAPProcessed; %handle to axes with processed image in the picture Panel all planes.
        hAPGroups; %handle to axes with image created from the Red Green and Blue color-planes.
        
        hAArea; %handle to axes with area plot.  
        hACount; %handle to axes with counter plot.
        hAScatterFarredRed; %handle to axes with scatterplot that contains fiber objects.
        hAScatterBlueRed; %handle to axes with scatterplot that contains fiber objects.
        
        hAAreaHist; %handle to axes with the area histogram
        hAAspectHist; %handle to axes with the aspect ratio histogram
        hADiaHist; %handle to axes with the diameter histogram
        hARoundHist; %handle to axes with the roundness histogram

        hAScatterAll %handle to axes with scatterplot that contains all fiber objects.
        
        B_BackAnalyze; %Button, close the ResultsMode and opens the the AnalyzeMode.
        B_Save; %Button, save data into the RGB image folder.
        B_NewPic; %Button, to select a new picture.
        B_CloseProgramm; %Button, to close the program.
        
        B_SaveFiberTable; %Checkbox, select if fiber table should be saved.
        B_SaveScatterAll; %Checkbox, select if statistic table should be saved.
        B_SavePlots; %Checkbox, select if Statistics plots should be saved.
        B_SaveHisto; %Checkbox, select if Histogram plots should be saved.
        B_SavePicProc; %Checkbox, select if processed image with Farred should be saved.
        B_SavePicGroups; %Checkbox, select if processed image without Farred image should be saved.
        B_SaveOpenDir %Button, opens the save directory.
        
        B_TableStatistic; %Table, that shows all statistic data.
        B_TableMain; %Table, that shows all object data.
        B_InfoText; %Shows the info log text.
        
    end
    
    methods
        function obj = viewResults(mainCard)
            
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
%             mainCard = figure('Units','normalized','Position',[0.01 0.05 0.98 0.85]);
            set(mainCard,'Visible','off');
            mainPanelBox = uix.HBox( 'Parent', mainCard,'Spacing',2,'Padding',2 );
            
            obj.panelResults = uix.Panel( 'Title', 'RESULTS', 'Parent', mainPanelBox,'FontSize',fontSizeB,'Padding',0);
            obj.panelControl = uix.Panel( 'Title', 'RESULTS', 'Parent', mainPanelBox,'FontSize',fontSizeB,'TitlePosition','centertop','Padding',0);
            set( mainPanelBox, 'MinimumWidths', [1 320] );
            set( mainPanelBox, 'Widths', [-4 -1] );
            
            %%%%%%%%%%%%%%%%%% Panel controls %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            PanelVBox = uix.VBox('Parent',obj.panelControl,'Spacing', 0,'Padding',2);
            
            PanelControl = uix.Panel('Parent',PanelVBox,'Title','Main controls','FontSize',fontSizeB,'Padding',2);
            PanelSave = uix.Panel('Parent',PanelVBox,'Title','Save options','FontSize',fontSizeB,'Padding',2);
            PanelInfo = uix.Panel('Parent',PanelVBox,'Title','Info:','FontSize',fontSizeB,'Padding',2);
            
            set( PanelVBox, 'Heights', [-3 -7 -14], 'Spacing', 5 );
            
            %%%%%%%%%%%%%%%%%% Panel control %%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxControl = uix.VButtonBox('Parent', PanelControl,'ButtonSize',[600 600],'Spacing', 3 ,'Padding',3 );
            
            HBoxControl1 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 40], 'Spacing',3);
            obj.B_BackAnalyze = uicontrol( 'Parent', HBoxControl1, 'String', sprintf('\x25C4 Classification'),'FontUnits','normalized','Fontsize',0.4 );
            obj.B_CloseProgramm = uicontrol( 'Parent', HBoxControl1,'FontUnits','normalized','Fontsize',0.4, 'String', sprintf('Close program \x2612') );
            
            HBoxControl2 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 40], 'Spacing',3);
            obj.B_NewPic = uicontrol( 'Parent', HBoxControl2,'FontUnits','normalized','Fontsize',0.4, 'String', sprintf('\x2633 New file') );
            obj.B_Save = uicontrol( 'Parent', HBoxControl2, 'String', sprintf('Save data \x2611'),'FontUnits','normalized','Fontsize',0.4 );
            
            %%%%%%%%%%%%%%%%%%%Panel SaveOptions %%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxSave = uix.VBox('Parent', PanelSave,'Spacing', 5 );
            
            %%%%%%%%%%%%%%%% 1. Row Save Overview plots 
            HBoxSave1 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave11 = uix.HButtonBox('Parent', HBoxSave1,'ButtonSize',[6000 20],'Padding', 1 );
            tempH = uicontrol( 'Parent', HButtonBoxSave11,'Style','text','FontUnits','normalized','Fontsize',0.7, 'HorizontalAlignment','left','String', '  Save Overview plots as .pdf: ' );
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
            
            HButtonBoxSave12 = uix.HButtonBox('Parent', HBoxSave1,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SavePlots = uicontrol( 'Parent', HButtonBoxSave12,'Style','checkbox','Value',1,'Tag','SaveOverview');
            
            set( HBoxSave1, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 2. Row Save Histogram plots 
            HBoxSave2 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave21 = uix.HButtonBox('Parent', HBoxSave2,'ButtonSize',[6000 20],'Padding', 1 );
            tempH = uicontrol( 'Parent', HButtonBoxSave21,'Style','text','FontUnits','normalized','Fontsize',0.7, 'HorizontalAlignment','left','String', '  Save Histogram plots as .pdf: ' );
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
            
            HButtonBoxSave22 = uix.HButtonBox('Parent', HBoxSave2,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SaveHisto = uicontrol( 'Parent', HButtonBoxSave22,'Style','checkbox','Value',1,'Tag','SaveHistogram');
            
            set( HBoxSave2, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 3. Row Save Processed image
            HBoxSave3 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave31 = uix.HButtonBox('Parent', HBoxSave3,'ButtonSize',[6000 20],'Padding', 1 );
            tempH = uicontrol( 'Parent', HButtonBoxSave31,'Style','text','FontUnits','normalized','Fontsize',0.7, 'HorizontalAlignment','left','String', '  Save Processed Image as .pdf: ' );
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
            
            HButtonBoxSave32 = uix.HButtonBox('Parent', HBoxSave3,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SavePicProc = uicontrol( 'Parent', HButtonBoxSave32,'Style','checkbox','Value',1,'Tag','SavePicProcessed');
            
            set( HBoxSave3, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 4. Row Save Fiber Groups image
            HBoxSave4 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave41 = uix.HButtonBox('Parent', HBoxSave4,'ButtonSize',[6000 20],'Padding', 1 );
            tempH = uicontrol( 'Parent', HButtonBoxSave41,'Style','text','FontUnits','normalized','Fontsize',0.7, 'HorizontalAlignment','left','String', '  Save Fiber-Grouping Image as .pdf: ' );
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
            
            HButtonBoxSave42 = uix.HButtonBox('Parent', HBoxSave4,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SavePicGroups = uicontrol( 'Parent', HButtonBoxSave42,'Style','checkbox','Value',1,'Tag','SavePicGroups');
            
            set( HBoxSave4, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 5. Row Save Fiber Table 
            HBoxSave5 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave51 = uix.HButtonBox('Parent', HBoxSave5,'ButtonSize',[6000 20],'Padding', 1 );
            tempH = uicontrol( 'Parent', HButtonBoxSave51,'Style','text','FontUnits','normalized','Fontsize',0.7, 'HorizontalAlignment','left','String', '  Save Fiber-Table as Excel spreadsheet: ' );
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
            
            HButtonBoxSave52 = uix.HButtonBox('Parent', HBoxSave5,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SaveFiberTable = uicontrol( 'Parent', HButtonBoxSave52,'Style','checkbox','Value',1,'Tag','SaveFiberTable'); 
            
            set( HBoxSave5, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 6. Row Save Scatter all 
            HBoxSave6 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave61 = uix.HButtonBox('Parent', HBoxSave6,'ButtonSize',[6000 20],'Padding', 1 );
            tempH = uicontrol( 'Parent', HButtonBoxSave61,'Style','text','FontUnits','normalized','Fontsize',0.7, 'HorizontalAlignment','left','String', '  Save Scatterplot all Fibers as .pdf: ' );
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER);
            
            HButtonBoxSave62 = uix.HButtonBox('Parent', HBoxSave6,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SaveScatterAll = uicontrol( 'Parent', HButtonBoxSave62,'Style','checkbox','Value',1,'Tag','SaveScatterAll');
            
            set( HBoxSave6, 'Widths', [-10 -1] );

            %%%%%%%%%%%%%%%% 7. Row Save dir
            HBoxSave7 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave71 = uix.HButtonBox('Parent', HBoxSave7,'ButtonSize',[600 30],'Padding', 3 );
            obj.B_SaveOpenDir = uicontrol( 'Parent', HButtonBoxSave71,'FontUnits','normalized','Fontsize',0.5, 'String', 'Open results folder' );
            
            %%%%%%%%
            set( mainVBBoxSave, 'Heights', [-1 -1 -1 -1 -1 -1 -2] );
            
            %%%%%%%%%%%%%%%%%%% Pnael Info Text Log %%%%%%%%%%%%%%%%%%%%%%%
            
            obj.B_InfoText = uicontrol('Parent',PanelInfo,'Style','listbox','FontSize',fontSizeM,'String',{});
            
            %%%%%%%%%%%%%%%%%%% Panel with Tabs %%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            tabPanel = uix.TabPanel('Parent',obj.panelResults,'FontSize',fontSizeM,'Padding',2,'TabWidth',200);
            
            statisticTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            histogramTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            pictureTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            pictureRGBPlaneTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            tableTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            scatterAllTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            
            tabPanel.TabTitles = {'Overview','Histograms','Image processed','Image with Fiber-Groups', 'Fiber Type Table','Scatterplot all Fibers'};
            
            tabPanel.TabWidth = -1;
            %%%%%%%%%%%%%%%%%%% Tab Overview %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            statisticTabHBox = uix.HBox('Parent',statisticTabPanel,'Spacing',2,'Padding',2);
            
            statsVBoxleft = uix.VBox( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            statsVBoxright = uix.VBox( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            
            PanelArea = uix.Panel('Parent',statsVBoxleft,'Padding',5);
            PanelCount = uix.Panel('Parent',statsVBoxleft,'Padding',5);
            PanelDia = uix.Panel('Parent',statsVBoxright,'Padding',5);
            PanelScatter = uix.Panel('Parent',statsVBoxright,'Padding',5);
            
            obj.hAArea = axes('Parent',uicontainer('Parent',PanelArea));
            set(obj.hAArea, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAArea,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hACount= axes('Parent',uicontainer('Parent',PanelCount));
            set(obj.hACount, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hACount,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hAScatterFarredRed = axes('Parent',uicontainer('Parent',PanelDia));
            set(obj.hAScatterFarredRed, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAScatterFarredRed,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hAScatterBlueRed = axes('Parent',uicontainer('Parent',PanelScatter));
            set(obj.hAScatterBlueRed, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAScatterBlueRed,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            
            
            PanelStatisticTabel = uix.Panel('Parent',statisticTabHBox,'Padding',5,'Title', 'Fiber-Type statistics','FontSize',fontSizeM);
            
            set(statisticTabHBox,'Widths', [-2 -2 -1.2])
            set( statsVBoxleft, 'Heights', [-1 -1] );
            set( statsVBoxright, 'Heights', [-1 -1] );
            
            set(obj.hAArea,'Units','normalized','OuterPosition',[0 0 1 1]);
            set(obj.hAArea,'XLim',[-1.8 1.8]);
            set(obj.hAArea,'YLim',[-1.8 1.8]);
            set(obj.hAArea,'xtick',[],'ytick',[])
            set(obj.hAArea,'PlotBoxAspectRatio',[1 1 1]);
            
            set(obj.hACount,'Units','normalized','OuterPosition',[0 0 1 1]);
            
            set(obj.hAScatterFarredRed,'Units','normalized','OuterPosition',[0 0 1 1]);

            set(obj.hAScatterBlueRed,'Units','normalized','OuterPosition',[0 0 1 1]);

            obj.B_TableStatistic = uitable('Parent',PanelStatisticTabel,'FontSize',fontSizeS);
            
           
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Histogramms %%%%%%%%%%%%%%%%%%%%%%
            
            histoTabHBox = uix.HBox('Parent',histogramTabPanel,'Spacing',2,'Padding',2);
            
            histoVBoxleft = uix.VBox( 'Parent', histoTabHBox, 'Spacing', 15 ,'Padding',5);
            histoVBoxright = uix.VBox( 'Parent', histoTabHBox, 'Spacing', 15 ,'Padding',5);
            
            histoArea = uix.Panel('Parent',histoVBoxleft,'Padding',5);
            histoAspect = uix.Panel('Parent',histoVBoxleft,'Padding',5);
            histoDiameter = uix.Panel('Parent',histoVBoxright,'Padding',5);
            histoRound = uix.Panel('Parent',histoVBoxright,'Padding',5);
            
            obj.hAAreaHist = axes('Parent',uicontainer('Parent',histoArea));
            set(obj.hAAreaHist, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAAreaHist,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hAAspectHist= axes('Parent',uicontainer('Parent',histoAspect));
            set(obj.hAAspectHist, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAAspectHist,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hADiaHist = axes('Parent',uicontainer('Parent',histoDiameter));
            set(obj.hADiaHist, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hADiaHist,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            obj.hARoundHist = axes('Parent',uicontainer('Parent',histoRound));
            set(obj.hARoundHist, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hARoundHist,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Image processed
            mainPicProcPanel = uix.Panel('Parent',pictureTabPanel,'Padding',35,'Title', 'RGB Image processed with object boundaries and label numbers','FontSize',fontSizeM);
            
            obj.hAPProcessed = axes('Parent',mainPicProcPanel,'Units','normalized','Position',[0 0 1 1]);
            axtoolbar(obj.hAPProcessed,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            axis image
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Image with Groups %%%%%%%%%%%%%
            
            mainPicGroupPanel = uix.Panel('Parent',pictureRGBPlaneTabPanel,'Padding',35,'Title', 'RGB Image with Fiber-Type-Groups','FontSize',fontSizeM);
            
            obj.hAPGroups = axes('Parent',mainPicGroupPanel,'Units','normalized','Position',[0 0 1 1]);
            axtoolbar(obj.hAPGroups,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            axis image
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Tabel %%%%%%%%%%%%%%%%%%%%%%%%%%
            
            mainTablePanel = uix.Panel('Parent',tableTabPanel,'Padding',5,'Title', 'Table object information','FontSize',fontSizeM);
            obj.B_TableMain = uitable('Parent',mainTablePanel,'FontSize',fontSizeB);
            
            obj.B_TableMain.FontSize = fontSizeS;
            obj.B_TableMain.Units = 'normalized';
            obj.B_TableMain.Position =[0 0 1 1];
            
            set(obj.hACount,'Units','normalized','OuterPosition',[0 0 1 1]);
            
            set(obj.hAScatterFarredRed,'Units','normalized','OuterPosition',[0 0 1 1]);

            set(obj.hAScatterBlueRed,'Units','normalized','OuterPosition',[0 0 1 1]);
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab Scatter all %%%%%%%%%%%%%%%%%%%%%%
            
            mainScatterallPanel = uix.Panel('Parent',scatterAllTabPanel,'Padding',35,'Title', '3D-Scatterplot showing all fibers in a Blue/Red/Farred coordinate system','FontSize',fontSizeM);
            
            obj.hAScatterAll = axes('Parent',uicontainer('Parent',mainScatterallPanel),'Units','normalized','OuterPosition',[0 0 1 1]);
            set(obj.hAScatterAll, 'LooseInset', [0,0,0,0]);
            axtoolbar(obj.hAScatterAll,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
%             set(obj.hAScatterAll,'Units','normalized','OuterPosition',[0 0 1 1]);
            %%%%%%%%%%%%%%% call edit functions for GUI
            obj.setToolTipStrings();
            
            appDesignChanger(mainCard,'light');
            set(mainCard,'Visible','on');

        end
                
         function setToolTipStrings(obj)
            % Set all tooltip strings in the properties of the operationg
            % elements that are shown in the GUI
            %
            %   setToolTipStrings(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewAnalyze object
            %
            
            BackAnalToolTip = sprintf(['Go back to analyze mode.']);
            
            NewPicToolTip = sprintf(['Select a new image for further processing.']);
            
            SaveToolTip = sprintf(['Saves the data in the same \n',...
                ' directory as the selected RGB image.',...
                'Create a new folder for each timestamp.']);
            
            CloseToolTip = sprintf(['Quit the program. \n',...
                'Unsaved data will be lost.']);
            
            set(obj.B_BackAnalyze,'tooltipstring',BackAnalToolTip);
            set(obj.B_CloseProgramm,'tooltipstring',CloseToolTip);
            set(obj.B_NewPic,'tooltipstring',NewPicToolTip);
            set(obj.B_Save,'tooltipstring',SaveToolTip);

            
        end
        
         function delete(obj)
            
        end
    end
    
end

