
function plot_eeg_data(eeg_data)
   %display('hello') 
end

function y = average_2(x)
if ~isvector(x)
    error('Input must be a vector')
end
y = sum(x)/length(x); 
end