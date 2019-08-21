#!/usr/bin/env Rscript
# see https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/MghFormat
#   and freesurfer/matlab/load_mgh.m


read_fs_mgh_file <- function(filepath) {

    # we could use 'gzfile' here if the file extension suggests it.

    cat(sprintf("Parsing header of file '%s'.\n", filepath));
    fh = file(filepath, "rb");

    v = fread1(fh);
    ndim1 = fread1(fh);
    ndim2 = fread1(fh);
    ndim3  = fread1(fh);
    nframes = fread1(fh);
    dtype = fread1(fh);
    dof = fread1(fh);


    cat(sprintf(" v=%d, ndim1=%d, ndim2=%d, ndim3=%d, nframes=%d, type=%d, dof=%d.\n", v, ndim1, ndim2, ndim3, nframes, dtype, dof));


    unused_header_space_size_left = 256;

    ras_good_flag = freadshort(fh);
    if(ras_good_flag == 1) {
        cat(sprintf(" 'RAS good' flag is set, reading RAS information.\n"));
        delta  = readBin(filehandle, float(), n = 3, endian = "big")
        Mdc    = readBin(filehandle, float(), n = 9, endian = "big")
        Pxyz_c = readBin(filehandle, float(), n = 3, endian = "big")
        RAS_space_size = (3*4 + 4*3*4);
        cat(sprintf(" Read %d bytes of RAS information.\n", RAS_space_size));
        unused_header_space_size_left = unused_header_space_size_left - RAS_space_size;
    } else {
        cat(sprintf(" 'RAS good' flag is NOT set, no RAS information to read.\n"));
    }
    cat(sprintf(" There are %d header bytes left.\n", unused_header_space_size_left));

    cat(sprintf("Reading data.\n"));
    nv = ndim1 * ndim2 * ndim3 * nframes;
    volsz = c(ndim1, ndim2, ndim3, nframes);
    cat(sprintf(" Expecting %d voxels total.\n", nv));

    #data = readBin(fh, numeric(), size = 4, n = num_verts, endian = "big");
    #cat(sprintf("Data read, min=%f, max=%f.\n", min(data), max(data)));
    close(fh);
}

# read a single integer
fread1 <- function(filehandle) {
    return(readBin(filehandle, integer(), n = 1, endian = "big"));
}

# read a short
freadshort <- function(filehandle) {
    return(readBin(filehandle, numeric(), n = 1, endian = "big"));
}

# read a 3 byte integer
fread3 <- function(filehandle) {
    b1 = read_byte(filehandle);
    b2 = read_byte(filehandle);
    b3 = read_byte(filehandle);
    res = bitwShiftL(b1, 16) + bitwShiftL(b2, 8) + b3;
    return(res);
}

read_byte <- function(filehandle) {
    b = readBin(filehandle, integer(), size=1, signed = FALSE);
    return(b);
}

test_file = file.path(path.expand("~"), "data", "tim_only", "tim", "surf", "lh.area.fwhm0.fsaverage.mgh")
read_fs_mgh_file(test_file)
