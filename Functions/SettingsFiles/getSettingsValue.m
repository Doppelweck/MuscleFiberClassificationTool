function value = getSettingsValue(searchString)

data=load('AppSettings.mat');

idx=find(contains(data.AppSettings,searchString));
value = data.AppSettings{idx,2};
end