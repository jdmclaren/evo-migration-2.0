function [inher_heads, zugkn_inher_heads, zug_signps] = ...
    det_phentyp(allel_heads,allel_zugs,allel_sps, ...
    idx_avgs,idx_1s,idx_2s,N_avgs,N_1s,N_2s,n_zugs,zug_signp,Dom_phen,n_heads)

    if n_heads == 1 % 'sign' of direction (E/W, CW/CCW) determined by genes
        sgn_hds = Dom_phen - ~Dom_phen;
        sgn_zgs = -sgn_hds;
    else
        sgn_hds = ones(size(Dom_phen));
        sgn_zgs = sgn_hds;
    end

    if N_avgs > 0
        inher_heads(idx_avgs,1) = -sgn_hds(idx_avgs,1).*circ_mean([allel_heads(idx_avgs,1) allel_heads(idx_avgs,2)]')';
    end
    if N_1s > 0
        inher_heads(idx_1s,1) = -sgn_hds(idx_1s,1).*allel_heads(idx_1s,1);
    end
    if N_2s > 0
        inher_heads(idx_2s,1) = -sgn_hds(idx_2s,1).*allel_heads(idx_2s,2);
    end    

inher_heads = mod(inher_heads + pi,2*pi) - pi;

% now zugknick heads 

if n_zugs > 0

    % need to inherit zugkn dirns as well
    % magncl cases dealt with below after
    % defining inher_heads via inherited projections
    for iirz = 1:n_zugs % numel(reqs_zug)-1
    
    %     try
        if N_avgs > 0
             zugkn_inher_heads(idx_avgs,iirz) =  ...
                sgn_hds(idx_avgs,1).*circ_mean([allel_zugs(idx_avgs,1,iirz)  ...
                allel_zugs(idx_avgs,2,iirz)]')'; % , [N_inds 1]);

             if zug_signp <= 2 
                zug_signps(idx_avgs,iirz) =  ...
                    circ_mean([allel_sps(idx_avgs,1,iirz)  ...
                    allel_sps(idx_avgs,2,iirz)]')'; 
             else
                zug_signps(idx_avgs,iirz) =  ...
                    mean([allel_sps(idx_avgs,1,iirz)  ...
                    allel_sps(idx_avgs,2,iirz)]')'; 
             end
        end
    %     catch
    %         keyboard
    %     end
        
        if N_1s > 0
            zugkn_inher_heads(idx_1s,iirz) =  ...
                sgn_hds(idx_1s,1).*allel_zugs(idx_1s,1,iirz); % , [N_inds 1]);
            zug_signps(idx_1s,iirz) =  allel_sps(idx_1s,1,iirz);
        end
    
        if N_2s > 0
            zugkn_inher_heads(idx_2s,iirz) =  ...
                sgn_hds(idx_2s,1).*allel_zugs(idx_2s,2,iirz); % , [N_inds 1]);
            zug_signps(idx_2s,iirz) =  allel_sps(idx_2s,2,iirz);
        end
    
    end

else

    zugkn_inher_heads = NaN(size(inher_heads));
    zug_signps = NaN(size(inher_heads));

end