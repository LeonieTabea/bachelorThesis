%% add common utilities to path

addpath(genpath('../commonUtilities'))
addpath(genpath('../FutureDaten'))
%% Download SP500 stock price data

relDataPath = '../bachelorThesis/';

%%
% specify start and end year of investigation period
dateBeg = 1980;
dateEnd = 2016;

%% specify encoding for maturity month

% specify letters used at quandl
xxLetters = { 'H'; 'K'; 'N'; 'V'; 'Z'};
monthCoding = cell2table(xxLetters, 'VariableNames', {'MonthCode'});

% determine names for months used in the analysis
nameSpecification = 'mmm';
firstOfMonthDates = [2015*ones(5, 1) [3,5,7,10,12]' 1*ones(5, 1)];
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
   for jj=1:5
       % get current ticker name
       thisMonthLetter = monthNameLookupTable.MonthCode{jj};
       thisTickerName = ['ICE/CT' thisMonthLetter num2str(ii)];
       
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
fname = fullfile('../FutureDaten/', 'futurePricesCotton.csv');
writetable(futurePrices, fname)

%%

settlePrices = futurePrices(:, {'Date', 'Settle', 'Ticker'});

prices = unstack(settlePrices, 'Settle', 'Ticker');

% important: unstack does not guarantee sorting with regards to dates
prices = sortrows(prices, 'Date'); 

%%

[nRows, nCols] = size(prices);

% preallocation
lastDateObs = zeros(1,nCols);

for ii=1:nCols
    for jj=1:nRows
        thisVal = prices{jj, ii};
        if ~isnan(thisVal) & ~ (thisVal == 0)
            lastDateObs(1, ii) = prices.Date(jj);
        end
    end
end
 
%%

priceVals = prices{:, :};

validObs = ~isnan(priceVals) & ~ (priceVals == 0);

findLastValFun = @(x)find(x, 1, 'last');

lastObsInds = zeros(1, nCols);
for ii=1:nCols
    lastObsInds(1, ii) = findLastValFun(validObs(:, ii));
end
        
%% Maturity und Datum
datestr(prices.Date(lastObsInds(1, 2)))
datestr(prices.Date(lastObsInds(1, 3)))        
datestr(prices.Date(lastObsInds(1, 4)))        
    

Maturities = prices.Date(lastObsInds(1,:))   

Maturities(1,1)

MaturityDate = zeros(nRows,nCols);

for ii=1:nCols
    for jj=1:nRows
        thisVal = prices{jj, ii};
        if ~isnan(thisVal) & ~ (thisVal == 0)
            MaturityDate(jj, ii) = prices.Date(jj);
        end
    end
end

%% Maturity - prices.Date


MaturityDates = MaturityDate;

for ii=2:nCols
    for jj=1:nRows
        thisVal = MaturityDate(jj, ii);
        if ~isnan(thisVal) & ~ (thisVal == 0)
        MaturityDates(jj, ii) = Maturities(ii)-MaturityDate(jj,ii);
        end
    end
 end

MaturityDates = array2table(MaturityDates);


%% get number of zero prices per column

nZeros = varfun(@(x)sum(x == 0), prices(:, 2:end));
nZeros.Properties.VariableNames = tabnames(prices(:, 2:end));

% show futures with zero prices
xxInds = nZeros{1, :} > 0;
nZeros(1, xxInds)

plot(prices.Date, prices{:, tabnames(nZeros(:, xxInds))})
datetick 'x'
grid on
grid minor

%%

plot(prices.Date, prices{:, 2:end})
datetick 'x'
grid on
grid minor

%% Zeros nur am Ende und Anfang
LocationZeros = [];
for col = prices{:, 2:end}
    notnan = find(~isnan(col)); 
    LocationZeros(end+1) = length(notnan) - (find(col(notnan), 1, 'last') - find(col(notnan), 1, 'first') + 1) == sum(col == 0);
end

any(LocationZeros == false)
%% convert zeros to nan
prices{:,2:end}(prices{:,2:end} == 0) = nan;



