classdef viewEdit < handle
    %viewEdit   view of the edit-MVC (Model-View-Controller).
    %Creates the first card panel in the main figure to select new pictures 
    %for further processing. The viewEdit class is called by the main.m  
    %file. Contains serveral buttons and uicontrol elements to manipulate
    %the binary picture.
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
        
        panelControl;    %handle to panel with the controls included
        panelPicture;   %handle to panel with the image axes included
        hAP;    %handle to axes that shows the image.
        hFCP;   %handle to figure with planes to check. Opens after the check plane button was pressed.
        
        B_Undo; %Button, to undo a change in the binary image.
        B_Redo; %Button, to redo a change in the binary image.
        B_NewPic; %Button, to select a new picture.
        B_CheckPlanes; %Button, opens a new figure to check and change the image planes.
        B_CheckMask; %Button, shows all objects in RGB colors to check the binary mask.
        B_StartAnalyzeMode; %Button, close the EditMode and opens the the AnalyzeMode.
        
        B_FiberForeBackGround
        
        B_Alpha; %Slider, to change the transperancy between the binary and the RGB picture.
        B_AlphaValue; % TextEditBox, to change the transperancy between the binary and the RGB picture.
        B_AlphaActive; %Checkbox, Switch Overlay on and off
        B_ImageOverlaySelection;

        B_Color; %Popupmenu, to select the color to draw into the binary image.
        B_Invert; %Butto, invert the binary pic.

        B_LineWidth; %Slider, to change the linewidth of the free hand draw function in the binary image.
        B_LineWidthValue; %TextEditBox, to change the linewidth of the free hand draw function in the binary image.
        
        B_ThresholdMode; %Popupmenu, to choose between manual-global and adaptive threshold mode binarize the image.
        B_Threshold;%Slider, to change the threshold value.
        B_ThresholdValue;%TextEditBox, to change the threshold value.
        
        B_MorphOP; %Popupmenu, to select between different morphologocal operations.
        B_ShapeSE; %Popupmenu, to select between different structering elements for morphologocal operation.
        B_SizeSE; %TextEditBox, to select the size of the structering element.
        B_NoIteration; %TextEditBox, to select the number of iterations of the morpological operations.
        B_StartMorphOP; %Button, runs the morpological operations.
        B_InfoText; %Shows the info log text.
        
        B_AxesCheckRGBFRPlane; %axes handle that contains the RGB image in the check planes figure.
        B_AxesCheckRGBPlane; %axes handle that contains the RGB image in the check planes figure.
        B_AxesCheckPlaneGreen; %axes handle that contains the green plane in the imagecheck planes figure.
        B_AxesCheckPlaneBlue; %axes handle that contains the blue plane image in the check planes figure.
        B_AxesCheckPlaneRed; %axes handle that contains the red plane image in the check planes figure.
        B_AxesCheckPlaneFarRed; %axes handle that contains the farred plane image in the check planes figure.

        B_ColorPlaneGreen %Popupmenu, to change the color plane in the check planes figure.
        B_ColorPlaneBlue %Popupmenu, to change the color plane in the check planes figure.
        B_ColorPlaneRed %Popupmenu, to change the color plane in the check planes figure.
        B_ColorPlaneFarRed %Popupmenu, to change the color plane in the check planes figure.
        
        B_CheckPOK %Button, to confirm changes in the check planes figure.
        B_CheckPBack %Button, to cancel and close the check planes figure.
        B_CheckPText %Text, shows information text in the check planes figure.
        
        B_AxesCheckRGB_noBC
        B_AxesCheckRGB_BC
        B_AxesCheckBrightnessGreen
        B_AxesCheckBrightnessBlue
        B_AxesCheckBrightnessRed
        B_AxesCheckBrightnessFarRed
        
        B_CurBrightImGreen
        B_SelectBrightImGreen
        B_CreateBrightImGreen
        B_DeleteBrightImGreen
        
        B_CurBrightImBlue
        B_SelectBrightImBlue
        B_CreateBrightImBlue
        B_DeleteBrightImBlue
        
        B_CurBrightImRed
        B_SelectBrightImRed
        B_CreateBrightImRed
        B_DeleteBrightImRed
        
        B_CurBrightImFarRed
        B_SelectBrightImFarRed
        B_CreateBrightImFarRed
        B_DeleteBrightImFarRed
    end
    
    methods
        function obj = viewEdit(mainCard)
            % constructor
            
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
            mainPanelBox = uix.HBox( 'Parent', mainCard, 'Spacing',5,'Padding',5);
            
            obj.panelPicture = uix.Panel('Parent', mainPanelBox,'FontSize',fontSizeB,'Padding',5);
            obj.panelControl = uix.Panel('Parent', mainPanelBox,'Title', 'SEGMENTATION' ,'FontSize',fontSizeB,'TitlePosition','centertop');
            set( mainPanelBox, 'MinimumWidths', [1 320] );
            set( mainPanelBox, 'Widths', [-4 -1] );
            set(obj.panelPicture,'Title','Picture');
            obj.hAP = axes('Parent',uicontainer('Parent', obj.panelPicture),'FontUnits','normalized','Fontsize',0.015);
%             obj.hAP = axes('Parent',uicontainer('Parent', obj.panelPicture),'FontUnits','normalized','Fontsize',0.35);
            axis image
            set(obj.hAP, 'LooseInset', [0,0,0,0]);
            
            PanelVBox = uix.VBox('Parent',obj.panelControl,'Spacing', 1,'Padding',1);
            
            PanelControl = uix.Panel('Parent',PanelVBox,'Title','Main controls','FontSize',fontSizeB,'Padding',2);
            PanelAlpha = uix.Panel('Parent',PanelVBox,'Title','Image Overlay','FontSize',fontSizeB,'Padding',2);
            PanelBinari = uix.Panel('Parent',PanelVBox,'Title','Binarization','FontSize',fontSizeB,'Padding',2);
            PanelMorphOp = uix.Panel('Parent',PanelVBox,'Title','Morphological operations','FontSize',fontSizeB,'Padding',2);
            PanelInfo = uix.Panel('Parent',PanelVBox,'Title','Info:','FontSize',fontSizeB,'Padding',2);
            
            set( PanelVBox, 'Heights', [-4.5 -2.5 -5 -5.5 -6], 'Spacing', 1 );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%% Panel Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxControl = uix.VButtonBox('Parent', PanelControl,'ButtonSize',[600 600],'Spacing', 3 ,'Padding',3);
            
            HBoxControl1 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 40], 'Spacing',3);
            obj.B_NewPic = uicontrol( 'Parent', HBoxControl1,'FontUnits','normalized','Fontsize',0.4, 'String', sprintf('\x2633 New file') );
            obj.B_StartAnalyzeMode = uicontrol( 'Parent', HBoxControl1,'FontUnits','normalized','Fontsize',0.4,'Style','pushbutton', 'String', sprintf('Analyze \x25BA') ,'Enable','off');
            
            HBoxControl2 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 40], 'Spacing',3);
            obj.B_CheckMask = uicontrol( 'Parent', HBoxControl2,'FontUnits','normalized','Fontsize',0.4,'Style','togglebutton', 'String', sprintf('\x2593 Check mask') ,'Enable','off');
            obj.B_CheckPlanes = uicontrol( 'Parent', HBoxControl2,'FontUnits','normalized','Fontsize',0.4, 'String', sprintf('Check planes \x2750') ,'Enable','off');
            
            HBoxControl3 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 40],'Spacing',3);
            obj.B_Undo = uicontrol( 'Parent', HBoxControl3, 'String', sprintf('\x21BA Undo'),'FontUnits','normalized','Fontsize',0.4);
            obj.B_Redo = uicontrol( 'Parent', HBoxControl3, 'String', sprintf('Redo \x21BB'),'FontUnits','normalized','Fontsize',0.4);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%% Panel Image Overview %%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBoxAlpha = uix.VBox('Parent', PanelAlpha);
            %%%%%%%%%%%%%%%% 1. Row Image Selection %%%%%%%%%%%%%%%%%%%%%%%%
            HBoxAlpha2 = uix.HBox('Parent', mainVBoxAlpha,'Spacing',5,'Padding', 3 );
            
            HButtonBoxAlpha1_1 = uix.HButtonBox('Parent', HBoxAlpha2,'ButtonSize',[6000 20],'Padding', 3 );
            ThresholdModeText = uicontrol( 'Parent', HButtonBoxAlpha1_1,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Image:' );
            jh = findjobj_fast(ThresholdModeText);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            
            HButtonBoxAlpha1_2 = uix.HButtonBox('Parent', HBoxAlpha2,'ButtonSize',[6000 20],'Padding', 3 );
            obj.B_ImageOverlaySelection = uicontrol( 'Parent', HButtonBoxAlpha1_2,'Style','popupmenu','FontUnits','normalized','Fontsize',0.6, 'String', {'RGB Image' , 'Green Plane', 'Blue Plane', 'Red Plane', 'Farred Plane'} ,'Enable','off');
            
            set( HBoxAlpha2, 'Widths', [-1.3 -3.7] );
            %%%%%%%%%%%%%%%% 2. Row Alpha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxAlpha2 = uix.HBox('Parent', mainVBoxAlpha,'Spacing',5,'Padding', 3 );
            
            HButtonBoxAlpha2_1 = uix.HButtonBox('Parent', HBoxAlpha2,'ButtonSize',[6000 20],'Padding', 3 );
            AlphaText = uicontrol( 'Parent', HButtonBoxAlpha2_1,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Alpha:');
            jh = findjobj_fast(AlphaText);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            
            HButtonBoxAlpha2_4 = uix.HButtonBox('Parent', HBoxAlpha2,'ButtonSize',[20 20],'Padding', 1 );
            obj.B_AlphaActive = uicontrol( 'Parent', HButtonBoxAlpha2_4,'Style','checkbox','Value',1,'Tag','activeAlpha');
            
            HButtonBoxAlpha2_2 = uix.HButtonBox('Parent', HBoxAlpha2,'ButtonSize',[6000 18],'Padding', 3 );
            obj.B_Alpha = uicontrol( 'Parent', HButtonBoxAlpha2_2,'Style','slider','FontUnits','normalized','Fontsize',0.6, 'String', 'Alpha' ,'Tag','sliderAlpha','Enable','off');
            
            HButtonBoxAlpha2_3 = uix.HButtonBox('Parent', HBoxAlpha2,'ButtonSize',[6000 20],'Padding',3 );
            obj.B_AlphaValue = uicontrol( 'Parent', HButtonBoxAlpha2_3,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','textAlpha','Enable','off');
            
            set( HBoxAlpha2, 'Widths', [-0.5 -0.5 -2 -1] );
            

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%% Panel Hand Draw Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBoxBinari = uix.VBox('Parent', PanelBinari);
            
            %%%%%%%%%%%%%%%% 1. Row Threshold Mode %%%%%%%%%%%%%%%%%%%%%%%%
            HBoxBinari1 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5,'Padding', 3 );
            
            HButtonBoxBinari1_1 = uix.HButtonBox('Parent', HBoxBinari1,'ButtonSize',[6000 20],'Padding', 3 );
            ThresholdModeText = uicontrol( 'Parent', HButtonBoxBinari1_1,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Mode:' );
            jh = findjobj_fast(ThresholdModeText);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            
            HButtonBoxBinari1_2 = uix.HButtonBox('Parent', HBoxBinari1,'ButtonSize',[6000 20],'Padding', 3 );
            obj.B_ThresholdMode = uicontrol( 'Parent', HButtonBoxBinari1_2,'Style','popupmenu','FontUnits','normalized','Fontsize',0.6, 'String', {'Manual global threshold' , 'Automatic adaptive threshold', 'Combined manual and adaptive', 'Automatic Watershed I', 'Automatic Watershed II'} ,'Enable','off');
            
            set( HBoxBinari1, 'Widths', [-1 -3] );
            
            %%%%%%%%%%%%%%%% 2. Row Green Plane Fiber Back or Forground %%%%%%%%%%%%%%%%%%%%%%%%
            HBoxBinari2 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5,'Padding', 3 );
            
            HButtonBoxBinari2_1 = uix.HButtonBox('Parent', HBoxBinari2,'ButtonSize',[6000 20],'Padding', 3 );
            ThresholdModeText = uicontrol( 'Parent', HButtonBoxBinari2_1,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Green Plane:' );
            jh = findjobj_fast(ThresholdModeText);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            
            HButtonBoxBinari2_2 = uix.HButtonBox('Parent', HBoxBinari2,'ButtonSize',[6000 20],'Padding', 3 );
            obj.B_FiberForeBackGround = uicontrol( 'Parent', HButtonBoxBinari2_2,'Style','popupmenu','FontUnits','normalized','Fontsize',0.6, 'String', {'Fibers in Background (Black Pixels)','Fibers in Forground (White Pixels)' } ,'Enable','off');
            
            set( HBoxBinari2, 'Widths', [-1 -3] );
            
            %%%%%%%%%%%%%%%% 3. Row Threshold %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari3 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5,'Padding', 3 );
            
            HButtonBoxBinari3_1 = uix.HButtonBox('Parent', HBoxBinari3,'ButtonSize',[6000 20],'Padding', 3 );
            ThresholdText = uicontrol( 'Parent', HButtonBoxBinari3_1,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left','String', 'Threshold:' );
            jh = findjobj_fast(ThresholdText);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            
            HButtonBoxBinari3_2 = uix.HButtonBox('Parent', HBoxBinari3,'ButtonSize',[6000 18],'Padding', 3 );
            obj.B_Threshold = uicontrol( 'Parent', HButtonBoxBinari3_2,'Style','slider','FontUnits','normalized','Fontsize',0.6, 'String', 'Thresh','Tag','sliderThreshold' ,'Enable','off');
            
            HButtonBoxBinari3_3 = uix.HButtonBox('Parent', HBoxBinari3,'ButtonSize',[6000 20],'Padding', 3 );
            obj.B_ThresholdValue = uicontrol( 'Parent', HButtonBoxBinari3_3,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','textThreshold','Enable','off');
            
            set( HBoxBinari3, 'Widths', [-1 -2 -1] );
                       
            %%%%%%%%%%%%%%%% 4. Row Linewidth %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari5 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5,'Padding', 3 );
            
            HButtonBoxBinari5_1 = uix.HButtonBox('Parent', HBoxBinari5,'ButtonSize',[6000 20],'Padding', 3 );
            LineWidthText = uicontrol( 'Parent', HButtonBoxBinari5_1,'Style','text', 'FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left','String', 'Pen width:');
            jh = findjobj_fast(LineWidthText);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)

            HButtonBoxBinari5_2 = uix.HButtonBox('Parent', HBoxBinari5,'ButtonSize',[6000 20],'Padding', 3 );
            obj.B_LineWidth = uicontrol( 'Parent', HButtonBoxBinari5_2,'Style','slider','FontUnits','normalized','Fontsize',0.6, 'String', 'Pen width','Min',0,'Max',300,'SliderStep',[1/300,1/300],'Tag','sliderLinewidth' );
            
            HButtonBoxBinari5_3 = uix.HButtonBox('Parent', HBoxBinari5,'ButtonSize',[6000 20],'Padding', 3 );
            obj.B_LineWidthValue = uicontrol( 'Parent', HButtonBoxBinari5_3,'Style','edit','FontUnits','normalized','Fontsize',0.6,'Tag','textLinewidth');
            
            set( HBoxBinari5, 'Widths', [-1 -2 -1] );
            
            
            %%%%%%%%%%%%%%%% 5. Row Color/Invert %%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari6 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5,'Padding', 3 );
            
            HButtonBoxBinari6_1 = uix.HButtonBox('Parent', HBoxBinari6,'ButtonSize',[6000 20],'Padding', 3 );
            ColorText = uicontrol( 'Parent', HButtonBoxBinari6_1,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Pen color:' );
            jh = findjobj_fast(ColorText);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            
            HButtonBoxBinari6_2 = uix.HButtonBox('Parent', HBoxBinari6,'ButtonSize',[6000 20],'Padding', 3 );
            obj.B_Color = uicontrol( 'Parent', HButtonBoxBinari6_2,'Style','popupmenu','FontUnits','normalized','Fontsize',0.6, 'String', {'White' , 'Black', 'White fill region', 'Black fill region'} ,'Enable','off');
            
            HButtonBoxBinari6_3 = uix.HButtonBox('Parent', HBoxBinari6,'ButtonSize',[6000 35],'Padding', 3 );
            obj.B_Invert = uicontrol( 'Parent', HButtonBoxBinari6_3,'FontUnits','normalized','Fontsize',0.6, 'String', 'Invert' ,'Enable','off');
            
            set( HBoxBinari6, 'Widths', [-1 -2 -1] );

            %%%%%%%%%%%%%% Morph Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            MainVBoxMorph = uix.VBox('Parent',PanelMorphOp,'Padding', 3 );
            
            HButtonBoxMorph1 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 20],'Spacing',0,'Padding', 3);
            HButtonBoxMorph2 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 20],'Spacing',0,'Padding', 3 );
            HButtonBoxMorph3 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 20],'Spacing',0,'Padding', 3 );
            HButtonBoxMorph4 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 20],'Spacing',0,'Padding', 3 );
            HButtonBoxMorph5 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 40],'Spacing',0,'Padding', 3 );
            
            tempH = uicontrol( 'Parent', HButtonBoxMorph1,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Morphol. operation:');
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            String = {'choose operation' ,'remove incomplete objects','close small gaps' ,'smoothing','erode', 'dilate', 'skel' ,'thin','shrink','majority','remove','open','close'};
            obj.B_MorphOP = uicontrol( 'Parent', HButtonBoxMorph1,'Style','popupmenu','FontUnits','normalized','Fontsize',0.6, 'String', String ,'Enable','off');
            
            tempH = uicontrol( 'Parent', HButtonBoxMorph2,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Structuring element:');
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            String = {'choose SE' , 'diamond', 'disk', 'octagon' ,'square'};
            obj.B_ShapeSE = uicontrol( 'Parent', HButtonBoxMorph2,'Style','popupmenu','FontUnits','normalized','Fontsize',0.6, 'String', String,'Enable','off' );
            
            tempH = uicontrol( 'Parent', HButtonBoxMorph3,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'Size of structuring element:');
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            obj.B_SizeSE = uicontrol( 'Parent', HButtonBoxMorph3,'Style','edit','FontUnits','normalized','Fontsize',0.6,'String','1','Enable','off' );
            
            tempH = uicontrol( 'Parent', HButtonBoxMorph4,'Style','text','FontUnits','normalized','Fontsize',0.6, 'HorizontalAlignment','left', 'String', 'No. of iterations / Size gaps:');
            jh = findjobj_fast(tempH);
            jh.setVerticalAlignment(javax.swing.JLabel.CENTER)
            obj.B_NoIteration = uicontrol( 'Parent', HButtonBoxMorph4,'Style','edit','FontUnits','normalized','Fontsize',0.6,'String','1','Enable','off' );
            
            obj.B_StartMorphOP = uicontrol( 'Parent', HButtonBoxMorph5, 'String', 'Run morphological operation','FontUnits','normalized','Fontsize',0.5 ,'Enable','off' );
            
            %%%%%%%%%%%%%% Panel Info Text %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.B_InfoText = uicontrol('Parent',PanelInfo,'Style','listbox','Fontsize', fontSizeM,'String',{''});
            
            %%%%%%%%%%%%%% Set Init Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            set(obj.B_LineWidth,'Value',1);
            set(obj.B_Threshold,'Value',0.1);
            set(obj.B_Alpha,'Value',1);
            set(obj.B_MorphOP,'Value',2);
            
            set(obj.B_LineWidthValue,'String',num2str(get(obj.B_LineWidth,'Value')));
            set(obj.B_ThresholdValue,'String',num2str(get(obj.B_Threshold,'Value')));
            set(obj.B_AlphaValue,'String',num2str(get(obj.B_Alpha,'Value')));
            
            set(obj.B_ThresholdMode,'Value',4);
            %%%%%%%%%%%%%%% call edit functions for GUI
            obj.setToolTipStrings();

        end % end constructor
        
        function checkPlanes(obj,Pics,mainFig)
            % Opens a new figure to show all founded color plane images.
            % User can change the plane if the program classified these
            % wrong.
            %
            %   checkPlanes(obj,Pics);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewEdit object
            %           Pics:   Cell-Array containing all color-plane
            %                   images and the original RGB image
            %
            
            if ismac
                fontSizeS = 10; % Font size small
                fontSizeM = 14; % Font size medium
                fontSizeB = 18; % Font size big
            elseif ispc
                fontSizeS = 10*0.75; % Font size small
                fontSizeM = 14*0.75; % Font size medium
                fontSizeB = 18*0.75; % Font size big
            else
                fontSizeS = 10; % Font size small
                fontSizeM = 14; % Font size medium
                fontSizeB = 18; % Font size big
                
            end
            
            
            obj.hFCP = figure('NumberTitle','off','ToolBar','none',...
                'MenuBar','none','Name','Check Color Planes',...
                'Units','normalized','Visible','off','Tag','CheckPlanesFigure',...
                'InvertHardcopy','off');
            %get position of mainFigure
            posMainFig = get(mainFig,'Position');
            
            set(obj.hFCP, 'position', [posMainFig(1) posMainFig(2) 0.8 0.8]);
            movegui(obj.hFCP,'center')
            set(obj.hFCP,'WindowStyle','modal');
            
            tabPanel = uix.TabPanel( 'Parent', obj.hFCP, 'FontSize',fontSizeB,'Padding',5,'TabWidth',300);
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Color Plane Tab
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            MainVBoxColorPlane = uix.VBox('Parent',tabPanel,'Spacing', 5,'Padding',5);
            MainGridColor = uix.Grid('Parent',MainVBoxColorPlane,'Padding',5);
            
            VBox1ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGBFRPlane = axes('Parent',VBox1ColorPlane,'ActivePositionProperty','position');
            axis image
            imshow(Pics{3})
            uicontrol( 'Parent', VBox1ColorPlane,'Style','text', 'String', 'RGB Image generated from Red Green Blue and FarRed plane','FontUnits','normalized','Fontsize',0.35);
            set(VBox1ColorPlane,'Heights',[-10 40])
            
            VBox2ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGBPlane = axes('Parent',VBox2ColorPlane,'ActivePositionProperty','position');
            axis image
            imshow(Pics{9})
            uicontrol( 'Parent', VBox2ColorPlane,'Style','text', 'String', 'RGB Image generated from Red Green and Blue Plane (no FarRed)','FontUnits','normalized','Fontsize',0.35);
            set(VBox2ColorPlane,'Heights',[-10 40])
            
            VBox3ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneGreen = axes('Parent',uicontainer('Parent', VBox3ColorPlane),'ActivePositionProperty','position','Units','normalized');
            axis image
            set(obj.B_AxesCheckPlaneGreen, 'position', [0 0 1 1]);
            imshow(Pics{5})
            String = {'Green Plane - Collagen (pseudo color: green)' , 'Blue Plane - Type 1 fibers (pseudo color: blue)', 'Red Plane - Type 2 fibers (all) (pseudo color: red)', 'FarRed Plane - Type 2 fibers specification (2x,2a,2ax) (pseudo color: yellow)'};
            obj.B_ColorPlaneGreen = uicontrol( 'Parent', VBox3ColorPlane,'Style','popupmenu', 'String', String, 'Value' ,1,'FontUnits','normalized','Fontsize',0.35);
            set(VBox3ColorPlane,'Heights',[-10 40])
            
            VBox4ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneBlue = axes('Parent',uicontainer('Parent', VBox4ColorPlane),'ActivePositionProperty','position','Units','normalized');
            axis image
            set(obj.B_AxesCheckPlaneBlue, 'position', [0 0 1 1]);
            imshow(Pics{6})
%             VButtonBox4 = uix.VButtonBox('Parent', VBox4ColorPlane,'ButtonSize',[400 40]);
            String = {'Green Plane - Collagen (pseudo color: green)' , 'Blue Plane - Type 1 fibers (pseudo color: blue)', 'Red Plane - Type 2 fibers (all) (pseudo color: red)', 'FarRed Plane - Type 2 fibers specification (2x,2a,2ax) (pseudo color: yellow)'};
            obj.B_ColorPlaneBlue = uicontrol( 'Parent', VBox4ColorPlane,'Style','popupmenu', 'String', String , 'Value' ,2,'FontUnits','normalized','Fontsize',0.35);
            set(VBox4ColorPlane,'Heights',[-10 40])
            
            VBox5ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneRed = axes('Parent',uicontainer('Parent', VBox5ColorPlane),'ActivePositionProperty','position','Units','normalized');
            axis image
            set(obj.B_AxesCheckPlaneRed, 'position', [0 0 1 1]);
            imshow(Pics{7})
%             VButtonBox5 = uix.VButtonBox('Parent', VBox5ColorPlane,'ButtonSize',[400 40]);
            String = {'Green Plane - Collagen (pseudo color: green)' , 'Blue Plane - Type 1 fibers (pseudo color: blue)', 'Red Plane - Type 2 fibers (all) (pseudo color: red)', 'FarRed Plane - Type 2 fibers specification (2x,2a,2ax) (pseudo color: yellow)'};
            obj.B_ColorPlaneRed = uicontrol( 'Parent', VBox5ColorPlane,'Style','popupmenu', 'String', String , 'Value' ,3,'FontUnits','normalized','Fontsize',0.35);
            set(VBox5ColorPlane,'Heights',[-10 40])
            
            VBox6ColorPlane = uix.VBox('Parent',MainGridColor,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneFarRed = axes('Parent',uicontainer('Parent', VBox6ColorPlane),'ActivePositionProperty','position','Units','normalized');
            axis image
            set(obj.B_AxesCheckPlaneFarRed, 'position', [0 0 1 1]);
            imshow(Pics{8})
%             VButtonBox6 = uix.VButtonBox('Parent', VBox6ColorPlane,'ButtonSize',[400 40]);
            String = {'Green Plane - Collagen (pseudo color: green)' , 'Blue Plane - Type 1 fibers (pseudo color: blue)', 'Red Plane - Type 2 fibers (all) (pseudo color: red)', 'FarRed Plane - Type 2 fibers specification (2x,2a,2ax) (pseudo color: yellow)'};
            obj.B_ColorPlaneFarRed = uicontrol( 'Parent', VBox6ColorPlane,'Style','popupmenu', 'String', String , 'Value' ,4,'FontUnits','normalized','Fontsize',0.35);
            set(VBox6ColorPlane,'Heights',[-10 40])
            
            HBox = uix.HBox('Parent',MainVBoxColorPlane,'Spacing', 5,'Padding',5);
            
            HButtonBox1ColorPlane = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPText = uicontrol( 'Parent', HButtonBox1ColorPlane,'Style','text', 'String', 'Confirm the changes with OK.','FontSize',fontSizeB);
            
            HButtonBox2ColorPlane = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPBack = uicontrol( 'Parent', HButtonBox2ColorPlane,'String', 'Back to Edit-Mode','FontSize',fontSizeB);
            
            HButtonBox3ColorPlane = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPOK = uicontrol( 'Parent', HButtonBox3ColorPlane,'String', 'OK','FontSize',fontSizeB);
            
            set( MainGridColor, 'Heights', [-1 -1 ], 'Widths', [-1 -1 -1] ,'Spacing',3);
            set(MainVBoxColorPlane,'Heights',[-10 -1])
            set(HBox,'Widths',[-3 -1 -1])
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Brigntness Correction images Tab
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            MainVBoxBrightness = uix.VBox('Parent',tabPanel,'Spacing', 5,'Padding',5);
            MainGridBrightness = uix.Grid('Parent',MainVBoxBrightness,'Padding',5,'Spacing', 5);
            
            % Image befor brightness correction
            VBox1Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGB_noBC= axes('Parent',VBox1Brightness,'ActivePositionProperty','position');
            imshow(Pics{10})
            axis image
            VButtonBox1 = uix.VButtonBox('Parent', VBox1Brightness,'ButtonSize',[2000 20]);
            uicontrol( 'Parent', VButtonBox1,'Style','text', 'String', 'RGB Image befor brightness correction','FontUnits','normalized','Fontsize',0.7);
            uix.Empty( 'Parent', VBox1Brightness );
            set(VBox1Brightness,'Heights',[-10 30 30])
            
            % Image after brightness correction
            VBox2Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGB_BC = axes('Parent',VBox2Brightness,'ActivePositionProperty','position');
            imshow(Pics{3})
            axis image
            VButtonBox2 = uix.VButtonBox('Parent', VBox2Brightness,'ButtonSize',[2000 20]);
            uicontrol( 'Parent', VButtonBox2,'Style','text', 'String', 'RGB Image after brightness correction','FontUnits','normalized','Fontsize',0.7);
            uix.Empty( 'Parent', VBox2Brightness );
            set(VBox2Brightness,'Heights',[-10 30 30])
            
            % Brightness correction image for Green Plane
            VBox3Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckBrightnessGreen = axes('Parent',uicontainer('Parent', VBox3Brightness),'ActivePositionProperty','position','Units','normalized');
            axis image
            set(obj.B_AxesCheckBrightnessGreen, 'position', [0 0 1 1]);
            imshow(Pics{11},[])
            caxis([0, 1])
            HBox31Brightness = uix.HButtonBox('Parent',VBox3Brightness,'Spacing', 5,'Padding',5,'ButtonSize',[600 20]);
            uicontrol( 'Parent', HBox31Brightness,'Style','text', 'String', 'Current image Green plane:','FontUnits','normalized','Fontsize',0.6);
            obj.B_CurBrightImGreen = uicontrol( 'Parent', HBox31Brightness,'Style','text', 'String', Pics{12},'FontUnits','normalized','Fontsize',0.6);
            HBox32Brightness = uix.HButtonBox('Parent',VBox3Brightness,'Spacing', 1,'Padding',1,'ButtonSize',[600 30]);
            obj.B_SelectBrightImGreen = uicontrol( 'Parent', HBox32Brightness,'String', 'Select new image','FontUnits','normalized','Fontsize',0.5,'Tag','SelectBCGreen');
            obj.B_CreateBrightImGreen = uicontrol( 'Parent', HBox32Brightness,'String', 'Create image','FontUnits','normalized','Fontsize',0.5,'Tag','CreateBCGreen');
            obj.B_DeleteBrightImGreen = uicontrol( 'Parent', HBox32Brightness,'String', 'Delete image','FontUnits','normalized','Fontsize',0.5,'Tag','DeleteBCGreen');
            
            set(VBox3Brightness,'Heights',[-10 30 30])
            
            % Brightness correction image for Blue Plane
            VBox4Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckBrightnessBlue = axes('Parent',uicontainer('Parent', VBox4Brightness),'ActivePositionProperty','position','Units','normalized');
            axis image
            set(obj.B_AxesCheckBrightnessBlue, 'position', [0 0 1 1]);
            imshow(Pics{13},[])
            caxis([0, 1])
            HBox41Brightness = uix.HButtonBox('Parent',VBox4Brightness,'Spacing', 5,'Padding',5,'ButtonSize',[600 20]);
            uicontrol( 'Parent', HBox41Brightness,'Style','text', 'String', 'Current image Blue plane:','FontUnits','normalized','Fontsize',0.6);
            obj.B_CurBrightImBlue = uicontrol( 'Parent', HBox41Brightness,'Style','text', 'String', Pics{14},'FontUnits','normalized','Fontsize',0.6);
            HBox42Brightness = uix.HButtonBox('Parent',VBox4Brightness,'Spacing', 1,'Padding',1,'ButtonSize',[600 30]);
            obj.B_SelectBrightImBlue = uicontrol( 'Parent', HBox42Brightness,'String', 'Select new image','FontUnits','normalized','Fontsize',0.5,'Tag','SelectBCBlue');
            obj.B_CreateBrightImBlue = uicontrol( 'Parent', HBox42Brightness,'String', 'Create image','FontUnits','normalized','Fontsize',0.5,'Tag','CreateBCBlue');
            obj.B_DeleteBrightImBlue = uicontrol( 'Parent', HBox42Brightness,'String', 'Delete image','FontUnits','normalized','Fontsize',0.5,'Tag','DeleteBCBlue');
            
            set(VBox4Brightness,'Heights',[-10 30 30])
            
            % Brightness correction image for Red Plane
            VBox5Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckBrightnessRed = axes('Parent',uicontainer('Parent', VBox5Brightness),'ActivePositionProperty','position','Units','normalized');
            axis image
            set(obj.B_AxesCheckBrightnessRed, 'position', [0 0 1 1]);
            imshow(Pics{15},[])
            caxis([0, 1])
            HBox51Brightness = uix.HButtonBox('Parent',VBox5Brightness,'Spacing', 5,'Padding',5,'ButtonSize',[600 20]);
            uicontrol( 'Parent', HBox51Brightness,'Style','text', 'String', 'Current image Red plane:','FontUnits','normalized','Fontsize',0.6);
            obj.B_CurBrightImRed = uicontrol( 'Parent', HBox51Brightness,'Style','text', 'String', Pics{16},'FontUnits','normalized','Fontsize',0.6);
            HBox52Brightness = uix.HButtonBox('Parent',VBox5Brightness,'Spacing', 1,'Padding',1,'ButtonSize',[600 30]);
            obj.B_SelectBrightImRed = uicontrol( 'Parent', HBox52Brightness,'String', 'Select new image','FontUnits','normalized','Fontsize',0.5,'Tag','SelectBCRed');
            obj.B_CreateBrightImRed = uicontrol( 'Parent', HBox52Brightness,'String', 'Create image','FontUnits','normalized','Fontsize',0.5,'Tag','CreateBCRed');
            obj.B_DeleteBrightImRed = uicontrol( 'Parent', HBox52Brightness,'String', 'Delete image','FontUnits','normalized','Fontsize',0.5,'Tag','DeleteBCRed');
            
            set(VBox5Brightness,'Heights',[-10 30 30])
            
            % Brightness correction image for FarRed Plane
            VBox6Brightness = uix.VBox('Parent',MainGridBrightness,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckBrightnessFarRed = axes('Parent',uicontainer('Parent', VBox6Brightness),'ActivePositionProperty','position','Units','normalized');
            axis image
            set(obj.B_AxesCheckBrightnessFarRed, 'position', [0 0 1 1]);
            imshow(Pics{17},[])
            caxis([0, 1])
            HBox61Brightness = uix.HButtonBox('Parent',VBox6Brightness,'Spacing', 5,'Padding',5,'ButtonSize',[600 20]);
            uicontrol( 'Parent', HBox61Brightness,'Style','text', 'String', 'Current image Farred plane:','FontUnits','normalized','Fontsize',0.6);
            obj.B_CurBrightImFarRed = uicontrol( 'Parent', HBox61Brightness,'Style','text', 'String', Pics{18},'FontUnits','normalized','Fontsize',0.6);
            HBox62Brightness = uix.HButtonBox('Parent',VBox6Brightness,'Spacing', 1,'Padding',1,'ButtonSize',[600 30]);
            obj.B_SelectBrightImFarRed = uicontrol( 'Parent', HBox62Brightness,'String', 'Select new image','FontUnits','normalized','Fontsize',0.5,'Tag','SelectBCFarRed');
            obj.B_CreateBrightImFarRed = uicontrol( 'Parent', HBox62Brightness,'String', 'Create image','FontUnits','normalized','Fontsize',0.5,'Tag','CreateBCFarRed');
            obj.B_DeleteBrightImFarRed = uicontrol( 'Parent', HBox62Brightness,'String', 'Delete image','FontUnits','normalized','Fontsize',0.5,'Tag','DeleteBCFarRed');
            
            set(VBox6Brightness,'Heights',[-10 30 30])
            
            set( MainGridBrightness, 'Heights', [-1 -1 ], 'Widths', [-1 -1 -1] ,'Spacing',10);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Sizes
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            tabPanel.TabTitles = {'Color Plane images', 'Brightness Correction images'};
            tabPanel.TabWidth = -1;
            set(obj.hFCP,'Visible','on');
            drawnow;
        end
        
        function infoMessage(obj,Text)
            % Shows info text to the user.
            %
            %   infoMessage(obj,Text);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewEdit object
            %           Text:   Cellaray containing the info text
            %
            beep
            uiwait(msgbox(Text,'Info','warn','modal'));
        end
        
        function setToolTipStrings(obj)
            % Set all tooltip strings in the properties of the operationg
            % elements that are shown in the main Edit GUI.
            %
            %   setToolTipStrings(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to viewEdit object
            %
            UndoToolTip = sprintf('Undo binary image.');
            
            RedoToolTip = sprintf('Redo binary image.');
            
            NewPicToolTip = sprintf('Select a new file for further processing.');
            
            CheckPlanesToolTip = sprintf(['Opens a menue to check or change the color plane images: \n ',...
                'Red, Green, Blue and Farred images.']);
            
            CheckMaskToolTip = sprintf(['Shows found objects in different RGB colors \n',...
                'to check the mask for further segmentation.']);
            
            StartAnaModeToolTip = sprintf(['Starts image analyzing mode.']);
            
            ThreshModeToolTip = sprintf(['Select threshold method for image binarization.']);
            
            ThreshToolTip = sprintf(['Select threshold for image binarization.']);
            
            AlphaToolTip = sprintf(['Change transparency of the binary image.']);
            
            LineWidthToolTip = sprintf(['Change linewidth for drawing into the binary image.']);
            
            ColorToolTip = sprintf(['Choose color mode for drawing into the binary image.']);
            
            InvertToolTip = sprintf(['Invert the binary image. \n',...
                'Has no effect on segmentation.']);
            
            MorphToolTip = sprintf(['Select morphological method.']);
            
            StructuringToolTip = sprintf(['Select structuring element']);
            
            StructuringSizeToolTip = sprintf(['Select the size of the structuring element']);
            
            NoOfIterationsToolTip = sprintf(['Select the number of iterations']);
            
            RunMorphToolTip = sprintf(['Perform the morphological operation \n',...
                'to the binary image']);
            
            set(obj.B_Undo,'tooltipstring',UndoToolTip);
            set(obj.B_Redo,'tooltipstring',RedoToolTip);
            set(obj.B_NewPic,'tooltipstring',NewPicToolTip);
            set(obj.B_CheckPlanes,'tooltipstring',CheckPlanesToolTip);
            set(obj.B_CheckMask,'tooltipstring',CheckMaskToolTip);
            set(obj.B_StartAnalyzeMode,'tooltipstring',StartAnaModeToolTip);
            
            set(obj.B_ThresholdMode,'tooltipstring',ThreshModeToolTip);
            set(obj.B_Threshold,'tooltipstring',ThreshToolTip);
            set(obj.B_ThresholdValue,'tooltipstring',ThreshToolTip);
            set(obj.B_Alpha,'tooltipstring',AlphaToolTip);
            set(obj.B_AlphaValue,'tooltipstring',AlphaToolTip);
            set(obj.B_LineWidth,'tooltipstring',LineWidthToolTip);
            set(obj.B_LineWidthValue,'tooltipstring',LineWidthToolTip);
            set(obj.B_Color,'tooltipstring',ColorToolTip);
            set(obj.B_Invert,'tooltipstring',InvertToolTip);
            
            set(obj.B_MorphOP,'tooltipstring',MorphToolTip);
            set(obj.B_ShapeSE,'tooltipstring',StructuringToolTip);
            set(obj.B_SizeSE,'tooltipstring',StructuringSizeToolTip);
            set(obj.B_NoIteration,'tooltipstring',NoOfIterationsToolTip);
            set(obj.B_StartMorphOP,'tooltipstring',RunMorphToolTip);
        end
        
        function delete(obj)
            
        end
        
    end
    
    
    
end

