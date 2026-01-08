function [u_wind, v_wind] = det_stoch_wind_weib(curr_Lat,w_scale,w_exp, ...
    opt_stdy_swtch_ws,u_pr,v_pr,is_uncorr_stp,is_w_swtch,p_stdy_w_updt)

% is_uncorr_stp determines whether It's a vector since 
% is_w_swtch is scalar within steps 
% (e.g., substeps every 6 hrs during endurance flts)
% p_non_switch gives prob steady winds between substeps

sz_vec = size(curr_Lat);

% Here define the wind regime (this needs to be updated to use parameters
% specific to the migr system!)
max_p_Ws = 0.75; % assume max 75% in mean zonal direction
min_p_Ws = 0.5; % at 30 degs
d_pWs = max_p_Ws - min_p_Ws;

% constant prob in mean medidional direction (dirn switches at 30 degs)
p_NS = 0.75; 

% if opt_stdy_swtch_ws && ~is_w_swtch
% 
%     u_wind = u_pr;
%     v_wind = v_pr;
% 
% else % not uniformly steady; need new components

    % first work out wind regime (Trade vs Westerly winds)

    is_W_Lats = abs(curr_Lat) >= pi/6; %   & abs(curr_Lat)<=pi/3;

    % assume most frequent E or W at 22.5 degs
    not_hi_Lats = abs(curr_Lat)<=pi/4;
    frac_W_mid_Lats = not_hi_Lats.*abs(abs(curr_Lat)-pi/8)*8/pi;
    
    p_EW = ~not_hi_Lats*max_p_Ws + ...
        not_hi_Lats.*(min_p_Ws + d_pWs*frac_W_mid_Lats);
    
    % new add random switch to tailwinds (also 2/3 chance)
    % p_EW = 0.75;
    % p_NS = 0.75;   
    
    % Westerlies vs. Easterlies 
    % Northeries vs. Southerlies 
    % Switch stoch at begin of step
    if ~opt_stdy_swtch_ws % always calculate new wind condns from regime
    
        EW_Ws = sign(p_EW - rand(sz_vec));
        NS_Ws = sign(p_NS - rand(size(curr_Lat)));
        
    else
          
        stdy_ws = rand(sz_vec) < p_stdy_w_updt;
        % stdy_EW = rand(sz_vec) < p_stdy_w_updt;
        % stdy_NS = rand(sz_vec) < p_stdy_w_updt;
    
        % calculate new winds for non-stopovers (w_switch)
        EW_Ws = stdy_ws.*sign(u_pr) + ... stdy_EW
            ~stdy_ws.*sign(p_EW - rand(sz_vec));
        NS_Ws = stdy_ws.*sign(v_pr) + ... stdy_NS
            ~stdy_ws.*sign(p_NS - rand(size(curr_Lat)));
       
        % then filter out nonstopovers if not "in air"
        % and filter out transients and endurance as same as in air
        % probabilities of steady directions
        if ~is_w_swtch % within flight always correlated
             % else % steady EW NS compts during step
             
            EW_Ws = ~is_uncorr_stp.*EW_Ws + ...
                is_uncorr_stp.*sign(p_EW - rand(sz_vec));
            NS_Ws = ~is_uncorr_stp.*NS_Ws + ...
                is_uncorr_stp.*sign(p_NS - rand(size(curr_Lat)));

        end
    
    end

    % add random direction 0-45 degrees from E/W
    w_dirs = pi/4*rand(sz_vec); % (1 + rand(sz_vec));
    % determine resultant wind component magnitudes (N/S dirn and E/W polarity
    % determined below)
    
    n_inds = numel(curr_Lat);
    
    % try
    w_strs = wblrnd(w_scale,w_exp,[n_inds 1]);
    % catch
    %     keyboard
    % end
    
    u_cmpts = w_strs.*cos(w_dirs);
    v_cmpts = w_strs.*sin(w_dirs);

    u_new = EW_Ws.*u_cmpts.*(is_W_Lats - ~is_W_Lats);
    % winds from South (headwind) vs. from North (tailwind) assymetrical between Hemispheres
    v_new = NS_Ws.*v_cmpts; % .*(is_W_Lats.*sign(curr_Lat) ...
       % - ~is_W_Lats.*sign(curr_Lat));
    
    if is_w_swtch

        % 2/3 chance same compts as last time bewteen days
        p_steady = 0;
        f_steady_sp = 0.5;
    
        % steady_us = rand(size(curr_Lat)) <= p_steady;
        % steady_vs = rand(size(curr_Lat)) <= p_steady;
        steady_ws = rand(size(curr_Lat)) <= p_steady;
    
        w_str_pr = sqrt(u_pr.^2 + v_pr.^2);
    
        w_str_sw_rtio =  steady_ws + ~steady_ws.*((1-f_steady_sp) + ...
            f_steady_sp*w_str_pr./w_strs);
    
        % u_wind = steady_us.*u_pr + ~steady_us.*u_new;
        % v_wind = steady_vs.*v_pr + ~steady_vs.*v_new;
        u_wind = steady_ws.*u_pr + ~steady_ws.*u_new.*w_str_sw_rtio;
        v_wind = steady_ws.*v_pr + ~steady_ws.*v_new.*w_str_sw_rtio;

    else

        u_wind = u_new;
        v_wind = v_new;

    end

% end