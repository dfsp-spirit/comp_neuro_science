
% Plot subject

user_home = getenv('HOME');
subjects_dir = fullfile(user_home, 'data', 'tim_only');

%fig = plot_subject('tim', subjects_dir, 'area', 'white');
fig = plot_subject_avg('tim', subjects_dir, 'area', 'white', '10', 'inflated');
