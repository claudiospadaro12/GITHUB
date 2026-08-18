# 🧪 R84 — L'ABLAZIONE DEI FILTRI DEL CORSO (Nasdaq apertura US)

_Criteri congelati il **18/08/2026 sera**, PRIMA di qualunque numero.
Chi legge la tabella dei risultati deve aver letto prima questo file._

> 🎯 **LA DOMANDA, UNA SOLA:**
> **"I filtri che il corso prescrive come CONDIZIONI aggiungono o tolgono —
> misurato, un filtro alla volta, a parita' di tutto il resto?"**

**Perche' esiste questo round.** L'audit del 02/08 spense tutti i filtri con
una promessa: *"prima si misura la configurazione dei documenti a tick reali,
poi si cambiano i default"*. Quella misura **non e' mai stata finita**
(`caccia_strategie/ANALISI_PIANI_APERTURA_2026-08-18.md` §1.2: *"l'ablazione
dei filtri Nasdaq non risulta mai girata"*). Quindi oggi i filtri sono spenti
**non perche' misurati inutili, ma perche' la misura non e' mai stata fatta**.
Finche' R84 non gira, la frase *"il metodo del corso non funziona"* resta
**NON DIMOSTRATA**: quello che e' morto nei walk-forward (PF 0,82 il 31/07;
19/20 celle OOS negative il 05/08) e' lo **scheletro NUDO**, senza le
condizioni che il corso mette prima dell'ingresso
[PAG 29: *"se anche solo un punto e' 'NO'... forse e' meglio aspettare"*].

Questo e' il **debito n.1 della coda di test** lasciata dall'analisi dei piani.

---

## 1. 🔒 COSA E' CONGELATO QUI (e non si tocca dopo)

1. **L'EA e' quello vivo, NON si tocca il codice.** `ABTG_Nasdaq_Apertura_US.mq5`
   com'e' sul branch `lavoro`. R84 accende input che esistono gia'.
2. **Un filtro alla volta.** Ogni cella cambia UNA cosa rispetto alla cella A.
   L'unica cella multi-filtro e' la I (*metodo completo*), ed e' dichiarata
   come tale: serve a rispondere alla domanda del corso (*tutte le condizioni
   insieme*), non a scegliere una configurazione.
3. **Nessuna griglia, nessuna ottimizzazione.** Le soglie dei filtri sono
   quelle **da manuale/da documento** (volumi x1,5 su 20 barre; ATR >= media
   su 20 barre; EMA 14/200 H1; Supertrend 10 x2,5; ST x3 = 2,5/3,0/3,5;
   correlazione SPXUSD 14/100 H1). **Non si spazzolano.** Se un filtro ha
   bisogno di una soglia diversa per funzionare, quello e' un ALTRO round.
4. **R84 non promuove niente in forward.** Produce una risposta, non una
   sedia. La sedia 770201 e' **SPENTA** dal 18/08 (FIRMA 5) e resta spenta.

## 2. 📏 COSA MISURA E COSA NON MISURA

**MISURA:** se, aggiungendo una condizione del corso allo stesso motore,
sulla stessa finestra e con lo stesso riempimento, il risultato migliora
o peggiora — e di quanto **il campione si assottiglia** (un filtro che porta
n a 12 non e' un filtro migliore: e' un filtro non misurabile).

**NON MISURA (dichiarato accanto a ogni numero, sempre):**
- **La robustezza di regime.** La finestra dei tick reali BCM non contiene
  ne' il crollo 2020 ne' l'orso 2022 (`risultati_prove/storico_bcm/LEGGIMI.md`).
- **Il filtro news.** Escluso apposta, vedi §6.
- **Se il Nasdaq apertura ha edge.** Anche se un filtro migliorasse i numeri,
  R84 da solo **non promuove**: 21 mesi e un solo regime non bastano
  (EMENDAMENTO DELLA FINESTRA, punto C).

## 3. 📅 FINESTRA E DATI — e il PASSO 0 che viene prima di tutto

### 3.1 PASSO 0 (obbligatorio, prima di qualunque corsa)

> **La profondita' dei TICK REALI degli INDICI a BCM non e' MAI stata
> misurata.** Il referto del 15/08 misura GBPUSD (tick dal **2024.07.05**) e
> dice a chiare lettere: *"da misurare allo stesso modo: i tick degli INDICI
> (D30EUR, U30USD, NASUSD, SPXUSD, 225JPY)"*. Il **2024.09.26** che gira in
> 110 file prova e' la profondita' delle **BARRE**, non dei tick.

Per essere precisi su cosa e' misurato e cosa no:
- **BARRE degli indici: MISURATE.** Sonda del 17/08
  (`risultati_archivio/REFERTO_SONDA_STORICO_17-08.md` §3): `NASUSD` e gli
  altri indici partono dal **2024.09.26**, verdetto **`COMPLETO`** — non
  manca sul disco, il broker non ce l'ha piu' indietro.
- **TICK degli indici: NON misurati.** Nel repo l'unica riga `TICK` che
  esiste e' quella di `GBPUSD` (probe del 15/08). Per gli indici quella riga
  non e' mai stata prodotta.

E' il difetto n.18 della checklist (*profondita' misurata su un TF, corsa
girata su un altro*). Quindi:

```
scarica_storico.ps1 -Simboli "NASUSD" -Da 2024.01.01 -TimeoutMin 180
```
e **si legge la riga `NASUSD,TICK`, colonna `PrimaDataLocale`**, non la riga
M1. Il `-TimeoutMin` e' dimensionato sulla stima (difetto n.19: un timeout
piu' corto della stima ammazza MT5 a meta' e **esce 0**).

- Se i tick partono **dopo** il `@DAQUANDO` scritto nei file prova → **il
  round si ferma** e la finestra si riscrive con la data misurata.
- Se i tick degli indici **non ci sono affatto** → R84 si gira a **modello 1
  (OHLC M1)** e **ogni numero porta scritto accanto "OHLC, non tick"**:
  l'illusione OHLC ha gia' revocato una promozione in questa casa (SupRev DOW
  H4, FIRMA 5).

### 3.2 La finestra dichiarata (provvisoria fino al PASSO 0)

| | |
|---|---|
| simbolo | **NASUSD** |
| TF del grafico nel tester | **M15** |
| dal | **2024.09.26** (barre misurate; **da confermare sui TICK**, §3.1) |
| al | **2026.06.30** |
| modello | **4 = tick reali** (se il PASSO 0 lo consente) |
| deposito | **10.000** |
| split del driver | IS 40% / OOS 60% (`walkforward_generico.ps1`) |

### 3.3 ⚖️ L'EMENDAMENTO DELLA FINESTRA, applicato onestamente

La regola di casa vuole **>=150 operazioni** per l'IS. **Qui non sono
raggiungibili e lo si dichiara PRIMA**: 21 mesi, `InpOneTradePerDay=true`,
un ciclo al giorno → il tetto teorico e' ~440 giornate, e il run US col piano
completo del 02/08 si fermo' a **72 trade**.

**Come si applica l'Emendamento a un round che non puo' rispettarlo:**

1. **R84 NON seleziona una cella.** Non c'e' scelta di parametri, quindi non
   c'e' il rischio che la soglia dei 150 esiste per prevenire (una superficie
   frastagliata da cui si pesca il picco). La domanda e' un **confronto A/B**,
   non una selezione.
2. **Il verdetto si legge sul campione INTERO** (IS+OOS della stessa cella).
   Lo split IS/OOS serve solo come **prova di coerenza**: stesso segno nelle
   due meta' = leggibile; segni opposti = **non concludente**, e si scrive.
3. **Valvola R59, per cella:** sotto **30 operazioni totali** il giudizio di
   **MERITO e' SOSPESO** (si scrive "non misurabile", non "peggiora"). Il
   giudizio di **RISCHIO** non si sospende mai: un DD del 25% e' un fatto
   accaduto anche su 12 trade.
4. **Regime contenuto nella finestra, dichiarato:** toro USA 2024-2025 +
   correzione primavera 2025. **Un solo regime e mezzo.** Nessun risultato di
   R84 puo' essere chiamato "robusto".

## 4. 🧬 LE NOVE CELLE

**Cella A = baseline.** Tutte le altre partono da A e cambiano **una riga**.

| cella | cosa accende | input cambiati rispetto ad A | magic (2 gemelli) | regola del corso |
|---|---|---|---|---|
| **A** | niente (scheletro nudo) | — | 776010 / 776011 | la sedia com'era |
| **B** | **volumi** | `InpUseVolumeFilter=true` | 776020 / 776021 | #13 [PAG 14,17] |
| **C** | **ATR >= media** | `InpUseAtrFilter=true` | 776030 / 776031 | #14 [PAG 14] |
| **D** | **volumi OR ATR** | `InpUseVolumeFilter=true` + `InpUseAtrFilter=true` + `InpConfirmMode=0 (OR)` | 776040 / 776041 | la conferma come la scrive il PDF |
| **E** | **EMA 14/200 H1** | `InpUseEmaFilter=true` | 776050 / 776051 | #16 [PAG 29] |
| **F** | **Supertrend H1** | `InpUseSupertrend=true` | 776060 / 776061 | #16/#17 |
| **G** | **Supertrend x3** | `InpUseSupertrend3=true` | 776070 / 776071 | #17 [EU SLIDE 23] |
| **H** | **correlazione SPXUSD** | `InpUseCorrelation=true` | 776080 / 776081 | #18 [EU SLIDE 2,18] |
| **I** | **METODO COMPLETO** | D + E + G + H insieme | 776090 / 776091 | *"se anche un punto e' NO, aspetta"* [PAG 29] |

**I due magic gemelli per cella** sono l'unico asse spazzolato (flag `Y`):
il driver pretende almeno un asse e le due passate **devono uscire identiche**
— e' il controllo gratis che smaschera cache del tester e griglie ricordate
da MT5 (checklist punto 5).

**Configurazione di base della cella A** (scritta per intero in
`prove/R84a_base_NASUSD.txt`, perche' un file prova deve dire da solo cosa ha
misurato): apertura 14:30 server, `RANGE_PREVBAR` su H1, buffer 200 pt,
`SL_RANGE`, TP1 1R con parziale 50% + BE, trailing base-candela M1, flat
21:45, un ciclo al giorno, **rischio pinnato 1,00%**, **tutti i filtri
spenti**, `InpUseRoundLevels=false`.

> ⚠️ **La cella A NON e' "la sedia viva".** La sedia 770201 girava a **0,25%**
> con un preset (`mql5/Presets/ABTG_Nasdaq_Apertura_US.set`) che e' **piu'
> vecchio del sorgente** (non contiene meta' degli input di oggi) e che ha
> `InpUseNewsFilter=true`, `InpUseRoundLevels=true`, `buffer=300`,
> `close=20:45` — mentre in campo il filtro news era **spento** (fedelta' #12).
> **Non si puo' dire "la cella A riproduce gli atti"**: gli atti (PF 0,82 del
> 31/07) sono di un'altra finestra e di una configurazione non piu'
> ricostruibile riga per riga. La cella A e' il **riferimento di R84**,
> dichiarato qui: e' contro di lei che si misurano B..I, e basta.

## 5. ⚖️ I CRITERI DI LETTURA — congelati adesso, si applicano dopo

Per ogni cella si leggono **Profit, PF, Equity DD %, Trades**, nelle due
finestre IS e OOS e nel totale.

**Un filtro "AGGIUNGE" se, e solo se, tutte e quattro:**
1. **campione leggibile**: >= **30 operazioni** totali (sotto: giudizio di
   merito sospeso, valvola R59);
2. **coerenza fra le due meta'**: il segno del Profit non si ribalta fra IS e
   OOS (o migliora in tutte e due rispetto ad A);
3. **PF meglio di A di almeno +0,10** sul campione intero (sotto quella
   soglia, con questi n, e' rumore: si scrive "non distinguibile");
4. **DD non peggiore di A** di piu' di 1 punto percentuale.

**Un filtro "TOGLIE" se** peggiora PF **e** taglia il campione, o se peggiora
il DD.

**"NON MISURABILE"** e' un verdetto valido e frequente qui, e va scritto per
esteso: campione troppo sottile, o segni discordi fra le meta'.

**Il verdetto del round** e' una riga sola, di uno di questi tre tipi:
- *"I filtri del corso AGGIUNGONO: la cella X e' meglio di A su tutti e
  quattro i criteri. Il debito del 02/08 e' chiuso: si apre un round di
  validazione vera (regimi + walk-forward) prima di qualunque forward."*
- *"I filtri del corso TOLGONO: nessuna cella batte A. I default spenti
  restano spenti, adesso PER MISURA e non per omissione."*
- *"NON MISURABILE su questa finestra: il campione e' troppo sottile. Serve
  piu' storico (broker esterno) o si chiude la pratica."*

**Nessuno di questi tre esiti accende una sedia.** Il forward passa dal
processo completo (regimi, walk-forward, canarino, firma di Claudio).

## 6. 🚫 COSA E' STATO ESCLUSO APPOSTA (e perche')

- **Filtro NEWS (`InpUseNewsFilter`)** — regola #12, la piu' importante del
  corso per le prop. **Escluso da R84**: si alimenta da un CSV in
  `MQL5/Files`, e la **copertura di quel CSV sulla finestra non e' misurata**.
  Un CSV che non copre il periodo produce una cella **identica alla baseline**
  e sembrerebbe "filtro neutro": sarebbe un numero falso. Prima serve una
  sonda che conti le righe del CSV dentro la finestra. → **coda, R84-bis**.
- **`InpUseRoundLevels`** — e' una regola di **USCITA** (primo obiettivo),
  non un filtro d'ingresso. Mescolarla qui contaminerebbe la lettura.
  Era acceso nel preset del Nasdaq: merita un round suo. → **coda**.
- **Filtro VWAP (`InpUseVwapFilter`)** — viene dalle live di Emiliano, non da
  questi quattro documenti: fuori tema per un round che misura *il metodo del
  corso*. Pinnato spento in tutte e nove le celle. → **coda**.
- **Leve R30 (`InpUseVolRegime`, `InpUseSRFilter`)** — non vengono dal corso
  (vengono dai parametri di un EA esterno). Fuori tema. → **coda**.
- **Size divisa 50/50** [AM SLIDE 10] — unica regola dei pptx **mai
  implementata**: richiede codice. Da fare solo se R84 mostra edge.

## 7. ⏱️ ORDINE DI ESECUZIONE E STIME (dichiarate come STIME)

1. **PASSO 0** — profondita' tick NASUSD (§3.1). **Stima 20-90 min**, dipende
   da cosa c'e' gia' sul disco. Si legge la riga `TICK`.
2. **GIRO A VUOTO** — `lancia_r84.ps1 -SoloControllo`: non apre MT5, stampa
   le celle e le anteprime `.ini`. **Stima 1-2 min.** Se una cella non
   produce l'anteprima, lo script esce **1** e ci si ferma li'.
3. **CANARINO** — `-Solo A`: la sola cella A. **Stima 20-60 min** (mai
   misurata su indici a tick reali: e' proprio questo che il canarino
   misura). Da qui si ricava la stima delle altre otto.
4. **LE OTTO CELLE** — `lancia_r84.ps1` senza `-Solo`. **Stima 3-8 ore**
   (= 8 x il tempo del canarino). Il `-TimeoutMin` del driver si dimensiona
   **dopo** il canarino, numero contro numero (difetto n.19).

⚠️ **UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**: R84 non
puo' girare mentre gira HistData/Dukascopy o un altro round. E MT5 va
**chiuso** prima di lanciare (lo script si rifiuta di partire se lo trova
aperto).

## 8. 📎 TRACCIABILITA'

- File prova: `prove/R84a_base_NASUSD.txt` ... `prove/R84i_completo_NASUSD.txt`
- Driver: `backtest_pipeline/lancia_r84.ps1`
- Fonti: `prove/PIANI_APERTURA_SPEC.md` ·
  `caccia_strategie/ANALISI_PIANI_APERTURA_2026-08-18.md` §1.2 e §3 (coda)
- Regole di casa applicate: EMENDAMENTO DELLA FINESTRA (A/B/C/D) ·
  valvola R59 · CHECKLIST_RIGA_DI_LANCIO punti 5, 13, 14, 18, 19
