% allel_hd_new_1 = NaN(N_inds,2,2);
% allel_hd_new_2 = NaN(N_inds,2,2);

parfor i_dep = 1:N_inds % par
    % p_d2_dep = NaN*ones(N_succ,1);
    p_d2_dep_arr = NaN*ones(N_succ,1);
    p_d2_all = NaN*ones(N_succ,1);

    % compute distance from selected successful migrants
%     arclens_deps = distance('gc',[lat_bs_deps(i_dep),lon_bs_deps(i_dep)], ...
%         [lat_deps_succ,lon_deps_succ]);

    % For speed (10 x faster), replace by Cartesian (local planar) distance 
    % since within 1000 km spherical effects are small
    arclens_deps =  sqrt((theta_0(i_dep)-lat_deps_succ).^2 + ...
        (cos(theta_0(i_dep))*(llamda_0(i_dep) -lon_deps_succ)).^2); %
    
    % expnential decay in selection beyond dispersal distance
    % modulated by (any) speed selectivity
    r_exps = arclens_deps./succ_disp_d_dep;
    r_exp_min = min(r_exps);
    rel_ps = speed.*exp(-r_exps.^2+r_exp_min^2)./succ_disp_d_dep; % .^2

    if  iYear > 1 && wt_natl_geomg % Sim_nr > N_init_Sims/2 && wt_natl_geomg % 
        if wt_natal_decln 
            d_decln_i = abs(dcln_curr(i_dep) - prv_dcln_succ);
            rel_ps = rel_ps./(d_decln_i/median(d_decln_i)).^2;
        end
        if wt_natal_incln
            d_incln_i = abs(incln_curr(i_dep) - prv_incln_succ);
            rel_ps = rel_ps./(d_incln_i/median(d_incln_i)).^2;
        end
        if wt_natal_intns
            d_intns_i = abs(intns_curr(i_dep) - prv_intns_succ);
            rel_ps = rel_ps./(d_intns_i/median(d_intns_i)).^2;
        end

    else
        d_dcln_i = NaN;
        d_incln_i = NaN;
        d_intns_i = NaN;
    end   

    pmax = max(rel_ps);
%     rmin = min(r_exps);
%     pmax = max(succ_disp_d_dep);
    p_d2_dep = rel_ps/pmax;

    % if acceleraed warmup favour homozygotes
%     if accel_wrmp && n_loci > 0 && Sim_nr <= N_wrmp_rnd +  N_wrmp_bck + 1 % N_i
% 
%         p_d2_dep = p_d2_dep.*(2*homozygs + 0.5*~homozygs);
% 
%     end
    
%     p_d2_dep(arclens_deps < succ_disp_d_dep) = ...
%         speed(arclens_deps < succ_disp_d_dep);
%     beyond_thr = arclens_deps >= succ_disp_d_dep;
%     
% 
%     p_d2_dep(beyond_thr) = speed(beyond_thr).* ...
%         exp(-(arclens_deps(beyond_thr)./succ_disp_d_dep(beyond_thr) -rmin).^2);
% 
%     % scale rel ps to avoid underflow & all zero probabilities
%     rel_dist_beynd= arclens_deps(beyond_thr)./succ_disp_d_dep(beyond_thr);
%     p_d2_dep(beyond_thr) = speed(beyond_thr).* ...
%         exp(-(rel_dist_beynd./min(rel_dist_beynd) -1).^2);
    
    % choose first "parent" traits based on natal proximity to new location
    i_parnt_1(i_dep) = randsample(1:N_succ,1,true,p_d2_dep);

    % choose second based on distance as above and...
    % on distance of winter arrival locn from 1st chosen
            

    % expnential decay in selection with distance
    % modeulated by (any) speed selectivity

    if ~isinf(max_disp_d_arr) % any(reqs_zug)

        arclens_arrs = distance('gc',[lat_arrs_succ(i_parnt_1(i_dep)), ...
          lon_arrs_succ(i_parnt_1(i_dep))],[lat_arrs_succ,lon_arrs_succ]);       
                
        p_d2_dep_arr(arclens_arrs < succ_disp_d_arr) = ...
            p_d2_dep(arclens_arrs < succ_disp_d_arr);
        
        beyond_thr = arclens_arrs >= succ_disp_d_arr;
                
        % scale rel ps to avoid underflow & all zero probabilities
        rel_dist_beynd= arclens_arrs(beyond_thr)./succ_disp_d_arr(beyond_thr);        
        p_d2_dep_arr(beyond_thr) = p_d2_dep(beyond_thr).* ...
            exp(-(rel_dist_beynd./min(rel_dist_beynd) -1).^2);
        
    else
        
        p_d2_dep_arr = p_d2_dep;
        
    end
                
    % also weight by first zugkn locn if applicable
    if zug_opt == 1 && ~isinf(max_disp_d_zug) % any(reqs_zug)
        
        arclens_zugs = distance('gc',[lat_zugs_succ(i_parnt_1(i_dep)), ...
        lon_zugs_succ(i_parnt_1(i_dep))],[lat_zugs_succ,lon_zugs_succ]);  
    
        p_d2_all(arclens_zugs < succ_disp_d_zug) = ...
        p_d2_dep_arr(arclens_zugs < succ_disp_d_zug);
    
        beyond_thr = arclens_zugs >= succ_disp_d_zug;
               
        % scale rel ps to avoid underflow & all zero probabilities
        rel_dist_beynd= arclens_zugs(beyond_thr)./succ_disp_d_zug(beyond_thr);        
        p_d2_all(beyond_thr) = p_d2_dep_arr(beyond_thr).* ...
            exp(-(rel_dist_beynd./min(rel_dist_beynd) -1).^2);
        
    else
        
        arclens_zugs = zeros(size(arclens_deps));  
        p_d2_all = p_d2_dep_arr;
        
    end
    
     % add contingency for dep date if uses sun compass
     % note with "speed" we've already accounted for return timing
     % Here we inversely weight by fractional week in
     % diffrence of departure between parents
     if incl_sun

        ddays = abs(day_start_succ - ...
            day_start_succ(i_parnt_1(i_dep)))/7 +1;
        p_d2_all = p_d2_all./ddays;

     end
     
    % during warmup 'select' sigma (headings) and thresh dists
    % Option (Aug 2022, now turned off) only for first third of warmup so that it doesn't overfit
    % the narrowness of "adaptive" std in inherited traits
    if accel_wrmp && Sim_nr <= N_wrmp_rnd +  N_wrmp_bck + 1 % N_init_Sims+1 % 
        
        if rng_std_inh_hd > 0
            d_stds = abs(succ_std_inher_head - succ_std_inher_head(i_parnt_1(i_dep)));
            p_d2_all = p_d2_all.*(1-d_stds/rng_std_inh_hd).^2; % ...
        end

        if rng_disp_d_dep > 0
            d_deps = abs(succ_disp_d_dep - succ_disp_d_dep(i_parnt_1(i_dep)));
            p_d2_all = p_d2_all.*(1-d_deps/rng_disp_d_dep).^2;
        end

        if zug_opt && rng_std_inh_sp > 0  
            d_stds = abs(succ_std_inher_signp - succ_std_inher_signp(i_parnt_1(i_dep)));
            p_d2_all = p_d2_all.*(1-d_stds/rng_std_inh_sp).^2; % ...
        end

    end

     % If option not to use (parent) inds from same locn,
     % then exclude same parent to promote diversity and converegence
     if ~opt_same_loc_brd && sum(p_d2_all > 1e-10) > 1 &&  ...
             Sim_nr <=  N_wrmp_rnd +  N_wrmp_bck + 1 % N_init_Sims+1 % 
         p_d2_all(i_parnt_1(i_dep)) = 0;
     end

     % add contingency for self-selection between 2 genotypes
     if n_loci == 2 && genSel

        same_phen = succ_Dom ==  succ_Dom(i_parnt_1(i_dep));
        p_d2_all = p_d2_all.*(~same_phen + genSelWt*same_phen);

     end

%      try
     % now choose 2nd parent traits based on arrival, zug  & sched proximities
     i_parnt_2(i_dep) = randsample(1:N_succ,1,true,p_d2_all);
%      catch
%          keyboard
%      end

     % randomly sample alleles from each parent
     r_t1 = rand_al_1s(i_dep,1);
     r_t2 = rand_al_2s(i_dep,1);

    all_allel_t1(i_dep,1) = succ_allels(i_parnt_1(i_dep),r_t1,1);
    all_allel_t2(i_dep,1) = succ_allels(i_parnt_2(i_dep),r_t2,1);

    allel_hd_new_t1(i_dep,1) = succ_al_hds(i_parnt_1(i_dep),r_t1,1);
    allel_hd_new_t2(i_dep,1) = succ_al_hds(i_parnt_2(i_dep),r_t2,1);

    if n_loci > 1

        r_m1 = rand_al_1s(i_dep,2);
        r_m2 = rand_al_2s(i_dep,2);
        all_allel_m1(i_dep,1) = succ_allels(i_parnt_1(i_dep),r_m1,2); % r_t1
        all_allel_m2(i_dep,1) = succ_allels(i_parnt_2(i_dep),r_m2,2); % r_t2
        allel_hd_new_m1(i_dep,1) = succ_al_hds(i_parnt_1(i_dep),r_t1,2);
        allel_hd_new_m2(i_dep,1) = succ_al_hds(i_parnt_2(i_dep),r_t2,2);
 
    end

    % if zug_opt == 1 %
    % 
    %     for iz = 1:n_zugs % add one to allow parfor loop 
    %         % (won't run anyway if n_zug == 0)
    %         allel_zg_new_t1(i_dep,iz) = succ_al_zgs(i_parnt_1(i_dep),r_t1,iz,1);
    %         allel_sp_new_t1(i_dep,iz) = succ_al_sps(i_parnt_1(i_dep),r_t1,iz,1);
    %         allel_zg_new_t2(i_dep,iz) = succ_al_zgs(i_parnt_2(i_dep),r_t2,iz,1);
    %         allel_sp_new_t2(i_dep,iz) = succ_al_sps(i_parnt_2(i_dep),r_t2,iz,1);    
    %     end
    % 
    %     if n_loci > 1
    % 
    %         for iz = 1:n_zugs % add one to allow parfor loop 
    %             % (won't run anyway if n_zug == 0)
    %             allel_zg_new_m1(i_dep,iz) = succ_al_zgs(i_parnt_1(i_dep),r_t1,iz,2);
    %             allel_sp_new_m1(i_dep,iz) = succ_al_sps(i_parnt_1(i_dep),r_t1,iz,2);
    %             allel_zg_new_m2(i_dep,iz) = succ_al_zgs(i_parnt_2(i_dep),r_t2,iz,2);
    %             allel_sp_new_m2(i_dep,iz) = succ_al_sps(i_parnt_2(i_dep),r_t2,iz,2);    
    %         end
    % 
    %     end
    % 
    % end
end