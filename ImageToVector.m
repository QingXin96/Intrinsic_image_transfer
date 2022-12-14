function [X,P,T]=ImageToVector(I,param)

    color_transfer       = param.color_transfer;
    color_space          = param.color_space;
    logarithm            = param.logarithm; 
    scale                = param.scale; 
    bias                 = param.bias;
    
    [rows, cols, layers] = size(I);
    Px             	     = repmat([1:rows]',1,cols);
    Py             	     = repmat([1:cols], rows,1); 
    P                    = [Px(:),Py(:)];
    
    if (strcmp(color_space,'hsv'))
        hsv_I            = rgb2hsv(I);
        v                = hsv_I(:,:,3);
        if color_transfer
            X            = reshape(hsv_I(:,:,1:2),[rows*cols,2]);
        else
            if (logarithm)
               %v(v==0)  = eps;
                v        = -log(bias+scale*v);
            end
            X            = reshape(v,[rows*cols,1]);
        end
    elseif (strcmp(color_space,'lab'))
        Lab_I            = rgb2lab(I);
        L                = Lab_I(:,:,1)/100.0;
        if color_transfer
            X            = reshape(Lab_I(:,2:3),[rows*cols,2]);
        else
            if (logarithm)
               %L(L==0)  = eps;
                L        = -log(bias+scale*L);
            end
            X            = reshape(L,[rows*cols,1]);
        end
     elseif (strcmp(color_space,'Ycbcr'))
        Ycbcr_I          = rgb2ycbcr(I);
        L                = Ycbcr_I(:,:,1);
        if color_transfer
            X            = reshape(Ycbcr_I(:,2:3),[rows*cols,2]);
        else
            if (logarithm)
               %L(L==0)  = eps;
                L        = -log(bias+scale*L);
            end
            X            = reshape(L,[rows*cols,1]);
        end
    else
        if (logarithm)
           %I(I==0)      = eps;
            I            = -log(bias+scale*I);
        end
        X_g              = reshape(I,[rows*cols,layers]);
        X                = X_g;
    end
end
