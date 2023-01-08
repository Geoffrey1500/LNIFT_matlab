function kpts = detector(im,N,is_ori)

%  locally normalized image
im = imagetransform(double(im), 1); 

key = detectORBFeatures(im);
key = key.selectUniform(N,size(im));
kpts = [key.Location ones(size(key.Location,1),1) key.Orientation*180/pi]';
kpts(4,kpts(4,:)>180)=kpts(4,kpts(4,:)>180)-180;
if is_ori ==0
    kpts(4,:)=0;
end
