land = shaperead('landareas','UseGeoCoords', true);
addpath('brewer/')
figure
bg_clr = 0.94; % 1; % 0.825;
set(gcf,'color',[bg_clr bg_clr bg_clr]); % [0.9 0.9 0.9]);
ax = worldmap([-50 -10],[150 210]);
setm(ax,'mapprojection','Mercator')
lnd_clr = 0.75; %  0.775; %  0.875; % [0.875 0.9 0.865 ]
scatterm(mod(theta*180/pi,360),llamda*180/pi,10,arrived,'fill')
geoshow(land, 'FaceColor',[0.825 0.885 0.815 ],'EdgeColor',[0.65 0.65 0.65]) %
colormap(brewermap([],'*RdYlBu')); % '*YlGnBu')); % ,