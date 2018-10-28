function res_struct = read_demographics_file(demographics_file, scan_string, variable_names)
fprintf("Reading demographics data from file %s ...\n", demographics_file);
fh_demographics = fopen(demographics_file);

format_entries = split(scan_string, " ");
if length(format_entries) ~= length(variable_names)
    fprintf("ERROR: Found %d format entries in scan_string and %d variable names. Lengths must be equal!", length(format_entries), length(variable_names));
end

C = textscan(fh_demographics, scan_string);

res_struct = struct();

for var_idx = 1:length(variable_names)
    var_name = variable_names(var_idx);
    var_data = C{var_idx};
    res_struct.(var_name) = var_data;
end
fclose(fh_demographics);

end
