function windowAnalysis(vowel,windowSizeSequence, order, sampleTime)
figure
hold on
for i = 1:length(windowSizeSequence)
    window = hamming(windowSizeSequence(i));
    vowelSeg =  vowel(1:windowSizeSequence(i));
    vowelSeg = vowelSeg .* window;
    %% frequency response
    [f, m] = fourier(vowelSeg, sampleTime);
    subplot(2,length(windowSizeSequence)/2,i)
    plot(f, m,'LineWidth',1.5)
    hold on
    axis([0 12000 -50 40])
    %% lpc model
    [lpcCoeffs, gain] = autolpc(vowelSeg, order);
    [h, w] = freqz(gain,lpcCoeffs);
    w = w/pi/2/sampleTime;
    plot(w,20*log10(abs(h)),'LineWidth',1.5)
    legend('STFT','LPC')
    xlabel('Frequency/ Hz')
    ylabel('Magnitude/ dB')
    title("window size of "+ double(windowSizeSequence(i))*sampleTime*1000 + " ms")
    ax = gca;
    ax.FontSize = 16;
end