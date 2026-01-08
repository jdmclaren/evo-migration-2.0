edge_sz = 2.5; % 
[Lon_dep_poly, Lat_dep_poly] = create_poly(Dep_verts);
[Lon_arr_poly, Lat_arr_poly] = create_poly(Arr_verts);
min_lon = nanmin(Lon_dep_poly)*180/pi-2*edge_sz;
max_lon = nanmax(Lon_dep_poly)*180/pi+2*edge_sz;
min_lat = nanmin(Lat_dep_poly)*180/pi-edge_sz;
max_lat = nanmax(Lat_dep_poly)*180/pi+edge_sz;  

figure('Position',fig_sz)
    land = shaperead('landareas', 'UseGeoCoords', true);
    ax = worldmap([min_lat max_lat],[min_lon max_lon]);
    geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
    sc = scatterm(blats(thous_arr,1)*180/pi, ...
    blons(thous_arr,1)*180/pi,20, ...
    sum(all_ys_allels(thous_arr,:,1,yr),2),'fill'); % 'LineWidth',1)
    sc.Children.MarkerFaceAlpha = 0.375; % min(.025*N_inds/min(size(blat_succs,1), ...
    colormap(brewermap([],'*YlOrRd'));
    mlabel('off'); plabel('off'); gridm('off')
    % clim(hds_rng)
    title(['Generation ' num2str(yrs(iy)) ' sum 1st gene'],'FontSize',11);
    colorbar

    if n_loci == 2
        
        figure('Position',fig_sz)
        land = shaperead('landareas', 'UseGeoCoords', true);
        ax = worldmap([min_lat max_lat],[min_lon max_lon]);
        geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
        sc = scatterm(blats(thous_arr,1)*180/pi, ...
        blons(thous_arr,1)*180/pi,20, ...
        sum(all_ys_allels(thous_arr,:,2,yr),2),'fill'); % 'LineWidth',1)
        sc.Children.MarkerFaceAlpha = 0.375; % min(.025*N_inds/min(size(blat_succs,1), ...
        colormap(brewermap([],'*YlOrRd'));
        mlabel('off'); plabel('off'); gridm('off')
        % clim(hds_rng)
       title(['Generation ' num2str(yrs(iy)) ' sum 2nd gene'],'FontSize',11);
        colorbar

    end

% std heads
if ~short_opt
    figure('Position',fig_sz)
    land = shaperead('landareas', 'UseGeoCoords', true);
    ax = worldmap([min_lat max_lat],[min_lon max_lon]);
    geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
    sc = scatterm(blats(thous_arr,1)*180/pi, ...
    blons(thous_arr,1)*180/pi,20, ...
    std_inher_head(thous_arr,1)*180/pi,'fill'); % 'LineWidth',1)
    sc.Children.MarkerFaceAlpha = 0.375; % min(.025*N_inds/min(size(blat_succs,1), ...
    colormap(brewermap([],'YlOrRd'));
    mlabel('off'); plabel('off'); gridm('off')
    % clim(hds_rng)
    cb = colorbar;
    title(cb,{'Intrinsic', 'variability (^o)'})
end
