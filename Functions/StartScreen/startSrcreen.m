function hf = startSrcreen( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

hf  = figure('Visible','off','MenuBar','none','NumberTitle','off','WindowStyle','modal');
ah = axes('Parent',hf,'Visible','off');
Pic = imread('StartScreen.png');
ih = imshow(Pic);
imxpos = get(ih,'XData');
imypos = get(ih,'YData');
figpos = get(hf,'Position');
figpos(3:4) = [imxpos(2) imypos(2)];
set(ah,'Unit','Normalized','Position',[0,0,1,1]);
set(hf,'Position',figpos);
movegui(hf,'center');
set(hf,'Visible','on');
set(hf,'WindowStyle','normal');
end

