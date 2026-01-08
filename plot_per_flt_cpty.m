
figure('Position',[100 100 250+100*pltRow 700])
sgtitle('Mean success (%)','FontSize',10)
for iac = 1:n_flh_plt

    iacc = n_flh_plt - iac + 1;

    flc_plt = mxHs_plt(iac);
    subplot(pltCol,pltRow,iacc)
    imagesc(err_plts,alt_plts,100*squeeze(mn_succ_pl(:,:,iac)))
    set(gca,'XTick',xtks_plt,'YTick',0:750:1500,'YTickLabel',ytks(end:-1:1))
    colormap(brewermap([],'Blues'))
    title(['Flight capacity ' num2str(flc_plt/2) '-' num2str(flc_plt) ' h'])
    set(gca,'YDir','normal')
    if iac ==  1
         xlabel('Std compass error (^o)')
    end
    if iac == 2 % 1 || iac == 3
        ylabel('Flight altitude (m)')
    end
    clim([min_succ 100])

end
figure('Position',[200 100 300 700]) % 200 400])
colorbar
colormap(brewermap([],'Blues')) % Greens'))
clim([min_succ 100])
box off; axis off

figure('Position',[300 100 250+100*pltRow 700]) % 150+100*pltRow 400])
sgtitle('Mean arr. longitude (^o)','FontSize',10)
for iac = 1:n_flh_plt

    iacc = n_flh_plt - iac + 1;

    flc_plt = mxHs_plt(iac);
    subplot(pltCol,pltRow,iacc)
    imagesc(err_plts,alt_plts,squeeze(mn_Lon_pl(:,:,iac)))
    set(gca,'XTick',xtks_plt,'YTick',0:750:1500,'YTickLabel',ytks(end:-1:1))
    colormap(brewermap([],'PiYG'))
    title(['Flight capacity ' num2str(flc_plt/2) '-' num2str(flc_plt) ' h'])
    set(gca,'YDir','normal')
    if iac ==  1
         xlabel('Std compass error (^o)')
    end
    if iac == 2 % 1 || iac == 3
        ylabel('Flight altitude (m)')
    end
    clim(Lon_lims); % ([160 200]);
    
end
figure('Position',[min_succ0 100 300 700]) % 200 400])
cb = colorbar;
colormap(brewermap([],'PiYG'))
clim(Lon_lims);
set(cb,'XTicK',Lon_lims(1):2:Lon_lims(2)); % 200,'XTicKLabel',[160 170 180 -170 -160])
box off; axis off

figure('Position',[300 100 250+100*pltRow 700]) %
sgtitle('Popn IQR Arr. Long (^o)','FontSize',10)
for iac = 1:n_flh_plt

    iacc = n_flh_plt - iac + 1;

    flc_plt = mxHs_plt(iac);
    subplot(pltCol,pltRow,iacc)
    imagesc(err_plts,alt_plts,squeeze(iqr_Lon_pl(:,:,iac)))
    set(gca,'XTick',xtks_plt,'YTick',0:750:1500,'YTickLabel',ytks(end:-1:1))
    colormap(brewermap([],'Greens')); % Reds')); % ,'RdYlBu'))
    title(['Flight capacity ' num2str(flc_plt/2) '-' num2str(flc_plt) ' h'])
    set(gca,'YDir','normal')
    if iac ==  1
         xlabel('Std compass error (^o)')
    end
    if iac == 2 % 1 || iac == 3
        ylabel('Flight altitude (m)')
    end
    clim(dLon_lims)

end
figure('Position',[min_succ0 100 300 700]) % 200 400])
colorbar
colormap(brewermap([],'Greens')); % ,'RdYlBu'))
clim(dLon_lims)
box off; axis off


figure('Position',[500 100 250+100*pltRow 700]) % 150+100*pltRow 400])
sgtitle('Mean inher headings (^o)','FontSize',10)
for iac = 1:n_flh_plt

    iacc = n_flh_plt - iac + 1;

    flc_plt = mxHs_plt(iac);
    subplot(pltCol,pltRow,iacc)
    imagesc(err_plts,alt_plts,squeeze(mn_hds_pl(:,:,iac)))
    set(gca,'XTick',xtks_plt,'YTick',0:750:1500,'YTickLabel',ytks(end:-1:1))
    colormap(brewermap([],'RdBu'))
    title(['Flight capacity ' num2str(flc_plt/2) '-' num2str(flc_plt) ' h'])
    set(gca,'YDir','normal')
    if iac ==  1
         xlabel('Std compass error (^o)')
    end
    if iac == 2
        ylabel('Flight altitude (m)')
    end
    clim(Hd_lims)

end
figure('Position',[600 100 300 700]) %  200 400])
colorbar
colormap(brewermap([],'RdBu'))
clim(Hd_lims)
box off; axis off

figure('Position',[700 100 250+100*pltRow 700]) % 150+100*pltRow 400])
sgtitle('Popn IQR headings (^o)','FontSize',10)
for iac = 1:n_flh_plt

    iacc = n_flh_plt - iac + 1;

    flc_plt = mxHs_plt(iac);
    subplot(pltCol,pltRow,iacc)
    imagesc(err_plts,alt_plts,squeeze(iqr_hds_pl(:,:,iac)))
    set(gca,'XTick',xtks_plt,'YTick',0:750:1500,'YTickLabel',ytks(end:-1:1))
    colormap(brewermap([],'Reds')); % Reds')); % ,'RdYlBu'))
    title(['Flight capacity ' num2str(flc_plt/2) '-' num2str(flc_plt) ' h'])
    set(gca,'YDir','normal')
    if iac ==  1
         xlabel('Std compass error (^o)')
    end
    if iac == 2 % 1 || iac == 3
        ylabel('Flight altitude (m)')
    end
    clim([3 5])

end
figure('Position',[800 100 300 700]) % 200 400])
colorbar
colormap(brewermap([],'Reds')); % ,'RdYlBu'))
clim([3 5])
box off; axis off

% figure('Position',[500 100 150+100*pltRow 400])
% sgtitle('Mean yearly change heading per locn (^o)','FontSize',10)
% for iac = 1:n_flh_plt
% 
%     flc_plt = mxHs_plt(iac);
%     subplot(pltCol,pltRow,iacc)
%     imagesc(err_plts,alt_plts,squeeze(mn_diff_hds_pl(:,:,iac))')
%     set(gca,'XTick',xtks_plt,'YTick',0:750:1500,'YTickLabel',ytks(end:-1:1))
%     colormap(brewermap([],'RdBu')); % 'YlOrRd')); % 
%     title(['Flight capacity ' num2str(flc_plt/2) '-' num2str(flc_plt) ' h'])
%     set(gca,'YDir','normal')
%     if iac ==  1
%          xlabel('Std compass error (^o)')
%     end
%     if iac == 1 || iac == 3
%         ylabel('Flight altitude (m)')
%     end
%     clim([-0.1 0.1])
% 
% end
% figure('Position',[550 100 200 400])
% colorbar
% colormap(brewermap([],'RdBu')); % 'YlOrRd')); % 
% clim([-0.1 0.1])
% box off; axis off
