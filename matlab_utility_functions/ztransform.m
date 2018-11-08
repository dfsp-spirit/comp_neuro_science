function xz = ztransform(x)
xz = (x-mean(x))/std(x);
end
