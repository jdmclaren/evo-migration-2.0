function tailw = calc_wind_supprt(alpha,u,v,N_S_migr)

w_str = sqrt(u.^2 + v.^2);
w_dir = atan2(u,v);

if N_S_migr

    tailw = w_str.*cos(pi+alpha-w_dir);

else

    tailw = w_str.*cos(alpha-w_dir);

end