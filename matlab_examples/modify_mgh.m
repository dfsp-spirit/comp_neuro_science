%% Simple example script that reads volume data from an MGH file, modifies a value and writes the result to a new MGH file.
% Written by Tim Schäfer, 2018-04-12.
%
% This requires that the FreeSurfer matlab functions are on your Matlab
% PATH. They come with FreeSurfer and are in $FREESURFER_HOME/matlab/.
%
% (If your Matlab PATH is not setup correctly, you will get errors that MRIread
% and/or MRIwrite do not exist.)
%
% This script works on a MGH file with a single dimension (it contains vertex-wise data in stanard space).


% Read data from an existing MGH file:
mgh_file = '~/develop/brainload/tests/test_data/subject1/surf/lh.area.fwhm10.fsaverage.mgh';
data = MRIread(mgh_file);

value_index = 100001;
% Note that matlab indices start at 1 instead of 0.
% So if you read the same data in a language like Python, you may need to read from index (value_index - 1) to get the same data point.

fprintf("Original value at position %d in file '%s' is: %f\n", value_index, mgh_file, data.vol(value_index));

% Change some value in the data and save the result to a new file:
mod_vol_data = data.vol;
mod_vol_data(value_index) = 0.2;    % Overwrite old value

% Write the modified data to a new mgh file:
mgh_file_new = '~/test_file.mgh';
mod_data = data;
mod_data.vol = mod_vol_data;
MRIwrite(mod_data, mgh_file_new);
fprintf("Modified value at index %d and saved resulting data to new file '%s'.\n", value_index, mgh_file_new);

% Read the modified data back in to verify that it was written correctly:
data_re = MRIread(mgh_file_new);

new_vol_data = data_re.vol;
fprintf("Read new data file '%s'. Value at position %d is: %f\n", mgh_file_new, value_index, new_vol_data(value_index));
