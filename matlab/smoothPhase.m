function smoothedPhase = smoothPhase(phase, parameters)

% get the dimensions
nSlice = size(phase,3);% number of slices
nTimestep = size(phase,4);% number of time steps
nComponent = size(phase,5);% number of components
nFrequency = size(phase,6);% number of frequencies

% loop for smoothing
smoothedPhase = zeros(size(phase));
for iFrequency = 1 : nFrequency
    for iComponent = 1: nComponent
        for iTimestep = 1 : nTimestep
            
            % create complex signal, smooth and extract the phase
            currentPhase = exp(1i*phase(:,:,:,iTimestep,iComponent,iFrequency));
            
            if nSlice > 1
                temp = smooth3(currentPhase, parameters.filter, parameters.size, parameters.sd);
            else % nSlice == 1
                currentPhase = repmat(currentPhase,[1 1 2]);
                temp = smooth3(currentPhase, parameters.filter, parameters.size, parameters.sd);
                temp = temp(:,:,1);
            end
            
            smoothedPhase(:,:,:,iTimestep,iComponent,iFrequency) = angle(temp);
            
        end
    end
end

end