function [Lat, Lon] = update_loc(fl_hrs,hourly_del_Lat,curr_Lat,curr_Lon, ...
    curr_head,N_S_migr,u_wind,v_wind,magn_star_night,decln,dateyear,magn_model)
% , sum_abs_decln,sum_decln,all_decs

u_wnd_fact = 1 + u_wind;
v_wnd_fact = 1 + v_wind;

   udy = round(mean(dateyear)); 
% initialize declination (will remain fixed for star compass)
    d_decln = zeros(size(decln));

    flr_fl_hrs = floor(fl_hrs);
    
            
    t_res = 1; % 10;  %
        
    
    for iH = 1:max(flr_fl_hrs)*t_res
        
        flies = flr_fl_hrs >= iH/t_res;
      % if abs(circ_mean(curr_head)) > pi/2 % South 
        curr_head(flies) = mod(pi + curr_head(flies) + d_decln(flies),2*pi)-pi;
      % else % North
      %    curr_head(flies) = mod(curr_head(flies) + d_decln(flies),2*pi)-pi;
      % end
      if N_S_migr % N to S migration, angles are rel to geogr (true) South
        dLon = hourly_del_Lat.* ...
            (sin(pi+curr_head(flies)).*u_wnd_fact(flies))./ ...
            cos(curr_Lat(flies))/t_res;
        dLat = hourly_del_Lat.*(cos(pi+curr_head(flies)).*v_wnd_fact(flies))/t_res;
      else  % S to N migration, angles are rel to geogr (true) North
        dLon = hourly_del_Lat.* ...
            (sin(curr_head(flies)).*u_wnd_fact(flies))./ ...
            cos(curr_Lat(flies))/t_res;
        dLat = hourly_del_Lat.*(cos(curr_head(flies)).*v_wnd_fact(flies))/t_res;
      end

        curr_Lon(flies) = curr_Lon(flies) + dLon; % mod( ,2*pi);
        curr_Lat(flies) = curr_Lat(flies) + dLat;
        
        % account for polar crossing
        curr_Lat(curr_Lat > pi/2) = pi - curr_Lat(curr_Lat > pi/2);
        curr_Lat(curr_Lat < -pi/2) = -pi - curr_Lat(curr_Lat < -pi/2);

        % account for dateline passing
        curr_Lon(flies) = shiftAnglesFromMinus180To180(curr_Lon(flies)*180/pi)*pi/180;
%         clear Bx By
        if magn_star_night == 1 && magn_model == 1

                [Bx, By, ~] = igrf(udy, ...
                   curr_Lat(flies)*180/pi, curr_Lon(flies)*180/pi, 0);

            decln_new = atan2(By,Bx);
            d_decln(flies,1) = decln_new-decln(flies);
      
        end
        
    end
    
    % now complete last fractional flight hour (all records)
    fl_h_frac = rem(fl_hrs*t_res,1)/t_res;
    if N_S_migr % N to S migration, angles are rel to geogr (true) South
        curr_head(flies) = mod(pi + curr_head(flies) + d_decln(flies),2*pi)-pi;
        dLon = fl_h_frac.*hourly_del_Lat./cos(curr_Lat).* ...
                    (sin(pi+curr_head).*u_wnd_fact)/t_res;
        dLat = fl_h_frac.*hourly_del_Lat.*(cos(pi+curr_head).*v_wnd_fact)/t_res;
    else % S to N migration, angles are rel to geogr (true) North
        % curr_head(flies) = mod(pi + curr_head(flies) + d_decln(flies),2*pi)-pi;
        dLon = fl_h_frac.*hourly_del_Lat./cos(curr_Lat).* ...
                    (sin(curr_head).*u_wnd_fact)/t_res;
        dLat = fl_h_frac.*hourly_del_Lat.*(cos(curr_head).*v_wnd_fact)/t_res;
    end

    % (final) increment location
    Lon = curr_Lon + dLon; % mod( ,2*pi);
    Lat = curr_Lat + dLat;

% end

% (final) accounting for polar crossing
Lat(Lat > pi/2) = pi - Lat(Lat > pi/2);
Lat(Lat < -pi/2) = -pi - Lat(Lat < -pi/2);

% and for datelne passing
Lon = shiftAnglesFromMinus180To180(Lon*180/pi)*pi/180;
