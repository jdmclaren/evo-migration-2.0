% addpath 'D:\Oldenburg_models\generic_comp_mig_model\brewer'
% 
addpath 'E:\evo_mdl_cst_gene'
addpath 'E:\evo_mdl_cst_gene/new_GSHHS/'
addpath 'E:\evo_mdl_cst_gene/brewer/'
addpath 'E:\evo_mdl_cst_gene/circ_stats/'

cb_opt = false; % true; % 

plot_hybrd =  false; % true; %  mig_sys == 2; % 

% figure
cmaps_solid = colormap(brewermap(9,'Set1')); % 6,'Dark2'));
rd_col = cmaps_solid(1,:);
bl_col =  cmaps_solid(2,:);
gr_col = cmaps_solid(3,:);
prp_col = cmaps_solid(4,:);
orng_col = cmaps_solid(5,:);
brn_col = cmaps_solid(7,:);
pnk_col = cmaps_solid(8,:);

cmaps_dark = colormap(brewermap(8,'Dark2'));
dk_pnk_col =  cmaps_dark(4,:);

cmaps_set1 = colormap(brewermap(9,'Set1')); %
grn_col_2 = cmaps_set1(3,:);
orng_col_2 = cmaps_set1(5,:);
ylw_col_2 = cmaps_set1(6,:);

arr_col = 'w'; % dk_gr_col; % 

fail_clr = pnk_col; % prp_col;

succ_clr = 'Greens'; % 'Oranges'; %  'Reds'; %  'YlOrBr'; % 'Blues'; % 

if ~exist('plot_fails')
    plot_fails = false % true % 
end

% for zug shapes
mkr_shp = {'o','s','>'};

if ~exist('plot_Zug_ellipse')
    plot_Zug_ellipse = true % false % 
end

if plot_Zug_ellipse
    plot_arrs = false;
    new_fig =false;
end

if ~exist('plot_stop_poly')
    plot_stop_poly =  false % true %
end

if ~exist('plot_ends')
    plot_ends = true % false % 
end

if ~exist('plot_zug')
    plot_zug = false % true % 
end

if ~exist('plot_zug_fails')
    plot_zug_fails =  true % false % 
end

if ~exist('plot_stops')
    
    plot_stops = false; %  true; % 

end

plot_order_Lon =  is_whtr | mig_sys == 2; % false; % 
ord_EW = 1; % 2; % 

% resolution of maps to look like trajectories
% rather than scatter plots
n_substp = 96; % 24; 
d_substp = 1/n_substp;

% if ~exist('plot_fails')
%     % 1 geo 2 mag 3 sun
%     plot_fails =  false % true % 
% end

if ~exist('clr_fails')
    clr_fails = true % false % 
end

if ~exist('plot_poly_opt')
    % 1 geo 2 mag 3 sun
    plot_poly_opt = 0 %1   3 %  
end

if ~exist('heads_type')
    % 1 geo 2 mag 3 sun
    heads_type = 1 % 2 %  3 %  
end

if ~exist('trj_clr_opt')
%     plot option 1 = init heading 2 = init Lon
    trj_clr_opt = 2; % 2*(mig_sys ~= 2) + 1*(mig_sys == 2);
end

if heads_type == 1
    
    all_heads = all_geo_heads; % mod(all_geo_heads+180,360)-180;

elseif heads_type == 2
    
    all_heads = all_mag_heads;
    
else
    
    all_heads = all_sun_heads; 
    
end

if ~exist('transp_plot')
    
    transp_plot = 0.2; % 0.55
    
end

% mag_str = {'', 'incl signpost ','decln signpost ','total str signpost ','vert str ','trsv magncl ','pll magncl ','horiz str '};
strat_string = [z_str{any_zug+1} zug_str{zug_signp+1} mag_str{calibr_comp(1)+1} ...
    sun_str{calibr_comp(2)+1} geo_str{calibr_comp(3)+1} magn_star_night_str{magn_star_night} cst_str{dtrCstOpt+1} ...
    reO_str{reOrWtr_opt+1}];

disp_summry_stats

% map ranges
if mig_sys == 1
    min_lat = -15;
    max_lat = 70;
    min_lon = -130; % + (magn_comp_nr == 4)*40;
    max_lon = -45; % 25; %  + (magn_comp_nr == 4)*40;
    map_proj = 'stereo'; % 'Mercator';      
elseif mig_sys == 2 % || mig_sys == 6
    min_lat = -0.5;
    max_lat = 70;
    min_lon = -22.5; % + (magn_comp_nr == 4)*40;
    max_lon = 65; % 25; %  + (magn_comp_nr == 4)*40;
    map_proj =  'Mercator'; % 'stereo'; %
    map_lat_cntr = 35; % (min_lat + max_lat)/2;
    map_lon_cntr = 0; % (min_lon + max_lon)/2;
    FLatLims = [90 90]; % [30 40]; % [0
elseif mig_sys == 3 % mig_sys = 3; [-190 -150 60 71], ...
    min_lat = 25; %  7.5; %  5; % -5;  % 
    max_lat = 90;
    min_lon = -180; % + (magn_comp_nr == 4)*40;
    max_lon = 180; % 25;
%     map_proj = 'stereo'; %  'eqdazim'; %  'Robinson'; % 'gnomonic'; % 'mollweid'; % 'ortho'; % 'stereo'; % 'Mercator'; %   % 'stereo'; % 'Mercator'; %  %    %
     map_proj = 'Ortho'; % 'Mercator';  % 'stereo'; %  
    FLatLims = [40 70]; %[60 70]; %[0
    map_lat_cntr = 60; % 55; %  90; %(min_lat + max_lat)/2;
    map_lon_cntr = 40; % (
elseif mig_sys == 4 % mig_sys = 3; [-190 -150 60 71], ...
    min_lat = -15;
    max_lat = 80;
    min_lon = 0; % + (magn_comp_nr == 4)*40;
    max_lon = 225; % 360; % 25;
    map_proj =  'Mercator'; % 'stereo'; %
        map_lat_cntr = 50; % (min_lat + max_lat)/2;
    map_lon_cntr = 95; % (min_lon + max_lon)/2;
    FLatLims = [80 80]; % [90 90]; % [0
elseif mig_sys == 6 % mig_sys == % mig_sys = 4; 
    min_lat = 2.5;
    max_lat = 57.5;
    min_lon = -25; % + (magn_comp_nr == 4)*40;
    max_lon = 20; % 25;
    map_proj =   'stereo'; % 'Mercator';  %
elseif mig_sys == 8
    min_lat = -15;
    max_lat = 75;
    min_lon = -150; % + (magn_comp_nr == 4)*40;
    max_lon = -45; % 25; %  + (magn_comp_nr == 4)*40;
    map_proj = 'stereo'; % 'Mercator';   
elseif mig_sys == 5 
    min_lat = 10; % -5 % 
    max_lat =  85; %70 % 
    min_lon = -85; % + (magn_comp_nr == 4)*40;
    max_lon = 45; % 
    map_proj =  'stereo'; % 'Mercator';  % 
    map_lat_cntr = 45; % (min_lat + max_lat)/2;
    map_lon_cntr = -20; % (min_lon + max_lon)/2;
    FLatLims = [43.5 43.5]; %[0
elseif mig_sys == 9 
    min_lat = -5 % 10;
    max_lat =  80; % 70 %
    min_lon = 0; % + (magn_comp_nr == 4)*40;
    max_lon = 220; % 
    map_proj =  'stereo'; % 'Mercator';  %
elseif mig_sys > 9 &&  mig_sys < 12 % Blackpolls
    min_lat = 5 % 10;
    max_lat =  65; % 70 %
    min_lon = 170; % + (magn_comp_nr == 4)*40;
    max_lon = 310; % 
%     map_proj =  'Mercator'; % 'stereo'; %
    map_lat_cntr = 42.5; % (min_lat + max_lat)/2;
    map_lon_cntr = 267.5; % (min_lon + max_lon)/2;
    FLatLims = [52.5 45]/1.15; % [90 90]; % [0
%     Arr_verts{iArr}(3) = Arr_verts{iArr}(3)*1.5;
%     Dep_verts{1}(1) = Dep_verts{1}(1) + 5*pi/180;
    map_proj =  'stereo'; % 'Mercator';  %
elseif mig_sys == 12 % LB Cuckoo NZ
    min_lat = -55 % 10;
    max_lat =  7.5; % 70 %
    min_lon = 135; % + (magn_comp_nr == 4)*40;
    max_lon = 225; % 
%     map_proj =  'Mercator'; % 'stereo'; %
    map_lat_cntr = -28.5; % 42.5; % (min_lat + max_lat)/2;
    map_lon_cntr = 177; % (min_lon + max_lon)/2;
    FLatLims = [40 40]; % [90 90]; % [0
%     Arr_verts{iArr}(3) = Arr_verts{iArr}(3)*1.5;
%     Dep_verts{1}(1) = Dep_verts{1}(1) + 5*pi/180;
    map_proj = 'Mercator';  %'stereo'; % 
else % == 7 just Greenland knot tracks
    min_lat = 35 % 10;
    max_lat =  85; % 70 %
    min_lon = -90; % + (magn_comp_nr == 4)*40;
    max_lon = 20; % 
    map_proj =  'stereo'; % 'Mercator';  %'ortho'; %
end

zug_kn_cols = {'mx','wx','rx'};

FigSz = 575; % 350; % 
figure('Position',[200 200 FigSz FigSz])
bg_clr = 0.94; % 1; % 0.825;
set(gcf,'color',[bg_clr bg_clr bg_clr]); % [0.9 0.9 0.9]);

if mig_sys == 12 || (trj_clr_opt == 1 || trj_clr_opt >= 3)
    
    colormap(brewermap([],'*RdYlBu')); % succ_clr)); %'Oranges')); % 'Blues')); %  '*RdYlBu'))   
    
else
    
    colormap(brewermap([],'RdYlBu'))
    
end

land = shaperead('landareas','UseGeoCoords', true);

if mig_sys == 12 
  MkSzArr = 4;
  N_cntr = 50;
  Alf = 1;% 0.5;
  Alf_fl = 0.5;
elseif mig_sys > 9 
  MkSzArr = 1.5;
  N_cntr = 300;
  Alf = 1;% 0.5;
  Alf_fl = 0.5;
elseif mig_sys ~= 3
  MkSzArr = 3;
  N_cntr = 360;
  Alf = 1;% 0.5; 
  Alf_fl = 0.5;
else
  MkSzArr = 0.7;
  N_cntr =  150; %350; % 
  Alf = 1;% 0.5;
  Alf_fl = 0.5;
end

ax = worldmap([min_lat max_lat],[min_lon max_lon]);
setm(ax,'mapprojection',map_proj)
if strcmp(map_proj,'Mercator')
    map_lat_cntr = (min_lat + max_lat)/2;
    map_lon_cntr = (min_lon + max_lon)/2;
    FLatLims = [100 100]; %[50 50]; %[0
elseif strcmp(map_proj,'Ortho')
    setm(ax,'mapprojection',map_proj,'Origin',[map_lat_cntr map_lon_cntr])
else % 'Stereo'
   ax = axesm ('stereo', 'Frame', 'on', 'Grid', 'off','Origin',[map_lat_cntr map_lon_cntr 0],'FlineWidth',1);
   ax.PositionConstraint = 'innerposition';
   axis('off')
   setm(gca,'FLatLimit',FLatLims)
end

lnd_clr = 0.75; %  0.775; %  0.875; % [0.875 0.9 0.865 ]
geoshow(land, 'FaceColor',[0.825 0.885 0.815 ],'EdgeColor',[0.65 0.65 0.65]) %
% geoshow(land, 'FaceColor', [lnd_clr lnd_clr lnd_clr],'LineWidth',0.2) %[0.85 0.85 0.85]

N_plt = min(size(blat_succs,1),N_cntr);

% if ord_EW == 1
%     [~,plt_ord] = sort(blons(1:N_plt,1)); % ,'descend'
% else
%     [~,plt_ord] = sort(blons(1:N_plt,1),'descend'); %     
% end
% N_plt = 100;

if ~plot_hybrd
    plt_ord = 1:N_plt; % find(stoppedAndArrived,N_plt,'first'); % 
    % find(idx_deps ==2,N_plt,'first'); %  stoppedAndArrived(7001:7100); % end:-1:(8062-N_plt+1));
else
    plt_ord = find(sum(all_allels(:,:,2),2) == 1 & sum(all_allels(:,:,1),2) > 0, N_plt,'first');
end

% plt_ord = [SWG_locs(1:50)'  Iq_locs(1:50)']; % SWG_locs(1:100); % 

% boost NA tracks for wheatears
if mig_sys == 3
    n_NA_0s = N_plt/10;
    idx_NAs = find(stoppedAndArrived(N_plt+1:end) & ...
        (blons(N_plt+1:end,1) > pi | blons(N_plt+1:end,1) < 0), ...
        n_NA_0s,'first');
    n_NAs = numel(idx_NAs)-1;
    plt_ord(N_plt-n_NAs:N_plt) = N_plt+ idx_NAs;
elseif mig_sys == 5
    n_HiLat_0s = N_plt/5;
    idx_HiLats = find(stoppedAndArrived(N_plt+1:end) & ...
        (blats(N_plt+1:end,1) > 70*pi/180), ... %  & idx_deps(N_plt+1:end) == 2
        n_HiLat_0s,'first');
    n_HiLats = numel(idx_HiLats)-1;
    plt_ord(N_plt-n_HiLats:N_plt) = N_plt+ idx_HiLats;
elseif mig_sys == 2
    if ~plot_hybrd

        n_Scan_0s = N_plt/6;
        idx_Scans = find(stoppedAndArrived(N_plt+1:end) & ...
            blons(N_plt+1:end,1) > 15*pi/180 & ...
            blons(N_plt+1:end,1) < 35*pi/180 & ...
            blats(N_plt+1:end,1) > 57.5*pi/180, ...
            n_Scan_0s,'first');
        n_Scans = numel(idx_Scans)-1;
        plt_ord(N_plt-n_Scans:N_plt) = N_plt+ idx_Scans;

    end

        % plt_ord(N_plt-n_Scans:N_plt) = N_plt+ idx_Scans;

    % end
    % N_plt = N_plt+n_Scans;
end

    
for iii = 1:N_plt
%     ndi = find(day_step(ii) == max(day_step),1,'first');
% if blons(ii,1) > -pi/3
%     keyboard
% end
    if plot_order_Lon
        ii =  plt_ord(iii); %
    else
        ii =  iii; % plt_ord(iii); %
    end
     nstpi = min(n_fl_step(ii)+1,size(blat_succs,2));
     if mig_sys ~= 4
        blons_i = mod(rad2deg(blons(ii,1:nstpi))+180,360)-180;
     else
        blons_i = mod(rad2deg(blons(ii,1:nstpi)),360);
     end
     sgn_chgs = sign(blons_i(1:end-1).*blons_i(2:end)) < 0;
     dat_lin_cross = find(sgn_chgs & abs(blons_i(1:end-1)) > 160);

     blats_i = rad2deg(blats(ii,1:nstpi));
     hds_i = all_geo_heads(ii,1:nstpi); % all_max_hrs_flt(ii,1:nstpi); % 
     max_hrs_flt_i = all_max_hrs_flt(ii,1:nstpi); % all_ovr_wtr(ii,1:nstpi); % 
     cum_h_flt_i = all_cum_h_flt(ii,1:nstpi); % 0*
     days_i = all_dates(ii,1:nstpi);

% flight step counter
     stps_i = 1:nstpi;
     stops_i = find(all_stp_ovs(ii,stps_i) > 0);
% within flight step counter (assume ~8 fl hours)
     substps_i = 1:d_substp:nstpi;
     lons_intp = interp1(stps_i,blons_i,substps_i);
     % now correct for any sign change
     if ~isempty(dat_lin_cross) 
%          fst_rec = 1;
         for ilc = 1:numel(dat_lin_cross)
             dlc = dat_lin_cross(ilc);
             idx = n_substp*(dlc-1)+(1:n_substp);
             sgn_1 = sign(blons_i(dlc));
             lons_intp(idx) = linspace(blons_i(dlc), ...
                 blons_i(dlc+1)+360*sgn_1,n_substp);
         end
%      else
%         lons_intp = interp1(stps_i,blons_i,substps_i);
     end

     lats_intp = interp1(stps_i,blats_i,substps_i);     
     hds_intp = interp1(stps_i,hds_i,substps_i);    
     hs_left_intp = interp1(stps_i,max_hrs_flt_i - cum_h_flt_i,substps_i);   
     days_intp = interp1(stps_i,days_i - days_i(1),substps_i);   

     if trj_clr_opt == 1
         plot_var = hds_intp;
         cb_titl = {'Flight', 'direction (^o)'}; % {'Geographic', 'heading (^o)'};
     elseif trj_clr_opt == 2
         plot_var =  blons_i(1)*ones(size(lats_intp)); % rad2deg(lat_bs_zugs(ii))*ones(size(lats_intp)); %
         cb_titl = {'Departure',  'Longitude (^o)'}; % 'Latitude (^o)'}; % 
     elseif trj_clr_opt == 3
         plot_var = hs_left_intp; %  days_intp; % 
         cb_titl =  {'Remaining flt hrs'}; %{'Cumulative days'}; %
     else
         plot_var =  days_intp; % 
         cb_titl =  {'Cumulative days'}; %         
     end
     
    if stoppedAndArrived(ii) == 1
                    
         h = scatterm(lats_intp,lons_intp,MkSzArr, ...
             plot_var,'fill'); % ,'LineWidth',1);
            h.Children.MarkerFaceAlpha = Alf; 
        if plot_ends
           h = scatterm(blats_i(end),blons_i(end),15, ...
             arr_col,'fill'); % ,'LineWidth',1);
            h.Children.MarkerFaceAlpha = Alf; 
            h.Children.MarkerEdgeColor = 'k'; 
        end
        if plot_stops && ~isempty(stops_i)
            for iis = 1:numel(stops_i)
                isi = stops_i(iis);
               h2 = scatterm(blats_i(isi),blons_i(isi),20, ...
               'g','fill'); % ,'LineWidth',1);
                % h2 = scatterm(blats_i(isi),blons_i(isi),10, ...
                %      plot_var(isi),'fill'); % ,'LineWidth',1);
                 h2.Children.MarkerFaceAlpha = Alf; 
                  h2.Children.MarkerEdgeColor = 'k'; 
            end
        end

        if plot_zug && ~isnan(lon_bs_zugs(ii))
            for iz = 1:n_zugs
                 h = scatterm(lat_bs_zugs(ii,iz)*180/pi,lon_bs_zugs(ii,iz)*180/pi,100, ...
                'Marker',mkr_shp{iz},'MarkerEdgeColor','k','LineWidth',1); % plot_var(1)
                h.Children.MarkerFaceAlpha = Alf; 
            end
        end

    elseif plot_fails
        
%         if clr_fails
% 
%              h = scatterm(lats_intp,lons_intp,MkSzArr/2, ...
%              'm','fill'); % ,'LineWidth',1);
%             h.Children.MarkerFaceAlpha = Alf; 
% 
%         else % if mod(iii,2) == 0

            %  h = scatterm(lats_intp,lons_intp,MkSzArr/3, ...
            %  fail_clr,'fill');
            % h.Children.MarkerFaceAlpha = Alf_fl; 

             % h = scatterm(lats_intp,lons_intp,MkSzArr, ...
             % plot_var,'fill'); % ,'LineWidth',1);

%         end

         if plot_ends % && mod(iii,2) == 0
             h = scatterm(lats_intp(end),lons_intp(end),45, ...
             fail_clr,'Marker','x','LineWidth',0.6); %1
        end

         h = plotm(lats_intp,lons_intp,'m'); % ,'LineWidth',1);
         if plot_stops && ~isempty(stops_i)
             for iis = 1:numel(stops_i)
                isi = stops_i(iis);
                h2 = scatterm(blats_i(isi),blons_i(isi),10, ...
                     plot_var(isi),'s','fill'); % ,'LineWidth',1);
                 h2.Children.MarkerFaceAlpha = Alf; 
                  h2.Children.MarkerEdgeColor = 'k'; 
            end
             scatterm(blats_i(stops_i),blons_i(stops_i),35, ...
                 'Color',fail_clr,'Marker','x'); % ,'LineWidth',1);
         end
         if plot_zug && ~isnan(lon_bs_zugs(ii)) && plot_zug_fails
             for iz= 1:n_zugs
                 h = scatterm(lat_bs_zugs(ii,iz)*180/pi,lon_bs_zugs(ii,iz)*180/pi,100, ...
                'Marker',mkr_shp{iz},'MarkerEdgeColor',fail_clr,'LineWidth',1); %  plot_var(1),
                h.Children.MarkerFaceAlpha = Alf; 
             end
        end
    end

end

clim_cb = clim;

if plot_poly_opt == 1

    plot_dep_stop_arr_polys

end
 

 % if dtrCstOpt || reOrWtr_opts
 %    caxis([90 315])
 % end

if cb_opt
     hh = colorbar;
     set(hh,'position',[.885 .2 .025 .6])  % [.825 .2 .025 .6]) 
    % set(hh,'position',[.825 .125 .05 .75])
    title(hh,cb_titl,'FontSize',10)
    if trj_clr_opt == 1
        clim([45 240])
        set(hh,'YTick',45:45:225)
    end
end
% addpath 'D:\generic_comp_rte_mdl\brewer'

tightmap

cols = {'b','r','g'};

if mig_sys ~=12
    gridm('off'); mlabel('off'); plabel('off'); 
end

if (mig_sys >= 3 && mig_sys <= 5) 
%     hold
    load coastlines; plotm(coastlat,coastlon,'Color',[0.06 0.35 0.2],'LineWidth',0.5) % 'g')

elseif mig_sys == 12 % use hi res coast for cuckoos on micronesia

    dk_gr_col = [0.06 0.35 0.2];
    ncfile = 'new_GSHHS/dist_to_GSHHG_v2.3.7_1m.nc' ; % nc file name
    % To get information about the nc file
    % ncinfo(ncfile)
    % % to display nc file
    % ncdisp(ncfile)
    % to read a vriable 'var' exisiting in nc file
    lon_GSH = ncread(ncfile,'lon');
    lat_GSH = ncread(ncfile,'lat') ;
    d_cst = ncread(ncfile,'dist');
    [Lns,Lts] = meshgrid(lon_GSH(:),lat_GSH(:));
    [Lns_nd,Lts_nd] = ndgrid(lon_GSH,lat_GSH);
    on_lnd = d_cst >0 & d_cst < 3;
    Lats_lnd = Lts_nd(on_lnd);
    Lons_lnd = Lns_nd(on_lnd);
    coastlat = Lats_lnd;
    coastlon = Lons_lnd;
    scatterm(coastlat,coastlon,2, ...
        dk_gr_col,'filled') % 'g')

    LnClr = brn_col; % grn_col_2; %  ylw_col_2;
    LW = 1.75;

    if plot_poly_opt
        for iA = 1:n_Arr_polys
            Arr_LL = Arr_verts{iA}*180/pi; % [160 215 -20 -5]
            plotm([Arr_LL(3) Arr_LL(4)],[Arr_LL(1) Arr_LL(1)], ...
                'Color',LnClr,'LineWidth',LW,'LineStyle','-.')
            plotm([Arr_LL(3) Arr_LL(4)],[Arr_LL(2) Arr_LL(2)], ...
                'Color',LnClr,'LineWidth',LW,'LineStyle','-.')
            plotm([Arr_LL(3) Arr_LL(3)],[Arr_LL(1) Arr_LL(2)], ...
                'Color',LnClr,'LineWidth',LW,'LineStyle','-.')
            plotm([Arr_LL(4) Arr_LL(4)],[Arr_LL(1) Arr_LL(2)], ...
                'Color',LnClr,'LineWidth',LW,'LineStyle','-.')
        
            plotm([min_lat+0.1 max_lat-0.1],[180 180], ...
                'Color','k','LineWidth',LW/2,'LineStyle',':')
        end
    end

end

% if plot_Zug_ellipse && zug_opt == 1
%     plot_drft_connect_single_yr_clr
% end

% keyboard

figure
hh = colorbar;
 set(hh,'position',[.885 .2 .025 .6])  %
clim([floor(clim_cb(1)) ceil(clim_cb(2))])
% set(hh,'YTick',45:45:225)
title(hh,cb_titl,'FontSize',10)
box off
axis off
colormap(brewermap([],'*RdYlBu'))

figure('Position',[200 200 900 120])
hold
stairs(yr_start:yr_start+N_mig_Sims-1,100*successful,'Color', ...
    orng_col,'LineStyle',':','LineWidth',1.5) % orng bl gn - : -. gr_col
stairs(yr_start:yr_start+N_mig_Sims-1,100*successful,'Color', ...
    gr_col,'LineStyle','-','LineWidth',1.5) % orng bl gn
stairs(yr_start:yr_start+N_mig_Sims-1,100*successful,'Color', ...
    bl_col,'LineStyle','--','LineWidth',1.5) % orng bl gn

set(gca,'FontSize',8)
xlim([yr_start-1 yr_start+N_mig_Sims])
ylim([0 100]) % 32 88])
xlabel('Year','FontSize',10)
ylabel({'Arrival'; 'Success (%)'},'FontSize',10)