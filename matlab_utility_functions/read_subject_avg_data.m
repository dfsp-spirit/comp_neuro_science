function measure_data = read_subject_avg_data(subject_id, subjects_dir, measure, surf, fwhm)
%% Read subject morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
%% Assumes that the morphometry data files are in mgh format and have been mapped to fsaverage (like lh.area.fwhm10.fsaverage.mgh).

average_subject = 'fsaverage';
subject_surf_dir = fullfile(subjects_dir, subject_id, 'surf');
surf_fn_part = filename_part_for_surface(surf);

lh_data_filename = sprintf('lh.%s%s.fwhm%s.%s.mgh', measure, surf_fn_part, fwhm, average_subject);
rh_data_filename = sprintf('rh.%s%s.fwhm%s.%s.mgh', measure, surf_fn_part, fwhm, average_subject);

lh_data_file = fullfile(subject_surf_dir, lh_data_filename);
rh_data_file = fullfile(subject_surf_dir, rh_data_filename);

measure_data_lh = SurfStatReadData(lh_data_file);
measure_data_rh = SurfStatReadData(rh_data_file);

measure_data = horzcat(measure_data_lh, measure_data_rh)';

end
