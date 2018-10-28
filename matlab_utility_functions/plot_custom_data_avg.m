function fig_handle = plot_custom_data_avg(subjects_dir, custom_data, display_surf, plot_title)
%% Display the data on a surface. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
%% Assums the data has been mapped to fsaverage and displays on its surfaces.

average_subject = 'fsaverage';
avg_subject_surf_dir = fullfile(subjects_dir, average_subject, 'surf');

lh_display_surf_file = fullfile(avg_subject_surf_dir, strcat('lh.', display_surf));
rh_display_surf_file = fullfile(avg_subject_surf_dir, strcat('rh.', display_surf));

if exist(lh_display_surf_file, 'file') ~= 2
    fprintf("ERROR: lh surf file '%s' does not exist. Check the path.\n", lh_display_surf_file);
end
if exist(rh_display_surf_file, 'file') ~= 2
    fprintf("ERROR: rh surf file '%s' does not exist. Check the path.\n", rh_display_surf_file);
end

display_surface = SurfStatReadSurf ( {lh_display_surf_file, rh_display_surf_file} );

figure;
SurfStatView(custom_data, display_surface, plot_title);
fig_handle = gcf;

end
