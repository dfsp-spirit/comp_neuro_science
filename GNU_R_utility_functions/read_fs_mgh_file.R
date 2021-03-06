#!/usr/bin/env Rscript
# see https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/MghFormat
#   and freesurfer/matlab/load_mgh.m


read_fs_mgh_file <- function(filepath, is_gzipped = "AUTO") {

    if(typeof(is_gzipped) == "logical") {
        is_gz = is_gzipped;
    } else if (typeof(is_gzipped) == "character") {
        if(is_gzipped == "AUTO") {
            nc = nchar(filepath);
            num_chars_to_inspect = 3; # last 3 chars
            if(nc >= 3) {
                ext = substr(filepath, nchar(filepath)-num_chars_to_inspect+1, nchar(filepath));
                if(tolower(ext) == "mgz" || tolower(ext) == ".gz") {
                    is_gz = TRUE;
                } else {
                    is_gz = FALSE;
                }
            } else {
                warning(sprintf("Argument 'is_gzipped set' to 'AUTO' but file name is too short (%d chars) to determine compression from last %d characters, assuming gz-compressed file.\n", nc, num_chars_to_inspect));
                is_gz = TRUE;
            }
        } else {
            stop("Argument 'is_gzipped' must be 'AUTO' if it is a string.\n");
        }
    } else {
        stop(sprintf("ERROR: Argument is_gzipped must be logical (TRUE or FALSE) or 'AUTO'.\n"));
    }

    if (is_gz) {
         cat(sprintf("*Parsing header of file '%s', assuming it is gz-compressed.\n", filepath));
        fh = gzfile(filepath, "rb");
    }
    else {
        cat(sprintf("*Parsing header of file '%s', assuming it is NOT gz-compressed.\n", filepath));
        fh = file(filepath, "rb");
    }

    v = readBin(fh, integer(), n = 1, endian = "big");
    ndim1 = readBin(fh, integer(), n = 1, endian = "big");
    ndim2 = readBin(fh, integer(), n = 1, endian = "big");
    ndim3  = readBin(fh, integer(), n = 1, endian = "big");
    nframes = readBin(fh, integer(), n = 1, endian = "big");
    dtype = readBin(fh, integer(), n = 1, endian = "big");
    dof = readBin(fh, integer(), n = 1, endian = "big");


    cat(sprintf(" v=%d, ndim1=%d, ndim2=%d, ndim3=%d, nframes=%d, type=%d, dof=%d.\n", v, ndim1, ndim2, ndim3, nframes, dtype, dof));


    unused_header_space_size_left = 256;

    ras_good_flag = readBin(fh, numeric(), n = 1, endian = "big");
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

    # Skip to end of header/beginning of data
    seek(fh, where = unused_header_space_size_left, origin = "current");

    nv = ndim1 * ndim2 * ndim3 * nframes;   # number of voxels
    volsz = c(ndim1, ndim2, ndim3, nframes);
    cat(sprintf(" Expecting %d voxels total.\n", nv));

    # Determine size of voxel data, depending on dtype from header above
    MRI_UCHAR = 0;
    MRI_INT = 1;
    MRI_FLOAT = 3;
    MRI_SHORT = 4;

    dt_explanation = "0=MRI_UCHAR; 1=MRI_INT; 3=MRI_FLOAT; 3=MRI_SHORT";

    # Determine number of bytes per voxel
    if(dtype == MRI_FLOAT) {
        nbytespervox = 4;
        data = readBin(fh, numeric(), size = nbytespervox, n = nv, endian = "big");
    } else if(dtype == MRI_UCHAR) {
        nbytespervox = 1;
        data = readBin(fh, integer(), size = nbytespervox, n = nv, signed = FALSE, endian = "big");
    } else if (dtype == MRI_SHORT) {
        nbytespervox = 2;
        data = readBin(fh, integer(), size = nbytespervox, n = nv, endian = "big");
    } else if (dtype == MRI_INT) {
        nbytespervox = 4;
        data = readBin(fh, int(), size = nbytespervox, n = nv, endian = "big");
    } else {
       stop(sprintf(" ERROR: Unexpected data type found in header. Expected one of {0, 1, 3, 4} (%s) but got %d.\n", dt_explanation, dtype));
    }
    cat(sprintf(" Data type found in header is %d (%s), with %d bytes per voxel.\n", dtype, dt_explanation, nbytespervox));

    num_read = prod(length(data));
    if (num_read == nv) {
        cat(sprintf(" OK, read %d voxel values as expected.\n", num_read));
    } else {
        cat(sprintf(" ERROR: read %d voxel values but expected to read %d.\n", num_read, nv));
        quit(status=1);
    }

    # Reshape to expected dimensions
    data = array(data, dim = c(ndim1, ndim2, ndim3, nframes));
    cat(sprintf(" Reshaped array to expected dimensions: %s\n", paste(dim(data), collapse = ' ')));
    close(fh);
    return(data);
}



cat(sprintf("==============file1==============\n"));
test_file1 = file.path(path.expand("~"), "data", "tim_only", "tim", "surf", "lh.area.fwhm0.fsaverage.mgh");
data1 = read_fs_mgh_file(test_file1, is_gzipped="AUTO");
cat(sprintf("data1 read. min=%f, max=%f.\n", min(data1), max(data1)));
cat(sprintf("==============file2==============\n"));
test_file2 = file.path(path.expand("~"), "data", "tim_only", "tim", "mri", "T1.mgz");
data2 = read_fs_mgh_file(test_file2);
cat(sprintf("data2 read. min=%f, max=%f.\n", min(data2), max(data2)));
