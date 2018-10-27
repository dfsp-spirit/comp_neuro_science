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
