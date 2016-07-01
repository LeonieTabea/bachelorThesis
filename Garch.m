%% Import data from text file.
% Script for importing data from the following text file:
%
%    /Users/leoniegoldmann/Desktop/Matlab/Futurecornprices.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2016/06/21 18:36:56

%% Initialize variables.
filename = '/Users/leoniegoldmann/Desktop/Matlab/Futurecornprices.csv';
delimiter = ',';

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%*s%*s%*s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

% Converts strings in the input cell array to numbers. Replaced non-numeric
% strings with NaN.
rawData = dataArray{2};
for row=1:size(rawData, 1);
    % Create a regular expression to detect and remove non-numeric prefixes and
    % suffixes.
    regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
    try
        result = regexp(rawData{row}, regexstr, 'names');
        numbers = result.numbers;
        
        % Detected commas in non-thousand locations.
        invalidThousandsSeparator = false;
        if any(numbers==',');
            thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
            if isempty(regexp(numbers, thousandsRegExp, 'once'));
                numbers = NaN;
                invalidThousandsSeparator = true;
            end
        end
        % Convert numeric strings to numbers.
        if ~invalidThousandsSeparator;
            numbers = textscan(strrep(numbers, ',', ''), '%f');
            numericData(row, 2) = numbers{1};
            raw{row, 2} = numbers{1};
        end
    catch me
    end
end

% Convert the contents of columns with dates to MATLAB datetimes using date
% format string.
try
    dates{1} = datetime(dataArray{1}, 'Format', 'yyyy-MM-dd', 'InputFormat', 'yyyy-MM-dd');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{1} = cellfun(@(x) x(2:end-1), dataArray{1}, 'UniformOutput', false);
        dates{1} = datetime(dataArray{1}, 'Format', 'yyyy-MM-dd', 'InputFormat', 'yyyy-MM-dd');
    catch
        dates{1} = repmat(datetime([NaN NaN NaN]), size(dataArray{1}));
    end
end

anyBlankDates = cellfun(@isempty, dataArray{1});
anyInvalidDates = isnan(dates{1}.Hour) - anyBlankDates;
dates = dates(:,1);

%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, 2);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
Futurecornprices = table;
Futurecornprices.VarName1 = dates{:, 1};
Futurecornprices.VarName5 = cell2mat(rawNumericColumns(:, 1));

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

Futurecornprices.VarName1=datenum(Futurecornprices.VarName1);

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me dates blankDates anyBlankDates invalidDates anyInvalidDates rawNumericColumns R;

%% delete first row 

Futurecornprices = Futurecornprices{2:end,1:end};

%% flip prices 

Futurecornprices = flipud(Futurecornprices);

Futurecornprices = array2table(Futurecornprices);

%% Plot prices 

figure(123)
plot(Futurecornprices{:,1}, Futurecornprices{:,2})
datetick 'x'
xlabel('Jahr');
ylabel('Preis in US Dollar');
grid on
grid minor

plotCounter = '123';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/FutureCornPreise');

figureNumber = 123;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')



%% returns 

Futurecornprices.Properties.VariableNames{'Futurecornprices1'} = 'Date';
Futurecornprices.Properties.VariableNames{'Futurecornprices2'} = 'Price';


Futurecornrenditen = zeros(7807,2);

Futurecornrenditen(:,2) = price2ret(Futurecornprices.Price);

Futurecornprices(1,:) = [];
Futurecornrenditen(:,1) = Futurecornprices.Date;

Futurecornrenditen = array2table(Futurecornrenditen);

%% PLot returns
figure(1234)
plot(Futurecornrenditen{:,1}, Futurecornrenditen{:,2})
datetick 'x'
xlabel('Jahr');
ylabel('Log-Rendite');
grid on
grid minor

plotCounter = '1234';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/FutureCornRenditen');

figureNumber = 1234;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

%% Ljung Box test lehnt Nullhypothese ab
returns = Futurecornrenditen{:,2}; 

returns2 = returns.^2;

[h, pValue] = lbqtest(returns)
[h, pValue] = lbqtest(returns2)

figure
autocorr(returns,500);

%% Garch Modell

returns = Futurecornrenditen{:,2}






%% VaR
%
% init different value-at-risk confidence levels
quants = [0.005 0.01 0.05];



%% Fit Garch model to data and estimate V 

EstMdl = garch('GARCH',NaN,'ARCH',NaN);
n=500;

for i=(n+1):length(returns)
    data=returns((i-n):(i-1));
    EstMdl1 = estimate(EstMdl,data);
    V(i-n)=sqrt(forecast(EstMdl1,1,'y0',data));
    Constantt(i-n)=EstMdl1.Constant;
    Garchhh(i-n)=EstMdl1.GARCH{1};
    Archh(i-n)=EstMdl1.ARCH{1};
end

%% Plot for Garch and Arch Parameters
figure
plot(Garchhh)
hold on
plot(Archh)

%% test if sum of parameters >zero 
for i=1:length(Garchhh)
    summe(i) = Garchhh(i)+Constantt(i)+Archh(i);
end

max(summe) 
min(summe)

%%
% preallocate VaR vector
returns(1:500) = [];

date = Futurecornprices.Date;

date(1:500) = [];

vars = zeros(numel(quants), numel(returns));

for ii=1:numel(V)
    % get sigma value
    curr_sigma = V(ii);
    vars(:, ii) = norminv(quants',0, curr_sigma);
end


%% Plot returns with exceeds

for ii=1:numel(quants)
    % get exceedances
    exceeds = (returns' <= vars(ii, :));
    
    % include in figure
    figure('position', [50 50 1200 600])
    plot(date( ~exceeds), ...
        returns(~exceeds), '.')
    hold on;
    plot(date( exceeds), ...
        returns(exceeds), '.r', 'MarkerSize', 12)
    datetick 'x'
    set(gca, 'xLim', [date(1) date(end-1)], ...
        'yLim', [-0.15 0.1]);

    %include line for VaR estimations
    hold on;
    plot(date(1:end), vars(ii, :), '-k')

    % calculate exceedance frequency
    frequ = sum(exceeds)/numel(returns);
    
    title(['Versto� Frequenz: ' num2str(frequ, 3)...
        ' anstelle von ' num2str(quants(ii), 3)])
    xlabel('Jahr');
    ylabel('Log-Rendite');
    grid on;
    grid minor;
    
    
end


%% Save Plots as pdf

figure(1000)
exceeds = (returns' <= vars(3, :));
    
    % include in figure

    plot(date( ~exceeds), ...
        returns(~exceeds), '.')
    hold on;
    plot(date( exceeds), ...
        returns(exceeds), '.r', 'MarkerSize', 12)
    datetick 'x'
    set(gca, 'xLim', [date(1) date(end-1)], ...
        'yLim', [-0.15 0.1]);

    % include line for VaR estimations
    hold on;
    plot(date(1:end), vars(3, :), '-k')

    % calculate exceedance frequency
    frequ = sum(exceeds)/numel(returns);
    
    title(['Versto� Frequenz: ' num2str(frequ, 3)...
        ' anstelle von ' num2str(quants(3), 3)])
    xlabel('Jahr');
    ylabel('Log-Rendite');
    grid on;
    grid minor;


plotCounter = '1000';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/Garcheins');

figureNumber = 1000;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

    
%%    
figure(2000)
exceeds = (returns' <= vars(2, :));
    

    plot(date( ~exceeds), ...
        returns(~exceeds), '.')
    hold on;
    plot(date( exceeds), ...
        returns(exceeds), '.r', 'MarkerSize', 12)
    datetick 'x'
    set(gca, 'xLim', [date(1) date(end-1)], ...
        'yLim', [-0.15 0.1]);

    % include line for VaR estimations
    hold on;
    plot(date(1:end), vars(2, :), '-k')

    % calculate exceedance frequency
    frequ = sum(exceeds)/numel(returns);
    
    title(['Versto� Frequenz: ' num2str(frequ, 3)...
        ' anstelle von ' num2str(quants(2), 3)])
    xlabel('Jahr');
    ylabel('Log-Rendite');
    grid on;
    grid minor;
    
plotCounter = '2000';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/Garch2');

figureNumber = 2000;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

    
 
%%    
figure(3000)
exceeds = (returns' <= vars(1, :));
    

    plot(date( ~exceeds), ...
        returns(~exceeds), '.')
    hold on;
    plot(date( exceeds), ...
        returns(exceeds), '.r', 'MarkerSize', 12)
    datetick 'x'
    set(gca, 'xLim', [date(1) date(end-1)], ...
        'yLim', [-0.15 0.1]);

    % include line for VaR estimations
    hold on;
    plot(date(1:end), vars(1, :), '-k')

    % calculate exceedance frequency
    frequ = sum(exceeds)/numel(returns);
    
    title(['Versto� Frequenz: ' num2str(frequ, 3)...
        ' anstelle von ' num2str(quants(1), 3)])
    xlabel('Jahr');
    ylabel('Log-Rendite');
    grid on;
    grid minor;

plotCounter = '3000';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/Garch3');

figureNumber = 3000;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

       
