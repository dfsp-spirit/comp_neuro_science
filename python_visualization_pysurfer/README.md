The script `plot_morphometry.py` was downloaded by Tim from the pysurfer website. This README explains how to install PySurfer and run the script successfully, as a demonstration that the installation worked.


== Setup your machine to be able to run PySurfer==

I did this under Ubuntu 18.04. Make sure you have FreeSurfer installed and working, including correct setup of the SUBJECTS_DIR environment variable (make it point to $FREESURFER_HOME/subjects for this script).


===Installation into an environment using conda===

- download and install anaconda from https://www.anaconda.com/download/
- create an environment based on the `environment.yml` file in this directory: `conda env create`
- then activate the environment, it is named `pysurfer`. (Activation depends on your platform, try `conda activate pysurfer` or `source activate pysurfer`.)
- with the environment active (displayed as prefix in the shell prompt), run the `plot_morphometry.py` test script as explained below.

===Installation using the system python and pip===

I did not get this to run under Ubuntu 18.04. According to the manual of PYSurfer, this should work (but it did not for me):

        sudo apt-get install python-pip
        pip install numpy scipy ipython nibabel matplotlib mayavi imageio pysurfer

==Run the script to ensure it worked out==

This should do it for the installation of the software, now run the script to verify it works:

    chmod +x plot_morphometry.py
    python ./plot_morphometry.py

==Matplotlib backend setup===

Note that you may need to configure matplotlib to use some backend that exists on your machine. What I dit was to add the line `backend: tkAgg` to the file `~/.config/matplotlib/matplotlibrc` under Linux. You can test whether it works by running the following command:

    python -c "from pylab import *; plot(); show();" --verbose-helpful

Do not omit the last part, otherwise no error message is displayed if something goes wrong.
