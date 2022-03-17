clear all;

files = dir('C:\Users\matth\OneDrive\Desktop\work\Hackathon\data\mre_original');

for f = 3:numel(files)

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

%% example display
nFile = 1;
nImage = 1;

nMin = min(cube(nFile,:,:,nImage), 'all')
imshow(squeeze(cube(nFile,:,:,nImage)))