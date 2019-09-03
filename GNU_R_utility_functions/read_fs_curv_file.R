#!/usr/bin/env Rscript
# see lines 5548 ff. in mrisurf.c
# see builds_and_patches/freesurfer/utils/fio.c for fread3 and freadfloat

read_fs_curv_file <- function(filepath) {
    MAGIC_FILE_TYPE_NUMBER = 16777215;
    fh = file(filepath, "rb");

    magic_byte = fread3(fh);
    if (magic_byte != MAGIC_FILE_TYPE_NUMBER) {
        stop(sprintf("Magic number mismatch. The given file '%s' is not a valid FreeSurfer 'curv' format file in new binary format. (Hint: This function is designed to read files like 'lh.area' in the 'surf' directory of a pre-processed FreeSurfer subject.)\n", filepath));
    }
    num_verts = readBin(fh, integer(), n = 1, endian = "big");
    num_faces = readBin(fh, integer(), n = 1, endian = "big");
    values_per_vertex = readBin(fh, integer(), n = 1, endian = "big");
    data = readBin(fh, numeric(), size = 4, n = num_verts, endian = "big");
    close(fh);
    return(data);
}



fread3 <- function(filehandle) {
    b1 = readBin(filehandle, integer(), size=1, signed = FALSE);
    b2 = readBin(filehandle, integer(), size=1, signed = FALSE);
    b3 = readBin(filehandle, integer(), size=1, signed = FALSE);
    res = bitwShiftL(b1, 16) + bitwShiftL(b2, 8) + b3;
    return(res);
}


test_file = file.path("/Users", "timschaefer", "data", "tim_only", "tim", "surf", "lh.area")
d = read_fs_curv_file(test_file);

cat(sprintf("Expected min=0.0034 and max=5.0085 from calling read_curv on the file in Matlab.\n"));
