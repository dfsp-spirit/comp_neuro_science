function [PD, BIC, AIC, AICc] = check_fit_dist(data, distname)
PD = fitdist(data, distname);
NLL=PD.NLogL; % -Log(L)
%If NLL is non-finite number, produce error to ignore distribution
if ~isfinite(NLL)
    error('non-finite NLL');
end
k=numel(PD.Params); %Number of parameters
n=numel(data);
BIC=-2*(-NLL)+k*log(n);
AIC=-2*(-NLL)+2*k;
AICc=(AIC)+((2*k*(k+1))/(n-k-1));

figure;
num_bins = 20;
histfit(data, num_bins, distname);
title(sprintf("Fit of %s dist against data", distname));

for p = 1:length(PD.ParameterNames)
fprintf("parameter %s estimate: %d\n", PD.ParameterNames{p}, PD.ParameterValues(p));
end

fprintf("AICc for fit of %s distribution to data: %f\n", distname, AICc);

end