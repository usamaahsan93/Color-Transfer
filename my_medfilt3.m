function filtered=my_medfilt3(filtered)
%Just applying median filter on the image to smooth out the effects
x=3;
filtered(:,:,1)=medfilt2(filtered(:,:,1),[x x]);
filtered(:,:,2)=medfilt2(filtered(:,:,2),[x x]);
filtered(:,:,3)=medfilt2(filtered(:,:,3),[x x]);
end