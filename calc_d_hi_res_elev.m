load DEMs_30min.mat 

Lon_cs = pi/180*Lon_cs;
Lat_cs = pi/180*Lat_cs;

% Lon_cs(Lon_cs >= pi) = Lon_cs(Lon_cs >= pi) - 2*pi;

[Lon_gr, Lat_gr] = meshgrid(Lon_cs,Lat_cs);

poss_elev_cels = inpolygon(Lon_gr(:),Lat_gr(:), ...
                        lon_poly_cst,lat_poly_cst);

% poss_elev_idx = ind2sub(size(Lon_gr),poss_elev_cels)

cst_poss_ln = Lon_gr(poss_elev_cels);
cst_poss_lt = Lat_gr(poss_elev_cels);

DEM_lin = DEM(:);

DEMs = DEM_lin(poss_elev_cels);

lnd_fact = 3.7;
fl_alt = 50, % 500; % 5000; %

d_hz = lnd_fact*sqrt(abs(DEMs-fl_alt));

d_SeeCst_2s = (th_ws(i_ow)-cst_poss_lt).^2 + ...
                            (cos(th_ws(i_ow))*(ll_ws(i_ow) -cst_poss_ln)).^2;

see_hz = d_hz >= d_SeeCst_2s;