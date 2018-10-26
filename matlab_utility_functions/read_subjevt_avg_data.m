function measure_data = read_subject_data_avg(subject_id, subjects_dir, measure, surf, fwhm)
%% Read subject morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
%% Assumes that the morphometry data files are in curv format (like lh.area).

subject_surf_dir = fullfile(subjects_dir, subject_id, 'surf');
surf_fn_part = filename_part_for_surface(surf);

lh_data_filename = sprintf('lh.%s%s', measure, surf_fn_part);
rh_data_filename = sprintf('rh.%s%s', measure, surf_fn_part);

lh_data_file = fullfile(subject_surf_dir, lh_data_filename);
rh_data_file = fullfile(subject_surf_dir, rh_data_filename);



measure_data_lh = read_curv(lh_data_file);
measure_data_rh = read_curv(rh_data_file);

measure_data = vertcat(measure_data_lh, measure_data_rh)';

end
