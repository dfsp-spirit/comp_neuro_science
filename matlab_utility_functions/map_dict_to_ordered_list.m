function ordered_region_values = map_dict_to_ordered_list(ordered_region_names, subset_names, subset_values, default_value)
% Orders the values given in subset_names and subset_values according to
% the order of the names in ordered_region_names.
%
% Parameters:
%
% * ordered_region_names: array of strings, e.g., ["region1", "region2", "region3", "region4", "region5"]
%
% * subset_names: array of strings. Strings should occur in ordered_region_names (otherwise warnings will be issued and values
% ignored). Example: ["region3", "region1"]
% 
% * subset_values: array of numbers (or whatever). Must have same length as
% subset_names.
% 
% * default_value: number. The value to put into the ordered output list
% for all regions in ordered_region_names which do not show up in
% subset_names.
%
%
% Returns:
%
% * array of numbers. The ordered values.
%
% Written by Tim.
%
    num_regions = length(ordered_region_names);
    ordered_region_values = ones(num_regions, 1) .* default_value;
    verbose = 0;

    if length(subset_values) ~= length(subset_names)
        error("ordered_region_values: subset_names and subset_values must have equal length");
    end

    subset_regions_handled = zeros(length(subset_values), 1);

    for region_idx = 1:length(ordered_region_names)
        region = ordered_region_names(region_idx);
        r_idx = find(ismember(subset_names, region));
        if length(r_idx) == 1
            if verbose
                fprintf("YES: Checking region '%s': found, using value %f.\n", region, subset_values(r_idx));
            end
           ordered_region_values(region_idx) = subset_values(r_idx);
           subset_regions_handled(r_idx) = 1;
        else
            if verbose
                fprintf("NO: Checking region '%s': NOT found in value list, using default value.\n", region);
            end
        end
    end
    
    for subsetregion_idx = 1:length(subset_names)
        if subset_regions_handled(subsetregion_idx) ~= 1
            subset_region = subset_names(subsetregion_idx);
            fprintf("WARNING: Subset region with name '%s' ignored, not in ordered_region_names of atlas.\n", subset_region);
        end
    end
    fprintf("Received %d atlas regions and %d subset regions with values. %d of them found in atlas regions.\n", num_regions, length(subset_values), sum(subset_regions_handled));
end
