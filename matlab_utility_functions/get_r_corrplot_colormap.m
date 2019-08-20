function r_colormap = get_r_corrplot_colormap()
% Generates the colormap used by GNU R for correlation plots using the 'corrplot' R package. The colormap goes from dark blue to light blue to gray, then from light red to dark red.

    c1 = [33, 102, 172] / 256;              % dark blue
    c2 = [217, 233, 241] / 256;     % light_blue
    c3 = [252, 225, 208] / 256;      % light_red
    c4 = [178, 25, 42] / 256;         % dark_red
    c_center = [0.8; 0.8; 0.8]; %set middle value to grey

    num_steps = 50; % Number of steps between one color and the next

    % Generate steps from c1 to c2
    mycmap=[linspace(c1(1), c2(1), num_steps); linspace(c1(2), c2(2), num_steps); linspace(c1(3), c2(3), num_steps)];

    % Add center color
    mycmap(:,end+1) = c_center;

    % Generate steps from c3 to c4
    mycmap(:,end+1:end+n)=[linspace(c3(1), c4(1), num_steps); linspace(c3(2), c4(2), num_steps); linspace(c3(3), c4(3), num_steps)];

    r_colormap = mycmap';
end
