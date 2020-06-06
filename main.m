% Makar Loktyukhin 
%
% Rocket Sizing for the Liquid Propulsion Group @ Sacramento State
clear;

table = readtable('test.xlsx');

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

%single mdot
in_mdot = 1; % input('mdot (kg/s): ');
in_lstar = 0.11; % input('Input L* (m): ');

rockets = Rocket.empty(0,height(table));
for i = 1:height(table)
   rockets(i) = Rocket(chemistry(i),in_mdot, in_lstar, 30, 0.3);
end

rockets(3).update(1.1, 0.22, 15, 0.15);

ch_rad = rockets(3).chamber_diameter/2;
ch_leng = rockets(3).chamber_length;
con_len = rockets(3).converging_length;
thr_rad = rockets(3).d_thr/2;
noz_rad = rockets(3).d_noz/2;

trace_y = [0 ch_rad ch_rad  thr_rad];
trace_x = [0 0      ch_leng ch_leng+con_len];

trace_y_bot = -1.*trace_y;
trace_y = fliplr(trace_y);

trace_x_bot = trace_x;
trace_x = fliplr(trace_x);

trace_x = horzcat(trace_x, trace_x_bot);
trace_y = horzcat(trace_y, trace_y_bot);

% trace = [trace_x; trace_y];

fprintf('test');

figure
plot(trace_x, trace_y);