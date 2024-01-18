function [newVersionAvailable, checkSuccessfull, newVersion] = checkAppForNewVersion(versionString)

    temp_newVersionAvailable = false;
    temp_checkSuccessfull = false;
    temp_newVersion = '';
    
    fileContent = '';

    try
        githubUrl = 'https://raw.githubusercontent.com/Doppelweck/MuscleFiberClassificationTool/master/LATEST.txt';
        fileContent = webread(githubUrl);
        temp_checkSuccessfull = true;
    catch
        temp_checkSuccessfull = false;
    end
    
    if(temp_checkSuccessfull)
        % Define a regular expression pattern
        pattern = '(\d+(\.\d+)*)';

        % Use regular expression to find a match
        matchfileContent = regexp(fileContent, pattern, 'match', 'once');
        if ~isempty(matchfileContent)
          gitMasterVersion = str2double(strsplit(['.' matchfileContent], '.'));
        end
        matchversionString = regexp(versionString, pattern, 'match', 'once');
        if ~isempty(matchversionString)
            appVersion = str2double(strsplit(['.' matchversionString], '.'));
        end
        
        % Ensure both version arrays have the same length
        gitMasterVersion(1) = [];
        appVersion(1) = [];
        maxLength = max(length(gitMasterVersion), length(appVersion));
        gitMasterVersion(end+1:maxLength) = 0;
        appVersion(end+1:maxLength) = 0;
        
        
        for i = 1:min(length(gitMasterVersion), length(appVersion))
            if gitMasterVersion(i) > appVersion(i)
                temp_newVersionAvailable = true;
                temp_newVersion = matchfileContent;
                break;  % Exit the loop
            end
        end

        % Compare version numbers
        if all(gitMasterVersion > appVersion)
            disp('The extracted version is greater than or equal to the reference version.');
        else
            disp('The extracted version is less than the reference version.');
        end
    end
    
    
    %RETURN
    newVersionAvailable = temp_newVersionAvailable;
    checkSuccessfull = temp_checkSuccessfull;
    newVersion = temp_newVersion;
end