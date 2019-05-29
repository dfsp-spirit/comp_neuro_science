function fig_handle = plot_data_onto_subject(subject_id, subjects_dir, data_lh, data_rh, colmap, surf)
%% Display the data on a surface. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.


%plot_title = sprintf("Subject '%s'", subject_id);
plot_title = '';

subject_surf_dir = fullfile(subjects_dir, subject_id, 'surf');
lh_display_surf_file = fullfile(subject_surf_dir, strcat('lh.', surf));
rh_display_surf_file = fullfile(subject_surf_dir, strcat('rh.', surf));
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

measure_data = vertcat(data_lh, data_rh);

fig_handle = figure;


SurfStatView(measure_data, display_surface, plot_title);
SurfStatColormap(colmap);

% Hack: delete the misplaced color bar (SurfStat bug)
% a=get(gcf,'Children');
% for i=1:length(a)
%     tag=get(a(i),'Tag');
%     if strcmp(tag,'Colorbar')
%         title=get(get(a(i),'Title'),'String');
%         delete(a(i));
%     end
% end

%fig_handle = gcf;

end