function measure_data = read_subject_data(subject_id, subjects_dir, measure, surf)
%% Read subject morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.

subject_surf_dir = fullfile(subjects_dir, subject_id, 'surf');
surf_fn_part = filename_part_for_surface(surf);

lh_data_filename = sprintf('lh.%s%s', measure, surf_fn_part);
rh_data_filename = sprintf('rh.%s%s', measure, surf_fn_part);

lh_data_file = fullfile(subject_surf_dir, lh_data_filename);
rh_data_file = fullfile(subject_surf_dir, rh_data_filename);



measure_data_lh = dd(lh_data_file);
measure_data_rh = SurfStatReadData(rh_data_file);
                        
measure_data = horzcat(measure_data_lh, measure_data_rh)';

end