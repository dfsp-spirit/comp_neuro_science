# comp_neuro_science
My playground for trying some computational neuro science tools. Just ignore this, you don't want it.


## Installation of dependencies for the scripts

As mentioned, this repo is not intended for the public. If you're lucky I left a `requirements.txt` file in the base directory of the tool you are interested in. If so, you could install anaconda (see https://conda.io/docs/user-guide/install/) and then try:

    conda create -n "MyProjectEnv" python=3.5 --file requirements.txt
	
Then use that environment to run the script.
	
If there is no ``requirements.txt` file, it's safe to assume that you will need at least numpy, scipy and mathplotlib. For everything else, you will have to check the imports in the script.
