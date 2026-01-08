function [inher_heads, zugkn_inher_heads, zug_signps] = ...
    det_phentyp_2_chrms(allel_heads,allel_zugs,allel_sps, ...
    zug_signp,idx_avg_ms,idx_1ms,idx_2ms,N_avg_ms,N_1ms,N_2ms, ...
    idx_avg_ts,idx_1ts,idx_2ts,N_avg_ts,N_1ts,N_2ts,n_zugs)

    if N_avg_ms > 0
        inher_heads(idx_avg_ms,1) = circ_mean([allel_heads(idx_avg_ms,1,2) allel_heads(idx_avg_ms,2,2)]')';
    end
    if N_1ms > 0
        inher_heads(idx_1ms,1) = allel_heads(idx_1ms,1,2);
    end
    if N_2ms > 0
        inher_heads(idx_2ms,1) = allel_heads(idx_2ms,2,2);
    end    

    if N_avg_ts > 0
        inher_heads(idx_avg_ts,1) = circ_mean([allel_heads(idx_avg_ts,1,1) allel_heads(idx_avg_ts,2,1)]')';
    end
    if N_1ts > 0
        inher_heads(idx_1ts,1) = allel_heads(idx_1ts,1,1);
    end
    if N_2ts > 0
        inher_heads(idx_2ts,1) = allel_heads(idx_2ts,2,1);
    end    

inher_heads = mod(inher_heads + pi,2*pi) - pi;

% now zugknick heads 

if n_zugs > 0

    % need to inherit zugkn dirns as well
    % magncl cases dealt with below after
    % defining inher_heads via inherited projections
    for iirz = 1:n_zugs % numel(reqs_zug)-1
    
    %     try
        if N_avg_ms > 0
             zugkn_inher_heads(idx_avg_ms,iirz) =  ...
                circ_mean([allel_zugs(idx_avg_ms,1,2,iirz)  ...
                allel_zugs(idx_avg_ms,2,2,iirz)]')'; % , [N_inds 1]);
             if zug_signp <= 2 
                zug_signps(idx_avg_ms,iirz) =  ...
                    circ_mean([allel_sps(idx_avg_ms,1,2,iirz)  ...
                    allel_sps(idx_avg_ms,2,2,iirz)]')'; 
             else
                zug_signps(idx_avg_ms,iirz) =  ...
                    mean([allel_sps(idx_avg_ms,1,2,iirz)  ...
                    allel_sps(idx_avg_ms,2,2,iirz)]')'; 
             end
        end


    %     catch
    %         keyboard
    %     end
        
        if N_1ms > 0
            zugkn_inher_heads(idx_1ms,iirz) =  ...
                allel_zugs(idx_1ms,1,2,iirz); % , [N_inds 1]);
            zug_signps(idx_1ms,iirz) =  allel_sps(idx_1ms,1,2,iirz);
        end
    
        if N_2ms > 0
            zugkn_inher_heads(idx_2ms,iirz) =  ...
                allel_zugs(idx_2ms,2,2,iirz); % , [N_inds 1]);
            zug_signps(idx_2ms,iirz) =  allel_sps(idx_2ms,2,2,iirz);
        end

        if N_avg_ts > 0
             zugkn_inher_heads(idx_avg_ts,iirz) =  ...
                circ_mean([allel_zugs(idx_avg_ts,1,1,iirz)  ...
                allel_zugs(idx_avg_ts,2,1,iirz)]')'; % , [N_inds 1]);
            zug_signps(idx_avg_ts,iirz) =  ...
                circ_mean([allel_sps(idx_avg_ts,1,1,iirz)  ...
                allel_sps(idx_avg_ts,2,1,iirz)]')'; 
        end
    %     catch
    %         keyboard
    %     end
        
        if N_1ts > 0
            zugkn_inher_heads(idx_1ts,iirz) =  ...
                allel_zugs(idx_1ts,1,1,iirz); % , [N_inds 1]);
            zug_signps(idx_1ts,iirz) =  allel_sps(idx_1ts,1,1,iirz);
        end
    
        if N_2ts > 0
            zugkn_inher_heads(idx_2ts,iirz) =  ...
                allel_zugs(idx_2ts,2,1,iirz); % , [N_inds 1]);
            zug_signps(idx_2ts,iirz) =  allel_sps(idx_2ts,2,1,iirz);
        end
    
    end

else

    zugkn_inher_heads = NaN*size(inher_heads);
    zug_signps = NaN*size(inher_heads);

end