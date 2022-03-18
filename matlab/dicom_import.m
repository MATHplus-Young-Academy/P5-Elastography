clear all;

% path to folder with dicom data
files = dir('C:\Users\matth\OneDrive\Desktop\work\Hackathon\data\mre_original');
% files = dir('C:\Users\matth\OneDrive\Desktop\work\Hackathon\data\mre_original_nii\IRMRE\f191125112201STD1312211075243167072-0045-00001-000001-01.nii');


%% load dicom and extract single images from mosaic (3x3) dicom
for f = 3:numel(files) % because 1st and 2nd is . and ..

    currentFile = fullfile(files(f).folder, files(f).name);
    
    img = double(dicomread(currentFile));

    s = size(img);

    nSlice = 9; % slices in one image
    w = s(1);   % image width
    h = s(2)    % image height

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
  smoothedPhase = smoothPhase(cube, (parameters.smoothPhase));

% get voxel size from dicom image (open it therefore in text editor)
% or with dicom viewer and search for tag (0028,0030) 
voxelsize = [2 2]/1000; % in plane resolutio in meter

parameters.numberOfHarmonics = 1; % constant for this kind of acquisition
% this wavefield contains shear waves and compression waves
% but we are only interested in the shearwavefield displacement field
wavefield = gradwrapFFT(smoothedPhase, voxelsize, parameters);

% lowpass filtering using butterworth to filter compression waves
parameters.radialFilter.lowpassThreshold = 100; %[1/m] butterworth threshold
parameters.radialFilter.lowpassOrder = 1; %butterworth order
shearWaveField = radialFilter(wavefield, voxelsize, (parameters.radialFilter));
%shearWaveField is in Fourier Domain


%% example display
nFile = 1;
nImage = 1;

minValue = min(cube(:,:,nImage,nFile),[], 'all')
maxValue = max(cube(:,:,nImage,nFile),[], 'all')
imshow(squeeze(cube(:,:,nImage,nFile)), [minValue maxValue])