%% Grafiken für Stylized Facts der Spot Preise
% 
SpotPricesRohstoffe

% Zeitreihen der Rohstoffe
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe{:, 2:6})
datetick 'x'
grid on
grid minor

%% Subplot Rohstoffpreise
figure(79)

subplot(2,2,1)
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe.Oil)
datetick 'x'
xlabel('Jahr'); 
ylabel('Preis in US Dollar'); 
title('Rohöl');
grid on
grid minor

subplot(2,2,2)
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe.Gold)
datetick 'x'
xlabel('Jahr'); 
ylabel('Preis in US Dollar'); 
title('Gold');
grid on
grid minor

subplot(2,2,3)
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe.Cocoa)
datetick 'x'
xlabel('Jahr'); 
ylabel('Preis in US Dollar'); 
title('Kakao');
grid on
grid minor

subplot(2,2,4)
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe.Cotton)
datetick 'x'
xlabel('Jahr'); 
ylabel('Preis in US Dollar'); 
title('Baumwolle');
grid on
grid minor

plotCounter = '79';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/subplotspreise');

figureNumber = 79;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')



%%

SpotPricesRohstoffe(1,2:end)

SpotPricesRohstoffe.Oilnorm = SpotPricesRohstoffe.Oil/26.4;
SpotPricesRohstoffe.Goldnorm = SpotPricesRohstoffe.Gold/309;
SpotPricesRohstoffe.Cornnorm = SpotPricesRohstoffe.Corn/2.59;
SpotPricesRohstoffe.Cocoanorm = SpotPricesRohstoffe.Cocoa/2141.6;
SpotPricesRohstoffe.Cottonnorm = SpotPricesRohstoffe.Cotton/72;


SpotPricesRohstoffe.Properties.VariableNames = tabnames(SpotPricesRohstoffe);

% Zeitreihen der Rohstoffe normiert auf 1

figure(1)
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe{:, 7:end})
datetick 'x'
grid on
grid minor
legend('Rohöl','Gold','Mais','Kakao','Baumwolle','Location','northwest')
xlabel('Jahr'); 
ylabel('Normierter Preis in US Dollar'); 

plotCounter = '1';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/PreiseNormiert');

figureNumber = 1;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')




%%
% LogReturns Grafik 

Renditen = zeros(8087,6);

Renditen(:,1) = price2ret(SpotPricesRohstoffe.Oil);
Renditen(:,2) = price2ret(SpotPricesRohstoffe.Gold);
Renditen(:,3) = price2ret(SpotPricesRohstoffe.Corn);
Renditen(:,4) = price2ret(SpotPricesRohstoffe.Cocoa);
Renditen(:,5) = price2ret(SpotPricesRohstoffe.Cotton);
SpotPricesRohstoffe(1,:) = []
Renditen(:,6) = SpotPricesRohstoffe.Code;

Renditen = array2table(Renditen)

Renditen.Properties.VariableNames{'Renditen1'} = 'Oil';
Renditen.Properties.VariableNames{'Renditen2'} = 'Gold';
Renditen.Properties.VariableNames{'Renditen3'} = 'Corn';
Renditen.Properties.VariableNames{'Renditen4'} = 'Cocoa';
Renditen.Properties.VariableNames{'Renditen5'} = 'Cotton';
Renditen.Properties.VariableNames{'Renditen6'} = 'Date';

%% Table values

min(Renditen.Corn);
max(Renditen.Corn);
mean(Renditen.Corn);
var(Renditen.Corn);
skewness(Renditen.Corn);
kurtosis(Renditen.Corn) - 3;

min(Renditen.Oil);
max(Renditen.Oil);
mean(Renditen.Oil);
var(Renditen.Oil);
skewness(Renditen.Oil);
kurtosis(Renditen.Oil) - 3;


min(Renditen.Gold);
max(Renditen.Gold);
mean(Renditen.Gold);
var(Renditen.Gold);
skewness(Renditen.Gold);
kurtosis(Renditen.Gold) - 3;

min(Renditen.Cotton);
max(Renditen.Cotton);
mean(Renditen.Cotton);
var(Renditen.Cotton);
skewness(Renditen.Cotton);
kurtosis(Renditen.Cotton) - 3;

min(Renditen.Cocoa);
max(Renditen.Cocoa);
mean(Renditen.Cocoa);
a = var(Renditen.Cocoa);
skewness(Renditen.Cocoa);
kurtosis(Renditen.Cocoa) - 3;


%% subplot
% Grafik für alle außer corn
figure(2)
subplot(2,2,1)
plot(Renditen.Date, Renditen.Oil)
datetick 'x'
grid on
grid minor
title('Rohöl');
xlabel('Jahr'); 
ylabel('Log-Rendite');
subplot(2,2,2)
plot(Renditen.Date, Renditen.Gold)
datetick 'x'
grid on
grid minor
title('Gold');
xlabel('Jahr'); 
ylabel('Log-Rendite');
subplot(2,2,3)
plot(Renditen.Date, Renditen.Cocoa)
datetick 'x'
grid on
grid minor
title('Kakao');
xlabel('Jahr'); 
ylabel('Log-Rendite');
subplot(2,2,4)
plot(Renditen.Date, Renditen.Cotton)
datetick 'x'
grid on
grid minor
title('Baumwolle');
xlabel('Jahr'); 
ylabel('Log-Rendite');

plotCounter = '2';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/SubplotsRenditen');

figureNumber = 2;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')



%%
% Grafik für Mais_Returns
figure(3)
plot(Renditen.Date, Renditen.Corn)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Rendite');

plotCounter = '3';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/returnsCorn');

figureNumber = 3;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')



%% Histogramme der Log_Renditen

figure(4)
subplot(2,2,1)
a = histfit(Renditen.Oil,100);
xlim([-0.13,0.13]);
a(1).FaceColor = [.8 .8 1];
a(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
title('Rohöl');
xlabel('Log-Rendite'); 
ylabel('Dichte');




subplot(2,2,2)
b = histfit(Renditen.Gold,100);
xlim([-0.04,0.04]);
b(1).FaceColor = [.8 .8 1];
b(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
title('Gold');
xlabel('Log-Rendite'); 
ylabel('Dichte');


subplot(2,2,3)
d = histfit(Renditen.Cocoa,100);
xlim([-0.07,0.07]);
d(1).FaceColor = [.8 .8 1];
d(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
title('Kakao');
xlabel('Log-Rendite'); 
ylabel('Dichte');

subplot(2,2,4)
e = histfit(Renditen.Cotton,100);
xlim([-0.05,0.05]);
e(1).FaceColor = [.8 .8 1];
e(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
title('Baumwolle');
xlabel('Log-Rendite'); 
ylabel('Dichte');

plotCounter = '4';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/SubplotsHist');

figureNumber = 4;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

%% Grafik Mais Histogramm Renditen

figure(5)
c = histfit(Renditen.Corn,100);
xlim([-0.08,0.08]);
c(1).FaceColor = [.8 .8 1];
c(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
xlabel('Log-Rendite'); 
ylabel('Dichte');

plotCounter = '5';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/histCorn');

figureNumber = 5;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')






%% ACF-plots der Log_Renditen
figure(6)
subplot(2,2,1)
autocorr(Renditen.Oil,200);
grid on
grid minor
title('Rohöl');


subplot(2,2,2)
autocorr(Renditen.Gold,200);
grid on
grid minor
title('Gold');


subplot(2,2,3)
autocorr(Renditen.Cocoa,200);
grid on
grid minor
title('Kakao');




subplot(2,2,4)
autocorr(Renditen.Cotton,200);
grid on
grid minor
title('Baumwolle');
plotCounter = '6';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/Subplotautocorr');

figureNumber = 6;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

%% ACF Plot Mais logrendite
figure(7)
autocorr(Renditen.Corn,200);
title('');
grid on
grid minor

plotCounter = '7';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/autocorrCorn');

figureNumber = 7;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')


%% ACF-plots der absoluten Log_Renditen
figure(8)
subplot(2,2,1)
autocorr(abs(Renditen.Oil),200);
grid on
grid minor
title('Rohöl');

subplot(2,2,2)
autocorr(abs(Renditen.Gold),200);
grid on
grid minor
title('Gold');

subplot(2,2,3)
autocorr(abs(Renditen.Cocoa),200);
grid on
grid minor
title('Kakao');

subplot(2,2,4)
autocorr(abs(Renditen.Cotton),200);
grid on
grid minor
title('Baumwolle');

plotCounter = '8';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/Subplotsautocorrabs');

figureNumber = 8;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

%% PLot abs renditen Mais 

figure(9)
autocorr(abs(Renditen.Corn),200);
title('');
grid on
grid minor

plotCounter = '9';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/autocorrabsCorn');

figureNumber = 9;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')


%% QQplots der Log_renditen

figure(10)
subplot(2,2,1)
qqplot(Renditen.Oil);
xlim([-4,4]);
ylim([-0.4,0.4]);
title('Rohöl');
grid on
grid minor

subplot(2,2,2)
qqplot(Renditen.Gold);
xlim([-4,4]);
ylim([-0.4,0.4]);
title('Gold');
grid on
grid minor


subplot(2,2,3)
qqplot(Renditen.Cocoa);
xlim([-4,4]);
ylim([-0.4,0.4]);
title('Kakao');
grid on
grid minor



subplot(2,2,4)
qqplot(Renditen.Cotton);
xlim([-4,4]);
ylim([-0.4,0.4]);
title('Baumwolle')
grid on
grid minor

plotCounter = '10';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/subplotsqqplot');

figureNumber = 10;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')


%% QQ plot corn

figure(11)
qqplot(Renditen.Corn);
xlim([-4,4]);
ylim([-0.4,0.4]);
title('');
grid on
grid minor

plotCounter = '11';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/qqplotCorn');

figureNumber = 11;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')



%%

figure(100)
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe.Corn)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Preis in US Dollar'); 

plotCounter = '100';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/PreiseCorn');

figureNumber = 100;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')

%% Grafik für abs acf kakao ab 1995

kakao2 = Renditen.Cocoa(2787:end);

figure(77)
autocorr(abs(kakao2),200);
grid on
grid minor
title('Kakao');

plotCounter = '77';

figNumCmd = ['-f' num2str(plotCounter)];
print(figNumCmd, '-painters', '-dpdf','../Grafiken Final/acfabskakaozwei');

figureNumber = 77;

f = figure(figureNumber);
orient landscape
xx = zeros(4,1);
xx(3:4) = get(gcf,'PaperSize');
set(gcf,'PaperPosition',xx)
set(f,'units',get(gcf,'PaperUnits'),'Position',xx,'Visible','off')
