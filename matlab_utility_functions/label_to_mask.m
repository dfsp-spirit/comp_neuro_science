function mask = label_to_mask(label, num_verts_in_surface)
% Convert the result of the Freesurfer matlab function read_label to a
% binary vertex mask.

label = label + 1; % Shift vertex indices by 1, as they are read as zero-based indices (and Matlab uses 1 as the min)
verts_in_label = label(:,1);

mask = zeros(num_verts_in_surface, 1);
mask(verts_in_label) = 1;

mask = logical(mask);


end