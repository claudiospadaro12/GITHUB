# 🔓 IL CANDIDATO CHE ERA GIA' IN CASA — `ABTG_ORB` ramo OPPRANGE (U30USD)

**10/09/2026 · verifica fatta a mano sui CSV, non riferita da un agente**
Fonte primaria: `backtest_pipeline/risultati_archivio/r88_csv/ABTG_ORB_Ottimizzato_U30USD_{IS,OOS}_r88a.csv`
(48 celle per finestra, tick reali, referto `REFERTO_R88.txt` del 20/08/2026, pin `c7714a8`).


> ⏳ **STATO: IN ATTESA DEL CANCELLO.** Questo referto e' stato mandato a
> `controllo-preventivo` il 10/09 sera e **non e' ancora tornato con un PASS**.
> Finche' non torna, i numeri qui dentro sono **verificati da me sui CSV
> primari** ma **non controfirmati**. Regola del 09/09: *"se il controllo non e'
> ancora tornato, SI ASPETTA."*

---

## 1. 🎯 IL FATTO, in una riga

**A parita' di rischio (1%), sugli STESSI 119 trade fuori campione, la geometria
`OPPRANGE` (stop all'estremo opposto del range) fa un drawdown di 3,84% dove la
geometria VIVA `HALFRANGE` (stop al 50% del range) ne fa 9,76% — e ha PF piu'
alto, Recovery Factor piu' alto e Sharpe piu' alto.**

| cella (OOS 2025.06.10 → 2026.06.30) | Profit | PF | **DD %** | Rec.F. | Sharpe | n |
|---|---:|---:|---:|---:|---:|---:|
| **HALFRANGE+0 TPmode1** — *la geometria VIVA sul reale (770611)* | 41.057,00 | 1,6742 | **9,7623** | 3,519 | 28,49 | 119 |
| **OPPRANGE+500 TPmode0 TP 1,5** | 23.003,35 | **1,8385** | **3,8395** | **5,543** | **31,93** | 119 |
| OPPRANGE+0 TPmode0 TP 1,5 | 21.942,40 | 1,7616 | 4,2025 | 4,812 | 29,51 | 119 |

📌 **Profitto per punto di drawdown: 5.991 contro 4.206 = +42%.**
📌 `InpRiskPercent = 1` identico in TUTTE le celle (verificato nel CSV): il
confronto e' **normalizzato al rischio**, non un artefatto di taglia.
📌 La riga HALFRANGE+0 TPmode1 **e' la cella viva**: PF 1,6742 e n=119 coincidono
con `770611` (`PIANO_CHALLENGE_OTTOBRE.md` r.70: *OOS 2484,17 / PF 1,67490 / DD
6,5389% / 119 trade*), dove il 6,54% e' lo stesso 9,76% **riportato a 0,65%**.
E coincide **al centesimo** con R55 (`DIARIO.md` 15/08: *+41.057,00 · 1,6742 ·
9,7623 · n=119*). Tre fonti indipendenti, stesso numero.

## 2. 🧱 L'ALTOPIANO, non il picco

Non e' una cella fortunata: **tutte e 12 le celle OPPRANGE** della griglia
stanno sotto il cap C1, **tutte e 12 le HALFRANGE** ci stanno sopra.

| ramo | DD OOS min → max (12 celle) | PF OOS min → max | vs **C1 = 7,00%** |
|---|---:|---:|:---:|
| **OPPRANGE** (SLMode 0) | **3,70 → 5,87%** | 1,642 → 1,844 | 🟢 **12/12 sotto** |
| HALFRANGE (SLMode 3) | **7,96 → 12,02%** | 1,247 → 1,674 | 🔴 **12/12 sopra** |

La cella scelta e' **al centro dell'altopiano** (buffer 500 = il valore di mezzo
dell'asse 0/500/1000), **non il picco** — regola di casa, dichiarata prima.

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

👉 **Tre misure indipendenti, fatte in tre round diversi, puntano tutte sulla
stessa casella: allargare lo stop.** E nessuna delle tre e' stata agita.

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
| *"il DD e' piu' basso solo perche' OPPRANGE espone meno capitale"* | `InpRiskPercent` = 1 in **tutte** le 48 righe del CSV; stesso n (119); stessa finestra | ❌ **smentita**: stesso denaro a rischio per trade |
| *"e' una cella fortunata"* | 12/12 celle OPPRANGE sotto C1, 12/12 HALFRANGE sopra | ❌ **smentita**: e' un ramo, non una cella |
| *"il PF OOS 1,84 promuove la sedia"* | n OOS = **119**, sotto la soglia 150 | ✅ **VERA, e mi smentisce**: 🔴 **il merito e' sospeso anche in OOS.** Il PF 1,84 **non promuove**, esattamente come il PF IS 1,06 non bocciava |
| *"la finestra copre piu' regimi"* | `R88a_stoplargo_U30USD.txt` r.153 dichiara: **"IL REGIME CONTENUTO: UNO SOLO"** | ✅ **VERA, e mi smentisce**: 🔴 **Emendamento C non soddisfatto** |
| *"il 52,0x del cancello di costo e' misurato"* | il range ~94 e' **INFERITO** (banda 85-103); al bordo basso con spread P95 fa **31,7x e NON passa** | ⚠️ **parzialmente vera**: serve buffer >= ~15, ed e' il motivo per cui l'asse del round arriva a 30 |

### 🔑 Quindi cosa e' promuovibile OGGI, e cosa no

- ✅ **PROMUOVIBILE — il RISCHIO.** L'Emendamento B: *"il vecchio giudica il
  RISCHIO... si boccia se avrebbe fatto un drawdown, perche' un drawdown e' un
  fatto accaduto, non una stima."* Il 9,76% contro 3,84% **e' accaduto**, a
  parita' di rischio, sugli stessi trade. Questo vale a qualunque n.
- 🔴 **NON PROMUOVIBILE — il MERITO.** n=71 IS e n=119 OOS sono **entrambi sotto
  150**, e il regime e' **uno solo**. Nessun PF di questa tabella schiera una
  sedia. Serve il round R125 per fare il numero.

## 6. 👉 COSA CHIEDE, in concreto

1. 🖊️ **Firma di Claudio sui criteri R125** (`backtest_pipeline/prove/R125_ORB_COSTO_CRITERI.md`)
   — a numeri non visti, prima del lancio. 6 file prova, 33 celle, 66 passate, ~67 minuti.
2. 🔴 **Una domanda che riguarda il conto REALE 10105439, quindi e' SOLO SUA:**
   la sedia viva `770611` gira con la geometria che **non passa il cancello di
   costo (23,5x contro 40x)** e che **R55 misura sfondare il 10% con 1,5 punti di
   slippage**. A 0,65% il margine viene **dalla taglia, non dal motore**. Non
   propongo di toccarla adesso — propongo di **misurare il ramo OPPRANGE con
   R125** e poi metterle a confronto con i numeri in mano.

---
*Nessun parametro in forward e' stato toccato. Nessuna riga e' partita verso il
VPS. Questo file e' una lettura di CSV gia' in archivio.*
