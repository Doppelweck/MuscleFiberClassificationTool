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
        hAPProcessed; %handle to axes with processed picture in the picture Panel.
        
        hAArea; %handle to axes with area plot.  
        hACount %handle to axes with counter plot.
        hAScatterAll %handle to axes with scatterplot that contains all objects.
        hAScatter %handle to axes with scatterplot that contains fiber objects.
        
        B_BackAnalyze; %Button, close the ResultsMode and opens the the AnalyzeMode.
        B_Save; %Button, save data into the RGB image folder.
        B_NewPic; %Button, to select a new picture.
        B_CloseProgramm; %Button, to close the program.
        
        B_SaveFiberTable; %Ceckbox, select if fiber table should be saved.
        B_SaveStatisticTable; %Ceckbox, select if statistic table should be saved.
        B_SavePlots; %Ceckbox, select if all plots should be saved.
        B_SaveAnaPicture; %Ceckbox, select if analyzed picture table should be saved.
        B_SaveOpenDir %Button, opens the save directory.
        
        B_TableStatistic; %Table, that shows all statistic data.
        B_TableMain; %Table, that shows all object data.
        B_InfoText; %Shows the info log text.
        
    end
    
    methods
        function obj = viewResults(mainCard)
            
            fontSizeS = 10; % Font size small
            fontSizeM = 12; % Font size medium
            fontSizeB = 16; % Font size big

            mainPanelBox = uix.HBox( 'Parent', mainCard,'Spacing',5,'Padding',5 );
            
            obj.panelResults = uix.Panel( 'Title', 'Results', 'Parent', mainPanelBox,'FontSize',fontSizeB,'Padding',5);
            obj.panelControl = uix.Panel( 'Title', 'Control Panel', 'Parent', mainPanelBox,'FontSize',fontSizeB );
            set( mainPanelBox, 'MinimumWidths', [1 320] );
            set( mainPanelBox, 'Widths', [-4 -1] );
            
            %%%%%%%%%%%%%%%%%% Panel controls %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            PanelVBox = uix.VBox('Parent',obj.panelControl,'Spacing', 5,'Padding',5);
            
            PanelControl = uix.Panel('Parent',PanelVBox,'Title','Main controls','FontSize',fontSizeB,'Padding',5);
            PanelSave = uix.Panel('Parent',PanelVBox,'Title','Save options','FontSize',fontSizeB,'Padding',5);
            PanelInfo = uix.Panel('Parent',PanelVBox,'Title','Info text log','FontSize',fontSizeB,'Padding',5);
            
            set( PanelVBox, 'Heights', [-5 -6 -14], 'Spacing', 5 );
            
            %%%%%%%%%%%%%%%%%% Panel control %%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxControl = uix.VButtonBox('Parent', PanelControl,'ButtonSize',[600 600],'Spacing', 5 );
            
            HBoxControl1 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 600],'Padding',5, 'Spacing',5);
            obj.B_BackAnalyze = uicontrol( 'Parent', HBoxControl1, 'String', 'Back to analyze mode','FontSize',fontSizeB );
            obj.B_CloseProgramm = uicontrol( 'Parent', HBoxControl1,'FontSize',fontSizeB, 'String', 'Close program' );
            
            HBoxControl2 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 600],'Padding',5, 'Spacing',5);
            obj.B_NewPic = uicontrol( 'Parent', HBoxControl2,'FontSize',fontSizeB, 'String', 'New image' );
            obj.B_Save = uicontrol( 'Parent', HBoxControl2, 'String', 'Save data','FontSize',fontSizeB );
            
            %%%%%%%%%%%%%%%%%%%Panel SaveOptions %%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxSave = uix.VButtonBox('Parent', PanelSave,'ButtonSize',[600 600],'Spacing', 5 );
            
            %%%%%%%%%%%%%%%% 1. Row Save Fiber Table 
            HBoxSave1 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave11 = uix.HButtonBox('Parent', HBoxSave1,'ButtonSize',[6000 18],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxSave11,'Style','text','FontSize',fontSizeM, 'String', 'Save Fiber-Data table in Excel sheet :' );
            
            HButtonBoxSave12 = uix.HButtonBox('Parent', HBoxSave1,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SaveFiberTable = uicontrol( 'Parent', HButtonBoxSave12,'Style','checkbox','Value',1,'Tag','SaveFiberTable');
            
            set( HBoxSave1, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 2. Row Save Statistic Table 
            HBoxSave2 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave21 = uix.HButtonBox('Parent', HBoxSave2,'ButtonSize',[6000 18],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxSave21,'Style','text','FontSize',fontSizeM, 'String', 'Save Fiber-Statistics table in Excel sheet :' );
            
            HButtonBoxSave22 = uix.HButtonBox('Parent', HBoxSave2,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SaveStatisticTable = uicontrol( 'Parent', HButtonBoxSave22,'Style','checkbox','Value',1,'Tag','SaveStatistcTable');
            
            set( HBoxSave2, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 3. Row Save Analyze Parameter Table
            HBoxSave3 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave31 = uix.HButtonBox('Parent', HBoxSave3,'ButtonSize',[6000 18],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxSave31,'Style','text','FontSize',fontSizeM, 'String', 'Save statistics plots as image files :' );
            
            HButtonBoxSave32 = uix.HButtonBox('Parent', HBoxSave3,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SavePlots = uicontrol( 'Parent', HButtonBoxSave32,'Style','checkbox','Value',1,'Tag','SaveParameter');
            
            set( HBoxSave3, 'Widths', [-10 -1] );
            
            %%%%%%%%%%%%%%%% 4. Row Save Picture analyzed 
            HBoxSave4 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave41 = uix.HButtonBox('Parent', HBoxSave4,'ButtonSize',[6000 18],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxSave41,'Style','text','FontSize',fontSizeM, 'String', 'Save processed picture :' );
            
            HButtonBoxSave42 = uix.HButtonBox('Parent', HBoxSave4,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_SaveAnaPicture = uicontrol( 'Parent', HButtonBoxSave42,'Style','checkbox','Value',1,'Tag','SaveProcessedPicture');
            
            set( HBoxSave4, 'Widths', [-10 -1] );

            %%%%%%%%%%%%%%%% 5. Row Save dir
            HBoxSave5 = uix.HBox('Parent', mainVBBoxSave);
            
            HButtonBoxSave51 = uix.HButtonBox('Parent', HBoxSave5,'ButtonSize',[600 30],'Padding', 1 );
            obj.B_SaveOpenDir = uicontrol( 'Parent', HButtonBoxSave51,'FontSize',fontSizeM, 'String', 'Open results folder' );
            
            %%%%%%%%%%%%%%%%%%% Pnael Info Text Log %%%%%%%%%%%%%%%%%%%%%%%
            
            obj.B_InfoText = uicontrol('Parent',PanelInfo,'Style','listbox','FontSize',fontSizeM,'String',{});
            
            %%%%%%%%%%%%%%%%%%% Panel with Tabs %%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            tabPanel = uix.TabPanel('Parent',obj.panelResults,'FontSize',fontSizeM,'Padding',2,'TabWidth',200);
            
            statisticTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            pictureTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            tableTabPanel = uix.Panel('Parent',tabPanel,'BorderType','line');
            
            
            tabPanel.TabTitles = {'Statistics','Picture', 'Object Table'};
            
            %%%%%%%%%%%%%%%%%%% Tab 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            statisticTabHBox = uix.HBox('Parent',statisticTabPanel,'Spacing',2,'Padding',2);
            
            statsVBoxleft = uix.VBox( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            statsVBoxright = uix.VBox( 'Parent', statisticTabHBox, 'Spacing', 15 ,'Padding',5);
            
            PanelArea = uix.Panel('Parent',statsVBoxleft,'Padding',5);
            PanelCount = uix.Panel('Parent',statsVBoxleft,'Padding',5);
            PanelDia = uix.Panel('Parent',statsVBoxright,'Padding',5);
            PanelScatter = uix.Panel('Parent',statsVBoxright,'Padding',5);
            
            obj.hAArea = axes('Parent',uicontainer('Parent',PanelArea));
            set(obj.hAArea, 'LooseInset', [0,0,0,0]);
            obj.hACount= axes('Parent',uicontainer('Parent',PanelCount));
            set(obj.hACount, 'LooseInset', [0,0,0,0]);
            obj.hAScatterAll = axes('Parent',uicontainer('Parent',PanelDia));
            set(obj.hAScatterAll, 'LooseInset', [0,0,0,0]);
            obj.hAScatter = axes('Parent',uicontainer('Parent',PanelScatter));
            set(obj.hAScatter, 'LooseInset', [0,0,0,0]);
            
            
            PanelStatisticTabel = uix.Panel('Parent',statisticTabHBox,'Padding',5,'Title', 'Fiber-Type statistics','FontSize',fontSizeM);
            
            set(statisticTabHBox,'Widths', [-3 -3 -2])
            set( statsVBoxleft, 'Heights', [-1 -1] );
            set( statsVBoxright, 'Heights', [-1 -1] );
            
            set(obj.hAArea,'Units','normalized','OuterPosition',[0 0 1 1]);
            set(obj.hAArea,'XLim',[-1.8 1.8]);
            set(obj.hAArea,'YLim',[-1.8 1.8]);
            set(obj.hAArea,'xtick',[],'ytick',[])
            set(obj.hAArea,'PlotBoxAspectRatio',[1 1 1]);
            
            set(obj.hACount,'Units','normalized','OuterPosition',[0 0 1 1]);
            
            set(obj.hAScatterAll,'Units','normalized','OuterPosition',[0 0 1 1]);

            set(obj.hAScatter,'Units','normalized','OuterPosition',[0 0 1 1]);

            obj.B_TableStatistic = uitable('Parent',PanelStatisticTabel,'FontSize',fontSizeB);
            obj.B_TableStatistic.RowName = [];
            obj.B_TableStatistic.ColumnName = {'Name of parameter                   ','Value of parameter                   '};
            
           
            %%%%%%%%%%%%%%%%%%%%%%%% Tab 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            mainPicPanel = uix.Panel('Parent',pictureTabPanel,'Padding',35,'Title', 'Picture with boundaries and label numbers','FontSize',fontSizeM);
            
            obj.hAPProcessed = axes('Parent',mainPicPanel,'Units','normalized','Position',[0 0 1 1]);
            axis image
            
            %%%%%%%%%%%%%%%%%%%%%%%% Tab 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            mainTablePanel = uix.Panel('Parent',tableTabPanel,'Padding',5,'Title', 'Table object information','FontSize',fontSizeM);
            obj.B_TableMain = uitable('Parent',mainTablePanel,'FontSize',fontSizeB);
            obj.B_TableMain.RowName = [];
            obj.B_TableMain.ColumnName = {'LabelNO' 'Area' 'XPos' 'YPos' 'MinorAxis' 'MajorAxis' 'Perimeter' 'Roundness' ...
                'AspectRatio' 'meanRed' 'meanGreen' 'meanBlue' 'meanFarRed' 'meanColorValue' ...
                'meanColorHue' 'RationBlueRed' 'DistBlueRed' 'FiberType'};
            obj.B_TableMain.FontSize = fontSizeM;
            obj.B_TableMain.Units = 'normalized';
            obj.B_TableMain.Position =[0 0 1 1];
            
            set(obj.hACount,'Units','normalized','OuterPosition',[0 0 1 1]);
            
            set(obj.hAScatterAll,'Units','normalized','OuterPosition',[0 0 1 1]);

            set(obj.hAScatter,'Units','normalized','OuterPosition',[0 0 1 1]);
            
            %%%%%%%%%%%%%%% call edit functions for GUI
            obj.setToolTipStrings();

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
            
            SaveToolTip = sprintf(['Saves the data in the same directory \n',...
                'as the selected rgb image']);
            
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

