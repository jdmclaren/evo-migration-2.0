lons_gr = -85:0.5:-45;
lons_rad = lons_gr*pi/180; % lons*pi/180 - 2*pi;
d_lon = lons_rad(2) - lons_rad(1);
lats_gr = -5:0.5:50;
lats_rad = lats_gr*pi/180; % flipud(lats)*pi/180;
d_lat = lats_rad(2) - lats_rad(1);

% lon_bs_ok = lon_bs(~isnan(lon_bs(:)));
% lat_bs_ok = lat_bs(~isnan(lat_bs(:)));

Ns = size(lon_bs);

n_arr = 0;
n_fail = 0;

for id = 1:Ns(1)
    
    for jf = 1:Ns(2)
        
        if f_arrs(id,jf) > 0
            
          
            nt = sum(~isnan(lon_bs(id,jf,:)));
            for it = 1:nt
                
                 lon_a_i = find((lon_bs(id,jf,it)> lons_rad) & ...
                    (lon_bs(id,jf,it)<= (lons_rad + d_lon)));
                if ~isempty(lon_a_i)
                    
                n_arr = n_arr + 1;
                lon_arr(n_arr) = lon_a_i;
                lat_arr(n_arr) = find((lat_bs(id,jf,it)> lats_rad) & ...
                    (lat_bs(id,jf,it)<= (lats_rad + d_lat)));
                
%                 else
%                     
%                     lon_arr(n_arr) = NaN;
%                     lat_arr(n_arr) = NaN;
                    
                end
                
               
            end
            
        else
                        
           
            nt = sum(~isnan(lon_bs(id,jf,:)));
            for it = 1:nt
                
                lon_f_i = find((lon_bs(id,jf,it)> lons_rad) & ...
                    (lon_bs(id,jf,it)<= (lons_rad + d_lon)));
                if ~isempty(lon_f_i)
                    
                    n_fail = n_fail + 1;
                    lon_fail(n_fail) = lon_f_i;
                    lat_fail(n_fail) = find((lat_bs(id,jf,it)> lats_rad) & ...
                        (lat_bs(id,jf,it)<= (lats_rad + d_lat)));
                    
%                 else
%                     
%                      lon_fail(n_fail) = NaN;
%                      lat_fail(n_fail) = NaN;
                    
                end
                
            end
                       
        end
        
    end

end
   
for i = 1:length(lats_gr)
    
    for j = 1:length(lons_gr)
        
        counts_arr(i,j) = sum(lon_arr == j & lat_arr == i);
        counts_fail(i,j) = sum(lon_fail == j & lat_fail == i);
        
    end
    
end


% figure
% subplot(1,2,1)
% hist(lon_cell)
% subplot(1,2,2)
% hist(lat_cell)

%% contours arrived
 figure
    
hw = worldmap([Domain(3) Domain(4)]*180/pi,[Domain(1) Domain(2)] ...
    *180/pi);
%         hw = worldmap([22.5 Domain(4)]*180/pi,[-75 Domain(2)*180/pi]);
set(hw,'FontSize',fSize_ax)
%         worldmap([42 53],[-60 -45])
load coastlines
plotm(coastlat, coastlon, 'k')

maxA = max(counts_arr(:));

counts_arr(counts_arr == 0) = -maxA/100;
% counts_fail(counts_fail == 0) = -maxA/10;

contourm(lats_gr,lons_gr,counts_arr,[-maxA/100 0 maxA.^(0.:.01:0.75)],'Fill','on') % 

land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(hw, land, 'FaceColor', [0.5 0.7 0.5])

colorbar

cmap = flipud(hot);
cmap_bl = cool;
cmap(1,:) = cmap_bl(1,:);
colormap(cmap)

%% contours failed
 figure
    
hw = worldmap([Domain(3) Domain(4)]*180/pi,[Domain(1) Domain(2)] ...
    *180/pi);
%         hw = worldmap([22.5 Domain(4)]*180/pi,[-75 Domain(2)*180/pi]);
set(hw,'FontSize',fSize_ax)
%         worldmap([42 53],[-60 -45])
load coastlines
plotm(coastlat, coastlon, 'k')

maxF = max(counts_fail(:));
% counts_arr(counts_arr == 0) = -maxA/10;
counts_fail(counts_fail == 0) = -maxF/100;
contourm(lats_gr,lons_gr,counts_fail,[-maxF/100 0 maxF.^(0.:.01:0.75)],'Fill','on') % ,[0 1 3 5 10 20 50 100 200]

land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(hw, land, 'FaceColor', [0.5 0.7 0.5])

colorbar
cmap = flipud(hot);
cmap_bl = cool;
cmap(1,:) = cmap_bl(1,:);
colormap(cmap)


