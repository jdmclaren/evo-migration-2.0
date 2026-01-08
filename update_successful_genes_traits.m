% keep track of field at dep locs
% date_jul_start is initialized in create_init_popn and 
% updated in update_succ_popn

if iWarmup == N_init_Sims +1 % max(n_req_stp+1,2)

    lat_bs_deps = lat_bs_deps(1:N_inds);
    lon_bs_deps = lon_bs_deps(1:N_inds);
    theta_0 = lat_bs_deps*deg2rad;
    llamda_0 = lon_bs_deps*deg2rad; 

    inher_head_kappa = [];
    std_inher_signp = [];
    inher_signp_kappa = [];   

     prev_succ_heads = NaN*one_vec;
     prev_succ_zug_inh_hds = NaN*one_vec;
     prev_speed = NaN*one_vec;

     blat_prev_succs = NaN*one_vec;
     blon_prev_succs = NaN*one_vec; 

     prev_coeff_succ = NaN*one_vec; 

end

% save last value for selection vs. decln etc. (note is same or 
% random yr in wrmup so better to do that during actual sim)
if  iYear > 1 % Sim_nr >= N_init_Sims/2 % +1 %

    prv_dcln_succ = decln_0s(stoppedAndArrived,max(iYear-1,1));
    prv_incln_succ = incln_0s(stoppedAndArrived,max(iYear-1,1));
    prv_intns_succ = intns_0s(stoppedAndArrived,max(iYear-1,1));

    % proxy day start based on previous year's depart date 
    % with curr_year updated
    date_jul_start = datenum(curr_year*one_vec,month_start*one_vec,day_starts); 

    [Bx0, By0, Bz0] = igrf(round(median(date_jul_start)), ...
      lat_bs_deps, lon_bs_deps, 0); % lat_bs_stops, lon_bs_stops, 0); % 
    % decln_0 used to set up mean initial (first-year) offset 
    % in initial heads gicen the local declination field
    dcln_curr = atan2(By0,Bx0)*180/pi;
    incln_curr = sqrt(Bx0.^2 + By0.^2 + Bz0.^2);
    intns_curr = atan(Bz0./hz_inten_0)*180/pi;  

    % we repopulate all locations, and (optionally) weight
    % % besides geographically also rel to geomagn signp
%     dcln_curr = decln_0s(:,iYear);
%     incln_curr = incln_0s(:,iYear);
%     intns_curr = intns_0s(:,iYear);
     
end

% prv_intns_suc = intns_0s(iYear,stoppedAndArrived);
% prv_incln_suc = incln_0s(iYear,stoppedAndArrived);  

%     prev_decln(stoppedAndArrived);

% zugkn_inher_heads = NaN*ones(N_inds,n_zugs); % zugkn_inher_heads(1:N_inds,:);

% keep locations same but take random successful weighted by distance

% N_succ = sum(stoppedAndArrived);

i_parnt_1 = NaN*ones(N_inds,1);
i_parnt_2 = NaN*ones(N_inds,1);

% try 
idx_succ = find(stoppedAndArrived);
succ_allels = NaN*ones(numel(idx_succ),2,n_loci);
succ_allels(:,:,1) = all_allels(idx_succ,:,1);
if n_loci > 1
    succ_allels(:,:,2) = all_allels(idx_succ,:,2);
% else
%     succ_allels = all_allels(idx_succ,:);
end
% succ_allel_2s = all_allels(idx_succ,:,2);
% homozygs = succ_allels(:,1) == succ_allels(:,2);

% here we assume all alleles on same chromosome 
% incl orientn and signp cues
rand_al_1s = randi(2,[N_inds,n_loci]);
rand_al_2s = randi(2,[N_inds,n_loci]);

succ_al_hds = allel_heads(idx_succ,:);
succ_al_zgs = allel_zugs(idx_succ,:,:);
succ_al_sps = allel_sps(idx_succ,:,:);

% loop through departure locations and choose
%  parental traits i_parnt_1 and i_parnt_2 for each new locn 

%     try
if zug_opt

    select_parents_zug

else % need separate functions due to parfor rules
    % (no conditional 0 count in loops)

    select_parents_no_zug

end

% first determine the inherited alleles 
all_allels(:,:,1) = [all_allel_t1 all_allel_t2];  

if n_loci> 1 % dom "M" allele is 2nd 

    T1s = all_allels(:,1,1);
    T2s = all_allels(:,2,1);    
    all_allels(:,:,2) = [all_allel_m1 all_allel_m2];  
    M1s = all_allels(:,1,2);
    M2s = all_allels(:,2,2);

else

    if EW_dom % Dom allele is first

         M1s = all_allels(:,1,1);
         M2s = all_allels(:,2,1);  
         T1s = zero_vec;
         T2s = zero_vec;

    else % Dom allel is 2nd

         T1s = all_allels(:,1,1);
         T2s = all_allels(:,2,1);  
         M1s = zero_vec;
         M2s = zero_vec;

    end

end

% determine if averaged or dominance
% avgd = (M1s == M2s & T1s == T2s);
% inh_1 = ~avgd & (M1s > M2s | (T1s > T2s)); 
% inh_2 = ~avgd & (M2s > M1s | (T2s > T1s));

% for subseq gens popn, update signs from dominance 
% (i.e. all positive for one allele, following dominance if two)
Dom_phen = M1s+M2s > 0;

if EW_avg
    avgd = one_vec;
else
    avgd = (M1s.*M2s==1) | (M1s == M2s & T1s == T2s);
end

inh_1 = ~avgd & (M1s > M2s | (M1s+M2s == 0 & T1s > T2s)); 
inh_2 = ~avgd & (M2s > M1s | (M1s+M2s == 0 & T2s > T1s));

% avgd = all_allels(:,1) == all_allels(:,2);
incl_1 = avgd | inh_1;
incl_2 = avgd | inh_2;

idx_avgs = find(avgd);
N_avgs = numel(idx_avgs);
idx_1s = find(inh_1); %  & ~incl_2
N_1s = numel(idx_1s);
idx_2s = find(inh_2); %  & ~incl_1
N_2s = numel(idx_2s);

% Always average 'variation' traits like std inh headings
% and also degree of nat dispersal (these are treated as 
% convergence variables not (within-time-domain) evoln vars

% update variation in inerited headings 
% add "minimum" variability to inherited variability
% If range is zero it will remain unchanged for all inds
% if rng_std_inh_hd > 0
std_inher_head = max(min((incl_1.*succ_std_inher_head(i_parnt_1) + ...
   incl_2.*succ_std_inher_head(i_parnt_2))./(1+avgd) + ...
   randn(N_inds,1)*min_std_inh_hd,max_std_inh_hd), ...
   min_std_inh_hd);

% inher_head_kappa(1:N_inds,1) = (1./succ_std_inher_head(i_parnt_1).^2 + ...
%    1./succ_std_inher_head(i_parnt_2).^2)/2;
inher_head_kappa(1:N_inds,1) = 1./std_inher_head.^2;

if ~isinf(inher_head_kappa(1))
    
    allel_hd_new_1 = vmrand(allel_hd_new_1, ...
            inher_head_kappa,[N_inds,1]);
    allel_hd_new_2 = vmrand(allel_hd_new_2, ...
            inher_head_kappa,[N_inds,1]);  

    if zug_opt == 1 
        allel_zg_new_1 = vmrand(allel_zg_new_1, ...
                inher_head_kappa,[N_inds,1]);
        allel_zg_new_2 = vmrand(allel_zg_new_2, ...
                inher_head_kappa,[N_inds,1]);  
    end

end

if zug_opt == 1 % need inclination or intensity signposts for zugknks

%     inher_signp_kappa = (zug_signp<3)*inher_signp_kappa + (zug_signp>=3)*std_rel_err_inten;
   
    std_inher_signp = max(min((incl_1.*succ_std_inher_signp(i_parnt_1) + ...
        incl_2.*succ_std_inher_signp(i_parnt_2))./(1+avgd) + randn(N_inds,1)*min_std_inh_sp, ...
        max_std_inh_sp),min_std_inh_sp); % 

%     try
    inher_signp_kappa(1:N_inds,1) = 1./std_inher_signp.^2;

end

%     succ_zug_signps = zug_signps(stoppedAndArrived,:);

if zug_signp == 1 || zug_signp ==  2 % incln and decln are circular var 

        for iz = 1:n_zugs
              
            allel_sp_new_1 = min(vmrand(allel_sp_new_1(:,iz), ...
                   inher_signp_kappa, [N_inds 1]),pi/2);

            allel_sp_new_2 = min(vmrand(allel_sp_new_2(:,iz), ...
                   inher_signp_kappa, [N_inds 1]),pi/2);
            
        end

else % zug_signp == 3 - 5 : non-circ field intens

    for iz = 1:n_zugs
        allel_sp_new_1 = allel_sp_new_1(:,iz).* ...
            (1 + randn(N_inds,1).*std_inher_signp); 

        allel_sp_new_2 = allel_sp_new_2(:,iz).* ...
            (1 + randn(N_inds,1).*std_inher_signp);      
    end
    
end

% now store (intrinsically varied) inherited headings & signposts
allel_heads = [allel_hd_new_1 allel_hd_new_2];  

if zug_opt
    allel_zugs = [allel_zg_new_1 allel_zg_new_2];  
    allel_sps = [allel_sp_new_1 allel_sp_new_2];  
end


% add variance to start date
day_starts = round(0.5*(day_start_succ(i_parnt_1) + ...
   day_start_succ(i_parnt_2)) + ...
   max(min(randn(N_inds,1)*std_day_start,max_dev_day_st), ...
   -max_dev_day_st));
curr_date.day = day_starts;     

%            inher_head_kappa(1:N_inds,1) = kap_hds_bar.*(1 + randn(N_inds,1)/10);

% if rng_std_inh_disp > 0

% update variation in inerited headings 
% add "minimum" variability to inherited variability
std_inher_disp = max(min((incl_1.*succ_std_inher_disp(i_parnt_1) + ...
incl_2.*succ_std_inher_disp(i_parnt_2))./(1+avgd) + ...
randn(N_inds,1)*min_std_inh_disp,max_std_inh_disp), ...
min_std_inh_disp);

     % have now updated std inh disp dist in new pop
     % Use this value to obtain the inherited "mean disp" param
     % (i.e., the "behavioural" tendancy to disperse according to a
     % Gaussian distribution)

% end

disp_d_dep = max(min((incl_1.*succ_disp_d_dep(i_parnt_1) + ...
    incl_2.*succ_disp_d_dep(i_parnt_2))./(1+avgd) + randn(N_inds,1).*std_inher_disp, ...
    max_disp_d_dep),min_disp_d_dep); % (1:N_inds,1)

disp_d_arr = max(min((incl_1.*succ_disp_d_arr(i_parnt_1) + ...
    incl_2.*succ_disp_d_arr(i_parnt_2))./(1+avgd) + randn(N_inds,1).*std_inher_disp, ...
    max_disp_d_arr),min_disp_d_dep); % (1:N_inds,1)

disp_d_zug = max(min((incl_1.*succ_disp_d_zug(i_parnt_1) + ...
    incl_2.*succ_disp_d_zug(i_parnt_2))./(1+avgd) + randn(N_inds,1).*std_inher_disp, ...
    max_disp_d_zug),min_disp_d_dep); % (1:N_inds,1)

% determine phenotype from genotype
if EW_dom % n_heads == 1 % only magnitude of dirn inherited 
    % and E/W determined by dominant allele 
            % [inher_heads, zugkn_inher_heads, zug_signps] = ...
            % det_phentyp(allel_heads,allel_zugs,allel_sps, ...
            % idx_avgs,idx_1s,idx_2s,N_avgs,N_1s,N_2s,n_zugs,Dom_phen,n_heads);
        [inher_heads, zugkn_inher_heads, zug_signps] = ...
            det_phentyp(abs(allel_heads),abs(allel_zugs),allel_sps, ...
             idx_avgs,idx_1s,idx_2s,N_avgs,N_1s,N_2s,n_zugs,zug_signp,Dom_phen,n_heads);
else % gene or genes each have directions as well as controls
    [inher_heads, zugkn_inher_heads, zug_signps] = ...
        det_phentyp(allel_heads,allel_zugs,allel_sps, ...
         idx_avgs,idx_1s,idx_2s,N_avgs,N_1s,N_2s,n_zugs,zug_signp,Dom_phen,n_heads);
end

if n_zugs > 1
    if zug_signp ~= 2 ||  mean(decln_0) > mean(decln_a)
        
        zug_signps = sort(zug_signps,3,'descend');
        
    else
        
        zug_signps = sort(zug_signps,3,'ascend');
        
    end
end


% for magncl strats we still need to calc init heads from
% (inherited) projections
% initialize vector for angles where magncl heads are well defined
 ok_incl = false_vec;
 
date_jul_start = datenum(curr_year*one_vec,month_start*one_vec,day_starts); 
doys = day(datetime(datevec(date_jul_start)),'dayofyear' );

% initialize sun az and geomagn field given locs and start (dep) dates
% initialize_sun_fl_hrs_geomag  
init_sun_geomag_fl_hrs  