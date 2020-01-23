function measure_data = read_subject_data(subject_id, subjects_dir, measure, surf, hemi)
%% Read subject morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
%% Assumes that the morphometry data files are in curv format (like lh.area).
% hemi: must be 'lh', 'rh', or 'both'
% surf: should be 'white'
% USAGE Example: 
% lh_thickness =  read_subject_data('bert',
% '/Applications/freesurfer/subjects', 'thickness', 'white', 'lh');


subject_surf_dir = fullfile(char(subjects_dir), char(subject_id), 'surf');
surf_fn_part = filename_part_for_surface(surf);

lh_data_filename = sprintf('lh.%s%s', measure, surf_fn_part);
rh_data_filename = sprintf('rh.%s%s', measure, surf_fn_part);

lh_data_file = fullfile(char(subject_surf_dir), char(lh_data_filename));
rh_data_file = fullfile(char(subject_surf_dir), char(rh_data_filename));

measure_data = 0;

if ~(strcmp(hemi, 'lh') || strcmp(hemi, 'both') || strcmp(hemi, 'rh'))
    error("Invaild hemi, must be one of 'lh', 'rh' or 'both'")
end

if strcmp(hemi, 'lh') || strcmp(hemi, 'both')
    if exist(lh_data_file, 'file') ~= 2
        error("The lh data file '%s' does not exist. Check the path.\n", lh_data_file);
    else
        measure_data_lh = read_curv(lh_data_file);
        if strcmp(hemi, 'lh')
            measure_data = measure_data_lh;
        end
    end
end

if strcmp(hemi, 'rh') || strcmp(hemi, 'both')
    if exist(rh_data_file, 'file') ~= 2
        error("The rh data file '%s' does not exist. Check the path.\n", rh_data_file);
    else
        measure_data_rh = read_curv(rh_data_file);
        if strcmp(hemi, 'rh')
            measure_data = measure_data_rh;
        end
    end
end

if strcmp(hemi, 'both')
    measure_data = vertcat(measure_data_lh, measure_data_rh)';
end

end
