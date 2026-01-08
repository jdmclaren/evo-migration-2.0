figure('Position',fig_sz)
land = shaperead('landareas', 'UseGeoCoords', true);
ax = worldmap([min_lat max_lat],[min_lon max_lon]);
geoshow(land, 'FaceColor', [0.75 0.75 0.75]) %
sc = scatterm(blats(idx_pl,1)*180/pi, ...
blons(idx_pl,1)*180/pi,20, ...
plt_fld(idx_pl),'fill'); % 'LineWidth',1)
sc.Children.MarkerFaceAlpha = 0.375; % min(.025*N_inds/min(size(blat_succs,1), ...
colormap(brewermap([],cmap_scheme));
mlabel('off'); plabel('off'); gridm('off')
% clim(hds_rng)
% title({[num2str(iy_str(iy)) ' Geogr.'], ' Heading (^o)'},'FontSize',11);