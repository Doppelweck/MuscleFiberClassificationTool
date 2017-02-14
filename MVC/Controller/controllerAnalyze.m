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
            obj.modelAnalyzeHandle.MinArea = str2double(obj.viewAnalyzeHandle.B_MinArea.String);
            obj.modelAnalyzeHandle.MaxArea = str2double(obj.viewAnalyzeHandle.B_MaxArea.String);
            
            obj.modelAnalyzeHandle.RoundnessActive = obj.viewAnalyzeHandle.B_RoundnessActive.Value;
            obj.modelAnalyzeHandle.MinRoundness = str2double(obj.viewAnalyzeHandle.B_MinRoundness.String);
            
            obj.modelAnalyzeHandle.AspectRatioActive = obj.viewAnalyzeHandle.B_AspectRatioActive.Value;
            obj.modelAnalyzeHandle.MinAspectRatio = str2double(obj.viewAnalyzeHandle.B_MinAspectRatio.String);
            obj.modelAnalyzeHandle.MaxAspectRatio = str2double(obj.viewAnalyzeHandle.B_MaxAspectRatio.String);
            
            obj.modelAnalyzeHandle.BlueRedThreshActive = obj.viewAnalyzeHandle.B_BlueRedThreshActive.Value;
            obj.modelAnalyzeHandle.BlueRedThresh = str2double(obj.viewAnalyzeHandle.B_BlueRedThresh.String);
            obj.modelAnalyzeHandle.BlueRedDistBlue = str2double(obj.viewAnalyzeHandle.B_BlueRedDistBlue.String);
            obj.modelAnalyzeHandle.BlueRedDistRed = str2double(obj.viewAnalyzeHandle.B_BlueRedDistRed.String);
            
            obj.modelAnalyzeHandle.FarredRedThreshActive = obj.viewAnalyzeHandle.B_FarredRedThreshActive.Value;
            obj.modelAnalyzeHandle.FarredRedThresh = str2double(obj.viewAnalyzeHandle.B_FarredRedThresh.String);
            obj.modelAnalyzeHandle.FarredRedDistFarred = str2double(obj.viewAnalyzeHandle.B_FarredRedDistFarred.String);
            obj.modelAnalyzeHandle.FarredRedDistRed = str2double(obj.viewAnalyzeHandle.B_FarredRedDistRed.String);
            
            obj.modelAnalyzeHandle.ColorValueActive = obj.viewAnalyzeHandle.B_ColorValueActive.Value;
            obj.modelAnalyzeHandle.ColorValue = str2double(obj.viewAnalyzeHandle.B_ColorValue.String);
            
            obj.modelAnalyzeHandle.XScale = str2double(obj.viewAnalyzeHandle.B_XScale.String);
            obj.modelAnalyzeHandle.YScale = str2double(obj.viewAnalyzeHandle.B_YScale.String);
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
            
            set(obj.viewAnalyzeHandle.B_BackEdit,'Callback',@obj.backEditModeEvent);
            set(obj.viewAnalyzeHandle.B_StartResults,'Callback',@obj.startResultsModeEvent);
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Callback',@obj.startAnalyzeEvent);
            
            set(obj.viewAnalyzeHandle.B_AnalyzeMode,'Callback',@obj.analyzeModeEvent)
            
            set(obj.viewAnalyzeHandle.B_AreaActive,'Callback',@obj.activeParaEvent);
            set(obj.viewAnalyzeHandle.B_RoundnessActive,'Callback',@obj.activeParaEvent);
            set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Callback',@obj.activeParaEvent);
            set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Callback',@obj.activeParaEvent);
            set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Callback',@obj.activeParaEvent);
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
            
            addlistener(obj.viewAnalyzeHandle.B_MinAspectRatio,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MaxAspectRatio,'String','PostSet',@obj.valueUpdateEvent);
            
            addlistener(obj.viewAnalyzeHandle.B_ColorValue,'String','PostSet',@obj.valueUpdateEvent);
            
            addlistener(obj.viewAnalyzeHandle.B_BlueRedThresh,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_BlueRedDistRed,'String','PostSet',@obj.valueUpdateEvent);
            
            addlistener(obj.viewAnalyzeHandle.B_FarredRedThresh,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_FarredRedDistRed,'String','PostSet',@obj.valueUpdateEvent);
            
            addlistener(obj.viewAnalyzeHandle.B_XScale,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_XScale,'String','PostSet',@obj.valueUpdateEvent);
            
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
                        % Value is not numerical. Set value to 0
                        set(obj.viewAnalyzeHandle.B_ColorValue,'String','0');
                    end
                    
                case obj.viewAnalyzeHandle.B_BlueRedThresh.Tag
                    % BlueRedThresh value has changed. Can only be between 0
                    % and +Inf
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set BlueRedThresh = 0
                            set(obj.viewAnalyzeHandle.B_BlueRedThresh,'String','0');
                        elseif Value > Inf
                            % If Value > Inf BlueRedThresh = 0
                            set(obj.viewAnalyzeHandle.B_BlueRedThresh,'String','0');
                        else
                            % Set BlueRedThresh to Value
                            set(obj.viewAnalyzeHandle.BlueRedThresh,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 0
                        set(obj.viewAnalyzeHandle.B_BlueRedThresh,'String','0');
                    end
                 
                case obj.viewAnalyzeHandle.B_BlueRedDistBlue.Tag
                    % BlueRedDistBlue value has changed. Can only be between 0
                    % and 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set BlueRedDistBlue = 0
                            set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'String','0');
                        elseif Value > 1
                            % If Value > 1 BlueRedDistBlue = 1
                            set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'String','1');
                        else
                            % Set BlueRedDistBlue to Value
                            set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 0
                        set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'String','0');
                    end  
                    
                case obj.viewAnalyzeHandle.B_BlueRedDistRed.Tag
                    % BlueRedDistRed value has changed. Can only be between 0
                    % and 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set BlueRedDistRed = 0
                            set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'String','0');
                        elseif Value > 1
                            % If Value > 1 BlueRedDistRed = 1
                            set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'String','1');
                        else
                            % Set BlueRedDistRed to Value
                            set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 0
                        set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'String','0');
                    end   
                    
                case obj.viewAnalyzeHandle.B_FarredRedThresh.Tag
                    % BlueRedThresh value has changed. Can only be between 0
                    % and +Inf
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set BlueRedThresh = 0
                            set(obj.viewAnalyzeHandle.B_FarredRedThresh,'String','0');
                        elseif Value > Inf
                            % If Value > 1 BlueRedThresh = 0
                            set(obj.viewAnalyzeHandle.B_FarredRedThresh,'String','0');
                        else
                            % Set BlueRedThresh to Value
                            set(obj.viewAnalyzeHandle.B_FarredRedThresh,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 0
                        set(obj.viewAnalyzeHandle.B_FarredRedThresh,'String','0');
                    end
                 
                case obj.viewAnalyzeHandle.B_FarredRedDistFarred.Tag
                    % FarredRedDistFarred value has changed. Can only be between 0
                    % and 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set B_FarredRedDistFarred = 0
                            set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'String','0');
                        elseif Value > 1
                            % If Value > 1 B_FarredRedDistFarred = 1
                            set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'String','1');
                        else
                            % Set ColorDistance to Value
                            set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 0
                        set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'String','0');
                    end  
                    
                case obj.viewAnalyzeHandle.B_FarredRedDistRed.Tag
                    % FarredRedDistRed value has changed. Can only be between 0
                    % and 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set B_FarredRedDistFarred = 0
                            set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'String','0');
                        elseif Value > 1
                            % If Value > 1 B_FarredRedDistFarred = 1
                            set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'String','1');
                        else
                            % Set B_FarredRedDistFarred to Value
                            set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 0
                        set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'String','0');
                    end
                    
                case obj.viewAnalyzeHandle.B_XScale.Tag
                    %XScale value has changed. Can only be between 0
                    % and +Inf
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set XScale = 1
                            set(obj.viewAnalyzeHandle.B_XScale,'String','1');
                        elseif Value > Inf
                            % If Value > 1 set XScale = 1
                            set(obj.viewAnalyzeHandle.B_XScale,'String','1');
                        else
                            % Set XScale to Value
                            set(obj.viewAnalyzeHandle.B_XScale,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 1
                        set(obj.viewAnalyzeHandle.B_XScale,'String','1');
                    end
                    
                case obj.viewAnalyzeHandle.B_YScale.Tag
                    %YScale value has changed. Can only be between 0
                    % and +Inf
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set YScale = 1
                            set(obj.viewAnalyzeHandle.B_YScale,'String','1');
                        elseif Value > Inf
                            % If Value > 1 set YScale = 1
                            set(obj.viewAnalyzeHandle.B_YScale,'String','1');
                        else
                            % Set YScale to Value
                            set(obj.viewAnalyzeHandle.B_YScale,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set value to 1
                        set(obj.viewAnalyzeHandle.B_YScale,'String','1');
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
            obj.modelAnalyzeHandle.InfoMessage = '-changing analyze mode';
            
            if src.Value == 1
                obj.modelAnalyzeHandle.InfoMessage = '   -Color-Based triple labeling';
                % Color-Based triple labeling classification
                obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBPlanes;
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
                obj.modelAnalyzeHandle.InfoMessage = '   -show image without farred plane';
                
%                 obj.modelAnalyzeHandle.InfoMessage = '   - Parameter:';
%                 obj.modelAnalyzeHandle.InfoMessage = '      - Colordistance-Based classification were selected';
%                 obj.viewAnalyzeHandle.B_ColorDistanceActive.Value = 1;
%                 set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','on')
%                 set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','on')
                
            elseif src.Value == 2
                obj.modelAnalyzeHandle.InfoMessage = '   -Color-Based quad labeling';
                % Color-Based quad labeling classification
                obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBFRPlanes;
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',1)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','on')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','on')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','on')
                obj.modelAnalyzeHandle.InfoMessage = '   -show image with farred plane';
                
%                 obj.modelAnalyzeHandle.InfoMessage = '   - Parameter:';
%                 obj.modelAnalyzeHandle.InfoMessage = '      - Cluster-Based classification were selected';
%                 obj.modelAnalyzeHandle.InfoMessage = '      - searching for 2 Fiber Type cluster';
%                 obj.viewAnalyzeHandle.B_ColorDistanceActive.Value = 0;
%                 set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','off')
%                 set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','off')
%                 obj.modelAnalyzeHandle.InfoMessage = '      - color distance parameter is not necessary';
                
            elseif src.Value == 3
                % Cluster-Based  classification 3 Fiber Type cluster
                
%                 obj.modelAnalyzeHandle.InfoMessage = '   - Parameter:';
%                 obj.modelAnalyzeHandle.InfoMessage = '      - Cluster-Based classification were selected';
%                 obj.modelAnalyzeHandle.InfoMessage = '      - searching for 3 Fiber Type cluster';
%                 obj.viewAnalyzeHandle.B_ColorDistanceActive.Value = 0;
%                 set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','off')
%                 set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','off')
%                 obj.modelAnalyzeHandle.InfoMessage = '      - color distance parameter is not necessary';
                
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
                
                case obj.viewAnalyzeHandle.B_BlueRedThreshActive.Tag
                    % BlueRedThreshActive has changed. If it is zero AspectRatio parameters
                    % won't be used for classification.
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','off')
                        set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','off')
                        set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','on')
                        set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','on')
                        set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','on')
                    end    

                case obj.viewAnalyzeHandle.B_FarredRedThreshActive.Tag
                    % BlueRedThreshActive has changed. If it is zero AspectRatio parameters
                    % won't be used for classification.
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
                        set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
                        set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','on')
                        set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','on')
                        set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','on')
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
        
        function startAnalyzeModeEvent(obj,PicData,InfoText)
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
            %               PicData{1}: name of selected file.
            %               PicData{2}: path of selected file.
            %               PicData{3}: RGB image created from all 4
            %               Planes.
            %               PicData{4}: binary mask image.
            %               PicData{5}: green plane image.
            %               PicData{6}: blue plane image.
            %               PicData{7}: red plane image.
            %               PicData{8}: farred plane image.
            %               PicData{9}: RGB image create from red green and
            %               blue color planeimages.           
            %
            %           InfoText:   Info text log.
            %
            
            
            % Set PicData Properties in the Analyze Model
            obj.modelAnalyzeHandle.FileName = PicData{1};
            obj.modelAnalyzeHandle.PathName = PicData{2};
            obj.modelAnalyzeHandle.PicPRGBFRPlanes = PicData{3};
            obj.modelAnalyzeHandle.PicBW = PicData{4};
            obj.modelAnalyzeHandle.PicPlaneGreen = PicData{5};
            obj.modelAnalyzeHandle.PicPlaneBlue = PicData{6};
            obj.modelAnalyzeHandle.PicPlaneRed = PicData{7};
            obj.modelAnalyzeHandle.PicPlaneFarRed = PicData{8};
            obj.modelAnalyzeHandle.PicPRGBPlanes = PicData{9};
            
            % get axes for PicRGB in Analyze GUI
            axes(obj.viewAnalyzeHandle.hAP);
            
            % show PicRGB in Analyze GUI
            if obj.viewAnalyzeHandle.B_AnalyzeMode.Value == 1
                
                %Show image for triple labeling
                obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{9});
                axis on
                axis image
            elseif obj.viewAnalyzeHandle.B_AnalyzeMode.Value == 2
                
                %Show image for quad labeling
                obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{3});
                axis on
                axis image
            end
            
            % set panel title to filename and path
            Titel = [obj.modelAnalyzeHandle.PathName obj.modelAnalyzeHandle.FileName];
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
            %   startAnalyzeEvent(obj,~,~);
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
                obj.addWindowCallbacks()
            end
            
            % If a Higlight Boundarie Box already exists,
            % delete it
            if ~isempty(OldFig)
                OldBox = findobj('Tag','highlightBox');
                delete(OldBox);
                %refresh WindowButtonMotionFcn. If a Higlight Boundarie Box
                %exist, than the WindowButtonMotionFcn is deleted
                obj.addWindowCallbacks()
            end
            
            obj.busyIndicator(1);
            % Set all Vlaues form the GUI objects in the correspondending
            % model properties.
            obj.modelAnalyzeHandle.AnalyzeMode = obj.viewAnalyzeHandle.B_AnalyzeMode.Value;
            
            obj.modelAnalyzeHandle.AreaActive = obj.viewAnalyzeHandle.B_AreaActive.Value;
            obj.modelAnalyzeHandle.MinArea = str2double(obj.viewAnalyzeHandle.B_MinArea.String);
            obj.modelAnalyzeHandle.MaxArea = str2double(obj.viewAnalyzeHandle.B_MaxArea.String);
            
            obj.modelAnalyzeHandle.RoundnessActive = obj.viewAnalyzeHandle.B_RoundnessActive.Value;
            obj.modelAnalyzeHandle.MinRoundness = str2double(obj.viewAnalyzeHandle.B_MinRoundness.String);
            
            obj.modelAnalyzeHandle.AspectRatioActive = obj.viewAnalyzeHandle.B_AspectRatioActive.Value;
            obj.modelAnalyzeHandle.MinAspectRatio = str2double(obj.viewAnalyzeHandle.B_MinAspectRatio.String);
            obj.modelAnalyzeHandle.MaxAspectRatio = str2double(obj.viewAnalyzeHandle.B_MaxAspectRatio.String);
            
            obj.modelAnalyzeHandle.BlueRedThreshActive = obj.viewAnalyzeHandle.B_BlueRedThreshActive.Value;
            obj.modelAnalyzeHandle.BlueRedThresh = str2double(obj.viewAnalyzeHandle.B_BlueRedThresh.String);
            obj.modelAnalyzeHandle.BlueRedDistBlue = str2double(obj.viewAnalyzeHandle.B_BlueRedDistBlue.String);
            obj.modelAnalyzeHandle.BlueRedDistRed = str2double(obj.viewAnalyzeHandle.B_BlueRedDistRed.String);
            
            obj.modelAnalyzeHandle.FarredRedThreshActive = obj.viewAnalyzeHandle.B_FarredRedThreshActive.Value;
            obj.modelAnalyzeHandle.FarredRedThresh = str2double(obj.viewAnalyzeHandle.B_FarredRedThresh.String);
            obj.modelAnalyzeHandle.FarredRedDistFarred = str2double(obj.viewAnalyzeHandle.B_FarredRedDistFarred.String);
            obj.modelAnalyzeHandle.FarredRedDistRed = str2double(obj.viewAnalyzeHandle.B_FarredRedDistRed.String);
            
            obj.modelAnalyzeHandle.ColorValueActive = obj.viewAnalyzeHandle.B_ColorValueActive.Value;
            obj.modelAnalyzeHandle.ColorValue = str2double(obj.viewAnalyzeHandle.B_ColorValue.String);
            
            obj.modelAnalyzeHandle.XScale = str2double(obj.viewAnalyzeHandle.B_XScale.String);
            obj.modelAnalyzeHandle.YScale = str2double(obj.viewAnalyzeHandle.B_YScale.String);
            
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
            set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','off')
            set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','off')
            set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','off')
            set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','off')
            set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','off')
            set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','off')
            set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','off')
            set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
            set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
            set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
            set(obj.viewAnalyzeHandle.B_XScale,'Enable','off')
            set(obj.viewAnalyzeHandle.B_YScale,'Enable','off')
            
            % start the classification
            obj.modelAnalyzeHandle.startAnalysze();
            
            %Set SavedStatus in results model to false if a new analyze
            %were running and clear old results data.
            obj.controllerResultsHandle.clearData();
            obj.busyIndicator(0);
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
            
            set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','on')
            if obj.viewAnalyzeHandle.B_BlueRedThreshActive.Value == 1
                set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','on')
                set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','on')
            end
            if obj.viewAnalyzeHandle.B_AnalyzeMode.Value == 2
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','on')
                if obj.viewAnalyzeHandle.B_FarredRedThreshActive.Value == 1
                    set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','on')
                    set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','on')
                    set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','on')
                end
            end
            
            set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','on')
            if obj.viewAnalyzeHandle.B_ColorValueActive.Value == 1
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
            end
            
            set(obj.viewAnalyzeHandle.B_XScale,'Enable','on')
            set(obj.viewAnalyzeHandle.B_YScale,'Enable','on')
            
            
        end
        
        function backEditModeEvent(obj,~,~)
            % Callback function of the back edit mode button in the GUI.
            % Clears the data in the analyze model and change the state of
            % the program to the edit mode. Refresh the figure callbacks
            % for the edit mode.
            %
            %   backEditModeEvent(obj,~,~);
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
        
        function startResultsModeEvent(obj,~,~)
            % Callback function of the show rsults button in the GUI.
            % Starts the rusults mode. transfers all data from the analyze
            % model to the results model.
            %
            %   startResultsModeEvent(obj,~,~)
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
                obj.controllerResultsHandle.startResultsModeEvent(Data,InfoText);
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
            set(obj.viewAnalyzeHandle.B_TextBlueRedRatio,'String', Info{5} );
            set(obj.viewAnalyzeHandle.B_TextFarredRedRatio,'String', Info{6} );
            set(obj.viewAnalyzeHandle.B_TextMeanRed,'String', Info{7} );
            set(obj.viewAnalyzeHandle.B_TextMeanGreen,'String', Info{8} );
            set(obj.viewAnalyzeHandle.B_TextMeanBlue,'String', Info{9} );
            set(obj.viewAnalyzeHandle.B_TextMeanFarred,'String', Info{10} );
            set(obj.viewAnalyzeHandle.B_TextColorValue,'String', Info{11} );
             set(obj.viewAnalyzeHandle.B_TextFiberType,'String', Info{12} );
            
            axis(obj.viewAnalyzeHandle.B_AxesInfo,'image');
            obj.modelAnalyzeHandle.handleInfoAxes.CData = Info{13};
            hlines = findobj(obj.viewAnalyzeHandle.B_AxesInfo,'Type','line');
            delete(hlines);
            
            switch Info{12}
                    case 'undefined'
                        % Type 0
                        Color = 'w';
                    case 'Type 1'
                        Color = 'b';
                    case 'Type 2x'
                        Color = 'r';
                    case 'Type 2a'
                        Color = 'y';    
                    case 'Type 2ax'
                        Color = [255/255 165/255 0]; %orange
                    case 'Type 12h'
                        % Type 3
                        Color = 'm';
                otherwise
                        % error
                        Color = 'k';
            end
            
            visboundaries(obj.viewAnalyzeHandle.B_AxesInfo,Info{14},'Color',Color,'LineWidth',1);
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
                    obj.busyIndicator(1);
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
                    rectLine = rectangle('Position',PosBoundingBox,'EdgeColor','g','LineWidth',2);
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
                    obj.busyIndicator(0);
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
            obj.busyIndicator(1);
            obj.modelAnalyzeHandle.manipulateFiberOK(NewFiberType, LabelNumber);
            obj.busyIndicator(0);
            
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
            %           obj:    Handle to controllerAnalyze object
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
            %           obj:    Handle to controllerAnalyze object
            %           src:    source of the callback
            %           evnt:   callback event data
            %
            
            obj.backEditModeEvent();
            obj.controllerEditHandle.newFileEvent();
        end
        
        function busyIndicator(obj,status)
            % See: http://undocumentedmatlab.com/blog/animated-busy-spinning-icon
            
            
            if status
                %create indicator object and disable GUI elements
                
                figHandles = findobj('Type','figure');
                set(figHandles,'pointer','watch');
                %find all objects that are enabled and disable them
                obj.modelAnalyzeHandle.busyObj = findall(figHandles, '-property', 'Enable','-and','Enable','on',...
                    '-and','-not','style','listbox','-and','-not','style','text');
                set( obj.modelAnalyzeHandle.busyObj, 'Enable', 'off')
                
                try
                    % R2010a and newer
                    iconsClassName = 'com.mathworks.widgets.BusyAffordance$AffordanceSize';
                    iconsSizeEnums = javaMethod('values',iconsClassName);
                    SIZE_32x32 = iconsSizeEnums(2);  % (1) = 16x16,  (2) = 32x32
                    obj.modelAnalyzeHandle.busyIndicator = com.mathworks.widgets.BusyAffordance(SIZE_32x32, 'busy...');  % icon, label
                catch
                    % R2009b and earlier
                    redColor   = java.awt.Color(1,0,0);
                    blackColor = java.awt.Color(0,0,0);
                    obj.modelAnalyzeHandle.busyIndicator = com.mathworks.widgets.BusyAffordance(redColor, blackColor);
                end
                
                obj.modelAnalyzeHandle.busyIndicator.setPaintsWhenStopped(false);  % default = false
                obj.modelAnalyzeHandle.busyIndicator.useWhiteDots(false);         % default = false (true is good for dark backgrounds)
                javacomponent(obj.modelAnalyzeHandle.busyIndicator.getComponent, [10,10,80,80], obj.mainFigure);
                obj.modelAnalyzeHandle.busyIndicator.start;

            else
                %delete indicator object and disable GUI elements
                
                if ~isempty(obj.modelAnalyzeHandle.busyIndicator)
                obj.modelAnalyzeHandle.busyIndicator.stop;
                [hjObj, hContainer] = javacomponent(obj.modelAnalyzeHandle.busyIndicator.getComponent, [10,10,80,80], obj.mainFigure);
                delete(hContainer) ;
                end
                
                obj.modelAnalyzeHandle.busyIndicator = [];
                figHandles = findobj('Type','figure');
                set(figHandles,'pointer','arrow');
                
                if ~isempty(obj.modelAnalyzeHandle.busyObj)
                    valid = isvalid(obj.modelAnalyzeHandle.busyObj);
                    obj.modelAnalyzeHandle.busyObj(~valid)=[];
                set( obj.modelAnalyzeHandle.busyObj, 'Enable', 'on')
                end
            end
        end
        
        function closeProgramEvent(obj,~,~)
            % Colose Request function of the main figure.
            %
            %   closeProgramEvent(obj,~,~)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to controllerAnalyze object
            %
            
            choice = questdlg({'Are you sure you want to quit? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            
            switch choice
                case 'Yes'
                    delete(obj.viewAnalyzeHandle);
                    delete(obj.modelAnalyzeHandle);
                    delete(obj.mainCardPanel);
                    
                    %find all objects
                    object_handles = findall(obj.mainFigure);
                    %delete objects
                    delete(object_handles);
                    %find all figures and delete them
                    figHandles = findobj('Type','figure');
                    delete(figHandles);
                case 'No'
                    obj.modelAnalyzeHandle.InfoMessage = '   - closing program canceled';
                otherwise
                    obj.modelAnalyzeHandle.InfoMessage = '   - closing program canceled';
            end
            
        end
        
        function delete(obj)
            %deconstructor
            delete(obj)
        end
        
        
    end
    
    
end

