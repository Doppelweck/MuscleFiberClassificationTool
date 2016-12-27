classdef viewAnalyze < handle
    %UNTITLED7 Summary of this class goes here
    %   Detailed explanation goes here7
    
    properties(SetObservable)
        hFP;    %handle to figure with pictures ans controls
        panelControl;    %handle to panel with controls
        panelPicture;   %handle to panel with picture
        hAP;    %handle to axes with pictures
        hFM; %handle to figure to manipulate Fiber-Type
        
        B_BackEdit;
        B_StartAnalyze;
        B_StartResults;
        
        B_AnalyzeMode
        
        B_AreaActive
        B_MinArea
        B_MaxArea
        
        B_RoundnessActive
        B_MinRoundness
        
        B_AspectRatioActive
        B_MinAspectRatio
        B_MaxAspectRatio
        
        B_ColorDistanceActive
        B_ColorDistance
        
        B_ColorValueActive
        B_ColorValue
        
        B_TextObjNo;

        B_TextArea;

        B_TextRoundness;

        B_TextFiberType

        B_TextAspectRatio

        B_TextColorValue

        B_TextColorDistance
        
        B_AxesInfo
        
        B_InfoText
        
        B_FiberTypeManipulate
        B_ManipulateOK
        B_ManipulateCancel
        
    end
    
    methods
        function obj = viewAnalyze(mainCard)
            
            fontSizeS = 10; % Font size small
            fontSizeM = 12; % Font size medium
            fontSizeB = 16; % Font size big
            
%             screenSize = get(0,'screensize');
%             
%             obj.hFP = figure('NumberTitle','off','Units','normalized','Name','Fiber types classification: ANALYZING MODE','Visible','off','Tag','viewAnalyze');
% %             set(obj.hFP, 'position', [0 0.1 0.8 1]);
%             set(obj.hFP, 'position', [0 0 1 0.85]);
%             set(obj.hFP,'WindowStyle','normal');
%             
%              % Center window
%             movegui(obj.hFP,'center');
            
            obj.hFP = uix.BoxPanel('Parent', mainCard); 
%             set(obj.hFP, 'doublebuffer', 'off');
            
            mainPanelBox = uix.HBox( 'Parent', obj.hFP ,'Spacing',5,'Padding',5);
            
            obj.panelPicture = uix.Panel( 'Title', 'Picture', 'Parent', mainPanelBox,'FontSize',fontSizeB,'Padding',35);
            obj.panelControl = uix.Panel( 'Title', 'Control Panel', 'Parent', mainPanelBox,'FontSize',fontSizeB );
            set( mainPanelBox, 'Widths', [-4 -1] );
            
            obj.hAP = axes('Parent',obj.panelPicture,'Units','normalized','Position',[0 0 1 1]);
            axis image
            
%             obj.hFC = figure('NumberTitle','off','Units','normalized','Name','Analyzing Controls','Visible','off');
%             set(obj.hFC, 'position', [0.801 0.1 0.199 1]);
            
            PanelVBox = uix.VBox('Parent',obj.panelControl,'Spacing', 1,'Padding',1);
            
            PanelControl = uix.Panel('Parent',PanelVBox,'Title','Control','FontSize',fontSizeB,'Padding',1);
            PanelPara = uix.Panel('Parent',PanelVBox,'Title','Parameter','FontSize',fontSizeB,'Padding',1);
            PanelFiberInformation = uix.Panel('Parent',PanelVBox,'Title','Fiber Information','FontSize',fontSizeB,'Padding',1);
            PanelInfo = uix.Panel('Parent',PanelVBox,'Title','Info Text Log','FontSize',fontSizeB,'Padding',1);
            
            
            set( PanelVBox, 'Heights', [-4 -5 -11 -4], 'Spacing', 1 );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%% Panel Control %%%%%%%%%%%%%%%%%%%%%%%%%
            VBBoxControl = uix.VButtonBox('Parent', PanelControl,'ButtonSize',[600 600],'Spacing', 5 );
            HBBoxControl1 = uix.HButtonBox('Parent', VBBoxControl,'ButtonSize',[600 600],'Spacing', 5 );
            
            obj.B_BackEdit = uicontrol( 'Parent', HBBoxControl1, 'String', '<- Back to edit mode','FontSize',fontSizeB );
            obj.B_StartResults = uicontrol( 'Parent', HBBoxControl1, 'String', 'Show results ->','FontSize',fontSizeB );
            
            obj.B_StartAnalyze = uicontrol( 'Parent', VBBoxControl, 'String', 'Start analyzing','FontSize',fontSizeB );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% Panel Para %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBoxPara = uix.VBox('Parent', PanelPara);
            
            %%%%%%%%%%%%%%%% 1. Row Analyze Mode
            HBoxPara1 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara11 = uix.HButtonBox('Parent', HBoxPara1,'ButtonSize',[6000 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara11,'Style','text','FontSize',fontSizeM, 'String', 'Analyze Classification Mode :' );
            
            HButtonBoxPara12 = uix.HButtonBox('Parent', HBoxPara1,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_AnalyzeMode = uicontrol( 'Parent', HButtonBoxPara12,'Style','popupmenu','FontSize',fontSizeM, 'String', {'Colordistance-Based' , 'Color-Cluster-Based ; 2 Types', 'Color-Cluster-Based ; 3 Types'} );
            
            set( HBoxPara1, 'Widths', [-1 -1] );
            
            %%%%%%%%%%%%%%%% 2. Row: Area
            HBoxPara2 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara21 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_AreaActive = uicontrol( 'Parent', HButtonBoxPara21,'Style','checkbox','Value',1,'Tag','AreaActive');
            
            HButtonBoxPara22 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara22,'Style','text','FontSize',fontSizeM, 'String', 'Area in pixel from:' );
            
            HButtonBoxPara23 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MinArea = uicontrol( 'Parent', HButtonBoxPara23,'Style','edit','FontSize',fontSizeM,'Tag','MinAreaValue', 'String', '100' );
            
            HButtonBoxPara24 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara24,'Style','text','FontSize',fontSizeM, 'String', 'to' );
            
            HButtonBoxPara25 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MaxArea = uicontrol( 'Parent', HButtonBoxPara25,'Style','edit','FontSize',fontSizeM,'Tag','MaxAreaValue', 'String', '10000' );
            
            set( HBoxPara2, 'Widths', [-1 -3 -2 -1 -2] );
            
            %%%%%%%%%%%%%%%% 3. Aspect Ratio
            HBoxPara3 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara31 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_AspectRatioActive = uicontrol( 'Parent', HButtonBoxPara31,'Style','checkbox','Value',1,'Tag','AspectRatioActive');
            
            HButtonBoxPara32 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara32,'Style','text','FontSize',fontSizeM, 'String', 'Aspect Ratio from:' );
            
            HButtonBoxPara33 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MinAspectRatio = uicontrol( 'Parent', HButtonBoxPara33,'Style','edit','FontSize',fontSizeM,'Tag','MinAspectRatioValue', 'String', '1' );
            
            HButtonBoxPara34 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara34,'Style','text','FontSize',fontSizeM, 'String', 'to' );
            
            HButtonBoxPara35 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MaxAspectRatio= uicontrol( 'Parent', HButtonBoxPara35,'Style','edit','FontSize',fontSizeM,'Tag','MaxAspectRatioValue', 'String', '4' );
            
            set( HBoxPara3, 'Widths', [-1 -3 -2 -1 -2] );
            
            %%%%%%%%%%%%%%%% 4. Row: Roundness
            HBoxPara4 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara41 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_RoundnessActive = uicontrol( 'Parent', HButtonBoxPara41,'Style','checkbox','Value',1,'Tag','RoundnessActive');
            
            HButtonBoxPara42 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara42,'Style','text','FontSize',fontSizeM, 'String', 'Minimal roundness ratio :' );
            
            HButtonBoxPara43 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MinRoundness = uicontrol( 'Parent', HButtonBoxPara43,'Style','edit','FontSize',fontSizeM,'Tag','MinRoundValue', 'String', '0.2' );
            
            set( HBoxPara4, 'Widths', [-1 -4 -4] );
            
            
            %%%%%%%%%%%%%%%% 5. Row Color Distans
            HBoxPara5 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara51 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_ColorDistanceActive = uicontrol( 'Parent', HButtonBoxPara51,'style','checkbox','Value',1,'Tag','ColorDistanceActive');
            
            HButtonBoxPara52 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara52,'Style','text','FontSize',fontSizeM, 'String', 'Minimal color distance :' );
            
            HButtonBoxPara53 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_ColorDistance = uicontrol( 'Parent', HButtonBoxPara53,'Style','edit','FontSize',fontSizeM,'Tag','ColorDistanceValue', 'String', '0.2' );
            
            set( HBoxPara5, 'Widths', [-1 -4 -4] );
            
            %%%%%%%%%%%%%%%% 5. Row Color Value HSV ColorRoom
            HBoxPara6 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara61 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_ColorValueActive = uicontrol( 'Parent', HButtonBoxPara61,'Style','checkbox','Value',1,'Tag','ColorValueActive');
            
            HButtonBoxPara62 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara62,'Style','text','FontSize',fontSizeM, 'String', 'Minimal color value :' );
            
            HButtonBoxPara63 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_ColorValue = uicontrol( 'Parent', HButtonBoxPara63,'Style','edit','FontSize',fontSizeM,'Tag','ColorValue', 'String', '0.2' );
            
            set( HBoxPara6, 'Widths', [-1 -4 -4] );
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%% Panel FiberInformation %%%%%%%%%%%%%%%%%%%%%
            VBoxMainInfoFiber = uix.VBox('Parent', PanelFiberInformation);
            HBBoxInfoFiber = uix.HBox('Parent', VBoxMainInfoFiber);
            VButtonBoxleftFiber = uix.VButtonBox('Parent', HBBoxInfoFiber,'ButtonSize',[6000 50]);
            VButtonBoxrightFiber = uix.VButtonBox('Parent', HBBoxInfoFiber,'ButtonSize',[6000 50]);
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Object Label No.:' );
            obj.B_TextObjNo = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Area in pixel:' );
            obj.B_TextArea = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Aspect Ratio:' );
            obj.B_TextAspectRatio = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Roundness:' );
            obj.B_TextRoundness = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Color distance Blue/Red:' );
            obj.B_TextColorDistance = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Color Value-channel:' );
            obj.B_TextColorValue = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Fiber Type:' );
            obj.B_TextFiberType = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            
            HBBoxInfoFiberAxes = uix.HBox('Parent', VBoxMainInfoFiber);
            obj.B_AxesInfo = axes('Parent',HBBoxInfoFiberAxes);
            axis image
            
            set( HBBoxInfoFiber, 'Widths', [-1 -1], 'Spacing', 2 );
            set( VBoxMainInfoFiber, 'Heights', [-2 -4], 'Spacing', 1 );
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%% Panel Info Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.B_InfoText = uicontrol('Parent',PanelInfo,'Style','listbox','FontSize',fontSizeM,'String',{});
            
            %%%%%%%%%%%%%%% call edit functions for GUI
%             obj.editToolBar();
%             obj.setToolTipStrings();
            mainCard.Selection = 1;
        end
        
        function showInfoToManipulate(obj,PosInAxes,PosMainFig,PosCurrent,Info)
            
            fontSizeS = 10; % Font size small
            fontSizeM = 12; % Font size medium
            fontSizeB = 16; % Font size big
            
            
            
            PosCurrent(1) = PosCurrent(1)+PosMainFig(1);
            PosCurrent(2) = PosCurrent(2)+PosMainFig(2);
            
            SizeInfoFigure = [300 200]; %[width height]
            
            obj.hFM = figure('NumberTitle','off','Units','pixels','Name','Change fiber informations','Visible','off','MenuBar','none','ToolBar','none');
            set(obj.hFM,'Tag','FigureManipulate')
            set(obj.hFM,'WindowStyle','normal');
            
            if PosInAxes(1,2)-SizeInfoFigure(2) < 0
                set(obj.hFM, 'position', [PosCurrent(1)+5 PosCurrent(2)-SizeInfoFigure(2)-10 SizeInfoFigure(1) SizeInfoFigure(2)]);
            else
                set(obj.hFM, 'position', [PosCurrent(1)+5 PosCurrent(2)+5 SizeInfoFigure(1) SizeInfoFigure(2)]);
            end
            
            mainVBoxInfo = uix.VBox('Parent', obj.hFM);
            HBBoxInfo = uix.HBox('Parent', mainVBoxInfo,'Spacing', 5,'Padding',5);
            VButtonBoxleftInfo = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200],'Spacing', 5 );
            VButtonBoxrightInfo = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200], 'Spacing', 5);
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Object Label No. :' );
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', Info{1} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Area in pixel :' );
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', Info{2} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Aspect Ratio :' );
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', Info{3} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Roundness :' );
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', Info{4} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Color distance :' );
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', Info{5} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Color Value :' );
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', Info{6} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Fiber type :' );
            obj.B_FiberTypeManipulate = uicontrol( 'Parent', VButtonBoxrightInfo,'Style','popupmenu','FontSize',fontSizeM );
            set(obj.B_FiberTypeManipulate,'String',{'Type 1 (blue)' , 'Type 2 (red)', 'Type 3 (magenta, between Type 1 ond 2)', 'Type 0 (white, no fiber)'})
            
            uix.Empty( 'Parent', VButtonBoxleftInfo);
            uix.Empty( 'Parent', VButtonBoxrightInfo);
            
            obj.B_ManipulateCancel = uicontrol( 'Parent', VButtonBoxleftInfo, 'String', 'Cancel','FontSize',fontSizeB );
            obj.B_ManipulateOK = uicontrol( 'Parent', VButtonBoxrightInfo, 'String', 'Change Info','FontSize',fontSizeB );
            
            switch Info{7} %Fiber Type
                case '1'
                    set(obj.B_FiberTypeManipulate,'Value',1);
                case '2'
                    set(obj.B_FiberTypeManipulate,'Value',2);
                case '3'
                    set(obj.B_FiberTypeManipulate,'Value',3);
                case '0'
                    set(obj.B_FiberTypeManipulate,'Value',4);
            end
            
            
            set(obj.hFM,'Visible','on')
        end
        
        function editToolBar(obj)
            set( findall(obj.hFP,'ToolTipString','Edit Plot') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Rotate 3D') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Data Cursor') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Insert Colorbar') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Insert Legend') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Hide Plot Tools') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','New Figure') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Show Plot Tools') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Brush/Select Data') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Show Plot Tools and Dock Figure') ,'Visible','Off');
            set( findall(obj.hFP,'ToolTipString','Link Plot') ,'Visible','Off');
        end
        
        function setToolTipStrings(obj)
            
        end
        
        function delete(obj)
            
        end
        
    end
    
end

