# Cinque video di Wim sull'Ultimate Breakout System: sintesi dalle trascrizioni (31/10/2026)
Fonte: i sottotitoli automatici in inglese (`.vtt`) dei 5 video YouTube incorporati nel commento #95 di Wim sulla pagina MQL5 del prodotto 133653 (zip `video03.zip` di Claudio). **Mancano i frame**: il download del video non e riuscito, quindi niente immagini: i valori mostrati a schermo non sono letti. I titoli sono dedotti dal contenuto (non in elenco); durate dai sottotitoli. Non controllata da agenti.

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
