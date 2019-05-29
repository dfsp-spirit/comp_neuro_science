% Common settings
atlas = "aparc";
subject_id = "bert";
subjects_dir = "/Applications/freesurfer/subjects/";

% Test with both hemispheres
data_to_plot = 1:72;
hemi = "both";
[fh, region_names] = plot_data_in_atlas_regions(data_to_plot, atlas, hemi, subject_id, subjects_dir);
title("Both hemis");

% Test with left hemisphere
data_to_plot = 1:36;
hemi = "lh";
[fh, region_names] = plot_data_in_atlas_regions(data_to_plot, atlas, hemi, subject_id, subjects_dir);
title("lh");

% Test with right hemisphere
data_to_plot = 1:36;
hemi = "rh";
[fh, region_names] = plot_data_in_atlas_regions(data_to_plot, atlas, hemi, subject_id, subjects_dir);
title("rh");