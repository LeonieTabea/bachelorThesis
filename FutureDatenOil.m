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
xxLetters = {'F'; 'G'; 'H'; 'J'; 'K'; 'M'; 'N'; 'Q'; 'U'; 'V'; 'X'; 'Z'};
monthCoding = cell2table(xxLetters, 'VariableNames', {'MonthCode'});

% determine names for months used in the analysis
nameSpecification = 'mmm';
firstOfMonthDates = [2015*ones(12, 1) (1:12)' 1*ones(12, 1)];
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
   for jj=1:12
       % get current ticker name
       thisMonthLetter = monthNameLookupTable.MonthCode{jj};
       thisTickerName = ['CME/CL' thisMonthLetter num2str(ii)];
       
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
fname = fullfile('../FutureDaten/', 'futurePrices.csv');
writetable(futurePrices, fname)

%%

settlePrices = futurePrices(:, {'Date', 'Settle', 'Ticker'});

prices1 = unstack(settlePrices, 'Settle', 'Ticker');



% important: unstack does not guarantee sorting with regards to dates
prices1 = sortrows(prices1, 'Date'); 

%% 


% extract prices as matrix
priceVals = prices1{:, :};

% find valid observations: neither NaN nor 0
validObs = ~isnan(priceVals) & ~ (priceVals == 0);

% define function to find last valid observation in column vector
findLastValFun = @(x)find(x, 1, 'last');

% apply function to each column to find last observation
[nRows, nCols] = size(prices1);
lastObsInds = zeros(1, nCols);
for ii=1:nCols
    lastObsInds(1, ii) = findLastValFun(validObs(:, ii));
end

% get respective dates to get maturities
Maturities = prices1.Date(lastObsInds(1,:));

% replicate date column
dats = repmat(prices1.Date, 1, nCols);

% get distance to maturity
xxMaturs = repmat(Maturities', nRows, 1);
MaturityDates = xxMaturs - dats;

%%

% include real dates again
MaturityDates(:, 1) = prices1.Date;

%%

% set unrequired values to NaN
MaturityDates(MaturityDates < 0) = NaN;

%%
% make table
maturitiestable = array2table(MaturityDates);
maturitiestable.Properties.VariableNames = tabnames(prices1);

%%

% make long format for prices and maturity dates
longMaturities = stack(maturitiestable, tabnames(maturitiestable(:, 2:end)),...
    'NewDataVariableName','TimeToMaturity',...
    'IndexVariableName','FutureID');

% make prices to long format
longPrices = stack(prices1, tabnames(prices1(:, 2:end)),...
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
SpotPricesRohstoffe.Gold = []
SpotPricesRohstoffe.Cocoa = []
SpotPricesRohstoffe.Corn = []
SpotPricesRohstoffe.Cotton = []

% sort SpotPrices
SpotPricesRohstoffe = sortrows(SpotPricesRohstoffe, 'Date');

%%
%Add spot prices to long format

pricesAndMaturitiesAndspotprices1 = outerjoin(pricesAndMaturities,SpotPricesRohstoffe, 'Keys', {'Date'},...
    'MergeKeys', true, 'Type', 'left');
%%
% Add new Column (Futureprice-spotprice) to pricesAndMaturitiesAndspotprices

pricesAndMaturitiesAndspotprices1.PriceDifference = pricesAndMaturitiesAndspotprices1.FuturePrices - pricesAndMaturitiesAndspotprices1.Oil;

% TestGrafik time to maturity & Price Difference
plot(pricesAndMaturitiesAndspotprices1.TimeToMaturity,pricesAndMaturitiesAndspotprices1.PriceDifference)

%% Testplot maturity & Price Difference getrennt nach FutureID

x5 = pricesAndMaturitiesAndspotprices1(:, {'TimeToMaturity', 'FutureID', 'PriceDifference'});

x1 = unstack(x5,'PriceDifference','FutureID');
x1 = sortrows(x1, 'TimeToMaturity');

figure
plot(x1.TimeToMaturity, x1{:, 2:end},'-')

%% get number of zero prices per column

nZeros = varfun(@(x)sum(x == 0), prices1(:, 2:end));
nZeros.Properties.VariableNames = tabnames(prices1(:, 2:end));

% show futures with zero prices
xxInds = nZeros{1, :} > 0;
nZeros(1, xxInds)

plot(prices1.Date, prices1{:, tabnames(nZeros(:, xxInds))})
datetick 'x'
grid on
grid minor



%% Zeros nur am Ende und Anfang
LocationZeros = [];
for col = prices1{:, 2:end}
    notnan = find(~isnan(col)); 
    LocationZeros(end+1) = length(notnan) - (find(col(notnan), 1, 'last') - find(col(notnan), 1, 'first') + 1) == sum(col == 0);
end

any(LocationZeros == false)
%% convert zeros to nan
prices1{:,2:end}(prices1{:,2:end} == 0) = nan;
%%
figure(33)
plot(prices1.Date, prices1{:, 2:end})
datetick 'x'
grid on
grid minor




%% Plot without Nans 
figure
[nRows, nCols] = size(x1);
figure(200)
y = x1{:,1}
hold on
for ii=2:nCols
    y = x1{:,1}
    thisval =x1{:,ii}
   plot(y(~isnan(thisval)),thisval(~isnan(thisval)));
   grid on
   grid minor
end



%% difference at time t=0 & maturity

maturity = pricesAndMaturitiesAndspotprices1{:,4}==0;
maturity1 = [pricesAndMaturitiesAndspotprices1(maturity,1)]

pricediff = pricesAndMaturitiesAndspotprices1{:,4}==0;
pricediff1 = [pricesAndMaturitiesAndspotprices1(pricediff,6)]

A = table2array(maturity1)
B = table2array(pricediff1)
newtable1 = table(A, B)

figure
plot(newtable1{:,1}, newtable1{:, 2:end},'o')
datetick 'x'
grid on
grid minor




