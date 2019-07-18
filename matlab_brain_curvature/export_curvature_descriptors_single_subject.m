function res = export_curvature_descriptors_single_subject(subject_id, subjects_dir)
%% export curv descriptors - export curvature descriptors for all subjects in a subjects file
% Written by Tim
% - Make sure to add /Applications/Freesurfer/matlab to the PATH in Matlab
%   (click 'HOME -> Set Path' in the GUI)
% - If you want to create surfstat plots (see create_surfstat_plots setting), you need SurfStat in your Matlab path
% - This script requires that my curvature script, CurvatureDescriptors.m, is in your Matlab path
% - This script reads mris_curvature output files that you will only have if you run my bash script to compute it, see run_cpc_for_all_surfaces_and_settings.bash or the GNU parallel version
%
%
% To run this from a shell script or the command line: matlab -nojvm -nodisplay -nosplash -r "export_curvature_descriptors_single_subject('tim','./');quit()"


%% Settings - you will have to adapt them to your needs.
settings = struct;
settings.subjects_dir = subjects_dir;    % The directory the Freesurfer environment variable $SUBJECTS_DIR points to, i.e., the directory containing the data for all your subjects. This can be any directory, just make sure the concatinated path that results in the end points to your data.

% general settings
settings.silent = 1;         % if silent is set to 1, no output is printed in the function.
settings.export_descriptor_data = 1; % Whether the descriptor data should be exported to a file in FreeSurfer format (using SurfStatWriteData). Useful to map it to fsaverage.

%% Setup for which data you want to compute stuff

settings.averagings_int = [5]; % These are encoded in the file extensions used. They were created by the bash script that runs mris_curvature for different averaging values.
settings.avg_int_to_perform_all_tasks_at = 5;       % This is the avg setting for which statistics and plots are created (it would be too much output to generate them at all settings). This value must occur in settings.averagings_int, or these tasks will not be performed at all.


% The surfaces for which you have measured curvature data from an mris_curvature run (see below). If you used ?h.pial, set this to 'pial' and this script will try to read the measured data from ?h.pial.max and ?h.pial.min. These output files are expected to be in 'subject_surf_dir' for your subject.
settings.surfaces = ["white", "pial"];

% The descriptors you are interested in
%settings.descriptors = CurvatureDescriptors.get_all_descriptor_short_names_as_array(); % export data for ALL descriptors
settings.descriptors = ["principal_curvature_k1", "principal_curvature_k2", "mean_curvature", "gaussian_curvature", "shape_index", "shape_type" ];



subjects_analysis = [string(subject_id)];     % list containing only the single subject

descriptors = settings.descriptors;
surfaces = settings.surfaces;

if ~ ismember(settings.avg_int_to_perform_all_tasks_at, settings.averagings_int)
    fprintf("WARNING: The value %d (settings.avg_int_to_perform_all_tasks_at) does not occur in the list of all averagings (settings.averagings_int). Will NOT perform the special tasks.", settings.avg_int_to_perform_all_tasks_at)
end

num_subjects = length(subjects_analysis);
fprintf("Running for %d subjects with %d surfaces and %d descriptors.\n", num_subjects, length(surfaces), length(descriptors));

averagings_str = string(settings.averagings_int);
num_averagings = length(averagings_str);

subject_curv_measures = zeros(1 + num_averagings, num_subjects); % first field is for subject id, then one for the measurements with each averaging
%fsaverage_surf_dir = strcat(settings.subjects_dir, 'fsaverage/surf/');

num_descriptors = length(descriptors);
for descriptor_index = 1:num_descriptors

    descriptor = descriptors(descriptor_index);



    num_surfaces = length(surfaces);
    for surface_index = 1:num_surfaces
        measured_surface = surfaces(surface_index);
        measured_surface_fs_file_name = sprintf('.%s', measured_surface);
        if strcmp(measured_surface, 'white')
            measured_surface_fs_file_name = '';
        end


        for subject_index = 1:num_subjects

            subject_id = subjects_analysis(subject_index);
            subject_curv_measures(subject_index, 1) = subject_id;
            if settings.silent == 0
                fprintf("Handling descriptor %s, surface %s, subject %s.\n", descriptor, measured_surface, subject_id);
            end
            subject_surf_dir = strcat(settings.subjects_dir, subject_id, '/surf/');    % The relative path to the surface data of the example subject you want to use. Here, 'tim' is the subject id, and 'surf' is the default folder used by Freesurfer to store computed surface data for a subject.


            %%Read input data
            % Note that you must generate the curvature files for k1 and k2 from a surface using mris_curvature in the system shell, see https://surfer.nmr.mgh.harvard.edu/fswiki/mris_curvature
            % Example: mris_curvature -min -max -a 3 rh.pial && mris_curvature -min -max -a 3 lh.pial


            for avg_index = 1:num_averagings
                avg = averagings_str(avg_index);
                if settings.silent == 0
                    fprintf(" * Handling subject %s surface %s with averaging set to %s.\n", subject_id, measured_surface, avg);
                end
                filename_suffix = strcat('.a', avg); % Construct the suffix to load the correct file

                k2_rh = read_curv(strcat(subject_surf_dir, 'rh.', measured_surface, '.min', filename_suffix));
                k1_rh = read_curv(strcat(subject_surf_dir, 'rh.', measured_surface, '.max', filename_suffix));
                k2_lh = read_curv(strcat(subject_surf_dir, 'lh.', measured_surface, '.min', filename_suffix));
                k1_lh = read_curv(strcat(subject_surf_dir, 'lh.', measured_surface, '.max', filename_suffix));


                % Generate data and compute surface descriptors
                k1 = vertcat(k1_lh, k1_rh);
                k2 = vertcat(k2_lh, k2_rh);

                % Compute the curvatures for current averaging, save them
                curv_calculator = CurvatureDescriptors(k1, k2); % init only

                descriptor_to_plot = curv_calculator.compute_by_descriptor_short_name(descriptor);  % compute descriptor
                descriptor_file_name = descriptor_to_plot.short_name; % descriptor name to use in file names, e.g., in exported figure files





                % Collect some data for this subject, add it to a list that hold the data over all subjects.
                % Here, we collect all data of the selected averaging of this subject.
                if avg == string(settings.avg_int_to_perform_all_tasks_at)

                    if settings.export_descriptor_data == 1
                        avg_filename_tag = sprintf('_avg%s', avg);       % The tag to add to mark the averaging setting used. If we decide on a final avg setting to use, we could set this to the empty string.

                        export_file_template = '%s%s.%s%s';
                        export_file_name_lh = sprintf(export_file_template, 'lh', measured_surface_fs_file_name, descriptor_file_name, avg_filename_tag);
                        export_file_name_rh = sprintf(export_file_template, 'rh', measured_surface_fs_file_name, descriptor_file_name, avg_filename_tag);
                        full_export_file_lh = strcat(subject_surf_dir, export_file_name_lh);
                        full_export_file_rh = strcat(subject_surf_dir, export_file_name_rh);
                        export_data_lh = descriptor_to_plot.data(1:(length(k1_lh)))';
                        export_data_rh = descriptor_to_plot.data((length(k1_lh)+1):end)';
                        fprintf("Exporting data for descriptor %s, surface %s, subject %s to files '%s' and '%s'.\n", descriptor, measured_surface, subject_id, full_export_file_lh, full_export_file_rh);
                        SurfStatWriteData(full_export_file_lh, export_data_lh);
                        SurfStatWriteData(full_export_file_rh, export_data_rh);
                    end
                end
            end % averagings
        end % subjects

    end % loop over surfaces
    close all;
    close all hidden;
end % loop over descriptors
close all;
close all hidden;
res = 1; % ignore this, return value

end % function
