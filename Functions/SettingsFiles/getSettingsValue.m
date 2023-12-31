function value = getSettingsValue(searchString)
currentFile = mfilename( 'fullpath' );

[pathstr,~,~] = fileparts( currentFile );

if(~contains(matlabpath, pathstr))
    addpath( pathstr );
end

data=load(fullfile( pathstr, 'AppSettings.mat' ));

idx=find(contains(data.Settings,searchString));

if(~isempty(idx))
    value = data.Settings{idx,2};
else
    value = [];
end
end