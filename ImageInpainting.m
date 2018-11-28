function newI = ImageInpainting(I,mask)
%IMAGEINPAINTING Inpaints a digital grayscale or color image using the
%given mask
%   Inputs:
%       I       Image to be inpainted
%       mask    The region to be inpainted
%   Outputs:
%       newI    Inpainted image

    % Return original image in case of error
    newI = I;

    [rI, cI, chI] = size(I);
    [rM, cM, ~] = size(mask);
    
    % Check the size of the mask and I
    if (~isequal([rI, cI],[rM, cM]))
        disp('The size of the Image and the Mask must be same');
    else
        imm=double(mask);
        
        % Grayscale image
        if (chI == 1)
            imo=double(I);
            newI = inpmask(imo, imm);     
        elseif (chI == 3)
            hsiI = rgb2hsv(I);
            
            chH = inpmask(double(hsiI(:,:,1)), imm);
            chS = inpmask(double(hsiI(:,:,2)), imm);
            chI = inpmask(double(hsiI(:,:,3)), imm);
            
            nhsiI = cat(3, chH, chS, chI);
            newI = hsv2rgb(nhsiI); 
        else
            disp('Number of channels in image must be either 1 or 3.');
        end
        
    end
    
end

% INPMASK Inpaint the given channel wherever the mask is 255.
%   Inputs:
%       ch      Channel of the image to be inpainted
%       mask    The region to be inpainted
%   Outputs:
%       cim     Inpainted channel
function cim = inpmask(ch, mask)
    cim=ch;
    itrs=10000;
    eta=0.0005;

    imt=zeros(size(cim,1),size(cim,2));
    rim=zeros(size(cim,1),size(cim,2));

    for it =0:itrs
        smooth = 0;

        % After every 100 iterations, anisotropic diffusion
        if (it ~= 0 && mod(it,100) == 0)
            cimd = anisotropicDiffusion(cim, 2, 1/8, 5);
            cim(mask==255) = cimd(mask==255);
            smooth = 1;
        end

        for ri = 1: size(cim,1)
            for ci = 1: size(cim,2)
                if(mask(ri,ci)==255)
                    B=dot(deLp(ri,ci,cim),normN(ri,ci,cim));
                    imt(ri,ci)=B*slGrad(ri,ci,cim,B);
                    rim(ri,ci)=cim(ri,ci)+eta*imt(ri,ci);
                else
                    rim(ri,ci)=cim(ri,ci);
                end
            end
        end
        cim=rim;
        cim(cim>255) = 255;
        cim(cim<0) = 0;
    end
    disp('itr = '+string(itrs)+' and eta = '+string(eta)+ ' and aniso diff = ' +string(smooth));
end

%LP Calculates the gradient
%   Inputs:
%       x,y Location of the given pixel
%       im  Image
%   Outputs:
%       L   Gradient
function L=Lp(x,y,im)

    [a,b,c,d] = nInt(x,y,im);

    L=(a+b+c+d - 4*im(x,y));
    
end

%DELP Calculates the direction of the isophotes
%   Inputs:
%       x,y Location of the given pixel
%       im  Image
%   Outputs:
%       deL
function deL=deLp(x,y,im)

    if x-1>=1,           a=Lp(x-1,y,im); else, a=0;end
    if x+1<=size(im,1),  b=Lp(x+1,y,im); else, b=0;end
    if y-1>=1,           c=Lp(x,y-1,im); else, c=0;end
    if y+1<=size(im,2),  d=Lp(x,y+1,im); else, d=0;end
    
    deL=([b-a,d-c]);    
    
end

%NORMN Calculates the information to be carried
%   Inputs:
%       x,y Location of the given pixel
%       im  Image
%   Outputs:
%       Nnorm
function Nnorm=normN(x,y,im)

    [a,b,c,d] = nInt(x,y,im);
    
    Ix=(b-a)/2;
    Iy=(d-c)/2;
    
    magI=sqrt((Ix*Ix)+(Iy*Iy));
    
    if(magI==0)
        Nnorm=([0,0]);
    else
        Nnorm=([-Iy/magI,Ix/magI]);
    end

end

%SL_GRAD Returns the intensity of the 4 neighbours of the given pixel
%   Inputs:
%       x,y Location of the given pixel
%       im  Image
%       B   
%   Outputs:
%       sl_Grad 
function sl_Grad=slGrad(x,y,im,B)

    [a,b,c,d] = nInt(x,y,im);

    Ixf=b-im(x,y);
    Ixb=im(x,y)-a;
    Iyf=d-im(x,y);
    Iyb=im(x,y)-c;
    
    Ixfm=min([Ixf,0]);
    IxfM=max([Ixf,0]);
    Ixbm=min([Ixb,0]);
    IxbM=max([Ixb,0]);
    Iyfm=min([Iyf,0]);
    IyfM=max([Iyf,0]);
    Iybm=min([Iyb,0]);
    IybM=max([Iyb,0]);
    
    if(B>0)
        sl_Grad=sqrt((Ixbm*Ixbm)+(IxfM*IxfM)+(Iybm*Iybm)+(IyfM*IyfM));
    else
        sl_Grad=sqrt((IxbM*IxbM)+(Ixfm*Ixfm)+(IybM*IybM)+(Iyfm*Iyfm));
    end
     
end

%NINT Returns the intensity of the 4 neighbours of the given pixel
%   Inputs:
%       x,y Location of the given pixel
%       im  Image
%   Outputs:
%       a,b,c,d Neighbouring pixels (top, bottom, left, right)
function [a,b,c,d] = nInt(x,y,im)

    if x-1>=1,           a=im(x-1,y); else, a=0;end
    if x+1<=size(im,1),  b=im(x+1,y); else, b=0;end
    if y-1>=1,           c=im(x,y-1); else, c=0;end
    if y+1<=size(im,2),  d=im(x,y+1); else, d=0;end
    
end
