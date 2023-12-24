function appDesignChanger(curFig,colorMode)
%APPDESIGNCHANGER Summary of this function goes here
%   Detailed explanation goes here

black = [0 0 0];
white = [1 1 1];

matlabGrey = [0.94 0.94 0.94];
matlabShadow = [0.7 0.7 0.7];
matlabEdge = [0.15 0.15 0.15];
matlabAxisColor = [0.15 0.15 0.15]; %XColor YColor ZColor
matlabGridColor = [0.15 0.15 0.15]; %GridColor
matlabMinorgridColor = [0.1 0.1 0.1]; %MinorGridColor


dark_grey_100 =[30 30 30]/255;
dark_grey_200 =[45 45 45]/255;

matlabBlue = [51,153,255]/255;
dark_blue_000 =[5 65 112]/255; %DarkBlue
dark_blue_100 =[3 85 148]/255;
dark_blue_200 =[3 157 239]/255; %Light Blue

switch colorMode
    case 'default'
        mainBackground = [0.94 0.94 0.94];
        objectBackground = matlabGrey;
        
        axisColor = matlabAxisColor; %XColor YColor ZColor
        gridColor = matlabGridColor; %GridColor
        minorGridColor = matlabMinorgridColor; %MinorGridColor
        axesBackGroundColor = white; %Color
        
        textColor = black; %Color
        textHighlightColor = black; %Color
        
        boarderColor = white; %HighlightColor
        shadowColor = matlabShadow; %ShadowColor
        
        edgeColor = matlabEdge; %EdgeColor
        
        legendBackGroundColor = white; %Color
        
        boarderType = 'etchedin';
        boarderWidth = 1;
        
    case 'light'
        mainBackground = white;
        objectBackground = white;
        
        axisColor = matlabAxisColor; %XColor YColor ZColor
        gridColor = matlabGridColor; %GridColor
        minorGridColor = matlabMinorgridColor; %MinorGridColor
        axesBackGroundColor = white; %Color
        
        textColor = black; %Color
        textHighlightColor = black; %Color
        
        boarderColor = matlabBlue; %HighlightColor
        shadowColor = matlabBlue; %ShadowColor
        
        edgeColor = matlabEdge; %EdgeColor
        
        legendBackGroundColor = white; %Color
        
        boarderType = 'line';
        boarderWidth = 2;
        
    case 'dark'
        mainBackground = dark_grey_200;
        objectBackground = dark_grey_100;
        
        axisColor = matlabBlue; %XColor YColor ZColor
        gridColor = dark_blue_200; %GridColor
        minorGridColor = dark_blue_200; %MinorGridColor
        axesBackGroundColor = black; %Color
        
        textColor = white; %Color
        textHighlightColor = matlabBlue; %Color
        
        boarderColor = matlabBlue; %HighlightColor
        shadowColor = matlabBlue; %ShadowColor
        
        edgeColor = matlabEdge; %EdgeColor
        
        legendBackGroundColor = black; %Color
        
        boarderType = 'line';
        boarderWidth = 2;
        
    otherwise
        mainBackground = [0.94 0.94 0.94];
        objectBackground = matlabGrey;
        
        axisColor = matlabAxisColor; %XColor YColor ZColor
        gridColor = matlabGridColor; %GridColor
        minorGridColor = matlabMinorgridColor; %MinorGridColor
        axesBackGroundColor = white; %Color
        
        textColor = black; %Color
        textHighlightColor = black; %Color
        
        boarderColor = white; %HighlightColor
        shadowColor = matlabShadow; %ShadowColor
        
        edgeColor = matlabEdge; %EdgeColor
        
        legendBackGroundColor = white; %Color
        
        boarderType = 'etchedin';
        boarderWidth = 1;
end

%Buttons
h = findobj(curFig,'Style','pushbutton','-or','Style','togglebutton');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',objectBackground);
        set(h(i),'ForegroundColor',textHighlightColor);
        set(h(i),'HighlightColor',dark_blue_200);
        set(h(i),'ShadowColor',dark_blue_200);
    catch
    end
end

%Buttons
h = findobj(curFig,'Style','text','-and',{'-not', 'ForegroundColor', textColor,'-or','-not', 'BackgroundColor', mainBackground,});
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',mainBackground);
        set(h(i),'ForegroundColor',textColor);
    catch
    end
end
h = findobj(curFig,'Style','text','-and', 'Tag', 'textFiberInfo','-and','-not', 'ForegroundColor', textHighlightColor);
for i=1:1:length(h)
    try
        set(h(i),'ForegroundColor',textHighlightColor);
    catch
    end
end


%Edit
h = findobj(curFig,'Style','edit');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',objectBackground);
        set(h(i),'ForegroundColor',textHighlightColor);
    catch
    end
end

%Slider
h = findobj(curFig,'Style','slider');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',objectBackground);
        set(h(i),'ForegroundColor',textHighlightColor);
    catch
    end
end

%CheckBox
h = findobj(curFig,'Style','checkbox');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',mainBackground);
        set(h(i),'ForegroundColor',textHighlightColor);
    catch
    end
end

%popup
h = findobj(curFig,'Style','popupmenu');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',objectBackground);
        set(h(i),'ForegroundColor',textHighlightColor);
    catch
    end
end

%ListBox
h = findobj(curFig,'Style','listbox');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',objectBackground);
        set(h(i),'ForegroundColor',textColor);
    catch
    end
end

%Panel
h = findobj(curFig,'Type','uipanel');
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',mainBackground);
        set(h(i),'ForegroundColor', textColor);
        set(h(i),'HighlightColor',boarderColor);
        set(h(i),'ShadowColor',shadowColor);
        set(h(i),'BoarderWidth',boarderWidth);
        set(h(i),'BoarderType',boarderType);
    catch
    end
end

%Axes
h = findobj(curFig,'Type','axes');
for i=1:1:length(h)
    try
        set(h(i),'XColor',axisColor);
        set(h(i),'YColor',axisColor);
        set(h(i),'ZColor',axisColor);
        set(h(i),'GridColor', gridColor);
        set(h(i),'MinorGridColor',minorGridColor);
        set(h(i),'Color',axesBackGroundColor);
        set(h(i),'AmbientLightColor',axesBackGroundColor);
        h(i).Title.Color    =  axisColor;
    catch
    end
end


%Legend
h = findobj(curFig,'Type','legend');
for i=1:1:length(h)
    try
        h(i).TextColor = textColor;
        h(i).EdgeColor = edgeColor;
    catch
    end
end


h = findobj(curFig,'Type','uicontainer','-and','-not', 'BackgroundColor', mainBackground);
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',mainBackground);
    catch
    end
end

appDesignElementChanger(curFig);

end

