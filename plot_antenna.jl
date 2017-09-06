#!/usr/bin/env julia

using Plots
using VectorizedRoutines

plotly()  # Select a plotting backend.

# Read the antenna data file (CSV format).
raw_data = readdlm("dipole_pattern.csv", ',', Float32, skipstart=1)

# Separate and sort the data.
freq = unique(raw_data[:,1])
theta = unique(raw_data[:,2])
phi = unique(raw_data[:,3])
pattern_db = reshape(raw_data[:,4], (length(phi), length(theta), length(freq)))

# If complex gain values are needed, uncomment the following line:
#complex_pattern = 10^(raw_data[:,4]/10)*exp(1j*raw_data[:,5]/180*π)

## Plot in 2D ##

# Pick a frequency
fidx = 1

# Control plot dynamic range
pltmax = 5.
pltmin = -35.

# Create the 2D colormap (heatmap)
xs = [string(i) for i = round(Int32, theta)]
ys = [string(i) for i = round(Int32, phi)]
heatmap(ys, xs, pattern_db[:,:,fidx]', clims = (pltmin,pltmax),
        title = "Dipole Realized Gain", xlabel = "phi (deg)",
        ylabel = "theta (deg)", fc=:haline, colorbar_title="dBi")

## Plot in 3D (project onto surface of sphere) ##
theta2d, phi2d = Matlab.meshgrid(theta, phi)
x2d = sind(theta2d).*cosd(phi2d)
y2d = sind(theta2d).*sind(phi2d)
z2d = cosd(theta2d)
color_mat = pattern_db[:,:,fidx]
color_mat[pattern_db[:,:,fidx] .< pltmin] = pltmin

surface(x2d, y2d, z2d, fill_z = color_mat, fc = :haline, grid=false,
        title = "Dipole Realized Gain", colorbar_title="dBi")

# Remove the axes
# Currently ticks=false doesn't entirely remove the axes.
plot!(foreground_color = :white, foreground_color_title = :black)

## Plot in 3D ##
r = pattern_db[:,:,fidx] - pltmin
r[r .< 0.0] = 0.0

x2d = r.*sind(theta2d).*cosd(phi2d)
y2d = r.*sind(theta2d).*sind(phi2d)
z2d = r.*cosd(theta2d)

surface(x2d, y2d, z2d, fill_z = color_mat, fc = :haline,
        title = "Dipole Realized Gain", colorbar_title="dBi",
        grid = false)

# Remove the axes
# Currently ticks=false doesn't entirely remove the axes.
plot!(foreground_color = :white, foreground_color_title = :black)
