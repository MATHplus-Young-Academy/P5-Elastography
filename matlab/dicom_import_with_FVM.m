clear all;
close all

% path to folder with dicom data
files = dir('C:\Users\adria\Documents\Hackathon\P5-Elastography\data\mre_original');

%% load dicom and extract single images from mosaic (3x3) dicom
for f = 3:numel(files) % because 1st and 2nd is . and ..

    currentFile = fullfile(files(f).folder, files(f).name);
    
    img = double(dicomread(currentFile));

    s = size(img);

    nSlice = 9; % slices in one image
    w = s(1);   % image width
    h = s(2);    % image height

   %% split mosaic into 3d cube
   l = ceil(sqrt(nSlice));
   slices = mat2cell(img, (w/l) * ones(1,l), (h/l) * ones(1,l) );
   slices = transpose(slices);
   slices = cell2mat(slices(1:nSlice));
   cube(f-2,:,:,:) = reshape(slices,[w/l,h/l,nSlice]);

end





%% bring dimensions in the right order for unwrapping function
% img1 img2 slices timesteps (necesarry for proceding function calls)
cube = permute (cube, [2 3 4 1]);

% quick and dirty cleaning
% extract the dim3 = slices 1:5 / extract the dim4 =  phase images = 25:48
cube = cube(:,:,1:5,25:48);




%% smooth data
    parameters.smoothPhase.filter = 'gaussian';
    parameters.smoothPhase.size = [5 5 1]; %[pixel]
    parameters.smoothPhase.sd = 0.65; %[pixel] standard deviation

  cube = rescale(cube, -pi, pi); %need to be in range of -pi to pi for unwrapping
  
  % maybe also voxelsize = [220 216]/128; need to double check 
voxelsize = [216 220]/128; 

parameters.numberOfHarmonics = 1; % constant for this kind of acquisition
% this wavefield contains shear waves and compression waves
% but we are only interested in the shearwavefield displacement field

% lowpass filtering using butterworth to filter compression waves
parameters.radialFilter.lowpassThreshold = 100; %[1/m] butterworth threshold
parameters.radialFilter.lowpassOrder = 1; %butterworth order

cube_x=cube(:,:,:,1:8);
cube_y=cube(:,:,:,9:16);
cube_z=cube(:,:,:,17:24);

cube_3D(:,:,:,:,1)=cube_x;
cube_3D(:,:,:,:,2)=cube_y;
cube_3D(:,:,:,:,3)=cube_z;

smoothedPhase = smoothPhase(cube_3D, (parameters.smoothPhase));

% get voxel size from dicom image (open it therefore in text editor)
% sSliceArray.asSlice.__attribute__.size	 = 	128
% sSliceArray.asSlice[0].dThickness	 = 	2.0
% sSliceArray.asSlice[0].dPhaseFOV	 = 	216.0
% sSliceArray.asSlice[0].dReadoutFOV	 = 	220.0


wavefield = gradwrapFFT(smoothedPhase, voxelsize, parameters);

shearWaveField = radialFilter(wavefield, voxelsize, (parameters.radialFilter));
%shearWaveField is in Fourier Domain

%%

script_FVM_Alfonso(abs(shearWaveField));


%% example display
% nFile = 1;
% nImage = 1;
% 
% figure(1)
% minValue = min(abs(shearWaveField(:,:,nFile,nImage)),[], 'all');
% maxValue = max(abs(shearWaveField(:,:,nFile,nImage)),[], 'all');
% imshow(squeeze(abs(shearWaveField(:,:,nFile,nImage))), [minValue maxValue])