#!/usr/bin/env Rscript
# see lines 5548 ff. in mrisurf.c

read_fs_curv_file <- function(filepath) {
    NEW_VERSION_MAGIC_NUMBER = 16777215
    fh = file(filepath, "rb")
    magic_byte = fread3(fh)
    #magic_byte = readBin(fh, integer(), n = 1, endian = "big")
    cat(sprintf("Magic byte is: %d", magic_byte))
    return(1)
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
