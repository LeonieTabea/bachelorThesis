%% add common utilities to path

addpath(genpath('../commonUtilities'))
addpath(genpath('../FutureDaten'))
%% Download SP500 stock price data

relDataPath = '../bachelorThesis/';

%%
% specify start and end year of investigation period
dateBeg = 1975;
dateEnd = 2016;

%% specify encoding for maturity month

% specify letters used at quandl
xxLetters = { 'G'; 'J'; 'M'; 'Q'; 'V'; 'Z'};
monthCoding = cell2table(xxLetters, 'VariableNames', {'MonthCode'});

% determine names for months used in the analysis
nameSpecification = 'mmm';
firstOfMonthDates = [2015*ones(6, 1) [2,4,6,8,10,12]' 1*ones(6, 1)];
xxSerialDates = datenum(firstOfMonthDates);
monthNames = table(datestr(xxSerialDates, nameSpecification), ...
    'VariableNames', {'Month'});

monthNameLookupTable = [monthNames monthCoding];

%% get ticker symbols for datasets

% create respective ticker names
dateRange = dateBeg:dateEnd;
nYears = length(dateRange);
allTickerNames = [];
for ii=dateRange(1):dateRange(end)
   for jj=1:6
       % get current ticker name
       thisMonthLetter = monthNameLookupTable.MonthCode{jj};
       thisTickerName = ['CME/GC' thisMonthLetter num2str(ii)];
       
       % add ticker name to list
       allTickerNames = [allTickerNames; thisTickerName];
   end
end

%% download data

% initialize future price table
futurePrices = [];
futureIDs = [];

for ii=1:length(allTickerNames)
    % get current ticker symbol
    thisTicker = allTickerNames(ii, :);
    
    % get valid Matlab identifier for current ticker
    thisTickerName = matlab.lang.makeValidName(thisTicker);
    
    % download this data
    [data, headers] = Quandl.get(thisTicker, 'type', 'data');
    
    % replicate data ticker name
    xxName = cellstr(repmat(thisTickerName, size(data, 1), 1));
    futureIDs = [futureIDs; xxName];
    
    % fix header names
    headerNames = matlab.lang.makeValidName(headers);
    
    % test compliance with existing headerNames
    if ~isempty(futurePrices)
        newColNames = setdiff(headerNames, futurePrices.Properties.VariableNames);
        
        if ~isempty(newColNames)
            % attach new column filled with NaNs to existing table
            nObsSoFar = size(futurePrices, 1);
            nanCols = array2table(NaN(nObsSoFar, length(newColNames)),...
                'VariableNames', newColNames);
            futurePrices = [futurePrices nanCols];
        end
    end
    
    % transform data to table
    thisFuturePrices = array2table(data, 'VariableNames', headerNames);
    
    % append to already existing data
    if isempty(futurePrices)
        futurePrices = [futurePrices; thisFuturePrices];
    else
        futurePrices = hcatUnequalTables(futurePrices, thisFuturePrices);
    end
    
    display(ii/length(allTickerNames))
end

%% attach ticker names

futurePrices.Ticker = futureIDs;

%%

% save to disk
fname = fullfile('../FutureDaten/', 'futurePricesGold.csv');
writetable(futurePrices, fname)

%%

settlePrices = futurePrices(:, {'Date', 'Settle', 'Ticker'});

prices = unstack(settlePrices, 'Settle', 'Ticker');

% important: unstack does not guarantee sorting with regards to dates
prices = sortrows(prices, 'Date'); 

%% get number of zero prices per column

nZeros = varfun(@(x)sum(x == 0), prices(:, 2:end));
nZeros.Properties.VariableNames = tabnames(prices(:, 2:end));

% show futures with zero prices
xxInds = nZeros{1, :} > 0;
nZeros(1, xxInds)

%%

plot(prices.Date, prices{:, 2:end})
datetick 'x'
grid on
grid minor

