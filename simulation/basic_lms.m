% reset everything
clear all; close all; clc;

% wait for button press
wait = 0;

% generate input
input_size = 1000;
input = 2048 .* sin(0.01*(1:input_size))' + 2048;

% create input buffer
buffer_size = 5;
buffer = zeros(buffer_size,1);

% create weights and randomize values
weights_size = 5;
%weights = 2 .* rand(weights_size,1) - 1;
weights(1,1) = -0.8049;
weights(2,1) = -0.4430;
weights(3,1) = 0.0938;
weights(4,1) = 0.9150;
weights(5,1) = 0.9298;

% set step size
step = 0.00000001;

% create vectors to hold values for predicted and error values
predicted_values = zeros(input_size,1);
error_values = zeros(input_size,1);

for ii = 1:input_size
    % read in next value
    buffer(:) = [(input(ii) - 2048); buffer(1:buffer_size-1)];
    
    % predict next value
    predict = buffer' * -weights;
    if predict > 2048
        predict = 2048;
    elseif predict < -2048
        predict = -2048;
    end
    
    % get error
    error = (input(ii) - 2048) + predict;
    if error > 2048
        error = 2048;
    elseif error < -2048
        error = -2048;
    end
    
    % print out all values
    fprintf('Input = %6f \nPredicted = %6f \nError = %6f \n\n', ...
        input(ii), predict, error);
    if wait == 1
        k = waitforbuttonpress;
    end
    
    % calculate new weights based on error
    weights(:) = (1-step) .* weights + step * double(error) .* buffer;
    
    % save predicted values and error values
    predicted_values(ii) = predict + 2048;
    error_values(ii) = error;
end

% plot subplot of actual values vs predicted values vs error values
fig1 = figure(1);
subplot(3,1,1);
plot(1:input_size, input);
title('Generated Input');
subplot(3,1,2);
plot(1:input_size, predicted_values);
title('Predicted Input');
axis([0 1000 -5000 5000])
subplot(3,1,3);
plot(1:input_size, error_values);
title('Error = Input - Predicted');
axis([0 1000 -5000 5000])


