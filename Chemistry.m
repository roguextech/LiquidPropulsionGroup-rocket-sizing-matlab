classdef Chemistry < handle
    %CHEMISTRY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1;
        aeat;
        rho;
        h;
        s;
        gam;
        g;
        u;
        m;
        mw;
        p;
        son;
        cp;
        t;
        ae;
        cf;
        ivac;
        mach;
        pip;
        isp;
        isp_s;
    end
    
    methods
        function obj = Chemistry()
        end        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

