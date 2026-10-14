# Arena Nexus Grid (EA di terzi) -- TRE TRANCHE MENSILI nel nostro Strategy Tester (scheda scritta il 14/10/2026 sera, PRIMA dei numeri)

Perche': la sonda del 14/10 (`report/ARENA_TESTER_SONDA_LETTURA_2026-10-14.md`) ha dato UN giorno (28/09, da conto vuoto) e un giro NON conforme (leva 1:100 invece di 1:500: nessun verdetto). La SONDA2 da tre mesi non e' partita (stima 509 minuti contro il timeout di 240). Qui si spezza in tre mesi, a leva dichiarata 1:100.

## 1. Cosa gira (script `backtest_pipeline/righe/ARENA_TESTER_TRANCHE.ps1`, marcatore `MARCATORE_ARENA_TESTER_TRANCHE_v1`, derivato dallo script della sonda v3 passato dai cancelli)
- PC di backtest `DESKTOP-H4D7CAJ`, terminale `C:\\Program Files\\BCM Markets MT5 Terminal` (demo 50503392), EA `Market\\Arena Nexus Grid Smart XAU MT5.ex5` SOLO nel tester. Mai il VPS, mai il reale, mai le sedie.
- XAUUSD M1, Modello 4 (ticks reali), deposito 5.000 EUR, **leva 1:100**, `ExecutionMode=0` (nessuna latenza), 14 input come sul demo del 13/10 (lotto base 0,01); i due enum non si impongono (il report dice quale valore).
- TRE tranche una dopo l'altra, **ognuna a conto vuoto** e indipendente: TRANCHE1 luglio (2026.07.01 -> 2026.08.01), TRANCHE2 agosto (08.01 -> 09.01), TRANCHE3 settembre (09.01 -> 10.01, contiene il 28/09). Timeout 270 minuti ciascuna.
- Tempo [STIMA, NON MISURATA]: la sonda ha fatto 467 s per il 28/09 (il giorno con il cesto profondo); un mese di ~22 giorni di borsa = ~170 minuti a giorno medio simile. Totale ~8,5 ore, caso peggiore ~14 ore (3 timeout + chiusure). **Ore del PC di backtest: la decisione e' di Claudio.**
- Lettore: `backtest_pipeline/leggi_arena_tranche.py` (riusa il parser, l'accoppiamento e i cesti del lettore della sonda; leva attesa 1:100; nessun verdetto (A)(B)(C)).

## 2. Ipotesi, scritte PRIMA dei numeri, ognuna con la sua smentita
Partono da UN dato (il 28/09, un cesto >= 10 livelli = 102% del netto del modulo [R], stop out al 49,4%). Sono ipotesi, non criteri.
- **H1 (coda nel trimestre):** in almeno UNA delle tre tranche il conto del tester va in STOP OUT. *Smentita:* nessuno stop out in nessuna delle tre (allora il 28/09 era un caso, non la coda del motore a questo lotto e a 1:100).
- **H2 (dove sta la perdita):** in ogni tranche con almeno un cesto [R] a >= 10 livelli, la **somma dei netti di quei cesti e' NEGATIVA**. *Smentita:* una tranche con cesti >= 10 livelli e somma POSITIVA.
- **H3 (regola o evento):** cesti [R] a >= 10 livelli compaiono in almeno DUE tranche su tre. *Smentita:* in una sola o in nessuna (allora la coda e' piu' rara di quanto la giornata del 28/09 faccia pensare).
- **H4 (il lato dei profitti, la frase di Claudio «fa troppi profitti»):** una tranche SENZA cesti >= 10 livelli ha netto POSITIVO e PF > 1. *Smentita:* una tranche senza cesti profondi con netto <= 0 (allora anche i mesi «buoni» non guadagnano a questo lotto).
Lettura: ogni ipotesi si legge SOLO sulle tranche con giro CONFORME (input, deposito, leva 1:100, finestra, qualita' 100%, provenienza). Su un giro non conforme i numeri sono descrittivi.

## 3. Cosa NON si potra' concludere (scritto prima)
- Tre mesi = UN regime e un feed (BCM); tester senza slippage ne' latenza (il reale e' PEGGIORE, dichiarato da terzi nelle recensioni del Market); lotto 0,01 a deposito 5.000, che NON e' il rapporto lotto/saldo consigliato dal venditore (stimato 25-50 volte piu' grande [INFERITO]); la leva del conto demo e' ancora [NON VISTA].
- Nessun merito, nessuna promozione, nessuna archiviazione. L'EA resta sul demo in osservazione.
- Non decide taglie ne' rischio (decisioni di Claudio).
