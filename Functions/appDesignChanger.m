function [mainBackgroundColor, mainTextColor, mainTextHighColor] = appDesignChanger(curFig,colorMode)
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
        
        tableBackgroundColor = [white;matlabGrey];
        
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
        
        tableBackgroundColor = [white;matlabGrey];
        
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
        
        tableBackgroundColor = [black;dark_grey_100];
        
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
        
        tableBackgroundColor = [white;matlabGrey];
        
        boarderType = 'etchedin';
        boarderWidth = 1;
end

h = findobj(curFig,'Type','figure');
if(~isempty(h))
    try
        set(h(1:length(h)),'Color',mainBackground);
    catch
        disp('Error: AppDesignChanger')
    end
end

%Buttons
h = findobj(curFig,'Style','pushbutton','-and',{'-not', 'ForegroundColor', textHighlightColor,'-or','-not', 'BackgroundColor', objectBackground,});
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',objectBackground);
        set(h(1:length(h)),'ForegroundColor',textHighlightColor);
        %     set(h(1:length(h)),'HighlightColor',dark_blue_200);
        %     set(h(1:length(h)),'ShadowColor',dark_blue_200);
    catch
        disp('Error: AppDesignChanger')
    end
end

%Buttons
h = findobj(curFig,'Style','text','-and',{'-not', 'ForegroundColor', textColor,'-or','-not', 'BackgroundColor', mainBackground,});
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',mainBackground);
        set(h(1:length(h)),'ForegroundColor',textColor);
    catch
        disp('Error: AppDesignChanger')
    end
end

h = findobj(curFig,'Style','text','-and', 'Tag', 'textFiberInfo','-and','-not', 'ForegroundColor', textHighlightColor);
if(~isempty(h))
    try
        set(h(1:length(h)),'ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignChanger')
    end
end


%Edit
h = findobj(curFig,'Style','edit','-and',{'-not', 'ForegroundColor', textHighlightColor,'-or','-not', 'BackgroundColor', objectBackground});
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',objectBackground);
        set(h(1:length(h)),'ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignChanger')
    end
end


%Slider
h = findobj(curFig,'Style','slider','-and',{'-not', 'ForegroundColor', textHighlightColor,'-or','-not', 'BackgroundColor', objectBackground});
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',objectBackground);
        set(h(1:length(h)),'ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignChanger')
    end
end


%CheckBox
h = findobj(curFig,'Style','checkbox','-and',{'-not', 'ForegroundColor', textHighlightColor,'-or','-not', 'BackgroundColor', mainBackground});
if(~isempty(h))
    for i=1:1:length(h)
        try
            set(h(1:length(h)),'BackgroundColor',mainBackground);
            set(h(1:length(h)),'ForegroundColor',textHighlightColor);
        catch
            disp('Error: AppDesignChanger')
        end
    end
end

%popup
h = findobj(curFig,'Style','popupmenu','-and',{'-not', 'ForegroundColor', textHighlightColor,'-or','-not', 'BackgroundColor', objectBackground});
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',objectBackground);
        set(h(1:length(h)),'ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignChanger')
    end
end


%ListBox
h = findobj(curFig,'Style','listbox','-and',{'-not', 'ForegroundColor', textColor,'-or','-not', 'BackgroundColor', objectBackground});
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',objectBackground);
        set(h(1:length(h)),'ForegroundColor',textColor);
    catch
        disp('Error: AppDesignChanger')
    end
end


%Panel
h = findobj(curFig,'Type','uipanel','-and',{'-not', 'ForegroundColor', textColor,'-or','-not', 'BackgroundColor', mainBackground});
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',mainBackground);
        set(h(1:length(h)),'ForegroundColor', textColor);
        set(h(1:length(h)),'HighlightColor',boarderColor);
        set(h(1:length(h)),'ShadowColor',shadowColor);
        %     set(h(1:length(h)),'BoarderWidth',boarderWidth);
        %     set(h(1:length(h)),'BoarderType',boarderType);
    catch
        disp('Error: AppDesignChanger')
    end
end


%Axes
h = findobj(curFig,'Type','axes');
if(~isempty(h))
    try
        for i=1:1:length(h)
            h(i).Title.Color    =  axisColor;
        end
    catch
        disp('Error: AppDesignChanger')
    end
    try
        set(h(1:length(h)),'XColor',axisColor);
        set(h(1:length(h)),'YColor',axisColor);
        set(h(1:length(h)),'ZColor',axisColor);
        set(h(1:length(h)),'GridColor', gridColor);
        set(h(1:length(h)),'MinorGridColor',minorGridColor);
        set(h(1:length(h)),'Color',axesBackGroundColor);
%         set(h(1:length(h)),'AmbientLightColor',axesBackGroundColor);
    catch
        disp('Error: AppDesignChanger')
    end
end



%Legend
h = findobj(curFig,'Type','legend',{'-not', 'TextColor', textColor,'-or','-not', 'EdgeColor', edgeColor,'-or','-not', 'Color', legendBackGroundColor});
if(~isempty(h))
    try
        set(h(1:length(h)),'TextColor' , textColor);
        set(h(1:length(h)),'EdgeColor' , edgeColor);
        set(h(1:length(h)),'Color' , legendBackGroundColor);
    catch
        disp('Error: AppDesignChanger')
    end
end

h = findobj(curFig,'-regexp', 'Tag', '.*Legend.*',{'-not', 'TextColor', textColor,'-or','-not', 'EdgeColor', edgeColor,'-or','-not', 'Color', legendBackGroundColor});
if(~isempty(h))
    try
        set(h(1:length(h)),'TextColor' , textColor);
        set(h(1:length(h)),'EdgeColor' , edgeColor);
        set(h(1:length(h)),'Color' , legendBackGroundColor);
    catch
        disp('Error: AppDesignChanger')
    end
end


h = findobj(curFig, 'Type', 'text','-and','-not', 'Color', textHighlightColor);
if(~isempty(h))
    try
        set(h(1:length(h)),'Color' ,textHighlightColor);
        %         h(1:length(h)).EdgeColor = edgeColor;
        %         h(1:length(h)).Color = legendBackGroundColor;
    catch
        disp('Error: AppDesignChanger')
    end
end

h = findobj(curFig,'Type','uicontainer','-and','-not', 'BackgroundColor', mainBackground);
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',mainBackground);
    catch
    end
end


h = findobj(curFig,'Type','uitable',{'-not', 'BackgroundColor', tableBackgroundColor,'-or','-not', 'ForegroundColor', textHighlightColor});
if(~isempty(h))
    try
        set(h(1:length(h)),'BackgroundColor',tableBackgroundColor);
        set(h(1:length(h)),'ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignChanger')
    end
end


h = findobj(curFig,'-regexp', 'Tag', '.*Panel.*',{'-not', 'ForegroundColor', textHighlightColor,'-or','-not', 'HighlightColor', textHighlightColor});
if(~isempty(h))
    try
        set(h(1:length(h)),'ForegroundColor',textHighlightColor);
        set(h(1:length(h)),'ShadowColor',textHighlightColor);
        set(h(1:length(h)),'HighlightColor',textHighlightColor);
    catch
        disp('Error: AppDesignChanger')
    end
end


appDesignElementChanger(curFig);
mainBackgroundColor = mainBackground;
mainTextColor = textColor;
mainTextHighColor  = textHighlightColor;

end

