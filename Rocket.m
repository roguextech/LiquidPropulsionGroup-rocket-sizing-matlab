    classdef Rocket < handle
    %ROCKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mdot;
        Lstar;
        chem;
        isp_s;
        rbar;
        a_thr;
        a_noz;
        d_thr;
        d_noz;
        thrust;
        chamber_volume;
        chamber_angle;
        chamber_diameter;
        chamber_length;
        converging_length;
        contour;
        
    end
    
    methods
        function obj = Rocket(chem, mdot, Lstar, angle, diameter)
            %ROCKET Construct an instance of this class
            %   Detailed explanation goes here
            obj.mdot = mdot;
            obj.chem = chem;
            obj.Lstar = Lstar;
            obj.chamber_angle = angle;
            obj.chamber_diameter = diameter;
            
            obj.isp_s = chem.isp/9.8;
            obj.rbar = 8.31446261815324 / chem.m * 1000; % Rbar in kJ
            obj.a_thr = (obj.mdot / (chem.p * 101325)) * sqrt(chem.t * obj.rbar / chem.gam) * power((1 + ((chem.gam - 1) / 2)), ((chem.gam + 1) / (2 * (chem.gam - 1))));  % Throat Size Equation
            
            % p is in atm; area in m^2
            
            obj.a_noz = obj.a_thr * chem.ae;
            obj.d_thr = 2 * sqrt(obj.a_thr/pi());
            obj.d_noz = 2 * sqrt(obj.a_noz/pi());
            
            obj.thrust = obj.mdot * chem.isp;
            
            obj.chamber_volume = obj.Lstar * obj.a_thr;
            
            r_throat = sqrt(obj.a_thr/pi());
            r_chamber = obj.chamber_diameter/2;
            
            tri_side = obj.chamber_diameter/2 - sqrt(r_throat);
            cone_length = tri_side*cotd(obj.chamber_angle);
            obj.converging_length = cone_length()*1/3*pi()*(r_chamber^2 + r_chamber*r_throat + r_throat^2);
            
            obj.chamber_length = (obj.chamber_volume - obj.converging_length) / (pi()*(r_chamber)^2);
            
        end
        
        function update(obj, mdot_new, Lstar_new, angle, diameter)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            obj.mdot = mdot_new;
            obj.Lstar = Lstar_new;
            obj.chamber_angle = angle;
            obj.chamber_diameter = diameter;
            
            obj.a_thr = (obj.mdot / (obj.chem.p * 101325)) * sqrt(obj.chem.t * obj.rbar / obj.chem.gam) * power((1 + ((obj.chem.gam - 1) / 2)), ((obj.chem.gam + 1) / (2 * (obj.chem.gam - 1))));
            
            obj.a_noz = obj.a_thr * obj.chem.ae;
            obj.d_thr = 2 * sqrt(obj.a_thr/pi());
            obj.d_noz = 2 * sqrt(obj.a_noz/pi());
            
            obj.thrust = obj.mdot * obj.chem.isp;
            
            obj.chamber_volume = obj.Lstar * obj.a_thr;
            
            r_throat = sqrt(obj.a_thr/pi());
            r_chamber = obj.chamber_diameter/2;
            
            tri_side = r_chamber - r_throat;
            obj.converging_length = tri_side*cotd(obj.chamber_angle);
            cone_volume = obj.converging_length()*1/3*pi()*(r_chamber^2 + r_chamber*r_throat + r_throat^2);
            
            obj.chamber_length = (obj.chamber_volume - cone_volume) / (pi()*(r_chamber)^2);
            
            
        end
        
        function generateContour(obj, injector_r, nozzle_l, nozzle_angle)
            
            obj.chamber_length = obj.chamber_volume/(pi*(injector_r^2));
            
        end
    end
end

