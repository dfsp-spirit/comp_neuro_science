classdef CurvatureDescriptors
    % CURVATUREDESCRIPTORS Compute curvature descriptors for points on a 3D surface
    % based on their two principal curvature values.
    %
    % Usage:
    %
    %    1) Call the constructor with k1 and k2 values for your points to create an instance of the class:
    %
    %     curv_calculator = CurvatureDescriptors(k1, k2);
    %
    %    2) Call functions on the instance:
    %
    %     mean_curvature_index = curv_calculator.mean_curvature_index();
    %
    %    3) Use the return value. It is a struct with the following fields:
    %       data: the descriptor values for all the points
    %       name: string, short name of the descriptor
    %       description: string, longer description and definition of the descriptor
    %       suggested_plot_range : a suggested range of values to plot
    %
    %     desc_data = mean_curvature_index.data;
    %     fprintf('Computes mean curvature index, min value is %d.',
    %     mean(desc_data));
    %
    %    That's it.
    %
    properties
        k1     % Numerical vector of k1 values, where each k1 value represents the larger principal curvature of a point on a surface in 3D space. Def: k1 >= k2, i.e., uses signed values.
        k2     % Numerical vector of k2 values, where each k2 value represents the smaller principal curvature of the point on a surface in 3D space. Def.: k1 >= k2i.e., uses signed values.
        k_major     % Numerical vector of k_major values, where each k_major value represents the larger principal curvature of a point on a surface in 3D space. Def: k_major >= k_minori.e., uses absolute values.
        k_minor     % Numerical vector of k_minor values, where each k_minor value represents the smaller principal curvature of the point on a surface in 3D space. Def.: |k_major| >= |k_minor|, i.e., uses absolute values.
    end

    methods(Static)
        function res = get_k1_k2_kmajor_kminor(k1_raw, k2_raw)
            % The k1 and k2 raw values we receive may be ordered in different
            % ways, because different definitions exist: some sources use k1>=k2,
            % while others use |k1|>=|k2|. This functions therefor computes both
            % definitions from the input data, so we have both and can use whatever variant we
            % need for a certain measure later.
            num_k_values = length(k1_raw);
            k1 = zeros(num_k_values, 1);
            k2 = zeros(num_k_values, 1);
            k_major = zeros(num_k_values, 1);
            k_minor = zeros(num_k_values, 1);

            for idx=1:num_k_values

                % Compute the k1 and k2 values: these follow the definition k1 >= k2.
                if k1_raw(idx) >= k2_raw(idx)
                    k1(idx) = k1_raw(idx);
                    k2(idx) = k2_raw(idx);
                else
                    k1(idx) = k2_raw(idx);
                    k2(idx) = k1_raw(idx);
                end

                % Compute the k_minor and k_major values: these follow the definition |k1| >= |k2|.
                if abs(k1_raw(idx)) >= abs(k2_raw(idx))
                    k_major(idx) = k1_raw(idx);
                    k_minor(idx) = k2_raw(idx);
                else
                    k_major(idx) = k2_raw(idx);
                    k_minor(idx) = k1_raw(idx);
                end
            end
            res = struct('k1', k1, 'k2', k2, 'k_major', k_major, 'k_minor', k_minor);
        end
    end

    methods
        function obj = CurvatureDescriptors(k1, k2)
        % Constructor, supports initing k1 and k2. It does not matter
        % whether you supply them according the the definition k1 >= k2 or
        % abs(k1) >= abs(k2), the class handles this correctly in any case.
        % Note that k1 and k2 must be numeric arrays of equal length.
            if nargin ~= 2
                error('Must supply k1 and k2. They must be numeric arrays of equal length.');
            end

            if ~ isnumeric(k1)
                error('k1 value must be numeric.');
            end

            if ~ isnumeric(k2)
                error('k2 value must be numeric.');
            end

            if length(k1) ~= length(k2)
                error('k1 and k2 must have same length.');
            end

            k_values = CurvatureDescriptors.get_k1_k2_kmajor_kminor(k1, k2);
            obj.k1 = k_values.k1;
            obj.k2 = k_values.k2;
            obj.k_major = k_values.k_major;
            obj.k_minor = k_values.k_minor;
        end


        function res = principal_curvature_k1(obj)
            % Returns the principal curvature k1, i.e., the larger principal curvature: k1 | k1 >= k2.
            name = 'Principal curvature k1';
            short_name = 'principal_curvature_k1';
            description = 'the larger principal curvature: k1 | k1 >= k2';
            suggested_plot_range = [-1.1, 0.8];
            curv = obj.k1;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = principal_curvature_k2(obj)
             % Returns the principal curvature k2, i.e., the smaller principal curvature: k2 | k1 >= k2
            name = 'Principal curvature k2';
            short_name = 'principal_curvature_k2';
            description = 'the smaller principal curvature: k2 | k1 >= k2';
            suggested_plot_range = [-0.4, 0.3];
            curv = obj.k2;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = principal_curvature_k_major(obj)
            % Returns the principal curvature k_major, i.e., the larger absolute principal curvature: k_major | abs(k_major) >= abs(k_minor)
            name = 'Principal curvature k_major';
            short_name = 'principal_curvature_k_major';
            description = 'the larger absolute principal curvature: k_major | abs(k_major) >= abs(k_minor)';
            suggested_plot_range = [-1.1, 0.8];
            curv = obj.k_major;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = principal_curvature_k_minor(obj)
            % Returns the principal curvature k_minor, i.e., the smaller absolute principal curvature: k_minor | abs(k_major) >= abs(k_minor)
            name = 'Principal curvature k_minor';
            short_name = 'principal_curvature_k_minor';
            description = 'the smaller absolute principal curvature: k_minor | abs(k_major) >= abs(k_minor)';
            suggested_plot_range = [-0.4, 0.3];
            curv = obj.k_minor;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = gaussian_curvature(obj)
            % Computes the gaussian curvature: K = k_major * k_minor
            name = 'Gaussian curvature';
            short_name = 'gaussian_curvature';
            description = 'the Gaussian curvature: K = k_major * k_minor';
            suggested_plot_range = [-0.1, 0.3];
            curv = obj.k_major .* obj.k_minor;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = mean_curvature(obj)
            % Computes the mean curvature: (k_major + k_minor)/2
            name = 'Mean curvature';
            short_name = 'mean_curvature';
            description = 'the mean curvature: (k_major + k_minor)/2';
            suggested_plot_range = [-0.7, 0.5];
            curv = (obj.k_major + obj.k_minor) / 2;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = intrinsic_curvature_index(obj)
            % Computes the intrinsic curvature index: ICI = max(K, 0),
            % where K is the Gaussian curvature.
            name = 'Intrinsic curvature index';
            short_name = 'intrinsic_curvature_index';
            description = 'the intrinsic curvature index: ICI = max(K, 0), where K is the Gaussian curvature';
            suggested_plot_range = [0.0, 0.3];
            k = obj.gaussian_curvature().data;
            curv = max(0, k);
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = negative_intrinsic_curvature_index(obj)
            % Computes the intrinsic negative curvature index: NICI = min(K, 0), where K is the Gaussian curvature.
            name = 'Intrinsic negative curvature index';
            short_name = 'negative_intrinsic_curvature_index';
            description = 'the intrinsic negative curvature index: NICI = min(K, 0), where K is the Gaussian curvature';
            suggested_plot_range = [-0.1, 0.0];
            k = obj.gaussian_curvature().data;
            curv = min(0, k);
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = absolute_intrinsic_curvature_index(obj)
            % Computes the absolute intrinsic curvature index: AICI = abs(K), where K is the Gaussian curvature
            name = 'Absolute intrinsic curvature index';
            short_name = 'absolute_intrinsic_curvature_index';
            description = 'the absolute intrinsic curvature index: AICI = abs(K), where K is the Gaussian curvature';
            suggested_plot_range = [0.0, 0.2];
            k = obj.gaussian_curvature().data;
            curv = abs(k);
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = mean_curvature_index(obj)
            % Computes the mean curvature index: MCI = max(H, 0) where H is the mean curvature
            name = 'Mean curvature index';
            short_name = 'mean_curvature_index';
            description = 'the mean curvature index: MCI = max(H, 0) where H is the mean curvature';
            suggested_plot_range = [0.0, 0.5];
            h = obj.mean_curvature().data;
            curv = max(0, h);
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = negative_mean_curvature_index(obj)
             % Computes the negative mean curvature index: NMCI =  min(H, 0) where H is the mean curvature
            name = 'Negative mean curvature index';
            short_name = 'negative_mean_curvature_index';
            description = 'the negative mean curvature index: NMCI =  min(H, 0) where H is the mean curvature';
            suggested_plot_range = [-0.7, 0.0];
            h = obj.mean_curvature().data;
            curv = min(0, h);
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = absolute_mean_curvature_index(obj)
            % Computes the absolute mean curvature index: AMCI = abs(H), where H is the mean curvature
            name = 'Absolute mean curvature index (AMCI)';
            short_name = 'absolute_mean_curvature_index';
            description = 'the absolute mean curvature index: AMCI = abs(H), where H is the mean curvature';
            suggested_plot_range = [0, 0.6];
            h = obj.mean_curvature().data;
            curv = abs(h);
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = mean_l2_norm(obj)
            % Computes the mean L2 norm: MLN = H * H, where H is the mean curvature
            name = 'Mean L2 norm (MLN)';
            short_name = 'mean_l2_norm';
            description = 'the mean l2 norm: H * H, where H is the mean curvature';
            suggested_plot_range = [-0.7, 0.0];
            h = obj.mean_curvature().data;
            curv = h .* h;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = gaussian_l2_norm(obj)
            % Computes the Gaussian L2 norm: GLN = K * K, where K is the Gaussian curvature
            name = 'Gaussian L2 norm (GLN)';
            short_name = 'gaussian_l2_norm';
            description = 'the Gaussian l2 norm: GLN = K * K, where K is the Gaussian curvature';
            suggested_plot_range = [-0.7, 0.0];
            k = obj.gaussian_curvature().data;
            curv = k .* k;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = folding_index(obj)
            % Computes the folding index: FI = ABS(k_major) * (ABS(k_major) - ABS(k_minor))
            name = 'Folding index (FI)';
            short_name = 'folding_index';
            description = 'the folding index: FI = ABS(k_major) * (ABS(k_major) - ABS(k_minor))';
            suggested_plot_range = [0.0, 0.8];
            curv = abs(obj.k_major) .* (abs(obj.k_major) - abs(obj.k_minor));
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = curvedness_index(obj)
            % Computes the curvedness index: CI = SQRT((k_major * k_major + k_minor * k_minor) / 2.0)
            name = 'Curvedness index (CI)';
            short_name = 'curvedness_index';
            description = 'the curvedness index: CI = SQRT((k_major * k_major + k_minor * k_minor) / 2.0)';
            suggested_plot_range = [0.0, 0.7];
            curv = sqrt((obj.k_major .* obj.k_major + obj.k_minor .* obj.k_minor) ./ 2.0);
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = area_fraction_of_mean_curvature_index(obj)
            % Computes the area fraction of the mean curvature index: FMCI = if (H > 0) then 1, else 0
            name = 'Area fraction of the mean curvature index (FMCI)';
            short_name = 'area_fraction_of_mean_curvature_index';
            description = 'the area fraction of the mean curvature index: FMCI = if (H > 0) then 1, else 0';
            suggested_plot_range = [0, 1];
            h = obj.mean_curvature().data;
            condition_one = h > 0;
            condition_zero = h <= 0;
            curv = 1 .* condition_one + 0 .* condition_zero + h .* (~(condition_one | condition_zero));
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = area_fraction_of_negative_mean_curvature_index(obj)
            % Computes the area fraction of the negative mean curvature index: FNMCI = if (H < 0) then 1, else 0
            name = 'Area fraction of the negative mean curvature index (FNMCI)';
            short_name = 'area_fraction_of_negative_mean_curvature_index';
            description = 'the area fraction of the negative mean curvature index: FNMCI = if (H < 0) then 1, else 0';
            suggested_plot_range = [0, 1];
            h = obj.mean_curvature().data;
            condition_one = h < 0;
            condition_zero = h >= 0;
            curv = 1 .* condition_one + 0 .* condition_zero + h .* (~(condition_one | condition_zero));
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = area_fraction_of_intrinsic_curvature_index(obj)
            % Computes the area fraction of the intrinsic curvature index: FICI = if (K > 0) then 1, else 0
            name = 'Area fraction of the intrinsic curvature index (FICI)';
            short_name = 'area_fraction_of_intrinsic_curvature_index';
            description = 'the area fraction of the intrinsic curvature index: FICI = if (K > 0) then 1, else 0';
            suggested_plot_range = [0, 1];
            k = obj.gaussian_curvature().data;
            condition_one = k > 0;
            condition_zero = k <= 0;
            curv = 1 .* condition_one + 0 .* condition_zero + k .* (~(condition_one | condition_zero));
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = area_fraction_of_negative_intrinsic_curvature_index(obj)
            % Computes the area fraction of the negative intrinsic curvature index: FNICI = if (K < 0) then 1, else 0
            name = 'Area fraction of the negative intrinsic curvature index (FNICI)';
            short_name = 'area_fraction_of_negative_intrinsic_curvature_index';
            description = 'the area fraction of the negative intrinsic curvature index: FNICI = if (K < 0) then 1, else 0';
            suggested_plot_range = [0, 1];
            k = obj.gaussian_curvature().data;
            condition_one = k < 0;
            condition_zero = k >= 0;
            curv = 1 .* condition_one + 0 .* condition_zero + k .* (~(condition_one | condition_zero));
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = sh2sh(obj)
            % Computes SH2SH = MLN / AMCI = (H * H) / ABS(H), where H is the mean curvature
            name = 'SH2SH';
            short_name = 'sh2sh';
            description = 'SH2SH = MLN / AMCI = (H * H) / ABS(H), where H is the mean curvature';
            suggested_plot_range = [0.0, 0.6];
            mln = obj.mean_l2_norm().data;
            amci = obj.absolute_mean_curvature_index().data;
            curv = mln ./ amci;
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = sk2sk(obj)
            % SK2SK Computes SK2SK = GLN / AICI = (K * K ) / ABS(K), where K is the Gaussian curvature.
            name = 'SK2SK';
            short_name = 'sk2sk';
            description = 'SK2SK = GLN / AICI = (K * K ) / ABS(K), where K is the Gaussian curvature';
            gln = obj.gaussian_l2_norm().data;
            aici = obj.absolute_intrinsic_curvature_index().data;
            curv = gln ./ aici;
            %suggested_plot_range = [0.0, 0.2];
            suggested_plot_range = obj.find_plot_range(curv, 30, 30);
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = shape_index(obj)
            % Computes the shape index: SI = (2.0 / PI) * ATAN((k1 + k2) / (k2 - k1)). See Surface shape and curvatures
            % scales, Jan j Koenderink and Andrea J van Doorn, 1992.
            name = 'Shape index (SI)';
            short_name = 'shape_index';
            description = 'the shape index: SI = (2.0 / PI) * ATAN((k1 + k2) / (k2 - k1))';
            suggested_plot_range = [-1.0, 1.0];
            curv = (2.0 / pi) * atan((obj.k1 + obj.k2) ./ (obj.k2 - obj.k1));
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function res = shape_type(obj)
            % Computes the shape type (based on the shape index). See Brain
            % Struct Funct (2013) 218:1451–1462 by Hu et al.
            name = 'Shape type';
            short_name = 'shape_type';
            description = 'the shape type: 1 for -1<=SI<-0.5, 2 for -0.5<=SI<-0, 3 for 0<=SI<0.5, and 4 for 0.5<=SI<1';
            suggested_plot_range = [1, 4];
            si = obj.shape_index().data;
            curv = zeros(1, length(si));
            num_out_of_range = 0;
            border1 = -1.0;
            border2 = -0.5;
            border3 = 0.0;
            border4 = 0.5;
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
                fprintf('WARNING: CurvatureDescriptors.shape_type: Received %d shape index values that were out of range.', num_out_of_range);
            end
            res = struct('data', curv, 'name', name, 'description', description, 'short_name', short_name, 'suggested_plot_range', suggested_plot_range);
        end


        function range = find_plot_range(~, data, cut_low, cut_high)
            % Determines the range of values to plot, based on removing the specified percentiles cut_low and cut_high from the (lower and upper) part of the data.
            % If you want to cut only from one side, just set the other cut
            % value to zero.
            lower_bound = 0 + cut_low;
            upper_bound = 100 - cut_high;
            removed_threshold_small = prctile(data, lower_bound);
            removed_threshold_large = prctile(data, upper_bound);
            mfilter = removed_threshold_small > data | removed_threshold_large < data;
            data_filtered = data;
            data_filtered(mfilter) = NaN;
            lowest_value_to_plot = nanmin(data_filtered);
            highest_value_to_plot = nanmax(data_filtered);
            range = [lowest_value_to_plot, highest_value_to_plot];
        end

        function res = compute_all(obj)
            % Convenience function that computes all folding measures and
            % returns them as a map. The keys are the short_name properties
            % of the individual functions, the values are the respective
            % result structs returned by the functions.
            res = containers.Map;
            res('absolute_mean_curvature_index') = obj.absolute_mean_curvature_index();
            res('principal_curvature_k1') = obj.principal_curvature_k1();
            res('principal_curvature_k2') = obj.principal_curvature_k2();
            res('principal_curvature_k_major') = obj.principal_curvature_k_major();
            res('principal_curvature_k_minor') = obj.principal_curvature_k_minor();
            res('mean_curvature') = obj.mean_curvature();
            res('gaussian_curvature') = obj.gaussian_curvature();
            res('intrinsic_curvature_index') = obj.intrinsic_curvature_index();
            res('negative_intrinsic_curvature_index') = obj.negative_intrinsic_curvature_index();
            res('gaussian_l2_norm') = obj.gaussian_l2_norm();
            res('absolute_intrinsic_curvature_index') = obj.absolute_intrinsic_curvature_index();
            res('mean_curvature_index') = obj.mean_curvature_index();
            res('negative_mean_curvature_index') = obj.negative_mean_curvature_index();
            res('mean_l2_norm') = obj.mean_l2_norm();
            res('absolute_mean_curvature_index') = obj.absolute_mean_curvature_index();
            res('folding_index') = obj.folding_index();
            res('curvedness_index') = obj.curvedness_index();
            res('shape_index') = obj.shape_index();
            res('shape_type') = obj.shape_type();
            res('area_fraction_of_intrinsic_curvature_index') = obj.area_fraction_of_intrinsic_curvature_index();
            res('area_fraction_of_negative_intrinsic_curvature_index') = obj.area_fraction_of_negative_intrinsic_curvature_index();
            res('area_fraction_of_mean_curvature_index') = obj.area_fraction_of_mean_curvature_index();
            res('area_fraction_of_negative_mean_curvature_index') = obj.area_fraction_of_negative_mean_curvature_index();
            res('sh2sh') = curv_calculator.sh2sh();
            res('sk2sk') = curv_calculator.sk2sk();
        end

    end
end
