DEM(DEM == -9999) = NaN;

theta_i = -17.5;
llamda_i = 179;

% llamda_360 = 360 + llamda_i;

lon_el_idx = find(mod(llamda_i,360) > Lon_cs, 1,'last');
lat_el_idx = find(theta_i > Lat_cs, 1,'first');

hrz_dst = 240;
rng_id_cst = -hrz_dst:hrz_dst;

elev_rng = DEM(lat_el_idx-rng_id_cst,lon_el_idx+rng_id_cst);
el_qi = quantile(elev_rng(~isnan(elev_rng(:))),0.999);

figure
h = imagesc(llamda_i + rng_id_cst/120,theta_i + rng_id_cst/120,elev_rng);
set(h, 'AlphaData', 1-isnan(elev_rng))
set(gca,'Ydir','normal')
colorbar
clim([0 el_qi])

% add new value to elevn at 1 deg

lat_deg_idx = 91 + floor(-theta_i);
lon_deg_idx = min(360,floor(llamda_i) + 181);

elev_new = max(elev(lat_deg_idx,lon_deg_idx),el_qi);