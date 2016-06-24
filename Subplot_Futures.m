%% Subplots Price Diff 

figure(22)

subplot(2,2,1)
[nRows1, nCols1] = size(x1);

y = x1{:,1}
hold on
for ii=2:nCols1
    y = x1{:,1}
    thisval =x1{:,ii}
   plot(y(~isnan(thisval)),thisval(~isnan(thisval)));
   xlabel('Tage bis zur Maturity'); 
   ylabel('Differenz von Future- und Spotpreis');
   title('Rohöl');
   xlim([0 3400]);
   grid on
   grid minor
end

subplot(2,2,2)
[nRows2, nCols2] = size(x2);

yy = x2{:,1}
hold on
for ii=2:nCols2
    yy = x2{:,1}
    thisval =x2{:,ii}
   plot(yy(~isnan(thisval)),thisval(~isnan(thisval)));
   xlabel('Tage bis zur Maturity'); 
   ylabel('Differenz von Future- und Spotpreis');
   title('Gold');
   xlim([0 2000]);
   grid on
   grid minor
end




subplot(2,2,3)
[nRows3, nCols3] = size(x3);

yyy = x3{:,1}
hold on
for ii=2:nCols3
    yyy = x3{:,1}
    thisval =x3{:,ii}
   plot(yyy(~isnan(thisval)),thisval(~isnan(thisval)));
   xlabel('Tage bis zur Maturity'); 
   ylabel('Differenz von Future- und Spotpreis');
   title('Kakao');
   xlim([0 750]);
   grid on
   grid minor
end

subplot(2,2,4)
[nRows4, nCols4] = size(x4);
yyyy = x4{:,1}
hold on
for ii=2:nCols4
    yyyy = x4{:,1}
    thisval =x4{:,ii}
   plot(yyyy(~isnan(thisval)),thisval(~isnan(thisval)));
   xlabel('Tage bis zur Maturity'); 
   ylabel('Differenz von Future- und Spotpreis');
   title('Baumwolle');
   xlim([0 1100]);
   grid on
   grid minor
end

plotCounter = '22';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/subplotspotvsmaturity');

figureNumber = 22;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')



%% Subplots Futureprices
figure(20)
subplot(2,2,3)
plot(prices3.Date, prices3{:, 2:end})
datetick 'x'
title('Kakao');
xlabel('Jahr');
ylabel('Preis in US Dollar');
grid on
grid minor

subplot(2,2,2)
plot(prices2.Date, prices2{:, 2:end})
datetick 'x'
title('Gold');
xlabel('Jahr');
ylabel('Preis in US Dollar');
grid on
grid minor

subplot(2,2,1)
plot(prices1.Date, prices1{:, 2:end})
datetick 'x'
title('Rohöl');
xlabel('Jahr');
ylabel('Preis in US Dollar');
grid on
grid minor

subplot(2,2,4)
plot(prices4.Date, prices4{:, 2:end})
datetick 'x'
title('Baumwolle');
xlabel('Jahr');
ylabel('Preis in US Dollar');
grid on
grid minor

plotCounter = '20';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/subplotFutureprices');

figureNumber = 20;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')


%% Subplots Price-Difference at Maturity
figure(21)

subplot(2,2,1)
plot(newtable1{:,1}, newtable1{:, 2:end},'o')
datetick 'x'
title('Rohöl');
xlabel('Maturity-Datum'); 
ylabel('Preisdifferenz');
xlim([724990 737791]);
grid on 
grid minor


subplot(2,2,3)
plot(newtable3{:,1}, newtable3{:, 2:end},'o')
datetick 'x'
title('Kakao');
xlabel('Maturity-Datum'); 
ylabel('Preisdifferenz');
grid on
grid minor

subplot(2,2,2)
plot(newtable2{:,1}, newtable2{:, 2:end},'o')
datetick 'x'
title('Gold');
xlabel('Maturity-Datum'); 
ylabel('Preisdifferenz');
grid on
grid minor

subplot(2,2,4)
plot(newtable4{:,1}, newtable4{:, 2:end},'o')
datetick 'x'
title('Baumwolle');
xlabel('Maturity-Datum'); 
ylabel('Preisdifferenz');
grid on
grid minor

plotCounter = '21';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/subplotPriceDiffMaturity');

figureNumber = 21;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

