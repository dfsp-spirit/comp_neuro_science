function medial_mask = load_medial_mask(mask_file)
% Loads a medial mask, i.e., a mask to zero out the vertices along the medial wall of a brain surface.
% The mask is a logical 1D array, and each value (1 or 0) indicates whether the respective vertex is part of the medial wall or not.
% Obviously, the mask has to fit your subject, but the function is commonly used to load the mask for the FreeSurfer 'fsaverage' subject.
% The medial wall is masked out because it by definition NOT part of the cortex.
% The mask is expected to be in a matlab file (file extension '.mat'), stored in a struct named 'mask' that has 'lh' and 'rh' keys.

if exist(medial_mask_file, 'file') ~= 2
    fprintf("ERROR: load_medial_mask: Medial mask file '%s' does not exist. Check the path.\n", medial_mask_file);
end

load(medial_mask_file); % Will introduce the new variable 'mask' into the namespace.
medial_mask = [mask.lh mask.rh];
medial_mask = logical(medial_mask);

end
