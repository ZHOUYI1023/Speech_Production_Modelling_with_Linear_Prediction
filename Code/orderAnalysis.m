function orderAnalysis(vowel,windowSize, orderSequence, sampleTime)
%% add window
window = hamming(windowSize);
vowel = vowel(1:windowSize);
vowel = vowel .* window;
%% frequency response
[f, m] = fourier(vowel, sampleTime);
figure
%% test different order of lpc
noise = zeros(length(orderSequence),1);
for i = 1:length(orderSequence)
    [lpcCoeffs, gain] = autolpc(vowel, orderSequence(i));
    [h, w] = freqz(gain,lpcCoeffs);
    w = w/pi/2/sampleTime;
    subplot(2,2,i)
    hold on
    plot(f, m,'LineWidth',1.5)
    plot(w,20*log10(abs(h)),'LineWidth',1.5)
    legend('STFT','LPC order of 10')
    xlabel('Frequency/ Hz')
    ylabel('Magnitude/ dB')
    ax = gca;
    ax.FontSize = 16;
    d = filter(lpcCoeffs,1, vowel);
    [noise(i),~] = meansqr(d);
end
figure
plot(orderSequence,noise,'x-','LineWidth', 1.5)
xlabel('order')
ylabel('MSE')
ax = gca;
ax.FontSize = 16;