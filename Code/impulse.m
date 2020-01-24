function signal = impulse(len, interval, span)
signal = zeros(len, 1);
for i = 1:interval:len
    signal(i:i+span) = 1;
end
    