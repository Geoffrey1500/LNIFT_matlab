function des = descriptor(im,kpts,patch_size,ns,nbin)

gausFilter = fspecial('gaussian',[3,3],1.5);
im= imfilter(im, gausFilter, 'replicate');
im = imagetransform(double(im), 3);

n = size(kpts,2);
des = zeros(ns*ns*nbin,n);
parfor k = 1: n
    x = kpts(1, k);
    y = kpts(2, k);
    s = kpts(3, k);
    r = round(s*patch_size);
    ang = kpts(4,k);

    patch = extract_patches(im, x, y, r/2, ang); 
    patch = imresize(patch,[patch_size,patch_size]);
    histo = zeros(ns,ns,nbin);  %descriptor vector
    histo = extractHOGFeatures(patch,'CellSize',[16 16],'BlockSize',[2 2],'BlockOverlap',[0,0],'NumBins',nbin);

    if norm(histo) ~= 0
        histo = histo /norm(histo);
    end
    des(:,k) = histo;
end
