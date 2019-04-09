function res = write_csv_with_header(csv_header_line, data_matrix, output_csv_file)
% This function is very primitive, it only supports CSV in the sense that
% the separator is really a comma ','. It writes data using dlmwrite, with its ceveats.
%
% So the header string should also be comma separated, of course.
%
% Contrary to its name, this function can also be used to write without
% header, just supply an empty string as first argument.
res = 0;
if (csv_header_line == "")
    dlmwrite(output_csv_file, data_matrix);
else
    fid = fopen(output_csv_file, 'w');
    fprintf(fid, '%s\n', csv_header_line);
    fclose(fid);
    dlmwrite(output_csv_file, data_matrix, '-append');
end
