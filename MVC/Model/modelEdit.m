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
        
        FileName; %Filename of the selected file.
        PathName; %Directory path of the selected RGB image.
        PicRGBFRPlanes;  %RGB image created from the color plane images red green blue and FarRed after brightness correction.
        PicRGBPlanes; %RGB image created from the color plane images red green and blue after brightness correction.
        PicRGBFRPlanesNoBC; %RGB image created from the color plane images red green blue and FarRed without brightness correction.
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
        PicPlaneGreen_adj; %Green color plane image after brightness adjustment. Used for classification.
        PicPlaneBlue_adj; %Blue color plane image after brightness adjustment. Used for classification.
        PicPlaneRed_adj; %Red color plane image after brightness adjustment. Used for classification.
        PicPlaneFarRed_adj; %Farred color plane image after brightness adjustment. Used for classification.
        PicPlaneGreen_BC; %Green color plane image after brightness adjustment, filtering and BackGround correction. Used for binarization only.
        PicPlaneBlue_BC; %Blue color plane image after brightness adjustment, filtering and BackGround correction. Used for binarization only.
        PicPlaneRed_BC; %Red color plane image after brightness adjustment, filtering and BackGround correction. Used for binarization only.
        PicPlaneFarRed_BC; %Farred color plane image after brightness adjustment, filtering and BackGround correction. Used for binarization only.
        PicBCBlue; %Brightness adjustment image for Blue color plane image.
        PicBCGreen; %Brightness adjustment image for Green color plane image.
        PicBCRed; %Brightness adjustment image for Red color plane image.
        PicBCFarRed; %Brightness adjustment image for FarRed color plane image.
        FilenameBCBlue; %FileName of the brightness adjustment image for Blue color plane image.
        FilenameBCGreen; %FileName of the brightness adjustment image for Green color plane image.
        FilenameBCRed; %FileName of the brightness adjustment image for Red color plane image.
        FilenameBCFarRed; %FileName of the brightness adjustment image for FarRed color plane image.
        
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
        
        busyIndicator; %Java object in the left bottom corner that shows whether the program is busy.
        busyObj; %All objects that are enabled during the calculation.
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
            
            obj.FileName = '';
            obj.PathName = '';
            obj.PicRGBFRPlanes = [];
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
            obj.PicBCBlue = [];
            obj.PicBCGreen = [];
            obj.PicBCRed = [];
            obj.PicBCFarRed = [];
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
            %               PathName of the RGB image. Also contains the
            %               RGB and the color plane images:
            %
            %               PicData{1}: filename RGB image
            %               PicData{2}: path RGB image
            %               PicData{3}: RGB image create from color plane
            %               Red Green Far Red and Blue
            %               PicData{4}: binary image
            %               PicData{5}: green plane image after brightness adjustment
            %               PicData{6}: blue plane image after brightness adjustment
            %               PicData{7}: red plane image after brightness adjustment
            %               PicData{8}: farred plane image after brightness adjustment
            %               PicData{9}: RGB image create from color plane
            %               Red Green and Blue
            %               PicData{10}: RGB image create from color plane
            %               Red Green Blue and Farred without brightness
            %               correction
            %               images
            %
            
            PicData{1} = obj.FileName;
            PicData{2} = obj.PathName;
            PicData{3} = obj.PicRGBFRPlanes;   %RGB
            
            % send binary pic to controller only in the normal non-inverted
            % form
            if strcmp(obj.PicBWisInvert,'true')
                PicData{4} = ~obj.handlePicBW.CData;    %BW
            else
                PicData{4} = obj.handlePicBW.CData;
            end
            
            PicData{5} = obj.PicPlaneGreen_adj;
            PicData{6} = obj.PicPlaneBlue_adj;
            PicData{7} = obj.PicPlaneRed_adj;
            PicData{8} = obj.PicPlaneFarRed_adj;
            PicData{9} = obj.PicRGBPlanes;
            PicData{10} = obj.PicRGBFRPlanesNoBC;
            PicData{11} = obj.PicBCGreen;
            PicData{12} = obj.FilenameBCGreen;
            PicData{13} = obj.PicBCBlue;
            PicData{14} = obj.FilenameBCBlue;
            PicData{15} = obj.PicBCRed;
            PicData{16} = obj.FilenameBCRed;
            PicData{17} = obj.PicBCFarRed;
            PicData{18} = obj.FilenameBCFarRed;
        end
        
        function success = searchBioformat(obj)
            % When the user select a RGB image this function searches
            % for the bioformt file that contains the color plane images
            % and the brightness adjustment images in the same directory as
            % the selected RGB image.
            %
            %   PicData = sucsess = searchLoadBioformat(obj)
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
            
            obj.InfoMessage = ['  - ' obj.FileName ' was selected'];
            
            obj.InfoMessage = '   - searching for bio format file';
            
            [pathstr,name,ext] = fileparts([obj.PathName obj.FileName]);
            f = fullfile(pathstr,name);
            
            % Searching for supported bio foramt files with the same name
            % as the selectd image
            FileNameBio = [];
            if isempty(FileNameBio)
                FileNameBio = dir([f '.zvi']);
            end
            if isempty(FileNameBio)
                FileNameBio = dir([f '.lsm']);
            end
            if isempty(FileNameBio)
                FileNameBio = dir([f '.ics']);
            end
            if isempty(FileNameBio)
                FileNameBio = dir([f '.nd2']);
            end
            if isempty(FileNameBio)
                FileNameBio = dir([f '.dv']);
            end
            if isempty(FileNameBio)
                FileNameBio = dir([f '.img']);
            end
            
            
            if exist([obj.PathName FileNameBio.name], 'file') == 2
                %bioformat file was found
                obj.FileName = FileNameBio.name;
                obj.InfoMessage = '      - bio format file found';
                
                success = true;
            else
                obj.InfoMessage = '   - ERROR searching for bio format file';
                obj.InfoMessage = '      - bio format file not found';
                
                infotext = {'Error while opening color plane pictures!',...
                    '',...
                    'Color plane pictures (bioformat file (.zvi ; .lsm ; ...) ) not found.',...
                    '',...
                    'Bioformat file must be in the same path as the selected RGB image.',...
                    'Bioformat file must be named as the selected RGB image.',...
                    '',...
                    'You can open supported bioformat files directly.',...
                    '',...
                    'See MANUAL for more details.',...
                    };
                success = false;
                
                %show info message on gui
                obj.controllerEditHandle.viewEditHandle.infoMessage(infotext);
            end
        end
        
        function status = openBioformat(obj)
            % When the user select a bioformat file this function opens
            % the bioformt file that contains the color plane images.
            % The funcion also searches for the brightness adjustment
            % images in the same directory as the selected file.
            %
            %   PicData = sucsess = searchLoadBioformat(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:        Handle to modelEdit object
            %
            %       - Output
            %           status:    returns 'SuccessIndentify' if the color
            %               plane images were founded and identified.
            %               Returns 'ErrorIndentify' if the images were
            %               foundet but not identified. Returns 'false' if
            %               no images were found.
            %
            % See: http://www.openmicroscopy.org/site/support/bio-formats5.3/developers/matlab-dev.html
            
            %Open bioformat file
            data = bfopen([obj.PathName obj.FileName]);
            reader = bfGetReader([obj.PathName obj.FileName]);
            
            %Number of Series in file
            seriesCount = size(data, 1);
            series1 = data{1, 1};
            series1_planeCount = size(series1, 1);
            series1_label1 = series1{1, 2};
            %get meta Data
            metadata = data{1, 2};
            %The OME metadata is always stored the same way, regardless of input file format.
            omeMeta = data{1, 4};
            
            metadata = data{1, 2};
            subject = metadata.get('Subject');
            title = metadata.get('Title');
            
            metadataKeys = metadata.keySet().iterator();
            for i=1:metadata.size()
                key = metadataKeys.nextElement();
                value = metadata.get(key);
                MetaData{i,1}=sprintf('%s', key);
                MetaData{i,2}=sprintf('%s', value);
            end
            
            %get Number of Color Planes
            NumberOfPlanes = size(data{1,1},1);
            
            if (NumberOfPlanes == 3 || NumberOfPlanes == 4) && seriesCount == 1
                
                if NumberOfPlanes == 3
                    
                    obj.InfoMessage = '   - 3 plane images';
                    
                    obj.PicPlane1 = bfGetPlane(reader,1);
                    obj.PicPlane2 = bfGetPlane(reader,2);
                    obj.PicPlane3 = bfGetPlane(reader,3);
                    
                    %Set Farred to zero
                    obj.PicPlaneFarRed = zeros(size(obj.PicPlane1));
                    
                    obj.InfoMessage = '   - indentifing planes';
                    
                    %get ColorPlane Info from metaData
                    [ch_order, ch_wave_name, ch_rgb, ch_rgbname] = get_channel_info(omeMeta);
                    
                    if size(ch_wave_name,2) ~= 3
                        
                        obj.InfoMessage = '   -ERROR while indentifing planes';
                        obj.InfoMessage = '      -can not indentifing planes';
                        obj.InfoMessage = '      -no channel color name were found in meta data';
                        
                        %find RGB image with the same file name and use
                        %this for plane identification
                        sucsess = obj.planeIdentifier();
                        
                        if sucsess == true
                            status = 'SuccessIndentify';
                            foundBlue = 1;
                            foundGreen = 1;
                            foundRed = 1;
                        else
                            obj.InfoMessage = 'ERROR while indentifing planes';
                            obj.InfoMessage = '   -cange planes by pressing the "Check planes" button';
                            status = 'ErrorIndentify';
                            foundBlue = 0;
                            foundGreen = 0;
                            foundRed = 0;
                            obj.PicPlaneBlue = obj.PicPlane1;
                            obj.PicPlaneRed = obj.PicPlane2;
                            obj.PicPlaneGreen = obj.PicPlane3;
                            obj.PicPlaneFarRed = zeros(size(obj.PicPlane1));
                        end
                        
                        
                    else
                        foundBlue = 0;
                        foundGreen = 0;
                        foundRed = 0;
                        
                        for i=1:1:NumberOfPlanes
                            
                            if ( ~isempty(strfind(ch_wave_name{1,i},'Blue')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'A4')) ) && ~foundBlue
                                
                                obj.PicPlaneBlue = bfGetPlane(reader,i);
                                obj.InfoMessage = ['      - plane ' num2str(i) ' identified as ' ch_wave_name{1,i}];
                                foundBlue = 1;
                                
                            elseif ( ~isempty(strfind(ch_wave_name{1,i},'Red')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'TX2')) ) && ~foundRed
                                
                                obj.PicPlaneRed = bfGetPlane(reader,i);
                                obj.InfoMessage = ['      - plane ' num2str(i) ' identified as ' ch_wave_name{1,i}];
                                foundRed = 1;
                                
                            elseif ( ~isempty(strfind(ch_wave_name{1,i},'Green')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'L5')) ) && ~foundGreen
                                
                                obj.PicPlaneGreen = bfGetPlane(reader,i);
                                obj.InfoMessage = ['      - plane ' num2str(i) ' identified as ' ch_wave_name{1,i}];
                                foundGreen = 1;
                                
                            else
                                
                                obj.InfoMessage = ['   -ERROR while indentifing plane ' num2str(i)];
                                obj.InfoMessage = '      -no channel color name were found in meta data';
                                
                            end
                            
                        end %end for I:noPlanes
                        
                        
                        
                        if foundBlue && foundRed && foundGreen
                            status = 'SucsessIndentify';
                        else
                            %find RGB image with the same file name and use
                            %this for plane identification
                            sucsess = obj.planeIdentifier();
                            
                            if sucsess == true
                                status = 'SuccessIndentify';
                            else
                                obj.InfoMessage = 'ERROR while indentifing planes';
                                obj.InfoMessage = '   -cange planes by pressing the "Check planes" button';
                                status = 'ErrorIndentify';
                                obj.PicPlaneBlue = obj.PicPlane1;
                                obj.PicPlaneRed = obj.PicPlane2;
                                obj.PicPlaneGreen = obj.PicPlane3;
                                obj.PicPlaneFarRed = zeros(size(obj.PicPlane1));
                            end
                        end
                    end %end size Channel Name
                    
                elseif NumberOfPlanes == 4
                    obj.InfoMessage = '   - 4 plane images';
                    
                    obj.PicPlane1 = bfGetPlane(reader,1);
                    obj.PicPlane2 = bfGetPlane(reader,2);
                    obj.PicPlane3 = bfGetPlane(reader,3);
                    obj.PicPlane4 = bfGetPlane(reader,4);
                    
                    obj.InfoMessage = '   - indentifing planes';
                    
                    %get ColorPlane Info from metaData
                    [ch_order, ch_wave_name, ch_rgb, ch_rgbname] = get_channel_info(omeMeta);
                    
                    
                    if size(ch_wave_name,2) ~= 4
                        
                        obj.InfoMessage = '   -ERROR while indentifing planes';
                        obj.InfoMessage = '      -can not indentifing planes';
                        obj.InfoMessage = '      -no channel color name were found in meta data';
                        
                        %find RGB image with the same file name and use
                        %this for plane identification
                        sucsess = obj.planeIdentifier();
                        
                        if sucsess == true
                            status = 'SuccessIndentify';
                            foundBlue = 1;
                            foundGreen = 1;
                            foundRed = 1;
                            foundFarRed = 1;
                        else
                            obj.InfoMessage = 'ERROR while indentifing planes';
                            obj.InfoMessage = '   -cange planes by pressing the "Check planes" button';
                            status = 'ErrorIndentify';
                            foundBlue = 0;
                            foundGreen = 0;
                            foundRed = 0;
                            foundFarRed = 0;
                            obj.PicPlaneBlue = obj.PicPlane1;
                            obj.PicPlaneRed = obj.PicPlane2;
                            obj.PicPlaneGreen = obj.PicPlane3;
                            obj.PicPlaneFarRed = obj.PicPlane4;
                        end
                        
                        
                    else
                        foundBlue = 0;
                        foundGreen = 0;
                        foundRed = 0;
                        foundFarRed = 0;
                        
                        for i=1:1:NumberOfPlanes
                            
                            if ( ~isempty(strfind(ch_wave_name{1,i},'Blue')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'A4')) ) && ~foundBlue
                                
                                obj.PicPlaneBlue = bfGetPlane(reader,i);
                                obj.InfoMessage = ['      - plane ' num2str(i) ' identified as ' ch_wave_name{1,i}];
                                foundBlue = 1;
                                
                            elseif ( ~isempty(strfind(ch_wave_name{1,i},'Far Red')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'FarRed')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'Farred')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'Y5')) ) && ~foundFarRed
                                
                                obj.PicPlaneFarRed = bfGetPlane(reader,i);
                                obj.InfoMessage = ['      - plane ' num2str(i) ' identified as ' ch_wave_name{1,i}];
                                foundFarRed = 1;
                                
                                
                            elseif ( ~isempty(strfind(ch_wave_name{1,i},'Red')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'TX2')) ) && ~foundRed
                                
                                obj.PicPlaneRed = bfGetPlane(reader,i);
                                obj.InfoMessage = ['      - plane ' num2str(i) ' identified as ' ch_wave_name{1,i}];
                                foundRed = 1;
                                
                            elseif ( ~isempty(strfind(ch_wave_name{1,i},'Green')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'L5')) ) && ~foundGreen
                                
                                obj.PicPlaneGreen = bfGetPlane(reader,i);
                                obj.InfoMessage = ['      - plane ' num2str(i) ' identified as ' ch_wave_name{1,i}];
                                foundGreen = 1;
                                
                            else
                                
                                obj.InfoMessage = ['   -ERROR while indentifing plane ' num2str(i)];
                                obj.InfoMessage = '      -no channel color name were found in meta data';
                                
                            end
                        end %end for I:noPlanes
                        
                        
                        if foundBlue && foundRed && foundGreen && foundFarRed
                            status = 'SucsessIndentify';
                        else
                            %find RGB image with the same file name and use
                            %this for plane identification
                            sucsess = obj.planeIdentifier();
                            
                            if sucsess == true
                                status = 'SuccessIndentify';
                            else
                                obj.InfoMessage = 'ERROR while indentifing planes';
                                obj.InfoMessage = '   -cange planes by pressing the "Check planes" button';
                                status = 'ErrorIndentify';
                                obj.PicPlaneBlue = obj.PicPlane1;
                                obj.PicPlaneRed = obj.PicPlane2;
                                obj.PicPlaneGreen = obj.PicPlane3;
                                obj.PicPlaneFarRed = obj.PicPlane4;
                            end
                            
                        end
                    end %end size Channel Name
                    
                end %end NumerPlanes =3 elseif = 4
                
                % Searching for brightness adjustment Pics
                obj.InfoMessage = '   - searching for brightness adjustment images';
                
                %Save currebt folder
                currentFolder = pwd;
                %go to the directory of the RGB image
                cd(obj.PathName);
                
                %search for brightness adjustment images
                [pathstr,name,ext] = fileparts([obj.PathName obj.FileName]);
                
                %find filenemes that started with the letter A for filter A
                %images
                filesA= dir(['A*' ext]);
                filesAname = {filesA.name};
                
                %find filenemes that started with the letter L for filter L
                %images
                filesL= dir(['L*' ext]);
                filesLname = {filesA.name};
                
                %find filenemes that started with the letter T for filter T
                %images
                filesT= dir(['T*' ext]);
                filesTname = {filesA.name};
                
                %find filenemes that started with the letter Y for filter Y
                %images
                filesY= dir(['Y*' ext]);
                filesYname = {filesA.name};
                
                if any(~cellfun(@isempty,regexp(ch_wave_name,'A[0-9]')))
                    FN = regexp(filesAname,'A[0-9]');
                    if any(~cellfun(@isempty,FN))
                        name = filesAname{find(~cellfun(@isempty,FN))};
                        FileNamePicBCBlue = dir(name);
                    else
                        FileNamePicBCBlue = [];
                    end
                elseif any(~cellfun(@isempty,regexp(ch_wave_name,'A[^0-9]')))
                    FN = regexp(filesAname,'A[^0-9]');
                    if any(~cellfun(@isempty,FN))
                        name = filesAname{find(~cellfun(@isempty,FN))};
                        FileNamePicBCBlue = dir(name);
                    else
                        FileNamePicBCBlue = [];
                    end
                    
                else
                    FileNamePicBCBlue = [];
                end
                
                FileNamePicBCGreen = dir(['L*' ext]);
                FileNamePicBCRed = dir(['TX*' ext]);
                FileNamePicBCFarRed = dir(['Y*' ext]);
                
                cd(currentFolder);
                
                if ~isempty(FileNamePicBCBlue)
                    %A4*.zvi brightness adjustment image were found
                    readertemp = bfGetReader([obj.PathName FileNamePicBCBlue(1).name]);
                    obj.PicBCBlue = double(bfGetPlane(readertemp,1));
                    obj.PicBCBlue = obj.PicBCBlue/max(max(obj.PicBCBlue));
                    obj.FilenameBCBlue = FileNamePicBCBlue(1).name;
                    obj.InfoMessage = ['      - ' FileNamePicBCBlue(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - A*' ext ' file were not found'];
                    obj.FilenameBCBlue = '-';
                    obj.PicBCBlue = [];
                end
                
                if ~isempty(FileNamePicBCGreen)
                    %L5*.zvi brightness adjustment image were found
                    readertemp = bfGetReader([obj.PathName FileNamePicBCGreen(1).name]);
                    obj.PicBCGreen = double(bfGetPlane(readertemp,1));
                    obj.PicBCGreen = obj.PicBCGreen/max(max(obj.PicBCGreen));
                    obj.FilenameBCGreen = FileNamePicBCGreen(1).name;
                    obj.InfoMessage = ['      - ' FileNamePicBCGreen(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - L5*' ext ' file were not found'];
                    obj.FilenameBCGreen = '-';
                    obj.PicBCGreen = [];
                end
                
                if ~isempty(FileNamePicBCRed)
                    %TX*.zvi brightness adjustment image were found
                    readertemp = bfGetReader([obj.PathName FileNamePicBCRed(1).name]);
                    obj.PicBCRed = double(bfGetPlane(readertemp,1));
                    obj.PicBCRed = obj.PicBCRed/max(max(obj.PicBCRed));
                    obj.FilenameBCRed = FileNamePicBCRed(1).name;
                    obj.InfoMessage = ['      - ' FileNamePicBCRed(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - TX*' ext ' file were not found'];
                    obj.FilenameBCRed = '-';
                    obj.PicBCRed = [];
                end
                
                if ~isempty(FileNamePicBCFarRed)
                    %Y5*.zvi brightness adjustment image were found
                    readertemp = bfGetReader([obj.PathName FileNamePicBCFarRed(1).name]);
                    obj.PicBCFarRed = double(bfGetPlane(readertemp,1));
                    obj.PicBCFarRed = obj.PicBCFarRed/max(max(obj.PicBCFarRed));
                    obj.FilenameBCFarRed = FileNamePicBCFarRed(1).name;
                    obj.InfoMessage = ['      - ' FileNamePicBCFarRed(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - Y5*' ext ' file were not found'];
                    obj.FilenameBCFarRed = '-';
                    obj.PicBCFarRed = [];
                end
                
                cd(currentFolder);
                
                if isempty(obj.PicBCFarRed) || isempty(obj.PicBCFarRed) || ...
                        isempty(obj.PicBCFarRed) || isempty(obj.PicBCFarRed)
                    
                    infotext = {'Info! ',...
                        '',...
                        'Not all brightness adjustment images were found.',...
                        '',...
                        'Go to the "Check planes" menu to verify the images:',...
                        'The following options are available:',...
                        '   - you can select new brightness images from',...
                        '     your hard drive.',...
                        '   - you can calculate new brightness images from the',...
                        '     background illumination.',...
                        '   - you can delete incorrect or unnecessary images',...
                        '',...
                        'See MANUAL for more details.',...
                        };
                    %show info message on gui
                    obj.controllerEditHandle.viewEditHandle.infoMessage(infotext);
                    
                end
            else
                % no 4 planes founded
                status = 'false';
            end
            
        end
        
        function createRGBImages(obj)
            tempR = obj.PicPlaneRed_adj;
            tempB = obj.PicPlaneBlue_adj;
            tempG = obj.PicPlaneGreen_adj;
            tempFR = obj.PicPlaneFarRed_adj;
            
            tempR3D(:,:,1) = double(255*ones(size(tempR))).*(double(tempR)/255);
            tempR3D(:,:,2) = double(0*ones(size(tempR))).*(double(tempR)/255);
            tempR3D(:,:,3) = double(0*ones(size(tempR))).*(double(tempR)/255);
            
            tempG3D(:,:,1) = double(0*ones(size(tempG))).*(double(tempG)/255);
            tempG3D(:,:,2) = double(255*ones(size(tempG))).*(double(tempG)/255);
            tempG3D(:,:,3) = double(0*ones(size(tempG))).*(double(tempG)/255);
            
            tempB3D(:,:,1) = double(0*ones(size(tempB))).*(double(tempB)/255);
            tempB3D(:,:,2) = double(0*ones(size(tempB))).*(double(tempB)/255);
            tempB3D(:,:,3) = double(255*ones(size(tempB))).*(double(tempB)/255);
            
            tempY3D(:,:,1) = double(255*ones(size(tempFR))).*(double(tempFR)/255);
            tempY3D(:,:,2) = double(255*ones(size(tempFR))).*(double(tempFR)/255);
            tempY3D(:,:,3) = double(0*ones(size(tempFR))).*(double(tempFR)/255);
            
            obj.PicRGBFRPlanes = uint8(tempR3D + tempG3D + tempB3D + tempY3D);
            
            obj.PicRGBPlanes = uint8(tempR3D + tempG3D + tempB3D );
            
            % Create RGB image without brightness correction
            tempR = obj.PicPlaneRed;
            tempB = obj.PicPlaneBlue;
            tempG = obj.PicPlaneGreen;
            tempFR = obj.PicPlaneFarRed;
            
            tempR3D(:,:,1) = double(255*ones(size(tempR))).*(double(tempR)/255);
            tempR3D(:,:,2) = double(0*ones(size(tempR))).*(double(tempR)/255);
            tempR3D(:,:,3) = double(0*ones(size(tempR))).*(double(tempR)/255);
            
            tempG3D(:,:,1) = double(0*ones(size(tempG))).*(double(tempG)/255);
            tempG3D(:,:,2) = double(255*ones(size(tempG))).*(double(tempG)/255);
            tempG3D(:,:,3) = double(0*ones(size(tempG))).*(double(tempG)/255);
            
            tempB3D(:,:,1) = double(0*ones(size(tempB))).*(double(tempB)/255);
            tempB3D(:,:,2) = double(0*ones(size(tempB))).*(double(tempB)/255);
            tempB3D(:,:,3) = double(255*ones(size(tempB))).*(double(tempB)/255);
            
            tempY3D(:,:,1) = double(255*ones(size(tempFR))).*(double(tempFR)/255);
            tempY3D(:,:,2) = double(255*ones(size(tempFR))).*(double(tempFR)/255);
            tempY3D(:,:,3) = double(0*ones(size(tempFR))).*(double(tempFR)/255);
            
            obj.PicRGBFRPlanesNoBC = uint8(tempR3D + tempG3D + tempB3D + tempY3D);
        end
        
        function success = planeIdentifier(obj)
            % If the indetification with the meta data of the bio format
            % file failed, this fuction searches for an RGB image with the
            % same name as the selected file. If the program find a image
            % file than the identification will be executed.
            %
            %   planeIdentifier(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            %       - Output:
            %           success: returns 'true' if the identification was
            %                    successful otherwise 'false'.
            %
            obj.InfoMessage = '   - trying to identify color planes with RGB image';
            if isequal(obj.FileName ,0) && isequal(obj.PathName,0)
                success = 'false';
                obj.InfoMessage = '   - indentifing planes canceled';
            else
                obj.InfoMessage = '      - searching for RGB image';
                obj.InfoMessage = '         - must have the same filename as the bioformat file';
                
                %searching for RGB image
                [pathstr,name,ext] = fileparts([obj.PathName obj.FileName]);
                
                RGBimageName = [];
                if isempty(RGBimageName)
                    RGBimageName = dir([obj.PathName name '.jpg']);
                end
                if isempty(RGBimageName)
                    RGBimageName = dir([obj.PathName name '.tif']);
                end
                if isempty(RGBimageName)
                    RGBimageName = dir([obj.PathName name '.jpeg']);
                end
                if isempty(RGBimageName)
                    RGBimageName = dir([obj.PathName name '.png']);
                end
                
                if ~isempty(RGBimageName)
                    
                    RGBimage = imread([obj.PathName RGBimageName.name]);
                    
                    obj.InfoMessage = '      - found RGB image';
                    obj.InfoMessage = '      - identify color plane...';
                    
                    %Save unidentified plane images in one array
                    Pic= cat(3,obj.PicPlane1 ,obj.PicPlane2 ,obj.PicPlane3 ,obj.PicPlane4 );
                    
                    %Dismantling the RGB image into its color channels
                    R=imadjust( RGBimage(:,:,1) ); %Red channel
                    G=imadjust( RGBimage(:,:,2) ); %Green channel
                    B=imadjust( RGBimage(:,:,3) ); %Blue channel
                    
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
                                    r(plane,:) = -Inf;
%                                     Pic(:,:,plane) = [];
                                    obj.InfoMessage = '         - red-plane was identified';
                                else
                                    %farred plane was identified
                                    %save farred plane temporary
                                    tempFR = Pic(:,:,plane);
                                    %clear foundet plane and color in the r array
                                    r(plane,:) = -Inf;
%                                     Pic(:,:,plane) = [];
                                    r(:,color) = -Inf;
                                    obj.InfoMessage = '         - farred-plane was identified';
                                end
                                
                            case 2  %Green
                                %green plane was identified
                                %save green plane temporary
                                tempG = Pic(:,:,plane);
                                r(plane,:) = -Inf;
                                r(:,color) = -Inf;
%                                 Pic(:,:,plane) = [];
                                obj.InfoMessage = '         - green-plane was identified';
                                
                            case 3  %Blue
                                %blue plane was identified
                                %save blue plane temporary
                                tempB = Pic(:,:,plane);
                                %clear foundet plane and color in the r array
                                r(plane,:) = -Inf;
                                r(:,color) = -Inf;
%                                 Pic(:,:,plane) = [];
                                obj.InfoMessage = '         - blue-plane was identified';
                        end
                    end
                    
                    %Save identified planes in the properties
                    obj.PicPlaneGreen = tempG;
                    obj.PicPlaneBlue = tempB;
                    obj.PicPlaneRed = tempR;
                    obj.PicPlaneFarRed = tempFR;
                    success = true;
                else
                    % no RGB image were found
                    success = false;
                    
                end
                
                
                
            end
        end
        
        function brightnessAdjustment(obj)
            % Perform a brightness correction with the brightness
            % adjustment images on the color plane pictures. If no brightness
            % adjustment images were found than the fuction performs the
            % imadjust() function from the image processing toolbox. Trys
            % to seperate the foreground from the background. Adjustment
            % images will not be used for classification.
            %
            %
            %   brightnessAdjustment(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
            
            obj.InfoMessage = '   - brightness adjustment';
            if isequal(obj.FileName ,0) && isequal(obj.PathName,0)
                obj.InfoMessage = '   - pictures brightness adjustment canceled';
            else
                %brightness adjustment PicPlaneGreen
                if ~isempty(obj.PicBCGreen)
                    obj.InfoMessage = '      - adjust green plane';
                    PicMF = medfilt2(obj.PicBCGreen,[5 5],'symmetric');
                    PicMFnorm = double(PicMF)./double(max(max(PicMF)));
                    PicBC = double(obj.PicPlaneGreen)./double(PicMFnorm);
                    PicBC = PicBC./max(max(PicBC))*double(max(max(obj.PicPlaneGreen)));
                    obj.PicPlaneGreen_adj = uint8(PicBC);
                    
%                     figure('name','green BC')
%                     surf(div,'EdgeColor','none')
%                     figure('name','green Plane')
%                     surf(obj.PicPlaneGreen,'EdgeColor','none')
%                     figure('name','green Plane adj')
%                     surf(obj.PicPlaneGreen_adj,'EdgeColor','none')
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicBCGreen not found';
                    obj.PicPlaneGreen_adj = obj.PicPlaneGreen;
                end
                
                %brightness adjustment PicPlaneRed
                if ~isempty(obj.PicBCRed)
                    obj.InfoMessage = '      - adjust red plane';
                    PicMF = medfilt2(obj.PicBCRed,[5 5],'symmetric');
                    PicMFnorm = double(PicMF)/double(max(max(PicMF)));
                    PicBC = double(obj.PicPlaneRed)./double(PicMFnorm);
                    PicBC = PicBC./max(max(PicBC))*double(max(max(obj.PicPlaneRed)));
                    obj.PicPlaneRed_adj = uint8(PicBC);
                    
%                     figure('name','red BC')
%                     surf(div,'EdgeColor','none')
%                     figure('name','red Plane')
%                     surf(obj.PicPlaneRed,'EdgeColor','none')
%                     figure('name','red Plane adj')
%                     surf(obj.PicPlaneRed_adj,'EdgeColor','none')
                else
                    obj.InfoMessage = '      - PicBCRed not found';
                    obj.PicPlaneRed_adj = obj.PicPlaneRed;
                end
                
                %brightness adjustment PicPlaneBlue
                if ~isempty(obj.PicBCBlue)
                    obj.InfoMessage = '      - adjust blue plane';
                    PicMF = medfilt2(obj.PicBCBlue,[5 5],'symmetric');
                    PicMFnorm = double(PicMF)/double(max(max(PicMF)));
%                     minP = min(obj.PicPlaneBlue(:)); %min Plane Original
                    maxP = double( max(obj.PicPlaneBlue(:)) ); %max Plane Original
                    PicBC = double(obj.PicPlaneBlue)./double(PicMFnorm);
                    minPBC = double(min(PicBC(:))); %min Plane afer BC
%                     maxPBC = max(PicBC(:)); %max Plane after BC
                    PicBC = ((PicBC-minPBC)/max(max((PicBC-minPBC)))*(maxP-minPBC))+minPBC;
%                     PicBC = PicBC./max(max(PicBC))*double(max(max(obj.PicPlaneBlue)));
                    obj.PicPlaneBlue_adj = uint8(PicBC);
                    
%                     figure('name','blue BC')
%                     surf(div,'EdgeColor','none')
%                     figure('name','blue Plane')
%                     surf(obj.PicPlaneBlue,'EdgeColor','none')
%                     figure('name','blue Plane adj')
%                     surf(obj.PicPlaneBlue_adj,'EdgeColor','none')
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicBCBlue not found';
                    obj.PicPlaneBlue_adj = obj.PicPlaneBlue;
                end
                
                %brightness adjustment PicPlaneFarRed
                if ~isempty(obj.PicBCFarRed)
                    obj.InfoMessage = '      - adjust farred plane';
                    PicMF = medfilt2(obj.PicBCFarRed,[5 5],'symmetric');
                    PicMFnorm = double(PicMF)/double(max(max(PicMF)));
                    PicBC = double(obj.PicPlaneFarRed)./double(PicMFnorm);
                    maxP = double( max(obj.PicPlaneFarRed(:)) ); %max Plane Original
                    minPBC = double(min(PicBC(:))); %min Plane afer BC
                    PicBC = ((PicBC-minPBC)/max(max((PicBC-minPBC)))*(maxP-minPBC))+minPBC;
                    PicBC = PicBC./max(max(PicBC))*double(max(max(obj.PicPlaneFarRed)));
                    obj.PicPlaneFarRed_adj = uint8(PicBC);
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicY4 not found';
                    obj.PicPlaneFarRed_adj = obj.PicPlaneFarRed;
                end
                
            end
            obj.InfoMessage = '   - brightness adjustment finished';
            
            
            
        end
        
        function calculateBackgroundIllumination(obj,plane)
%             obj.controllerEditHandle.busyIndicator(1);
            switch plane
                
                case 'Green'
                    
                    obj.InfoMessage = '      - create image for Green Plane adjustment';
                    obj.InfoMessage = '         - try to calculate the background illumination';
                    obj.InfoMessage = '            - determine mean area of fibers';
                    %use green plane to get Area of fibers
                    PlaneBW = imbinarize(obj.PicPlaneGreen,'adaptive','ForegroundPolarity','bright');
                    PlaneBW = ~PlaneBW;
                    PlaneBW = imfill(PlaneBW,8,'holes');
                    stats = regionprops('struct',PlaneBW,'Area');
                    %Sort area from small to large
                    Area = [stats(:).Area];
                    Area = sort(Area);
                    %mean area  value of the biggest fibers
                    AreaBig = Area(round(length(Area)*(2/3)):end);
                    MeanArea = mean(AreaBig);
                    obj.InfoMessage = '            - determine fiber radius';
                    %radius of mean area
                    radius = sqrt(MeanArea/pi);
                    %double radius to be sure that the structering element
                    %is bigger than the fibers
                    radius=ceil(radius)*3;
                    obj.InfoMessage = '            - calculate background profile';
                    background = imopen(obj.PicPlaneGreen,strel('disk',radius));
                    h = fspecial('disk', radius);
                    obj.InfoMessage = '            - smoothing background profile';
                    smoothedBackground = imfilter(single(background), h, 'replicate');
                    %Normalized Background to 1
                    smoothedBackground = smoothedBackground/max(max(smoothedBackground));
                    obj.PicBCGreen = smoothedBackground;
                    obj.FilenameBCGreen = 'calculated from Green plane background';
                    
                case 'Blue'
                    
                    obj.InfoMessage = '      - create image for Blue Plane adjustment';
                    obj.InfoMessage = '         - try to calculate the background illumination';
                    obj.InfoMessage = '            - determine mean area of fibers';
                    %use green plane to get Area of fibers
                    PlaneBW = imbinarize(obj.PicPlaneGreen,'adaptive','ForegroundPolarity','bright');
                    PlaneBW = ~PlaneBW;
                    PlaneBW = imfill(PlaneBW,8,'holes');
                    stats = regionprops('struct',PlaneBW,'Area');
                    %Sort area from small to large
                    Area = [stats(:).Area];
                    Area = sort(Area);
                    %mean area  value of the biggest fibers
                    AreaBig = Area(round(length(Area)*(2/3)):end);
                    MeanArea = mean(AreaBig);
                    obj.InfoMessage = '            - determine fiber radius';
                    %radius of mean area
                    radius = sqrt(MeanArea/pi);
                    %double radius to be sure that the structering element
                    %is bigger than the fibers
                    radius=ceil(radius)*3;
                    obj.InfoMessage = '            - calculate background profile';
                    background = imopen(obj.PicPlaneBlue,strel('disk',radius));
                    h = fspecial('disk', radius);
                    obj.InfoMessage = '            - smoothing background profile';
                    smoothedBackground = imfilter(single(background), h, 'replicate');
                    %Normalized Background to 1
                    smoothedBackground = smoothedBackground/max(max(smoothedBackground));
                    obj.PicBCBlue = smoothedBackground;
                    obj.FilenameBCBlue = 'calculated from Blue plane background';
                    
                case 'Red'
                    
                    obj.InfoMessage = '      - create image for Red Plane adjustment';
                    obj.InfoMessage = '         - try to calculate the background illumination';
                    obj.InfoMessage = '            - determine mean area of fibers';
                    %use green plane to get Area of fibers
                    PlaneBW = imbinarize(obj.PicPlaneGreen,'adaptive','ForegroundPolarity','bright');
                    PlaneBW = ~PlaneBW;
                    PlaneBW = imfill(PlaneBW,8,'holes');
                    stats = regionprops('struct',PlaneBW,'Area');
                    %Sort area from small to large
                    Area = [stats(:).Area];
                    Area = sort(Area);
                    %mean area  value of the biggest fibers
                    AreaBig = Area(round(length(Area)*(2/3)):end);
                    MeanArea = mean(AreaBig);
                    obj.InfoMessage = '            - determine fiber radius';
                    %radius of mean area
                    radius = sqrt(MeanArea/pi);
                    %double radius to be sure that the structering element
                    %is bigger than the fibers
                    radius=ceil(radius)*3;
                    obj.InfoMessage = '            - calculate background profile';
                    background = imopen(obj.PicPlaneRed,strel('disk',radius));
                    h = fspecial('disk', radius);
                    obj.InfoMessage = '            - smoothing background profile';
                    smoothedBackground = imfilter(single(background), h, 'replicate');
                    %Normalized Background to 1
                    smoothedBackground = smoothedBackground/max(max(smoothedBackground));
                    obj.PicBCRed = smoothedBackground;
                    obj.FilenameBCRed = 'calculated from Red plane background';
                    
                case 'Farred'
                    
                    obj.InfoMessage = '      - create image for Farred Plane adjustment';
                    obj.InfoMessage = '         - try to calculate the background illumination';
                    obj.InfoMessage = '            - determine mean area of fibers';
                    %use green plane to get Area of fibers
                    PlaneBW = imbinarize(obj.PicPlaneGreen,'adaptive','ForegroundPolarity','bright');
                    PlaneBW = ~PlaneBW;
                    PlaneBW = imfill(PlaneBW,8,'holes');
                    stats = regionprops('struct',PlaneBW,'Area');
                    %Sort area from small to large
                    Area = [stats(:).Area];
                    Area = sort(Area);
                    %mean area  value of the biggest fibers
                    AreaBig = Area(round(length(Area)*(2/3)):end);
                    MeanArea = mean(AreaBig);
                    obj.InfoMessage = '            - determine fiber radius';
                    %radius of mean area
                    radius = sqrt(MeanArea/pi);
                    %double radius to be sure that the structering element
                    %is bigger than the fibers
                    radius=ceil(radius)*3;
                    obj.InfoMessage = '            - calculate background profile';
                    background = imopen(obj.PicPlaneFarRed,strel('disk',radius));
                    h = fspecial('disk', radius);
                    obj.InfoMessage = '            - smoothing background profile';
                    smoothedBackground = imfilter(single(background), h, 'replicate');
                    %Normalized Background to 1
                    smoothedBackground = smoothedBackground/max(max(smoothedBackground));
                    obj.PicBCFarRed = smoothedBackground;
                    obj.FilenameBCFarRed = 'calculated from Farred plane background';
                    
                otherwise %calculate all missing images
                    disp('all missing');
                    
            end
%             obj.controllerEditHandle.busyIndicator(0);
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
%                             figure
% imhist(obj.PicPlaneGreen_adj)
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
%                             obj.addToBuffer();
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
            xMax = double(size(obj.PicBW,2));
            yMax = double(size(obj.PicBW,1));
            x = round(CurPos(1,1));
            y = round(CurPos(1,2));
            if x > xMax
                x = xMax;
            end
            if y > yMax
                y = yMax;
            end
            if x < 1
                x = 1;
            end
            if y < 1
                y = 1;
            end
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
            
            obj.x1 = double(CurPos(1,1));
            
            obj.y1 = double(CurPos(1,2));
            
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
%                 
%                 him=findobj('Tag','him');
%                 him.CData(obj.y1,obj.x1)=180;

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
%             obj.dx = double(obj.x1)-obj.x2;
%             obj.dy = double(obj.y1)-obj.y2;
            obj.dx = double(obj.x2-obj.x1);
            obj.dy = double(obj.y2-obj.y1);

            obj.abs_dx = ceil(abs(obj.dx));
            obj.abs_dy = ceil(abs(obj.dy));
            
            %calculate eucledian distance between the points.
%             obj.dist = sqrt((obj.abs_dx)^2+(obj.abs_dy)^2);
            
%             obj.x_v = double( sort([obj.x1 obj.x2]) );
%             obj.y_v = double( sort([obj.y1 obj.y2]) );
            
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
                    obj.xValues = (double(obj.x1)+i)*ones(1, obj.abs_dy*2);
                    %check if the values in the range if the image
                    obj.xValues(obj.xValues<1)=double(1);
                    obj.xValues(obj.xValues>xMax)=xMax;
                    
                    %crate y values vektor for the line
                    obj.yValues = linspace(obj.y1,obj.y2, obj.abs_dy*2);
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
                    obj.xValues = linspace(obj.x1,obj.x2,obj.abs_dx*3);
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
                    obj.yValues = linspace(obj.y1,obj.y2,obj.abs_dy*2);
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
                    obj.InfoMessage = ['      - ' num2str(max(max(L))) ' objects was found'];
                    
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
                    obj.InfoMessage = ['      - ' num2str(max(max(L))) ' objects was found'];

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
                
                case 'close'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'close',obj.NoIteration);
                    obj.InfoMessage = '      - close operation completed';    
                    
                case 'remove'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'remove',obj.NoIteration);
                    obj.InfoMessage = '      - remove operation completed';
                    
                case 'shrink'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'shrink',obj.NoIteration);
                    obj.InfoMessage = '      - shrink operation completed';
                    
                case 'majority'
                    
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'majority',obj.NoIteration);
                    obj.InfoMessage = '      - majority operation completed';
                    
                case 'smoothing'
                    
                    %performs the majority morph 500 times
                    obj.handlePicBW.CData = bwmorph(obj.handlePicBW.CData,'majority',Inf);
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
                    
                    %skel the temp binary image
                    tempPic = bwmorph(tempPic,'skel',Inf);
                    
                    %create small structering element
                    se = strel('disk',1);
                    
                    %perform n times a dilate with small SE
                    for i = 1:1:round(obj.NoIteration)
                        tempPic = imdilate(tempPic , se);
                        if mod(i,1)==0
                            tempPic = bwmorph(tempPic,'majority',1);
                        end
%                         figure
%                         imshow(tempPic)
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
                    
                case 'Remove incomplete objects'
                    
                    obj.InfoMessage = ['      - removing objects at the image border'];
                    
                    %Check invert status of the binary image
                    if strcmp(obj.PicBWisInvert,'true')
                        %image is invert. Fibers are foreground
                        tempPic = obj.handlePicBW.CData;
                    else
                        %image is in normal form. Collagen is Foreground
                        tempPic = ~obj.handlePicBW.CData;
                    end
                    
                    %create Label Mat
                    tempLabelMat = bwlabel(tempPic,8);
                    % get size of Label Mat
                    [m,n]=size(tempLabelMat);
                    %seperate x and y Edges
                    BordersX(1,:) =tempLabelMat(1,:); %Upper-X Axis
                    BordersX(2,:) =tempLabelMat(m,:); %Lower-X Axis
                    BordersY(1,:) =tempLabelMat(:,1); %Left-Y Axis
                    BordersY(2,:) =tempLabelMat(:,n); %Right-Y Axis
                    %Find Labels of Objects at the image edge
                    
                    EdgeObjectsX=unique(BordersX);
                    EdgeObjectsY=unique(BordersY);
                    EdgeObjects=cat(1,EdgeObjectsX,EdgeObjectsY);
                    EdgeObjects=unique(EdgeObjects);
                    if ~isempty(EdgeObjects)
                        for i=1:1:size(EdgeObjects,1)
                            tempPic(tempLabelMat==EdgeObjects(i))=0;
                        end
                    end
                    
                    %Check invert status of the binary image
                    if strcmp(obj.PicBWisInvert,'true')
                        %Update binary mask in inverted form
                        obj.handlePicBW.CData = tempPic;
                        obj.PicBW = tempPic;
                    else
                        %Update binary mask in normal form
                        obj.handlePicBW.CData = ~tempPic;
                        obj.PicBW = ~tempPic;
                    end
                otherwise
                    obj.InfoMessage = '! ERROR in runMorphOperation() FUNCTION !';
            end
            
            obj.addToBuffer();
        end
        
        function autoSetupBinarization(obj)
            obj.InfoMessage = '   - running auto setup binarization';
            
            obj.PicBW = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
            obj.PicBWisInvert = 'false';
            
            %create Gradient Magnitude image
            obj.InfoMessage = '      - compute Gradient-Magnitude image';
            hy = fspecial('sobel');
            hx = hy';
            Iy = imfilter(double(obj.PicPlaneGreen_adj), hy, 'replicate');
            Ix = imfilter(double(obj.PicPlaneGreen_adj), hx, 'replicate');
            gradmag = sqrt(Ix.^2 + Iy.^2); %image of Gradient Magnitude
            gradmag = medfilt2(gradmag,[5 5],'symmetric');

%             test = gradmag;
%             test(test>255)=255;
%             x = imbinarize(uint8(test),'adaptive','ForegroundPolarity','bright');
%             figure()
%             imshow(x,[])
% %             
%             x = imregionalmin(gradmag);
            
%             Hmin = imhmin(gradmag,round(MeanMinGradMag/3));
%             HminVec = Hmin(:,500);
%             grandmagVec = gradmag(:,500);
%             grandmagPlus = gradmag+round(MeanMinGradMag/3);
%             grandmagPlusVec = grandmagPlus(:,500);
%             figure
%             plot(grandmagVec,'k','LineWidth',2)
%             hold on
%             plot(grandmagPlusVec,'r','LineWidth',2)
%             hold on
%             plot(HminVec,'--b','LineWidth',2)
%             grid on
%             obj.InfoMessage = '      - compute fiber type markes';
%             LEG=legend('G`','G`+h','HMIN(G`)');
%             set(LEG,'FontSize',36)
%             set(gca,'FontSize',36)
%             %find mean value of all regional minima
            MeanMinGradMag=mean(gradmag(imregionalmin(gradmag)));
            
            MeanMinGradMag = round(MeanMinGradMag/3);
            if MeanMinGradMag < 3
                MeanMinGradMag = 3;
            end
            
            %extend regional minima using h-min transform
            MinMarker = imextendedmin(gradmag,round(MeanMinGradMag));
%             MaxMarker = imextendedmax(gradmag,200);
            %
            MinMarker = imfill(MinMarker,'holes');
            MinMarker = bwareaopen(MinMarker,5);
            MinMarker = imfill(MinMarker,'holes');
%             figure()
%             imshow(MinMarker)
            MinMarker = imclose(MinMarker,strel('disk',3));
            MinMarker = imerode(MinMarker,strel('disk',1));
            MinMarker = imfill(MinMarker,'holes');

%             figure()
%             imshow(MinMarker,[])
%             
            stats = regionprops('struct',MinMarker,'Area');
            MeanArea = mean([stats(:).Area]);
            obj.InfoMessage = '      - remove small fiber type markes';
            MinMarker = bwareaopen(MinMarker,round(MeanArea/10));

%             figure()
%             imshow(MinMarker)
            
            %Background Markers (currently not used)
            D = bwdist(MinMarker);
            DL = watershed(D);
            bgm = DL == 0;
%             figure()
%             imshow(bgm)
%             gradmag2 = imimposemin(gradmag, bgm | MinMarker);
            gradmag2 = imimposemin(gradmag, MinMarker);

            obj.InfoMessage = '      - perform watershed transformation';
            L = watershed(gradmag2);
            
            f2=zeros(size(L));
            f2(L==0)=1;
            se = strel('disk',1);
            f2 = imdilate(f2,se);
            obj.InfoMessage = '      - create binary mask';
            obj.PicBW = obj.PicBW | f2;
            obj.handlePicBW.CData = obj.PicBW | f2;
            
            obj.InfoMessage = '   - auto setup binarization completed';
        end
        
        function [xOut yOut isInAxes] = checkPosition(obj,PosX,PosY)
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
            %           xOut:   Corrected x position.
            %           yOut:   Corrected y position.
            %       isInAxes:   True if PosX and PoxY are within the Axes  
            %
            isInAxes = true;
            if PosX < 1
                PosX = 1;
                isInAxes = false;
            end
            
            if PosY < 1
                PosY = 1;
                isInAxes = false;
            end
            
            if PosX > size(obj.PicRGBFRPlanes,2)
                PosX = size(obj.PicRGBFRPlanes,2);
                isInAxes = false;
            end
            
            if PosY > size(obj.PicRGBFRPlanes,1)
                PosY = size(obj.PicRGBFRPlanes,1);
                isInAxes = false;
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
            % functionality. Saves the current binary mask in the PicBW
            % properties.
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
