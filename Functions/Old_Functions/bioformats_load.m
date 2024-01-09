function [ch_order, ch_wave_name, ch_rgb, ch_rgbname] = bioformats_load(hmf)

% load_confocal_stack - opens confocal images using BIOFORMATS toolbox
% Requirements - bfmatlab
% Reference: http://ci.openmicroscopy.org/job/BIOFORMATS-5.0-latest/javadoc/ome/xml/meta/MetadataRetrieve.html#getDatasetImageRef(int,%20int)
% TODO: Clean up code
% TODO: Review load after imstack close (figure handle must shift to
% lastest imstack opened
%
%https://uk.mathworks.com/matlabcentral/fileexchange/55546-imstack/content/imstack/private/bioformats_load.m


%% Check for proper install
if isempty(regexp(path,'bfmatlab','once'))
    beep
    display('bioformats toolbox needs to be downloaded and added to MATLAB search path')
    web('http://www.openmicroscopy.org/site/support/bio-formats5/developers/matlab-dev.html','-browser')
    return
end

%% get path
[filename, pathname] = uigetfile({'*.*;*','All files'});

if ~filename
    display('load canceled')
    return
end

%% loads a reader and creates the metadata object
fh = figure('Menubar', 'none', 'Name', ['BioFormats - ' filename]);

reader = bfGetReader(fullfile(pathname, filename));
omeMeta = reader.getMetadataStore();
setappdata(fh, 'OME', omeMeta);
% omeXML = char(omeMeta.dumpXML());

%% loads everything
% data = bfopen(fullfile(pathname, filename));

%% Generate preview
series_idx = 0;

% series info
% count = omeMeta.getImageCount;
ChannelCount = omeMeta.getChannelCount(series_idx);

numSeries = reader.getSeriesCount();
imageNames = repmat({''}, numSeries, 1);

% image dimensions
sz_cols = double(omeMeta.getPixelsSizeX(series_idx).getNumberValue); %cols
sz_rows = double(omeMeta.getPixelsSizeY(series_idx).getNumberValue); %rows

%pixel dimensions
PhysicalSizeX = double(omeMeta.getPixelsPhysicalSizeX(series_idx).value);
PhysicalSizeY = double(omeMeta.getPixelsPhysicalSizeY(series_idx).value);
PhysicalSizeZ = double(omeMeta.getPixelsPhysicalSizeZ(series_idx).value);

% bit depth
bit_depth = double(omeMeta.getPixelsSignificantBits(series_idx).getNumberValue);
bit_string = char(omeMeta.getPixelsType(series_idx));

% % make sure bit string makes sense
% bit_strings = {'uint8', 'uint16','double'};
% if ~any(strcmp(bit_strings,bit_string))
%     if bit_depth > 8
%         bit_string = 'uint16';
%     else
%         bit_string = 'uint8';
%     end
% end

% img = zeros(sz_x, sz_y, numChannels, bit_string);

[ch_order, ch_wave_name, ch_rgb, ch_rgbname] = get_channel_info(omeMeta);

% subplot dimensions
cols = ceil(sqrt(numSeries));
rows = ceil(numSeries/cols);
% max_rc = max([rows cols]);
% max_xy = max([sz_x sz_y]);
% set(fh, 'Units', 'Normalized', 'Position', [0 0 (cols / max_rc) * (sz_x/max_xy) (rows / max_rc) * (sz_y/max_xy)]);

subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.01 0.01], [0.01 0.01]);
hw = waitbar(0,'reading image stacks');
%%
for series_idx = 1:numSeries
    figure(fh);
    try
        IMG = get_stack(series_idx);
    catch
        display(sprintf('Series %d did not load',series_idx))
        continue
    end
    projection = get_projection(IMG);
    imageNames{series_idx} = char(omeMeta.getImageName(series_idx-1));
    
    subplot(rows, cols, series_idx)
    ha = imshow(projection);
    set(ha, 'ButtonDownFcn', @(varargin) axes_click_callback(series_idx,hmf));
    set(imgca, 'XLim', [0.5 size(projection, 2)+0.5], 'YLim', [0.5 size(projection, 1)+0.5])
    axis tight
    title(imageNames{series_idx});
    waitbar(series_idx / numSeries);
end
delete(hw)
clear subplot

%% subfunctions
    function axes_click_callback(series_idx, hmf)
        
        IMG = get_stack(series_idx);
        
        ud.StudyPath = pathname;
        ud.StudyDescription = imageNames{series_idx};
        ud.SeriesDescription = 'Confocal';
        ud.PixelSpacing = [PhysicalSizeX PhysicalSizeY];
        ud.PixelMax = double(max(IMG(:)));
        ud.SliceThickness = PhysicalSizeZ;
        ud.BitDepth = bit_depth;
        ud.ChannelCount = ChannelCount;
        ud.ChannelName = ch_wave_name;
        ud.ChannelRGB = ch_rgb;
        ud.ChannelRGBName = ch_rgbname;
        if ishandle(hmf)
            setappdata(hmf, 'IMGS', IMG)
            ud = init_ud(ud, hmf, size(IMG), false);
            init_im_display(ud);
        else
            hmf = imstack(IMG, ud);
        end
    end
%%
    function IMG = get_stack(series_idx)
        reader.setSeries(series_idx-1);
        %         numPlanes = omeMeta.getPlaneCount(series_idx-1);
        numPlanes = reader.getImageCount;
        IMG = zeros(sz_rows, sz_cols, ChannelCount, numPlanes/ChannelCount, bit_string);
        plane_idx = 1:ChannelCount:numPlanes;
        for np = 1:numel(plane_idx)
            for cidx = 1:ChannelCount
                IMG(:,:, cidx,np) = bfGetPlane(reader, plane_idx(np) + (ch_order(cidx)-1));
            end
        end
    end

    function projection = get_projection(IMG)
        % returns a max projection type single
        
        if ndims(IMG) < 4
            % if a grayscale image stack, return a grayscale projection
            projection = single(mat2gray(max(IMG,[], 3)));
        else
            % a color 4D stack
            sz = size(IMG);
            projection = zeros(sz(1), sz(2), 3, 'single');
            
            if ChannelCount > 3 % e.g. for confetti mice with multiple labels and thus multiple image channels
                % requires ch_color because grayscale stacks (channels)
                % will have to be combined for each projection channel
                
                % example red channel
                
                % red_idx = find(ch_colors(:,1)); % find all channels that should be included in the red channel
                % red = mat2gray(max(squeeze((sum(single(IMG(:,:,red_idx,:)),3))),[],3));
                
                % For Each channel in the RGB projection image, sum the
                % selected channels in IMG, then squeeze, then get max
                % pixel across slices, then mat2gray, then add to the
                % projection channel
                for proj_ch_i=1:3
                    projection(:,:,proj_ch_i) = mat2gray(max(squeeze(max(single(IMG(:,:,ch_rgb(:,proj_ch_i)>0,:)),[],3)),[],3));
                end
                
            else % only the standard three or less labels
                
                for ch=1:ChannelCount
                    projection(:,:,ch) = single(mat2gray(max(squeeze( IMG(:,:,ch,:) ), [], 3)));
                end
            end
        end
    end
end

function [ch_order, ch_wave_name, ch_rgb, ch_rgbname] = get_channel_info(omeMeta)
% Check for color info in the following order
% * emission wavelength
% * emission filter
% * excitation wavelength
% * excitation filter

% returns:
% ch_order - the order to rearrange the image stack so that
% the image taken with longest wavelenth is in channel 1 and the shortest wavelength
% is in channel numChannels
% ch_wave_name - any name assigned to filter during image capture
% ch_rgb - an RGB triplet value for the set color of the
% channel
% ch_colorname - interpreted channel color name for the RGB
% triplet value

% NOTE ch_wave_name, ch_rgb, and ch_colorname are sorted by ch_order. ch_order is
% not sorted. This means that ch_order only refers to the image stack on
% file. ch_wave_name and ch_color are in the order that the channels in
% IMG WILL BE sorted into

series_idx = 0;
ChannelCount = omeMeta.getChannelCount(series_idx);

ch_rgb_defaults = uint8([255 0 0; 0 255 0; 0 0 255; 0 255 255; 255 0 255; 255 255 0]); % r g b c m y
%         ch_rgb = zeros(ChannelCount,3,'uint8');
ch_order = 1:ChannelCount;
ch_rgb = ch_rgb_defaults(1:ChannelCount, :);

EmissionWavelength = zeros(1,ChannelCount);
ExcitationWavelength = zeros(1,ChannelCount);
ch_wave_name = {''};
for cidx = 1:ChannelCount
    EmissionWavelength(cidx) = str2double(char(omeMeta.getChannelEmissionWavelength(0,cidx-1)));
    ExcitationWavelength(cidx) = str2double(char(omeMeta.getChannelExcitationWavelength(0,cidx-1)));
    ch_wave_name{cidx} = char(omeMeta.getChannelName(0,cidx-1));
    
    if ~isempty(omeMeta.getChannelColor(0,cidx-1))
        ch_rgb(cidx,1) = getRed(omeMeta.getChannelColor(0,cidx-1));
        ch_rgb(cidx,2) = getGreen(omeMeta.getChannelColor(0,cidx-1));
        ch_rgb(cidx,3) = getBlue(omeMeta.getChannelColor(0,cidx-1));
    end
end

%         if ~any(isnan(EmissionWavelength))
%             [~,ch_order] = sort(EmissionWavelength,'descend');
%             ch_order = EmissionWavelength
%         elseif ~any(isnan(ExcitationWavelength))
%             [~,ch_order] = sort(ExcitationWavelength,'descend');
%         end

[ch_rgbname,ch_order] = get_ch_rgbname(ch_rgb);
ch_wave_name = ch_wave_name(ch_order);
ch_rgb = ch_rgb(ch_order,:);
end

function [ch_rgbname,ch_order] = get_ch_rgbname(ch_rgb)
color_names = {'red','green','blue','magenta','cyan','yellow'};

% map RGB values to color names
mapTriplet = containers.Map({'255,0,0', '0,255,0','0,0,255','255,0,255','0,255,255','255,255,0'},...
    color_names);

% properly formats ch_rgb for interpretation
ch_rgb = cellstr(num2str(ch_rgb)); % convert to cell array
ch_rgb = regexprep(ch_rgb, '^\s+',''); % remove leading spaces
ch_rgb = regexprep(ch_rgb, '\s+',','); % replace remaining spaces with commas

% create cell array of channel color names
ch_rgbname = repmat({''},numel(ch_rgb),1);
for n = 1:numel(ch_rgb)
    ch_rgbname{n} = mapTriplet(ch_rgb{n});
end

%% generate channel order
[Lia, Locb] = ismember(color_names,ch_rgbname);
ch_order = Locb(Lia);
ch_rgbname = ch_rgbname(ch_order);

end