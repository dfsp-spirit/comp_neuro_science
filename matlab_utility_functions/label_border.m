function [borderVertices] = label_border(surf_verts, surf_faces, label_vert_indices)
%label_border Compute border of a FreeSurfer label
%   This function takes a label (i.e., a set of adjacent vertices) on a
%   brain surface mesh and computes the subset of the vertices which form
%   the label border.
%   This is useful for visualizing the outline of the label.
%
%   Parameters:
%   
%   surf_verts: float matrix of size (n, 3) for n vertices. The vertices of a brain surface (tri-)mesh, as returned by the
%     FreeSurfer Matlab function `read_surf`. Each row defines a vertex by
%     its x, y, and z coords. Typically, this is the fsaverage white
%     surface.
%
%   surf_faces: integer matrix of size (m, 3) for m faces. The faces of a brain surface (tri-)mesh, as returned by the
%     FreeSurfer Matlab function `read_surf`. Each row defines a face by
%     the three vertex indices. Typically, this is the fsaverage white
%     surface.
%
%   label_vert_indices: integer vector, the vertex indices of the label.
%      Must be valid indices into the surf_verts. This function only makes
%      sense if the vertices form a contiguous patch on the surface, but
%      that is not checked and up to the user. Typically, this is a cluster
%      defined on the fsaverage surface.
%
% . Return Value: integer vector, the indices of the border vertices.
%
% Example:
%  [verts, faces] = read_surf("~/data/bert_only/bert/surf/lh.white");
%
%  setenv("SUBJECTS_DIR", "~/data/bert_only");
%  [lbl] = read_label("bert", "lh.bankssts");
%
%  lb = label_border(verts, faces, lbl);
%    
label_faces = mesh_verts_included_faces(surf_faces, label_vert_indices);
fprintf("Surface consists of %d vertices and %d faces.\n", size(surf_verts, 1), size(surf_faces,1))
fprintf("Found %d label faces which are made up of the %d label vertices.\n", length(label_faces), length(label_vert_indices));
borderVertices = [1,2,3];
end


% Find all mesh faces which are made up completely of the query vertices.
% Returns an integer list, the face indices.
function [face_indices] = mesh_verts_included_faces(faces, query_verts)
num_faces = size(faces,1);
face_is_included = zeros(num_faces,1);
for face_idx = 1:size(faces,1)
    face_is_included(face_idx) = all(ismember(faces(face_idx,:), query_verts));
end
face_indices = find(face_is_included);
end