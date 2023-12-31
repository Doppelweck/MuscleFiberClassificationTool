function appDesignElementChanger(curFig)


colorMode = getSettingsValue('Style');

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
        gridColor = dark_blue_000; %GridColor
        minorGridColor = dark_blue_100; %MinorGridColor
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

if(strcmp(colorMode,'dark'))
    h = findobj(curFig,{'Style','edit','-and','Enable','off'},'-or',{'Style','checkbox4','-and','Enable','off'}, ...
        '-or',{'Style','slider','-and','Enable','off'},'-or',{'Style','popupmenu','-and','Enable','off'});
    try
        set(h(1:length(h)),'Style','frame','Enable','off','ForegroundColor',black);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
    h = findobj(curFig,'Style','frame','-and','Enable','on','-and',{'-regexp', 'Tag', '.*edit.*'});
    try
        set(h(1:length(h)),'Style','edit','Enable','on','ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
    
    h = findobj(curFig,'Style','frame','-and','Enable','on','-and',{'-regexp', 'Tag', '.*checkbox.*'});
    try
        set(h(1:length(h)),'Style','checkbox','Enable','on','ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
    
    h = findobj(curFig,'Style','frame','-and','Enable','on','-and',{'-regexp', 'Tag', '.*slider.*'});
    try
        set(h(1:length(h)),'Style','slider','Enable','on','ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
    
    h = findobj(curFig,'Style','frame','-and','Enable','on','-and',{'-regexp', 'Tag', '.*popupmenu.*'});
    try
        set(h(1:length(h)),'Style','popupmenu','Enable','on','ForegroundColor',textHighlightColor);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
   
else
    %If Style is not dark, then frame objects are not needed. Transfer alle
    %Frame Objects back to normal uicontrols
    h = findobj(curFig,'Style','frame','-and',{'-regexp', 'Tag', '.*edit.*'});
    try
        set(h(1:length(h)),'Style','edit','ForegroundColor',textHighlightColor);
        set(h(1:length(h)),'Style','edit','BackgroundColor',objectBackground);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
    
    h = findobj(curFig,'Style','frame','-and',{'-regexp', 'Tag', '.*checkbox.*'});
    try
        set(h(1:length(h)),'Style','checkbox','ForegroundColor',textHighlightColor,'BackgroundColor',mainBackground);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
    
    h = findobj(curFig,'Style','frame','-and',{'-regexp', 'Tag', '.*slider.*'});
    try
        set(h(1:length(h)),'Style','slider','ForegroundColor',textHighlightColor,'BackgroundColor',objectBackground);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
    
    h = findobj(curFig,'Style','frame','-and',{'-regexp', 'Tag', '.*popupmenu.*'});
    try
        set(h(1:length(h)),'Style','popupmenu','Enable','on','ForegroundColor',textHighlightColor,'BackgroundColor',objectBackground);
    catch
        disp('Error: AppDesignElementChanger')
    end
    
end

end
