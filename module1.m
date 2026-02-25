function [P1, T1, Cp1, Tt1, Pt1, a1, V1] = module1(R, M1, z, z_star)
% MODULE1  Computes thermodynamic and flow properties at the diffuser inlet (State 1)
%
%   This module uses an isentropic atmosphere model to determine static and
%   total temperature, static and total pressure, speed of sound, and flow
%   velocity at the freestream / diffuser inlet station.
%
%   Two altitude regimes are used:
%     z < 7958 m  : isentropic model (temperature decreases with altitude)
%     z >= 7958 m : isothermal / stratospheric model (T = 210 K constant)
%
%   INPUTS:
%     R      - Gas constant [J/(kg·K)]
%     M1     - Freestream Mach number [-]
%     z      - Flight altitude [m]
%     z_star - Reference altitude for isentropic model [m] (= 8404 m)
%
%   OUTPUTS:
%     P1   - Static pressure at state 1 [kPa]
%     T1   - Static temperature at state 1 [K]
%     Cp1  - Specific heat at constant pressure [J/(kg·K)]
%     Tt1  - Total (stagnation) temperature at state 1 [K]
%     Pt1  - Total (stagnation) pressure at state 1 [kPa]
%     a1   - Speed of sound at state 1 [m/s]
%     V1   - Flow velocity at state 1 [m/s]

    gamma = 1.4;
    Cp1 = (gamma * R) / (gamma - 1);

    if z < 7958
        % --- Tropospheric / lower atmosphere isentropic model ---
        Ts = 288;    % Sea-level standard temperature [K]
        Ps = 101.3;  % Sea-level standard pressure [kPa]

        part1 = 1 - ((gamma - 1) / gamma) * (z / z_star);
        T1    = Ts * part1;
        P1    = Ps * part1^(gamma / (gamma - 1));
    else
        % --- Stratospheric model (isothermal above ~8 km) ---
        T1 = 210;                                       % [K]
        P1 = 33.6 * exp(-1 * ((z - 7958) / 6605));     % [kPa]
    end

    % Total (stagnation) conditions from isentropic relations
    part2 = 1 + ((gamma - 1) / 2) * M1.^2;
    Tt1   = T1 * part2;
    Pt1   = P1 * part2.^(gamma / (gamma - 1));

    % Speed of sound and flow velocity
    a1 = sqrt(gamma * R * T1);
    V1 = a1 .* M1;

end
