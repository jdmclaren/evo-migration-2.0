% try

% if include wind, determine and update effective wind 
% if any compensation is involved
% if comp_HWs || comp_TWs_cst % == 1
   [tail_w(~finished), cross_w(~finished), del_alpha_dep(~finished)] = ...
       calc_wind_supprt_drft(alpha(~finished), u_wind(~finished), ...
          v_wind(~finished), N_S_migr, is_deps, ...
          over_water(~finished), lnd_wtr_ahd(~finished), ...
          comp_HWs_dep, comp_HWs_cst,  ...
          comp_TWs_dep, comp_TWs_cst, frc_cmp_dep, ...
          del_alpha_dep(~finished), mnt_TW_comp_wtr);
    % tail_w = calc_wind_supprt(alpha, u_wind, v_wind,N_S_migr);
% else
%     tail_w = zero_vec;
% end

w_sps = sqrt(u_wind.^2 + v_wind.^2);

% check if needs tailwinds before water crossing
if dep_TWs || (dep_wtr_TWs && any(tail_w(lnd_wtr_ahd) < 0)) || ...
      (any(w_sps > max_wsp_dep)) ||  (any(w_sps(lnd_wtr_ahd) > max_wsp_cst))
    
    any_waits = (dep_TWs & tail_w < 0) | ...
        w_sps > max_wsp_dep;
    cst_waits = lnd_wtr_ahd & ( (dep_wtr_TWs & tail_w) < 0  | ...
        w_sps > max_wsp_cst);

    idx_hi_w_hw = find(~finished & (any_waits | cst_waits));

    one_hws = ones(size(idx_hi_w_hw));
    true_hws = true(size(idx_hi_w_hw));
    

        hw_hi_s = idx_hi_w_hw;

        % hws = idx_hi_w_hw(island(ahead_theta(idx_hi_w_hw)*rad2deg, ...
        % ahead_llamda(idx_hi_w_hw)*rad2deg) == 0);
    
       while ~isempty(hw_hi_s) 

            if wind_form == 1 % constant wind str

                [u_wind(hw_hi_s), v_wind(hw_hi_s)] = ...
                   det_stoch_wind(theta(hw_hi_s),wind_str, ...
                   u_wind(hw_hi_s),v_wind(hw_hi_s),switch_wind_opt); % 

            else % Weibull 
    
                % need to first rescale previous winds
                % as Weibull most easily scaled to mean w sp in m/s
                [u_wind(hw_hi_s), v_wind(hw_hi_s)] = ...
                    det_stoch_wind_weib(theta(hw_hi_s), ...
                    weib_str_exp(hw_hi_s),weib_exp(hw_hi_s), ...
                    opt_stdy_swtch_ws, ...
                    u_wind(hw_hi_s)/wind_str, v_wind(hw_hi_s)/wind_str, ...
                    true_hws,false,p_stdy_w_updt); % d
                 u_wind(hw_hi_s) = wind_str*u_wind(hw_hi_s);
                 v_wind(hw_hi_s) = wind_str*v_wind(hw_hi_s);

                 % assume winds are uncorrelated since waiting multiple days
                 % and set is_w_switch to false


            end

            w_sps(hw_hi_s) = sqrt(u_wind(hw_hi_s).^2 + v_wind(hw_hi_s).^2);
           

            % tail_w(hw_hi_s) = calc_wind_supprt(alpha(hw_hi_s), ...
            % u_wind(hw_hi_s), v_wind(hw_hi_s),N_S_migr);

            date_jul(hw_hi_s) = date_jul(hw_hi_s) + 1;
%                     date_nrs(hw_hi_s) = date_nrs(hw_hi_s) + 1;
            
            % tail_w(hw_hi_s) = calc_wind_supprt(alpha(hw_hi_s), ...
            %     u_wind(hw_hi_s), v_wind(hw_hi_s),N_S_migr);

            % calc TW assist without compensation effects (computationally
            % efficient)

            % 2024 now maintain any adj to wtr while selecting
            [tail_w(hw_hi_s)] = calc_wind_supprt_drft ...
               (alpha(hw_hi_s), u_wind(hw_hi_s), ...
               v_wind(hw_hi_s), N_S_migr, is_deps, over_water(hw_hi_s), ...
               lnd_wtr_ahd(hw_hi_s), false, false, false, false, ...
               NaN, del_alpha_dep(hw_hi_s), true); 

          % comp_HWs_dep, comp_HWs_cst,  ...
          % comp_TWs_dep, comp_TWs_cst, frc_cmp_dep, ...
          % del_alpha_dep(~finished), mnt_TW_comp_wtr);

          any_wait_hws = (dep_TWs & tail_w(hw_hi_s) < 0) | ...
                w_sps(hw_hi_s) > max_wsp_dep;
          cst_wait_hws = lnd_wtr_ahd(hw_hi_s) & ( (dep_wtr_TWs & tail_w(hw_hi_s)) < 0  | ...
                w_sps(hw_hi_s) > max_wsp_cst);

          hw_hi_s = hw_hi_s(any_wait_hws | ...
               cst_wait_hws);

          true_hws = true_hws(any_wait_hws | ...
               cst_wait_hws);
                        
       end

       % now add possible compensation
       if comp_HWs_dep || comp_TWs_dep || comp_HWs_cst || comp_TWs_cst
          [tail_w(idx_hi_w_hw), cross_w(idx_hi_w_hw), del_alpha_dep(idx_hi_w_hw)] = ...
              calc_wind_supprt_drft(alpha(idx_hi_w_hw), u_wind(idx_hi_w_hw), ...
           v_wind(idx_hi_w_hw), N_S_migr, is_deps, over_water(idx_hi_w_hw),  ...
           lnd_wtr_ahd(idx_hi_w_hw), comp_HWs_dep, comp_HWs_cst,  ...
          comp_TWs_dep, comp_TWs_cst, frc_cmp_dep, ...
          del_alpha_dep(idx_hi_w_hw), mnt_TW_comp_wtr);
       end
    
end

% catch
% 
%     keyboard
% 
% end
