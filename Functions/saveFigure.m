function saveFigure(h,outfilename)

set(h, 'units', 'centimeters');
 Pos=get(h, 'position');
 width =Pos(3);
 height= Pos(4);
set(h,'PaperUnits','centimeters');
set(h,'PaperSize', [width height]);
set(h,'PaperPositionMode', 'manual');
set(h,'PaperPosition',[0 0 width height]);

saveas(h,outfilename);
end