# Cinque video di Wim sull'Ultimate Breakout System: sintesi dalle trascrizioni (31/10/2026)
Fonte: i sottotitoli automatici in inglese (`.vtt`) dei 5 video YouTube incorporati nel commento #95 di Wim sulla pagina MQL5 del prodotto 133653 (zip `video03.zip` di Claudio). Aggiunta 31/10 sera: con gli zip dei frame (un frame ogni 20 s) ho letto anche cio che si vede a schermo in alcuni punti chiave; sono in fondo, sezione IMMAGINI. I titoli dedotti sono risultati giusti (info.json). Non controllata da agenti.

| File | Contenuto (titolo dedotto) | Durata |
|---|---|---|
| video01 | Video Guide: ottimizzazione di una strategia su oro D1 | 34:53 |
| video02 | Risk settings: DD a 0,01 lotti, lot size step, portafoglio bilanciato | 13:26 |
| video03 | Novita v1.2: grid, impostazioni prop, rischio in valuta, adjust lot size to variable values | 22:22 |
| video04 | Portafogli bilanciati con strategie a valori variabili | 15:23 |
| video05 | Novita v5.0: OneChartSetup, MaxRiskPerStrategy, ForceSymbol | 12:08 |

## Metodo di ottimizzazione (video01)
- Terminale MT5 con conto demo MetaQuotes per forex e oro (dati storici buoni); IC Markets per indici e Bitcoin. Dopo, prove su altri broker.
- Tester: EA UBS, XAUUSD **D1**, periodo **2013-2023 (in-sample)**; fuori campione **2004-2012** e **2024-2025**; modello **1 minuto OHLC** (veloce) per ottimizzare, poi test a tick reali su un periodo breve; deposito grande (100k) e leva alta; algoritmo **genetico veloce**; criterio **Custom Max** (expected payoff, recovery factor, numero di operazioni: servono almeno qualche centinaio).
- Durante l ottimizzazione: **lotto fisso** (0,01 forex, 0,1 oro/indici), **niente** filtro spread, filtri notizie, orari. Dopo si controlla quanto peggiorano i risultati accendendoli.
- Usa la **MQL5 Cloud Network** (a pagamento, dal wallet MQL5) per velocita; dopo 10 minuti si guarda se escono strategie decenti, altrimenti si ricomincia con altri valori.
- Selezione: classifica per recovery factor (esempio 17 e buono) o per profitto; si scartano le righe con 3 operazioni. Poi in-sample, OOS 2024-2025, OOS 2004-2012, e **test a tick reali breve**: nell esempio il profitto passa da 93 (1M OHLC) a 48 (tick): la curva deve avere la stessa forma.
- Salva i set come A, B, C (circa un ora per tre strategie), li carica in **Quant Analyzer** (gratuito), sceglie a vista la curva piu parallela a una retta e con il miglior rapporto rendimento/DD (la C).
- Ritocco finale: **al massimo 1-2 parametri** alla volta (esempio: SL/TP con ottimizzazione completa; TP da 1300 a 1650, recovery factor un po piu alto). Poi i filtri NFP/tassi/CPI: si accettano se il peggioramento e piccolo.
- Se non esce niente: altri valori, altro periodo, altri mercati, altri timeframe; D1 e il migliore per swing, piu si scende piu pesano spread e slippage.

## Rischio e portafoglio (video02, video04, video03)
- Lot size step = DD storico a 0,01 lot / DD massimo voluto (esempio 92 / 0,30 = 306, poi arrotondato a 310): 3.000 euro partono a 0,1 lot e il DD a 30% e rispettato (29%). Meglio arrotondare in su: il DD futuro puo superare quello storico.
- Portafoglio: si porta ogni strategia allo stesso DD a minimo lotto (es. circa 300) con Quant Analyzer (what-if sul lotto) e si somma: quattro strategie danno DD 370, non 1.200. Poi dal DD del portafoglio si ricava il lot size step di ciascuna.
- Con `adjust lot size to variable values` (valore variabile = prezzo di riferimento 1.000 sull oro) il lotto **scende al salire del prezzo** per tenere costante il rischio; si ottimizza/si testa a 0,1 lot (non 0,01, altrimenti l effetto non si vede) e si ricava il passo da quel DD.
- Il DD del test a 0,01 lot si divide per 10 solo per il calcolo; il passo si calcola sul lotto di riferimento.

## Funzioni v1.2 e v5.0 (video03, video05)
- **Grid** (martingale opzionale): per l oro il DD di esempio a 0,01 lot e 1.800; Wim non lo usa e lo gestisce a mano. Bisogna spegnere SL e trailing negativi. Parametro di stop di perdita della griglia (0 = mai: rischio di margin call).
- **Impostazioni prop**: chiusura a **equity massima** (target), chiusura a **equity minima**, **max daily drawdown**: considera i trade chiusi **e aperti** del giorno, e quando e superato **chiude solo i trade dell EA stesso** e aspetta il giorno dopo; non tocca gli altri EA. Consiglio: 4 se il limite e 5. (La base del calcolo non e detta.) Randomization: valore unico per tutti i set con l override.
- **Rischio per trade in valuta** (es. 100 USD).
- **OneChartSetup**: set in `Common\Files\Sets`, `ForceSymbol` con il nome esatto del broker, **magic diversi**, timeframe espliciti, tutti i parametri della v5.0; override dei lotti, notizie, orari, prop; `MaxRiskPerStrategy` (es. 5%) con il DD storico a 0,01 lot scritto nel set; tutte le strategie nascono bilanciate a quel DD. Gold Reaper (senza la 9, la piu aggressiva) girato da un solo grafico come esempio.

## Cosa significa per noi
1. **Il limite giornaliero dell EA chiude solo i suoi trade** (risposta alla domanda aperta per Wim), conta anche il flottante e non e il freno di conto: il Guardian resta necessario. Quel video e della v1.2 di UBS: negli EA del bundle non e verificato che funzioni uguale [INFERENZA].
2. **2013-2023 e in-sample** per le strategie costruite col suo metodo: i nostri anni 2013/2018/2020 non sono fuori campione; 2025 si. Il fuori campione 2004-2012 non lo abbiamo mai testato; i dati BCM per quegli anni non sono verificati.
3. **Il suo test 1M OHLC contro tick** (93 contro 48) mostra che i risultati a candele possono sovrastimare di molto: i nostri anni 2013/2018/2020 sono a Modello 1 (solo il 2025 e a tick reali).
4. **Rischio nominale e rischio reale**: i suoi calcoli presuppongono lotti frazionabili; a 3.745 EUR il minimo 0,01 rende il rischio reale molto sopra a quello nominale (22% di DD con MaxRisk 1% per il Gold Trade Pro), come misurato.
5. Il suo metodo e quello standard di ottimizzazione in-sample/out-of-sample e mira alle strategie con curva liscia; rischio di over-ottimizzazione e di scelta a occhio (la sua scelta finale e visiva). Su oro lo storico e quasi sempre in salita: anche un fuori campione lungo (2004-2012) premia i breakout long.
6. Con UBS (EA a pagamento) si potrebbero costruire strategie nuove; con gli EA gia comprati non si ottimizza. Acquisto: decisione di Claudio.

## Cosa NON dice
Solo sottotitoli automatici: possono sbagliare i termini; niente immagini; il video 4 e dedotto e non confrontato con un titolo; nessun numero di Wim e stato riprodotto da noi.

## IMMAGINI (frame ogni 20 s, letti dopo le trascrizioni)
Titoli ufficiali: 1 "Ultimate Breakout System Video Guide" (35:01, 16/05/2025); 2 "Risk settings and portfolio creation" (13:33, 16/05/2025); 3 "V1.2 Overview new features" (22:30, 26/05/2025); 4 "Creating balanced portfolio's: a more detailed overview" (15:30, 09/06/2025); 5 "V5.0 Tutorial" (12:16, 28/04/2026).
- **Tester (video01, 02:20 e 04:20):** EA `Ultimate_Breakout_EA_WSC_V1.0`, XAUUSD, **Daily**, periodo personalizzato **2013.01.01 - 2023.12.21**, forward No, ritardo "zero latency", modellazione **1 minute OHLC**, deposito **100000 USD**, leva **1:500**, ottimizzazione **Fast genetic**, criterio **Custom max**. Terminale MetaQuotes-Demo.
- **Intervalli dell ottimizzazione (video01, 11:20):** prezzo di riferimento per i valori variabili 1000-3000 passo 1000; candele a sinistra/destra del massimo-minimo 2-30 passo 1; massimo di candele nello storico 20-250 passo 10; distanza minima dal massimo/minimo 10-1000 passo 10; pips extra sopra il massimo / sotto il minimo per l ingresso 0-200 passo 5. Totale stimato: **10.496 passate**, con il genetico (1.022 dopo 6 minuti).
- **Risultati (video01, 25:00):** in Quant Analyzer le tre strategie a, b, c su XAUUSD (2004.11-2025.04, 0,01 lot): netto 1.364 / 1.484 / 2.177 USD; operazioni 767 / 390 / 866; profit factor 1,99 / 2,73 / 1,77; DD massimo 63 / 55 / 84 USD; rendimento/DD 21,6 / 27,1 / 25,8. Il DD e in dollari a 0,01 lot: per questo si usa per calcolare il lotto.
- **Grid (video03):** inputs: grid start 50 pips, step 20, Total profit for TP 50, Total pips TP 100, GridMultiplier 1,5 nell esempio. **Impostazioni prop (video03, 09:00):** "Close all trades/stop trading at min equity", "... at max equity", "Max Daily Drawdown", tutte a 0 per default.
- **OneChartSetup (video05, 03:00 e 08:20):** Risk = "use Max Risk Per Strategy", MaxRiskPerStrategy_Value 5.0, "max historical drawdown (in $) at 0.01 lots" 50.0, LotsizeStep 500, maximum lotsize per trade 99, OnlyUp true; presente "Max Randomization for entry and exit". Pannello: 20 set su un solo grafico, **tutti a MaxRiskStrat 5,00%**: Bitcoin Reaper 1-4 (BTCUSD H1, magic 4501-4504), DAX_M15_f, Daytrade Pro su 5 coppie (Daily, 50501-50508), **Gold Reaper 3 (XAUUSD Daily, magic 2003), 4 (H4, 2004), 5 (H1, 2005)**, US30_M15 c/f/h, US500_M15 a/c; i lotti vanno da 0,01 a 2,10 (US500) e l oro ha 0,02-0,06.
- **Conferma:** il Gold Reaper e un insieme di strategie UBS (stessi set e magic nello zip dei set); i nostri EA del bundle sono costruiti col metodo mostrato.
