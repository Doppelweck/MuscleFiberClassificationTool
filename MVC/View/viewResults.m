classdef viewResults < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hFR;    %handle to figure with Results and controls
        panelControl;    %handle to panel with controls
        panelResults;   %handle to panel with results
        hAPProcessed;    %handle to axes with processed picture in the picture Panel
        
        hAArea  
        hACount
        hAScatterAll
        hAScatter
        
        B_BackAnalyze;
        B_Save;
        B_NewPic;
        B_CloseProgramm;
        
        B_SaveFiberTable
        B_SaveStatisticTable
        B_SavePlots
        B_SaveAnaPicture
        B_SaveOpenDir
        
        B_TableStatistic;
        B_TableMain;
        B_InfoText;
        
    end
    
    methods
        function obj = viewResults(mainCard)
            
            fontSizeS = 10; % Font size small
            fontSizeM = 12; % Font size medium
            fontSizeB = 16; % Font size big
            
%             screenSize = get(0,'screensize');
%             
% %             obj.hFR = figure('NumberTitle','off','Units','normalized','Name','Fiber types classification: RESULTS MODE','Visible','off','Tag','viewResults');
% %             set(obj.hFR, 'position', [0 0 1 0.85]);
% %             set(obj.hFR,'WindowStyle','normal');
%             
%              % Center window
%             movegui(obj.hFR,'center');
%             
%             set(obj.hFR, 'doublebuffer', 'off');
            
%             obj.hFR = uix.BoxPanel('Parent', mainCard); 
            
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
%             PanelMorphOp = uix.Panel('Parent',PanelVBox,'Title','Morphological operations','FontSize',fontSizeM,'Padding',5);
            PanelInfo = uix.Panel('Parent',PanelVBox,'Title','Info text log','FontSize',fontSizeB,'Padding',5);
            
            set( PanelVBox, 'Heights', [-1 -1 -3], 'Spacing', 5 );
            
            %%%%%%%%%%%%%%%%%% Panel control %%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxControl = uix.VButtonBox('Parent', PanelControl,'ButtonSize',[600 600],'Spacing', 5 );
            
            HBoxControl1 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 600],'Padding',5, 'Spacing',5);
            obj.B_BackAnalyze = uicontrol( 'Parent', HBoxControl1, 'String', '<- Back to Analyze mode','FontSize',fontSizeB );
            obj.B_CloseProgramm = uicontrol( 'Parent', HBoxControl1,'FontSize',fontSizeB, 'String', 'Close program' );
            
            HBoxControl2 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 600],'Padding',5, 'Spacing',5);
            obj.B_NewPic = uicontrol( 'Parent', HBoxControl2,'FontSize',fontSizeB, 'String', 'NewPic' );
            obj.B_Save = uicontrol( 'Parent', HBoxControl2, 'String', 'Save Data','FontSize',fontSizeB );
            
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
            
            
%             obj.hACount.Title.String = 'Number of fiber type';
            set(obj.hACount,'Units','normalized','OuterPosition',[0 0 1 1]);
            
            set(obj.hAScatterAll,'Units','normalized','OuterPosition',[0 0 1 1]);

            set(obj.hAScatter,'Units','normalized','OuterPosition',[0 0 1 1]);

            obj.B_TableStatistic = uitable('Parent',PanelStatisticTabel,'FontSize',fontSizeB);
%             obj.B_TableStatistic.RowName = {'Analyze Mode','Para min area','Para max area',...
%                 'Para min Asp.Ratio','Para max Asp.Ratio',...
%                 'Para min Roundn.','Para min Colordist.',...
%                 'Para min ColorVal.',...
%                 'No. Objects',...
%                 'No. Type 1','No. Type 2','No. Type 3','No. Type 0',...
%                 'Area Type 1','Area Type 2','Area Type 3','Area Type 0',...
%                 'Area Type 1 in %','Area Type 2 in %','Area Type 3 in %','Area Type 0 in %',...
%                 'Smallest Area','Smalest Fiber','Largest Area','Largest Fiber',...
%                 'Smallest Area T1','Smalest Fiber T1','Largest Area T1','Largest Fiber T1',...
%                 'Smallest Area T2','Smalest Fiber T2','Largest Area T2','Largest Fiber T2',...
%                 'Smallest Area T3','Smalest Fiber T3','Largest Area T3','Largest Fiber T3'};
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
            obj.editToolBar()
            
%             drawnow;
        end
        
                
         function editToolBar(obj)
            set( findall(obj.hFR,'ToolTipString','Edit Plot') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Rotate 3D') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Data Cursor') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Insert Colorbar') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Insert Legend') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Hide Plot Tools') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','New Figure') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Show Plot Tools') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Brush/Select Data') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Show Plot Tools and Dock Figure') ,'Visible','Off');
            set( findall(obj.hFR,'ToolTipString','Link Plot') ,'Visible','Off');
         end
        
         function delete(obj)
            
        end
    end
    
end

