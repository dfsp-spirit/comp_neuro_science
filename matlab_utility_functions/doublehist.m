function fh = doublehist(data1, data2, nBins, legend_data1, legend_data2, plot_title)
% Create a figure containing the histograms for data1 and data2, with same
% bin size.
% Ex.: doublehist(lh_mean_gyri, rh_mean_gyri, 20, "lh", "rh", "Comparison of gyri data for LH vs RH");
figure;
all_data = horzcat(data1, data2);
[~ , bins] = hist(all_data, nBins); % Compute bin borders for all data
histogram(data1, bins); % force same bins for data1...
hold on;
histogram(data2, bins);   % ...and data2.
title(plot_title);
legend(legend_data1, legend_data2);
hold off;
fh = gcf;
end