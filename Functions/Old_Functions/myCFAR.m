function [detectedPeakPos] = myCFAR(data, windowSize, numOfWindows, stride,...
                            thresholdFactor, numTrimLow, numTrimHigh, numOfGuideWindows, enableSided)
detectedPeakPos(1)=-1;
if (mod(numOfWindows,2)==0)
    error('"numOfWindows" must be a odd integer');
end

if (numOfWindows<3)
    error('"numOfWindows" must be greater than 2 and odd');
end

if (windowSize<1)
    error('"windowSize" must be greater or equal to 1');
end

if (stride<1)
    error('"stride" must be greater or equal to 1');
end

if (thresholdFactor<=0)
    error('"thresholdFactor" must be greater than 0');
end
if (numTrimLow<0)
    error('"numTrimLow" must be an integer and greater or equal to 0');
end

if (numTrimHigh<0)
    error('"numTrimHigh" must be an integer and greater or equal to 0');
end


if (numTrimHigh>=floor(numOfWindows/2))
    error('"numTrimHigh" must be smaller than floor(numOfWindows/2)');
end

if (numTrimLow>=floor(numOfWindows/2))
    error('"numTrimLow" must be smaller than floor(numOfWindows/2)');
end

if (numOfGuideWindows<0)
    error('"numOfGuideWindows" must be an integer and greater or equal to 0');
end

endPoint = floor((length(data)-((numOfWindows+numOfGuideWindows*2)*windowSize))/stride)*stride; 


peakCount = 1;



for idx=1:stride:endPoint
meanBeforeCUT = zeros(floor(numOfWindows/2),1);
meanAfterCUT = zeros(floor(numOfWindows/2),1);

    for j = 1:length(meanBeforeCUT)
        meanBeforeCUT(j) = mean(data(idx+(j-1)*windowSize:idx+j*windowSize-1));
    end
    offset = idx+j*windowSize;
    
    meanCUT = mean(data(offset+numOfGuideWindows*windowSize:...
        offset+numOfGuideWindows*windowSize+windowSize-1));
    
    offset = offset+numOfGuideWindows*windowSize+windowSize;
    
    for j = 1:length(meanBeforeCUT)
        meanAfterCUT(j) = mean(data(offset+numOfGuideWindows*windowSize+(j-1)*windowSize:...
            offset+numOfGuideWindows*windowSize+j*windowSize-1));
    end
    
    if(numTrimLow>0 || numTrimHigh>0)
       meanAfterCUT = sort(meanAfterCUT);
       meanBeforeCUT = sort(meanBeforeCUT);
        
       meanAfterCUT = meanAfterCUT(numTrimLow+1:end-numTrimHigh);
       meanBeforeCUT =  meanBeforeCUT(numTrimLow+1:end-numTrimHigh);
    end
    
      if (enableSided == 0)
      threshold = (mean(meanBeforeCUT)+mean(meanAfterCUT))/2 * thresholdFactor; 
      else
          if (enableSided == 1)
         
              if(mean(meanBeforeCUT)>mean(meanAfterCUT))
                  threshold = mean(meanBeforeCUT)*thresholdFactor;
              else
                  threshold = mean(meanAfterCUT)*thresholdFactor;
              end
              
          end
      end
    
    
    if(threshold < meanCUT)
        detectedPeakPos(peakCount) = (idx+round(windowSize*(numOfWindows+numOfGuideWindows*2)/2));
        peakCount = peakCount+1;
    end
end


end