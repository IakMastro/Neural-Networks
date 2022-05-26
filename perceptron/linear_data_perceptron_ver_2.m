clear; clc; format compact;

function er = mean_squared_error(x)
  if size(x, 1) == 1
    er = x * x' / size(x, 2);
  else
    er = x' * x / size(x, 1);
  end
end

N = 200;
x1 = 4 * rand(1, N);
x2 = 3 * rand(1, N);
data = [x1; x2];

D = x1/4 + x2/4 - 1;

tol = 0.1;
idx1 = find(D > tol);
idx2 = find(D < -tol);
data1 = data(:, idx1);
data2 = data(:, idx2);

hf = figure();
plot(data1(1, :), data1(2, :), 'b*', data2(1, :), data2(2, :), 'r*')
print(hf, '-dpng', '-r300', 'linear_data_ver2.png');

dout1 = ones(1, size(data1, 2));
dout2 = -ones(1, size(data2, 2));

P = [data1 data2];
T = [dout1 dout2];

idx = randperm(size(P, 2));
P = P(:, idx);
T = T(idx);

w1 = rand - .5;
w2 = rand - .5;
w0 = rand - .5;

a = -w1 / w2;
b = -w0 / w2;

x1 = [-.5 4.5];
x2 = a * x1 + b;

plot(data1(1, :), data1(2, :), 'b*', data2(1, :), data2(2, :), 'r*')
hold on
plot(x1, x2, 'k')
axis([-1 5 -1 4])
print(hf, '-dpng', '-r300', 'initial_linear_perceptron_ver2.png');
hold off

maxepochs = 100;
epochlength = length(T);

changed = false;
i = 1;
W = rand(3, 1) - 0,5;

while i <= maxepochs && ~changed
  e = 1 / i;
  changed = true;
  for j = 1 : epochlength
    y(j) = sign(W' * [P(:, j); 1]);

    if y(j) ~= T(j)
      changed = false;
      W = W + e * [T(j) * P(:, j); T(j)];
    end
  end

  a = -W(1) / W(2);
  b = -W(3) / W(2);
  x1 = [-.5 4.5];
  x2 = a * x1 + b;
  plot(data1(1, :), data1(2, :), 'b*', data2(1, :), data2(2, :), 'r*')
  hold on
  plot(x1, x2, 'k')
  axis([-1 5 -1 4])
  print(hf, '-dpng', '-r300', ['linear_perceptron_', int2str(i), '_ver2.png']);
  hold off
  W
  MSE = mean_squared_error(y - T)
  disp('Πατήστε ένα κουμπί για να συνεχίσει...')
  pause
  i = i + 1;
end

if changed
  disp(['Το συνολικό πλήθος επαναλήψεων είναι: ', int2str(i)])
else
  disp('Το συνολικό πλήθος επαναλήψεων δεν ήταν αρκετό.')
end

disp('Τελείωσε η εκπαίδευση του perceptron.')
