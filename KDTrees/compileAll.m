filez = dir('./*.cpp');

for f=1:numel(filez)
    mex([filez(f).name])
end