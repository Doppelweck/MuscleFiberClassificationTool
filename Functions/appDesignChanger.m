function appDesignChanger(curFig,colorMode)
%APPDESIGNCHANGER Summary of this function goes here
%   Detailed explanation goes here

switch colorMode
    case 'default'
        
        backGroundColor = [0.94 0.94 0.94];
        panelLineType = 'etchedin';
        panelBoarderWidth = 1;
        highlightColor = [1 1 1];
        shadowColor = [0.70,0.70,0.70];
        textColor = [0 0 0];
        
    case 'light'
        
        backGroundColor = 'w';
        panelLineType = 'line';
        panelBoarderWidth = 2;
        highlightColor = [0.64 0.64 0.64];
        shadowColor = highlightColor;
        textColor = [0 0 0];
        
    case 'dark'
        
    otherwise
end
h = findobj(curFig,'-property','BackgroundColor','-and', ...
    '-not',{'Style','pushbutton','-or','Style','togglebutton'});
for i=1:1:length(h)
    try
        set(h(i),'BackgroundColor',backGroundColor);
    catch
    end
end

h = findobj(curFig,'Type','uipanel');
for i=1:1:length(h)
    try
        set(h(i),'BorderWidth',panelBoarderWidth);
        set(h(i),'BorderType',panelLineType);
        set(h(i),'HighlightColor',highlightColor);
        set(h(i),'ShadowColor',shadowColor);
        set(h(i),'ForegroundColor',textColor);
    catch
    end
end

h = findobj(curFig,'Style','popupmenu','-or','Style','popupmenu','-or','Style','text' ...
    ,'-or','Style','edit' ,'-or','Style','pushbutton');
for i=1:1:length(h)
    try
%         set(h(i),'BorderWidth',panelBoarderWidth);
%         set(h(i),'BorderType',panelLineType);
%         set(h(i),'HighlightColor',highlightColor);
%         set(h(i),'ShadowColor',shadowColor);
        set(h(i),'ForegroundColor',textColor);
        set(h(i),'BackgroundColor',backGroundColor);
    catch
        disp('Error');
    end
end

end

