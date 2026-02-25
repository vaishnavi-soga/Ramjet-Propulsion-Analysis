function [P2, T2, Tt2, Cp2, Pt2, a2, V2, deltaS12] = module2(R, M2, M1, eta_d, Tt1, P1, Pt1)
% MODULE2  Computes thermodynamic and flow properties at the diffuser exit (State 2)
%
%   The diffuser decelerates the freestream flow from M1 down to M2.
%   A non-ideal (real) diffuser is modelled using an isentropic efficiency
%   eta_d, which accounts for irreversibilities (entropy generation) due
%   to shock waves and viscous losses inside the inlet.
%
%   Key assumptions:
%     - Adiabatic diffuser  --> Tt2 = Tt1  (total temperature conserved)
%     - Non-ideal process   --> Pt2 < Pt1  (total pressure loss)
%
%   INPUTS:
%     R      - Gas constant [J/(kg·K)]
%     M2     - Mach number at diffuser exit [-]
%     M1     - Freestream Mach number [-]
%     eta_d  - Isentropic efficiency of the diffuser [-]  (0 to 1)
%     Tt1    - Total temperature at state 1 [K]
%     P1     - Static pressure at state 1 [kPa]
%     Pt1    - Total pressure at state 1 [kPa]
%
%   OUTPUTS:
%     P2       - Static pressure at state 2 [kPa]
%     T2       - Static temperature at state 2 [K]
%     Tt2      - Total temperature at state 2 [K]
%     Cp2      - Specific heat at constant pressure [J/(kg·K)]
%     Pt2      - Total pressure at state 2 [kPa]
%     a2       - Speed of sound at state 2 [m/s]
%     V2       - Flow velocity at state 2 [m/s]
%     deltaS12 - Entropy rise from state 1 to state 2 [J/(kg·K)]

    gamma = 1.4;
    Cp2 = R * gamma / (gamma - 1);

    % Adiabatic diffuser: total temperature unchanged
    Tt2 = Tt1;

    % Non-ideal total pressure recovery using isentropic efficiency
    Pt2 = P1 * (1 + eta_d * ((gamma - 1) / 2) .* M1.^2).^(gamma / (gamma - 1));

    % Static temperature and pressure from isentropic total-to-static relations
    T2 = Tt2 / (1 + ((gamma - 1) / 2) * M2^2);
    P2 = Pt2 / (1 + ((gamma - 1) / 2) * M2^2)^(gamma / (gamma - 1));

    % Entropy increase (irreversibilities in diffuser)
    deltaS12 = Cp2 * log(Tt2 / Tt1) - R * log(Pt2 / Pt1);

    % Speed of sound and flow velocity at diffuser exit
    a2 = sqrt(gamma * R * T2);
    V2 = M2 * a2;

end
