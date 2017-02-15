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
                FileNameBio = dir([f '.lsm']);
            end
            if isempty(FileNameBio)
                FileNameBio = dir([f '.zvi']);
            end
            if isempty(FileNameBio)
                FileNameBio = dir([f '.zvi']);
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
            
            if NumberOfPlanes == 3 || NumberOfPlanes == 4
                %%
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
                        
                        if sucsess
                            status = 'SuccessIndentify';
                        else
                            obj.InfoMessage = 'ERROR while indentifing planes';
                            obj.InfoMessage = '   -cange planes by pressing the "Check planes" button';
                            status = 'ErrorIndentify';
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
                                
                                obj.InfoMessage = '   -ERROR while indentifing planes';
                                obj.InfoMessage = '      -can not indentifing planes';
                                obj.InfoMessage = '      -no channel color name were found in meta data';
                                
                                %find RGB image with the same file name and use
                                %this for plane identification
                                sucsess = obj.planeIdentifier();
                                
                                if sucsess
                                    status = 'SucsessIndentify';
                                else
                                    obj.InfoMessage = 'ERROR while indentifing planes';
                                    obj.InfoMessage = '   -cange planes by pressing the "Check planes" button';
                                    status = 'ErrorIndentify';
                                end
                                
                            end
                            
                        end %end for I:noPlanes
                        
                    end %end size Channel Name
                    
                    if foundBlue && foundRed && foundGreen
                        status = 'SucsessIndentify';
                    end
                %%    
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
                        
                        if sucsess
                            status = 'SuccessIndentify';
                        else
                            obj.InfoMessage = 'ERROR while indentifing planes';
                            obj.InfoMessage = '   -cange planes by pressing the "Check planes" button';
                            status = 'ErrorIndentify';
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
                                
                            elseif ( ~isempty(strfind(ch_wave_name{1,i},'Far Red')) || ...
                                    ~isempty(strfind(ch_wave_name{1,i},'Y5')) ) && ~foundFarRed
                                
                                obj.PicPlaneFarRed = bfGetPlane(reader,i);
                                obj.InfoMessage = ['      - plane ' num2str(i) ' identified as ' ch_wave_name{1,i}];
                                foundFarRed = 1;
                                
                            else
                                
                                obj.InfoMessage = '   -ERROR while indentifing planes';
                                obj.InfoMessage = '      -can not indentifing planes';
                                obj.InfoMessage = '      -no channel color name were found in meta data';
                                
                                %find RGB image with the same file name and use
                                %this for plane identification
                                sucsess = obj.planeIdentifier();
                                
                                if sucsess
                                    status = 'SucsessIndentify';
                                else
                                    obj.InfoMessage = 'ERROR while indentifing planes';
                                    obj.InfoMessage = '   -cange planes by pressing the "Check planes" button';
                                    status = 'ErrorIndentify';
                                end
                                
                            end
                        end %end for I:noPlanes
                    end %end size Channel Name
                    
                    if foundBlue && foundRed && foundGreen && foundFarRed
                        status = 'SucsessIndentify';
                    end
                 %%   
                end %end NumerPlanes =3 elseif = 4
                
            % Searching for brightness adjustment Pics
                obj.InfoMessage = '   - searching for brightness adjustment images';
                regexp(ch_wave_name,'A4')
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
                    obj.PicBCBlue = bfGetPlane(readertemp,1);
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
                    obj.PicBCGreen = bfGetPlane(readertemp,1);
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
                    obj.PicBCRed = bfGetPlane(readertemp,1);
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
                    obj.PicBCFarRed = bfGetPlane(readertemp,1);
                    obj.FilenameBCFarRed = FileNamePicBCFarRed(1).name;
                    obj.InfoMessage = ['      - ' FileNamePicBCFarRed(1).name ' were found'];
                else
                    obj.InfoMessage = ['      - Y5*' ext ' file were not found'];
                    obj.FilenameBCFarRed = '-';
                    obj.PicBCFarRed = [];
                end
                
                cd(currentFolder);
            
                
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
                tempR3D(:,:,2) = double(1*ones(size(tempR))).*(double(tempR)/255);
                tempR3D(:,:,3) = double(1*ones(size(tempR))).*(double(tempR)/255);
                
                tempG3D(:,:,1) = double(1*ones(size(tempG))).*(double(tempG)/255);
                tempG3D(:,:,2) = double(255*ones(size(tempG))).*(double(tempG)/255);
                tempG3D(:,:,3) = double(1*ones(size(tempG))).*(double(tempG)/255);
                
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
                tempR3D(:,:,2) = double(1*ones(size(tempR))).*(double(tempR)/255);
                tempR3D(:,:,3) = double(1*ones(size(tempR))).*(double(tempR)/255);
                
                tempG3D(:,:,1) = double(1*ones(size(tempG))).*(double(tempG)/255);
                tempG3D(:,:,2) = double(255*ones(size(tempG))).*(double(tempG)/255);
                tempG3D(:,:,3) = double(1*ones(size(tempG))).*(double(tempG)/255);
                
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
                                    r(plane,:) = [];
                                    Pic(:,:,plane) = [];
                                    obj.InfoMessage = '         - red-plane was identified';
                                else
                                    %farred plane was identified
                                    %save farred plane temporary
                                    tempFR = Pic(:,:,plane);
                                    %clear foundet plane and color in the r array
                                    r(plane,:) = [];
                                    Pic(:,:,plane) = [];
                                    r(:,color) = 0;
                                    obj.InfoMessage = '         - farred-plane was identified';
                                end
                                
                            case 2  %Green
                                %green plane was identified
                                %save green plane temporary
                                tempG = Pic(:,:,plane);
                                r(plane,:) = [];
                                r(:,color) = 0;
                                Pic(:,:,plane) = [];
                                obj.InfoMessage = '         - green-plane was identified';
                                
                            case 3  %Blue
                                %blue plane was identified
                                %save blue plane temporary
                                tempB = Pic(:,:,plane);
                                %clear foundet plane and color in the r array
                                r(plane,:) = [];
                                r(:,color) = 0;
                                Pic(:,:,plane) = [];
                                obj.InfoMessage = '         - blue-plane was identified';
                        end
                    end
                    
                    %Save identified planes in the properties
                    obj.PicPlaneGreen = tempG;
                    obj.PicPlaneBlue = tempB;
                    obj.PicPlaneRed = tempR;
                    obj.PicPlaneFarRed = tempFR;
 
                else
                    % no RGB image were found
                    success = 'false';
                    
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
                      div = double(obj.PicBCGreen)/double(max(max(obj.PicBCGreen)));
                      Mat1 = double(obj.PicPlaneGreen)./double(div);
                      obj.PicPlaneGreen_adj = uint8(Mat1);
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicBCGreen not found';
                    obj.PicPlaneGreen_adj = obj.PicPlaneGreen;
                end
                
                %brightness adjustment PicPlaneRed
                if ~isempty(obj.PicBCRed)
                    obj.InfoMessage = '      - adjust red plane';
                      div = double(obj.PicBCRed)/double(max(max(obj.PicBCRed)));
                      Mat1 = double(obj.PicPlaneRed)./double(div);
                      obj.PicPlaneRed_adj = uint8(Mat1);
                else
                    obj.InfoMessage = '      - PicBCRed not found';
                    obj.PicPlaneRed_adj = obj.PicPlaneRed;
                end
                
                %brightness adjustment PicPlaneBlue
                if ~isempty(obj.PicBCBlue)
                    obj.InfoMessage = '      - adjust blue plane';
                      div = double(obj.PicBCBlue)/double(max(max(obj.PicBCBlue)));
                      Mat1 = double(obj.PicPlaneBlue)./double(div);
                      obj.PicPlaneBlue_adj = uint8(Mat1);
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicBCBlue not found';
                    obj.PicPlaneBlue_adj = obj.PicPlaneBlue;
                end
                
                %brightness adjustment PicPlaneFarRed
                if ~isempty(obj.PicBCFarRed)
                    obj.InfoMessage = '      - adjust farred plane';
                      div = double(obj.PicBCFarRed)/double(max(max(obj.PicBCFarRed)));
                      Mat1 = double(obj.PicPlaneFarRed)./double(div);
                      obj.PicPlaneFarRed_adj = uint8(Mat1);
                else
                    %no adjustment image were found
                    obj.InfoMessage = '      - PicY4 not found';
                    obj.PicPlaneFarRed_adj = obj.PicPlaneFarRed;
                end

            end
            obj.InfoMessage = '   - brightness adjustment finished';
            
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
            
        end
        
        function calculateBackgroundIllumination(obj,plane)
            obj.controllerEditHandle.busyIndicator(1);
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
                    workbar(1/4,'determine fiber radius... ','Background Calculation'); 
                    AreaBig = Area(round(length(Area)*(2/3)):end);
                    MeanArea = mean(AreaBig);
                    obj.InfoMessage = '            - determine fiber radius';
                    %radius of mean area
                    radius = sqrt(MeanArea/pi);
                    %double radius to be sure that the structering element
                    %is bigger than the fibers
                    radius=ceil(radius)*3;
                    workbar(2/4,'calculate background profile... ','Background Calculation'); 
                    obj.InfoMessage = '            - calculate background profile';
                    background = imopen(obj.PicPlaneGreen,strel('disk',radius));
                    h = fspecial('disk', radius);
                    obj.InfoMessage = '            - smoothing background profile';
                    workbar(3/4,'smoothing background profile... ','Background Calculation'); 
                    smoothedBackground = imfilter(double(background), h, 'replicate');
                    %Normalized Background to 1
                    smoothedBackground = smoothedBackground/max(max(smoothedBackground));
                    obj.PicBCGreen = smoothedBackground;
                    obj.FilenameBCGreen = 'calculated from Green plane background';
                    workbar(4/4,'save data ','Background Calculation'); 
                    
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
                    smoothedBackground = imfilter(double(background), h, 'replicate');
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
                    smoothedBackground = imfilter(double(background), h, 'replicate');
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
                    smoothedBackground = imfilter(double(background), h, 'replicate');
                    %Normalized Background to 1
                    smoothedBackground = smoothedBackground/max(max(smoothedBackground));
                    obj.PicBCFarRed = smoothedBackground;
                    obj.FilenameBCFarRed = 'calculated from Farred plane background';
                      
                otherwise %calculate all missing images
                    disp('all missing');
                    
            end
            obj.controllerEditHandle.busyIndicator(0);
        end
        
        function imagePreBinarization(obj)
            % 
            % 
            %
            %   brightnessAdjustment(obj)
            %
            %   ARGUMENTS:
            %
            %       - Input
            %           obj:    Handle to modelEdit object
            %
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
                            obj.addToBuffer();
                            
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
                            obj.addToBuffer();
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
            obj.InfoMessage = '   - running auto setup binarization';
            
            obj.PicBW = imbinarize(obj.PicPlaneGreen_adj,'adaptive','ForegroundPolarity','bright');
            obj.PicBWisInvert = 'false';
            se = strel('disk',4);
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
            
            obj.InfoMessage = '      - run watershed transformation';
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
%             imshow(obj.PicRGBFRPlanes)
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
            
            obj.InfoMessage = '   - auto setup binarization completed';
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
            
            if PosX > size(obj.PicRGBFRPlanes,2)
                PosX = size(obj.PicRGBFRPlanes,2);
            end
            
            if PosY > size(obj.PicRGBFRPlanes,1)
                PosY = size(obj.PicRGBFRPlanes,1);
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
