function [test1,error1,test2,error2]=ex2(symbol)
%% Initialization

%% ================ Part 1: Feature Normalization ================

fprintf('Loading data ...\n');

%% Load Data
getData(symbol,'1/1/2008','7/1/2013');
dir_data=[symbol,'.mat'];
load(dir_data);

%% Data Initialization
[Short,Med,Long]=SimpleMovingAverage(Close,[5 20 60]);
x1=Close-Short;
x2=Close-Med;
x3=Close-Long;

tomorrow=Close(2:end);
data=[Close(1:end-1),x1(1:end-1),x2(1:end-1),x3(1:end-1),...
    Volume(1:end-1),tomorrow];
data=data(61:end,:);

X = data(1:0.7*end, 1:5);
X_test = data(0.7*end:end, 1:5);
y = data(1:0.7*end, 6);
y_test = data(0.7*end:end, 6);
m = length(y);
n = length(y_test);

% Scale features and set them to zero mean
fprintf('Normalizing Features ...\n');

[X mu sigma] = featureNormalize(X);

% Add intercept term to X
X = [ones(m, 1) X];
X_test = [ones(n, 1) X_test];

%% ================ Part 2: Gradient Descent ================

fprintf('Running gradient descent ...\n');

% Choose some alpha value
alpha = 0.01;
num_iters = 400;

% Init Theta and Run Gradient Descent 
theta = zeros(6, 1);
[theta, J_history] = gradientDescentMulti(X, y, theta, alpha, num_iters);

% % Plot the convergence graph
% figure;
% plot(1:numel(J_history), J_history, '-b', 'LineWidth', 2);
% xlabel('Number of iterations');
% ylabel('Cost J');

% Display gradient descent's result
fprintf('Theta computed from gradient descent: \n');
fprintf(' %f \n', theta);
fprintf('\n');

%% Predict and test

% part #1
predict_y1=X(1:end-1,:)*theta;
y=y(1:end-1);
test1=[predict_y1,y];
error1=mean(abs(test1(:,2)-test1(:,1))./y);

% part #2
predict_y2=X_test(1:end-1,:)*theta;
test2=[predict_y2,y_test(1:end-1)];
error2=mean(abs(test2(:,2)-test2(:,1))./y_test(1:end-1));

%% plot
plot(1:0.7*items,Close(1:0.7*end),'r.')
hold on
plot(0.7*items:items,Close(0.7*items:items),'b.')
% plot(0.7*n:n,predict_y2,'y.')
hold off

figure;
plot3(Short(1:0.7*end),Med(1:0.7*end),Close(1:0.7*end),'r.')
hold on
plot3(Short(0.7*end:end),Med(0.7*end:end),Close(0.7*end:end),'b.')

