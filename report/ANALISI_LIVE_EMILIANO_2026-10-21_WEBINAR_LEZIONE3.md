# ANALISI WEBINAR EMILIANO - 21/10/2026 (sera, "terza lezione": recap, mindset, ospite Leonardo Fasciano, testimonianze, offerta del percorso)

**Stato:** scheda del coordinatore, **non controllata da agenti**. Fonte: `data/trascrizioni/WEBINAR_EMILIANO_2026-10-21_lezione3.txt` (copia del file di Claudio `LIVE_EMILIANO_21.10-26_...-570.txt`, 104.458 byte, 39 righe, nessun timestamp) + uno screenshot dello schermo di Leonardo (indicatore TradingView "BULGE BACKTESTER LEO" su GBPCHF H1).

> **Da questo materiale non si muove NIENTE.** Ogni numero e una **[DICHIARAZIONE DEL RELATORE]**, non verificata. Nessun EA, preset, sedia o conto toccato.

## 0. Natura del documento
Per circa il 70% e una **vendita del percorso** (Forex Evolution/Abiforex): "6.500 euro" (la frase e "6500 euro per IVA": non chiaro se IVA inclusa), "valore 12.664 euro" (Abiforex 3.470 + percorso 4.500 + licenze algoritmi 1.000 + Trading Concierge 1.224 + Dr. Mind 2.470), 10 slot di coaching one-to-one a patto di avere un conto da 5-10 mila euro, scadenza di pressione ("la decisione va presa ora", "fino a venerdi"). Testimonianze: 10.000 euro raddoppiati in 19 giorni; 100 euro -> 1.000 in due mesi. Leonardo dichiara "137% nell'anno, dati ufficiali". Nessuno statement allegato: tutto **[NON VERIFICATO]**.
Sugli EA il relatore dice: "gli expert advisor lasciateli stare", "io ho le strategie in automatico ma le tengo per me ... in Italia e vietato darle". **Conflitto di interesse** da tenere presente quando legge cose sugli EA.

## 1. Cosa c'e di tecnico (e cosa dice il repo)
| # | cosa dice | rapporto con il nostro lavoro | misurabile? |
|---|---|---|---|
| N1 | **Nasdaq, apertura americana (15:25 IT, cioe 14:25 server BCM per la regola di casa)**: candela M5, due pendenti a 10 punti oltre massimo e minimo; **candela fra 17 e 38 punti**, sotto "ti prende entrambi gli ordini", sopra "lo stop e troppo ampio" | Il nostro EA ha gia `InpMinRangePts` e `InpMaxRangePts` (nei default live: 1700 = 17 punti e 4000 = 40 punti). **Nelle celle di prova R274/R276 sono a 0 (spenti)** [LETTO nel file prova R276b]. Il preset realmente in uso sulla sedia: [NON VERIFICATO oggi]. | Si: R274 con filtro 17-38 acceso contro spento |
| N2 | **Piano B**: se i due pendenti vengono eseguiti entrambi, **si aggiunge un ordine della stessa quantita** oltre il livello con lo stop sopra i due | E mediazione/recupero: **contro la nostra regola di scarto (C)**. Non si adotta. | No (non si fa) |
| N3 | **Piano A**: dopo ~50 punti in 1-2 minuti si porta lo stop a pari, si chiude meta posizione e il resto in trailing; sul DAX meta a 20 punti | Gia noto: chiusura parziale 50% (`InpTP1_ClosePct`). R276 ha trovato che a 0,1 lotti il 50% non e eseguibile. | Gia misurato |
| N4 | **Stop a tempo: "tutte le operazioni che superano 6 minuti vanno in stop"** (scoperto da un loro strumento di IA sul suo statement) | Non e nel nostro EA. [DICHIARATO], una sola fonte, nessun dato. | Si, come ipotesi: uscita se non in profitto entro N minuti (serve il per-trade con orario di ingresso; oggi abbiamo solo l'orario di chiusura) |
| N5 | **Filtro di direzione: si opera solo se candela weekly e daily vanno nello stesso verso**, poi H4/H1 per le confluenze | Non e nel nostro EA (abbiamo un filtro EMA su H4). | Si: filtro W1+D1 su R274 |
| N6 | **Rischio variabile**: 3-4% "in condizioni normali", "5-10% quando l'operazione e A+" | Contrario alla nostra regola: nessuna taglia, nessun rischio variabile deciso a discrezione. | No |
| N7 | **Indicatore "Bulge backtester"** (screenshot): dopo espansione + contrazione delle Bollinger H1 su cross forex, tabella di % storiche per Continuazione e Inversione (storico, 12 mesi, 6 mesi, 3 mesi) e una "valutazione ponderata"; soglia dichiarata "almeno 78-80%" per entrare, 67% = "da evitare" | Parente del nostro Bulge (R92, telemetria). L'unica metrica e la **% di vincenti**, senza guadagno medio, senza costi, senza intervallo di confidenza. Dallo screenshot i campioni sono di **decine di casi e di poche unita a 3 mesi** [LETTO, cifre piccole da confermare]. Dalla tabella: valutazione ponderata continuazione 67,9% "da evitare", inversione 70,0% "OK" mentre a voce dice 76% [INCERTO]. | Si, ma e gia il nostro lavoro sul Bulge |

## 2. Cosa NON c'e (come nella lezione 2)
Nessuno statement, nessun costo di spread/slippage, nessuna perdita reale mostrata oltre a "-170 e +600 su 20.000 (3%)" della giornata. Oggi, dice, "difficile, mercato fermo in apertura americana".

## 3. Cosa propongo (decisione di Claudio, nessuna riga lanciata)
1. N1 e la voce piu utile e piu semplice: una R274 con filtro range 17-38 acceso contro spento sul Nasdaq (stesse celle, stesso periodo), previsioni da scrivere prima. Prima va verificato quale valore ha il preset vivo.
2. N5 (filtro W1+D1) e N4 (stop a tempo) come ipotesi in coda, dopo il filtro range.
3. N2, N6: scartati per regola.
