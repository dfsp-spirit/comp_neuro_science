function [neighborhood_vertices] = mesh_neighborhood(surf_faces, source_vertices, k)
%MESH_NEIGHBORHOOD Compute trimesh neighborhood of source vertices
%   This function takes a trimesh and a set of source vertices and computes
%   all vertices which are in graph distance 1 from the given verts.
%
% --Usage Example--
% % Load surface mesh:
% [verts, faces] = read_surf("path/to/lh.white");
% % Compute all vertices in distance up to 5 for source vertices 1 and 2:
% mesh_neighborhood(faces, [1,2], 5);
%
% Written by Tim Schaefer, 2020-01-11
fprintf("Computing neighborhood in distance %d for the %d query vertices on mesh of with %d faces.\n", k, length(source_vertices), size(surf_faces,1));
neighborhood_vertices = [];
query_verts = source_vertices;
for inter_idx = 1:k
    [~, neighborhood_vertices] = mesh_verts_adjacent_faces_any(surf_faces, query_verts);
    query_verts = neighborhood_vertices;   
end
end



% Find all mesh faces which are adjacent to the query vertices.
% Returns 2 integer lists, the face indices and vertex indices.
% Uses only faces which consist *ONLY* of the query_verts (all verts have to be source verts).
function [neigh_face_indices, neigh_vertex_indices] = mesh_verts_adjacent_faces_all(faces, query_verts)
num_faces = size(faces,1);
face_is_included = zeros(num_faces,1);
for face_idx = 1:num_faces
    face_is_included(face_idx) = all(ismember(faces(face_idx,:), query_verts));
end
neigh_face_indices = find(face_is_included);
neigh_vertex_indices = unique(reshape(faces(neigh_face_indices,:),1,[]));
end


% Find all mesh faces which are adjacent to the query vertices.
% Returns 2 integer lists, the face indices and vertex indices.
% Uses all faces which contain at least ONE of the query_verts.
function [neigh_face_indices, neigh_vertex_indices] = mesh_verts_adjacent_faces_any(faces, query_verts)
num_faces = size(faces,1);
face_is_included = zeros(num_faces,1);
for face_idx = 1:num_faces
    face_is_included(face_idx) = any(ismember(faces(face_idx,:), query_verts));
end
neigh_face_indices = find(face_is_included);
neigh_vertex_indices = unique(reshape(faces(neigh_face_indices,:),1,[]));
fprintf("-Found %d verts, %d faces.\n", length(neigh_face_indices), length(neigh_vertex_indices));
end