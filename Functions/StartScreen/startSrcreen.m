function hf = startSrcreen()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Pic = imread('StartScreen3.jpg');
[m n]= size(Pic);
hf  = figure('Visible','off','MenuBar','none','NumberTitle','off',...
    'WindowStyle','normal','Units','pixels');
ha = axes('Parent',hf,'Visible','on','Units','pixels');
axis image
% Pic = imread('StartScreen.png');
set(ha, 'LooseInset', [0,0,0,0]);
ih = imshow(Pic);
imxpos = get(ih,'XData');
imypos = get(ih,'YData');
figpos = get(hf,'Position');
figpos(3:4) = [imxpos(2) imypos(2)];
set(ha,'Unit','Normalized','Position',[0,0,1,1]);
set(hf, 'Units','pixels');
set(hf,'Position',figpos);
movegui(hf,'center');
set(hf,'CloseRequestFcn','');
set(hf,'Visible','on');
set(hf,'WindowStyle','normal');

end

