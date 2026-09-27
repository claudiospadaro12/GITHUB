# 📋 RESOCONTO DELLA GIORNATA — 27/09/2026 (domenica; il mercato riapre stanotte)

## 🤖 Cosa ha fatto la macchina da sola
- Runner 03:30 sul VPS: 12/12 righe di sola lettura, 0 round, esito completo. 9 sedie nel profilo
  FTMO (770105 viva ma non nel `.chr`, classe 822). Nessuna operazione (weekend).
- 5 agenti morti a mezzanotte per il limite settimanale di chiamate, ripresi alle 08 dal transcript.
- Sul PC di backtest Claudio ha girato la **riga B** (09:10-09:54, 18/18, 0 nulli, tutte le ancore
  al centesimo) e lanciato la **riga A** (36 job, in corsa alla sera; zip non ancora arrivato).

## 💶 Il conto
FTMO 541452707: saldo 75.090,72 (26/09), DD 6,14%; posizione #170709416 SELL 4,84 US30.cash della
771531 aperta sul weekend (~735 EUR di rischio, SL sul server). MC v2 dallo stato di oggi (4 sedie
modellate + 770105): **P(PASS) 55,1%**, fine corsa entro 5 giorni 25,4%; non modellate 770260,
770511, 770212. Reale 10105439: non toccato.

## 🔬 Cosa ho deciso io (col numero)
1. **ORO 770402 solo LONG ha merito** (R260a: 279 posizioni, PF 1,336, meta' 1,171/1,521, DD 4,15%
   a 0,5% OHLC): costruita tutta la catena in BOZZA (preset 770421, script di compilazione CLAU12,
   riga preset per il VPS, referto SEDIA_ORO_LONG_FTMO_BOZZA) con PASS. Nessuna taglia proposta.
2. Round R268 (oro a TICK + 22 anni) e R269 (flat 13:00, DAX long -1h) scritti dopo che l'autopsia
   dei persi ha trovato che il 52% degli stop dell'oro cade nella sessione USA e ~1 su 7 vicino a un
   dato USD (conclusione capovolta dal cancello: classe 862). Riga D consegnata.
3. R262/R263 (770201): altopiano chiuso 160-280, centro 220; muro 10% fra rischio 1,25 e 1,50%;
   a 2% DD 14%. R261: DAX long NON ANCORA MISURATO (uscita, gemelli col filtro), 0/41 sopra PF 1.
4. Stress dei costi sull'oro long: PASS S1/S2/S3 (pareggio a +316% dello spread); la sola voce che
   rovescia e' lo slippage sopra ~9-13 punti.
5. Gemini: 4 conferme sul metodo; 2 sue proposte gia' misurate morte (R95, R42); buchi accolti
   (tick, stress come cancello = firma, MC con sedie nuove: fatto).
6. Classi di difetto 833-871 in checklist in due giorni, tutte trovate PRIMA che i numeri
   arrivassero a Claudio.

## ⚠️ Cosa aspetta Claudio
- **1 o 2 sulla 770212** (pacchetto con PASS, fermo; R54a OOS PF 0,840).
- Zip di **A**, poi R255, C, D sul PC di backtest (una riga alla volta, MT5 chiuso fra una e l'altra).
- Per l'oro long: firma su taglia e sedia dopo R268; **pausa delle sedie oro** su piccolo 50503392
  (770402 a due lati + 3), manuale 50503635 (scalper 779901) e Tickmill (Ichimoku): FTMO conta i demo.
- Risposta di Jonas (FTMO) alle tre domande del 27/09.
- Dallo zip A in poi: **non leggere la console della riga come verdetto su R258** (classe 883): mandare lo zip, legge il lettore.
- Entro il 25/10: decisione sull'orologio delle sedie a ora fissa (preset oro scade il 24/10).

## 🌙 Aggiunta delle 21:00 — la sera, in background
Dichiarato per quello che e': **una sera di ponteggio**, nessuna sedia in piu'. Ma il ponteggio serve
domani: senza lettori gli zip di A, R255, C e D non diventano verdetti, e senza la procedura di
pausa la sedia oro non si attacca nemmeno con la firma in mano.

**Quattro consegne, quattro FAIL in prima stesura, quattro correzioni prima di uscire** (l'Agente dei
Controlli del 13/09, applicato): autotest rifatti da me su tutti e quattro dopo il cancello.

| consegna | commit finale | difetti al cancello | classi nuove |
|---|---|---|---|
| lettore R255 `leggi_r255.py` (Dow short a due orologi) | `1abafd59` | 8 + 1 trovato da me | 872-876 |
| lettore D `leggi_round_corti_d.py` (R268 oro / R269 flat) | `e549b8ea` | 13 | 877-879 |
| `righe/PACCHETTO_PAUSA_ORO_DEMO.md` (blocco (f) della sedia oro) | `06d9ee01` | 4 bloccanti | 880-882 |
| lettore A `leggi_round_corti_a.py` (R250/R258/R259) | `4f014012` | 10 | 883-885 |

I difetti che avrebbero dato un **verdetto sbagliato su un round buono**, per nome:
- cartella madre al posto della raccolta = 24 file NULLI con referto intero (872, in tre lettori su tre);
- i NULLI che solo la riga vede (motore diverso dal pin, classe 166) ignorati dal lettore (873, tre su tre);
- "RISCHIO PASSATO" / "PROMOSSA" scritti PRIMA del cancello che li condiziona (874);
- K1 dell'oro ribaltato da due ancore con uscite a 0,03 $ di distanza sul per-trade 795301 vero (877);
- sull'oro la regola stretta di identificazione prendeva la cella 1,0 al posto della 2,0 (878);
- l'ancora S0 di R259 era "0/0" per tutti, XAGUSD ha 0/4: una riproduzione giusta usciva "NON LETTO" (884).

Due cose trovate stasera che cambiano la lettura di domani:
- 🔴 **classe 883** — la riga A in corsa scrivera' in console "R258 NULLO" quasi ovunque: `ABTG_Londra_ORB` r.484
  scrive gli input senza virgolette e `InpNewsCurrencies=GBP,USD` mette un campo in piu' nel CSV; `Import-Csv`
  sposta le colonne e il P0 della riga fallisce. Verificato alla fonte: **nessun job salta** per questo (l'unico
  blocco condizionato e' L, sullo storico M1). Fa fede il lettore, che ricuce e stampa ogni esenzione per nome.
- 🔴 **classe 876** — la corsa R255 e' una sola (moncone + 641 giorni) e la curva riparte per era: lo "scarto di
  saldo" della testa in era OOS contiene l'utile IS della corsa. Contro-esempio: +1.200 in IS poi -50/+40 in OOS
  = scarto 12,0% per la lettera, 0,0% a curva continua. La testa non si tocca (pinnata); il lettore stampa i due numeri.

**Pacchetto pausa oro demo**: sedie verificate alla fonte, non copiate dalla bozza. Fatti nuovi: il piccolo
50503392 e' **chiuso dal 23/09 19:35** (CODA_05), Tickmill dal 20/07, e la posizione XAUUSD `#3430899` (short,
giornale del 23/09 03:25) **puo' essere ancora aperta sul server** [NON MISURATO]. Lo scalper 779901 sul manuale
gira in modo CANDELA/MEZZO CORPO (CODA_08 r.2470/2472): il verso lo decide l'EA, quindi L+S. Riaperture del
piccolo e di Tickmill **solo a mercato chiuso** (al primo tick EMA200/Supertrend contano barra nuova e
MaxMinNotte piazza gli stop). Resta una firma di Claudio: nulla eseguito.

Nota sulla riga D gia' consegnata: usa tolleranza 0,05 sul Profit delle gemelle, la testa dice "al centesimo",
il lettore ora usa 0,01. Il lettore e' il piu' severo e unisce i NULLI: direzione conservativa, la riga non si
riconsegna.

In corsa a quest'ora: il lettore della riga C (`leggi_round_corti_c.py`, 37 job), poi il suo cancello.
Prossima classe libera: 886.

## 🎯 Domani
Leggere gli zip (A, R255, C, D) con i lettori passati dal cancello; referti al cancello; se R268 regge, la sedia
oro long passa alla firma (con il pacchetto di pausa gia' pronto). Report della notte alle 06:30 con la prima
foto del mercato riaperto.
