function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.

##input_layer_size  = 400;  % 20x20 Input Images of Digits
##hidden_layer_size = 25;   % 25 hidden units
##num_labels = 10;          % 10 labels, from 1 to 10   
##                          % (note that we have mapped "0" to label 10)
##                          
##load('ex4data1.mat');
##m = size(X, 1);
##load('ex4weights.mat');
##nn_params = [Theta1(:) ; Theta2(:)];
##lambda = 1;

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
X = [ones(size(X,1), 1) X];
A = sigmoid(X*Theta1');
A = [ones(size(A,1), 1) A];
H = sigmoid(A*Theta2');
unit = eye(num_labels);

  for totalExamples = 1:m
    J += (-1)*log(H(totalExamples,:))*unit(:,y(totalExamples)) - log(1-H(totalExamples,:))*(1-unit(:,y(totalExamples)));
  end

J = J/m;
temp = 0;
for i = 1:size(Theta1,1)
  for j = 2:size(Theta1,2)
   temp += Theta1(i,j)*Theta1(i,j);
  end
end

for i = 1:size(Theta2,1)
  for j = 2:size(Theta2,2)
   temp += Theta2(i,j)*Theta2(i,j);
  end
end

J += temp * lambda / (2*m);

for i = 1:m
  A_1 = X(i,:);
  Z_2 = A_1*Theta1';
  A_2 = sigmoid(Z_2);
  A_2 = [ones(size(A_2,1), 1) A_2];
  A_3 = sigmoid(A_2*Theta2');
  
   Z_2 = [ones(size(Z_2,1), 1) Z_2];
  test = unit(:,y(i))';
  
  delta_3 = A_3 - unit(:,y(i))' ;
  delta_2 = delta_3*Theta2.* sigmoidGradient(Z_2);
  delta_2 = delta_2(2:end);
  Theta1_grad = Theta1_grad + delta_2'*A_1;
  Theta2_grad = Theta2_grad + delta_3'*A_2;
end

Theta1_grad(:, 1) = Theta1_grad(:, 1) ./ m;
	
Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) ./ m + ((lambda/m) * Theta1(:, 2:end));


Theta2_grad(:, 1) = Theta2_grad(:, 1) ./ m;

Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) ./ m + ((lambda/m) * Theta2(:, 2:end));
% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
