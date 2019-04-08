function [h, p, ci ,stats] = info_ttest2(data_print_label, data_group_case, data_group_control)
compute_effect_size = 0; % requires Toolbox 'Measures of Effect Size' by Harald Hentschke
if (compute_effect_size == 1)
    stats = mes(data_group_case, data_group_control, 'hedgesg', 'nBoot', 10000);
    fprintf("Hesges g is: %f", stats.hedgesg)
end
[h, p, ci, stats] = ttest2( data_group_case, data_group_control);

cohens_d = abs(stats.tstat ./ sqrt(stats.df + 1)); % measure of effect size

fprintf("---%s---\n", data_print_label);
fprintf("Test for differences in %s: result = %d (0 means no differences), [t(%d) = %f, p = %f] |d|=%f.\n", data_print_label, h, stats.df, stats.tstat, p, cohens_d);
fprintf("Control: Mean=%f, Stddev=%f (range %f - %f).\n", mean(data_group_control), std(data_group_control), min(data_group_control), max(data_group_control));
fprintf("Case   : Mean=%f, Stddev=%f (range %f - %f).\n", mean(data_group_case), std(data_group_case), min(data_group_case), max(data_group_case));
if h == 1
    fprintf("!!!!! Found group difference in %s. !!!!!\n", data_print_label)
end
fprintf("%s mean for case group: %f, %s mean for control group: %f.\n", data_print_label, mean(data_group_case), data_print_label, mean(data_group_control));
end
