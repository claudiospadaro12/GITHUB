# Arena Nexus Grid (EA di terzi, scatola nera) nel NOSTRO Strategy Tester -- LETTURA della sonda del 14/10/2026

Zip `ARENA_TESTER_SONDA.zip` (SHA256 `5adc28f0…`), archivio `backtest_pipeline/risultati_archivio/ARENA_TESTER_SONDA_20261014/`, letto con `leggi_arena_tester.py` (SHA `b627ace6…`, uscita completa in `LETTURA_USCITA.txt`). Script v3, pin `1f0cdf62…` (nei pin passati), data 14/10 22:17, `.ex5` del Market `B261E252…` uguale prima e dopo.

## 1. Stato: SONDA1 KO per una condizione dichiarata, SONDA2 NON lanciata. NESSUN verdetto.
- 🔴 **Il report dice leva 1:100, non 1:500** (l'`.ini` chiedeva 500, il tester ha preso 100). La regola scritta PRIMA dei numeri dice che un giro diverso da quello dichiarato non da' verdetto: il lettore stampa «(A)(B)(C) NESSUN verdetto». Resta cosi': non la ammorbidisco adesso che ho visto i numeri. **I numeri sotto sono DESCRITTIVI di QUEL giro (1:100), non una misura della condizione dichiarata.**
- Perche' la leva ha cambiato il giro non e' noto [NON VERIFICATO]: o il tester prende la leva del conto demo (che quindi sarebbe 1:100, e allora la nostra assunzione «1:500» della sonda era sbagliata e il 1:100 e' piu' vicino al demo vero), o l'ordine dei parametri dell'`.ini` e' stato ignorato. Una misura a costo zero: leggere la leva del conto demo 50503392 nel terminale.
- **SONDA2 (luglio-settembre) NON partita**: la stima era 509 minuti contro il timeout di 240 [STIMA NON MISURATA: 467 s di test per il solo 28/09 x 65 giorni]. Regola scritta prima, non un guasto. Decisione aperta: spezzarla in tranche mensili (~170 minuti l'una, stima).

## 2. Quello che il giro ha mostrato (28/09/2026 da conto VUOTO, lotto base 0,01, deposito 5.000 EUR, ticks reali, ExecutionMode 0 = nessuna latenza ne' slippage) [MISURATO, descrittivo]
- 111 operazioni, **netto -3.351,18 EUR (-67,0% del deposito)**, PF 0,04, DD d'equita' **3.362,84 (67,10%)**, saldo finale **1.648,82**.
- **STOP OUT del conto del tester alle 14:31:00 (server) a livello di margine 49,40%**: 6 deal di stop out, 14 righe nei giornali. Da li' il conto e' morto: il resto del giorno non misura l'EA.
- **Un solo cesto di recupero profondo (>=10 livelli) fa il -3.357,08**, cioe' il **102,1% del netto del modulo [R]**; gli altri 22 cesti [R] erano in utile (somma +70). Durata del cesto 13,6 ore, somma lotti 0,37, picco lotti vivi 0,42 (buy 0,38 / sell 0,09). Gli ingressi stopout erano buy da 4251, 4231, 4227.
- Concentrazione identica alla lettura del demo: il demo 13/10 aveva il 24,5% e il 14/10 il 50,8% del netto [R] nei cesti >= 10 livelli [LETTO nel censimento]; qui il 102%.
- Moduli [F]: CF 61 posizioni, netto -67,67, PF 0,42; FinlabX 7 posizioni, +3,22, PF 2,79.
- Ingressi da ordine pendente: 15 su 111 (13,5%) esattamente al prezzo dell'ordine, 96 a prezzo PEGGIORE (max 12,84 USD, media dei peggiori 0,439), nessuno migliore: **anche senza latenza**, il salto fra due tick vale un peggioramento; sul demo 14/10 731/731 erano esatti [LETTO].
- Commissione addebitata 3,88 EUR per lotto a giro (atteso ~3,90).
- Giornale: modifiche di SL/TP rifiutate «close to market» (retcode 10029 frozen) alle 00:40:26-27, ripetute.

## 3. Quello che NON si puo' concludere (scritto dal lettore e da me)
- Un giorno, un regime, il solo 28/09 da conto vuoto: **non e' la frequenza del crollo**, e' una prova che **a 0,01 lotti il cesto profondo puo' ammazzare un conto da 5.000 in un giorno quando il margine e' 1:100**. Con leva 1:500 lo stop out sarebbe arrivato piu' tardi o non arrivato: la perdita flottante e' la stessa, il margine no.
- Tester senza slippage ne' latenza: il reale sarebbe PEGGIORE (la recensione del 03/10 dice che nel reale «alcuni ordini non vengono eseguiti»: dichiarato da terzi).
- Feed BCM, non quello dell'utente; enum al default del tester (`InpTradeMode=0`, `InpGoldPulseTheme=0`).
- Nessun merito: griglia + scala di lotti + recupero senza SL iniziale resta fuori dall'imbuto prop. **Non e' un verdetto ne' una promozione ne' un'archiviazione.**

## 4. Cosa ne esce come MISURA (senza muovere nessuna soglia)
1. **La leva reale del demo/tester**: da leggere (zero tempo macchina). Se il conto e' 1:100, il giro 1:100 e' quello giusto e va dichiarato come tale PRIMA del prossimo, con l'attesa scritta prima.
2. **SONDA2 spezzata in tre tranche mensili** (luglio, agosto, settembre; ~170 minuti l'una [STIMA]) a leva dichiarata, per vedere quante volte compare un cesto >= 10 livelli e se il 28/09 e' un caso o la regola. E' tempo macchina del PC di backtest: **decide Claudio**.
3. Il confronto con la **versione capata** nostra: la sonda ha dato la distribuzione dei cesti reali (14 cesti a profondita' 1: +24; 6 a 2: +25; 2 a 3-4: +21; 1 a >=10: -3.357): e' il dato che la proxy non aveva. Prossimo passo sulla capata: stadio A col cap, solo dopo la leva.
