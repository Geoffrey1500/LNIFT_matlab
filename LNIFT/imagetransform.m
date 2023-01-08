function trx = imagetransform(im, d)

q = d*2+1;
D = d+1;
[nr,nc] = size(im);
s = cumsum(cumsum(im,2),1); 

br = nr-d-1;
bc = nc-d-1;
b0 = D+1;
nx = q*q;
K = zeros(nr,nc);
for r=b0:br
    for c=b0:bc
        v= (s(r-D,c-D)-s(r-D,c+d)-s(r+d,c-D)+s(r+d,c+d))/nx;
        k = (im(r,c)-v);
        K(r,c)=k;
    end
end
sigma=std(K(:));
K(K>5*sigma)=5*sigma;
K(K<-5*sigma)=-5*sigma;
K=(K+5*sigma)./(10*sigma);
trx=uint8(K*255);
