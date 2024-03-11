function value = getDefaultSettingsValue(searchString)
currentFile = mfilename( 'fullpath' );

[pathstr,~,~] = fileparts( currentFile );

if(~contains(matlabpath, pathstr))
    addpath( pathstr );
end

data=load(fullfile( pathstr, 'AppSettings.mat' ));
stringCellArray = cellfun(@(x) isnumeric(x) || islogical(x), data.Settings);
data.Settings(stringCellArray) = cellfun(@num2str, data.Settings(stringCellArray), 'UniformOutput', false);

idx=find(contains(data.Settings,searchString));

if(~isempty(idx))
    value = data.Settings{idx,3};
else
    value = [];
end
end