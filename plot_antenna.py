#!/usr/bin/env python

"""
This file contains code for demonstration purposes only. It is not structured
for use as a Python module.
Author: Dylan Crocker
Copyright 2017 Viper Science LLC
"""

from mayavi import mlab
import matplotlib.pyplot as plt
import numpy as np

# Read the antenna data file (CSV format).
raw_data = np.loadtxt("dipole_pattern.csv", delimiter=',', skiprows=1)

# Separate and sort the data.
freq = np.unique(raw_data[:,0])
theta = np.unique(raw_data[:,1])
phi = np.unique(raw_data[:,2])
pattern_db = np.reshape(raw_data[:,3], (len(phi), len(theta), len(freq)), order='F')

## Plot in 2D ##

# Index of frequency to plot
fidx = 1

# Control plot dynamic range
pltmax = 5
pltmin = -35

# Create the 2D colormap
plt.figure()
theta2d, phi2d = np.meshgrid(theta, phi)
plt.pcolor(phi2d, theta2d, pattern_db[:,:,fidx],
    vmin=pltmin, vmax=pltmax, cmap="jet")
plt.xlabel("Phi [degrees]")
plt.ylabel("Theta [degrees]")
plt.colorbar(label="Realized Gain [dBi]")
# plt.show()

## Plot in 3D (project onto surface of sphere) ##

x2d = np.sin(np.deg2rad(theta2d))*np.cos(np.deg2rad(phi2d))
y2d = np.sin(np.deg2rad(theta2d))*np.sin(np.deg2rad(phi2d))
z2d = np.cos(np.deg2rad(theta2d))

mlab.figure(bgcolor=(1,1,1), fgcolor=(0.,0.,0.))
mlab.mesh(x2d, y2d, z2d, scalars=pattern_db[:,:,fidx],
    colormap='jet', vmax=pltmax, vmin=pltmin)
mlab.colorbar(orientation='vertical')
mlab.orientation_axes()
# mlab.show()

## Plot in 3D ##

r = pattern_db[:,:,fidx] - pltmin
r[r < 0.0] = 0.0

x2d = r*np.sin(np.deg2rad(theta2d))*np.cos(np.deg2rad(phi2d))
y2d = r*np.sin(np.deg2rad(theta2d))*np.sin(np.deg2rad(phi2d))
z2d = r*np.cos(np.deg2rad(theta2d))

mlab.figure(bgcolor=(1,1,1), fgcolor=(0.,0.,0.))
mlab.mesh(x2d, y2d, z2d, scalars=pattern_db[:,:,fidx], colormap='jet', vmax=pltmax, vmin=pltmin)
mlab.colorbar(orientation='vertical')
mlab.orientation_axes()

plt.show()
mlab.show()
