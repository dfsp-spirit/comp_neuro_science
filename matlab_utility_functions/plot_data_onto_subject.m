function fig_handle = plot_data_onto_subject(subject_id, subjects_dir, data_lh, data_rh, colmap, surf)
%% Display the data on a surface. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.


%plot_title = sprintf("Subject '%s'", subject_id);
plot_title = '';
color_bar_title = "Cohen's d";

subject_surf_dir = fullfile(char(subjects_dir), char(subject_id), 'surf');
lh_display_surf_file = fullfile(char(subject_surf_dir), char(strcat('lh.', surf)));
rh_display_surf_file = fullfile(char(subject_surf_dir), char(strcat('rh.', surf)));
if exist(lh_display_surf_file, 'file') ~= 2
    error("lh surf file '%s' does not exist. Check the path.\n", lh_display_surf_file);
end
if exist(rh_display_surf_file, 'file') ~= 2
    error("rh surf file '%s' does not exist. Check the path.\n", rh_display_surf_file);
end

if isempty(data_rh)
    display_surface = SurfStatReadSurf ( {lh_display_surf_file} );
elseif isempty(data_lh)
    display_surface = SurfStatReadSurf ( {rh_display_surf_file} );
else
    display_surface = SurfStatReadSurf ( {lh_display_surf_file, rh_display_surf_file} );
end

data = vertcat(data_lh, data_rh);

fig_handle = figure;

%colormap(colmap);

%SurfStatColormap(colmap);

[ ~, hcb ] = SurfStatView(data, display_surface, plot_title);
colormap(colmap);

colorTitleHandle = get(hcb,'Title');
set(colorTitleHandle ,'String', color_bar_title);


end
