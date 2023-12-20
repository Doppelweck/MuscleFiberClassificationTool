function value = setSettingsValue(searchString)
data = load('AppSettings.mat');

idx=find(contains(data.AppSettings,searchString));
save('SettingsFiles/AppSettings.mat');
end