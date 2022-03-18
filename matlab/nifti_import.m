% this code can l~oad a single nifti image
% in order to use this function download 
% https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image

function cube_all=nifti_import

path = 'C:\Users\adria\Documents\Hackathon\P5-Elastography\data\mre_original_nii\IRMRE\';
files_nii = dir([path,'*.nii']);
N=length(files_nii);
cube_all=zeros(N,110,108,5);
%%

for i=1:N
    nii_file = files_nii(i).name;

    file_path = strcat(path,nii_file);

    nii_data = load_nii(file_path);

    cube = double(nii_data.img);
    cube = rescale(cube, -pi, pi); % rescale for unwrapping

    cube_all(i,:,:,:)=cube;
end
cube_all = permute (cube_all, [2 3 4 1]);

end