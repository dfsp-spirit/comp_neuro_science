# Matlab utility functions

For lab members: If you are using one of my Matlab scripts and it calls a function that does not exist in your Matlab installation, chances are high that it is one of my own neuroimaging utility functions for Matlab.

To use them, checkout this repo in git, and add the *matlab_utility_functions* directory to your Matlab path:

    cd ~/matlab/
    git clone https://github.com/dfsp-spirit/comp_neuro_science.git

Now add *~/matlab/comp_neuro_science/matlab_utility_functions/* to your Matlab path:

* In the Matlab GUI: Select the **Home** tab in the upper left, then click **Set Path** in the top ribbon. In the resulting dialog, click **Add Folder** and select the directory in the file browser.
* From within a script:

    ```addpath('~/matlab/comp_neuro_science/matlab_utility_functions/')```

Should it happen again in the future, just do the following to get any new utility functions I added in the meantime:

    cd ~/matlab/comp_neuro_science/
    git pull

## Credits

Not all of these were written by me, some are from Matlab file exchange. See the headers of the individual functions for author info.

## Requirements / Dependency hell

Note that you will also need our standard Matlab packages, as my scripts use functions from them as well:

* The Freesurfer Matlab functions (in $FREESURFER_HOME/matlab/): for loading Freesurfer format files
* [Surfstat](https://www.math.mcgill.ca/keith/surfstat/) by Keith Worsley: for visualization and modeling
* bioelectromagnetism toolbox: ftp://sccn.ucsd.edu/pub/bioelectromagnetism.zip
* export_fig https://github.com/altmany/export_fig
* cbrwer from https://github.com/DrosteEffect/BrewerMap or from https://de.mathworks.com/matlabcentral/fileexchange/45208-colorbrewer-attractive-and-distinctive-colormaps

All of these are free (in the sense that they do not cost money). No commercial matlab toolbox is required (but of course Matlab itself).

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
