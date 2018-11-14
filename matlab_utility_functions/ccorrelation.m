function [sep_corr, sep_pval] = ccorrelation(data_white, data_pial)
% Compute correlation between columns in data_white and data_pial, separately for each column.
% Each column represents a vertex on the brain surface.
%
% This function uses Pearson correlation, it is thus only applicable to
% continuous data (i.e., not for categorial like shape type).
%
% Returns:
% - the correlation coefficients (one for each column in data_white/pial)
% - the p value for each correlation coefficient (see

NUM_VERTS_PER_BRAIN = length(data_white);
sep_corr = zeros(1, NUM_VERTS_PER_BRAIN);
sep_pval = zeros(1, NUM_VERTS_PER_BRAIN);
fprintf("Computing in parallel for %d vertices...", NUM_VERTS_PER_BRAIN);
parfor vert_idx = 1:NUM_VERTS_PER_BRAIN
    [sep_R, sep_P] = corrcoef(data_white(:, vert_idx), data_pial(:,vert_idx));  % Compute Pearsons's correlation coefficient.
    sep_corr(vert_idx) = sep_R(2,1);
    sep_pval(vert_idx) = sep_P(2,1);
end
fprintf(" done.\n");
end
