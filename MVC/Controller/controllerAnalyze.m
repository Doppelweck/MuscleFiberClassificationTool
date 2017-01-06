classdef controllerAnalyze < handle
    %controllerAnalyze   Controller of the Analyze-MVC (Model-View-Controller).
    %Controls the communication and data exchange between the view
    %instance and the model instance. Connected to the edit- and results-
    %Controllers to communicate with the edit- and resulzs-MVC and to
    %exchange data between them.
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
        viewAnalyzeHandle; %hande to viewAnalyze instance.
        modelAnalyzeHandle; %hande to modelAnalyze instance.
        controllerEditHandle; %handle to controllerEdit instance.
        controllerResultsHandle; %handle to controllerRsults instance.
    end
    
    
    methods
        
        function obj = controllerAnalyze(mainFigure,mainCardPanel,viewAnalyzeH,modelAnalyzeH)
            % Constuctor of the controllerAnalyze class. Initialize the
            % callback and listener functions to observes the corresponding
            % View objects. Saves the needed handles of the corresponding
            % View and Model in the properties.
            %
            %   obj = controllerAnalyze(mainFigure,mainCardPanel,viewAnalyzH,modelAnalyzeH)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           mainFigure:     Handle to main figure.
            %           mainCardPanel:  Handle to main card panel.
            %           viewAnalyzeH:   Hande to viewAnalyze instance.
            %           modelAnalyzeH:  Hande to modelAnalyze instance.
            %
            %       - Output:
            %           obj:            Handle to controllerAnalyze object.
            %
            
            obj.mainFigure =mainFigure;
            obj.mainCardPanel =mainCardPanel;
            
            obj.viewAnalyzeHandle = viewAnalyzeH;
            obj.modelAnalyzeHandle =modelAnalyzeH;
            
            obj.setInitValueInModel();
            
            obj.addMyListener();
            
            obj.addMyCallbacks();
        end
        
        function setInitValueInModel(obj)
            % Get the values from the buttons and GUI objects in the View
            % and set the values in the Model.
            %
            %   setInitValueInModel(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            obj.modelAnalyzeHandle.AnalyzeMode = obj.viewAnalyzeHandle.B_AnalyzeMode.Value;
            
            obj.modelAnalyzeHandle.AreaActive = obj.viewAnalyzeHandle.B_AreaActive.Value;
            obj.modelAnalyzeHandle.MinAreaPixel = str2double(obj.viewAnalyzeHandle.B_MinArea.String);
            obj.modelAnalyzeHandle.MaxAreaPixel = str2double(obj.viewAnalyzeHandle.B_MaxArea.String);
            
            obj.modelAnalyzeHandle.RoundnessActive = obj.viewAnalyzeHandle.B_RoundnessActive.Value;
            obj.modelAnalyzeHandle.MinRoundness = str2double(obj.viewAnalyzeHandle.B_MinRoundness.String);
            
            obj.modelAnalyzeHandle.ColorDistanceActive = obj.viewAnalyzeHandle.B_ColorDistanceActive.Value;
            obj.modelAnalyzeHandle.MinColorDistance = str2double(obj.viewAnalyzeHandle.B_ColorDistance.String);
            
            obj.modelAnalyzeHandle.AspectRatioActive = obj.viewAnalyzeHandle.B_AspectRatioActive.Value;
            obj.modelAnalyzeHandle.MinAspectRatio = str2double(obj.viewAnalyzeHandle.B_MinAspectRatio.String);
            obj.modelAnalyzeHandle.MaxAspectRatio = str2double(obj.viewAnalyzeHandle.B_MaxAspectRatio.String);
            
            obj.modelAnalyzeHandle.ColorValueActive = obj.viewAnalyzeHandle.B_ColorValueActive.Value;
            obj.modelAnalyzeHandle.ColorValue = str2double(obj.viewAnalyzeHandle.B_ColorValue.String);
            
        end
        
        function addMyCallbacks(obj)
            % Set callback functions to several button objects in the
            % viewAnalyze instance.
            %
            %   addMyCallbacks(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            set(obj.viewAnalyzeHandle.B_BackEdit,'Callback',@obj.backEditEvent);
            set(obj.viewAnalyzeHandle.B_StartResults,'Callback',@obj.startResultsEvent);
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Callback',@obj.startAnalyzeEvent);
            
            set(obj.viewAnalyzeHandle.B_AnalyzeMode,'Callback',@obj.analyzeModeEvent)
            
            set(obj.viewAnalyzeHandle.B_AreaActive,'Callback',@obj.activeParaEvent);
            set(obj.viewAnalyzeHandle.B_RoundnessActive,'Callback',@obj.activeParaEvent);
            set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Callback',@obj.activeParaEvent);
            set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Callback',@obj.activeParaEvent);
            set(obj.viewAnalyzeHandle.B_ColorValueActive,'Callback',@obj.activeParaEvent);
        end
        
        function addWindowCallbacks(obj)
            % Set callback functions of the main figure
            %
            %   addWindowCallbacks(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            set(obj.mainFigure,'ButtonDownFcn','');
            set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
            set(obj.modelAnalyzeHandle.handlePicRGB,'ButtonDownFcn',@obj.manipulateFiberShowInfoEvent);
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);
            
        end
        
        function addMyListener(obj)
            % add listeners to the several button objects in the
            % viewAnalyze instance and value objects or handles in the
            % modelAnalyze.
            %
            %   addMyListener(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            % listeners VIEW
            addlistener(obj.viewAnalyzeHandle.B_MinArea,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MaxArea,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MinRoundness,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_ColorDistance,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MinAspectRatio,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MaxAspectRatio,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_ColorValue,'String','PostSet',@obj.valueUpdateEvent);
            
            % listeners MODEL
            addlistener(obj.modelAnalyzeHandle,'InfoMessage', 'PostSet',@obj.updateInfoLogEvent);
        end
        
        function valueUpdateEvent(obj,src,evnt)
            % Checks if a value in the GUI parameter panel has changed. If
            % a value has changed the function checks which source has
            % triggered the event. Checks if the value is in the permitted
            % range. Only changes the values in the view (GUI) not in the
            % model. Data will be send to the model after pressing start
            % analyze button.
            %
            %   valueUpdateEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %           src:    source of the callback.
            %           evnt:   callback event data.
            %
            
            % Which element has triggered the callback
            Tag = evnt.AffectedObject.Tag;
            % Value that has changed
            Value = str2double(evnt.AffectedObject.String);
            
            switch Tag
                
                case obj.viewAnalyzeHandle.B_MinArea.Tag
                    % MinArea has changed. Can only be positiv integer
                    % must be smaller than MaxArea
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If MinArea < 0 set MinArea to 0
                            set(obj.viewAnalyzeHandle.B_MinArea,'String','0');
                        elseif Value > str2double(obj.viewAnalyzeHandle.B_MaxArea.String)
                            %if MinArea > MaxArea set MinArea to MaxArea
                            set(obj.viewAnalyzeHandle.B_MinArea,'String',obj.viewAnalyzeHandle.B_MaxArea.String);
                        else
                            % Set MinArea value
                            set(obj.viewAnalyzeHandle.B_MinArea,'String',num2str(round(Value)));
                        end
                    else
                        % Value is not numerical. Set MinArea to MaxArea.
                        set(obj.viewAnalyzeHandle.B_MinArea,'String',obj.viewAnalyzeHandle.B_MaxArea.String);
                    end
                    
                case obj.viewAnalyzeHandle.B_MaxArea.Tag
                    % MaxArea has changed. Can only be positiv
                    % integer. Must be greater than MinArea
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < str2double(obj.viewAnalyzeHandle.B_MinArea.String)
                            % If MaxArea < MinArea set MaxArea to MinArea
                            set(obj.viewAnalyzeHandle.B_MaxArea,'String',obj.viewAnalyzeHandle.B_MinArea.String);
                        else
                            % Set MaxArea value
                            set(obj.viewAnalyzeHandle.B_MaxArea,'String',num2str(round(Value)));
                        end
                    else
                        % Value is not numerical. Set MaxArea to MinArea
                        set(obj.viewAnalyzeHandle.B_MaxArea,'String',obj.viewAnalyzeHandle.B_MinArea.String);
                    end
                    
                case obj.viewAnalyzeHandle.B_MinRoundness.Tag
                    % MinRoundness has changed. Can only be between 0 and
                    % 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set MinRoundness = 0
                            set(obj.viewAnalyzeHandle.B_MinRoundness,'String','0');
                        elseif Value > 1
                            % If Value > 1 set MinRoundness = 1
                            set(obj.viewAnalyzeHandle.B_MinRoundness,'String','1');
                        else
                            % Set MinRound value
                            set(obj.viewAnalyzeHandle.B_MinRoundness,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 0
                        set(obj.viewAnalyzeHandle.B_MinRoundness,'String','0');
                    end
                    
                case obj.viewAnalyzeHandle.B_ColorDistance.Tag
                    % ColorDistance has changed. Can only be between 0
                    % and 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set ColorDistance = 0
                            set(obj.viewAnalyzeHandle.B_ColorDistance,'String','0');
                        elseif Value > 1
                            % If Value > 1 setColorDistance = 1
                            set(obj.viewAnalyzeHandle.B_ColorDistance,'String','1');
                        else
                            % Set ColorDistance value
                            set(obj.viewAnalyzeHandle.B_ColorDistance,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set Value to 0
                        set(obj.viewAnalyzeHandle.B_ColorDistance,'String','0');
                    end
                    
                case obj.viewAnalyzeHandle.B_MinAspectRatio.Tag
                    % MinAspectRatio has changed. Can only be positiv
                    % Integer >= 1. Must be smaller than MaxAspectRatio
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 1
                            % If Value < 1 set MinAspectRatio = 1
                            set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String','1');
                        elseif Value > str2double(obj.viewAnalyzeHandle.B_MaxAspectRatio.String)
                            % If MinAspectRatio > MaxAspectRatio set MinAspectRatio to MaxAspectRatio
                            set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String',obj.viewAnalyzeHandle.B_MaxAspectRatio.String);
                        else
                            % Set MinAspectRatio value
                            set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 1
                        set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String','1');
                    end
                    
                case obj.viewAnalyzeHandle.B_MaxAspectRatio.Tag
                    % MaxAspectRatio has changed. Can only be positiv
                    % Integer >= 1. Must be greater or equal than MaxAspectRatio
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < str2double(obj.viewAnalyzeHandle.B_MinAspectRatio.String)
                            % If MaxAspectRatio < MinAspectRatio set MaxAspectRatio to MinAspectRatio
                            set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'String',obj.viewAnalyzeHandle.B_MinAspectRatio.String);
                        else
                            % Set MaxAspectRatio to Value
                            set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set MaxAspectRatio to MinAspectRatio
                        set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'String',obj.viewAnalyzeHandle.B_MinAspectRatio.String);
                    end
                    
                case obj.viewAnalyzeHandle.B_ColorValue.Tag
                    % ColorValue has changed. Can only be between 0
                    % and 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set ColorDistance = 0
                            set(obj.viewAnalyzeHandle.B_ColorValue,'String','0');
                        elseif Value > 1
                            % If Value > 1 setColorDistance = 1
                            set(obj.viewAnalyzeHandle.B_ColorValue,'String','1');
                        else
                            % Set ColorDistance to Value
                            set(obj.viewAnalyzeHandle.B_ColorValue,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Dont change value.
                        set(obj.viewAnalyzeHandle.B_ColorValue,'String','0');
                    end
                    
                otherwise
                    % Error Code
                    obj.modelAnalyzeHandle.InfoMessage = '! ERROR in valueUpdateEvent() FUNCTION !';
            end
            
        end
        
        function analyzeModeEvent(obj,src,evnt)
            % Checks wich analyze mode is selecred. Only changes the values
            % in the view (GUI) not in the model. Data will be send to the
            % model after pressing start analyze button.
            %
            %   analyzeModeEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %           src:    source of the callback.
            %           evnt:   callback event data.
            %
            
            if src.Value == 1
                % Colordistance-Based classification
                
                obj.modelAnalyzeHandle.InfoMessage = '   - Parameter:';
                obj.modelAnalyzeHandle.InfoMessage = '      - Colordistance-Based classification were selected';
                obj.viewAnalyzeHandle.B_ColorDistanceActive.Value = 1;
                set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','on')
                
            elseif src.Value == 2
                % Cluster-Based  classification 2 Fiber Type cluster
                
                obj.modelAnalyzeHandle.InfoMessage = '   - Parameter:';
                obj.modelAnalyzeHandle.InfoMessage = '      - Cluster-Based classification were selected';
                obj.modelAnalyzeHandle.InfoMessage = '      - searching for 2 Fiber Type cluster';
                obj.viewAnalyzeHandle.B_ColorDistanceActive.Value = 0;
                set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','off')
                set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','off')
                obj.modelAnalyzeHandle.InfoMessage = '      - color distance parameter is not necessary';
                
            elseif src.Value == 3
                % Cluster-Based  classification 3 Fiber Type cluster
                
                obj.modelAnalyzeHandle.InfoMessage = '   - Parameter:';
                obj.modelAnalyzeHandle.InfoMessage = '      - Cluster-Based classification were selected';
                obj.modelAnalyzeHandle.InfoMessage = '      - searching for 3 Fiber Type cluster';
                obj.viewAnalyzeHandle.B_ColorDistanceActive.Value = 0;
                set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','off')
                set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','off')
                obj.modelAnalyzeHandle.InfoMessage = '      - color distance parameter is not necessary';
                
            end
            
        end
        
        function activeParaEvent(obj,src,evnt)
            % Checks if the active status of a parameter has changed.
            % Disables or enables the correspondening edit box elements in
            % the GUI if nessesary. Only changes the values in the view
            % (GUI) not in the model. Data will be send to the model after
            % pressing start analyze button.
            %
            %   activeParaEvent(obj,src,evnt)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %           src:    source of the callback.
            %           evnt:   callback event data.
            %
            
            % Which element has triggered the callback
            Tag = evnt.Source.Tag;
            % Value that has changed. Can only be 1 or 0 (true or false)
            Value = src.Value;
            
            switch Tag
                
                case obj.viewAnalyzeHandle.B_AreaActive.Tag
                    % AreaActive has changed. If it is zero, Area parameters
                    % won't be used for classification.
                    
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_MinArea,'Enable','off')
                        set(obj.viewAnalyzeHandle.B_MaxArea,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_MinArea,'Enable','on')
                        set(obj.viewAnalyzeHandle.B_MaxArea,'Enable','on')
                    end
                    
                case obj.viewAnalyzeHandle.B_RoundnessActive.Tag
                    % RoundActive has changed. If it is zero, Roundness parameter
                    % won't be used for classification.
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                    end
                    
                case obj.viewAnalyzeHandle.B_AspectRatioActive.Tag
                    % AspectRatioActive has changed. If it is zero AspectRatio parameters
                    % won't be used for classification.
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','off')
                        set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','on')
                        set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','on')
                    end
                    
                case obj.viewAnalyzeHandle.B_ColorDistanceActive.Tag
                    % ColorDistanceActive has changed. If it is zero ColorDistance parameters
                    % won't be used for classification.
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','on')
                    end
                    
                case obj.viewAnalyzeHandle.B_ColorValueActive.Tag
                    % ColorValueActive has changed. If it is zero ColorValue parameters
                    % won't be used for classification.
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
                    end
                    
                otherwise
                    % Error Code
            end
            
        end
        
        function startAnalyzingMode(obj,PicData,InfoText)
            % Called by the controllerEdit instance when the user change
            % the program state to analyze-mode. Saves all nessessary Data
            % from the edit model into the analyze model.
            %
            %   startAnalyzingMode(obj,PicData,InfoText)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to controllerAnalyze object.
            %           PicData:    Cell Array that contains the file- and
            %               pathnames of the RGB image. Also contains the
            %               RGB and the color plane images:
            %
            %               PicData{1}: filename RGB image
            %               PicData{2}: path RGB image
            %               PicData{3}: RGB image
            %               PicData{4}: binary image
            %               PicData{5}: green plane image
            %               PicData{6}: blue plane image
            %               PicData{7}: red plane image
            %               PicData{8}: farred plane image
            %               PicData{9}: RGB image create from color plane
            %               images
            %
            %           InfoText:   Info text log.
            %
            
            
            % Set PicData Properties in the Analyze Model
            obj.modelAnalyzeHandle.FileNamesRGB = PicData{1};
            obj.modelAnalyzeHandle.PathNames = PicData{2};
            obj.modelAnalyzeHandle.PicRGB = PicData{3};
            obj.modelAnalyzeHandle.PicBW = PicData{4};
            obj.modelAnalyzeHandle.PicPlaneGreen = PicData{5};
            obj.modelAnalyzeHandle.PicPlaneBlue = PicData{6};
            obj.modelAnalyzeHandle.PicPlaneRed = PicData{7};
            obj.modelAnalyzeHandle.PicPlaneFarRed = PicData{8};
            obj.modelAnalyzeHandle.PicPRGBPlanes = PicData{9};
            
            % get axes for PicRGB in Analyze GUI
            axes(obj.viewAnalyzeHandle.hAP);
            
            % show PicRGB in Analyze GUI
            obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{3});
            axis on
            axis image
            
            % set panel title to filename and path
            Titel = [obj.modelAnalyzeHandle.PathNames obj.modelAnalyzeHandle.FileNamesRGB];
            obj.viewAnalyzeHandle.panelPicture.Title = Titel;
            
            % get axes for zoomed Pic in Analyze GUI FIber Information Panel
            axes(obj.viewAnalyzeHandle.B_AxesInfo);
            axis(obj.viewAnalyzeHandle.B_AxesInfo,'image');
            obj.modelAnalyzeHandle.handleInfoAxes = imshow([]);
            axis on
            
            % set InfoText log in View
            set(obj.viewAnalyzeHandle.B_InfoText, 'String', InfoText);
            set(obj.viewAnalyzeHandle.B_InfoText, 'Value' , length(obj.viewAnalyzeHandle.B_InfoText.String));
            
            % If a window for Fibertype manipulation already exists,
            % delete it
            OldFig = findobj('Tag','FigureManipulate');
            delete(OldFig);
            % If a Higlight Boundarie Box already exists,
            % delete it
            OldBox = findobj('Tag','highlightBox');
            delete(OldBox);
            
            %change the card panel to selection 2: analyze mode
            obj.mainCardPanel.Selection = 2;
            
            %change the figure callbacks for the analyze mode
            obj.addWindowCallbacks()
            
            obj.modelAnalyzeHandle.InfoMessage = '*** Start analyzing mode ***';
            obj.modelAnalyzeHandle.InfoMessage = '   -Set Parameters and press "Start analyzimg"';
            
        end
        
        function startAnalyzeEvent(obj,~,~)
            % Callback function of the start analyze button in the GUI.
            % Transfers all parameter data into the analyze model and start
            % the fiber type classification functions in the model. Disable
            % all GUI elements during the classification.
            %
            %   analyzeModeEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            % If a window for Fibertype manipulation already exists,
            % delete it
            OldFig = findobj('Tag','FigureManipulate');
            if ~isempty(OldFig)
                delete(OldFig);
                %refresh WindowButtonMotionFcn. If a Figure Manipulate
                %exist, than the WindowButtonMotionFcn is deleted
                set(obj.viewAnalyzeHandle.hFP,'WindowButtonMotionFcn',@obj.showFiberInfo);
            end
            
            % If a Higlight Boundarie Box already exists,
            % delete it
            if ~isempty(OldFig)
                OldBox = findobj('Tag','highlightBox');
                delete(OldBox);
                %refresh WindowButtonMotionFcn. If a Higlight Boundarie Box
                %exist, than the WindowButtonMotionFcn is deleted
                set(obj.viewAnalyzeHandle.hFP,'WindowButtonMotionFcn',@obj.showFiberInfo);
            end
            
            % send selected analyze mode to the model.
            obj.modelAnalyzeHandle.AnalyzeMode = obj.viewAnalyzeHandle.B_AnalyzeMode.Value;
            
            % send selected area parameters to the model.
            obj.modelAnalyzeHandle.AreaActive = obj.viewAnalyzeHandle.B_AreaActive.Value;
            obj.modelAnalyzeHandle.MinAreaPixel = str2double(obj.viewAnalyzeHandle.B_MinArea.String);
            obj.modelAnalyzeHandle.MaxAreaPixel = str2double(obj.viewAnalyzeHandle.B_MaxArea.String);
            
            % send selected aspect ratio parameters to the model.
            obj.modelAnalyzeHandle.AspectRatioActive = obj.viewAnalyzeHandle.B_AspectRatioActive.Value;
            obj.modelAnalyzeHandle.MinAspectRatio = str2double(obj.viewAnalyzeHandle.B_MinAspectRatio.String);
            obj.modelAnalyzeHandle.MaxAspectRatio = str2double(obj.viewAnalyzeHandle.B_MaxAspectRatio.String);
            
            % send selected roundness parameters to the model.
            obj.modelAnalyzeHandle.RoundnessActive = obj.viewAnalyzeHandle.B_RoundnessActive.Value;
            obj.modelAnalyzeHandle.MinRoundness = str2double(obj.viewAnalyzeHandle.B_MinRoundness.String);
            
            % send selected color distance parameters to the model.
            obj.modelAnalyzeHandle.ColorDistanceActive = obj.viewAnalyzeHandle.B_ColorDistanceActive.Value;
            obj.modelAnalyzeHandle.MinColorDistance = str2double(obj.viewAnalyzeHandle.B_ColorDistance.String);
            
            % send selected color value parameters to the model.
            obj.modelAnalyzeHandle.ColorValueActive = obj.viewAnalyzeHandle.B_ColorValueActive.Value;
            obj.modelAnalyzeHandle.ColorValue = str2double(obj.viewAnalyzeHandle.B_ColorValue.String);
            
            % Disable all GUI buttons during classification
            set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','off')
            set(obj.viewAnalyzeHandle.B_StartResults,'Enable','off')
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','off')
            set(obj.viewAnalyzeHandle.B_AnalyzeMode,'Enable','off')
            set(obj.viewAnalyzeHandle.B_AreaActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_MinArea,'Enable','off')
            set(obj.viewAnalyzeHandle.B_MaxArea,'Enable','off')
            set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','off')
            set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','off')
            set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','off')
            set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','off')
            set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','off')
            
            % start the classification
            obj.modelAnalyzeHandle.startAnalysze();
            
            % Enable all GUI buttons
            set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','on')
            set(obj.viewAnalyzeHandle.B_StartResults,'Enable','on')
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','on')
            set(obj.viewAnalyzeHandle.B_AnalyzeMode,'Enable','on')
            
            set(obj.viewAnalyzeHandle.B_AreaActive,'Enable','on')
            if obj.viewAnalyzeHandle.B_AreaActive.Value == 1
                set(obj.viewAnalyzeHandle.B_MinArea,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MaxArea,'Enable','on')
            end
            
            set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','on')
            if obj.viewAnalyzeHandle.B_RoundnessActive.Value == 1
                set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
            end
            
            set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','on')
            if obj.viewAnalyzeHandle.B_AspectRatioActive.Value == 1
                set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','on')
            end
            
            set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','on')
            if obj.viewAnalyzeHandle.B_ColorDistanceActive.Value == 1
                set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','on')
            end
            
            set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','on')
            if obj.viewAnalyzeHandle.B_ColorValueActive.Value == 1
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
            end
        end
        
        function backEditEvent(obj,~,~)
            % Callback function of the back edit mode button in the GUI.
            % Clears the data in the analyze model and change the state of
            % the program to the edit mode. Refresh the figure callbacks
            % for the edit mode.
            %
            %   analyzeModeEvent(obj,src,evnt);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            obj.modelAnalyzeHandle.InfoMessage = ' ';
            
            %clear Data
            obj.modelAnalyzeHandle.Stats = [];
            obj.modelAnalyzeHandle.LabelMat = [];
            obj.modelAnalyzeHandle.BoundarieMat = [];
            % Clear PicRGB and Boundarie Objects
            handleChild = allchild(obj.modelAnalyzeHandle.handlePicRGB.Parent);
            delete(handleChild);
            
            % If a window for Fibertype manipulation already exists,
            % delete it
            OldFig = findobj('Tag','FigureManipulate');
            if ~isempty(OldFig)
                delete(OldFig);
            end
            
            % If a Higlight Boundarie Box already exists,
            % delete it
            if ~isempty(OldFig)
                OldBox = findobj('Tag','highlightBox');
                delete(OldBox);
            end
            
            % set log text from Analyze GUI to Pic GUI
            obj.controllerEditHandle.setInfoTextView(get(obj.viewAnalyzeHandle.B_InfoText, 'String'));
            
            %change the card panel to selection 1: edit mode
            obj.mainCardPanel.Selection = 1;
            
            %change the figure callbacks for the edit mode
            obj.controllerEditHandle.addWindowCallbacks();
            
            obj.controllerEditHandle.modelEditHandle.InfoMessage = '*** Back to Edit mode ***';
        end
        
        function startResultsEvent(obj,~,~)
            % Callback function of the show rsults button in the GUI.
            % Starts the rusults mode. transfers all data from the analyze
            % model to the results model.
            %
            %   startResultsEvent(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            if isempty(obj.modelAnalyzeHandle.Stats)
                obj.modelAnalyzeHandle.InfoMessage = '   - No data are analyzed';
                obj.modelAnalyzeHandle.InfoMessage = '   - Press "Start analyzing"';
            else
                
                % If a window for Fibertype manipulation already exists,
                % delete it
                OldFig = findobj('Tag','FigureManipulate');
                if ~isempty(OldFig)
                    delete(OldFig);
                end
                
                % If a Higlight Boundarie Box already exists,
                % delete it
                if ~isempty(OldFig)
                    OldBox = findobj('Tag','highlightBox');
                    delete(OldBox);
                end
                
                obj.modelAnalyzeHandle.InfoMessage = ' ';
                
                % get data from the analyze model
                Data = obj.modelAnalyzeHandle.sendDataToController();
                
                % get info text log from analyze GUI
                InfoText = get(obj.viewAnalyzeHandle.B_InfoText, 'String');
                
                % send all data to the result controller and start the
                % result mode
                obj.controllerResultsHandle.startResultsMode(Data,InfoText);
            end
        end
        
        function showFiberInfo(obj,~,~)
            % WindowButtonMotionFcn of the main figure when the analyze
            % stage of the program is active. If the first analyze is
            % complete than the function shows the fiber information and a
            % zoomed picture of the fiber object in the fiber information
            % panel depending on the cursor position.
            %
            %   showFiberInfo(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            %get current cursor position in the rgb image.
            Pos = get(obj.viewAnalyzeHandle.hAP, 'CurrentPoint');
            
            %get data form the fiber object at the current positon.
            Info = obj.modelAnalyzeHandle.getFiberInfo(Pos);
            
            %show info in GUI fiber information panel.
            set(obj.viewAnalyzeHandle.B_TextObjNo,'String', Info{1} );
            set(obj.viewAnalyzeHandle.B_TextArea,'String', Info{2} );
            set(obj.viewAnalyzeHandle.B_TextAspectRatio,'String', Info{3} );
            set(obj.viewAnalyzeHandle.B_TextRoundness,'String', Info{4} );
            set(obj.viewAnalyzeHandle.B_TextColorDistance,'String', Info{5} );
            set(obj.viewAnalyzeHandle.B_TextColorValue,'String', Info{6} );
            set(obj.viewAnalyzeHandle.B_TextFiberType,'String', Info{7} );
            
            axis(obj.viewAnalyzeHandle.B_AxesInfo,'image');
            obj.modelAnalyzeHandle.handleInfoAxes.CData = Info{8};
            hlines = findobj(obj.viewAnalyzeHandle.B_AxesInfo,'Type','line');
            delete(hlines);
            
            switch Info{7}
                case '0'
                    Color = 'w';
                case '1'
                    Color = 'b';
                case '2'
                    Color = 'r';
                case '3'
                    Color = 'm';
                otherwise
                    Color = 'k';
            end
            
            visboundaries(obj.viewAnalyzeHandle.B_AxesInfo,Info{9},'Color',Color,'LineWidth',1);
            axis(obj.viewAnalyzeHandle.B_AxesInfo,'tight');
            
        end
        
        function manipulateFiberShowInfoEvent(obj,~,~)
            % ButtonDownFcn Callback function of the RGB image axes. Opens
            % a new figure at the positon where the user clicked. Allows
            % the user to change the fiber type manually after the
            % classification in that figure.
            %
            %   manipulateFiberShowInfoEvent(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %
            
            % Show the fiber information from the selected object on the
            % right side of the GUI
            obj.showFiberInfo();
            
            % If a window already exists, delete it
            OldFig = findobj('Tag','FigureManipulate');
            delete(OldFig);
            
            % If a highlight BoundarieBox already exists, delete it
            OldBox = findobj('Tag','highlightBox');
            delete(OldBox);
            
            % get Position of mouse cursor in the axes
            PosAxes = get(obj.viewAnalyzeHandle.hAP, 'CurrentPoint');
            PosOut = obj.modelAnalyzeHandle.checkPosition(PosAxes);
            
            if ~isnan(PosOut(1)) && ~isnan(PosOut(1)) && ~isempty(obj.modelAnalyzeHandle.LabelMat)
                
                %Check whether object was clicked
                Label = obj.modelAnalyzeHandle.LabelMat(PosOut(2),PosOut(1));
                
                if Label ~= 0
                    % If Label is zero than the click was on the background
                    % instead of a fiber object
                    
                    %block WindowButtonMotionFcn
                    set(obj.mainFigure,'WindowButtonMotionFcn','');
                    
                    % make axes with rgb image the current axes
                    axesh = obj.modelAnalyzeHandle.handlePicRGB.Parent;
                    axes(axesh)
                    
                    % get bounding box of the fiber at the selected
                    % position and plot the box.
                    PosBoundingBox = obj.modelAnalyzeHandle.Stats(Label).BoundingBox;
                    rectLine = rectangle('Position',PosBoundingBox,'EdgeColor','y','LineWidth',2);
                    set(rectLine,'Tag','highlightBox')
                    
                    % get object information at the selected position
                    Info = obj.modelAnalyzeHandle.getFiberInfo(PosOut);
                    
                    %get positon of the main figure
                    set(obj.mainFigure, 'Units','pixels');
                    PosMainFig = get(obj.mainFigure, 'Position');
                    PosCurrent = get(obj.mainFigure, 'CurrentPoint');
                    set(obj.mainFigure, 'Units','normalized');
                    
                    % create figure to show informations at the cursor position
                    obj.viewAnalyzeHandle.showInfoToManipulate(PosOut,PosMainFig,PosCurrent,Info);
                    
                    % refresh Callbacks on figure manupilate fiber info
                    set(obj.viewAnalyzeHandle.B_ManipulateOK,'Callback',@obj.manipulateFiberOKEvent);
                    set(obj.viewAnalyzeHandle.B_ManipulateCancel,'Callback',@obj.manipulateFiberCancelEvent);
                    set(obj.viewAnalyzeHandle.hFM,'closereq',@obj.manipulateFiberCancelEvent);
                else
                % click was on the background
                % refresh Callback function in figure AnalyzeMode
                set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
                end
            end
        end
        
        function manipulateFiberOKEvent(obj,src,evnt)
            % Callback function of the ok button in the maipulate fiber
            % type figure. Calls the manipulateFiberOK() fuction in the
            % model to change the fiber type into the new one.
            %
            %   manipulateFiberShowInfoEvent(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %           src:    source of the callback.
            %           evnt:   callback event data.
            %
            
            NewFiberType = get(obj.viewAnalyzeHandle.B_FiberTypeManipulate, 'Value');
            LabelNumber = str2num( get(obj.viewAnalyzeHandle.B_TextObjNo, 'String') );
            
            %change fiber type
            obj.modelAnalyzeHandle.manipulateFiberOK(NewFiberType, LabelNumber);
            
            set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
            % If a window for Fibertype manipulation already exists,
            % delete it
            OldFig = findobj('Tag','FigureManipulate');
            delete(OldFig);
            % If a Higlight Boundarie Box already exists,
            % delete it
            OldBox = findobj('Tag','highlightBox');
            delete(OldBox);
        end
        
        function manipulateFiberCancelEvent(obj,src,evnt)
            % Callback function of the cancel button in the maipulate fiber
            % type figure. Deletes the maipulate fiber figure object and
            % refresh the callback functions of the main figure.
            %
            %   manipulateFiberShowInfoEvent(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object.
            %           src:    source of the callback.
            %           evnt:   callback event data.
            %
            
            % If a window for Fibertype manipulation already exists,
            % delete it
            OldFig = findobj('Tag','FigureManipulate');
            delete(OldFig);
            % If a Higlight Boundarie Box already exists,
            % delete it
            OldBox = findobj('Tag','highlightBox');
            delete(OldBox);
            
            % refresh Callback function in figure AnalyzeMode
            set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
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
            
            set(obj.viewAnalyzeHandle.B_InfoText, 'String', InfoText);
            set(obj.viewAnalyzeHandle.B_InfoText, 'Value' , length(obj.viewAnalyzeHandle.B_InfoText.String));
        end
        
        function updateInfoLogEvent(obj,src,evnt)
            % Listener callback function of the InfoMessage propertie in
            % the model. Is called when InfoMessage string changes. Appends
            % the text in InfoMessage to the log text in the GUI.
            %
            %   updateInfoLogEvent(obj,src,evnt)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            InfoText = cat(1, get(obj.viewAnalyzeHandle.B_InfoText, 'String'), {obj.modelAnalyzeHandle.InfoMessage});
            set(obj.viewAnalyzeHandle.B_InfoText, 'String', InfoText);
            set(obj.viewAnalyzeHandle.B_InfoText, 'Value' , length(obj.viewAnalyzeHandle.B_InfoText.String));
            drawnow;
            pause(0.05)
        end
        
        function newPictureEvent(obj)
            % Calls by the controller results-mode. Get back to the edit
            % mode and call the newPictureEvent function to select a new
            % image for further processing.
            %
            %   updateInfoLogEvent(obj,src,evnt)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerEdit object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            obj.backEditEvent();
            obj.controllerEditHandle.newPictureEvent();
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
                    figHandles = findall(0,'Type','figure');
                    object_handles = findall(figHandles);
                    delete(object_handles);
                    delete(figHandles)
                case 'No'
                    obj.modelAnalyzeHandle.InfoMessage = '   - closing program canceled';
                otherwise
                    obj.modelAnalyzeHandle.InfoMessage = '   - closing program canceled';
            end
            
        end
        
        function delete(obj)
            %deconstructor
        end
        
        
    end
    
    
end

