function fh = plot_linear_model_min(mdl, plot_title)
% Plot minimal results for a linear model (4 subplots)

% print Model overview
fprintf("===Simple Model overview===\n");
mdl

fprintf("===ANOVA of model===\n");
anv_result = anova(mdl, 'components');
anv_result

% Plot LM overview
figure;
dimx = 2;
dimy = 2;
subplot(dimx, dimy, 1);
plot(mdl);
title("Model significance");

subplot(dimx, dimy, 2);
%plotResiduals(mdl,'probability');
x = mdl.Residuals.Standardized;
cdfplot(x);
hold on;
x_values = linspace(min(x),max(x));
plot(x_values, normcdf(x_values, 0, 1), 'r-');
legend('Empirical CDF','Standard Normal CDF','Location','best')
title("Standardized residuals vs standard normal CDF");

subplot(dimx, dimy, 3);
plotEffects(mdl);
title("Effects");

subplot(dimx, dimy, 4);           
plotAdded(mdl,'group');
title("Added variable plot for coefficient group");


check_result = exist('sgtitle', 'file');
if check_result == 6     % see docs on `exist`
    if strlength(plot_title) > 0
        sgtitle(plot_title, 'Interpreter', 'none'); % sgtitle requires bioinformatics toolbox and Matlab >= 2018b
    end
end

fprintf("Simple overview done for model: %s.\n", plot_title);

fh = gcf;

end