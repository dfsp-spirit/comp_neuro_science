function measure_data = read_subject_data(subject_id, subjects_dir, measure, surf)
%% Read subject morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
%% Assumes that the morphometry data files are in curv format (like lh.area).



subject_surf_dir = fullfile(char(subjects_dir), char(subject_id), 'surf');
surf_fn_part = filename_part_for_surface(surf);

lh_data_filename = sprintf('lh.%s%s', measure, surf_fn_part);
rh_data_filename = sprintf('rh.%s%s', measure, surf_fn_part);

lh_data_file = fullfile(char(subject_surf_dir), char(lh_data_filename));
rh_data_file = fullfile(char(subject_surf_dir), char(rh_data_filename));

if exist(lh_data_file, 'file') ~= 2
    fprintf("ERROR: lh data file '%s' does not exist. Check the path.\n", lh_data_file);
end

if exist(rh_data_file, 'file') ~= 2
    fprintf("ERROR: rh data file '%s' does not exist. Check the path.\n", rh_data_file);
end


measure_data_lh = read_curv(lh_data_file);
measure_data_rh = read_curv(rh_data_file);

measure_data = vertcat(measure_data_lh, measure_data_rh)';

end
