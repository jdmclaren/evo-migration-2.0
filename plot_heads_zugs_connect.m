addpath 'E:\evo_mdl_cst_gene\brewer\'

if ~exist('short_opt')
    short_opt = true; %  false; %
end

if ~exist('opt_fst_lst_yr')
    opt_fst_lst_yr = false; % true; % 
end

if N_mig_Sims == 124
    yrs = [1 60 124];
elseif opt_fst_lst_yr
    yrs = [1 N_mig_Sims];
else
    yrs = N_mig_Sims;
end

yr_str = yr_start + yrs -1;

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


fig_sz = [200 200 300 300]; % [200 200 400 400];
fig_sz_cb = [200 200 200 350];

% if max_lon > 70
%     max_lat = 90; 
% end

for iy = 1:numel(yrs)

    yr = yrs(iy);
    
    thous = min(sum(all_ys_stoppedAndArrived(:,yr)),2000);
    thous_arr = find(all_ys_stoppedAndArrived(:,yr), thous,'first');
    thous_not = min(sum(~all_ys_stoppedAndArrived(:,yr)),2000);
    thous_not_arr = find(~all_ys_stoppedAndArrived(:,yr), thous_not,'first');
    
    n_Arrs_plt = numel(thous_arr);

    figure('Position',fig_sz)
    land = shaperead('landareas', 'UseGeoCoords', true);
    ax = worldmap([min_lat max_lat],[min_lon max_lon]);
    geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
    sc = scatterm(blats(thous_arr,1)*180/pi, ...
    blons(thous_arr,1)*180/pi,20, ...
    all_ys_init_geo_heads(thous_arr,yr),'fill'); % 'LineWidth',1)
    sc.Children.MarkerFaceAlpha = 0.375; % min(.025*N_inds/min(size(blat_succs,1), ...
    colormap(brewermap([],'*YlOrRd'));
    mlabel('off'); plabel('off'); gridm('off')
    clim(hds_rng)
    title({[num2str(yr_str(iy)) ' Geogr.'], ' Heading (^o)'},'FontSize',11);

    colorbar

    if zug_opt && ~short_opt

        figure('Position',fig_sz)
        land = shaperead('landareas', 'UseGeoCoords', true);
        ax = worldmap([min_lat max_lat],[min_lon max_lon]);
        geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
        sc = scatterm(blats(thous_arr,1)*180/pi, ...
        blons(thous_arr,1)*180/pi,20, ...
        all_ys_zugkn_heads(thous_arr,yr),'fill'); % 'LineWidth',1)
        sc.Children.MarkerFaceAlpha = 0.375; % min(.025*N_inds/min(size(blat_succs,1), ...
        colormap(brewermap([],'*YlOrRd'));
        mlabel('off'); plabel('off'); gridm('off')
        clim(hds_rng)
        title({[num2str(yr_str(iy)) ' Zugkn'], ' Heading (^o)'},'FontSize',11);

    end

    if iy == numel(yrs) && ~short_opt
        figure('Position',fig_sz_cb)
        cb = colorbar('FontSize',10);
        clim(hds_rng)
        title(cb,{'Magnetic', 'Heading (^o)'},'FontSize',10);
        a =  cb.Position; %gets the positon and size of the color bar
        set(cb,'Position',[a(1) a(2)-0.05 a(3) a(4)]);% To c
        colormap(brewermap([],'*YlOrRd'));
        box off
        axis off
    end
    
    % if ~short_opt

        figure('Position',fig_sz)
        colormap(brewermap([],'*RdYlBu')) 
        lon_arrs = all_ys_lon_fin(thous_arr,yr);
    
        if mig_sys == 12
    
            lon_arrs = mod(lon_arrs,360);
    
        end
        
        land = shaperead('landareas', 'UseGeoCoords', true);
        ax = worldmap([min_lat max_lat],[min_lon max_lon]);
        geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
        scatterm(blats(thous_arr,1)*180/pi, ...
        blons(thous_arr,1)*180/pi,20,lon_arrs,'o','fill')
        mlabel('off'); plabel('off'); gridm('off')
        clim(arr_lons_rng)
        title({[num2str(yr_str(iy)) ' Arrival'], ' Longitude (^o)'},'FontSize',11);
    
        % if iy == numel(yrs)
        %     figure('Position',fig_sz_cb)
            cb = colorbar('FontSize',10); % ('Location','SouthOutside');
            clim(arr_lons_rng)
            title(cb,{'Arrival', 'Longitude (^o)'},'FontSize',10);
            % a =  cb.Position; %gets the positon and size of the color bar
            % set(cb,'Position',[a(1) a(2)-0.05 a(3) a(4)]);% To change size
            % colormap(brewermap([],'*RdYlBu')) 
            % box off
            % axis off
        % end

    % end

    % figure('Position',1.3*fig_sz)
    % colormap(brewermap([],'*RdYlBu')) 
    % lon_arrs = all_ys_lon_fin(thous_arr,yr);
    % land = shaperead('landareas', 'UseGeoCoords', true);
    % ax = worldmap([min_lat max_lat],[min_lon max_lon]);
    % geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
    % scatterm(blats(thous_arr,1)*180/pi, ...
    % blons(thous_arr,1)*180/pi,20,lon_arrs,'o','fill')
    % scatterm(blats(thous_not_arr,1)*180/pi, ...
    % blons(thous_not_arr,1)*180/pi,20,'kx')
    % 
    % mlabel('off'); plabel('off'); gridm('off')
    % clim(arr_lons_rng)
    % title({[num2str(yr_str(iy)) ' Arrival'], ' Longitude (^o)'},'FontSize',11);

    
    if zug_opt == 1 && ~short_opt
        
        figure('Position',fig_sz)
%         lon_arrs = mod(blons(thous_arr,end)*180/pi+180,360)-180;
        land = shaperead('landareas', 'UseGeoCoords', true);
        ax = worldmap([min_lat max_lat],[min_lon max_lon]);
        geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
        scatterm(blats(thous_arr,1)*180/pi, ...
        blons(thous_arr,1)*180/pi,20, ...
        all_ys_lat_zg(thous_arr,yr),'o','fill')
        colormap(brewermap([],'RdYlBu')) 
        % caxis([min(lon_arrs)) max(abs(lon_arrs))])
        mlabel('off'); plabel('off'); gridm('off')
        clim(zg_lats_rng)
        title({[num2str(yr_str(iy)) ' Zugknick'], ' Latitude (^o)'},'FontSize',11);

        if iy == numel(yrs)
            figure('Position',fig_sz_cb)
            cb = colorbar('FontSize',10); % ('Location','SouthOutside');
            clim(zg_lats_rng)
            title(cb,{'Zugknick', 'Latitude (^o)'},'FontSize',10);
            a =  cb.Position; %gets the positon and size of the color bar
            set(cb,'Position',[a(1) a(2)-0.05 a(3) a(4)]);% To change size
            colormap(brewermap([],'RdYlBu'))
            box off
            axis off
        end
    
    end

   if ~isinf(n_chrs) || n_loci > 1 % s&&  ~isnan(all_ys_allels)
        plot_allels
    end

end