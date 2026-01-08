function [tailw, crossw, del_alpha_dep] = calc_wind_supprt_drft(alpha, ...
    uw,vw,N_S_migr, is_deps, ovr_wtr, lnd_wtr_ahd, ...
          comp_HWs_dep, comp_HWs_cst,  ...
          comp_TWs_dep, comp_TWs_cst, ...
          frc_cmp_dep, del_alpha_dep, mnt_TW_comp_wtr)

% Param alpha is heading cw from N or S
% Param is_deps is flag for flight initiation (comps)
% Also possible to maintain comp over water

% comp_HWs,  ...
%     comp_TWs_cst, frc_cmp_dep, del_alpha_dep, mnt_TW_comp_wtr)

% determine wind strength and direction
% Note that wind is defined throughout relative to the airspeed, and we
% don't consider wind strength greater than airspeed for this simple model
% which focuses on the evolution of orientation 
w_str = sqrt(uw.^2 + vw.^2);
w_dir = atan2(uw,vw);

if N_S_migr

    w_drft_ang = w_dir - (pi+alpha);

else

    w_drft_ang = w_dir - alpha;

end

% 1st assume drifts and headings unadjusted
tailw = w_str.*cos(w_drft_ang);
% del_alpha = zeros(size(tailw));

% Allow drift in TWs (Alerstam '79a)
% possibly excepting flights before water crossings (comp_TWs_cst)
% Also allow drift in HWs if no comp_HWs option
TW_comp_opts = tailw >= 0 & (comp_TWs_dep | ...
    (lnd_wtr_ahd & comp_TWs_cst));
HW_comp_opts = tailw < 0 & (comp_HWs_dep | ...
    (lnd_wtr_ahd & comp_HWs_cst));
will_comp = TW_comp_opts | HW_comp_opts;
drfts = ~will_comp;

% Define crosswinds; this will change for non-drifting birds
crossw = w_str.*sin(w_drft_ang);

% If not departing, update adjustments when no longer over water according to strategy
if ~is_deps
    del_alpha_dep(~ovr_wtr) = 0;
    del_alpha_dep(ovr_wtr) = mnt_TW_comp_wtr*del_alpha_dep(ovr_wtr);
end

% Change TW and CW for non-drifting birds 
% % depending on if can fully compensate
if sum(~drfts) > 0

    comps = find(will_comp);

    b_cw_comps = -sign(crossw(comps)) ...
        .*min(frc_cmp_dep*abs(crossw(comps)),1);

    b_d_alph = asin(b_cw_comps);

    del_alpha_dep(comps) = b_d_alph;

    % update tail and crossw rel to new heads
    tailw(comps) = w_str(comps).*cos(w_drft_ang(comps)-b_d_alph);
    crossw(comps) = w_str(comps).*sin(w_drft_ang(comps)-b_d_alph);

    % twc = tailw(comps);
    % cwc = crossw(comps);
    % 
    % tailw(comps) = twc*cos(b_d_alph) + cwc*sin(b_d_alph);
    % crossw(comps) = cwc*cos(b_d_alph) - twc*sin(b_d_alph);

    % extent comp will depend if wind str lt or gt airsp
    % cws_to_cmp = crossw(comps);
    % can_fc = abs(magn_cmps) < 1; % eff_Va > 0 & 
    % % determine effective wind components after full comp
    % % I.e., account for the loss in effective windspeed
    % f_comps = comps(can_fc);


    % reduce TWs by comp factor 1-sqrt(1-w2sin2)
    % tailw(comps) = tailw(comps) - (1 - sqrt(1-b_cw_comps.^2));

    %  no effective crosswind 
    % crossw(comps) = cws_to_cmp + b_cw_comps; % 0;

    % uw_eff(f_comps) = TW_eff_cmps.*sin(alpha((f_comps)));
    % vw_eff(f_comps) = TW_eff_cmps.*cos(alpha((f_comps)));  

    % f_nfc = comps(~can_fc);
    % % Eff TW redecued by 1 (full bird airsp used to comp)
    % % but not full wind comp (winds/airsps are scaled to 1)
    % tailw(f_nfc) = tailw(f_nfc) -1;
    % % CW also reduced by 1 from full bird speed 
    % crossw(f_nfc) = (abs(magn_cmps(~can_fc)) - 1).*sign(crossw(f_nfc));
    % % uw_eff(f_nfc) = TW_eff_cmps.*sin(alpha((f_nfc)));
    % % vw_eff(f_nfc) = TW_eff_cmps.*cos(alpha((f_nfc)));  

end

