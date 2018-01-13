# comp_neuro_science
My playground for trying some computational neuro science tools. Just ignore this, you don't want it.


## Installation of dependencies for the scripts

As mentioned, this repo is not intended for the public. If you're lucky I left a `environment.yml` file in the base directory of the tool you are interested in. If so, you could install anaconda (see https://conda.io/docs/user-guide/install/) and then use that file to reproduce the required environment:

    conda env create -f environment.yml

You should then see the new environment in your environments list, check `conda env list`. Make sure you activate the new environment (called `comp_neuro_science` here) before running the python script:

    source activate comp_neuro_science
    python some_script.py
    source deactivate
	
If there is no `environment.yml` file, it's safe to assume that you will need at least numpy, scipy and mathplotlib. For everything else, you will have to check the imports in the script.
