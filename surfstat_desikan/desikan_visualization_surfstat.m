% Feel free to replace this with your data, or use the 'bert' example subject that comes with FreeSurfer in $FREESURFER_HOME/subjects/bert/.
subjects_dir = '~/data/tim_only/';
subject_id = 'tim';

aparc_file_lh = fullfile(subjects_dir, subject_id, 'label', "lh.aparc.annot");
aparc_file_rh = fullfile(subjects_dir, subject_id, 'label', "rh.aparc.annot");

% Note: read_annotation is a Matlab function that comes with FreeSurfer in $FREESURFER_HOME/matlab/.
[vertices_lh, data_lh, colortable_lh] = read_annotation(aparc_file_lh);
[vertices_rh, data_rh, colortable_rh] = read_annotation(aparc_file_rh);



[~,idx] = sort(colortable_lh.table(:, 5)); % sort based on 5th column
sortedmat = colortable_lh.table(idx, :);

num_regions = size(sortedmat, 1);
colmap = sortedmat(:, 1:3) ./ 255;   % RGB color values are columns 1:3. They are in range 0:255 though, and we need 0:1.


% The values are the codes so far. Map them to 1..36 instead.
for vidx = 1:num_regions
    data_lh(data_lh==sortedmat(vidx, 5)) = vidx;
    data_rh(data_rh==sortedmat(vidx, 5)) = vidx;
end

plot_data_onto_subject(subject_id, subjects_dir, data_lh, data_rh, colmap, 'white');
