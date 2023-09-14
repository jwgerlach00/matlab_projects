function [apf, rho] = APFDens(sphVol, recVol, atmNum, atmWeight)

    % Calculates the atomic packing factor (APF) and density
    %
    % Inputs:    sphVol -- volume of an atom (m^3)
    %            recVol -- volume of one unit cell (m^3)
    %            atmNum -- number of atoms in one unit cell
    %            atmWeight -- atomic weight of one atom in the unit cell
    %            (g/mol
    % Outputs:   apf -- atomic packing factor
    %            density -- density of atoms within a unit cell (kg/m^3)
    
    na = 6.022e23; % Avogadro's number
    
    apf = (atmNum*sphVol)/recVol;
    rho = (atmNum*atmWeight)/(1000*(recVol*na));
end
