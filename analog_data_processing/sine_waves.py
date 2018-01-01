# Plots some sine wave signals, as well as their joint signal
import matplotlib.pyplot as plt
import numpy as np


duration_secs = 5
sampling_frequency_hz = 1000
time_base = np.linspace(0, duration_secs, sampling_frequency_hz * duration_secs)

signal_frequencies_hz = [10, 7]

fig = plt.figure()

signals = []
for index, signal_frequency in enumerate(signal_frequencies_hz):
    signal = np.sin( 2 * np.pi * signal_frequency * time_base)
    signals.append(signal)
    ax = plt.subplot(3, 1, index + 1)
    ax.plot(time_base, signal, c='k', lw=2)

joint_signal = signals[0] + signals[1]
ax = plt.subplot(3, 1, len(signal_frequencies_hz)+1)
ax.plot(time_base, joint_signal,  c='k', lw=2)

fig.show()
