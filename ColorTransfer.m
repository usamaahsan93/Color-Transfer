% Author : Usama Ahsan
clc
close all

%Selecting the Image for Source and Reference Colors
[S,source,~]=uigetfile('*.jpg','Pick Source Image');
[R,reference,~]=uigetfile('*.jpg','Pick Reference Image');
source=strcat(source,S);
reference=strcat(reference,R);

%Reading the  image from the directory
S=imread(source);
R=imread(reference);

%These two lines are commented , but uncomment them if you want to use the
%crop on the pictures

% S=imcrop(S);
% R=imcrop(R);

%The following function segments the background and skin from the image and
%returns the 2 pictures having same dimensions as cloth and skin.
[cloth,skin]=SkinSegmentation(S);

%Finding the RGB Value of the majority color
[r,g,b]=findColor(cloth);
SourceHSV=rgb2hsv([r/255 g/255 b/255]);
[r,g,b]=findColor(R);
ReferenceHSV=rgb2hsv([r/255 g/255 b/255]);

%Finding the factor to shift the Source HSV towards the Reference HSV 
DiffHSV=ReferenceHSV./SourceHSV;

%Converting both of the images in HSV
skin=rgb2hsv(skin);
K=rgb2hsv(cloth);

%Applying the factor on the source image
K(:,:,1)=K(:,:,1).*DiffHSV(1);
K(:,:,2)=K(:,:,2).*DiffHSV(2);
K(:,:,3)=K(:,:,3).*DiffHSV(3);

%Adding the Background+Skin to the color updated image and converting back
%to RGB
final=K+skin;
final=hsv2rgb(final);

%Applying the median filter to remove the noisy pixels
final=my_medfilt3(final);

%Displaying the Output
figure;
subplot(1,3,1),imshow(S); title('Source');
subplot(1,3,2),imshow(R); title('Reference');
subplot(1,3,3),imshow(final); title('Converted');
