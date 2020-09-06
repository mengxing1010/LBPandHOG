function assin = fourier_rad_ang(I)

[M N] = size(I);
if(M~=N)
    minimo = min([M N]);
    I=imresize(I,[minimo minimo]);
end

assin = [];
[M N] = size(I);
IF = abs(fftshift(fft2(I)));


% obter matriz de raios e separa�oes angulares
[r, f] = sep_angulares(M, 4);


%calculo da assinatura
for ang = 0:7
    
    [mi, mf, ni, nf] = quadrante(ang, M, N);
    mini = IF(mi:mf, ni:nf);
    minir = r(mi:mf, ni:nf);
    minif = f(mi:mf, ni:nf);
    
    for freq_radial = [3 6 9 12 15 18 21 24]; %[5 10 15 20 30 40 50 60];
        
        minir_ = minir <= freq_radial;
        minif_ = minif == rem(ang,2);
        final = and(minir_, minif_);
        assin = [assin, sum(mini(find(final)))];   
        
    end
end 
 
end



function [r, f1] = sep_angulares(size, spokes)

hsup = (size-1)/2; % size controls the resolution
[x,y] = meshgrid([-hsup:hsup]);

[THETA, r] = cart2pol(x,y);

f1 = sin(THETA*spokes);   % 1st radial filter
f1 = f1 >= 0;   

end


function [mi, mf, ni, nf] = quadrante(dir, M, N)

if (dir == 0 || dir == 1)
    mi = 1;
    mf = M/2;
    ni = N/2+1;
    nf = N;
end

if (dir == 2 || dir == 3)
    mi = 1;
    mf = M/2;
    ni = 1;
    nf = N/2;
end

if (dir == 4 || dir == 5)
    mi = M/2+1;
    mf = M;
    ni = 1;
    nf = N/2;
end

if (dir == 6 || dir == 7)
    mi = M/2+1; 
    mf = M;
    ni = N/2+1;
    nf = N;
end

end