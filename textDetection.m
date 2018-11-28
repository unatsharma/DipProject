function I_new = textDetection(I)

    % Step 1
    fil = [0,1,0;...
        1,1,1;...
        0,1,0];
    fil = fil/5;
    I = imfilter(I,fil);

    % Step 2
    [h,w] = size(I);

    s_x = [-1,0,1;-2,0,2;-1,0,1];
    s_y = [1,2,1;0,0,0;-1,-2,-1];

    G_x = double(imfilter(I,s_x));
    G_y = double(imfilter(I,s_y));

    G = uint8(sqrt(G_x.^2 + G_y.^2));
    imshow(G);
    s_G = sum(sum(G.^2));
    d = (h-1)*(w-1);
    t_1 = uint8(2*sqrt(s_G/d));

    % Step 3
    t_2 = 125;

    E = zeros(h,w);
    for i = 1:h
        for j = 1:w
            if (G(i,j) > t_1)
                E(i,j) = 255;
            end
        end
    end

    % Step 4
    if (mod(h,2) == 1 && mod(w,2) == 1)
        I_pad = zeros(h+1,w+1);
        I_pad(1:h,1:w) = I;
        G_pad = [G,zeros(h,1);zeros(1,w+1)];
        E_pad = [E,zeros(h,1);zeros(1,w+1)];
    elseif (mod(h,2) == 1)
        I_pad = zeros(h+1,w);
        I_pad(1:h,1:w) = I;
        G_pad = [G;zeros(1,w)];
        E_pad = [E;zeros(1,w)];    
    elseif (mod(w,2) == 1)
        I_pad = zeros(h,w+1);
        I_pad(1:h,1:w) = I;
        G_pad = [G,zeros(h,1)];
        E_pad = [E,zeros(h,1)];
    else
        I_pad = I;
        G_pad = G;
        E_pad = E;
    end

    [h_pad,w_pad] = size(I_pad);

    n = 2;
    for i_I = 1:n:h_pad
        for j_I = 1:n:w_pad
            G_ij = G_pad(i_I:i_I+n-1,j_I:j_I+n-1);
            E_ij = E_pad(i_I:i_I+n-1,j_I:j_I+n-1);

            H_1 = G_ij - t_1;
            H_2 = E_ij - 255;

            H_1(H_1 >= 0) = 1;
            H_1(H_1 < 0) = 0;
            H_2(H_2 >= 0) = 1;
            H_2(H_2 < 0) = 0;

            R_ij = sum(sum(double(G_ij).*(double(H_1).*double(H_2))))/n^2;

            if (R_ij > t_2)
                I_pad(i_I:i_I+n-1,j_I:j_I+n-1) = 255;
            else
                I_pad(i_I:i_I+n-1,j_I:j_I+n-1) = 0;
            end
        end
    end

    I_new = I_pad(1:h,1:w);
    I_new = imdilate(imclose(I_new,ones(3)),ones(3));
    
end
