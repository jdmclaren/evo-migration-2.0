addpath 'E:\evo_mdl_cst_gene\brewer\'
addpath 'E:\evo_mdl_cst_gene\circ_stats\'

if ~exist('plot_basic')
    plot_basic =  true; % false; %
end

plot_succ_opt =  true; % false; %
plot_stds_opt =  false;

plt_geo_hds = false; % true; % 

% if N_mig_Sims == 124
%     yrs = [1 60 124];
% elseif opt_fst_lst_yr
%     yrs = [1 N_mig_Sims];
% else
%     yrs = N_mig_Sims;
% end

% yrs = 1:N_mig_Sims;

% yr_str = yr_start + yrs -1;

hds_rng = (mig_sys~=12)*[160 220] + (mig_sys==12)*[-30 20];
arr_lons_rng = (mig_sys==12)*[150 190] + (mig_sys~=12)*[-20 30]; % [-15 10];
zg_lats_rng = [10 70];

edge_sz = 2.5; % 
[Lon_dep_poly, Lat_dep_poly] = create_poly(Dep_verts);
[Lon_arr_poly, Lat_arr_poly] = create_poly(Arr_verts);
min_lon = nanmin(Lon_dep_poly)*180/pi-2*edge_sz;
max_lon = nanmax(Lon_dep_poly)*180/pi+2*edge_sz;
min_lat = nanmin(Lat_dep_poly)*180/pi-edge_sz;
max_lat = nanmax(Lat_dep_poly)*180/pi+edge_sz;


fig_sz = [200 200 500 500]; % [200 200 400 400];
fig_sz_cb = [200 200 200 350];

% if max_lon > 70
%     max_lat = 90; 
% end

n_plot = min(1500,N_inds);
skp_plt = floor(N_inds/n_plot);

idx_pl = 1:skp_plt:N_inds;

if plt_geo_hds
    mn_hd = circ_mean(all_ys_init_geo_heads*pi/180,[],2)*180/pi;
    std_hd = circ_std(all_ys_init_geo_heads*pi/180,[],[],2)*180/pi;
else % inher i.e., mag or sun if non-geo inher
    mn_hd = circ_mean(all_ys_inher_heads*pi/180,[],2)*180/pi;
    std_hd = circ_std(all_ys_inher_heads*pi/180,[],[],2)*180/pi;
end

wts_arr = ones(N_inds, N_mig_Sims);
fnl_lons(all_ys_stoppedAndArrived) = all_ys_lon_fin(all_ys_stoppedAndArrived)*pi/180;

mn_lon_arr = mod(circ_mean(all_ys_lon_fin*pi/180,wts_arr,2)*180/pi,360);
std_lon_arr = circ_std(all_ys_lon_fin*pi/180,wts_arr,[],2)*180/pi;

succ_arrs = sum(all_ys_stoppedAndArrived,2)/N_mig_Sims*100;

display(num2str(round(1000*geomean(successful))/10))

    g_mn_hd = round(10*circ_mean(mn_hd*pi/180)*180/pi)/10;
    g_std_hd = round(10*circ_mean(std_hd*pi/180)*180/pi)/10;
    % mn_Zug = round(10*circ_mean(th_all_nxt_ids'*pi/180)*180/pi)/10;
    % std_Zug = round(10*circ_std(th_all_nxt_ids'*pi/180)*180/pi)/10;
    display(num2str([g_mn_hd g_std_hd]))

    mn_lon_lnd = round(10*circ_mean(mn_lon_arr*pi/180)*180/pi)/10;
    std_lon_lnd = round(10*circ_std(mn_lon_arr*pi/180)*180/pi)/10;
    % display(num2str([mn_lon_lnd std_lon_lnd]))

    lq_lon_lnd = round(10*quantile(mn_lon_arr,0.05))/10;
    uq_lon_lnd = round(10*quantile(mn_lon_arr,0.95))/10;
    display(num2str([mn_lon_lnd lq_lon_lnd uq_lon_lnd]))

    % [q,U2_obs,U2_H0]=watsons_U2_perm_test(all_init_ths,th_all_nxt_ids,1e4);
    % disp(['p subsequent landings flown same direction < ' num2str(ceil(1e3*q)/1e3)])

if plot_basic

    
    if plot_succ_opt
    
        plt_fld = succ_arrs;
        cmap_scheme = '*YlOrRd';
        plot_conts_hds_arrs
        
    end
        
    plt_fld = mn_hd;
    cmap_scheme = 'RdBu';
    plot_conts_hds_arrs
    cb = colorbar %('SouthOutside');
    set(gca,'FontSize',16)
    title(cb,'Heading (^o)')
    
    plt_fld = mn_lon_arr;
    cmap_scheme = '*Greens';
    plot_conts_hds_arrs
    colorbar

    if plot_stds_opt
    
        plt_fld = std_hd;
        plot_conts_hds_arrs
        colorbar
        
        plt_fld = std_lon_arr;
        plot_conts_hds_arrs
        colorbar

    end

end

% figure('Position',fig_sz)
% colormap(brewermap([],'*RdYlBu')) 
% lon_arrs = all_ys_lon_fin(thous_arr,iy);
% 
% if mig_sys == 12
% 
%     lon_arrs = mod(lon_arrs,360);
% 
% end

% land = shaperead('landareas', 'UseGeoCoords', true);
% ax = worldmap([min_lat max_lat],[min_lon max_lon]);
% geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
% scatterm(blats(thous_arr,1)*180/pi, ...
% blons(thous_arr,1)*180/pi,20,lon_arrs,'o','fill')
% mlabel('off'); plabel('off'); gridm('off')
% clim(arr_lons_rng)
% title({[num2str(iy_str(iy)) ' Arrival'], ' Longitude (^o)'},'FontSize',11);
% 
% % if iy == numel(iys)
% %     figure('Position',fig_sz_cb)
%     cb = colorbar('FontSize',10); % ('Location','SouthOutside');
%     clim(arr_lons_rng)
%     title(cb,{'Arrival', 'Longitude (^o)'},'FontSize',10);

