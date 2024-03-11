function h = uicontrolHyperLink(parentFig,position,units,fontsize,text,url)
%% Creates Hyperlink for figure objects (no uifigure needed)
% 
% Requiers:     findjobj - find java handles of Matlab graphic objects
%               Yair Altman (2024). findjobj - find java handles of Matlab graphic objects 
%               (https://www.mathworks.com/matlabcentral/fileexchange/14317-findjobj-find-java-handles-of-matlab-graphic-objects), 
%               MATLAB Central File Exchange. Retrieved January 15, 2024.
% 
% SYNTAX:       h = uicontrolHyperLink(Parent,Position,Units,Fontsize,Text,URL);
% 
% INPUT parameters:
%               Parent      - Parent object, specified as a Figure, Panel, ButtonGroup, or Tab object. 
%                             Use this property to specify the parent container when creating a UI component 
%                             or to move an existing UI component to a different parent container.
%               Position    - Location and size, specified as a four-element vector of the form [left bottom width height]. 
%                             Default measurement units are in pixels.
%               Units       - Units of measurement and Font, specified as one of the values
%                             'points' | 'normalized' | 'inches' | 'centimeters' | 'pixels'
%               Fontsize    - Font size of Text, specified as a positive number. The Units property specifies the units. 
%               Text        - String that is shown as a hyperlink
%               URL         - URL of the Hyperlink. Opens a new tab in the default
%                             Browser and enters URL. If URL contains '@' then th default
%                             E-Mail program will be opend.
% 
% OUTPUT parameters: 
%               h           - handle to uicontrol element (Style pushbutton)
% 
% EXAMPLES:     url = 'https://drive.google.de';
%               text = 'Google Website';
%               hlinkDrive  = uicontrolHyperLink(figureHandle,[70, 370, 110, 20],'pixels',16,text,url);
% 
% PROGRAMMED by Sebastian Friedrich: sebastian.friedrich.software(at)gmail.com
% $Revision: 1.0 $  $Date: 2024/01/15 $
%%
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