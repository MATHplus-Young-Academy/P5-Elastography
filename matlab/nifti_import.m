% this code can load a single nifti image
% in order to use this function download 
% https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image

clear all;

path = 'C:\Users\matth\OneDrive\Desktop\work\Hackathon\data\mre_original_nii\IRMRE\'
nii_file = 'f191125112201STD1312211075243167072-0045-00001-000001-01.nii'

file_path = strcat(path,nii_file);

nii_data = load_nii(file_path);

cube = double(nii_data.img);
cube = rescale(cube, -pi, pi); % rescale for unwrapping

imshow(cube(:,:,2), [-pi pi])