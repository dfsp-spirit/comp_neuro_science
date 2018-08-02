function cmap = change_colormap_extremes(in_colormap, num_lower, num_upper, target_color_lower, target_color_upper)
% Change the extreme colors of a color map. The exteme colors are those
% used for the minimum and maximum values.
% To invert the extreme colors of the matlab default colormap, try: cmap = change_colormap_extremes(colormap, 13, 13, [.2, .2, .2], [.8, .8, .8]);


cmap = in_colormap;
num_colors = length(cmap);

red = 1;
green = 2;
blue = 3;



%=== Fade upper part to target_color_upper  ===

last_unmodified_upper = num_colors - num_upper;
start_fade_upper =  last_unmodified_upper + 1;

first_modified_upper_color_red = cmap(start_fade_upper, red);
first_modified_upper_color_green = cmap(start_fade_upper, green);
first_modified_upper_color_blue = cmap(start_fade_upper, blue);

% Create the new colors
last_num_upper_red = linspace(first_modified_upper_color_red, target_color_upper(red), num_upper);
last_num_upper_green = linspace(first_modified_upper_color_green, target_color_upper(green), num_upper);
last_num_upper_blue = linspace(first_modified_upper_color_blue, target_color_upper(blue), num_upper);

cmap(start_fade_upper:end, red) = last_num_upper_red';
cmap(start_fade_upper:end, green) = last_num_upper_green';
cmap(start_fade_upper:end, blue) = last_num_upper_blue';

% === Fade lower part to target_color_lower ===



first_unmodified_lower = num_lower + 1;

first_red_value = cmap(first_unmodified_lower, red);
first_green_value = cmap(first_unmodified_lower, green);
first_blue_value = cmap(first_unmodified_lower, blue);

first_num_lower_red = linspace(target_color_lower(red), first_red_value, num_lower);
first_num_lower_green = linspace(target_color_lower(green), first_green_value, num_lower);
first_num_lower_blue = linspace(target_color_lower(blue), first_blue_value, num_lower);

cmap(1:num_lower, red) = first_num_lower_red';
cmap(1:num_lower, green) = first_num_lower_green';
cmap(1:num_lower, blue) = first_num_lower_blue';


