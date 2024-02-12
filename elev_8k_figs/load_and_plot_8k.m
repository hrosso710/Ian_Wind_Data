%% Loads and plots 8k data

%% Load in fort.61 and mesh

load('3D_mesh_plot.mat')
fort61_OWI = read_adcirc_fort61('OWIfort.61',[2022,09,19,12,0,0]);


%% Line plots of elevation at the stations

figure()
hold on
plot(fort61_OWI.zeta(:,6),'LineWidth',2.0)
plot(fort61_OWI.zeta(:,7),'LineWidth',2.0)