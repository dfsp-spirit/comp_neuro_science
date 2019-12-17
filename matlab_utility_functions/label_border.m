function [border_vertices, border_edges, border_faces] = label_border(surf_verts, surf_faces, label_vert_indices)
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
%   Return Values: 
%   
%   border_vertices: integer vector, the indices of the border vertices.
%   I.e., these are indices into surf_verts.
%
%   border_edges: integer matrix of size (n,2) for n edges. Each row
%   defined an edge by the indices of its start and end vertices.
%
%   border_faces: integer vector, the indices of the border faces. I.e.,
%   these are indices into surf_faces.
%
%   Example:
%  [verts, faces] = read_surf("~/data/bert_only/bert/surf/lh.white");
%
%  setenv("SUBJECTS_DIR", "~/data/bert_only");
%  [lbl] = read_label("bert", "lh.bankssts");
%
%  lb = label_border(verts, faces, lbl);
%    
%
%  Written by Tim Schaefer, 2019-12-17
%   

fprintf("Surface consists of %d vertices and %d faces.\n", size(surf_verts, 1), size(surf_faces,1));

% Compute all faces consisting ONLY of label vertices
label_faces = mesh_verts_included_faces(surf_faces, label_vert_indices);

% Compute all edges consisting ONLY of label vertices
label_edges = get_face_edges(surf_faces, label_faces);
fprintf("Found %d label faces and %d label edges based on the %d label vertices.\n", length(label_faces), size(label_edges,1), length(label_vert_indices));

 % Sort source and target vertices of edges, to be able to properly count (u, v) and (v, u) as 2 occurrences of the same edge later.
sorted_edges = sort(label_edges, 2); 

 % Identify the unique edges (sorted, so (u, v) and (v, u) will be counted as the same edge).
[unique_edges,~,ic] = unique(sorted_edges, 'rows'); 

% Count how often each unique edge occurs.
unique_edge_num_occurrences = accumarray(ic, 1);    

% Merge unique edges and their counts. Each row contains 3 int values: edge_start, end_end (with edge_start < edge_end), and count. 
unique_edge_counts = [unique_edges unique_edge_num_occurrences];

% Compute border edges. Border edges are unique edges that occur only once over all faces. 
% That is because the second face adjacent to the respective border edge is not part of the label.
border_edges = unique_edge_counts(unique_edge_counts(:,3)==1,1:2);

% Compute the border vertices from the border edges.
border_vertices = unique(reshape(border_edges,1,[]));

% Compute the border faces from the vertices. Vertices and edges alone are
% not great for visualizing something on a mesh, coloring the whole face
% looks way better.
border_faces = mesh_verts_included_faces(surf_faces, border_vertices);
fprintf("Computed border consisting of %d vertices, %d edges and %d faces.\n", length(border_vertices), size(border_edges,1), length(border_faces));
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


% Find all edges of all the given faces in the mesh.
% Returns a 2D matrix of size (n,2) for n edges. Each row contains two integer
% values, which are the vertex indices of the source and the target vertex of
% the respective edge.
% Note that edges may occur several times in the result if part of multiple
% faces. Also, they can (and will) be in
% arbitrary order for the source and target vertices defining
% an edge, i.e., they are not sorted with the rows.
function [face_edges] = get_face_edges(surface_faces, query_face_indices)
    e1 = surface_faces(query_face_indices, 1:2);
    e2 = surface_faces(query_face_indices, 2:3);
    e3 = surface_faces(query_face_indices, [3,1]);
    face_edges = [e1; e2; e3];
end
