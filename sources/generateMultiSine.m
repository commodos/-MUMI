function [U] = generateMultiSine(N,M,phase,f0,tau,lines,gain_on_lines)
%GenerateMultiSine is a function to generate random phase multisine
%   N: number of samples in a block
%   M: number of realizations
%   U => excitation signal in frequency domain, single sided
%
%   Copyright (c) Péter Zoltán Csurcsia, September 2010

   U = zeros(M,N);
   
   F=length(lines);    
   k=lines;
   if(isempty(gain_on_lines))
       gain_on_lines=1;
   else
       gain_on_lines=repmat(gain_on_lines,M,1);
   end
    omega_k = tau*2*f0*pi*(k-1);  
    switch phase
        case 'linear'
            U(:,lines) = gain_on_lines.*exp(-1i*repmat(omega_k,M,1));   
        case 'random'
            U(:,lines) = gain_on_lines.*exp(-1i*rand(M,F)*2*pi);   
        case 'schroeder'         
            U(:,lines) = gain_on_lines.*exp(-1i*repmat(k.*(k-1)*pi./F,M,1));   
    end

    
end