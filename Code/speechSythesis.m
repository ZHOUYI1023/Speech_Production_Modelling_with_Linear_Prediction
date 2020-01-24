function vowelSythesized = speechSythesis(model, intervalTime, timeSpan)
global Plot
timeLast = model.sampleTime; 
%% generate impulse exicitation                   
exicitation = impulse(int32(timeSpan/model.sampleTime),int32(intervalTime/model.sampleTime),int32(timeLast/model.sampleTime));
%% speech sythesize
vowelSythesized = zeros(length(exicitation), 1);
ind = 0;
for i = 1:model.windowShift:length(exicitation)-model.windowSize + 1
    ind = ind + 1;
    vowelSythesized(i:i+model.windowSize-1) = filter(model.gain(ind), model.lpcCoeffs(ind,:), exicitation(i:i+model.windowSize-1));
end

%%
if Plot
    figure
    plot((model.sampleTime:model.sampleTime:timeSpan),vowelSythesized, 'LineWidth', 1.5);
    %axis([0,0.1,0,1.5])
    xlabel('time/ s')
    ylabel('amplitude')
    ax = gca;
    ax.FontSize = 16;
    hold on
    plot((model.sampleTime:model.sampleTime:timeSpan),exicitation,'--', 'LineWidth', 1.5);
    legend('sythesized speech','excitation')
end
end