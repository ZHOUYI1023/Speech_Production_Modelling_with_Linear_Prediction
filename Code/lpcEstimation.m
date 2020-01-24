function [model, formant, f0] = lpcEstimation(vowel, windowSize, shift, order, ts, nFormants)
global Plot;
model.sampleTime = ts;
model.windowSize = windowSize;
model.windowShift = shift;
t = model.sampleTime * (1:size(vowel));
window = hamming(windowSize);
ind = 0;
model.lpcCoeffs = zeros((length(vowel)-1)/shift -1, order+1);
model.gain = zeros((length(vowel)-1)/shift -1, 1);
noise = zeros(size(vowel));
formant = zeros((length(vowel)-1)/shift -1, 3);
%% f0 frequency
f0 = f0Estimation(vowel, 1/ts);
%% lpc
for i = 1:shift:length(vowel)-windowSize + 1
    ind = ind + 1;
    vowelSegment = vowel(i:i+windowSize-1);
    vowelSegment = vowelSegment .* window;
    [model.lpcCoeffs(ind,:), model.gain(ind)] = autolpc(vowelSegment, order);
    noise(i:i+windowSize-1) = filter(model.lpcCoeffs(ind,:),1, vowelSegment);
    [h, w] = freqz(model.gain(ind), model.lpcCoeffs(ind,:));
    w = w/pi/2/model.sampleTime;
    magnitude = 20*log10(abs(h));
%% pole-zero map
    lpcPoles = roots(model.lpcCoeffs(ind,:));
    sys = tf(model.gain(ind),model.lpcCoeffs(ind,:), 'Ts', model.sampleTime);
%% formant
    ang = atan2(imag(lpcPoles),real(lpcPoles))/pi/2/model.sampleTime;
    ang = sort(ang(find(ang>0)));
    formant(ind,:) = ang(1:nFormants);
    wList = sort([ang(1:nFormants);w]);
    for i = 1:nFormants
        peakIndex(i) = find(wList==formant(ind,i))-i;
    end
end
%% fundamental frequency
%f0 = f0Estimation(noise, model.sampleTime);

formant = mean(formant);
sound(noise,  1/ts);
if Plot
    figure
    pzmap(sys);
    ax = gca;
    ax.FontSize = 16;
    axis equal
    
    figure
    plot(w, magnitude, 'LineWidth',1.5)
    hold on
    plot(w(peakIndex), magnitude(peakIndex),'ro', 'LineWidth',1.5)
    xlabel('frequency/ Hz')
    ylabel('magnitude/ db')
    ax = gca;
    ax.FontSize = 16;
    
    figure
    hold on
    plot(t, vowel,'LineWidth',1.5)
    plot(t, vowel-noise,'--','LineWidth',1.5)
    plot(t, noise,'LineWidth',1.5)
    legend('original speech', 'reconstructed speech', 'noise')
    xlabel('time/ s')
    ylabel('amplitude')
    ax = gca;
    ax.FontSize = 16;
end