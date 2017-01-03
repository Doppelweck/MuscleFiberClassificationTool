classdef controllerAnalyze < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mainFigure;
        mainCardPanel;
        viewAnalyzeHandle;
        modelAnalyzeHandle;
        controllerEditHandle;
        controllerResultsHandle;
    end
    
    
    methods
        
        function obj = controllerAnalyze(mainFigure,mainCardPanel,viewAnalyzH,modelAnalyzeH)
            obj.mainFigure =mainFigure;
            obj.mainCardPanel =mainCardPanel;
            
            obj.viewAnalyzeHandle = viewAnalyzH;
            obj.modelAnalyzeHandle =modelAnalyzeH;
            
            obj.setInitValueInModel();
            
            obj.addMyListener();
            
            obj.addMyCallbacks();
        end
        
        function setInitValueInModel(obj)
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
%             set(obj.viewAnalyzeHandle.hFP,'WindowButtonMotionFcn',@obj.showFiberInfo);
%             set(obj.modelAnalyzeHandle.handlePicRGB,'ButtonDownFcn',@obj.manipulateFiberShowInfoEvent);
%             set(obj.viewAnalyzeHandle.hFP,'CloseRequestFcn',@obj.closeProgramEvent);
            
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
            set(obj.mainFigure,'ButtonDownFcn','');
            set(obj.mainFigure,'WindowButtonMotionFcn',@obj.showFiberInfo);
            set(obj.modelAnalyzeHandle.handlePicRGB,'ButtonDownFcn',@obj.manipulateFiberShowInfoEvent);
            set(obj.mainFigure,'CloseRequestFcn',@obj.closeProgramEvent);

        end
        
        function addMyListener(obj)
            addlistener(obj.viewAnalyzeHandle.B_MinArea,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MaxArea,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MinRoundness,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_ColorDistance,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MinAspectRatio,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_MaxAspectRatio,'String','PostSet',@obj.valueUpdateEvent);
            addlistener(obj.viewAnalyzeHandle.B_ColorValue,'String','PostSet',@obj.valueUpdateEvent);
            
%             addlistener(obj.modelAnalyzeHandle,'CalculationRunning', 'PostSet',@obj.calculationEvent);
            addlistener(obj.modelAnalyzeHandle,'InfoMessage', 'PostSet',@obj.updateInfoLogEvent);
        end
        
        function valueUpdateEvent(obj,src,evnt)
            % Which element has triggered the callback
            Tag = evnt.AffectedObject.Tag;
            % Value that has changed
            Value = str2num(evnt.AffectedObject.String);
            
            switch Tag
                case obj.viewAnalyzeHandle.B_MinArea.Tag
                    
                    % MinArea has changed. Can only be positiv integer
                    % must be smaller than MaxArea
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If MinArea < 0 set MinArea to 0
                            
                            set(obj.viewAnalyzeHandle.B_MinArea,'String','0');
                        elseif Value > obj.modelAnalyzeHandle.MaxAreaPixel
                            %if MinArea > MaxArea set MinArea to MaxArea
                            %                             obj.modelAnalyzeHandle.MinAreaPixel = round(obj.modelAnalyzeHandle.MaxAreaPixel);
                            set(obj.viewAnalyzeHandle.B_MinArea,'String',obj.viewAnalyzeHandle.B_MaxArea.String);
                        else
                            % Set MinArea to Value
                            %                             obj.modelAnalyzeHandle.MinAreaPixel = round(Value);
                            %                             set(obj.viewAnalyzeHandle.B_MinArea,'String',num2str(round(Value)));
                        end
                    else
                        % Value is not numerical. Set Value to 0.
                        %                         obj.modelAnalyzeHandle.MinAreaPixel = 0;
                        set(obj.viewAnalyzeHandle.B_MinArea,'String','0');
                    end
                    
                case obj.viewAnalyzeHandle.B_MaxArea.Tag
                    
                    % MaxArea has changed. Can only be positiv
                    % integer. Must be greater than MinArea
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < obj.modelAnalyzeHandle.MinAreaPixel
                            % If MaxArea < MinArea set MaxArea to MinArea
                            %                             obj.modelAnalyzeHandle.MaxAreaPixel = obj.modelAnalyzeHandle.MinAreaPixel;
                            set(obj.viewAnalyzeHandle.B_MaxArea,'String',obj.viewAnalyzeHandle.B_MinArea.String);
                        else
                            % Set MaxArea to Value
                            %                             obj.modelAnalyzeHandle.MaxAreaPixel = round(Value);
                            %                             set(obj.viewAnalyzeHandle.B_MinArea,'String',num2str(round(Value)));
                        end
                    else
                        % Value is not numerical. Set Value to MinAreaValue.
                        %                         obj.modelAnalyzeHandle.MaxAreaPixel = obj.modelAnalyzeHandle.MinAreaPixel;
                        set(obj.viewAnalyzeHandle.B_MaxArea,'String',obj.viewAnalyzeHandle.B_MinArea.String);
                    end
                    
                case obj.viewAnalyzeHandle.B_MinRoundness.Tag
                    
                    % MinRoundness has changed. Can only be between 0 and
                    % 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set MinRoundness = 0
                            %                             obj.modelAnalyzeHandle.MinRoundness = 0;
                            set(obj.viewAnalyzeHandle.B_MinRoundness,'String','0');
                        elseif Value > 1
                            % If Value > 1 set MinRoundness = 1
                            %                             obj.modelAnalyzeHandle.MinRoundness = 1;
                            set(obj.viewAnalyzeHandle.B_MinRoundness,'String','1');
                        else
                            % Set MinRound to Value
                            %                             obj.modelAnalyzeHandle.MinRoundness = Value;
                            %                             set(obj.viewAnalyzeHandle.B_MinRoundness,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set Value to 0.
                        %                         obj.modelAnalyzeHandle.MinRoundness = 0;
                        set(obj.viewAnalyzeHandle.B_MinRoundness,'String','0');
                    end
                    
                case obj.viewAnalyzeHandle.B_ColorDistance.Tag
                    
                    % ColorDistance has changed. Can only be between 0
                    % and 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set ColorDistance = 0
                            %                             obj.modelAnalyzeHandle.MinColorDistance = 0;
                            set(obj.viewAnalyzeHandle.B_ColorDistance,'String','0');
                        elseif Value > 1
                            % If Value > 1 setColorDistance = 1
                            %                             obj.modelAnalyzeHandle.MinColorDistance = 1;
                            set(obj.viewAnalyzeHandle.B_ColorDistance,'String','1');
                        else
                            % Set ColorDistance to Value
                            %                             obj.modelAnalyzeHandle.MinColorDistance = Value;
                            %                             set(obj.viewAnalyzeHandle.B_ColorDistance,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set Value to 0.
                        %                         obj.modelAnalyzeHandle.MinColorDistance = 0;
                        set(obj.viewAnalyzeHandle.B_ColorDistance,'String','0');
                    end
                    
                case obj.viewAnalyzeHandle.B_MinAspectRatio.Tag
                    
                    % MinAspectRatio has changed. Can only be positiv
                    % Integer >= 1. Must be smaller than MaxAspectRatio
                    
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 1
                            % If Value < 1 set MinAspectRatio = 1
                            %                             obj.modelAnalyzeHandle.MinAspectRatio = 1;
                            set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String','1');
                        elseif Value > obj.modelAnalyzeHandle.MaxAspectRatio
                            % If MinAspectRatio > MaxAspectRatio set MinAspectRatio to MaxAspectRatio
                            %                             obj.modelAnalyzeHandle.MinAspectRatio = obj.modelAnalyzeHandle.MaxAspectRatio;
                            set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String',obj.viewAnalyzeHandle.B_MaxAspectRatio.String);
                        else
                            % Set MinAspectRatio to Value
                            %                             obj.modelAnalyzeHandle.MinAspectRatio = Value;
                            %                             set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String',num2str(round(Value)));
                        end
                    else
                        % Value is not numerical. Set Value to 1.
                        %                         obj.modelAnalyzeHandle.MinAspectRatio = 1;
                        set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String','1');
                    end
                    
                case obj.viewAnalyzeHandle.B_MaxAspectRatio.Tag
                    
                    % MaxAspectRatio has changed. Can only be positiv
                    % Integer >= 1. Must be greater or equal than MaxAspectRatio
                    
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        
                        if Value < obj.modelAnalyzeHandle.MinAspectRatio
                            % If MaxAspectRatio < MinAspectRatio set MaxAspectRatio to MinAspectRatio
                            %                             obj.modelAnalyzeHandle.MaxAspectRatio = obj.modelAnalyzeHandle.MinAspectRatio;
                            set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'String',obj.viewAnalyzeHandle.B_MinAspectRatio.String);
                        else
                            % Set MaxAspectRatio to Value
                            %                             obj.modelAnalyzeHandle.MaxAspectRatio = Value;
                            %                             set(obj.viewAnalyzeHandle.B_MinAspectRatio,'String',num2str(round(Value)));
                        end
                    else
                        % Value is not numerical. Set Value to MinAspectRatio.
                        %                         obj.modelAnalyzeHandle.MaxAspectRatio = obj.modelAnalyzeHandle.MinAspectRatio;
                        set(obj.viewAnalyzeHandle.B_MaxAspectRatio,'String',obj.viewAnalyzeHandle.B_MinAspectRatio.String);
                    end
                    
                case obj.viewAnalyzeHandle.B_ColorValue.Tag
                    
                    % ColorValue has changed. Can only be between 0
                    % and 1
                    if isscalar(Value) && isreal(Value) && ~isnan(Value)
                        % Value is numerical
                        if Value < 0
                            % If Value < 0 set ColorDistance = 0
                            %                             obj.modelAnalyzeHandle.ColorValue = 0;
                            set(obj.viewAnalyzeHandle.B_ColorValue,'String','0');
                        elseif Value > 1
                            % If Value > 1 setColorDistance = 1
                            %                             obj.modelAnalyzeHandle.ColorValue = 1;
                            set(obj.viewAnalyzeHandle.B_ColorValue,'String','1');
                        else
                            % Set ColorDistance to Value
                            obj.modelAnalyzeHandle.ColorValue = Value;
                            %                             set(obj.viewAnalyzeHandle.B_ColorDistance,'String',num2str(Value));
                        end
                    else
                        % Value is not numerical. Set Value to 0.
                        %                         obj.modelAnalyzeHandle.ColorValue = 0;
                        set(obj.viewAnalyzeHandle.B_ColorValue,'String','0');
                    end
                    
                otherwise
                    % Error Code
            end
            
        end
        
        function analyzeModeEvent(obj,src,evnt)
            
            %                     obj.modelAnalyzeHandle.AnalyzeMode = src.Value;
            
            if src.Value == 1
                obj.modelAnalyzeHandle.InfoMessage = '   - Parameter:';
                obj.modelAnalyzeHandle.InfoMessage = '      - Colordistance-Based classification were selected';
                obj.viewAnalyzeHandle.B_ColorDistanceActive.Value = 1;
                set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','on')
                set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','on')
                
            elseif src.Value == 2
                obj.modelAnalyzeHandle.InfoMessage = '   - Parameter:';
                obj.modelAnalyzeHandle.InfoMessage = '      - Cluster-Based classification were selected';
                obj.modelAnalyzeHandle.InfoMessage = '      - searching for 2 Fiber Type cluster';
                obj.viewAnalyzeHandle.B_ColorDistanceActive.Value = 0;
                set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','off')
                set(obj.viewAnalyzeHandle.B_ColorDistanceActive,'Enable','off')
                obj.modelAnalyzeHandle.InfoMessage = '      - color distance parameter is not necessary';
                
            elseif src.Value == 3
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
            % Which element has triggered the callback
            Tag = evnt.Source.Tag;
            % Value that has changed. Can only be 1 or 0 (true or false)
            Value = src.Value;
            
            switch Tag
                
                case obj.viewAnalyzeHandle.B_AreaActive.Tag
                    % AreaActive has changed. If it is zero, Area parameters
                    % won't be used for classification.
                    
                    %                     obj.modelAnalyzeHandle.AreaActive = Value;
                    
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
                    
                    %                     obj.modelAnalyzeHandle.RoundnessActive = Value;
                    
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_MinRoundness,'Enable','on')
                    end
                    
                case obj.viewAnalyzeHandle.B_AspectRatioActive.Tag
                    % AspectRatioActive has changed. If it is zero AspectRatio parameters
                    % won't be used for classification.
                    
                    %                     obj.modelAnalyzeHandle.AspectRatioActive = Value;
                    
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
                    
                    %                     obj.modelAnalyzeHandle.ColorDistanceActive = Value;
                    
                    if Value == 0
                        set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','off')
                    elseif Value == 1
                        set(obj.viewAnalyzeHandle.B_ColorDistance,'Enable','on')
                    end
                    
                case obj.viewAnalyzeHandle.B_ColorValueActive.Tag
                    % ColorValueActive has changed. If it is zero ColorValue parameters
                    % won't be used for classification.
                    
                    %                     obj.modelAnalyzeHandle.ColorValueActive = Value;
                    
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
           
%             set(obj.controllerEditHandle.viewEditHandle.hFP,'Visible','off'); 
            
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
            
            obj.modelAnalyzeHandle.handlePicRGB = imshow(PicData{3});
            axis on
            axis image
            
            Titel = [obj.modelAnalyzeHandle.PathNames obj.modelAnalyzeHandle.FileNamesRGB];
            obj.viewAnalyzeHandle.panelPicture.Title = Titel;
            %             set(obj.viewAnalyzeHandle.hAP,'Units','normalized','Position',[0 0 1 1]);
            
            % get axes for zoomed Pic in Analyze GUI Control Panel
            axes(obj.viewAnalyzeHandle.B_AxesInfo);
            axis(obj.viewAnalyzeHandle.B_AxesInfo,'image');
            obj.modelAnalyzeHandle.handleInfoAxes = imshow([]);
            axis on
            % set InfoText in View
            set(obj.viewAnalyzeHandle.B_InfoText, 'String', InfoText);
            set(obj.viewAnalyzeHandle.B_InfoText, 'Value' , length(obj.viewAnalyzeHandle.B_InfoText.String));
            
            %             set(obj.viewAnalyzeHandle.B_AxesInfo,'OuterPosition',[0 0 1 1]);
            % Show Analyze GUI
            %             set(obj.viewAnalyzeHandle.hFC,'Visible','on');
            
            
%             pause(0.05);
            
            
            % If a window for Fibertype manipulation already exists,
            % delete it
            OldFig = findobj('Tag','FigureManipulate');
            delete(OldFig);
            % If a Higlight Boundarie Box already exists,
            % delete it
            OldBox = findobj('Tag','highlightBox');
            delete(OldBox);
            
            % refresh Callbacks
%             obj.addMyCallbacks();
            obj.mainCardPanel.Selection = 2;
            obj.addWindowCallbacks()
%             set(obj.viewAnalyzeHandle.hFP,'Visible','on');
%             figure(obj.viewAnalyzeHandle.hFP);
            
            obj.modelAnalyzeHandle.InfoMessage = '*** Start analyzing mode ***';
            obj.modelAnalyzeHandle.InfoMessage = '   -Set Parameters and press "Start analyzimg"';
            
        end
        
        function startAnalyzeEvent(obj,~,~)
            
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
            
            obj.modelAnalyzeHandle.AnalyzeMode = obj.viewAnalyzeHandle.B_AnalyzeMode.Value;
            
            obj.modelAnalyzeHandle.AreaActive = obj.viewAnalyzeHandle.B_AreaActive.Value;
            obj.modelAnalyzeHandle.MinAreaPixel = str2num(obj.viewAnalyzeHandle.B_MinArea.String);
            obj.modelAnalyzeHandle.MaxAreaPixel = str2num(obj.viewAnalyzeHandle.B_MaxArea.String);
            
            obj.modelAnalyzeHandle.AspectRatioActive = obj.viewAnalyzeHandle.B_AspectRatioActive.Value;
            obj.modelAnalyzeHandle.MinAspectRatio = str2num(obj.viewAnalyzeHandle.B_MinAspectRatio.String);
            obj.modelAnalyzeHandle.MaxAspectRatio = str2num(obj.viewAnalyzeHandle.B_MaxAspectRatio.String);
            
            obj.modelAnalyzeHandle.RoundnessActive = obj.viewAnalyzeHandle.B_RoundnessActive.Value;
            obj.modelAnalyzeHandle.MinRoundness = str2num(obj.viewAnalyzeHandle.B_MinRoundness.String);
            
            obj.modelAnalyzeHandle.ColorDistanceActive = obj.viewAnalyzeHandle.B_ColorDistanceActive.Value;
            obj.modelAnalyzeHandle.MinColorDistance = str2num(obj.viewAnalyzeHandle.B_ColorDistance.String);
            
            obj.modelAnalyzeHandle.ColorValueActive = obj.viewAnalyzeHandle.B_ColorValueActive.Value;
            obj.modelAnalyzeHandle.ColorValue = str2num(obj.viewAnalyzeHandle.B_ColorValue.String);
            
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
            
            obj.modelAnalyzeHandle.startAnalysze();
            
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
%             set(obj.viewAnalyzeHandle.hFP,'Visible','off');
            obj.modelAnalyzeHandle.InfoMessage = ' ';
            
            %clear Data
            obj.modelAnalyzeHandle.Stats = [];
            obj.modelAnalyzeHandle.LabelMat = [];
            obj.modelAnalyzeHandle.BoundarieMat = [];
            % Clear PicRGB and Boundarie Objects
            handleChild = allchild(obj.modelAnalyzeHandle.handlePicRGB.Parent);
            delete(handleChild);
%             % clear all axes in viewResult figure
%             arrayfun(@cla,findall(obj.viewAnalyzeHandle.hFP,'type','axes'))
            
             % If a window for Fibertype manipulation already exists,
                % delete it
                OldFig = findobj('Tag','FigureManipulate');
                if ~isempty(OldFig)
                    delete(OldFig);
                    %refresh WindowButtonMotionFcn. If a Figure Manipulate
                    %exist, than the WindowButtonMotionFcn is deleted
%                     set(mainFig,'WindowButtonMotionFcn',@obj.showFiberInfo);
                end
                
                % If a Higlight Boundarie Box already exists,
                % delete it
                if ~isempty(OldFig)
                    OldBox = findobj('Tag','highlightBox');
                    delete(OldBox);
                    %refresh WindowButtonMotionFcn. If a Higlight Boundarie Box
                    %exist, than the WindowButtonMotionFcn is deleted
%                     set(mainFig,'WindowButtonMotionFcn',@obj.showFiberInfo);
                end
            
            % set log text from Analyze GUI to Pic GUI
            obj.controllerEditHandle.setInfoTextView(get(obj.viewAnalyzeHandle.B_InfoText, 'String'));
            
            %             set(obj.controllerEditHandle.viewEditHandle.hFC,'Visible','on');
            
%             set(obj.controllerEditHandle.viewEditHandle.hFP,'Visible','on');
            %make visible figure the current figure
%             figure(obj.controllerEditHandle.viewEditHandle.hFP);


            obj.mainCardPanel.Selection = 1;
            obj.controllerEditHandle.addWindowCallbacks();
            obj.controllerEditHandle.modelEditHandle.InfoMessage = '*** Back to Edit mode ***';
        end
        
        function startResultsEvent(obj,~,~)
            if isempty(obj.modelAnalyzeHandle.Stats)
                obj.modelAnalyzeHandle.InfoMessage = '   - No data are analyzed';
                obj.modelAnalyzeHandle.InfoMessage = '   - Press "Start analyzing"';
            else
                
                % If a window for Fibertype manipulation already exists,
                % delete it
                OldFig = findobj('Tag','FigureManipulate');
                if ~isempty(OldFig)
                    delete(OldFig);
                    %refresh WindowButtonMotionFcn. If a Figure Manipulate
                    %exist, than the WindowButtonMotionFcn is deleted
%                     set(obj.viewAnalyzeHandle.hFP,'WindowButtonMotionFcn',@obj.showFiberInfo);
                end
                
                % If a Higlight Boundarie Box already exists,
                % delete it
                if ~isempty(OldFig)
                    OldBox = findobj('Tag','highlightBox');
                    delete(OldBox);
                    %refresh WindowButtonMotionFcn. If a Higlight Boundarie Box
                    %exist, than the WindowButtonMotionFcn is deleted
%                     set(obj.viewAnalyzeHandle.hFP,'WindowButtonMotionFcn',@obj.showFiberInfo);
                end
                
                obj.modelAnalyzeHandle.InfoMessage = ' ';
                
                Data = obj.modelAnalyzeHandle.sendDataToController();
                
                InfoText = get(obj.viewAnalyzeHandle.B_InfoText, 'String');
                
                obj.controllerResultsHandle.startResultsMode(Data,InfoText);
            end
        end
        
        function showFiberInfo(obj,~,~)
            
            
            Pos = get(obj.viewAnalyzeHandle.hAP, 'CurrentPoint');
            Info = obj.modelAnalyzeHandle.showFiberInfo(Pos);
            
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
            % Show the fiber information from the selected object on the
            % right side of the GUI
            obj.showFiberInfo()
            
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
                    set(obj.mainFigure,'WindowButtonMotionFcn','');
                    % If Label is zero than the click was on the background
                    % instead of a fiber object
                    
                    % get object information at the selected position
                    Info = obj.modelAnalyzeHandle.manipulateFiberShowInfo(Label,PosOut);
                    
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
                end
            end
        end
        
        function manipulateFiberOKEvent(obj,src,evnt)
            
            
            NewFiberType = get(obj.viewAnalyzeHandle.B_FiberTypeManipulate, 'Value');
            LabelNumber = str2num( get(obj.viewAnalyzeHandle.B_TextObjNo, 'String') );
            
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
        
%         function calculationEvent(obj,src,evnt)
%             if strcmp(evnt.AffectedObject.CalculationRunning, 'true')
%                 set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','off')
%                 set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','off')
%                 set(obj.viewAnalyzeHandle.B_StartResults,'Enable','off')
%             else
%                 set(obj.viewAnalyzeHandle.B_BackEdit,'Enable','on')
%                 set(obj.viewAnalyzeHandle.B_StartAnalyze,'Enable','on')
%                 set(obj.viewAnalyzeHandle.B_StartResults,'Enable','on')
%             end
%         end
        
        function setInfoTextView(obj,InfoText)
            set(obj.viewAnalyzeHandle.B_InfoText, 'String', InfoText);
            set(obj.viewAnalyzeHandle.B_InfoText, 'Value' , length(obj.viewAnalyzeHandle.B_InfoText.String));
        end
        
        function updateInfoLogEvent(obj,src,evnt)
            InfoText = cat(1, get(obj.viewAnalyzeHandle.B_InfoText, 'String'), {obj.modelAnalyzeHandle.InfoMessage});
            set(obj.viewAnalyzeHandle.B_InfoText, 'String', InfoText);
            set(obj.viewAnalyzeHandle.B_InfoText, 'Value' , length(obj.viewAnalyzeHandle.B_InfoText.String));
            drawnow;
            pause(0.05)
        end
        
        function newPictureEvent(obj)
            obj.backEditEvent();
            obj.controllerEditHandle.newPictureEvent();
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
                obj.modelAnalyzeHandle.InfoMessage = '   - closing program canceled';
                otherwise
                obj.modelAnalyzeHandle.InfoMessage = '   - closing program canceled';   
            end
            
        end
        
        function delete(obj)
            
        end
        
        
    end
    
    
end

