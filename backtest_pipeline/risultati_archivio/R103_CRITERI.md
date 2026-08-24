# 📝 R103 — **LA CLASSIFICA DELLA FLOTTA** — criteri di dettaglio

> ## 🖊️ NASCE DA UNA FIRMA GIÀ DATA
> `R103_PROPOSTA_CLASSIFICA_FLOTTA.md`, **firmata da Claudio il 24/08/2026**:
> **_"FIRMO TUTTE E TRE, PARTIAMO"_** — le tre decisioni (finestra comune 6,5
> anni · indici in tabella separata a 21 mesi · due colonne di profitto,
> si ordina sul normalizzato) sono **risolte come proposte, senza modifiche**.
>
> E dallo stesso documento, **il chiarimento della mattina del 24/08**:
> > _"Voglio avere una classifica aggiornata x ogni Ea e x ogni simbolo di ogni
> > Ea… Vedi tu se vuoi farlo anno x anno x ognuno o se vuoi fare la somma di
> > tutti **ma vorrei capire se esistono anni negativi x qualcuno**."_
>
> 👉 **Quel "ma" è il requisito**: la somma non basta. La **SPINA DORSALE
> periodo per periodo** diventa **OBBLIGATORIA per tutte e 40 le sedie**, e ogni
> riga della classifica porta la colonna **periodi negativi / periodi operati**.

**Oggetto**: le **celle VIVE** di **tutte e 40 le sedie di trading** dei due
conti, misurate una per una su una finestra **recente e comune al loro gruppo**.
**Driver**: `backtest_pipeline/righe/RIGA_R103_CLASSIFICA_FLOTTA.ps1`
(marcatore `MARCATORE_RIGA_R103_v1`).
**File prova**: `backtest_pipeline/prove/R103_<ea>_<simbolo>_<magic>.txt` — **40**,
generati dai sorgenti da `prove/R103_GENERA_PROVE.py`.
**Macchina**: è quella di **R102** (`RIGA_R102_CLASSIFICA_LUNGA.ps1`, pin
`fd23d4a`), **semplificata** (una finestra per sedia invece di sei) e
**allargata** (due gruppi, due finestre, la sedia senza OPTFRAME). Riusati
**invariati**: guardia MT5/MetaEditor, download pinnato di
`scarica_storico.ps1` col fix Battito-Basi, install dell'include
`ABTG_PausaGuardian.mqh`, `[Charts] MaxBars`, compilazione diretta col verdetto
`LastWriteTime` + backup datato + ripristino, sosta svuotata a ogni giro,
lettura dei log **a offset**, `LeggiDeal` col parser corretto (`Bilancio` fra i
sinonimi, netto = Profitto+Commissioni+Swap), gate dei **gemelli identici**,
gate della **prima operazione a due misure**, `-SoloSedia` con split `'[,\s]+'`
(checklist 65), parametri numerici **tipizzati** (checklist 64), filtro
`$idBlocco` nella raccolta, esiti **PARZIALE vs COMPLETO CON RILIEVI**
(commit `fd23d4a`), `exit 0` esplicito.

---

## 0. 🚫 CHE COSA QUESTO ROUND **NON** È

### 0.1 Non è un verdetto: è una **MISURA**

L'Emendamento **regola B** (16/08) resta la cornice: **il VECCHIO giudica il
RISCHIO, il RECENTE giudica il MERITO**. Qui la finestra è **recente**, quindi
il profitto *può* parlare di merito — ma **R103 non promuove e non boccia
nessuno lo stesso**, e per una ragione scritta nella proposta firmata:

> 🔴 **Una classifica è un'informazione per decidere, non un verdetto
> automatico.** Nessuna sedia viene accesa, spenta, ingrandita o rimpicciolita
> da un numero di questo round. Le uscite restano quelle della **C3 del 18/08**
> (rischio / merito / tagliando), che girano sul **FORWARD**, non su un
> backtest.

### 0.2 E le altre cose che non è

- **NON ottimizza e non cerca celle.** Una cella per sedia, **quella VIVA**,
  congelata. L'unico asse `Y` è `InpMagic`, cioè la **coppia gemella di
  controllo**. Se una sedia esce male, la risposta **non** è "proviamo un'altra
  cella": quello sarebbe pescare (regola della seconda caccia).
- **NON tocca niente in forward.** Nessun sorgente EA modificato, nessun preset
  riscritto, nessun grafico toccato. Magic **vergini** del blocco `76xxxx`.
- **NON dà un drawdown di PORTAFOGLIO.** 40 sedie non fanno un DD pari alla
  somma né pari al massimo: dipende da **quanto si sovrappongono**. È un round
  diverso (macchina R16/R34), e resta la priorità successiva della corsia
  rischio. ⚠️ E qui morde: **7 sedie su GBPUSD** e **8 su U30USD**.
- **NON è un guadagno.** Vedi §3.

---

## 1. 🪑 IL PERIMETRO — le 40, e chi resta fuori

Fonte unica della lista, del **magic vivo**, del **rischio vivo** e del
**commento**: `risultati_archivio/censimento_rischio_2026-08-23_1549.txt`
(56 righe `.chr`, misurate il 23/08/2026 alle 15:49).

| gruppo | sedie | finestra | perché |
|---|---:|---|---|
| **FOREX + METALLI** | **25** | **2020.01.01 → 2026.06.30** (6,5 anni) | DECISIONE 1 firmata: è l'unica finestra recente che contiene **un crollo vero** (covid feb-mar 2020) |
| **INDICI** | **15** | **2024.09.26 → 2026.06.30** (21 mesi) | DECISIONE 2 firmata: **il broker non ha altro**. Sonda 17/08: prima data `2024.09.26`, verdetto **`COMPLETO`** su tutti gli indici |

### 1.1 🔴 Perché gli indici non possono avere 5 anni, e non è una scelta nostra

`REFERTO_SONDA_STORICO_17-08.md`: su `D30EUR`, `U30USD`, `NASUSD`, `225JPY` la
sonda risponde `2024.09.26` con verdetto **`COMPLETO`**. **`COMPLETO` è la
parola che chiude la questione**: non manca sul disco — **il broker non ce
l'ha**, e MT5 testa solo sui dati del broker collegato.

> ⚠️ **Le due tabelle NON si confrontano fra loro**, e ogni riga della seconda
> porta l'etichetta stampata: *"21 mesi, UN solo regime, NON confrontabile"*.
> Mettere 21 mesi e 6,5 anni nella stessa classifica sarebbe la truffa peggiore
> del round.

### 1.2 Chi NON c'è, e perché — dichiarato prima

| sedia | stato | motivo |
|---|---|---|
| `BREAKOUT_EA_JPY_v3` USDJPY | ⛔ **NON MISURABILE** | **il sorgente non esiste nel repo** (misurato: zero file `BREAKOUT_EA_JPY_v3.mq5`), nessun magic e nessun rischio leggibili nel `.chr`, **nessun contratto**. È il **rilievo del 18/08, ancora aperto** |
| `ABTG_GapContinuation` 225JPY (774101) | ⛔ **FUORI MISURA** | nel `.chr` del 23/08 **non ha nessun input di rischio leggibile** (`n/d`): senza taglia viva non esiste né la colonna A né la colonna B. Ha un contratto (11,59%), quindi **non è una sedia senza metro**: è una sedia senza **taglia misurata**. Rilievo nuovo, si chiude con un `.chr` che la legga |
| `ABTG_Guardian`, `ABTG_TradeExporter` ×2 | ⚙️ utility | non tradano |
| `ABTG_Nasdaq_Apertura_US` NASUSD | 🛑 spenta dal 18/08 | non è più in campo (verificato in tutti i censimenti dal 18/08 09:41) |

### 1.3 ⚖️ Le cinque sedie che nel `.chr` compaiono a DUE taglie

`ABTG_DAX_Apertura_EU` (770101), `ABTG_Dow_Apertura_US` (770202),
`ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (770411),
`ABTG_SupertrendReversal` 225JPY (770901), `ABTG_ORB_Ottimizzato` (770611)
compaiono nel censimento **due volte**: a **1,0%** (demo piccolo) e a
**0,65% / 0,3%** (le copie sul **dry-run 100k col Guardian**,
`report/DEPLOY_GUARDIANO_100K.md`).

> ✅ **SCELTA DICHIARATA (assunzione prudente, non una firma nuova): R103 usa la
> taglia RIDOTTA** (0,65% / 0,3%), perché:
> 1. è quella del conto da **100.000**, che è esattamente il deposito del banco
>    di questo round;
> 2. è la taglia **più recente** (deploy del Guardian) e la più conservativa;
> 3. **per la classifica non cambia nulla**: si ordina sulla colonna
>    **normalizzata a 1%**, che è indipendente dalla taglia.
> La colonna "taglia viva" di queste cinque righe va quindi letta come *"quello
> che avrebbero fatto sul conto 100k"*.

---

## 2. 🔬 LA CELLA VIVA — da dove viene, campo per campo

I 40 file prova **non contengono un solo valore scritto a memoria**. Il
generatore `R103_GENERA_PROVE.py`:

1. **legge gli input dal sorgente** `.mq5` al pin, in ordine, col loro tipo e il
   loro default (compresi gli **enum** e le **macro `#define`** — vedi §2.2);
2. sovrascrive solo i campi della **cella viva**, presi da un **artefatto**;
3. pinna `InpRiskPercent` alla **taglia viva** e `InpComment` al **commento
   vivo**, tutti e due misurati nel `.chr` del 23/08;
4. accende `InpVerbose` (serve al gate 1) **dove esiste**;
5. mette `InpMagic` come **coppia gemella vergine**;
6. **si ferma** se un campo della cella non esiste fra gli input di quell'EA.

### 2.1 🎯 La fonte della cella, sedia per sedia — e la novità di R103

R102 leggeva le celle dagli **script di deploy**. R103 fa un passo in più: dove
nel repo esiste il **preset `.set` della sedia viva**, la cella si legge **da
quello, riga per riga** — è l'artefatto più vicino a ciò che gira davvero.

| fonte della cella | sedie |
|---|---|
| **PRESET LIVE** `mql5/Presets/sedie_piccolo/…` e `…/recupero2/…` | F13, F15, F21, F22, F23, F24, I01, I02, I03, I06, I07, I08, I10, I11, I12, I13, I15 (**17**) |
| **script di DEPLOY** (`deploy_vivaio_*.ps1`, `deploy_pte_gbpusd_b25.ps1`) | F01-F12, F14, F16-F20, I04, I05, I09 (**21**) |
| `report/DEPLOY_GUARDIANO_100K.md` riga 152 | I14 (**1**) |
| **default del sorgente** (magic e rischio del `.chr` coincidono col default, nessun preset esiste) | F25 Gold_Ichimoku (**1**) |

🟢 **CONTROLLO INCROCIATO ESEGUITO, e va agli atti**: le celle di **I01 (DAX
Apertura)** e **I02 (Dow Apertura)** sono state confrontate **input per input**
coi file prova `R101_DAX_00_viva.txt` / `R101_DOW_00_viva.txt`, cioè col
**metro già validato di R101**. Risultato: **tutti i parametri di cella
coincidono**. Le uniche differenze sono, e sono dichiarate:
- `InpRiskPercent` **0,65** (R103, taglia 100k) contro **1,0** (R101) — §1.3;
- `InpMagic` (vergini diversi);
- i booleani scritti `true/false` invece di `1/0` (equivalenti per MT5);
- 🔵 **R103 scrive 82 input contro i 72 di R101**: i dieci in più sono
  `InpNews*`, `InpCorrSymbol`, `InpLevelTF`, `InpOCTimeframe`. **Meglio così**:
  un input che il file prova non nomina **non torna al suo default**, resta
  l'ultimo valore usato a mano che MT5 ricorda (checklist 25).

### 2.2 🧨 Due trappole trovate scrivendo il generatore (e chiuse)

1. **Le APERTURE scrivono i default come MACRO**:
   `input int InpSessionHour = ABTG_DEF_SESSION_HOUR;`. Senza risolvere il
   `#define`, il file prova avrebbe contenuto la riga
   `InpSessionHour=ABTG_DEF_SESSION_HOUR||…` — che nel `.ini` **non è un
   numero**: il tester la ignora **in silenzio** e gira **con l'ora sbagliata**,
   cioè con un'altra sedia. Il generatore ora risolve le macro (**la prima
   definizione vince**: la seconda sta dentro un `#ifndef`) e **si ferma** se un
   default non si riduce a numero/bool/stringa.
2. **`Gold_Ichimoku` ha i commenti dentro gli `enum`**
   (`DIR_SHORT_ONLY = 2 // Solo SHORT`): il parser di R100/R102 ci esplodeva.
   Ora i commenti si tolgono prima. _(Verificato a mano: `DIR_LONG_ONLY = 1`,
   `EXIT_CROSS = 1` — i due valori che finiscono nel file prova.)_

### 2.3 🔴 IL TF DEL GRAFICO NON SI DERIVA DA `InpTF`

È la trappola pagata in R102: `ABTG_SuperWave GBPUSD` gira su un grafico **H4**
con **`InpTF` = H2**. In R103 il TF del grafico ha una **fonte propria,
dichiarata sedia per sedia** nell'intestazione del suo file prova. Le sedie in
cui i due **differiscono** sono **tre**, e sono tutte dichiarate:

| sedia | grafico | `InpTF` | fonte del TF di grafico |
|---|---|---|---|
| F21 `SuperWave` GBPUSD | **H4** | H2 | `deploy_vivaio_r23.ps1`: *"InpTF resta H2!"* |
| I12 `SuperWave` U30USD | **H4** | H2 | idem |
| I15 `SupertrendReversal` 225JPY 770924 | **H4** | H2 | `FLOTTA_ATTIVA.md` riga `225JPYH4` = 770924; il preset live dice `InpTF=16386` |

### 2.4 🔵 Una scoperta del censimento delle celle, e va detta

**I14 (770901) e I15 (770924) sono lo STESSO MOTORE.** Il preset live di 770924
e la riga 152 di `DEPLOY_GUARDIANO_100K.md` per 770901 danno **la stessa cella**
(`InpTF` H2, `InpStMult` 3,5, `InpTP_RR` 2,0, long+short): le due sedie
differiscono **solo** per taglia (1,0% contro 0,65%), commento e **TF del
grafico** (H4 contro H2).

> 👉 **Diventa un CONTROLLO D'IGIENE gratis**: nella colonna **normalizzata a
> 1%** le due righe devono uscire **quasi uguali**. Se escono molto diverse, la
> differenza è tutta nel **TF del grafico** (granularità del tick simulato), e
> allora è il **banco** che va guardato, non le sedie.

---

## 3. 🔬 IL BANCO, E I SUOI LIMITI — prima dei numeri

| | |
|---|---|
| **modello** | **1 = OHLC su M1**, per tutte e 40 |
| **deposito** | **100.000 EUR**, leva 100 |
| **spread** | `Spread=0` nell'`.ini` = spread **CORRENTE** del terminale, **scritto** invece che lasciato allo stato nascosto |
| **suffisso dei CSV** | `_ohlc` — regola di casa: un OHLC non deve nemmeno poter finire nella stessa tabella di un tick reale |

### 3.1 💸 Il profitto è una **STIMA DEL LORDO**, e generosa

Spread corrente e non storico, **nessuno slippage**, nessun requote,
riempimenti ideali. 👉 **UN NUMERO DI PROFITTO DI R103 NON È UN GUADAGNO**: è un
ordine di grandezza per confrontare le sedie **fra loro**, sullo stesso banco e
con gli stessi difetti. La frase da usare con Claudio è *"su questo banco
avrebbe fatto X"*, mai *"avrebbe guadagnato X"*.

### 3.2 🔻 Il DD è un **LIMITE INFERIORE**

L'OHLC non vede i percorsi dentro la barra: il rischio vero è **peggiore**, mai
migliore.

### 3.3 🔴 E SUGLI INDICI L'OHLC HA GIÀ MENTITO — misurato, non temuto

Sulla finestra degli indici (2024.09.26 → 2026.06.30) i **tick reali
esistono** (BCM li ha dal 2024.07.05) e **R101 li ha usati**. R103 gira lo
stesso in **OHLC**, perché **la proposta firmata dice OHLC** (§4 della
proposta: *"Nessun tick reale… modello OHLC M1"*) e perché un solo banco per
tutte e 40 è più leggibile.

> ⚠️ **MA IL COSTO È MISURATO, non ipotetico**: il 30/07 la revalidation a tick
> reali ha ribaltato `SupRev_DOW_H4_Ottimizzato` da **PF 2,77 (OHLC)** a
> **PF 0,79 (tick reali)** — *"illusione OHLC"*, contratto **revocato**. Sugli
> indici intraday l'OHLC è **ottimista**, e la seconda tabella va letta
> sapendolo.
>
> ### 🟡 DECISIONE RESIDUA **[DA FIRMARE — non blocca il round]**
> Il driver ha lo switch **`-TickReali`** (default **OFF**), che vale **solo per
> il gruppo INDICI**: se Claudio firma, si rilancia **il solo gruppo indici**
> con quel flag e **niente altro cambia** (una variabile alla volta). Costo: più
> ore di tester e lo scarico dei tick di `NASUSD` e `225JPY` (quelli di
> `D30EUR`/`U30USD` R101 li ha già portati a disco). **Il default resta OHLC
> perché è ciò che è firmato.**

---

## 4. 📐 I NUMERI CHE R103 PRODUCE, sedia per sedia

| # | numero | strumento |
|---|---|---|
| **A** | **PROFITTO ALLA TAGLIA VIVA** (colonna `PROF-VIVO`) | `OptResults`, due passate **gemelle** |
| **B** | **PROFITTO NORMALIZZATO A 1%** (colonna `PROF-1%`) — **è la colonna su cui si ORDINA** | A × (1 / rischio) |
| **C** | **PF**, **n operazioni** | `OptResults` |
| **D** | **DD massimo** alla taglia viva **e** normalizzato a 1% | `OptResults` (`Equity DD %`) |
| **E** | **DD promesso** dal contratto e il **rapporto** col DD normalizzato | `report/CONTRATTI_SEDIE.md` **al pin**, per colonna |
| **F** | **PEGGIOR GIORNATA %** (muro prop giornaliero **5%**) | deal del report `.htm` |
| **G** | **LA SPINA DORSALE** periodo per periodo + **periodi negativi / operati** | deal del report `.htm` |

### 4.1 ⚖️ La normalizzazione a 1% — la formula, e il suo limite

```
PROF-1%  =  PROF-VIVO  ×  (1,00 / rischio_vivo)
DD-1%    =  DD-VIVO    ×  (1,00 / rischio_vivo)
```

**[APPROSSIMATO — riscalatura LINEARE]**, ed è la **convenzione di casa**:
`CONTRATTI_SEDIE.md` §*COME LEGGERE I NUMERI* punto 2 (*"il DD atteso scala
~linearmente col rischio per trade"*). I moltiplicatori che escono:

| rischio vivo | moltiplicatore | sedie |
|---:|---:|---|
| 1,0% | ×1,00 | 26 |
| 0,65% | ×1,54 | I01, I02, I06, I14 |
| 0,5% | ×2,00 | F13, F14, F23, F25 |
| 0,3% | ×3,33 | F20, I07 |
| 0,25% | ×4,00 | F22 |

> 🔴 **DOVE LA LINEARITÀ SI ROMPE, e va scritto**: il lotto ha un **minimo** e
> uno **step**. A taglie piccole (0,25-0,3%) su un conto da 100k il lotto
> calcolato può cadere **sotto il minimo del simbolo** e venire arrotondato:
> lì il rapporto col rischio **non è più lineare** e il numero normalizzato è
> **sovrastimato**. Il referto stampa l'avvertenza **su ogni riga con rischio <
> 0,5%** (F20, F22, I07). _(È lo stesso meccanismo misurato in R5: col lotto
> minimo l'ingresso frazionato non riusciva a spezzare il volume.)_
> 👉 **La colonna B serve a ORDINARE i motori, non a promettere euro.**

### 4.2 🦴 LA SPINA DORSALE — la granularità, e perché è diversa nei due gruppi

| gruppo | granularità **UFFICIALE** (è la colonna della classifica) | in più, nel referto |
|---|---|---|
| **FOREX + METALLI** (6,5 anni) | **ANNO SOLARE**: 2020, 2021, 2022, 2023, 2024, 2025, **2026 (parziale, → 30/06)** | — |
| **INDICI** (21 mesi) | **TRIMESTRE**: **2024Q3** *(soli 5 giorni: 26→30 settembre)*, 2024Q4, 2025Q1…Q4, 2026Q1, 2026Q2 = **8 trimestri** | il **mese per mese**, marcato **[DIAGNOSTICA, non è il criterio]** |

> ⚠️ **Il primo trimestre è di CINQUE GIORNI** (la finestra parte il 26/09,
> dentro il Q3), e quasi tutte le sedie ci usciranno con **zero operazioni**:
> finirà quindi **fuori dal denominatore** per la regola qui sotto, non fra i
> negativi. Verificato eseguendo: `ElencoPeriodi 2024.09.26 → 2026.06.30` dà
> **8 trimestri** (2024Q3 … 2026Q2) e **22 mesi** (2024.09 … 2026.06).

> ### 🎯 PERCHÉ IL TRIMESTRE E NON IL MESE, sugli indici — **è una scelta, e la dichiaro**
> Su 21 mesi la scelta è fra 21 caselle mensili e 7 trimestrali. **Ho scelto il
> trimestre**, e il motivo è **la frequenza misurata delle sedie**, non il
> gusto: dal censimento dei contratti, `MaxMinNotte DAX` promette **~1,7
> operazioni al mese**, `SupertrendReversal` Nikkei **~1**, `GapFill` Nikkei
> **~1,2**, `PunteLarry DOW` **~2,9**.
> - Con le caselle **mensili**, su quelle sedie ogni casella contiene **0 o 1
>   operazione**: la riga *"12 mesi negativi su 21"* si leggerebbe come una
>   condanna quando è **solo il segno di dodici singoli trade**. È rumore
>   travestito da statistica — esattamente il difetto che l'**Emendamento
>   regola A** ci ha insegnato a non ripetere (*"l'unità di misura è
>   l'OPERAZIONE, non il calendario"*).
> - Con le caselle **trimestrali** ogni casella contiene **3-30 operazioni** e
>   la domanda di Claudio (*"esistono periodi negativi?"*) ha una risposta che
>   vuol dire qualcosa.
> - 🟢 **E il mese per mese non si butta**: si stampa lo stesso, sotto, marcato
>   **DIAGNOSTICA**. Costa zero (sono gli stessi deal) e Claudio lo vede se lo
>   vuole. Quello che **non** fa è entrare nella colonna della classifica.
>
> ⚠️ **Le due granularità NON si confrontano**: *"1 anno negativo su 6"* e
> *"2 trimestri negativi su 7"* non sono la stessa frase. Sta scritto sopra la
> seconda tabella.

**Come si contano i periodi negativi** (e il denominatore è la parte che conta):

- **negativo** = periodo con **n > 0** e **netto < 0**;
- **denominatore** = i periodi **OPERATI**, cioè con **n > 0**;
- i periodi con **n = 0** **NON contano come negativi**: si tolgono dal
  denominatore e si **elencano a parte** (è il **GATE DENSITÀ**). *"1 su 6"* e
  *"1 su 4, più 2 senza nessuna operazione"* sono due frasi diverse, e il
  referto stampa la seconda.

**[APPROSSIMATO], e resta scritto**: la spina dorsale è il **flusso di cassa
delle chiusure realizzate** (netto = Profitto+Commissioni+Swap, anno/trimestre
**della chiusura**). **Non è l'equity e non è il drawdown.** Una posizione
aperta a dicembre e chiusa a gennaio conta **tutta** nel periodo della chiusura.

### 4.3 📜 IL DD PROMESSO — letto dall'artefatto, mai a memoria

Funzione `DDPromesso` di R100/R102, **invariata**: cerca la riga in
`report/CONTRATTI_SEDIE.md` **al pin**, **per colonna**, col vincolo su
**EA + SIMBOLO + MAGIC** (è quel vincolo che in R100 ha impedito alla sedia oro
di pescare la riga del Nikkei, stesso magic 770901). Tre esiti possibili, e
**nessuno dei tre inventa un numero**:

| esito | quando | cosa stampa il referto |
|---|---|---|
| `DD PROMESSO ESTRATTO` | la cella contiene una percentuale non ambigua | il numero + il rapporto col DD-1% |
| `DD PROMESSO AMBIGUO` | la cella contiene una **riscalatura di taglia** (*"9,92% — a 0,3% ≈ 3,0%"*) | la riga **verbatim** e `RAPPORTO NON CALCOLABILE` |
| `RIGA NON TROVATA` | la sedia non ha contratto | **`DD PROMESSO NON AGLI ATTI`** |

> ### 🟢 ESEGUITO SUL FILE VERO, PRIMA DELLA CORSA: **31 ESTRATTI · 9 AMBIGUI · 0 NON AGLI ATTI**
> Tutte e 40 le sedie **trovano la loro riga** in `CONTRATTI_SEDIE.md` (nessuna
> sedia senza contratto fra le 40 — le due senza contratto del 18/08 sono
> **fuori perimetro**, §1.2). I **9 AMBIGUI** sono:
>
> | sedia | perché la cella è ambigua |
> |---|---|
> | **F13, F14** `PTE GBPUSD` | *"2,64% — a 0,5% ≈ 1,3%"* — **rilievo aperto dal 23/08** |
> | **F20** `PunteLarry` oro · **F22** `EMA200_Ott` oro · **F23** `MaxMinNotte` oro | riscritti da R100 **alla taglia ridotta** (*"…a rischio 1% → … a 0,3%"*) |
> | **I07** `ORB_Ott` | *"9,92% … a 0,3% ≈ 3,0%"* |
> | **I14** `SupertrendReversal` Nikkei 770901 | *"0,88% … a 0,65% ≈ 0,6%"* |
> | **F25** `Gold_Ichimoku` | *"DD 4,38% a rischio 0,3% (a 0,5% ≈ 7,3%)"* — e per di più i numeri sono di **un altro broker** |
> | **F24** `SupertrendReversal_Ott` oro | 🔵 **è un FALSO POSITIVO CONSERVATIVO, e lo dichiaro**: il numero (**9,0%**, da R99) è già **alla taglia viva 1%**; a far scattare il rifiuto è l'avvertenza *"⚠️ a rischio 2% i numeri RADDOPPIANO"* scritta nella stessa cella |
>
> 👉 **Su F24 NON ho allentato la funzione.** È la funzione **verificata** di
> R100/R102, e renderla meno prudente in un round che non posso provare contro
> MT5 va nella direzione sbagliata: il numero **9,0% resta leggibile** nella
> riga **verbatim** che il referto stampa sotto la sedia. *Un denominatore
> letto alla taglia sbagliata è peggio di un denominatore mancante.*

### 4.4 🚦 E il confronto col DD promesso **NON è un verdetto meccanico**

R99/R100/R102 avevano la regola *"DD > 2× il promesso → REVISIONE"*, e girava
sulla finestra **LUNGA**. Qui **no**, e il perché è onesto:

- la firma del 18/08 (corsia RISCHIO) parla di **DD FORWARD** oltre il promesso;
- il DD promesso di ogni contratto è stato misurato **su un'altra finestra**
  (spesso 12-13 mesi di OOS): confrontarlo con 6,5 anni **senza dirlo** farebbe
  scattare revisioni per un cambio di finestra, non per un peggioramento.

> ✅ **QUINDI**: se `DD-1%` supera il **DD promesso**, il referto scrive un
> **RILIEVO** (*"da portare a Claudio"*), **non una revisione automatica**.
> **L'unica cosa che questo round decide è: niente.** Le decisioni le prende
> Claudio leggendo la tabella.

### 4.5 🩺 LA SECONDA MISURA — i deal come controllo incrociato

Per **tutte** le sedie il driver ricalcola **dai deal del report `.htm`**:
`n`, **netto totale**, **PF** e un **DD sul SALDO CHIUSO**. Sono numeri che
vengono da uno strumento **indipendente** dall'`OptResults` (che lo scrive
l'EA): se i due divergono di più del filo, **è il metodo che va guardato, non
la sedia**, e il referto lo stampa come rilievo.

> 🔵 **E su `Gold_Ichimoku` (F25) questa NON è la seconda misura: è l'UNICA.**
> Vedi §7.
> ⚠️ **Il DD sul saldo chiuso NON è il DD dell'equity**: ignora il flottante,
> quindi è **un limite inferiore del limite inferiore**. Si stampa con
> quell'etichetta, e non entra mai nella stessa colonna dell'altro.

---

## 5. 🚦 I GATE — cosa ferma una sedia e cosa no

| # | gate | se fallisce |
|---|---|---|
| **0** | **file prova**: righe vive, n° parametri, `@SIMBOLO`/`@PERIODO`/`@DAQUANDO`, `InpRiskPercent` = taglia viva, `InpComment` = commento vivo *(solo dove l'EA ce l'ha)*, coppia gemella, **magic vietati**, **un solo asse Y** | 🔴 **FATALE per la sedia** (la corsa passa alla seguente) |
| **0-bis** | **sorgente**: `#property version`, `InpMagic` di default = quello del sorgente, include Guardian, `OnTesterDeinit` *(salvo F25)*, marcatore di log d'ingresso *(salvo F25)* | 🔴 **FATALE per la sedia** |
| **1** | **prima operazione** entro i primi **6 mesi** della finestra, letta da **due misure indipendenti** (log del tester + deal del report) | 🟡 **RILIEVO**: la corsa prosegue e il referto stampa la **durata EFFETTIVAMENTE operata** accanto a ogni numero |
| **2** | **n coerente** fra `OptResults` (`Trades`) e report (deal `out`) | 🟡 RILIEVO |
| **3** | **gemelli identici al centesimo** (profitto, PF, DD, n) | 🔴 **FATALE**: banco sporco, di quella sedia non si legge niente |
| **4** | **densità**: periodi con zero operazioni | 🟡 **è un RISULTATO**, non un guasto: si dichiara e si toglie dal denominatore |
| **5** | **n minimo** (§5.1) | 🟡 **etichetta**, mai esclusione |

### 5.1 📏 Il cancello sul `n` — **etichetta, non esclusione**, e il numero ha una ragione

- **n = 0** → *"**PROFITTO ASSENTE**, non profitto zero"*. La riga resta, in
  fondo, col motivo scritto. **Non è uno zero da mettere in classifica.**
- **0 < n < 30** → riga stampata **con l'etichetta `[CAMPIONE SOTTILE]`**.
  Il **30** non è pescato: è il minimo di casa già usato in R5 (*"il minimo dei
  30"*), ed è la **valvola di R59**: *"il campione sottile sospende il giudizio
  sul MERITO, mai sul RISCHIO"*. Quindi su quelle righe **il profitto non si
  legge come merito**, ma **il DD e la peggior giornata si leggono eccome**.
- **n ≥ 30** → riga piena.

🔵 **Nessuna sedia viene esclusa dalla tabella per pochi trade**: Claudio ha
chiesto *"la classifica di TUTTI"*, e una sedia che ha girato **non si butta
via**. Si etichetta.

⚠️ **Atteso**: sui **21 mesi** diverse sedie indici staranno **sotto i 30**
(i contratti promettono ~1-4 op/mese → 20-80 operazioni in 21 mesi, ma
`MaxMinNotte DAX` ne promette ~1,7/mese = **~36**, e `SupertrendReversal`
Nikkei 770924 **~1/mese = ~21**). **È previsto, ed è il motivo dell'etichetta.**

---

## 6. ⚙️ LE TRADUZIONI ESECUTIVE

### 6.1 Il PASSO 0-A (le barre) si fa **per SIMBOLO**, non per sedia

**17 simboli distinti** per 40 sedie: su `GBPUSD` ci sono **7** sedie e su
`U30USD` **8**. Si scarica **una volta per simbolo**, con
`scarica_storico.ps1` **pinnato** (fix Battito-Basi compreso — **non si tocca**),
`-SenzaTick`, dalla data della **finestra del gruppo**:

| gruppo | simboli | timeframe scaricati |
|---|---|---|
| FOREX+METALLI (dal `2020.01.01`) | AUDJPY AUDUSD CHFJPY EURAUD EURCAD EURJPY EURUSD GBPCAD GBPJPY GBPUSD USDJPY XAGUSD XAUUSD (**13**) | `M1,H1,H2,H4,D1` |
| INDICI (dal `2024.09.26`) | D30EUR U30USD NASUSD 225JPY (**4**) | `M1,M5,M15,H1,H2,H4,D1` |

🟡 Il verdetto **non-`COMPLETO` sull'M1 è ATTESO** (`scarica_storico.ps1` dà 120
secondi per timeframe): va nelle **NOTE**, non nei PROBLEMI (checklist 47). La
misura che decide resta **la prima operazione**.
🔴 **E il verdetto si CONFRONTA con la data chiesta**: se il broker risponde una
`PrimaDataServer` **più recente**, la finestra di quella sedia **non è quella
dichiarata**, e il driver lo scrive nei **PROBLEMI** *prima* che si legga un
numero.

### 6.2 Si compila **una volta per EA**

**20 EA distinti** per 40 sedie. Backup datato `.prima_r103_<stamp>` di `.mq5`
**e** `.ex5`, verdetto sul `LastWriteTime`, **ripristino del `.mq5` se
fallisce** (checklist 54). Il terminale è quello collegato al conto vero: è la
ragione per cui il backup non è facoltativo.

### 6.3 🔢 I magic

Blocco **`76xxxx`**, **VERGINE**. Schema: `Base = 760000 + indice_progressivo × 10`
(indice 1…40), e da lì `Base+10` / `Base+11` = **le gemelle**, `Base+12` = la
**passata singola** — lo stesso pattern di R102. Ogni sedia occupa quindi **una
decade sua** (`76002x` per la prima … `76041x` per la quarantesima): **nessuna
collisione**.

✅ **VERIFICATO ESEGUENDO, magic per magic, tutti e 120**: `grep` su tutto il
repo (`.mq5 .mqh .ps1 .txt .set .md .py .ini .csv`) → **zero occorrenze**.
🚫 **Vietati e controllati nel codice**: tutti i magic vivi del `.chr` del
23/08, i blocchi già spesi `7799xx` (R99), `78xxxx` (R100), `79xxxx` (R102),
`7732xx/7733xx` (R101) e **`750xxx` (R104, preso il 24/08)**.

### 6.4 Le passate: **3 per sedia** (2 per la sedia senza OPTFRAME)

1. **SINGOLA** (`Optimization=0`, magic `Base+12`) → il **log** (prima
   operazione) e il **report `.htm`** (deal → spina dorsale, peggior giornata,
   seconda misura);
2. **GEMELLE** (`Optimization=1` sul solo asse `InpMagic`, `Base+10`/`Base+11`)
   → l'`OptResults` con profitto, PF, DD, n **e il gate 3**.

---

## 7. ⛔ LE SEDIE PROBLEMATICHE — dichiarate, non nascoste

### 7.1 🔴 `Gold_Ichimoku_TK_ATR_EA` XAUUSD 250604 — **la sedia senza strumenti**

**MISURATO nel sorgente** (`grep`, non ricordo): **niente `OnTesterDeinit`**
(quindi **nessun `OptResults`**), **niente `InpComment`**, **niente
`InpVerbose`**, **nessuna riga di log d'ingresso**. Non è un difetto della
sedia: **non è un EA della famiglia ABTG** e non ha la strumentazione di casa.
_(R100 l'aveva già dichiarata NON MISURABILE per lo stesso motivo.)_

> ### ✅ COME LA TRATTA R103 — e perché non la butta fuori
> Claudio ha chiesto la spina dorsale **di tutte e 40**. Quindi:
> - gira **solo la passata SINGOLA** (le gemelle non hanno niente da scrivere);
> - **tutti** i suoi numeri escono **dai deal del report `.htm`**: `n`, netto,
>   **spina dorsale anno per anno**, **peggior giornata**, **PF**, e un **DD sul
>   SALDO CHIUSO**;
> - le colonne che non esistono si stampano **`NON MISURATE (l'EA non ha
>   OPTFRAME)`** — **mai un numero al loro posto**;
> - il **gate 3** (gemelli) e il **gate 1 misura-log** su di lei **non
>   esistono**, e il referto lo dice: *"un gate che non c'è non è un gate
>   verde"*.
> - 🟡 **E il suo TF di grafico è `[DA CONFERMARE]`**: l'ho messo a **H1**
>   perché il sorgente stampa *"AVVISO: l'EA è tarato su H1"* se il periodo è
>   un altro — ma **il `.chr` non riporta il TF del grafico**. Se il grafico
>   vivo fosse un altro, quella riga misura **un'altra sedia**. Rilievo scritto
>   sulla sua riga del referto.
>
> 👉 **PROPOSTA per Claudio [DA FIRMARE, fuori da questo round]**: per portarla
> allo stesso banco delle altre serve una **copia di sola lettura** dell'EA con
> l'OPTFRAME (la macchina esiste: è quella che R104 ha usato per l'EA di misura
> MFE). **Non l'ho fatta**, perché questo round non tocca sorgenti.

### 7.2 🟡 `ABTG_DAX_Apertura_EU` e `ABTG_Dow_Apertura_US` — senza `InpComment`

**MISURATO**: questi due EA **non hanno l'input `InpComment`** (infatti nel
`.chr` il loro commento è **vuoto**, e non per distrazione). Il file prova non
lo scrive e **il driver non lo gata**. Tutto il resto è normale.

📌 **E per queste due il dettaglio fine è già agli atti**: **R101** le ha
misurate **a tick reali** sulla **stessa finestra di 21 mesi**, con l'ablazione
dei filtri. Il referto di R103 rimanda esplicitamente a
`risultati_archivio/R101_REFERTO.md`, e le due righe servono qui **solo per
completezza della flotta**.

### 7.3 🟡 Le due `PTE GBPUSD` (F13 e F14) — stesso EA, stesso simbolo

Le distingue **solo il magic** (771322 storica / 771332 candidata R78) e la
cella (buffer 5/TP2 2,0 contro buffer 25/TP2 3,0). Il vincolo sul **magic**
nella lettura del contratto è quello che impedisce di pescare la riga sbagliata.
🔴 Restano **AMBIGUE** sul DD promesso: rilievo aperto dal 23/08, si chiude
riscrivendo quelle due celle del contratto **alla taglia viva** — **è una
firma**, non un esito di questo round.

---

## 8. ⏱️ DURATA, BLOCCHI, RIPRESA

### 8.1 [STIMA] — misurata in **durata simulata**

| pezzo | conto | anni-sedia |
|---|---|---:|
| FOREX+METALLI | 25 sedie × 3 passate × 6,5 anni | **~488** |
| INDICI | 15 sedie × 3 passate × 1,76 anni | **~79** |
| **TOTALE** | | **~567** |

Riferimento: **R100 valeva ~886 anni-sedia ed era stimato 2-6 ore**; R102 ne
valeva ~2.280.

> ⏳ **ORDINE DI GRANDEZZA ATTESO: 1,5-4 ORE DI TESTER**, più lo **scarico
> delle barre M1 di 17 simboli** — che è il collo di bottiglia vero, ma qui è
> **4 volte più leggero di R102** (6,5 anni invece di 27) e i simboli già a
> disco (GBPUSD, EURUSD, AUDUSD, D30EUR, U30USD…) **restano**.
> 🔴 **Questa stima è la parte meno affidabile del documento**, ed è giusto che
> si veda.

### 8.2 🧱 Si lancia **a blocchi**, e c'è anche il gruppo

`-SoloSedia` accetta un **ELENCO fra apici** (checklist 65) e `-SoloGruppo`
accetta `FOREX` o `INDICI`. **I blocchi sono per FAMIGLIA DI EA**, così ogni
blocco **compila un solo sorgente** (dove è possibile): l'elenco completo sta in
`righe/RIGA_R103_DA_MANDARE.md`.

⚠️ **Ogni blocco scrive una cartella e uno zip suoi**, e il referto dichiara in
testa che *"un blocco NON è il round"*. **Vanno mandati tutti.**

### 8.3 🔁 La ripresa, detta com'è (checklist 59)

Un rilancio **liscio** della stessa riga **rifà** la passata singola e le
gemelle di **ogni sedia della lista**: qui non c'è niente da saltare (una
finestra sola per sedia). 👉 **La ripresa che costa poco è `-SoloSedia` con
l'elenco delle sedie il cui esito non è `OK`.**

---

## 9. 🧾 DA DOVE VIENE OGNI PEZZO — la mappa delle fonti

| pezzo | fonte | stato |
|---|---|---|
| le tre decisioni (finestre, tabella separata, due colonne) | `R103_PROPOSTA_CLASSIFICA_FLOTTA.md` | ✅ **FIRMATE 24/08** |
| la spina dorsale obbligatoria + colonna periodi negativi | chiarimento di Claudio, 24/08 mattina, in coda alla proposta | ✅ **REQUISITO** |
| lista sedie, magic vivo, **rischio vivo**, commento | `censimento_rischio_2026-08-23_1549.txt` | ✅ MISURATI |
| il muro `2024.09.26` degli indici | `REFERTO_SONDA_STORICO_17-08.md` (verdetto `COMPLETO`) | ✅ MISURATO |
| le celle vive (17 sedie) | i **preset `.set`** in `mql5/Presets/` | ✅ ARTEFATTI |
| le celle vive (21 sedie) | `deploy_vivaio_*.ps1`, `deploy_pte_gbpusd_b25.ps1` | ✅ ARTEFATTI |
| la cella I14 | `report/DEPLOY_GUARDIANO_100K.md` riga 152 | ✅ ARTEFATTO |
| le taglie ridotte 0,65 / 0,3 | `report/DEPLOY_GUARDIANO_100K.md` righe 149-153 | ✅ MISURATE |
| gli **altri** input di ogni cella | default del sorgente al pin | 🟡 **[DA CONFERMARE]** col `.chr` |
| i TF di grafico | dichiarati **sedia per sedia** nel file prova | ✅ + 🟡 uno **[DA CONFERMARE]** (F25) |
| DD promesso | `report/CONTRATTI_SEDIE.md` **al pin**, per colonna | ✅ ESTRATTO A RUNTIME |
| la convenzione di riscalatura lineare | `CONTRATTI_SEDIE.md` §COME LEGGERE I NUMERI punto 2 | ✅ REGOLA DI CASA |
| il minimo dei 30 trade | R5 + valvola R59 | ✅ AGLI ATTI |
| l'illusione OHLC sugli indici | revalidation 30/07 (`SupRev_DOW_H4`: PF 2,77 → 0,79) | ✅ MISURATA |
| il confronto celle I01/I02 col metro R101 | eseguito, input per input | ✅ **COINCIDONO** |
| verginità dei 120 magic `76xxxx` | `grep` **magic per magic** su tutto il repo | ✅ MISURATA (0 occorrenze) |
| la stima 1,5-4 ore | conto in anni-sedia contro R100 | 🔴 **[STIMA]** |

---

## 10. ✅ CHE COSA È GIÀ STATO VERIFICATO — **eseguendo**

Checklist punto **63** (*"il parse si FA, non si dichiara impossibile"*):

| controllo | come | esito |
|---|---|---|
| il `.ps1` **parsa** | `/opt/pwsh/pwsh` + `[Parser]::ParseFile` | ✅ **0 errori** |
| il `.ps1` è **ASCII puro** | `grep -P '[^\x00-\x7F]'` | ✅ **0 righe** |
| i **40 file prova** sono generati **dai sorgenti veri** | `R103_GENERA_PROVE.py`, con controllo positivo su ogni campo della cella | ✅ **40/40** |
| ogni default si riduce a numero/bool/stringa (macro ed enum risolti) | controllo nel generatore, che **si ferma** altrimenti | ✅ **40/40** |
| le celle **I01/I02** contro il metro **R101** | confronto input per input | ✅ **coincidono** |
| i **120 magic** `76xxxx` | `grep` su tutto il repo, **magic per magic** | ✅ **0 occorrenze** |
| i **gate veri** del driver sui 40 file prova (righe vive, parametri, direttive, rischio, commento, coppia gemella, magic vietati, un solo asse `Y`, nessun default non risolto) | banco di prova offline **sui file veri** | ✅ **40/40** |
| le **due fabbriche di `.ini`** (SINGOLA + GEMELLE) e i loro gate | eseguite per tutte e 40 | ✅ **40/40** |
| version, magic di sorgente, include Guardian, `OnTesterDeinit`, `MarkSrc` | letti nei **sorgenti veri** | ✅ **40/40** |
| i **marcatori di log** (13 distinti), campione **POSITIVO** *e* **NEGATIVO** (checklist 55: riga di servizio dello stesso EA + riga di un ALTRO EA) | banco di prova | ✅ **39/39 presi, 0 falsi positivi** *(1 sedia non ha marcatore: F25 non logga gli ingressi)* |
| `LeggiDeal` su report `.htm` sintetici, **con e senza** la colonna `Commento` in coda (checklist 58) | banco di prova | ✅ stesso risultato: netto **−900 / +1500**, saldo `100 600.00` con lo **spazio** letto |
| `MisureDaiDeal` (n, netto, PF, DD sul saldo) | banco di prova | ✅ e su lista vuota torna **n = −1**, non 0 |
| la **spina dorsale**: 7 anni, 8 trimestri, 22 mesi; anni **VUOTI** fuori dal denominatore | banco di prova | ✅ *"2 negativi su 4 operati"*, non *"su 7"* |
| `DataSimulata` contro la trappola dei millesimi | riga con orologio reale 2026 + data tester 2020 | ✅ legge **2020** |
| `DDPromesso` sul `CONTRATTI_SEDIE.md` **vero**, per tutte e 40 | banco di prova | ✅ **31 estratti, 9 ambigui, 0 mancanti** |
| `-SoloSedia` con **virgole** e con **spazi** (checklist 65), `-SoloGruppo`, e la lista di **UNO** (checklist 62) | banco di prova | ✅ |
| i numeri sotto **cultura it-IT** | banco forzato a `it-IT` | ✅ `1.27013` e `9 005.54` letti giusti; 🐛 **e ha trovato un difetto vero**: la colonna `PF` usciva **`1,3`** con la virgola. Corretto con `Fmt3` (formattazione **invariante esplicita**) |

🟡 **CHE COSA NON È STATO VERIFICATO, e va detto**: tutto ciò che richiede
**MT5** — la compilazione vera dei 20 EA, la durata reale, l'intestazione
italiana del report `.htm` del terminale di Claudio, il comportamento del
tester sui simboli indice. **Il giro a vuoto (`-SoloControllo`) copre gli
artefatti; i numeri li può dare solo la corsa.**

---

## 11. ✍️ LE DECISIONI RESIDUE

Le tre grandi sono **già firmate**. Restano **due cose che NON bloccano il
round**, scritte qui perché siano visibili e non nascoste nel codice:

| # | decisione | come è **adesso** (assunzione prudente, dichiarata) | quando serve la firma |
|---|---|---|---|
| **A** | **taglia delle 5 sedie che nel `.chr` compaiono a due rischi** | **si usa la ridotta** (0,65 / 0,3), che è quella del conto 100k = il deposito del banco. **Ininfluente sull'ordinamento**, che è sul normalizzato (§1.3) | solo se Claudio vuole la colonna "taglia viva" letta sull'altro conto |
| **B** | **modello sugli INDICI**: OHLC (firmato) o **tick reali** (esistono su tutta quella finestra) | **OHLC**, come dice la proposta firmata. Lo switch `-TickReali` esiste, **default OFF** (§3.3) | 🟡 **[DA FIRMARE]** se si vuole la seconda corsa a tick reali sul solo gruppo indici |

> 🔴 **E i due RILIEVI che questo round NON chiude** (li eredita, e li ristampa
> nel referto perché non si perdano):
> 1. **`BREAKOUT_EA_JPY_v3`** USDJPY, viva senza sorgente e senza contratto —
>    **aperto dal 18/08**;
> 2. i **due contratti `PTE GBPUSD`** scritti a due taglie — **aperto dal
>    23/08**;
> 3. *(nuovo)* **`ABTG_GapContinuation` 225JPY**: contratto sì, ma **rischio
>    non leggibile** nel `.chr` → fuori dalla classifica per mancanza di taglia.
