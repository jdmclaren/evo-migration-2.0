% documentation, see https://www.earthenv.org/landcover
% load water for proportions in coastal areas
% load water_1_deg

kLands = 1:4; % [1:5 7]; % 1:8; %  10; % 5:6 % 1:4; % [1 4]; % 1:12; % 1:4; % 
% wts = double([2 1]);
% kLands = 1:2 % 1:4;
% clear yy

yy = NaN(17520,43200,numel(kLands));

yWt = imread(['Consensus_full_class_' num2str(12) '.tif'], 'tif');

for kL = 1:numel(kLands) % 12
    % 1-4 trees, 5-8 other veg, 9 urban, 10 snow, 11 barren, 12 water
    y = imread(['Consensus_full_class_' num2str(kLands(kL)) '.tif'], 'tif');
    yy(:,:,kL) = y;
     
end

res = 1; %  0.05; % 0.25; % 
n_pix = 120*res;

n2_pix = n_pix^2;

all_leaf_qs = NaN(146/res,360/res,5);

    for jLat = 1:146/res
        for iLon = 1:360/res

            yijs = yy((jLat-1)*n_pix+(1:n_pix), ...
                (iLon-1)*n_pix+(1:n_pix),:);

            yij_sum = double(sum(yijs,3));

            yWt_ijs = yWt((jLat-1)*n_pix+(1:n_pix), ...
                (iLon-1)*n_pix+(1:n_pix));

            % yWt_sum = sum(double(yWt_ijs(:)))/n2_pix;

            lnd_ijs = 100-double(yWt_ijs);

            some_lnd = lnd_ijs > 0;

            veg_lnd(some_lnd) = yij_sum(some_lnd(:))./lnd_ijs(some_lnd(:));
            veg_lnd(~some_lnd) = 0; 

            try
            % all_leaf_mn(jLat,iLon) = mean(double(yijs(:))); % quantile(yij(yij>0),0.5,'all');
            all_leaf_qs(jLat,iLon,:) = min(quantile(veg_lnd,[0.05 0.25 0.5 0.75 0.95]),1); %
            all_leaf_mn(jLat,iLon) = mean(veg_lnd);
            all_leaf_std(jLat,iLon) = std(veg_lnd);
            catch
                keyboard
            end

        end
    end

    save('all_tree_1_km','all_leaf_qs','all_leaf_mn','all_leaf_std','kLands')
   
% wt_sum = sum(wts.*yy,3);
% y_sum = sum(yy,3);
% yf = im2double(y_sum)/im2double(100); % im2double(max(y_sum(:)));

% scale to water
% yf = yf./max((1-water),0.01);