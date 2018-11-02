
%%
input_original_image='../input/outpool.jpg';
input_original_image_mask='../input/outpoolmask.jpg';

imo=double(rgb2gray(imread(input_original_image)));
imm=double(binarize_im(convert_2_gray(imread(input_original_image_mask)),127));
%%
cim=imo;
itrs=1000;
eta=0.001;

imt=zeros(size(cim,1),size(cim,2));
rim=zeros(size(cim,1),size(cim,2));


for it =0:itrs
    disp(it)
    for ri = 1: size(cim,1)
        for ci = 1: size(cim,2)
            if(imm(ri,ci)==255)
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



%%

function im=binarize_im(im,t)
    for i= 1:size(im,1)
        for j = 1 : size(im,2)
            if(im(i,j)<=t)
                im(i,j)=0;
            else
                im(i,j)=255;
            end
        end
    end

end

function im=convert_2_gray(im)

if ( size(im,3)==3 )
im=.21*im(:,:,1)+.71*im(:,:,2)+.07*im(:,:,3);
end

end



function L=Lp(x,y,im)
%L=((im[x-1,y]  if x-1>=0 else 0 )+(im[x+1,y]  if x+1<im.shape[0] else 0)+(im[x,y-1]  if y-1>=0 else 0)+(im[x,y+1]  if y+1<im.shape[1] else 0)-4*im[x,y])
    if x-1>=1,           a=im(x-1,y); else, a=0;end
    if x+1<=size(im,1),  b=im(x+1,y); else, b=0;end
    if y-1>=1,           c=im(x,y-1); else, c=0;end
    if y+1<=size(im,2),  d=im(x,y+1); else, d=0;end
    
    L=(a+b+c+d - 4*im(x,y));
    
end

function deL=deLp(x,y,im)
%L=((im[x-1,y]  if x-1>=0 else 0 )+(im[x+1,y]  if x+1<im.shape[0] else 0)+(im[x,y-1]  if y-1>=0 else 0)+(im[x,y+1]  if y+1<im.shape[1] else 0)-4*im[x,y])
    if x-1>=1,           a=Lp(x-1,y,im); else, a=0;end
    if x+1<=size(im,1),  b=Lp(x+1,y,im); else, b=0;end
    if y-1>=1,           c=Lp(x,y-1,im); else, c=0;end
    if y+1<=size(im,2),  d=Lp(x,y+1,im); else, d=0;end
    
    deL=([b-a,d-c]);
    
end


function Nnorm=normN(x,y,im)
    if x-1>=1,           a=im(x-1,y); else, a=0;end
    if x+1<=size(im,1),  b=im(x+1,y); else, b=0;end
    if y-1>=1,           c=im(x,y-1); else, c=0;end
    if y+1<=size(im,2),  d=im(x,y+1); else, d=0;end
    
    Ix=(b-a)/2;
    Iy=(d-c)/2;
    
    magI=sqrt((Ix*Ix)+(Iy*Iy));
    
    if(magI==0)
        Nnorm=([0,0]);
    else
        Nnorm=([-Iy/magI,Ix/magI]);
    end

end

function sl_Grad=slGrad(x,y,im,B)

    if x-1>=1,           a=im(x-1,y); else, a=0;end
    if x+1<=size(im,1),  b=im(x+1,y); else, b=0;end
    if y-1>=1,           c=im(x,y-1); else, c=0;end
    if y+1<=size(im,2),  d=im(x,y+1); else, d=0;end

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

