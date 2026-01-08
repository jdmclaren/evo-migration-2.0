% https://earthexplorer.usgs.gov/
% https://rda.ucar.edu/datasets/ds758.0/docs/tiles.gif

% resolution options 1 = 1-deg, 2= 0.25 deg, 3 = 1/60 deg
res_opt = 3; % 2; % 1; % 
plot_opt = res_opt ~=3;

% gtopo30 data: limits are NW corners of coverage, cells will be offset by
% half-res (i.e., 1/240 deg)

[AW,RW] = readgeoraster('gt30w180s10_dem/gt30w180s10.dem');
res_dg = 1/120;
lat_W = (-10:-res_dg:-60+res_dg) - res_dg/2;
lon_W = 360+(-180:res_dg:-140-res_dg) + res_dg/2;
% figure; imagesc(AW)
% colorbar
% clim([0 1]) % ([0 2400])

[AE,RE] = readgeoraster('gt30e140s10_dem/gt30e140s10.dem');
lat_E = lat_W;
lon_E = (140:res_dg:180-res_dg) + res_dg/2;
% figure; imagesc(AE)
% colorbar
% clim([0 1]) % ([0 2400])

% now the 'Northern' sections
[ANE,RNE] = readgeoraster('gt30e140n40_dem/gt30e140n40.dem'); % E140N40.dem');
lat_NE = (40:-res_dg:-10+res_dg) - res_dg/2;
lon_NE = lon_E; % 

[ANW,RNW] = readgeoraster('gt30w180n40_dem/gt30w180n40.dem');
lat_NW = lat_NE; % (140:res_dg:180-res_dg) + res_dg/2;
lon_NW = lon_W;

% figure; imagesc(AE(3000:end,3000:end))
% colorbar
% clim([0 1]) % ([0 2400])

% E & W refer to Long not to in relation to each other
% as E is W of W!

% combine all 

AENS = double([ANE; AE]);
AWNS = double([ANW; AW]);

DEM = double([AENS AWNS]);
Lat_cs = [lat_NE lat_E];
Lon_cs = [lon_E lon_W];

% [Lon_gr, Lat_gr] = meshgrid(Lon_cs,Lat_cs);

figure;
imagesc('XData',[Lon_cs(1) Lon_cs(end)],'YData',[Lat_cs(1) Lat_cs(end)],'CData',DEM)
set(gca,'XTick',140:20:220,'XTickLabel',{'140','160','180','-160','-140'})
colorbar
clim([0 1])

save('DEMs_1_120th','DEM',"Lon_cs","Lat_cs")

DEM(DEM<0) = -2000;
% figure;
% imagesc('XData',[Lon_cs(1) Lon_cs(end)],'YData',[Lat_cs(1) Lat_cs(end)],'CData',DEM)
% axis([175 195 -20 -15])
% set(gca,'XTick',175:5:195,'YTick',-20:-15)
% colorbar
% clim([-2000 1000])

% DEM(DEM<0) = -2000;
% figure;
% imagesc('XData',[Lon_cs(1) Lon_cs(end)],'YData',[Lat_cs(1) Lat_cs(end)],'CData',DEM)
% axis([195 215 -20 -15])
% set(gca,'XTick',195:5:215,'YTick',-20:-15)
% colorbar
% clim([0 1000])


n_ln = numel(Lon_cs);
n_lt = numel(Lat_cs);
% go for 1/60, 1/4 degree or 1 deg
gr_res = 2; % 30; % 120; % 

Lon_hrzns = Lon_cs(1:gr_res:end)';
Lat_hrzns = Lat_cs(end:-gr_res:1)';

ltln_stp = res_dg*gr_res;
n_ln_gr = n_ln/gr_res; %  -1;
n_lt_gr = n_lt/gr_res; %  -1;
Lon_0 = Lon_cs(1); %  + ltln_stp/2;
Lat_0 = Lat_cs(end); %  - ltln_stp/2;

% use 99.9% qntl (1-deg) or 99.5% (.25-deg) 
% translates to approx 300 m2 area of land
mx_qt = 0.95; % 1; %  0.995; % 0.999; % 

for jlt = 1:n_lt_gr

    Lat_i = Lat_0 + (jlt-1)*ltln_stp;
    j_min = n_lt - jlt*gr_res +1;
    j_max = j_min + gr_res -1;
 
    for iln = 1:n_ln_gr

        i_min = 1 + (iln-1)*gr_res;
        i_max = i_min + gr_res-1;

        Lon_hrzn_gr(jlt,iln) = Lon_0 + (iln-1)*ltln_stp;
        Lat_hrzn_gr(jlt,iln) = Lat_i;
        DEMs_ij = DEM(j_min:j_max,i_min:i_max);
        DEM_gr(jlt,iln) = max(quantile(DEMs_ij(:),mx_qt),0);

    end

end
% 

if plot_opt
    figure
    scatter(Lon_hrzn_gr(:),Lat_hrzn_gr(:),80,DEM_gr(:),'s','fill');
    colorbar
    clim([0 1000])
    % axis([155 185 -20 -10])
    % set(gca,'XTick',155:5:185,'YTick',-20:-10)
    colorbar
end

fl_alts = [50 500 1500 5000];
for ih = 1:numel(fl_alts)

    h_i = fl_alts(ih);

    hzs_i = 3.57*(sqrt(DEM_gr) + sqrt(h_i));
    hzs_i(DEM_gr <=0) = 0;
    Hrzns{ih} = hzs_i;

    min_hz(ih) = round(min(hzs_i(hzs_i(:)>0))/10)*10;
    max_hz(ih) = round(max(hzs_i(:))/10)*10;

    if plot_opt
        figure
        scatter(Lon_hrzn_gr(:),Lat_hrzn_gr(:),80,Hrzns{ih}(:),'s','fill');
        colorbar
        clim([0 350])
        % axis([155 185 -20 -10])
        % set(gca,'XTick',155:5:185,'YTick',-20:-10)
        cb = colorbar;
        title(cb,'Horizon distance (km)')
        title(['Flt alt = ' num2str(h_i) ' m, Horzn range ' ...
            num2str(min_hz(ih)) ' - ' num2str(max_hz(ih)) ' km'])
    end

end

if res_opt == 2
    save('Hrzns_qtr_deg','Hrzns',"Lon_hrzns","Lat_hrzns")
elseif res_opt == 1
    save('Hrzns_1_deg','Hrzns',"Lon_hrzns","Lat_hrzns")
else
    save('Hrzns_1_60th_deg','Hrzns',"Lon_hrzns","Lat_hrzns")    
end

% figure;
% imagesc('XData',[Lon_hrzns(1) Lon_hrzns(end)],'YData',[Lat_hrzns(1) Lat_hrzns(end)],'CData',DEM)
% set(gca,'XTick',140:20:220,'XTickLabel',{'140','160','180','-160','-140'})
% colorbar
% clim([0 1])