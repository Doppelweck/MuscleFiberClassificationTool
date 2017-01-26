function [ch_rgbname,ch_order] = get_ch_rgbname(ch_rgb)
%
%https://uk.mathworks.com/matlabcentral/fileexchange/55546-imstack/content/imstack/private/bioformats_load.m

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