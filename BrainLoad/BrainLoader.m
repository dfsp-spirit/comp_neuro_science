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
                       
            addRequired(p, 'measure', @ischar);
            addParameter(p, 'hemi', 'both', check_hemi);
            addParameter(p, 'surf', 'white', @ischar);
            addParameter(p, 'fwhm', '10', @ischar);
            addParameter(p, 'average_subject', 'fsaverage', @ischar);
            addParameter(p, 'subjects_file', 'subjects.txt', @ischar);
            
          
            
            % Parameters specified, now parse them:
            parse(p, measure, varargin{:})
            
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
            
            group_morphology_data = strcat(measure, 'a');
            group_meta_data = 'a';
            
        end
    end
end