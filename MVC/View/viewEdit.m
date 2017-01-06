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
        B_CheckPlanes;%Button, opens a new figure to check and change the image planes.
        B_StartAnalyzeMode; %Button, close the EditMode and opens the the AnalyzeMode.
        
        B_Alpha; %Slider, to change the transperancy between the binary and the RGB picture.
        B_AlphaValue; % TextEditBox, to change the transperancy between the binary and the RGB picture.

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
        
        B_AxesCheckRGB; %axes handle that contains the RGB image in the check planes figure.
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
    end
    
    methods
        function obj = viewEdit(mainCard)
            % constructor
            fontSizeS = 10; % Font size small
            fontSizeM = 12; % Font size medium
            fontSizeB = 16; % Font size big
            
            mainPanelBox = uix.HBox( 'Parent', mainCard, 'Spacing',5,'Padding',5);
            
            obj.panelPicture = uix.Panel('Parent', mainPanelBox,'FontSize',fontSizeB,'Padding',5);
            obj.panelControl = uix.Panel('Parent', mainPanelBox,'Title', 'Control Panel' ,'FontSize',fontSizeB);
            set( mainPanelBox, 'MinimumWidths', [1 320] );
            set( mainPanelBox, 'Widths', [-4 -1] );
            set(obj.panelPicture,'Title','Picture');
            
            obj.hAP = axes('Parent',uicontainer('Parent', obj.panelPicture));
            axis image
            set(obj.hAP, 'LooseInset', [0,0,0,0]);
            
            PanelVBox = uix.VBox('Parent',obj.panelControl,'Spacing', 5,'Padding',5);
            
            PanelControl = uix.Panel('Parent',PanelVBox,'Title','Main controls','FontSize',fontSizeB,'Padding',5);
            PanelBinari = uix.Panel('Parent',PanelVBox,'Title','Binarization operations ','FontSize',fontSizeB,'Padding',5);
            PanelMorphOp = uix.Panel('Parent',PanelVBox,'Title','Morphological operations','FontSize',fontSizeB,'Padding',5);
            PanelInfo = uix.Panel('Parent',PanelVBox,'Title','Info text log','FontSize',fontSizeB,'Padding',5);
            
            set( PanelVBox, 'Heights', [-1 -1 -1 -1], 'Spacing', 5 );
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%% Panel Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBBoxControl = uix.VButtonBox('Parent', PanelControl,'ButtonSize',[600 600],'Spacing', 5 );
            
            HBoxControl1 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 600],'Padding',5, 'Spacing',5);
            obj.B_Undo = uicontrol( 'Parent', HBoxControl1, 'String', '<- Undo','FontSize',fontSizeB );
            obj.B_Redo = uicontrol( 'Parent', HBoxControl1, 'String', 'Redo ->','FontSize',fontSizeB );
            
            
            HBoxControl2 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 600],'Padding',5, 'Spacing',5);
            obj.B_NewPic = uicontrol( 'Parent', HBoxControl2,'FontSize',fontSizeB, 'String', 'New image' );
            obj.B_CheckPlanes = uicontrol( 'Parent', HBoxControl2,'FontSize',fontSizeB, 'String', 'Check planes' ,'Enable','off');
            
            HBoxControl3 = uix.HButtonBox('Parent', mainVBBoxControl,'ButtonSize',[600 600],'Padding',5,'Spacing',5);
            obj.B_StartAnalyzeMode = uicontrol( 'Parent', HBoxControl3,'FontSize',fontSizeB,'Style','pushbutton', 'String', 'Start analyzing mode' ,'Enable','off');

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%% Panel Hand Draw Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%
            mainVBoxBinari = uix.VBox('Parent', PanelBinari);
            
            %%%%%%%%%%%%%%%% 1. Row Threshold Mode %%%%%%%%%%%%%%%%%%%%%%%%
            HBoxBinari1 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5);
            
            HButtonBoxBinari11 = uix.HButtonBox('Parent', HBoxBinari1,'ButtonSize',[6000 20],'Padding', 1 );
            ThresholdModeText = uicontrol( 'Parent', HButtonBoxBinari11,'Style','text','FontSize',fontSizeM, 'String', 'Threshold Mode :' );
            
            HButtonBoxBinari12 = uix.HButtonBox('Parent', HBoxBinari1,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_ThresholdMode = uicontrol( 'Parent', HButtonBoxBinari12,'Style','popupmenu','FontSize',fontSizeM, 'String', {'Manual global' , 'Automatic adaptive', 'both'} ,'Enable','off');
            
            set( HBoxBinari1, 'Widths', [-1 -2] );
            
            %%%%%%%%%%%%%%%% 2. Row Threshold %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari2 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5);
            
            HButtonBoxBinari21 = uix.HButtonBox('Parent', HBoxBinari2,'ButtonSize',[6000 20],'Padding', 1 );
            ThresholdText = uicontrol( 'Parent', HButtonBoxBinari21,'Style','text','FontSize',fontSizeM, 'String', 'Threshold:' );
            
            HButtonBoxBinari22 = uix.HButtonBox('Parent', HBoxBinari2,'ButtonSize',[6000 18],'Padding', 1 );
            obj.B_Threshold = uicontrol( 'Parent', HButtonBoxBinari22,'Style','slider', 'String', 'Thresh','Tag','sliderThreshold' ,'Enable','off');
            
            HButtonBoxBinari23 = uix.HButtonBox('Parent', HBoxBinari2,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_ThresholdValue = uicontrol( 'Parent', HButtonBoxBinari23,'Style','edit','FontSize',fontSizeM,'Tag','textThreshold','Enable','off');
            
            set( HBoxBinari2, 'Widths', [-1 -2 -1] );
            
            
            %%%%%%%%%%%%%%%% 3. Row Alpha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari3 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5);
            
            HButtonBoxBinari31 = uix.HButtonBox('Parent', HBoxBinari3,'ButtonSize',[6000 20],'Padding', 1 );
            AlphaText = uicontrol( 'Parent', HButtonBoxBinari31,'Style','text','FontSize',fontSizeM, 'String', 'Alpha:');
            
            HButtonBoxBinari32 = uix.HButtonBox('Parent', HBoxBinari3,'ButtonSize',[6000 18],'Padding', 1 );
            obj.B_Alpha = uicontrol( 'Parent', HButtonBoxBinari32,'Style','slider', 'String', 'Alpha' ,'Tag','sliderAlpha','Enable','off');
            
            HButtonBoxBinari33 = uix.HButtonBox('Parent', HBoxBinari3,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_AlphaValue = uicontrol( 'Parent', HButtonBoxBinari33,'Style','edit','FontSize',fontSizeM,'Tag','textAlpha','Enable','off');
            
            set( HBoxBinari3, 'Widths', [-1 -2 -1] );
            
            
            %%%%%%%%%%%%%%%% 3. Row Linewidth %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari4 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5);
            
            HButtonBoxBinari41 = uix.HButtonBox('Parent', HBoxBinari4,'ButtonSize',[6000 20],'Padding', 1 );
            LineWidthText = uicontrol( 'Parent', HButtonBoxBinari41,'Style','text', 'FontSize',fontSizeM ,'String', 'LineWidth:');
            
            HButtonBoxBinari42 = uix.HButtonBox('Parent', HBoxBinari4,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_LineWidth = uicontrol( 'Parent', HButtonBoxBinari42,'Style','slider', 'String', 'LineWidth','Min',0,'Max',10,'SliderStep',[1/10,1/10],'Tag','sliderLinewidth' );
            
            HButtonBoxBinari43 = uix.HButtonBox('Parent', HBoxBinari4,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_LineWidthValue = uicontrol( 'Parent', HButtonBoxBinari43,'Style','edit','FontSize',fontSizeM,'Tag','textLinewidth');
            
            set( HBoxBinari4, 'Widths', [-1 -2 -1] );
            
            
            %%%%%%%%%%%%%%%% 3. Row Color/Invert %%%%%%%%%%%%%%%%%%%%%%%%%%
            
            HBoxBinari5 = uix.HBox('Parent', mainVBoxBinari,'Spacing',5);
            
            HButtonBoxBinari51 = uix.HButtonBox('Parent', HBoxBinari5,'ButtonSize',[6000 20],'Padding', 1 );
            ColorText = uicontrol( 'Parent', HButtonBoxBinari51,'Style','text','FontSize',fontSizeM, 'String', 'Color:' );
            
            HButtonBoxBinari52 = uix.HButtonBox('Parent', HBoxBinari5,'ButtonSize',[6000 20],'Padding', 1 );
            obj.B_Color = uicontrol( 'Parent', HButtonBoxBinari52,'Style','popupmenu','FontSize',fontSizeM, 'String', {'White' , 'Black'} ,'Enable','off');
            
            HButtonBoxBinari53 = uix.HButtonBox('Parent', HBoxBinari5,'ButtonSize',[6000 30],'Padding', 1 );
            obj.B_Invert = uicontrol( 'Parent', HButtonBoxBinari53,'FontSize',fontSizeM, 'String', 'Invert' ,'Enable','off');
            
            set( HBoxBinari5, 'Widths', [-1 -2 -1] );

            %%%%%%%%%%%%%% Morph Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            MainVBoxMorph = uix.VBox('Parent',PanelMorphOp);
            
            HButtonBoxMorph1 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 20]);
            HButtonBoxMorph2 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 20]);
            HButtonBoxMorph3 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 20]);
            HButtonBoxMorph4 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 20]);
            HButtonBoxMorph5 = uix.HButtonBox('Parent', MainVBoxMorph,'ButtonSize',[3000 40]);
            
            uicontrol( 'Parent', HButtonBoxMorph1,'Style','text','FontSize',fontSizeM, 'String', 'Morphol. operation:');
            String = {'choose operation' ,'edge smoothing','close small gaps' ,'erode', 'dilate', 'skel' ,'thin','shrink','majority'};
            obj.B_MorphOP = uicontrol( 'Parent', HButtonBoxMorph1,'Style','popupmenu','FontSize',fontSizeM, 'String', String ,'Enable','off');
            
            uicontrol( 'Parent', HButtonBoxMorph2,'Style','text','FontSize',fontSizeM, 'String', 'Structuring element:');
            String = {'choose SE' , 'diamond', 'disk', 'octagon' ,'square'};
            obj.B_ShapeSE = uicontrol( 'Parent', HButtonBoxMorph2,'Style','popupmenu','FontSize',fontSizeM, 'String', String,'Enable','off' );
            
            uicontrol( 'Parent', HButtonBoxMorph3,'Style','text','FontSize',fontSizeM, 'String', 'Size of structuring element:');
            obj.B_SizeSE = uicontrol( 'Parent', HButtonBoxMorph3,'Style','edit','FontSize',fontSizeM,'String','1','Enable','off' );
            
            uicontrol( 'Parent', HButtonBoxMorph4,'Style','text','FontSize',fontSizeM, 'String', 'No. of iterations / Size gaps:');
            obj.B_NoIteration = uicontrol( 'Parent', HButtonBoxMorph4,'Style','edit','FontSize',fontSizeM,'String','1','Enable','off' );
            
            obj.B_StartMorphOP = uicontrol( 'Parent', HButtonBoxMorph5, 'String', 'Run morphological operation','FontSize',fontSizeM ,'Enable','off' );
            
            %%%%%%%%%%%%%% Panel Info Text %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            obj.B_InfoText = uicontrol('Parent',PanelInfo,'Style','listbox','FontSize',fontSizeM,'String',{''});
            
            %%%%%%%%%%%%%% Set Init Values %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            set(obj.B_LineWidth,'Value',1);
            set(obj.B_Threshold,'Value',0.1);
            set(obj.B_Alpha,'Value',1);
            
            set(obj.B_LineWidthValue,'String',num2str(get(obj.B_LineWidth,'Value')));
            set(obj.B_ThresholdValue,'String',num2str(get(obj.B_Threshold,'Value')));
            set(obj.B_AlphaValue,'String',num2str(get(obj.B_Alpha,'Value')));
            
            
            %%%%%%%%%%%%%%% call edit functions for GUI
            obj.setToolTipStrings();

        end % end constructor
        
        function checkPlanes(obj,Pics)
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
            
            obj.hFCP = figure('NumberTitle','off','ToolBar','none','MenuBar','none','Name','Check Color Planes','Units','normalized','Visible','off','Tag','CheckPlanesFigure');
            set(obj.hFCP, 'position', [0.1 0.1 0.8 0.8]);
            set(obj.hFCP,'WindowStyle','modal');
            
            MainVBox = uix.VBox('Parent',obj.hFCP,'Spacing', 5,'Padding',5);
            MainGrid = uix.Grid('Parent',MainVBox,'Padding',5);
            
            VBox1 = uix.VBox('Parent',MainGrid,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGB = axes('Parent',VBox1,'ActivePositionProperty','position');
            imshow(Pics{3})
            axis image
            uicontrol( 'Parent', VBox1,'Style','text', 'String', 'Original Picture');
            set(VBox1,'Heights',[-10 -1])
            
            VBox2 = uix.VBox('Parent',MainGrid,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckRGBPlane = axes('Parent',VBox2,'ActivePositionProperty','position');
            imshow(Pics{9})
            axis image
            uicontrol( 'Parent', VBox2,'Style','text', 'String', 'Image generated from Red Green and Blue Plane');
            set(VBox2,'Heights',[-10 -1])
            
            VBox3 = uix.VBox('Parent',MainGrid,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneGreen = axes('Parent',VBox3,'ActivePositionProperty','position');
            axis image
            imshow(Pics{5})
            obj.B_ColorPlaneGreen = uicontrol( 'Parent', VBox3,'Style','popupmenu', 'String', {'Green Plane' , 'Blue Plane', 'Red Plane', 'FarRed Plane'} , 'Value' ,1);
            set(VBox3,'Heights',[-10 -1])
            
            VBox4 = uix.VBox('Parent',MainGrid,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneBlue = axes('Parent',VBox4,'ActivePositionProperty','position');
            axis image
            imshow(Pics{6})
            obj.B_ColorPlaneBlue = uicontrol( 'Parent', VBox4,'Style','popupmenu', 'String', {'Green Plane' , 'Blue Plane', 'Red Plane', 'FarRed Plane'} , 'Value' ,2);
            set(VBox4,'Heights',[-10 -1])
            
            VBox5 = uix.VBox('Parent',MainGrid,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneRed = axes('Parent',VBox5,'ActivePositionProperty','position');
            axis image
            imshow(Pics{7})
            obj.B_ColorPlaneRed = uicontrol( 'Parent', VBox5,'Style','popupmenu', 'String', {'Green Plane' , 'Blue Plane', 'Red Plane', 'FarRed Plane'} , 'Value' ,3);
            set(VBox5,'Heights',[-10 -1])
            
            VBox6 = uix.VBox('Parent',MainGrid,'Spacing', 5,'Padding',5);
            obj.B_AxesCheckPlaneFarRed = axes('Parent',VBox6,'ActivePositionProperty','position');
            axis image
            imshow(Pics{8})
            obj.B_ColorPlaneFarRed = uicontrol( 'Parent', VBox6,'Style','popupmenu', 'String', {'Green Plane' , 'Blue Plane', 'Red Plane', 'FarRed Plane'} , 'Value' ,4);
            set(VBox6,'Heights',[-10 -1])
            
            set( MainGrid, 'Heights', [-1 -1], 'Widths', [-1 -1] ,'Spacing',10);
            
            HBox = uix.HBox('Parent',MainVBox,'Spacing', 5,'Padding',5);
            
            HButtonBox1 = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPText = uicontrol( 'Parent', HButtonBox1,'Style','text', 'String', 'Confirm the changes with OK.','FontSize',16);
            
            HButtonBox2 = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPBack = uicontrol( 'Parent', HButtonBox2,'String', 'Back to Edit-Mode','FontSize',20);
            
            HButtonBox3 = uix.HButtonBox('Parent',HBox,'Spacing', 5,'Padding',5,'ButtonSize',[600 600]);
            obj.B_CheckPOK = uicontrol( 'Parent', HButtonBox3,'String', 'OK','FontSize',20);
            
            set( MainGrid, 'Heights', [-1 -1 ], 'Widths', [-1 -1 -1] ,'Spacing',10);
            set(MainVBox,'Heights',[-10 -1])
            set(HBox,'Widths',[-3 -1 -1])
            
            
            set(obj.hFCP,'Visible','on');
            drawnow;
        end
        
        function setToolTipStrings(obj)
            % Set all tooltip strings in the properties of the operationg
            % elements that are shown in the GUI.
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
            
            NewPicToolTip = sprintf('Select a new image for further processing.');
            
            CheckPlanesToolTip = sprintf(['Opens a menue to check or change the color plane images: \n ',...
                'Red, Green, Blue and Farred images']);
            
            StartAnaModeToolTip = sprintf(['Starts image analyzing mode.']);
            
            ThreshModeToolTip = sprintf(['Select threshold method for image binarization.']);
            
            ThreshToolTip = sprintf(['Select threshold for image binarization.']);
            
            AlphaToolTip = sprintf(['Change transparency of the binary image.']);
            
            LineWidthToolTip = sprintf(['Change linewidth for drawing into the binary image.']);
            
            ColorToolTip = sprintf(['Choose color for drawing into the binary image.']);
            
            InvertToolTip = sprintf(['Invert the binary image. \n',...
                'Has no effect on segmentation.']);
            
            MorphToolTip = sprintf(['Select morphological method.']);
            
            StructuringToolTip = sprintf(['Select structuring element']);
            
            StructuringSizeToolTip = sprintf(['Change the size of the structuring element']);
            
            NoOfIterationsToolTip = sprintf(['Change the number of iterations']);
            
            RunMorphToolTip = sprintf(['Perform the morphological operation \n',...
                'to the binary image']);
            
            set(obj.B_Undo,'tooltipstring',UndoToolTip);
            set(obj.B_Redo,'tooltipstring',RedoToolTip);
            set(obj.B_NewPic,'tooltipstring',NewPicToolTip);
            set(obj.B_CheckPlanes,'tooltipstring',CheckPlanesToolTip);
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

