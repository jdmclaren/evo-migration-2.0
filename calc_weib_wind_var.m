means = [7 10];
exps = [2 1.5];

for im = 1:2

    mn_i = means(im);
    exp_i = exps(im);
    gam_1 = gamma(1 + 1/exp_i);
    % calc scale para giving correct mean
    llam = mn_i/gam_1;
    % calc var
    stds(im) = sqrt(llam^2*(gamma(1 + 2/exp_i) - gam_1^2));

end