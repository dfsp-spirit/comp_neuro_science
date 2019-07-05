# My Matlab utility functions

For lab members: If you are using one of my Matlab scripts and it calls a function that does not exist in your Matlab installation, chances are high that it is one of my own neuroimaging utility functions for Matlab.

They can all be found in the sub directory [./matlab_utility_functions](./matlab_utility_functions). To get them, checkout this repo in git, and add the *matlab_utility_functions* directory to your Matlab path:

    cd ~/matlab/
    git clone https://github.com/dfsp-spirit/comp_neuro_science.git

Now add *~/matlab/comp_neuro_science/matlab_utility_functions/* to your Matlab path:

* In the Matlab GUI: Select the **Home** tab in the upper left, then click **Set Path** in the top ribbon. In the resulting dialog, click **Add Folder** and select the directory in the file browser.
* From within a script:

    ```addpath('~/matlab/comp_neuro_science/matlab_utility_functions/')```

Should it happen again in the future, just do the following to get any new utility functions I added in the meantime:

    cd ~/matlab/
    git pull

## Dependency hell

Note that you will also need our standard Matlab packages, as my scripts use functions from them as well:

* The Freesurfer Matlab functions (in $FREESURFER_HOME/matlab/): for loading Freesurfer format files
* [Surfstat](https://galton.uchicago.edu/faculty/InMemoriam/worsley/research/surfstat/) by Keith Worsley: for visualization and modeling


# niplot -- Matlab neuroimaging utility functions to display neuroimaging morphometry data on brain meshes

These are some Matlab utility function for neuroimaging. They implement a simple high-level interface to some SurfStat functions, e.g., they allow you to plot some measure onto a brain surface in a single line of Matlab code.

## Requirements

These functions require Matlab, and the SurfStat package on your Matlab path.

## Installation

Put all of them into a directory and add that directory to your matlab path. A typical path would be ~/matlab/toolboxes/niplot


## Example Workflow: load standard space area data for a list of subjects and plot it for one of them

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
