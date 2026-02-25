function [P3, Pt3, T3, Tt3, Cp3, a3, V3, M3, q23, deltaS23, deltaS13] = ...
    module3(Tt3_max, Tt2, P2, Pt2, M2, R, deltaS12)
% MODULE3  Computes thermodynamic and flow properties at the combustor exit (State 3)
%
%   The combustor adds heat at constant pressure, raising the total temperature
%   from Tt2 to Tt3. This module checks whether the combustor is thermally choked.
%
%   THERMAL CHOKING:
%     If too much heat is added to a subsonic combustor, the Mach number can
%     reach M=1 at the exit — this is called thermal choking (like a sonic throat).
%     Once choked, no more heat can be added without changing the inlet conditions.
%     The choked total temperature Tt3_choked is the maximum heat addition limit.
%
%     - If Tt3_choked < Tt3_max  --> Combustor IS thermally choked (M3 = 1)
%     - If Tt3_choked >= Tt3_max --> Combustor is NOT choked (use Tt3_max)
%
%   Variable specific heat model (caloric imperfect gas):
%     Cp(T) = A + B*T   where A = 986 J/(kg·K), B = 0.179 J/(kg·K²)
%     Heat added: q23 = A*(Tt3-Tt2) + 0.5*B*(Tt3²-Tt2²)
%
%   INPUTS:
%     Tt3_max  - Maximum allowable total temperature at combustor exit [K]
%     Tt2      - Total temperature entering combustor (= Tt1) [K]
%     P2       - Static pressure at combustor inlet [kPa]
%     Pt2      - Total pressure at combustor inlet [kPa]
%     M2       - Mach number at combustor inlet [-]
%     R        - Gas constant [J/(kg·K)]
%     deltaS12 - Cumulative entropy rise through diffuser [J/(kg·K)]
%
%   OUTPUTS:
%     P3       - Static pressure at combustor exit [kPa]
%     Pt3      - Total pressure at combustor exit [kPa]
%     T3       - Static temperature at combustor exit [K]
%     Tt3      - Total temperature at combustor exit [K]
%     Cp3      - Specific heat at Cp at combustor exit temperature [J/(kg·K)]
%     a3       - Speed of sound at combustor exit [m/s]
%     V3       - Flow velocity at combustor exit [m/s]
%     M3       - Mach number at combustor exit [-]
%     q23      - Heat added per unit mass in combustor [J/kg]
%     deltaS23 - Entropy rise through combustor [J/(kg·K)]
%     deltaS13 - Cumulative entropy rise from state 1 to state 3 [J/(kg·K)]

    gamma = 1.3;   % Higher gamma in combustor region (hot gas)

    % --- Check for thermal choking ---
    % Rayleigh flow choked total temperature:
    Tt3_choked = Tt2 * ((1 / (2*gamma + 2)) * (1 / (M2.^2)) * ...
                 ((1 + gamma * M2.^2)^2) * ...
                 (1 + ((gamma - 1) / 2) * M2^2)^(-1));

    if Tt3_choked < Tt3_max
        % THERMALLY CHOKED: combustor reaches M=1 before Tt3_max
        M3  = 1;
        Tt3 = Tt3_choked;
    else
        % NOT THERMALLY CHOKED: can reach full Tt3_max
        Tt3 = Tt3_max;

        % Solve quadratic for exit Mach number (from Rayleigh flow relations)
        C = (Tt3 / Tt2) * (M2^2) * ...
            ((1 + ((gamma - 1) / 2) * M2^2) / ((1 + gamma * (M2^2))^2));

        a_coef = C * gamma^2 - (gamma - 1) / 2;
        b_coef = 2 * C * gamma - 1;
        c_coef = C;

        M3_1 = sqrt((-b_coef + sqrt(b_coef.^2 - 4*a_coef*c_coef)) / (2*a_coef));
        M3_2 = sqrt((-b_coef - sqrt(b_coef.^2 - 4*a_coef*c_coef)) / (2*a_coef));

        % Select physically correct root (subsonic inlet -> subsonic or sonic exit)
        if M2 < 1 && M3_1 > M2 && M3_1 <= 1
            M3 = M3_1;
        else
            M3 = M3_2;
        end
    end

    % --- Heat added using variable Cp model ---
    A   = 986;
    B   = 0.179;
    q23 = A * (Tt3 - Tt2) + 0.5 * B * (Tt3^2 - Tt2^2);

    % --- Constant pressure combustion ---
    P3  = P2;

    % --- Static conditions from total-to-static relations ---
    T3  = Tt3 / (1 + ((gamma - 1) / 2) * M3^2);
    Pt3 = P3 * (1 + ((gamma - 1) / 2) * M3^2)^(gamma / (gamma - 1));

    % --- Velocity ---
    a3 = sqrt(gamma * R * T3);
    V3 = M3 * a3;

    % --- Entropy ---
    Cp3      = A + B * T3;
    deltaS23 = Cp3 * log(Tt3 / Tt2) - R * log(Pt3 / Pt2);
    deltaS13 = deltaS12 + deltaS23;

end
