classdef controllerEdit < handle
    %controllerEdit   Controller of the edit-MVC (Model-View-Controller).
    %Controls the communication and data exchange between the view
    %instance and the model instance. Connected to the analyze
    %controller to communicate with the analyze MVC and to exchange data
    %between them.
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
        mainFigure; %handle to main figure.
        mainCardPanel; %handle to card panel in the main figure.
        viewEditHandle; %hande to viewEdit instance.
        modelEditHandle; %hande to modelEdit instance.
        controllerAnalyzeHandle; %hande to controllerAnalyze instance.
    end
    
    methods
        
        function obj = controllerEdit(mainFigure,mainCardPanel,viewEditH,modelEditH)
            % Constuctor of the controllerEdit class. Initialize the
            % callback and listener functions to observes the corresponding
            % View objects. Saves the needed handles of the corresponding
            % View and Model in the properties.
            %
            %   obj = controllerEdit(mainFigure,mainCardPanel,viewEditH,modelEditH);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           mainFigure:     Handle to main figure
            %           mainCardPanel:  Handle to main card panel
            %           viewEditH:      Hande to viewEdit instance
            %           modelEditH:     Hande to modelEdit instance
            %
            %       - Output:
            %           obj:            Handle to controllerEdit object
            %
            
            obj.mainFigure =mainFigure;
            obj.mainCardPanel =mainCardPanel;
            
            obj.viewEditHandle = viewEditH;
            
            obj.modelEditHandle = modelEditH;
            
            obj.addMyListener();
            
            obj.setInitValueInModel();
            
            obj.addMyCallbacks();
            
            obj.addWindowCallbacks();
            
            %show init text in the info log
            obj.modelEditHandle.InfoMessage = '*** Start program ***';
            obj.modelEditHandle.InfoMessage = 'Fiber-Type classification tool';
            obj.modelEditHandle.InfoMessage = ' ';
            obj.modelEditHandle.InfoMessage = 'Developed by:';
            obj.modelEditHandle.InfoMessage = 'Trier University of Applied Sciences';
            obj.modelEditHandle.InfoMessage = 'Version 1.0 2017';
            obj.modelEditHandle.InfoMessage = ' ';
            obj.modelEditHandle.InfoMessage = 'Press "New image" to start';
            
            
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
            set(obj.viewEditHandle.B_CheckPlanes,'Enable','off')
            
        end % end constructor
        
        function addMyListener(obj)
            % add listeners to the several button objects in the viewEdit
            % instance and value objects or handles in the modelEdit.
            %
            %   addMyListener(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            % listeners MODEL
            addlistener(obj.modelEditHandle,'InfoMessage', 'PostSet',@obj.updateInfoLogEvent);
            
            % listeners VIEW
            addlistener(obj.viewEditHandle.B_Threshold, 'ContinuousValueChange',@obj.thresholdEvent);
            addlistener(obj.viewEditHandle.B_Alpha, 'ContinuousValueChange',@obj.alphaMapEvent);
            addlistener(obj.viewEditHandle.B_LineWidth, 'ContinuousValueChange',@obj.lineWidthEvent);
        end
        
        function addMyCallbacks(obj)
            % Set callback functions to several button objects in the viewEdit
            % instance and handles im the editModel.
            %
            %   addMyCallbacks(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            %ButtonDownFcn of the binary pic. Starts the hand draw
            %functions
            set(obj.modelEditHandle.handlePicBW,'ButtonDownFcn',@obj.startDragFcn);
            
            set(obj.viewEditHandle.B_Undo,'Callback',@obj.undoEvent);
            set(obj.viewEditHandle.B_Redo,'Callback',@obj.redoEvent);
            set(obj.viewEditHandle.B_NewPic,'Callback',@obj.newPictureEvent);
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Callback',@obj.startAnalyzeModeEvent);
            set(obj.viewEditHandle.B_CheckPlanes,'Callback',@obj.checkPlanesEvent);
            set(obj.viewEditHandle.B_CheckMask,'Callback',@obj.checkMaskEvent);
            set(obj.viewEditHandle.B_Invert,'Callback',@obj.invertEvent);
            set(obj.viewEditHandle.B_ThresholdValue,'Callback',@obj.thresholdEvent);
            set(obj.viewEditHandle.B_AlphaValue,'Callback',@obj.alphaMapEvent);
            set(obj.viewEditHandle.B_LineWidthValue,'Callback',@obj.lineWidthEvent);
            set(obj.viewEditHandle.B_Color,'Callback',@obj.colorEvent);
            set(obj.viewEditHandle.B_MorphOP,'Callback',@obj.morphOpEvent);
            set(obj.viewEditHandle.B_ShapeSE,'Callback',@obj.structurElementEvent);
            set(obj.viewEditHandle.B_SizeSE,'Callback',@obj.morphValuesEvent);
            set(obj.viewEditHandle.B_NoIteration,'Callback',@obj.morphValuesEvent);
            set(obj.viewEditHandle.B_StartMorphOP,'Callback',@obj.startMorphOPEvent);
            set(obj.viewEditHandle.B_ThresholdMode,'Callback',@obj.thresholdModeEvent);
            
        end
        
        function addWindowCallbacks(obj)
            % Set callback functions of the main figure
            %
            %   addWindowCallbacks(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            set(obj.mainFigure,'ButtonDownFcn',@obj.startDragFcn);
            set(obj.mainFigure,'WindowButtonMotionFcn','');
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);
        end
        
        function setInitValueInModel(obj)
            % Get the values from the button ang GUI objects in the View
            % and set the values in the Model.
            %
            %   setInitValueInModel(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            obj.modelEditHandle.ThresholdMode = obj.viewEditHandle.B_ThresholdMode.Value;
            obj.modelEditHandle.ThresholdValue = obj.viewEditHandle.B_Threshold.Value;
            obj.modelEditHandle.AlphaMapValue = obj.viewEditHandle.B_Alpha.Value;
        end
        
        function setInitPicsGUI(obj)
            % set the initalize images in the axes handels viewEdit to show
            % the images in the GUI.
            %
            %   setInitPicsGUI(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            % get Pics from the model
            PicRGB = obj.modelEditHandle.PicRGB;
            PicBW = obj.modelEditHandle.PicBW;
            
            % set axes in the GUI as the current axes
            axes(obj.viewEditHandle.hAP);
            
            if isa(obj.modelEditHandle.handlePicRGB,'struct')
                % first start of the programm. No image handle exist.
                % create image handle for Pic RGB
                obj.modelEditHandle.handlePicRGB = imshow(PicRGB);
            else
                % New image was selected. Change data in existing handle
                obj.modelEditHandle.handlePicRGB.CData = PicRGB;
            end
            
            hold on
            
            if isa(obj.modelEditHandle.handlePicBW,'struct')
                % first start of the programm. No image handle exist.
                % create image handle for Pic BW
                obj.modelEditHandle.handlePicBW = imshow(PicBW);
                
                % Callback for modelEditHandle.handlePicBW must be refresh
                obj.addMyCallbacks();
            else
                % New image was selected. Change data in existing handle
                obj.modelEditHandle.handlePicBW.CData = PicBW;
            end
            
            % show x and y axis
            axis on
            axis image
            hold off
            Titel = [obj.modelEditHandle.PathNames obj.modelEditHandle.FileNamesRGB];
            obj.viewEditHandle.panelPicture.Title = Titel;
            
           
            mainTitel = ['Fiber types classification tool: ' obj.modelEditHandle.FileNamesRGB];
            set(obj.mainFigure,'Name', mainTitel);
            
        end
        
        function newPictureEvent(obj,~,~)
            % Callback function of the NewPic-Button in the GUI. Opens a
            % input dialog where the user can select a new image for
            % further processing. Identify the color planes and create the
            % binary pic after a correct image was selected.
            %
            %   newPictureEvent(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            %disable GUI objects
            set(obj.viewEditHandle.B_NewPic,'Enable','off');
            set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
            set(obj.viewEditHandle.B_CheckMask,'Enable','off');
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
            set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
            set(obj.viewEditHandle.B_ThresholdMode,'Enable','off');
            set(obj.viewEditHandle.B_Threshold,'Enable','off');
            set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
            set(obj.viewEditHandle.B_Color,'Enable','off');
            set(obj.viewEditHandle.B_Invert,'Enable','off');
            set(obj.viewEditHandle.B_Alpha,'Enable','off');
            set(obj.viewEditHandle.B_AlphaValue,'Enable','off');
            set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
            set(obj.viewEditHandle.B_ShapeSE,'Enable','off');
            set(obj.viewEditHandle.B_SizeSE,'Enable','off');
            set(obj.viewEditHandle.B_NoIteration,'Enable','off');
            
            %select a new image
            succsesNewPic = obj.openNewPic();
            
            if succsesNewPic
                %selecting a new image was successfully
                
                % clear info text log
                set(obj.viewEditHandle.B_InfoText, 'String','*** New Picture selected ***')
                
                % search and load the color plane images .zvi file
                sucsessLoadPic = obj.modelEditHandle.loadPics();
                
                if sucsessLoadPic
                    %loading color plane images was successfully
                    
                    %Identify color planes
                    obj.modelEditHandle.planeIdentifier();
                    
                    %brightness adjustment of color plane images
                    obj.modelEditHandle.brightnessAdjustment();
                    
                    %reset invert status of binary pic
                    obj.modelEditHandle.PicBWisInvert = 'false';
                    
                    %create binary pic
                    obj.modelEditHandle.createBinary();
                    
                    %reset pic buffer for undo redo functionality
                    obj.modelEditHandle.PicBuffer = {};
                    %load binary pic in the buffer
                    obj.modelEditHandle.PicBuffer{1,1} = obj.modelEditHandle.PicBW;
                    %reset buffer pointer
                    obj.modelEditHandle.PicBufferPointer = 1;
                    
                    %show images in GUI
                    obj.setInitPicsGUI();
                    obj.modelEditHandle.InfoMessage = '- opening images completed';
                    %enable GUI objects
                    set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','on');
                    set(obj.viewEditHandle.B_CheckPlanes,'Enable','on');
                    set(obj.viewEditHandle.B_CheckMask,'Enable','on');
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                    set(obj.viewEditHandle.B_ThresholdMode,'Enable','on');
                    set(obj.viewEditHandle.B_Threshold,'Enable','on');
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                    set(obj.viewEditHandle.B_Color,'Enable','on');
                    set(obj.viewEditHandle.B_Invert,'Enable','on');
                    set(obj.viewEditHandle.B_Alpha,'Enable','on');
                    set(obj.viewEditHandle.B_AlphaValue,'Enable','on');
                    set(obj.viewEditHandle.B_MorphOP,'Enable','on');
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                    
                    % check wich morphOp buttons must be enabled
                    obj.morphOpEvent();
                    
                else
                    %loading color plane images was not successfully
                    %disable GUI objects
                    set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
                    set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
                    set(obj.viewEditHandle.B_ThresholdMode,'Enable','off');
                    set(obj.viewEditHandle.B_Threshold,'Enable','off');
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                    set(obj.viewEditHandle.B_Color,'Enable','off');
                    set(obj.viewEditHandle.B_Invert,'Enable','off');
                    set(obj.viewEditHandle.B_Alpha,'Enable','off');
                    set(obj.viewEditHandle.B_AlphaValue,'Enable','off');
                    set(obj.viewEditHandle.B_MorphOP,'Enable','off');
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
                    set(obj.viewEditHandle.B_ShapeSE,'Enable','off');
                    set(obj.viewEditHandle.B_SizeSE,'Enable','off');
                    set(obj.viewEditHandle.B_NoIteration,'Enable','off');
                end
                
            elseif isa(obj.modelEditHandle.handlePicRGB,'struct')
                %selecting a new image was not successfully. No image is
                %loaded into the program
                set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
                set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
                set(obj.viewEditHandle.B_CheckMask,'Enable','off');
            else
                %selecting a new image was not successfully.
                if isempty(obj.modelEditHandle.handlePicBW)
                    %No image is loaded into the program.
                    %disable GUI objects
                    set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
                    set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
                    set(obj.viewEditHandle.B_CheckMask,'Enable','off');
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
                    set(obj.viewEditHandle.B_ThresholdMode,'Enable','off');
                    set(obj.viewEditHandle.B_Threshold,'Enable','off');
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                    set(obj.viewEditHandle.B_Invert,'Enable','off');
                    set(obj.viewEditHandle.B_Color,'Enable','off');
                    set(obj.viewEditHandle.B_Alpha,'Enable','off');
                    set(obj.viewEditHandle.B_AlphaValue,'Enable','off');
                    set(obj.viewEditHandle.B_MorphOP,'Enable','off');
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
                    set(obj.viewEditHandle.B_ShapeSE,'Enable','off');
                    set(obj.viewEditHandle.B_SizeSE,'Enable','off');
                    set(obj.viewEditHandle.B_NoIteration,'Enable','off');
                else
                    %One image is already loaded into the program.
                    %enable GUI objects
                    set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','on');
                    set(obj.viewEditHandle.B_CheckPlanes,'Enable','on');
                    set(obj.viewEditHandle.B_CheckMask,'Enable','on');
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                    set(obj.viewEditHandle.B_ThresholdMode,'Enable','on');
                    set(obj.viewEditHandle.B_Threshold,'Enable','on');
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                    set(obj.viewEditHandle.B_Invert,'Enable','on');
                    set(obj.viewEditHandle.B_Color,'Enable','on');
                    set(obj.viewEditHandle.B_Alpha,'Enable','on');
                    set(obj.viewEditHandle.B_AlphaValue,'Enable','on');
                    set(obj.viewEditHandle.B_MorphOP,'Enable','on');
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                    
                    % check wich morphOp buttons must be enabled
                    obj.morphOpEvent();
                end
            end
            set(obj.viewEditHandle.B_NewPic,'Enable','on');
        end
        
        function succses = openNewPic(obj)
            % Opens a file select dialog box where the user can select a
            % new RGB image for further processing. Only allows to select
            % one image .tif file. If a new picture was selected all old
            % image data will be deleted.
            %
            %   PicData = sendPicsToController(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to modelEdit object
            %
            %       - Output
            %           succses:    returns true if a new image was
            %               selected, otherwise flase.
            
            %Get filename and path of the new image
            [tempFileNamesRGB,tempPathNames] = uigetfile('*.tif','Select the image','MultiSelect', 'off');
            
            if isequal(tempFileNamesRGB ,0) && isequal(tempPathNames,0)
                %no image was selected
                obj.modelEditHandle.InfoMessage = '   - open image canceled';
                succses = false;
            else
                % clear old Pic Data if a new one is selected
                obj.modelEditHandle.clearPicData();
                
                %save filename and path in the properties
                obj.modelEditHandle.FileNamesRGB = tempFileNamesRGB;
                obj.modelEditHandle.PathNames = tempPathNames;
                succses = true;
            end
        end
        
        function checkPlanesEvent(obj,~,~)
            % Callback function of the Check planes button in the GUI.
            % Opens a new figure that shows all color plane pictures
            % identified by the program. The figure also shows the
            % origianal RGB image and an RGB image that is created by the
            % color plane images.
            % Set the callback functions for the buttons and the close
            % request function of the created check planes figure.
            %
            %   checkPlanesEvent(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            obj.modelEditHandle.InfoMessage = '   - Checking planes opened';
            PicData = obj.modelEditHandle.sendPicsToController();
            obj.viewEditHandle.checkPlanes(PicData);
            
            % set Callbacks of the cancel and Ok button.
            set(obj.viewEditHandle.B_CheckPOK,'Callback',@obj.checkPlanesOKEvent);
            set(obj.viewEditHandle.B_CheckPBack,'Callback',@obj.checkPlanesBackEvent);
            % find the handle h of the checkplanes figure
            h = findobj('Tag','CheckPlanesFigure');
            % set the close request functio of the figure h
            set(h,'CloseRequestFcn',@obj.checkPlanesBackEvent);
        end
        
        function checkMaskEvent(obj,src,evnt)
            % Callback function of the Check mask button in the GUI.
            %
            %   checkPlanesEvent(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            if src.Value == 1
                obj.modelEditHandle.InfoMessage = '   - check mask';
                set(obj.mainFigure,'ButtonDownFcn','');
                set(obj.modelEditHandle.handlePicBW,'ButtonDownFcn','');
                
                set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
                set(obj.viewEditHandle.B_NewPic,'Enable','off');
                set(obj.viewEditHandle.B_Undo,'Enable','off');
                set(obj.viewEditHandle.B_Redo,'Enable','off');
                set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
                set(obj.viewEditHandle.B_ThresholdMode,'Enable','off');
                set(obj.viewEditHandle.B_Threshold,'Enable','off');
                set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                set(obj.viewEditHandle.B_Invert,'Enable','off');
                set(obj.viewEditHandle.B_Color,'Enable','off');
                set(obj.viewEditHandle.B_MorphOP,'Enable','off');
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off');
                set(obj.viewEditHandle.B_SizeSE,'Enable','off');
                set(obj.viewEditHandle.B_NoIteration,'Enable','off');
                
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
                
                obj.modelEditHandle.checkMask(src.Value);
                
            elseif src.Value == 0
                
                obj.modelEditHandle.InfoMessage = '   - close check mask';
                obj.addWindowCallbacks();
                set(obj.modelEditHandle.handlePicBW,'ButtonDownFcn',@obj.startDragFcn);
                
                obj.modelEditHandle.checkMask(src.Value);
                
                set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','on');
                set(obj.viewEditHandle.B_NewPic,'Enable','on');
                set(obj.viewEditHandle.B_Undo,'Enable','on');
                set(obj.viewEditHandle.B_Redo,'Enable','on');
                set(obj.viewEditHandle.B_CheckPlanes,'Enable','on');
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                set(obj.viewEditHandle.B_ThresholdMode,'Enable','on');
                if (obj.viewEditHandle.B_ThresholdMode.Value == 1 || ...
                        obj.viewEditHandle.B_ThresholdMode.Value == 3 )
                    %activate only if threshold is nessesary
                    set(obj.viewEditHandle.B_Threshold,'Enable','on');
                    set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                end
                set(obj.viewEditHandle.B_Invert,'Enable','on');
                set(obj.viewEditHandle.B_Color,'Enable','on');
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                
                % check wich morphOp buttons must be enabled
                obj.morphOpEvent();
            end
            
            
            
        end
        
        function checkPlanesOKEvent(obj,~,~)
            % Callback function of the OK button in the check planes
            % figure. Checks if the user has changed the order of the color
            % planes. if the order has changed than the function checks if
            % each color plane is only choosen once.
            %
            %   checkPlanesOKEvent(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            % get the values of the color popupmenus
            Values(1) = obj.viewEditHandle.B_ColorPlaneGreen.Value;
            Values(2) = obj.viewEditHandle.B_ColorPlaneBlue.Value;
            Values(3) = obj.viewEditHandle.B_ColorPlaneRed.Value;
            Values(4) = obj.viewEditHandle.B_ColorPlaneFarRed.Value;
            
            % check if each color is selected once
            C = unique(Values);
            
            if ~isequal(Values,[1 2 3 4])
                % change was made
                
                if length(C) == 4
                    % All Values are unique. No Plane Type is selestet twice
                    obj.modelEditHandle.InfoMessage = '      - changing planes...';
                    
                    %change plane orders
                    temp{1} = obj.modelEditHandle.PicPlaneGreen;
                    temp{2} = obj.modelEditHandle.PicPlaneBlue;
                    temp{3} = obj.modelEditHandle.PicPlaneRed;
                    temp{4} = obj.modelEditHandle.PicPlaneFarRed;
                    
                    obj.modelEditHandle.PicPlaneGreen = temp{Values(1)};
                    obj.modelEditHandle.PicPlaneBlue = temp{Values(2)};
                    obj.modelEditHandle.PicPlaneRed = temp{Values(3)};
                    obj.modelEditHandle.PicPlaneFarRed = temp{Values(4)};
                    
                    % Create Picture generated from Red Green and Blue
                    % Planes
                    obj.modelEditHandle.PicRGBPlanes(:,:,1) = obj.modelEditHandle.PicPlaneRed;
                    obj.modelEditHandle.PicRGBPlanes(:,:,2) = obj.modelEditHandle.PicPlaneGreen;
                    obj.modelEditHandle.PicRGBPlanes(:,:,3) = obj.modelEditHandle.PicPlaneBlue;
                    obj.modelEditHandle.PicRGBPlanes = uint8(obj.modelEditHandle.PicRGBPlanes);
                    
                    %brightness adjustment of color plane image
                    obj.modelEditHandle.brightnessAdjustment();
                    
                    %reset invert status of binary pic
                    obj.modelEditHandle.PicBWisInvert = 'false';
                    
                    %create binary pic
                    obj.modelEditHandle.createBinary();
                    
                    %reset pic buffer for undo redo functionality
                    obj.modelEditHandle.PicBuffer = {};
                    %load binary pic in the buffer
                    obj.modelEditHandle.PicBuffer{1,1} = obj.modelEditHandle.PicBW;
                    %reset buffer pointer
                    obj.modelEditHandle.PicBufferPointer = 1;
                    
                    %show new color planes order in the check planes figure
                    obj.viewEditHandle.B_AxesCheckPlaneGreen.Children.CData = obj.modelEditHandle.PicPlaneGreen;
                    obj.viewEditHandle.B_AxesCheckPlaneBlue.Children.CData = obj.modelEditHandle.PicPlaneBlue;
                    obj.viewEditHandle.B_AxesCheckPlaneRed.Children.CData = obj.modelEditHandle.PicPlaneRed;
                    obj.viewEditHandle.B_AxesCheckPlaneFarRed.Children.CData = obj.modelEditHandle.PicPlaneFarRed;
                    obj.viewEditHandle.B_AxesCheckRGBPlane.Children.CData = obj.modelEditHandle.PicRGBPlanes;
                    
                    %reset the color popupmenus
                    obj.viewEditHandle.B_ColorPlaneGreen.Value = 1;
                    obj.viewEditHandle.B_ColorPlaneBlue.Value = 2;
                    obj.viewEditHandle.B_ColorPlaneRed.Value = 3;
                    obj.viewEditHandle.B_ColorPlaneFarRed.Value = 4;
                    
                    obj.modelEditHandle.InfoMessage = '   - Planes was changed';
                else
                    obj.viewEditHandle.B_CheckPText.String = 'Each color type can only be selected once!';
                    obj.modelEditHandle.InfoMessage = '      - Error checking planes:';
                    obj.modelEditHandle.InfoMessage = '      - Each color type can only be selected once!';
                end
            else
                obj.modelEditHandle.InfoMessage = '      - No change was made';
                
            end
        end
        
        function checkPlanesBackEvent(obj,~,~)
            % Callback function of the Back button in the check planes
            % figure. Is also the close request function of the check
            % planes figure. Delete the figure object.
            %
            %   checkPlanesBackEvent(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            obj.modelEditHandle.InfoMessage = '   - Checking planes closed';
            % find the handle h of the checkplanes figure
            h = findobj('Tag','CheckPlanesFigure');
            delete(h);
            
        end
        
        function thresholdModeEvent(obj,src,evnt)
            % Callback function of the threshold mode popupmenu in the
            % GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values in the
            % model depending on the selection. Calls the
            % createBinary() function in the model.
            %
            %   thresholdModeEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            Mode = src.Value;
            
            obj.modelEditHandle.InfoMessage = '   - Binarization operation';
            
            if Mode == 1
                % Use manual global threshold for binarization
                set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                set(obj.viewEditHandle.B_Threshold,'Enable','on');
                obj.modelEditHandle.ThresholdMode = Mode;
                obj.modelEditHandle.InfoMessage = '      - Manual threshold mode has been selected';
                obj.modelEditHandle.InfoMessage = '      - Use slider to change threshold';
                
                %Create binary image with threshold value in model
                obj.modelEditHandle.createBinary();
                
            elseif Mode == 2
                % Use automatic adaptive threshold for binarization
                set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                set(obj.viewEditHandle.B_Threshold,'Enable','off');
                obj.modelEditHandle.ThresholdMode = Mode;
                obj.modelEditHandle.InfoMessage = '      - Adaptive threshold mode has been selected';
                
                %Create binary image with threshold value in model
                obj.modelEditHandle.createBinary();
                
            elseif Mode == 3
                % Use automatic adaptive and manual global threshold for binarization
                set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                set(obj.viewEditHandle.B_Threshold,'Enable','on');
                obj.modelEditHandle.ThresholdMode = Mode;
                obj.modelEditHandle.InfoMessage = '      - Combined threshold has been selected';
                obj.modelEditHandle.InfoMessage = '      - Use slider to change threshold';
                
                %Create binary image with threshold value in model
                obj.modelEditHandle.createBinary();
                
            elseif Mode == 4
                % Use Automatic setup for binarization
                set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                set(obj.viewEditHandle.B_Threshold,'Enable','off');
                
                set(obj.viewEditHandle.B_NewPic,'Enable','off');
                set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
                set(obj.viewEditHandle.B_CheckMask,'Enable','off');
                set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
                set(obj.viewEditHandle.B_ThresholdMode,'Enable','off');
                set(obj.viewEditHandle.B_Threshold,'Enable','off');
                set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                set(obj.viewEditHandle.B_Color,'Enable','off');
                set(obj.viewEditHandle.B_Invert,'Enable','off');
                set(obj.viewEditHandle.B_Alpha,'Enable','off');
                set(obj.viewEditHandle.B_AlphaValue,'Enable','off');
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off');
                
                obj.modelEditHandle.ThresholdMode = Mode;
                obj.modelEditHandle.InfoMessage = '      - Automatic setup has been selected';
                
                
                %Create binary image with threshold value in model
                obj.modelEditHandle.createBinary();
                
                set(obj.viewEditHandle.B_NewPic,'Enable','on');
                set(obj.viewEditHandle.B_CheckPlanes,'Enable','on');
                set(obj.viewEditHandle.B_CheckMask,'Enable','on');
                set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','on');
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                set(obj.viewEditHandle.B_ThresholdMode,'Enable','on');
                set(obj.viewEditHandle.B_Color,'Enable','on');
                set(obj.viewEditHandle.B_Invert,'Enable','on');
                set(obj.viewEditHandle.B_Alpha,'Enable','on');
                set(obj.viewEditHandle.B_AlphaValue,'Enable','on');
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on');
                
            else
                % Error Code
                obj.modelEditHandle.InfoMessage = '! ERROR in thresholdModeEvent() FUNCTION !';
            end
            
        end
        
        function thresholdEvent(obj,src,evnt)
            % Callback function of the threshold slider and the text edit
            % box in the GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values
            % in the model depending on the selection. Calls the
            % createBinary() function in the model.
            %
            %   thresholdEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            if strcmp(evnt.Source.Tag,'textThreshold')
                % Text Value has changed
                
                Value = str2double( src.String );
                
                if isscalar(Value) && isreal(Value) && ~isnan(Value)
                    % Value is numerical
                    
                    if Value > 1
                        % Value is bigger than 1. Set Value to 1.
                        set(obj.viewEditHandle.B_Threshold,'Value',1);
                        set(obj.viewEditHandle.B_ThresholdValue,'String','1');
                        
                        %Set threshold value in the model
                        obj.modelEditHandle.ThresholdValue = 1;
                        
                        %Create binary image with new threshold
                        obj.modelEditHandle.createBinary();
                    elseif Value < 0
                        % Value is smaller than 0. Set Value to 0.
                        set(obj.viewEditHandle.B_Threshold,'Value',0);
                        set(obj.viewEditHandle.B_ThresholdValue,'String','0');
                        
                        %Set threshold value in the model
                        obj.modelEditHandle.ThresholdValue = 0;
                        
                        %Create binary image with new threshold
                        obj.modelEditHandle.createBinary();
                    else
                        % Value is ok
                        set(obj.viewEditHandle.B_Threshold,'Value',Value);
                        
                        %Set threshold value in the model
                        obj.modelEditHandle.ThresholdValue = Value;
                        
                        %Create binary image with new threshold
                        obj.modelEditHandle.createBinary();
                    end
                else
                    % Value is not numerical. Set Value to 0.1.
                    set(obj.viewEditHandle.B_Threshold,'Value',0.1);
                    set(obj.viewEditHandle.B_ThresholdValue,'String','0.1');
                    
                    %Set threshold value in the model
                    obj.modelEditHandle.ThresholdValue = 0.1;
                    
                    %Create binary image with new threshold
                    obj.modelEditHandle.createBinary();
                end
                
            elseif strcmp(evnt.Source.Tag,'sliderThreshold')
                % slider Value has changed
                set(obj.viewEditHandle.B_ThresholdValue,'String',num2str(evnt.Source.Value));
                
                %Set threshold value in the model
                obj.modelEditHandle.ThresholdValue = evnt.Source.Value;
                
                %Create binary image with new threshold
                obj.modelEditHandle.createBinary();
            else
                % Error Code
                obj.modelEditHandle.InfoMessage = '! ERROR in thresholdEvent() FUNCTION !';
            end
            
        end
        
        function alphaMapEvent(obj,src,evnt)
            % Callback function of the alpha map slider and the text edit
            % box in the GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values
            % in the model depending on the selection.
            %
            %   alphaMapEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            if strcmp(evnt.Source.Tag,'textAlpha')
                % Text Value has changed
                
                Value = str2double( src.String );
                
                if isscalar(Value) && isreal(Value) && ~isnan(Value)
                    % Value is numerical
                    
                    if Value > 1
                        % Value is bigger than 1. Set Value to 1.
                        
                        %Set the slider value in GUI to 1
                        set(obj.viewEditHandle.B_Alpha,'Value',1);
                        
                        %Set the text edit box string in GUI to '1'
                        set(obj.viewEditHandle.B_AlphaValue,'String','1');
                        
                        %Set alphamap value in the model
                        obj.modelEditHandle.AlphaMapValue = 1;
                        
                        %Change alphamp (transparency) of binary image
                        obj.modelEditHandle.alphaMapEvent();
                    elseif Value < 0
                        % Value is smaller than 0. Set Value to 0.
                        
                        %Set the slider value in GUI to 0
                        set(obj.viewEditHandle.B_Alpha,'Value',0);
                        
                        %Set the text edit box string in GUI to '0'
                        set(obj.viewEditHandle.B_AlphaValue,'String','0');
                        
                        %Set alphamap value in the model
                        obj.modelEditHandle.AlphaMapValue = 0;
                        
                        %Change alphamp (transparency) of binary image
                        obj.modelEditHandle.alphaMapEvent();
                        
                    else
                        % Value is ok
                        
                        %Copy the textedit value into the text slider in the GUI
                        set(obj.viewEditHandle.B_Alpha,'Value',Value);
                        
                        %Set alphamap value in the model
                        obj.modelEditHandle.AlphaMapValue = Value;
                        
                        %Change alphamp (transparency) of binary image
                        obj.modelEditHandle.alphaMapEvent();
                    end
                else
                    % Value is not numerical. Set Value to 1.
                    
                    %Set the slider value in GUI to 1
                    set(obj.viewEditHandle.B_Alpha,'Value',1);
                    
                    %Set the text edit box string in GUI to '1'
                    set(obj.viewEditHandle.B_AlphaValue,'String','1');
                    
                    %Set alphamap value in the model
                    obj.modelEditHandle.AlphaMapValue = 1;
                    
                    %Change alphamp (transparency) of binary image
                    obj.modelEditHandle.alphaMapEvent();
                    
                end
                
            elseif strcmp(evnt.Source.Tag,'sliderAlpha')
                % slider Value has changed
                
                %Copy the slider value into the text edit box in the GUI
                set(obj.viewEditHandle.B_AlphaValue,'String',num2str(evnt.Source.Value));
                
                %Set alphamap value in the model
                obj.modelEditHandle.AlphaMapValue = evnt.Source.Value;
                
                %Change alphamp (transparency) of binary image
                obj.modelEditHandle.alphaMapEvent();
            else
                % Error Code
                obj.modelEditHandle.InfoMessage = '! ERROR in alphaMapEvent() FUNCTION !';
            end
            
        end
        
        function lineWidthEvent(obj,src,evnt)
            % Callback function of the linewidth slider and the text edit
            % box in the GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values
            % in the model depending on the selection.
            %
            %   lineWidthEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            if strcmp(evnt.Source.Tag,'textLinewidth')
                % Text Value has changed
                
                Value = get(obj.viewEditHandle.B_LineWidthValue,'String');
                Value = round(str2double(Value));
                
                if isscalar(Value) && isreal(Value) && ~isnan(Value)
                    
                    ValueMax = obj.viewEditHandle.B_LineWidth.Max;
                    ValueMin = obj.viewEditHandle.B_LineWidth.Min;
                    
                    if Value > ValueMax
                        Value = ValueMax;
                    end
                    
                    if Value < ValueMin
                        Value = ValueMin;
                    end
                    
                    set(obj.viewEditHandle.B_LineWidth,'Value',Value);
                    set(obj.viewEditHandle.B_LineWidthValue,'String',num2str(Value));
                    obj.modelEditHandle.LineWidthValue = Value;
                else
                    % Value is not numerical. Set Value to 1.
                    set(obj.viewEditHandle.B_LineWidth,'Value',1);
                    set(obj.viewEditHandle.B_LineWidthValue,'String','1');
                    obj.modelEditHandle.LineWidthValue = 1;
                end
            elseif strcmp(evnt.Source.Tag,'sliderLinewidth')
                % slider Value has changed
                
                Value = round(evnt.Source.Value);
                
                set(obj.viewEditHandle.B_LineWidthValue,'String',num2str(Value));
                set(obj.viewEditHandle.B_LineWidth,'Value',Value);
                obj.modelEditHandle.LineWidthValue = Value;
            else
                % Error Code
                obj.modelEditHandle.InfoMessage = '! ERROR in alphaMapEvent() FUNCTION !';
            end
            
        end
        
        function colorEvent(obj,src,evnt)
            % Callback function of the color popupmenu in the
            % GUI. Sets the corresponding value in the
            % model depending on the selection.
            %
            %   colorEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            if evnt.Source.Value == 1
                % White Color
                obj.modelEditHandle.ColorValue = 1;
            elseif evnt.Source.Value == 2
                % Black Color
                obj.modelEditHandle.ColorValue = 0;
            elseif evnt.Source.Value == 3
                % White Color fill region
                obj.modelEditHandle.ColorValue = 1;
            elseif evnt.Source.Value == 4
                % Black Color fill region
                obj.modelEditHandle.ColorValue = 0;
            else
                % Error Code
                obj.modelEditHandle.InfoMessage = '! ERROR in lineWidthEvent() FUNCTION !';
            end
            
        end
        
        function invertEvent(obj,src,evnt)
            % Callback function of the invert button in the
            % GUI. Sets the corresponding value in the
            % model depending on the selection.
            %
            %   invertEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            obj.modelEditHandle.invertPicBWEvent();
        end
        
        function morphOpEvent(obj,src,evnt)
            % Callback function of the Morphol. opertion popupmenu in the
            % GUI. Sets the corresponding value in the
            % model depending on the selection. Controlls the visibility of
            % the corresponding buttons.
            %
            %   morphOpEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            %check wich morph operation is selected
            Strings = obj.viewEditHandle.B_MorphOP.String;
            String = Strings{obj.viewEditHandle.B_MorphOP.Value};
            
            switch String
                
                case 'erode'
                    
                    obj.modelEditHandle.morphOP = 'erode';
                    
                case 'dilate'
                    
                    obj.modelEditHandle.morphOP = 'dilate';
                    
                case 'skel'
                    
                    obj.modelEditHandle.morphOP = 'skel';
                    
                case 'thin'
                    
                    obj.modelEditHandle.morphOP = 'thin';
                    
                case 'open'
                    
                    obj.modelEditHandle.morphOP = 'open';
                    
                case 'remove'
                    
                    obj.modelEditHandle.morphOP = 'remove';
                    
                case 'shrink'
                    
                    obj.modelEditHandle.morphOP = 'shrink';
                    
                case 'majority'
                    
                    obj.modelEditHandle.morphOP = 'majority';
                    
                case 'edge smoothing'
                    
                    obj.modelEditHandle.morphOP = 'edge smoothing';
                    
                case 'close small gaps'
                    
                    obj.modelEditHandle.morphOP = 'close small gaps';
                    
                otherwise
                    
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                    set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                    set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                    obj.viewEditHandle.B_MorphOP.Value = 1;
                    obj.modelEditHandle.morphOP = 'choose operation';
                    set(obj.viewEditHandle.B_MorphOP,'Enable','on')
                    
            end
            
            % Check wich morph option is selectet to turn off/on the
            % corresponding operating elements
            
            set(obj.viewEditHandle.B_MorphOP,'Enable','on');
            
            % get morphological operation string
            tempMorpStr = obj.modelEditHandle.morphOP;
            % get structering element string
            tempSEStr = obj.modelEditHandle.SE;
            
            % Check wich operation is selected
            if strcmp(tempMorpStr,'choose operation') || strcmp(tempMorpStr,'')
                % No operation is selected
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                
            elseif strcmp(tempMorpStr,'erode') || strcmp(tempMorpStr,'dilate')
                % Morph options that need a structuring element. No
                % structering element is selected
                
                %disable run morph button until a structering element was
                %selected
                set(obj.viewEditHandle.B_ShapeSE,'Enable','on')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                
                if ~strcmp(tempSEStr,'') && ~strcmp(tempSEStr,'choose SE')
                    % Morph options with choosen structuring element
                    
                    %enable run morph button
                    set(obj.viewEditHandle.B_SizeSE,'Enable','on')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
                    
                end
                
            else
                % Morph options that dont need a structuring element
                
                %enable run morph button, diable structering element
                %buttons
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
                
            end
            
        end
        
        function structurElementEvent(obj,src,evnt)
            % Callback function of the structering element popupmenu in the
            % GUI. Sets the corresponding value in the
            % model depending on the selection. Controlls the visibility of
            % the corresponding buttons.
            %
            %   structurElementEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            %check wich structering element is selected
            String = src.String{src.Value};
            
            switch String
                
                case 'diamond'
                    
                    obj.modelEditHandle.SE = 'diamond';
                    obj.modelEditHandle.FactorSE = 1;
                case 'disk'
                    
                    obj.modelEditHandle.SE = 'disk';
                    obj.modelEditHandle.FactorSE = 1;
                    
                case 'octagon'
                    
                    obj.modelEditHandle.SE = 'octagon';
                    %Size if octagon must be n*3
                    obj.modelEditHandle.FactorSE = 3;
                    
                case 'square'
                    
                    obj.modelEditHandle.SE = 'square';
                    obj.modelEditHandle.FactorSE = 1;
                    
                otherwise
                    
                    set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                    obj.modelEditHandle.SE = '';
                    
            end
            
            % Check wich morph option is selectet to turn off/on the
            % corresponding operating elements
            
            % get morphological operation string
            tempMorpStr = obj.modelEditHandle.morphOP;
            % get structering element string
            tempSEStr = obj.modelEditHandle.SE;
            
            % Check wich operation is selected
            if strcmp(tempMorpStr,'choose operation') || strcmp(tempMorpStr,'')
                % No operation is selected
                
                %disable run morph button, diable structering element
                %buttons
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                
            elseif strcmp(tempMorpStr,'erode') || strcmp(tempMorpStr,'dilate')
                % Morph options that need a structuring element. No
                % structering element is selected
                
                %disable run morph button until a structering element was
                %selected
                set(obj.viewEditHandle.B_ShapeSE,'Enable','on')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                
                if ~strcmp(tempSEStr,'') && ~strcmp(tempSEStr,'choose SE')
                    % Morph options with choosen structuring element
                    
                    %enable run morph button
                    set(obj.viewEditHandle.B_SizeSE,'Enable','on')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
                end
                
            else
                % Morph options that dont need a structuring element
                
                %enable run morph button, diable structering element
                %buttons
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
            end
            
        end
        
        function morphValuesEvent(obj,src,evnt)
            % Callback function of the value textedit boxes Size and
            % NoInterations in the GUI. Checks whether the value is within
            % the permitted value range. Sets the corresponding value in
            % the model depending on the selection.
            %
            %   structurElementEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            %get strings from GUI text box and transform into numeric value
            ValueSE = round(str2double(obj.viewEditHandle.B_SizeSE.String));
            ValueNoI = round(str2double(obj.viewEditHandle.B_NoIteration.String));
            
            if isnan(ValueSE) || ValueSE < 1 || ~isreal(ValueSE)
                %Value size of structering element is not numeric, not real
                %or negativ.
                
                %set value to 1
                ValueSE = 1;
                set(obj.viewEditHandle.B_SizeSE,'String','1')
            end
            
            if isnan(ValueNoI) || ValueNoI < 1 || ~isreal(ValueNoI)
                %Value number of iterations is not numeric, not real or
                %negativ.
                
                %set value to 1
                ValueSE = 1;
                set(obj.viewEditHandle.B_NoIteration,'String','1')
            end
            
            %set value in the model
            obj.modelEditHandle.SizeSE = ValueSE;
            set(obj.viewEditHandle.B_SizeSE,'String',num2str(ValueSE));
            
            obj.modelEditHandle.NoIteration = ValueNoI;
            set(obj.viewEditHandle.B_NoIteration,'String',num2str(ValueNoI));
        end
        
        function startMorphOPEvent(obj,src,evnt)
            % Callback function of the run morph operation button in the
            % GUI. Runs the runMorphOperation function in the editModel
            % object.
            %
            %   startMorphOPEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            obj.modelEditHandle.runMorphOperation();
        end
        
        function startDragFcn(obj,~,~)
            % ButtonDownFcn callback function of the GUI figure. Set the
            % WindowButtonMotionFcn callback function of the GUI figure.
            % Get the current cursor position in the figure and calls the
            % startDragFcn in the editModel.
            %
            %
            %   startDragFcn(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            if ~isempty(obj.modelEditHandle.handlePicBW)
                
                if (obj.viewEditHandle.B_Color.Value == 1 || ...
                     obj.viewEditHandle.B_Color.Value == 2 )   
                % Color Black or white is selected to use free hand draw
                % mode.
                set(obj.mainFigure,'WindowButtonUpFcn',@obj.stopDragFcn);
                set(obj.mainFigure,'WindowButtonMotionFcn',@obj.dragFcn);
                Pos = get(obj.viewEditHandle.hAP, 'CurrentPoint');
                obj.modelEditHandle.startDragFcn(Pos);
                
                elseif (obj.viewEditHandle.B_Color.Value == 3 || ...
                     obj.viewEditHandle.B_Color.Value == 4 ) 
                % Color Black or white is selected to use region fill
                % mode. 
                Pos = get(obj.viewEditHandle.hAP, 'CurrentPoint');
                obj.modelEditHandle.fillRegion(Pos);
                else
                    
                end
                
            end
        end
        
        function dragFcn(obj,~,~)
            % WindowButtonMotionFcn callback function of the GUI figure.
            % Get the current cursor position in the figure and calls the
            % dragFcn in the editModel.
            %
            %   dragFcn(obj;
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            %get cursor positon in binary pic
            Pos = get(obj.viewEditHandle.hAP, 'CurrentPoint');
            %call drag fcn in model with given cursor position
            obj.modelEditHandle.DragFcn(Pos);
        end
        
        function stopDragFcn(obj,~,~)
            % ButtonUpFcn callback function of the GUI figure. Delete the
            % WindowButtonMotionFcn callback function of the GUI figure.
            % Calls the stopDragFcn in the editModel.
            %
            %
            %   stopDragFcn(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            %clear ButtonUp and motion function
            set(obj.mainFigure,'WindowButtonUpFcn','');
            set(obj.mainFigure,'WindowButtonMotionFcn','');
            %call stop drag fcn in model
            obj.modelEditHandle.stopDragFcn();
        end
        
        function startAnalyzeModeEvent(obj,src,evnt)
            % Callback function of the Start Analyze Mode-Button in the GUI.
            % Calls the function sendPicsToController() in the editModel to
            % send all image Data to the analyze model. Calls the
            % startAnalyzeMode function in the controllerAnalyze instanze.
            %
            %   startAnalyzeModeEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            obj.modelEditHandle.InfoMessage = ' ';
            
            %get all pic data from the model
            PicData = obj.modelEditHandle.sendPicsToController();
            
            %Send Data to Controller Analyze
            InfoText = get(obj.viewEditHandle.B_InfoText, 'String');
            obj.controllerAnalyzeHandle.startAnalyzeModeEvent(PicData,InfoText);
        end
        
        function undoEvent(obj,src,evnt)
            % Callback function of the Undo Button in the GUI. Calls the
            % undo() function in the editModel.
            %
            %   undoEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            obj.modelEditHandle.undo();
        end
        
        function redoEvent(obj,src,evnt)
            % Callback function of the Redo Button in the GUI. Calls the
            % redo() function in the editModel.
            %
            %   redoEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            obj.modelEditHandle.redo();
        end
        
        function setInfoTextView(obj,InfoText)
            % Sets the log text on the GUI.
            % Only called by changing the MVC if the stage of the
            % program changes.
            %
            %   setInfoTextView(obj,InfoText);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to controllerEdit object
            %           InfoText:   Info text log
            %
            set(obj.viewEditHandle.B_InfoText, 'String', InfoText);
            set(obj.viewEditHandle.B_InfoText, 'Value' , length(obj.viewEditHandle.B_InfoText.String));
        end
        
        function updateInfoLogEvent(obj,src,evnt)
            % Listener callback function of the InfoMessage propertie in
            % the model. Is called when InfoMessage string changes. Appends
            % the text in InfoMessage to the log text in the GUI.
            %
            %   updateInfoLogEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            InfoText = cat(1, get(obj.viewEditHandle.B_InfoText, 'String'), {obj.modelEditHandle.InfoMessage});
            set(obj.viewEditHandle.B_InfoText, 'String', InfoText);
            set(obj.viewEditHandle.B_InfoText, 'Value' , length(obj.viewEditHandle.B_InfoText.String));
            drawnow;
            pause(0.05)
        end
        
        function closeProgramEvent(obj,~,~)
            % Colose Request function of the main figure.
            %
            %   closeProgramEvent(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            choice = questdlg({'Are you sure you want to quit? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            
            switch choice
                case 'Yes'
                    
                    delete(obj.viewEditHandle);
                    delete(obj.modelEditHandle);
                    delete(obj.mainCardPanel);
                    
                    %find all objects
                    object_handles = findall(obj.mainFigure);
                    %delete objects
                    delete(object_handles);
                    %delete main figure
                    delete(obj.mainFigure);
                case 'No'
                    obj.modelEditHandle.InfoMessage = '   - closing program canceled';
                otherwise
                    obj.modelEditHandle.InfoMessage = '   - closing program canceled';
            end
            
        end
        
        function delete(obj)
            %deconstructor
            delete(obj)
        end
    end
    
    
end

