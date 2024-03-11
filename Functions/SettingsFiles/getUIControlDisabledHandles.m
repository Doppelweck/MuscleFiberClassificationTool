function controlHandles = getUIControlDisabledHandles(fig)
    % Get all properties of the object
    props = properties(fig);

    % Initialize an empty array to store disabled UI handles
    controlHandles = [];

    % Iterate through each property
    for i = 1:numel(props)
        % Check if the property is a UI handle
        if ishandle(fig.(props{i}))
            % Check if the 'Enable' property is set to 'off'
            if isprop(fig.(props{i}), 'Enable') && strcmpi(fig.(props{i}).Enable, 'off')
                % Add the handle to the list of disabled handles
                controlHandles = [controlHandles; fig.(props{i})];
            end
        end
    end
end