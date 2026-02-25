% =========================================================================
% PART B: Isentropic Atmosphere vs. ICAO Standard Atmosphere
%
% Compares the temperature and pressure profiles from:
%   1. ICAO International Standard Atmosphere (read from Excel)
%   2. Isentropic atmosphere model used in this project
%
% Why this matters:
%   The isentropic model is simpler but we need to know how accurate it is.
%   Result: Pressures match very well. Temperature diverges slightly above
%   ~8 km because the real atmosphere becomes isothermal (stratosphere)
%   while the isentropic model underestimates temperature there.
% =========================================================================

clear; close all; clc;

R = 286.9;  z_star = 8404;  M1 = 2.4;
z = [0:500:20000, 22000];

for i = 1:length(z)
    [P1(i), T1(i), ~, ~, ~, ~, ~] = module1(R, M1, z(i), z_star);
end

% NOTE: Requires 'Validation of Atmospheric Model.xlsx' in working directory
% If unavailable, comment out the ICAO lines and plot only the isentropic model
try
    data = readtable('Validation of Atmospheric Model.xlsx', 'Range', 'G14:H55');
    T_z  = table2array(data(:,1));
    P_z  = table2array(data(:,2));
    has_icao = true;
catch
    warning('ICAO Excel file not found. Plotting isentropic model only.');
    has_icao = false;
end

figure(1);
if has_icao
    plot(T_z, z, 'b-', 'LineWidth', 2); hold on;
end
plot(T1, z, 'r-', 'LineWidth', 2);
title('Isentropic vs. Standard Atmosphere: Temperature', 'FontSize', 13);
xlabel('Temperature at Altitude T(z) [K]', 'FontSize', 11);
ylabel('Flight Altitude z [m]',            'FontSize', 11);
if has_icao
    legend('Standard Atmosphere (ICAO)', 'Isentropic Model', 'Location', 'Best');
else
    legend('Isentropic Model', 'Location', 'Best');
end
grid on; grid minor;

figure(2);
if has_icao
    plot(P_z, z, 'b-', 'LineWidth', 2); hold on;
end
plot(P1, z, 'r-', 'LineWidth', 2);
title('Isentropic vs. Standard Atmosphere: Pressure', 'FontSize', 13);
xlabel('Pressure at Altitude P(z) [kPa]', 'FontSize', 11);
ylabel('Flight Altitude z [m]',           'FontSize', 11);
if has_icao
    legend('Standard Atmosphere (ICAO)', 'Isentropic Model', 'Location', 'Best');
else
    legend('Isentropic Model', 'Location', 'Best');
end
grid on; grid minor;
