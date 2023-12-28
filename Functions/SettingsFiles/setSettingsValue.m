function setSettingsValue(settingsString,value)

currentFile = mfilename( 'fullpath' );
[pathstr,~,~] = fileparts( currentFile );
addpath( pathstr );

data=load(fullfile( pathstr, 'AppSettings.mat' ));

%Check if setting exist
idx=find(contains(data.Settings,settingsString));

if(isempty(idx))
    %Add Setting and value to list if not exist
    data.Settings{end+1,1} =  settingsString;
    data.Settings{end,2} =  value;
else
    data.Settings{idx,2} =  value;
end

%Save to File
savePath = fullfile( pathstr, 'AppSettings.mat' );
Settings = data.Settings;
save( savePath ,'Settings');
end