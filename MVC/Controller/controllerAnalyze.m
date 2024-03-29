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
        panelControl;    %handle to panel with controls.
        panelAxes;   %handle to panel with image.
        panelAnalyze; %handle to panel with editAnalyze components.
        
        viewAnalyzeHandle; %hande to viewAnalyze instance.
        modelAnalyzeHandle; %hande to modelAnalyze instance.
        controllerEditHandle; %handle to controllerEdit instance.
        controllerResultsHandle; %handle to controllerRsults instance.
        
        winState; %Check if window was maximized
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
            
            obj.mainFigure = mainFigure;
            obj.mainCardPanel =mainCardPanel;
            
            obj.viewAnalyzeHandle = viewAnalyzeH;
            obj.modelAnalyzeHandle = modelAnalyzeH;
            
            obj.panelAnalyze = obj.viewAnalyzeHandle.panelAnalyze;
            obj.panelControl = obj.viewAnalyzeHandle.panelControl;
            obj.panelAxes = obj.viewAnalyzeHandle.panelAxes;

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
            set(obj.viewAnalyzeHandle.B_PreResults,'Callback',@obj.showPreResultsEvent);
            
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
            
            set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
            set(obj.mainFigure,'WindowButtonDownFcn',@obj.manipulateFiberShowInfoEvent);
            set(obj.mainFigure,'ButtonDownFcn','');
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);
            set(obj.mainFigure,'ResizeFcn','');
            
            %             set(obj.modelAnalyzeHandle.handlePicRGB,'ButtonDownFcn',@obj.manipulateFiberShowInfoEvent);
            
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
            addlistener(obj.viewAnalyzeHandle.B_YScale,'String','PostSet',@obj.valueUpdateEvent);
            
            % listeners MODEL
            addlistener(obj.modelAnalyzeHandle,'InfoMessage', 'PostSet',@obj.updateInfoLogEvent);
        end
        
        function valueUpdateEvent(obj,~,evnt)
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
            
            % If a window already exists, delete it
            OldFig = findobj('Tag','FigureManipulate');
            if ~isempty(OldFig) && isvalid(OldFig)
                delete(OldFig);
            end
            
            % If a highlight BoundarieBox already exists, delete it
            OldBox = findobj('Tag','highlightBox');
            if ~isempty(OldBox) && isvalid(OldBox)
                delete(OldBox);
            end
            
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
                            set(obj.viewAnalyzeHandle.B_BlueRedThresh,'String',num2str(Value));
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
                    Xvalue = str2double(obj.viewAnalyzeHandle.B_XScale.String);
                    maxPixelX = size(obj.modelAnalyzeHandle.PicPRGBFRPlanes,2);
                    obj.viewAnalyzeHandle.hAP.XTick = 0:100:maxPixelX;
                    obj.viewAnalyzeHandle.hAP.XTickLabel = obj.viewAnalyzeHandle.hAP.XTick*Xvalue;
                    
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
                    maxPixelY = size(obj.modelAnalyzeHandle.PicPRGBFRPlanes,1);
                    Yvalue = str2double(obj.viewAnalyzeHandle.B_YScale.String);
                    obj.viewAnalyzeHandle.hAP.YTick = 0:100:maxPixelY;
                    obj.viewAnalyzeHandle.hAP.YTickLabel = obj.viewAnalyzeHandle.hAP.XTick*Yvalue;
                    %                 Yvalue = str2double(obj.viewAnalyzeHandle.B_YScale.String);
                    %                 maxPixelY = size(obj.modelAnalyzeHandle.PicPRGBFRPlanes,1);
                    %                 NoTicksY = 100*floor(maxPixelY/100)/100;
                    %                 YStep = (NoTicksY*ceil(maxPixelY/NoTicksY)*round(Yvalue))/(NoTicksY*Yvalue);
                    %                 obj.viewAnalyzeHandle.hAP.YTick = [0:YStep:maxPixelY];
                    % %                 obj.viewAnalyzeHandle.hAP.YTick = linspace(0,maxPixelY);
                    %                 obj.viewAnalyzeHandle.hAP.YTickLabel = obj.viewAnalyzeHandle.hAP.YTick*Yvalue;
                    
                    %                 maxUmY = maxPixelY*Yvalue;
                    % %                 set(a,'xlim',[0 xmaxa]);
                    % %                 yticks(obj.viewAnalyzeHandle.hAP,'auto');
                    % %                 obj.viewAnalyzeHandle.hAP.Xlim = [0 maxUmY];
                    %                 obj.viewAnalyzeHandle.hAP.YTick = [0:maxPixelY/10*Yvalue:maxPixelY];
                otherwise
                    % Error Code
                    obj.modelAnalyzeHandle.InfoMessage = '! ERROR in valueUpdateEvent() FUNCTION !';
            end
            
        end
        
        function analyzeModeEvent(obj,src,~)
            % Checks wich analyze mode is selected. Only changes the values
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
                obj.modelAnalyzeHandle.InfoMessage = '      -searching for Type 1 2 12h fibers';
                % Color-Based triple labeling classification
                try
                    obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBPlanes;
                catch
                end
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Value',1)
                set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','on')
                set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','on')
                
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Value',0)
                
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Value',1);
                appDesignElementChanger(obj.panelControl);
                obj.modelAnalyzeHandle.InfoMessage = '   -show image without farred plane';
                
                obj.viewAnalyzeHandle.ParaCard.Selection = 1;
                
            elseif src.Value == 2
                obj.modelAnalyzeHandle.InfoMessage = '   -Color-Based quad labeling';
                obj.modelAnalyzeHandle.InfoMessage = '      -searching for Type 1 12h 2x 2a 2ax fibers';
                % Color-Based quad labeling classification
                try
                    obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBFRPlanes;
                catch
                end
                
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Value',1)
                set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','on')
                set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','on')
                
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',1)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','on')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','on')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','on')
                
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Value',0)
                
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Value',1);
                appDesignElementChanger(obj.panelControl);
                obj.modelAnalyzeHandle.InfoMessage = '   -show image with farred plane';
                
                obj.viewAnalyzeHandle.ParaCard.Selection = 1;
                
            elseif src.Value == 3
                obj.modelAnalyzeHandle.InfoMessage = '   -OPTICS -Cluster-Based triple labeling';
                obj.modelAnalyzeHandle.InfoMessage = '      -searching for Type 1 2 and 12h fibers';
                
                try
                    obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBPlanes;
                catch
                end
                
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Value',1)
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Value',0)
                
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Value',1);
                appDesignElementChanger(obj.panelControl);
                obj.modelAnalyzeHandle.InfoMessage = '   -show image without farred plane';
                
                obj.viewAnalyzeHandle.ParaCard.Selection = 2;
                
            elseif src.Value == 4
                obj.modelAnalyzeHandle.InfoMessage = '   -OPTICS -Cluster-Based quad labeling';
                obj.modelAnalyzeHandle.InfoMessage = '      -searching for Type 1 12h 2x 2a 2ax fibers';
                
                try
                    obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBFRPlanes;
                catch
                end
                
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Value',1)
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Value',1)
                
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Value',1);
                appDesignElementChanger(obj.panelControl);
                obj.modelAnalyzeHandle.InfoMessage = '   -show image with farred plane';
                
                obj.viewAnalyzeHandle.ParaCard.Selection = 2;
                
            elseif src.Value == 5
                obj.modelAnalyzeHandle.InfoMessage = '   -Manual Classification triple labeling';
                
                try
                    obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBPlanes;
                catch
                end
                
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Value',0)
                
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Value',1);
                appDesignElementChanger(obj.panelControl);
                obj.viewAnalyzeHandle.ParaCard.Selection = 1;
                obj.modelAnalyzeHandle.InfoMessage = '   -show image without farred plane';
                
            elseif src.Value == 6
                obj.modelAnalyzeHandle.InfoMessage = '   -Manual Classification quad labeling';
                
                try
                    obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBFRPlanes;
                catch
                end
                
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Value',0)
                
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','on')
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Value',1);
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Value',1);
                appDesignElementChanger(obj.panelControl);
                obj.viewAnalyzeHandle.ParaCard.Selection = 1;
                obj.modelAnalyzeHandle.InfoMessage = '   -show image with farred plane';
                
            elseif src.Value == 7
                obj.modelAnalyzeHandle.InfoMessage = '   - No Classification';
                obj.modelAnalyzeHandle.InfoMessage = '      - only determination of fiber object properties';
                
                try
                    obj.modelAnalyzeHandle.handlePicRGB.CData = obj.modelAnalyzeHandle.PicPRGBFRPlanes;
                catch
                end
                
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_BlueRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistBlue,'Enable','off')
                set(obj.viewAnalyzeHandle.B_BlueRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedThreshActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_FarredRedThresh,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistFarred,'Enable','off')
                set(obj.viewAnalyzeHandle.B_FarredRedDistRed,'Enable','off')
                
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_12HybridFiberActive,'Value',0)
                set(obj.viewAnalyzeHandle.B_2axHybridFiberActive,'Value',0)
                
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_RoundnessActive,'Value',0);
                set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','off')
                set(obj.viewAnalyzeHandle.B_MinAspectRatio,'Enable','off')
                set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'Enable','off')
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Value',0);
                set(obj.viewAnalyzeHandle.B_AspectRatioActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Enable','off')
                set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','off')
                set(obj.viewAnalyzeHandle.B_ColorValueActive,'Value',0);
                appDesignElementChanger(obj.panelControl);
                obj.viewAnalyzeHandle.ParaCard.Selection = 1;
                obj.modelAnalyzeHandle.InfoMessage = '   -show image with farred plane';
            end
            
        end
        
        function activeParaEvent(obj,src,~)
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
            Tag = src.Tag;
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
                    appDesignElementChanger(obj.panelControl);
                    
                case obj.viewAnalyzeHandle.B_RoundnessActive.Tag
                    % RoundActive has changed. If it is zero, Roundness parameter
                    % won't be used for classification.
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                    end
                    appDesignElementChanger(obj.panelControl);
                    
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
                    appDesignElementChanger(obj.panelControl);
                    
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
                    appDesignElementChanger(obj.panelControl);
                    
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
                    appDesignElementChanger(obj.panelControl);
                    
                case obj.viewAnalyzeHandle.B_ColorValueActive.Tag
                    % ColorValueActive has changed. If it is zero ColorValue parameters
                    % won't be used for classification.
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_ColorValue,'Enable','on')
                    end
                     appDesignElementChanger(obj.panelControl);
                     
                otherwise
                    % Error Code
            end
           % If a window already exists, delete it
            OldFig = findobj('Tag','FigureManipulate');
            if ~isempty(OldFig) && isvalid(OldFig)
                delete(OldFig);
            end
            
            % If a highlight BoundarieBox already exists, delete it
            OldBox = findobj('Tag','highlightBox');
            if ~isempty(OldBox) && isvalid(OldBox)
                delete(OldBox);
            end  
        end
        
        function startAnalyzeMode(obj,InfoText)
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
            %               PicData{10 - 18}: All images neede for Check
            %                                 Planes Window in Edit Mode
            %               PicData{18}: MetaData from Bio-Format file
            %
            %           InfoText:   Info text log.
            %
            
            obj.busyIndicator(1);
            
            obj.mainCardPanel.Selection = 2;
            obj.viewAnalyzeHandle.PanelFiberInformation.Title = 'Fiber informations';
            
            %get all pic data from the model
            PicData = obj.controllerEditHandle.modelEditHandle.sendPicsToController();
            
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
            
            switch obj.viewAnalyzeHandle.B_AnalyzeMode.Value
                
                case 1
                    
                    %Show image for triple labeling
                    obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{9},'Parent',obj.viewAnalyzeHandle.hAP);
                    axis(obj.viewAnalyzeHandle.hAP, 'on')
                    axis(obj.viewAnalyzeHandle.hAP, 'image')
                    
                case 2
                    
                    %Show image for quad labeling
                    obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{3},'Parent',obj.viewAnalyzeHandle.hAP);
                    axis(obj.viewAnalyzeHandle.hAP, 'on')
                    axis(obj.viewAnalyzeHandle.hAP, 'image')
                    
                case 3
                    
                    %Show image for triple labeling
                    obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{9},'Parent',obj.viewAnalyzeHandle.hAP);
                    axis(obj.viewAnalyzeHandle.hAP, 'on')
                    axis(obj.viewAnalyzeHandle.hAP, 'image')
                    
                case 4
                    
                    %Show image for quad labeling
                    obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{3},'Parent',obj.viewAnalyzeHandle.hAP);
                    axis(obj.viewAnalyzeHandle.hAP, 'on')
                    axis(obj.viewAnalyzeHandle.hAP, 'image')
                    
                case 5
                    
                    %Show image for triple labeling
                    obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{9},'Parent',obj.viewAnalyzeHandle.hAP);
                    axis(obj.viewAnalyzeHandle.hAP, 'on')
                    axis(obj.viewAnalyzeHandle.hAP, 'image')
                    
                case 6
                    
                    %Show image for quad labeling
                    obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{3},'Parent',obj.viewAnalyzeHandle.hAP);
                    axis(obj.viewAnalyzeHandle.hAP, 'on')
                    axis(obj.viewAnalyzeHandle.hAP, 'image')
                case 7
                    
                    %Show image for quad labeling
                    obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{3},'Parent',obj.viewAnalyzeHandle.hAP);
                    axis(obj.viewAnalyzeHandle.hAP, 'on')
                    axis(obj.viewAnalyzeHandle.hAP, 'image')
            end
            
            lhx=xlabel(obj.viewAnalyzeHandle.hAP, sprintf('x/\x3BCm'),'Fontsize',12);
            ylabel(obj.viewAnalyzeHandle.hAP, sprintf('y/\x3BCm'),'Fontsize',12);
            title(obj.viewAnalyzeHandle.hAP,'Analyzing Fibers')
            axtoolbar(obj.viewAnalyzeHandle.hAP,{'export','datacursor','pan','zoomin','zoomout','restoreview'});
            set(lhx, 'Units', 'Normalized', 'Position', [1.05 0]);
            Xvalue = str2double(obj.viewAnalyzeHandle.B_XScale.String);
            maxPixelX = size(obj.modelAnalyzeHandle.PicPRGBFRPlanes,2);
            obj.viewAnalyzeHandle.hAP.XTick = 0:100:maxPixelX;
            obj.viewAnalyzeHandle.hAP.XTickLabel = obj.viewAnalyzeHandle.hAP.XTick*Xvalue;
            maxPixelY = size(obj.modelAnalyzeHandle.PicPRGBFRPlanes,1);
            Yvalue = str2double(obj.viewAnalyzeHandle.B_YScale.String);
            obj.viewAnalyzeHandle.hAP.YTick = 0:100:maxPixelY;
            obj.viewAnalyzeHandle.hAP.YTickLabel = obj.viewAnalyzeHandle.hAP.XTick*Yvalue;
            
            % set panel title to filename and path
            Titel = [obj.modelAnalyzeHandle.PathName obj.modelAnalyzeHandle.FileName];
            obj.viewAnalyzeHandle.panelAxes.Title = Titel;
            
            % get axes for zoomed Pic in Analyze GUI FIber Information Panel
            obj.modelAnalyzeHandle.handleInfoAxes = imshow([],'Parent',obj.viewAnalyzeHandle.B_AxesInfo);
            axis(obj.viewAnalyzeHandle.B_AxesInfo, 'on');
            axis(obj.viewAnalyzeHandle.B_AxesInfo,'image');
            
            % set InfoText log in View
            set(obj.viewAnalyzeHandle.B_InfoText, 'String', InfoText);
            set(obj.viewAnalyzeHandle.B_InfoText, 'Value' , length(obj.viewAnalyzeHandle.B_InfoText.String));
            
            % If a window for Fibertype manipulation already exists,
            % delete it
            OldFig = findobj('Tag','FigureManipulate');
            if ~isempty(OldFig) && isvalid(OldFig)
                delete(OldFig);
            end
            
            % If a Higlight Boundarie Box already exists,
            % delete it
            OldBox = findobj('Tag','highlightBox');
            if ~isempty(OldBox) && isvalid(OldBox)
                delete(OldBox);
            end
            
            % If a Preview Results figure already exists,
            % delete it
            preFig = findobj('Tag','FigurePreResults');
            if ~isempty(preFig) && isvalid(preFig)
                delete(preFig);
            end
            
            %change the figure callbacks for the analyze mode
            obj.addWindowCallbacks()
            
            appDesignChanger(obj.panelAnalyze,getSettingsValue('Style'));
            %change the card panel to selection 2: analyze mode
            obj.mainCardPanel.Selection = 2;
            
            obj.modelAnalyzeHandle.InfoMessage = '*** Start analyzing mode ***';
            
            oldScaleX = get(obj.viewAnalyzeHandle.B_XScale, 'String');
            oldScaleY = get(obj.viewAnalyzeHandle.B_YScale, 'String');
            
            try
                MetaData = PicData{1,19};
                XScale = str2double(MetaData(2).GlobalScaleFactorforX);
                set(obj.viewAnalyzeHandle.B_XScale, 'String', num2str(XScale) );
                
                MetaData = PicData{1,19};
                YScale = str2double(MetaData(2).GlobalScaleFactorforY);
                set(obj.viewAnalyzeHandle.B_YScale, 'String', num2str(YScale) );
                obj.modelAnalyzeHandle.InfoMessage = '<HTML><FONT color="orange">-INFO: Program has changed Values: </FONT></HTML>';
                obj.modelAnalyzeHandle.InfoMessage = '     -XScale and YScale have been adjusted';
                obj.modelAnalyzeHandle.InfoMessage = '     -Found in image MetaData';
            catch
                set(obj.viewAnalyzeHandle.B_XScale, 'String', oldScaleX );
                set(obj.viewAnalyzeHandle.B_YScale, 'String', oldScaleY );
            end
            
            obj.busyIndicator(0);
            if isempty(obj.modelAnalyzeHandle.Stats)
                set(obj.viewAnalyzeHandle.B_StartResults,'Enable','off');
                set(obj.viewAnalyzeHandle.B_PreResults,'Enable','off');
            else
                set(obj.viewAnalyzeHandle.B_StartResults,'Enable','on');
                set(obj.viewAnalyzeHandle.B_PreResults,'Enable','on');
            end
            appDesignElementChanger(obj.panelControl);
            obj.modelAnalyzeHandle.InfoMessage = '-Set Parameters and press "Start analyzing"';
            obj.modelAnalyzeHandle.InfoMessage = ' ';
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
            
            try
                obj.busyIndicator(1);
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
                
                % If a window for preview results already exists,
                % delete it
                preFig = findobj('Tag','FigurePreResults');
                if ~isempty(preFig) && isvalid(preFig)
                    delete(preFig);
                    obj.addWindowCallbacks()
                end
                
                % Set all Vlaues form the GUI objects in the correspondending
                % model properties.
                obj.modelAnalyzeHandle.AnalyzeMode = obj.viewAnalyzeHandle.B_AnalyzeMode.Value;
                
                obj.modelAnalyzeHandle.AreaActive = obj.viewAnalyzeHandle.B_AreaActive.Value;
                if obj.modelAnalyzeHandle.AreaActive == 1
                    obj.modelAnalyzeHandle.MinArea = str2double(obj.viewAnalyzeHandle.B_MinArea.String);
                    obj.modelAnalyzeHandle.MaxArea = str2double(obj.viewAnalyzeHandle.B_MaxArea.String);
                else
                    obj.modelAnalyzeHandle.MinArea ='-';
                    obj.modelAnalyzeHandle.MaxArea ='-';
                end
                
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
                
                obj.modelAnalyzeHandle.Hybrid12FiberActive = obj.viewAnalyzeHandle.B_12HybridFiberActive.Value;
                obj.modelAnalyzeHandle.Hybrid2axFiberActive = obj.viewAnalyzeHandle.B_2axHybridFiberActive.Value;
                
                obj.modelAnalyzeHandle.minPointsPerCluster = 'not active';
                
                % start the classification
                obj.modelAnalyzeHandle.startAnalysze();
                
                %Set SavedStatus in results model to false if a new analyze
                %were running and clear old results data.
                obj.controllerResultsHandle.clearData();
                obj.busyIndicator(0);
                
                [y,Fs] = audioread('filling-your-inbox.mp3');
                sound(y,Fs);
            catch
                obj.busyIndicator(0);
                obj.errorMessage();
            end
            if isempty(obj.modelAnalyzeHandle.Stats)
                set(obj.viewAnalyzeHandle.B_StartResults,'Enable','off');
                set(obj.viewAnalyzeHandle.B_PreResults,'Enable','off');
            else
                set(obj.viewAnalyzeHandle.B_StartResults,'Enable','on');
                set(obj.viewAnalyzeHandle.B_PreResults,'Enable','on');
            end
            appDesignElementChanger(obj.panelControl);
            
        end
        
        function plotBoundaries(obj)
            % Show boundaries in the RGB image after classification.
            %
            %   plotBoundaries(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelAnalyze object
            %
            
            %Make axes with rgb image the current axes
            axesh = obj.modelAnalyzeHandle.handlePicRGB.Parent;
            %             axes(axesh)
            
            % Find old Boundarie Objects and delete them
            hBounds = findobj(axesh,'Type','hggroup');
            delete(hBounds);
            
            % Find old Line Objects and delete them
            hLines = findobj(axesh,'Type','line');
            delete(hLines);
            
            nObjects = size(obj.modelAnalyzeHandle.Stats,1);
            
            if nObjects > 0
                obj.modelAnalyzeHandle.InfoMessage = '   - plot boundaries...';
            end
            
            hold(axesh, 'on')
            
            B = bwboundaries(obj.modelAnalyzeHandle.PicInvertBW,4,'noholes');
            Bound0={};
            Bound1={};
            Bound2={};
            Bound2x={};
            Bound2a={};
            Bound2ax={};
            Bound12h={};
            BoundE={};
            for i=1:1:nObjects
                %select boundarie color for diffrent fiber types
                switch obj.modelAnalyzeHandle.Stats(i).FiberType
                    case 'undefined'
                        Bound0{end+1,1} =  B{i,1};
                        Bound0{end,2} = ['boundLabel ' num2str(i)];
                    case 'Type 1'
                        Bound1{end+1,1} =  B{i,1};
                        Bound1{end,2} = ['boundLabel ' num2str(i)];
                    case 'Type 2'
                        Bound2{end+1,1} =  B{i,1};
                        Bound2{end,2} = ['boundLabel ' num2str(i)];
                    case 'Type 2x'
                        Bound2x{end+1,1} =  B{i,1};
                        Bound2x{end,2} = ['boundLabel ' num2str(i)];
                    case 'Type 2a'
                        Bound2a{end+1,1} =  B{i,1};
                        Bound2a{end,2} = ['boundLabel ' num2str(i)];
                    case 'Type 2ax'
                        Bound2ax{end+1,1} =  B{i,1};
                        Bound2ax{end,2} = ['boundLabel ' num2str(i)];
                    case 'Type 12h'
                        % Type 3
                        Bound12h{end+1,1} =  B{i,1};
                        Bound12h{end,2} = ['boundLabel ' num2str(i)];
                    otherwise
                        % error
                        BoundE{end+1,1} =  B{i,1};
                        BoundE{end,2} = ['boundLabel ' num2str(i)];
                end
                percent = (i)/nObjects;
                
                workbar(percent,'Please Wait...ploting boundaries','Boundaries',obj.mainFigure);
            end
            
            if ~isempty(Bound0)
                visboundaries(axesh,Bound0(:,1),'Color','w','LineWidth',2);
            end
            if ~isempty(Bound1)
                visboundaries(axesh,Bound1(:,1),'Color','b','LineWidth',2);
            end
            if ~isempty(Bound2)
                visboundaries(axesh,Bound2(:,1),'Color','r','LineWidth',2);
            end
            
            if ~isempty(Bound2x)
                visboundaries(axesh,Bound2x(:,1),'Color','r','LineWidth',2);
            end
            if ~isempty(Bound2a)
                visboundaries(axesh,Bound2a(:,1),'Color','y','LineWidth',2);
            end
            if ~isempty(Bound2ax)
                visboundaries(axesh,Bound2ax(:,1),'Color',[1 100/255 0],'LineWidth',2);
            end
            if ~isempty(Bound12h)
                visboundaries(axesh,Bound12h(:,1),'Color','m','LineWidth',2);
            end
            if ~isempty(BoundE)
                visboundaries(axesh,BoundE(:,1),'Color','k','LineWidth',2);
            end
            hold(axesh, 'off')
            workbar(1,'Please Wait...ploting boundaries','Boundaries',obj.mainFigure);
        end
        
        function clearDataModel(obj)
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
%             obj.busyIndicator(1);
            obj.modelAnalyzeHandle.InfoMessage = ' ';
            
            %clear Data
            obj.modelAnalyzeHandle.Stats = [];
            obj.modelAnalyzeHandle.LabelMat = [];
            obj.modelAnalyzeHandle.BoundarieMat = [];
            % Clear PicRGB and Boundarie Objects
            handleChild = allchild(obj.modelAnalyzeHandle.handlePicRGB.Parent);
            if ~isempty(handleChild)
                delete(handleChild);
            end
            
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
            
            % If a window for preview results already exists,
            % delete it
            preFig = findobj('Tag','FigurePreResults');
            if ~isempty(preFig) && isvalid(preFig)
                delete(preFig);
            end
            
            % set log text from Analyze GUI to Pic GUI
            obj.controllerEditHandle.setInfoTextView(get(obj.viewAnalyzeHandle.B_InfoText, 'String'));
%             obj.busyIndicator(0);
            %change the card panel to selection 1: edit mode
        end
        
        function backEditModeEvent(obj,~,~)
            
            set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','off')
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','off')
            set(obj.viewAnalyzeHandle.B_StartResults,'Enable','off')
            set(obj.viewAnalyzeHandle.B_PreResults,'Enable','off')
            
            obj.mainCardPanel.Selection = 1;
            obj.clearDataModel();
            %change the figure callbacks for the edit mode
            obj.controllerEditHandle.addWindowCallbacks();
            
            set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','on')
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','on')
            set(obj.viewAnalyzeHandle.B_StartResults,'Enable','on')
            set(obj.viewAnalyzeHandle.B_PreResults,'Enable','on')
            
            obj.controllerEditHandle.modelEditHandle.InfoMessage = '*** Back to Edit mode ***';
            
        end
        
        function startResultsModeEvent(obj,~,~)
            set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','off')
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','off')
            set(obj.viewAnalyzeHandle.B_StartResults,'Enable','off')
            set(obj.viewAnalyzeHandle.B_PreResults,'Enable','off')
            drawnow;
            try
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
                
                %                 obj.busyIndicator(1);
                if isempty(obj.modelAnalyzeHandle.Stats)
                    obj.modelAnalyzeHandle.InfoMessage = '   - No data are analyzed';
                    obj.modelAnalyzeHandle.InfoMessage = '   - Press "Start analyzing"';
                else
%                     obj.mainCardPanel.Selection = 3;
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
                    
                    % If a window for preview results already exists,
                    % delete it
                    preFig = findobj('Tag','FigurePreResults');
                    if ~isempty(preFig) && isvalid(preFig)
                        delete(preFig);
                    end
                    
                    obj.modelAnalyzeHandle.InfoMessage = ' ';
                    
                    % get data from the analyze model
                    Data = obj.modelAnalyzeHandle.sendDataToController();
                    
                    % get info text log from analyze GUI
                    InfoText = get(obj.viewAnalyzeHandle.B_InfoText, 'String');
                    
                    % send all data to the result controller and start the
                    % result mode
                    obj.controllerResultsHandle.startResultsMode(Data,InfoText);
                    %                     obj.busyIndicator(0);
                end
            catch
                obj.errorMessage();
            end
            set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','on')
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','on')
            set(obj.viewAnalyzeHandle.B_StartResults,'Enable','on')
            set(obj.viewAnalyzeHandle.B_PreResults,'Enable','on')
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
            %Label Number
            curretnStyleColor = obj.viewAnalyzeHandle.B_TextMeanGreen.ForegroundColor;
            set(obj.viewAnalyzeHandle.B_TextObjNo,'String', Info{1} );
            %Area. Display text in red when out of range
            if obj.modelAnalyzeHandle.AreaActive && ~isempty(str2double(Info{2}))
                if obj.modelAnalyzeHandle.MaxArea < str2double(Info{2})
                    obj.viewAnalyzeHandle.B_TextArea.ForegroundColor=[1 0 0];
                else
                    obj.viewAnalyzeHandle.B_TextArea.ForegroundColor=curretnStyleColor;
                end
            else
                obj.viewAnalyzeHandle.B_TextArea.ForegroundColor=curretnStyleColor;
            end
            set(obj.viewAnalyzeHandle.B_TextArea,'String', Info{2} );
            
            % Aspect Ratio. Display text in red when out of range
            if obj.modelAnalyzeHandle.AspectRatioActive && ~isempty(str2double(Info{3}))
                if obj.modelAnalyzeHandle.MinAspectRatio > str2double(Info{3}) ||...
                        obj.modelAnalyzeHandle.MaxAspectRatio < str2double(Info{3})
                    obj.viewAnalyzeHandle.B_TextAspectRatio.ForegroundColor=[1 0 0];
                else
                    obj.viewAnalyzeHandle.B_TextAspectRatio.ForegroundColor=curretnStyleColor;
                end
            else
                obj.viewAnalyzeHandle.B_TextAspectRatio.ForegroundColor=curretnStyleColor;
            end
            set(obj.viewAnalyzeHandle.B_TextAspectRatio,'String', Info{3} );
            
            % Roundnes. Display text in red when out of range
            if obj.modelAnalyzeHandle.RoundnessActive && isnumeric(str2double(Info{4}))
                if obj.modelAnalyzeHandle.MinRoundness > str2double(Info{4})
                    obj.viewAnalyzeHandle.B_TextRoundness.ForegroundColor=[1 0 0];
                else
                    obj.viewAnalyzeHandle.B_TextRoundness.ForegroundColor=curretnStyleColor;
                end
            else
                obj.viewAnalyzeHandle.B_TextRoundness.ForegroundColor=curretnStyleColor;
            end
            set(obj.viewAnalyzeHandle.B_TextRoundness,'String', Info{4} );
            
            set(obj.viewAnalyzeHandle.B_TextBlueRedRatio,'String', Info{5} );
            set(obj.viewAnalyzeHandle.B_TextFarredRedRatio,'String', Info{6} );
            set(obj.viewAnalyzeHandle.B_TextMeanRed,'String', Info{7} );
            set(obj.viewAnalyzeHandle.B_TextMeanGreen,'String', Info{8} );
            set(obj.viewAnalyzeHandle.B_TextMeanBlue,'String', Info{9} );
            set(obj.viewAnalyzeHandle.B_TextMeanFarred,'String', Info{10} );
            
            % Roundnes. Display text in red when out of range
            if obj.modelAnalyzeHandle.ColorValueActive && isnumeric(str2double(Info{11}))
                if obj.modelAnalyzeHandle.ColorValue > str2double(Info{11})
                    obj.viewAnalyzeHandle.B_TextColorValue.ForegroundColor=[1 0 0];
                else
                    obj.viewAnalyzeHandle.B_TextColorValue.ForegroundColor=curretnStyleColor;
                end
            else
                obj.viewAnalyzeHandle.B_TextColorValue.ForegroundColor=curretnStyleColor;
            end
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
                case 'Type 2'
                    Color = 'r';
                case 'Type 2x'
                    Color = 'r';
                case 'Type 2a'
                    Color = 'y';
                case 'Type 2ax'
                    Color = [255/255 100/255 0]; %orange
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
            if(isempty(OldFig))
                obj.winState=get(obj.mainFigure,'WindowState');
            end
            delete(OldFig);
            
            % If a highlight BoundarieBox already exists, delete it
            OldBox = findobj('Tag','highlightBox');
            delete(OldBox);
            
            % get Position of mouse cursor in the axes
            PosAxes = get(obj.viewAnalyzeHandle.hAP, 'CurrentPoint');
            PosOut = obj.modelAnalyzeHandle.checkPosition(PosAxes);
            
            if isnan(PosOut(1)) || isnan(PosOut(1))
                set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
                if strcmp(obj.winState,'maximized')
                    set(obj.mainFigure,'WindowState','maximized');
                end
            end
            
            if ~isnan(PosOut(1)) && ~isnan(PosOut(2)) && ~isempty(obj.modelAnalyzeHandle.LabelMat)
                
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
                    obj.addWindowCallbacks();
                end
            end
        end
        
        function manipulateFiberOKEvent(obj,~,~)
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
            LabelNumber = str2double( get(obj.viewAnalyzeHandle.B_TextObjNo, 'String') );
            
            %change fiber type
            obj.busyIndicator(1);
            obj.modelAnalyzeHandle.manipulateFiberOK(NewFiberType, LabelNumber);
            obj.busyIndicator(0);
            
            set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
            %refresh main figure callbacks
            obj.addWindowCallbacks();
            
            % If a window for Fibertype manipulation already exists,
            % delete it
            OldFig = findobj('Tag','FigureManipulate');
            delete(OldFig);
            % If a Higlight Boundarie Box already exists,
            % delete it
            OldBox = findobj('Tag','highlightBox');
            delete(OldBox);
            
            if strcmp(obj.winState,'maximized')
                set(obj.mainFigure,'WindowState','maximized');
           end
        end
        
        function manipulateFiberCancelEvent(obj,~,~)
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
            
            if strcmp(obj.winState,'maximized')
                set(obj.mainFigure,'WindowState','maximized');
            end
            
            % refresh Callback function in figure AnalyzeMode
            set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
            %refresh main figure callbacks
            obj.addWindowCallbacks();
        end
        
        function showPreResultsEvent(obj,~,~)
            set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','off')
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','off')
            set(obj.viewAnalyzeHandle.B_StartResults,'Enable','off')
            set(obj.viewAnalyzeHandle.B_PreResults,'Enable','off')
            
            obj.winState=get(obj.mainFigure,'WindowState');
            
            try
                %refresh main figure callbacks
                addWindowCallbacks(obj);
                % If a window already exists, delete it
                OldFig = findobj('Tag','FigureManipulate');
                if ~isempty(OldFig) && isvalid(OldFig)
                    delete(OldFig);
                end
                
                % If a highlight BoundarieBox already exists, delete it
                OldBox = findobj('Tag','highlightBox');
                if ~isempty(OldBox) && isvalid(OldBox)
                    delete(OldBox);
                end
                
                if ~isempty(obj.modelAnalyzeHandle.Stats)
                    
                    %Find Pre Figure for results
                    preFig = findobj('Tag','FigurePreResults');
                    if ~isempty(preFig) && isvalid(preFig)
                        % If figure already exist make it the current figure
                        figure(preFig)
                    else
                        % If figure dont exist create a new figure
                        obj.viewAnalyzeHandle.showFigurePreResults(obj.mainFigure);
                    end
                    preFig = findobj('Tag','FigurePreResults');
                    set(preFig,'CloseRequestFcn', @obj.closePreResultsEvent)
                     
                    %Color Map for FIber Types
                    ColorMap(1,:) = [51 51 255]; % Blue Fiber Type 1
                    ColorMap(2,:) = [255 51 255]; % Magenta Fiber Type 12h
                    ColorMap(3,:) = [255 51 51]; % Red Fiber Type 2x
                    ColorMap(4,:) = [255 255 51]; % Yellow Fiber Type 2a
                    ColorMap(5,:) = [255 153 51]; % orange Fiber Type 2ax
                    ColorMap(6,:) = [224 224 224]; % Grey Fiber Type undifiend
                    ColorMap = ColorMap/255;
                    
                    %find all Type 1 Fibers
                    Index = strcmp({obj.modelAnalyzeHandle.Stats.FiberType}, 'Type 1');
                    T1 = obj.modelAnalyzeHandle.Stats(Index);
                    
                    %find all Type 12h Fibers
                    Index = strcmp({obj.modelAnalyzeHandle.Stats.FiberType}, 'Type 12h');
                    T12h = obj.modelAnalyzeHandle.Stats(Index);
                    
                    %find all Type 2 Fibers
                    Index = strcmp({obj.modelAnalyzeHandle.Stats.FiberType}, 'Type 2');
                    T2 = obj.modelAnalyzeHandle.Stats(Index);
                    
                    %find all Type 2x Fibers
                    Index = strcmp({obj.modelAnalyzeHandle.Stats.FiberType}, 'Type 2x');
                    T2x = obj.modelAnalyzeHandle.Stats(Index);
                    
                    %find all Type 2a Fibers
                    Index = strcmp({obj.modelAnalyzeHandle.Stats.FiberType}, 'Type 2a');
                    T2a = obj.modelAnalyzeHandle.Stats(Index);
                    
                    %find all Type 2ax Fibers
                    Index = strcmp({obj.modelAnalyzeHandle.Stats.FiberType}, 'Type 2ax');
                    T2ax = obj.modelAnalyzeHandle.Stats(Index);
                    
                    %find all Type 0 Fibers
                    Index = strcmp({obj.modelAnalyzeHandle.Stats.FiberType}, 'undefined');
                    T0 = obj.modelAnalyzeHandle.Stats(Index);
                    
                    switch obj.modelAnalyzeHandle.AnalyzeMode
                        
                        case {3,4} %Cluster Based. Need two plots instead of the other ones
                            %Handle to axes Pre-Results Blue over Red
                            ax = obj.viewAnalyzeHandle.hAPRBR;
                            axes(ax);
                            axs1=subplot(2,1,1); %Plot for main Fibers
                            LegendString = {};
                            
                            hold(axs1, 'on')
                            if ~isempty(T1)
                                h=scatter(axs1,[T1.ColorRed],[T1.ColorBlue],20,ColorMap(1,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 1';
                            end
                            hold(axs1, 'on')
                            if ~isempty(T12h)
                                h=scatter(axs1,[T12h.ColorRed],[T12h.ColorBlue],20,ColorMap(2,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 12h';
                            end
                            hold(axs1, 'on')
                            if ~isempty(T2)
                                h=scatter(axs1,[T2.ColorRed],[T2.ColorBlue],20,ColorMap(3,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2';
                            end
                            hold(axs1, 'on')
                            if ~isempty(T2x)
                                h=scatter(axs1,[T2x.ColorRed],[T2x.ColorBlue],20,ColorMap(3,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2x';
                            end
                            hold(axs1, 'on')
                            if ~isempty(T2a)
                                h=scatter(axs1,[T2a.ColorRed],[T2a.ColorBlue],20,ColorMap(4,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2a';
                            end
                            hold(axs1, 'on')
                            if ~isempty(T2ax)
                                h=scatter(axs1,[T2ax.ColorRed],[T2ax.ColorBlue],20,ColorMap(5,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2ax';
                            end
                            hold(axs1, 'on')
                            if ~isempty(T0)
                                h=scatter(axs1,[T0.ColorRed],[T0.ColorBlue],20,ColorMap(6,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type-0 (undefined)';
                            end
                            
                            Rmax = max([obj.modelAnalyzeHandle.Stats.ColorRed]);
                            Bmax = max([obj.modelAnalyzeHandle.Stats.ColorBlue]);
                            grid(axs1, 'on')
                            legend(axs1,LegendString,'Location','best')
                            title(axs1,{'Fiber Type main group classification'; '(Type-1, all Type-2, Type-12h, Type-0)'},'FontSize',14)
                            maxLim = max([Rmax Bmax]);
                            xlabel(axs1,'x: mean Red','FontSize',12);
                            ylabel(axs1,'y: mean Blue','FontSize',12);
                            ylim(axs1,[ 0 maxLim+10 ] );
                            xlim(axs1,[ 0 maxLim+10 ] );
                            
                            axs2=subplot(2,1,2); %Plot Reachability Plot for main Fibers
                            if ~isempty(obj.modelAnalyzeHandle.ClusterData.ReachPlotMain)
                                bar(axs2,obj.modelAnalyzeHandle.ClusterData.ReachPlotMain);
                                set(axs2,'xlim',[0 length(obj.modelAnalyzeHandle.ClusterData.ReachPlotMain)])
                                hold(axs2, 'on')
                                epsilon = obj.modelAnalyzeHandle.ClusterData.EpsilonMain;
                                plot(axs2,get(gca,'xlim'), [epsilon epsilon],'Color','g','LineWidth',2);
                                grid(axs2, 'on')
                            end
                            title(axs2,'OPTICS-Clustering: Reachability Plot for Fiber Type Maingroups','FontSize',14)
                            xlabel(axs2,'x: Order','FontSize',12);
                            ylabel(axs2,'y: Reachability distance R_D','FontSize',12);
                            
                            %%% Plot Farred over Red %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            ax = obj.viewAnalyzeHandle.hAPRFRR;
                            LegendString = {};
                            axes(ax);
                            axs3=subplot(2,1,1); %Plot for Type-2 sub Fibers
                            
                            hold(axs3, 'on')
                            if ~isempty(T2)
                                h=scatter(axs3,[T2.ColorRed],[T2.ColorFarRed],20,ColorMap(3,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2';
                            end
                            if ~isempty(T2x)
                                h=scatter(axs3,[T2x.ColorRed],[T2x.ColorFarRed],20,ColorMap(3,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2x';
                            end
                            hold(axs3, 'on')
                            if ~isempty(T2a)
                                h=scatter(axs3,[T2a.ColorRed],[T2a.ColorFarRed],20,ColorMap(4,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2a';
                            end
                            hold(axs3, 'on')
                            if ~isempty(T2ax)
                                h=scatter(axs3,[T2ax.ColorRed],[T2ax.ColorFarRed],20,ColorMap(5,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2ax';
                            end
                            
                            Rmax = max([obj.modelAnalyzeHandle.Stats.ColorRed]);
                            FRmax = max([obj.modelAnalyzeHandle.Stats.ColorFarRed]);
                            hold(axs3, 'on')
                            legend(axs3,LegendString,'Location','best')
                            if obj.modelAnalyzeHandle.AnalyzeMode == 1 || obj.modelAnalyzeHandle.AnalyzeMode == 3 || ...
                                    obj.modelAnalyzeHandle.AnalyzeMode == 5 || obj.modelAnalyzeHandle.AnalyzeMode == 7
                                title(axs3,{'Trible labeling: Type-2 specification classification' ;'(Type-2)'},'FontSize',14)
                            else
                                title(axs3,{'Quad labeling: Fiber Type-2 specification' ;'(Type-2x, Type-2a, Type-2ax)'},'FontSize',14)
                            end
                            maxLim = max([Rmax FRmax]);
                            xlabel(axs3,'x: mean Red','FontSize',12);
                            ylabel(axs3,'y: mean Farred','FontSize',12);
                            ylim(axs3,[ 0 maxLim+10 ] );
                            xlim(axs3,[ 0 maxLim+10 ] );
                            grid(axs3, 'on')
                            
                            axs4 = subplot(2,1,2); %Plot Reachability Plot for sub Type-2 Fibers
                            if ~isempty(obj.modelAnalyzeHandle.ClusterData.ReachPlotSub)
                                bar(axs4,obj.modelAnalyzeHandle.ClusterData.ReachPlotSub);
                                set(axs4,'xlim',[0 length(obj.modelAnalyzeHandle.ClusterData.ReachPlotSub)])
                                hold(axs4, 'on')
                                epsilon = obj.modelAnalyzeHandle.ClusterData.EpsilonSub;
                                plot(axs4,get(gca,'xlim'), [epsilon epsilon],'Color','g','LineWidth',2);
                                grid(axs4, 'on')
                            end
                            title(axs4,'OPTICS-Clustering: Reachability Plot for Fiber Type-2 Subgroups','FontSize',14)
                            xlabel(axs4,'x: Order','FontSize',12);
                            ylabel(axs4,'y: Reachability distance R_D','FontSize',12);
                            
                        otherwise
                            
                            %Handle to axes Pre-Results Blue over Red
                            ax = obj.viewAnalyzeHandle.hAPRBR;
                            
                            LegendString = {};
                            
                            hold(ax, 'on')
                            if ~isempty(T1)
                                h=scatter(ax,[T1.ColorRed],[T1.ColorBlue],20,ColorMap(1,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 1';
                            end
                            hold(ax, 'on')
                            if ~isempty(T12h)
                                h=scatter(ax,[T12h.ColorRed],[T12h.ColorBlue],20,ColorMap(2,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 12h';
                            end
                            hold(ax, 'on')
                            if ~isempty(T2)
                                h=scatter(ax,[T2.ColorRed],[T2.ColorBlue],20,ColorMap(3,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2';
                            end
                            hold(ax, 'on')
                            if ~isempty(T2x)
                                h=scatter(ax,[T2x.ColorRed],[T2x.ColorBlue],20,ColorMap(3,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2x';
                            end
                            hold(ax, 'on')
                            if ~isempty(T2a)
                                h=scatter(ax,[T2a.ColorRed],[T2a.ColorBlue],20,ColorMap(4,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2a';
                            end
                            hold(ax, 'on')
                            if ~isempty(T2ax)
                                h=scatter(ax,[T2ax.ColorRed],[T2ax.ColorBlue],20,ColorMap(5,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2ax';
                            end
                            if ~isempty(T0)
                                h=scatter(ax,[T0.ColorRed],[T0.ColorBlue],20,ColorMap(6,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type-0 (undefined)';
                            end
                            
                            Rmax = max([obj.modelAnalyzeHandle.Stats.ColorRed]);
                            Bmax = max([obj.modelAnalyzeHandle.Stats.ColorBlue]);
                            R = [0 10*Rmax]; %Red value vector
                            
                            if obj.modelAnalyzeHandle.BlueRedThreshActive
                                % BlueRedThreshActive Parameter is active, plot
                                % classification functions
                                
                                BlueRedTh = obj.modelAnalyzeHandle.BlueRedThresh;
                                BlueRedDistB = obj.modelAnalyzeHandle.BlueRedDistBlue;
                                BlueRedDistR = obj.modelAnalyzeHandle.BlueRedDistRed;
                                
                                if BlueRedDistB == 1
                                    BlueRedDistB = 0.999999999;
                                end
                                
                                % creat classification function line obj
                                f_BRthresh =  BlueRedTh * R; %Blue/Red thresh fcn
                                f_Bdist = BlueRedTh * R / (1-BlueRedDistB); %blue dist fcn
                                f_Rdist = BlueRedTh * R * (1-BlueRedDistR); %red dist fcn
                                hold(ax, 'on')
                                plot(ax,R,f_Bdist,'b','LineWidth',1.5);
                                LegendString{end+1} = ['f_{Bdist}(R) = ' num2str(BlueRedTh) ' * R / (1-' num2str(BlueRedDistB) ')'];
                                hold(ax, 'on')
                                plot(ax,R,f_Rdist,'r','LineWidth',1.5);
                                LegendString{end+1}= ['f_{Rdist}(R) = ' num2str(BlueRedTh) ' * R * (1-' num2str(BlueRedDistR) ')'];
                                hold(ax, 'on')
                                plot(ax,R,f_BRthresh,'k','LineWidth',1.5);
                                LegendString{end+1}= ['f_{BRthresh}(R) = ' num2str(BlueRedTh) ' * R'];
                            elseif obj.modelAnalyzeHandle.AnalyzeMode == 1 || obj.modelAnalyzeHandle.AnalyzeMode == 2
                                BlueRedTh = 1;
                                f_BRthresh =  BlueRedTh * R; %Blue/Red thresh fcn
                                LegendString{end+1}= 'f_{BRthresh}(R) = R (not active)';
                                hold(ax, 'on')
                                plot(ax,R,f_BRthresh,'k');
                                
                            end
                            
                            maxLim =  max([Rmax Bmax]);
                            ylabel(ax,'y: mean Blue (B)','FontSize',12);
                            xlabel(ax,'x: mean Red (R)','FontSize',12);
                            ylim(ax,[ 0 maxLim+10 ] );
                            xlim(ax,[ 0 maxLim+10 ] );
                            grid(ax, 'on')
                            title(ax,{'Fiber Type main group classification'; '(Type-1, all Type-2, Type-12h, Type-0)'},'FontSize',14)
                            legend(ax,LegendString,'Location','best')
                            
                            %%% Plot Farred over Red %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                            ax = obj.viewAnalyzeHandle.hAPRFRR;
                            %                             axes(ax)
                            LegendString = {};
                            
                            hold(ax, 'on')
                            if ~isempty(T2)
                                h=scatter(ax,[T2.ColorRed],[T2.ColorBlue],20,ColorMap(3,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2';
                            end
                            if ~isempty(T2x)
                                h=scatter(ax,[T2x.ColorRed],[T2x.ColorFarRed],20,ColorMap(3,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2x';
                            end
                            hold(ax, 'on')
                            if ~isempty(T2a)
                                h=scatter(ax,[T2a.ColorRed],[T2a.ColorFarRed],20,ColorMap(4,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2a';
                            end
                            hold(ax, 'on')
                            if ~isempty(T2ax)
                                h=scatter(ax,[T2ax.ColorRed],[T2ax.ColorFarRed],20,ColorMap(5,:),'filled');
                                set(h,'MarkerEdgeColor','k');
                                LegendString{end+1} = 'Type 2ax';
                            end
                            
                            Rmax = max([obj.modelAnalyzeHandle.Stats.ColorRed]);
                            FRmax = max([obj.modelAnalyzeHandle.Stats.ColorFarRed]);
                            R = [0 10*Rmax]; %Red value vector
                            
                            if obj.modelAnalyzeHandle.FarredRedThreshActive
                                % Color-Based Classification
                                % FarredRedThreshActive Parameter is active, plot
                                % classification functions
                                FarredRedTh = obj.modelAnalyzeHandle.FarredRedThresh;
                                FarredRedDistFR = obj.modelAnalyzeHandle.FarredRedDistFarred;
                                FarredRedDistR = obj.modelAnalyzeHandle.FarredRedDistRed;
                                
                                if FarredRedDistFR == 1
                                    FarredRedDistFR = 0.999999999;
                                end
                                
                                % creat classification function line obj
                                f_FRRthresh =  FarredRedTh * R; %Blue/Red thresh fcn
                                f_FRdist = FarredRedTh * R / (1-FarredRedDistFR); %farred dist fcn
                                f_Rdist = FarredRedTh * R * (1-FarredRedDistR); %red dist fcn
                                
                                plot(ax,R,f_FRdist,'y','LineWidth',1.5);
                                LegendString{end+1} = ['f_{FRdist}(R) = ' num2str(FarredRedTh) ' * R / (1-' num2str(FarredRedDistFR) ')'];
                                
                                plot(ax,R,f_Rdist,'r','LineWidth',1.5);
                                LegendString{end+1} = ['f_{Rdist}(R) = ' num2str(FarredRedTh) ' * R * (1-' num2str(FarredRedDistR) ')'];
                                
                                plot(ax,R,f_FRRthresh,'k','LineWidth',1.5);
                                LegendString{end+1} = ['f_{FRthresh}(R) = ' num2str(FarredRedTh) ' * R'];
                            elseif obj.modelAnalyzeHandle.AnalyzeMode == 2
                                FarredRedTh = 1;
                                f_BRthresh =  FarredRedTh * R; %Blue/Red thresh fcn
                                LegendString{end+1} = 'f_{FRthresh}(R) = R (not active)';
                                hold(ax, 'on')
                                plot(ax,R,f_BRthresh,'k');
                            end
                            
                            maxLim =  max([Rmax FRmax]);
                            ylabel(ax,'y: mean Farred (FR)','FontSize',12);
                            xlabel(ax,'x: mean Red (R)','FontSize',12);
                            ylim(ax,[ 0 maxLim+10 ] );
                            xlim(ax,[ 0 maxLim+10 ] );
                            grid(ax, 'on')
                            if obj.modelAnalyzeHandle.AnalyzeMode == 1 || obj.modelAnalyzeHandle.AnalyzeMode == 3 || ...
                                    obj.modelAnalyzeHandle.AnalyzeMode == 5 || obj.modelAnalyzeHandle.AnalyzeMode == 7
                                title(ax,{'Trible labeling: Type-2 specification classification' ;'(Type-2)'},'FontSize',14)
                            else
                                title(ax,{'Quad labeling: Fiber Type-2 specification' ;'(Type-2x, Type-2a, Type-2ax)'},'FontSize',14)
                            end
                            legend(ax,LegendString,'Location','Best')
                    end
                    appDesignChanger(preFig,getSettingsValue('Style'));
                else % if ~isempty(obj.modelAnalyzeHandle.Stats)
                    obj.modelAnalyzeHandle.InfoMessage = '   - No data are analyzed';
                    obj.modelAnalyzeHandle.InfoMessage = '   - Press "Start analyzing"';
                end
            catch
                obj.errorMessage();
            end
            set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','on')
            set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','on')
            set(obj.viewAnalyzeHandle.B_StartResults,'Enable','on')
            set(obj.viewAnalyzeHandle.B_PreResults,'Enable','on')
        end
        
        function closePreResultsEvent(obj,src,~)
            delete(src);
            if strcmp(obj.winState,'maximized')
                set(obj.mainFigure,'WindowState','maximized');
            end
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
        
        function updateInfoLogEvent(obj,~,~)
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
%                 figHandles = findobj('Type','figure');
                set(obj.mainFigure,'pointer','watch');
                %create indicator object and disable GUI elements
                
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
                
                
                %find all objects that are enabled and disable them
                obj.modelAnalyzeHandle.busyObj = getUIControlEnabledHandles(obj.viewAnalyzeHandle);
%                 findall(obj.panelAnalyze, '-property', 'Enable','-and','Enable','on',...
%                     '-and','-not','style','listbox','-and','-not','style','text','-and','-not','Type','uitable');
                set( obj.modelAnalyzeHandle.busyObj, 'Enable', 'off')
                appDesignElementChanger(obj.panelControl);
                
            else
                %delete indicator object and disable GUI elements
                
%                 figHandles = findobj('Type','figure');
                
                
                if ~isempty(obj.modelAnalyzeHandle.busyObj)
                    valid = isvalid(obj.modelAnalyzeHandle.busyObj);
                    obj.modelAnalyzeHandle.busyObj(~valid)=[];
                    set( obj.modelAnalyzeHandle.busyObj, 'Enable', 'on')
                    appDesignElementChanger(obj.panelControl);
                end
                
                if ~isempty(obj.modelAnalyzeHandle.busyIndicator)
                    obj.modelAnalyzeHandle.busyIndicator.stop;
                    [~, hContainer] = javacomponent(obj.modelAnalyzeHandle.busyIndicator.getComponent, [10,10,80,80], obj.mainFigure);
                    obj.modelAnalyzeHandle.busyIndicator = [];
                    delete(hContainer) ;
                end
                workbar(1.5,'delete workbar','delete workbar',obj.mainFigure);
                
                set(obj.mainFigure,'pointer','arrow');
            end
            
        end
        
        function errorMessage(obj)
            ErrorInfo=lasterror;
            Text = cell(5*size(ErrorInfo.stack,1)+2,1);
            Text{1,1} = ErrorInfo.message;
            Text{2,1} = '';
            
            if any(strcmp('stack',fieldnames(ErrorInfo)))
                for i=1:size(ErrorInfo.stack,1)
                    idx = (i - 1) * 5 + 2;
                    Text{idx+1,1} = [ErrorInfo.stack(i).file];
                    Text{idx+2,1} = [ErrorInfo.stack(i).name];
                    Text{idx+3,1} = ['Line: ' num2str(ErrorInfo.stack(i).line)];
                    Text{idx+4,1} = '------------------------------------------';
                end
            end
            
            mode = struct('WindowStyle','modal','Interpreter','tex');
            beep
            uiwait(errordlg(Text,'ERROR: Analyze-Mode',mode));
            workbar(1.5,'delete workbar','delete workbar',obj.mainFigure);
            obj.busyIndicator(0);
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
            winState=get(obj.mainFigure,'WindowState');
            choice = questdlg({'Are you sure you want to quit? ','All unsaved data will be lost.'},...
                'Close Program', ...
                'Yes','No','No');
            if strcmp(winState,'maximized')
                set(obj.mainFigure,'WindowState','maximized');
            end
            
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

