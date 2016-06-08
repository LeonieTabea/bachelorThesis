%% Grafiken für Stylized Facts der Spot Preise
% 
SpotPricesRohstoffe

% Zeitreihen der Rohstoffe
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe{:, 2:6})
datetick 'x'
grid on
grid minor


SpotPricesRohstoffe(1,2:end)

SpotPricesRohstoffe.Oilnorm = SpotPricesRohstoffe.Oil/26.4;
SpotPricesRohstoffe.Goldnorm = SpotPricesRohstoffe.Gold/309;
SpotPricesRohstoffe.Cornnorm = SpotPricesRohstoffe.Corn/2.59;
SpotPricesRohstoffe.Cocoanorm = SpotPricesRohstoffe.Cocoa/2141.6;
SpotPricesRohstoffe.Cottonnorm = SpotPricesRohstoffe.Cotton/72;

% Zeitreihen der Rohstoffe normiert auf 1
plot(SpotPricesRohstoffe.Code, SpotPricesRohstoffe{:, 7:end})
datetick 'x'
grid on
grid minor
legend(tabnames(SpotPricesRohstoffe(:, 7:end)),'Location','northwest')
xlabel('Jahr'); 
ylabel('Normierter Preis in US Dollar'); 

%%
% LogReturns Grafik 

Renditen = zeros(8087,6);

Renditen(:,1) = price2ret(SpotPricesRohstoffe.Oil);
Renditen(:,2) = price2ret(SpotPricesRohstoffe.Gold);
Renditen(:,3) = price2ret(SpotPricesRohstoffe.Corn);
Renditen(:,4) = price2ret(SpotPricesRohstoffe.Cocoa);
Renditen(:,5) = price2ret(SpotPricesRohstoffe.Cotton);
SpotPricesRohstoffe(8088,:) = []
Renditen(:,6) = SpotPricesRohstoffe.Code;

Renditen = array2table(Renditen)

Renditen.Properties.VariableNames{'Renditen1'} = 'Oil';
Renditen.Properties.VariableNames{'Renditen2'} = 'Gold';
Renditen.Properties.VariableNames{'Renditen3'} = 'Corn';
Renditen.Properties.VariableNames{'Renditen4'} = 'Cocoa';
Renditen.Properties.VariableNames{'Renditen5'} = 'Cotton';
Renditen.Properties.VariableNames{'Renditen6'} = 'Date';


% Grafik für Oil_Returns
plot(Renditen.Date, Renditen.Oil)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Rendite');

% Grafik für Gold_Returns
plot(Renditen.Date, Renditen.Gold)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Rendite');

% Grafik für Corn_Returns
plot(Renditen.Date, Renditen.Corn)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Rendite');

% Grafik für Cocoa_Returns
plot(Renditen.Date, Renditen.Cocoa)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Rendite');

% Grafik für Cotton_Returns
plot(Renditen.Date, Renditen.Cotton)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Rendite');

%% Histogramme der Log_Renditen

a = histfit(Renditen.Oil,100);
xlim([-0.13,0.13]);
a(1).FaceColor = [.8 .8 1];
a(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
xlabel('Log-Rendite'); 
ylabel('Dichte');


b = histfit(Renditen.Gold,100);
xlim([-0.04,0.04]);
b(1).FaceColor = [.8 .8 1];
b(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
xlabel('Log-Rendite'); 
ylabel('Dichte');

c = histfit(Renditen.Corn,100);
xlim([-0.08,0.08]);
c(1).FaceColor = [.8 .8 1];
c(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
xlabel('Log-Rendite'); 
ylabel('Dichte');

d = histfit(Renditen.Cocoa,100);
xlim([-0.07,0.07]);
d(1).FaceColor = [.8 .8 1];
d(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
xlabel('Log-Rendite'); 
ylabel('Dichte');

e = histfit(Renditen.Cotton,100);
xlim([-0.05,0.05]);
e(1).FaceColor = [.8 .8 1];
e(2).Color = [.2 .2 .2];
grid on
grid minor
legend('Log-Rendite', 'Normalverteilung')
xlabel('Log-Rendite'); 
ylabel('Dichte');

%% ACF-plots der Log_Renditen

autocorr(Renditen.Oil,200);
grid on
grid minor

autocorr(Renditen.Gold,200);
grid on
grid minor

autocorr(Renditen.Corn,200);
grid on
grid minor

autocorr(Renditen.Cocoa,200);
grid on
grid minor

autocorr(Renditen.Cotton,200);
grid on
grid minor

%% ACF-plots der absoluten Log_Renditen

autocorr(abs(Renditen.Oil),200);
grid on
grid minor

autocorr(abs(Renditen.Gold),200);
grid on
grid minor

autocorr(abs(Renditen.Corn),200);
grid on
grid minor

autocorr(abs(Renditen.Cocoa),200);
grid on
grid minor

autocorr(abs(Renditen.Cotton),200);
grid on
grid minor

%% QQplots der Log_renditen

qqplot(Renditen.Oil);
xlim([-4,4]);
ylim([-0.4,0.4]);
grid on
grid minor

qqplot(Renditen.Gold);
xlim([-4,4]);
ylim([-0.4,0.4]);
grid on
grid minor

qqplot(Renditen.Corn);
xlim([-4,4]);
ylim([-0.4,0.4]);
grid on
grid minor

qqplot(Renditen.Cocoa);
xlim([-4,4]);
ylim([-0.4,0.4]);
grid on
grid minor

qqplot(Renditen.Cotton);
xlim([-4,4]);
ylim([-0.4,0.4]);
grid on
grid minor

