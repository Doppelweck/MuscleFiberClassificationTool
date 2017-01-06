classdef viewAnalyze < handle
    %viewAnalyze   view of the analyze-MVC (Model-View-Controller).
    %Creates the second card panel in the main figure to select the  
    %parameters for further classification. The viewEdit class is called by  
    %the main.m file. Contains serveral buttons and uicontrol elements to 
    %tchange the classification parameters and to runs the classification.
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
    
    properties(SetObservable)

        panelControl;    %handle to panel with controls.
        panelPicture;   %handle to panel with image.
        hAP;    %handle to axes with image.
        hFM; %handle to figure to change the Fiber-Type.
        
        B_BackEdit; %Button, close the AnalyzeMode and opens the the EditMode.     
        B_StartAnalyze; %Button, runs the segmentation and classification functions.
        B_StartResults; %Button, close the AnalyzeMode and opens the the ResultsMode.
        
        B_AnalyzeMode; %Popup menu, select the classification method.
        
        B_AreaActive; %Ceckbox, select if area parameter is used for classificaton.
        B_MinArea; %TextEditBox, minimal allowed fiber area.
        B_MaxArea; %TextEditBox, maximal allowed fiber area.
        
        B_RoundnessActive; %Checkbox, select if roundness parameter is used for classificaton.
        B_MinRoundness; %TextEditBox, minimal allowed fiber roudness.
        
        B_AspectRatioActive %Checkbox, select if aspect ratio parameter is used for classificaton.
        B_MinAspectRatio; %TextEditBox, minimal allowed fiber aspect ratio.
        B_MaxAspectRatio; %TextEditBox, maximal allowed fiber aspect ratio.
        
        B_ColorDistanceActive; %Checkbox, select if color distance parameter is used for classificaton.
        B_ColorDistance; %TextEditBox, minimal allowed fiber color distance.
        
        B_ColorValueActive; %Checkbox, select if color value parameter is used for classificaton.
        B_ColorValue; %TextEditBox, minimal allowed fiber color value (HSV).
        
        B_TextObjNo; %TextBox, shows label number of selected fiber in the fiber information panel.
        B_TextArea; %TextBox, shows area of selected fiber in the fiber information panel.
        B_TextRoundness; %TextBox, shows roundness of selected fiber in the fiber information panel.
        B_TextFiberType; %TextBox, shows fiber type of selected fiber in the fiber information panel.
        B_TextAspectRatio; %TextBox, shows aspect ratio of selected fiber in the fiber information panel.
        B_TextColorValue; %TextBox, shows color value (HSV) of selected fiber in the fiber information panel.
        B_TextColorDistance; %TextBox, shows color distance of selected fiber in the fiber information panel.
        B_AxesInfo; %handle to axes with image of selected fiber in the fiber information panel.
        B_InfoText; %Shows the info log text.
        
        B_FiberTypeManipulate; %Popup menu, select new fiber type.
        B_ManipulateOK; %Button, apply fiber type changes.
        B_ManipulateCancel; %Button, cancel fiber type changes.
        
    end
    
    methods
        function obj = viewAnalyze(mainCard)
            
            fontSizeS = 10; % Font size small
            fontSizeM = 12; % Font size medium
            fontSizeB = 16; % Font size big
            
            mainPanelBox = uix.HBox( 'Parent', mainCard ,'Spacing',5,'Padding',5);
            
            obj.panelPicture = uix.Panel( 'Title', 'Picture', 'Parent', mainPanelBox,'FontSize',fontSizeB,'Padding',5);
            obj.panelControl = uix.Panel( 'Title', 'Control Panel', 'Parent', mainPanelBox,'FontSize',fontSizeB );
            set( mainPanelBox, 'MinimumWidths', [1 320] );
            set( mainPanelBox, 'Widths', [-4 -1] );
            
            obj.hAP = axes('Parent',uicontainer('Parent', obj.panelPicture));
            axis image
            set(obj.hAP, 'LooseInset', [0,0,0,0]);
            
            PanelVBox = uix.VBox('Parent',obj.panelControl,'Spacing', 1,'Padding',1);
            
            PanelControl = uix.Panel('Parent',PanelVBox,'Title','Main controls','FontSize',fontSizeB,'Padding',1);
            PanelPara = uix.Panel('Parent',PanelVBox,'Title','Parameter','FontSize',fontSizeB,'Padding',1);
            PanelFiberInformation = uix.Panel('Parent',PanelVBox,'Title','Fiber informations','FontSize',fontSizeB,'Padding',1);
            PanelInfo = uix.Panel('Parent',PanelVBox,'Title','Info text log','FontSize',fontSizeB,'Padding',1);
            
            
            set( PanelVBox, 'Heights', [-4 -5 -11 -4], 'Spacing', 1 );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%% Panel Control %%%%%%%%%%%%%%%%%%%%%%%%%
            VBBoxControl = uix.VButtonBox('Parent', PanelControl,'ButtonSize',[600 600],'Spacing', 5 );
            HBBoxControl1 = uix.HButtonBox('Parent', VBBoxControl,'ButtonSize',[600 600],'Spacing', 5 );
            
            obj.B_BackEdit = uicontrol( 'Parent', HBBoxControl1, 'String', 'Back to edit mode','FontSize',fontSizeB );
            obj.B_StartResults = uicontrol( 'Parent', HBBoxControl1, 'String', 'Show results','FontSize',fontSizeB );
            
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
            obj.B_MinRoundness = uicontrol( 'Parent', HButtonBoxPara43,'Style','edit','FontSize',fontSizeM,'Tag','MinRoundValue', 'String', '0.15' );
            
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
            obj.B_ColorValue = uicontrol( 'Parent', HButtonBoxPara63,'Style','edit','FontSize',fontSizeM,'Tag','ColorValue', 'String', '0.1' );
            
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
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Color value (HSV):' );
            obj.B_TextColorValue = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Fiber-Type:' );
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
            obj.setToolTipStrings();

        end
        
        function showInfoToManipulate(obj,PosInAxes,PosMainFig,PosCurrent,Info)
            % Creates a new figure to show and change the type of the
            % selected fiber object. 
            %
            %   showInfoToManipulate(obj,PosInAxes,PosMainFig,PosCurrent,Info);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to viewEdit object
            %           PosInAxes:  Relative position of the point where
            %                       the users clicked in the axes
            %           PosMainFig: Positon of the main figure
            %           PosCurrent: Position of the point where the users
            %                       clicked in the figure
            %           Info:       Cell array that contains all needed
            %                       informations and images
            %
            
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
                    %Fiber Type 1 (blue)
                    set(obj.B_FiberTypeManipulate,'Value',1);
                case '2'
                    %Fiber Type 2 (red)
                    set(obj.B_FiberTypeManipulate,'Value',2);
                case '3'
                    %Fiber Type 3 (magenta)
                    set(obj.B_FiberTypeManipulate,'Value',3);
                case '0'
                    %Fiber Type 0 (white)
                    set(obj.B_FiberTypeManipulate,'Value',4);
            end
            
            
            set(obj.hFM,'Visible','on')
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
            
            BackEditToolTip = sprintf(['Go back to edit mode.']);
            
            ShowResultsToolTip = sprintf(['Show classification results']);
            
            StartAnaToolTip = sprintf(['Start fiber type classification']);
            
            ClassModeToolTip = sprintf(['Select classification method.']);
            
            MinAreaToolTip = sprintf(['Change minimal area value. \n',...
                'Smaller objects will be removed.']);
            
            MaxAreaToolTip = sprintf(['Change maximal area value. \n',...
                'Larger objects will be classified as Type 0 fiber.']);
            
            MinAspectToolTip = sprintf(['Change minimal aspect ratio.']);
            
            MaxAspectToolTip = sprintf(['Change maximal aspect ratio. \n',...
                'Objects with larger aspect ration will be classified as Type 0 fiber.']);
            
            MinRoundToolTip = sprintf(['Change minimal roundness value. \n',...
                'Objects with samller roundness value will be classified as Type 0 fiber.']);
            
            MinColorDistToolTip = sprintf(['Change minimal color distance. \n',...
                'Normalized distance between red and blue color value. \n',...
                'Objects with samller color distance value will be classified as Type 3 fiber.']);
            
            MinColorValueToolTip = sprintf(['Change minimal color value. \n',...
                'Value form the HSV color model (lightness).',...
                'Objects with samller color value will be classified as Type 0 fiber.']);
            
            set(obj.B_BackEdit,'tooltipstring',BackEditToolTip);
            set(obj.B_StartResults,'tooltipstring',ShowResultsToolTip);
            set(obj.B_StartAnalyze,'tooltipstring',StartAnaToolTip);
            
            set(obj.B_AnalyzeMode,'tooltipstring',ClassModeToolTip);
            set(obj.B_MinArea,'tooltipstring',MinAreaToolTip);
            set(obj.B_MaxArea,'tooltipstring',MaxAreaToolTip);
            set(obj.B_MinAspectRatio,'tooltipstring',MinAspectToolTip);
            set(obj.B_MaxAspectRatio,'tooltipstring',MaxAspectToolTip);
            set(obj.B_MinRoundness,'tooltipstring',MinRoundToolTip);
            set(obj.B_ColorDistance,'tooltipstring',MinColorDistToolTip);
            set(obj.B_ColorValue,'tooltipstring',MinColorValueToolTip);
            
        end
        
        function delete(obj)
            
        end
        
    end
    
end

