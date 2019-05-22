function histgrid_group_comparison_matrix(dimx, dimy, data_matrix_group1, data_matrix_group2, subplot_titles, super_title)
% Shows a figure with a grid of dimx * dimy histograms (as subplots) of the
% data in data_matrix. The matrix must have m = dimx * dimy columns.
% Each plot shows 2 histograms, one for each group.
figure;
num_subplots = dimx * dimy;
if num_subplots ~= size(data_matrix_group1, 2)
    error("Mismatch: Requested %d * %d = %d subplots, but data matrix has %d columns.\n", dimx, dimy, num_subplots, size(data_matrix_group1,2));
end
if size(data_matrix_group1, 2) ~= size(data_matrix_group2, 2)
    error("Mismatch: Data matrix for group 1 has %d columns, but the one for group 2 has %d.\n", size(data_matrix_group1, 2), size(data_matrix_group2, 2));
end
add_subplot_titles = 1;
if num_subplots ~= length(subplot_titles)
    add_subplot_titles = 0;
    fprintf("Mismatch: Requested %d * %d = %d subplots, but received only %d titles, ignoring all of them.\n", dimx, dimy, num_subplots, length(subplot_titles));
end
for active_plot_idx = 1:num_subplots
    subplot(dimx, dimy, active_plot_idx);
    data_group1 = data_matrix_group1(:,active_plot_idx);
    data_group2 = data_matrix_group2(:,active_plot_idx);
    
    method = 2;
    
    if method == 1
        histogram(data_group1, 'Normalization','probability');
        hold on;  % Draw line at mean
        line([mean(data_group1), mean(data_group1)], ylim, 'LineWidth', 1, 'Color', 'b');
        histogram(data_matrix_group2(:,active_plot_idx), 'Normalization', 'probability');
        line([mean(data_group2), mean(data_group2)], ylim, 'LineWidth', 1, 'Color', 'r');
        hold off;
    elseif method == 2
        nBins = 10;
        all_data = horzcat(data_group1, data_group2);
        [~ , bins] = hist(all_data, nBins); % Compute bin borders for all data
        histogram(data_group1, bins); % force same bins for data1...
        line([mean(data_group1), mean(data_group1)], ylim, 'LineWidth', 1, 'Color', 'b');
        hold on;
        histogram(data_group2, bins);   % ...and data2.
        line([mean(data_group2), mean(data_group2)], ylim, 'LineWidth', 1, 'Color', 'r');
        hold off;
    end
    if add_subplot_titles == 1
        title(subplot_titles(active_plot_idx), 'Interpreter', 'none');
    end
end

check_result = exist('sgtitle', 'file');
if check_result == 6     % see docs on `exist`
    if strlength(super_title) > 0
        sgtitle(super_title, 'Interpreter', 'none');
    end
end
end