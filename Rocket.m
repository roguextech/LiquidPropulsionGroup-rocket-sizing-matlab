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
            
            r_throat = sqrt(obj.a_thr/pi())/2;
            r_chamber = obj.chamber_diameter/2;
            
            tri_side = obj.chamber_diameter/2 - sqrt(r_throat);
            cone_length = tri_side*cotd(obj.chamber_angle);
            obj.converging_length = cone_length()*1/3*pi()*(r_chamber^2 + r_chamber*r_throat + r_throat^2);
            
            %obj.chamber_length = (obj.chamber_volume - obj.converging_length) / (pi()*(r_chamber)^2);
            obj.chamber_length = obj.chamber_volume/(pi*r_chamber^2)
            
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
        
%         function generateContour(obj, injector_r, nozzle_l, nozzle_angle, step)
%             
%             %use obj.contour;
%             obj.chamber_length = obj.chamber_volume/(pi*(injector_r^2));
%             
%             % Chamber section of the engine
%             x1 = [1:step:(obj.chamber_length-0.06776)];
%             section1 = ones(length(x1));
%             section1 = (obj.chamber_diameter/2).*section1;
%             
%             % first inward curving circle
%             x2 = [(obj.chamber_length-0.06776):step:(obj.chamber_length-0.02819)];
%             section2 = ((obj.chamber_diameter/2) - 0.05) + sqrt(0.05^2 - (x2-(obj.chamber_length-0.06776)).^2);
% 
%             % first straight inward curving line
%             x3 = [(obj.chamber_length-0.02819):step:(obj.chamber_length-0.015)];
%             section3 = (pi/6)*((obj.chamber_length-0.02819)-x3)+0.0333;
% 
%         end
        function ret = generateContour(obj, injector_r, nozzle_l)
            %convergance_angle, nozzle_l, step
            %use obj.contour;
            %obj.chamber_length = obj.chamber_volume/(pi*(injector_r^2)^2);
            
            %vairables
            origin_thr = [0; obj.d_thr/2];

            %left side (do left to right then invert x)
            d = [0.03*sin(pi/6); origin_thr(2)+0.03-0.03*cos(pi/6)];
            
            c_y = injector_r-0.05+0.05*cos(pi/6);
            c = [(c_y-d(2))/tan(pi/6)+d(1); c_y];

            b = [c(1)+0.05*sin(pi/6);injector_r];

            inj = [obj.chamber_length; injector_r];

            obj.contour = [inj b c d origin_thr];
            obj.contour = obj.contour.*[-1;1];

            n = [0.025*sind(13.57205188); origin_thr(2)+0.025-0.025*cosd(13.57205188)];
            e = [nozzle_l; obj.d_noz/2];

            obj.contour = [obj.contour n e];
            %points = obj.contour;

            %range = inj(1)-e(1);
            ret = lambdaCurve(obj.contour, 1e-6, 0.05, 0.03, 0.025);

        end
    end
end

