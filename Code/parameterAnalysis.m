function parameterAnalysis(vowel,windowSize,order,sampleRate,windowSzieSequence,orderSequence )
% test the effect of different order 
orderAnalysis(vowel,windowSize, orderSequence, 1/sampleRate)
% test the effect of different window size
windowAnalysis(vowel,windowSzieSequence, order, 1/sampleRate)