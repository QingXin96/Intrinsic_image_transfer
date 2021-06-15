function I = VectorToImage(Y,S,C,param)

    scale               = param.scale;
    color_space         = param.color_space;
    logarithm           = param.logarithm;
    color_transfer      = param.color_transfer;
    color_exemplar      = param.color_exemplar;
    
    [rows,cols,layers]  = size(S);
    if (strcmp(color_space,'hsv'))
        if (strcmp(color_exemplar,'original'))
            hsv_S           = rgb2hsv(S);
        elseif (strcmp(color_exemplar,'exemplar'))
            hsv_S           = rgb2hsv(C);
        end
        
        if(color_transfer)
            hsv_S(:,:,1:2) = reshape(Y,[rows,cols, 2]);
        else
            v           = Y;
            if (logarithm)
                v       = min(1,max(0,(exp(-v)/scale)));
            end
            hsv_S(:,:,3)= reshape(v,[rows,cols, 1]);
        end
        I               = hsv2rgb(hsv_S);
    elseif (strcmp(color_space,'lab'))
        if (strcmp(color_exemplar,'original'))
            lab_S           = rgb2lab(S);
        elseif (strcmp(color_exemplar,'exemplar'))
            lab_S           = rgb2lab(C);
        end
        if(color_transfer)
            lab_S(:,:,2:3) = reshape(Y,[rows,cols, 2]);
        else
            L           = Y;
            if (logarithm)
                L       = min(1,max(0,exp(-L)/scale));
            end
            lab_S(:,:,1)    = reshape(100*L,[rows,cols, 1]);
        end
        I               = lab2rgb(lab_S);
    elseif (strcmp(color_space,'Ycbcr'))
        if (strcmp(color_exemplar,'original'))
            Ycbcr_S           = rgb2ycbcr(S);
        elseif (strcmp(color_exemplar,'exemplar'))
            Ycbcr_S           = rgb2ycbcr(C);
        end
        if(color_transfer)
            Ycbcr_S(:,:,2:3) = reshape(Y,[rows,cols, 2]);
        else
            L           = Y;
            if (logarithm)
                L       = min(1,max(0,exp(-L)/scale));
            end
            Ycbcr_S(:,:,1)    = reshape(L,[rows,cols, 1]);
        end
        I               = ycbcr2rgb(Ycbcr_S);
    else
        if (logarithm)
            Y           = min(1,max(0,(exp(-Y)/scale)));
        end
        I = reshape(Y,[rows,cols,layers]);
    end
end