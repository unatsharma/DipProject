# DipProject
How to run the code:
1) Our code runs on MATLAB, the code is made in R2018a.
2) Make sure the folder (and subfolders, if any) containing the code and images is added to the MATLAB path.
3) The 'Input Images' folder is used to select an image to be inpainted, 'Mask Images' folder can be used to upload a mask directly and 'Output Images' contain all the outputs we obtained using our code. Download the images from the following link in the folder added to the MATLAB path. Link to images: https://drive.google.com/drive/folders/13L9KiayaeleNbZSV5opwWE8Ttc7tRW_r?usp=sharing .
This link contains three folders - input, mask and output. The nomenclature for images in the above folders is -
Input image name = <image_name>, Mask image name = <image_name>+'Mask' and Output image name = <image_name>.
4) One must keep all the code files together in one folder which is in MATLAB path.
5) When one runs the program i.e.,'project.m', the first window asks the user to upload an image which has to be inpainted, make sure the folder containing the image is added to MATLAB path. The code allows images with 'jpg', 'jpeg' and 'png' extensions only.
6) Next user must provide a mask to identify the regions to be inpainted. It could be done using following 3 methods:- 
a) User can upload a Mask Image, make sure the folder containing the image is added to MATLAB path.
b) User can generate mask herself/himself using the UI provided. In the UI, user has to hold the left button of the mouse and scribble the region to be inpainted. If the user, wants to scribble another region which is not connected to the previous one, left click twice, again the user will get the curser to mark the region. After user is done making the mask, press 'Enter'. The UI for mask generation will close and image inpainting process will start.
c) In case of elimination of embedded text, one can use text detection method to generate mask.
7) Based on the image size, number of channels in the image and the pixels to be inpainted, the time required for inpainting will vary.
8) Finally, the output will be displayed which contains the input image, mask used for inpainting and the inpainted output image.
