function setDefaultSettingsValue(settingsString,value)

currentFile = mfilename( 'fullpath' );
[pathstr,~,~] = fileparts( currentFile );
addpath( pathstr );

data=load(fullfile( pathstr, 'AppSettings.mat' ));
stringCellArray = cellfun(@(x) isnumeric(x) || islogical(x), data.Settings);
data.Settings(stringCellArray) = cellfun(@num2str, data.Settings(stringCellArray), 'UniformOutput', false);
%Check if setting exist
idx=find(contains(data.Settings,settingsString));
disp([settingsString '  - ' value])
if(isempty(idx))
    %Add Setting and value to list if not exist
    data.Settings{end+1,1} =  settingsString;
    data.Settings{end,3} =  value;
else
    data.Settings{idx,3} =  value;
end

%Save to File
savePath = fullfile( pathstr, 'AppSettings.mat' );
Settings = data.Settings;
save( savePath ,'Settings');
end