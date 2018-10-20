from tvtk.api import tvtk; from mayavi import mlab; import numpy as np

nr_points = 300

x,y,z=np.random.random((3,nr_points)) #some data
colors=np.random.randint(256,size=(100,4)) #some RGB or RGBA colors

pts=mlab.points3d(x,y,z)
sc=tvtk.UnsignedCharArray()
sc.from_array(colors)

pts.mlab_source.dataset.point_data.scalars=sc
pts.mlab_source.dataset.modified()

mlab.show()
