function [newVersionAvailable, checkSuccessfull] = checkAppForNewVersion()

    temp_newVersionAvailable = false;
    temp_checkSuccessfull = false;
    
    fileContent = '';

    try
        githubUrl = 'https://raw.githubusercontent.com/Doppelweck/MuscleFiberClassificationTool/master/LATEST.txt';
        fileContent = webread(githubUrl);
        temp_checkSuccessfull = true;
    catch
        temp_checkSuccessfull = false;
    end
    
    
    %RETURN
    newVersionAvailable = temp_newVersionAvailable;
    checkSuccessfull = temp_checkSuccessfull;
end