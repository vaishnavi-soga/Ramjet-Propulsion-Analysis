% =========================================================================
% PART E: Optimal Flight Mach Number vs Altitude
%
% For each altitude from 2,000 m to 20,000 m, sweeps M1 from 0.8 to 5.0
% and finds:
%   (i)  The M1 that MAXIMISES overall efficiency (eta_o)
%   (ii) The M1 that MINIMISES TSFC (best fuel economy)
%
% Interpretation:
%   - Optimal M1 for peak efficiency rises to ~3.35 and plateaus above 4000 m
%   - Optimal M1 for minimum TSFC drops sharply from ~5 at low altitude to
%     ~2 at high altitude (less dense air changes the trade-off)
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;  M2 = 0.15;
Tt3_max = 2400;  Ae = 0.015;  eta_d = 0.92;  eta_n = 0.94;  qf = 43.2e6;

M1 = 0.8:0.001:5;
z  = 2e3:500:2e4;

eta_o = zeros(length(z), length(M1));
TSFC  = zeros(length(z), length(M1));

fprintf('Running Part E optimization sweep... (this may take a moment)\n');

for i = 1:length(z)
    for j = 1:length(M1)
        [P1,T1,Cp1,Tt1,Pt1,a1,V1]                              = module1(R,M1(j),z(i),z_star);
        [P2,T2,Tt2,Cp2,Pt2,a2,V2,deltaS12]                     = module2(R,M2,M1(j),eta_d,Tt1,P1,Pt1);
        [P3,Pt3,T3,Tt3,Cp3,a3,V3,M3,q23,deltaS23,deltaS13]     = module3(Tt3_max,Tt2,P2,Pt2,M2,R,deltaS12);
        [Pe,Pte,Te,Tte,Cpe,Me,Ve,ae,deltaS3e,deltaS1e,mdot_exit,M_Test] = module4(Ae,eta_n,P1,Tt3,Pt3,R,deltaS12,deltaS23);
        [P4,Pt4,T4,Tt4,Cp4,a4,V4,M4,etan_e,deltaS4e,deltaS41]  = module5(R,M_Test,Tte,P1,Pte,deltaS1e);
        [~,~,~,TSFC(i,j),~,~,~,~,~,~,~,eta_o(i,j),~] = ...
            module6(q23,qf,mdot_exit,Ve,V1,Pe,P1,Ae);
    end
end

% Find optimal M1 at each altitude
eta_o_optM1 = zeros(1, length(z));
TSFC_optM1  = zeros(1, length(z));
for i = 1:length(z)
    [~, I] = max(eta_o(i,:));
    eta_o_optM1(i) = M1(I);
    [~, J] = min(TSFC(i,:));
    TSFC_optM1(i) = M1(J);
end

figure(1);
plot(z, eta_o_optM1, 'LineWidth', 2, 'Color', 'magenta');
ylim([3 3.5]);
title('Altitude Variation for Maximizing \eta_o vs M_1', 'FontSize', 12);
xlabel('Flight Altitude z [m]',       'FontSize', 11);
ylabel('Optimal Flight Mach Number M_1', 'FontSize', 11);
grid on;

figure(2);
plot(z, TSFC_optM1, 'LineWidth', 2, 'Color', 'k');
ylim([1.5 5]);
title('Altitude Variation for Minimizing TSFC vs M_1', 'FontSize', 12);
xlabel('Flight Altitude z [m]',       'FontSize', 11);
ylabel('Optimal Flight Mach Number M_1', 'FontSize', 11);
grid on;
