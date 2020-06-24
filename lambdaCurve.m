function ret = lambdaCurve(points, resolution, r1, r2, r3)
%LAMBDACURVE calculates a numerical function that describes a rocket engine contour when
%provided with a 7 point description
%   function [ret] = lambdaCurve(points, resolution, r1, r2, r3)
%   points is a 2x7 matrix that contains precalculated points x-y points inj, b, c, d, o_thr, n, and e
%   resolution is step size in meters
%   pass default r123 as 50 30 25 mm (to m)

% points(x,y) 1inj, 2b, 3c, 4d, 5o_thr, 6n, and 7e
points=points';
operators = {
    @(x) x-x+points(1,2),
    @(x) sqrt(r1^2 - (x - points(2,1)).^2)+(points(1,2)-r1),
    @(x) (points(3,2)-points(4,2))/(points(3,1)-points(4,1)) * (x - points(3,1)) + points(3,2),
    @(x) sqrt(r2^2 + (x + points(5,1)).^2)-r2+points(5,2),
    @(x) -sqrt(r3^2 - (x - points(5,1)).^2)+(points(5,2)+r3),
    @(x) (points(6,2)-points(7,2))/(points(6,1)-points(7,1)) * (x - points(6,1)) + points(6,2)
};

%tot_range = points(7,1) - points (1,1);
x_set = {};
y_set = {};

for i = 1:6
    
    x_set{i} = linspace( points(i,1), points(i+1,1));%(points(i+1,1)-points(i,1))/resolution )
    y_set{i} = operators{i}(x_set{i});    

end

x_array = x_set{1};
y_array = y_set{1};

for i = 2:6

    x_array = horzcat(x_array,x_set{i});
    y_array = horzcat(y_array,y_set{i});

end

ret = vertcat(x_array,y_array);
%ret = {x_set; y_set};

end

