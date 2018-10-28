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
