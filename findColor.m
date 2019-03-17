function [rVal,gVal,bVal]=findColor(I)

%Take the RGB Image
if (size(I, 3) ~= 3)
    error('Input image must be RGB.')
end

%Calculate the histogram of RGB individually
nBins = 256;
rHist = imhist(I(:,:,1), nBins);
gHist = imhist(I(:,:,2), nBins);
bHist = imhist(I(:,:,3), nBins);

%Taking mean
rMean=mean(rHist);
gMean=mean(gHist);
bMean=mean(bHist);

%SUbtracting the mean from the histogram to take only the peaks which are
%above the mean.
rHist=rHist-rMean;
gHist=gHist-gMean;
bHist=bHist-bMean;

%If any value goes below zero replace it with zero
rHist(rHist<0)=0;
gHist(gHist<0)=0;
bHist(bHist<0)=0;

%Smooth out the histogram to remove any jaggedness of the curve
rHist = smooth(rHist);
gHist = smooth(gHist);
bHist = smooth(bHist);

%Finding the mean of those values which are taking larger portion on the x-axis 
rVal=findValue(rHist);
gVal=findValue(gHist);
bVal=findValue(bHist);
end

function val=findValue(x)
%Setting the parameters for minimum range, and looping parameters
range=1;
i=2;

%Taking the length of row and looping till the end
 [r,~]=size(x);
while (i<=r)
    %If value is greatre than 0 then start recording that value till again
    %0 is found and record the range
    if(x(i)>0)
        startValue=i;
        while x(i)>0 && i<r
            i=i+1;
        end
        stopValue=i;
        
        %If this range is greater than previous range then accept this and
        %find the average value of it.
        if (stopValue-startValue)>range
            range=stopValue-startValue;
            val=floor((stopValue+startValue)/2);
        end
    end
    i=i+1;
end    
  

end
