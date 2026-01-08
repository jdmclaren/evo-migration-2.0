figure

if mig_sys == 3
    blons = mod(blons,2*pi);
end
% histogram(std_inher_head(stoppedAndArrived)*180/pi)
scatter(blons(stoppedAndArrived,1)*180/pi, ...
    blats(stoppedAndArrived,1)*180/pi,100, ...
    std_inher_head(stoppedAndArrived)*180/pi,'LineWidth',1)
colorbar

% figure; scatter(blons(:,1)*180/pi,blats(:,1)*180/pi,50,std_inher_signp*180/pi,'fill')
% colorbar

% figure; scatter(blons(:,1)*180/pi,blats(:,1)*180/pi,50,std_inher_signp*100,'fill')
% colorbar
% caxis([0.6 0.65])

mn_in_hd = median(std_inher_head(stoppedAndArrived))*180/pi;
disp(['median std inher heads ' num2str(round(mn_in_hd*10)/10)])
std_in_hd = mad(std_inher_head(stoppedAndArrived))*180/pi;
disp(['mad std inher heads ' num2str(round(std_in_hd*100)/100)])

% mn_in_hd = circ_mean(std_inher_head(stoppedAndArrived))*180/pi;
% disp(['mean std inher heads ' num2str(round(mn_in_hd*10)/10)])
% std_in_hd = circ_std(std_inher_head(stoppedAndArrived))*180/pi;
% disp(['std std inher heads ' num2str(round(std_in_hd*10)/10)])

if zug_opt == 1
    figure

    if zug_signp <= 2 % magns ~= 2 && magns ~= 5 && magns ~= 6
        
        scatter(blons(stoppedAndArrived,1)*180/pi, ...
            blats(stoppedAndArrived,1)*180/pi,100, ...
            std_inher_signp(stoppedAndArrived)*180/pi,'LineWidth',1)
        
        mn_in_zsp = median(std_inher_signp(stoppedAndArrived))*180/pi;
        disp(['mean std inher signps ' num2str(round(mn_in_zsp*10)/10)])
        std_in_zsp = mad(std_inher_signp(stoppedAndArrived))*180/pi;
        disp(['std std inher signps ' num2str(round(std_in_zsp*10)/10)])
%         mn_in_zsp = mean(std_inher_signp(stoppedAndArrived))*180/pi;
%         disp(['mean std inher signps ' num2str(round(mn_in_zsp*10)/10)])
%         std_in_zsp = std(std_inher_signp(stoppedAndArrived))*180/pi;
%         disp(['std std inher signps ' num2str(round(std_in_zsp*10)/10)])
        
    else
        
        scatter(blons(stoppedAndArrived,1)*180/pi, ...
            blats(stoppedAndArrived,1)*180/pi,100, ...
            std_inher_signp(stoppedAndArrived)*100,'LineWidth',1)

        mn_in_zsp = mean(std_inher_signp(stoppedAndArrived))*100;
        disp(['mean std inher signps ' num2str(round(mn_in_zsp))])
        std_in_zsp = std(std_inher_signp(stoppedAndArrived))*100;
        disp(['std std inher signps ' num2str(round(std_in_zsp))])
        
    end
    colorbar
end

if numel(unique(succ_disp_d_dep)) > 1
    figure
    scatter(blons(stoppedAndArrived,1)*180/pi, ...
        blats(stoppedAndArrived,1)*180/pi,100, ...
        succ_disp_d_dep,'LineWidth',1)
    colorbar
end


% figure
% subplot(1,2,1)
% scatter(blons(stoppedAndArrived,1)*180/pi, ...
%     blats(stoppedAndArrived,1)*180/pi,100, ...
%     succ_disp_d_dep,'LineWidth',1)
% colorbar
% 
% subplot(1,2,2)
% scatter(blons(stoppedAndArrived,1)*180/pi, ...
%     blats(stoppedAndArrived,1)*180/pi,100, ...
%     succ_disp_d_arr,'LineWidth',1)
% colorbar
% colorbar   

figure
subplot(1,2,1)
hist(succ_disp_d_dep)
subplot(1,2,2)
hist(succ_disp_d_arr)

figure
yyaxis left
plot(mn_std_inh_hds*180/pi)
yyaxis right
plot(std_std_inh_hds*180/pi)

R_Earth_km = 6371;
figure
yyaxis left
plot(mn_disp_d_dep)
yyaxis right
plot(std_disp_d_dep) % *R_Earth_km*pi/180