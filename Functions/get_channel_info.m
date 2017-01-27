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
%
%https://uk.mathworks.com/matlabcentral/fileexchange/55546-imstack/content/imstack/private/bioformats_load.m

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