classdef Brainload
    % BRAINLOAD Load FreeSurfer brain morphometry data.
    % A high-level interface and wrapper around SurfStat.
    %
    properties
        subjects_dir
    end

    properties (Constant)
        vertices_per_fsaverage_hemisphere = 163842;
        vertices_per_fsaverage_brain = vertices_per_fsaverage_hemisphere * 2;
    end

    methods(Static)
        function res = filename_part_for_surface(surf)
            % Determines the string that represents a surface in FreeSurfer curv output
            % files. The white surface is the default and not mentioned at all. For all
            % other surfaces, the output files are marked with '.<surface>' in the file name.
            if strcmp(surf, 'white')
                res = '';
            else
                res = sprintf('.%s', surf);
            end
        end

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

        function medial_mask = load_medial_mask(medial_mask_file)
            % Loads a medial mask, i.e., a mask to zero out the vertices along the medial wall of a brain surface.
            % The mask is a logical 1D array, and each value (1 or 0) indicates whether the respective vertex is part of the medial wall or not.
            % Obviously, the mask has to fit your subject, but the function is commonly used to load the mask for the FreeSurfer 'fsaverage' subject.
            % The medial wall is masked out because it by definition NOT part of the cortex.
            % The mask is expected to be in a matlab file (file extension '.mat'), stored in a struct named 'mask' that has 'lh' and 'rh' keys.
            % To visualize the mask, try the following:
            %     subjects_dir = fullfile('path', 'to', 'freesurfer', 'subjects');  % a dir that contains 'fsaverage'.
            %     medial_mask = load_medial_mask('medial_mask_fsaverage.mat');
            %     fd = plot_custom_data_avg(subjects_dir, double(medial_mask), 'white', 'mask');

            if exist(medial_mask_file, 'file') ~= 2
                fprintf("ERROR: load_medial_mask: Medial mask file '%s' does not exist. Check the path.\n", medial_mask_file);
            end

            mask_file_contents = load(medial_mask_file); % Will introduce the new variable 'mask' into the namespace.
            mask = mask_file_contents;
            medial_mask = [mask.lh mask.rh];
            medial_mask = logical(medial_mask);

        end

        function group_data = load_group_data_cell(subjects_list, subjects_dir, measure, surf, fwhm)
            % Read group morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
            % Assumes that the morphometry data files are in mgh format and have been mapped to fsaverage (like lh.area.fwhm10.fsaverage.mgh).
            % Data is returned in a cell array with two cells. The first contains the subject ids as string, the second contains
            %  an array with the morphometry data for the respective subject.

            num_subjects = length(subjects_list);
            C = cell(2, num_subjects);
            group_data = C;

            for subject_idx = 1:num_subjects
                subject_id = char(subjects_list(subject_idx));
                subject_data = read_subject_avg_data(subject_id, subjects_dir, measure, surf, fwhm);
                group_data{1, subject_idx} = subject_id;
                group_data{2, subject_idx} = subject_data;
            end

        end

        function group_data = load_group_data(subjects_list, subjects_dir, measure, surf, fwhm)
            % Read group morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
            % Assumes that the morphometry data files are in mgh format and have been mapped to fsaverage (like lh.area.fwhm10.fsaverage.mgh).
            % Data is returned in a matrix containing the data of each subject on one row. The order of the input subjects_list is preserved in the returned group_data.

            %% Constants
            NUM_VERTS_PER_HEMI = 163842;       % for fsaverage
            NUM_VERTS_PER_BRAIN = NUM_VERTS_PER_HEMI * 2;

            num_subjects = length(subjects_list);
            group_data = zeros(num_subjects, NUM_VERTS_PER_BRAIN);

            for subject_idx = 1:num_subjects
                subject_id = char(subjects_list(subject_idx));
                subject_data = read_subject_avg_data(subject_id, subjects_dir, measure, surf, fwhm)';
                group_data(subject_idx, :) = subject_data;
            end

        end

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

        function fig_handle = plot_subject_avg(subject_id, subjects_dir, measure, surf, fwhm, display_surf)
            %% Display the data on a surface. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
            %% Assums the data has been mapped to fsaverage and displays on its surfaces.

            average_subject = 'fsaverage';
            plot_title = sprintf('Measure %s for subject %s, mapped to %s.', measure, subject_id, average_subject);

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

            measure_data = read_subject_avg_data(subject_id, subjects_dir, measure, surf, fwhm);

            figure;
            SurfStatView(measure_data, display_surface, plot_title);
            fig_handle = gcf;

        end

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

            measure_data = read_subject_data(subject_id, subjects_dir, measure, surf);

            figure;
            SurfStatView(measure_data, display_surface, plot_title);
            fig_handle = gcf;

        end

        function res_struct = read_demographics_file(demographics_file, scan_string, variable_names)
            % Example usage:
            %  demographics = read_demographics_file(demographics_file, '%s %s %f %f %f %f %f %f %s', ["subjects", "group", "age", "iq", "bd1", "bd2", "bd3", "bd4", "site"]);
            %  subjects = demographics.subjects;

            fprintf("Reading demographics data from file %s ...\n", demographics_file);
            fh_demographics = fopen(demographics_file);

            format_entries = split(scan_string, " ");
            if length(format_entries) ~= length(variable_names)
                fprintf("ERROR: Found %d format entries in scan_string and %d variable names. Lengths must be equal!\n", length(format_entries), length(variable_names));
                return;
            end

            C = textscan(fh_demographics, scan_string);

            res_struct = struct();

            for var_idx = 1:length(variable_names)
                var_name = variable_names(var_idx);
                var_data = C{var_idx};
                res_struct.(var_name) = var_data;
            end
            fclose(fh_demographics);

        end

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

            if exist(lh_data_file, 'file') ~= 2
                fprintf("ERROR: lh data file '%s' does not exist. Check the path.\n", lh_data_file);
            end

            if exist(rh_data_file, 'file') ~= 2
                fprintf("ERROR: rh data file '%s' does not exist. Check the path.\n", rh_data_file);
            end


            measure_data_lh = SurfStatReadData(lh_data_file);
            measure_data_rh = SurfStatReadData(rh_data_file);

            measure_data = horzcat(measure_data_lh, measure_data_rh)';

        end

        function measure_data = read_subject_data(subject_id, subjects_dir, measure, surf)
            %% Read subject morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
            %% Assumes that the morphometry data files are in curv format (like lh.area).

            subject_surf_dir = fullfile(subjects_dir, subject_id, 'surf');
            surf_fn_part = filename_part_for_surface(surf);

            lh_data_filename = sprintf('lh.%s%s', measure, surf_fn_part);
            rh_data_filename = sprintf('rh.%s%s', measure, surf_fn_part);

            lh_data_file = fullfile(subject_surf_dir, lh_data_filename);
            rh_data_file = fullfile(subject_surf_dir, rh_data_filename);

            if exist(lh_data_file, 'file') ~= 2
                fprintf("ERROR: lh data file '%s' does not exist. Check the path.\n", lh_data_file);
            end

            if exist(rh_data_file, 'file') ~= 2
                fprintf("ERROR: rh data file '%s' does not exist. Check the path.\n", rh_data_file);
            end


            measure_data_lh = read_curv(lh_data_file);
            measure_data_rh = read_curv(rh_data_file);

            measure_data = vertcat(measure_data_lh, measure_data_rh)';

        end


        function subject_ids = read_subjects_file(subjects_file_name, subjects_dir)
            % Read the contents of a subjects file, i.e., a txt or csv file with n columns (where n >= 1).
            % The first column in each row is assumed to contain the subject id, and all other data which may follow is ignored.
            % Fields are expected to be separated by whitespace.
            % The file subjects_file_name is assumed to be in the directory subjects_dir, which must be a full (absolute or relative) path to an existing directory.

            subjects_file = fullfile(subjects_dir, subjects_file_name);
            fh_sf = fopen(subjects_file);
            all_data = textscan(fh_sf, '%s %*[^\n]');
            subject_ids_cell = all_data{1};
            fclose(fh_sf);

            subject_ids = string(subject_ids_cell);

        end




    end % static methods
end % class
