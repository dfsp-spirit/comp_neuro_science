# test_qdecr

This is just a small test script to have a quick look at [qdecr](http://qdecr.com), a GNU R package that allows you to perform vertex-wise analysis of structural neuroimaging data in R. The cool thing about it is that you can use the intuitive R formula syntax to describe your models instead of having to fiddle with contrast matrices manually.

A very early version of the was presented at OHBM 2019 in Rome today, and I thought I'd give it a try. The [qdecr github repo is here](https://github.com/slamballais/QDECR), btw.

The script in this directory is mostly copied from the documentation of qdecr, but here is a screenshot of the result visualization within rstudio:


![Annotations](./qdecr_in_rstudio.png?raw=true "qdecr in rstudio")


Internally, qdecr uses both R and Freesurfer tools to do the work. The visualization is done in Freeview.
