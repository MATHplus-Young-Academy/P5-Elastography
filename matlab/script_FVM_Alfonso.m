function script_FVM_Alfonso(U)

% load('../data/displacementField.mat')
% U=abs(shearWaveField);

% load('../data/synthetic/square/sim.mat')

% simulated frequencies: 50Hz, 60Hz, 70Hz and 80Hz
% freq = [50,60,70,80];
freq=20;

% some physical parameters
dx  = 1e-3; % 1 mm
dy  = 1e-3;
dz  = 1e-3;
rho = 1e+3; % 1 g/cm^3

% Color axis limits
Gmin = 2.5e3; %  2.5 KPa
Gmax = 1.05e4;% 10.5 KPa



%%

U_plot=squeeze(U(:,:,1,1,1,1));

figure(1)
imshow(U_plot,[min(U_plot(:)),max(U_plot(:))])


%%

[nx,ny,nz,nt,nenc,nf]  = size(U);

% U_fft = fft(U,[],4);
% Uc    = squeeze(abs(U_fft(:,:,:,2,:,:)));
% [X,Y,Z] = meshgrid(0:nx*dx:dx,0:ny*dy:dy,0:nz*dz:dz);
Uc=squeeze(abs(U(:,:,:,2,:,:)));

Uc_plot=squeeze(Uc(:,:,1,1,1,1));

figure(2)
imshow(Uc_plot,[min(Uc_plot(:)),max(Uc_plot(:))])

%%

f = 1;
% Ux = squeeze(Uc(:,:,:,2,:));
% Uy = squeeze(Uc(:,:,:,1,:));
% Uz = squeeze(Uc(:,:,:,3,:));
Ux = Uc(:,:,:,2,f);
Uy = Uc(:,:,:,1,f);
Uz = Uc(:,:,:,3,f);

% RB_cube=zeros(nx+2,ny+2,nz+2);
% 
% Ux_RB=RB_cube;
% Ux_RB(2:nx+1,2:ny+1,2:nz+1)=Ux;
% Uy_RB=RB_cube;
% Uy_RB(2:nx+1,2:ny+1,2:nz+1)=Uy;
% Uz_RB=RB_cube;
% Uz_RB(2:nx+1,2:ny+1,2:nz+1)=Uz;

G=zeros(nx,ny,nz);

%
for i = 2:nx-1
    for j = 2:ny-1
        for k = 2:nz-1
            volume = dx*dy*dz;
            p = [Ux(i,j,k)*volume, Uy(i,j,k)*volume, Uz(i,j,k)*volume];
            
            dV = [dx,dy,dz];
            Uxxy = DUdxdy(Ux,dV,i,j,k);
            Uyxy = DUdxdy(Uy,dV,i,j,k);
            Uzxy = DUdxdy(Uz,dV,i,j,k);
            Uxxz = DUdxdz(Ux,dV,i,j,k);
            Uyxz = DUdxdz(Uy,dV,i,j,k);
            Uzxz = DUdxdz(Uz,dV,i,j,k);
            Uxyz = DUdydz(Ux,dV,i,j,k);
            Uyyz = DUdydz(Uy,dV,i,j,k);
            Uzyz = DUdydz(Uz,dV,i,j,k);
            bx = [Uxyz(1), 0.5*(Uxyz(2)+Uyyz(1)), 0.5*(Uxyz(3)+Uzyz(1))];
            by = [0.5*(Uxxz(2)+Uyxz(1)), Uyxz(2), 0.5*(Uyxz(3)+Uzxz(2))];
            bz = [0.5*(Uxxy(3)+Uzxy(1)), 0.5*(Uyxy(3)+Uzxy(2)), Uzxy(3)];
            for n=[1,2,3]
                b(n) = bx(n) + by(n)+ bz(n);
            end
            % Evaluation of shear modulus
            G(i,j,k) = -rho*(2*pi*freq(f)).^2./abs(dot(b,b))*abs(dot(b,p));
        end
    end
end
% for i = 2:nx+1
%     for j = 2:ny+1
%         for k = 2:nz+1
%             volume = dx*dy*dz;
%             p = [Ux_RB(i,j,k)*volume, Uy_RB(i,j,k)*volume, Uz_RB(i,j,k)*volume];
%             
%             dV = [dx,dy,dz];
%             Uxxy = DUdxdy(Ux_RB,dV,i,j,k);
%             Uyxy = DUdxdy(Uy_RB,dV,i,j,k);
%             Uzxy = DUdxdy(Uz_RB,dV,i,j,k);
%             Uxxz = DUdxdz(Ux_RB,dV,i,j,k);
%             Uyxz = DUdxdz(Uy_RB,dV,i,j,k);
%             Uzxz = DUdxdz(Uz_RB,dV,i,j,k);
%             Uxyz = DUdydz(Ux_RB,dV,i,j,k);
%             Uyyz = DUdydz(Uy_RB,dV,i,j,k);
%             Uzyz = DUdydz(Uz_RB,dV,i,j,k);
%             bx = [Uxyz(1), 0.5*(Uxyz(2)+Uyyz(1)), 0.5*(Uxyz(3)+Uzyz(1))];
%             by = [0.5*(Uxxz(2)+Uyxz(1)), Uyxz(2), 0.5*(Uyxz(3)+Uzxz(2))];
%             bz = [0.5*(Uxxy(3)+Uzxy(1)), 0.5*(Uyxy(3)+Uzxy(2)), Uzxy(3)];
%             for n=[1,2,3]
%                 b(n) = bx(n) + by(n)+ bz(n);
%             end
%             % Evaluation of shear modulus
%             G(i-1,j-1,k-1) = -rho*(2*pi*freq(f)).^2/abs(dot(b,b))*abs(dot(b,p));
%         end
%     end
% end

%%

%% example display
nFile = 2;
% nImage = 1;

figure(3)
minValue = min(abs(G(:,:,nFile)),[], 'all');
maxValue = max(abs(G(:,:,nFile)),[], 'all');
imshow(squeeze(abs(G(:,:,nFile))), [minValue maxValue])
% imshow(squeeze(abs(G(:,:,nFile))), [2000 12000])
colormap parula

% 
% figure(3)
% imshow(abs(G(:,:,1)),[2000 12000])


