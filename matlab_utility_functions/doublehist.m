function fh = doublehist(data1, data2, nBins, legend_data1, legend_data2, plot_title)
% Create a figure containing the histograms for data1 and data2, with same
% bin size.
% Ex.: doublehist(lh_mean_gyri, rh_mean_gyri, 20, "lh", "rh", "Comparison of gyri data for LH vs RH");
figure;
all_data = vertcat(data1, data2);
[~ , bins] = hist(all_data, nBins); % Compute bin borders for all data
histogram(data1, bins, 'normalization', 'pdf'); % force same bins for data1...
hold on;
histogram(data2, bins, 'normalization', 'pdf');   % ...and data2.
title(plot_title);
legend(legend_data1, legend_data2);
hl1 = line([mean2(data1), mean2(data1)], ylim, 'LineWidth', 1, 'Color', 'b');
hl2 = line([mean2(data2), mean2(data2)], ylim, 'LineWidth', 1, 'Color', 'r');

% Use handles of lines to remove their entries from the legend
set(get(get(hl1,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
set(get(get(hl2,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

hold off;
fh = gcf;
end