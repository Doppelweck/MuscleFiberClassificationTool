
% find starting path
path = cd;
% add files to the matalb path
addpath(genpath(path));

cl;
pause(0.1);
% 
% if checkSystem()

% create starting screen
hf = startSrcreen();    
setAlwaysOnTop(hf,true);

% create main figure
mainFig = figure('Units','normalized','Position',[0.01 0.05 0.98 0.85],...
    'Name','Fiber types classification tool','DockControls','off',...
    'doublebuffer', 'off','Menubar','figure','Visible','on',...
    'WindowStyle','normal','NumberTitle','off');

% hide needless ToogleTool objects in the main figure
set( findall(mainFig,'ToolTipString','Edit Plot') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Insert Colorbar') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Insert Legend') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Hide Plot Tools') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','New Figure') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Show Plot Tools') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Brush/Select Data') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Show Plot Tools and Dock Figure') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Link Plot') ,'Visible','Off');

%create card panel onbject
mainCard = uix.CardPanel('Parent', mainFig,'Selection',0);

%Init VIEW's
viewEditHandle = viewEdit(mainCard);
mainCard.Selection = 1;
drawnow;pause(0.5);
viewAnalyzeHandle = viewAnalyze(mainCard);
mainCard.Selection = 2;
drawnow;pause(0.5);
viewResultsHandle = viewResults(mainCard);
mainCard.Selection = 3;
drawnow;pause(0.5);
mainCard.Selection = 1;
drawnow;

%Init MODEL's
modelEditHandle = modelEdit();
modelAnalyzeHandle = modelAnalyze();
modelResultsHandle = modelResults();

%Init CONTROLLER's
controllerEditHandle = controllerEdit(mainFig, mainCard, viewEditHandle, modelEditHandle);
controllerAnalyzeHandle = controllerAnalyze(mainFig, mainCard, viewAnalyzeHandle, modelAnalyzeHandle);
controllerResultsHandle = controllerResults(mainFig, mainCard, viewResultsHandle, modelResultsHandle);

%Connecting Model's and their Controller's
modelEditHandle.controllerEditHandle = controllerEditHandle;
modelAnalyzeHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
modelResultsHandle.controllerResultsHandle = controllerResultsHandle;

%Connecting Controller's to each other
controllerEditHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
controllerAnalyzeHandle.controllerEditHandle = controllerEditHandle;
controllerAnalyzeHandle.controllerResultsHandle = controllerResultsHandle;
controllerResultsHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;

pause(0.5);
drawnow;
% delete starting screen
delete(hf);
% end