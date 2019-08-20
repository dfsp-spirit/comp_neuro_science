function r_colormap = get_r_corrplot_colormap_nocenter()
% Generates the colormap used by GNU R for correlation plots using the 'corrplot' R package. The colormap goes from dark blue to light blue to gray, then from light red to dark red.

    c1 = [33, 102, 172] / 256;              % dark blue
    c2 = [247; 247; 247] / 256;
    c3 = [178, 25, 42] / 256;
    num_steps = 50; % Number of steps between one color and the next

    % Generate steps from c1 to c2
    mycmap=[linspace(c1(1), c2(1), num_steps); linspace(c1(2), c2(2), num_steps); linspace(c1(3), c2(3), num_steps)];

    % Generate steps from c3 to c4
    mycmap(:,end+1:end+num_steps)=[linspace(c2(1), c3(1), num_steps); linspace(c2(2), c3(2), num_steps); linspace(c2(3), c3(3), num_steps)];

    r_colormap = mycmap';
end
