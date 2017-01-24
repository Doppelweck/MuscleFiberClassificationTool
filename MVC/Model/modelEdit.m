classdef modelEdit < handle
    %modelEdit   Model of the edit-MVC (Model-View-Controller). Runs all
    %nessesary calculations. Is connected and gets controlled by the
    %correspondening Controller.
    %The main tasks are:
    %   - Open the selected RGB image, search and load the associated color
    %     plane images (.zvi file).
    %   - Identification of color plane images.
    %   - Performing the brightness correction on the color plane images.
    %   - Creating the binary image.
    %   - Calculating the line objects for the hand draw methods.
    %
    %
    %======================================================================
    %
    % AUTHOR:           - Sebastian Friedrich,
    %                     Trier University of Applied Sciences, Germany
    %
    % SUPERVISOR:       - Prof. Dr.-Ing. K.P. Koch
    %                     Trier University of Applied Sciences, Germany
    %
    %                   - Mr Justin Perkins, BVetMed MS CertES Dip ECVS MRCVS
    %                     The Royal Veterinary College, Hertfordshire United Kingdom
    %
    % FIRST VERSION:    30.12.2016 (V1.0)
    %
    % REVISION:         none
    %
    %======================================================================
    %
    
    
    properties
        
        controllerEditHandle; %hande to controllerEdit instance.
        
        FileNamesRGB; %Filename of the selected RGB image.
        PathNames; %Directory path of the selected RGB image.
        PicRGB; %RGB image.
        PicBW; %Binary image.
        handlePicRGB; %handle to RGB image.
        handlePicBW; %handle to binary image.
        PicPlane1; %first unidentified color plane image.
        PicPlane2; %second unidentified color plane image.
        PicPlane3; %third unidentified color plane image.
        PicPlane4; %fourth unidentified color plane image.
        PicPlaneGreen; %Green identified color plane image.
        PicPlaneBlue; %Blue identified color plane image.
        PicPlaneRed; %Red identified color plane image.
        PicPlaneFarRed; %Farred identified color plane image.
        PicRGBPlanes; %RGB image created from the color plane images.
        PicPlaneGreen_adj; %Green color plane image after brightness adjustment.
        PicPlaneBlue_adj; %Blue color plane image after brightness adjustment.
        PicPlaneRed_adj; %Red color plane image after brightness adjustment.
        PicPlaneFarRed_adj; %Farred color plane image after brightness adjustment.
        PicA4; %Brightness adjustment image for Blue color plane image.
        PicL5; %Brightness adjustment image for Green color plane image.
        PicTX; %Brightness adjustment image for Red color plane image.
        PicY5; %Brightness adjustment image for FarRed color plane image.
        
        PicBWisInvert = 'false'; %Invert staus of binary image.
        
        ThresholdMode; %Selected threshold mode.
        ThresholdValue; %Selected threshold value.
        
        AlphaMapValue; %Selected alphamap value (transparency).
        
        LineWidthValue = 1; %Selected linewidth value.
        ColorValue = 1; %Selected color value. 1 for white, 0 for black
        
        PicBufferPointer = 1; %Pointer to the current buffer element. Buffer contains binary iamges for undo and redo functionality
        BufferSize = 100; %Size of the buffer;
        PicBuffer; %Image buffer for binary images.Used for undo and redo functionality.
        
        morphOP = ''; %Selected morphological method.
        SE = ''; %Selected structering element shape.
        SizeSE = 1; %Size of the selected structering element.
        FactorSE = 1; %Multiplier for the size of the selected structering element.
        NoIteration = 1; %Number of iterations of the selected morphological method.
        
        x1; %x-coordinate of the starting point for the line object. Used for hand draw functionality.
        x2; %x-coordinate of the end point for the line object. Used for hand draw functionality.
        y1; %y-coordinate of the starting point for the line object. Used for hand draw functionality.
        y2; %y-coordinate of the end point for the line object. Used for hand draw functionality.
        x_v; %Vektor 2x1 of sorted x values (start and end point sorted by size).
        y_v; %Vektor 2x1 of sorted y values (start and end point sorted by size).
        dx; %Gradient in x-direction. Used for hand draw functionality.
        dy; %Gradient in y-direction. Used for hand draw functionality.
        abs_dx; %Abslote value of the gradient in x-direction. Used for hand draw functionality.
        abs_dy; %Abslote value of the gradient in y-direction. Used for hand draw functionality.
        dist; %Euclidean distance between the start and end point of line object. Used for hand draw functionality.
        m; %Gradient of the line object. Used for hand draw functionality.
        b; %Offset of the line object. Used for hand draw functionality.
        xValues; %Vector nx1 with interpolated x values for the line to draw the binary image. Used for hand draw functionality.
        yValues; %Vector nx1 with interpolated y values for the line to draw the binary image. Used for hand draw functionality.
        index; %Index vektor to draw the line in the binary image.
    end
    properties(SetObservable)
        %Properties that are observed
        InfoMessage; %Last info message in the GUI log text. Observed by the Controller.
        
    end
    
    methods
        
        function obj = modelEdit()
            % Constuctor of the modelEdit class. Does absolutely nothing.
            %
            %   obj = modelEdit();
            %
            %   ARGUMENTS:
            %
            %       - Input
            %
            %       - Output
            %           obj:    Handle to modelEdit object
            %
            
        end
        
        function clearPicData(obj)
            % Clears all image data. Set all images to an empty array.
            %Deletes filename and pathnames of the images. Reset the image
            %buffer.
            %
            %   addMyListener(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
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
            % Send all image data from the model to the Controller that are
            % needed.
            %
            %   PicData = sendPicsToController(obj);
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to modelEdit object
            %
            %       - Output
            %           PicData:    Cell Array that contains the file- and
            %               pathnames of the RGB image. Also contains the
            %               RGB and the color plane images:
            %
            %               PicData{1}: filename RGB image
            %               PicData{2}: path RGB image
            %               PicData{3}: RGB image
            %               PicData{4}: binary image
            %               PicData{5}: green plane image
            %               PicData{6}: blue plane image
            %               PicData{7}: red plane image
            %               PicData{8}: farred plane image
            %               PicData{9}: RGB image create from color plane
            %               images
            %
            
            PicData{1} = obj.FileNamesRGB;
            PicData{2} = obj.PathNames;
            PicData{3} = obj.PicRGB;   %RGB
            
            % send binary pic to controller only in the normal non-inverted
            % form
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
        
        function sucsess = loadPics(obj)
            % Search for the .zvi file that contains the color plane images
            % and the brightness adjustment images in the same directory as
            % the selected RGB image.
            %
            %   PicData = sucsess = loadPics(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to modelEdit object
            %
            %       - Output
            %           succses:    returns true if the color plane images
            %               was founded, otherwise false.
            %
            
            obj.InfoMessage = '   - open image';
            obj.InfoMessage = ['      - ' obj.FileNamesRGB ' was selected'];
            
            obj.InfoMessage = '   - searching for color plane images';
            
            %The .zvi file has always the same name as the RGB image.
            LFN = length(obj.FileNamesRGB);
            FileNamesZIV = obj.FileNamesRGB;
            FileNamesZIV(LFN)='i';
            FileNamesZIV(LFN-1)='v';
            FileNamesZIV(LFN-2)='z';
            
            if exist([obj.PathNames FileNamesZIV], 'file') == 2
                %.zvi file was found
                
                obj.InfoMessage = '      - loading color plane images';
                
                %open .zvi file
                reader = bfGetReader([obj.PathNames FileNamesZIV]);
                
                %read and save RGB image
                obj.PicRGB = imread([obj.PathNames, obj.FileNamesRGB]);
                
                %read and save plane color images (unidentified)
                obj.PicPlane1 = bfGetPlane(reader,1);
                obj.PicPlane2 = bfGetPlane(reader,2);
                obj.PicPlane3 = bfGetPlane(reader,3);
                obj.PicPlane4 = bfGetPlane(reader,4);
                
                % Searching for brightness adjustment Pics
                obj.InfoMessage = '      - searching for brightness adjustment images';
                
                %Save currebt folder
                currentFolder = pwd;
                %go to the directory of the RGB image
                cd(obj.PathNames);
                
                %search for brightness adjustment images
                FileNamePicA4 = dir('A4*.zvi');
                FileNamePicL5 = dir('L5*.zvi');
                FileNamePicTX = dir('TX*.zvi');
                FileNamePicY5 = dir('Y5*.zvi');
                
                cd(currentFolder);
                
                if ~isempty(FileNamePicA4)
                    %A4*.zvi brightness adjustment image were found
                    readertemp = bfGetReader([obj.PathNames FileNamePicA4(1).name]);
                    obj.PicA4 = bfGetPlane(readertemp,1);
                    obj.InfoMessage = ['      - ' FileNamePicA4(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - A4*.zvi file were not found'];
                    obj.PicA4 = [];
                end
                
                if ~isempty(FileNamePicL5)
                    %L5*.zvi brightness adjustment image were found
                    readertemp = bfGetReader([obj.PathNames FileNamePicL5(1).name]);
                    obj.PicL5 = bfGetPlane(readertemp,1);
                    obj.InfoMessage = ['      - ' FileNamePicL5(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - L5*.zvi file were not found'];
                    obj.PicL5 = [];
                end
                
                if ~isempty(FileNamePicTX)
                    %TX*.zvi brightness adjustment image were found
                    readertemp = bfGetReader([obj.PathNames FileNamePicTX(1).name]);
                    obj.PicTX = bfGetPlane(readertemp,1);
                    obj.InfoMessage = ['      - ' FileNamePicTX(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - TX*.zvi file were not found'];
                    obj.PicTX = [];
                end
                
                if ~isempty(FileNamePicY5)
                    %Y5*.zvi brightness adjustment image were found
                    readertemp = bfGetReader([obj.PathNames FileNamePicY5(1).name]);
                    obj.PicY5 = bfGetPlane(readertemp,1);
                    obj.InfoMessage = ['      - ' FileNamePicY5(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - Y5*.zvi file were not found'];
                    obj.PicY5 = [];
                end
                
                cd(currentFolder);
                
                sucsess = true;
            else
                obj.InfoMessage = '   - Error color plane pictures';
                obj.InfoMessage = '      - color plane pictures (.zvi file) not found';
                obj.InfoMessage = ['      - ' FileNamesZIV ' dont exist'];
                obj.InfoMessage = ['      - ' FileNamesZIV ' must be in the same path as the selected RGB.tif image'];
                
                infotext = {'Error while opening color plane pictures!',...
                    '',...
                    'Color plane pictures (.zvi file) not found.',...
                    FileNamesZIV ' dont exist.',...
                    FileNamesZIV ' must be in the same path as the selected RGB.tif image.'};
                
                sucsess = false;
                
                obj.controllerEditHandle.viewEditHandle.infoMessage(infotext);
            end
        end
        
        function planeIdentifier(obj)
            % Identifies which plane image (1 2 3 4) belongs to which color
            % (green red blue farred).
            %
            %   planeIdentifier(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
            if isequal(obj.FileNamesRGB ,0) && isequal(obj.PathNames,0)
                obj.InfoMessage = '   - indentifing planes canceled';
            else
                obj.InfoMessage = '   - indentifing planes';
                
                %Save unidentified plane images in one array
                Pic= cat(3,obj.PicPlane1 ,obj.PicPlane2 ,obj.PicPlane3 ,obj.PicPlane4 );
                
                %Dismantling the RGB image into its color channels
                R=imadjust( obj.PicRGB(:,:,1) ); %Red channel
                G=imadjust( obj.PicRGB(:,:,2) ); %Green channel
                B=imadjust( obj.PicRGB(:,:,3) ); %Blue channel
                
                %Save unidentified plane images and RGB-channel images in
                %one array.
                PicRGB_P = cat(3,R, G, B);
                
                r=[]; %Array for the correlation coefficients
                
                for i=1:1:length(PicRGB_P(1,1,:))
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
                    %search for the highest correlation coefficient. Plane
                    %and color are the indices of the correlation array r
                    [plane color] = ind2sub( size(r) , find( r==max(max(r)) ) );
                    
                    switch color
                        
                        case 1  %Red and FarRed
                            % Red value should have two max values in the r
                            % array. For red and farred plane
                            
                            %The first and highest correlation value in the
                            %red color channel will be identified as red.
                            %The second one as farred.
                            
                            if isempty(tempR)
                                %red plane was identified
                                %save red plane temporary
                                tempR = Pic(:,:,plane);
                                %clear foundet plane in the r array
                                r(plane,:) = [];
                                Pic(:,:,plane) = [];
                                obj.InfoMessage = '      - red-plane was identified';
                            else
                                %farred plane was identified
                                %save farred plane temporary
                                tempFR = Pic(:,:,plane);
                                %clear foundet plane and color in the r array
                                r(plane,:) = [];
                                Pic(:,:,plane) = [];
                                r(:,color) = 0;
                                obj.InfoMessage = '      - farred-plane was identified';
                            end
                            
                        case 2  %Green
                            %green plane was identified
                            %save green plane temporary
                            tempG = Pic(:,:,plane);
                            r(plane,:) = [];
                            r(:,color) = 0;
                            Pic(:,:,plane) = [];
                            obj.InfoMessage = '      - green-plane was identified';
                            
                        case 3  %Blue
                            %blue plane was identified
                            %save blue plane temporary
                            tempB = Pic(:,:,plane);
                            %clear foundet plane and color in the r array
                            r(plane,:) = [];
                            r(:,color) = 0;
                            Pic(:,:,plane) = [];
                            obj.InfoMessage = '      - blue-plane was identified';
                    end
                end
                
                %Save identified planes in the properties
                obj.PicPlaneGreen = tempG;
                obj.PicPlaneBlue = tempB;
                obj.PicPlaneRed = tempR;
                obj.PicPlaneFarRed = tempFR;
                
                %Create an RGB image consisting of the identified red green
                %and blue color planes. The user can check with that
                %picture whether the planes were identified correctly.
                obj.PicRGBPlanes(:,:,1) = tempR;
                obj.PicRGBPlanes(:,:,2) = tempG;
                obj.PicRGBPlanes(:,:,3) = tempB;
                obj.PicRGBPlanes = uint8(obj.PicRGBPlanes);
                
            end
        end
        
        function brightnessAdjustment(obj)
            % Perform a brightness correction with the brightness
            % adjustment images on the color plane pictures. If no brightness
            % adjustment images were found than the fuction performs the
            % imadjust() function from the image processing toolbox.
            %
            %   brightnessAdjustment(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
            obj.InfoMessage = '   - brightness adjustment';
            if isequal(obj.FileNamesRGB ,0) && isequal(obj.PathNames,0)
                obj.InfoMessage = '   - pictures brightness adjustment canceled';
            else
                %brightness adjustment PicPlaneGreen
                if ~isempty(obj.PicL5)
                    %Divide the color plane image through the adjustment image
                    Mat1 = double(obj.PicPlaneGreen)./double(obj.PicL5);
                    Mat1 = uint8(Mat1./max(max(Mat1)).*255);
                    obj.PicPlaneGreen_adj = imadjust(Mat1);
                    obj.InfoMessage = '      - adjust green plane';
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicL5 not found';
                    obj.PicPlaneGreen_adj = imadjust(obj.PicPlaneGreen);
                end
                
                %brightness adjustment PicPlaneRed
                if ~isempty(obj.PicTX)
                    %Divide the color plane image through the adjustment image
                    Mat2 = double(obj.PicPlaneRed)./double(obj.PicTX);
                    Mat2 = uint8(Mat2./max(max(Mat2)).*255);
                    obj.PicPlaneRed_adj = imadjust(Mat2);
                    obj.InfoMessage = '      - adjust red plane';
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicTX not found';
                    obj.PicPlaneRed_adj = imadjust(obj.PicPlaneRed);
                end
                
                %brightness adjustment PicPlaneBlue
                if ~isempty(obj.PicA4)
                    %Divide the color plane image through the adjustment image
                    Mat3 = double(obj.PicPlaneBlue)./double(obj.PicA4);
                    Mat3 = uint8(Mat3./max(max(Mat3)).*255);
                    obj.PicPlaneBlue_adj = imadjust(Mat3);
                    obj.InfoMessage = '      - adjust blue plane';
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicA4 not found';
                    obj.PicPlaneBlue_adj = imadjust(obj.PicPlaneBlue);
                end
                
                %brightness adjustment PicPlaneFarRed
                if ~isempty(obj.PicY5)
                    %Divide the color plane image through the adjustment image
                    Mat4 = double(obj.PicPlaneFarRed)./double(obj.PicY5);
                    Mat4 = uint8(Mat4./max(max(Mat4)).*255);
                    obj.PicPlaneFarRed_adj = imadjust(Mat4);
                    obj.InfoMessage = '      - adjust farred plane';
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicY4 not found';
                    obj.PicPlaneFarRed_adj = imadjust(obj.PicPlaneFarRed);
                end
                
                
            end
            obj.InfoMessage = '   - brightness adjustment finished';
        end
        
        function createBinary(obj)
            % Creates a binary image from the green color image depending
            % on the selected threshold mode and threshold value.
            %
            %   createBinary(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
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
                            
                        case 4 % Use automatic setup for binarization 
                            obj.autoSetupBinarization();
                            
                    end
                else
                    % Binary pictur is invert
                    switch obj.ThresholdMode
                        
                        case 1 % Use manual global threshold for binarization
                            
                            temp = im2bw(obj.PicPlaneGreen_adj,thresh);
                            obj.PicBW = ~temp;
                            obj.handlePicBW.CData = obj.PicBW;
                            
                        case 2 % Use automatic adaptive threshold for binarization
                            
                            temp = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
                            obj.PicBW = ~temp;
                            obj.handlePicBW.CData = obj.PicBW;
                            
                        case 3 % Use automatic adaptive and manual global threshold for binarization
                            
                            temp1 = im2bw(obj.PicPlaneGreen_adj,thresh);
                            temp2 = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
                            obj.PicBW = ~(temp1 | temp2);
                            obj.handlePicBW.CData = obj.PicBW;
                            
                        case 4 % Use automatic setup for binarization     
                            obj.autoSetupBinarization();
                    end
                    
                end
            end
        end
        
        function alphaMapEvent(obj)
            % Set the alpha map value of the binary image dependingon the
            % selected alpha value.
            %
            %   alphaMapEvent(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
            if ~isempty(obj.handlePicBW)
                
                set(obj.handlePicBW,'AlphaData',obj.AlphaMapValue);
                
            end
            
        end
        
        function invertPicBWEvent(obj)
            % Invert die binary image. Saves the invert state of the image
            % in the properties.
            %
            %   invertPicBWEvent(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
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
        
        function fillRegion(obj,CurPos)
            % Called by the controller when a user clicked into the binary
            % image. Get the position of the click and fill the region,
            % defined by the connected zeros or ones, depending on the
            % selected color, in the binary image
            %
            %   fillRegion(obj,CurPos)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %           CurPos: current cursor position in the binary image
            %
            
            x = round(CurPos(1,1));
            y = round(CurPos(1,2));
            if obj.ColorValue == 1
                %white fill
            BW1 = obj.handlePicBW.CData;
            BW2 = imfill(BW1,[y x]);
            BW3 = ~eq(BW1,BW2);

            obj.handlePicBW.CData(BW3 == 1)=obj.ColorValue;
            elseif obj.ColorValue == 0
               BW1 = ~obj.handlePicBW.CData; 
               BW2 = imfill(BW1,[y x]);
               BW3 = ~eq(BW1,BW2);
               obj.handlePicBW.CData(BW3 == 1)=obj.ColorValue;
            else
            end
            
            obj.addToBuffer();
        end
        
        function startDragFcn(obj,CurPos)
            % Called by the controller when a user clicked into the binary
            % image. Get the position of the click and draw a circle with
            % the color and the radius depending on the linewidth value
            % that the user has selected at that position in the binary
            % image.
            %
            %   startDragFcn(obj,CurPos)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %           CurPos: current cursor position in the binary image
            %
            
            obj.x1 = int16(CurPos(1,1));
            
            obj.y1 = int16(CurPos(1,2));
            
            [imageSizeY imageSizeX]=size(obj.PicBW);
            [columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
            radius = obj.LineWidthValue;
            
            if obj.ColorValue == 1
                % create white circle
                circlePixels = ((rowsInImage - double(obj.y1)).^2 + (columnsInImage - double(obj.x1)).^2 <= radius.^2);
                obj.handlePicBW.CData = obj.handlePicBW.CData | circlePixels;
            else
                % create black circle
                circlePixels = ~((rowsInImage - double(obj.y1)).^2 + (columnsInImage - double(obj.x1)).^2 <= radius.^2);
                obj.handlePicBW.CData = obj.handlePicBW.CData & circlePixels;
            end
            
        end
        
        function DragFcn(obj,CurPos)
            % Called by the controller when a user clicked into the binary
            % image and moves the cursor with pressed key over the image.
            % Interpolate a line between the cursor points that are saved
            % when this function is called the next time during the cursor
            % movement.
            %
            %   DragFcn(obj,CurPos)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %           CurPos: current cursor position in the binary image
            %
            
            %get current cursor positon
            obj.x2 = double(CurPos(1,1));
            obj.y2 = double(CurPos(1,2));
            
            % Draw a circle with the selected linewidth at the point where
            % the previews line ends a new lineobject starts.
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
            
            %calculate gradient in x and y direction
            obj.dx = double(obj.x1)-obj.x2;
            obj.dy = double(obj.y1)-obj.y2;
            obj.abs_dx = abs(obj.dx);
            obj.abs_dy = abs(obj.dy);
            
            %calculate eucledian distance between the points.
            obj.dist = sqrt((obj.abs_dx)^2+(obj.abs_dy)^2);
            
            obj.x_v = double( sort([obj.x1 obj.x2]) );
            obj.y_v = double( sort([obj.y1 obj.y2]) );
            
            %Calculatae slope and offset of the line
            obj.m=double(obj.dy/obj.dx);
            obj.b = double(obj.y1)-obj.m*double(obj.x1);
            
            xMax = double(size(obj.PicBW,2));
            yMax = double(size(obj.PicBW,1));
            
            %Draw line object in binary image
            if obj.dx == 0
                %dx is zero, m ins Inf
                
                for i=-obj.LineWidthValue:1:obj.LineWidthValue
                    
                    %crate x values vektor for the line
                    obj.xValues = (double(obj.x_v(1))+i)*ones(1, int32(obj.dist*2));
                    %check if the values in the range if the image
                    obj.xValues(obj.xValues<1)=double(1);
                    obj.xValues(obj.xValues>xMax)=xMax;
                    
                    %crate y values vektor for the line
                    obj.yValues = linspace(obj.y_v(1),obj.y_v(2),int32(obj.dist*2));
                    %check if the values in the range if the image
                    obj.yValues(obj.yValues<1)=double(1);
                    obj.yValues(obj.yValues>yMax)=yMax;
                    
                    %create index vector of the line object
                    obj.index = sub2ind(size(obj.handlePicBW.CData),round(obj.yValues),round(obj.xValues));
                    %draw line in the binary image
                    obj.handlePicBW.CData(obj.index) = obj.ColorValue;
                    
                end
            elseif obj.abs_dx >= obj.abs_dy
                
                for i=-obj.LineWidthValue:1:obj.LineWidthValue
                    
                    %crate x values vektor for the line
                    obj.xValues = linspace(obj.x_v(1),obj.x_v(2),int32(obj.dist*2));
                    %crate y values vektor for the line
                    obj.yValues = obj.m*obj.xValues+obj.b+i;
                    
                    %check if the values in the range if the image
                    obj.xValues(obj.xValues<1)=double(1);
                    obj.xValues(obj.xValues>xMax)=xMax;
                    obj.yValues(obj.yValues<1)=double(1);
                    obj.yValues(obj.yValues>yMax)=yMax;
                    
                    %create index vector of the line object
                    obj.index = sub2ind(size(obj.handlePicBW.CData),round(obj.yValues),round(obj.xValues));
                    %draw line in the binary image
                    obj.handlePicBW.CData(obj.index) = obj.ColorValue;
                    
                end
            elseif obj.abs_dy > obj.abs_dx
                
                for i=-obj.LineWidthValue:1:obj.LineWidthValue
                    
                    %crate y values vektor for the line
                    obj.yValues = linspace(obj.y_v(1),obj.y_v(2),int32(obj.dist*2));
                    %crate x values vektor for the line
                    obj.xValues = ((obj.yValues-obj.b)/obj.m)+i;
                    
                    %check if the values in the range if the image
                    obj.xValues(obj.xValues<1)=double(1);
                    obj.xValues(obj.xValues>xMax)=xMax;
                    obj.yValues(obj.yValues<1)=double(1);
                    obj.yValues(obj.yValues>yMax)=yMax;
                    
                    %create index vector of the line object
                    obj.index = sub2ind(size(obj.handlePicBW.CData),round(obj.yValues),round(obj.xValues));
                    %draw line in the binary image
                    obj.handlePicBW.CData(obj.index) = obj.ColorValue;
                    
                end
            end
            %set the end point of the current line as starting point for the
            %next line oject.
            obj.x1 = obj.x2;
            obj.y1 = obj.y2;
            
        end
        
        function stopDragFcn(obj)
            % Called by the controller when the user stops hand drawing.
            % Save binary image with changes in the buffer for undo and
            % redo functionality.
            %
            %   stopDragFcn(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
            obj.addToBuffer();
        end
        
        function checkMask(obj,check)
            
            if check == 1
                if strcmp(obj.PicBWisInvert,'true')
                    obj.InfoMessage = '      - image is in inverted form';
                    obj.InfoMessage = '      - labeling objects';
                    
                    temp = obj.handlePicBW.CData; 
                    % Fill holes in the binary image
                    temp = imfill(temp,8,'holes');
                    % Remove single pixels
                    temp = bwareaopen(temp,1,4);
                    L = bwlabel(temp,4);
                    obj.InfoMessage = ['      - ' num2str(max(max(L))) 'objects was found'];
                    
                    temp = label2rgb(L, 'jet', 'w', 'shuffle');
                    obj.InfoMessage = ['      - objects will be highlighted in RGB colors'];
                    obj.handlePicBW.CData = temp;
                    obj.InfoMessage = ['      - press "Check mask" button to quit check mask'];
                else
                    temp = ~obj.handlePicBW.CData;
                    obj.InfoMessage = '      - image is in normal form';
                    obj.InfoMessage = '      - labeling objects';
                    % Fill holes in the binary image
                    temp = imfill(temp,8,'holes');
                    % Remove single pixels
                    temp = bwareaopen(temp,1,4);
                    L = bwlabel(temp,4);
                    obj.InfoMessage = ['      - ' num2str(max(max(L))) 'objects was found'];
                    temp = label2rgb(L, 'jet', 'w', 'shuffle');
                    obj.InfoMessage = ['      - objects will be highlighted in RGB colors'];
                    obj.handlePicBW.CData = temp;
                    obj.InfoMessage = ['      - press "Check mask" button to quit check mask'];
                end
                
            elseif check == 0
                obj.handlePicBW.CData = obj.PicBW;
            else
                obj.InfoMessage = '! ERROR in checkMask() FUNCTION !';
            end
            
        end
        
        function runMorphOperation(obj)
            % Performs the selected mophological operation when a user
            % press the run morph button in the GUI.
            %
            %   runMorphOperation(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
            obj.InfoMessage = '   - Run morpholigical operation';
            
            %check wich morph operation is selected
            switch obj.morphOP
                
                case 'erode'
                    
                    se = strel(obj.SE,obj.SizeSE*obj.FactorSE);
                    for i=1:1:obj.NoIteration
                        obj.handlePicBW.CData = imerode(obj.handlePicBW.CData,se);
                    end
                    obj.InfoMessage = '      - erode operation completed';
                    
                case 'dilate'
                    
                    se = strel(obj.SE,obj.SizeSE*obj.FactorSE);
                    for i=1:1:obj.NoIteration
                        obj.handlePicBW.CData = imdilate(obj.handlePicBW.CData , se);
                    end
                    obj.InfoMessage = '      - dilate operation completed';
                    
                case 'skel'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'skel',Inf);
                    obj.InfoMessage = '      - skel operation completed';
                    
                case 'thin'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'thin',obj.NoIteration);
                    obj.InfoMessage = '      - thin operation completed';
                    
                case 'open'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'open',obj.NoIteration);
                    obj.InfoMessage = '      - open operation completed';
                    
                case 'remove'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'remove',obj.NoIteration);
                    obj.InfoMessage = '      - remove operation completed';
                    
                case 'shrink'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'shrink',obj.NoIteration);
                    obj.InfoMessage = '      - shrink operation completed';
                    
                case 'majority'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'majority',obj.NoIteration);
                    obj.InfoMessage = '      - majority operation completed';
                    
                case 'edge smoothing'
                    
                    %performs the majority morph 500 times
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'majority',500);
                    obj.InfoMessage = '      - edge smoothing completed';
                    
                case 'close small gaps'
                    
                    obj.InfoMessage = ['      - closing small gaps with a size of ' num2str(obj.NoIteration) ' pixels'];
                    
                    %Check invert status of the binary image
                    if strcmp(obj.PicBWisInvert,'true')
                        %image is invert
                        tempPic = ~obj.handlePicBW.CData;
                    else
                        %image is in normal form
                        tempPic = obj.handlePicBW.CData;
                    end
                    
                    %create small structering element
                    se = strel('disk',1);
                    
                    %perform n times a dilate with small SE
                    for i = 1:1:round(obj.NoIteration/2)
                        tempPic = imdilate(tempPic , se);
                        if mod(i,2)==0
                            tempPic = bwmorph(tempPic,'majority',1);
                        end
                    end
                    
                    %skel the temp binary image again
                    tempPic = bwmorph(tempPic,'skel',Inf);
                    %perform one times a dilate with small SE to make the
                    %skeleton thicker
                    tempPic = imdilate(tempPic , se);
                    %remove pixels with a small neighborhood
                    tempPic = bwmorph(tempPic,'majority',1);
                    
                    %add the temp pic to the binary mask
                    if strcmp(obj.PicBWisInvert,'true')
                        obj.handlePicBW.CData = ~(~obj.handlePicBW.CData | tempPic);    %BW
                    else
                        obj.handlePicBW.CData = obj.handlePicBW.CData | tempPic;
                    end
                    
                    obj.InfoMessage = '      - closing gaps complete';
                otherwise
                    obj.InfoMessage = '! ERROR in runMorphOperation() FUNCTION !';
            end
            
            obj.addToBuffer();
        end
        
        function autoSetupBinarization(obj)
            obj.PicBW = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
            obj.PicBWisInvert = 'false';
            se = strel('disk',5);
            imTopHatGreen = imtophat(obj.PicPlaneGreen_adj,se);
            imTopHatGreen = imadjust(imTopHatGreen);
            imCompGreen = imcomplement(obj.PicPlaneGreen_adj);
%             figure(11)
%             imshow(imCompGreen);
            
            %             imOpenGreen = imopen(imCompGreen, se);
            %             figure(12)
            %             imshow(imOpenGreen);
            %
            %             imErodeGreen = imerode(imCompGreen, se);
            %             figure(13)
            %             imshow(imErodeGreen);
            %
            %             Iobr = imreconstruct(imErodeGreen, imCompGreen);
            %             figure(14)
            %             imshow(Iobr);
            %
            %             Ioc = imclose(imOpenGreen, se);
            
            I = imCompGreen;
            
            hy = fspecial('sobel');
            hx = hy';
            Iy = imfilter(double(I), hy, 'replicate');
            Ix = imfilter(double(I), hx, 'replicate');
            gradmag = sqrt(Ix.^2 + Iy.^2);
            
%             figure(10)
%             imshow(gradmag,[],'InitialMagnification','fit'), title('gradmag');
            Io = imopen(I, se);
%             figure(12)
%             imshow(Io), title('Opening (Io)')
            
            Ie = imerode(I, se);
            Iobr = imreconstruct(Ie, I);
%             figure(13)
%             imshow(Iobr), title('Opening-by-reconstruction (Iobr)')
            
            Ioc = imclose(Io, se);
%             figure(14)
%             imshow(Ioc), title('Opening-closing (Ioc)')
            
            Iobrd = imdilate(Iobr, se);
            Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(Iobr));
            Iobrcbr = imcomplement(Iobrcbr);
%             figure(15)
%             imshow(Iobrcbr), title('Opening-closing by reconstruction (Iobrcbr)')
            
            fgm = imregionalmax(Iobrcbr);
%             figure(16)
%             imshow(fgm,[],'InitialMagnification','fit'), title('Regional maxima of opening-closing by reconstruction (fgm)')
            
            I2 = I;
            I2(fgm) = 255;
%             figure(17)
%             imshow(I2,[],'InitialMagnification','fit'), title('Regional maxima superimposed on original image (I2)')
            
            se2 = strel(ones(3,3));
            fgm2 = imclose(fgm, se2);
            fgm3 = imerode(fgm2, se2);
            
            fgm4 = bwareaopen(fgm3, 10); %%%%%%%%%%%%%%%%
            fgm4 = imfill(fgm4,'holes');
            
            I3 = I;
            I3(fgm4) = 255;
%             figure(18)
%             imshow(I3,[],'InitialMagnification','fit')
%             title('Modified regional maxima superimposed on original image (fgm4)')
            
            bw = imbinarize(Iobrcbr);
%             figure(19)
%             imshow(bw,[],'InitialMagnification','fit'), title('Thresholded opening-closing by reconstruction (bw)')
            
            D = bwdist(bw);
            DL = watershed(D);
            bgm = DL == 0;
%             figure(20)
%             imshow(DL,[],'InitialMagnification','fit'), title('Watershed ridge lines (bgm)')
            
            gradmag2 = imimposemin(gradmag, bgm | fgm4);
            
            L = watershed(gradmag2);
            
            I4 = obj.PicPlaneGreen_adj;
            I4(imdilate(L == 0, ones(1, 1),1) | bgm | fgm4) = 255;
%             
%             figure(21)
%             imshow(I4,[],'InitialMagnification','fit')
%             title('Markers and object boundaries superimposed on original image (I4)')
            
            Lrgb = label2rgb(L, 'jet', 'w', 'shuffle');
%             figure(22)
%             imshow(Lrgb,[],'InitialMagnification','fit')
%             title('Colored watershed label matrix (Lrgb)')
            
%             figure(23)
%             imshow(obj.PicRGB)
%             hold on
%             himage = imshow(Lrgb,[],'InitialMagnification','fit');
%             himage.AlphaData = 0.2;
%             title('Lrgb superimposed transparently on original image')
            
            f2=zeros(size(L));
            f2(L==0)=1;
            se = strel('disk',1);
            f2 = imdilate(f2,se);
            
            obj.PicBW = obj.PicBW | f2;
            obj.handlePicBW.CData = obj.PicBW | f2;
            
            %             [x,y]=size(imTopHatGreen);
            %             X=1:x;
            %             Y=1:y;
            %             [xx,yy]=meshgrid(Y,X);
            %             i=im2double(imTopHatGreen);
            %             figure(12);mesh(xx,yy,i);
            %             colorbar
            %             figure;imshow(i)
        end
        
%         function autoSetupBinarization(obj)
%                    %Set invert status to false
%                    obj.PicBWisInvert = 'false';
%             
%                    %create binary image
%                    obj.PicBW = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
%                    
%                    f = obj.PicPlaneGreen_adj;
%                    h = fspecial('sobel');
%                    fd = double(f);
%                    g = sqrt(imfilter(fd,h,'replicate').^2 + imfilter(fd,h','replicate').^2);
%                    g2 = imclose(imopen(g, ones(3,3)), ones(3,3));
%                    figure(11)
%                    imshow(g,[],'InitialMagnification','fit');
%                    figure(12)
%                    imshow(g2,[],'InitialMagnification','fit');
%                    L = watershed(g2);
%                    figure(13)
%                    rgb = label2rgb(L,'jet',[.5 .5 .5]);
%                    imshow(rgb,[],'InitialMagnification','fit');
%                    
%                    wr = L == 0;
%                    
%                    rm = imregionalmin(f);
%                    im = imextendedmin(f,5);
%                    fim = f;
%                    fim(im) = 175;
%                    figure(14)
%                    imshow(fim,[],'InitialMagnification','fit');
%                    
%                    Lim = watershed(bwdist(im));
%                    em = Lim == 0;
%                    figure(15)
%                    imshow(em,[],'InitialMagnification','fit');
%                    
%                    g3 = imimposemin(g2,im | em);
%                    L2 = watershed(g3);
%                    f2 = zeros(size(L2));
%                    f2(L2 == 0) = 255;
%                    rgb = label2rgb(L2,'jet',[.5 .5 .5]);
%                     figure(16)
%                     imshow(rgb,[],'InitialMagnification','fit');
%                    
%                    tempPic = ~imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright','Sensitivity',0.5);
%                    
%                    figure
%                    imshow(f2);
%                    
%                    
%                    imDistMarker = bwdist(~tempPic,'cityblock');
%                    figure(7)
%                    imshow(imDistMarker,[],'InitialMagnification','fit');
%                    imDistMarkerBW = imbinarize(imDistMarker,'adaptive','ForegroundPolarity','bright','Sensitivity',0.00001);
%                    figure(6)
%                    imshow(imDistMarkerBW,[],'InitialMagnification','fit');
% %                    tempPic = ~tempPic;
% %                    tempPic = imfill(tempPic,8,'holes');
% %                    tempPic = ~tempPic;
% 
%                    %Set invert status to false
%                    obj.PicBWisInvert = 'false';
%                     
%                    
%                    
% %                     %create small structering element
% %                     se = strel('disk',1);
% %                     
% %                     tempPic = bwmorph(tempPic,'diag');
% %                     tempPic = bwmorph(tempPic,'skel',Inf);
% %                     
% %                     %perform n times a dilate with small SE
% %                     for i = 1:1:5
% %                         tempPic = imdilate(tempPic , se);
% %                         if mod(i,2)==0
% %                             tempPic = bwmorph(tempPic,'majority',1);
% %                         end
% %                     end
% %                     
% %                     %skel the temp binary image again
% %                     tempPic = bwmorph(tempPic,'skel',Inf);
% %                     %perform one times a dilate with small SE to make the
% %                     %skeleton thicker
% %                     tempPic = imdilate(tempPic , se);
% %                     %remove pixels with a small neighborhood
% % %                     tempPic = bwmorph(tempPic,'majority',1);
% %                     tempPic = tempPic | obj.PicBW;
% %                     
%                     
% %                     figure
% %                     imshow(D,[],'InitialMagnification','fit');
%                     figure(8)
%                     imshow(tempPic);
%                     imDist = -bwdist(~tempPic,'cityblock');
%                     imDist(~tempPic)=-inf;
%                     figure(9)
%                     imshow(imDist,[],'InitialMagnification','fit');
%                     BW = imregionalmax(imDistMarker);
%                     figure(10)
%                     imshow(BW);
%                     I3 = imhmin(imDist,30);
%                     L = watershed(I3);
%                     rgb = label2rgb(L,'jet',[.5 .5 .5]);
%                     figure(11)
%                     imshow(rgb,[],'InitialMagnification','fit');
%                     
%                     tempPic(L==0)=1;
% %                     D_BW = imbinarize(D,'adaptive','ForegroundPolarity','bright','Sensitivity',1);
% % %                     
% % %                     D = -D;
% % %                     figure
% % %                     imshow(D,[],'InitialMagnification','fit');
% % %                     D(~tempPic) = Inf;
% %                     L = watershed(D);
% %                     rgb = label2rgb(L,'jet',[.5 .5 .5]);
% %                     figure
% %                     imshow(rgb,'InitialMagnification','fit');
% % %                     tempPic(L==0)=1;
% % %                     tempPic(L>0)=0;
% % %                     se = strel('disk',1);
% % %                     tempPic = imdilate(tempPic , se);
% %                     Y=D./max(max(D));
% %                     X=im2bw(Y,graythresh(Y));
% %                     X= bwareaopen(X,4,4);
% %                     [LOld,numOld] = bwlabel(X);
% %                     numNew = numOld;
% %                     Xnew = X;
% %                     se = strel('disk',1);
% %                     while numOld == numNew
% %                         [LNew,numNew] = bwlabel(Xnew);
% % %                         figure
% % %                         imshow(X,'InitialMagnification','fit');
% %                         if numOld == numNew
% %                             X = Xnew;
% %                             
% %                             Xnew = imdilate(Xnew , se); 
% %                         end  
% %                     end
% %                     X = ~X;
% %                     X = bwmorph(X,'skel',Inf);
% %                     X = imdilate(X , se);
%                     
%                     obj.PicBW = obj.PicBW | f2;
%                     obj.handlePicBW.CData = obj.PicBW | f2;
% 
%         end
        
        function [xOut yOut] = checkPosition(obj,PosX,PosY)
            % Check whether the positon of the cursor is in the binary
            % image while drawing a line. If the positon is out if range
            % the poition will be set to the max and min values of the
            % image bounding box.
            %
            %   [xOut yOut] = checkPosition(obj,PosX,PosY)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           PosX:   Current x positon of the cursor relativ to
            %               the axes with icluded image. Pos can be negativ
            %               if its outside of the axes.
            %           PosY:   Current y positon of the cursor relativ to
            %               the axes with icluded image. Pos can be negativ
            %               if its outside of the axes.
            %           obj:    Handle to modelEdit object.
            %
            %       - Output
            %           xOut:    Corrected x position.
            %           yOut:    Corrected y position.
            %
            
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
            % Gets the previous image out of the buffer and set it to the
            % current iamge.
            %
            %   undo(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object.
            %

            
            if obj.PicBufferPointer > 1 && obj.PicBufferPointer <= obj.BufferSize
                obj.PicBufferPointer = obj.PicBufferPointer-1;
                obj.handlePicBW.CData = obj.PicBuffer{1,obj.PicBufferPointer};
                obj.PicBWisInvert = obj.PicBuffer{2,obj.PicBufferPointer};
                obj.PicBW = obj.handlePicBW.CData;
                
            end
        end
        
        function redo(obj)
            % Gets the next image out of the buffer and set it to the
            % current iamge.
            %
            %   redo(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object.
            %
            
            if obj.PicBufferPointer >= 1 && obj.PicBufferPointer < obj.BufferSize && obj.PicBufferPointer < size(obj.PicBuffer,2)
                obj.PicBufferPointer = obj.PicBufferPointer+1;
                obj.handlePicBW.CData = obj.PicBuffer{1,obj.PicBufferPointer};
                obj.PicBWisInvert = obj.PicBuffer{2,obj.PicBufferPointer};
                obj.PicBW = obj.handlePicBW.CData;
                
            end
        end
        
        function addToBuffer(obj)
            % Save current binary image in the buffer for redo and undo
            % functionality.
            %
            %   addToBuffer(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object.
            %
            
            if obj.PicBufferPointer >= obj.BufferSize
                temp = obj.PicBuffer;
                
                for i=1:1:obj.BufferSize-1
                    obj.PicBuffer{1,i}=temp{1,i+1};
                end
                obj.PicBufferPointer = obj.BufferSize;
                obj.PicBuffer{1,obj.PicBufferPointer}=obj.handlePicBW.CData;
                obj.PicBW = obj.handlePicBW.CData;
                obj.PicBuffer{2,obj.PicBufferPointer}=obj.PicBWisInvert;
            else
                obj.PicBufferPointer =obj.PicBufferPointer+1;
                obj.PicBuffer{1,obj.PicBufferPointer}=obj.handlePicBW.CData;
                obj.PicBW = obj.handlePicBW.CData;
                obj.PicBuffer{2,obj.PicBufferPointer}=obj.PicBWisInvert;
            end
        end
        
        function delete(obj)
            %deconstructor
        end
        
    end
    
end
