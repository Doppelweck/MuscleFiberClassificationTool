function writeVersionToTxt(versionString)

% Open a text file for writing
fileID = fopen('LATEST.txt', 'w');

% Check if the file was opened successfully
if fileID == -1
    error('Could not open the file for writing.');
end

% Write the text to the file
fprintf(fileID, '%s\n', versionString);

% Close the file
fclose(fileID);

end