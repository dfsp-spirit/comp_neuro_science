subjects_dir = '~/data/tim_only/';
subject_id = 'tim';

aparc_file_lh = fullfile(subjects_dir, subject_id, 'label', "lh.aparc.annot");
aparc_file_rh = fullfile(subjects_dir, subject_id, 'label', "rh.aparc.annot");

[vertices_lh, label_lh, colortable_lh] = read_annotation(aparc_file_lh);
[vertices_rh, label_rh, colortable_rh] = read_annotation(aparc_file_rh);

fprintf("Read aparc parcellation file '%s' containing %d regions.\n", aparc_file_lh, length(colortable_lh.struct_names));

for sidx = 1:length(colortable_lh.struct_names)
    region = colortable_lh.struct_names{sidx};
    struct_code = colortable_lh.table(sidx, 5);
    lh_vertices_of_struct_roi = find(label_lh == struct_code);
    rh_vertices_of_struct_roi = find(label_rh == struct_code);
    fprintf("Found region '%s' with code %d. Has %d verts in left hemi and %d in right hemi.\n", region, struct_code, length(lh_vertices_of_struct_roi), length(rh_vertices_of_struct_roi));
end



data_lh = label_lh;
data_rh = label_rh;
%colmap = colortable_lh.table(:, 1:3) ./ 255;

[~,idx] = sort(colortable_lh.table(:,5)); % sort based on 5th column
sortedmat = colortable_lh.table(idx,:);

num_regions = size(sortedmat, 1);

sortedmat(:,6) = 1:num_regions;
colmap = sortedmat(:, 1:3) ./ 255;   % RGB color values are columns 1:3. They are in range 0:255 though, and we need 0:1.


% The values are the codes so far. Map them to 1..36 instead.
for vidx = 1:num_regions
    code_val = sortedmat(vidx, 5);
    target_val = sortedmat(vidx, 6);
    data_lh(data_lh==code_val) = target_val;
    data_rh(data_rh==code_val) = target_val;
end

plot_data_onto_subject(subject_id, subjects_dir, data_lh, data_rh, colmap, 'white');