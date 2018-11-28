% Upload Image to be inpainted
input_original_image = uigetfile({'*.jpg';'*.jpeg';'*.png'},'Upload original image');

if input_original_image ~= 0
    
    I = imread(input_original_image);
    
    % Upload Mask for the inpainted region
    gen_mask = questdlg('Please provide mask', 'Method to provide mask', ...
                        'Upload Mask', 'Generate Mask', 'Text Detection Mask', 'Text Detection Mask');
    switch gen_mask
        case 'Upload Mask'
            input_original_image_mask = uigetfile({'*.jpg';'*.jpeg';'*.png'},'Upload mask file');
            
            if input_original_image_mask ~= 0
                M = imread(input_original_image_mask);
                if size(M,3) == 3
                    M = rgb2gray(M);
                end
                M = imbinarize(M)*255;
            else
                M = '';
            end

        case 'Generate Mask'
            M = createMask(I);

        case 'Text Detection Mask'
            M = textDetection(rgb2gray(I));

    end

    if (~isempty(M))
        
        % Perform image inpainting
        newI = ImageInpainting(I, M);

        figure;
        subplot(1,3,1); imshow(I); title('Original Image');
        subplot(1,3,2); imshow(M); title('Mask for used for inpainting');
        subplot(1,3,3); imshow(newI); title('Inpainted Image');
        
    else
        disp('No mask was provided');
    end
else
    disp('No image provided to be inpainted');
end
