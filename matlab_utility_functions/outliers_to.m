function data_mod = outliers_to(data, target_value)
% Detect outliers in data and set their value to target_value.
% Ceveats: This implementation is not optimized yet and quite slow.

data_mod = data;

[~, num_columns] = size(data);
for vert_idx = 1:num_columns
    vertex_data = data(vert_idx);
    
    if isstring(target_value)
        if strcmp(target_value, "mean")
            data_mod(isoutlier(data_mod) == 1) = mean(vertex_data);
        elseif strcmp(target_value, "median")
            target_value = median(vertex_data);
            data_mod(isoutlier(data_mod) == 1) = median(vertex_data);
        else
            fprintf("ERROR: Invalid target_value: '%s'.\n", target_value);
            return;
        end
    else
        data_mod(isoutlier(data_mod) == 1) = target_value;
    end
    
end


