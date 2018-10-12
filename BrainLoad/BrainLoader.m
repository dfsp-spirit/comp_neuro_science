classdef BrainLoader
    % BRAINLOADER Load FreeSurfer brain data.
    %
    % Copyright Tim Schäfer, 2018
    % Requires SurfStat for the file loading and plotting functions.
    %
    properties (Constant)
        debug = 1;
    end
    
    methods(Static)
        function [group_morphology_data, group_meta_data] = load_group_data(measure, varargin)
            %% Parse command line arguments
            
            p = inputParser;
            
            % Specify available command line parameters and values
            
            check_hemi = @(x) any(validatestring(x, {'lh','rh', 'both'}));
            default_subjects_dir = BrainLoader.get_env_or_default('SUBJECTS_DIR', '.');
            
            default_arg_empty_string = '';
                       
            addRequired(p, 'measure', @ischar);
            addParameter(p, 'hemi', 'both', check_hemi);
            addParameter(p, 'surf', 'white', @ischar);
            addParameter(p, 'fwhm', '10', @ischar);
            addParameter(p, 'average_subject', 'fsaverage', @ischar);
            addParameter(p, 'subjects_file', 'subjects.txt', @ischar);
            addParameter(p, 'subjects_dir', default_subjects_dir, @ischar);
            addParameter(p, 'subjects_file_dir', default_arg_empty_string, @ischar);
            
          
            
            % Parameters specified, now parse them:
            parse(p, measure, varargin{:})
            
            % Report
            if BrainLoader.debug == 1
                disp(['measure: ',p.Results.measure])
                            
                if ~isempty(fieldnames(p.Unmatched))
                    disp('Extra inputs:')
                    disp(p.Unmatched)
                end
                
                if ~isempty(p.UsingDefaults)
                    disp('Using defaults: ')
                    disp(p.UsingDefaults)
                end
            end
            
            % Based on the parameters we received, setup data.
            subjects_dir = p.Results.subjects_dir;
            
            if strcmp(p.Results.subjects_file_dir, default_arg_empty_string)
                subjects_file_dir = subjects_dir;     % If the directory was not supplied by the user, assume the file is in the subject_dir.
            else
                subjects_file_dir = p.Results.subjects_file_dir;
            end
            
            % Report again.
            if BrainLoader.debug == 1
                disp(['subjects_dir: ', subjects_dir])
                disp(['subjects_file_dir: ', subjects_file_dir]);
            end
            
            
            group_morphology_data = strcat(measure, 'a');
            group_meta_data = 'a';
            
        end
        
        % Retrieves an env var, or the default value if it is not set.
        function value = get_env_or_default(env_var, default_value)
            value = getenv(env_var);
            if strlength(value) == 0
                value = default_value;
            end
        end
        
    end
end