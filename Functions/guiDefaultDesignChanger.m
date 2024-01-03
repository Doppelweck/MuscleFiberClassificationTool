function guiDefaultDesignChanger(uiObj)

g = groot;

    % Set default figure properties
    g.DefaultFigureColor = [0.1 0.1 0.1]; % Dark background color
    g.DefaultAxesXColor = [1 1 1]; % White x-axis color
    g.DefaultAxesYColor = [1 1 1]; % White y-axis color
    g.DefaultAxesZColor = [1 1 1]; % White z-axis color
    g.DefaultTextColor = [1 1 1]; % White text color

    % Customize edit, list, and popup elements
    g.DefaultUIControlBackgroundColor = [0.2 0.2 0.2]; % Dark background for edit, list, etc.
    g.DefaultUIControlForegroundColor = [1 1 1]; % White foreground for edit, list, etc.

end