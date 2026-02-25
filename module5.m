function [P4, Pt4, T4, Tt4, Cp4, a4, V4, M4, etan_e, deltaS4e, deltaS41] = ...
    module5(R, M_Test, Tte, P1, Pte, deltaS1e)
% MODULE5  Computes thermodynamic properties at the far-field exhaust plane (State 4)
%
%   After the gas exits the nozzle, it continues expanding to match the
%   ambient pressure P1 in the far field. State 4 represents the final
%   exhaust state used for T-s diagram closure and entropy accounting.
%
%   The nozzle efficiency at this point (etan_e) is modelled as a function
%   of the test Mach number:
%     - If M_Test < 1  --> Subsonic nozzle, etan_e = 1 (ideal)
%     - If M_Test >= 1 --> Supersonic case, etan_e = M_Test^(-0.3) (empirical)
%
%   INPUTS:
%     R        - Gas constant [J/(kg·K)]
%     M_Test   - Test Mach number from Module 4 (checks if nozzle was choked) [-]
%     Tte      - Total temperature at nozzle exit [K]
%     P1       - Ambient static pressure [kPa]
%     Pte      - Total pressure at nozzle exit [kPa]
%     deltaS1e - Cumulative entropy rise from state 1 to nozzle exit [J/(kg·K)]
%
%   OUTPUTS:
%     P4       - Static pressure at state 4 [kPa]  (= P1 by definition)
%     Pt4      - Total pressure at state 4 [kPa]
%     T4       - Static temperature at state 4 [K]
%     Tt4      - Total temperature at state 4 [K]
%     Cp4      - Specific heat at state 4 temperature [J/(kg·K)]
%     a4       - Speed of sound at state 4 [m/s]
%     V4       - Flow velocity at state 4 [m/s]
%     M4       - Mach number at state 4 [-]
%     etan_e   - Effective nozzle efficiency at this condition [-]
%     deltaS4e - Entropy change from nozzle exit to state 4 [J/(kg·K)]
%     deltaS41 - Total entropy change from state 4 back to state 1 [J/(kg·K)]

    gamma = 1.3;

    % Far-field pressure equals ambient
    P4  = P1;

    % Total temperature conserved (adiabatic, 1st Law)
    Tt4 = Tte;

    % Effective nozzle efficiency
    if M_Test < 1
        etan_e = 1;
    else
        etan_e = M_Test^(-0.3);
    end

    % Static temperature at state 4
    T4 = Tte * (1 - etan_e * (1 - (P1 / Pte)^((gamma - 1) / gamma)));

    % Mach number and total pressure
    M4  = sqrt((2 / (gamma - 1)) * ((Tt4 / T4) - 1));
    Pt4 = P4 * (1 + ((gamma - 1) / 2) * M4^2)^(gamma / (gamma - 1));

    % Speed of sound and velocity
    a4 = sqrt(gamma * R * T4);
    V4 = a4 * M4;

    % Variable Cp and entropy
    Cp4      = 986 + 0.179 * T4;
    deltaS4e = Cp4 * log(Tt4 / Tte) - R * log(Pt4 / Pte);
    deltaS41 = deltaS1e + deltaS4e;

end
