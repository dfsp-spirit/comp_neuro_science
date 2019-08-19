function clipped = clip_data(arr, lim)
% Clip outliers to percentile values.
% Usage example: clipped = clip_data(my_vector, [5 95]);
    lower_lim = lim(1);
    upper_lim = lim(2);

    lower_val = percentile_value(arr, lower_lim);
    upper_val = percentile_value(arr, upper_lim);
    clipped = arr;
    clipped(clipped < lower_val) = lower_val;
    clipped(clipped > upper_val) = upper_val;
end
