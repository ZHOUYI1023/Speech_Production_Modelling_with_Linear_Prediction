function f0 = f0Estimation(vowel, sampleRate)
global Plot
scale = 5;
vowelDwonSample = downsample(vowel,scale);
[c, lags] = xcorr(vowelDwonSample, 'coeff');
c = c(lags > 0);
lags = lags(lags > 0);
ind = 1;
peakIndex(ind) = find(c == max(c));
for i = peakIndex(1):peakIndex(1):length(c)-5
    peakIndex(ind) = find(c == max(c(max(i-5,1):i+5)));
    ind = ind + 1;
end
peakIndex = peakIndex(1:8);
f0 = 1/(mean(diff(peakIndex))* 5) * sampleRate;

if Plot
    figure
    plot(lags, c,'LineWidth',1.5)
    hold on
    plot(lags(peakIndex), c(peakIndex),'rx' ,'LineWidth',1.5)
    xlabel('time shift/ sample')
    ylabel('correlation coefficient')
    axis([0,521,0,8000])
    ax = gca;
    ax.FontSize = 16;
end