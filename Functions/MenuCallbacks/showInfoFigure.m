function showInfoFigure(mainFigObj)

width = 640; height = 600;
    
    % Create a modal figure
    modalFig = uifigure('Name', 'App Information', 'NumberTitle', 'off', 'WindowStyle', 'normal');
    modalFig.Position(3) = width;
    modalFig.Position(4) = height;
    get(mainFigObj,'Position')
    set(mainFigObj,'units','pixel')
    Pix_SS = get(mainFigObj,'Position');
    set(mainFigObj,'units','normalized')
    get(mainFigObj,'Position')
    modalFigWidht = modalFig.Position(3);
    modalFigHeight = modalFig.Position(4);
    
    set(modalFig,'Position', [(Pix_SS(3)-width)/2 (Pix_SS(4)-height)/2 width height])
    
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
    label_1.FontSize = 20;
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
    
    label_4 = uilabel(modalFig, 'Text', 'Sebastian Friedrich, BEng', 'Position', [60, label_3.Position(2)-20, modalFigWidht, 20]);
    label_4.FontSize = 16;
    label_4.HorizontalAlignment = 'left';
    
    hlinkMail = uihyperlink(modalFig, 'Position', [60, label_4.Position(2)-20, modalFigWidht, 20]);
    email = 'sebastian.friedrich.software@gmail.com';
    hlinkMail.FontSize = 16;
    hlinkMail.Text = email;
    hlinkMail.URL = ['mailto:' email];
    
    label_5 = uilabel(modalFig, 'Text', 'With the help of:', 'Position', [20, hlinkMail.Position(2)-40, modalFigWidht, 20]);
    label_5.FontSize = 16;
    label_5.FontWeight = 'bold';
    label_5.HorizontalAlignment = 'left';
    
    label_6 = uilabel(modalFig, 'Text', 'David Goodwin, BSc', 'Position', [60, label_5.Position(2)-20, modalFigWidht, 20]);
    label_6.FontSize = 16;
    label_6.HorizontalAlignment = 'left';
    
    label_7 = uilabel(modalFig, 'Text', 'The Royal Veterinary College', 'Position', [60, label_6.Position(2)-20, modalFigWidht, 20]);
    label_7.FontSize = 16;
    label_7.HorizontalAlignment = 'left';
    
    label_8 = uilabel(modalFig, 'Text', 'Justin Perkins, BVetMed MS CertES Dip ECVS MRCVS', 'Position', [60, label_7.Position(2)-30, modalFigWidht, 20]);
    label_8.FontSize = 16;
    label_8.HorizontalAlignment = 'left';
    
    label_9 = uilabel(modalFig, 'Text', 'The Royal Veterinary College', 'Position', [60, label_8.Position(2)-20, modalFigWidht, 20]);
    label_9.FontSize = 16;
    label_9.HorizontalAlignment = 'left';
    
    label_10 = uilabel(modalFig, 'Text', 'Manual and Current Version available at:', 'Position', [20, label_9.Position(2)-40, modalFigWidht, 20]);
    label_10.FontSize = 16;
    label_10.FontWeight = 'bold';
    label_10.HorizontalAlignment = 'left';
    
    urlName = 'sebastian.friedrich.software@gmail.com';
    hlinkDrive = uihyperlink(modalFig, 'Position', [60, label_10.Position(2)-20, modalFigWidht, 20]);
    hlinkDrive.FontSize = 16;
    hlinkDrive.Text = 'Google Drive';
    hlinkDrive.URL = urlName;
    



    figure(modalFig);
    set(modalFig,'WindowStyle','alwaysontop');
    set(modalFig, 'Resize', 'off');
    
end