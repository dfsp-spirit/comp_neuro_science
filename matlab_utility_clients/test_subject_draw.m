
% Plot subject

user_home = getenv('HOME');
%subjects_dir = fullfile(user_home, 'data', 'tim_only');
subjects_dir = fullfile(user_home, 'data', 'euaims_curvature');

% Load subjects from a subjects.txt or demographics file.
subjects = read_subjects_file('subjects.txt', subjects_dir);
fprintf("Found %d subjects in subjects file.\n", length(subjects));

% Load subjects data
alot_of_data = load_group_data_cell(subjects, subjects_dir, 'area', 'white', '10');
subject_5 = alot_of_data{1, 5};
fprintf("Selected subject at index 5: %s\n", subject_5);
fprintf("Length of data for subject %s is %d.\n", subject_5, length(alot_of_data{2, 5}));


%fig = plot_subject('tim', subjects_dir, 'area', 'white');
%fig = plot_subject_avg('tim', subjects_dir, 'area', 'white', '10', 'inflated');

%% Adjust color map and/or plooting range if you feel like it.
%SurfStatColormap('jet');
%SurfStatColLim([-5, 5]);

%% You could also do stuff with the returned figure handle. Examples:
%fig.Color = [0 0.5 0.5];     % Sets superfancy background color.
%saveas(fig, 'exported_brain.jpg')   % Save it to a file.
