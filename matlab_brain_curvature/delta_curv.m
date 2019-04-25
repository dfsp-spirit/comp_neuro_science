%% delta_curvs.m -- curvature differences between white and pial surfaces
% Written by Tim
% Make sure to add $FREESURFER_HOME/matlab to the PATH in Matlab
% (click 'HOME -> Set Path' in the GUI)

clc;
clear;

%% Settings - you will have to adapt them to your needs.
subjects_dir = '/Users/timschaefer/data/tim_only/';    % The directory the Freesurfer environment variable $SUBJECTS_DIR points to, i.e., the directory containing the data for all your subjects. This can be any directory, just make sure the concatinated path that results in the end points to your data.
%subjects_dir = '/home/spirit/data/tim_only/005_edits_fs/';
setenv('SUBJECTS_DIR', subjects_dir);       % required for some Freesurfer matlab functions, e.g., read_label

subject_id = "tim";

subject_surf_dir = sprintf("%s/%s/%s", subjects_dir, subject_id, "surf/");    % The relative path to the surface data of the example subject you want to use. Here, 'tim' is the subject id, and 'surf' is the default folder used by Freesurfer to store computed surface data for a subject.

% Note: If you do not have MRI data or mris_curvature output yet and just want to test this script, you can check for example data in the directory 'example_data' of this repo. Just modify subject_surf_dir to point to that directory. Data for the 'pial' and 'white' surfaces can be found in the directory.
measured_surface = 'both';       % The surface for which you have measured curvature data from an mris_curvature run (see below). If you used ?h.pial, set this to 'pial' and this script will try to read the measured data from ?h.pial.max and ?h.pial.min. These output files are expected to be in 'subject_surf_dir' for your subject.
%display_on_surface = 'inflated'; % The surface on which the data should be plotted. You can use the same surface you measured, but it is often better to use 'inflated' to see the values in deep sulci.
display_on_surface = 'pial';


dir_here = pwd;

% End of settings. But make sure you set the descriptor you want to plot
% below, it is in the variable 'descriptor_to_plot'.

%%Read input data
% Note that you must generate the curvature files for k1 and k2 from a surface using mris_curvature in the system shell, see https://surfer.nmr.mgh.harvard.edu/fswiki/mris_curvature
% Example: mris_curvature -min -max -a 3 rh.pial && mris_curvature -min -max -a 3 lh.pial

[k1_pial, k2_pial] = read_curv_data_for_surface(subjects_dir, subject_id, "pial", 1);
[k1_white, k2_white] = read_curv_data_for_surface(subjects_dir, subject_id, "white", 1);


curv_calculator_pial = CurvatureDescriptors(k1_pial, k2_pial);
curv_calculator_white = CurvatureDescriptors(k1_white, k2_white);

% Compute all the descriptors:
mean_curvature_white = curv_calculator_white.mean_curvature();
gaussian_curvature_white = curv_calculator_white.gaussian_curvature();

mean_curvature_pial = curv_calculator_pial.mean_curvature();
gaussian_curvature_pial = curv_calculator_pial.gaussian_curvature();


%...but we only use/plot one of them. Make your choice:

delta_curv_meancurv = mean_curvature_white.data - mean_curvature_pial.data;
delta_curv_gausscurv = gaussian_curvature_white.data - gaussian_curvature_pial.data; % Just for fun, this will look ugly

descriptor_to_plot = delta_curv_meancurv;

plot_title = "delta curv";
plot_range = [-0.2, 0.2];
%plot_range = [-0.15, 0.15];
% Note: If you want to try a custom plot range, it helps to look at the histogram of the curv_values:
%histogram(descriptor_to_plot.data)

disp("Delta curv");
descriptor_stats = sprintf('min=%.3f, max=%.3f, median=%.3f, mean=%.3f, skewness=%.3f. Plotting range %.3f to %.3f.', min(descriptor_to_plot), max(descriptor_to_plot), median(descriptor_to_plot), mean(descriptor_to_plot), skewness(descriptor_to_plot), plot_range(1), plot_range(2));
disp(descriptor_stats);

%% Display the data on a surface. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
%display_surf_dir = subjects_dir + 'fsaverage/surf';g
display_surf_dir = subject_surf_dir;     % We use the surface of the subject itself in this demo case, since the data only consists of this single subject. You would usually plot on fsaverage for group comparison.
lh_display_surf_file = strcat(display_surf_dir, strcat('lh.', display_on_surface));
rh_display_surf_file = strcat(display_surf_dir, strcat('rh.', display_on_surface));
fprintf("Loading display surf files: '%s' and '%s'.\n", lh_display_surf_file, rh_display_surf_file);
display_surface = SurfStatReadSurf ( {lh_display_surf_file, rh_display_surf_file} );

colormap_blue_orange = [0 1 1
    0 0 1
    1 0 0
    1 1 0];

% A custom colormap useful for plotting descriptors which have binary output, e.g., area_fraction_of_mean_curvature_index.
colormap_binary = [1 1 0
    0 0 1
    ];

% red green
colormap_binary_rg = [1 0 0
    0 1 0
    ];

colormap_tri_rgg = [1 0 0
    0.5 0.5 0.5
    0 1 0
    ];

cd(dir_here); % Ensure images are saved in script dir (not in subjects dir!)


descriptor_to_plot_short_name = "deltacurv";

SurfStatColormap('jet');
SurfStatView(descriptor_to_plot, display_surface, plot_title);
SurfStatColormap('jet');
%SurfStatColormap(colormap_blue_orange);
%SurfStatColormap(colormap_binary);
SurfStatColLim(plot_range);
export_fig_filename = sprintf("%s_of_%s_on_%s_full.png", descriptor_to_plot_short_name, measured_surface, display_on_surface);
SurfStatSaveFig(export_fig_filename, 'o');
fprintf("Current directory is: %s\n", pwd);
fprintf("Saved figure to '%s'.\n", export_fig_filename);

% Plot the negative versus positive curvature
d = sign(descriptor_to_plot);
d(d==0) = -1; % assign the 0 curvature values to one of the other 2 values, to avoid a 3rd color in the plot
SurfStatView(d, display_surface, 'pos vs. neg');
SurfStatColormap(colormap_binary_rg);
export_fig_filename = sprintf("%s_of_%s_on_%s_binarized.png", descriptor_to_plot_short_name, measured_surface, display_on_surface);
SurfStatSaveFig(export_fig_filename, 'o');
fprintf("Saved figure to '%s'.\n", export_fig_filename);

% Plot the negative versus positive versus zero curvature

if strcmp(descriptor_to_plot_short_name, "gaussian_curvature")
    threshold_consider_curv_zero = 0.001;    % Curvature values smaller than this threshold will be plotted as zero
elseif strcmp(descriptor_to_plot_short_name, "mean_curvature")
    threshold_consider_curv_zero = 0.05;
else
    threshold_consider_curv_zero = 0.0;
end

dn = descriptor_to_plot;
dn(abs(dn)<threshold_consider_curv_zero) = 0;
dn = sign(dn);
SurfStatView(dn, display_surface, 'pos vs. neg vs. zero');
SurfStatColormap(colormap_tri_rgg);
export_fig_filename = sprintf("%s_of_%s_on_%s_tri.png", descriptor_to_plot_short_name, measured_surface, display_on_surface);
SurfStatSaveFig(export_fig_filename, 'o');
fprintf("Saved figure to '%s'.\n", export_fig_filename);


function [k1, k2] = read_curv_data_for_surface(subjects_dir, subject_id, measured_surface, setting_do_threshold)
% subjects_dir: FreeSurfer subjects dir, something like '/path/to/study/'
% subject_id: string, subject id (dir name within subjects_dir), something
% like 'subject1'
% measured_surface: something like 'pial' or 'white'
% setting_do_threshold: 1 for yes, 0 for no. Whether to threshold curvature
% values, i.e., discard very small or large ones.

subject_surf_dir = sprintf("%s/%s/surf", subjects_dir, subject_id);


dir_here = pwd;

cd(subject_surf_dir);
k2_rh = read_curv(strcat('rh.', measured_surface, '.min'));
k1_rh = read_curv(strcat('rh.', measured_surface, '.max'));
k2_lh = read_curv(strcat('lh.', measured_surface, '.min'));
k1_lh = read_curv(strcat('lh.', measured_surface, '.max'));

cd(dir_here);

% Read cortex mask. This is only needed to mask vertices along the medial
% wall.
num_verts_lh = length(k1_lh);
label_file_name_lh = "lh.cortex"; % The 'read_label' function will append '.label' to this.
lh_cortex_label = read_label(subject_id, label_file_name_lh); % This works based on $SUBJECTS_DIR
lh_cortex_mask = label_to_mask(lh_cortex_label, num_verts_lh);
num_verts_rh = length(k1_rh);
label_file_name_rh = "rh.cortex"; % The 'read_label' function will append '.label' to this.
rh_cortex_label = read_label(subject_id, label_file_name_rh); % This works based on $SUBJECTS_DIR
rh_cortex_mask = label_to_mask(rh_cortex_label, num_verts_rh);

% Apply mask
k1_lh = k1_lh .* lh_cortex_mask;
k2_lh = k2_lh .* lh_cortex_mask;
k1_rh = k1_rh .* rh_cortex_mask;
k2_rh = k2_rh .* rh_cortex_mask;



%% Generate data and compute surface descriptors
k1 = vertcat(k1_lh, k1_rh);
k2 = vertcat(k2_lh, k2_rh);


if setting_do_threshold == 1
    fprintf("Thresholding k1 and k2 to remove outliers.\n");
    k1(k1 < -1.5) = 0;
    k1(k1 > 1.0) = 0;    
    k2(k2 < -0.1) = 0;
    k1(k1 > 0.1) = 0;
end

end

