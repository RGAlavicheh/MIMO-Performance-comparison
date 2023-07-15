% In this simulation, our objective is to assess the capacity of...
% a Multiple-Input Multiple-Output (MIMO) system across three distinct modes:
% Equal Power, Single-Mode, and EigenBeamforming. The EigenBeamforming mode 
% incorporates the utilization of the Waterfilling algorithm. Furthermore, 
% we compare the performance of the MIMO system with that of a Single-Input 
% Single-Output (SISO) system. The simulation allows us to analyze and compare
% the capacity characteristics of these different system configurations.
% Author: Reza Ghasemi Alavicheh[r.ghasemi.reza@gmail.com]

%%%%%%%%%%%%%%%%%%%%%%%%%%  PART_1    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% clean
clc; clear
%% constant
N_t = 3;
N_r = 5;
H_1 = randn(N_r, N_t) + 1i * randn(N_r, N_t);
H_1 = normalize(H_1); % put center 0 and standard deviation 1
H_1 = (sqrt(1/N_t)).*H_1;
[u, d, v] = svd(H_1);
r = rank(H_1);
snr = [-20:0.01:20];

%% Single Mode
C_SingleMode = log2(1 + (10.^(snr / 10)) .* d(1, 1));

%% SISO
C_SISO = log2(1 + (10.^(snr / 10)));

%% EqualPower
C_EqualPower = 0;

for j = 1:1:r
    C_temp = log2(1 + (10.^(snr / 10) * d(j, j) * 1 / N_t));
    C_EqualPower = C_temp + C_EqualPower;
end

%% EigenBeamforming

c_EBF = zeros(length(snr), 1);

for jj = 1:1:length(snr)
    P_opt = waterfilling(10^(snr(jj) / 10), d, r);
    P_opt = flip(P_opt);

    c = 0;

    for i = 1:1:r

        c_temp = log2(1 + (10^(snr(jj) / 10)) * P_opt(i) * d(i, i));
        c = c + c_temp;

    end

    c_EBF(jj) = c;

end

%% plot
figure
plot(snr, C_SingleMode, "-.", LineWidth = 1.6);
hold on;
plot(snr, C_SISO, ":", LineWidth = 1.6);
plot(snr, C_EqualPower, "--", LineWidth = 1.8);
plot(snr, c_EBF, LineWidth = 1, Color = 'k');
legend('Single Mode', 'SISO', 'EqualPower', "EigenBeamforming");
title('Based in H_1');
xlim([-20 20]);
ylim([0 20])
xlabel('SNR(dB)');
ylabel('Bits per channel use');
grid on;
hold off;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%  PART_2    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% constant

H_2 = transpose(H_1);
[u, d_2, v] = svd(H_2);
uu = N_t;
N_t = N_r;
N_r = uu;
r = rank(H_2);
snr = [-20:0.1:20];
%% Single Mode
C_SingleMode = log2(1 + (10.^(snr / 10)) .* d_2(1, 1));

%% SISO
C_SISO = log2(1 + (10.^(snr / 10)));

%% EqualPower
C_EqualPower = 0;

for j = 1:1:r
    C_temp = log2(1 + (10.^(snr / 10) * d_2(j, j) * 1 / N_t));
    C_EqualPower = C_temp + C_EqualPower;
end

%% EigenBeamforming

c_EBF = zeros(length(snr), 1);

for jj = 1:1:length(snr)
    P_opt = waterfilling(10^(snr(jj) / 10), d_2, r);
    P_opt = flip(P_opt);
    c = 0;

    for i = 1:1:r

        c_temp = log2(1 + (10^(snr(jj) / 10)) * P_opt(i) * d_2(i, i));
        c = c + c_temp;

    end

    c_EBF(jj) = c;

end

%% plot
figure
plot(snr, C_SingleMode, "-.", LineWidth = 1.6);
hold on;
plot(snr, C_SISO, ":", LineWidth = 1.6);
plot(snr, C_EqualPower, "--", LineWidth = 1.8);
plot(snr, c_EBF, LineWidth = 1, Color = 'k');
legend('Single Mode', 'SISO', 'EqualPower', "EigenBeamforming");
title('Based in H_2');
xlim([-20 20]);
ylim([0 20])
xlabel('SNR(dB)');
ylabel('Bits per channel use');
grid on;

% %% annotation on plot
% dim = [.7 .5 .15 .10];
% annotation('ellipse', dim, LineWidth = 1.3, Color = "b");
% x = [0.6 0.7];
% y = [0.55 0.55];
% annotation('textarrow', x, y, "string", " 2dB gap ", Color = "b");
