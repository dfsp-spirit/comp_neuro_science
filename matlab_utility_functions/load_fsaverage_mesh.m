function fsaverage_mesh = load_fsaverage_mesh(subjects_dir, display_surf)

average_subject = 'fsaverage';
avg_subject_surf_dir = fullfile(subjects_dir, average_subject, 'surf');

lh_display_surf_file = fullfile(avg_subject_surf_dir, strcat('lh.', display_surf));
rh_display_surf_file = fullfile(avg_subject_surf_dir, strcat('rh.', display_surf));

if exist(lh_display_surf_file, 'file') ~= 2
    fprintf("ERROR: fsaverage lh surf file '%s' does not exist. Check the path.\n", lh_display_surf_file);
end
if exist(rh_display_surf_file, 'file') ~= 2
    fprintf("ERROR: fsaverage rh surf file '%s' does not exist. Check the path.\n", rh_display_surf_file);
end

fsaverage_mesh = SurfStatReadSurf ( {lh_display_surf_file, rh_display_surf_file} );

end
