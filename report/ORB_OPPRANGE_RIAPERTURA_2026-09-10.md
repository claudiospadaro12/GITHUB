# 🔓 IL CANDIDATO CHE ERA GIA' IN CASA — `ABTG_ORB` ramo OPPRANGE (U30USD)

**10/09/2026 · verifica fatta a mano sui CSV, non riferita da un agente**
Fonte primaria: `backtest_pipeline/risultati_archivio/r88_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r88a.csv`
(48 celle per finestra, tick reali, referto `REFERTO_R88.txt` del 20/08/2026, pin `c7714a8`).


> 🔁 **STATO: v2 — il cancello ha detto FAIL alla v1, e aveva ragione su 10 punti.**
> `controllo-preventivo` ha ricalcolato ogni cifra dai CSV primari (**12 su 12
> esatte al centesimo**) e poi ha trovato **quattro difetti di classe nuova**
> (189, 190, 191, 192) piu' sei correzioni. **Tutti applicati qui sotto.**
> Il piu' grave: al punto 2 avevo scritto *"centro dell'altopiano, non il picco"*
> — invocando una regola di casa **senza applicarla**. Quella cella **e' il
> picco**, su tutte e tre le metriche. Verbale del cancello nella cronologia di
> sessione; classi in `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`.

## 1. 🎯 IL FATTO, in una riga

**A parita' di rischio (1%), sugli STESSI 119 trade fuori campione, la geometria
`OPPRANGE` (stop all'estremo opposto del range) fa un drawdown di 3,84% dove la
geometria VIVA `HALFRANGE` (stop al 50% del range) ne fa 9,76% — e ha PF piu'
alto, Recovery Factor piu' alto e Sharpe piu' alto.**

| cella (OOS 2025.06.10 → 2026.06.30) | Profit | PF | **DD %** | Rec.F. | Sharpe | n |
|---|---:|---:|---:|---:|---:|---:|
| **HALFRANGE+0 TPmode1** — *stessa geometria della sedia VIVA 770611* | 41.057,00 | 1,6742 | **9,7623** | 3,519 | 28,49 | 119 |
| **OPPRANGE+500 TPmode0 TP 1,5** | 23.003,35 | **1,8385** | **3,8395** | **5,543** | **31,93** | 119 |
| OPPRANGE+0 TPmode0 TP 1,5 | 21.942,40 | 1,7616 | 4,2025 | 4,812 | 29,51 | 119 |

⚠️ **PF, Recovery Factor e Sharpe sono qui per COMPLETEZZA, non come
promozione:** a n=119 (**sotto 150**) il **MERITO e' SOSPESO** e **nessuno dei tre
schiera niente** (vedi punto 5). 👉 **L'unica cosa leggibile a questo n e' il DD,
che e' un fatto accaduto.**

📌 **Profitto per punto di drawdown: 5.991 contro 4.206 = +42%.**

🔴 **E il rovescio, che va detto subito:** OPPRANGE fa **il 44,0% di profitto
in meno** (23.003,35 contro 41.057,00).

📌 **Ma attenzione, ed e' la correzione piu' sottile del secondo giro di
cancello:** il **44,0% in meno** e il **DD dimezzato** sono **LA STESSA COSA vista
due volte** — meno nozionale (~2,2x), contato una volta sul lato dei ricavi e una
volta sul lato del rischio. Non sono uno svantaggio e un vantaggio indipendenti.
- ⚖️ A **parita' di DD** il confronto si ribalterebbe — ma **DI QUANTO e'
  `[NON MISURATO]`**, e **non si estrapola**: questo stesso referto misura che il
  DD **non si riscala linearmente** (6,346 atteso contro 6,5389 misurato).
- 🛑 **E la taglia e' di Claudio.** Qui si dichiara il fatto, non si propone
  un numero.
- 🎯 In una prop il target e' **vincolato al muro di DD**: il rapporto
  profitto/DD **e' la grandezza che morde**. Ma resta vero che la challenge si
  passa col **target**, e con 23.003 al posto di 41.057 quel target arriva piu'
  tardi. **Le due cose vanno tenute insieme, non una sola.**

📌 **DELTA rispetto al preset reale** (`mql5/Presets/conto_reale/ABTG_ORB_Ottimizzato_770611_REALE.set`),
verificati riga per riga dal cancello: **coincidono** `SLMode=3`, `TPMode=1`,
`SLBufferPts=0`, `ExecTF=5`, range 14:30-14:45, `EndHour=21`, `AllowShort=false`,
`TP1Pct=0`, `Ema200Filter`, `MaxRangePct`. **Differiscono tre cose:**
- `InpTP_R` **1,0 dal vivo contro 1,5 nella cella** — **INERTE** con `TPMode=1`
  e `TP1Pct=0`, e **lo prova il CSV stesso**: le righe TP_R 1,5 e 2,0 sono
  identiche al centesimo (Pass 11/15, 27/31, 43/47);
- `InpRiskPercent` **0,65 contro 1** (gia' dichiarato);
- ⚠️ **R88a girava la v1.02, la sedia reale gira la v1.04** — differenza
  **dichiarata, NON misurata**.

📌 **[INFERITO, non misurato] — e la v1 di questo referto ci si era sbagliata.**
Avevo scritto *"tre fonti indipendenti, stesso numero"*. **Falso:** R54b/R55/R88a
sono **la stessa configurazione** (dep. 100.000, rischio 1%) → PF **1,67419**.
R119 e' **un'altra corsa** (dep. **10.000**, rischio **0,65%**) → PF **1,67490**,
diverso alla 4a cifra. E il riscalaggio lineare di 9,7623 a 0,65% darebbe
**6,346%**, mentre R119 misura **6,5389%** (**+3,0%**): 🔴 **il DD non si
riscala linearmente** (cambia anche il deposito, e con lui l'arrotondamento del
lotto). Fonte corretta: `PIANO_CHALLENGE_OTTOBRE.md` **r.149** (non r.70).

## 2. 🧱 IL RAMO — e la cella che **NON** e' il centro dell'altopiano

Non e' una cella fortunata: **tutte e 12 le celle OPPRANGE** stanno sotto il
cancello sul DD, **tutte e 12 le HALFRANGE** ci stanno sopra.

| ramo | DD OOS min → max (12 celle, **rischio 1%**) | PF OOS min → max | vs **A1 (`R88_CRITERI.md`) = DD ≤ 7,00%** |
|---|---:|---:|:---:|
| **OPPRANGE** (SLMode 0) | **3,70 → 5,87%** | 1,642 → 1,844 | 🟢 **12/12 sotto** |
| HALFRANGE (SLMode 3) | **7,96 → 12,02%** | 1,247 → 1,674 | 🔴 **12/12 sopra** |

⚠️ **Il confronto e' a rischio 1%, la taglia del banco di R88.** Alla taglia
**VIVA di 0,65%** la sedia in campo promette **6,5389%**, cioe' **sotto A1**
(`PIANO_CHALLENGE_OTTOBRE.md` r.149). 👉 **L'allarme e' sulla GEOMETRIA, non
sul fatto che la sedia viva sfondi A1 oggi.**

📛 **`A1` e' il cancello sul DD di `R88_CRITERI.md`, NON il `C1` firmato il
18/08** — quello e' il **cap sul rischio aperto simultaneo, 3,25%**. La v1 di
questo referto li aveva confusi (classe 190).

### 🔴 E LA CORREZIONE CHE MI SMENTISCE DI PIU' (classe 189)

La v1 diceva *"la cella e' al centro dell'altopiano, non il picco — regola di
casa, dichiarata prima"*. 🔴 **E' FALSO: quella cella E' il picco del suo
asse, su tutte e tre le metriche.**

| `InpSLBufferPts` | 0 | **500** | 1000 |
|---|---:|---:|---:|
| PF OOS | 1,76162 | **1,83850** ⬅ **max** | 1,64542 |
| Profit | 21.942,40 | **23.003,35** ⬅ **max** | 16.850,58 |
| DD OOS | 4,2025 | **3,8395** ⬅ **min** | 4,4027 |

500 e' il centro dell'**ASSE**, non dell'**ALTOPIANO**. Sono due cose diverse, e
avevo scambiato la seconda per la prima. Applicando la forma operativa che
**R125 congela da solo** (`R125_ORB_COSTO_CRITERI.md` par.3: *vicini col PF
entro ±0,15*): `|1,8385 − 1,6454| = **0,193 > 0,15**` ⇒ **su questo asse NON
c'e' una configurazione robusta.**

👉 **Ed e' un motivo IN PIU' per lanciare R125 con l'asse a 7 valori, non un
motivo per promuovere.** L'altopiano, se c'e', si vede con la griglia fitta —
non con tre punti.

## 3. 🔬 IL MECCANISMO ERA GIA' MISURATO — questo non e' un numero nuovo che spunta

- **R55 (15/08)** aveva gia' trovato la CAUSA: *"il tipo di ordine non la spiega,
  la spiega la LARGHEZZA DELLO STOP (lotto = R / distanza stop → stop stretto =
  piu' lotti = ogni punto costa di piu'). Una cella con lo stop stretto e'
  **fragile due volte**."* E aveva misurato che la config VIVA **sfonda il 10%
  con 1,5 punti indice di slippage** (9,76 → 10,34%).
- **R88 (19/08)** aveva gia' misurato che **OPPRANGE dimezza il DD e alza il PF**.
- **R125 (10/09)** aggiunge il **cancello del costo**: HALFRANGE ~47 punti indice
  = **23,5x** lo spread mediano (2,00) → **sotto il pavimento di lavoro 40x**;
  OPPRANGE ~104 = **52,0x** → **passa**.
  ⚠️ **Numeri DERIVATI.** La stessa grandezza e' anche **misurata** su 7 gambe
  vere della `770611`: **59,0 idx = 29,5x** (OPPRANGE **~64,0x**) — vedi il
  punto 5 e `ROUND_ORB_ATR_PS5` §2.2-bis, **classe 198**. 🟢 **Verdetto
  identico con tutti e due**, ma i due numeri **non si mediano**.

👉 **E allora e' onesto contare bene, perche' la v1 aveva contato male qui
come al punto 1** (classe 196): **NON sono tre prove indipendenti.**
- **R55 e R88a leggono la STESSA riga di CSV** (`41.057,00 / 1,6742 / 9,7623 /
  n=119`): sono **due letture degli stessi dati**, non due misure.
- 🔴 **R125 non e' un round: e' IL round che questo referto chiede di
  autorizzare al punto 6.** Zero passate eseguite. Quello che porta e' un
  **cancello di costo su un range `[INFERITO]`** — e lo dice il punto 5 quattro
  paragrafi piu' sotto. La v1 lasciava punto 3 e punto 5 a contraddirsi **dentro
  lo stesso documento**.

📌 **Quello che resta, ed e' comunque il punto:** due letture degli stessi dati
e un cancello di costo ancora inferito **puntano sulla stessa casella — allargare
lo stop — e nessuna delle tre e' mai stata agita.** E' un buon motivo per
**misurare**, non per promuovere.

## 4. 🪦 PERCHE' ERA STATO ARCHIVIATO — ed e' un numero MANCANTE, non brutto

`OPPRANGE` fu bocciato da un cancello sul **`PF IS >= 1,10`**: misurato **1,061**
(buffer 0) / **1,063** (buffer 500). Ma quel PF e' calcolato su **n IS = 71**.

🔴 **L'Emendamento A (16/08) dice che sotto 150 operazioni il MERITO e'
sospeso.** Un `PF IS = 1,06` a n=71 non boccia niente: e' un numero che non c'e'.
E' esattamente il caso che il motto del 09/09 vieta di archiviare:
*"quando un candidato e' fermo per un numero MANCANTE e non per un numero
BRUTTO, non si archivia: si trova la via piu' corta al numero."*

## 5. 🛑 IL CONTRO-ESEMPIO — cosa questo referto NON dimostra

Costruito prima di consegnare, come vuole la regola del 10/09.

| ipotesi alternativa che romperebbe la lettura | verifica | esito |
|---|---|---|
| *"il DD e' piu' basso solo perche' OPPRANGE espone meno capitale"* | `InpRiskPercent`=1 in **tutte** le 48 righe, n=119, stessa finestra — **ma il lotto va come `R / distanza stop`** (R55, che cito io stesso al punto 3): 47 contro 104 punti indice ⇒ HALFRANGE porta **~2,2x il NOZIONALE** a parita' di 1%, e `Equity DD %` si misura sull'equity, quindi **include il flottante** | ⚠️ 🔴 **NON smentita — anzi, e' il meccanismo PIU' PROBABILE.** La v1 di questo referto la dichiarava "smentita" portando una prova **irrilevante all'ipotesi** (classe 191). Il **fatto** (il DD accaduto) resta e vale per l'Emendamento B; la **causa** e' un misto di *meno stop-out da rumore* e *meno escursione flottante*, e le due parti **non sono separate**: `[NON MISURATO]` — servirebbe il per-trade, che R88 non ha salvato |
| *"e' una cella fortunata"* | 12/12 celle OPPRANGE sotto **A1** (`R88_CRITERI.md`, DD OOS <= 7,00%), 12/12 HALFRANGE sopra | ❌ **smentita**: e' un ramo, non una cella |
| *"il PF OOS 1,84 promuove la sedia"* | n OOS = **119**, sotto la soglia 150 | ✅ **VERA, e mi smentisce**: 🔴 **il merito e' sospeso anche in OOS.** Il PF 1,84 **non promuove**, esattamente come il PF IS 1,06 non bocciava |
| *"la finestra copre piu' regimi"* | `R88a_stoplargo_U30USD.txt` r.153 dichiara: **"IL REGIME CONTENUTO: UNO SOLO"** | ✅ **VERA, e mi smentisce**: 🔴 **Emendamento C non soddisfatto** |
| *"il 52,0x del cancello di costo e' misurato"* | il range ~94 e' **INFERITO** (banda 85-103); al bordo basso con spread P95 fa **31,7x e NON passa** | ⚠️ **parzialmente vera, e la v1 aveva sottostimato il buffer del 40%** (classe 195): il pavimento a P95 chiede `40 x 3,00 = 120` idx, e con `stop = range + 10 + buffer` serve **~16 al centro della banda (range 94)** ma **~25 al BORDO BASSO (range 85)** — cioe' proprio il caso che la frase nomina. 🟢 L'asse arriva a 3000 punti = **30 idx** e contiene **2500**, quindi la conclusione regge — **ma reggeva per fortuna**: fermarsi a 20 avrebbe misurato solo celle che al bordo basso non passano. 🆕 **E il terzo giro di cancello ha trovato l'ANTENATO del numero (classe 198):** lo stesso giorno `CANCELLO_COSTO_FLOTTA_2026-09-10.md` ha **MISURATO** lo stop vero della `770611` su **7 gambe reali** = **59,0 idx** (non ~47) → range implicito **~118**, **sopra** la banda 85-103 → OPPRANGE+0 fa **~64,0x** e **~42,7x anche al P95**, cioe' **passa nudo**. 🟢 **Nessun verdetto si ribalta e la direzione dell'errore era prudente**, ma il "52,0x" di questa riga e' la lettura **DERIVATA**, non la migliore che abbiamo: le due **non si mediano** (`ROUND_ORB_ATR_PS5` §2.2-bis) |

### 🔑 Quindi cosa e' promuovibile OGGI, e cosa no

- ✅ **PROMUOVIBILE — il RISCHIO.** L'Emendamento B: *"il vecchio giudica il
  RISCHIO... si boccia se avrebbe fatto un drawdown, perche' un drawdown e' un
  fatto accaduto, non una stima."* Il 9,76% contro 3,84% **e' accaduto**, a
  parita' di rischio, sugli stessi trade. Questo vale a qualunque n.
- 🔴 **NON PROMUOVIBILE — il MERITO.** n=71 IS e n=119 OOS sono **entrambi sotto
  150**, e il regime e' **uno solo**. Nessun PF di questa tabella schiera una
  sedia.
  🆕 🔴 **E il terzo giro di cancello corregge la riga che stava qui (classe
  205): NON e' vero che *"serve il round R125 per fare il numero"* — su
  U30USD R125 quel numero NON lo fa.** `R125a` dichiara da solo *"n:
  INVARIANTE lungo tutto l'asse, IS 71 / OOS 119, in tutte e 7 le celle"*: il
  buffer sposta lo **stop**, non decide **se si entra**, e il muro dei tick BCM
  (2024.09.26) non si sposta. 👉 **R125 serve a sapere se l'altopiano esiste e
  a che costo.** Il **merito pieno** sul ramo puo' venire solo da **D30EUR** e
  **NASUSD** (`R125c`/`R125e`/`R125f`, n fino a **233** e **357**
  nell'archivio) o da un simbolo in piu' — **non** da un'altra griglia sul Dow.

  ⚠️ 🆕 **MA QUEI DUE NUMERI DICONO IL CAMPIONE, NON IL MERITO** (classe 207,
  quarto giro di cancello). Il **233** e' di `r11` su D30EUR — **un'altra
  ricetta** (finestra 65', EMA50, niente trailing/parziale/breakeven), che il
  dossier archivia **MORTA** con **PF OOS 0,940-1,022** e **DD 17,5-29,7%**.
  Il **357** e' di `ORB` `ohlc` su NASUSD — **altro EA, modello OHLC e non
  tick**, **PF IS 0,945**, **PF OOS 1,248** cioe' **sotto `R125-G3` (1,40)**.
  👉 **Il campione e' RAGGIUNGIBILE li'; il merito NON e' dimostrato.**
  🔴 E la portata vera di R125 la dichiarano i suoi file prova: **n atteso
  90-190 e 100-220**, **due bande a cavallo dei 150** — quindi il merito
  **puo' restare sospeso anche sul DAX e sul Nasdaq**.
  🛑 **E il colpo finale e' di RISCHIO, che si legge a qualunque n:** quelle
  due righe del censimento portano **DD OOS 19,59%** (D30EUR `r11`, profitto
  OOS mediano **negativo**) e **DD IS 22,85% / OOS 11,77%** (NASUSD `ohlc`,
  profitto IS **negativo**). 🔴 **Sfondano `R125-G1`, `R125-G2` e la
  bocciatura secca a 9,7623%.** 👉 Si citano **solo** per il campione: per il
  merito e per il rischio **sono gia' bocciate**.

## 6. 👉 COSA CHIEDE, in concreto

1. 🖊️ **Firma di Claudio sui criteri R125** (`backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md`)
   — a numeri non visti, prima del lancio.

   > ### 🆕 🔴 COSA COMPRA ESATTAMENTE CON QUELLA FIRMA (classe 208, quarto giro di cancello)
   > La riserva del punto 5 stava **solo** nel paragrafo che SPIEGA, non in
   > quello che **CHIEDE LA FIRMA**: chi legge solo "cosa chiede, in concreto"
   > non la incontrava. Quindi, in chiaro:
   > - ✅ **COMPRA:** 6 misure a criteri congelati — **se l'altopiano del ramo
   >   OPPRANGE esiste, dove sta, e a che costo** (`R125a`); se il parziale
   >   lascia soldi per terra sulla sedia viva (`R125b`); e **la prima misura
   >   in assoluto** della geometria del Dow su **DAX** e **Nasdaq**
   >   (`R125c`-`R125f`, buchi B2/B3/B5 del dossier). Costo: **~7 minuti**.
   > - 🔴 **NON COMPRA una sedia schierabile.** Su **U30USD** e' **misurato**
   >   che non puo' esserci: `n` e' **INVARIANTE 71 IS / 119 OOS su tutte e 48
   >   le celle** di R88a (verificato sul CSV: `Trades` ha **un solo valore
   >   distinto**), il buffer sposta lo **stop** e non decide **se si entra**,
   >   e sotto 150 l'Emendamento A tiene il **merito sospeso**.
   >   Su **D30EUR** e **NASUSD** l'`n` atteso e' **90-190** e **100-220**:
   >   🔴 **a cavallo dei 150**, quindi **nemmeno li' e' promessa**.
   > - 🚫 **NON COMPRA niente sul conto reale 10105439.** Nessuna riga di
   >   questo round tocca la `770611`: la domanda del punto 2 resta **sua**,
   >   e resta aperta anche dopo R125.
   > - ⏳ **E cosa servirebbe DAVVERO per una sedia sul Dow:** tick sotto il
   >   muro del **2024.09.26** (che non abbiamo) **oppure** un secondo regime
   >   da un altro simbolo. 👉 **Questo e' il buco da segnalare a Claudio, non
   >   da subire** — e' esattamente il caso in cui si e' messo a disposizione. 6 file prova, 33 celle, 66 passate, **~7 minuti di macchina**. 🔴 **La v1 diceva "~67 minuti": sbagliato di un fattore 10 esatto** (classe 192). Il vero ritmo e' misurato: `REFERTO_R88.txt` da' **13,7 min per 136 passate** = **0,101 min/passata** — le "2,3 ore" del referto R88 sono di **tutta la notte**, R87+R89+R86 compresi.
2. 🔴 **Una domanda che riguarda il conto REALE 10105439, quindi e' SOLO SUA:**
   la sedia viva `770611` gira con la geometria che **non passa il cancello di
   costo** — **23,5x** con lo stop DERIVATO, **29,5x** con lo stop **MISURATO
   su 7 gambe vere** (59,0 idx, `CANCELLO_COSTO_FLOTTA` §5.1): **sotto il
   pavimento di 40x con tutti e due** — e che **R55 misura sfondare il 10% con
   1,5 punti di slippage**. A 0,65% il margine viene **dalla taglia, non dal motore**. Non
   propongo di toccarla adesso — propongo di **misurare il ramo OPPRANGE con
   R125** e poi metterle a confronto con i numeri in mano.

---
*Nessun parametro in forward e' stato toccato. Nessuna riga e' partita verso il
VPS. Questo file e' una lettura di CSV gia' in archivio.*
