function P_opt = waterfilling(snr, d, r)
  
    P_opt = zeros(r, 1);
    P_temp = 0; %initial value for P_opt

    for p = 1:r

        sigma = 0;

        for i = 1:r - p + 1
            sigma = sigma + 1 / (d(i, i));
        end

        if P_temp == 0
            mu = 1 / (r - p + 1) * (1 + 1 / snr * sigma); %mu change when P_opt = 0

        end

        P_temp = mu - 1 / (snr * d(r - p + 1, r - p + 1));

        if P_temp < 0 %discard negative values
            P_temp = 0;
        end

        P_opt(p) = P_temp;

    end

end
