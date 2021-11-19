function [ f, g, gain_on_lines ] = GenerateDecadeBand(fmin,fmax,gaindB,f0,lines)
%GenerateOctaveBand generates an octave band and set the magnitude values
%of the excitation specturm of multisines

    f(1)=fmin;
    g(1)=1;
    
     if(~exist('gaindB'))
        gaindB=0;
     end 
    
    gain=db2mag(gaindB);
    
    while f(end)<fmax
        f(end+1)=f(end)*10;
        g(end+1)=g(end)*gain;
    end
    
    if(exist('f0')==1 && exist('lines')==1)
        gain_on_lines=zeros(size(lines));
        f_scale=f0*(lines-1);
        
        for i=1:length(f)-1
            [c index1]=min(abs(f_scale-f(i)));
            [c index2]=min(abs(f_scale-f(i+1)));
            if(i==length(f)-1 &&  f(end)>=f_scale(end)+max(diff(f_scale)));
                c=linspace(g(i),g(i+1),index2+(f(end)-f(end-1))/f0-index1+1);
                gain_on_lines(index1:index2)=c(1:index2-index1+1);
            else
                gain_on_lines(index1:index2)=linspace(g(i),g(i+1),index2-index1+1);
            end
        end
     end

end

