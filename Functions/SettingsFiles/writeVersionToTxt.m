function writeVersionToTxt(versionString)
inputFilePath = 'LATEST.txt';
outputFilePath = 'LATEST.txt';

% Open a text file for writing
fid = fopen(inputFilePath, 'r');

% Check if the file was opened successfully
if fid == -1
    error('ERROR writeVersionToTxt(): Could not open the file for writing.');
else
   
    
% New string to replace the first line
newFirstLine = versionString;

% Read the entire content of the file
fileContent = fread(fid, '*char')';  % Read entire content as a string
fclose(fid);

% Split the content into lines
lines = strsplit(fileContent, '\n', 'CollapseDelimiters', false);

% Replace the first line
lines{1} = newFirstLine;

% Join the lines back into a single string
modifiedContent = strjoin(lines, '\n');

% Write the modified content back to the file
fid = fopen(outputFilePath, 'w');
fprintf(fid, '%s', modifiedContent);
fclose(fid);
    
end

end