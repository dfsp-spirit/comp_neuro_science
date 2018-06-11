classdef CurvatureDescriptors
    properties
        k1     % Numerical vector of k1 values, where each k1 value represents the larger principal curvature of a point on a surface in 3D space.
        k2     % Numerical vector of k2 values, where each k2 value represents the smaller principal curvature of the point on a surface in 3D space.
    end
    methods
        % Constructor, supports initing k1 and k2. Does not check whether
        % k1 and k2 have equal length, but that must obviously be the
        % case.
        function obj = CurvatureDescriptors(k1, k2)
            if nargin > 0
                if isnumeric(k1)
                    obj.k1 = k1;
                else
                    error('k1 value must be numeric.')
                end
            end
            if nargin > 1
                if isnumeric(k2)
                    obj.k2 = k2;
                else
                    error('k2 value must be numeric.')
                end
            end
        end

        % Returns the principal curvature k1.
        function res = principal_curvature_k1(obj)
            name = 'Principal curvature k1';
            description = 'the larger principal curvature: k1';
            suggested_plot_range = [-1.1, 0.8];
            curv = obj.k1;
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Returns the principal curvature k2.
        function res = principal_curvature_k2(obj)
            name = 'Principal curvature k2';
            description = 'the smaller principal curvature: k2';
            suggested_plot_range = [-0.4, 0.3];
            curv = obj.k2;
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the gaussian curvature.
        function res = gaussian_curvature(obj)
            name = 'Gaussian curvature';
            description = 'the Gaussian curvature: K = k1 * k2';
            suggested_plot_range = [-0.1, 0.3];
            curv = obj.k1 .* obj.k2;
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the mean curvature.
        function res = mean_curvature(obj)
            name = 'Mean curvature';
            description = 'the mean curvature: (k1+k2)/2';
            suggested_plot_range = [-0.7, 0.5];
            curv = (obj.k1 + obj.k2) / 2;
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the intrinsic curvature index.
        function res = intrinsic_curvature_index(obj)
            name = 'Intrinsic curvature index';
            description = 'the intrinsic curvature index: ICI = max(K, 0), where K is the Gaussian curvature';
            suggested_plot_range = [0.0, 0.3];
            k = obj.gaussian_curvature().data;
            curv = max(0, k);
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the intrinsic negative curvature index.
        function res = negative_intrinsic_curvature_index(obj)
            name = 'Intrinsic negative curvature index';
            description = 'the intrinsic negative curvature index: NICI = min(K, 0), where K is the Gaussian curvature';
            suggested_plot_range = [-0.1, 0.0];
            k = obj.gaussian_curvature().data;
            curv = min(0, k);
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the absolute intrinsic curvature index.
        function res = absolute_intrinsic_curvature_index(obj)
            name = 'Absolute intrinsic curvature index';
            description = 'the absolute intrinsic curvature index: AICI = abs(K), where K is the Gaussian curvature';
            suggested_plot_range = [0.0, 0.2];
            k = obj.gaussian_curvature().data;
            curv = abs(k);
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the mean curvature index.
        function res = mean_curvature_index(obj)
            name = 'Mean curvature index';
            description = 'the mean curvature index: MCI = max(H, 0) where H is the mean curvature';
            suggested_plot_range = [-0.5, 0.5];
            h = obj.mean_curvature().data;
            curv = max(0, h);
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the negative mean curvature index.
        function res = negative_mean_curvature_index(obj)
            name = 'Negative mean curvature index';
            description = 'the negative mean curvature index: NMCI =  min(H, 0) where H is the mean curvature';
            suggested_plot_range = [-0.7, 0.0];
            h = obj.mean_curvature().data;
            curv = min(0, h);
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the absolute mean curvature index.
        function res = absolute_mean_curvature_index(obj)
            name = 'Absolute mean curvature index (AMCI)';
            description = 'the absolute mean curvature index: AMCI = abs(H), where H is the mean curvature';
            suggested_plot_range = [0, 0.6];
            h = obj.mean_curvature().data;
            curv = abs(h);
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the mean L2 norm.
        function res = mean_l2_norm(obj)
            name = 'Mean L2 norm (MLN)';
            description = 'the mean l2 norm: H * H, where H is the mean curvature';
            suggested_plot_range = [-0.7, 0.0];
            h = obj.mean_curvature().data;
            curv = h .* h;
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the Gaussian L2 norm.
        function res = gaussian_l2_norm(obj)
            name = 'Gaussian L2 norm (GLN)';
            description = 'the Gaussian l2 norm: K * K, where K is the Gaussian curvature';
            suggested_plot_range = [-0.7, 0.0];
            k = obj.gaussian_curvature().data;
            curv = k .* k;
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the folding index.
        function res = folding_index(obj)
            name = 'Folding index (FI)';
            description = 'the folding index: ABS(K1) * (ABS(K1) - ABS(K2))';
            suggested_plot_range = [0.0, 0.8];
            curv = abs(obj.k1) .* (abs(obj.k2) - abs(obj.k2));
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the curvedness index.
        function res = curvedness_index(obj)
            name = 'Curvedness index (CI)';
            description = 'the curvedness index: SQRT((k1*k1 + k2*k2) / 2.0)';
            suggested_plot_range = [0.0, 0.7];
            curv = sqrt((obj.k1 .* obj.k1 + obj.k2 .* obj.k2) ./ 2.0);
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the area fraction of the mean curvature index
        function res = area_fraction_of_mean_curvature_index(obj)
            name = 'Area fraction of the mean curvature index (FMCI)';
            description = 'the area fraction of the mean curvature index: if (H > 0) then 1, else 0';
            suggested_plot_range = [0, 1];
            h = obj.mean_curvature().data;
            condition_one = h > 0;
            condition_zero = h <= 0;
            curv = 1 .* condition_one + 0 .* condition_zero + h .* (~(condition_one | condition_zero));
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the area fraction of the negative mean curvature index
        function res = area_fraction_of_negative_mean_curvature_index(obj)
            name = 'Area fraction of the negative mean curvature index (FNMCI)';
            description = 'the area fraction of the negative mean curvature index: if (H < 0) then 1, else 0';
            suggested_plot_range = [0, 1];
            h = obj.mean_curvature().data;
            condition_one = h < 0;
            condition_zero = h >= 0;
            curv = 1 .* condition_one + 0 .* condition_zero + h .* (~(condition_one | condition_zero));
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the area fraction of the intrinsic curvature index
        function res = area_fraction_of_intrinsic_curvature_index(obj)
            name = 'Area fraction of the intrinsic curvature index (FICI)';
            description = 'the area fraction of the intrinsic curvature index: if (K > 0) then 1, else 0';
            suggested_plot_range = [0, 1];
            k = obj.gaussian_curvature().data;
            condition_one = k > 0;
            condition_zero = k <= 0;
            curv = 1 .* condition_one + 0 .* condition_zero + k .* (~(condition_one | condition_zero));
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the area fraction of the negative intrinsic curvature index
        function res = area_fraction_of_negative_intrinsic_curvature_index(obj)
            name = 'Area fraction of the negative intrinsic curvature index (FNICI)';
            description = 'the area fraction of the negative intrinsic curvature index: if (K < 0) then 1, else 0';
            suggested_plot_range = [0, 1];
            k = obj.gaussian_curvature().data;
            condition_one = k < 0;
            condition_zero = k >= 0;
            curv = 1 .* condition_one + 0 .* condition_zero + k .* (~(condition_one | condition_zero));
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes SH2SH
        function res = sh2sh(obj)
            name = 'SH2SH';
            description = 'SH2SH = MLN / AMCI = (H * H) / ABS(H), where H is the mean curvature';
            suggested_plot_range = [0.0, 0.6];
            mln = obj.mean_l2_norm().data;
            amci = obj.absolute_mean_curvature_index().data;
            curv = mln ./ amci;
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes SK2SK
        function res = sk2sk(obj)
            name = 'SK2SK';
            description = 'SK2SK = GLN / AICI = (K * K ) / ABS(K), where K is the Gaussian curvature';
            suggested_plot_range = [0.0, 0.2];
            gln = obj.gaussian_l2_norm().data;
            aici = obj.absolute_intrinsic_curvature_index().data;
            curv = gln ./ aici;
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the shape index
        function res = shape_index(obj)
            name = 'Shape index (SI)';
            description = 'the shape index: SI = (2.0 / PI) * ATAN((k1 + k2) / (k2 - k1))';
            suggested_plot_range = [0.0, 1.0];
            curv = (2.0 / pi) * atan((obj.k1 + obj.k2) ./ (obj.k2 - obj.k1));
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end

        % Computes the shape type (based on the shape index). See Brain
        % Struct Funct (2013) 218:1451–1462 by Hu et al.
        function res = shape_type(obj)
            name = 'Shape type';
            description = 'the shape type: 1 for -1<=SI<-0.5, 2 for -0.5<=SI<-0, 3 for 0<=SI<0.5, and 4 for 0.5<=SI<1';
            suggested_plot_range = [1, 4];
            si = obj.shape_index().data;
            curv = zeros(1, length(si));
            num_out_of_range = 0;
            %border1 = -1.0;
            %border2 = -0.5;
            %border3 = 0.0;
            %border4 = 0.5;
            %border5 = 1.0;
            border1 = 0.0;
            border2 = 0.25;
            border3 = 0.5;
            border4 = 0.75;
            border5 = 1.0;
            for idx = 1:length(si)
                val = si(idx);
                if val >= border1 && val < border2
                    curv(idx)=1;
                elseif val >= border2 && val < border3
                    curv(idx)=2;
                elseif val >= border3 && val < border4
                    curv(idx)=3;
                elseif val >= border4 && val <= border5
                    curv(idx)=4;
                else
                    num_out_of_range = num_out_of_range + 1;
                    curv(idx)=0;
                end
            end
            if num_out_of_range > 0
                msg = sprintf('WARNING: CurvatureDescriptors.shape_type: Received %d shape index values that were out of range.', num_out_of_range);
                disp(msg);
            end
            res = struct('data', curv, 'name', name, 'description', description, 'suggested_plot_range', suggested_plot_range);
        end



    end
end
