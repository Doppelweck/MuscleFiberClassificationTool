function appDesignElementChanger(curFig)

colorMode = getSettingsValue('Style');

switch colorMode
    case 'default'
        %Buttons Style: pushbutton, togglebutton
        button_backGroundColor = [0.94 0.94 0.94];
        button_textColor = [0 0 0]; %ForegroundColor
        
        %Text Style: text
        text_backGroundColor = [0.94 0.94 0.94];
        text_textColor = [0 0 0]; %ForegroundColor
        
        %Edit Style: edit
        edit_backGroundColor = [0.94 0.94 0.94];
        edit_textColor = [0 0 0]; %ForegroundColor
        
        %Slider Style: slider
        slider_backGroundColor = [0.94 0.94 0.94];
        slider_textColor = [0 0 0]; %ForegroundColor
        
        %CheckBox Style: checkbox
        checkBox_backGroundColor = [0.94 0.94 0.94];
        checkBox_textColor = [0 0 0]; %ForegroundColor
        
        %popupmenu Style: popupmenu
        pupupmenu_backGroundColor = [0.94 0.94 0.94];
        pupupmenu_textColor = [0 0 0]; %ForegroundColor
        
        %ListBox Style: listbox
        listbox_backGroundColor = [0.94 0.94 0.94];
        listbox_textColor = [0 0 0]; %ForegroundColor
        
        %Panel 'Type','uipanel'
        panel_backGroundColor = [0.94 0.94 0.94];
        panel_textColor = [0 0 0]; %ForegroundColor
        panel_BoarderColor = [1 1 1]; %HighlightColor
        panel_ShadowColor = [0.7 0.7 0.7]; %ShadowColor
        panel_BoarderWidth = 1;
        panel_BoarderType = 'etchedin';
        
        %Axes 'Type','axes'
        axes_axisColor = [0.15 0.15 0.15]; %XColor YColor ZColor
        axes_gridColor = [0.15 0.15 0.15]; %GridColor
        axes_minorgrid_Color = [0.1 0.1 0.1]; %MinorGridColor
        axes_backGroundColor = [1 1 1]; %Color
        axes_AmbientLightColor = [1 1 1]; %AmbientLightColor
        
        %Legelnd 'Type','legend'
        legend_textColor = [0 0 0]; %TextColor
        legend_BackGroundColor = [1 1 1]; %Color
        legend_edgeColor = [0.15 0.15 0.15]; %EdgeColor
        
        %Container 'Type','uicontainer'
        uicontainer_BackgroundColor = [0.94 0.94 0.94]; %Color
        
    case 'light'
        
        %Buttons Style: pushbutton, togglebutton
        button_backGroundColor = [0.98 0.98 0.98];
        button_textColor = [0 0 0]; %ForegroundColor
        
        %Text Style: text
        text_backGroundColor = [1 1 1];
        text_textColor = [0 0 0]; %ForegroundColor
        
        %Edit Style: edit
        edit_backGroundColor = [0.99 0.99 0.99];
        edit_textColor = [0 0 0]; %ForegroundColor
        
        %Slider Style: slider
        slider_backGroundColor = [0.99 0.99 0.99];
        slider_textColor = [0 0 0]; %ForegroundColor
        
        %CheckBox Style: checkbox
        checkBox_backGroundColor = [0.99 0.99 0.99];
        checkBox_textColor = [0 0 0]; %ForegroundColor
        
        %popupmenu Style: popupmenu
        pupupmenu_backGroundColor = [0.99 0.99 0.99];
        pupupmenu_textColor = [0 0 0]; %ForegroundColor
        
        %ListBox Style: listbox
        listbox_backGroundColor = [0.99 0.99 0.99];
        listbox_textColor = [0 0 0]; %ForegroundColor
        
        %Panel 'Type','uipanel'
        panel_backGroundColor = [1 1 1];
        panel_textColor = [0 0 0]; %ForegroundColor
        panel_BoarderColor = [0.7 0.7 0.70]; %HighlightColor
        panel_ShadowColor = [0.5 0.5 0.5]; %ShadowColor
        panel_BoarderWidth = 2;
        panel_BoarderType = 'etchedin';
        
        %Axes 'Type','axes'
        axes_axisColor = [0.15 0.15 0.15]; %XColor YColor ZColor
        axes_gridColor = [0.15 0.15 0.15]; %GridColor
        axes_minorgrid_Color = [0.1 0.1 0.1]; %MinorGridColor
        axes_backGroundColor = [1 1 1]; %Color
        axes_AmbientLightColor = [1 1 1]; %AmbientLightColor
        
        %Legelnd 'Type','legend'
        legend_textColor = [0 0 0]; %TextColor
        legend_BackGroundColor = [1 1 1]; %Color
        legend_edgeColor = [0.15 0.15 0.15]; %EdgeColor
        
        %Container 'Type','uicontainer'
        uicontainer_BackgroundColor = [1 1 1]; %Color
        
    case 'dark'
        textColor =[0 0 0]; %Black
        dark_grey_100 =[38 38 38]/255;
        dark_grey_200 =[70 70 70]/255;
        
        dark_blue_000 =[5 65 112]/255; %DarkBlue
        dark_blue_100 =[3 85 148]/255;
        dark_blue_200 =[3 157 239]/255; %Light Blue
        
        textColor = [1 1 1];
        matlabBlue = [51,153,255]/255;
        
        %Buttons Style: pushbutton, togglebutton
        button_backGroundColor = [0.2 0.2 0.2];
        button_textColor = textColor; %ForegroundColor
        
        %Text Style: text
        text_backGroundColor = dark_grey_100;
        text_textColor = textColor; %ForegroundColor
        
        %Edit Style: edit
        edit_backGroundColor = dark_grey_200;
        edit_textColor = matlabBlue; %ForegroundColor
        
        %Slider Style: slider
        slider_backGroundColor = dark_grey_200;
        slider_textColor = matlabBlue; %ForegroundColor
        
        %CheckBox Style: checkbox
        checkBox_backGroundColor = dark_grey_200;
        checkBox_textColor = matlabBlue; %ForegroundColor
        
        %popupmenu Style: popupmenu
        pupupmenu_backGroundColor = dark_grey_200;
        pupupmenu_textColor = matlabBlue; %ForegroundColor
        
        %ListBox Style: listbox
        listbox_backGroundColor = dark_grey_100;
        listbox_textColor = textColor; %ForegroundColor
        
        %Panel 'Type','uipanel'
        panel_backGroundColor = dark_grey_100;
        panel_textColor = [1 1 1]; %ForegroundColor
        panel_BoarderColor = [0.7 0.7 0.70]; %HighlightColor
        panel_ShadowColor = [0.5 0.5 0.5]; %ShadowColor
        panel_BoarderWidth = 2;
        panel_BoarderType = 'etchedin';
        
        %Axes 'Type','axes'
        axes_axisColor = textColor; %XColor YColor ZColor
        axes_gridColor = [0.15 0.15 0.15]; %GridColor
        axes_minorgrid_Color = [0.1 0.1 0.1]; %MinorGridColor
        axes_backGroundColor = [0 0 0]; %Color
        axes_AmbientLightColor = [1 1 1]; %AmbientLightColor
        
        %Legelnd 'Type','legend'
        legend_textColor = [1 1 1]; %TextColor
        legend_BackGroundColor = [1 1 1]; %Color
        legend_edgeColor = [0.9 0.9 0.9]; %EdgeColor
        
        %Container 'Type','uicontainer'
        uicontainer_BackgroundColor = dark_grey_100; %Color
    otherwise
end

h = findobj(curFig,{'Style','edit','-and','Enable','off'},'-or',{'Style','checkbox4','-and','Enable','off'}, ...
    '-or',{'Style','slider','-and','Enable','off'},'-or',{'Style','popupmenu','-and','Enable','off'});
for i=1:1:length(h)
    try
        set(h(i),'Style','frame','Enable','off','ForegroundColor',text_backGroundColor);
    catch
    end
end

h = findobj(curFig,'Style','frame','-and','Enable','on','-and',{'-regexp', 'Tag', '.*edit.*'});
for i=1:1:length(h)
    try
        set(h(i),'Style','edit','Enable','on','ForegroundColor',edit_textColor);
    catch
    end
end

h = findobj(curFig,'Style','frame','-and','Enable','on','-and',{'-regexp', 'Tag', '.*checkbox.*'});
for i=1:1:length(h)
    try
        set(h(i),'Style','checkbox','Enable','on','ForegroundColor',checkBox_textColor);
    catch
    end
end

h = findobj(curFig,'Style','frame','-and','Enable','on','-and',{'-regexp', 'Tag', '.*slider.*'});
for i=1:1:length(h)
    try
        set(h(i),'Style','slider','Enable','on','ForegroundColor',slider_textColor);
    catch
    end
end

h = findobj(curFig,'Style','frame','-and','Enable','on','-and',{'-regexp', 'Tag', '.*popupmenu.*'});
for i=1:1:length(h)
    try
        set(h(i),'Style','popupmenu','Enable','on','ForegroundColor',pupupmenu_textColor);
    catch
    end
end

end
