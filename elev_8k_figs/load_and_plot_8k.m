%% Loads and plots 8k data

%% trying new mesh
x1 = linspace(26.6,23.2,25)';
y1 = linspace(82.55,83.44,25)';
% x2 = (26,6)
% y2 = (81.39,83.14)
latlong = [-y x];

%% Load in fort.61 and fort.14

mesh = readtable("fort14.txt");
mesh = removevars(mesh, ["Var1","Var4","Var5","Var6","Var7","Var8","Var9","Var10"]);
mesh = table2array(mesh);
mesh = mesh(1:8006,:);

%fort61_OWI = read_adcirc_fort61('OWIfort.61',[2022,09,19,12,0,0]);
%fort61_HOL = read_adcirc_fort61('HOLfort.61',[2022,09,19,12,0,0]);

%% Load in fort.63 

hol63 = readtable("HOL_fort63.txt");
hol63 = table2array(hol63);
hol63_long = hol63(2:end,2);

for i = 1:50
    hol63_long(8007*i,:) = [];
end

hol63 = reshape(hol63_long,[8006,51]);

owi63 = readtable("OWI_fort63.txt");
owi63 = table2array(owi63);
owi63_long = owi63(2:end,2);

for i = 1:50
    owi63_long(8007*i,:) = [];
end

owi63 = reshape(owi63_long,[8006,51]);


%% Line graphs

% for i = 1:5
%     figure()
%     hold on
%     semilogy(hol63(5598+i,:), 'LineWidth',2.0,'Color','#C12283') 
%     semilogy(owi63(5598+i,:),'LineWidth',2.0,'Color','#2AB8AB')
%     xlim([32 52])
%     title('Station','Interpreter','latex','FontSize', 18)
%     ylabel('Surge Elevation','Interpreter','latex','FontSize', 15)
%     xlabel('Time Step (s)','Interpreter','latex','FontSize', 15)
%     legend('Holland','OWI','Interpreter','latex','FontSize', 15)
% end

figure()
hold on
semilogy(hol63(1860,:), 'LineWidth',2.0,'Color','#C12283') 
semilogy(owi63(1860,:),'LineWidth',2.0,'Color','#2AB8AB')
ylabel('Surge Elevation','Interpreter','latex','FontSize', 15)
xlabel('Time','Interpreter','latex','FontSize', 15)
legend('Holland','OWI','Interpreter','latex','FontSize', 15)

%% Load in maxele 
% first set of 8006 is what I want - probably in meters

hol_max = readtable("HOL_maxele63.txt");
hol_max = table2array(hol_max);
hol_max = hol_max(2:8007,2);

owi_max = readtable("OWI_maxele63.txt");
owi_max = table2array(owi_max);
owi_max = owi_max(2:8007,2);

maxele_diff = owi_max - hol_max;


%% Line plots of elevation at the stations w fort61

for i = 1:50
    figure()
    hold on
    plot(fort61_OWI.zeta(:,i),'LineWidth',2.0)
    plot(fort61_HOL.zeta(:,i),'LineWidth',2.0)
    legend('owi','hol')
end

%% Maps with maxele

figure()
scatter(mesh(:,1),mesh(:,2),20,hol_max,'filled')
colorbar
colormap turbo
title('Maximum Elevation with Holland Wind Model','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)

figure()
scatter(mesh(:,1),mesh(:,2),20,owi_max,'filled')
colorbar
colormap turbo
title('Maximum Elevation with OWI Wind Model','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)

figure()
scatter(mesh(:,1),mesh(:,2),30,sqrt(maxele_diff.^2),'filled')
colorbar
colormap turbo
title('Maximum Elevation Difference','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)

%% maxele hydrographs

figure()
scatter(owi_max, hol_max,50,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7],'LineWidth',1.5)
title('Maximum Elevation','Interpreter','latex','FontSize', 20)
xlabel('OWI Data','Interpreter','latex','FontSize', 15)
ylabel('Holland Data','Interpreter','latex','FontSize', 15)

figure()
plot(maxele_diff,'x')


%2046 or 2047 it is biggest difference

%% Read in DA analysis 

analy = readtable("IanAnaly0216.txt");
analy = table2array(analy);
analy_long = analy(2:end,2);

for i = 1:50
    analy_long(8007*i,:) = [];
end

analy = reshape(analy_long,[8006,51]);

figure()
subplot(2,1,2)
hold on
plot(hol63(5814,:), 'LineWidth',2.0,'Color','#C12283') 
plot(owi63(5814,:),'LineWidth',2.0,'Color','#2AB8AB')
plot(analy(5814,:),'LineWidth',2.0)
legend('Holland','OWI','Assimilated','Interpreter','latex','FontSize', 15)
ylabel('Elevation (m)','Interpreter','latex','FontSize', 15)
xlabel('Time','Interpreter','latex','FontSize', 15)
xlim([30,55])
subplot(2,1,1)
hold on
plot(hol63(6000,:), 'LineWidth',2.0,'Color','#C12283') 
plot(owi63(6000,:),'LineWidth',2.0,'Color','#2AB8AB')
plot(analy(6000,:),'LineWidth',2.0)
legend('Holland','OWI','Assimilated','Interpreter','latex','FontSize', 15)
ylabel('Elevation (m)','Interpreter','latex','FontSize', 15)
xlabel('Time','Interpreter','latex','FontSize', 15)
xlim([30,55])
% title('Data Assimilation Results','Interpreter','latex','FontSize', 20)

%% pseudo max ele stuff with maps

M = max(analy');
M = M';

da_diff = owi_max - M;

figure()
scatter(mesh(:,1),mesh(:,2),20,hol_max,'filled')
colorbar
colormap jet
clim([0.4 0.6])
title('Maximum Elevation with Holland Wind Model','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)

figure()
scatter(mesh(:,1),mesh(:,2),20,owi_max,'filled')
colorbar
colormap jet
clim([0.4 0.6])
title('Maximum Elevation with OWI Wind Model','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)


figure()
scatter(mesh(:,1),mesh(:,2),30,sqrt(maxele_diff.^2),'filled')
colorbar
colormap jet
title('Maximum Elevation Difference','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)

figure()
scatter(mesh(:,1),mesh(:,2),20,M,'filled')
colorbar
colormap jet
clim([0.4 0.6])
title('Maximum Elevation with Data Assimilation','Interpreter','latex','FontSize', 20)
xlabel('Latitude','Interpreter','latex','FontSize', 15)
ylabel('Longitude','Interpreter','latex','FontSize', 15)

figure()
plot(sqrt(maxele_diff.^2),'x')
ylim([0 0.7])

figure()
plot(sqrt(da_diff.^2),'ro')
ylim([0 0.7])
