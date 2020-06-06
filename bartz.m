function h_gas = bartz(d_throat, p_chamber, Cstar, d, c_p, visc, t_gas, t_wall)
%BARTZ Calculate gas side convection coefficient using Bartz's approximation
%   Params: bartz(d_throat, p_chamber, Cstar, d, c_p, visc, t_gas, t_wall)
%   Can accept single points or arrays.
%   d_throat is single
%   p_chamber is single
%   Cstar is single
%   t_wall is single

    t_boundary = (t_gas + t_wall)./2;
    
    h_gas = 0.026/d_throat^(0.2)*(p_chamber/Cstar)^(0.8)*(d_throat./d).^(1.8)*c_p*visc^(0.2)*(t_gas/t_boundary)^(0.8-0.2*0.6);

end

