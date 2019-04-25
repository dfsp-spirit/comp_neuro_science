

% Generate mesh grid
x = -1:0.1:1;y = x;
[X,Y] = meshgrid(x,y);

% Define surface shape using k1 and k2
k1 = 1;
k2 = -2;

% Set Z value of grid
Z = 0.5*(k1*X.^2 + k2*Y.^2);

% Plot shape (colormap indicates simply elavation, i.e., the Z value)
figure;surf(X,Y,Z);

% Compute Mean (H) and Gaussian (K) curvatures
[H, K] = get_curvatures(X,Y,Z);


% Plot figures with colormap representing curvature
figure;surf(X,Y,Z,H);
title("Mean curvature");

figure;surf(X,Y,Z,K);
title("Gaussian curvature");

% Function by Ahmed Elnaggar, https://www.mathworks.com/matlabcentral/fileexchange/5229-gaussian-curvature
function [H, K] = get_curvatures(X,Y,Z)
[Xu,Xv] = gradient(X); [Yu,Yv] = gradient(Y); [Zu,Zv] = gradient(Z);
% Second Derivatives
[Xuu,Xuv] = gradient(Xu); [Yuu,Yuv] = gradient(Yu); [Zuu,Zuv] = gradient(Zu);
[Xuv,Xvv] = gradient(Xv); [Yuv,Yvv] = gradient(Yv); [Zuv,Zvv] = gradient(Zv);
% Initialize Gaussian and mean curvature
K = zeros(size(Z));
H = zeros(size(Z));
% Calculate both Gaussian and mean curvature
for i=1:size(Z,1)
    for j=1:size(Z,2)
        % assign vector values that we are going to work on
        r_u = [Xu(i,j) Yu(i,j) Zu(i,j)];
        r_v = [Xv(i,j) Yv(i,j) Zv(i,j)];
        r_uu = [Xuu(i,j) Yuu(i,j) Zuu(i,j)];
        r_uv = [Xuv(i,j) Yuv(i,j) Zuv(i,j)];
        r_vv = [Xvv(i,j) Yvv(i,j) Zvv(i,j)];
        % First fundamental Coeffecients of the surface (E,F,G)
        E = dot(r_u, r_u);
        F = dot(r_u, r_v);
        G = dot(r_v, r_v);
        % Calculate the unite normal vector (the perpendicular vector for
        % both of these vectors)
        m = cross(r_u,r_v,2);
        n = m./sqrt(dot(m,m,2));
        % Second fundamental Coeffecients of the surface (L,M,N)
        L = dot(r_uu,n);
        M = dot(r_uv,n);
        N = dot(r_vv,n);
        % Gaussian Curvature
        K(i,j) = (L.*N - M.^2)./(E.*G - F.^2);
        % Mean Curvature
        H(i,j) = (E.*N + G.*L - 2.*F.*M)./(2*(E.*G - F.^2));
    end
end
end
