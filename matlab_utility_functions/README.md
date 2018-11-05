# niplot -- Matlab neuroimaging utility functions to display neuroimaging morphometry data on brain meshes

These are some Matlab utility function for neuroimaging. They implement a simple high-level interface to some SurfStat functions, e.g., they allow you to plot some measure onto a brain surface in a single line of Matlab code.

## Requirements

These functions require Matlab, and the SurfStat package on your Matlab path.

## Installation

Put all of them into a directory and add that directory to your matlab path. A typical path would be ~/matlab/toolboxes/niplot

### Usage

Example that uses many of the functions to load group data and plot it for some subjects:

```matlab
subjects_dir = fullfile(getenv('HOME'), 'data', 'my_study1');
demographics_file = fullfile(subjects_dir, 'demographics_curv.txt');

medial_mask = load_medial_mask('medial_mask_fsaverage.mat'); % That file is on the Matlab path, so no path needed.

demographics = read_demographics_file(demographics_file, '%s %s %f %f %f %f %f %f %s', ["subjects", "group", "age", "iq", "bd_pial_sa", "bd_white_sa", "bd_thickness", "bd_volume", "site"]);

subjects = string(demographics.subjects);
fprintf("Found data on %d subjects in demographics file.\n", length(subjects));

% Load area data for white surface at fwhm10 for all subjects.
% Will load the 2 files subjects_dir/subject/surf/?h.area.fwhm10.fsaverage.mgh  (where ? is 'l' and 'r' for the left and right hemispheres)
data = load_group_data(subjects, subjects_dir, 'area', 'white', '10');
data_std = std(data);
data_mean = mean(data);

% Plot the data for the 3rd subject in the list on fsaverage inflated surface
plot_title_stddev = sprintf('Stddev of %s at fwhm%s, s=%s', measure_plot_name, fwhm, surface);
plot_custom_data_avg(subjects_dir, data_std(3,:), 'inflated', plot_title_stddev);
```
