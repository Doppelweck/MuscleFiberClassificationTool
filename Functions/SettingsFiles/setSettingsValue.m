function setSettingsValue(settingsString,value)

currentFile = mfilename( 'fullpath' );
[pathstr,~,~] = fileparts( currentFile );
addpath( fullfile( pathstr, 'AppSettings.mat' ) );

data=load([pathstr '\AppSettings.mat']);

%Check if setting exist
idx=find(contains(data.AppSettings,settingsString));

if(~isempty(idx))
    %Add Setting and value to list
    data.AppSettings{end+1,1} =  settingsString;
    data.AppSettings{end,2} =  value;
end

%Save to File
savePath = [pathstr '\AppSettings.mat'];
Settings = data.Settings;
save( savePath ,'Settings');
end