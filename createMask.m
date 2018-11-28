function Im = createMask(I)
%CREATEMASK Function for GUI to allow user to draw mask on the region to be
%inpainted
%   Inputs:
%       I       Original image
%   Outputs:
%       Im    	Mask for I

    Im = zeros(size(I,1), size(I,2));
    
    figure;
    imshow(I);
    h = imfreehand('Closed',false);
    pos = h.getPosition();
    while (~waitforbuttonpress)
        h = imfreehand('Closed',false);
        pos = [pos;h.getPosition()];
    end
    close;
    pos32 = int64(pos);
    
    for i = 1:length(pos)
        if (pos32(i,2) > 0 && pos32(i,2) <= size(I,1) && pos32(i,1) > 0 && pos32(i,1) <= size(I,2))
            Im(pos32(i,2),pos32(i,1)) = 255;
        end
    end
    
    Im = imdilate(Im,ones(3));
    
end

