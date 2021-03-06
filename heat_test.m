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

% rockets = Rocket.empty(0,height(table));
% for i = 1:height(table)
%    rockets(i) = Rocket(chemistry(i),in_mdot, in_lstar, 30, 0.3);
% end

rockets = Rocket(chemistry(i), in_mdot, in_lstar, 30, 0.3);

rockets.generateContour(40/1000, 40.14/1000, 30, 0.1);

a = bartz(rockets(1).d_thr, 5.8406e5, 1777.5, rockets(1).d_thr,...
    5.5537e3, 0.97690e-4, 3126.56, 600+273);

b = bartz(0.033296, 5.8406*100000, 1777.5, 0.033296, 5.5537e3, 97.69e-6, 3126.56, 600+273);

%params = struct([]);
params.throatDiameter = 0.03328618976;
params.channelGap = 1/1000;
params.mdot = 0.15625;
params.density = 767.04;
params.conduct = 0.10635;
params.visc = 863.6e-6;
params.cp = 2010;

%output = sim('heat_transfer_model.slx', params);

app_struct.mdot = 0.15626; %keep in mind that this is fuel only
app_struct.total_mdot = 0;
app_struct.low_k = 100;
app_struct.high_k = 1000;
app_struct.low_t_wall = 0.0005;
app_struct.high_t_wall = 0.005;

app_struct.h_g = 35.025e3; % W / (m * K)
%app_struct.h_g = a;
app_struct.T_aw = 3126.56; % K
app_struct.T_wg = 0;
app_struct.T_wc = 0;
app_struct.T_co = 310; % K
app_struct.q = 0;
app_struct.h_c = 0; % coolant coefficient (driven)

%this is for the whole mdot
app_struct.throat_mdot_factor = 0.001740396; %m^2*s/kg
app_struct.area_thr = 0;
app_struct.d_thr = 0;

app_struct.area_thr = app_struct.throat_mdot_factor*app_struct.total_mdot;
app_struct.d_thr = sqrt(app_struct.area_thr/pi)*2;
app_struct.Thr_d_mmLabel.Text = num2str(app_struct.d_thr*1000);

%             app_struct.low_k = app_struct.LowkEditField.Value;
%             app_struct.high_k = app_struct.HighkEditField.Value;
%             app_struct.low_t_wall = app_struct.Lowt_wallEditField.Value;
%             app_struct.high_t_wall = app_struct.Hight_wallEditField.Value;

app_struct.q = app_struct.h_g*(app_struct.T_aw-app_struct.T_wg);
app_struct.qLabel.Text = num2str(app_struct.q);

H = app_struct.q/(app_struct.T_aw - app_struct.T_co);

step_t = (app_struct.high_t_wall - app_struct.low_t_wall)/100;
step_k = (app_struct.high_k - app_struct.low_k)/100;

%[Thick, Conduct] = meshgrid(linspace(app_struct.low_t_wall,app_struct.high_t_wall,100),...
%    linspace(app_struct.low_k,app_struct.high_k, 100));

% Thick = [app.low_t_wall:step_t:app.high_t_wall];
% Conduct = [app.low_k:step_k:app.high_k];

Thick = linspace(app_struct.low_t_wall,app_struct.high_t_wall);
Conduct = linspace(app_struct.low_k,app_struct.high_k);

Thick_col = Thick.^-1;
Thick_col = Thick_col';

app_struct.h_c = -1.*((1/H)-(1/app_struct.h_g)-(1./(Thick_col*Conduct))).^(-1);

%[X,Y] = meshgrid(-8:.5:8);
%R = sqrt(X.^2 + Y.^2) + eps;
%Z = sin(R)./R;

mesh(Thick,Conduct,app_struct.h_c);
xlabel('Wall Thickness (m)')
ylabel('Wall Conductivity (W/(m*K))')
zlabel('Coolant Convection Coefficient (h_c)')