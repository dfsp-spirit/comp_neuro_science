# test_qdecr

2019-06-12

This is just a small test script to have a quick look at [qdecr](http://qdecr.com), a GNU R package that allows you to perform vertex-wise analysis of structural neuroimaging data that has been pre-processed in [Freesurfer](http://freesurfer.net/) using R. The cool thing about it is that you can use the intuitive R formula syntax to describe your models instead of having to fiddle with contrast matrices manually.

A very early version of the was presented at [OHBM 2019 in Rome](https://www.humanbrainmapping.org) today, and I thought I'd give it a try. The [qdecr github repo is here](https://github.com/slamballais/QDECR), btw.

The script in this directory is mostly copied from the documentation of qdecr. I tested it on some neuroimaging data and computed a toy model. Here is a screenshot of the result visualization within rstudio:


![Annotations](./qdecr_in_rstudio.png?raw=true "qdecr in rstudio")
It shows the effect of age on brain surface area in the dataset as a toy example.


Internally, qdecr uses both R and Freesurfer tools to do the work. The visualization is done in Freeview.


The runtime for the analysis was less then 4 minutes for the 330 subjects in the dataset, which is fast enough for me and comparable to tools like [surfstat](http://www.math.mcgill.ca/keith/surfstat/).
