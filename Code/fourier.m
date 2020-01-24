function [f, m] = fourier(t, sampleTime)
s = fft(t);
s = s(1:length(t)/2+1);
f = 1/sampleTime * (0:length(t)/2)/length(t);
m = 20*log10(abs(s));