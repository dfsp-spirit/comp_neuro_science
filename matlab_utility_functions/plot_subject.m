function fig_handle = plot_subject(subject_id, subjects_dir, measure, surf)
%% Display the data on a surface. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.


plot_title = sprintf('Measure %s for subject %s', measure, subject_id);


subject_surf_dir = fullfile(subjects_dir, subject_id, 'surf');

lh_display_surf_file = fullfile(subject_surf_dir, strcat('lh.', surf));
rh_display_surf_file = fullfile(subject_surf_dir, strcat('rh.', surf));

display_surface = SurfStatReadSurf ( {lh_display_surf_file, rh_display_surf_file} );

measure_data = read_subject_data(subject_id, subjects_dir, measure, surf);

figure;
SurfStatView(measure_data, display_surface, plot_title);
fig_handle = gcf;

end
