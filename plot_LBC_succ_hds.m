clear

addpath("circ_stats\")
addpath("brewer\")

plot_y_lbs = false; % true; % 

Dspers_clr_map = 'YlOrRd';
Succ_clr_map = '*RdYlBu'; % '*RdBu'; % 'Reds'; % 'RdBu'; % 'YlOrRd';
Hds_clr_map = '*YlOrRd'; % 'Oranges'; % )) % 'RdBu')) %
iqr_Hds_clr_map = '*PiYG'; % 'Blues'; % 'PuRd'; % 'Reds';
Fij_clr_map = '*YlGnBu'; %'PuBuGn'; %  'Greens'; % '*RdYlBu';
iqr_Lons_clr_map = '*YlGnBu'; % '*PuBuGn'; % '*PiYG'; %

% opt 1: panels per fl alt
% opt 2 panels per flt capcty
plot_opt = 2; % 1; % 

% option to plot distr all arr Lons
plot_all_arr_Lns = false; % true; % 

min_succ = 0; % 30; %

mn_Hd_lims = [2 13];
mn_Hd_tics = 2:2:13;

iqr_Hd_lims = [3 10];
tmpl_iqr_Hd_lims = [2 7];
iqr_Hd_tics = [3:2:9 10]; % 3:2:15;
iqr_Hd_tic_lbl = {'3','5','7','9','10+'};

Hd_lims =  [-15 20]; % [-5 15]; % [
Hd_tics = -20:5:20;

Lon_lims =  [176 186]; % 
Lon_tics = 176:2:186;

mn_Lon_lims = [178 182]; % [176 182]; % 186];
mn_Lon_tics = 178:182;

Fij_Lons = [176.75 182];
Fij_Lats = [-20 Inf]; % [-20 -15.5]; %

pct_Fiji_lims = [0 60];
pct_Fiji_tics = 0:15:75;

disp_lims = [18.5 21.5];

dLon_lims = [2 12];
% dLon_y_lims = [2 10]; % [2 7]; % [1 6];
% Hd_lims =  [2 12]; % [-1 9]; % [-2 12]; %
% pct_EWN_Fiji = [0 50];

Lon_F_W = Fij_Lons(1); % 176.75; %  173.5; % sepatrates Fiji group from islands further W
Lon_F_E = Fij_Lons(2); % 182; % sepatrates Fiji group from islands further E

% Lon_lims =  [Lon_F_W Lon_F_E]; % 

Lat_F_N = Fij_Lats(2); % -16;

dir_pl = 'output_Oct_2025\'; % 'output_Sep_2025\'; % 'Koel_stpov_wtr_ahd\'; % \output\'; % 'Koel_2025\output\'; % 'LBC_final_out\'; %  %'new_comp_sel\'; %   '\fix_tws'; % '\main_runs'; % '\p_hrzn_runs'; % 

if  strcmp(dir_pl,'output_Sep_2025\') || strcmp(dir_pl,'output_Oct_2025\')% strcmp(dir_pl,'\main_runs') ||

    alt_plts = [5000 1500 500 50]; % [50 500 1500 5000]; 5000 
    err_plts = 5:5:25; %  5:5:25; % 
    mxHs_plt = [36 48 60 72 84 96];

    % yrs_2_plt = 1:50; %  25:50;

    pltRow = 1;
    pltCol = 4; 

    extr_str = '';

    LBC_str =  'LTCuckoo_'; % 'LBC_';
  
elseif strcmp(dir_pl,'\p_hrzn_runs')

    alt_plts = [50 1500];
    err_plts = [5 20]; % [5 15 25];
    mxHs_plt = [48 72];

    % yrs_2_plt = 1:50; %  25:50;

    pltRow = 2;
    pltCol = 1; 

    extr_str = '';

    LBC_str = 'LBC_';

elseif strcmp(dir_pl,'\new_comp_sel')

    alt_plts = [50 500 1500 5000];
    err_plts = [5 10 15 20 25]; %
    mxHs_plt = [48 72 96];

    % yrs_2_plt = 1:20; %  25:50;

    pltRow = 2;
    pltCol = 2; 

    extr_str = '';

    LBC_str = '';

else % 'Koel_2025\') % final / July

    alt_plts = [5000 1500 500 50]; %  5000  500 1500
    err_plts =  5:5:25; % 5:5:30; % 
    mxHs_plt = [36 48 64 72]; % [36 48 64 72 96]; % 120

    % yrs_2_plt = 1:50; %  25:50; 1:20; %

    pltRow = 1;
    pltCol = 4;    

    extr_str = '';

    LBC_str = 'LTCuckoo_'; % '';

end

n_alt_plt = numel(alt_plts);
n_flh_plt = numel(mxHs_plt);
n_err_plt = numel(err_plts);

xtks_plt = err_plts;

if plot_opt == 2
    ytks_plt = mxHs_plt(2:2:end); % (1:2:end); %
else
    ytks_plt = alt_plts;
end

mn_succ_pl = NaN(n_alt_plt,n_err_plt,n_flh_plt);

sz_arrays = size(mn_succ_pl);

% mn_Lon_pl std_succ_pl std_Lon_pl mn_hds_pl std_hds_pl

rev_alt_levs = fliplr(alt_plts);

for je = 1:n_err_plt

    err = err_plts(je);

    for kh = 1:n_flh_plt

        mxH = mxHs_plt(kh);

        for iap = 1:n_alt_plt

            alt_plt = alt_plts(iap);

           load([dir_pl LBC_str num2str(alt_plt) '_' ...
                num2str(err) '_' num2str(mxH)  extr_str])

            % load([dir_pl LBC_str num2str(alt_plt) '_' ...
            %      num2str(mxH) '_' num2str(err) extr_str])
        
            % load([dir_pl LBC_str num2str(alt_plt) '_' ...
            %     num2str(err) '_' num2str(mxH) extr_str])

            % if n_alt_plt ~= 3 %  || ~strcmp(dir_pl,'')
            %     keyboard
            % end

            % if sum(size(alt_plts) ~= sz_arrays) > 0
            % 
            %     keyboard
            % 
            % end

            all_lon_fin_vec = all_ys_lon_fin;
            all_lat_fin_vec = all_ys_lat_fin;
            all_succ = all_ys_stoppedAndArrived;
            all_Lon_arrs = all_lon_fin_vec(all_succ);
            all_Lat_arrs = all_lat_fin_vec(all_succ);

            % mn_arr_ys = arrayfun(@(x) geomean(x),all_ys_stoppedAndArrived); % all_ys_stoppedAndArrived,2)/N_mig_Sims*100;

            mn_succ_pl(iap,je,kh) = geomean(successful)*100; % (yrs_2_plt)

            mn_arr_ys = sum(all_ys_stoppedAndArrived,2)/N_mig_Sims*100;

            iqr_succ_arrs(iap,je,kh) = iqr(mn_arr_ys);

            all_ys_lon_fin(~all_succ) = NaN;

            fin_lns = all_ys_lon_fin(:);

            % fin_lns(~all_succ) = NaN;

            mn_Ln_locs = circ_mean(all_ys_lon_fin'*pi/180);
            std_Ln_ys = circ_std(all_ys_lon_fin'*pi/180);

            mn_Lon_pl(iap,je,kh) = mod(circ_mean(fin_lns*pi/180)*180/pi,360);

            med_Lon_pl(iap,je,kh) =  median(mod(fin_lns,360));

            std_Lon_loc_pl(iap,je,kh) = mod(circ_std(mn_Ln_locs'*pi/180)*180/pi,360); % fin_lns

            std_Lon_ys_pl(iap,je,kh) = mod(circ_mean(std_Ln_ys')*180/pi,360); % fin_lns

            iqr_Lon_pl(iap,je,kh) = nanmean(iqr(all_ys_lon_fin));

            iqr_Lon_ys(iap,je,kh) = nanmean(iqr(all_ys_lon_fin,2));

            std_succ_pl(iap,je,kh) = std(successful); % (yrs_2_plt)

            hds_ijk = all_ys_inher_heads*pi/180; % (:,yrs_2_plt)

            mn_hds_pl(iap,je,kh) = circ_mean(circ_mean(hds_ijk')')*180/pi;

            std_hds_pl(iap,je,kh) = circ_mean(circ_std(hds_ijk)')*180/pi;

            iqr_hds_ys(iap,je,kh) = nanmean(iqr(all_ys_inher_heads,2)); % (iqr(hds_ijk'))*180/pi;

            iqr_hds_pl(iap,je,kh) = nanmean(iqr(all_ys_inher_heads));

            mn_diff_hds_pl(iap,je,kh) = nanmean(mean(diff(hds_ijk,[],2),2),1)*180/pi;



            pct_W_Fiji(iap,je,kh) = 100*sum(all_Lon_arrs < Lon_F_W)/numel(all_Lon_arrs);
            pct_E_Fiji(iap,je,kh) = 100*sum(all_Lon_arrs > Lon_F_E)/numel(all_Lon_arrs);

            pct_N_Fiji(iap,je,kh) = 100*sum(all_Lat_arrs > Lat_F_N)/numel(all_Lon_arrs);

            lq_arrLon(iap,je,kh) = quantile(all_Lon_arrs,0.25);
            uq_arrLon(iap,je,kh) = quantile(all_Lon_arrs,0.75);

            lq_Hd(iap,je,kh) = quantile(all_ys_inher_heads(:),0.25);
            uq_Hd(iap,je,kh) = quantile(all_ys_inher_heads(:),0.75);  

            pct_Fiji(iap,je,kh) = 100*sum(all_Lat_arrs >= Fij_Lats(1) & ...
                all_Lat_arrs <= Fij_Lats(2) & all_Lon_arrs >= Fij_Lons(1) & ...
                all_Lon_arrs <= Fij_Lons(2))/numel(all_Lon_arrs);

            mn_disp(iap,je,kh) = mean(all_disp_d_dep);

            if base_err ~= err || ...
                    rev_alt_levs(fl_alt_lev) ~= alt_plt || max_ns_fl_hs(1) ~= mxH

                keyboard

            end

            % if pct_Fiji(iap,je,kh) < 0 || isnan(pct_Fiji(iap,je,kh))
            %     keyboard
            % end
            % mn_Ln_locs = circ_mean(all_Lon_arrs*pi/180);
            % std_Ln_ys = circ_std(all_Lon_arrs'*pi/180);
            % 
            % mn_Lon_arr(iap,je,kh) = mod(circ_mean(all_Lon_arrs*pi/180)*180/pi,360);
            % 
            % med_Lon_arr(iap,je,kh) =  median(mod(circ_mean(all_Lon_arrs*pi/180)*180/pi,360));
            % 
            % std_Lon_loc_arr(iap,je,kh) = mod(circ_std(all_Lon_arrs*pi/180)*180/pi,360); % fin_lns
            % 
            % iqr_Lon_arr(iap,je,kh) = mean(iqr(all_Lon_arrs*pi/180))*180/pi;
            % 
            % iqr_Lon_arr_ys(iap,je,kh) = mean(iqr(all_Lon_arrs*pi/180,2))*180/pi;

            % std_Lon_ys_arr(iap,je,kh) = mod(circ_mean(std_Ln_ys')*180/pi,360); % fin_lns            

            if plot_all_arr_Lns
                figure(888+100*iap); sgtitle([num2str(alt_plt) ' ' num2str(err) ' ' num2str(mxH)])
                subplot(5,4,(je-1)*4+kh)
                hist(all_ys_lon_fin(all_ys_stoppedAndArrived),160:210)       
                title([num2str(err) ' ' num2str(mxH)])
                xlim([160 190])
            end

        end

    end

end

% lq_Hd(4,2,4) = mean(lq_Hd(4,2,[3 5]));
% uq_Hd(4,2,4) = mean(uq_Hd(4,2,[3 5]));
% 
% lq_arrLon(4,2,4) = mean(lq_arrLon(4,2,[3 5]));
% uq_arrLon(4,2,4) = mean(uq_arrLon(4,2,[3 5]));

if plot_opt == 1

    plot_per_alt

else

    plot_per_flt_cpty

end
