%% analysis: script to analyze vertical jump data
% Description
%
% Author Julian Bustamante <jbustamante@wisc.edu>

%% Import and process data
din = '/home/jbustamante/Dropbox/Misc/dataanalytics/ujumpgood';
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

% Interpolate data points
% tst               = ...
%     interpolateOutline([Y.Measurement Y.Vertical_cm], numel(tt.Time));
repl               = fillmissing(tt.Var1, 'linear');
% repl              = tt.Var1;
% repl(isnan(repl)) = tst(isnan(repl),2);

%% Plot data to test this out
size_data  = 12;
size_title = 11;
size_label = 10;
size_ticks = 10;
mskip      = 2;
mbuff      = 1;
tbuff      = 1;
wbuff      = 0.2;

figclr(1);
fnms{1} = sprintf('%s_VerticalAnalysis_Day%d', tdate, max(Y.Measurement));

% ------------------------------- Measurement -------------------------------- %
subplot(221);
hold on;
plt(repl, 'r.', size_data - 2);
plt(tt.Var1, 'k.', size_data);
plt([0 , GOAL ; numel(tt.Time) , GOAL], 'r--', 1);                            % Goal
plt([0 , Y.Vertical_cm(end) ; numel(tt.Time) , Y.Vertical_cm(end)], 'b-', 1); % Latest
plt([0 , Y.Vertical_cm(1) ; numel(tt.Time) , Y.Vertical_cm(1)], 'm-', 1);     % Initial
xticks(1 : mskip : numel(tt.Time));
xticklabels(dtstr(cellfun(@str2num, get(gca, 'XTickLabel'))));
ylim(round([min(tt.Var1) - mbuff , max(Y.Vertical_cm) + mbuff]));
set(gca, 'FontSize', size_ticks - 2);
xlabel('Date', 'FontSize', size_label);
ylabel('Vertical (cm)', 'FontSize', size_label);
title('Timeline', 'FontSize', size_title);

% ---------------------------------- Weight ---------------------------------- %
subplot(222);
hold on;
plt([Y.Weight_kg , Y.Vertical_cm], 'k.', size_data);
plt([Y.Weight_kg(end) , Y.Vertical_cm(end)], 'b.', size_data + 1); % Latest
plt([Y.Weight_kg(1) , Y.Vertical_cm(1)], 'm.', size_data + 1);     % Initial
set(gca, 'FontSize', size_ticks);
xlim([min(Y.Weight_kg) - wbuff, max(Y.Weight_kg) + wbuff]);
ylabel('Vertical (cm)', 'FontSize', size_label);
title('Weight (kg)', 'FontSize', size_title);

% ------------------------------- Temperature -------------------------------- %
subplot(223);
hold on;
plt([Y.Temperature_C, Y.Vertical_cm], 'k.', size_data);
plt([Y.Temperature_C(end) , Y.Vertical_cm(end)], 'b.', size_data + 1); % Latest
plt([Y.Temperature_C(1) , Y.Vertical_cm(1)], 'm.', size_data + 1);     % Initial
set(gca, 'FontSize', size_ticks);
ylabel('Vertical (cm)', 'FontSize', size_label);
xlim([min(Y.Temperature_C) - tbuff , max(Y.Temperature_C) + tbuff]);
title(sprintf('Temperature (%sC)', deg), 'FontSize', size_title);

% ---------------------------------- Weather --------------------------------- %
subplot(224);
hold on;
plt([Y.WeatherCode, Y.Vertical_cm], 'k.', size_data);
plt([Y.WeatherCode(end) , Y.Vertical_cm(end)], 'b.', size_data + 1); % Latest
plt([Y.WeatherCode(1) , Y.Vertical_cm(1)], 'm.', size_data + 1);     % Initial
text(Y.WeatherCode + 0.1, Y.Vertical_cm, tstr, 'Color', 'k', 'FontSize', 8);
set(gca, 'FontSize', size_ticks);
ylabel('Vertical (cm)', 'FontSize', size_label);
xticklabels(W.textdata);
xticks(1 : max(Y.WeatherCode));
xlim([0 , numel(W.textdata) + 1]);
title('Weather', 'FontSize', size_title);

%% Projections to new goal
NEW_GOAL   = 75;
size_data  = 12;
size_title = 11;
size_label = 10;
size_ticks = 10;
mskip      = 2;
mbuff      = 1;
tbuff      = 1;
wbuff      = 0.2;

figclr(2);
fnms{2} = sprintf('%s_VerticalAnalysis_Projection', tdate);

% ------------------------------- Measurement -------------------------------- %
hold on;
plt(repl, 'r.', size_data - 2);
plt(tt.Var1, 'k.', size_data);
plt([0 , GOAL ; numel(tt.Time) , GOAL], 'r--', 1);                            % Goal
plt([0 , Y.Vertical_cm(end) ; numel(tt.Time) , Y.Vertical_cm(end)], 'b-', 1); % Latest
plt([0 , Y.Vertical_cm(1) ; numel(tt.Time) , Y.Vertical_cm(1)], 'm-', 1);     % Initial
xticks(1 : mskip : numel(tt.Time));
xticklabels(dtstr(cellfun(@str2num, get(gca, 'XTickLabel'))));
ylim(round([min(tt.Var1) - mbuff , NEW_GOAL + mbuff]));
set(gca, 'FontSize', size_ticks - 2);
xlabel('Date', 'FontSize', size_label);
ylabel('Vertical (cm)', 'FontSize', size_label);
title('Timeline', 'FontSize', size_title);

% -------------------------------- Projection -------------------------------- %
%% Plot projection until next goal
max_proj = 32;
rng_proj = (numel(repl) : max_proj)';

lx  = [(1:numel(repl))' , repl];
lt  = fitlm(lx(:,1), lx(:,2), 'linear');
ly  = lt.predict(rng_proj);
% prj = [(1 : max_proj)' , [lx(:,2) ; ly]];
prj = [rng_proj , ly];

plot(lt);
plt(prj, 'k-', 1);
plt([0 , NEW_GOAL ; max_proj , NEW_GOAL], 'g--', 1);                            % New Goal
xlim([0 , max_proj]);


