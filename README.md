# comp_neuro_science

My playground for trying some computational neuroscience tools. Just ignore this, you don't want it. It's mostly Matlab.

![shape_index_of_white_on_white](./matlab_brain_curvature/shape_index_of_white_on_white.jpg?raw=true "The Shape index (SI) of the white matter surface of a human brain.")

## My Matlab utility functions

For lab members: If you are using one of my Matlab scripts and it calls a function that does not exist in your Matlab installation, chances are high that it is one of my own neuroimaging utility functions for Matlab.

They can all be found in the sub directory [./matlab_utility_functions](./matlab_utility_functions). To get them, checkout this repo in git, and add the *matlab_utility_functions* directory to your Matlab path:

    cd ~/matlab/
    git clone https://github.com/dfsp-spirit/comp_neuro_science.git
    
Now add *~/matlab/comp_neuro_science/matlab_utility_functions/* to your Matlab path:

* In the Matlab GUI: Select the **Home** tab in the upper left, then click **Set Path** in the top ribbon. In the resulting dialog, click **Add Folder** and select the directory in the file browser.
* From within a script:

    ```addpath('~/matlab/comp_neuro_science/matlab_utility_functions/')```

Should it happen again in the future, just do the following to get any new utility functions I added in the meantime:

    cd ~/matlab/
    git pull

### Dependency hell

Note that you will also need our standard Matlab packages, as my scripts use functions from them as well: 

* The Freesurfer Matlab functions (in $FREESURFER_HOME/matlab/): for loading Freesurfer format files
* [Surfstat](https://galton.uchicago.edu/faculty/InMemoriam/worsley/research/surfstat/) by Keith Worsley: for visualization and modeling
