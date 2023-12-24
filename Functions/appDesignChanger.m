function appDesignChanger(curFig,colorMode)
%APPDESIGNCHANGER Summary of this function goes here
%   Detailed explanation goes here

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
        dark_grey_100 =[30 30 30]/255;
        dark_grey_200 =[70 70 70]/255;
        
        matlabBlue = [51,153,255]/255;
        
        dark_blue_000 =[5 65 112]/255; %DarkBlue
        dark_blue_100 =[3 85 148]/255;
        dark_blue_200 =[3 157 239]/255; %Light Blue
        
        textColor = [1 1 1];
        
        %Buttons Style: pushbutton, togglebutton
        button_backGroundColor = [0.2 0.2 0.2];
        button_textColor = matlabBlue; %ForegroundColor
        
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
        checkBox_backGroundColor = dark_grey_100;
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
        panel_BoarderColor = matlabBlue; %HighlightColor
        panel_ShadowColor = matlabBlue; %ShadowColor
        panel_BoarderWidth = 2;
        panel_BoarderType = 'etchedin';
        
        %Axes 'Type','axes'
        axes_axisColor = matlabBlue; %XColor YColor ZColor
        axes_gridColor = dark_blue_000; %GridColor
        axes_minorgrid_Color = dark_blue_100; %MinorGridColor
        axes_backGroundColor = [0 0 0]; %Color
        axes_AmbientLightColor = [1 1 1]; %AmbientLightColor
        
        %Legelnd 'Type','legend'
        legend_textColor = matlabBlue; %TextColor
        legend_BackGroundColor = [0 0 0]; %Color
        legend_edgeColor = matlabBlue; %EdgeColor
        
        %Container 'Type','uicontainer'
        uicontainer_BackgroundColor = dark_grey_100; %Color
    otherwise
end

%Buttons
h = findobj(curFig,'Style','pushbutton','-or','Style','togglebutton');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',button_backGroundColor);
        set(h(i),'ForegroundColor',button_textColor);
        set(h(i),'HighlightColor',dark_blue_200);
        set(h(i),'ShadowColor',dark_blue_200);
    catch
    end
end

%Buttons
h = findobj(curFig,'Style','text','-and',{'-not', 'ForegroundColor', text_textColor,'-or','-not', 'BackgroundColor', text_backGroundColor,});
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',text_backGroundColor);
        set(h(i),'ForegroundColor',text_textColor);
    catch
    end
end
h = findobj(curFig,'Style','text','-and', 'Tag', 'textFiberInfo','-and','-not', 'ForegroundColor', button_textColor);
for i=1:1:length(h)
    try
        set(h(i),'ForegroundColor',button_textColor);
    catch
    end
end


%Edit
h = findobj(curFig,'Style','edit');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',edit_backGroundColor);
        set(h(i),'ForegroundColor',edit_textColor);
    catch
    end
end

%Slider
h = findobj(curFig,'Style','slider');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',slider_backGroundColor);
        set(h(i),'ForegroundColor',slider_textColor);
    catch
    end
end

%CheckBox
h = findobj(curFig,'Style','checkbox');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',checkBox_backGroundColor);
        set(h(i),'ForegroundColor',checkBox_textColor);
    catch
    end
end

%popup
h = findobj(curFig,'Style','popupmenu');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',pupupmenu_backGroundColor);
        set(h(i),'ForegroundColor',pupupmenu_textColor);
    catch
    end
end

%ListBox
h = findobj(curFig,'Style','listbox');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',listbox_backGroundColor);
        set(h(i),'ForegroundColor',listbox_textColor);
    catch
    end
end

%Panel
h = findobj(curFig,'Type','uipanel');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',panel_backGroundColor);
        set(h(i),'ForegroundColor', panel_textColor);
        set(h(i),'HighlightColor',panel_BoarderColor);
        set(h(i),'ShadowColor',panel_ShadowColor);
        set(h(i),'BoarderWidth',panel_BoarderWidth);
        set(h(i),'BoarderType',panel_BoarderType);
    catch
    end
end

%Axes
h = findobj(curFig,'Type','axes');
for i=1:1:length(h)
    try
        set(h(i),'XColor',axes_axisColor);
        set(h(i),'YColor',axes_axisColor);
        set(h(i),'ZColor',axes_axisColor);
        set(h(i),'GridColor', axes_gridColor);
        set(h(i),'MinorGridColor',axes_minorgrid_Color);
        set(h(i),'Color',axes_backGroundColor);
        set(h(i),'AmbientLightColor',axes_axisColor);
        h(i).Title.Color    =  axes_axisColor;
    catch
    end
end


%text
h = findobj(curFig,'Type','legend');
for i=1:1:length(h)
    try
        h(i).TextColor = legend_textColor;
        h(i).EdgeColor = legend_edgeColor;
    catch
    end
end

h = findobj(curFig,'Type','legend');
for i=1:1:length(h)
    try
        h(i).TextColor = legend_textColor;
        h(i).EdgeColor = legend_edgeColor;
    catch
    end
end


h = findobj(curFig,'Type','uicontainer','-and','-not', 'BackgroundColor', uicontainer_BackgroundColor);
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',uicontainer_BackgroundColor);
    catch
    end
end

appDesignElementChanger(curFig);

end

