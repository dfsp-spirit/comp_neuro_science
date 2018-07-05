The script `plot_morphometry.py` was downloaded by Tim from the pysurfer website.

To get pysurfer to run it, I did the following under Ubuntu 18.04:

    sudo apt-get install python-pip
    pip install numpy scipy ipython nibabel matplotlib mayavi pysurfer

This should do it for the installation of the software, now run the script to verify it works:

    chmod +x plot_morphometry.py
    python ./plot_morphometry.py

Hope that helps.
