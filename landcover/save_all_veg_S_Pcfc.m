% documentation, see https://www.earthenv.org/landcover
% load water for proportions in coastal areas
% load water_1_deg

kLands = 1:5; % [1:4 7]; %   10; % 5:6 % 1:4; % [1 4]; % 1:12; % 1:4; % 
% wts = double([2 1]);
% kLands = 1:2 % 1:4;
% clear yy

% quanmtiles to save
qs = 1; % [0.05 0.25 0.5 0.75 0.9 0.95];
nqs = numel(qs);

if ~exist('yy')

    yy = NaN(17520,43200,numel(kLands));    
    
    yWt = imread(['Consensus_full_class_' num2str(12) '.tif'], 'tif');
    
    for kL = 1:numel(kLands) % 12
        % 1-4 trees, 5-8 other veg, 9 urban, 10 snow, 11 barren, 12 water
        y = imread(['Consensus_full_class_' num2str(kLands(kL)) '.tif'], 'tif');
        yy(:,:,kL) = y;
         
    end

end

n_Ln_wrld = size(yy,2);

res = 2; %  0.05; % 0.25; % 
n_pix = 1*res;

n2_pix = n_pix^2;

all_leaf_qs = NaN(146/res,360/res);

res = 1/60;
Lns = 140:res:220;
fst_ln = (180+140)*120;
Lts = -60:res:40;
Lts_lc = -56:res:40;
fst_lt = 50*120;

n_Lts_lc = numel(Lts_lc)-1;
n_Lts = numel(Lts)-1;
n_Lns = numel(Lns)-1;

clear some_lnd veg_lnd

    for jLat = 1:n_Lts_lc % 91:146/res
        for iLon = 1:n_Lns % 1:360/res

            try

            if fst_ln + (iLon-1)*n_pix > n_Ln_wrld-1
                Ln_idx = mod(fst_ln + (iLon-1)*n_pix+(1:n_pix),n_Ln_wrld);
            else
                Ln_idx = fst_ln + (iLon-1)*n_pix+(1:n_pix);
            end


             yijs = yy(fst_lt + (jLat-1)*n_pix+(1:n_pix),Ln_idx,:);
             yWt_ijs = yWt(fst_lt + (jLat-1)*n_pix+(1:n_pix),Ln_idx);


            yij_sum = double(sum(yijs,3));

            % yWt_sum = sum(double(yWt_ijs(:)))/n2_pix;

            lnd_ijs = 100-double(yWt_ijs);

            some_lnd = lnd_ijs > 0;

            veg_lnd(some_lnd) = yij_sum(some_lnd(:))./lnd_ijs(some_lnd(:));
            veg_lnd(~some_lnd) = 0; 

            all_leaf_SP(jLat,iLon) = min(quantile(veg_lnd,qs),1); %
            % try
            % % all_leaf_mn(jLat,iLon) = mean(double(yijs(:))); % quantile(yij(yij>0),0.5,'all');
            % all_leaf_qs(jLat,iLon,:) = min(quantile(veg_lnd,qs),1); %
            % all_leaf_mn(jLat,iLon) = mean(veg_lnd);
            % all_leaf_std(jLat,iLon) = std(veg_lnd);

            catch
                keyboard
            end

        end
    end

    % ignore landcover below 56S
    all_leaf_SP(n_Lts_lc:n_Lts,:) = 0;

    save('all_veg_60_S_Pcfc','all_leaf_SP','kLands') % ,'veg_lnd'
   
    figure; imagesc(all_leaf_SP)
    colorbar

% wt_sum = sum(wts.*yy,3);
% y_sum = sum(yy,3);
% yf = im2double(y_sum)/im2double(100); % im2double(max(y_sum(:)));

% scale to water
% yf = yf./max((1-water),0.01);