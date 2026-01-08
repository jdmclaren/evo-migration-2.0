% aysA1 = all_ys_stoppedAndArrived(:,1);
% aysA20 = all_ys_stoppedAndArrived(:,20);

figure; subplot(1,2,1); 
violinplot(mod(all_ys_lon_fin(all_ys_stoppedAndArrived),360), ...
    [],'ViolinColor',[0 1 1]);
subplot(1,2,2); 
violinplot(mod(all_ys_lon_fin(~all_ys_stoppedAndArrived),360), ...
    [],'ViolinColor',[1 0 1]);

figure; subplot(1,2,1); 
violinplot(all_ys_lat_fin(all_ys_stoppedAndArrived), ...
    [],'ViolinColor',[0 1 1]);
subplot(1,2,2); 
violinplot(all_ys_lat_fin(~all_ys_stoppedAndArrived), ...
    [],'ViolinColor',[1 0 1]);

% figure; subplot(1,2,1); 
% violinplot(all_ys_inher_heads(all_ys_stoppedAndArrived), ...
%     [],'ViolinColor',[0 1 1]);
% subplot(1,2,2); 
% violinplot(all_ys_inher_heads(~all_ys_stoppedAndArrived), ...
%     [],'ViolinColor',[1 0 1]);

% figure; % subplot(1,2,1); 
% hps = polaraxes;
% if geomean(successful(:)) > 0.5
%     polarhistogram(all_ys_inher_heads(all_ys_stoppedAndArrived)*pi/180, ...
%        'FaceColor','c','FaceAlpha',0.5); % ,'FaceColor',[0 1 1])
%     hold
%     % subplot(1,2,2); 
%     polarhistogram(all_ys_inher_heads(~all_ys_stoppedAndArrived)*pi/180, ...
%         'FaceColor','m','FaceAlpha',0.5);
%     hps.ThetaZeroLocation = 'top';          % Change Angle Origin
%     hps.ThetaDir = 'clockwise'; 
% else
%     polarhistogram(all_ys_inher_heads(~all_ys_stoppedAndArrived)*pi/180, ...
%         'FaceColor','m','FaceAlpha',0.5);
%     hold
%     polarhistogram(all_ys_inher_heads(all_ys_stoppedAndArrived)*pi/180, ...
%         'FaceColor','c','FaceAlpha',0.5); % ,'LineColor',[0 1 1])
%     % subplot(1,2,2); 
% 
%     hps.ThetaZeroLocation = 'top';          % Change Angle Origin
%     hps.ThetaDir = 'clockwise'; 
% end

