
ths = -22:1/60:-18;
lls = 157:1/60:165; % 165:1/60:175;

[hrzn_ths,hrzn_lls] = ndgrid(ths*pi/180,lls*pi/180);
idx_hrzn_land = near_idx_hrzn(hrzn_ths,hrzn_lls);
d2_hrzn_land = d2_hrzn(idx_hrzn_land(:)); %

figure; scatter(hrzn_lls(:)*180/pi,hrzn_ths(:)*180/pi,60,sqrt(d2_hrzn_land(:))*111*180/pi,'fill')

colorbar

fl_lev = 3; 
fl_alt = 1500;
d0 = 3.57*(sqrt(fl_alt));

d5 = 3.57*(sqrt(fl_alt) + sqrt(5));
clim([d0-1 d5])