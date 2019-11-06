function fig_handle = plot_subject(subject_id, subjects_dir, measure, surf)
%% Display the data on a surface. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.


plot_title = sprintf('Measure %s for subject %s', measure, subject_id);


subject_surf_dir = fullfile(subjects_dir, subject_id, 'surf');

lh_display_surf_file = fullfile(subject_surf_dir, strcat('lh.', surf));
rh_display_surf_file = fullfile(subject_surf_dir, strcat('rh.', surf));
if exist(lh_display_surf_file, 'file') ~= 2
    fprintf("ERROR: lh surf file '%s' does not exist. Check the path.\n", lh_display_surf_file);
end
if exist(rh_display_surf_file, 'file') ~= 2
    fprintf("ERROR: rh surf file '%s' does not exist. Check the path.\n", rh_display_surf_file);
end

display_surface = SurfStatReadSurf ( {lh_display_surf_file, rh_display_surf_file} );

hemi = 'both';
measure_data = read_subject_data(subject_id, subjects_dir, measure, surf, hemi);

figure;
SurfStatView(measure_data, display_surface, plot_title);
fig_handle = gcf;

end
