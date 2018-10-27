function group_data = load_group_data(subjects_list, subjects_dir, measure, surf, fwhm)
% Read group morphometry data. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
% Assumes that the morphometry data files are in mgh format and have been mapped to fsaverage (like lh.area.fwhm10.fsaverage.mgh).
% Data is returned in a cell array with two cells. The first contains the subject ids as string, the second contains
%  an array with the morphometry data for the respective subject.

num_subjects = length(subjects_list);
C = cell(2, num_subjects);
group_data = C;

for subject_idx = 1:num_subjects
  subject_id = subjects_list(subject_idx);
  subject_data = read_subject_avg_data(subject_id, subjects_dir, measure, surf, fwhm);
  group_data{1, subject_idx} = subject_id;
  group_data{2, subject_idx} = subject_data;
end

end
