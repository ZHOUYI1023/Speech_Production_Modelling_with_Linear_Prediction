clear all;
close all;
clc;
addpath("speech");
list = dir("speech/*.wav");
global Plot;
% flag to turn on/off the plot
Plot = false;
%% preprocessing
vowelIndex = 15;
% vowelIndex = 10;
fileName = list(vowelIndex).name;
[vowel, Vowel.sampleRate] = audioread(fileName);
sound(vowel, Vowel.sampleRate);
timeSpan = 0.1 * Vowel.sampleRate;
Vowel.vowel = vowel(800:800 + timeSpan);
%% lpc model
nFormants = 3;
order = 35;
windowSize = int32(0.02 * Vowel.sampleRate);
windowShift = int32(0.005* Vowel.sampleRate);
[Model, Vowel.formant, Vowel.f0] = lpcEstimation(Vowel.vowel, windowSize, windowShift, order, 1/Vowel.sampleRate, nFormants);
%% model parameter analysis
if Plot
    orderSequence = 10:20:70;
    windowSzieSequence = int32((0.005:0.015:0.08) .* Vowel.sampleRate);
    parameterAnalysis(Vowel.vowel,windowSize,order,Vowel.sampleRate,windowSzieSequence,orderSequence);
end
%% sythesis
vowelSythesized = speechSythesis(Model, 1/Vowel.f0, timeSpan/Vowel.sampleRate);
sound(vowelSythesized, Vowel.sampleRate);
fileName = [fileName(1:end-4),'_sythesized.wav'];
audiowrite(fileName,vowelSythesized,Vowel.sampleRate);