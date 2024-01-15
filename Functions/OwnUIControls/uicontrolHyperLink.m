function h=uicontrolHyperLink(parentFig,position,units,fontsize,text,url)

%Position [70, label_4.Position(2)-20, modalFigWidht, 20]
iptPointerManager(parentFig, 'enable');
textUnderline = ['<html><u>' text '</u></html>'];
hlink = uicontrol('Style', 'pushbutton', 'Parent', parentFig,'FontUnits',units,'Units',units,'Position', position, 'String', textUnderline, 'ForegroundColor', [0 0 1], 'FontWeight', 'bold');
set(hlink,'Enable' ,'Inactive', 'FontSize', fontsize);

jh = findjobj(hlink);
jh.setHorizontalAlignment(javax.swing.JLabel.LEFT)
jh.setBorderPainted(false);    
jh.setContentAreaFilled(false);

if contains(url,'@')
    urlName = ['mailto:',url];
    set(hlink,'ButtonDownFcn', @(~,~)web(urlName));
else
    urlName = url;
    set(hlink,'ButtonDownFcn', @(~,~)web(urlName));
end

iptSetPointerBehavior(hlink, @(parentFig, currentPoint)set(parentFig, 'Pointer', 'hand'));
h=hlink;
    
end 