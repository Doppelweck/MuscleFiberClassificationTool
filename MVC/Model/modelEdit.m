classdef modelEdit < handle
    %UNTITLED6 Summary of this class goes here
    %   Detailed explanation goes here7
    
    
    properties
        %Handle to other Classes
        controllerEditHandle
    end
    
    properties(SetObservable)
        FileNamesRGB
        PathNames
        PicRGB
        PicBW
        handlePicRGB
        handlePicBW
        PicPlane1
        PicPlane2
        PicPlane3
        PicPlane4
        PicPlaneGreen
        PicPlaneBlue
        PicPlaneRed
        PicPlaneFarRed
        PicRGBPlanes
        PicPlaneGreen_adj
        PicPlaneBlue_adj
        PicPlaneRed_adj
        PicPlaneFarRed_adj
        PicA4
        PicL5
        PicTX
        PicY5
        
        PicBWisInvert = 'false';
        
        ThresholdMode;
        ThresholdValue;
        AlphaMapValue;
        LineWidthValue = 1;
        ColorValue = 1;
        
        InfoMessage
        
        PicBufferPointer = 1;
        BufferSize = 100;
        PicBuffer
        
        morphOP = '';
        SE = '';
        SizeSE = 1;
        NoIteration = 1;
        
        x1
        x2
        y1
        y2
        x_v
        y_v
        dx
        dy
        abs_dx
        abs_dy
        dist
        m
        b
        xValues
        yValues
        index
        
        
    end
    
  
    
    methods
        
        
        
        
        function obj = modelEdit()
            obj.addMyListener();
            %             obj.PicBuffer = cell(1,obj.BufferSize);
        end
        
        
        function addMyListener(obj)
            
            addlistener(obj,'ThresholdValue' ,'PostSet',@obj.createBinary);
            addlistener(obj,'ThresholdMode' ,'PostSet',@obj.createBinary);
            addlistener(obj,'AlphaMapValue' ,'PostSet',@obj.alphaMapEvent);
            %             addlistener(obj,'LineWidthValue' ,'PostSet',@obj.lineWidthEvent);
        end
        
        function clearPicData(obj)
            obj.InfoMessage = '- clear all picture data';
            
            obj.FileNamesRGB = '';
            obj.PathNames = '';
            obj.PicRGB = [];
            obj.PicBW = [];
            obj.handlePicRGB.CData = [];
            obj.handlePicBW.CData = [];
            obj.PicPlane1 = [];
            obj.PicPlane2 = [];
            obj.PicPlane3 = [];
            obj.PicPlane4 = [];
            obj.PicPlaneGreen = [];
            obj.PicPlaneBlue = [];
            obj.PicPlaneRed = [];
            obj.PicPlaneFarRed = [];
            obj.PicRGBPlanes = [];
            obj.PicPlaneGreen_adj = [];
            obj.PicPlaneBlue_adj = [];
            obj.PicPlaneRed_adj = [];
            obj.PicPlaneFarRed_adj = [];
            obj.PicA4 = [];
            obj.PicL5 = [];
            obj.PicTX = [];
            obj.PicY5 = [];
            obj.PicBuffer = cell(1,obj.BufferSize);
            obj.PicBufferPointer = 1;
        end
        
        function PicData = sendPicsToController(obj)
            PicData{1} = obj.FileNamesRGB;
            PicData{2} = obj.PathNames;
            PicData{3} = obj.PicRGB;   %RGB
            
            if strcmp(obj.PicBWisInvert,'true')
                PicData{4} = ~obj.handlePicBW.CData;    %BW
            else
                PicData{4} = obj.handlePicBW.CData;
            end
            
            PicData{5} = obj.PicPlaneGreen;
            PicData{6} = obj.PicPlaneBlue;
            PicData{7} = obj.PicPlaneRed;
            PicData{8} = obj.PicPlaneFarRed;
            PicData{9} = obj.PicRGBPlanes;
        end
        
        function succses = openNewPic(obj)
            [tempFileNamesRGB,tempPathNames] = uigetfile('*.tif','Select the image','MultiSelect', 'off');
            
              if isequal(tempFileNamesRGB ,0) && isequal(tempPathNames,0)
                obj.InfoMessage = '   - open image canceled';
                succses = false;
              else
                  % clear old Pic Data if a new one is selected
                obj.clearPicData();
                obj.FileNamesRGB = tempFileNamesRGB;
                obj.PathNames = tempPathNames;
                succses = true;
              end
        end
        
        function sucsess = loadPics(obj)
            %UNTITLED Summary of this function goes here
            %   Detailed explanation goes here
            
            obj.InfoMessage = '   - open image';
            obj.InfoMessage = ['      - ' obj.FileNamesRGB ' was selected'];
            
            obj.InfoMessage = '   - searching for color plane images';
            
            LFN = length(obj.FileNamesRGB);
            FileNamesZIV = obj.FileNamesRGB;
            FileNamesZIV(LFN)='i';
            FileNamesZIV(LFN-1)='v';
            FileNamesZIV(LFN-2)='z';
            
            if exist([obj.PathNames FileNamesZIV], 'file') == 2
                obj.InfoMessage = '      - loading color plane images';
                
                reader = bfGetReader([obj.PathNames FileNamesZIV]);
                
                obj.PicRGB = imread([obj.PathNames, obj.FileNamesRGB]);
                
                obj.PicPlane1 = bfGetPlane(reader,1);
                obj.PicPlane2 = bfGetPlane(reader,2);
                obj.PicPlane3 = bfGetPlane(reader,3);
                obj.PicPlane4 = bfGetPlane(reader,4);
                
                % Searching for brightness adjustment Pics
                obj.InfoMessage = '      - searching for brightness adjustment Pics';
                
                currentFolder = pwd;
                cd(obj.PathNames);
                
                FileNamePicA4 = dir('A4*.zvi');
                FileNamePicL5 = dir('L5*.zvi');
                FileNamePicTX = dir('TX*.zvi');
                FileNamePicY5 = dir('Y5*.zvi');
                
                cd(currentFolder);
                if ~isempty(FileNamePicA4) && ~isempty(FileNamePicL5) && ~isempty(FileNamePicTX) && ~isempty(FileNamePicY5)
                    
                    readertemp = bfGetReader([obj.PathNames FileNamePicA4(1).name]);
                    obj.PicA4 = bfGetPlane(readertemp,1);
                    obj.InfoMessage = ['      - ' FileNamePicA4(1).name ' were found'];
                    pause(0.01);
                    
                    readertemp = bfGetReader([obj.PathNames FileNamePicL5(1).name]);
                    obj.PicL5 = bfGetPlane(readertemp,1);
                    obj.InfoMessage = ['      - ' FileNamePicL5(1).name ' were found'];
                    pause(0.01);
                    
                    readertemp = bfGetReader([obj.PathNames FileNamePicTX(1).name]);
                    obj.PicTX = bfGetPlane(readertemp,1);
                    obj.InfoMessage = ['      - ' FileNamePicTX(1).name ' were found'];
                    pause(0.01);
                    
                    readertemp = bfGetReader([obj.PathNames FileNamePicY5(1).name]);
                    obj.PicY5 = bfGetPlane(readertemp,1);
                    obj.InfoMessage = ['      - ' FileNamePicY5(1).name ' were found'];
                    pause(0.01);
                    
                else
                    
                    obj.InfoMessage = '      - no brightness pictures were found';
                    obj.PicA4 = [];
                    obj.PicL5 = [];
                    obj.PicTX = [];
                    obj.PicY5 = [];
                    
                end
                
                cd(currentFolder);
                
                sucsess = true;
            else
                obj.InfoMessage = '   - Error color plane pictures';
                obj.InfoMessage = '      - color plane pictures (.zvi file) not found';
                obj.InfoMessage = ['      - ' FileNamesZIV ' dont exist'];
                obj.InfoMessage = ['      - ' FileNamesZIV ' must be in the same path as the selected RGB.tif image'];
                
                sucsess = false;
            end
        end
        
        function planeIdentifier(obj)
            if isequal(obj.FileNamesRGB ,0) && isequal(obj.PathNames,0)
                obj.InfoMessage = '   - indentifing planes canceled';
            else
                obj.InfoMessage = '   - indentifing planes';
                
                Pic= cat(3,obj.PicPlane1 ,obj.PicPlane2 ,obj.PicPlane3 ,obj.PicPlane4 );
                
                PicHSV = rgb2hsv(obj.PicRGB);
                PicHSV_H = PicHSV(:,:,1); % H CHannel
                PicMean = [];
                
                for i=1:1:length(Pic(1,1,:))
                    PicBW(:,:,i) = im2bw(Pic(:,:,i),graythresh(Pic(:,:,i)));
                    PicBW(:,:,i) = bwmorph(PicBW(:,:,i),'majority');
                    PicMean(i,:) =[ mean(mean(PicHSV_H(PicBW(:,:,i) == 1))) i];
                end
                
                b=sortrows(PicMean);
                
                R=imadjust( obj.PicRGB(:,:,1) );
                G=imadjust( obj.PicRGB(:,:,2) );
                B=imadjust( obj.PicRGB(:,:,3) );
                
                PicRGB_P = cat(3,R, G, B);
                
                PicAnalyzed = cat( 3 , zeros(size(G),'uint8') , zeros(size(B),'uint8') , zeros(size(R),'uint8') , zeros(size(R),'uint8') );
                r=[];
                rf=[];
                for i=1:1:length(PicRGB_P(1,1,:))
                    % i = 1 search for Green Plane
                    % i = 2 search for Blue Plane
                    % i = 3 search for Red Plane

                    for j=1:1:length(Pic(1,1,:))
                        % correlation between R G B Planes and unknown Planes
                        % r contains correlation coefficients
                        r(j,i) = corr2(PicRGB_P(:,:,i) , Pic(:,:,j));
                    end
                    
                end
                
                tempR = [];
                tempFR=[];
                tempG=[];
                tempB=[];
                for i=1:1:4
                    [plane color] = ind2sub( size(r) , find( r==max(max(r)) ) );
                    
                    switch color
                        
                        case 1  %Red and FarRed
                            
                            if isempty(tempR)
                                tempR = Pic(:,:,plane);
                                r(plane,:) = [];
                                Pic(:,:,plane) = [];
                                obj.InfoMessage = '      - red-plane was identified';
                            else
                                tempFR = Pic(:,:,plane);
                                r(plane,:) = [];
                                Pic(:,:,plane) = [];
                                r(:,color) = 0;
                                obj.InfoMessage = '      - farred-plane was identified';
                            end
                            
                        case 2  %Green
                            
                            tempG = Pic(:,:,plane);
                            r(plane,:) = [];
                            r(:,color) = 0;
                            Pic(:,:,plane) = [];
                            obj.InfoMessage = '      - green-plane was identified';
                            
                        case 3  %Blue
                            
                            tempB = Pic(:,:,plane);
                            r(plane,:) = [];
                            r(:,color) = 0;
                            Pic(:,:,plane) = [];
                            obj.InfoMessage = '      - blue-plane was identified';
                    end
                end
                
                obj.PicPlaneGreen = tempG;
                obj.PicPlaneBlue = tempB;
                obj.PicPlaneRed = tempR;
                obj.PicPlaneFarRed = tempFR;
                
                obj.PicRGBPlanes(:,:,1) = tempR;
                obj.PicRGBPlanes(:,:,2) = tempG;
                obj.PicRGBPlanes(:,:,3) = tempB;
                
                obj.PicRGBPlanes = uint8(obj.PicRGBPlanes);
                

            end
        end
        
        function brightnessAdjustment(obj)
            obj.InfoMessage = '   - brightness adjustment';
            if isequal(obj.FileNamesRGB ,0) && isequal(obj.PathNames,0)
                obj.InfoMessage = '   - pictures brightness adjustment canceled';
            else
                if ~isempty(obj.PicL5)
                    Mat1 = zeros(size(obj.PicRGB));
                    Mat1 = double(obj.PicPlaneGreen)./double(obj.PicL5);
                    Mat1 = uint8(Mat1./max(max(Mat1)).*255);
                    obj.PicPlaneGreen_adj = imadjust(Mat1);
                    obj.InfoMessage = '      - adjust green plane';
                else
                    obj.InfoMessage = '      - PicL5 not found';
                    obj.PicPlaneGreen_adj = imadjust(obj.PicPlaneGreen);
                end
                
                if ~isempty(obj.PicTX)
                    Mat2 = double(obj.PicPlaneRed)./double(obj.PicTX);
                    Mat2 = uint8(Mat2./max(max(Mat2)).*255);
                    obj.PicPlaneRed_adj = imadjust(Mat2);
                    obj.InfoMessage = '      - adjust red plane';
                else
                    obj.InfoMessage = '      - PicTX not found';
                    obj.PicPlaneRed_adj = imadjust(obj.PicPlaneRed);
                end
                
                if ~isempty(obj.PicA4)
                    Mat3 = double(obj.PicPlaneBlue)./double(obj.PicA4);
                    Mat3 = uint8(Mat3./max(max(Mat3)).*255);
                    obj.PicPlaneBlue_adj = imadjust(Mat3);
                    obj.InfoMessage = '      - adjust blue plane';
                else
                    obj.InfoMessage = '      - PicA4 not found';
                    obj.PicPlaneBlue_adj = imadjust(obj.PicPlaneBlue);
                end
                
                obj.PicPlaneFarRed_adj = imadjust(obj.PicPlaneFarRed);
            end
            obj.InfoMessage = '- opening images completed';
        end
        
        function createBinary(obj,src,evnt)
            
            thresh = obj.ThresholdValue;
            
            if ~isempty(obj.PicPlaneGreen_adj)
                % Picture was choosen by User. 
                if strcmp (obj.PicBWisInvert , 'false')
                    % Binary pictur is not invert
                    switch obj.ThresholdMode
                        
                        case 1 % Use manual global threshold for binarization
                            
                            obj.PicBW = im2bw(obj.PicPlaneGreen_adj,thresh);
                            obj.handlePicBW.CData = obj.PicBW;
                    
                        case 2 % Use automatic adaptive threshold for binarization
                            
                            obj.PicBW = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
                            obj.handlePicBW.CData = obj.PicBW;
                            
                        case 3 % Use automatic adaptive and manual global threshold for binarization
                            
                            PicBW1 = im2bw(obj.PicPlaneGreen_adj,thresh);
                            PicBW2 = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
                            obj.PicBW = PicBW1 | PicBW2;
                            obj.handlePicBW.CData = obj.PicBW;
                            
                    end
                else
                    % Binary pictur is invert
                     switch obj.ThresholdMode
                        
                        case 1 % Use manual global threshold for binarization
                            
%                             temp = obj.PicPlaneGreen_adj;
                            temp = im2bw(obj.PicPlaneGreen_adj,thresh);
                            obj.PicBW = ~temp;
                            obj.handlePicBW.CData = obj.PicBW;
                    
                        case 2 % Use automatic adaptive threshold for binarization
                            
%                             temp = obj.PicPlaneGreen_adj;
                            temp = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
                            obj.PicBW = ~temp;
                            obj.handlePicBW.CData = obj.PicBW;
                            
                        case 3 % Use automatic adaptive and manual global threshold for binarization
                            
                            temp1 = im2bw(obj.PicPlaneGreen_adj,thresh);
                            temp2 = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
                            obj.PicBW = ~(temp1 | temp2);
                            obj.handlePicBW.CData = obj.PicBW;
                            
                    end
                    
                end
            end
        end
        
%         function [PicRGB PicBW] = setInitPicsGUI(obj)
%             PicRGB = obj.PicRGB;
%             PicBW = obj.PicBW;
%         end
        
        function alphaMapEvent(obj,src,evnt)
            
            if ~isempty(obj.handlePicBW)
                alphaMat = obj.AlphaMapValue*ones(size(obj.PicBW));
                set(obj.handlePicBW,'AlphaData',alphaMat);
               
            end
        end
        
        function invertPicBWEvent(obj)
            obj.InfoMessage = '   - Binarization operation';
            
            if strcmp(obj.PicBWisInvert,'true')
                obj.PicBWisInvert = 'false';
                obj.InfoMessage = '      - Picture is displayed in normal form';
            else
                obj.PicBWisInvert = 'true';
                obj.InfoMessage = '      - Picture is displayed in inverted form';
            end
            
            
            obj.handlePicBW.CData = ~obj.handlePicBW.CData;
            
            obj.addToBuffer();
        end
        
        function startDragFcn(obj,CurPos)
            
            obj.x1 = int16(CurPos(1,1));
            
            obj.y1 = int16(CurPos(1,2));
            
            [imageSizeY imageSizeX]=size(obj.PicBW);
            [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
            radius = obj.LineWidthValue;
            if obj.ColorValue;
                % create white circle
                circlePixels = ((rowsInImage - double(obj.y1)).^2 + (columnsInImage - double(obj.x1)).^2 <= radius.^2);
                obj.handlePicBW.CData = obj.handlePicBW.CData | circlePixels;
            else
                % create black circle
                circlePixels = ~((rowsInImage - double(obj.y1)).^2 + (columnsInImage - double(obj.x1)).^2 <= radius.^2);
                obj.handlePicBW.CData = obj.handlePicBW.CData & circlePixels;
            end
            
            %             obj.handlePicBW.CData(obj.y1,obj.x1)=obj.ColorValue;
        end
        
        function DragFcn(obj,CurPos)
            %           profile on
            obj.x2 = double(CurPos(1,1));
            obj.y2 = double(CurPos(1,2));
            
            %             [obj.x2 obj.y2] = obj.checkPosition(obj.x2,obj.y2);
            
            [imageSizeY imageSizeX]=size(obj.PicBW);
            [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
            radius = obj.LineWidthValue;
            if obj.ColorValue;
                % create white circle
                circlePixels = (rowsInImage - double(obj.y2)).^2 + (columnsInImage - double(obj.x2)).^2 <= radius.^2;
                obj.handlePicBW.CData = obj.handlePicBW.CData | circlePixels;
            else
                % create black circle
                circlePixels = ~((rowsInImage - double(obj.y2)).^2 + (columnsInImage - double(obj.x2)).^2 <= radius.^2);
                obj.handlePicBW.CData = obj.handlePicBW.CData & circlePixels;
            end
            
            obj.dx = double(obj.x1)-obj.x2;
            obj.dy = double(obj.y1)-obj.y2;
            obj.abs_dx = abs(obj.dx);
            obj.abs_dy = abs(obj.dy);
            
            obj.dist = sqrt((obj.abs_dx)^2+(obj.abs_dy)^2);
            
            obj.x_v = double( sort([obj.x1 obj.x2]) );
            obj.y_v = double( sort([obj.y1 obj.y2]) );
            
            obj.m=double(obj.dy/obj.dx);
            obj.b = double(obj.y1)-obj.m*double(obj.x1);
            
            %             LineWidthValue = obj.LineWidthValue - 1;
            
            xMax = double(size(obj.PicBW,2));
            yMax = double(size(obj.PicBW,1));
            
            if obj.dx == 0
                for i=-obj.LineWidthValue:1:obj.LineWidthValue
                    obj.xValues = (double(obj.x_v(1))+i)*ones(1, int32(obj.dist*2));
                    obj.xValues(obj.xValues<1)=double(1);
                    obj.xValues(obj.xValues>xMax)=xMax;
                    
                    obj.yValues = linspace(obj.y_v(1),obj.y_v(2),int32(obj.dist*2));
                    obj.yValues(obj.yValues<1)=double(1);
                    obj.yValues(obj.yValues>yMax)=yMax;
                    
                    obj.index = sub2ind(size(obj.handlePicBW.CData),round(obj.yValues),round(obj.xValues));
                    obj.handlePicBW.CData(obj.index) = obj.ColorValue;
                end
            elseif obj.abs_dx >= obj.abs_dy
                for i=-obj.LineWidthValue:1:obj.LineWidthValue
                    obj.xValues = linspace(obj.x_v(1),obj.x_v(2),int32(obj.dist*2));
                    obj.yValues = obj.m*obj.xValues+obj.b+i;
                    obj.xValues(obj.xValues<1)=double(1);
                    obj.xValues(obj.xValues>xMax)=xMax;
                    obj.yValues(obj.yValues<1)=double(1);
                    obj.yValues(obj.yValues>yMax)=yMax;
                    obj.index = sub2ind(size(obj.handlePicBW.CData),round(obj.yValues),round(obj.xValues));
                    obj.handlePicBW.CData(obj.index) = obj.ColorValue;
                end
            elseif obj.abs_dy > obj.abs_dx
                for i=-obj.LineWidthValue:1:obj.LineWidthValue
                    obj.yValues = linspace(obj.y_v(1),obj.y_v(2),int32(obj.dist*2));
                    obj.xValues = ((obj.yValues-obj.b)/obj.m)+i;
                    obj.xValues(obj.xValues<1)=double(1);
                    obj.xValues(obj.xValues>xMax)=xMax;
                    obj.yValues(obj.yValues<1)=double(1);
                    obj.yValues(obj.yValues>yMax)=yMax;
                    obj.index = sub2ind(size(obj.handlePicBW.CData),round(obj.yValues),round(obj.xValues));
                    obj.handlePicBW.CData(obj.index) = obj.ColorValue;
                end
            end
            
            obj.x1 = obj.x2;
            obj.y1 = obj.y2;
            
        end
        
        function runMorphOperation(obj)
            
            obj.InfoMessage = '   - Run morpholigical operation';
            pause(0.01)
            
            switch obj.morphOP
                
                case 'erode'
                    
                    se = strel(obj.SE,obj.SizeSE);
                    for i=1:1:obj.NoIteration
                        obj.handlePicBW.CData = imerode(obj.handlePicBW.CData,se);
                    end
                    
                case 'dilate'
                    
                    se = strel(obj.SE,obj.SizeSE);
                    for i=1:1:obj.NoIteration
                        obj.handlePicBW.CData = imdilate(obj.handlePicBW.CData , se);
                    end
                    
                case 'skel'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'skel',Inf);
%                     se = strel('disk',1);
%                     obj.handlePicBW.CData = imdilate(obj.handlePicBW.CData, se);
                    
                case 'thin'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'thin',obj.NoIteration);
                    
                case 'open'
                    
                    
                case 'remove'
                    
                case 'shrink'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'shrink',obj.NoIteration);
                    
                case 'majority'
                    
                    for i=1:1:obj.NoIteration
                        obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'majority');
                    end
                    
                case 'edge smoothing'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'majority',Inf);
                    obj.InfoMessage = '      - edge smoothing completed';
                    pause(0.01)
                    
                case 'close small gaps'
                    
                    obj.InfoMessage = ['      - closing small gaps with a size of ' num2str(obj.NoIteration) ' pixels'];
                    pause(0.01)
                                        if strcmp(obj.PicBWisInvert,'true')
                                            tempPic = ~obj.handlePicBW.CData;    %BW
                                        else
                                            tempPic = obj.handlePicBW.CData;
                                        end
                    
                    
                                        se = strel('disk',1);
                                        
                                        for i = 1:1:round(obj.NoIteration/2)
                                        
                                        tempPic = imdilate(tempPic , se);

                                        end
                                        

                                        tempPic = bwmorph(tempPic,'skel',Inf);
                                        tempPic = imdilate(tempPic , se);
                                        tempPic = bwmorph(tempPic,'majority',Inf);

                                        if strcmp(obj.PicBWisInvert,'true')
                                            obj.handlePicBW.CData = ~(~obj.handlePicBW.CData | tempPic);    %BW
                                        else
                                            obj.handlePicBW.CData = obj.handlePicBW.CData | tempPic;
                                        end
                    
                    
%                                         obj.handlePicBW.CData = obj.handlePicBW.CData | tempPic;
                                        
                                        obj.InfoMessage = '      - closing gaps complete';
                otherwise
                    
            end
            
            obj.addToBuffer();
        end
        
        function stopDragFcn(obj)
            obj.addToBuffer();
        end
        
        function [xOut yOut] = checkPosition(obj,PosX,PosY)
            
            if PosX < 1
                PosX = 1;
            end
            
            if PosY < 1
                PosY = 1;
            end
            
            if PosX > size(obj.PicRGB,2)
                PosX = size(obj.PicRGB,2);
            end
            
            if PosY > size(obj.PicRGB,1)
                PosY = size(obj.PicRGB,1);
            end
            
            xOut = PosX;
            yOut = PosY;
        end
        
        function undo(obj)
            if obj.PicBufferPointer > 1 && obj.PicBufferPointer <= obj.BufferSize
                obj.PicBufferPointer = obj.PicBufferPointer-1;
                obj.handlePicBW.CData = obj.PicBuffer{1,obj.PicBufferPointer};
                
            end
        end
        
        function redo(obj)
            if obj.PicBufferPointer >= 1 && obj.PicBufferPointer < obj.BufferSize && obj.PicBufferPointer < size(obj.PicBuffer,2)
                obj.PicBufferPointer = obj.PicBufferPointer+1;
                obj.handlePicBW.CData = obj.PicBuffer{1,obj.PicBufferPointer};
                
            end
        end
        
%         function closeGabs(obj)
%             
%             imSkel = bwmorph(obj.handlePicBW.CData,'skel',Inf);
%             EndPoints = find_skel_ends(imSkel)
%             
%             [imageSizeY imageSizeX]=size(obj.PicBW);
%             [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
%             
%             radius = obj.NoIteration;
%             
%             for j=1:1:length(EndPoints)
%                 workbar(j/length(EndPoints),'Gab','Gab');
%                 % Check if second Object is in the max Raduis
%                 circlePixels = ((rowsInImage - double(EndPoints(j,2))).^2 + (columnsInImage - double(EndPoints(j,1))).^2 <= radius.^2);
%                 detectionArea = circlePixels & obj.handlePicBW.CData;
%                 [BoundarieMat LabelMat] = bwboundaries(detectionArea,4);
%                 NoObjCircle = max(max(LabelMat));
%                 
%                 if NoObjCircle == 0
%                     % Error
%                 elseif NoObjCircle == 1
%                     % NO second object near by the end of skeleton
%                 elseif NoObjCircle == 2
%                     % second object near by
%                     stats = regionprops('struct',LabelMat,'Centroid');
%                     
%                     % Find the Object thats the center of the cirle search
%                     % area
%                     LabelCenter = LabelMat(EndPoints(j,2),EndPoints(j,1));
%                     % Delete that Object in the stats struct
%                     stats(LabelCenter) = [];
%                     
%                     center = stats(1).Centroid;
%                     
%                     dx = center(1)-EndPoints(j,1);
%                     dy = center(2)-EndPoints(j,2);
%                     dist = sqrt(dx^2+dy^2);
%                     
%                     if dx == 0
%                         xValues = EndPoints(j,1)*ones(1, int32(dist*3));
%                         yValues = linspace(EndPoints(j,2),center(2),int32(dist*3));
%                         index = sub2ind(size(obj.handlePicBW.CData),round(yValues),round(xValues));
%                         obj.handlePicBW.CData(index) = 1;
%                     else
%                         xValues = linspace(EndPoints(j,1),center(1),int32(dist*3));
%                         m = double(dy/dx);
%                         b = double(center(2))-m*double(center(1));
%                         yValues = m*xValues+b;
%                         index = sub2ind(size(obj.handlePicBW.CData),round(yValues),round(xValues));
%                         obj.handlePicBW.CData(index) = 1;
%                     end
%                     
%                 elseif NoObjCircle > 2
%                     % more Objects near by. Find the nearst one
%                     
%                     for radius=1:1:obj.NoIteration
%                         circlePixels = ((rowsInImage - double(EndPoints(j,2))).^2 + (columnsInImage - double(EndPoints(j,1))).^2 <= radius.^2);
%                         
%                         detectionArea = circlePixels & obj.handlePicBW.CData;
%                         
%                         [BoundarieMat LabelMat] = bwboundaries(detectionArea,4);
%                         NoObjCircle = max(max(LabelMat));
%                         
%                         if NoObjCircle > 1
%                             
%                             stats = regionprops('struct',LabelMat,'Centroid');
%                             
%                             % Find the Object thats the center of the cirle search
%                             % area
%                             LabelCenter = LabelMat(EndPoints(j,2),EndPoints(j,1));
%                             % Delete that Object in the stats struct
%                             stats(LabelCenter) = [];
%                             
%                             for i=1:1:NoObjCircle-1
%                                 center = stats(i).Centroid;
%                                 dx = EndPoints(j,1)-center(1);
%                                 dy = EndPoints(j,2)-center(2);
%                                 dist = sqrt(dx^2+dy^2);
%                                 
%                                 if dx == 0
%                                     xValues = EndPoints(j,1)*ones(1, int32(dist*3));
%                                     yValues = linspace(EndPoints(j,2),center(2),int32(dist*3));
%                                     index = sub2ind(size(obj.handlePicBW.CData),round(yValues),round(xValues));
%                                     obj.handlePicBW.CData(index) = 1;
%                                 else
%                                     xValues = linspace(EndPoints(j,1),center(1),int32(dist*3));
%                                     m = double(dy/dx);
%                                     b = double(EndPoints(j,2))-m*double(EndPoints(j,1));
%                                     yValues = m*xValues+b;
%                                     index = sub2ind(size(obj.handlePicBW.CData),round(yValues),round(xValues));
%                                     obj.handlePicBW.CData(index) = 1;
%                                 end
%                                 
%                             end
%                            
% %                             break;
%                         end
%                     end
%                 end
%                 
%                 
%             end
%             
%             disp('Gabs end')
%         end
        
        function addToBuffer(obj)
            if obj.PicBufferPointer >= obj.BufferSize
                temp = obj.PicBuffer;
                
                for i=1:1:obj.BufferSize-1
                    obj.PicBuffer{1,i}=temp{1,i+1};
                end
                obj.PicBufferPointer = obj.BufferSize;
                obj.PicBuffer{1,obj.PicBufferPointer}=obj.handlePicBW.CData;
            else
                obj.PicBufferPointer =obj.PicBufferPointer+1;
                obj.PicBuffer{1,obj.PicBufferPointer}=obj.handlePicBW.CData;
            end
        end
        
        function delete(obj)
            
        end
        
    end
    
end
