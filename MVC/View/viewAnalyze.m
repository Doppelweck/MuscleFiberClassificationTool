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
        hAMC; %handle to axes for manual classification mode.
        hFM; %handle to figure to change the Fiber-Type.
        hFMC; %handle to figure for manual classification mode.
        hFPR; %handle to figure the shows a preview of the ruslts after calssification.
        hAPRBR; %handle to axes with Blue over Red classification results in the Preview Results Figure.
        hAPRFRR; %handle to axes with Farred over Red classification results in the Preview Results Figure.
        ParaCard;
        
        B_BackEdit; %Button, close the AnalyzeMode and opens the the EditMode.     
        B_StartAnalyze; %Button, runs the segmentation and classification functions.
        B_StartResults; %Button, close the AnalyzeMode and opens the the ResultsMode.
        B_PreResults; %Button, Shows a preview scatter plot with classified fibers. 
        
        B_AnalyzeMode; %Popup menu, select the classification method.
        
        B_AreaActive; %Ceckbox, select if area parameter is used for classificaton.
        B_MinArea; %TextEditBox, minimal allowed fiber area.
        B_MaxArea; %TextEditBox, maximal allowed fiber area.
        
        B_RoundnessActive; %Checkbox, select if roundness parameter is used for classificaton.
        B_MinRoundness; %TextEditBox, minimal allowed fiber roudness.
        
        B_AspectRatioActive %Checkbox, select if aspect ratio parameter is used for classificaton.
        B_MinAspectRatio; %TextEditBox, minimal allowed fiber aspect ratio.
        B_MaxAspectRatio; %TextEditBox, maximal allowed fiber aspect ratio.
        
        B_BlueRedThreshActive; %Checkbox, select if Blue/Red threshold parameter is used for classificaton.
        B_BlueRedThresh; %TextEditBox, Blue/Red threshold to indentify type 1 and type 2 fibers.
        B_BlueRedDistBlue; %TextEditBox, distance from Blue/Red threshold line in Blue direction to indentify type 12 hybrid fibers.
        B_BlueRedDistRed; %TextEditBox, distance from Blue/Red threshold line in Red direction to indentify type 12 hybrid fibers.
        
        B_FarredRedThreshActive; %Checkbox, select if FarRed/Red threshold parameter is used for classificaton.
        B_FarredRedThresh; %TextEditBox, FarRed/Red threshold to indentify type 2a and type 2x fibers.
        B_FarredRedDistFarred; %TextEditBox, distance from FarRed/Red threshold line in FarRed direction to indentify type 2ax fibers.
        B_FarredRedDistRed; %TextEditBox, distance from FarRed/Red threshold line in Red direction to indentify type 2ax fibers.
        
        B_ColorValueActive; %Checkbox, select if color value parameter is used for classificaton.
        B_ColorValue; %TextEditBox, minimal allowed fiber color value (HSV).
        
        B_12HybridFiberActive;
        B_2axHybridFiberActive;
        
        B_XScale;
        B_YScale;
        
        B_TextObjNo; %TextBox, shows label number of selected fiber in the fiber information panel.
        B_TextArea; %TextBox, shows area of selected fiber in the fiber information panel.
        B_TextRoundness; %TextBox, shows roundness of selected fiber in the fiber information panel.
        B_TextAspectRatio; %TextBox, shows aspect ratio of selected fiber in the fiber information panel.
        B_TextMeanRed; %TextBox, shows mean Red value of selected fiber in the fiber information panel.
        B_TextMeanGreen; %TextBox, shows mean Green value of selected fiber in the fiber information panel.
        B_TextMeanBlue; %TextBox, shows mean Blue value of selected fiber in the fiber information panel.
        B_TextMeanFarred; %TextBox, shows mean Farred value of selected fiber in the fiber information panel.
        B_TextBlueRedRatio; %TextBox, shows Blue/Red ratio value of selected fiber in the fiber information panel.
        B_TextFarredRedRatio; %TextBox, shows Farred/Red ratio value of selected fiber in the fiber information panel.
        B_TextColorValue; %TextBox, shows color value (HSV) of selected fiber in the fiber information panel.
        B_TextFiberType; %TextBox, shows fiber type of selected fiber in the fiber information panel.
        B_AxesInfo; %handle to axes with image of selected fiber in the fiber information panel.
        B_InfoText; %Shows the info log text.
        
        B_FiberTypeManipulate; %Popup menu, select new fiber type.
        B_ManipulateOK; %Button, apply fiber type changes.
        B_ManipulateCancel; %Button, cancel fiber type changes.
        
        B_ManualInfoText; %Text, info text for manual classification
        B_ManualClassBack; %Button, manual classification, go back to choose main fiber types.
        B_ManualClassEnd; %Button, quit manual classification.
        B_ManualClassForward; %Button, manual classification, go forward to specify type 2 fiber types.
        
    end
    
    methods
        function obj = viewAnalyze(mainCard)
            
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
            mainPanelBox = uix.HBox( 'Parent', mainCard ,'Spacing',5,'Padding',5);
            
            obj.panelPicture = uix.Panel( 'Title', 'Picture', 'Parent', mainPanelBox,'FontSize',fontSizeB,'Padding',5);
            obj.panelControl = uix.Panel( 'Title', 'Control Panel - ANALYZE-MODE', 'Parent', mainPanelBox,'FontSize',fontSizeB );
            set( mainPanelBox, 'MinimumWidths', [1 320] );
            set( mainPanelBox, 'Widths', [-80 -20] );
            
            obj.hAP = axes('Parent',uicontainer('Parent', obj.panelPicture), 'FontUnits','normalized','Fontsize',0.015);
            axis image
            set(obj.hAP, 'LooseInset', [0,0,0,0]);
            
            PanelVBox = uix.VBox('Parent',obj.panelControl,'Spacing', 1,'Padding',1);
            
            PanelControl = uix.Panel('Parent',PanelVBox,'Title','Main controls','FontSize',fontSizeB,'Padding',2);
            PanelPara = uix.Panel('Parent',PanelVBox,'Title','Parameter','FontSize',fontSizeB,'Padding',2);
            PanelFiberInformation = uix.Panel('Parent',PanelVBox,'Title','Fiber informations','FontSize',fontSizeB,'Padding',2);
            PanelInfo = uix.Panel('Parent',PanelVBox,'Title','Info text log','FontSize',fontSizeB,'Padding',2);
            
            
            set( PanelVBox, 'Heights', [-3 -7 -10 -4], 'Spacing', 1 );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%% Panel Control %%%%%%%%%%%%%%%%%%%%%%%%%
            VBBoxControl = uix.VButtonBox('Parent', PanelControl,'ButtonSize',[600 600],'Spacing', 0 );
            
            HBBoxControl1 = uix.HButtonBox('Parent', VBBoxControl,'ButtonSize',[600 600],'Spacing', 0 );
            obj.B_BackEdit = uicontrol( 'Parent', HBBoxControl1, 'String', sprintf('\x25C4 Edit-Mode'),'FontUnits','normalized','Fontsize',0.4 );
            obj.B_StartResults = uicontrol( 'Parent', HBBoxControl1, 'String', sprintf('Result-Mode \x25BA'),'FontUnits','normalized','Fontsize',0.4 );
            
            HBBoxControl2 = uix.HButtonBox('Parent', VBBoxControl,'ButtonSize',[600 600],'Spacing', 0 );
            obj.B_StartAnalyze = uicontrol( 'Parent', HBBoxControl2, 'String', sprintf('\x21DB Start analyzing'),'FontUnits','normalized','Fontsize',0.4 );
            obj.B_PreResults = uicontrol( 'Parent', HBBoxControl2, 'String', sprintf('Preview results \x2750'),'FontUnits','normalized','Fontsize',0.4 );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%% Panel Para %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBoxPara = uix.VBox('Parent', PanelPara);
            
            %%%%%%%%%%%%%%%% 1. Row Analyze Mode
            HBoxPara1 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara11 = uix.HButtonBox('Parent', HBoxPara1,'ButtonSize',[6000 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara11,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', ' Analyze Mode :' );
            
            HButtonBoxPara12 = uix.HButtonBox('Parent', HBoxPara1,'ButtonSize',[6000 20],'Padding', 1 );
            String= {sprintf('Color-Ratio-Based triple labeling') ; sprintf('Color-Ratio-Based quad labeling');...
            'OPTICS-Cluster-Based triple labeling' ; 'OPTICS-Cluster-Based quad labeling';'Manual CLassification triple labeling';'Manual CLassification quad labeling'; 'Collagen / dystrophin'};
            obj.B_AnalyzeMode = uicontrol( 'Parent', HButtonBoxPara12,'Style','popupmenu','FontUnits','normalized','Fontsize',0.6, 'String', String ,'Value',2);
            
            set( HBoxPara1, 'Widths', [-2 -5] );
            
            %%%%%%%%%%%%%%%% 2. Row: Area
            HBoxPara2 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara21 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_AreaActive = uicontrol( 'Parent', HButtonBoxPara21,'Style','checkbox','FontUnits','normalized','Fontsize',0.6,'Value',1,'Tag','AreaActive');
            
            HButtonBoxPara22 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara22,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', ['Area (' sprintf(' \x3BCm^2') ') from:'] );
            
            HButtonBoxPara23 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MinArea = uicontrol( 'Parent', HButtonBoxPara23,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','MinAreaValue', 'String', '100' );
            
            HButtonBoxPara24 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara24,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'to' );
            
            HButtonBoxPara25 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MaxArea = uicontrol( 'Parent', HButtonBoxPara25,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','MaxAreaValue', 'String', '10000' );
            
            set( HBoxPara2, 'Widths', [-8 -34 -22 -12 -22] );
            
            %%%%%%%%%%%%%%%% 3. Aspect Ratio
            HBoxPara3 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara31 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_AspectRatioActive = uicontrol( 'Parent', HButtonBoxPara31,'Style','checkbox','Value',1,'Tag','AspectRatioActive');
            
            HButtonBoxPara32 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara32,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Aspect Ratio from:' );
            
            HButtonBoxPara33 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MinAspectRatio = uicontrol( 'Parent', HButtonBoxPara33,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','MinAspectRatioValue', 'String', '1' );
            
            HButtonBoxPara34 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara34,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'to' );
            
            HButtonBoxPara35 = uix.HButtonBox('Parent', HBoxPara3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MaxAspectRatio= uicontrol( 'Parent', HButtonBoxPara35,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','MaxAspectRatioValue', 'String', '4' );
            
            set( HBoxPara3, 'Widths', [-8 -34 -22 -12 -22] );
            
            %%%%%%%%%%%%%%%% 4. Row Color Value HSV ColorRoom
            HBoxPara4 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara41 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_ColorValueActive = uicontrol( 'Parent', HButtonBoxPara41,'Style','checkbox','Value',1,'Tag','ColorValueActive');
            
            HButtonBoxPara42 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara42,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Minimal Color Value:' );
            
            HButtonBoxPara43 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_ColorValue = uicontrol( 'Parent', HButtonBoxPara43,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','ColorValue', 'String', '0.1' );
            
            set( HBoxPara4, 'Widths', [-8 -46 -46] );
            
            %%%%%%%%%%%%%%%% 5. Row: Roundness
            HBoxPara5 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara51 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_RoundnessActive = uicontrol( 'Parent', HButtonBoxPara51,'Style','checkbox','Value',1,'Tag','RoundnessActive');
            
            HButtonBoxPara52 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara52,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Minimal Roundness:' );
            
            HButtonBoxPara53 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MinRoundness = uicontrol( 'Parent', HButtonBoxPara53,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','MinRoundValue', 'String', '0.15' );
            
            set( HBoxPara5, 'Widths', [-8 -46 -46] );
            
            
            %%%%%%%%%%%%%%%% 6. Row Blue Red thresh
            obj.ParaCard = uix.CardPanel('Parent', mainVBoxPara,'Selection',0, 'Padding',0);
            
            VBoxMainPara1 = uix.VBox('Parent', obj.ParaCard,'Padding',0,'Spacing', 0);
            
            HBoxPara6 = uix.HBox('Parent', VBoxMainPara1,'Padding',0,'Spacing', 0);
            
            HButtonBoxPara61 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_BlueRedThreshActive = uicontrol( 'Parent', HButtonBoxPara61,'style','checkbox','Value',1,'Tag','BlueRedThreshActive');
            
            HButtonBoxPara62 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara62,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'B/R thresh:' );
            
            HButtonBoxPara63 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_BlueRedThresh = uicontrol( 'Parent', HButtonBoxPara63,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','BlueRedThresh', 'String', '1' );
            
            HButtonBoxPara64 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara64,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Blue dist:' );
            
            HButtonBoxPara65 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_BlueRedDistBlue = uicontrol( 'Parent', HButtonBoxPara65,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','BlueRedDistBlue', 'String', '0.1' );
            
            HButtonBoxPara66 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara66,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Red dist:' );
            
            HButtonBoxPara67 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_BlueRedDistRed = uicontrol( 'Parent', HButtonBoxPara67,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','BlueRedDistRed', 'String', '0.1' );
            
            set( HBoxPara6, 'Widths', [-8 -22 -10 -20 -10 -20 -10] );
            

            %%%%%%%%%%%%%%%% 7. Row FarRed Red thresh
            HBoxPara7 = uix.HBox('Parent', VBoxMainPara1,'Padding',0,'Spacing', 0);
            
            HButtonBoxPara71 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_FarredRedThreshActive = uicontrol( 'Parent', HButtonBoxPara71,'style','checkbox','Value',1,'Tag','FarredRedThreshActive');
            
            HButtonBoxPara72 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara72,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'FR/R thresh:' );
            
            HButtonBoxPara73 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_FarredRedThresh = uicontrol( 'Parent', HButtonBoxPara73,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','FarredRedThresh', 'String', '1' );
            
            HButtonBoxPara74 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara74,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Farred dist:' );
            
            HButtonBoxPara75 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_FarredRedDistFarred = uicontrol( 'Parent', HButtonBoxPara75,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','FarredRedDistFarred', 'String', '0.1' );
            
            HButtonBoxPara76 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara76,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Red dist:' );
            
            HButtonBoxPara77 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_FarredRedDistRed = uicontrol( 'Parent', HButtonBoxPara77,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','FarredRedDistRed', 'String', '0.1' );
            
            set( HBoxPara7, 'Widths', [-8 -22 -10 -20 -10 -20 -10] );
            
            VBoxMainPara2 = uix.VBox('Parent', obj.ParaCard,'Padding',0,'Spacing', 0);
            
            HBoxPara71 = uix.HBox('Parent', VBoxMainPara2);
            
            HButtonBoxPara711 = uix.HButtonBox('Parent', HBoxPara71,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_12HybridFiberActive = uicontrol( 'Parent', HButtonBoxPara711,'style','checkbox','Value',1,'Tag','Hybrid12FiberActive');
            
            HButtonBoxPara712 = uix.HButtonBox('Parent', HBoxPara71,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara712,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Searching for 1/2-Hybrid Fibers allowed?' );
            
            set( HBoxPara71, 'Widths', [-8 -92] );
            
            HBoxPara72 = uix.HBox('Parent', VBoxMainPara2);
            
            HButtonBoxPara721 = uix.HButtonBox('Parent', HBoxPara72,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_2axHybridFiberActive = uicontrol( 'Parent', HButtonBoxPara721,'style','checkbox','Value',1,'Tag','Hybrid2axFiberActive');
            
            HButtonBoxPara722 = uix.HButtonBox('Parent', HBoxPara72,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara722,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Searching for 2ax-Hybrid Fibers allowed?' );
            
            set( HBoxPara72, 'Widths', [-8 -92] );
            
            obj.ParaCard.Selection = 1;
            %%%%%%%%%%%%%%%% 8. Pixel Scale
            HBoxPara8 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara81 = uix.HButtonBox('Parent', HBoxPara8,'ButtonSize',[600 20],'Padding', 1 );
%             ui = uibuttongroup('Parent', HButtonBoxPara81);
%             t = text('Parent', ui,'Interpreter','LaTex','string','$\alpha_{0}$','FontSize',13)
            uicontrol( 'Parent', HButtonBoxPara81,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String',sprintf('Xs: \x3BCm/pixel'));
            
            HButtonBoxPara82 = uix.HButtonBox('Parent', HBoxPara8,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_XScale = uicontrol( 'Parent', HButtonBoxPara82,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','XScale', 'String', '1' );
            
            HButtonBoxPara83 = uix.HButtonBox('Parent', HBoxPara8,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara83,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String',sprintf('Ys: \x3BCm/pixel') );
            
            HButtonBoxPara83 = uix.HButtonBox('Parent', HBoxPara8,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_YScale = uicontrol( 'Parent', HButtonBoxPara83,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','YScale', 'String', '1' );
            
             set( HBoxPara8, 'Widths', [-1 -1 -1 -1] );
            
            set( mainVBoxPara, 'Heights', [-1 -1 -1 -1 -1 -2 -1], 'Spacing', 0 );
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%% Panel FiberInformation %%%%%%%%%%%%%%%%%%%%%
            VBoxMainInfoFiber = uix.VBox('Parent', PanelFiberInformation);
            
            HBoxInfo1 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo11 = uix.HButtonBox('Parent', HBoxInfo1,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo11,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Label No.:' );
            
            HButtonBoxInfo12 = uix.HButtonBox('Parent', HBoxInfo1,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextObjNo = uicontrol( 'Parent', HButtonBoxInfo12,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HButtonBoxInfo13 = uix.HButtonBox('Parent', HBoxInfo1,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo13,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ['Area' sprintf(' (\x3BCm^2)') ':'] );
            
            HButtonBoxInfo14 = uix.HButtonBox('Parent', HBoxInfo1,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextArea = uicontrol( 'Parent', HButtonBoxInfo14,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HBoxInfo2 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo21 = uix.HButtonBox('Parent', HBoxInfo2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo21,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Aspect Ratio:' );
            
            HButtonBoxInfo22 = uix.HButtonBox('Parent', HBoxInfo2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextAspectRatio = uicontrol( 'Parent', HButtonBoxInfo22,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HButtonBoxInfo23 = uix.HButtonBox('Parent', HBoxInfo2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo23,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Roundness:' );
            
            HButtonBoxInfo24 = uix.HButtonBox('Parent', HBoxInfo2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextRoundness = uicontrol( 'Parent', HButtonBoxInfo24,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HBoxInfo3 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo31 = uix.HButtonBox('Parent', HBoxInfo3,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo31,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Red:' );
            
            HButtonBoxInfo32 = uix.HButtonBox('Parent', HBoxInfo3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextMeanRed = uicontrol( 'Parent', HButtonBoxInfo32,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HButtonBoxInfo33 = uix.HButtonBox('Parent', HBoxInfo3,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo33,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Green:' );
            
            HButtonBoxInfo34 = uix.HButtonBox('Parent', HBoxInfo3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextMeanGreen = uicontrol( 'Parent', HButtonBoxInfo34,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HBoxInfo4 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo41 = uix.HButtonBox('Parent', HBoxInfo4,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo41,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Blue:' );
            
            HButtonBoxInfo42 = uix.HButtonBox('Parent', HBoxInfo4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextMeanBlue = uicontrol( 'Parent', HButtonBoxInfo42,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HButtonBoxInfo43 = uix.HButtonBox('Parent', HBoxInfo4,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo43,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Farred:' );
            
            HButtonBoxInfo44 = uix.HButtonBox('Parent', HBoxInfo4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextMeanFarred = uicontrol( 'Parent', HButtonBoxInfo44,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HBoxInfo5 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo51 = uix.HButtonBox('Parent', HBoxInfo5,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo51,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Blue/Red:' );
            
            HButtonBoxInfo52 = uix.HButtonBox('Parent', HBoxInfo5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextBlueRedRatio = uicontrol( 'Parent', HButtonBoxInfo52,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HButtonBoxInfo53 = uix.HButtonBox('Parent', HBoxInfo5,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo53,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Farred/Red:' );
            
            HButtonBoxInfo54 = uix.HButtonBox('Parent', HBoxInfo5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextFarredRedRatio = uicontrol( 'Parent', HButtonBoxInfo54,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HBoxInfo6 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo61 = uix.HButtonBox('Parent', HBoxInfo6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo61,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Color Value:' );
            
            HButtonBoxInfo62 = uix.HButtonBox('Parent', HBoxInfo6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextColorValue = uicontrol( 'Parent', HButtonBoxInfo62,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HButtonBoxInfo63 = uix.HButtonBox('Parent', HBoxInfo6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo63,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Fiber Type:' );
            
            HButtonBoxInfo64 = uix.HButtonBox('Parent', HBoxInfo6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextFiberType = uicontrol( 'Parent', HButtonBoxInfo64,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ' - ' );
            
            HBoxInfo7 = uix.HBox('Parent', VBoxMainInfoFiber);
            obj.B_AxesInfo = axes('Parent',uicontainer('Parent', HBoxInfo7),'FontUnits','normalized','Fontsize',0.015);
            axis image
            set(obj.B_AxesInfo, 'LooseInset', [0,0,0,0]);
            
            set( VBoxMainInfoFiber, 'Heights', [-6 -6 -6 -6 -6 -6 -64], 'Spacing', 1 );
            set( VBoxMainInfoFiber, 'MinimumHeights', [10 10 10 10 10 10 10] );
%             VBoxMainInfoFiber = uix.VBox('Parent', PanelFiberInformation);
%             HBBoxInfoFiber = uix.HBox('Parent', VBoxMainInfoFiber);
%             VButtonBoxleftFiber = uix.VButtonBox('Parent', HBBoxInfoFiber,'ButtonSize',[6000 50]);
%             VButtonBoxrightFiber = uix.VButtonBox('Parent', HBBoxInfoFiber,'ButtonSize',[6000 50]);
%             
%             uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Object Label No.:' );
%             obj.B_TextObjNo = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
%             
%             uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Area in pixel:' );
%             obj.B_TextArea = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
%             
%             uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Aspect Ratio:' );
%             obj.B_TextAspectRatio = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
%             
%             uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Roundness:' );
%             obj.B_TextRoundness = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
%             
%             uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Color distance Blue/Red:' );
%             obj.B_TextColorDistance = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
%             
%             uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Color value (HSV):' );
%             obj.B_TextColorValue = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
%             
%             uicontrol( 'Parent', VButtonBoxleftFiber,'Style','text','FontSize',fontSizeM, 'String', 'Fiber-Type:' );
%             obj.B_TextFiberType = uicontrol( 'Parent', VButtonBoxrightFiber,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
%             
%             
%             HBBoxInfoFiberAxes = uix.HBox('Parent', VBoxMainInfoFiber);
%             obj.B_AxesInfo = axes('Parent',HBBoxInfoFiberAxes);
%             axis image
%             
%             set( HBBoxInfoFiber, 'Widths', [-1 -1], 'Spacing', 2 );
%             set( VBoxMainInfoFiber, 'Heights', [-2 -4], 'Spacing', 1 );
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%% Panel Info Log %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            obj.B_InfoText = uicontrol('Parent',PanelInfo,'Style','listbox','FontSize', fontSizeM,'String',{});
            
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
            
            
            
            PosCurrent(1) = PosCurrent(1)+PosMainFig(1);
            PosCurrent(2) = PosCurrent(2)+PosMainFig(2);
            
            SizeInfoFigure = [400 250]; %[width height]
            
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
            VButtonBoxleftValue = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200],'Spacing', 5 );
            VButtonBoxrightInfo = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200], 'Spacing', 5);
            VButtonBoxrightValue = uix.VButtonBox('Parent', HBBoxInfo,'ButtonSize',[6000 200], 'Spacing', 5);
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Label No. :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{1} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', ['Area in ' sprintf(' \x3BCm^2') ' :'] );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{2} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Aspect Ratio :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{3} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Roundness :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{4} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Red :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{7} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Green :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{8} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Blue :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{9} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'mean Farred :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{10} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Blue/red :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{5} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Farred/Red :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{6} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', 'Color Value :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontUnits','normalized','Fontsize',0.6, 'String', Info{11} );
            
            uix.Empty( 'Parent', VButtonBoxrightInfo);
            uix.Empty( 'Parent', VButtonBoxrightValue);
            
            HBBoxType = uix.HBox('Parent', mainVBoxInfo,'Spacing', 5,'Padding',5);
            
            uicontrol( 'Parent', HBBoxType,'Style','text','FontUnits','normalized','Fontsize',0.5, 'String', 'Fiber type :' );
            obj.B_FiberTypeManipulate = uicontrol( 'Parent', HBBoxType,'Style','popupmenu','FontUnits','normalized','Fontsize',0.4 );
            
            analyzeMode = Info{15}; % last performed analyz mode 
            if analyzeMode == 1 || analyzeMode == 3 || analyzeMode == 5 || analyzeMode == 7
                %tripple labeling was active only Type 1,2 and 12h fibers
                %allowed
            set(obj.B_FiberTypeManipulate,'String',{'Type 1 (blue)' , 'Type 12h (magenta)', 'Type 2 (red)','Type 0 undefined (white)'})
            else
                %quad labeling was active all fibers allowed
            set(obj.B_FiberTypeManipulate,'String',{'Type 1 (blue)' , 'Type 12h (magenta)', 'Type 2x (red)', 'Type 2a (yellow)', 'Type 2ax (orange)' ,'Type 0 undefined (white)' })    
            end
%             uix.Empty( 'Parent', VButtonBoxleftInfo);
%             uix.Empty( 'Parent', VButtonBoxleftValue);
            
            HBBoxCont = uix.HButtonBox('Parent', mainVBoxInfo,'Spacing', 5,'Padding',5,'ButtonSize',[6000 200]);
            obj.B_ManipulateCancel = uicontrol( 'Parent', HBBoxCont, 'String', 'Cancel','FontUnits','normalized','Fontsize',0.6 );
            obj.B_ManipulateOK = uicontrol( 'Parent', HBBoxCont, 'String', 'Change Info','FontUnits','normalized','Fontsize',0.6 );
            set( mainVBoxInfo, 'Heights', [-4 -1 -1], 'Spacing', 1 );
            
            if analyzeMode == 1 || analyzeMode == 3 || analyzeMode == 5 || analyzeMode == 7
                switch Info{12} %Fiber Type
                    case 'Type 1'
                        %Fiber Type 1 (blue)
                        set(obj.B_FiberTypeManipulate,'Value',1);
                    case 'Type 12h'
                        %Fiber Type 12h (magenta)
                        set(obj.B_FiberTypeManipulate,'Value',2);
                    case 'Type 2'
                        %Fiber Type 3 (red)
                        set(obj.B_FiberTypeManipulate,'Value',3);
                    case 'undefined'
                        %Fiber Type 0 (white)
                        set(obj.B_FiberTypeManipulate,'Value',4);    
                end
            else
                switch Info{12} %Fiber Type
                    case 'Type 1'
                        %Fiber Type 1 (blue)
                        set(obj.B_FiberTypeManipulate,'Value',1);
                    case 'Type 12h'
                        %Fiber Type 12h (magenta)
                        set(obj.B_FiberTypeManipulate,'Value',2);
                    case 'Type 2x'
                        %Fiber Type 3 (red)
                        set(obj.B_FiberTypeManipulate,'Value',3);
                    case 'Type 2a'
                        %Fiber Type 3 (yellow)
                        set(obj.B_FiberTypeManipulate,'Value',4);
                    case 'Type 2ax'
                        %Fiber Type 3 (orange)
                        set(obj.B_FiberTypeManipulate,'Value',5);
                    case 'undefined'
                        %Fiber Type 0 (white)
                        set(obj.B_FiberTypeManipulate,'Value',6);
                end
                
            end
            set(obj.hFM,'Visible','on')
        end
        
        function showFigureManualClassify(obj,mainFig)
            % Creates a new figure when the user selects manual classification.
            %
            %   showFigureManualClassify(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to viewEdit object
            %
            
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
            
            obj.hFMC = figure('NumberTitle','off','Units','normalized','Name','Manual Classification','Visible','off');
            set(obj.hFMC,'Tag','FigureManualClassify')
            
            %get position of mainFigure
            posMainFig = get(mainFig,'Position');
            
            set(obj.hFMC, 'position', [posMainFig(1) posMainFig(2) 0.6 0.8]);
            movegui(obj.hFMC,'center')
            
%             set(obj.hFMC, 'position', [0.2 0.1 0.6 0.8]);
            set(obj.hFMC,'WindowStyle','normal');
            
            VBox = uix.VBox('Parent', obj.hFMC );
%             %VBox 1 with info text
%             HBoxText = uix.HButtonBox('Parent', VBox,'ButtonSize',[6000 40],'Padding', 1 );
%             String = 'Select a Area by clicking the mouse and choose fiber type';
%             uicontrol( 'Parent', HBoxText,'Style','text','FontSize',fontSizeB, 'String', String);
%             String = 'Select Main Fiber types 1 12h and 2';
%             obj.B_ManualInfoText = uicontrol( 'Parent', HBoxText,'Style','text','FontSize',fontSizeB, 'String', String,'Tag','ManualInfoText');
%             
            %VBox 2 with axes
            AxesBox = uix.HBox('Parent', VBox,'Padding', 1 );
            obj.hAMC = axes('Parent',uicontainer('Parent', AxesBox), 'FontSize',fontSizeB,'Tag','AxesManualClassify');
            set(obj.hAMC, 'LooseInset', [0,0,0,0]);
            daspect(obj.hAMC,[1 1 1]);
            %VBox 3 with Buttons
            BBox = uix.HButtonBox('Parent', VBox,'ButtonSize',[600 40],'Padding', 10 );
            obj.B_ManualClassBack = uicontrol( 'Parent', BBox, 'String', '<- Back Main Fbers','FontUnits','normalized','Fontsize',0.6 ,'Tag','Back Main Fbers');
            obj.B_ManualClassEnd = uicontrol( 'Parent', BBox, 'String', 'Complete Classification','FontUnits','normalized','Fontsize',0.6 ,'Tag','Complete Classification');
            obj.B_ManualClassForward = uicontrol( 'Parent', BBox, 'String', 'Specify Type 2 Fibers ->','FontUnits','normalized','Fontsize',0.6 ,'Tag','Specify Type 2 Fibers');
            
            set( VBox, 'Heights', [ -8 -1], 'Spacing', 1 ); 
            set(obj.hFMC, 'Visible', 'on');
        end
        
        function showFigurePreResults(obj,mainFig)
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
            
            obj.hFPR = figure('NumberTitle','off','Units','normalized','Name','Preview Results','Visible','off','MenuBar','figure');
            set(obj.hFPR,'Tag','FigurePreResults')
            
            %get position of mainFigure
            posMainFig = get(mainFig,'Position');
            
            set(obj.hFPR, 'position', [posMainFig(1) posMainFig(2) 0.8 0.8]);
            movegui(obj.hFPR,'center')

            set(obj.hFPR,'WindowStyle','normal');
            
            AxesBox = uix.HBox('Parent', obj.hFPR,'Padding', 25,'Spacing', 10);
            obj.hAPRBR = axes('Parent',uicontainer('Parent', AxesBox), 'FontUnits','normalized','Fontsize',0.015,'Tag','AxesManualClassify');
            set(obj.hAPRBR, 'LooseInset', [0,0,0,0]);
            %daspect(obj.hAPRBR,[1 1 1]);
            obj.hAPRFRR = axes('Parent',uicontainer('Parent', AxesBox), 'FontUnits','normalized','Fontsize',0.015,'Tag','AxesManualClassify');
            set(obj.hAPRFRR, 'LooseInset', [0,0,0,0]);
            %daspect(obj.hAPRFRR,[1 1 1]);
            set(obj.hFPR, 'Visible', 'on');
        end
        
        function setToolTipStrings(obj)
            % Set all tooltip strings in the properties of the operationg
            % elements that are shown in the main GUI
            %
            %   setToolTipStrings(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewAnalyze object
            %
            
            BackEditToolTip = sprintf(['Go back to edit mode.']);
            
            ShowResultsToolTip = sprintf(['Switch to Result-Mode. \n',...
                'Show classification results']);
            
            StartAnaToolTip = sprintf(['Start fiber type classification']);
            
            PreviewToolTip = sprintf(['Show preview classification results']);
            
            ClassModeToolTip = sprintf(['Select classification method.']);
            
            MinAreaToolTip = sprintf(['Select minimal area value. \n',...
                'Smaller objects will be removed.']);
            
            MaxAreaToolTip = sprintf(['Select maximal area value. \n',...
                'Larger objects will be classified as Type 0 fiber.']);
            
            MinAspectToolTip = sprintf(['Select minimal aspect ratio.\n',...
                'Objects with smaller aspect ratio\n will be classified as Type-0 fiber']);
            
            MaxAspectToolTip = sprintf(['Change maximal aspect ratio. \n',...
                'Objects with larger aspect ratio\n will be classified as Type-0 fiber.']);
            
            MinRoundToolTip = sprintf(['Change minimal roundness value. \n',...
                'Objects with samller roundness value\n will be classified as Type-0 fiber.']);
            
            MinColorValueToolTip = sprintf(['Change minimal color value. \n',...
                'Value form the HSV color model (lightness).',...
                'Objects with samller color value\n will be classified as Type-0 fiber.']);
            
            BRTreshToolTip = sprintf(['Slope of Blue/Red classification function.']);
            
            BRDistBhToolTip = sprintf(['Blue offset of Blue/Red classification function in percent']);
            
            BRDistRhToolTip = sprintf(['Red offset of Blue/Red classification function in percent']);
            
            FRRTreshToolTip = sprintf(['Slope of Farred/Red classification function.']);
            
            FRRDistFRhToolTip = sprintf(['Farred offset of Farred/Red classification function in percent']);
            
            FRRDistRhToolTip = sprintf(['Farred offset of Farred/Red classification function in percent']);
            
            set(obj.B_BackEdit,'tooltipstring',BackEditToolTip);
            set(obj.B_StartResults,'tooltipstring',ShowResultsToolTip);
            set(obj.B_StartAnalyze,'tooltipstring',StartAnaToolTip);
            set(obj.B_PreResults,'tooltipstring',PreviewToolTip);
            
            set(obj.B_AnalyzeMode,'tooltipstring',ClassModeToolTip);
            set(obj.B_MinArea,'tooltipstring',MinAreaToolTip);
            set(obj.B_MaxArea,'tooltipstring',MaxAreaToolTip);
            set(obj.B_MinAspectRatio,'tooltipstring',MinAspectToolTip);
            set(obj.B_MaxAspectRatio,'tooltipstring',MaxAspectToolTip);
            set(obj.B_MinRoundness,'tooltipstring',MinRoundToolTip);
            set(obj.B_ColorValue,'tooltipstring',MinColorValueToolTip);
            
            set(obj.B_BlueRedThresh,'tooltipstring',BRTreshToolTip);
            set(obj.B_BlueRedDistBlue,'tooltipstring',BRDistBhToolTip);
            set(obj.B_BlueRedDistRed,'tooltipstring',BRDistRhToolTip);
        
            set(obj.B_FarredRedThresh,'tooltipstring',FRRTreshToolTip);
            set(obj.B_FarredRedDistFarred,'tooltipstring',FRRDistFRhToolTip);
            set(obj.B_FarredRedDistRed,'tooltipstring',FRRDistRhToolTip);
            
            
            
        end
        
        function delete(obj)
            
        end
        
    end
    
end

