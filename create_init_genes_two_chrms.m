
%% initialize dep. stop and Zug locations
[lat_bs_deps, lon_bs_deps, idx_deps] = ...
    initialize_locs(N_inds,rad2deg*Lon_dep_poly, rad2deg*Lat_dep_poly, ...
     near_idx_cst, d_cst_vec, req_land_init, hi_elevs, barrens, ...
    false(size(barrens)), ok_veg_breed, near_dateline); % 
%             lon_bs_deps = shiftAnglesFromMinus180To180(lon_bs_deps*rad2deg)*deg2rad;
theta_0 = shiftAnglesFromMinus180To180(lat_bs_deps)*deg2rad;
llamda_0 = lon_bs_deps*deg2rad;   

% define if starts in North_hemisph
% North_hemi =  circ_mean(theta_0) > 0;

% if n_loci > 1  % second row alleles will be direction 

% qs_Lon = quantile(lon_bs_deps,[0.25 0.5 0.75]);

% ctrl gene follows frequency equal to rel Eastwardness of lon
    min_lon_dep = min(lon_bs_deps);
    max_lon_dep = max(lon_bs_deps);
    d_lon = (max_lon_dep - min_lon_dep);
    min_lat_dep = min(lat_bs_deps);
    max_lat_dep = max(lat_bs_deps);
    d_lat = (max_lat_dep - min_lat_dep);

%    all_allels(:,:,1) =  rand(N_inds,2,1) <= 0.5;
   %      all_allels(:,:,1) = 1*(sqrt(rand(N_inds,2,1).*rand(N_inds,2,1)) > ...
%          (lon_bs_deps-min_lon_dep)./d_lon.* ...
%          (lat_bs_deps-min_lat_dep)./d_lat);

%      all_allels(lon_bs_deps-min_lon_dep<d_lon/3,:,2) = 1;


     if n_loci == 1

         % 
         all_allels(:,1,1) = one_vec; % randi(2,[N_inds,1])-1; % 1*(lat_bs_deps<=-41); % > 61); % 
         all_allels(:,2,1) = one_vec; % randi(2,[N_inds,1])-1; % 1*(lat_bs_deps<=-41); %; 
         % all_allels(:,1,2) = zero_vec; % > 61randi(2,[N_inds,1])-1; %  
         % all_allels(:,2,2) =  zero_vec; % randi(2,[N_inds,1])-1; %
         M1s = zero_vec; %
         M2s = zero_vec; %

     else
    
         if rndm_init_allels(1) && rndm_init_allels(2)

            all_allels(:,1:2,1:2) = randi(2,[N_inds,2,2])-1; %

         elseif ~near_dateline

             Troch_hom = (lon_bs_deps <= 10 & lat_bs_deps <= 62) | ...
                    (lon_bs_deps <= 20 & lat_bs_deps <= 58);
             Acred_hom = lat_bs_deps >= 65 | lon_bs_deps >= 30;

             % basis is heterozygotes (2 alleles for 2 genes / loci)
             all_allels = randi(2,[N_inds,2,2])-1; % 1*(lat_bs_deps>=-41); % 

             if ~rndm_init_allels(1)
                 % trochilus gene on 1st element last index
                 all_allels(Troch_hom,:,1) = 1;
                 all_allels(Acred_hom,:,1) = 0;
             end

             if ~rndm_init_allels(2)
                 % acreduls gene on 2nd element last index
                 all_allels(Acred_hom,:,2) = 1; % randi(2,[N_inds,1])-1; % > 61); % 
                 all_allels(Troch_hom,:,2) = 0;
             end

        else
         %              
             % all_allels(:,1,1) = 1*(lat_bs_deps <= -41); % randi(2,[N_inds,1])-1; % > 61); % 
             % all_allels(:,2,1) = randi(2,[N_inds,1])-1; % 1*(lat_bs_deps>=-41); % 
             all_allels(:,1:2,1) = randi(2,[N_inds,2])-1; %
             all_allels(lat_bs_deps >= -42,1:2,2) = 1; % randi(2,[N_inds,1])-1; % > 61); % 
             all_allels(lat_bs_deps < -40,1:2,2) = 0;

             % all_allels(:,1,2) = 1*(lat_bs_deps > -41); % randi(2,[N_inds,1])-1; %   > 61
             % all_allels(:,2,2) = randi(2,[N_inds,1])-1; %1*(lat_bs_deps<41); % 
             all_allels(:,1:2,2) = randi(2,[N_inds,2])-1; %
             all_allels(lat_bs_deps < -40,1:2,2) = 1; % randi(2,[N_inds,1])-1; % > 61); % 
             all_allels(lat_bs_deps >= -42,1:2,2) = 0;
         % 
        end
         M1s = all_allels(:,1,2);
         M2s = all_allels(:,2,2);
   
     end

     T1s = all_allels(:,1,1);
     T2s = all_allels(:,2,1);     


     % for init popn, use signs of Dom phenotyp as W (i.e. all positive)
    Dom_phen = M1s+M2s > 0;

%          all_allels(:,:,2) =  rand(N_inds,2,1) <= 0.5;
%          all_allels(:,:,2) = 1*(sqrt(rand(N_inds,2,1).*rand(N_inds,2,1)) < ...
%              (lon_bs_deps-min_lon_dep)./d_lon.* ...
%              (lat_bs_deps-min_lat_dep)./d_lat);
%          all_allels(lon_bs_deps-min_lon_dep<d_lon/3,:,2) = 0;
     % 
     % else
     % 
     % end

%      figure; scatter(lon_bs_deps(1:10000,1)*180/pi, ...
%     lat_bs_deps(1:10000,1)*180/pi ...
%     ,60,(M1s(1:10000)+M2s(1:10000)),'fill')
     
% determine if averaged or dominance
%     avgd = (M1s == M2s & T1s == T2s);
    inh_1m = M1s == 1; 
    inh_2m = M2s == 1; 
    avgd_m = inh_1m & inh_2m;
    inh_1t = ~(inh_1m | inh_2m) & (T1s == 1 | T1s+T2s == 0);
    inh_2t = ~(inh_1m | inh_2m) & (T2s == 1 | T1s+T2s == 0);
    avgd_t = inh_1t & inh_2t;
    
    % avgd = all_allels(:,1) == all_allels(:,2);
    % incl_1 = avgd | inh_1;
    % incl_2 = avgd | inh_2;
    
    idx_avg_ms = find(avgd_m);
    N_avg_ms = numel(idx_avg_ms);
    idx_1ms = find(inh_1m & ~avgd_m);
    N_1ms = numel(idx_1ms);
    idx_2ms = find(inh_2m & ~avgd_m);
    N_2ms = numel(idx_2ms);

    idx_avg_ts = find(avgd_t);
    N_avg_ts = numel(idx_avg_ts);
    idx_1ts = find(inh_1t & ~avgd_t);
    N_1ts = numel(idx_1ts);
    idx_2ts = find(inh_2t & ~avgd_t);
    N_2ts = numel(idx_2ts);

% figure; scatter(lon_bs_deps(1:10000,end)*180/pi, ...
% lat_bs_deps(1:10000,end)*180/pi, 100, ...
% (M1s(1:10000)+M2s(1:10000))/2,'fill')
% colorbar

%      all_allels(:,1) = 1*(rand(N_inds,1) < ...
%          (lon_bs_deps-min_lon_dep)./d_lon);

     % initialise MARB-a 
     % % assume 0-6 when West, 15-45 when Ease 
     % % use binomial distribuition to populate
%      Ws = lon_bs_deps - min_lon_dep < d_min/2;
%      N_Ws = sum(Ws);create_init
%      all_allels(Ws,2) = binornd(20,0.1,[1 N_Ws]);  
%      Es = lon_bs_deps - min_lon_dep >= d_min/2;
%      N_Es = sum(Es);
%      all_allels(Es,2) = binornd(200,0.15,[1 N_Es]);  

% else % zeros mean recessive - always average
% 
%     all_allels = [zero_vec zero_vec];
%     idx_avgs = 1:N_inds;
%     idx_1s = [];
%     idx_2s = [];
%     N_avgs = N_inds;
%     N_1s = 0;
%     N_2s = 0;
% 
% end

for iDep = 1:nDep_polys

    N_inds_DepPs(iDep) = sum(idx_deps == iDep);
    
end

% If multiple choices in Arr poly, 
% find closest poly for each departure Lon 

lat_bs_stops = NaN*one_vec;
lon_bs_stops = NaN*one_vec;
lat_bs_arrs = NaN*one_vec;
lon_bs_arrs = NaN*one_vec;

% if require_stopover_zug % ~isempty(req_stps)

%         Lon_stop_degs = cellfun(@(x) x*rad2deg,Lon_stop_poly{1}, ...
%             'UniformOutput',false);

       % If multiple choices in 1st stop, and zug required at stop,
       % find closest stopover option to mean of departure and arrival Lons 
       % for each individual each individual
% if nSt_Ply_1 > 1

   if zgknk_req_in_stop(1) == 1 || zgknk_req_stop_warm 

      % match dep locs to stop Polys
      dLon_Sts = abs(mn_Lon_St_1-lon_bs_deps);
      [~, idx_stops] = min(dLon_Sts,[],2);
      
      for iSt = 1:nSt_Ply_1
        idx_iSt = (iSt-1)*6+1:(iSt-1)*6+6;
        [lat_bs_stops(idx_stops==iSt), lon_bs_stops(idx_stops==iSt)] = ...
        initialize_locs(sum(idx_stops==iSt),rad2deg*Lon_stop_poly{1}(idx_iSt), ...
                rad2deg*Lat_stop_poly{1}(idx_iSt),  near_idx_cst, d_cst_vec, req_land_stop, ...
        hi_elevs, barrens, poor_stops, true(size(ok_veg_breed)), near_dateline); %
      end
      
      % then match Arr polys to stops 
     dLon_Arrs = abs(mn_Lon_Arr_deg-lon_bs_stops);
%       dLon_Arrs = abs(mn_Lon_Arr_deg-mn_Lon_St_1(idx_stops)');
     [~, idx_arrs] = min(dLon_Arrs,[],2);

     for iArr = 1:nArr_polys
         idx_iA = (iArr-1)*6+1:(iArr-1)*6+6;
        [lat_bs_arrs(idx_arrs==iArr), lon_bs_arrs(idx_arrs==iArr)] = ...
            initialize_locs(sum(idx_arrs==iArr),rad2deg*Lon_arr_poly(idx_iA), ...
            rad2deg*Lat_arr_poly(idx_iA),  near_idx_cst, d_cst_vec, req_land_arr, ...
            hi_elevs, barrens, poor_stops, true(size(ok_veg_breed)), near_dateline); % 
      end     
      
   else

     % match dep locs to Arr locs 
     dLon_Arrs = abs(mn_Lon_Arr_deg-lon_bs_deps);

     if match_init_Lons == 2 % match by dominant genes

        % [~, idx_arrs] = min(dLon_Arrs,[],2);
        idx_arrs = randi(2,[N_inds 1]);
        idx_arrs(M1s+M2s==2) = 2;
        idx_arrs(M1s+M2s==0) = 1;
        % idx_arrs(lat_bs_deps > -41) = 2;
        % idx_arrs(lat_bs_deps <= -41) = 1;

     elseif match_init_Lons == 1 % match by Lons

        [~, idx_arrs] = min(dLon_Arrs,[],2);
        % idx_arrs(M1s+M2s==2) = 2;
        % idx_arrs(M1s+M2s==1) = randi(2,size(idx_arrs(M1s+M2s==1)));
        % idx_arrs(M1s+M2s==0) = 1;
        % % idx_arrs(lat_bs_deps > -41) = 2;
        % % idx_arrs(lat_bs_deps <= -41) = 1;

     else
         
         idx_arrs = randi(nArr_polys,size(one_vec));

     end

     for iArr = 1:nArr_polys
         idx_iA = (iArr-1)*6+1:(iArr-1)*6+6;
        [lat_bs_arrs(idx_arrs==iArr), lon_bs_arrs(idx_arrs==iArr)] = ...
            initialize_locs(sum(idx_arrs==iArr),rad2deg*Lon_arr_poly(idx_iA), ...
            rad2deg*Lat_arr_poly(idx_iA), near_idx_cst, d_cst_vec, req_land_arr, ...
            hi_elevs, barrens, poor_stops, true(size(ok_veg_breed)), near_dateline); % 
      end

      mn_dep_arr_Lons =(lon_bs_deps + lon_bs_arrs)*pi/360; %c 
      dLon_Sts = abs(mn_Lon_St_1-mn_dep_arr_Lons); 
      [~, idx_stops] = min(dLon_Sts,[],2); 
      
      for iSt = 1:nSt_Ply_1
        idx_iSt = (iSt-1)*6+1:(iSt-1)*6+6;
        [lat_bs_stops(idx_stops==iSt), lon_bs_stops(idx_stops==iSt)] = ...
        initialize_locs(sum(idx_stops==iSt),rad2deg*Lon_stop_poly{1}(idx_iSt), ...
                rad2deg*Lat_stop_poly{1}(idx_iSt),  near_idx_cst, d_cst_vec, req_land_stop, ...
            hi_elevs, barrens, poor_stops, true(size(ok_veg_breed)), near_dateline); %
%           hi_elevs, false(size(ok_veg_breed)), false(size(ok_veg_breed)), true(size(ok_veg_breed))); %

      end

   end


%% initialize variation in inerited parameters

std_inher_disp = min_std_inh_disp + ...
    (max_std_inh_disp-min_std_inh_disp)*rand([N_inds,1]);

std_inher_head = min_std_inh_hd + ...
    (max_std_inh_hd-min_std_inh_hd)*rand([N_inds,1]);
inher_head_kappa = 1./std_inher_head.^2;

std_inher_steer = min_std_inh_steer + ...
(max_std_inh_steer - min_std_inh_steer)*rand([N_inds,1]);

% add variance to start date
dev_day = round(std_day_start*randn([N_inds 1]));
dev_day(dev_day > max_dev_day_st) = max_dev_day_st;
dev_day(dev_day < -max_dev_day_st) = -max_dev_day_st;
day_starts = day_start + dev_day; 
% curr_date.day = day_starts;
date_jul = datenum(curr_year*one_vec,month_start*one_vec,day_starts);
date_jul_start = date_jul;
doys = day(datetime(datevec(date_jul)),'dayofyear' );

% initialize sun az and geomagn field given locs and start (dep) dates
% initialize_sun_fl_hrs_geomag 
init_sun_geomag_fl_hrs

% first check if zug_opt == 1 to set zugknik magn signposts

if zug_opt == 1

    std_inher_signp = min_std_inh_sp + ...
    (max_std_inh_sp - min_std_inh_sp)*rand([N_inds,1]);
    inher_signp_kappa = 1./std_inher_signp.^2;

    % initial error magnetic compass parameters
    if ~isinf(compass_kappa_incl)
         rand_magn_a = vmrand(0, compass_kappa_incl, [N_inds 2 2]); %      
    else
         rand_magn_a = zeros(N_inds,2,2); % [zero_vec zero_vec];
    end

    % determine inclination at arrival (use median date, for
    % guesstimate)
    
    if  zgknk_req_in_stop(1) == 1 || zgknk_req_stop_warm % (zug_opt == 1 &&  n_zugs > 0) %  || 
        
         [Bxa, Bya, Bza] = igrf(round(median(date_jul)), ...
            lat_bs_stops, lon_bs_stops, 0); % lat_bs_arrs, lon_bs_arrs, 0); %  
         
    else
        
         [Bxa, Bya, Bza] = igrf(round(median(date_jul)), ...
              lat_bs_arrs, lon_bs_arrs, 0); % lat_bs_stops, lon_bs_stops, 0); % 
         
    end

    % decln_0 used to set up mean initial (first-year) offset 
    % in initial heads gicen the local declination field
    decln_a = atan2(Bya,Bxa);

    hz_inten_a = hypot(Bxa,Bya);
    incln_a = min(atan(Bza./hz_inten_a) + rand_magn_a,pi/2);

    if zug_signp == 0                   

        allel_sps =  NaN*ones(N_inds,2,2,n_zugs);
%                     zug_signps = sort(zug_signps,2,'descend');

    elseif zug_signp == 1

        if  zgknk_req_in_stop(1) == 1 || zgknk_req_stop_warm % (zug_opt == 1 &&  n_zugs > 0) %  || 

            allel_sps(:,:,1) = incl_a; % repmat(incl_a,[2 2]); % [incln_a incln_a]; % + rand(N_inds,n_zugs).*(incln_0 - incln_a);
            
        else
            
            allel_sps(:,:,:,1) = incln_a  + rand(N_inds,2,2,n_zugs).*(incln_0 - incln_a);
              
        end
        
        if n_zugs > 1
            allel_sps = sort(allel_sps,4,'descend'); 
        end

    elseif zug_signp == 2

%                     tot_B_a = hypot(hz_inten_a,Bza).*(1 + randn(N_inds,1)*std_rel_err_inten);
%                 zug_signps = rand(N_inds,n_zugs).*(1-tot_B_a./tot_inten_0); 

        if zgknk_req_in_stop(1) == 1 || zgknk_req_stop_warm % (zug_opt == 1 &&  n_zugs > 0) %  || 
            
             allel_sps(:,:,:,1) = [decln_a decln_a]; 
             % Bza./tot_B_a + rand(N_inds,n_zugs).*(vt_inten_0 - Bza./tot_B_a);
             
        else
            
             allel_sps(:,:,:,1) = decln_a + rand(N_inds,2,2,n_zugs).*(decln_0 - decln_a); 
             
        end 
        
        if n_zugs > 1
            if mean(decln_0) > mean(decln_a)
    
                allel_sps = sort(allel_sps,4,'descend');   
    
            else
    
                 allel_sps = sort(allel_sps,4,'ascend');                          
    
            end
        end

    elseif zug_signp == 3
        
        tot_B_a = hypot(hz_inten_a,Bza).*(1 + randn(N_inds,2)*std_rel_err_inten);

        if  zgknk_req_in_stop(1) == 1 || zgknk_req_stop_warm % (zug_opt == 1 &&  n_zugs > 0) %  || 

            allel_sps(:,:,:,1) = [tot_B_a tot_B_a]; %  + rand(N_inds,n_zugs).*(tot_inten_0 - tot_B_a); % Bza./tot_B_a + rand(N_inds,n_zugs).*(vt_inten_0 - Bza./tot_B_a);
            
        else
            
            allel_sps = tot_B_a  + rand(N_inds,2,2,n_zugs).*(tot_inten_0 - tot_B_a); % Bza./tot_B_a + rand(N_inds,n_zugs).*(vt_inten_0 - Bza./tot_B_a);
              
        end
        
        if n_zugs > 1
            allel_sps = sort(allel_sps,4,'descend');
        end


    elseif zug_signp == 4  

        vt_inten_a = Bza.*(1 + randn(N_inds,1)*std_rel_err_inten);
        if  zgknk_req_in_stop(1) == 1 || zgknk_req_stop_warm % (zug_opt == 1 &&  n_zugs > 0) %  || 
                allel_sps(:,:,:,1) = [vt_inten_a vt_inten_a]; % + rand(N_inds,n_zugs).*(vt_inten_0 - vt_inten_a);
        else
                allel_sps(:,:,:,1) = vt_inten_a + rand(N_inds,2,2,n_zugs).*(vt_inten_0 - vt_inten_a);
        end
%                 zug_signps = Bza./tot_B_a + rand(N_inds,n_zugs).*(vt_inten_0 - Bza./tot_B_a);
        if n_zugs > 1
            allel_sps = sort(zug_signps,4,'descend');
        end
        
    elseif zug_signp == 5  

        hz_inten_a = hz_inten_a.*(1 + randn(N_inds,1)*std_rel_err_inten);
        
        if  zgknk_req_in_stop(1) == 1 || zgknk_req_stop_warm % (zug_opt == 1 &&  n_zugs > 0) %  || 
            
            allel_sps(:,:,:,1) = [hz_inten_a hz_inten_a];
            
        else

            allel_sps(:,:,:,1) = hz_inten_a + rand(N_inds,2,2,n_zugs).*(hz_inten_0 - hz_inten_a);
                        
        end
        
%                 zug_signps = Bza./tot_B_a + rand(N_inds,n_zugs).*(vt_inten_0 - Bza./tot_B_a);
        if n_zugs > 1
          allel_sps = sort(allel_sps,4,'descend');
        end


    end

else

    allel_sps = NaN*ones(N_inds,2,2,n_zugs);
    std_inher_signp = NaN*ones(N_inds,n_zugs);

end


% next set up the initial heads, given the departure arrival areas
% as well as any required stopover locations (and initial
% declination field which could be high e.g. in the Arctic)

              
%             if calibr_comp(1)  == 4 % use 90 to 270


if zgknk_req_in_stop(1) == 1  || zgknk_req_stop_warm %% (zug_opallel_signpst == 1 &&  n_zugs > 0) %  || 
% nStop_polys > 0

    angs_dep_stop_rh = pi/180*azimuth('rh',lat_bs_deps,mod(lon_bs_deps,360), ...
          lat_bs_stops,mod(lon_bs_stops,360));
    angs_dep_stop_gc = pi/180*azimuth('gc',lat_bs_deps,mod(lon_bs_deps,360), ...
         lat_bs_stops,mod(lon_bs_stops,360));

%     mn_angs_arr = angs_dep_stop_rh; % (angs_dep_stop_rh ...
%         +  (calibr_comp(2)~=0)*angs_dep_stop_gc)/(1+(calibr_comp(2)~=0));
    
      mn_angs_arr =  circ_mean([angs_dep_stop_rh angs_dep_stop_gc]')'; %circ_mean([angs_dep_stop_rh' angs_dep_stop_gc']');
  
     % sign_mns = (~North_hemi-North_hemi)*sign(lon_bs_stops-lon_bs_deps); 
     % large_mns = abs(lon_bs_arrs-lon_bs_deps) > 90;      
     
      %     var_ang_arr = circ_var([angs_dep_stop_rh' angs_dep_stop_gc']');
% 
%     % use 10 times the variance for offsets to means
%     init_offs_lots = vmrand(0, 1/(10*var_ang_arr), [N_inds*10 1]); % rand(N_inds,1)*2*pi;   mn_angs_arr      

%     [~, std_ang_arr] = circ_std([angs_dep_stop_rh' angs_dep_stop_gc']);
    std_ang_arrs = max(absDiffRad(mn_angs_arr,angs_dep_stop_rh),absDiffRad(mn_angs_arr,angs_dep_stop_gc)); % circ_std([angs_dep_stop_rh' angs_dep_stop_gc']);
    std_ang_arr = 2*quantile((std_ang_arrs),0.75);    % use 10 times the variance 

    init_offs_lots = vmrand(0, 1/(std_ang_arr^2), [N_inds*10 1]); % rand(N_inds,1)*2*pi;    mn_angs_arr  

else

    angs_dep_arr_rh = pi/180*azimuth('rh',lat_bs_deps,mod(lon_bs_deps,360), ...
      lat_bs_arrs,mod(lon_bs_arrs,360));
    angs_dep_arr_gc = pi/180*azimuth('gc',lat_bs_deps,mod(lon_bs_deps,360), ...
      lat_bs_arrs,mod(lon_bs_arrs,360));

%   mn_angs_arr = angs_dep_arr_rh; % 
   mn_angs_arr = circ_mean([angs_dep_arr_rh angs_dep_arr_gc]')';%  angs_dep_arr_gc; %  angs_dep_arr_rh; %

   % sign_mns = (~North_hemi-North_hemi)*sign(lon_bs_arrs-lon_bs_deps);
   % large_mns = abs(lon_bs_arrs-lon_bs_deps) > 90;
   
%     [~, std_ang_arr] = circ_std([angs_dep_arr_rh angs_dep_arr_gc]')';
    std_ang_arrs = max(absDiffRad(mn_angs_arr,angs_dep_arr_rh),absDiffRad(mn_angs_arr,angs_dep_arr_gc)); % circ_std([angs_dep_stop_rh' angs_dep_stop_gc']);
    std_ang_arr = 2*quantile((std_ang_arrs),0.75);    % use 10 times the variance 

    % use 10 times the variance 
    init_offs_lots = vmrand(0, 1/(std_ang_arr^2), [N_inds*10 1]); % rand(N_inds,1)*2*pi;    mn_angs_arr           

end

%% adjust mean angles for cases where longitude changes sign (need to
% enter abs(lons) > 180 for this to work
% Don't forget mn_angs_arr is clockwise from N at this point
% mn_angs_arr(large_mns & sign_mns == 1 & mn_angs_arr > 0) = ...
%     -mn_angs_arr(large_mns & sign_mns == 1 & mn_angs_arr > 0);
% 
% mn_angs_arr(large_mns & sign_mns == -1 & mn_angs_arr < 0) =  ...
%     -mn_angs_arr(large_mns & sign_mns == -1 & mn_angs_arr < 0);

% add offsets for compass strategy to assess if init heads are
% 'on track' within +/- 90 degs
% inher_offs_lots = mod(init_offs_lots - ...
%     (add_decl_inher)*median(decln_0) - ...
%     (add_az_inher)*(circ_median(sun_az_0(1:min(10000,N_inds)))*sign(sign_clockw_sun) + ...
%         2*(sign_clockw_sun==-1 && geo_mag_refl_sun_opt == 2)*median(decln_0))...
%         + pi,2*pi) -pi;
% 
% 
% %     absDiff = min(360-absDiffDeg(init_offs_lots*rad2deg,0), ...
% %     absDiffDeg(init_offs_lots*rad2deg,0));
% %     inh_offs_fun = inher_offs_lots; % will modulate and set vs. 180 = South below
%    within_bounds = abs(init_offs_lots) <  pi; %(mig_sys~=7)*90 + (mig_sys==7)*15; %  > pi/2;    
% 
% % end
% 
% % sign_mn_ang =  -sign(mn_angs_arr); % -pi     
% 
%  coeff_magn_steer = zeros(N_inds,n_zugs+1);      
% 
% %     inher_offs = randsample(inh_offs_fun,N_inds,true);
% %     inher_offs = randsample(init_offs_lots(within_bounds),N_inds,true); % *2
%     inher_offs = randsample(init_offs_lots(within_bounds),N_inds*2,true); % 
% % end
% 
% clear init_offs_lots inher_offs_lots within_bounds absDiff inh_hd_fun

% bunch heads within +/- 90 of means
inher_offs = -pi/2 + pi*rand(N_inds*2,2);

% distinguish between N and S migration
% Could alternatively choose within N or S angles
if abs(circ_mean(mn_angs_arr)) > pi/2 % S
    N_S_migr = true; % subtr pi from all angles (was for convenience, originally)
    % then convert to -pi:pi
    % idx_NS = find(abs(inher_lots) > pi/2,2*N_inds,'first');
    % inher_hds = inher_lots(idx_NS);
    allel_heads(:,1,1) = mod(mn_angs_arr + inher_offs(1:N_inds,1)-pi+pi,2*pi)-pi;
    allel_heads(:,2,1) = mod(mn_angs_arr + inher_offs(N_inds+1:2*N_inds,1)-pi+pi,2*pi)-pi;
    allel_heads(:,1,2) = mod(mn_angs_arr + inher_offs(1:N_inds,2)-pi+pi,2*pi)-pi;
    allel_heads(:,2,2) = mod(mn_angs_arr + inher_offs(N_inds+1:2*N_inds,2)-pi+pi,2*pi)-pi;
else % N, not relative to 180 (pi)
    % idx_NS = find(abs(inher_lots) < pi/2,2*N_inds,'first');
    % inher_hds = inher_lots(idx_NS(1:N_inds));
    allel_heads(:,1,1) = mod(mn_angs_arr + inher_offs(1:N_inds,1)+pi,2*pi)-pi;
    allel_heads(:,2,1) = mod(mn_angs_arr + inher_offs(N_inds+1:2*N_inds,1)+pi,2*pi)-pi;
    allel_heads(:,1,2) = mod(mn_angs_arr + inher_offs(1:N_inds,2)+pi,2*pi)-pi;
    allel_heads(:,2,2) = mod(mn_angs_arr + inher_offs(N_inds+1:2*N_inds,2)+pi,2*pi)-pi;
    N_S_migr = false;
end

    clear inher_offs % inher_lots inher_hds

    coeff_magn_steer = zeros(N_inds,n_zugs+1);

%             inher_heads(inher_heads <0) = inher_heads(inher_heads <0) +2*pi;
% allel_heads(:,1) = mod(mn_angs_arr + inher_offs(1:N_inds)-pi+pi,2*pi)-pi;
% allel_heads(:,2) = mod(mn_angs_arr + inher_offs(N_inds+1:2*N_inds)-pi+pi,2*pi)-pi;


%     std_inher_head = max(min((incl_1.*succ_std_inher_head(i_trt_1) + ...
%        incl_2.*succ_std_inher_head(i_trt_2))./(1+avgd) + ...
%        randn(N_inds,1)*min_std_inh_hd,max_std_inh_hd), ...
%        min_std_inh_hd);
% 
% % inher_head_kappa(1:N_inds,1) = (1./succ_std_inher_head(i_trt_1).^2 + ...
% %    1./succ_std_inher_head(i_trt_2).^2)/2;
% inher_head_kappa(1:N_inds,1) = 1./std_inher_head.^2;

if zug_opt
    
   if zgknk_req_in_stop(1) == 1  || zgknk_req_stop_warm %% (zug_opt == 1 &&  n_zugs > 0) %  || 
    % nStop_polys > 0 % &&  zug_opt ~= 2
        for iz = 1:max(min(nStop_polys,n_zugs),1)
    
            % set last stopover as "previous"
            lon_bs_prev = lon_bs_stops;    
            lat_bs_prev = lat_bs_stops;            
    
            % if TC sun comp and no magn set zugkn head to endog head
            if ~(calibr_comp(2)==2 && tc_comp_reset == 0 && endog_comp == 2) && ...
                    (require_stopover_zug(iz) == 1 || (zug_opt == 1 && iz <= n_zugs)) % ismember(iz,req_stps))
    
                if iz == nStop_polys
    
                    angs_stop_arr_rh = pi/180*azimuth('rh',lat_bs_prev,mod(lon_bs_prev,360), ...
                          lat_bs_arrs,mod(lon_bs_arrs,360));
                    angs_stop_arr_gc = pi/180*azimuth('gc',lat_bs_deps,mod(lon_bs_deps,360), ...
                          lat_bs_arrs,mod(lon_bs_arrs,360));   
    
                else 
    
                    % update to next stopover
                    [lat_bs_stops, lon_bs_stops] = ...
                        initialize_locs(N_inds,rad2deg*Lon_stop_poly{iz+1}, ...
                                rad2deg*Lat_stop_poly{iz+1},  near_idx_cst, d_cst_vec, req_land_stop, ...
                        hi_elevs, barrens, poor_stops, true(size(ok_veg_breed)), near_dateline); %
    %                [lat_bs_stops, lon_bs_stops] = ...
    %                 initialize_locs(N_inds,rad2deg*Stop_verts{iz+1},req_land_stop, ...
    %                 hi_elevs, barrens, poor_stops, true(size(ok_veg_breed))); %
    
                    angs_stop_arr_rh = pi/180*azimuth('rh',lat_bs_prev,mod(lon_bs_prev,360), ...
                          lat_bs_stops,mod(lon_bs_stops,360));
                    angs_stop_arr_gc = pi/180*azimuth('gc',lat_bs_prev,mod(lon_bs_prev,360), ...
                          lat_bs_stops,mod(lon_bs_stops,360));                    
    
                end
         
                mn_angs_arr =  circ_mean([angs_stop_arr_rh angs_stop_arr_gc]')';%angs_stop_arr_gc; % circ_mean([angs_dep_arr_rh'; angs_dep_arr_gc'])';%  
    
    %             mn_angs_arr = (calibr_comp(2)~=2)*circ_mean(angs_stop_arr_rh) ...
    %                 + (calibr_comp(2)==2)*circ_mean(angs_stop_arr_gc); % circ_mean([angs_dep_arr_rh' angs_dep_arr_gc']');
    %            [~,var_ang_arr] =  circ_var([angs_stop_arr_rh' angs_stop_arr_gc']'); % pi; %
               
                std_ang_arrs = max(absDiffRad(mn_angs_arr,angs_stop_arr_rh),absDiffRad(mn_angs_arr,angs_stop_arr_gc)); % circ_std([angs_dep_stop_rh' angs_dep_stop_gc']);
                std_ang_arr = 2*quantile((std_ang_arrs),0.75);  
             
                zug_head_kappa = 1/(std_ang_arr^2);
    %             [~, std_ang_arr] = circ_std([angs_stop_arr_rh' angs_stop_arr_gc']');
    
                % to get ballpark range for inherited
                % zugkn angle (i.e. rel to magn or sun az) 
                % guesstimate offset for heading from inherited
                % angle
    
                % first estimate the decln and sun az at
                % stopover. for simplicity keep dates same as first
                % departure (may be light bias but ang spread
                % should catch proper angles)
                
                udy = round(mean(date_jul)); 
                [Bx_stop, By_stop,~] = igrf(udy,lat_bs_stops,lon_bs_stops, ...
                    zero_vec);
           
                    decln_stop = atan2(By_stop,Bx_stop);
                    
    %             end
    
    %                 zgkn_lots = vmrand(mn_angs_arr, 1/(10*var_ang_arr), [N_inds*10 1]); %
                allel_zugs(:,1,iz) = vmrand(mn_angs_arr, zug_head_kappa); % 
                allel_zugs(:,2,iz) = vmrand(mn_angs_arr, zug_head_kappa); % 
                % assume same sun azimuth as a ballpark guess
                if incl_sun
    %                                 [sun_az_stop,~] = SolarAzEl(dates,lat_bs_stops,lon_bs_stops,zero_vec);
                    sun_az_stop = sun_az_0; % sun_az_stop*deg2rad -pi;
                else
                    sun_az_stop = zero_vec;
                end
    
    
                % add offsets for compass strategy to assess if init heads are
                % 'on track' within +/- 90 degs
                if add_az_inher
                    
                    allel_zugs(:,:,iz) = allel_zugs(:,:,iz) - ...
                    (add_decl_inher == 1)*median(decln_stop) - ...
                    (add_az_inher)*(circ_median(sun_az_stop)*sign(sign_clockw_sun) + ...
                        2*(sign_clockw_sun==-1 && geo_mag_refl_sun_opt == 2)*median(decln_stop));
                    
                else
                    
                    allel_zugs(:,:,iz) = allel_zugs(:,:,iz) - ...
                    (add_decl_inher == 1)*median(decln_stop);
                    
                end
                
            else
    
                % magcl transverse (Kiep) or pll inverted,
                % restricted init range works better
                allel_zugs(:,1,1:2,iz) = randinterval(pi,pi+sign_mn_ang*pi/12,[N_inds 2]) ...
                    - (endog_comp == 1)*median(decln_stop); %
                allel_zugs(:,2,1:2,iz) = randinterval(pi,pi+sign_mn_ang*pi/12,[N_inds 2]) ...
                    - (endog_comp == 1)*median(decln_stop); %
    %                             zgkn_fun = zgkn_lots;
    
            end
    
                allel_zugs(:,:,iz) = allel_zugs(:,:,iz)-pi;
    
    
        end
    
        for iz = iz+1:n_zugs
    
            allel_zugs(:,:,iz) = allel_zugs(:,:,iz-1);
    
        end
    
        clear zgkn_lots zugkn_init_lots  within_bounds absDiff zgkn_fun
    
    else
    
        if n_zugs > 0
            for iz = 1:n_zugs
    %             allel_zugs(:,iz) = inher_heads(randperm(length(inher_heads)));
                allel_zugs(:,1,1:2,iz) = allel_heads(randperm(size(allel_heads,1)),1:2,1);
                allel_zugs(:,2,1:2,iz) = allel_heads(randperm(size(allel_heads,1)),1:2,2);
            end
    %     else
    % %         allel_zugs = inher_heads(randperm(length(inher_heads)));
    %          allel_zugs(:,1,:) = NaN_vec; % allel_heads(randperm(size(allel_heads,1)),1);
    %          allel_zugs(:,2,:) = NaN_vec; % allel_heads(randperm(size(allel_heads,1)),2);
    
        end
    
    end
    
    % shift to -180:180
    allel_zugs = mod(allel_zugs+pi,2*pi)-pi;

end

% determine phenotype from genotype

% if zug_opt

    [inher_heads, zugkn_inher_heads, zug_signps] = ...
        det_phentyp_2_chrms(allel_heads,allel_zugs,allel_sps, ...
        zug_signp,idx_avg_ms,idx_1ms,idx_2ms,N_avg_ms,N_1ms,N_2ms, ...
        idx_avg_ts,idx_1ts,idx_2ts,N_avg_ts,N_1ts,N_2ts,n_zugs);

% else
% 
%     inher_heads = ...
%         det_phentyp(allel_heads,allel_zugs,allel_sps, ...
%         idx_avgs,idx_1s,idx_2s,N_avgs,N_1s,N_2s,n_zugs);
% 
% end

% define half length selection on breeding grounds 
% from natal distance and winter connectivity
mn_d_dep = max_disp_d_dep/2;
std_d_dep = mn_d_dep/4;

if ~isinf(min_disp_d_dep)
    disp_d_dep = min_disp_d_dep + rand(N_inds,1)*(max_disp_d_dep-min_disp_d_dep);
    % disp_d_dep = min(max(mn_d_dep + randn(N_inds,1)*std_d_dep,min_disp_d_dep),max_disp_d_dep);
else
    disp_d_dep = Inf*one_vec;
end
if ~isinf(min_disp_d_arr)
    disp_d_arr = min_disp_d_arr + rand(N_inds,1)*(max_disp_d_arr-min_disp_d_arr);
else
       disp_d_arr = Inf*one_vec;
end 
if ~isinf(min_disp_d_zug)
    disp_d_zug = min_disp_d_zug + rand(N_inds,1)*(max_disp_d_zug-min_disp_d_zug);
else
       disp_d_zug = Inf*one_vec;
end 