%% analysis: script to analyze vertical jump data
% Description
%
% Author Julian Bustamante <jbustamante@wisc.edu>

%% Import and process data
din = '/home/jbustamante/Dropbox/Misc/dataanalytics/vertical';
fin = 'data.csv';
w   = 'weather_code.txt';
deg = char(176);
X   = importdata([din , filesep , fin]);
Y   = cell2table(X.textdata(2:end,:), 'VariableNames', X.textdata(1,:));

% Import function is dumb and separates text and numeric data
Y.Measurement   = cellfun(@str2num, Y.Measurement);
Y.Temperature_C = X.data(:,1);
Y.Height_cm     = X.data(:,2);
Y.Stretch_cm    = X.data(:,3);
Y.Weight_kg     = X.data(:,4);
Y.Reach_cm      = X.data(:,5);

% Convert weather strings to code digit
W  = importdata([din , filesep , w]);
aa = cellfun(@(x) strfind(W.textdata, x), Y.Weather, 'UniformOutput', 0);
bb = cat(2, aa{:});
cc = ~cellfun(@isempty, bb);
dd = cell2mat(arrayfun(@(x) W.data(cc(:,x)), 1:size(cc,2), 'UniformOutput', 0));

Y.WeatherCode = dd';

% Compute true vertical [Reach - Stretch]
Y.Vertical_cm = Y.Reach_cm - Y.Stretch_cm;
GOAL          = 274.4 - Y.Stretch_cm(1);

% Interpolate date strings (since I'm not doing this every day)
Y.Date = cellfun(@datetime, Y.Date);
t      = timetable(Y.Date , Y.Vertical_cm);
tt     = retime(t, 'daily', 'fillwithmissing');
dtstr  = cellfun(@(x) [x(4:5) , '-' , x(1:2)], ...
    cellstr(tt.Time), 'UniformOutput', 0);
tstr   = cellfun(@(x) sprintf('%s%s', x, deg), ...
    cellstr(num2str(Y.Temperature_C)), 'UniformOutput', 0);

%% Plot data to test this out
size_data  = 12;
size_title = 11;
size_label = 10;
size_ticks = 10;

figclr(1);

subplot(221);
hold on;
plt(tt.Var1, 'k.', size_data);
plt([0 , GOAL ; numel(tt.Time) , GOAL], 'r-', 1);
xticks(1 : numel(tt.Time));
xticklabels(dtstr);
ylim(round([min(tt.Var1)-1 , GOAL+1]));
set(gca, 'FontSize', size_ticks-2);
xlabel('Date', 'FontSize', size_label);
ylabel('Vertical (cm)', 'FontSize', size_label);
title('Timeline', 'FontSize', size_title);

subplot(222);
plt([Y.Weight_kg , Y.Vertical_cm], 'k.', size_data);
set(gca, 'FontSize', size_ticks);
xlim(round([min(Y.Weight_kg) , max(Y.Weight_kg)]));
% xlabel('Weight (kg)', 'FontSize', size_label);
ylabel('Vertical (cm)', 'FontSize', size_label);
title('Weight (kg)', 'FontSize', size_title);

subplot(223);
plt([Y.Temperature_C, Y.Vertical_cm], 'k.', size_data);
set(gca, 'FontSize', size_ticks);
% xlabel('Temperature (C)', 'FontSize', size_label);
ylabel('Vertical (cm)', 'FontSize', size_label);
title(sprintf('Temperature (%sC)', deg), 'FontSize', size_title);

subplot(224);
plt([Y.WeatherCode, Y.Vertical_cm], 'k.', size_data);
text(Y.WeatherCode + 0.1, Y.Vertical_cm, tstr, ...
    'Color', 'k', 'FontSize', 8);
set(gca, 'FontSize', size_ticks);
% xlabel('Weather', 'FontSize', size_label);
ylabel('Vertical (cm)', 'FontSize', size_label);
xticklabels(W.textdata);
xticks(1 : max(Y.WeatherCode));
xlim([0 , numel(W.textdata) + 1]);
title('Weather', 'FontSize', size_title);

