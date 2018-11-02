function new_I = anisotropicDiffusion(I,itr,lambda,K)
%ANISOTROPICDIFFUSION Summary of this function goes here
%   Detailed explanation goes here
    [~,~,ch] = size(I);
    if (ch == 1)
        % Grayscale image
        new_I = diffuseIm(I,itr,lambda,K);
    elseif (ch == 3)
        % Color image
        I_R = I(:,:,1);
        I_G = I(:,:,2);
        I_B = I(:,:,3);

        smooth_IR = diffuseIm(I_R,itr,lambda,K);
        smooth_IG = diffuseIm(I_G,itr,lambda,K);
        smooth_IB = diffuseIm(I_B,itr,lambda,K);

        new_I = cat(3,smooth_IR,smooth_IG,smooth_IB);
    else
        disp('Incorrect image. It should be either grayscale or colored');
    end
end

function smooth_I = diffuseIm(I,itr,lambda,K)
    im = I;
    for i = 1:itr
        % Filters to get change in 8 directions
        f_N = [0,1,0;0,-1,0;0,0,0];
        f_S = [0,0,0;0,-1,0;0,1,0];
        f_W = [0,0,0;1,-1,0;0,0,0];
        f_E = [0,0,0;0,-1,1;0,0,0];
        f_NE = [0,0,1;0,-1,0;0,0,0];
        f_SE = [0,0,0;0,-1,0;0,0,1];
        f_NW = [1,0,0;0,-1,0;0,0,0];
        f_SW = [0,0,0;0,-1,0;1,0,0];

        % Image gradient with respect to each direction
        I_N = imfilter(im,f_N);
        I_S = imfilter(im,f_S);
        I_W = imfilter(im,f_W);
        I_E = imfilter(im,f_E);
        I_NE = imfilter(im,f_NE);
        I_SE = imfilter(im,f_SE);
        I_NW = imfilter(im,f_NW);
        I_SW = imfilter(im,f_SW);

        % Diffusion constant corresponding to each Image gradient
        c_N = diffusionConstant(I_N,K);
        c_S = diffusionConstant(I_S,K);
        c_W = diffusionConstant(I_W,K);
        c_E = diffusionConstant(I_E,K);
        c_NE = diffusionConstant(I_NE,K);
        c_SE = diffusionConstant(I_SE,K);
        c_NW = diffusionConstant(I_NW,K);
        c_SW = diffusionConstant(I_SW,K);

        % Smoothened image after each iteration
        im = im + lambda*(c_N.*I_N + c_S.*I_S + c_W.*I_W + c_E.*I_E...
            + c_NE.*I_NE + c_SE.*I_SE + c_NW.*I_NW + c_SW.*I_SW);    
    end
    smooth_I = uint8(im);    
end

% Finds diffusion constant for given image
function c = diffusionConstant(I,K)
    c = 1./(1+(I./K).^2);
end