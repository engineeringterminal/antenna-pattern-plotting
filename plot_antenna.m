% Antenna plotting example for the EngineeringTerminal.com article 
% "Visualizing Antenna Patterns".

clear variables
close all
clc

%% Read in the dipole antenna pattern data

% Read the antenna data file (CSV format).
rawData = dlmread('dipole_pattern.csv', ',', 1, 0);

% Separate and sort the data.
freq = unique(rawData(:,1));
theta = unique(rawData(:,2));
phi = unique(rawData(:,3));
pattern = reshape(rawData(:,4), length(phi), length(theta), length(freq));

%% Plot in 2D

% Index of frequency to plot
iFreq = 1;

% Control plot dynamic range
pltmax = 5;
pltmin = -35;

% Make the 2D colormap
figure()
[theta2d, phi2d] = meshgrid(theta, phi);
pcolor(phi2d, theta2d, pattern(:,:,iFreq))
set(gca, 'clim', [pltmin pltmax])
ylabel('Theta [degrees]')
xlabel('Phi [degrees]')
shading interp
colormap 'jet'
cbar = colorbar;
cbar.Label.String = 'Realized Gain (dBi)';

%% Plot in 3D (project onto surface of sphere)

x2d = sind(theta2d).*cosd(phi2d);
y2d = sind(theta2d).*sind(phi2d);
z2d = cosd(theta2d);

figure()
surf(x2d, y2d, z2d, pattern(:,:,iFreq))
set(gca, 'clim', [pltmin pltmax])
shading interp
colormap jet
axis equal
axis off

cbar = colorbar;
cbar.Label.String = 'Realized Gain (dBi)';

ax = gca;               % get the current axis
ax.Clipping = 'off';    % turn clipping off

%% Plot in 3D

r = pattern(:,:,iFreq) - pltmin;
r(r < 0.0) = 0.0;

x2d = r.*sind(theta2d).*cosd(phi2d);
y2d = r.*sind(theta2d).*sind(phi2d);
z2d = r.*cosd(theta2d);

figure()
surf(x2d, y2d, z2d, pattern(:,:,iFreq))
set(gca, 'clim', [pltmin pltmax])
shading interp
colormap jet
axis equal
axis off

cbar = colorbar;
cbar.Label.String = 'Realized Gain (dBi)';

ax = gca;               % get the current axis
ax.Clipping = 'off';    % turn clipping off
