%Perimeter test
Radius = [];
PerimeterMATLAB = [];
PerimeterOWN = [];
PerimeterREAL = [];
ErrorPerimeterOWN = [];
ErrorPerimeterREAL = [];
ErrorPerimeterMATLAB = [];

ErrorAreaReal = [];
ErrorAreaOWN = [];

Area = [];
AreaReal = [];
AreaOWN = [];

for i=1:1:200
    PicBW = zeros(4*i,4*i);
    [imageSizeY imageSizeX]=size(PicBW);
    [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
    
    circlePixels = ((rowsInImage - double(2*i)).^2 + (columnsInImage - double(2*i)).^2 <= i.^2);
    PicBW = PicBW | circlePixels;
    [BoundarieMat,LabelMat] = bwboundaries(PicBW,8,'noholes');
    Stats = regionprops('struct',LabelMat,'Area','Centroid','BoundingBox','Perimeter');
%     figure
%     imshow(LabelMat,[])
    Radius(i)=i;
    PerimeterMATLAB(i) = Stats.Perimeter;
    
%     BW2 = zeros(size(LabelMat));
%     BW2(LabelMat==i)=1;
%     BW2 = padarray()
%     [B2,L2] = bwboundaries(BW,8,'noholes');
%     d2 = diff(BoundarieMat{1});
    
    
    d = diff(BoundarieMat{1});
    d = d.^2;
%     isCorner  = any(diff([d;d(1,:)]),2); % Count corners.
%     isEven    = any(~d,2);
    
    d(:,2)=d(:,2).*1;
    d(:,1)=d(:,1).*1;
    d = d.^2;
    
    
%     PerimeterOWN2(i) = sum(d(isEven))*0.980 + sum(d(~isEven))*1.406 - sum(d(isCorner))*0.091;
%     perimeter = sum(isEven)*0.980 + sum(~isEven)*1.406 - sum(isCorner)*0.091;
    PerimeterOWN(i) = sum(sqrt(sum(d,2))); 
    PerimeterREAL(i) = 2*pi*i;
    
    ErrorPerimeterOWN(i) = (PerimeterOWN(i)-PerimeterREAL(i))/PerimeterREAL(i)*100;
    ErrorPerimeterREAL(i) = (PerimeterREAL(i)-PerimeterREAL(i))/PerimeterREAL(i)*100;
    ErrorPerimeterMATLAB(i) = (PerimeterMATLAB(i)-PerimeterREAL(i))/PerimeterREAL(i)*100;
    
    AreaReal(i) = pi*i.^2;
    AreaOWN(i) = Stats.Area;
    
    ErrorAreaReal(i) = (AreaReal(i)-AreaReal(i))/AreaReal(i)*100;
    ErrorAreaOWN(i) = (AreaOWN(i)-AreaReal(i))/AreaReal(i)*100;
    
    workbar(i/200,'Please Wait...calculating perimeter','Permimeter',[]); 
end

meanErrorPeriOWN = round( mean(ErrorPerimeterOWN),3);
meanErrorPeriMATLAB = round( mean(ErrorPerimeterMATLAB),3);
meanErrorPeriREAL = round( mean(ErrorPerimeterREAL),3);

meanErrorAreaOWN = round( mean(ErrorAreaOWN) ,3);
meanErrorAreaREAL = round( mean(ErrorAreaReal) ,3);

% Perimeter
figure('Position',[825 612 500 350])
% axis for radius
% b=axes('Position',[.1 .1 .8 1e-12]);
% set(b,'Units','normalized');
% set(b,'Color','none');
% 
% % axis for area
% a=axes('Position',[.1 .2 .8 .69]);
% set(a,'Units','normalized');



plot(Radius,ErrorPerimeterREAL);
hold on
plot(Radius,ErrorPerimeterOWN);
hold on
plot(Radius,ErrorPerimeterMATLAB);
grid on
set(gca,'xtick',[0:20:max(Radius)])
set(gca,'FontSize',14)
% plot(b,AreaOWN,ErrorPerimeterREAL);
% set limits and labels
% set(a,'xlim',[0 max(Radius)]);
% set(b,'xlim',[0 max(AreaReal)]);
xlabel('Radius \it r \rm in pixel')
% xlabel(b,'Area (A) in pixel^2')

% xlabel('Radius (r) in pixel ','Fontsize', 20)
ylabel('Error \itE \rm in %')
string={['REAL'],['APP (mean Error: ' num2str(meanErrorPeriOWN) ' %)'],['MATLAB (mean Error: ' num2str(meanErrorPeriMATLAB) ' %)']};
legend(string,'Fontsize', 14)
title('Error Perimeter')

% Area %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Position',[825 612 500 350])
% axis for radius
% b=axes('Position',[.1 .1 .8 1e-12]);
% set(b,'Units','normalized');
% set(b,'Color','none');
% 
% % axis for area
% a=axes('Position',[.1 .2 .8 .7]);
% set(a,'Units','normalized');

plot(Radius,ErrorAreaReal,'LineWidth',1);
hold on
plot(Radius,ErrorAreaOWN,'LineWidth',1);
grid on
set(gca,'FontSize',14)

set(gca,'xtick',[0:20:max(Radius)])
% set limits and labels
% set('xlim',[3 max(Radius)]);
% set(b,'xlim',[0 max(AreaOWN)]);
xlabel('Radius \itr \rmin pixel')
% xlabel(b,'Area (A) in pixel^2')

ylabel('Error \itE \rm in %')
string={['REAL'],['APP (mean Error: ' num2str(meanErrorAreaOWN) ' %)']};
legend(string,'Fontsize', 14)
title('Error Area')








