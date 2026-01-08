% field 1 is init head (vs geo/mag/sun), 2 is start date
plot_fld_opt =  1 % 2 %

% if plot_fld_opt == 1 && mig_sys == 5 
%     
%    all_init_heads(all_init_heads > 180) = ...
%        all_init_heads(all_init_heads > 180) - 360;
%     
% end

plot_fld = (plot_fld_opt == 1)*all_init_heads + ...
    (plot_fld_opt == 2)*all_day_starts;

figure

if mig_sys == 3
    
    blons = mod(blons,2*pi);
    
end

if stop_opt == 1
    
    subplot(1,2,1)
    scatter(blons(stoppedAndArrived,1)*180/pi, ...
        blats(stoppedAndArrived,1)*180/pi,100, ...
        plot_fld(stoppedAndArrived),'LineWidth',1)
    colorbar
    
    subplot(1,2,2)
    scatter(blons(~stoppedAndArrived,1)*180/pi, ...
        blats(~stoppedAndArrived,1)*180/pi,100, ...
        plot_fld(~stoppedAndArrived),'x')
    colorbar

else
    
    subplot(2,1,1)    
    sc = scatter(blons(arrived,1)*180/pi, ...
        blats(arrived,1)*180/pi,100, ...
        plot_fld(arrived),'fill'); % 'LineWidth',1)
    sc.MarkerFaceAlpha = 0.3;
    colorbar
    
    subplot(2,1,2)
    scatter(blons(~arrived,1)*180/pi, ...
        blats(~arrived,1)*180/pi,100, ...
        plot_fld(~arrived),'x')
    
      colorbar
    
end