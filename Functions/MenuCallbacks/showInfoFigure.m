function showInfoFigure(mainFigObj)

width = 660; height = 700;
    
    % Create a modal figure
    modalFig = uifigure('Name', 'App Information', 'NumberTitle', 'off', 'WindowStyle', 'normal');
    
    set(modalFig,'Visible','off');
    
    modalFig.Position(3) = width;
    modalFig.Position(4) = height;
    set(mainFigObj,'units','pixel')
    Pix_SS = mainFigObj.Position;
    set(mainFigObj,'units','normalized')
    modalFigWidht = modalFig.Position(3);
    modalFigHeight = modalFig.Position(4);
    
    set(modalFig,'Position', [(Pix_SS(3)-width)/2 (Pix_SS(4)-height)/1.5 width height])
    
    % Load your image (replace 'your_image_file.jpg' with your actual image file)
    [img, map, alphachannel] = imread('Icon4.png');
    imgHW = 200;
    % Set the position of the axes for the image in the top right corner
    ax1=axes(modalFig,'Units', 'pixels', 'Position', [modalFigWidht-imgHW-15, modalFigHeight-imgHW-15, imgHW, imgHW],'Color','none');
    image(img,'alphadata',im2double(alphachannel),'Parent',ax1);
    
    % Remove axis ticks and labels for a cleaner look
    axis(ax1, 'off');
    axtoolbar(ax1,{}); 
  
    label_1 = uilabel(modalFig, 'Text', 'Muscle-Fiber-Classification-Tool', 'Position', [20, modalFigHeight-40, modalFigWidht, 30]);
    label_1.FontSize = 24;
    label_1.FontWeight = 'bold';
    label_1.HorizontalAlignment = 'left';
    
    versionString = ['Version ' getSettingsValue('Version') '  ' getSettingsValue('Day') '-' getSettingsValue('Month') '-' getSettingsValue('Year')];
    label_2 = uilabel(modalFig, 'Text', versionString, 'Position', [20, label_1.Position(2)-20, modalFigWidht, 20]);
    label_2.FontSize = 18;
    label_2.HorizontalAlignment = 'left';
    
    label_3 = uilabel(modalFig, 'Text', 'Developed by:', 'Position', [20, label_2.Position(2)-40, modalFigWidht, 20]);
    label_3.FontSize = 16;
    label_3.FontWeight = 'bold';
    label_3.HorizontalAlignment = 'left';
    
    label_4 = uilabel(modalFig, 'Text', 'Sebastian Friedrich, BEng', 'Position', [70, label_3.Position(2)-20, modalFigWidht, 20]);
    label_4.FontSize = 16;
    label_4.HorizontalAlignment = 'left';
    
    hlinkMail = uihyperlink(modalFig, 'Position', [70, label_4.Position(2)-20, modalFigWidht, 20]);
    email = 'sebastian.friedrich.software@gmail.com';
    hlinkMail.FontSize = 16;
    hlinkMail.Text = email;
    hlinkMail.URL = ['mailto:' email];
    
    label_5 = uilabel(modalFig, 'Text', 'With the help of:', 'Position', [20, hlinkMail.Position(2)-40, modalFigWidht, 20]);
    label_5.FontSize = 16;
    label_5.FontWeight = 'bold';
    label_5.HorizontalAlignment = 'left';
    
    label_6 = uilabel(modalFig, 'Text', 'David Goodwin, BSc', 'Position', [70, label_5.Position(2)-20, modalFigWidht, 20]);
    label_6.FontSize = 16;
    label_6.HorizontalAlignment = 'left';
    
    label_7 = uilabel(modalFig, 'Text', 'The Royal Veterinary College', 'Position', [70, label_6.Position(2)-20, modalFigWidht, 20]);
    label_7.FontSize = 14;
    label_7.HorizontalAlignment = 'left';
    
    label_8 = uilabel(modalFig, 'Text', 'Justin Perkins, BVetMed MS CertES Dip ECVS MRCVS', 'Position', [70, label_7.Position(2)-30, modalFigWidht, 20]);
    label_8.FontSize = 16;
    label_8.HorizontalAlignment = 'left';
    
    label_9 = uilabel(modalFig, 'Text', 'The Royal Veterinary College', 'Position', [70, label_8.Position(2)-20, modalFigWidht, 20]);
    label_9.FontSize = 14;
    label_9.HorizontalAlignment = 'left';
    
    label_10 = uilabel(modalFig, 'Text', 'Manual and current version available at:', 'Position', [20, label_9.Position(2)-40, modalFigWidht, 20]);
    label_10.FontSize = 16;
    label_10.FontWeight = 'bold';
    label_10.HorizontalAlignment = 'left';
    
    urlName = 'https://drive.google.com/drive/folders/1ZpQZU2xMfEPq2BbAiHYZUVx-WdxUNUDx?usp=share_link';
    hlinkDrive = uihyperlink(modalFig, 'Position', [70, label_10.Position(2)-20, modalFigWidht, 20]);
    hlinkDrive.FontSize = 16;
    hlinkDrive.Text = 'Google Drive to latest Version';
    hlinkDrive.URL = urlName;
    
    hlinkDrive2 = uihyperlink(modalFig, 'Position', [70, hlinkDrive.Position(2)-20, modalFigWidht, 20]);
    hlinkDrive2.FontSize = 12;
    hlinkDrive2.Text = urlName;
    hlinkDrive2.URL = urlName;
    
    [imgGD, mapPP, alphachannelPP] = imread('IconGoogleDrive.png');
    imgHW = 40;
    % Set the position of the axes for the image in the top right corner
    axGD=axes(modalFig,'Units', 'pixels', 'Position', [20, hlinkDrive.Position(2)-20, imgHW, imgHW],'Color','none');
    image(imgGD,'alphadata',im2double(alphachannelPP),'Parent',axGD);
    axis(axGD, 'off');
    axtoolbar(axGD,{});
    
    label_12 = uilabel(modalFig, 'Text', 'GitHub repository:', 'Position', [20, hlinkDrive2.Position(2)-40, modalFigWidht, 20]);
    label_12.FontSize = 16;
    label_12.FontWeight = 'bold';
    label_12.HorizontalAlignment = 'left';
    
    urlNameGit = 'https://github.com/Doppelweck/MuscleFiberClassificationTool';
    hlinkGit = uihyperlink(modalFig, 'Position', [70, label_12.Position(2)-20, modalFigWidht, 20]);
    hlinkGit.FontSize = 16;
    hlinkGit.Text = 'Github.com';
    hlinkGit.URL = urlNameGit;
    
    hlinkGit2 = uihyperlink(modalFig, 'Position', [70, hlinkGit.Position(2)-20, modalFigWidht, 20]);
    hlinkGit2.FontSize = 12;
    hlinkGit2.Text = urlNameGit;
    hlinkGit2.URL = urlNameGit;
    
    [imgGit, mapPP, alphachannelPP] = imread('IconGithub2.png');
    imgHW = 40;
    % Set the position of the axes for the image in the top right corner
    axGit=axes(modalFig,'Units', 'pixels', 'Position', [20, hlinkGit.Position(2)-20, imgHW, imgHW],'Color','none');
    image(imgGit,'alphadata',im2double(alphachannelPP),'Parent',axGit);
    axis(axGit, 'off');
    axtoolbar(axGit,{}); 
    
    label_13 = uilabel(modalFig, 'Text', 'PayPal donation:', 'Position', [20, hlinkGit2.Position(2)-40, modalFigWidht, 20]);
    label_13.FontSize = 16;
    label_13.FontWeight = 'bold';
    label_13.HorizontalAlignment = 'left';
    
    urlNamePayPal = 'paypal.me/sFriedrichSoftware';
    hlinkPP = uihyperlink(modalFig, 'Position', [70, label_13.Position(2)-20, modalFigWidht, 20]);
    hlinkPP.FontSize = 16;
    hlinkPP.Text = 'PayPal.com';
    hlinkPP.URL = urlNamePayPal;
    
    hlinkPP2 = uihyperlink(modalFig, 'Position', [70, hlinkPP.Position(2)-20, modalFigWidht, 20]);
    hlinkPP2.FontSize = 12;
    hlinkPP2.Text = urlNamePayPal;
    hlinkPP2.URL = urlNamePayPal;
    
    [imgPP, mapPP, alphachannelPP] = imread('IconPayPal2.png');
    imgHW = 40;
    % Set the position of the axes for the image in the top right corner
    axPP=axes(modalFig,'Units', 'pixels', 'Position', [20, hlinkPP.Position(2)-20, imgHW, imgHW],'Color','none');
    image(imgPP,'alphadata',im2double(alphachannelPP),'Parent',axPP);
    axis(axPP, 'off');
    axtoolbar(axPP,{}); 
    
    label_disclaimer = uilabel(modalFig, 'Text', ['This Appis provided free of charge for use on Windows and macOS platforms. ' ...
        'You can download the latest version from the Google Drive link above.'...
        'Additionally, the source code is available on GitHub.com. '...
        'Feel free to use and enjoy the software at your convenience. '...
        'If you find it valuable and would like to support further development, you have the option to make a donation. '...
        'Your contributions are greatly appreciated and help in enhancing the quality and features of this software. '...
        'However, donations are entirely voluntary, and users are under no obligation to contribute. '...
        'Thank you for using my App!']...
        ,'Position', [20, hlinkPP2.Position(2)-140, modalFigWidht-40, 120]);
    label_disclaimer.FontSize = 14;
    label_disclaimer.WordWrap = "on";
%     label_10.FontWeight = 'bold';
    label_disclaimer.HorizontalAlignment = 'left';
    
    figure(modalFig);
    set(modalFig,'WindowStyle','alwaysontop');
    set(modalFig, 'Resize', 'off');
    
    set(modalFig,'Visible','on');
    drawnow;
    
end