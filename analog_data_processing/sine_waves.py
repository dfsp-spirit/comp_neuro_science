# Plots some sine wave signals, as well as their joint signal
# You can tweak the frequencies below, see the signal_frequencies_hz variable.abs
#
# Note: If the matplotlib window does not show up, ensure that you have configured a proper backend in your matplotlib config file. Try 'tkagg' on Linux.
import matplotlib
import matplotlib.pyplot as plt
import numpy as np


duration_secs = 5
sampling_frequency_hz = 1000
time_base = np.linspace(0, duration_secs, sampling_frequency_hz * duration_secs)

signal_frequencies_hz = [10, 7, 5]

fig = plt.figure()
num_plot_rows = len(signal_frequencies_hz)+1
num_plot_columns = 1
signals = []
for index, signal_frequency in enumerate(signal_frequencies_hz):
    signal = np.sin( 2 * np.pi * signal_frequency * time_base)
    signals.append(signal)
    ax = plt.subplot(num_plot_rows, num_plot_columns, index + 1)
    ax.plot(time_base, signal, c='k', lw=2)

joint_signal = np.sum(signals, axis=0)
ax = plt.subplot(num_plot_rows, num_plot_columns, num_plot_rows)
ax.plot(time_base, joint_signal,  c='k', lw=2)

plt.show()
