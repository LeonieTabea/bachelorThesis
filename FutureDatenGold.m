%% add common utilities to path

addpath(genpath('../commonUtilities'))
addpath(genpath('../FutureDaten'))
%% Download SP500 stock price data

relDataPath = '../bachelorThesis/';

%%
% specify start and end year of investigation period
dateBeg = 1985;
dateEnd = 2015;

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

prices2 = unstack(settlePrices, 'Settle', 'Ticker');

% important: unstack does not guarantee sorting with regards to dates
prices2 = sortrows(prices2, 'Date'); 

%% 


% extract prices as matrix
priceVals = prices2{:, :};

% find valid observations: neither NaN nor 0
validObs = ~isnan(priceVals) & ~ (priceVals == 0);

% define function to find last valid observation in column vector
findLastValFun = @(x)find(x, 1, 'last');

% apply function to each column to find last observation
[nRows, nCols] = size(prices2);
lastObsInds = zeros(1, nCols);
for ii=1:nCols
    lastObsInds(1, ii) = findLastValFun(validObs(:, ii));
end

% get respective dates to get maturities
Maturities = prices2.Date(lastObsInds(1,:));

% replicate date column
dats = repmat(prices2.Date, 1, nCols);

% get distance to maturity
xxMaturs = repmat(Maturities', nRows, 1);
MaturityDates = xxMaturs - dats;

%%

% include real dates again
MaturityDates(:, 1) = prices2.Date;

%%

% set unrequired values to NaN
MaturityDates(MaturityDates < 0) = NaN;

%%
% make table
maturitiestable = array2table(MaturityDates);
maturitiestable.Properties.VariableNames = tabnames(prices2);

%%

% make long format for prices and maturity dates
longMaturities = stack(maturitiestable, tabnames(maturitiestable(:, 2:end)),...
    'NewDataVariableName','TimeToMaturity',...
    'IndexVariableName','FutureID');

% make prices to long format
longPrices = stack(prices2, tabnames(prices2(:, 2:end)),...
    'NewDataVariableName','FuturePrices',...
    'IndexVariableName','FutureID');

% remove invalid prices
invalidObs = isnan(longPrices.FuturePrices) | longPrices.FuturePrices == 0;
longPrices = longPrices(~invalidObs, :);

%%
%
pricesAndMaturities = outerjoin(longPrices, longMaturities, 'Keys', {'Date', 'FutureID'},...
    'MergeKeys', true, 'Type', 'left');

%% 
% Change Variable Name  

SpotPricesRohstoffe.Properties.VariableNames{'Code'} = 'Date';


% Delete cocoa, gold etc. 
SpotPricesRohstoffe.Cotton = []
SpotPricesRohstoffe.Cocoa = []
SpotPricesRohstoffe.Corn = []
SpotPricesRohstoffe.Oil = []

% sort SpotPrices
SpotPricesRohstoffe = sortrows(SpotPricesRohstoffe, 'Date');

%%
%Add spot prices to long format

pricesAndMaturitiesAndspotprices2 = outerjoin(pricesAndMaturities,SpotPricesRohstoffe, 'Keys', {'Date'},...
    'MergeKeys', true, 'Type', 'left');
%%
% Add new Column (Futureprice-spotprice) to pricesAndMaturitiesAndspotprices

pricesAndMaturitiesAndspotprices2.PriceDifference = pricesAndMaturitiesAndspotprices2.FuturePrices - pricesAndMaturitiesAndspotprices2.Gold;

% TestGrafik time to maturity & Price Difference
plot(pricesAndMaturitiesAndspotprices2.TimeToMaturity,pricesAndMaturitiesAndspotprices2.PriceDifference)

%% Testplot maturity & Price Difference getrennt nach FutureID

x5 = pricesAndMaturitiesAndspotprices2(:, {'TimeToMaturity', 'FutureID', 'PriceDifference'});

x2 = unstack(x5,'PriceDifference','FutureID');
x2 = sortrows(x2, 'TimeToMaturity');


plot(x2.TimeToMaturity, x2{:, 2:end},'-')
grid on
grid minor

%% get number of zero prices per column

nZeros = varfun(@(x)sum(x == 0), prices2(:, 2:end));
nZeros.Properties.VariableNames = tabnames(prices2(:, 2:end));

% show futures with zero prices
xxInds = nZeros{1, :} > 0;
nZeros(1, xxInds)

%%

figure(33)
plot(prices2.Date, prices2{:, 2:end})
datetick 'x'
grid on
grid minor


%% plot without Nans

[nRows, nCols] = size(x2);

y = x2{:,1}
hold on
for ii=2:nCols
    y = x2{:,1}
    thisval =x2{:,ii}
   plot(y(~isnan(thisval)),thisval(~isnan(thisval)));
   grid on
   grid minor
end





%% difference at time t=0 & maturity

maturity = pricesAndMaturitiesAndspotprices2{:,4}==0;
maturity1 = [pricesAndMaturitiesAndspotprices2(maturity,1)]

pricediff = pricesAndMaturitiesAndspotprices2{:,4}==0;
pricediff1 = [pricesAndMaturitiesAndspotprices2(pricediff,6)]

A = table2array(maturity1)
B = table2array(pricediff1)
newtable2 = table(A, B)


plot(newtable2{:,1}, newtable2{:, 2:end},'o')
datetick 'x'
grid on
grid minor

