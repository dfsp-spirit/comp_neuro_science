## Brain curvature descriptors

Implementation of various curvature descriptors for a point on a 3D surface, based on the two principal curvatures `k1` and `k2`. The implementation assumes you already have k1 and k2 values for each point on the surface. The implementation is in the `CurvatureDescriptors.m` file.

This is a Matlab implementation that follows the definitions given in Table 1 of the following publication: `Shimony, J. S., Smyser, C. D., Wideman, G., Alexopoulos, D., Hill, J., Harwell, J., ... & Neil, J. J. (2016). Comparison of cortical folding measures for evaluation of developing human brain. Neuroimage, 125, 780-790.` For a quick online overview with some illustrations, you can also check http://brainvis.wustl.edu/wiki/index.php/Folding/Measurements.

The measures themselves originate from the latter and various other publications, including `Rodriguez-Carranza et al. (2008)`, `Koenderink and van Doorn (1992)`, `Van Essen and Drury (1997)`, and `Batchelor et al. (2002)`.

### Usage

    % Assuming k1 and k2 are the vectors containing the two principal curvatures for the points. Create instance:
    curv_calculator = CurvatureDescriptors(k1, k2);

    % ...and then have it compute the descriptors you want:
    mean_curvature = curv_calculator.mean_curvature();
    gaussian_curvature = curv_calculator.gaussian_curvature();
    intrinsic_curvature_index = curv_calculator.intrinsic_curvature_index();
    ...

Note that the return value of all these functions in a struct that contains the following fields:

* data: the vector of computed descriptor values
* name: string, name of the descriptor (e.g., 'Gaussian curvature')
* description: string, description of the descriptor (e.g., 'the Gaussian curvature: K = k1 * k2')
* suggested_plot_range: a suggested range of the values to plot (e.g., [-0.1, 0.3]).

See the source code of a descriptor function in `CurvatureDescriptors.m` for more details, e.g., the function `gaussian_curvature`.


### Implemented descriptors

The following descriptors are available:

* principal_curvature_k1
* principal_curvature_k2
* principal_curvature_k_major
* principal_curvature_k_minor
* mean_curvature
* gaussian_curvature
* intrinsic_curvature_index
* negative_intrinsic_curvature_index
* gaussian_l2_norm
* absolute_intrinsic_curvature_index
* mean_curvature_index
* negative_mean_curvature_index
* mean_l2_norm
* absolute_mean_curvature_index
* folding_index
* curvedness_index
* shape_index
* shape_type
* area_fraction_of_intrinsic_curvature_index
* area_fraction_of_negative_intrinsic_curvature_index
* area_fraction_of_mean_curvature_index
* area_fraction_of_negative_mean_curvature_index
* sh2sh
* sk2sk


### Usage example

The script `curvatures.m` is a usage example that assumes you have brain surface data from [Freesurfer](https://surfer.nmr.mgh.harvard.edu/), generated by running [mris_curvature](https://surfer.nmr.mgh.harvard.edu/fswiki/mris_curvature) on the brain mesh resulting from a Freesurfer run on MRI data. It computes the descriptors and uses [surfstat](http://www.math.mcgill.ca/keith/surfstat/) to display them on the brain. You can find the example `mris_curvature` output data for my brain in the `example_data` directory (the pial and white surfaces are available). Here are screenshots of several descriptors, plotted onto surfaces of a brain:

![shape_index_of_white_on_white](./shape_index_of_white_on_white.jpg?raw=true "The Shape index (SI) of the white matter surface of a human brain, plotted on the same surface.")
Fig. 1: The Shape index (SI) of the white matter surface of a human brain, plotted on the same surface.


![absolute_mean_curvature_index_of_white_on_inflated](./absolute_mean_curvature_index_of_white_on_inflated.jpg?raw=true "The absolute mean curvature index (AMCI) of the white matter surface of a human brain, plotted on the inflated surface of that brain.")
Fig. 2: The absolute mean curvature index (AMCI) of the white matter surface of a human brain, plotted on the inflated surface of that brain.

![principal_curvature_k2_of_white_on_white](./principal_curvature_k2_of_white_on_white.jpg?raw=true "The principal curvature k2 of the white matter surface of a human brain, plotted on the same surface.")
Fig. 3: The principal curvature k2 of the white matter surface of a human brain, plotted on the same surface.

![principal_curvature_k2_of_pial_on_pial](./principal_curvature_k2_of_pial_on_pial.jpg?raw=true "The principal curvature k2 of the pial surface of a human brain, plotted on the same surface.")
Fig. 4: The principal curvature k2 of the pial surface of a human brain, plotted on the same surface. Compare this to Fig. 3 and note the difference in curvature between the pial and the white matter surfaces of the same brain.



Of course, the descriptors work for all surfaces and are not limited to the brain.
