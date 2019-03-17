function [totalCloth,totalSkin]=SkinSegmentation(img)
% This function removes the background and skin so that
test=rgb2gray(img);
mask = zeros(size(test));
mask(25:end-25,25:end-25) = 1;
bw = activecontour(test,mask,500);
not_bw=~bw;

maskedCloth=double(img);
maskedCloth(:,:,1)=maskedCloth(:,:,1).*bw;
maskedCloth(:,:,2)=maskedCloth(:,:,2).*bw;
maskedCloth(:,:,3)=maskedCloth(:,:,3).*bw;
maskedCloth=uint8(maskedCloth);

maskedSkin=double(img);
maskedSkin(:,:,1)=maskedSkin(:,:,1).*not_bw;
maskedSkin(:,:,2)=maskedSkin(:,:,2).*not_bw;
maskedSkin(:,:,3)=maskedSkin(:,:,3).*not_bw;
maskedSkin=uint8(maskedSkin);

residualSkin=rgb2ycbcr(maskedCloth);

%The following chunk of code is taken from
% Matlab Central File Exchange
% Simple Skin segmentation
% version 1.0.0.0 (18.3 KB) by Pon
for i=1:size(residualSkin,1)
    for j= 1:size(residualSkin,2)
        cb = residualSkin(i,j,2);
        cr = residualSkin(i,j,3);
        if(~(cr > 135 && cr < 167 && cb > 80 && cb < 120))
            residualSkin(i,j,1)=235;
            residualSkin(i,j,2)=128;
            residualSkin(i,j,3)=128;
        end
    end
end
residualSkin=ycbcr2rgb(residualSkin);

R=residualSkin(:,:,1);
G=residualSkin(:,:,2);
B=residualSkin(:,:,3);

R(R>250)=0;
G(G>250)=0;
B(B>250)=0;

residualSkin(:,:,1)=R;
residualSkin(:,:,2)=G;
residualSkin(:,:,3)=B;

totalSkin=maskedSkin+residualSkin;
totalCloth=img-totalSkin;
end
