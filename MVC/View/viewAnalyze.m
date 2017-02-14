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
            obj.panelControl = uix.Panel( 'Title', 'Control Panel', 'Parent', mainPanelBox,'FontSize',fontSizeB );
            set( mainPanelBox, 'MinimumWidths', [1 320] );
            set( mainPanelBox, 'Widths', [-80 -20] );
            
            obj.hAP = axes('Parent',uicontainer('Parent', obj.panelPicture), 'FontSize',fontSizeM);
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
            uicontrol( 'Parent', HButtonBoxPara11,'Style','text','FontSize',fontSizeM, 'String', 'Analyze Mode :' );
            
            HButtonBoxPara12 = uix.HButtonBox('Parent', HBoxPara1,'ButtonSize',[6000 20],'Padding', 1 );
            String = {'Color-Based triple labeling (T: 1 12h 2x)          ' , 'Color-Based quad labeling (T: 1 12h 2a 2x 2ax)', 'Cluster-Based ; 3 Types'};
            obj.B_AnalyzeMode = uicontrol( 'Parent', HButtonBoxPara12,'Style','popupmenu','FontSize',fontSizeM, 'String', String ,'Value',2);
            
            set( HBoxPara1, 'Widths', [-2 -5] );
            
            %%%%%%%%%%%%%%%% 2. Row: Area
            HBoxPara2 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara21 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_AreaActive = uicontrol( 'Parent', HButtonBoxPara21,'Style','checkbox','Value',1,'Tag','AreaActive');
            
            HButtonBoxPara22 = uix.HButtonBox('Parent', HBoxPara2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara22,'Style','text','FontSize',fontSizeM, 'String', ['Area in ' sprintf(' \x3BCm^2') ' from:'] );
            
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
            
            %%%%%%%%%%%%%%%% 4. Row Color Value HSV ColorRoom
            HBoxPara4 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara41 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_ColorValueActive = uicontrol( 'Parent', HButtonBoxPara41,'Style','checkbox','Value',1,'Tag','ColorValueActive');
            
            HButtonBoxPara42 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara42,'Style','text','FontSize',fontSizeM, 'String', 'Minimal color value :' );
            
            HButtonBoxPara43 = uix.HButtonBox('Parent', HBoxPara4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_ColorValue = uicontrol( 'Parent', HButtonBoxPara43,'Style','edit','FontSize',fontSizeM,'Tag','ColorValue', 'String', '0.1' );
            
            set( HBoxPara4, 'Widths', [-1 -4 -4] );
            
            %%%%%%%%%%%%%%%% 5. Row: Roundness
            HBoxPara5 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara51 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_RoundnessActive = uicontrol( 'Parent', HButtonBoxPara51,'Style','checkbox','Value',1,'Tag','RoundnessActive');
            
            HButtonBoxPara52 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara52,'Style','text','FontSize',fontSizeM, 'String', 'Minimal roundness ratio :' );
            
            HButtonBoxPara53 = uix.HButtonBox('Parent', HBoxPara5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_MinRoundness = uicontrol( 'Parent', HButtonBoxPara53,'Style','edit','FontSize',fontSizeM,'Tag','MinRoundValue', 'String', '0.15' );
            
            set( HBoxPara5, 'Widths', [-1 -4 -4] );
            
            
            %%%%%%%%%%%%%%%% 6. Row Blue Red thresh
            HBoxPara6 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara61 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_BlueRedThreshActive = uicontrol( 'Parent', HButtonBoxPara61,'style','checkbox','Value',1,'Tag','BlueRedThreshActive');
            
            HButtonBoxPara62 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara62,'Style','text','FontSize',fontSizeM, 'String', 'B/R thresh:' );
            
            HButtonBoxPara63 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_BlueRedThresh = uicontrol( 'Parent', HButtonBoxPara63,'Style','edit','FontSize',fontSizeM,'Tag','BlueRedThresh', 'String', '1' );
            
            HButtonBoxPara64 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara64,'Style','text','FontSize',fontSizeM, 'String', 'Blue dist:' );
            
            HButtonBoxPara65 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_BlueRedDistBlue = uicontrol( 'Parent', HButtonBoxPara65,'Style','edit','FontSize',fontSizeM,'Tag','BlueRedDistBlue', 'String', '0.1' );
            
            HButtonBoxPara66 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara66,'Style','text','FontSize',fontSizeM, 'String', 'Red dist:' );
            
            HButtonBoxPara67 = uix.HButtonBox('Parent', HBoxPara6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_BlueRedDistRed = uicontrol( 'Parent', HButtonBoxPara67,'Style','edit','FontSize',fontSizeM,'Tag','BlueRedDistRed', 'String', '0.1' );
            
            set( HBoxPara6, 'Widths', [-8 -22 -10 -20 -10 -20 -10] );
            
            %%%%%%%%%%%%%%%% 7. Row FarRed Red thresh
            HBoxPara7 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara71 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_FarredRedThreshActive = uicontrol( 'Parent', HButtonBoxPara71,'style','checkbox','Value',1,'Tag','FarredRedThreshActive');
            
            HButtonBoxPara72 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara72,'Style','text','FontSize',fontSizeM, 'String', 'FR/R thresh:' );
            
            HButtonBoxPara73 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_FarredRedThresh = uicontrol( 'Parent', HButtonBoxPara73,'Style','edit','FontSize',fontSizeM,'Tag','FarredRedThresh', 'String', '1' );
            
            HButtonBoxPara74 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara74,'Style','text','FontSize',fontSizeM, 'String', 'Farred dist:' );
            
            HButtonBoxPara75 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_FarredRedDistFarred = uicontrol( 'Parent', HButtonBoxPara75,'Style','edit','FontSize',fontSizeM,'Tag','FarredRedDistFarred', 'String', '0.1' );
            
            HButtonBoxPara76 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara76,'Style','text','FontSize',fontSizeM, 'String', 'Red dist:' );
            
            HButtonBoxPara77 = uix.HButtonBox('Parent', HBoxPara7,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_FarredRedDistRed = uicontrol( 'Parent', HButtonBoxPara77,'Style','edit','FontSize',fontSizeM,'Tag','FarredRedDistRed', 'String', '0.1' );
            
            set( HBoxPara7, 'Widths', [-8 -22 -10 -20 -10 -20 -10] );
            
            
            %%%%%%%%%%%%%%%% 8. Pixel Scale
            HBoxPara8 = uix.HBox('Parent', mainVBoxPara);
            
            HButtonBoxPara81 = uix.HButtonBox('Parent', HBoxPara8,'ButtonSize',[600 20],'Padding', 1 );
%             ui = uibuttongroup('Parent', HButtonBoxPara81);
%             t = text('Parent', ui,'Interpreter','LaTex','string','$\alpha_{0}$','FontSize',13)
            uicontrol( 'Parent', HButtonBoxPara81,'Style','text','FontSize',fontSizeM, 'String',sprintf('Xs: \x3BCm/pixel'));
            
            HButtonBoxPara82 = uix.HButtonBox('Parent', HBoxPara8,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_XScale = uicontrol( 'Parent', HButtonBoxPara82,'Style','edit','FontSize',fontSizeM,'Tag','XScale', 'String', '1' );
            
            HButtonBoxPara83 = uix.HButtonBox('Parent', HBoxPara8,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxPara83,'Style','text','FontSize',fontSizeM, 'String',sprintf('Ys: \x3BCm/pixel') );
            
            HButtonBoxPara83 = uix.HButtonBox('Parent', HBoxPara8,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_YScale = uicontrol( 'Parent', HButtonBoxPara83,'Style','edit','FontSize',fontSizeM,'Tag','YScale', 'String', '1' );
            
             set( HBoxPara8, 'Widths', [-1 -1 -1 -1] );
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%% Panel FiberInformation %%%%%%%%%%%%%%%%%%%%%
            VBoxMainInfoFiber = uix.VBox('Parent', PanelFiberInformation);
            
            HBoxInfo1 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo11 = uix.HButtonBox('Parent', HBoxInfo1,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo11,'Style','text','FontSize',fontSizeM, 'String', 'Label No.:' );
            
            HButtonBoxInfo12 = uix.HButtonBox('Parent', HBoxInfo1,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextObjNo = uicontrol( 'Parent', HButtonBoxInfo12,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HButtonBoxInfo13 = uix.HButtonBox('Parent', HBoxInfo1,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo13,'Style','text','FontSize',fontSizeM, 'String', ['Area in ' sprintf(' \x3BCm^2') ':'] );
            
            HButtonBoxInfo14 = uix.HButtonBox('Parent', HBoxInfo1,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextArea = uicontrol( 'Parent', HButtonBoxInfo14,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HBoxInfo2 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo21 = uix.HButtonBox('Parent', HBoxInfo2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo21,'Style','text','FontSize',fontSizeM, 'String', 'Aspect Ratio:' );
            
            HButtonBoxInfo22 = uix.HButtonBox('Parent', HBoxInfo2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextAspectRatio = uicontrol( 'Parent', HButtonBoxInfo22,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HButtonBoxInfo23 = uix.HButtonBox('Parent', HBoxInfo2,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo23,'Style','text','FontSize',fontSizeM, 'String', 'Roundness:' );
            
            HButtonBoxInfo24 = uix.HButtonBox('Parent', HBoxInfo2,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextRoundness = uicontrol( 'Parent', HButtonBoxInfo24,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HBoxInfo3 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo31 = uix.HButtonBox('Parent', HBoxInfo3,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo31,'Style','text','FontSize',fontSizeM, 'String', 'mean Red:' );
            
            HButtonBoxInfo32 = uix.HButtonBox('Parent', HBoxInfo3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextMeanRed = uicontrol( 'Parent', HButtonBoxInfo32,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HButtonBoxInfo33 = uix.HButtonBox('Parent', HBoxInfo3,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo33,'Style','text','FontSize',fontSizeM, 'String', 'mean Green:' );
            
            HButtonBoxInfo34 = uix.HButtonBox('Parent', HBoxInfo3,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextMeanGreen = uicontrol( 'Parent', HButtonBoxInfo34,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HBoxInfo4 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo41 = uix.HButtonBox('Parent', HBoxInfo4,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo41,'Style','text','FontSize',fontSizeM, 'String', 'mean Blue:' );
            
            HButtonBoxInfo42 = uix.HButtonBox('Parent', HBoxInfo4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextMeanBlue = uicontrol( 'Parent', HButtonBoxInfo42,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HButtonBoxInfo43 = uix.HButtonBox('Parent', HBoxInfo4,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo43,'Style','text','FontSize',fontSizeM, 'String', 'mean Farred:' );
            
            HButtonBoxInfo44 = uix.HButtonBox('Parent', HBoxInfo4,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextMeanFarred = uicontrol( 'Parent', HButtonBoxInfo44,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HBoxInfo5 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo51 = uix.HButtonBox('Parent', HBoxInfo5,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo51,'Style','text','FontSize',fontSizeM, 'String', 'Blue/Red:' );
            
            HButtonBoxInfo52 = uix.HButtonBox('Parent', HBoxInfo5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextBlueRedRatio = uicontrol( 'Parent', HButtonBoxInfo52,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HButtonBoxInfo53 = uix.HButtonBox('Parent', HBoxInfo5,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo53,'Style','text','FontSize',fontSizeM, 'String', 'Farred/Red:' );
            
            HButtonBoxInfo54 = uix.HButtonBox('Parent', HBoxInfo5,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextFarredRedRatio = uicontrol( 'Parent', HButtonBoxInfo54,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HBoxInfo6 = uix.HBox('Parent', VBoxMainInfoFiber);
            
            HButtonBoxInfo61 = uix.HButtonBox('Parent', HBoxInfo6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo61,'Style','text','FontSize',fontSizeM, 'String', 'Color Value:' );
            
            HButtonBoxInfo62 = uix.HButtonBox('Parent', HBoxInfo6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextColorValue = uicontrol( 'Parent', HButtonBoxInfo62,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HButtonBoxInfo63 = uix.HButtonBox('Parent', HBoxInfo6,'ButtonSize',[600 20],'Padding', 1 );
            uicontrol( 'Parent', HButtonBoxInfo63,'Style','text','FontSize',fontSizeM, 'String', 'Fiber Type:' );
            
            HButtonBoxInfo64 = uix.HButtonBox('Parent', HBoxInfo6,'ButtonSize',[600 20],'Padding', 1 );
            obj.B_TextFiberType = uicontrol( 'Parent', HButtonBoxInfo64,'Style','text','FontSize',fontSizeM, 'String', ' - ' );
            
            HBoxInfo7 = uix.HBox('Parent', VBoxMainInfoFiber);
            obj.B_AxesInfo = axes('Parent',HBoxInfo7);
            axis image
            
            set( VBoxMainInfoFiber, 'Heights', [-6 -6 -6 -6 -6 -6 -64], 'Spacing', 1 );
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
            
            obj.B_InfoText = uicontrol('Parent',PanelInfo,'Style','listbox','FontSize',fontSizeM,'String',{});
            
            %%%%%%%%%%%%%%% call edit functions for GUI
%             obj.setToolTipStrings();

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
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Label No. :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontSize',fontSizeM, 'String', Info{1} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', ['Area in ' sprintf(' \x3BCm^2') ' :'] );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontSize',fontSizeM, 'String', Info{2} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Aspect Ratio :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontSize',fontSizeM, 'String', Info{3} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', 'Roundness :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontSize',fontSizeM, 'String', Info{4} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'mean Red :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontSize',fontSizeM, 'String', Info{7} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', 'mean Green :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontSize',fontSizeM, 'String', Info{8} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'mean Blue :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontSize',fontSizeM, 'String', Info{9} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', 'mean Farred :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontSize',fontSizeM, 'String', Info{10} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Blue/red :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontSize',fontSizeM, 'String', Info{5} );
            
            uicontrol( 'Parent', VButtonBoxrightInfo,'Style','text','FontSize',fontSizeM, 'String', 'Farred/Red :' );
            uicontrol( 'Parent', VButtonBoxrightValue,'Style','text','FontSize',fontSizeM, 'String', Info{6} );
            
            uicontrol( 'Parent', VButtonBoxleftInfo,'Style','text','FontSize',fontSizeM, 'String', 'Color Value :' );
            uicontrol( 'Parent', VButtonBoxleftValue,'Style','text','FontSize',fontSizeM, 'String', Info{11} );
            
            uix.Empty( 'Parent', VButtonBoxrightInfo);
            uix.Empty( 'Parent', VButtonBoxrightValue);
            
            HBBoxType = uix.HBox('Parent', mainVBoxInfo,'Spacing', 5,'Padding',5);
            
            uicontrol( 'Parent', HBBoxType,'Style','text','FontSize',fontSizeM, 'String', 'Fiber type :' );
            obj.B_FiberTypeManipulate = uicontrol( 'Parent', HBBoxType,'Style','popupmenu','FontSize',fontSizeM );
            set(obj.B_FiberTypeManipulate,'String',{'Type 1 (blue)' , 'Type 12h (magenta)', 'Type 2x (red)', 'Type 2a (yellow)', 'Type 2ax (orange)' ,'undefined (white)' })
            
%             uix.Empty( 'Parent', VButtonBoxleftInfo);
%             uix.Empty( 'Parent', VButtonBoxleftValue);
            
            HBBoxCont = uix.HBox('Parent', mainVBoxInfo,'Spacing', 5,'Padding',5);
            obj.B_ManipulateCancel = uicontrol( 'Parent', HBBoxCont, 'String', 'Cancel','FontSize',fontSizeB );
            obj.B_ManipulateOK = uicontrol( 'Parent', HBBoxCont, 'String', 'Change Info','FontSize',fontSizeB );
            set( mainVBoxInfo, 'Heights', [-4 -1 -1], 'Spacing', 1 );
            
            switch Info{12} %Fiber Type
                case 'Type 1'
                    %Fiber Type 1 (blue)
                    set(obj.B_FiberTypeManipulate,'Value',1);
                case 'Type 12h'
                    %Fiber Type 2 (red)
                    set(obj.B_FiberTypeManipulate,'Value',2);
                case 'Type 2x'
                    %Fiber Type 3 (magenta)
                    set(obj.B_FiberTypeManipulate,'Value',3);
                case 'Type 2a'
                    %Fiber Type 3 (magenta)
                    set(obj.B_FiberTypeManipulate,'Value',4);
                case 'Type 2ax'
                    %Fiber Type 3 (magenta)
                    set(obj.B_FiberTypeManipulate,'Value',5);       
                case 'undefined'
                    %Fiber Type 0 (white)
                    set(obj.B_FiberTypeManipulate,'Value',6);
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

