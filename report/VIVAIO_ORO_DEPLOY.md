# VIVAIO -- DEPLOY ORO NOTTURNO SUL DEMO PICCOLO (10/08/2026)

Deciso da Claudio: l'oro promosso (R17, cella 250/H2) entra nel VIVAIO
per i suoi **30 trade di forward**. Trafila: imbuto -> vivaio -> 100k.

## Dove
- **VECCHIO MT5** (conto 50503392, il demo piccolo). Il -V3/100k NON
  si tocca: li' si entra solo dopo il forward maturo.
- L'EA `ABTG_MaxMinNotte` e' GIA' compilato sul VPS (gira su EURUSD):
  niente ricompilazione, niente riavvii. Solo un grafico nuovo.

## La scaletta (5 minuti)
1. Vecchio MT5 -> File -> Nuovo grafico -> **XAUUSD** -> timeframe **H2**
2. Trascina **ABTG_MaxMinNotte** dal Navigatore sul grafico
3. Parametri di input -- differenze dai default, DA CONTROLLARE TUTTE:

| Campo | Valore | Nota |
|---|---|---|
| Ora inizio box (server) | 22 | la notte vera dell'oro |
| Minuti inizio box | 0 | |
| Ora fine box | 6 | |
| Minuti fine box | 59 | |
| Ampiezza MIN/MAX box | 0 / 0 | filtri spenti |
| Ora piazzamento | 7 : 0 | |
| Cutoff ingressi | 9 : 30 | |
| Ora cancellazione/flat | 17 : 30 | |
| Chiudi residue / OneTradePerDay | true / true | |
| Scadenza pendente | 90 | |
| **InpBufferPoints** | **250** | IL numero della cella |
| AllowLong / AllowShort | true / true | l'oro lavora nei due sensi |
| **Stop loss (SLMode)** | **estremo opposto del box (0)** | vincitore due volte |
| **TF di gestione (MgmtTF)** | **2 Hours** | L'ALTRO numero della cella |
| AtrPeriod / AtrSLmult / SLFixed | 14 / 1.5 / 3000 | inerti/riserva |
| TP1 / % / BE | 1.0 / 50 / true | |
| TP2 / % | 2.5 / 50 | |
| Target EMA200 / periodo | true / 200 | |
| Target sicurezza | 4.0 | |
| Trailing / mult | true / 2.0 | |
| **Filtro correlazione** | **false** | DIVERSO dal MaxMin DAX! |
| **Rischio** | **1.0** | vivaio = 1%, come da trafila |
| Filtro news | false | |
| **InpComment** | **MAXMIN ORO** | per pagella e storico |
| **InpMagic** | **770402** | MAI 770401 (e' del MAXMIN EURUSD!) |
| MaxSpread / Verbose | 0 / true | |

4. Scheda Generale -> Permetti Algo Trading -> OK
5. **SCREENSHOT dei parametri** -> verifica campo-per-campo (legge: 5
   deploy, 5 errori beccati)

## I due controlli critici (dove si sbaglia)
- **Magic 770402**: sullo stesso conto gira gia' ABTG_MaxMinNotte su
  EURUSD col magic 770401. Stesso EA, due grafici -> magic DIVERSI o
  i trade si mischiano (lezione del censimento flotta).
- **Correlazione FALSE**: la cella promossa e' senza filtro S&P (il
  MaxMin DAX ce l'ha, l'oro NO). Copiare "a memoria" dal DAX = errore.

## Cosa aspettarsi
- Primo box stanotte 22:00 server (23:00 IT); pendenti alle 7:00 server.
- ~10 posizioni/mese dal backtest -> 30 trade in ~3 mesi.
- ATTENZIONE dichiarata: lo spread notturno dell'oro dal vivo puo'
  differire dal tester. E' UNA delle cose che il vivaio deve misurare.
- Verdetto a 30 trade: distribuzione live vs attesa OOS (PF 2,45 a 100k
  e' la versione ottimista; contano forma e DD, non il numero secco).
