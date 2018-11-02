function [sep_corr, sep_pval] = columwise_correlation(matrix1, matrix2)
% Compute correlation between columns in the two matrices, separately for each column.
% Each column could represent (some measure mapped to) a vertex on the brain surface, and each row a
% subject.



m1_num_rows = size(matrix1, 1);
m2_num_rows = size(matrix2, 1);

m1_num_columns = size(matrix1, 2);
m2_num_columns = size(matrix2, 2);


if m1_num_columns ~= m2_num_columns
    fprintf("ERROR: Matrices must have same number of columns (variables) but have %d and %d.\n", m1_num_columns, m2_num_columns);
    return;
end

if m1_num_rows ~= m2_num_rows
    fprintf("ERROR: Matrices must have same number of rows (observations) but have %d and %d.\n", m1_num_rows, m2_num_rows);
    return;
end

if m1_num_rows < 2 || m2_num_rows < 2
    fprintf("ERROR: Matrices must have at least 2 rows (observations) to compute the columwise correlation between rows, but have %d and %d.\n", m1_num_rows, m2_num_rows);
    % If this happens, the result of the call to corrcoef in the loop below
    % will not be a 2x2 matrix but a scalar value, and accessing it at
    % index (2,1) will lead to an error. It makes no sense anyway for this
    % function, so instead of then returning R, we bail out.
    return;
end

NUM_VERTS_PER_BRAIN = m1_num_columns;
sep_corr = zeros(1, NUM_VERTS_PER_BRAIN);
sep_pval = zeros(1, NUM_VERTS_PER_BRAIN);
fprintf("Computing in parallel for %d vertices...", NUM_VERTS_PER_BRAIN);
parfor vert_idx = 1:NUM_VERTS_PER_BRAIN 
    [sep_R, sep_P] = corrcoef(matrix1(:, vert_idx), matrix2(:,vert_idx));  % Compute Pearsons's correlation coefficient.
    sep_corr(1, vert_idx) = sep_R(2,1);
    sep_pval(1, vert_idx) = sep_P(2,1);
end
end

