#!/usr/bin/env Rscript
# see lines 5548 ff. in mrisurf.c
# see builds_and_patches/freesurfer/utils/fio.c for fread3 and freadfloat

read_fs_curv_file <- function(filepath) {
    NEW_VERSION_MAGIC_NUMBER = 16777215;
    fh = file(filepath, "rb");
    magic_byte = fread3(fh);
    cat(sprintf("Parsing header of file '%s'.\n", filepath));
    cat(sprintf(" *Magic byte is: %d\n", magic_byte));
    num_verts = readBin(fh, integer(), n = 1, endian = "big");
    num_faces = readBin(fh, integer(), n = 1, endian = "big");
    values_per_vertex = readBin(fh, integer(), n = 1, endian = "big");
    cat(sprintf(" *num_verts is %d, num_faces is %d, values_per_vertex is %d.\n", num_verts, num_faces, values_per_vertex));
    cat(sprintf("Reading data.\n"));
    data = readBin(fh, numeric(), size = 4, n = num_verts, endian = "big");
    cat(sprintf("Data read, min=%f, max=%f.\n", min(data), max(data)));
    close(fh);
}



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

test_file = file.path("/Users", "timschaefer", "data", "tim_only", "tim", "surf", "lh.area")
read_fs_curv_file(test_file)

cat(sprintf("Expected min=0.0034 and max=5.0085 from calling read_curv on the file in Matlab.\n"));
