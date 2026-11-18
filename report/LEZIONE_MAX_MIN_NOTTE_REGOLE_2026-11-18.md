# Strategia MAX-MIN della notte: regole dai PDF del corso (18/11/2026)
Fonti: `014_Piano_Trading_-_MAX-MIN_ABTG.pdf` (piano scritto, 5 pagine) e `010_ABTG-MAX-MIN_20250925.pdf` (slide del 07/05/2025, 17 pagine; letta fino a pag. 12 circa). Nessun giudizio su lotti/taglie. Dove il PDF non dice: NON SPECIFICATO.

## Regole OGGETTIVE (testabili)
- **Strumenti:** DAX (esempio principale), Dow, SPX500, Nasdaq; anche coppie valutarie volatili.
- **Livelli:** massimo e minimo della **sessione notturna**; il piano dice due finestre diverse: **02:00-07:59:59 CET/CEST (6 candele H1)** (strategia e slide) e **00:00-05:59 CET/CEST** (punto ii delle regole di ingresso): **CONTRADDIZIONE da chiarire**. Anche massimo/minimo del **giorno precedente**.
- **Ordini pendenti** piazzati prima dell'apertura (ore **08:59 CET** per l'apertura europea): **BUY STOP a massimo notte + 10 punti, SELL STOP a minimo notte - 10 punti** (15-20 punti per indici piu volatili come il Dow). Il piano scritto dice "Short sotto i minimi, Long sopra i massimi" = breakout. **Alternativa REVERSAL (SELL/BUY LIMIT sui bordi) solo con conferma dei mercati correlati ("condizione sine qua non") = DISCREZIONALE.** (Le slide parlano di PIP, il piano di PUNTI: sugli indici si intende punti.)
- **Stop loss:** nelle slide **±30 punti**; nel piano "sopra/sotto le ultime candele significative M15-H1", **ATR M15**, **a meta canale se maggiore dell'ATR**.
- **Target (esempio DAX):** 1° **30 punti (R/R 1:1, prudente)**, 2° **87 punti (50% della volatilita)**, 3° **113 punti (EMA 200)**; chiusura parziale al 1°, stop sul profitto al raggiungimento del 2°; **trade chiuso alle 11:45 CET (durata ~3 h)** nell'esempio.
- **Finestre operative:** apertura europea **9:00-11:00** e americana **15:30-17:00**; gli ordini non scattati vanno rimossi **prima di dati macro importanti o entro le 18:30**.
- **Money management:** 2% di rischio per operazione, R/R minimo 1:2 (piano scritto) / >= 1:1 (slide), drawdown massimo 2%.
- **Obiettivo prima del reale (dal piano):** > 70% di operazioni vincenti su almeno 30 in demo.

## Regole DISCREZIONALI (non testabili cosi)
Correlazioni con SPX500/Nikkei/Dow ("se i tre indici rompono insieme...", "falso breakout se...", "reversal solo se S&P rimbalza su un supporto"), lettura "momentum forte/debole" per trailing o chiusura parziale, esclusione per "mercato laterale / volumi bassi" (segnali: candele piccole, range stretti, triangoli), supply & demand, ABTG Opposing "tracciato a mano", copertura in hedging.

## Cose NON specificate
Cancellazione dell'ordine opposto dopo l'esecuzione (OCO) e riarmo; dimensione delle tre parti; EMA 200 su quale timeframe; come si definisce "momentum forte"; filtro notizie esatto; orario di uscita a fine giornata (11:45 e solo un esempio).

## Legame con quello che abbiamo
Esiste gia l'EA `ABTG_MaxMinNotte` (+ `_DAX_Short_Ottimizzato`): nel demo, MAXMIN DAX SHORT 8 operazioni +168 EUR, MAXMIN ORO 18 operazioni +147 EUR (PF 1,83); in classifica il default aveva PF ~1,0 "solo SHORT+corr rende" (periodo 2024-26, in-sample). **Manca la prova fuori campione sul DAX (2019-2023).** Dati: D30EUR M1 esterno 2019-2026 sul PC di Claudio (orologio da diagnosticare), BCM nativo solo 2024-2026.
