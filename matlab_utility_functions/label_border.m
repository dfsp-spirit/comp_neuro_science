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
%     its x, y, and z coords.
%
%   surf_faces: integer matrix of size (m, 3) for m faces. The faces of a brain surface (tri-)mesh, as returned by the
%     FreeSurfer Matlab function `read_surf`. Each row defines a face by
%     the three vertex indices.
%
%   label_vert_indices: integer vector, the vertex indices of the label.
%      Must be valid indices into the surf_verts. This function only makes
%      sense if the vertices form a contiguous patch on the surface, but
%      that is not checked and up to the user.
%
% . Return Value: integer vector, the indices of the border vertices.
%    
outputArg1 = inputArg1;
borderVertices = inputArg2;
end

