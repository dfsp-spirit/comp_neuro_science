function [lh_mask, rh_mask] = compute_medial_mask_for_subject(subject_id, subjects_dir)
% This function loads the files
% <subjects_dir>/<subject_id>/label/lh.cortex.label and rh.cortex.label and
% uses them to compute a mask of the medial wall for the given subject.
%
% In the mask, cortex vertices are set to 1 and medial wall vertices are
% set to 0.
%
% IMPORTANT: The mask is returned using one-based indices, as used in
% MATLAB. (Even though the data is stored zero-based in the files).
%
% Using this for a subject of your study makes sense only if you work with native space data.
%
% If you work with standard space (fsaverage) data, you can apply this
% function to the fsaverage subject to get a standard space mask to use with the mapped data
% of all your subjects.
%
% Requires standard FreeSurfer MATLAB functions read_label and read_surf.
%
% USAGE EXAMPLE: 
%
% % Start by loading data and mask:
% subjects_dir = '/Applications/freesurfer/subjects';
% subject_id = 'bert';
% data_lh =  read_subject_data(subject_id, subjects_dir, 'thickness', 'white', 'lh');
% data_rh =  read_subject_data(subject_id, subjects_dir, 'thickness', 'white', 'rh');
% [mask_lh, mask_rh] = compute_medial_mask_for_subject(subject_id, subjects_dir);
%
% % Now set values of all medial wall vertices to (arbitrary value) 9 for right hemi:
% data_rh(find(~mask_rh)) = 9;
%
% % Or set the values of all medial wall vertices to zero for left hemi:
% data_lh = data_lh .* mask_lh;
%
% % And show the results:
% plot_data_onto_subject(subject_id, subjects_dir, data_lh, data_rh, jet, 'inflated', 'CT', 'mm')
%
%
% Written by Tim, 2020-01-23

subjects_dir_before = getenv("SUBJECTS_DIR");  % save old env var value

% We need to modify the environment for the FreeSurfer read_label function.
% It is a bit unfortunate, but that function does only work based on environment
% variabels. Will resore asap. :/ 
setenv("SUBJECTS_DIR", subjects_dir);  


lh_cortex_lbl = read_label(subject_id, 'lh.cortex');
rh_cortex_lbl = read_label(subject_id, 'rh.cortex');

lh_cortex_indices = lh_cortex_lbl(:,1) + 1;  % the '+1' is to compute one-based indices
rh_cortex_indices = rh_cortex_lbl(:,1) + 1;

% We need to know the number of vertices of the surfaces to create the
% mask. For this, we have to load the surface.

subject_surf_dir_path = sprintf("%s/%s/surf/", subjects_dir, subject_id);
[lh_verts, ~] = read_surf(sprintf("%s/lh.white", subject_surf_dir_path));
[rh_verts, ~] = read_surf(sprintf("%s/rh.white", subject_surf_dir_path));

num_verts_lh = length(lh_verts);
num_verts_rh = length(rh_verts);

lh_mask = zeros(num_verts_lh, 1);
lh_mask(lh_cortex_indices) = 1;

rh_mask = zeros(num_verts_rh, 1);
rh_mask(rh_cortex_indices) = 1;

% Restore ENV variable
setenv("SUBJECTS_DIR", subjects_dir_before);

end