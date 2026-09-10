# 🤖 RICHIESTA DATI PS5 — scritta per essere data DIRETTAMENTE al Claude del collega

> 📌 **A cosa serve**: le domande dell'altro file chiedono a **Marco** cose che
> ricorda. Questo file chiede al **suo Claude** cose che si **estraggono dai
> file**: valori, conteggi, distribuzioni, definizioni lette nel codice.
> Un ricordo si discute; un numero estratto no.
>
> ✅ **Non chiediamo NIENTE di riservato**: nessuna credenziale, nessun sorgente,
> nessun numero di conto. Solo **numeri derivati** e **definizioni**. Se una
> richiesta gli sembra troppo, salti quella e risponda alle altre.
>
> 🧷 **Regola che vale per tutte le risposte**: accanto a ogni numero vogliamo
> **come e' stato prodotto** — `forward live` / `tick 100%` / `coarse 1-min` /
> `stimato` — e la **n**. E' la gerarchia che ha inventato lui: gliela
> restituiamo applicata alle sue risposte.

---

# 🔴 LE QUATTRO CHE SCIOLGONO I DUBBI VERI

## 1. 📋 I PARAMETRI VIVI, LETTI DAL TERMINALE (non dai `.set`)
E' la sua stessa lezione della sezione 8 (*"il file diceva una cosa, il terminale
ne faceva un'altra"*), e per noi e' la domanda n.1 perche' il riassunto che ci e'
arrivato dice **"pavimento di stop fisso"** mentre il documento dice **0**.

**Cosa vorremmo, come tabella, una riga per asset:**
| asset | InpMinSLPts | InpATR_SLMult | InpATR_TPMult | InpATR_BufMult | InpATR_MinMult | InpMaxLevels | InpPartialRR | InpPartialPct | InpChaseOnInvalid | InpMaxChasePts | MaxMult | rischio % |

- 🎯 letti **dal terminale in esecuzione** (pannello F7 o `.chr` del grafico), **non**
  dal `.set`, e con la **data della lettura**;
- accanto, la **versione dell'EA** che sta girando (il timbro `===== PS5 ORB vX.XX =====`
  che stampa nel log Esperti);
- e se un valore sul terminale **differisce** dal `.set`, per noi quella riga vale
  piu' di tutte le altre: e' esattamente il difetto che ci e' costato una
  discussione ieri.

## 2. 🥇 LA DISTRIBUZIONE DELLO SLIPPAGE — non la media, la **distribuzione**
E' il dato piu' prezioso di tutto il documento, e oggi ha **n=2**.

**Cosa vorremmo, se la raccolta e' andata avanti:**
| asset | n | mediana | P80 | P90 | max | in **punti** e in **% dello stop** |

più tre spaccature che cambiano dove si mette la protezione:
- 🔀 **INGRESSO contro USCITA** tenuti separati (da noi il primo dato su conto
  reale dice **slippage in ingresso e ZERO sull'uscita in stop** — n=1, quindi un
  indizio, non una statistica: se anche da lui l'uscita costa meno, e' una
  regolarita' e non un caso);
- ⏱️ **per minuto dall'apertura** (0-1', 1-5', 5-15'): lo slippage peggiora nel
  primo minuto? Di quanto?
- 📅 **giorni con notizia macro contro giorni normali**.

⚠️ E una domanda tecnica che vale il dato intero: **da quale campo e' preso il
prezzo "richiesto"?** Sul nostro broker il livello richiesto **non viene
riportato** nel prezzo dell'ordine: chi misura lo slippage da li' ottiene **zero
su qualunque conto**. Se la sua raccolta legge quel campo, il **4,67 punti di
US30 potrebbe essere sottostimato** — e siccome tutto l'haircut (+130% contro
+93%) dipende da quel numero, vale la pena verificarlo prima di tararlo.

## 3. 🔁 LE FREQUENZE DI INVERSIONE — la **definizione**, poi il numero
35% UK100, **57% DAX**, 68% Russell: e' il numero che ci ha colpito di piu',
perche' trasforma "cancellare la gamba opposta" da preferenza a protezione.

**Cosa vorremmo:**
- la **definizione operativa esatta**, meglio se copiata dal codice o dalla query
  che l'ha prodotta. Le tre plausibili danno numeri molto diversi:
  (a) il prezzo tocca il livello opposto **entro la giornata**;
  (b) lo tocca **entro N minuti** dall'ingresso (quale N?);
  (c) lo tocca **dopo** che la prima gamba e' stata stoppata;
- la **n** e la **finestra temporale** su cui e' calcolata;
- se ce l'ha: la **distribuzione dei minuti** fra il primo riempimento e il tocco
  del livello opposto. 👉 Questo secondo numero per noi **vale piu' della
  percentuale**: dice quanto tempo ha davvero una cancellazione per arrivare in
  tempo.

## 4. 📐 COME SI TRADUCONO I SUOI MOLTIPLICATORI SUL NOSTRO BROKER
I suoi numeri sono moltiplicatori di ATR: da soli non sono trasportabili. Per
convertirli ci servono **due misure sue**, e sono entrambe banali da estrarre:

- 📊 **ATR(14) su D1 chiusa, mediana e quartili**, per ciascun asset, sul periodo
  del backtest → cosi' `0,03208` diventa **punti indice**, e possiamo confrontarlo
  con il nostro spread misurato;
- 🔧 **le specifiche di contratto** dei suoi simboli (`GER40.cash`, `US30.cash`,
  `US100.cash`, `US2000.cash`): **contract size, tick size, tick value, digits**.
  Senza queste, `MaxMult` e il rischio % non sono confrontabili con i nostri.

❓ **E una domanda diretta: cos'e' esattamente `MaxMult`?** Il documento dice che
e' *"strutturale e dipende dallo strumento"*, ma non spiega **di cosa** e' il
moltiplicatore (lotti massimi? ampiezza massima di range accettata? tetto sulla
size?). E' l'unico parametro della tabella che non riusciamo a interpretare.

---

# 🟠 LE ALTRE, se ha tempo di farle estrarre

## 5. 🧮 DA DOVE VIENE LA SOGLIA `spread ÷ SL ≤ 20%`
Non la soglia: **i dati sotto**. Cioe' la tabella (asset, periodo) con
**spread/SL misurato** e **risultato** accanto, quella da cui si vede che sotto il
20% sopravvivono e sopra il 50% muoiono.
👉 Perche' ci serve: **noi usiamo circa il 2,5%**, otto volte piu' stretto. Se la
sua soglia e' **osservata** (regressione su asset veri) batte la nostra, che e'
**scelta a tavolino**. Se e' derivata da un conto, vogliamo il conto. In ogni caso
**una delle due e' sbagliata**, e questa e' la strada per sapere quale.

## 6. 🎲 GLI INGRESSI DEL MONTE CARLO
Il MC su 10.000 percorsi con ricampionamento per giornata e' ben fatto, ma il
risultato dipende **tutto** dalla distribuzione in ingresso.
**Cosa vorremmo:** la distribuzione degli **R per trade** (o per giornata) usata
come urna — istogramma o quartili + n. 🔎 In particolare: e' costruita su risultati
**tick** o **coarse**? Il documento dice che il coarse *"mente sul drawdown"*
(12 mesi verdi che diventano −11%): se l'urna e' coarse, il DD del MC eredita
quella bugia.

## 7. 📉 LA CRONOLOGIA OPERAZIONE PER OPERAZIONE DELLA SETTIMANA NERA
29 luglio → 5 agosto, da 162.672 a 154.075 EUR. L'ha gia' analizzata operazione
per operazione: se puo' girarci **l'export delle operazioni** (anche anonimizzato:
bastano **asset, ora, direzione, R, causa di chiusura**), per noi e' **il pezzo
piu' istruttivo del documento**.
👉 Motivo: e' l'unico campione **forward live** che esiste, ed e' la fonte con il
massimo livello di fiducia della sua stessa gerarchia.

## 8. ✅ US30 AL TICK NELLA FINESTRA VERA (15:25-15:40)
Era fra i loop aperti. Se l'ha chiuso: **il PF 3,01 dov'e' andato a finire?**
Sugli altri asset il passaggio coarse→tick e' costato **circa la meta'**.
E' il motore principale del portafoglio: se anche li' si dimezza, l'intero
+130% annuo va riletto.

## 9. 🌍 IL PORTAFOGLIO DECORRELATO — soprattutto **cosa NON ha funzionato**
Ultimo loop aperto. Se ha gia' provato ad aggiungere qualcosa di davvero
scorrelato (altra sessione, altra classe, altro meccanismo) e **non** ha
funzionato, quella lista di fallimenti per noi vale piu' dei successi: ci
risparmia settimane. E' lo stesso principio della sua tabella degli scartati.

---

# 🎁 E COSA GLI DIAMO NOI — **in cambio, e subito**
Perche' funzioni deve essere uno scambio, non un questionario. Questi li abbiamo
misurati e li giriamo volentieri, nello stesso formato che chiediamo a lui:

| dato | valore | livello di fiducia |
|---|---|---|
| spread mediani a tick sui nostri indici | campione **~252 milioni di tick** | 🟢 misurato |
| slippage su conto **REALE**, ORB d'apertura DAX | **+0,70 punti indice in ingresso, 0,00 sull'uscita in stop** | 🟡 **n=1 per gruppo: indizio, non statistica** |
| la trappola del livello richiesto non riportato dal server | il modo ovvio di misurare lo slippage darebbe **ZERO su qualunque conto** | 🟢 misurato, trovato per confronto fra due fonti |
| disponibilita' simboli sul nostro broker | **US2000 non esiste**; UK100 c'e', spread ~**1,6 punti indice** | 🟢 letto dal listino |

> 🔥 E la frase che gli rubiamo, perche' e' la migliore del documento:
> **"Un vantaggio misurato con lo strumento sbagliato e' un vantaggio inesistente."**
