head_bins =  5*pi/180; % pi/12; % pi/6; % pi/9; %  
max_dtr =  30*pi/180; % 3*pi/8; % 2*pi/3; % 
n_bins = floor(max_dtr/head_bins);
hd_adj = (head_bins:head_bins:n_bins*head_bins);

prev_del_alph_dtr = del_alph_dtr;
del_alph_dtr = zero_vec;

chck_ahd = can_dtr;
idx_chck_ahd = find(chck_ahd);

% first check where pref dirs alpha result in flight over ocean 
% then check where land in sight (ignore wind)

one_chk = ones(size(idx_chck_ahd));
zero_chk = zeros(size(idx_chck_ahd));

if ~isempty(idx_chck_ahd)
    
    [ahead_theta, ahead_llamda] = update_loc(...
    one_chk,radAheadDtrCst,theta(idx_chck_ahd), ...
    llamda(idx_chck_ahd),alpha(idx_chck_ahd),N_S_migr,zero_chk,zero_chk, ...
    star_cmp_flag,decln(idx_chck_ahd),date_jul(idx_chck_ahd),geomagn_model);

    % ahead_wtr = island(ahead_theta*rad2deg, ahead_llamda*rad2deg) == 0;

    idx_cst_ahd = near_idx_cst(llamda(idx_chck_ahd)*180/pi,theta(idx_chck_ahd)*180/pi);
    % end
    d_csts_ahd = d_cst_vec(idx_cst_ahd);
    
    ahead_wtr_chck = d_csts_ahd < 0; 

    eps = 1e-10;

    ahd_lat_deg_idx = round(ahead_theta*rad2deg + 90.5 - eps);
    ahd_lon_deg_idx = round(ahead_llamda*rad2deg + 180.5 - eps);
    ahd_hi_elev = hi_elevs(sub2ind([180 360],ahd_lat_deg_idx,ahd_lon_deg_idx));

    dtr_ahd= idx_chck_ahd(ahead_wtr_chck | ahd_hi_elev);

    %                 catch
    %                     keyboard
    %                 end
    if numel(dtr_ahd) > 0

    %     if sum(can_dtr) > 0 % check detour angle bins along coast

        %         tic
    
        % predefine "broadcast" variables
        alph_dtr = alpha(dtr_ahd);
        ll_dtr = repmat(llamda(dtr_ahd),[1 n_bins]);
        th_dtr = repmat(theta(dtr_ahd),[1 n_bins]);
        uw_dtr = repmat(uw_eff(dtr_ahd),[1 n_bins]);
        vw_dtr = repmat(vw_eff(dtr_ahd),[1 n_bins]);
        decl_dtr = repmat(decln(dtr_ahd),[1 n_bins]);
        date_dtr = repmat(date_jul(dtr_ahd),[1 n_bins]);
        ones_dtr = ones([1 n_bins]);
    %     al_ahd = alpha(dtr_ahd);

%     try

       for i_dtr = 1:numel(dtr_ahd) % par
            % search in e.g. <= 10 deg bins  
            %  here, 9 on either side of pref heading
            % (clock/anti-clockwise)

            alpha_bins_clws = alph_dtr(i_dtr)+hd_adj;
            alpha_bins_anticlws = alph_dtr(i_dtr)-hd_adj;

            % locs if a further hrsAheadDtrCst away
            %  (~100-200 km if 2 hrs) Here ignore wind, include_wind = 0
            [ahead_theta_clws, ahead_llamda_clws] = update_loc(...
                ones_dtr,radAheadDtrCst,th_dtr(i_dtr,:), ...
                ll_dtr(i_dtr,:),alpha_bins_clws,N_S_migr, ...
                uw_dtr(i_dtr,:),vw_dtr(i_dtr,:), ...
                star_cmp_flag,decl_dtr(i_dtr,:),date_dtr(i_dtr,:),geomagn_model);
            
            [ahead_theta_anticlws, ahead_llamda_anticlws] = update_loc(...
                ones_dtr,radAheadDtrCst,th_dtr(i_dtr,:), ...
                ll_dtr(i_dtr,:),alpha_bins_anticlws,N_S_migr, ...
                uw_dtr(i_dtr,:),vw_dtr(i_dtr,:), ...
                star_cmp_flag,decl_dtr(i_dtr,:),date_dtr(i_dtr,:),geomagn_model);

%                                 over_water_clws  = ...
%                                     land_or_ocean(ahead_theta_clws*rad2deg, ...
%                                     ahead_llamda_clws*rad2deg,cst_accuracy) == 1;   
%                                  over_water_anticlws  = ...
%                                     land_or_ocean(ahead_theta_anticlws*rad2deg, ...
%                                     ahead_llamda_anticlws*rad2deg,cst_accuracy) == 1; 

%                 ahd_water_s  = ...
%                     island([ahead_theta_clws ahead_theta_anticlws]*rad2deg, ...
%                     [ahead_llamda_clws ahead_llamda_anticlws]*rad2deg) == 0;

            % ahd_water_s  = ...
            %     interp2(Coast.lon,Coast.lat,Coast.land,...
            %     [ahead_llamda_clws ahead_llamda_anticlws]*rad2deg, ...
            %     [ahead_theta_clws ahead_theta_anticlws]*rad2deg,'nearest',0);

            idx_cst_ahd = near_idx_cst([ahead_llamda_clws ahead_llamda_anticlws]*rad2deg, ...
                [ahead_theta_clws ahead_theta_anticlws]*rad2deg);
            % end
            d_csts_ahd = d_cst_vec(idx_cst_ahd)';
            
            ahd_water_s = d_csts_ahd < 0; 

            ahd_lats_idx = round([ahead_theta_clws ahead_theta_anticlws]*rad2deg + 90.5 - eps);
            ahd_lons_idx = round([ahead_llamda_clws ahead_llamda_anticlws]*rad2deg + 180.5 - eps);
            ahd_hi_s = hi_elevs(sub2ind([180 360],ahd_lats_idx,ahd_lons_idx));

%                 dtr_ahd_clws = ahd_water_s(1:n_bins) | ahd_hi_s(n_bins+1:2*n_bins);
%                 dtr_ahd_anticlws = ahd_water_s(n_bins+1:2*n_bins) | ahd_hi_s(1:n_bins);
            
            dtr_ahd_clws = ahd_water_s(1:n_bins) | ahd_hi_s(1:n_bins);
            dtr_ahd_anticlws = ahd_water_s(n_bins+1:2*n_bins) | ahd_hi_s(n_bins+1:2*n_bins);
            
%                 ahd_water_clws  = ...
%                     island(ahead_theta_clws*rad2deg, ...
%                     ahead_llamda_clws*rad2deg) == 0;
% ´
%                 ahd_lat_clw_idx = round(ahead_theta_clws*rad2deg + 90.5 - eps);
%                 ahd_lon_clw_idx = round(ahead_llamda_clws*rad2deg + 180.5 - eps);
%                 ahd_hi_clws = elev_bathy(sub2ind(size(elev_bathy),ahd_lat_clw_idx,ahd_lon_clw_idx)) > elev_thr;
% 
%                 dtr_ahd_clws = ahd_water_clws | ahd_hi_clws;
% 
%                tic;   ahd_water_anticlws  = ...
%                     island(ahead_theta_anticlws*rad2deg, ...
%                     ahead_llamda_anticlws*rad2deg) == 0; toc
% 
%                 ahd_lat_anticlw_idx = round(ahead_theta_anticlws*rad2deg + 90.5 - eps);
%                 ahd_lon_anticlw_idx = round(ahead_llamda_anticlws*rad2deg + 180.5 - eps);
%                 ahd_hi_anticlws = elev_bathy(sub2ind(size(elev_bathy),ahd_lat_anticlw_idx,ahd_lon_anticlw_idx)) > elev_thr;
% 
%                 dtr_ahd_anticlws = ahd_water_anticlws | ahd_hi_anticlws;
% 
              % first, choose 'closest' pref dir 
              % towards meridian for which land in
              %  sight on horizon
              if (dtrCstStr ~= 7 && alph_dtr(i_dtr) >= 0) || ...
                      (dtrCstStr == 7 && alph_dtr(i_dtr) < 0)
                land_pref_bins{i_dtr} = find(dtr_ahd_anticlws == 0);
                n_land_pref(i_dtr) = numel(land_pref_bins{i_dtr});
                ahead_alpha_prefs{i_dtr} = alpha_bins_anticlws;
                land_opp_bins{i_dtr} = find(dtr_ahd_clws == 0);
                n_land_opp(i_dtr) = numel(land_opp_bins{i_dtr});
                ahead_alpha_opps{i_dtr} = alpha_bins_clws;
              else
                land_pref_bins{i_dtr} = find(dtr_ahd_clws == 0);
                n_land_pref(i_dtr) = numel(land_pref_bins{i_dtr});
                ahead_alpha_prefs{i_dtr} = alpha_bins_clws;
                land_opp_bins{i_dtr} = find(dtr_ahd_anticlws == 0);
                n_land_opp(i_dtr) = numel(land_opp_bins{i_dtr});
                ahead_alpha_opps{i_dtr} = alpha_bins_anticlws;
              end

              med_land_pref(i_dtr) = floor(median(land_pref_bins{i_dtr}));
%                                       first_land_pref = land_pref_bins(1);
              med_land_opp(i_dtr) = floor(median(land_opp_bins{i_dtr}));


       end

   % now check for 'allowable' detours to prevent for open ocean flight

       for i_dtr = 1:numel(dtr_ahd)

         if dtrCstStr == 4 % choose closest angle, pref first
               
               if n_land_pref(i_dtr) > 0 
                   
                   if n_land_opp(i_dtr) > 0
                       
                        if land_pref_bins{i_dtr}(1) <= land_opp_bins{i_dtr}(1) % min(n_land_opp(i_dtr),2)) % 
                            % take 1st pref
                            
                              alpha_new = ahead_alpha_prefs{i_dtr}(land_pref_bins{i_dtr}(1));

                              del_alph_dtr(dtr_ahd(i_dtr)) = ...
                                  mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                              alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;

                                nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                                mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr + ...
                                   land_pref_bins{i_dtr}(1)*head_bins)/(nCmpDtr+1);
                               toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                               fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                               cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;
                            
                        else % take 1st opp
                            
                             alpha_new = ahead_alpha_opps{i_dtr}(land_opp_bins{i_dtr}(1));
                      
                              del_alph_dtr(dtr_ahd(i_dtr)) = ...
                                  mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                              alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;


                              nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                              mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr - ...
                                   land_opp_bins{i_dtr}(1)*head_bins)/(nCmpDtr+1);
                               toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                               fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                               cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;
                            
                            
                        end
                       
                   else % take 1st pref
                       
                             alpha_new = ahead_alpha_prefs{i_dtr}(land_pref_bins{i_dtr}(1));

                              del_alph_dtr(dtr_ahd(i_dtr)) = ...
                                  mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                              alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;

                                nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                                mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr + ...
                                   land_pref_bins{i_dtr}(1)*head_bins)/(nCmpDtr+1);
                               toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                               fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                               cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;
                       
                   end
                   
               elseif n_land_opp(i_dtr) > 0 % take 1st opp
                   
                     alpha_new = ahead_alpha_opps{i_dtr}(land_opp_bins{i_dtr}(1));
                      
                      del_alph_dtr(dtr_ahd(i_dtr)) = ...
                          mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                      alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;


                      nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                      mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr - ...
                           land_opp_bins{i_dtr}(1)*head_bins)/(nCmpDtr+1);
                       toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                       fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                       cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;
                   
               end                  
               
               
         elseif dtrCstStr < 8

              if n_land_pref(i_dtr) >= n_land_opp(i_dtr)  

                  if n_land_pref(i_dtr) > 0 % if none, no change to heading alpha

                      alpha_new = (dtrCstStr==5)*ahead_alpha_prefs{i_dtr}(land_pref_bins{i_dtr}(1)) ...
                          + (dtrCstStr>=6)*ahead_alpha_prefs{i_dtr}(med_land_pref(i_dtr));
                      
                      del_alph_dtr(dtr_ahd(i_dtr)) = ...
                          mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                      alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;

                        nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                        mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr + ...
                           ((dtrCstStr==5)*land_pref_bins{i_dtr}(1)+(dtrCstStr>=6)*med_land_pref(i_dtr))*head_bins)/(nCmpDtr+1);
                       toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                       fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                       cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;
                                                                       
                  end

              else % opposite side 
                  
                     alpha_new = (dtrCstStr==5)*ahead_alpha_opps{i_dtr}(land_opp_bins{i_dtr}(1)) ...
                          + (dtrCstStr>=6)*ahead_alpha_opps{i_dtr}(med_land_opp(i_dtr));
                      
                      del_alph_dtr(dtr_ahd(i_dtr)) = ...
                          mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                      alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;


                      nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                      mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr - ...
                           ((dtrCstStr==5)*land_opp_bins{i_dtr}(1)+(dtrCstStr>=6)*med_land_opp(i_dtr))*head_bins)/(nCmpDtr+1);
                       toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                       fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                       cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;
                       
              end     
              
           else % strat 8, 9 go in opposite direction (first = 8, med = 9)
             
             if n_land_pref(i_dtr) > 0 && ...
                     (alph_dtr(i_dtr)*prev_del_alph_dtr(dtr_ahd(i_dtr)) >= 0  || n_land_opp(i_dtr) == 0)

                      alpha_new = (dtrCstStr==8)*ahead_alpha_prefs{i_dtr}(land_pref_bins{i_dtr}(1)) ...
                          + (dtrCstStr==9)*ahead_alpha_prefs{i_dtr}(med_land_pref(i_dtr));
                      
                      del_alph_dtr(dtr_ahd(i_dtr)) = ...
                          mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                      alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;

                        nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                        mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr + ...
                           ((dtrCstStr==8)*land_pref_bins{i_dtr}(1)+(dtrCstStr==9)*med_land_pref(i_dtr))*head_bins)/(nCmpDtr+1);
                       toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                       fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                       cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;    
               
             elseif n_land_opp(i_dtr) > 0 && ...
                     (alph_dtr(i_dtr)*prev_del_alph_dtr(dtr_ahd(i_dtr)) <= 0 || n_land_pref(i_dtr) == 0)
                 
                      alpha_new = (dtrCstStr==8)*ahead_alpha_opps{i_dtr}(land_opp_bins{i_dtr}(1)) ...
                          + (dtrCstStr==9)*ahead_alpha_opps{i_dtr}(med_land_opp(i_dtr));
                      
                      del_alph_dtr(dtr_ahd(i_dtr)) = ...
                          mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                      alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;


                      nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                      mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr - ...
                           ((dtrCstStr==8)*land_opp_bins{i_dtr}(1)+(dtrCstStr==9)*med_land_opp(i_dtr))*head_bins)/(nCmpDtr+1);
                       toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                       fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                       cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;
                       
             elseif n_land_pref(i_dtr) > 0 
                 
                       alpha_new = (dtrCstStr==8)*ahead_alpha_prefs{i_dtr}(land_pref_bins{i_dtr}(1)) ...
                          + (dtrCstStr==9)*ahead_alpha_prefs{i_dtr}(med_land_pref(i_dtr));
                      
                      del_alph_dtr(dtr_ahd(i_dtr)) = ...
                          mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                      alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;

                        nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                        mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr + ...
                           ((dtrCstStr==8)*land_pref_bins{i_dtr}(1)+(dtrCstStr==9)*med_land_pref(i_dtr))*head_bins)/(nCmpDtr+1);
                       toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                       fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                       cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;  
                       
             elseif n_land_opp(i_dtr) > 0 
                 
                       alpha_new = (dtrCstStr==8)*ahead_alpha_opps{i_dtr}(land_opp_bins{i_dtr}(1)) ...
                          + (dtrCstStr==9)*ahead_alpha_opps{i_dtr}(med_land_opp(i_dtr));
                      
                      del_alph_dtr(dtr_ahd(i_dtr)) = ...
                          mod(alpha_new - alpha(dtr_ahd(i_dtr))+pi,2*pi)-pi; 
                      alpha(dtr_ahd(i_dtr)) = mod(alpha_new+pi,2*pi)-pi;


                      nCmpDtr = toCmpDtr(dtr_ahd(i_dtr)) +1;
                      mn_Dtr(dtr_ahd(i_dtr)) =  (mn_Dtr(dtr_ahd(i_dtr))*nCmpDtr - ...
                           ((dtrCstStr==8)*land_opp_bins{i_dtr}(1)+(dtrCstStr==9)*med_land_opp(i_dtr))*head_bins)/(nCmpDtr+1);
                       toCmpDtr(dtr_ahd(i_dtr)) = nCmpDtr;
                       fl_hrs(dtr_ahd(i_dtr)) = max(fl_hrs(dtr_ahd(i_dtr))/dtrShortFact,2);
                       cum_steps_dtr(dtr_ahd(i_dtr)) = cum_steps_dtr(dtr_ahd(i_dtr)) +1;
                       
             end
                  
         end

               
       end

    end
    
end

% del_alph_dtr(~chck_ahd) = 0;