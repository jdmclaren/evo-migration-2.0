function [coastlat,coastlon, near_idx_cst, d_cst_vec, igrfcoefs, ...
    hi_elevs, barrens, ...
    poor_stops, ok_veg_breed, ndvi, veg_stp_md, veg_stp_95, ...
    veg_stp_sum_md, veg_stp_sum_95, thr_veg_stp, ...
    near_idx_hrzn, d2_hrzn, Lns_ndh, Lts_ndh] = ...
    load_geo_data(geo_filnm, thrsh_snow_barrn, ...
    thrsh_elev,thrsh_ndvi_breed, thrsh_ndvi_stop_min, thrsh_trees_breed, ...
    thrsh_trees_stop,max_trees_stop,thrsh_conif_breed,thrsh_low_veg_breed, ...
    thrsh_low_veg_stop,thrsh_all_veg_stop,min_any_veg_stp, ...
    near_dateline,veg_mod_pal,hrzn_opt,fl_alt_lev)

R_Earth_km = 6371;
% km_deg = R_Earth_km*pi/180;

% load geomagnetic, elevation and landcover data
igrfcoefs = load([geo_filnm '/igrf_data/igrfcoefs']);

% folder name for 1 degree data
one_deg_fnm = [geo_filnm '/mdl_1_deg_data'];


% load topography: coast and elevation data
% load coastlines
% coastlat = coastlat*pi/180;
% coastlon = coastlon*pi/180;
ncfile = ([geo_filnm '/dist_to_GSHHG_v2.3.7_1m.nc']);

% finfo = ncinfo(ncfile)
% finfo.Dimensions.Name
% finfo.Variables.Name

lon = ncread(ncfile,'lon');
lat  = ncread(ncfile,'lat') ;
d_cst = ncread(ncfile,'dist');

id_grid = reshape(1:numel(d_cst),numel(lon),numel(lat));
% create function for nearest GSHHG grid cell
% If near dateline (within 30 degs), use abs(Lon)

% near_idx_cst gives nearest pt on coastal grid 
% for assessing d_cst(any locn)
[Lns_nd,Lts_nd] = ndgrid(lon,lat);
near_idx_cst = griddedInterpolant(Lns_nd,Lts_nd,id_grid,'nearest');

on_lnd = d_cst >0 & d_cst < 3;
Lats_lnd = Lts_nd(on_lnd);
Lons_lnd = Lns_nd(on_lnd);
coastlat = Lats_lnd*pi/180;
coastlon = near_dateline*Lons_lnd*pi/180 + ...
    ~near_dateline*(mod(pi+Lons_lnd*pi/180,2*pi)-pi);

d_cst_vec = d_cst(:);

% if hrzn option same for horzn dist
if hrzn_opt

   load([geo_filnm  '/Hrzns_1_60th_deg'])
   load([geo_filnm  '/all_veg_60_S_Pcfc'])

   % d2_hrzn = (Hrzns{fl_alt_lev}/R_Earth_km).^2;
   d2_hrzn = ((Hrzns{fl_alt_lev})/R_Earth_km).^2;
   idh_grid = reshape(1:numel(d2_hrzn),size(d2_hrzn,1),size(d2_hrzn,2));
   % [Lns_ndh,Lts_ndh] = ndgrid(Lon_hrzns,Lat_hrzns);
   [Lts_ndh,Lns_ndh] = ndgrid(Lat_hrzns,Lon_hrzns);
   Lns_ndh = Lns_ndh*pi/180;
   Lts_ndh = Lts_ndh*pi/180;
   % near_idx_hrzn = griddedInterpolant(Lns_ndh,Lts_ndh,idh_grid,'nearest');
   near_idx_hrzn = griddedInterpolant(Lts_ndh,Lns_ndh,idh_grid,'nearest');

   % to remove erroneous islands in SW Pacific, find locs with 
   % neg d2cst and set to zero in DEM
   is_wtr = d_cst < 0;
   Lt_wtr = Lts_nd(is_wtr);
   Ln_wtr = Lns_nd(is_wtr);
   id_h_wtr = near_idx_hrzn(Lt_wtr(:)*pi/180,Ln_wtr(:)*pi/180);
   d2_hrzn(id_h_wtr) = 0;

   % also remove non-vegtated islands, say < 5% leafy landcover
   is_brn_SP = flipud(all_leaf_SP) < 0.05;
   Lt_bsp = Lts_ndh(is_brn_SP);
   Ln_bsp = Lns_ndh(is_brn_SP);
   id_brn_SP = near_idx_hrzn(Lt_bsp(:),Ln_bsp(:)); % *pi/180
   d2_hrzn(id_brn_SP) = 0;   

    % now fix the coastal data! It also contains reefs e.g. Chesterfield Islands
    % and artefacts e.g. Sandy Is.  https://en.wikipedia.org/wiki/Sandy_Island,_New_Caledonia
    % If low-veg cells on land are flagged, they effectively become lakes
    id_brn_cst = near_idx_cst(mod(Lns_ndh(is_brn_SP)*180/pi,360),Lts_ndh(is_brn_SP)*180/pi);
    d_cst(id_brn_cst) = -1;
    d_cst_vec = d_cst(:);

else

    near_idx_hrzn = NaN;
    d2_hrzn = NaN;
    Lns_ndh = NaN;
    Lts_ndh = NaN;

end

% figure; imagesc(d_cst'); colorbar
% ax = gca;
% ax.YDir = 'normal';
% clim([-1 1])

% 1x1 elevation for high elevation
load([one_deg_fnm '/elev'])
hi_elevs = elev_1_deg > thrsh_elev;

% load landcover (snow, barren land and NDVI) 
load([one_deg_fnm '/snow_1_deg'])

load([one_deg_fnm '/barrn_1_deg'])
% load mean fall NDVI
load([one_deg_fnm '/ndvi_mn_fall'])
% load([one_deg_fnm '/ndvi_Sep'])
ndvi = double(ndvi_mn_fall); % double(ndvi_Sep); %  
load([one_deg_fnm '/all_trees_1_deg'])
load([one_deg_fnm '/conifers_1_deg'])
load([one_deg_fnm '/low_veg_1_deg'])
load([one_deg_fnm '/all_veg_1_deg'])
% load([one_deg_fnm '/all_veg_rWtr'])
load([one_deg_fnm '/non_grass_1_deg'])
% load([one_deg_fnm '/all_leaf_veg_1_deg'])
load([one_deg_fnm '/all_leaf_scrub_1_deg'])

load([one_deg_fnm '/all_veg_paleo_ann']); % '/all_veg_paleo_rel']);
% load([one_deg_fnm '/GPP_paleo']);
% 
% % use june july aug if above 37.5N (as stopgap for date driven stop quality)
% load([one_deg_fnm '/all_veg_paleo_jja']); % '/all_veg_paleo_rel']);
% load([one_deg_fnm '/GPP_paleo_jja']);

% Apr 2022 changed poor stops to both barren and low ndvi (rather than
% either)
% poor_stops = barrens & (ndvi_mn_fall(1:size(barrens,1),:) < thrsh_ndvi_stop);

% barrens = ndvi_mn_fall(1:size(snow,1),:) <  thrsh_ndvi_stop & ...
%     (snow > thrsh_snow_barrn | barrn > thrsh_snow_barrn);

ok_veg_breed = all_trees >= thrsh_trees_breed & ...
    conifers >= thrsh_conif_breed & ...
    low_veg >= thrsh_low_veg_breed & ...
    ndvi_mn_fall(1:size(snow,1),:) >= thrsh_ndvi_breed;
%     ndvi_Sep(1:size(snow,1),:) >= thrsh_ndvi_breed;

% keyboard;

if thrsh_trees_stop > 0

     veg_stp = all_trees;
    thr_veg_stp = thrsh_trees_stop;

elseif thrsh_low_veg_stop > 0

    veg_stp = low_veg;
    thr_veg_stp = thrsh_low_veg_stop;

else % thrsh_all_veg_stop >= 0

    veg_md = all_leaf_qs(:,:,4);
    % veg_uq = all_leaf_qs(:,:,4);
    veg_95 = all_leaf_qs(:,:,6);
    % veg_90 = all_leaf_qs(:,:,5);

    % veg_md = all_trees(:,:);
    % % veg_uq = all_leaf_qs(:,:,4);
    % veg_95 = all_trees(:,:);
    % % veg_90 = all_leaf_qs(:,:,5);

    if veg_mod_pal==1
        veg_stp_md = veg_md;
        veg_stp_95 = veg_95;
    else
        veg_stp_md = all_vegp{14}; 
        veg_stp_95 = all_vegp{14};
    end

    % veg_stp_md = (veg_mod_pal==1)*veg_90 + (veg_mod_pal==2)*all_vegp{14}; 
    % all_veg   ./all_vegp{1}.*(all_vegp{1}>=0.05); %all_veg; %  all_vegp{14} + all_veg - all_vegp{1}; %  max(all_veg, all_vegp{1}); 
    % veg_stp = GPPp{1}./all_vegp{1}.*(all_vegp{1}>=0.025); 
    % .*(all_vegp{1}>=0.05) 0.025; % log10(GPPp{1}); % GPPp{14}; %  
    thr_veg_stp = thrsh_all_veg_stop;
    
end

veg_stp_sum_md = veg_stp_md; % all_veg./GPPp{1}; % all_vegp{1}; %  + all_veg - all_vegp{1}; %   all_vegp_jja{14}; % all_vegp{1}; % 
veg_stp_sum_95 = veg_stp_95; %% veg_stp_sum = GPPp_jja{1}./all_vegp_jja{1}.*(all_vegp_jja{1}>=0.025); 

% poor_stops = ndvi_mn_fall(1:size(snow,1),:) < thrsh_ndvi_stop | ...
% poor_stops = (ndvi_Sep(1:size(snow,1),:) < thrsh_ndvi_stop_min) & ...
%     (all_trees(1:size(snow,1),:) < thrsh_trees_stop | ...
%     all_trees(1:size(snow,1),:) > max_trees_stop | ...
%     low_veg(1:size(snow,1),:) < thrsh_low_veg_stop | ...
%     all_veg(1:size(snow,1),:) < thrsh_all_veg_stop);

% poor_stops = (ndvi_Sep(1:size(snow,1),:) < thrsh_ndvi_stop_min) | ...

if ~hrzn_opt
    poor_stops = (ndvi(1:size(snow,1),:) <= thrsh_ndvi_stop_min) | ...
    (veg_stp_95 <= min_any_veg_stp) | (veg_stp_sum_95 <= min_any_veg_stp);
else
    poor_stops = false(size(veg_stp_sum_95));
end

barrens = poor_stops & (snow > thrsh_snow_barrn | barrn > thrsh_snow_barrn);

% i_i_i = 34;

