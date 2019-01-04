function xz = transform_to_zero_mean_and_unit_variance(X)
%% Transform to zero mean and unit variance.
xz = reshape(zscore(X(:)),size(X,1),size(X,2));
end