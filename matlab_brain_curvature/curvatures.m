%% curvatures.m -- Reads curvature files generated by FreeSurfer, computes different curvature descriptors and allows one to plot them.
% Written by Tim
% Make sure to add /Applications/Freesurfer/matlab to the PATH in Matlab
% (click 'HOME -> Set Path' in the GUI)

clc;
clear;

%% Settings - you will have to adapt them to your needs.
subjects_dir = '/Users/timschaefer/data/tim_only/005_edits_fs/';
%subjects_dir = '/home/spirit/data/tim_only/005_edits_fs/';

subject_surf_dir = strcat(subjects_dir,'tim/surf/');
measured_surface = 'pial';       % The surface for which you have measured curvature data from an mris_curvature run (see below). If you used ?h.pial, set this to 'pial' and this script will try to read the measured data from ?h.pial.max and ?h.pial.min.
display_on_surface = 'inflated'; % The surface on which the data should be plotted. You can use the same surface you measured, but it is often better to use 'inflated' to see the values in deep sulci.
%display_on_surface = 'pial';


%% Read input data
% Note that you must generate the curvature file from a surface using mris_curvature in the system shell, see https://surfer.nmr.mgh.harvard.edu/fswiki/mris_curvature
% Example: mris_curvature -min -max -a 3 rh.pial && mris_curvature -min -max -a 3 lh.pial

cd(subject_surf_dir);
k2_rh = read_curv(strcat('rh.', measured_surface, '.min'));
k1_rh = read_curv(strcat('rh.', measured_surface, '.max'));
k2_lh = read_curv(strcat('lh.', measured_surface, '.min'));
k1_lh = read_curv(strcat('lh.', measured_surface, '.max'));


%% Generate data and compute surface descriptors
k1 = vertcat(k1_lh, k1_rh);
k2 = vertcat(k2_lh, k2_rh);

% Different curvature descriptors are available in the CurvatureDescriptors class. See
% http://brainvis.wustl.edu/wiki/index.php/Folding/Measurements for a full
% list. Feel free to come up with and implement some more.

curv_calculator = CurvatureDescriptors(k1, k2);

% Compute all the descriptors:
principal_curvature_k1 = curv_calculator.principal_curvature_k1();
principal_curvature_k2 = curv_calculator.principal_curvature_k2();
mean_curvature = curv_calculator.mean_curvature();
gaussian_curvature = curv_calculator.gaussian_curvature();
intrinsic_curvature_index = curv_calculator.intrinsic_curvature_index();
negative_intrinsic_curvature_index = curv_calculator.negative_intrinsic_curvature_index();
gaussian_l2_norm = curv_calculator.gaussian_l2_norm();
absolute_intrinsic_curvature_index = curv_calculator.absolute_intrinsic_curvature_index();
mean_curvature_index = curv_calculator.mean_curvature_index();
negative_mean_curvature_index = curv_calculator.negative_mean_curvature_index();
mean_l2_norm = curv_calculator.mean_l2_norm();
absolute_mean_curvature_index = curv_calculator.absolute_mean_curvature_index();
folding_index = curv_calculator.folding_index();
curvedness_index = curv_calculator.curvedness_index();
shape_index = curv_calculator.shape_index();
shape_type = curv_calculator.shape_type();
area_fraction_of_intrinsic_curvature_index = curv_calculator.area_fraction_of_intrinsic_curvature_index();
area_fraction_of_negative_intrinsic_curvature_index = curv_calculator.area_fraction_of_negative_intrinsic_curvature_index();
area_fraction_of_mean_curvature_index = curv_calculator.area_fraction_of_mean_curvature_index();
area_fraction_of_negative_mean_curvature_index = curv_calculator.area_fraction_of_negative_mean_curvature_index();
sh2sh = curv_calculator.sh2sh();
sk2sk = curv_calculator.sk2sk();

%...but we only use/plot one of them. Make your choice:
descriptor_to_plot = principal_curvature_k2;

plot_title = descriptor_to_plot.name;
plot_range = descriptor_to_plot.suggested_plot_range;
%plot_range = [-0.4, 0.3];
% Note: If you want to try a custom plot range, it helps to look at the histogram of the curv_values:
%histogram(descriptor_to_plot.data)

disp(descriptor_to_plot.description);
descriptor_stats = sprintf('min=%.3f, max=%.3f, median=%.3f, mean=%.3f, skewness=%.3f. Plotting range %.2f to %.2f.', min(descriptor_to_plot.data), max(descriptor_to_plot.data), median(descriptor_to_plot.data), mean(descriptor_to_plot.data), skewness(descriptor_to_plot.data), plot_range(1), plot_range(2));
disp(descriptor_stats);

%% Display the data on a surface. Requires surfstat in your MATLAB path, see http://www.math.mcgill.ca/keith/surfstat/.
%display_surf_dir = subjects_dir + 'fsaverage/surf';g
display_surf_dir = subject_surf_dir;     % We use the surface of the subject itself in this demo case, since the data only consists of this single subject.
display_surface = SurfStatReadSurf ( {strcat(display_surf_dir, strcat('lh.', display_on_surface)), strcat(display_surf_dir, strcat('rh.', display_on_surface))} );

colormap_blue_orange = [0 1 1
    0 0 1
    1 0 0
    1 1 0];

SurfStatView(descriptor_to_plot.data, display_surface, plot_title);
SurfStatColormap('jet');
%SurfStatColormap(colormap_blue_orange);
SurfStatColLim(plot_range);
