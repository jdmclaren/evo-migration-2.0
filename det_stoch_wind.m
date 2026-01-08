function [u_wind, v_wind] = det_stoch_wind(curr_Lat, wind_str, ...
    opt_stdy_swtch_ws,u_pr,v_pr,is_begn_stp,is_w_switch)  

sz_vec = size(curr_Lat);

is_mid_Lats = abs(curr_Lat)>=pi/6  & abs(curr_Lat)<=pi/3;

% new add random switch to tailwinds (also 2/3 chance)
p_EW = 0.75;
p_NS = 0.75;

% add random direction (Oct '23) between 30 and 60 degrees from E/W
w_dirs = pi/6*(1 + rand(sz_vec));
% determine resultant wind component magnitudes (N/S dirn and E/W polarity
% determined below)
u_cmpts = wind_str*cos(w_dirs);
v_cmpts = wind_str*sin(w_dirs);

% Westerlies vs. Easterlies 
% Northeries vs. Southerlies 
if opt_stdy_swtch_ws && is_w_switch
    EW_Ws = sign(p_EW - rand(sz_vec));
    NS_Ws = sign(p_NS - rand(size(curr_Lat)));
else
    EW_Ws = sign(u_pr);
    NS_Ws = sign(v_pr);
end

u_new = EW_Ws.*u_cmpts.*(is_mid_Lats - ~is_mid_Lats);
v_new = NS_Ws.*v_cmpts.*(is_mid_Lats.*sign(curr_Lat) ...
   - ~is_mid_Lats.*sign(curr_Lat));

if opt_stdy_swtch_ws
    
    % 2/3 chance same as last time
    p_steady = 0.75*is_w_switch; %
    steadys = rand(size(curr_Lat)) < p_steady;
    
    u_wind = steadys.*u_pr + ~steadys.*u_new;
    v_wind = steadys.*v_pr + ~steadys.*v_new;
    
else

    u_wind = u_new;
    v_wind = v_new;

end