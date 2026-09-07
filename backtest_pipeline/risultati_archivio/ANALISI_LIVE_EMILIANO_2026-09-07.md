# 🎙️ ANALISI LIVE EMILIANO (FTD/ABTG) — lunedì 07/09/2026, mattina (08:30)

**Data referto:** 07/09/2026 · **Analista:** estrattore trascrizioni
**Fonte unica:** la trascrizione TurboScribe caricata da Claudio, archiviata nel repo in
`docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-07.txt` (52.296 byte, 73 righe).
Niente memoria, niente web, niente "completamento" dei buchi.

> ⛔ **REGOLA CHE VALE SOPRA TUTTO: da questo materiale non si muove NIENTE in forward.**
> Ogni numero qui dentro è una **DICHIARAZIONE DEL RELATORE**, mai un criterio nostro.
> Un numero detto in una live **non entra in nessun cancello**: è una fonte, non una misura.

> ⚠️ **E una nota che serve al lettore distratto:** il §3.2 confronta la **finestra della
> notte** del relatore con la nostra. `ABTG_MaxMinNotte` è una **sedia VIVA** (magic
> `770411` sul DAX, `770402` sull'oro). Confrontare due finestre **non è** rianimare un
> motore morto e **non è** una ri-ottimizzazione: la regola della seconda caccia
> (_"mai parametri diversi di un motore morto"_) qui **non è in gioco**, perché il motore
> non è morto. È una **domanda di misura mai posta su un motore vivo**.

---

## 0. 🗂️ IL FILE — e la prima correzione al mandato

| | |
|---|---|
| **Nome originale** | `56862987-LIVE_EMILIANO_07.09.26_20260907_083000515.txt` |
| **Archiviato in repo** | `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-07.txt` |
| **Dimensione** | 52.296 caratteri · 73 righe |
| **Relatori** | **EMILIANO** (voce principale) · **FABIO La Rosa** (ospite, seconda parte) · **GIACOMO** (regia/coaching AI) · allievi nominati: Silvia, Gianni, Giorgia, Michele, Giuliano |
| **Strumenti trattati** | **DAX (D30EUR)** = 90% dell'operatività · **XAUUSD** (forbice forza) · **EURUSD** (chiusura) · **AUDUSD/AUDCAD** (demo di Fabio) · **USOIL** (correlazione) |

### ⚠️ CORREZIONE AL MANDATO — la seconda metà **NON** è tutta commerciale

Il mandato diceva: *"seconda metà = presentazione commerciale … per quanto vedo non c'è
contenuto operativo"*. **Misurato, non opinato**, contando i caratteri:

| blocco | righe | caratteri | quota |
|---|---|---:|---:|
| Emiliano operativo (pre-apertura + apertura) | r.1–42 | **19.975** | 38% |
| Fabio — demo MQLSuite (commerciale) | r.73, car. 1–4.586 | **4.586** | **9%** |
| 🔴 **Emiliano operativo di ritorno** (gestione, stop, size, R:R) | r.73, car. 4.586–27.551 | **~22.965** | **44%** |
| altro (saluti, logistica, r.43–72) | — | ~4.770 | 9% |

🔴 **La riga 73 è lunga 27.551 caratteri — il 53% dell'intero file** — ed è **un blocco
unico senza punteggiatura di paragrafo**. Dentro ci stanno **sia** la demo commerciale
**sia** la parte più densa della live: la gestione della posizione in diretta, il
posizionamento dello stop, la size in due tranche, e **la soglia di R:R che mancava da due
referti**. Le citazioni da lì sono marcate **`r.73 (blocco unico)`**.

📌 **Conseguenza pratica:** l'80% del contenuto operativo di questa live sarebbe finito
negli scarti seguendo il mandato alla lettera. **La parte commerciale è il 9%, non la metà.**

---

# ⭐ PARTE 1 — LA SINTESI INCROCIATA (la pagina da leggere per prima)

## 1.1 🏆 LE QUATTRO COSE CHE VALGONO DAVVERO

---

### 🥇 1. LA DOMANDA DEL MANDATO HA UNA RISPOSTA NETTA: **la finestra della notte NON è MAI stata misurata. È stata SCELTA.**

**La risposta non è un'opinione: è stata letta dentro i CSV delle corse.**

Ho aperto **tutti** i file di ottimizzazione della famiglia MaxMinNotte esistenti in
`backtest_pipeline/risultati_archivio/` e ho estratto i valori **distinti** assunti dagli
input di finestra oraria in ogni riga di ogni corsa:

| file di corsa | righe | `InpBoxStartHour` | `InpBoxEndHour` | `InpPlaceHour` | `InpCloseHour` |
|---|---:|---|---|---|---|
| `MaxMinNotte/080957cf-valid_MaxMin_D30EUR.csv` | 72 | **{23}** | **{4}** | {7} | {17} |
| `MaxMinNotte/4528c79b-valid_MaxMin_F40EUR.csv` | 72 | **{23}** | **{4}** | {7} | {17} |
| `MaxMinNotte/8eefb007-valid_MaxMin_E50EUR.csv` | 72 | **{23}** | **{4}** | {7} | {17} |
| `MaxMinNotte/efe054b5-valid_MaxMin_100GBP.csv` | 72 | **{23}** | **{4}** | {7} | {17} |
| `MaxMinNotte/valid_MaxMin_DAX_short_refine.csv` | 36 | **{23}** | **{4}** | {7} | {17} |
| `MaxMin_Oro/oro_maxmin_fase1_{M5,M15,M30,H1}.csv` | 48 | **{22}** | **{6}** | {7} | {17} |

**Un solo valore distinto per colonna, in tutte e 324 le righe.**
👉 **La finestra non è mai stata un asse di ottimizzazione. Nemmeno una volta.**

**Cosa È stato misurato invece** (`REGISTRO_TEST.md` r.413-438, `REFERTO_ROUND2.md` §1):
- ✅ **direzione** (long/short/entrambe) → sul DAX vince **SHORT only**;
- ✅ **buffer d'ingresso** → griglia 500/750/1000/1250/1500, **altopiano da 750 a 1500**,
  scelto **1000** come centro. Testuale del referto: _"**L'edge è del box notturno, non
  del numero 1000**"_;
- ✅ **SL ATR** (1.5/2.0/2.5), ✅ **filtro ampiezza box** (irrilevante: _"notti DAX sempre
  larghe"_), ✅ **correlazione S&P** (raddoppia il PF: 1,2 → 2,05);
- ❌ **finestra oraria del box** → **MAI**.

#### 🎯 E adesso il pezzo che rende la domanda interessante davvero

**La DURATA converge esattamente. La POSIZIONE no.**

| | finestra | candele H1 |
|---|---|---:|
| **Emiliano, 07/09** | _"quindi **sono 6 candele**"_ | **6** |
| **`ABTG_MaxMinNotte` DAX (770411)** | `InpBoxStartHour=23` → `InpBoxEndHour=4`, `InpBoxEndMin=59` = **23:00–04:59 server** (23,00,01,02,03,04) | **6** ✅ |
| `ABTG_Nightly` | 22:00–04:59 | 7 |
| `ABTG_MaxMinNotte` oro (770402, `.set` vivo) | 23:00–04:59 | 6 |
| variante oro delle prove (`maxmin_oro.ps1` r.128-130, `R100_GENERA_PROVE.py` r.65) | 22:00–06:59 | **9** ⚠️ |

🟢 **Sei candele contro sei candele: la LUNGHEZZA della "notte" combacia al minuto.**
🔴 **Ma la POSIZIONE no**, e questo è il delta vero. La sua "notte" **finisce all'apertura**;
la nostra **finisce alle 04:59**, cioè **tre ore prima** che il nostro EA pianifichi
(`InpPlaceHour:Min = 07:59`).

⚠️ **Dove finisce esattamente la sua finestra è `[INCERTO]`** e lo dico invece di
indovinare. Lui conta all'indietro dall'ultima candela H1 chiusa, a mercato ancora chiuso
(_"mancano dieci minuti"_), e aggiunge _"fate una candela in meno"_. Le due letture:

| lettura | finestra implicita | sovrapposizione col NOSTRO box (23:00–04:59) |
|---|---|---|
| **(a)** la notte finisce all'**apertura** (08:00 server) | **02:00–07:59** | **3 ore su 6** (02,03,04) |
| **(b)** la notte finisce alle **05:00** | 23:00–04:59 | **identica alla nostra** |

Il contesto della trascrizione favorisce **(a)**, ma **non lo firmo**.

#### 🧩 E sotto la lettura (a) le due metà della sua finestra **esistono già in casa, separate**

- La metà "vecchia" (02:00–05:00) → **è dentro il nostro box `MaxMinNotte`**.
- La metà "pre-mercato" (05:00–08:00) → **è esattamente il round `PREOPEN DAX`, PREPARATO
  E MAI LANCIATO**: `ABTG_DAX_Apertura_EU` con `InpRangeMode=1` costruisce il livello su
  `[08:00 − InpPrevWindowMin, 08:00)`, e la griglia congelata è
  **`InpPrevWindowMin=60||60||60||300||Y`** = **60/120/180/240/300 minuti**
  (`prove/PREOPEN_RETEST_DAX_M15.txt` r.378).
- ✅ **Verificato**: nessun file `PREOPEN*` esiste in `risultati_archivio/` e la parola
  `PREOPEN` non compare in `REGISTRO_TEST.md` → **il round non è mai girato**.

🔴 **E il numero di Emiliano cade FUORI dalla griglia, di poco: 6 candele H1 = 360 minuti,
la griglia si ferma a 300.**

⚠️ **Nota metodologica che va detta prima che qualcuno la scavalchi:** quel round ha
**criteri di merito GIÀ CONGELATI** (`PREOPEN_RETEST_DAX_M15.txt`, sezioni `COME PUÒ
MORIRE` e `CRITERI DI ACCETTAZIONE`). **Aggiungere una colonna a 360 dopo aver letto una
live cambia il round**, e i criteri di casa si cambiano **prima** dei numeri, non dopo.
Se si vuole il 360, si dichiara **adesso**, prima del lancio. → **SPUNTO S1**, §4.

📌 **La tabella di sovrapposizione col box vivo esiste già** ed è nel referto di
preparazione (`prove/REFERTO_PREPARAZIONE_PREOPEN_DAX_NAS.md` §4): con `prevWin` 60/120/180
la sovrapposizione col box `770411` è **0 minuti**; con 240 diventa 60 min (16,7%), con 300
diventa 120 min (33,3%). **Un `prevWin=360` sovrapporrebbe 180 minuti = metà del box della
sedia viva** → il sospetto di doppione diventerebbe strutturale. Questo va **nella pagina di
lancio**, non scoperto dopo.

> ### ✅ RISPOSTA SECCA ALLA DOMANDA DEL MANDATO
> **Il nostro 23:00–04:59 NON è stato misurato contro alternative: è stato SCELTO e mai
> più toccato** (fonte: le 324 righe dei CSV di corsa, tutte con un solo valore).
> Quindi la definizione diversa del relatore **non è "un'opinione contro una nostra
> misura"**: è **un'opinione contro una nostra CONVENZIONE**. 👉 **È una domanda aperta
> legittima**, e va scritta come tale. **Ma resta uno SPUNTO, non un candidato**, e la
> porta per rispondere è già costruita (il round PREOPEN), non va inventata.

---

### 🥈 2. I DUE OFFSET DELL'ORDINE PENDENTE CONVERGONO COL NOSTRO CODICE — e sull'indice sono **IDENTICI**

⚠️ **Prima l'unità, perché senza è aria fritta.** Su questi indici BCM
**1 punto indice = 100 punti MT5** — e questa **è una misura**, non una convenzione
(R97, `righe/RIGA_R97_DA_MANDARE.md` r.100-114). Ogni riga qui sotto porta **tutte e due**
le unità.

**Quello che dice lui, testuale (r.27):**
> _"si mettono l'ordine pendente e si mette **per le valute a tre pip** per quanto riguarda
> invece **gli indici a dieci**"_ · _"metto un ordine pendente **a circa dieci punti**"_
> `[TRASCRITTO chiaro]` — detto due volte a distanza di poche righe, numeri scritti in
> lettere ("dieci", "tre"): **non è un decimale storpiabile dallo speech-to-text**.

**Quello che c'è nel nostro sorgente — verificato riga per riga, mai a memoria:**

| dove | input | valore | **punti MT5** | **punti indice / pip** | vs Emiliano |
|---|---|---:|---:|---|---|
| `ABTG_MaxMinNotte.mq5` r.140 (default) | `InpBufferPoints` | 1000 | 1000 | **10 punti indice** | 🟢 **IDENTICO** |
| `.set` sedia viva **770411** r.21 | `InpBufferPoints` | 1000 | 1000 | **10 punti indice** | 🟢 **IDENTICO** |
| `ABTG_DAX_Apertura_EU.mq5` r.89 (`ABTG_DEF_BUFFER`) | `InpBufferPoints` | 500 | 500 | **5 punti indice** | 🟡 **metà** |
| `ABTG_DAX_Apertura_EU.mq5` r.277 | `InpRetestOffsetPts` | 200 | 200 | **2 punti indice** _(DENTRO il livello, non fuori)_ | ⚪ altro parametro |
| `ABTG_Dow_Apertura_US.mq5` r.69/234 | `InpBufferPoints` | 200 (def.) / **700 live** | 200/700 | 2 / **7 punti indice** | 🟡 |
| `ABTG_DAX_Live5m_v2.mq5` r.31 | `InpBufferPoints` | 700 | 700 | **7 punti indice** | 🟡 |
| `ABTG_PostNews.mq5` r.95-96 | `InpBuyOffsetPips` / `InpSellOffsetPips` | **3.0 / 3.0** | — | **3 pip** | 🟢 **IDENTICO** |
| `.set` `ABTG_MaxMinNotte_EURUSD` r.26 | `InpBufferPoints` | 200 | 200 | **20 pip** (EURUSD 5 cifre) | 🔴 **~7×** |

🟢 **Sull'INDICE il suo numero e il nostro sono lo stesso numero, e il nostro è MISURATO:**
griglia 500→1500, altopiano 750-1500, **cella scelta al CENTRO dell'altopiano, non sul
picco** (il picco era 1250 con PF OOS 2,68 — non è stato preso, regola di casa).
👉 **Questa è la convergenza più forte di tutta la live**, ed è a due strade davvero
indipendenti: la sua esperienza e la nostra griglia.

🟢 **Sul FOREX post-news idem:** i suoi 3 pip = i nostri 3,0 pip di `ABTG_PostNews`.
📌 **E non è la prima volta:** il consolidamento delle **18 live** già agli atti dice, testuale
(`REGISTRO_TEST.md` r.230): _"**RICORRENTE** Max/min della notte: ordine pendente a **10
punti** oltre (indici)"_. 👉 **Oggi è la conferma N-esima della stessa cosa, non una
scoperta.** Vedi §1.2, voce 🔁.

🔴 **L'unico posto dove NON combaciamo è EURUSD**: il nostro box notturno usa **200 punti
MT5 = 20 pip**, quasi **sette volte** i suoi 3 pip. ⚠️ **E qui manca proprio la misura:**
in `risultati_archivio/MaxMinNotte/` ci sono le corse di **D30EUR, F40EUR, E50EUR, 100GBP**
— **nessuna corsa su EURUSD**. Il 200 su EURUSD non è "sbagliato": **non è misurato**.
→ **SPUNTO S3**, §4. ⚠️ Con la cautela ovvia: il suo 3 pip è per una **rottura dei minimi
della notte tenuta a vista**, il nostro 200 è un **buffer anti-rumore su un pendente
lasciato solo per 90 minuti**. **Domini diversi. Si registra la distanza, non si copia il
numero.**

⛔ **Trappola evitata, dichiarata:** il buffer dell'**ORB** (`ABTG_ORB_Ottimizzato.mq5` r.192,
`InpSLBufferPts = 0`) **NON è confrontabile**: è un buffer **sullo STOP**, non
sull'**ingresso**. Metterlo in questa tabella sarebbe stato un confronto fra due cose diverse
con lo stesso nome.

---

### 🥉 3. IL BANK HOLIDAY USA + `InpUseCorrelation=true`: la nostra sedia viva legge un S&P **FERMO**, e non se ne accorge

Questa è la voce con la **ricaduta più diretta su una sedia viva** ed è **verificata nel
sorgente**, non dedotta.

**Quello che dice lui (r.27), testuale:**
> _"perché sia **Arcade** che **U.S.** sono in **Bank Holiday**, cosa vuol dire, **non
> abbiamo la possibilità di andare a fare delle correlazioni con l'SMP**, quindi il mercato
> è chiuso, non ci dovrebbe essere molta volatilità sui mercati americani, anzi veramente
> piatto"_ · _"il mercato potrebbe fare **cose anche strane**"_ · _"non c'è liquidità, non
> c'è volume, quindi **può seguire anche dinamiche completamente diverse rispetto a quelle
> tradizionali**"_
> `[TRASCRITTO chiaro]` — ⚠️ **"Arcade" = "Canada"**, errore di riconoscimento vocale
> evidente dal contesto (Labor Day = festivo USA **e** canadese).

**Quello che c'è in casa — verificato in `mql5/Experts/ABTG_MaxMinNotte.mq5` r.698-711:**

```
int CorrBias()
  {
   if(!InpUseCorrelation || StringLen(InpCorrSymbol)==0) return(0);
   int hf=iMA(InpCorrSymbol,InpCorrTF,InpCorrEmaFast,0,MODE_EMA,PRICE_CLOSE);
   int hs=iMA(InpCorrSymbol,InpCorrTF,InpCorrEmaSlow,0,MODE_EMA,PRICE_CLOSE);
   ...
   if(CopyBuffer(hf,0,1,1,f)==1 && CopyBuffer(hs,0,1,1,s)==1)
      dir=(f[0]>s[0])?+1:(f[0]<s[0]?-1:0);
```

E nel `.set` della sedia viva
(`mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_770411.set`):

| riga | input | valore |
|---:|---|---|
| 40 | `InpUseCorrelation` | **true** |
| 41 | `InpCorrSymbol` | **SPXUSD** |
| 48 | `InpUseNewsFilter` | **false** |
| 59 | `InpMaxSpread` | **500** (5 punti indice) |

🔴 **Il difetto, descritto senza gonfiarlo:** `CorrBias()` confronta **EMA14 vs EMA100 su
SPXUSD H1, shift 1**. In una giornata di **festivo USA** l'SPXUSD non stampa barre nuove:
`CopyBuffer` **non fallisce**, restituisce l'ultima barra disponibile. Quindi il filtro
**non si accorge del festivo**: restituisce **il bias del giorno prima**, con la stessa
faccia sicura di sempre. Non c'è **nessun** controllo di freschezza della barra, e
`InpUseNewsFilter=false` → **nessun calendario acceso**.

🟡 **Onestà su quanto pesa:** un EMA14/EMA100 su H1 è **lento per costruzione** — un bias
vecchio di un giorno **spesso coincide** con quello di oggi. Il rischio non è "il filtro
dice il contrario": è che **il filtro dice qualcosa quando non ha nulla da dire**, e la
sedia opera con una conferma che non esiste. ⚠️ **Quanto costi, NON LO SAPPIAMO — perché
non l'abbiamo mai contato.** Ed è contabile a costo quasi zero (→ **SPUNTO S2**).

📌 **E il flag "bank holiday" è già uno spunto aperto in casa dal 31/08**
(`ANALISI_LIVE_EMILIANO_2026-08-31.md`, spunto **S-D**: _"la regola bank holiday → niente
istituzionali → niente movimento è meccanizzabile … e da noi non esiste"_).
👉 **Oggi è la SECONDA occorrenza in 5 giorni**, e stavolta arriva **agganciata a un input
acceso su una sedia viva**. Non è più una curiosità di calendario: è una **domanda su
`770411`**.

---

### 🏅 4. LA SOGLIA DI R:R CHE MANCAVA DA DUE REFERTI: **oggi la dichiara. È 1:1.**

Il referto del **28/08** (§6.3) chiudeva così, testuale:
> _"🔴 **MA — e questo è il limite — una SOGLIA MINIMA DICHIARATA non esiste in nessuna
> delle due live.** Non pronuncia mai '1:2', '1:3', né un numero minimo. **Due dati non
> fanno una regola.** Resta il buco già segnato ieri."_

**Oggi lo dice. Due volte, esplicito, r.73 (blocco unico):**
> _"io devo calcolare che se ho uno **stop di 40 punti non posso prendermene 20** … però
> **il rapporto deve essere almeno 1 a 1**"_
>
> _"lo stop però guarda se diventa importante lo stop perché **io devo avere uno stop di
> rischio di rendimento 1 a 1 almeno**"_
>
> `[TRASCRITTO chiaro]` — numero scritto in lettere ("1 a 1"), ripetuto.

🟢 **Il buco segnalato il 27/08 e riconfermato il 28/08 si chiude alla terza live.**
L'etichetta passa da `[INFERITO da due casi]` a **`[TRASCRITTO chiaro, DICHIARATO]`**.

⚠️ **E la nota di casa del 28/08 resta valida parola per parola:** _"un R:R 1:1 su una sedia
automatica ha bisogno di un win rate ben sopra il 50% per pagare spread e commissioni.
**Non è un numero adottabile: è un numero registrato.**"_ Per confronto, la sedia `770411`
lavora su `InpTP1_R=1.0` (50% della size) **+ `InpTP2_R=3.0`** (l'altro 50%) **+
`InpTPfinal_R=4.0`** + trailing: **la nostra uscita non è 1:1, è a scaglioni fino a 4R.**
Il suo 1:1 è **il pavimento di un discrezionale che gestisce a mano**, non il nostro.

---

## 1.2 🆕🔁⚔️ NUOVA / RIPETUTA / IN CONTRADDIZIONE — voce per voce

Convenzione: **RIPETUTA** = già estratta in un referto precedente (indicato).
Le fonti FTD/ABTG **contano come UNA sola**: Emiliano, Paolo, Giacomo e i `.docx` del corso
sono **quattro voci della stessa fonte**, non quattro fonti.

| # | Voce estratta oggi | Stato | Dove stava già / con cosa cozza |
|---|---|---|---|
| **V1** | Ingresso alla **rottura dei max/min della notte** con **ordine pendente** | 🔁 **RIPETUTA** | `REGISTRO_TEST.md` r.230 (consolidamento 18 live) · `docs/live_emiliano/ANALISI_LIVE_luglio.md` (Emiliano 20/07) · `ANALISI_LIVE_EMILIANO_2026-08-27.md` M15 |
| **V2** | Offset **10 punti indici** | 🔁 **RIPETUTA — e classificata "RICORRENTE"** | `REGISTRO_TEST.md` r.230 testuale: _"**RICORRENTE** … ordine pendente a **10 punti** oltre (indici)"_ |
| **V3** | Offset **3 pip valute** | 🔁 **RIPETUTA** | `ANALISI_LIVE_luglio.md` §PostNews: _"BUY STOP +3 pip … SELL STOP −3 pip"_ (Emiliano/De Marco 29/07) |
| **V4** | **"la notte = 6 candele H1"** | 🆕 **NUOVA** | ⭐ **mai quantificata prima in nessun referto.** È il numero che rende confrontabile la sua finestra con la nostra (§3.2) |
| **V5** | **"su BCM il lunedì c'è una doppia candela"** per il cambio d'orario del server | 🆕 **NUOVA** | ⭐ mai apparsa. **E tocca una domanda aperta di casa**: `DA_FARE.md` §3 _"Il server BCM cambia ora legale?"_ (§3.4) |
| **V6** | Gli **"ostacoli"** da guardare prima di piazzare (VWAP, media 200, S/R, pre-section, numero tondo) | 🔁 **RIPETUTA** | `REGISTRO_TEST.md` r.239 testuale: _"**Declassano il setup (5 ostacoli): media 200 H1, VWAP, S/R, pre-section, numero tondo**"_ — oggi cita **tutti e 5**, ma la media è **H4**, non H1 → ⚔️ micro-scostamento, vedi V6b |
| **V6b** | La media 200 come ostacolo sta in **H4** | ⚔️ **SCOSTAMENTO** (non contraddizione piena) | Il consolidamento dice **H1**; oggi è **H4** (_"in H4 abbiamo la media quindi l'ingresso è assolutamente a cancellare"_). Il TF dell'ostacolo **non è stabile** |
| **V7** | **VWAP basato sulla volatilità, "in M15 fa lo spartiacque"** | 🔁 **RIPETUTA — e da noi già MISURATA E BOCCIATA** | `REGISTRO_TEST.md` r.252 (18 live) · e soprattutto **R101 gradino `07_vwap`**, che `R101_CRITERI.md` r.231 attribuisce testualmente a _"**live Emiliano, non del corso**"_ → §3.3 |
| **V8** | Correlazione **DAX ↔ USOIL**, motivata dal peso automotive | 🔁 **RIPETUTA** | `ANALISI_LIVE_luglio.md`: _"Correlazione utile: petrolio su → DAX giù (peso automotive nel DAX)"_ (Emiliano 26/07) — con **un'AZIONE mai eseguita**, §3.5 |
| **V9** | Correlazione **DAX ↔ EURUSD** e **DAX ↔ S&P** | 🔁 **RIPETUTA** | `REGISTRO_TEST.md` r.225 · `ANALISI_LIVE_EMILIANO_2026-08-31.md` C16 |
| **V10** | **Forbice della forza valutaria** come filtro di direzione | 🔁 **RIPETUTA, e con precedente negativo** | `ANALISI_LIVE_PAOLO_2026-09-03.md` **Y8**: la stessa tabella, con numeri **aritmeticamente incoerenti**. E `ANALISI_LIVE_storico.md`: _"indicatori ancora in beta (ZenFX, **forza valute**, BOS) → nessuna regola stabile"_ |
| **V11** | **Bank holiday → poca liquidità → movimenti anomali** | 🔁 **RIPETUTA (2ª volta in 5 giorni)** | `ANALISI_LIVE_EMILIANO_2026-08-31.md` **M10** (GBP bank holiday) + spunto **S-D**. 🆕 **La novità di oggi è l'aggancio a `InpUseCorrelation` su sedia viva** (§1.1.3) |
| **V12** | **"non entro prima dell'apertura, sono rarissime le volte"** | 🆕 **NUOVA come regola di piano** | Il divieto **notturno** c'era (28/08, E23: _"sul DAX di notte non mi azzardo"_); il divieto **pre-apertura** è più stretto e non era mai stato dichiarato. ⚔️ **E oggi la contraddice lui stesso**, vedi X1 |
| **V13** | **R:R minimo dichiarato = 1:1** | 🆕 **NUOVA — chiude un buco aperto in DUE referti** | `ANALISI_LIVE_EMILIANO_2026-08-28.md` §6.3 lo dichiarava esplicitamente mancante (§1.1.4) |
| **V14** | **Size in due tranche 5 + 5 contratti**, primo ingresso anticipato + secondo sul retest | 🔁 **RIPETUTA (variante)** | `REGISTRO_TEST.md` r.244: _"**RICORRENTE** Money management **1/3 + 2/3**"_. ⚔️ **Oggi è 1/2 + 1/2**, non 1/3+2/3 → vedi X4 |
| **V15** | **Stop sopra il massimo della candela M15**, allineato alla media 200 H4 / ai massimi della notte | 🔁 **RIPETUTA** | `REGISTRO_TEST.md` r.242: _"Stop … messo **sotto media/Supertrend/minimo** (5-10 pt oltre)"_ |
| **V16** | **Se un ordine pendente viene SFIORATO, si sposta** | 🔁 **RIPETUTA quasi alla lettera** | `REGISTRO_TEST.md` r.231: _"Se un livello viene 'sfiorato' la prima volta → **sposta l'ordine** (la 2ª volta rompe)"_ |
| **V17** | **Movimento negli ultimi 20-30 secondi / ultimo minuto prima della nuova candela H1** | 🆕 **NUOVA** | ⭐ mai apparsa in nessun referto. Grep in `backtest_pipeline/` + `report/`: zero occorrenze di un'affermazione simile. Vedi §2.2 M9 |
| **V18** | **Retest progressivo** invece di inseguire il prezzo (_"se insegui il prezzo eri fottuto"_) | 🔁 **RIPETUTA (pilastro)** | 27/08 M18 (anti-chasing) · 24/08 (_"se chiude troppo lontano, aspetta il pullback"_) · nostra geometria `RETEST` |
| **V19** | **Livello obiettivo = supporto/resistenza weekly** (_"i supporti di resistenza attraggono i prezzi"_) | 🔁 **RIPETUTA** | 27/08 M16 · 28/08 E6 |
| **V20** | MQLSuite: **50 profili MT5, 100+ MT4**, e-signal a **5.000-5.150 $** | 🆕 **NUOVA** (ma ⚪ **non operativa**) | § scarti, §5 |
| **V21** | **"il mercato si muove per multipli di 0,25%"** (Fabio) | 🆕 **NUOVA** | ⚪ `[DICHIARATO, NON VERIFICATO]`, senza campione né definizione. §5 |
| **V22** | **Non può usare MT5 sui social** → motivo dichiarato dell'intervento di Fabio | 🆕 **NUOVA** (logistica) | ⚪ nessun uso |

---

## 1.3 📊 TABELLA DEI VALORI CONVERGENTI

⚠️ **Colonna "fonti INDIP.": FTD/ABTG = 1.** Emiliano oggi, Emiliano il 27/08, Paolo il
03/09 e i `.docx` **sono la stessa fonte**. L'unica seconda strada indipendente è **il
nostro repo**.

| Parametro / meccanismo | Live 07/09 | Live precedenti FTD | **Nostro repo — verificato** | Fonti INDIP. |
|---|---|---|---|---:|
| **Offset pendente indici = 10 punti indice** | ✅ _"per gli indici a dieci"_ | ✅ "RICORRENTE" su 18 live | ✅ **`InpBufferPoints=1000` = 10 pt indice, MISURATO** (altopiano 750-1500, R2) | **2** 🟢🟢 |
| **Offset pendente valute = 3 pip** | ✅ _"per le valute a tre pip"_ | ✅ PostNews 29/07 | ✅ `ABTG_PostNews.mq5` r.95-96 = **3.0 / 3.0** | **2** 🟢 |
| **La "notte" dura 6 ore** | ✅ _"sono 6 candele"_ | ⚪ mai quantificata | ✅ box `23:00–04:59` = **6 candele H1** | **2** 🟢 (sulla DURATA) |
| **Dove sta la notte** | 🔴 finisce all'**apertura** | ⚪ | 🔴 finisce alle **04:59**, **mai misurato** | **0** ⚠️ §3.2 |
| **Stop SEMPRE, su livello tecnico** | ✅ _"stop sopra il massimo della candela M15"_ | ✅ 27/08 M11 · 28/08 | ✅ ogni EA ha SL; `InpSLMode`, `InpAtrSLmult=2.5` | **2** 🟢 |
| **Mai inseguire il prezzo / retest** | ✅✅ _"se insegui il prezzo eri fottuto"_ (×3) | ✅ 27/08 M18 · 24/08 | ✅ geometria `RETEST` (+64,76 su 6 pos) | **2** 🟢 |
| **Ordine sfiorato → si sposta** | ✅ | ✅ (18 live) | 🟡 **non esiste**: `InpPendingExpiryMin=90` cancella, non sposta | **1 + delta** |
| **Correlazione come filtro di direzione** | ✅✅ (S&P, EURUSD, USOIL, forza valutaria) | ✅ 31/08 C16 · ❌ **Paolo 24/08: _"le correlazioni sono andate tutte a farsi fottere"_** | 🟡 **DOPPIA RISPOSTA MISURATA**: bocciata come filtro sulle Aperture (R101/G3, incoerente Dow↔DAX) · **promossa** sul night-box (PF 1,2→2,05, `REGISTRO_TEST.md` r.435) | **contraddizione, §1.4** |
| **VWAP come filtro direzionale M15** | ✅ _"in M15 fa proprio lo spartia[cque]"_ | ✅ (18 live) | 🔴 **MISURATO E BOCCIATO**: R101 `07_vwap` PF **+0,007** Dow / **−0,061** DAX → incoerente | **1 vs 1 — vince la misura** |
| **R:R minimo 1:1** | ✅ **dichiarato ×2** | 🟡 `[INFERITO]` da 2 casi (28/08) | 🟡 sedia 770411 esce a **1R / 3R / 4R**, non 1:1 | **1 + delta** |
| **Bank holiday = giornata declassata** | ✅ | ✅ 31/08 M10 | ❌ **non esiste nessun flag** | **1 + buco nostro** 🚩 |
| **Size in due tranche** | ✅ 5+5 (1/2+1/2) | ✅ 1/3+2/3 (18 live) | ❌ una sola entrata per ciclo (`InpOneTradePerDay=true`) | **1 + delta** |

### 🏆 IL DATO PIÙ SOLIDO DELLA GIORNATA
**L'offset del pendente sugli indici: 10 punti indice = 1000 punti MT5.**
È l'unico valore che regge in **due strade davvero indipendenti** — la sua pratica
(dichiarata "RICORRENTE" su 18 live prima di oggi) **e** la nostra griglia di R2, dove
750-1500 formano un altopiano e il 1000 è il **centro** — **e per il quale la nostra
misura esiste già.** **Nessuna azione: la conferma non muove un parametro, conferma che
non va mosso.**

---

## 1.4 ⚔️ LE CONTRADDIZIONI — dentro la live e fra le live

| # | Contraddizione | Le due citazioni | Gravità |
|---|---|---|---|
| **X1** | 🔴 **Insegna un ingresso che il suo piano vieta** | Insegna: _"la strategia prevede un ingresso alla rottura dei minimi della notte **senza aspettare neanche l'apertura** della candela successiva, cioè metto un ordine pendente a circa dieci punti"_ ⟷ Dichiara, **tre volte**: _"**il mio piano non prevede un ingresso prima dell'apertura**"_ · _"sono **rarissime le volte** che entro"_ (tutte r.27/31/37) | 🔴 **ALTA — interna, nella stessa live.** Il meccanismo che detta agli allievi **lui non lo esegue**. Un allievo esce di lì con una regola che il maestro non applica |
| **X2** | 🔴 **Ordini pendenti: tre live, tre posizioni** | 07/09: _"metto un ordine pendente a dieci punti"_ (e ne piazza almeno 3) ⟷ 31/08: _"**io non metto gli ordini pendenti** e la motivazione che vi do…"_ ⟷ 28/08: _"la pazienza di pianificare il trade **con ordini pendenti** su due livelli"_ | 🔴 **ALTA — già segnata come X1 il 31/08, e oggi si aggrava.** Il metodo d'ingresso **non è deciso**. 👉 **Conseguenza per noi: da questa fonte NON si ricava una regola sul trigger d'ingresso.** Si ricavano i LIVELLI, non il modo di entrarci |
| **X3** | 🟡 **Correlazioni: Emiliano vs Paolo, stessa accademia** | Emiliano oggi ci costruisce sopra tutta la direzione (S&P, EURUSD, USOIL, forbice) ⟷ Paolo 24/08: _"le correlazioni sono andate **tutte a farsi fottere** in questo periodo"_ | 🟡 **MEDIA.** 🟢 **E noi abbiamo il numero, loro l'opinione** — anzi **due** numeri opposti (R101/G3 boccia, R2 promuove): _"il filtro giusto dipende dalla strategia"_ (`REGISTRO_TEST.md` r.438). **Nessuno dei due ha ragione in astratto** |
| **X4** | 🟡 **Money management: 1/3+2/3 diventa 1/2+1/2** | 18 live: _"1/3 + 2/3 (il 2/3 deve essere eseguito)"_ ⟷ oggi: _"**con 5 con 10 lo divido in 2**, quindi sono entrato adesso con 5"_ · _"la parte alta la divido in **5 e 5**"_ | 🟡 **MEDIA** — la proporzione della scala non è stabile |
| **X5** | 🟡 **La gerarchia notte / giorno-prima si appiattisce** | 27/08 (M15, con conferma da lui): _"**Dai massimi del giorno prima avrà più forza**"_ ⟷ oggi: _"i punti d'ingresso quali sono? sono **massimi e minimi della notte, massimi e minimi del giorno prima**, i veri punti d'ingresso, quelli forti"_ — **elencati alla pari** | 🟡 **MEDIA.** 📌 **Ci riguarda**: la nostra sedia `770411` vive **solo** sugli estremi della notte. La gerarchia del 27/08 la penalizzava; oggi la parifica. **Nessuna delle due versioni è misurata: restano due opinioni** |
| **X6** | 🟡 **Il TF dell'ostacolo "media 200"** | 18 live: **media 200 H1** ⟷ oggi: _"in **H4** abbiamo la media, quindi l'ingresso è assolutamente a cancellare"_ | 🟡 **BASSA-MEDIA** |
| **X7** | 🟡 **La forbice XAU/USD si ribalta in 40 minuti e la lettura si adatta dopo** | Pre-apertura: _"XAU −4,6 … USD +0,8 … la direzione che dovrebbe prendere è **short**"_ ⟷ Post-apertura: _"da 4.5 a **meno 3,3** con un dollaro che da più 0,8 va a **meno di 0,1** … adesso **l'oro diventa più interessante**"_ · _"**l'apertura cambia le carte in tavola**"_ | 🟡 **MEDIA — ma onesta**: la ammette in diretta. ⚠️ **Per noi vuol dire che quel filtro ha una vita utile di minuti**: non è meccanizzabile su una sedia che arma alle 07:59 e non guarda più |

---

## 1.5 🚩 LE BANDIERE — col metro di casa

| # | Bandiera | Citazione che la prova | Verdetto |
|---|---|---|---|
| **B1** | 🟢 **MARTINGALA / GRIGLIA / RECOVERY** | grep sull'intero file: **0 occorrenze**. E il contrario è mostrato: al primo ingresso andato male **non raddoppia**, sposta lo stop e riduce | ⚪ **ASSENTI** |
| **B2** | 🟢 **NO-STOP-LOSS** | _"lo stop dovrò mettere … Giorgia stop sopra il massimo della candela M15"_ · _"dove metti lo stop viene **dopo** la scelta del trigger d'ingresso"_ | ⚪ **ASSENTE. Posizione opposta, esplicita** |
| **B3** | 🟢 **TRUCCHI ANTI-PROP** | grep `prop`/`FTMO`/`challenge`/`funded`/`drawdown`: **0 occorrenze** come termini prop | ⚪ **ASSENTI. Materiale pulito** |
| **B4** | 🟡 **Ingresso dichiarato dallo stesso relatore come RISCHIOSO, ed eseguito lo stesso** | _"la zona dove ho messo l'ordine è **rischio** perché siamo sul floor … è **abbastanza rischioso** entrare proprio lì, anzi se venire la verità **io tendenzialmente faccio il contrario**"_ · poi lo lascia e commenta _"sono stato un po' **imperativo**"_ ⚠️ `[TRASCRITTO dubbio]`, probabile **"imprudente"** o **"impulsivo"** | 🟡 **AMBRA, autodenunciata** — didattica sull'errore, come il 27/08 (B6). Mitigato dalla size: _"ho messo una **size ridicola**"_ |
| **B5** | 🟡 **Un secondo ingresso in un mercato dichiarato "anomalo"** | _"ricordatevi che il mercato è **anomalo** perché siamo in **assenza di volumi** … possono essere **movimenti di rumore**"_ — e in quella stessa giornata **entra due volte** | 🟡 **AMBRA.** 🟢 Mitigato: si autodichiara _"cautelativo"_ 5 volte e usa size ridotta. Ma **la coerenza piena sarebbe stata non operare** |
| **B6** | 🟡 **"promessa di guadagno" — nessuna da Emiliano, e Fabio la NEGA esplicitamente** | Fabio: _"Molti in giro propongono cose vincenti per guadagnare, per fare soldi … **Strumenti magici non esistono** … il mercato rimane sempre per natura **imprevedibile**"_ | 🟢 **DA SEGNARE A LORO FAVORE.** In una presentazione commerciale, la frase più venduta è quella che **non** viene detta |
| **B7** | 🟡 **Contenuto commerciale con trial estesa offerta in diretta** | _"se vuoi prendiamo altre due settimane, diamo una **trial di due settimane**"_ | 🟡 **AMBRA — conflitto d'interesse dichiarato apertamente** (_"lo conosco da tanto"_, _"me l'avete chiesto voi"_). ⛔ Non è materiale tecnico: **§5, scarti** |
| **B8** | ⚪ **Motivo personale di salute** dichiarato come causa di riduzione del carico e spostamento del calendario live | (nel testo) | ⚪ **NON ESTRAIBILE E NON PERTINENTE.** Registrato solo per l'effetto pratico: **live spostate a mercoledì**, giovedì sera niente |

**Conteggio: 8 bandiere — 3 VERDI (assenza confermata dei difetti classici), 4 AMBRA,
1 neutra. ZERO ROSSE. È il materiale più pulito delle quattro live analizzate.**

---

# 📋 PARTE 2 — LA SCHEDA

```
FILE            docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-07.txt
                (52.296 byte, 73 righe; la r.73 da sola è 27.551 car. = 53%)
RELATORE        EMILIANO [TRASCRITTO: chiamato "Emi"/"Emiliano" da Fabio, r.43/71]
                + FABIO La Rosa (ospite) + GIACOMO (regia)
CANALE          FTD/ABTG [INFERITO dal contesto di casa: stessa serie di live,
                stessi allievi, stesso "algoritmo"/tabella forza valute]
OGGETTO         Analisi e operatività DAX in diretta all'apertura europea, in
                giornata di BANK HOLIDAY USA+CANADA (Labor Day) + demo
                commerciale di una suite di profili MT5 (prodotto terzo)
DATA/ORA        lunedì 07/09/2026, avvio registrazione 08:30 (fuso NON dichiarato)
```

## 2.1 🔢 PARAMETRI CON VALORE — tutti i numeri della live

| # | Valore | Contesto | Citazione | Etichetta |
|---|---|---|---|---|
| **P1** | **10 punti** (indici) | offset dell'ordine pendente oltre il livello | _"metto un ordine pendente a circa **dieci punti** … per quanto riguarda invece gli indici **a dieci**"_ | 🟢 `[TRASCRITTO chiaro]` — in lettere, ripetuto |
| **P2** | **3 pip** (valute) | idem | _"si mette per le valute a **tre pip**"_ | 🟢 `[TRASCRITTO chiaro]` |
| **P3** | **6 candele H1** | definizione operativa di "notte" | _"quindi **sono 6 candele** … 1,2,3,4,5,6, quindi 1,2,3,4,5,6"_ | 🟢 `[TRASCRITTO chiaro]` — conta ad alta voce due volte |
| **P4** | **1 candela doppia il lunedì** su BCM | eccezione al conteggio | _"in **BCN** ha soltanto, diciamo il **lunedì ha questa doppia candela** perché è **l'orale dei servizi** che cambia"_ | 🟡 `[TRASCRITTO dubbio]` — "BCN"→**BCM**, "l'orale dei servizi"→probabile **"l'orario dei server"**. **Il senso è ambiguo: lo dico invece di indovinare** (§3.4) |
| **P5** | **R:R ≥ 1:1** | soglia minima dichiarata | _"il rapporto deve essere **almeno 1 a 1**"_ · _"devo avere uno stop di rischio di rendimento **1 a 1 almeno**"_ | 🟢 `[TRASCRITTO chiaro]` — 🆕 §1.1.4 |
| **P6** | **stop 40 pt / target 20 pt = R:R 0,5** | l'esempio che boccia | _"se ho uno **stop di 40 punti non posso prendermene 20**"_ | 🟢 `[TRASCRITTO chiaro]` |
| **P7** | **5 contratti** poi **5 + 5 = 10** | size in due tranche | _"ho messo una **size ridicola**, ho messo **5 contatti**"_ · _"con 5 con 10 **lo divido in 2**"_ · _"siamo **5 più 5**"_ | 🟡 `[TRASCRITTO chiaro]` sul numero — ⚠️ **"contatti"=contratti**. **Nessun valore in € o in % del conto: la size NON è confrontabile con la nostra** |
| **P8** | **~30 punti** | escursione contro la posizione sul livello sbagliato | _"lui va su di circa **30 punti**"_ | 🟡 `[TRASCRITTO chiaro]` |
| **P9** | **>50 punti** | recupero del DAX dopo l'apertura | _"ha recuperato **più di 50 punti** sui **26 mila**"_ | 🟢 `[TRASCRITTO chiaro]` |
| **P10** | **20-30 secondi / ultimo minuto** | finestra in cui "si decide" la candela H1 | _"tendenzialmente negli **ultimi 20-30 secondi o nell'ultimo minuto** ci sarà un movimento"_ | 🟢 `[TRASCRITTO chiaro]` — 🆕 V17 |
| **P11** | **XAU −4,6 · USD +0,8** | forbice della forza valutaria pre-apertura | _"la differenza che c'è tra **XAU-4,6 e XAU-0,8**"_ | 🔴 `[TRASCRITTO dubbio]` — **il secondo "XAU" è quasi certamente "USD"**: due righe dopo dice _"la forbice tra **il dollaro e l'oro**"_. **I due valori sono usabili solo come esempio, non come dato** |
| **P12** | **XAU −3,3 · USD −0,1 · AUD +2** | la stessa forbice **dopo** l'apertura | _"da 4.5 a **meno 3,3** con un dollaro che da più 0,8 va a **meno di 0,1**"_ · _"**Audi più 2**"_ | 🔴 `[TRASCRITTO dubbio]` — "Audi"=**AUD**. §X7 |
| **P13** | **regola della forbice: da −4,6 a −4,5 l'oro SALE; da −4,5 a −4,6 l'oro SCENDE** | direzione dal segno del delta | _"da 4,6 vado a 4,5 **l'oro sale**, da 4,5 vado a 4,6 **l'oro scende**"_ | 🟢 `[TRASCRITTO chiaro]` — ✅ **internamente coerente** (meno negativo = più forte) |
| **P14** | **25.893** | supporto weekly del DAX | _"un livello molto importante a **25,8,93**"_ | 🟡 `[TRASCRITTO chiaro]` sulle cifre, ricomposto **25.893** |
| **P15** | **26.110** | chiusura pre-apertura / minimi notte | _"**26,11**, 26,11 siamo qui"_ | 🟡 `[TRASCRITTO dubbio]` — troncato |
| **P16** | **26.000** | numero tondo citato come livello | _"siamo **sopra un numero tondo importante**"_ + _"sui **26 mila**"_ | 🟢 `[TRASCRITTO chiaro]` |
| **P17** | **…041 / …065 / …067 / …075 / …078 / …110 / …117** | livelli intraday, tutti **troncati** | _"c'è un livello a **110**"_ · _"**117** c'è un altro livello"_ · _"è arrivato il **67**"_ · _"lui è andato fino a **65**"_ · _"su questo livello a **75**"_ | 🔴 `[TRASCRITTO dubbio → NON RICOSTRUIBILI]`. ⛔ **Non li ricostruisco.** La lezione del 27/08 (il "115" che era "315") vale identica: **su questa fonte i prezzi troncati non si firmano** |
| **P18** | **50 profili MT5 / 100+ MT4** | prodotto terzo | _"Sulla Metatrader 5 abbiamo soltanto questi **50 profili**. Sulla Metatrader 4 ne ho fatti **più di 100**"_ | 🟢 `[TRASCRITTO chiaro]` · ⚪ **non operativo, §5** |
| **P19** | **5.000-5.150 $** | prezzo dichiarato di e-Signal/Advanced GET | _"una piattaforma professionale, che paga i **5.150 dollari**"_ · _"ho pagato un occhio della testa, **5.000 dollari**"_ | 🟡 `[DICHIARATO, NON VERIFICATO]` · ⚪ §5 |
| **P20** | **0,25%** | "multiplo" del movimento di mercato secondo Fabio | _"può andare a fare almeno lo **0,25%** … in genere il mercato si muove **per multipli di 0,25**"_ | 🔴 `[DICHIARATO, NON VERIFICATO]` — **nessun campione, nessun mercato, nessuna finestra.** §5 |
| **P21** | **2011 / 15 anni / >10 anni** | anzianità dichiarata di Fabio e del progetto | _"si occupa di queste cose da **15 anni**, abbiamo iniziato nel **2011**"_ · _"lavoriamo sul progetto MQLSuite **più di 10 anni**"_ | 🟡 `[DICHIARATO, NON VERIFICATO]` — ⚠️ 2011→2026 sono **15 anni**: internamente coerente |

## 2.2 ⚙️ I MECCANISMI — con la citazione che li prova

| # | Meccanismo | Citazione testuale | Etichetta |
|---|---|---|---|
| **M1** | **Catena multi-timeframe obbligatoria PRIMA di ogni ingresso: W1 → D1 → H4 → H1 → M15** | _"dobbiamo attenerci semplicemente a **due regole**. La prima regola è **l'analisi del trend** e poi facciamo **l'analisi multi-frame**"_ · _"i due timeframe più principali sono il **weekly e il daily**, tutti e due sono in direzione"_ | 🟢 `[TRASCRITTO chiaro]` · 🔁 identico a 28/08 (le "due regole") e 31/08 (C1) |
| **M2** | **I punti d'ingresso "veri" sono solo due: estremi della NOTTE ed estremi del GIORNO PRIMA** | _"i punti d'ingresso quali sono? sono **massimi e minimi della notte, massimi e minimi del giorno prima**, i veri punti d'ingresso, **quelli forti**"_ | 🟢 `[TRASCRITTO chiaro]` — ⚔️ X5 |
| **M3** | **Prima di piazzare: censimento degli OSTACOLI** | _"io quando metto l'ordine pendente **guardo sempre se ci sono degli ostacoli**, guardate sempre se ci sono degli ostacoli, guardate sempre questo"_ — ostacoli citati oggi: **VWAP**, **media 200 H4**, **S/R weekly/daily**, **pre-section**, **numero tondo** | 🟢 `[TRASCRITTO chiaro]` — 🔁 i **5 ostacoli** del consolidamento 18 live, al completo |
| **M4** | **Un ostacolo ANNULLA l'ingresso, non lo declassa soltanto** | _"in H4 abbiamo la media, quindi l'ingresso è **assolutamente a cancellare** … lo prendo in considerazione **solo quando mi apre [il corpo] della candela sotto la media**"_ — e **cancella davvero** il pendente in diretta | 🟢 `[TRASCRITTO chiaro]` — 🆕 **la forza della regola è nuova**: prima era "declassa", oggi è "cancella" |
| **M5** | **Trigger di conferma = APERTURA della candela oltre il livello, non il tocco** | _"aspetto che mi **apra la ca[ndela] sotto il VWAP**"_ · _"bisogna aspettare la ca[ndela] **che mi apra di sotto**"_ · _"o mi apre **totalmente sotto** e quindi **questo è il trigger**"_ | 🟢 `[TRASCRITTO chiaro]` — 🔁 27/08 M8 ("il culetto della candela mi apre sotto") |
| **M6** | **Retest progressivo su DUE livelli: metà sul primo, metà sul secondo (più importante)** | _"io ho stabilito un **retest progressivo** sul mio e il **secondo retest sulla parte più importante** … la parte alta la **divido in 5 e 5**"_ | 🟢 `[TRASCRITTO chiaro]` |
| **M7** | **Ordine SFIORATO → si sposta più in là** | _"mi ha **sfiorato l'ordine**, quando mi sfiora l'ordine **devo necessariamente portarlo su** perché la prossima volta che ci va **probabilmente lo supera**"_ | 🟢 `[TRASCRITTO chiaro]` — 🔁 e stavolta con la **motivazione** esplicita (18 live avevano solo la regola) |
| **M8** | **Lo STOP viene DOPO il trigger, mai prima; e va sopra l'ostacolo che "garantisce di più"** | _"dove metti lo stop **viene dopo la scelta del trigger d'ingresso e del punto d'ingresso**"_ · _"se VWAP e media sono lì vicine, **ce lo metto sopra quella che mi garantisce di più**"_ | 🟢 `[TRASCRITTO chiaro]` — 🟢 **regola di priorità netta e meccanizzabile** |
| **M9** | 🆕 **Il movimento che "decide" la candela H1 sta negli ultimi 20-30 secondi** | _"siamo vicini all'apertura di una nuova candela in H1 e sappiamo che in prossimità della nuova candela ci sarà un movimento, tendenzialmente negli **ultimi 20-30 secondi o nell'ultimo minuto**, che ci darà cognizione di dove andrà la nostra operazione"_ — poi lo osserva in diretta al minuto **9.57 → 9.59:10** | 🟡 `[TRASCRITTO chiaro]` **come affermazione**, 🔴 `[DICHIARATO, NON VERIFICATO]` **come fatto**. **Un solo caso osservato in diretta. Non è una misura** |
| **M10** | **Bank holiday USA → si declassa la giornata: niente correlazione, size ridotta, ingressi "cautelativi"** | _"io sono stato **cautelativo esclusivamente perché il mercato americano è chiuso**"_ · _"consiglio di operare … proprio per questo movimento"_ ⚠️ `[TRASCRITTO dubbio]`: probabile **"sconsiglio"**, il senso della frase è di cautela | 🟡 `[TRASCRITTO in parte dubbio]` — 🔁 31/08 M10 |
| **M11** | **Correlazione DAX ↔ USOIL con causale dichiarata** | _"perché **è il petrolio**? Perché è un indice dove i pesi delle azioni all'interno dell'indice è **un indice automotive**, quindi prevalentemente orientato e mosso dal peso delle azioni **sull'industria automobilistica che dipende da quello che è il petrolio** … **l'USOIL sale e il DAX scende**"_ | 🔴 `[DICHIARATO, NON VERIFICATO]` · 🔁 identica a luglio (§3.5) |
| **M12** | **Forbice della forza valutaria: più i due valori sono distanti, più la direzione è forte** | _"si va a prendere quelle valute che hanno una **distanza ampia tra i valori** … **più sono distanti più prende quella direzione**"_ · _"io cerco … **uno rosso e uno verde**"_ | 🔴 `[DICHIARATO, NON VERIFICATO]` — ⚠️ **nessuna soglia numerica**: "distante" non è un numero. **Non meccanizzabile così com'è** |
| **M13** | **Il VWAP è "spartiacque" e va letto in M15** | _"è molto interessante lavorarlo **in M15** perché in M15 fa proprio lo **spartia[cque]**"_ · _"è sempre stato diciamo **uno spartiacque**"_ · _"rappresenta i **volumi per prezzo**, quindi **questa non è una media**"_ | 🟢 `[TRASCRITTO chiaro]` — 🔴 **da noi già misurato e bocciato**, §3.3 |
| **M14** | **Il target è un livello di S/R, non un multiplo** | _"la **linea arancione è l'obiettivo** … è un **livello di supporto weekly** che in questo momento diventa il suo obiettivo perché **i supporti di resistenza attraggono i prezzi**"_ | 🟢 `[TRASCRITTO chiaro]` — 🔁 |
| **M15** | **Chiusura della live con stop E target già definiti** | _"con questo **sappiamo già tutto**: stop … **stop ben definito e target ben definito**"_ | 🟢 `[TRASCRITTO chiaro]` — 🔁 27/08 M17 |

## 2.3 📢 REGOLE PROP CITATE
⚪ **NESSUNA.** Verificato per grep sull'intero file: `prop` / `FTMO` / `challenge` /
`funded` / `drawdown` / `equity` / `margine` → **zero occorrenze** come termini prop.
**Niente da confrontare con `report/METRO_PROP.md`.** ✅ **Quarta live consecutiva senza
una sola menzione del mondo prop** — vale come osservazione strutturale: **questa
accademia non insegna a passare una challenge.**

## 2.4 📈 NUMERI DI PERFORMANCE
⚪ **NESSUNO.** Nessun win rate, nessun profitto, nessun drawdown, nessun numero di
operazioni, nessun risultato di conto in tutta la live. **Nemmeno l'esito della sua
operazione del giorno viene dichiarato** (chiude la live con la posizione aperta).
🟢 **Da un lato è un buco; dall'altro è un'assenza di vanteria che va riconosciuta.**
L'unico numero venduto è quello di **Fabio** (P19, P20, P21) — e Fabio **nega**
esplicitamente le promesse di guadagno (B6).

## 2.5 🕐 GLI ORARI — e perché **non ne converto nessuno**

**Gli orari pronunciati, tutti:**
| orario | contesto | citazione |
|---|---|---|
| **"circa alle nove e mezzo"** | quando parlerà Fabio | _"circa alle **nove e mezzo** saremo bravissimi"_ |
| **"mancano dieci minuti"** | all'apertura del DAX | _"mancano **dieci minuti** per cui vediamo la chiusura"_ |
| **"all'otto"** | l'apertura del mercato ⚠️ | _"l'apertura sarebbe un po' **in termine all'otto**"_ `[TRASCRITTO dubbio]` |
| **"9.54" → "9.56" → "9.57" → "59, 59:10"** | conto alla rovescia verso la candela H1 | _"adesso sono le **9.54**"_ · _"quando saremo al **59** lì capiamo cosa succede"_ |

🔴 **IL FUSO NON È DICHIARATO. NEMMENO UNA VOLTA. NON CONVERTO NIENTE.**
Regola di casa: **un orario col fuso sbagliato è peggio di nessun orario.**

📌 **Ma una nota tecnica va detta, perché è la stessa lezione che sta in `CLAUDE.md`:**
nella stessa live convivono **due orologi diversi**. _"l'apertura … **all'otto**"_ è
compatibile con l'**ora del grafico** (server: DAX apre 08:00 server = 09:00 IT); _"sono
le **9.54**"_ è compatibile con l'**orologio del PC** (ora locale). ⚠️ **Se sono davvero
due orologi diversi, i suoi numeri orari non sono confrontabili fra loro** — figuriamoci
coi nostri. 🔎 Questo è **esattamente** l'errore che ci è costato il 06/08 (_"prima di
dire che un EA è in ritardo: stabilire in quale ora è scritto il numero"_).
👉 **Etichetta finale: `[INCERTO]`. Nessun orario di questa live entra in nessun `.set`.**

---

# 🧭 PARTE 3 — CONFRONTO COL REPO (verificato nel sorgente, mai a memoria)

## 3.1 📋 Il quadro d'insieme

| Elemento della live | Stato in casa — **file e riga** | Verdetto |
|---|---|---|
| Offset pendente **10 pt indice** | ✅ `ABTG_MaxMinNotte.mq5` r.140 · `.set 770411` r.21 = **1000 pt MT5** · **MISURATO** (R2) | 🟢🟢 **LO FACCIAMO GIÀ, IDENTICO, E MISURATO** |
| Offset pendente **3 pip valute** | ✅ `ABTG_PostNews.mq5` r.95-96 = **3.0 / 3.0** | 🟢 **LO FACCIAMO GIÀ** |
| **Retest / mai inseguire** | ✅ geometria `RETEST` di `ABTG_DAX_Apertura_EU` (`InpRetestOffsetPts=200`, r.277) | 🟢 **LO FACCIAMO GIÀ** |
| **Stop tecnico sempre presente** | ✅ `InpSLMode` + `InpAtrSLmult=2.5` + cap **0,65%/sedia** | 🟢 **LO FACCIAMO GIÀ, e meglio** (cap di rischio, lui non ne ha) |
| **Chiusura di fine giornata** | ✅ `InpCloseHour/Min = 17:30` server + `InpCloseAtEnd=true` | 🟢 **LO FACCIAMO GIÀ** |
| **Guardia spread** | ✅ `.set 770411` r.59 `InpMaxSpread=500` — **acceso il 28/08** dopo la live di allora (`FILTRO_SPREAD_MAXMINNOTTE_2026-08-28.md`) | 🟢 **già chiuso.** ⚠️ Il valore resta una **stima ragionata**, non una misura di spread BCM |
| **VWAP come filtro direzionale** | 🔴 **R101 gradino `07_vwap` — BOCCIATO** (§3.3) | 🟢 **NOI ABBIAMO IL NUMERO, LUI L'OPINIONE** |
| **Correlazione come filtro** | 🟡 **due misure opposte**: bocciata su Aperture (R101/G3), promossa sul night-box (R2) | 🟡 **dipende dal motore — e lo sappiamo per misura** |
| **Finestra della notte** | 🔴 **MAI MISURATA** (§3.2) | ⚠️ **DOMANDA APERTA LEGITTIMA** |
| **Ordine sfiorato → si sposta** | ❌ **non esiste**: `InpPendingExpiryMin=90` **cancella**, `InpEntryCutoffHour/Min=08:30` **cancella** | 🟡 **DELTA REALE** — ⛔ ma **modificarlo cambierebbe il motore**, non un parametro |
| **Flag bank holiday** | ❌ **non esiste** · `InpUseNewsFilter=false` su entrambe le sedie MaxMinNotte | 🚩 **BUCO NOSTRO — 2ª segnalazione in 5 giorni** |
| **Size in 2 tranche** | ❌ `InpOneTradePerDay=true` — **un solo ciclo al giorno** | ⚪ **scelta deliberata**, non un buco |

## 3.2 🌙 LA FINESTRA DELLA NOTTE — la risposta completa

**Domanda del mandato:** *il nostro 23:00–04:59 è stato MISURATO contro alternative, o
scelto e mai più toccato?*

**Risposta: SCELTO. La prova, con la fonte:**

1. **I CSV delle corse** (§1.1.1): in **324 righe** su 9 file, `InpBoxStartHour` e
   `InpBoxEndHour` hanno **un solo valore distinto ciascuno**. Mai variati.
2. **Il registro** (`REGISTRO_TEST.md` r.414) descrive la corsa così:
   _"Box 23:00-04:59 server, piazza 07:59, cutoff 08:30. **Sweep direzione x buffer**, SL
   ad ATR, rischio 1%."_ → **la finestra è nel preambolo, non fra gli assi**.
3. **Il raffinamento** (r.426): _"Sweep **buffer x SL-ATR x filtro box x correlazione S&P**"_
   → di nuovo, **la finestra non c'è**.
4. **Nemmeno il gemello dell'oro**: `maxmin_oro.ps1` r.128-130 pinna
   `InpBoxStartHour=22||22||0||22||**N**` — la **`N` finale** significa **non ottimizzato**.
5. **E le due varianti d'oro non sono nemmeno d'accordo fra loro**: il `.set` della sedia
   viva `770402` dice **23:00-04:59**, i file di prova dicono **22:00-06:59**. ⚠️ Questa
   incoerenza **era già agli atti** (`PIANO_PROVA_GENERALE_FTMO.md` §X5, risolta a favore
   del `.set`) — ma **nessuna delle due è stata misurata contro l'altra.**

**La cosa più vicina a una misura che esiste in casa** — e va detta, perché è vera e utile:
📊 **`risultati_archivio/MaxMin_Oro/NOTTE_ORO.md`** — studio su **371 notti**
(28/02/2025→04/08/2026) che misura **ora per ora quale ora della notte si muove**:

| ora server | quota mediana sull'ampiezza della notte |
|---|---:|
| 22:00 | 22,0% |
| 23:00 | 25,8% |
| 00:00 | 26,9% |
| 01:00 | 35,7% |
| **02:00** | **47,9%** ⭐ |
| 03:00 | 34,9% |
| 04:00 | 28,0% |
| 05:00 | 22,5% |
| 06:00 | 34,6% |

🔎 **Come si legge questo, onestamente:**
- ✅ È una **misura vera** su un campione grande — **ma è sull'ORO, non sul DAX**, e misura
  **dove si muove il prezzo di notte**, non **quale box produce il miglior breakout**.
  Sono **due domande diverse**: la seconda non è mai stata posta.
- ✅ Il nostro box `23:00–04:59` **contiene** l'ora regina (02:00) e **la tiene al centro**.
- ⚠️ Sotto la lettura **(a)** della sua finestra (02:00–07:59), l'ora regina sarebbe **il
  primo minuto del box** — posizione peggiore per un box che deve **contenere** l'escursione.
  📌 **Ma questo è un ragionamento, non una misura, e su un altro simbolo. Vale come
  ipotesi da testare, non come argomento per chiudere la domanda.**

> ### 🎯 CONCLUSIONE OPERATIVA
> La definizione di Emiliano **non si archivia come "opinione battuta da una nostra
> misura"** — quella misura **non c'è**. Si archivia come **SPUNTO S1**, con la porta già
> costruita: il round **PREOPEN DAX**, preparato e mai lanciato, che misura
> `InpPrevWindowMin` da 60 a 300 minuti. **La sua definizione (360 min) sta appena fuori.**
> ⛔ **E il round ha criteri congelati: se si vuole il 360, si dichiara PRIMA del lancio.**

## 3.3 📉 IL VWAP — questa sì che è già stata misurata, ed è stata bocciata

Il mandato chiedeva di verificare, non fidarsi. Verificato:

- **`R101_CRITERI.md` r.231**, la riga che definisce il gradino:
  | **07** | `07_vwap` | `InpUseVwapFilter` | 0 → 1 | 0 → 1 | **live Emiliano, non del corso** |
  👉 **Quel gradino esiste PROPRIO PERCHÉ lo aveva detto lui**, in una live precedente.
- **`R101_REFERTO.md` r.60 e r.75**, i numeri:

| simbolo | IS (profit · PF · DD · n) | OOS | **Δ PF** |
|---|---|---|---:|
| **Dow** | +6.440 · **2,152** · 2,80 · 47 | +4.096 · 1,278 · 3,36 · 77 | **+0,007** |
| **DAX** | +9.281 · 1,619 · 3,25 · 107 | +8.530 · 1,337 · 5,20 · 160 | **−0,061** |

- **Verdetto agli atti (r.93):** _"PF piatto (+0,007) … **PF peggio** (−0,061) … ❌
  **incoerente sul PF** … niente candidato (G2 sul DAX fallisce)"_.
- **E c'è un secondo verdetto, più recente e più duro** (`REGISTRO_TEST.md` r.944):
  `ABTG_VwapRevert` su **D30EUR M15** — cioè **esattamente il TF e il simbolo di cui parla
  lui** — **FALSIFICATO il 03/09/2026 al cancello S0**, tutte e 4 le celle negative:
  _"il motore perde in media **PIÙ dello spread**: non è un problema di costo, è un
  problema di **edge**"_ · _"il meccanismo VWAP-reversion su D30EUR M15 **è arato**"_.

> 🟢 **Su questa voce la risposta è netta e nella direzione opposta a quella della notte:
> il VWAP in M15 sul DAX NON è una domanda aperta. È misurato, due volte, e non regge.**
> Il suo _"in M15 fa proprio lo spartiacque"_ **si archivia**, con la fonte.

⚠️ **Con la precisazione onesta che i due test misurano due cose diverse:** R101/07 misura
il VWAP **come filtro appiccicato**, `ABTG_VwapRevert` lo misura **come motore**. Lui lo usa
in un terzo modo ancora: **come "ostacolo" che cancella un ingresso già deciso.** Quella
terza forma **non è mai stata misurata** — 📌 ma la regola di casa scritta in
`VWAPREVERT_TESI.md` r.80 dice quanto valgono i filtri appiccicati:
**"filtro aggiunto dopo = 0 successi su 5"**. **Il precedente è pesante.**

## 3.4 🕰️ LA "DOPPIA CANDELA DEL LUNEDÌ SU BCM" — dove tocca una domanda aperta di casa

**La citazione, integrale, con tutti i suoi difetti (r.27):**
> _"quindi sono 6 candele, in realtà in **BCN** ha soltanto, diciamo **il lunedì ha questa
> doppia candela** perché è **l'orale dei servizi che cambia**, nei momenti in cui adesso
> noi andiamo a calcolare, quindi **può essere che abbiamo diverso**"_

🔴 **`[TRASCRITTO dubbio]` — e il senso è genuinamente AMBIGUO. Lo dico invece di
indovinare.** Le letture possibili:

| lettura | cosa significherebbe | verificabile? |
|---|---|---|
| **(i)** l'apertura settimanale di BCM produce **una candela H1 in più** rispetto agli altri giorni (settimana che apre a mercato aperto) | il **conteggio delle 6 candele va corretto il lunedì** | ✅ misurabile in 1 passata |
| **(ii)** BCM ha un **offset di fuso diverso** da altri broker, quindi le sue candele "non tornano" con quelle degli allievi | tocca **direttamente** la domanda aperta di `DA_FARE.md` §3 | ✅ misurabile |
| **(iii)** riferimento al **cambio di ora legale** del server | 🔴 **fuori stagione**: il cambio europeo è il **25/10/2026** | ⚠️ improbabile oggi |

📌 **Perché la registro comunque: tocca il punto più caro della casa.**
`DA_FARE.md` §3, testuale:
> _"**Il server BCM cambia ora legale?** La nostra regola ('server = ora italiana − 1') ha
> sempre avuto la nota 'in questo periodo dell'anno' e **non è mai stata verificata
> d'inverno**. Se BCM NON cambiasse, dal **25 ottobre 2026** tutti gli `InpSessionHour`
> degli EA VIVI sarebbero sbagliati di un'ora (**DAX, aperture USA, fasce orarie, box
> notturno**). … **Scadenza: prima del 25/10/2026.**"_

🟢 **E la misura è già pronta e non richiede nessun codice nuovo:** `DA_FARE.md` §3-bis
contiene la riga di lancio completa (`prepara_broker_esterno.ps1 -SimboloFuso "D30EUR"`),
dichiarata **"10 minuti, sul PC di backtest"**, che legge l'ora della prima barra del DAX
su date campione di sei mesi diversi.

> ⛔ **Non è uno spunto nuovo: è un promemoria di scadenza che una fonte esterna ha appena
> sfiorato.** L'unica cosa che aggiunge è **urgenza**: mancano **7 settimane** al 25/10.

## 3.5 🛢️ LA CORRELAZIONE DAX ↔ PETROLIO — no, non l'abbiamo mai misurata. E c'è un'AZIONE dimenticata.

**Cercato, non ipotizzato.** Grep su `USOIL` / `petrolio` in tutto il repo:

| dove compare | come |
|---|---|
| `agent/config.py` r.47 | ticker `CL=F` nel report macro |
| `backtest_pipeline/scan_market.ps1`, `notte_larry.ps1`, ecc. | **solo come simbolo in una lista**, mai come coppia col DAX |
| `REGISTRO_TEST.md` (gap-fill, R36) | USOIL trattato **da solo**, mai correlato |
| `report/SWEEP_MECCANISMI_2026-08-23.md` S11 | paper EIA **sul petrolio da solo** — scartato per campione (95 mercoledì) |
| 🔴 **`docs/live_emiliano/ANALISI_LIVE_luglio.md` r.19-20** | **"Correlazione utile: petrolio su → DAX giù (peso automotive nel DAX)"** + **"AZIONE: aggiungere la correlazione petrolio-DAX al report"** |

🔴 **Zero occorrenze di una MISURA della coppia D30EUR ↔ USOIL. In tutto il repo.**
E **l'AZIONE aperta a luglio non è mai stata eseguita** (nessun campo petrolio-DAX in
`run_report.py` / `run_weekly_report.py`, nessuna riga in `REGISTRO_TEST.md`).

**Quindi:** la sua affermazione **è ripetuta** (2ª volta, luglio + oggi, **stessa fonte**),
**la causale è plausibile** (peso automotive nel DAX) — e da noi **è un buco vero**.

⚠️ **Ma prima di chiamarla "costo quasi zero", i due vincoli veri, misurati:**
1. 🔴 **Lo storico BCM di USOIL parte dal `2024.09.26`** ed è marcato **`COMPLETO`** —
   cioè _"**non manca sul disco, il broker NON CE L'HA**"_
   (`report/SWEEP_MECCANISMI_2026-08-23.md` r.86 · `REFERTO_SONDA_STORICO_17-08.md` r.46).
   👉 **~2 anni scarsi, un solo regime.** Con la **regola della finestra §C** (prova di
   regime) e la **valvola R59**, un giudizio di **MERITO** su questa base è **sospeso per
   costruzione**.
2. 🟡 **E il precedente in casa sui filtri di correlazione è pesante**: R101/G3 ha bocciato
   il filtro S&P sulle Aperture **per incoerenza fra due indici**. Una correlazione nuova
   entra con lo stesso sospetto.

> ✅ **Verdetto: SPUNTO S4 — MISURA DESCRITTIVA, non filtro.** Calcolare la correlazione
> rolling D30EUR↔USOIL è **letteralmente un download e una riga di pandas**, e produce un
> **numero agli atti** che chiude una domanda ricorrente. Ma **non è un candidato**: con 2
> anni di storico non si promuove niente, e nessun `InpUseCorrelation` va toccato.

---

# 🎯 PARTE 4 — GLI SPUNTI (etichettati SPUNTO, MAI candidati)

| # | Spunto | Costo | Perché | Priorità |
|---|---|---|---|---|
| **S1** | 🌙 **Dichiarare, PRIMA di lanciare il round PREOPEN DAX, se la griglia `InpPrevWindowMin` deve arrivare a 360** (= le sue 6 candele) invece che fermarsi a 300 | ⚡ **una colonna di griglia** (il round è già scritto e mai girato) | La finestra della notte **non è mai stata misurata** (§3.2); il round esiste e misura **esattamente** l'asse mancante. ⛔ **Vincolo non negoziabile: i criteri sono CONGELATI. Si decide adesso o mai** — cambiarli dopo aver visto i numeri è la cosa che non si fa in questa casa. 📌 E va scritta nella pagina di lancio la nota che a 360 la sovrapposizione col box della sedia viva `770411` sale a **180 min = metà box** (doppione strutturale) | 🟠 **ALTA, ma a scadenza** |
| **S2** | 🇺🇸 **Contare quante giornate di festivo USA la sedia `770411` ha operato con `CorrBias()` su un SPXUSD fermo** | ⚡ **basso** — è un incrocio fra il CSV dei trade e un calendario festivi | `InpUseCorrelation=true` + `InpUseNewsFilter=false` (verificato nel `.set`, r.40/48) → il filtro **non sa** che l'S&P è chiuso e restituisce il bias di ieri (§1.1.3). ⚠️ **Non sappiamo se costa. Non l'abbiamo mai contato.** Un numero prima di qualunque proposta | 🟠 **ALTA** |
| **S3** | 💱 **Misurare il buffer di `MaxMinNotte` su EURUSD** (oggi 200 pt MT5 = **20 pip**, mai passato per nessuna griglia) | 🔧 medio (una corsa) | In `risultati_archivio/MaxMinNotte/` esistono le corse di **D30EUR, F40EUR, E50EUR, 100GBP** — **nessuna su EURUSD**. Il 200 non è sbagliato, **è non misurato**. Il "3 pip" del relatore non è il numero da copiare (dominio diverso), è **il campanello che ha fatto guardare** | 🟡 **MEDIA** |
| **S4** | 🛢️ **Correlazione rolling D30EUR ↔ USOIL come MISURA DESCRITTIVA** (nessun filtro, nessun input) | ⚡ **quasi zero** (i dati ci sono dal 2024.09.26) | Chiude un'**AZIONE aperta da luglio e mai eseguita** (§3.5) e mette un numero sotto un'affermazione ripetuta due volte dalla stessa fonte. ⛔ **Con 2 anni di storico non si promuove niente**: si scrive il numero, si dichiara il campione, si chiude la domanda | 🟡 **MEDIA** |
| **S5** | 🗓️ **Far girare la sonda DST su BCM** (`DA_FARE.md` §3-bis, riga già scritta) | ⚡ **10 minuti dichiarati** | 🔴 **Non è uno spunto nuovo: è una SCADENZA.** Mancano **7 settimane** al 25/10/2026, e se BCM non segue il cambio europeo **tutti** gli `InpSessionHour` delle sedie vive (compreso il box notturno) diventano sbagliati di un'ora. La live l'ha solo sfiorata (§3.4) — **il promemoria vale comunque** | 🔴 **URGENTE (per data, non per la live)** |
| **S6** | 🗓️ **Flag "bank holiday" dal calendario → giornata declassata** | 🔧 basso (il campo c'è nei dataset FF) | **Già aperto come S-D il 31/08.** Oggi è la **2ª occorrenza in 5 giorni**, e stavolta con un aggancio a una sedia viva (S2). Non si duplica: **si alza di priorità** | 🟡 **MEDIA (era bassa)** |

### ⛔ COSE CHE NON SI FANNO, DA QUESTA LIVE

| 🚫 | Perché |
|---|---|
| **Toccare `InpBufferPoints` su qualunque sedia** | Il suo numero **coincide già** col nostro sull'indice, e il nostro viene da un **altopiano misurato** (R2, 750-1500, centro scelto). **Una conferma non muove un parametro** |
| **Aggiungere un filtro VWAP a qualunque motore** | 🔴 **Misurato e bocciato due volte** (§3.3), e la seconda volta **proprio su D30EUR M15** |
| **Cambiare `InpBoxStartHour` di una sedia viva** | La finestra è **non misurata**, non "sbagliata". Si misura in un round, con criteri scritti prima — **non si sposta perché un mentore conta 6 candele** |
| **Adottare il R:R 1:1** | Nota già scritta il 28/08 e ancora valida: **1:1 su una sedia automatica pretende un win rate ben sopra il 50%**. La `770411` esce a **1R/3R/4R** |
| **Meccanizzare la forbice della forza valutaria** | ⚠️ Nessuna soglia numerica ("distante" non è un numero), numeri della trascrizione **incoerenti** (P11: due "XAU"), e **si ribalta in 40 minuti** (X7). E in casa la famiglia è già segnata come _"indicatori ancora in beta … nessuna regola stabile"_ |
| **Meccanizzare il "movimento negli ultimi 20-30 secondi"** | 🆕 e affascinante, ma è **un solo caso osservato in diretta**. `[DICHIARATO, NON VERIFICATO]` |
| **Modificare la gestione dei pendenti "sfiorati"** | ⛔ Non è un parametro: `InpPendingExpiryMin`/`InpEntryCutoff` **cancellano**. Farli **spostare** è un motore diverso |

---

# 🧺 PARTE 5 — GLI SCARTI (letti, e buttati col motivo)

| Blocco | Righe | Perché è scarto |
|---|---|---|
| 🛒 **Demo commerciale MQLSuite** (Fabio) | r.43-73, car. 1-4.586 (**9% del file**) | ⚪ **Prodotto terzo di analisi grafica** (profili MT5, pulsantiere, livelli percentuali, "projection scalping/intraday/multiday"). **Nessuna regola operativa, nessun parametro numerico, nessuna soglia.** ✅ **Censite comunque le affermazioni verificabili**: P18 (50/100+ profili), P19 (5.000-5.150 $ e-Signal), P20 (multipli di 0,25%), P21 (2011/15 anni), B6 (nega le promesse di guadagno) |
| 🧭 **Il trade AUDUSD di Fabio** | r.73 | ⚪ _"può andare a fare **almeno lo 0,25%**"_ + _"la **famiglia degli australiani** in questo momento quasi tutti sono positivi"_ → **nessuna regola, nessuno stop, nessun target numerico**, esito mai dichiarato. Autodichiarato: _"probabilità, con molta probabilità e **nessuna certezza**"_ |
| 🤖 **AI / coaching di Giacomo** | r.7-11 | 🔁 **Già coperto** in `ANALISI_LIVE_EMILIANO_2026-08-31.md` §A. L'unica novità è tecnica e minima: _"per **Cloud** da collegare l'MCP diretto dall'app, al momento **non funziona**. Funziona solo tramite **Cloud Code**"_ ⚠️ **"Cloud" = Claude**. ⚪ **Nessuna ricaduta operativa** |
| 📅 **Logistica del calendario live** | r.73 | ⚪ Live spostate a **mercoledì** (mattina e sera), niente giovedì. Registrato per completezza |
| 🩺 **Motivo personale di riduzione carico** | r.39 | ⚪ **Non pertinente e non si estrae.** Registrato solo l'effetto: meno impegno nel weekend |
| 💬 **Saluti, problemi di condivisione schermo, richieste di "fammi organizzatore"** | r.1-16, sparsi | ⚪ Rumore di regia |
| 📉 **Tutti i livelli di prezzo troncati** | P17 | 🔴 **Scartati per decisione, non per pigrizia.** Il precedente del 27/08 (il "115" che era "315") dice che su questa fonte i troncati **non si firmano** |

## 📸 COSA C'ERA A SCHERMO E NON NEL PARLATO — le domande per Claudio

| # | Cosa serve | Minuto ~ | Perché serve davvero |
|---|---|---|---|
| **D1** | 🌙 **Screenshot del grafico H1 del DAX con le 6 candele della notte evidenziate** | ~**08:45-08:55** (subito prima dell'apertura, quando dice _"1,2,3,4,5,6"_) | 🥇 **È LA DOMANDA PIÙ IMPORTANTE DEL REFERTO.** Con gli **orari sull'asse X** si risolve in un secondo l'ambiguità (a)/(b) del §1.1.1 — cioè **dove comincia e finisce davvero la sua notte** — e si vede il **fuso del suo terminale**. Senza questo, la finestra resta `[INCERTO]` |
| **D2** | 🕰️ **Screenshot del lunedì con la "doppia candela"** | ~**08:50** | Risolve fra le letture (i)/(ii)/(iii) del §3.4. Se è davvero BCM, è **un dato sul NOSTRO broker** che entra nella verifica DST |
| **D3** | 📊 **La tabella della forza valutaria ("l'algoritmo")** | ~**09:00** e di nuovo ~**09:40** | I valori dettati sono **incoerenti** (P11: due "XAU"). Due screenshot alle due ore diverse **misurano** quanto si muove la forbice in 40 minuti (X7) e dicono se il numero è una % o un punteggio |
| **D4** | 🛢️ **Il grafico USOIL affiancato al DAX** | ~**09:05** | Serve **il timeframe e la finestra** che lui guarda: senza, la correlazione di S4 non è confrontabile con la sua |
| **D5** | 📐 **Il pannello dell'ordine pendente** (prezzo, SL, TP, volume) | ~**09:45-09:55** | 🎯 **L'unico modo per avere i suoi numeri veri**: distanza dell'ordine dal livello, ampiezza dello stop, e **verificare il R:R 1:1 dichiarato**. Nel parlato c'è solo _"5 contatti"_ |
| **D6** | 🖥️ **`Get-Process terminal64 \| select Id, MainWindowTitle, Path`** — no, qui basta il **titolo della finestra MT5 di Emiliano** | qualunque | Dice **quale broker** sta usando. Tutto il §2.5 (gli orari) e il §3.4 (la doppia candela) dipendono da questo. **Se non è BCM, i suoi orari non sono i nostri orari** |

---

## 🔒 CONCLUSIONE

**Su 1 trascrizione (52.296 caratteri): 21 parametri con valore, 15 meccanismi, 8 bandiere
di cui ZERO rosse, 7 contraddizioni, 6 spunti, 4 voci nuove su 22.**

**Le tre righe che contano:**

1. 🥇 **La domanda del mandato ha una risposta netta, e non è quella comoda.** Il nostro
   box `23:00–04:59` **non è mai stato misurato contro alternative**: in **324 righe** di
   CSV di corsa, gli input di finestra hanno **un solo valore distinto**. È una
   **convenzione**, non una misura. La sua definizione **non si archivia come opinione
   battuta**: si archivia come **domanda aperta legittima**, con la porta già costruita
   (round PREOPEN, preparato e mai lanciato, `InpPrevWindowMin` 60→300 — **e le sue 6
   candele fanno 360, appena fuori**). ⛔ **E i criteri di quel round sono congelati: si
   decide prima del lancio o non si decide.**

2. 🥈 **Il dato più solido converge ed è già nostro, misurato.** Offset del pendente
   **10 punti indice = 1000 punti MT5** — il suo numero e il nostro `InpBufferPoints`
   sono **lo stesso numero**, e il nostro sta al **centro di un altopiano misurato**
   (750-1500, R2). Idem sul forex post-news: **3 pip = 3,0 pip**. **Nessuna azione: una
   conferma conferma che non si tocca.**

3. 🥉 **La ricaduta più diretta su una sedia viva non è un parametro, è un buco.**
   In una giornata di **festivo USA**, `CorrBias()` di `ABTG_MaxMinNotte` legge un SPXUSD
   **fermo** e restituisce il bias di ieri — verificato in `ABTG_MaxMinNotte.mq5` r.698-711
   con `InpUseCorrelation=true` e `InpUseNewsFilter=false` nel `.set` della `770411`.
   ⚠️ **Quanto costi non lo sappiamo, perché non l'abbiamo mai contato.** → **S2**, e prima
   di qualunque proposta viene **il numero**.

**E la nota di metodo, che vale quanto le tre righe sopra:** il mandato dava per commerciale
la seconda metà della live. **Misurato: la parte commerciale è il 9%, e il 44% del file è la
parte operativa più densa della giornata** — quella dove esce il **R:R 1:1** che due referti
precedenti avevano dichiarato mancante. 👉 **Il blocco unico da 27.551 caratteri della riga
73 va letto, sempre. Non si salta perché comincia con una demo.**

> ### ⛔ NESSUNA AZIONE SULLA FLOTTA. NESSUN PARAMETRO TOCCATO. NESSUNA PROMOZIONE.
> Questo è un referto di **lettura**. Decide Claudio.

---

### 🔗 Referti collegati (non duplicare — linkare)
- 📄 **Trascrizione integrale:** `docs/live_emiliano/trascrizioni/LIVE_EMILIANO_2026-09-07.txt`
- 🎙️ `risultati_archivio/ANALISI_LIVE_EMILIANO_2026-08-27.md` — M15 (gerarchia notte/giorno prima, ⚔️ X5), i 5 ostacoli, il buco del R:R
- 🎙️ `risultati_archivio/ANALISI_LIVE_EMILIANO_2026-08-28.md` — §6.3 (**il buco del R:R, oggi chiuso**), E23 (DAX di notte), §2.3 (guardia spread, poi accesa)
- 🎙️ `risultati_archivio/ANALISI_LIVE_EMILIANO_2026-08-31.md` — **M10 + spunto S-D (bank holiday)**, ⚔️ X1 (pendenti sì/no), C16 (correlazioni)
- 🎙️ `risultati_archivio/ANALISI_LIVE_PAOLO_2026-08-27.md` · `caccia_strategie/ANALISI_LIVE_PAOLO_2026-09-03.md` (**Y8**, forza valutaria incoerente) · `caccia_strategie/ANALISI_LIVE_EMILIANO_2026-08-24.md` (_"le correlazioni sono andate tutte a farsi fottere"_)
- 📜 `docs/live_emiliano/ANALISI_LIVE_luglio.md` — **l'AZIONE petrolio→DAX aperta a luglio e mai eseguita**
- 📊 `risultati_archivio/R101_REFERTO.md` r.60/75/93 + `R101_CRITERI.md` r.231 — **il gradino `07_vwap`, nato da una sua live e bocciato**
- 📊 `risultati_archivio/REFERTO_ROUND2.md` §1 — **l'altopiano del buffer 750-1500**
- 📊 `risultati_archivio/MaxMin_Oro/NOTTE_ORO.md` — **le 371 notti, ora per ora**
- 🔬 `prove/PREOPEN_RETEST_DAX_M15.txt` r.378 + `prove/REFERTO_PREPARAZIONE_PREOPEN_DAX_NAS.md` §4 — **il round che misura la finestra, e la tabella di sovrapposizione**
- 🗓️ `DA_FARE.md` §3 e §3-bis — **la domanda DST su BCM, scadenza 25/10/2026**
- 🛡️ `risultati_archivio/FILTRO_SPREAD_MAXMINNOTTE_2026-08-28.md` — la guardia spread accesa dopo la live del 28/08
- 💻 Sorgenti verificati: `mql5/Experts/ABTG_MaxMinNotte.mq5` (r.118-121, 140, 164-168, 698-711) · `ABTG_DAX_Apertura_EU.mq5` (r.89, 265, 277) · `ABTG_Dow_Apertura_US.mq5` (r.69, 234) · `ABTG_PostNews.mq5` (r.95-96) · `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_770411.set` (r.21, 40-41, 48, 59)
