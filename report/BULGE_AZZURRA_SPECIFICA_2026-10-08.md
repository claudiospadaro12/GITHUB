# 🔵 BULGE AZZURRA — la CONTINUAZIONE del Bulge (specifica, 08/10/2026)

> Richiesta di Claudio, 08/10/2026, testuale: _"ORA VOGLIO CHE CREI UNA EA BULGE CON LA CANDELA VIOLA DI
> CONTINUAZIONE CHE IN QUESTO CASO LA FAREMO AZZURRA PER DISTINGUERE IL COLORE E IL COMMENTO SARA' BUGE
> AZZURRA. STESSE IMPOSTAZIONI SOLO CHE IL MOVIMENTO E' DIVERSO. ATTIENITI A CREARLO IDENTICO ALL'EA ATTUALE."_
>
> "BUGE AZZURRA" e' un **refuso**: il commento e' `BULGE_AZZURRA` (dichiarato qui e nell'intestazione dell'EA).

**File**: `mql5/Experts/ABTG_BulgeAzzurra.mq5` (copia di `mql5/Experts/ABTG_Bulge.mq5` v5.20) ·
**Collaudo**: `backtest_pipeline/collaudo_bulge_azzurra.py` ·
**Stato**: 🔴 **compilazione MetaEditor NON provata** (MetaEditor non c'e' in questo ambiente) · 🔴 **nessun backtest**.
Niente preset, niente righe di lancio: `ABTG_Bulge.mq5`, `BULGE_MASTER.mq5` e i preset **non sono stati toccati**.

---

## 1. 🎯 Il movimento, in una riga per segnale

| | VIOLA (in `ABTG_Bulge`) | 🔵 AZZURRA (questo EA) |
|---|---|---|
| Pattern della guida | INVERSIONE | CONTINUAZIONE |
| Dopo l'impulso | il prezzo torna alla mediana | il prezzo **ritraccia in modo ordinato** fino alla banda **opposta** |
| Test | **ritest della STESSA banda** dell'impulso | **test della banda OPPOSTA** (obbligatorio) |
| Direzione | **contro** l'impulso | **nella direzione** dell'impulso |
| Esempio | impulso ribassista -> long sul ritest della banda bassa | impulso rialzista -> **long** sul test della banda **bassa**; ribassista -> **short** sul test della banda **alta** |
| Banda testata | deve essere **piatta** (`lowerFlat/upperFlat`) | **non si valuta** (guida: "nessun requisito, puo' essere gonfia") |
| TP / SL | mediana BB (aggiornata a ogni tick) / 3 x ATR | **identici** (stessa `OpenOrder`, stessa `UpdateAllTP`) |
| Filosofia | "ogni tocco dopo un impulso" (decisione di Claudio) | **la stessa**: ogni tocco, di default; `Azure_FirstTouchOnly=true` = solo il primo |

## 2. 📜 Regola per regola: guida -> codice

Fonte: `docs/breaking_band/GUIDA_OPERATIVA_11.txt` (regole ufficiali r.~60-80, definizione di ritracciamento ordinato
r.~212-247, tabella comparativa r.~283-335, filtri r.~336-392, entrata r.~400-445).

| Regola della guida (CONTINUAZIONE) | Nel codice | Stato |
|---|---|---|
| Impulso (bulge) prima del ritracciamento | ricerca dell'**ultimo impulso** gia' esistente in `CheckSignal` (candela che tocca la banda, corpo >= 0,2 x ATR, colore nel verso), finestra `[1, Lookback_Bars*2]` = 40 barre H1 come il VIOLA | ✅ riusata, non toccata |
| Ritracciamento verso la banda opposta, passando la mediana | `midAfterImpUp/Down` (stessa misura del VIOLA: una candela fra impulso e test che contiene la mediana) | ✅ **scelta**: obbligatoria (domanda 3) |
| "Nessuna candela con range > 1,5 x ATR" (definizione A del ritracciamento ordinato) | `AzureOrderedRetrace`: nessuna candela **fra** l'impulso e la candela di test con `high-low > Azure_MaxRetraceRangeATR x ATR` (default 1,5; 0 = spento). Impulso e candela di test **esclusi** | ✅ |
| Test **obbligatorio** della banda opposta | `lows[iCnf] <= bbLowerCnf` (long) / `highs[iCnf] >= bbUpperCnf` (short), barra di conferma chiusa | ✅ |
| "Entry al tocco della banda opposta (corpo o spike)" | il tocco e' sul **minimo/massimo** (spike ammesso); il range della candela di test NON e' limitato | ✅ |
| "Test con candela non impulsiva" / invalidazione "test impulsivo > 1,5 x ATR" | `PurpleReactionCore(..., false)`: corpo <= 1,5 x ATR. **Sempre** la variante EA del VIOLA: `Use_Purple_PineReaction` resta una manopola del solo VIOLA | ✅ |
| Banda opposta: nessuna inclinazione, puo' essere gonfia | **nessun** controllo di banda piatta / inclinazione | ✅ |
| TP mediana, SL 3 x ATR | `OpenOrder(sym, lato, atrSig, bbBasisCnf, ...)`, identica al VIOLA | ✅ |
| News rosse H1-M30 | filtro news orario ereditato (spento di default, come in `ABTG_Bulge`) | = ereditato |
| Zig-zag / "impulsi contrari" / "accelerazioni di volatilita'" / "candele coerenti" | **NON codificato** (non oggettivo nella guida) | ❓ domanda 1 |
| "Bande in fase di chiusura / restringimento dopo la bulge", deviazione standard sotto la sua SMA50 | **NON codificato** (coerente con la decisione VIOLA "senza controllo del bulge") | ❓ domanda 3 |
| Band riding (20+ candele sulla banda dell'impulso) | **NON codificato** | ❓ domanda 1 |
| Ombre <= 1,5 x corpo, range medio -30/50% rispetto all'impulso | **NON codificato** (la guida stessa li dice "facoltativi") | — |
| Candela di inversione sul livello (pin bar, doji) | **NON codificato** (la guida la dice "opzionale") | — |

## 3. ✅ Cosa e' IDENTICO a `ABTG_Bulge.mq5`

Verificato **a macchina** dal collaudo, non a occhio:
- **tutte le funzioni** tranne le 8 dichiarate sono **byte per byte** uguali (OnTick, CalcLots, UpdateAllTP,
  kill switch, parziale, BE/trailing, gestione manuale, OnTester/OPTFRAME, ecc.);
- `OpenOrder` e' identica **a meno del nome passato al Guardian** (`"ABTG_BulgeAzzurra"`, solo etichetta di log);
- `CheckSignal` **senza il blocco AZZURRA** e' identica: VIOLA, BLU, ARANCIO e le misure condivise non sono toccati;
- **tutti gli input** hanno stesso nome, tipo e default (BB 20/2, ATR 14, `SL_ATR_Mult` 3, `Bulge_Multi` 1,1,
  `Lookback_Bars` 20, `Signal_Bar_Offset` 1, filtro ATR, ADX acceso con soglia 30 sul BLU, news spento, parziale/BE/
  trailing spenti, kill switch 4/3/2%, rischio 0,80% x `Max_Trades` 4, Guardian acceso, basket di 22 cross).

## 4. ✏️ Cosa CAMBIA (e solo questo)

| # | Cosa | Default |
|---|---|---|
| 1 | `InpMagic` | **774500** — blocco **7745xx verificato libero** (vedi sotto) |
| 2 | `InpComment` | **`BULGE_AZZURRA`** |
| 3 | `Use_Blue`, `Use_Purple` | **false** (`Use_Orange` era gia' false): il codice dei tre segnali resta, spento |
| 4 | `Use_Azure` (nuovo) | **true** |
| 5 | `Azure_MaxRetraceRangeATR` (nuovo) | **1.5** (0 = controllo spento) |
| 6 | `Azure_FirstTouchOnly` (nuovo) | **false** = ogni tocco, come il VIOLA |
| 7 | `ADX_Apply_On_Azure` (nuovo) | **false**, come il VIOLA |
| 8 | blocco AZZURRA in `CheckSignal`, dopo il VIOLA + funzioni pure `AzureCore`, `AzureOrderedRetrace` | — |
| 9 | tag `AZZURRA` in `ExtractSignalTag` (notifiche, referto di chiusura, colonna `signal` del CSV), `AdxFilterOk`, `[BULGE-CONTA]`, nome del CSV per-trade (`..._azzurraOGNI.csv` / `PRIMO`) | — |
| 10 | autotest AZZURRA in avvio + prova "il VIOLA non e' cambiato" | — |
| 11 | **un caso di prova dell'autotest B) corretto** (vedi §6) — NON la logica | — |

**Diff contro `ABTG_Bulge.mq5`**: 25 blocchi, **22 righe** di `ABTG_Bulge` toccate, ~279 righe nuove (quasi tutte
commenti e autotest). Ogni blocco cade in una delle **18 zone dichiarate** nel collaudo.

**Il magic, e perche' non 7728xx.** Il blocco proposto (7728xx) e' **OCCUPATO**: `ABTG_IntradayMomentum.mq5` r.186
= 772800, e le righe del round R98 usano 772820-772891. Il blocco **7745xx**: **0 file** con ripgrep a confini di
numero su tutto il repo (file ignorati e nascosti compresi, `.git` escluso) e **0 file** con `git grep` sulle punte di
12 branch remoti (08/10). Il collaudo lo rifa' a ogni corsa (`git grep --untracked`).

**Il commento degli ordini** sara' `BULGE_AZZURRA_AZZURRA_L` / `_S` (23 caratteri, sotto il limite di 31): il
prefisso e' `InpComment`, il suffisso e' il segnale, come `BULGE_VIOLA_L` nel Bulge. La ripetizione e' voluta dalla
consegna; se Claudio preferisce `BULGE_AZZURRA_L` basta `InpComment=BULGE` (il magic diverso tiene comunque separati
i due EA). ⚠️ Il prefisso contiene gia' `_AZZURRA`: per questo `ExtractSignalTag` riconosce l'AZZURRA **per ultima e
sul suffisso completo** (`BULGE_AZZURRA_VIOLA_L` resta VIOLA; un commento troncato dal broker `BULGE_AZZURRA_VIO` da'
`?`, non AZZURRA). Il collaudo stesso **ci era caduto** al primo giro (filtrava gli ordini su `_AZZURRA_`): ora e'
una prova esplicita.

## 5. 🧭 Le scelte fatte dove la guida NON detta

1. **"Ordinato" = solo la regola oggettiva A della guida**: nessuna candela con range > 1,5 x ATR fra l'impulso e la
   candela di test. ATR = quello della barra del segnale (lo stesso metro del VIOLA). L'impulso e' escluso (e' grande
   per definizione), la candela di test e' esclusa (ha il controllo del corpo, e la guida ammette lo "spike").
   Zig-zag, "impulsi contrari", band riding, "candele coerenti" **non sono codificati**: non hanno un numero.
2. **Ogni tocco** di default, come il VIOLA; il primo tocco e' un input (`Azure_FirstTouchOnly`).
3. **Mediana attraversata obbligatoria** (stessa misura del VIOLA). Passando dalla banda alta alla bassa il prezzo la
   attraversa quasi sempre; la differenza la fanno i gap e la mediana che si sposta. E' la scelta prudente.
4. **Finestra**: impulso entro `Lookback_Bars*2` = 40 barre H1 dalla barra del segnale, come il VIOLA.
5. **Nessun controllo del bulge** (`isBulgeSig`) e **nessun restringimento delle bande**: come il VIOLA, per la
   decisione di Claudio "ogni tocco dopo un impulso, senza controllo del bulge". La guida pero' li elenca fra le
   conferme della continuazione: e' la domanda 3.
6. **Un impulso CONTRARIO durante il ritracciamento non annulla l'AZZURRA.** Esempio: dopo un impulso rialzista, una
   candela ribassista che tocca la banda bassa con corpo >= 0,2 x ATR e' per l'EA anche un "impulso ribassista", ma
   l'AZZURRA long guarda solo l'ultimo impulso rialzista. Il limite di range (1,5 x ATR) taglia le candele davvero
   grandi; il resto e' la domanda 1.
7. **ADX**: `Use_ADX_Filter` resta acceso (si applica al BLU, che qui e' spento); sull'AZZURRA e' **spento** come sul
   VIOLA. ⚠️ Il filtro e' "anti-bandriding": blocca quando il trend e' FORTE. Per una **continuazione** il trend forte
   potrebbe essere un alleato, non un nemico: e' la domanda 5.
8. **TF H1 fisso**, come tutto il Bulge (`PERIOD_H1` nel codice condiviso). Cambiarlo tocca codice condiviso.

## 6. 🐛 Difetto trovato in `ABTG_Bulge.mq5` (preesistente, NON corretto li')

L'autotest **B)** di `ABTG_Bulge.mq5` (r.743) prova la "candela larga" con `1.10000 -> 1.10020`: corpo **0,0002**,
contro una soglia di 1,5 x 0,0010 = **0,0015**. Il corpo **passa**, l'attesa scritta e' "scarta": la riga B) stampa
**`*** FAIL ***` a ogni avvio** e il verdetto d'insieme dice **"NON mettere in campo"**. Misurato dal collaudo
**compilando il sorgente vero** (riga `INFO` in testa all'esito: `eLargo=1 aEA=0`). Il contro-esempio che lo prova:
la stessa prova con corpo 0,0017 scarta, come atteso. E' un difetto **dell'autotest, non della logica di trading**
(i commenti dicono "20 pip" per 0,0002: la scala e' sbagliata di 10). La riga R92bis
(`backtest_pipeline/righe/RIGA_R92bis_CANARINO_BARRA1.md` r.111) si aspettava `PASS`; nessun log del campo nel repo
riporta l'uscita reale. Nella **copia AZZURRA** il solo caso di prova e' portato a `1.10170` (zona dichiarata), perche'
altrimenti l'AZZURRA direbbe "NON mettere in campo" per un errore non suo. **Correggerlo anche in `ABTG_Bulge.mq5` e'
una decisione della sessione principale** (la consegna era di non toccarlo).

## 7. 🧪 Cosa prova il collaudo (e cosa no)

`python3 backtest_pipeline/collaudo_bulge_azzurra.py` — esito nel referto di consegna. Strati:
- **Z** zone del diff; **S** statico (funzioni identiche, input, magic, Guardian prima di ogni invio, segnaposto);
- **P** funzioni pure compilate in C++: `AzureCore` (33 casi a mano), `AzureOrderedRetrace` (9, bordi esatti),
  `ExtractSignalTag` (11), `AdxFilterOk`, `PurpleReactionCore` uguale fra i due EA, e il **pezzo vero dell'autotest**;
- **X** `CheckSignal` **vera** dei due EA compilata in C++: 27 scenari a mano con l'ordine atteso (lato, commento,
  ATR, mediana); **differenziale** su 6000 finestre casuali x 4 configurazioni (con `Use_Azure` spento i due EA aprono
  gli **stessi** ordini; acceso, nessun ordine BLU/VIOLA/ARANCIO si sposta); **specchio Python indipendente**
  della regola AZZURRA su 6000 finestre x 7 configurazioni;
- **M** mutanti ciechi: i mutanti di logica devono essere presi da P o X, non solo dal diff.

🔴 **NON provato**: compilazione MQL5, `CTrade`/riempimenti, Guardian oltre la sua riga, iBands/iATR/iADX del
terminale, tick reali. **Nessun numero di performance**: frequenza, PF, DD sono **non misurati**. I conteggi delle
finestre casuali del collaudo **non sono una stima di frequenza** (serie sintetiche).

## 8. ❓ Domande per Claudio

1. **"Ordinato"**: basta "nessuna candela con range > 1,5 x ATR fra l'impulso e il test" (com'e' ora)? Oppure vuoi
   anche "nessuna candela impulsiva **contro** l'impulso" (con quale soglia di corpo?) e un limite al band riding
   (20 candele sulla banda dell'impulso)?
2. **Primo tocco o ogni tocco** della banda opposta? Ora: ogni tocco, come hai deciso per il VIOLA.
3. **Mediana attraversata obbligatoria** (ora si'). E il **restringimento delle bande / deviazione standard sotto la
   sua media**, che la guida mette fra le conferme della continuazione: lo codifichiamo, o resta fuori come per il
   VIOLA?
4. **Finestra**: 40 barre H1 fra l'impulso e il test (come il VIOLA) ti torna, o la continuazione e' piu' corta?
5. **TF e ADX**: H1 come il Bulge (o anche M30, che la guida cita per le news)? E l'ADX: sull'AZZURRA lo lasciamo
   spento, o per una continuazione lo vuoi **al contrario** (entrare solo se il trend e' forte)?

## 9. ⚠️ Avvertenze prima di qualunque uso

- **Rischio aperto**: l'AZZURRA ha il **suo** `Max_Trades` (4) e il **suo** kill switch (magic diverso). Se gira
  sullo stesso conto del Bulge, il rischio aperto possibile e' **4 x 0,80% + 4 x 0,80% = 6,40%**, sopra il cap C1 del
  3,25%: lo regge **solo il Guardian**, e sul piccolo `50503392` il Guardian **non gira** (CLAUDE.md, 12/09). Le taglie
  sono **firma di Claudio**: qui non e' stato cambiato nessun rischio.
- **Ordine dei controlli**: 1) compilazione in MetaEditor; 2) all'avvio, le righe `[BULGE][AUTOTEST]` devono dire
  tutte PASS (comprese `AZZURRA: ... PASS` e `VIOLA invariato ... PASS`); 3) solo dopo, il backtest su **storico
  lungo e un simbolo per passata**, con criteri firmati **prima** dei numeri (regole di casa: >=150 operazioni di IS,
  regime dichiarato, OOS). Nessuna riga di lancio e' stata preparata.
- **Demo prima del reale**, sempre.
