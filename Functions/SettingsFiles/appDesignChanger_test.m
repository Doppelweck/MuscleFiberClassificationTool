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
        disp('Error: AppDesignChanger0')
    end
end

h = findobj(curFig,'Style','pushbutton','-or','Style','edit','-or','Style','slider','-or','Style','checkbox','-or','Style','popupmenu',...
    '-or','Style','listbox','-or','Type','uipanel','-or','Type','axes','-or','Type','legend','-or','Type','uicontainer',...
    '-or','Type','uitable','-or','Style','text','-or','Type','text');

for i = 1:numel(h)
    if isprop(h(i),'Style')
        search = h(i).Style;
    elseif isprop(h(i),'Type')
        search = h(i).Type;
    else
        search = 'not found';
    end
    
    switch search
        case 'edit'
            set(h(i),'BackgroundColor',objectBackground,'ForegroundColor',textHighlightColor);
        case 'pushbutton'
            set(h(i),'BackgroundColor',objectBackground,'ForegroundColor',textHighlightColor);
        case 'checkbox'
            set(h(i),'BackgroundColor',mainBackground,'ForegroundColor',textHighlightColor);
        case 'slider'
            set(h(i),'BackgroundColor',objectBackground,'ForegroundColor',textHighlightColor);
        case 'popupmenu'
            set(h(i),'BackgroundColor',objectBackground,'ForegroundColor',textHighlightColor);
        case 'listbox'
            set(h(i),'BackgroundColor',objectBackground,'ForegroundColor',textColor,'ForegroundColor',textColor);
        case 'uipanel'
            set(h(i),'BackgroundColor',mainBackground,'ForegroundColor', textColor,'HighlightColor',boarderColor,'ShadowColor',shadowColor);
        case 'axes'
            set(h(i),'XColor',axisColor,'YColor',axisColor,'ZColor',axisColor,'GridColor', gridColor,'MinorGridColor',minorGridColor,'Color',axesBackGroundColor);
        case 'legend'
            set(h(i),'TextColor' , textColor,'EdgeColor' , edgeColor,'Color' , legendBackGroundColor);
        case 'uicontainer'
            set(h(i),'BackgroundColor',mainBackground);
        case 'uitable'
            set(h(i),'BackgroundColor',tableBackgroundColor,'ForegroundColor',textHighlightColor);
        case 'text'
            if contains(h(i).Tag,'textFiberInfo') && isprop(h(i),'Style')
                set(h(i),'ForegroundColor',textHighlightColor,'BackgroundColor',mainBackground);
            elseif ~contains(h(i).Tag,'fiberLabelsProcessed') && isprop(h(i),'Style')
                set(h(i),'ForegroundColor',textColor,'BackgroundColor',mainBackground);
            elseif ~contains(h(i).Tag,'fiberLabelsProcessed') && isprop(h(i),'Type')
                set(h(i),'Color',textHighlightColor);
            else
%                 set(h(i),'ForegroundColor',textColor,'BackgroundColor',mainBackground);
            end
            
        case 'not found'
            disp('Error: AppDesignChanger for loop no obj found')
        otherwise
            disp('Error: AppDesignChanger for loop')
    end
end




% Text
% h = findobj(curFig,'Style','text','-and',{'-not', 'ForegroundColor', textColor,'-or','-not', 'BackgroundColor', mainBackground,}...
%     ,'-and','-not','Tag','fiberLabelsProcessed');
% if(~isempty(h))
%     try
%         set(h(1:length(h)),'BackgroundColor',mainBackground);
%         set(h(1:length(h)),'ForegroundColor',textColor);
%     catch
%         disp('Error: AppDesignChanger2')
%     end
% end
% 
% h = findobj(curFig,'Style','text','-and', 'Tag', 'textFiberInfo','-and','-not', 'ForegroundColor', textHighlightColor);
% if(~isempty(h))
%     try
%         set(h(1:length(h)),'ForegroundColor',textHighlightColor);
%     catch
%         disp('Error: AppDesignChanger3')
%     end
% end
% 
% % 
% 
% 
% h = findobj(curFig, 'Type', 'text','-and','-not', 'Color', textHighlightColor,'-and','-not','Tag','fiberLabelsProcessed');
% if(~isempty(h))
%     try
%         set(h(1:length(h)),'Color' ,textHighlightColor);
%         %         h(1:length(h)).EdgeColor = edgeColor;
%         %         h(1:length(h)).Color = legendBackGroundColor;
%     catch
%         disp('Error: AppDesignChanger14')
%     end
% end




h = findobj(curFig,'-regexp', 'Tag', '.*Panel.*',{'-not', 'ForegroundColor', textHighlightColor,'-or','-not', 'HighlightColor', textHighlightColor});
if(~isempty(h))
    try
        set(h(1:length(h)),'ForegroundColor',textHighlightColor);
        set(h(1:length(h)),'ShadowColor',textHighlightColor);
        set(h(1:length(h)),'HighlightColor',textHighlightColor);
    catch
        disp('Error: AppDesignChanger16')
    end
end


% appDesignElementChanger(curFig);
mainBackgroundColor = mainBackground;
mainTextColor = textColor;
mainTextHighColor  = textHighlightColor;

end

