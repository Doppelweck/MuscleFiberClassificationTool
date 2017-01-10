

path = cd;

addpath(genpath(path));

cl;
pause(0.1);
% 
% if checkSystem()

hf = startSrcreen();    
setAlwaysOnTop(hf,true);   
% Init View's

mainFig = figure('Units','pixels','Position',[1 50 1900 900],...
    'Name','Fiber types classification tool','DockControls','off',...
    'doublebuffer', 'off','Menubar','figure','Visible','on',...
    'WindowStyle','normal','NumberTitle','off');

set( findall(mainFig,'ToolTipString','Edit Plot') ,'Visible','Off');
% set( findall(mainFig,'ToolTipString','Rotate 3D') ,'Visible','Off');
% set( findall(mainFig,'ToolTipString','Data Cursor') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Insert Colorbar') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Insert Legend') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Hide Plot Tools') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','New Figure') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Show Plot Tools') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Brush/Select Data') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Show Plot Tools and Dock Figure') ,'Visible','Off');
set( findall(mainFig,'ToolTipString','Link Plot') ,'Visible','Off');

mainCard = uix.CardPanel('Parent', mainFig,'Selection',0);

movegui(mainFig,'center');



viewEditHandle = viewEdit(mainCard);

mainCard.Selection = 1;
pause(1.5);
drawnow;
viewAnalyzeHandle = viewAnalyze(mainCard);
mainCard.Selection = 2;
pause(1.5);
drawnow;
viewResultsHandle = viewResults(mainCard);
mainCard.Selection = 3;
pause(1.5);
drawnow;
mainCard.Selection = 1;
pause(0.5);
drawnow;

%Init Model's
modelEditHandle = modelEdit();
modelAnalyzeHandle = modelAnalyze();
modelResultsHandle = modelResults();

%Init Controller's
controllerEditHandle = controllerEdit(mainFig,mainCard,viewEditHandle,modelEditHandle);
controllerAnalyzeHandle = controllerAnalyze(mainFig,mainCard,viewAnalyzeHandle,modelAnalyzeHandle);
controllerResultsHandle = controllerResults(mainFig,mainCard,viewResultsHandle,modelResultsHandle);

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
delete(hf);
% end