function [Lat_fins, Lon_fins, Lat_hs, Lon_hs, decln_new] = update_loc_hrly ...
    (fl_hrs,hourly_del_Lat,curr_Lat,curr_Lon, ...
    curr_head,N_S_migr,tailw,crossw,magn_star_night, ...
    decln,dateyear,magn_model,n_f_hs)
% , sum_abs_decln,sum_decln,all_decs


try

n_inds = numel(fl_hrs);

Lon_fins = NaN(n_inds,1);
Lat_fins = NaN(n_inds,1);

tw_fact = 1 + tailw;
cw_fact = crossw;

udy = round(mean(dateyear)); 
% initialize declination (will remain fixed for star compass)
decln_new = decln;
d_decln = zeros(size(decln));

flr_fl_hrs = floor(fl_hrs);
mx_flhs = max(flr_fl_hrs);

t_res = 1; % 10;  %     

Lon_hs = NaN(n_inds,n_f_hs); % mx_flhs);
Lat_hs = NaN(n_inds,n_f_hs); % mx_flhs);

flies = true(size(flr_fl_hrs));

for iH = 1:max(flr_fl_hrs)*t_res
    
    flies = flr_fl_hrs >= iH/t_res;
  % if abs(circ_mean(curr_head)) > pi/2 % South 
    curr_head(flies) = mod(pi + curr_head(flies) + d_decln(flies),2*pi)-pi;
  % else % North
  %    curr_head(flies) = mod(curr_head(flies) + d_decln(flies),2*pi)-pi;
  % end
  if N_S_migr % N to S migration, angles are rel to geogr (true) South
    dLon = hourly_del_Lat.* ...
        (sin(pi+curr_head(flies)).*tw_fact(flies) + ...
        cos(pi+curr_head(flies)).*cw_fact(flies))./ ...
        cos(curr_Lat(flies))/t_res;
    dLat = hourly_del_Lat.*(cos(pi+curr_head(flies)).*tw_fact(flies) - ...
        sin(pi+curr_head(flies)).*cw_fact(flies))/t_res;
  else  % S to N migration, angles are rel to geogr (true) North
    dLon = hourly_del_Lat.* ...
        (sin(curr_head(flies)).*tw_fact(flies) + ...
        cos(curr_head(flies)).*cw_fact(flies))./ ...
        cos(curr_Lat(flies))/t_res;
    dLat = hourly_del_Lat.*(cos(curr_head(flies)).*tw_fact(flies) - ...
        sin(curr_head(flies)).*cw_fact(flies))/t_res;
  end

    curr_Lon(flies) = curr_Lon(flies) + dLon; % mod( ,2*pi);
    curr_Lat(flies) = curr_Lat(flies) + dLat;
    
    % account for polar crossing
    curr_Lat(curr_Lat > pi/2) = pi - curr_Lat(curr_Lat > pi/2);
    curr_Lat(curr_Lat < -pi/2) = -pi - curr_Lat(curr_Lat < -pi/2);

    % account for datelne passing
    curr_Lon(flies) = shiftAnglesFromMinus180To180(curr_Lon(flies)*180/pi)*pi/180;
%         clear Bx By
    if magn_star_night == 1 && magn_model == 1

            [Bx, By, ~] = igrf(udy, ...
               curr_Lat(flies)*180/pi, curr_Lon(flies)*180/pi, 0);

        decln_new = atan2(By,Bx);
        d_dec_fl = decln_new-decln(flies);
        d_decln(flies,1) = d_dec_fl;

        % new 2024 also update tailw and crossw compts rel to new
        % geogr heading
        tw = tw_fact - 1;
        tw_fact = 1 + tw.*cos(d_dec_fl) + cw_fact.*sin(d_dec_fl);
        cw_fact = cw_fact.*cos(d_dec_fl) - tw.*sin(d_dec_fl);
  
    end

    Lon_hs(flies,iH) = curr_Lon(flies);
    Lat_hs(flies,iH) = curr_Lat(flies);
    
end

% now complete last fractional flight hour (all records)
fl_h_frac = rem(fl_hrs*t_res,1)/t_res;
if N_S_migr % N to S migration, angles are rel to geogr (true) South
    curr_head(flies) = mod(pi + curr_head(flies) + d_decln(flies),2*pi)-pi;
    dLon = fl_h_frac(flies).*hourly_del_Lat.* ...
        (sin(pi+curr_head(flies)).*tw_fact(flies) + ...
        cos(pi+curr_head(flies)).*cw_fact(flies))./ ...
        cos(curr_Lat(flies))/t_res;
    dLat = fl_h_frac(flies).*hourly_del_Lat.* ...
        (cos(pi+curr_head(flies)).*tw_fact(flies) - ...
        sin(pi+curr_head(flies)).*cw_fact(flies))/t_res;
else % S to N migration, angles are rel to geogr (true) North
    % curr_head(flies) = mod(pi + curr_head(flies) + d_decln(flies),2*pi)-pi;
    dLon = fl_h_frac(flies).*hourly_del_Lat.* ...
        (sin(curr_head(flies)).*tw_fact(flies) + ...
        cos(curr_head(flies)).*cw_fact(flies))./ ...
        cos(curr_Lat(flies))/t_res;
    dLat = fl_h_frac(flies).*hourly_del_Lat.* ...
        (cos(curr_head(flies)).*tw_fact(flies) - ...
        sin(curr_head(flies)).*cw_fact(flies))/t_res;
end

% (final) increment location
curr_Lon(flies) = curr_Lon(flies) + dLon; % mod( ,2*pi); (flies)
curr_Lat(flies) = curr_Lat(flies) + dLat;

% end

Lat_fins = curr_Lat;
Lon_fins = curr_Lon;

% (final) accounting for polar crossing
Lat_hs(Lat_hs > pi/2) = pi - Lat_hs(Lat_hs > pi/2);
Lat_hs(Lat_hs < -pi/2) = -pi - Lat_hs(Lat_hs < -pi/2);

Lat_fins(Lat_fins > pi/2) = pi - Lat_fins(Lat_fins > pi/2);
Lat_fins(Lat_fins < -pi/2) = -pi - Lat_fins(Lat_fins < -pi/2);

% and for datelne passing
Lon_hs = shiftAnglesFromMinus180To180(Lon_hs*180/pi)*pi/180;
Lon_fins = shiftAnglesFromMinus180To180(Lon_fins*180/pi)*pi/180;

catch

    keyboard

end
