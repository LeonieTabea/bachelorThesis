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
ylabel('Log-Renditen');

% Grafik für Gold_Returns
plot(Renditen.Date, Renditen.Gold)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Renditen');

% Grafik für Corn_Returns
plot(Renditen.Date, Renditen.Corn)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Renditen');

% Grafik für Cocoa_Returns
plot(Renditen.Date, Renditen.Cocoa)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Renditen');

% Grafik für Cotton_Returns
plot(Renditen.Date, Renditen.Cotton)
datetick 'x'
grid on
grid minor
xlabel('Jahr'); 
ylabel('Log-Renditen');

%% Histogramme der Log_Renditen

histfit(Renditen.Oil);
histfit(Renditen.Gold);
histfit(Renditen.Corn);
histfit(Renditen.Cocoa);
histfit(Renditen.Cotton);

%% ACF-plots der Log_Renditen

autocorr(Renditen.Oil,200);
autocorr(Renditen.Gold,200);
autocorr(Renditen.Corn,200);
autocorr(Renditen.Cocoa,200);
autocorr(Renditen.Cotton,200);

%% ACF-plots der absoluten Log_Renditen

autocorr(abs(Renditen.Oil),200);
autocorr(abs(Renditen.Gold),200);
autocorr(abs(Renditen.Corn),200);
autocorr(abs(Renditen.Cocoa),200);
autocorr(abs(Renditen.Cotton),200);

%% QQplots der Log_renditen

qqplot(Renditen.Oil);
qqplot(Renditen.Gold);
qqplot(Renditen.Corn);
qqplot(Renditen.Cocoa);
qqplot(Renditen.Cotton);


