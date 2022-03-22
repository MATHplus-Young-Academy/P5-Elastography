function Du= DUdxdy(u,D,i,j,k)
    Du = zeros(1,3);
%     if i>1 && i<80 && j>1 && j<80 && k>1 && k<5
        Du(1) = 0.25*D(2)*(u(i-1,j,k+1) + u(i+1,j,k-1) - u(i+1,j,k+1) - u(i-1,j,k-1));
        Du(2) = 0.25*D(1)*(u(i,j-1,k+1) + u(i,j+1,k-1) - u(i,j-1,k-1) - u(i,j+1,k+1));
        Du(3) = D(1)*D(2)/D(3)*(u(i,j,k+1) - 2*u(i,j,k) + u(i,j,k-1));
%     end
end