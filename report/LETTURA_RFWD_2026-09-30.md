# Lettura RFWD: il forward FTMO rigiocato nel tester BCM (30/09/2026)

Round girato da Claudio sul PC di backtest DESKTOP-H4D7CAJ alle 21:01-21:07 (6 minuti, 7 job su 7, nessun job nullo, nessun guasto
del tester in QUESTA corsa). Archivio: `backtest_pipeline/risultati_archivio/ROUND_RFWD_2026-09-30/`. Criteri congelati PRIMA dei
numeri: `report/RFWD_CRITERI.md`. Questo file e' una LETTURA, non un backtest: nessun PF, nessuna promozione, nessuna taglia.

## 1. Il verdetto meccanico
`H_FEDELI: SI`. 11 posizioni forward nel confronto, 11 nel tester. **L1 (uscita stretta, 15 min) 8 su 11 (73%); L1+L2 (stesso giorno)
10 su 11 (91%)**. Stessa classe di uscita 9 su 10, R entro 0,25 in 9 su 10. Controesempio (tester INDIPENDENTE dal forward, 2000
permutazioni): L1 attesa 2% (p95 9%), L1+L2 attesa 38% (p95 55%). Le soglie (L1 >= 50%, L1+L2 >= 70%) sono SOPRA il p95 del nullo.

## 2. Che cosa vuol dire, per la domanda di Claudio ("gli EA hanno un problema o e' cambiato il PF?")
- **Le sedie fanno nel tester BCM le stesse operazioni che hanno fatto su FTMO**, allo stesso minuto e quasi allo stesso prezzo
  (scarti di 1-8 punti). Quindi: non c'e' un orologio sfasato, non c'e' un codice diverso da quello provato, non c'e' un feed che
  cambi le decisioni. **Cio' che e' successo e' il comportamento delle sedie su questi giorni di mercato.**
- **Gli stop pieni non sono un difetto di esecuzione.** Delle 5 perdite della flotta: 3 si riproducono tali e quali nel tester
  (770411 il 24/09 -1,07 R nel forward e -1,03 R nel tester, alle 08:14:49 e 08:14:29; 771531 il 22/09, due posizioni, stop alla
  stessa ora 12:45:51); 1 e' DIVERSA (770101 il 25/09: nel forward entra alle 10:27 e prende lo stop 15:02 a -1,01 R; nel tester
  la stessa giornata chiude a +0,05 R alle 11:03); 1 NON era simulabile (vedi par. 3).
- **770411 (il caso guida, frequenza 14 volte il contratto)**: forward 3 posizioni, tester 2, di cui 2 riprodotte a L1. Il
  contratto dice 0,051 posizioni/giorno (0,4 attese in 7 giorni, P(zero) 0,70): **anche il tester ne fa 2**. La frequenza alta non
  e' quindi un artefatto del feed FTMO: e' il comportamento del motore su questi giorni (regime) oppure il contratto e' tarato
  basso. Lo scarto resta da spiegare, ma non e' piu' un sospetto sull'esecuzione.
- **Non dimostra** che il PF del contratto sia giusto: dice solo che forward e tester concordano. Il campione e' 11 posizioni,
  13 giorni-sedia, un solo regime (estate, ora legale).

## 3. Difetto del round, trovato leggendo il log (classe 992)
Il log del tester dice: `Experts\ABTG_MaxMinNotte_DAX_Short_Ottimizzato.ex5 on D30EUR,M15 from 2026.09.21 00:00 to 2026.09.30 00:00`.
**Il tester e' arrivato al 30/09 alle 00:00 ESCLUSO**, anche se la riga dichiarava `@FINOA 2026.10.01`. Il cancello aveva risposto
che il 30/09 "rientra nella finestra": era una lettura del codice, NON una misura, ed e' sbagliata. Conseguenza: lo stop pieno
della 770411 del 30/09 (-1.535,91, l'ultima perdita) **non poteva** comparire nel tester: e' il `F_SOLO` del confronto, e non
e' una differenza tra forward e tester. La causa del taglio (limite sulla data odierna? tetto della data di fine?) [NON DIMOSTRATA].
Da correggere prima di un eventuale rilancio: fine finestra al 02/10 o dopo e verifica a macchina della riga `... to ...` del log.

## 4. Sedie senza operazioni
770202 (Dow Apertura), 770260 (Nasdaq RETEST), 770511 (SuperWave Dow): **zero contro zero**, coerente ma NON falsificabile. Il
contratto ne prevedeva 2,4 / 2,5 / 2,1 in 7 giorni (P(zero) 0,088 / 0,080 / 0,128). Che il tester non apra nemmeno una
posizione dove il forward non l'ha fatto e' compatibile con un regime senza segnali, non con un guasto: i tre job hanno
per-trade freschi e G1 ok. Il riepilogo di job come "rc 2 (Trades=0 su una riga)" e' il comportamento atteso per queste sedie.

## 5. Una sola divergenza vera (770101, 25/09)
Forward: buy limit 25468,24 piazzato 09:28:40, riempito 10:27:10, uscita a stop 15:02:18 (p 25390,59, -1,01 R).
Tester: stessa giornata, uscita 11:03:42 a 25468,60 (+0,05 R, trailing). Differenza di 238,6 minuti e 78 punti. Da guardare col
giornale dell'EA (il per-trade ha solo le uscite): il tester non dice perche'. L'ipotesi piu' semplice e' un ingresso a prezzo
diverso per il feed (il riempimento dei limit del retest diverge anche tra due feed vivi, misura del 22-24/09). [NON DIMOSTRATA].

## 6. Cosa NON e' misurato da questo round
Spread, slippage e rifiuti di modify di FTMO; il Guardian del forward (nel tester non c'e'); gli ingressi e i pendenti del
tester (il per-trade ha solo le uscite); il 30/09 (par. 3); qualunque regime diverso da quello di queste due settimane.
Nessuna sedia e' archiviata come MORTA: nessuna ha il certificato (PF, n, DD, uscita ad asse, gemelli, TF). Stato: NON ANCORA MISURATO.
