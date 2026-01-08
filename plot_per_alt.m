figure('Position',[150 100 200 600])
colorbar
colormap(brewermap([],Succ_clr_map)) % 'Blues' % Greens'))
clim([min_succ 100])
box off; axis off

figure('Position',[100 100 75+100*pltRow 600])
sgtitle('Mean success (%)','FontSize',12)
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(mn_succ_pl(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],Succ_clr_map)) % 'Blues'
    % title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)','FontSize',10)
    end
    if plot_y_lbs
        if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
            if mod(n_alt_plt,2) == 1
                ylabel('Max flight capacity (h)','FontSize',10)
            else
                ylabel(['                          '   ...
                    '       Max flight capacity (h)'],'FontSize',10)
            end
        end
    end
    clim([min_succ 100])

end

% figure('Position',[950 100 200 600])
% colorbar
% colormap(brewermap([],Dspers_clr_map)) % 'Blues' % Greens'))
% clim(disp_lims)
% box off; axis off
% 
% figure('Position',[900 100 75+100*pltRow 600])
% sgtitle('Mean disp dist (km)','FontSize',12)
% for iap = 1:n_alt_plt
% 
%     alt_plt = alt_plts(iap);
%     subplot(pltCol,pltRow,iap)
%     imagesc(err_plts,mxHs_plt,squeeze(mn_disp(iap,:,:))')
%     set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
%     colormap(brewermap([],Dspers_clr_map)) % 'Blues'
%     % title(['Flight altitude ' num2str(alt_plt) ' m'])
%     set(gca,'YDir','normal')
%     if iap == n_alt_plt
%          xlabel('Std compass error (^o)','FontSize',10)
%     end
%     if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
%         if mod(n_alt_plt,2) == 1
%             ylabel('Max flight capacity (h)','FontSize',10)
%         else
%             ylabel(['                          '   ...
%                 '       Max flight capacity (h)'],'FontSize',10)
%         end
%     end
%     clim(disp_lims)
% 
% end


% 
% figure('Position',[300 100 75+100*pltRow 600])
% sgtitle('Lower qt. longitude (^o)','FontSize',12)
% for iap = 1:n_alt_plt
% 
%     alt_plt = alt_plts(iap);
%     subplot(pltCol,pltRow,iap)
%     imagesc(err_plts,mxHs_plt,squeeze(lq_arrLon(iap,:,:))')
%     set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
%     colormap(brewermap([],'PiYG'))
%     title(['Flight altitude ' num2str(alt_plt) ' m'])
%     set(gca,'YDir','normal')
%     if iap == n_alt_plt
%          xlabel('Std compass error (^o)')
%     end
%     if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
%         ylabel('Max flight capacity (h)')
%     end
%     clim(Lon_lims); % ([160 200]);
% 
% end
% figure('Position',[350 100 200 600])
% cb = colorbar;
% colormap(brewermap([],'PiYG'))
% clim(Lon_lims);
% set(cb,'XTicK',Lon_tics); % 200,'XTicKLabel',[160 170 180 -170 -160])
% box off; axis off
% 
% figure('Position',[300 100 75+100*pltRow 600])
% sgtitle('Upper qt. longitude (^o)','FontSize',12)
% for iap = 1:n_alt_plt
% 
%     alt_plt = alt_plts(iap);
%     subplot(pltCol,pltRow,iap)
%     imagesc(err_plts,mxHs_plt,squeeze(uq_arrLon(iap,:,:))')
%     set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
%     colormap(brewermap([],'PiYG'))
%     title(['Flight altitude ' num2str(alt_plt) ' m'])
%     set(gca,'YDir','normal')
%     if iap == n_alt_plt
%          xlabel('Std compass error (^o)')
%     end
%     if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
%         ylabel('Max flight capacity (h)')
%     end
%     clim(Lon_lims); % ([160 200]);
% 
% end
% figure('Position',[350 100 200 600])
% cb = colorbar;
% colormap(brewermap([],'PiYG'))
% clim(Lon_lims);
% set(cb,'XTicK',Lon_tics); % 200,'XTicKLabel',[160 170 180 -170 -160])
% box off; axis off

% figure('Position',[350 100 200 600])
% cb = colorbar;
% colormap(brewermap([],Hds_clr_map)) % 'RdBu')) %
% clim(Hd_lims);
% set(cb,'XTicK',Hd_tics); % 200,'XTicKLabel',[160 170 180 -170 -160])
% box off; axis off
% 
% figure('Position',[200 100 75+100*pltRow 600])
% sgtitle('Lower qt. heading (^o)','FontSize',12)
% for iap = 1:n_alt_plt
% 
%     alt_plt = alt_plts(iap);
%     subplot(pltCol,pltRow,iap)
%     imagesc(err_plts,mxHs_plt,squeeze(lq_Hd(iap,:,:))')
%     set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
%     colormap(brewermap([],Hds_clr_map)) % 'RdBu')) %
%     % title(['Flight altitude ' num2str(alt_plt) ' m'])
%     set(gca,'YDir','normal')
%     if iap == n_alt_plt
%          xlabel('Std compass error (^o)','FontSize',10)
%     end
%     if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
%         if mod(n_alt_plt,2) == 1
%             ylabel('Max flight capacity (h)','FontSize',10)
%         else
%             ylabel(['                          '   ...
%                 '       Max flight capacity (h)'],'FontSize',10)
%         end
%     end
%     clim(Hd_lims); % ([160 200]);
% 
% end
% 
% figure('Position',[300 100 75+100*pltRow 600])
% sgtitle('Upper qt. heading (^o)','FontSize',12)
% for iap = 1:n_alt_plt
% 
%     alt_plt = alt_plts(iap);
%     subplot(pltCol,pltRow,iap)
%     imagesc(err_plts,mxHs_plt,squeeze(uq_Hd(iap,:,:))')
%     set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
%     colormap(brewermap([],Hds_clr_map)) % 'RdBu')) %
%     % title(['Flight altitude ' num2str(alt_plt) ' m'])
%     set(gca,'YDir','normal')
%     if iap == n_alt_plt
%          xlabel('Std compass error (^o)','FontSize',10)
%     end
%     if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
%         if mod(n_alt_plt,2) == 1
%             ylabel('Max flight capacity (h)','FontSize',10)
%         else
%             ylabel(['                          '   ...
%                 '       Max flight capacity (h)'],'FontSize',10)
%         end
%     end
%     clim(Hd_lims); % ([160 200]);
% 
% end


%% 

% figure('Position',[200 100 75+100*pltRow 600])
% sgtitle('IQR success (%)','FontSize',12)
% for iap = 1:n_alt_plt
% 
%     alt_plt = alt_plts(iap);
%     subplot(pltCol,pltRow,iap)
%     imagesc(err_plts,mxHs_plt,squeeze(iqr_succ_arrs(iap,:,:))')
%     set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
%     colormap(brewermap([],'RdPu')); % ,'YlOrRd')) % 'Blues'
%     title(['Flight altitude ' num2str(alt_plt) ' m'])
%     set(gca,'YDir','normal')
%     if iap == n_alt_plt
%          xlabel('Std compass error (^o)')
%     end
%     if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
%         ylabel('Max flight capacity (h)')
%     end
%     clim([0 20])
% 
% end
% figure('Position',[250 100 200 600])
% colorbar
% colormap(brewermap([],'RdPu'))% 'Blues' % Greens'))
% clim([0 20])
% box off; axis off
% 
% figure('Position',[600 100 75+100*pltRow 600])
% sgtitle('Mean arr. longitude (^o)','FontSize',12)
% for iap = 1:n_alt_plt
% 
%     alt_plt = alt_plts(iap);
%     subplot(pltCol,pltRow,iap)
%     imagesc(err_plts,mxHs_plt,squeeze(mn_Lon_pl(iap,:,:))')
%     set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
%     colormap(brewermap([],'PiYG'))
%     title(['Flight altitude ' num2str(alt_plt) ' m'])
%     set(gca,'YDir','normal')
%     if iap == n_alt_plt
%          xlabel('Std compass error (^o)')
%     end
%     if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
%         ylabel('Max flight capacity (h)')
%     end
%     clim(mn_Lon_lims); % ([160 200]);
% 
% end
% figure('Position',[650 100 200 600])
% cb = colorbar;
% colormap(brewermap([],'PiYG'))
% clim(mn_Lon_lims);
% set(cb,'XTicK',mn_Lon_tics); % 200,'XTicKLabel',[160 170 180 -170 -160])
% box off; axis off

figure('Position',[650 100 200 600])
cb = colorbar;
colormap(brewermap([],Fij_clr_map)) % 'YlOrRd'
clim(pct_Fiji_lims);
set(cb,'XTicK',pct_Fiji_tics); % 200,'XTicKLabel',[160 170 180 -170 -160])
box off; axis off

figure('Position',[400 100 75+100*pltRow 600])
sgtitle('Arrival W of Fijis (%)','FontSize',12)
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(pct_W_Fiji(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],Fij_clr_map)) % 'YlOrRd'
    % title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)','FontSize',10)
    end
    if plot_y_lbs
        if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
            if mod(n_alt_plt,2) == 1
                ylabel('Max flight capacity (h)','FontSize',10)
            else
                ylabel(['                          '   ...
                    '       Max flight capacity (h)'],'FontSize',10)
            end
        end
    end
    clim(pct_Fiji_lims); % ([160 200]);

end
% figure('Position',[550 100 200 600])
% cb = colorbar;
% colormap(brewermap([],Fij_clr_map)) % 'YlOrRd'
% clim(pct_Fiji_lims);
% set(cb,'XTicK',pct_Fiji_tics); % 200,'XTicKLabel',[160 170 180 -170 -160])
% box off; axis off

figure('Position',[500 100 75+100*pltRow 600])
sgtitle('Arrival on Fijis (%)','FontSize',12)
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(pct_Fiji(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],Fij_clr_map)) % 'YlOrRd'
    % title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)','FontSize',10)
    end
    if plot_y_lbs
        if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
            if mod(n_alt_plt,2) == 1
                ylabel('Max flight capacity (h)','FontSize',10)
            else
                ylabel(['                          '   ...
                    '       Max flight capacity (h)'],'FontSize',10)
            end
        end
    end
    clim(pct_Fiji_lims); % ([160 200]);

end
% figure('Position',[650 100 200 600])
% cb = colorbar;
% colormap(brewermap([],Fij_clr_map)) % 'YlOrRd'
% clim(pct_Fiji_lims);
% set(cb,'XTicK',pct_Fiji_tics); % 200,'XTicKLabel',[160 170 180 -170 -160])
% box off; axis off

% figure('Position',[500 100 75+100*pltRow 600])
% sgtitle('Arrival N of Fiji Lats (%)','FontSize',12)
% for iap = 1:n_alt_plt
% 
%     alt_plt = alt_plts(iap);
%     subplot(pltCol,pltRow,iap)
%     imagesc(err_plts,mxHs_plt,squeeze(pct_N_Fiji(iap,:,:))')
%     set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
%     colormap(brewermap([],Fij_clr_map)) % 'YlOrRd'
%     title(['Flight altitude ' num2str(alt_plt) ' m'])
%     set(gca,'YDir','normal')
%     if iap == n_alt_plt
%          xlabel('Std compass error (^o)')
%     end
%     if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
%         ylabel('Max flight capacity (h)')
%     end
%     clim(pct_Fiji_lims); % ([160 200]);
% 
% end
% figure('Position',[550 100 200 600])
% cb = colorbar;
% colormap(brewermap([],Fij_clr_map)) % 'YlOrRd'
% clim(pct_Fiji_lims);
% set(cb,'XTicK',pct_Fiji_tics); % 200,'XTicKLabel',[160 170 180 -170 -160])
% box off; axis off

figure('Position',[600 100 75+100*pltRow 600])
sgtitle('Arrival E of Fijis (%)','FontSize',12)
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(pct_E_Fiji(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],Fij_clr_map)) % 'YlOrRd'
    % title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)','FontSize',10)
    end
    if plot_y_lbs
        if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
            if mod(n_alt_plt,2) == 1
                ylabel('Max flight capacity (h)','FontSize',10)
            else
                ylabel(['                          '   ...
                    '       Max flight capacity (h)'],'FontSize',10)
            end
        end
    end
    clim(pct_Fiji_lims); % ([160 200]);

end



figure('Position',[600 100 75+100*pltRow 600])
sgtitle({'Population IQR', ...
    'Arrival Longitude (^o)'},'FontSize',12)
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(iqr_Lon_pl(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],iqr_Lons_clr_map)) % 'Blues'; % Reds')); % ,'RdYlBu'))
    title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)')
    end
    % if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
    %     ylabel('Max flight capacity (h)')
    % end
    clim(dLon_lims)

end
% figure('Position',[650 100 200 600])
% colorbar
% colormap(brewermap([],'Greens')) % 'Blues'; % ,'RdYlBu'))
% clim(dLon_lims)
% box off; axis off


figure('Position',[700 100 75+100*pltRow 600])
sgtitle({'Local IQR', ...
    'Arrival Longitude (^o)'},'FontSize',12)
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(iqr_Lon_ys(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],iqr_Lons_clr_map)); %'Blues')) % 'Greens'; % Reds')); % ,'RdYlBu'))
    title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)')
    end
    % if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
    %     ylabel('Max flight capacity (h)')
    % end
    clim(dLon_lims)

end

figure('Position',[750 100 200 600])
colorbar
colormap(brewermap([],iqr_Lons_clr_map)) % 'Blues'; % ,'RdYlBu'))
clim(dLon_lims)
box off; axis off

% 
% 
figure('Position',[800 100 75+100*pltRow 600])
sgtitle('Mean headings (^o)','FontSize',12) % inher 
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(mn_hds_pl(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],Hds_clr_map))
    % title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)','FontSize',10)
    end
    if plot_y_lbs
        if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
            if mod(n_alt_plt,2) == 1
                ylabel('Max flight capacity (h)','FontSize',10)
            else
                ylabel(['                          '   ...
                    '       Max flight capacity (h)'],'FontSize',10)
            end
        end
    end
    clim(mn_Hd_lims)
    % set(cb,'XTicK',mn_Hd_tics);
end
figure('Position',[850 100 200 600])
cb = colorbar;
colormap(brewermap([],Hds_clr_map)) % 'RdBu')) % 
clim(mn_Hd_lims)
set(cb,'YTicK',mn_Hd_tics);
box off; axis off

% 
figure('Position',[900 100 75+100*pltRow 600])
sgtitle('IQR headings (^o)','FontSize',12) % Popn 
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(iqr_hds_pl(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],iqr_Hds_clr_map)); % Reds')); % ,'RdYlBu'))
    % title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)','FontSize',10)
    end
    if plot_y_lbs
        if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
            if mod(n_alt_plt,2) == 1
                ylabel('Max flight capacity (h)','FontSize',10)
            else
                ylabel(['                          '   ...
                    '       Max flight capacity (h)'],'FontSize',10)
            end
        end
    end

    % colorbar
    clim(iqr_Hd_lims)

end
figure('Position',[950 100 200 600])
cb = colorbar;
colormap(brewermap([],iqr_Hds_clr_map)); % ,'RdYlBu'))
clim(iqr_Hd_lims)
set(cb,'YTicK',iqr_Hd_tics,'YTicKLabel',iqr_Hd_tic_lbl);
box off; axis off
% 

figure('Position',[1000 100 75+100*pltRow 600])
sgtitle('Long-term local IQR headings (^o)','FontSize',12)
for iap = 1:n_alt_plt

    alt_plt = alt_plts(iap);
    subplot(pltCol,pltRow,iap)
    imagesc(err_plts,mxHs_plt,squeeze(iqr_hds_ys(iap,:,:))')
    set(gca,'XTick',xtks_plt ,'YTick',ytks_plt)
    colormap(brewermap([],iqr_Hds_clr_map)); % Reds')); % ,'RdYlBu'))
    title(['Flight altitude ' num2str(alt_plt) ' m'])
    set(gca,'YDir','normal')
    if iap == n_alt_plt
         xlabel('Std compass error (^o)')
    end
    if iap == round(n_alt_plt/2 +1) % 1 || iap == 3
        ylabel('Max flight capacity (h)')
    end

    % colorbar
    clim(tmpl_iqr_Hd_lims)

end
% figure('Position',[1050 100 200 600])
% colorbar
% colormap(brewermap([],'Reds')); % 'Blues')); % ,'RdYlBu'))
% clim([2 7])
% box off; axis off
% 
% 
% % figure('Position',[500 100 75+100*pltRow 600])
% % sgtitle('Mean yearly change heading per locn (^o)','FontSize',12)
% % for iap = 1:n_alt_plt
% % 
% %     alt_plt = alt_plts(iap);
% %     subplot(pltCol,pltRow,iap)
% %     imagesc(err_plts,mxHs_plt,squeeze(mn_diff_hds_pl(iap,:,:))')
% %     set(gca,'XTick',xtks_plt,'YTick',ytks)
% %     colormap(brewermap([],'*RdYlBu')); % 'YlOrRd')); % 
% %     title(['Flight altitude ' num2str(alt_plt) ' m'])
% %     set(gca,'YDir','normal')
% %     if iap == n_alt_plt
% %          xlabel('Std compass error (^o)')
% %     end
% %     if iap == 1 || iap == 3
% %         ylabel('Max flight capacity (h)')
% %     end
% %     clim([-0.1 0.1])
% % 
% % end
% % figure('Position',[550 100 200 600])
% % colorbar
% % colormap(brewermap([],'RdBu')); % 'YlOrRd')); % 
% % clim([-0.1 0.1])
% % box off; axis off
