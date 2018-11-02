function [sep_corr, sep_pval] = columwise_correlation(matrix1, matrix2)
% Compute correlation between columns in the two matrices, separately for each column.
% Each column could represent (some measure mapped to) a vertex on the brain surface, and each row a
% subject.

NUM_VERTS_PER_BRAIN = length(matrix1);
sep_corr = zeros(1, NUM_VERTS_PER_BRAIN);
sep_pval = zeros(1, NUM_VERTS_PER_BRAIN);
fprintf("Computing in parallel for %d vertices...", NUM_VERTS_PER_BRAIN);
parfor vert_idx = 1:NUM_VERTS_PER_BRAIN
  
    [sep_R, sep_P] = corrcoef(matrix1(:, vert_idx), matrix2(:,vert_idx));  % Compute Pearsons's correlation coefficient.
    sep_corr(vert_idx) = sep_R(2,1);
    sep_pval(vert_idx) = sep_P(2,1);
end
end

