function val = percentile_value(arr, pct)
% Compute percentile values from data, i.e., the values that occurs in the data and is closest to the percentile. Index is rounded down.
% Example usage: val_close_to_5_percentile = percentile_value(my_data, 5);
    len = length(arr);
    ind = floor(pct/100*len);
    newarr = sort(arr);
    val = newarr(ind);
end
