settings = struct;
settings.atlas = "aparc";
settings.subject_id = "fsaverage";
settings.subjects_dir = "/Applications/freesurfer/subjects/";

settings.plot_title = "";
settings.color_bar_title = "Correlation";
settings.colmap = get_r_corrplot_colormap_nosteps();
settings.visualization_surface = "pial";
settings.default_value = 0.0;



% lh_precentral_thickness            0.09673059 -0.194465719  0.01487262  0.147379981 -0.52411059
% lh_precuneus_thickness             0.21884523 -0.126466834  0.44986957  0.172225972  0.22390818
% lh_superiorparietal_thickness     -0.36556475  0.765971649 -0.74639899 -0.482728031 -0.89580556

% rh_inferiorparietal_thickness      0.05575758 -0.073921879  0.04312874 -0.188321643 -0.04548064
% rh_lateralorbitofrontal_thickness  0.80011163  0.447101409 -0.34368481  0.324895584  0.12425388
% rh_medialorbitofrontal_thickness  -0.20727826  0.338633921  0.63367881 -0.226990762 -0.19561498
% rh_parsorbitalis_thickness        -0.23389753  0.115389042 -0.06156532  0.167822907 -0.06996907
% rh_rostralmiddlefrontal_thickness -0.41589291 -0.560685243 -0.59425986 -0.243035123 -0.07478848
% rh_superiorparietal_thickness      0.18465023 -0.232560989  0.09830221 -0.002455148  0.42763110

% lh_cuneus_area                     0.16968102 -0.002177254  0.27797724 -0.387400984  0.28970908
% lh_superiorparietal_area          -0.62857313  0.987445391 -1.03749328 -0.579315989 -0.47436636
% lh_temporalpole_area               0.01596289  0.040645231  0.42363964 -0.237406049 -0.45428465

% rh_superiortemporal_area           0.38095445 -0.163404417 -0.28569611  0.225711117  0.65461787

% lh_superiorparietal_volume         0.74139835 -0.950063248  1.04192831  0.734337232  1.13120834
% lh_supramarginal_volume           -0.10921499  0.006661659  0.30768490 -0.408689689  0.59975195
% lh_insula_volume                  -0.12394311  0.523989286 -0.02918664 -0.114713283  0.06576499

% rh_precuneus_volume               -0.04277069 -0.513872508  0.01915885  0.226863564 -0.46051890
% rh_superiorparietal_volume         0.11357352 -0.028586333 -0.31733383 -0.289559775 -0.05103286
% rh_superiortemporal_volume        -0.63573469  0.081307127  0.01919355  0.327169002 -0.60104862


settings.region_names = get_atlas_region_names(settings.subjects_dir, settings.subject_id, settings.atlas);
fprintf("Received %d region names for atlas '%s'.\n", length(settings.region_names), settings.atlas);

% ----- Define the data points here. -----
subset_names_lh_thickness = ["precentral", "precuneus", "superiorparietal"];
subset_values_lh_thickness = [0.09673059, 0.21884523, -0.36556475];

subset_names_rh_thickness = ["inferiorparietal", "lateralorbitofrontal", "medialorbitofrontal", "parsorbitalis", "rostralmiddlefrontal", "superiorparietal"];
subset_values_rh_thickness = [0.05575758, 0.80011163, -0.20727826, -0.23389753, -0.41589291, 0.18465023];

subset_names_lh_area = ["cuneus", "superiorparietal", "temporalpole"];
subset_values_lh_area = [0.16968102, -0.62857313, 0.01596289];

subset_names_rh_area = ["superiortemporal"];
subset_values_rh_area = [0.38095445];

subset_names_lh_volume = ["superiorparietal", "supramarginal", "insula"];
subset_values_lh_volume = [0.74139835, -0.10921499, -0.12394311];

subset_names_rh_volume = ["precuneus", "superiorparietal", "superiortemporal"];
subset_values_rh_volume = [-0.04277069, 0.11357352, -0.63573469];



% ----- Call the function several times here. ----- 
plot_corr_values("thickness", "lh", subset_names_lh_thickness, subset_values_lh_thickness, settings);
plot_corr_values("thickness", "rh", subset_names_rh_thickness, subset_values_rh_thickness, settings);
plot_corr_values("area", "lh", subset_names_lh_area, subset_values_lh_area, settings);
plot_corr_values("area", "rh", subset_names_rh_area, subset_values_rh_area, settings);
plot_corr_values("volume", "lh", subset_names_lh_volume, subset_values_lh_volume, settings);
plot_corr_values("volume", "rh", subset_names_rh_volume, subset_values_rh_volume, settings);


% ----- Function definition ------
function plot_corr_values(data_tag, hemi, subset_names, subset_values, settings)
    fprintf("Plotting for data '%s', hemi %s.\n", data_tag, hemi);
    data = map_dict_to_ordered_list(settings.region_names, subset_names, subset_values, settings.default_value);
    [fh, ~] = plot_data_in_atlas_regions(data, settings.atlas, hemi, settings.subject_id, settings.subjects_dir, settings.visualization_surface, settings.colmap);
    SurfStatColLim([-1,1]);
    base_export_filename = sprintf("corr_%s_%s", data_tag, hemi);
    TSSurfStatSaveFig(base_export_filename, 'png', 'all');
end
