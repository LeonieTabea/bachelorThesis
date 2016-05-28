%% Import data from text file.

relDataPath = '../bachelorThesis/';

%% Initialize variables.
filename = '/Users/leoniegoldmann/Desktop/Matlab/SpotPricesRohstoffe.csv';
delimiter = {'\t',' ',';'};

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%q%q%q%q%q%q%[^\n\r]';

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

for col=[2,3,4,5,6]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\.]*)+[\,]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\.]*)*[\,]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers=='.');
                thousandsRegExp = '^\d+?(\.\d{3})*\,{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = strrep(numbers, '.', '');
                numbers = strrep(numbers, ',', '.');
                numbers = textscan(numbers, '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

% Convert the contents of columns with dates to MATLAB datetimes using date
% format string.
try
    dates{1} = datetime(dataArray{1}, 'Format', 'dd.MM.yy', 'InputFormat', 'dd.MM.yy');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{1} = cellfun(@(x) x(2:end-1), dataArray{1}, 'UniformOutput', false);
        dates{1} = datetime(dataArray{1}, 'Format', 'dd.MM.yy', 'InputFormat', 'dd.MM.yy');
    catch
        dates{1} = repmat(datetime([NaN NaN NaN]), size(dataArray{1}));
    end
end

anyBlankDates = cellfun(@isempty, dataArray{1});
anyInvalidDates = isnan(dates{1}.Hour) - anyBlankDates;
dates = dates(:,1);

%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [2,3,4,5,6]);

%% Exclude rows with non-numeric cells
I = ~all(cellfun(@(x) (isnumeric(x) || islogical(x)) && ~isnan(x),rawNumericColumns),2);  %Find rows with non-numeric cells
K = I | anyInvalidDates | anyBlankDates;
dates = cellfun(@(x) x(~K,:), dates, 'UniformOutput', false);
rawNumericColumns(K,:) = [];

%% Create output variable
SpotPricesRohstoffe = table;
SpotPricesRohstoffe.Code = dates{:, 1};
SpotPricesRohstoffe.Oil = cell2mat(rawNumericColumns(:, 1));
SpotPricesRohstoffe.Gold = cell2mat(rawNumericColumns(:, 2));
SpotPricesRohstoffe.Corn = cell2mat(rawNumericColumns(:, 3));
SpotPricesRohstoffe.Cocoa = cell2mat(rawNumericColumns(:, 4));
SpotPricesRohstoffe.Cotton = cell2mat(rawNumericColumns(:, 5));

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

SpotPricesRohstoffe.Code=datenum(SpotPricesRohstoffe.Code);

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me dates blankDates anyBlankDates invalidDates anyInvalidDates rawNumericColumns I J K;