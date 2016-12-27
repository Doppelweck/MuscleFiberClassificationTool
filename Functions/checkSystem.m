function sucsess = checkSystem()
%CHECKSYSTEM Check whether the correct MatLab version as well as all
%necessary toolboxes are installed. Returns false if a condition is not
%met, otherwise true.
%Necessary toolboxes and condition are:
%   - GUI Layout Toolbox Version 2.3
%   - Image Processing Toolbox
%   - Matlab Version 8.4 (2014b) or higher
%
%   Inputs:     none
%
%   Output:     - sucsess (boolean)
%                   Returns false if a condition is not
%                   met, otherwise true.
MLversion = getversion();
ToolBoxes = ver;

for i=1:1:size(ToolBoxes,2)
    ToolBoxCell{i,1} = ToolBoxes(i).Name;
    ToolBoxCell{i,2} = ToolBoxes(i).Version;
end

[rowIPTB colIPTB] = find(strcmp(ToolBoxCell,'Image Processing Toolbox'));
[rowGLTB colGLTB] = find(strcmp(ToolBoxCell,'GUI Layout Toolbox'));

if length(rowGLTB) > 1
    rowGLTB = rowGLTB(1);
end

if MLversion < 8.4
    % This application is for MATLAB release R2014b (8.4) onwards.
    errordlg('This applictaion requires MATLAB release R2014b onwards')
    sucsess = false;
    
elseif isempty(rowIPTB) || isempty(rowIPTB)
    % Check if 'Image Processing Toolbox' is installed
    errordlg('This applictaion requires the "Image Processing Toolbox"')
    sucsess = false;
    
elseif isempty(rowGLTB) || isempty(colGLTB)
    % Check if 'GUI Layout Toolbox Version' is installed
    errordlg('This applictaion requires the "GUI Layout Toolbox Version 2.3"')
    sucsess = false;
    
else
    % Check Versions of toolboxes
    temp = false;
    for i=1:1:length(rowGLTB)
        % Check all installed versions of GUI Layout Toolbox
        if str2double(ToolBoxCell{rowGLTB(i),2}) == 2.3
            temp = true;
        end
    end
    % Check Versions of toolboxes
    if temp
        sucsess = true;
    else
        sucsess = true;
    end
    
end

