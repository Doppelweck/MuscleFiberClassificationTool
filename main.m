try
    
    % find starting path
    path = cd;
    % add files to the current matalb path
    addpath(genpath('MVC'));
    addpath(genpath('Functions'));
    addpath(genpath('NotifySounds'));
%     javaaddpath(genpath('bioformats_package.jar'),'-end')
    
    cl;
    pause(0.1);
    
    % if checkSystem()
    
    % create starting screen
    if ismac
        fontSizeS = 18; % Font size small
        fontSizeB = 20; % Font size big
    elseif ispc
        fontSizeS = 20*0.75; % Font size small
        fontSizeB = 20*0.75; % Font size big
    else
        fontSizeS = 18; % Font size small
        fontSizeB = 20; % Font size big
    end
    
    %Create Start Screen
    hf = startSrcreen();
    TitleText1=text(hf.Children,0.45,0.92,'Muscle Fiber',...
        'units','normalized','FontUnits','normalized','FontSize',0.08,'Color',[1 0.5 0]);
    TitleText2=text(hf.Children,0.45,0.83,'Classification Tool',...
        'units','normalized','FontUnits','normalized','FontSize',0.08,'Color',[1 0.5 0]);
    VersionText=text(hf.Children,0.45,0.75,'Version 1.3 6-March-2020','units','normalized','FontUnits','normalized','FontSize',0.03,'Color','k');
    InfoText=text(hf.Children,0.45,0.7,'Loading please wait... Initialize application...','units','normalized','FontUnits','normalized','FontSize',0.02,'Color','k');
    text(hf.Children,0.05,0.3,'Developed by:','units','normalized','FontUnits','normalized','FontSize',0.03,'Color','k');
    text(hf.Children,0.05,0.15,'In cooperation with:','units','normalized','FontUnits','normalized','FontSize',0.03,'Color','k');
    text(hf.Children,0.05,0.07,'2017','units','normalized','FontUnits','normalized','FontSize',0.045,'Color','[1 0.5 0]');
    % setAlwaysOnTop(hf,true);
    drawnow;
    
    % create main figure
    mainFig = figure('Units','normalized','Position',[0.01 0.05 0.98 0.85],...
        'Name','Muscle-Fiber-Classification-Tool','DockControls','off',...
        'doublebuffer', 'off','Menubar','figure','Visible','on',...
        'WindowStyle','normal','NumberTitle','off',...
        'PaperPositionMode','auto',...
        'InvertHardcopy','off');
    figure(hf)
    set(hf,'WindowStyle','modal');
    
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
    set( findall(mainFig,'ToolTipString','Save Figure') ,'Visible','Off');
    set( findall(mainFig,'ToolTipString','Open File') ,'Visible','Off');
    
    %create card panel onbject
    mainCard = uix.CardPanel('Parent', mainFig,'Selection',0);
    InfoText.String='Loading please wait...   Initialize VIEW-Components...';
    %Init VIEW's
    viewEditHandle = viewEdit(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Edit...';
    mainCard.Selection = 1;
    drawnow;pause(0.5);
    viewAnalyzeHandle = viewAnalyze(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Analyze...';
    mainCard.Selection = 2;
    drawnow;pause(0.5);
    viewResultsHandle = viewResults(mainCard);
    InfoText.String='Loading please wait...   Initialize VIEW-Results...';
    mainCard.Selection = 3;
    drawnow;pause(0.5);
    mainCard.Selection = 1;
    drawnow;
    
    InfoText.String='Loading please wait...   Initialize MODEL-Components...';
    %Init MODEL's
    modelEditHandle = modelEdit();
    modelAnalyzeHandle = modelAnalyze();
    modelResultsHandle = modelResults();
    pause(0.2)
    
    InfoText.String='Loading please wait...   Initialize CONTROLLER-Components...';
    %Init CONTROLLER's
    controllerEditHandle = controllerEdit(mainFig, mainCard, viewEditHandle, modelEditHandle);
    controllerAnalyzeHandle = controllerAnalyze(mainFig, mainCard, viewAnalyzeHandle, modelAnalyzeHandle);
    controllerResultsHandle = controllerResults(mainFig, mainCard, viewResultsHandle, modelResultsHandle);
    pause(0.2)
    
    InfoText.String='Loading please wait...   Connecting components...';
    %Connecting Model's and their Controller's
    modelEditHandle.controllerEditHandle = controllerEditHandle;
    modelAnalyzeHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    modelResultsHandle.controllerResultsHandle = controllerResultsHandle;
    pause(0.2)
    
    InfoText.String='Loading please wait...   Start application...';
    %Connecting Controller's to each other
    controllerEditHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    controllerAnalyzeHandle.controllerEditHandle = controllerEditHandle;
    controllerAnalyzeHandle.controllerResultsHandle = controllerResultsHandle;
    controllerResultsHandle.controllerAnalyzeHandle = controllerAnalyzeHandle;
    pause(0.2)
    
    InfoText.String='Run application';
    pause(0.5);
    drawnow;
    % delete starting screen
    delete(hf);
    delete(InfoText);
    delete(VersionText);
    
catch
    ErrorInfo = lasterror;
    Text = [];
    Text{1,1} = ErrorInfo.message;
    Text{2,1} = '';
    
    if any(strcmp('stack',fieldnames(ErrorInfo)))
        
        for i=1:size(ErrorInfo.stack,1)
            
            Text{end+1,1} = [ErrorInfo.stack(i).file];
            Text{end+1,1} = [ErrorInfo.stack(i).name];
            Text{end+1,1} = ['Line: ' num2str(ErrorInfo.stack(i).line)];
            Text{end+1,1} = '------------------------------------------';
            
        end
        
    end
    
    mode = struct('WindowStyle','modal','Interpreter','tex');
    
    % delete starting screen
    delete(hf);
    delete(InfoText);
    delete(VersionText);
    
    uiwait(errordlg(Text,'ERROR: Initalize Program failed:',mode));
    
                    
    %find all objects
    object_handles = findall(mainFig);
    %delete objects
    delete(object_handles);
    %find all figures and delete them
    figHandles = findobj('Type','figure');
    delete(figHandles);
    
    
end
% end