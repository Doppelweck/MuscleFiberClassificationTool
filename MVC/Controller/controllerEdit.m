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
        mainFigure;
        mainCardPanel;
        viewEditHandle; %hande to viewEdit object
        modelEditHandle; %hande to modelEdit object
        controllerAnalyzeHandle; %hande to controllerAnalyze object
    end
    
    methods
        
        function obj = controllerEdit(mainFigure,mainCardPanel,viewEditH,modelEditH)
            % constructer
            obj.mainFigure =mainFigure;
            obj.mainCardPanel =mainCardPanel;
            
            obj.viewEditHandle = viewEditH;
            
            obj.modelEditHandle = modelEditH;
            
            obj.addMyListener();
            
            obj.setInitValueInModel();
            
            obj.addMyCallbacks();
            
            obj.addWindowCallbacks();
            
            obj.modelEditHandle.InfoMessage = '*** Start program ***';
            obj.modelEditHandle.InfoMessage = 'Fiber-Type classification tool';
            obj.modelEditHandle.InfoMessage = ' ';
            obj.modelEditHandle.InfoMessage = 'Developed by:';
            obj.modelEditHandle.InfoMessage = 'Trier University of Applied Sciences';
            obj.modelEditHandle.InfoMessage = 'Version 1.0 2016';
            obj.modelEditHandle.InfoMessage = ' ';
            obj.modelEditHandle.InfoMessage = 'Press "NewPic" to start';
            
            
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
            set(obj.viewEditHandle.B_CheckPlanes,'Enable','off')
            
        end % end constructor
        
        function addMyListener(obj)
            % add listeners to the several button objects in the viewEdit
            % instance and value objects or handles in the editModel.
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
            % set callback functions to several button objects in the viewEdit
            % instance and handles im the editModel.
            %
            %   addMyCallbacks(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            set(obj.modelEditHandle.handlePicBW,'ButtonDownFcn',@obj.startDragFcn);
% %             set(obj.viewEditHandle.hAP,'ButtonDownFcn',@obj.startDragFcn);
% %             set(obj.viewEditHandle.hFP,'WindowButtonUpFcn',@obj.stopDragFcn);
%             set(obj.viewEditHandle.hFP,'CloseRequestFcn',@obj.closeProgramEvent);
            
            set(obj.viewEditHandle.B_Undo,'Callback',@obj.undoEvent);
            set(obj.viewEditHandle.B_Redo,'Callback',@obj.redoEvent);
            set(obj.viewEditHandle.B_NewPic,'Callback',@obj.newPictureEvent);
            set(obj.viewEditHandle.B_StartAnalyzeMode,'Callback',@obj.startAnalyzeModeEvent);
            set(obj.viewEditHandle.B_CheckPlanes,'Callback',@obj.checkPlanesEvent);
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
            set(obj.mainFigure,'ButtonDownFcn',@obj.startDragFcn);
            set(obj.mainFigure,'WindowButtonMotionFcn','');
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);
        end
        
        
        function setInitValueInModel(obj)
            % set the initalize values in the editModel.
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
                % first start of the programm. No imagehandle exist.
                % create image handle for Pic RGB
                obj.modelEditHandle.handlePicRGB = imshow(PicRGB);
            else
                % New image was selected. Change data in existing handle
                obj.modelEditHandle.handlePicRGB.CData = PicRGB;
            end
            
            hold on
            
            if isa(obj.modelEditHandle.handlePicBW,'struct')
                % first start of the programm. No imagehandle exist.
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
            
        end
        
        function newPictureEvent(obj,~,~)
            % Callback function of the NewPic-Button in the GUI. Opens a
            % input dialog where the user can select a new image for
            % further processing.
            %
            %   newPictureEvent(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %
            
            set(obj.viewEditHandle.B_NewPic,'Enable','off');
            set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
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
            
            succsesNewPic = obj.modelEditHandle.openNewPic();
            
            %             temp = obj.modelEditHandle.loadPics();
            
            if succsesNewPic
                
                % clear info text log
                set(obj.viewEditHandle.B_InfoText, 'String','*** New Picture selected ***')
                
                sucsessLoadPic = obj.modelEditHandle.loadPics();
                
                if sucsessLoadPic
                    obj.modelEditHandle.planeIdentifier();
                    
                    obj.modelEditHandle.brightnessAdjustment();
                    
                    obj.modelEditHandle.PicBWisInvert = 'false';
                    
                    obj.modelEditHandle.createBinary();
                    
                    obj.modelEditHandle.PicBuffer = {};
                    
                    obj.modelEditHandle.PicBuffer{1,1} = obj.modelEditHandle.PicBW;
                    
                    obj.modelEditHandle.PicBufferPointer = 1;
                    
                    obj.setInitPicsGUI();
                    set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','on');
                    set(obj.viewEditHandle.B_CheckPlanes,'Enable','on');
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

                else
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
                end
                
            elseif isa(obj.modelEditHandle.handlePicRGB,'struct')
                
                set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
                set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
            else
                if isempty(obj.modelEditHandle.handlePicBW);
                    set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','off');
                    set(obj.viewEditHandle.B_CheckPlanes,'Enable','off');
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
                else
                    set(obj.viewEditHandle.B_StartAnalyzeMode,'Enable','on');
                    set(obj.viewEditHandle.B_CheckPlanes,'Enable','on');
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
                end
            end
            set(obj.viewEditHandle.B_NewPic,'Enable','on');
        end
        
        function checkPlanesEvent(obj,~,~)
            % Callback function of the Check planes button in the GUI.
            % Opens a new figure that shows all color plane pictures
            % identified by the program. Thee figure also shows the
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
                    
                    obj.modelEditHandle.brightnessAdjustment();
                    obj.modelEditHandle.PicBWisInvert = 'false';
                    obj.modelEditHandle.createBinary();
                    obj.modelEditHandle.PicBuffer = {};
                    obj.modelEditHandle.PicBuffer{1,1} = obj.modelEditHandle.PicBW;
                    obj.modelEditHandle.PicBufferPointer = 1;
                    
                    obj.viewEditHandle.B_AxesCheckPlaneGreen.Children.CData = obj.modelEditHandle.PicPlaneGreen;
                    obj.viewEditHandle.B_AxesCheckPlaneBlue.Children.CData = obj.modelEditHandle.PicPlaneBlue;
                    obj.viewEditHandle.B_AxesCheckPlaneRed.Children.CData = obj.modelEditHandle.PicPlaneRed;
                    obj.viewEditHandle.B_AxesCheckPlaneFarRed.Children.CData = obj.modelEditHandle.PicPlaneFarRed;
                    obj.viewEditHandle.B_AxesCheckRGBPlane.Children.CData = obj.modelEditHandle.PicRGBPlanes;
                    
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
            % model depending on the selection.
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
                
            elseif Mode == 2
                % Use automatic adaptive threshold for binarization
                set(obj.viewEditHandle.B_ThresholdValue,'Enable','off');
                set(obj.viewEditHandle.B_Threshold,'Enable','off');
                obj.modelEditHandle.ThresholdMode = Mode;
                obj.modelEditHandle.InfoMessage = '      - Adaptive threshold mode has been selected';
                
            elseif Mode == 3
                % Use automatic adaptive and manual global threshold for binarization
                set(obj.viewEditHandle.B_ThresholdValue,'Enable','on');
                set(obj.viewEditHandle.B_Threshold,'Enable','on');
                obj.modelEditHandle.ThresholdMode = Mode;
                obj.modelEditHandle.InfoMessage = '      - Combined threshold has been selected';
                obj.modelEditHandle.InfoMessage = '      - Use slider to change threshold';
            else
                % Error Code
            end
            
            
        end
        
        function thresholdEvent(obj,src,evnt)
            % Callback function of the threshold slider and the text edit
            % box in the GUI. Checks whether the value is within the
            % permitted value range. Sets the corresponding values
            % in the model depending on the selection.
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
                        obj.modelEditHandle.ThresholdValue = 1;
                        
                    elseif Value < 0
                        % Value is smaller than 0. Set Value to 0.
                        set(obj.viewEditHandle.B_Threshold,'Value',0);
                        set(obj.viewEditHandle.B_ThresholdValue,'String','0');
                        obj.modelEditHandle.ThresholdValue = 0;
                    else
                        % Value is ok
                        set(obj.viewEditHandle.B_Threshold,'Value',Value);
                        obj.modelEditHandle.ThresholdValue = Value;
                    end
                else
                    % Value is not numerical. Set Value to 0.1.
                    set(obj.viewEditHandle.B_Threshold,'Value',0.1);
                    set(obj.viewEditHandle.B_ThresholdValue,'String','0.1');
                    obj.modelEditHandle.ThresholdValue = 0.1;
                end
                
            elseif strcmp(evnt.Source.Tag,'sliderThreshold')
                % slider Value has changed
                set(obj.viewEditHandle.B_ThresholdValue,'String',num2str(evnt.Source.Value));
                obj.modelEditHandle.ThresholdValue = evnt.Source.Value;
            else
                % Error Code
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
                        set(obj.viewEditHandle.B_Alpha,'Value',1);
                        set(obj.viewEditHandle.B_AlphaValue,'String','1');
                        obj.modelEditHandle.AlphaMapValue = 1;
                    elseif Value < 0
                        % Value is smaller than 0. Set Value to 0.
                        set(obj.viewEditHandle.B_Alpha,'Value',0);
                        set(obj.viewEditHandle.B_AlphaValue,'String','0');
                        obj.modelEditHandle.AlphaMapValue = 0;
                        
                    else
                        % Value is ok
                        set(obj.viewEditHandle.B_Alpha,'Value',Value);
                        obj.modelEditHandle.AlphaMapValue = Value;
                    end
                else
                    % Value is not numerical. Set Value to 1.
                    set(obj.viewEditHandle.B_Alpha,'Value',1);
                    set(obj.viewEditHandle.B_AlphaValue,'String','1');
                    obj.modelEditHandle.AlphaMapValue = 1;
                    
                end
                
            elseif strcmp(evnt.Source.Tag,'sliderAlpha')
                % slider Value has changed
                set(obj.viewEditHandle.B_AlphaValue,'String',num2str(evnt.Source.Value));
                obj.modelEditHandle.AlphaMapValue = evnt.Source.Value;
            else
                % Error Code
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
            else
                % Error Code
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
            
            String = src.String{src.Value};
            
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
                    obj.modelEditHandle.morphOP = '';
                    
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
                
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                
            elseif strcmp(tempMorpStr,'erode') || strcmp(tempMorpStr,'dilate')
                % Morph options that need a structuring element
                
                set(obj.viewEditHandle.B_ShapeSE,'Enable','on')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                
                if ~strcmp(tempSEStr,'') && ~strcmp(tempSEStr,'choose SE')
                    
                    set(obj.viewEditHandle.B_SizeSE,'Enable','on')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
                    
                end
                
            else
                
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
            
            String = src.String{src.Value};
            
            switch String
                
                case 'dimond'
                    
                    obj.modelEditHandle.SE = 'dimond';
                    
                case 'disk'
                    
                    obj.modelEditHandle.SE = 'disk';
                    
                case 'octagon'
                    
                    obj.modelEditHandle.SE = 'octagon';
                    
                case 'square'
                    
                    obj.modelEditHandle.SE = 'square';
                    
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
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                set(obj.viewEditHandle.B_ShapeSE,'Enable','off')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
            elseif strcmp(tempMorpStr,'erode') || strcmp(tempMorpStr,'dilate')
                % Morph options that need a structuring element
                set(obj.viewEditHandle.B_ShapeSE,'Enable','on')
                set(obj.viewEditHandle.B_SizeSE,'Enable','off')
                set(obj.viewEditHandle.B_NoIteration,'Enable','off')
                set(obj.viewEditHandle.B_StartMorphOP,'Enable','off')
                if ~strcmp(tempSEStr,'') && ~strcmp(tempSEStr,'choose SE')
                    set(obj.viewEditHandle.B_SizeSE,'Enable','on')
                    set(obj.viewEditHandle.B_NoIteration,'Enable','on')
                    set(obj.viewEditHandle.B_StartMorphOP,'Enable','on')
                end
                
            else
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
            
            ValueSE = round(str2double(obj.viewEditHandle.B_SizeSE.String));
            ValueNoI = round(str2double(obj.viewEditHandle.B_NoIteration.String));
            
            if isnan(ValueSE) || ValueSE < 1 || ~isreal(ValueSE)
                ValueSE = 1;
                set(obj.viewEditHandle.B_SizeSE,'String','1')
            end
            
            if isnan(ValueNoI) || ValueNoI < 1 || ~isreal(ValueNoI)
                ValueSE = 1;
                set(obj.viewEditHandle.B_NoIteration,'String','1')
            end
            
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
            if ~isempty(obj.modelEditHandle.handlePicBW);
                
            set(obj.mainFigure,'WindowButtonUpFcn',@obj.stopDragFcn);
            set(obj.mainFigure,'WindowButtonMotionFcn',@obj.dragFcn);
            Pos = get(obj.viewEditHandle.hAP, 'CurrentPoint');
            obj.modelEditHandle.startDragFcn(Pos);
            
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
            
            Pos = get(obj.viewEditHandle.hAP, 'CurrentPoint');
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
            
            set(obj.mainFigure,'WindowButtonUpFcn','');
            set(obj.mainFigure,'WindowButtonMotionFcn','');
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
            
            PicData = obj.modelEditHandle.sendPicsToController();
            
            %Send Data to Controller Alalyze
            InfoText = get(obj.viewEditHandle.B_InfoText, 'String');
            obj.controllerAnalyzeHandle.startAnalyzingMode(PicData,InfoText);
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
            set(obj.viewEditHandle.B_InfoText, 'String', InfoText);
            set(obj.viewEditHandle.B_InfoText, 'Value' , length(obj.viewEditHandle.B_InfoText.String));
        end
        
        function updateInfoLogEvent(obj,src,evnt)
            InfoText = cat(1, get(obj.viewEditHandle.B_InfoText, 'String'), {obj.modelEditHandle.InfoMessage});
            set(obj.viewEditHandle.B_InfoText, 'String', InfoText);
            set(obj.viewEditHandle.B_InfoText, 'Value' , length(obj.viewEditHandle.B_InfoText.String));
            drawnow;
            pause(0.05)
        end
        
        function closeProgramEvent(obj,~,~)
            
            choice = questdlg({'Are you sure you want to quit? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            
            switch choice
                case 'Yes'
                    figHandles = findall(0,'Type','figure');
                    object_handles = findall(figHandles);
                    delete(object_handles);
                    delete(figHandles)
                case 'No'
                    obj.modelEditHandle.InfoMessage = '   - closing program canceled';
                otherwise
                    obj.modelEditHandle.InfoMessage = '   - closing program canceled';
            end
            
        end
        
        function delete(obj)
            
        end
    end
    
    
end

