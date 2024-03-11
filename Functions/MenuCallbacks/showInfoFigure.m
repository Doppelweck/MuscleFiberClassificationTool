function h=showInfoFigure(mainFigObj)

winState=get(mainFigObj,'WindowState');

width = 660; height = 700;
    
    % Create a modal figure
    modalFig = figure('Name', 'App Information', 'NumberTitle', 'off', 'MenuBar', 'none', 'ToolBar', 'none');
    set(modalFig,'CloseRequestFcn',{@closeInfoFigure,winState})

    set(modalFig, 'Visible', 'off');
    modalFig.Position(3) = width;
    modalFig.Position(4) = height;
    set(mainFigObj, 'units', 'pixel');
    Pix_SS = mainFigObj.Position;
    set(mainFigObj, 'units', 'normalized');
    modalFigWidht = modalFig.Position(3);
    modalFigHeight = modalFig.Position(4);
    
    [img, ~, alphachannel] = imread('Icon4.png');
    [imgGit, ~, alphachannelGit] = imread('IconGithub2.png');
    [imgPP, ~, alphachannelPP] = imread('IconPayPal2.png');
    [imgGD, ~, alphachannelGD] = imread('IconGoogleDrive.png');
    
    imgHW = 200;
    ax1=axes(modalFig,'Units', 'pixels', 'Position', [modalFigWidht-imgHW-15, modalFigHeight-imgHW-15, imgHW, imgHW],'Color','none');
    image(img,'alphadata',im2double(alphachannel),'Parent',ax1);
    axis(ax1, 'off');
%     axtoolbar(ax1,{}); 

    imgHW = 40;
    axPP=axes(modalFig,'Units', 'pixels', 'Position', [20, 170, imgHW, imgHW],'Color','none');
    image(imgPP,'alphadata',im2double(alphachannelPP),'Parent',axPP);
    axis(axPP, 'off');
    
    axGit=axes(modalFig,'Units', 'pixels', 'Position', [20, 250, imgHW, imgHW],'Color','none');
    image(imgGit,'alphadata',im2double(alphachannelGit),'Parent',axGit);
    axis(axGit, 'off');
    
    axGD=axes(modalFig,'Units', 'pixels', 'Position', [20, 330, imgHW, imgHW],'Color','none');
    image(imgGD,'alphadata',im2double(alphachannelGD),'Parent',axGD);
    axis(axGD, 'off');
    
    drawnow;
    
    set(modalFig, 'Position', [(Pix_SS(3)-width)/2 (Pix_SS(4)-height)/1.5 width height])
    
    
  
    label_1 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [20, modalFigHeight-40, modalFigWidht-250, 24], 'String', 'Muscle-Fiber-Classification-Tool');
    set(label_1,'FontUnits','pixels','FontSize', 24, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');

    versionString = ['Version ' getSettingsValue('Version') '  ' getSettingsValue('Day') '-' getSettingsValue('Month') '-' getSettingsValue('Year')];
    label_2 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [20, label_1.Position(2)-30, modalFigWidht-250, 25], 'String', versionString);
    set(label_2,'FontUnits','pixels', 'FontSize', 18, 'HorizontalAlignment', 'left');
    

    
    label_3 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [20, label_2.Position(2)-40, modalFigWidht-250, 25], 'String', 'Developed by:');
    set(label_3,'FontUnits','pixels', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');

    label_4 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [70, label_3.Position(2)-25, modalFigWidht-300, 20], 'String', 'Sebastian Friedrich, BEng');
    set(label_4,'FontUnits','pixels', 'FontSize', 16, 'HorizontalAlignment', 'left');
    
    
    
    
    
    label_5 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [20, 545-40, modalFigWidht/2, 25], 'String', 'With the help of:');
    set(label_5,'FontUnits','pixels', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');

    label_6 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [70, label_5.Position(2)-25, modalFigWidht/2, 20], 'String', 'David Goodwin, BSc');
    set(label_6,'FontUnits','pixels', 'FontSize', 16, 'FontWeight', 'normal', 'HorizontalAlignment', 'left');
    
    label_7 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [70, label_6.Position(2)-20, modalFigWidht/2, 20], 'String', 'The Royal Veterinary College');
    set(label_7,'FontUnits','pixels', 'FontSize', 14, 'FontWeight', 'normal', 'HorizontalAlignment', 'left');

    label_8 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [70, label_7.Position(2)-30, modalFigWidht, 20], 'String', 'Justin Perkins, BVetMed MS CertES Dip ECVS MRCVS');
    set(label_8,'FontUnits','pixels', 'FontSize', 16, 'FontWeight', 'normal', 'HorizontalAlignment', 'left');
    
    label_9 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [70, label_8.Position(2)-20, modalFigWidht/2, 20], 'String', 'The Royal Veterinary College');
    set(label_9,'FontUnits','pixels', 'FontSize', 14, 'FontWeight', 'normal', 'HorizontalAlignment', 'left');

    
    
    label_10 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [20, label_9.Position(2)-40, modalFigWidht-200, 25], 'String','Manual and current version available at:');
    set(label_10,'FontUnits','pixels', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');

    
    
    
    
    label_12 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [20, 330-40, modalFigWidht, 25], 'String','GitHub repository:');
    set(label_12,'FontUnits','pixels', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');
    
   

    
    
    label_13 = uicontrol('Style', 'text', 'Parent', modalFig, 'Position', [20, 250-40, modalFigWidht, 25], 'String','PayPal donation:');
    set(label_13,'FontUnits','pixels', 'FontSize', 18, 'FontWeight', 'bold', 'HorizontalAlignment', 'left');
    
    

    label_disclaimer = uicontrol('Style', 'text', 'Parent', modalFig, 'String', ['This Appis provided free of charge for use on Windows and macOS platforms. ' ...
        'You can download the latest version from the Google Drive link above. '...
        'Additionally, the source code is available on GitHub.com. '...
        'Feel free to use and enjoy the software at your convenience. '...
        'If you find it valuable and would like to support further development, you have the option to make a donation. '...
        'Your contributions are greatly appreciated and help in enhancing the quality and features of this software. '...
        'However, donations are entirely voluntary, and users are under no obligation to contribute. '...
        'Thank you for using my App!']...
        ,'Position', [20, 170-140, modalFigWidht-40, 120]);
    set(label_disclaimer,'FontUnits','pixels', 'FontSize', 14, 'FontWeight', 'normal');
    
    set(modalFig, 'Visible', 'on');

    
    url = 'sebastian.friedrich.software@gmail.com';
    text = url;
    hlinkMail = uicontrolHyperLink(modalFig,[70, 545, 305, 20],'pixels',16,text,url);
    
    url = 'https://drive.google.com/drive/folders/1ZpQZU2xMfEPq2BbAiHYZUVx-WdxUNUDx?usp=share_link';
    text = 'Google Drive';
    hlinkDrive  = uicontrolHyperLink(modalFig,[70, 370-20, 110, 20],'pixels',16,text,url);
    text = url;
    hlinkDrive2 = uicontrolHyperLink(modalFig,[70, 350-20, 555, 20],'pixels',12,text,url);
    
    url = 'https://github.com/Doppelweck/MuscleFiberClassificationTool';
    text = 'Github.com';
    hlinkGit  = uicontrolHyperLink(modalFig,[70, 290-20, 90, 20],'pixels',16,text,url);
    text = url;
    hlinkGit2 = uicontrolHyperLink(modalFig,[70, 270-20, 350, 20],'pixels',12,text,url);
    

    url = 'paypal.me/sFriedrichSoftware';
    text = 'PayPal.com';
    hlinkPP  = uicontrolHyperLink(modalFig,[70, 210-20, 90, 20],'pixels',16,text,url);
    text = url;
    hlinkPP2 = uicontrolHyperLink(modalFig,[70, 190-20, 175, 20],'pixels',12,text,url);
   
    set(modalFig,'WindowStyle','modal');
    set(modalFig, 'Resize', 'off');
    set(modalFig,'Visible','on');

    h=modalFig;
    
    figure(modalFig);
end

function closeInfoFigure(src,~,winState)
    mainFigObj=findobj('Tag','mainFigure');

    delete(src);

    if strcmp(winState,'maximized')
        set(mainFigObj,'WindowState','maximized');
    end
end