function lab1()
    % ������� ������ n �� ����������� ������������ �
    X = [
 -7.50, -6.61, -7.85, -7.72, -8.96, -6.55, -7.82, -6.55, -6.87, -5.95, ...
 -5.05, -4.56, -6.14, -6.83, -6.33, -7.67, -4.65, -6.30, -8.01, -5.88, ...
 -5.38, -7.06, -6.85, -5.53, -7.83, -5.89, -7.57, -6.76, -6.02, -4.62, ...
 -8.55, -6.37, -7.52, -5.78, -6.12, -8.82, -5.14, -7.68, -6.14, -6.48, ...
 -7.14, -6.25, -7.32, -5.51, -6.97, -7.86, -7.04, -6.24, -6.41, -6.00, ...
 -7.46, -6.00, -6.06, -5.94, -5.39, -5.06, -6.91, -8.06, -7.24, -6.42, ...
 -8.73, -6.20, -7.35, -5.90, -5.02, -5.93, -7.56, -7.49, -6.26, -6.06, ...
 -7.35, -5.10, -6.52, -7.97, -5.71, -7.62, -7.33, -5.31, -6.21, -7.28, ...
 -7.99, -4.65, -7.07, -7.31, -7.72, -5.22, -7.00, -7.17, -6.64, -7.00, ...
 -6.12, -6.57, -6.07, -6.65, -7.60, -6.92, -6.78, -6.85, -7.90, -7.40, ...
 -5.32, -6.58, -6.71, -5.07, -5.80, -4.87, -5.90, -7.43, -7.03, -6.67, ...
 -7.72, -5.83, -7.49, -6.68, -6.71, -7.31, -7.83, -7.92, -5.97, -6.34, ...
 ];
    % ������������ ��������
    Mmax = max(X);
    % ����������� ��������
    Mmin = min(X);
    % ������ �������
    R = Mmax - Mmin;
    % ���������� �������
    mu = mean(X);
    % ������������� ������ ���������
    s2 = var(X);
    
    % ����� ���������� ����� ��������
    fprintf('Mmax = %f\n', Mmax);
    fprintf('Mmin = %f\n', Mmin);
    fprintf('R = %f\n', R);
    fprintf('mu = %f\n', mu);
    fprintf('S2 = %f\n', s2);
    % ��������� ������������ ���
    [count, edges, m] = groupInterval(X);
    
    % ���������� �����������
    plotHistogram(X, count, edges, m);
    % ���������� �� ����� ������������ ���������
    hold on; 
    % ������ ������� ��������� ������������� ������������ ���������� 
    % ��������� ��������
    fn = @(x, mu, s2) normpdf(x, mu, s2);
    plotGraph(fn, mu, s2, Mmin, Mmax, 0.1);
    
    % ����� ������������ ���������
    figure;
    % ������ ������������ ������� �������������
    plotEmpiricalF(X);
    % ���������� �� ����� ������������ ���������
    hold on;
    % ������ ������� ������������� ���������� ��������� ��������
    Fn = @(x, mu, s2) normcdf(x, mu, s2);
    plotGraph(Fn, mu, s2, Mmin, Mmax, 0.1);
end

% ������� ��� ����������� �������� �������
function [count, edges, m] = groupInterval(X)
    % ���������� ���������� ����������
    m = floor(log2(length(X))) + 2;
    % � ������� ������� histcounts ��������� ������� �� m ���������� ��
    % �������� �� ���������. ���������� ��������� � ���������� ���������
    % � ������ �� ���
    [count, edges] = histcounts(X, m, 'BinLimits', [min(X), max(X)]);
    lenC = length(count);
    
    % ����� ���������� � ���������� ���������
    fprintf('\n������������ ��� ��� m = %d \n', m);
    for i = 1 : (lenC - 1)
        fprintf('[%f,%f) - %d\n', edges(i), edges(i + 1), count(i));
    end
    fprintf('[%f,%f] - %d\n', edges(lenC), edges(lenC + 1), count(lenC));
end

% ������� ��� ��������� �����������
function plotHistogram(X, count, edges, m)
    % ���������� �����������
    h = histogram();
    % ������ ���������
    h.BinEdges = edges;
    % ������ �������� � ������ ��������� (������������ ���������)
    h.BinCounts = count / length(X) / ((max(X) - min(X)) / m);
    h.LineWidth = 2;
    h.DisplayStyle = 'stairs';
end

% ������� ��� ��������� �������� func, c �������������� ��������� mu 
% � ���������� s2, �� min �� max � ����� step
function plotGraph(func, mu, s2, min, max, step)
    x = min : step : max;
    y = func(x, mu, s2);
    plot(x, y, 'LineWidth', 2);
end

% ������ ������������ ������� �������������
function plotEmpiricalF(X)
    % ����� ���������� ���������
    u = unique(X);
    % ������� ���������� ������� �� ���������� ���������
    count = histcounts(X, u);
    % ������� ���������� ���������, ������� �������� ����������� ��������
    for i = 2 : (length(count))
        count(i) = count(i) + count(i - 1);
    end
    count = [0 count];
    % ��������� �������
    stairs(u, count / length(X), 'LineWidth', 2);
end