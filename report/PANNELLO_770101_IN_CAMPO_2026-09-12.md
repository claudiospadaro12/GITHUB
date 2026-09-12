# 📸 IL PANNELLO DI `770101` IN CAMPO — letto dalle foto del 12/09/2026, 20:43

**Fonte**: tre schermate del pannello *Dati in Ingresso* di `ABTG_DAX_Apertura_EU 1.01`
sul grafico **D30EUR,M5** del terminale **`50504263`** (`... MT5 Terminal -V3`,
profilo `SQUADRA 100K`). Mandate da Claudio.
🔴 **Le schermate contenevano saldo ed equita' del conto 100k: NON sono riportati qui,
il repository e' pubblico.** Qui ci sono solo input di configurazione.

---

## 🟢 LE QUATTRO RISPOSTE CHE SERVIVANO

| input | valore IN CAMPO | verdetto |
|---|---|---|
| **Rischio per trade %** (`InpRiskPercent`) | **0.65** | 🟢 **il contratto e' rispettato** |
| **Consenti operazioni short** (`InpAllowShort`) | **false** | 🟢 long only, come i criteri |
| **Ingresso** (`InpEntryMode`) | **rottura + ritorno sul livello con LIMIT** = **RETEST** | 🟢 e' la cella validata |
| **% chiusa al 1o obiettivo** (`InpTP1_ClosePct`) | **50.0** | 🔴 **il regalo NON e' incassato** |

### 🔑 Conseguenza sulla discrepanza di taglia 4,0x
Il rischio in campo sul conto della challenge e' **0,65%**, cioe' **esattamente il
contratto**. Quindi la discrepanza misurata (uno stop pieno da 104,60 unita' contro
un segnale da 40,30) **non viene da un rischio mal impostato su questa sedia**.
👉 Combinata con il fatto che il `104,60` del 14/08 porta il commento **BREAKOUT** e
sta sul **piccolo 50503392**, la spiegazione piu' economica resta: quella misura
apparteneva a un'**istanza diversa sul demo**, non alla sedia del 100k.
🔴 Resta `[NON MISURATO]` da dove venga esattamente quel 104,60.

---

## 🔴 LA SCOPERTA CHE NON CERCAVO: **LE TRE PROTEZIONI DAL COSTO SONO TUTTE SPENTE**

| input | valore | cosa vuol dire |
|---|---|---|
| **Spread massimo in punti** | **0** | `0 = nessun limite`. La sedia **entra a qualunque spread** |
| **Slippage stimato in PUNTI** | **0.0** | nessun cuscinetto sull'ingresso |
| **Floor minimo di STOP in punti** | **0.0** | il cancello *"se lo stop < floor SALTA il trade"* e' **true**, ma con floor **0** e' **inerte** |

🔴 **E stasera ho misurato perche' questo conta**, su 650.484 campioni veri
(`data/spread_vivo/SPREAD_VIVO_2026-09-12_referto.txt`):
- **D30EUR** ore cash: mediana **1,60** / P95 **1,70** / max **1,70** — piattissimo;
  ma **di notte 2,80**, cioe' **+75%**.
- **U30USD**: mediana 2-3 punti indice, **P99 ora 17 = 9,0**, **MAX ora 13 = 30,0**.
  Cioe' lo spread **decuplica**.

👉 Su D30EUR nelle ore di sessione il rischio e' basso (lo spread non ha coda: max = P95).
🔴 Ma **una manopola a `0` non e' una scelta tarata: e' l'assenza di una scelta**, e la
sedia non ha **nessuna** difesa se il feed allarga. Il backtest a spread costante
**non ha mai visto quella coda**.

⚠️ **NON E' UNA CORREZIONE CHE POSSO FARE**: `InpMaxSpread`, `InpSlippage` e il floor
sono **parametri di rischio**, e quelli restano di Claudio. Qui si **misura e si propone**.

### 📐 La proposta, col numero e non a occhio
Con mediana **1,60** e P95 **1,70** nelle ore di sessione (GG=5), un tetto a
**2,70 punti indice = 270 punti MT5** lascerebbe passare **tutto** il normale
(e' il P95 della notte, non delle ore cash) e taglierebbe solo gli allargamenti
anomali. 🔴 **Da provare, non da applicare**: il file prova
`COLLAUDO_DAX101_01_spread_scala_ini.txt` e' gia' scritto e gatato per misurare
la scala di spread a tick reali.

---

## 🟢 E SETTE CONFERME CHE CHIUDONO ALTRETTANTI DUBBI

| | in campo | perche' conta |
|---|---|---|
| **Guardian** (pausa B1 + cap rischio aperto) | **true** | la sedia e' sotto il Guardian |
| **Ora apertura (server)** | **8** | 🟢 **ora SERVER**, non italiana (la trappola di casa: 9 sarebbe sbagliato) |
| **Un solo ciclo operativo al giorno** | **true** | e' il meccanismo che garantisce **max 1 posizione**, misurato anche dai 193 giorni |
| **Come calcolo lo stop loss** | **stop sull'estremo opposto del range** | 🔑 **ANCORA UNICA confermata al pannello**: lo stop nasce dal range e il target e' in unita' di stop. E' la ragione per cui questa sedia vive a M5 con 35,1x mentre un cono a 52,4x muore |
| **Durata del range** | **35** minuti | combacia col preset `770101_100K` |
| **Numero magico** | **770101** | 🟢 la sedia giusta |
| **Versione EA** | **1.01** | da confrontare col sorgente a HEAD |

🔴 **Filtro notizie: `false`.** La sedia opera anche dentro le news. Su un breakout
d'apertura e' difendibile (l'apertura *e'* l'evento), ma va **dichiarato**, non subito.

---

## 🧾 COSA RESTA `[NON MISURATO]`
1. **Se su `D30EUR,M15` ci sia una seconda istanza** di `DAX_Apertura` oppure
   `ABTG_MaxMinNotte` (magic 770411). Il terminale ha **otto** grafici aperti:
   `D30EUR,M5` · `U30USD,M5` · `D30EUR,M15` · `225JPY,H2` · `EURUSD,H1` ·
   `U30USD,H1` · `AUDNZD,H1` · `AUDUSD,H1`. Serve il nome in alto a destra di quel grafico.
2. **Da dove viene il `104,60`** del 14/08 sul piccolo.
3. **La versione 1.01 contro il sorgente a HEAD**: se il campo gira un binario piu'
   vecchio, i numeri del backtest sono di un altro codice.
4. **Se `InpMaxSpread=0` sia una scelta o una dimenticanza.** Domanda per Claudio.

---

# 🔴 ERRATA DELLO STESSO GIORNO — IL CASO ERA GIA' CHIUSO IL 02/09

Ho riaperto da zero un caso che aveva **gia' un verbale nel repo**:
`report/VERBALE_CHIUSURA_770101_2026-09-02.md`, commit `9638318`. Settima volta
oggi con la stessa causa: **la risposta c'era gia', scritta da qualcun altro.**

## Cosa dice quel verbale, e cosa smonta della mia indagine

| mia "scoperta" di stasera | il verbale del 02/09 |
|---|---|
| *"770101 esiste su DUE conti"* | 🟢 **E' il MIRROR, ed e' una DECISIONE FIRMATA** (n.2 del 02/09: stesso magic su piccolo + 100k, rinumerazione prevista alla challenge). **Non e' contaminazione: e' il disegno.** |
| *"due SELL allo stesso secondo il 29/07 = due istanze"* | 🟢 Gia' indagato: attribuito a una configurazione **di PRIMA del 17/08**, **non riproducibile ne' osservabile oggi**. C1 del 02/09: lista Expert del piccolo = **UN SOLO grafico** con `DAX_Apertura` |
| *"potrebbe girare il preset LEGACY_2pct al 2%"* | 🔴 **Il rinominare quel preset in `LEGACY_2pct` ERA IL FIX**, firmato ed eseguito il 02/09 (C4.2). Stavo sospettando di un file **ritirato dieci giorni fa, e ritirato apposta** |
| *"`ABTG_DEF_RISK 2.0` e' una trappola da chiudere"* | 🟢 Chiuso il 02/09 su questo EA: `2.0 -> 1.0` (C4.1). *(Resta aperto su `ABTG_Nasdaq_Apertura_US`, che e' un altro EA.)* |

## 🟢 Ma la mia lettura del pannello aggiunge DUE fatti che il verbale non poteva avere

**1. IL RISCHIO E' SCESO DA 1,0 A 0,65 dopo il 02/09.**
Il verbale C2 registra `InpRiskPercent = **1.0**` (il contratto di allora). La foto di
stasera dice **0.65**. 🟢 E' **esattamente** la conclusione del collaudo prop di oggi
(*"lo 0,65% e' la condizione di sopravvivenza, non una preferenza: a 1,00% il DD
combinato fa p99 12,17%"*) — quindi qualcuno l'ha **gia' applicata**.
🔴 **Ma e' un parametro di rischio cambiato fra il 02/09 e oggi, e va confermato da
Claudio**, non dedotto da me.

**2. `A1: tetto posizioni+pendenti sul simbolo` E' ANCORA `0` = SPENTO.**
Il verbale lo segnalava (*"l'EA ha GIA' questo input, oggi 0=spento -> la proposta P0
puo' riusare input esistenti"*), e **dieci giorni dopo e' ancora spento**. 👉 E' la
protezione che avrebbe impedito le due SELL gemelle del 29/07, **il codice c'e' gia'**,
e manca **solo una firma**. Zero righe da scrivere.

## 🧾 E quindi cosa resta DAVVERO aperto, ridotto all'osso
1. 🔴 **`Spread massimo = 0`** (nessun limite) + **slippage 0** + **floor 0**: le tre
   difese dal costo spente, mentre stasera ho misurato spread che su U30USD arrivano
   a **30,0 punti indice**. **Da quantificare, poi da firmare.**
2. 🔴 **`A1 tetto` = 0**: una firma, zero codice.
3. 🔴 **`InpTP1_ClosePct` = 50** contro il regalo a **0** (PF 1,397->1,491, DD 7,23%->6,27%).
4. ⚠️ La conferma che il **rischio a 0,65** sia voluto.
