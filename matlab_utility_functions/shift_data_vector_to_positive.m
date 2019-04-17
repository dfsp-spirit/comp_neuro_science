function [shift, shifted_data] = shift_data_vector_to_positive(data)
% Shift data to positive range.

% If data is just a vector:
data_min = min(data);


if data_min <= 0
    shift = abs(data_min) + 0.1; % The additional value ensures that the data is not 0 (all data must be positive).
    fprintf("Computed min of %f, applying shift %f.\n", data_min, shift);
    shifted_data = data + shift;
else
    fprintf("Computed min of %f, not applying any shift.\n", data_min);
    shift = 0;
    shifted_data = data;
end


end