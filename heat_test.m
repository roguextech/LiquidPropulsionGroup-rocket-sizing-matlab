clear;

table = readtable('heat_engine_params.xlsx');

chemistry = Chemistry.empty(0,height(table));

for i = 1:height(table)
   chemistry(i) = Chemistry(); 
end

for i = 1:height(table)
    chemistry(i).aeat = table{i,2};
    chemistry(i).t = table{i,2};
    chemistry(i).cp = table{i,3};
    chemistry(i).ae = table{i,4};
    chemistry(i).isp = table{i,5};
    chemistry(i).p = table{i,6};
    chemistry(i).m = table{i,7};
    chemistry(i).gam = table{i,8};
end

in_mdot = 0.5; % input('mdot (kg/s): ');
in_lstar = 1.1; % input('Input L* (m): ');

rockets = Rocket.empty(0,height(table));
for i = 1:height(table)
   rockets(i) = Rocket(chemistry(i),in_mdot, in_lstar, 30, 0.3);
end

rockets.generateContour(40/1000, 40.14/1000, 30);

a = bartz(rockets(1).d_thr, rockets(1).chem.p*101300, 1763, rockets(1).d_thr,...
    5.5537e3, 0.97690e-4, 3126.56, 600+237);

b = bartz(0.033296, 1.013e6, 1763, 0.033296, 5.5537e3, 97.69e-6, 3126.56, 600+237);