#!/usr/bin/env Rscript
# see https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/MghFormat
#   and freesurfer/matlab/load_mgh.m


read_fs_mgh_file <- function(filepath) {

    # we could use 'gzfile' here if the file extension suggests it.

    cat(sprintf("*Parsing header of file '%s'.\n", filepath));
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
    cat(sprintf(" There are %d unused header bytes left that will be skipped (data starts at fixed index).\n", unused_header_space_size_left));

    cat(sprintf("*Reading data.\n"));
    seek(fh, where = unused_header_space_size_left, origin = "current"); # skip to end of header/beginning of data

    nv = ndim1 * ndim2 * ndim3 * nframes;
    volsz = c(ndim1, ndim2, ndim3, nframes);
    cat(sprintf(" Expecting %d voxels total.\n", nv));

    # Determine size of voxel data, depending on dtype from header above
    MRI_UCHAR = 0;
    MRI_INT = 1;
    MRI_FLOAT = 3;
    MRI_SHORT = 4;

    # Determine number of bytes per voxel
    if(dtype == MRI_FLOAT) {
        nbytespervox = 4;
    } else if(dtype == MRI_UCHAR) {
        nbytespervox = 1;
    } else if (dtype == MRI_SHORT) {
        nbytespervox = 2;
    } else if (dtype == MRI_INT) {
        nbytespervox = 4;
    } else {
       cat(sprintf(" ERROR: Unexpected data type found in header. Expected one of (0, 1, 3, 4) but got %d.\n"), dtype);
       quit(status=1);
    }
    cat(sprintf(" Data type found in header is %d, with %d bytes per voxel.\n", dtype, nbytespervox));

    data = readBin(fh, numeric(), size = nbytespervox, n = nv, endian = "big");
    num_read = prod(length(data));
    if (num_read == nv) {
        cat(sprintf(" OK, read %d voxel values as expected.\n", num_read));
    } else {
        cat(sprintf(" WARNING, read %d voxel values but expected to read %d.\n", num_read, nv));
    }

    # Reshape to expected dimensions
    data = array(data, dim = c(ndim1, ndim2, ndim3, nframes));
    cat(sprintf(" Reshaped array to expected dimensions: %s\n", paste(dim(data), collapse = ' ')));
    close(fh);
    return(data);
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

test_file = file.path(path.expand("~"), "data", "tim_only", "tim", "surf", "lh.area.fwhm0.fsaverage.mgh");
data = read_fs_mgh_file(test_file);
cat(sprintf("Data read. min=%f, max=%f.\n", min(data), max(data)));
