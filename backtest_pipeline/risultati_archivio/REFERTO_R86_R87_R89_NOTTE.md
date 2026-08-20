# 🔓 R86 · R87 · R89 — i tre round sigillati, aperti dopo la firma

_Girati la notte del 19→20/08 col resto della coda. **I CSV sono rimasti chiusi
in una cartella sigillata finche' Claudio non ha firmato i criteri** (firma in
chat la sera del 20/08, a numeri mai visti). Aperti subito dopo. CSV agli atti
in `r86_r87_r89_csv/`._

---

## 1. 🔬 R87a — L'IMPATTO DEI 3 FIX DEL GOLDENCROSS (v1.00 congelata vs v2.00)

| simbolo | fin | **V1: PF · DD · profit · n** | **v2.00: PF · DD · profit · n** |
|---|---|---|---|
| USDCHF | IS | 3,6277 · 1,56 · +465,54 · 20 | 2,8669 · 2,03 · +422,10 · 21 |
| USDCHF | OOS | **2,1884** · 2,34 · +229,57 · 17 | **1,5929** · 2,35 · +157,36 · 18 |
| USDCAD | IS | **3,5190** · 1,28 · +287,27 · 10 | **1,5081** · 2,80 · +143,19 · 12 |
| USDCAD | OOS | 2,8936 · 1,27 · +197,98 · 12 | **3,6755** · 1,40 · **+280,85** · 14 |
| NZDUSD | IS | 2,7774 · 0,94 · +149,60 · 8 | **3,5638** · 1,10 · +200,44 · 10 |
| NZDUSD | OOS | **1,6679** · 2,81 · +189,05 · 14 | **1,1648** · **4,68** · +86,46 · **22** |
| XAUUSD | IS | 1,4943 · 2,28 · +299,35 · 32 | **1,7212** · 2,41 · **+622,61** · **47** |
| XAUUSD | OOS | 1,2531 · 6,08 · +308,30 · 57 | 1,1944 · 6,31 · +303,59 · 66 |

### Il fatto che spiega tutto: **la v2.00 fa SEMPRE piu' trade**
20→21 · 17→18 · 10→12 · 12→14 · 8→10 · **14→22** · **32→47** · 57→66.
E' la firma del **FIX 1**: la finestra dell'incrocio ora cerca l'EVENTO nelle
ultime N barre invece di guardare solo la barra numero N, quindi **trova gli
incroci freschi che la v1.00 perdeva**. Il motore non e' stato "accelerato":
prima ne saltava una parte per un difetto di indice.

### Verdetto secondo i criteri firmati
- **"i fix hanno MIGLIORATO"** (PF v2 >= PF V1 +0,10 in ENTRAMBE le finestre e
  DD non peggiore di 1,0 pp): **nessun simbolo lo soddisfa**.
- **"i fix hanno PEGGIORATO"** (PF <= PF V1 −0,10 in almeno una finestra, o DD
  peggiore di >1,0 pp): **USDCHF** (peggio in entrambe), **USDCAD** (IS
  −2,01), **NZDUSD** (OOS −0,50 e **DD +1,87 pp**). **XAUUSD non scatta**
  (OOS −0,06, DD +0,23): e' l'unico "invariato", e in IS migliora nettamente.
- **Cambio di identita' della sedia** (|Δn| > 25% = "e' un'altra sedia"):
  **NZDUSD OOS +57%** e **XAUUSD IS +47%** sfondano. USDCAD e' in mezzo
  (+17/+20%), USDCHF resta cosmetico (+5%).

### 🔴 E la regola firmata, che vale piu' dei numeri
> *"In OGNI caso i fix RESTANO — un bug non si tiene perche' era fortunato.
> Se peggiora, la reazione ammessa e' spegnere la sedia, MAI rimettere la
> v1.00. Il FIX 3 e' un fix di RISCHIO, non negoziabile sul P&L."*

Quindi **la v1.00 non torna in campo**: il suo vantaggio nasceva dal saltare
segnali per un difetto di indice, e su un campione di **8-32 trade in IS** e'
indistinguibile dalla fortuna. Cio' che R87a dice davvero e': **il GoldenCross
completo, senza il difetto, e' piu' debole di quanto credessimo.**

📌 Nota di merito **sospeso**: n IS = 8-32 su tutti e quattro (contro i 150
dell'Emendamento). Questi numeri **non promuovono e non bocciano nessuna
sedia**: descrivono un cambiamento, non un edge.

---

## 2. 🌊 R89 — LIQUIDITY SWEEP (GBPUSD): il motore nuovo NON parte

| cella | IS | OOS |
|---|---|---|
| **A — motore nudo** | PF **0,2318** · DD 7,74 · **−637,30** · n 14 | PF **1,0566** · DD 5,87 · +74,44 · n 24 |
| B — finestra Londra (ore 6/7/8, 3 varianti) | **tutte PF 0,00** · n 1-4 | migliore PF 1,3921 · n **9** |

**Bocciato dal canarino di frequenza, che si legge PRIMA del conto economico:**
il criterio firmato pretende **n IS >= 30 e livelli IS >= 30**; qui l'IS fa
**14 trade** nudo e **1-4** con la finestra. **Il round non e' misurabile.**
E il criterio diceva anche cosa concludere: *"la conclusione e' che
`SwingBars=21` su H4 e' troppo raro — NON che manca l'edge"*.

La cella B non si legge affatto (il criterio lo vieta quando A e' sotto
canarino). Le tre ore 6/7/8 danno peraltro numeri **identici**: la finestra
non sta separando niente, sta solo tagliando.

➡️ **Non e' una bocciatura del meccanismo**: e' la prova che con 21 barre H4
per lato i livelli sono troppo pochi. Se il motore merita un round vero,
servono **swing piu' corti** (o un TF di struttura piu' basso) — e sarebbe un
round nuovo, con criteri nuovi.

---

## 3. ⚡ R86 — CROSSEMA (incrocio EMA 9/21): l'aspettativa era giusta

| mercato | cella | IS: PF · DD · profit · n | OOS: PF · DD · profit · n |
|---|---|---|---|
| **XAUUSD** | A nudo | 0,8188 · **21,77** · −1.608 · 138 | 1,0310 · **15,56** · +372 · 197 |
| XAUUSD | B volumi | 0,5588 · 18,89 · −1.447 · 45 | **1,4064** · 13,12 · **+1.614** · 65 |
| XAUUSD | **C ema200** | **1,1069** · **10,92** · **+620** · 84 | **1,1832** · 12,30 · +1.344 · 119 |
| XAUUSD | D opposta | 0,9233 · 13,97 · −768 · 171 | 1,1562 · 15,80 · +2.431 · 270 |
| **D30EUR** | A nudo | 0,9484 · 17,69 · −394 · 113 | 0,9242 · **20,43** · −1.009 · 204 |
| D30EUR | B volumi | 1,0919 · 9,34 · +275 · 44 | 0,8744 · 16,43 · −771 · 93 |
| D30EUR | C ema200 | 0,8100 · 18,42 · −1.012 · 78 | 1,0211 · 12,90 · +165 · 123 |
| D30EUR | D opposta | 0,8438 · **26,12** · −1.500 · 150 | 0,9735 · 14,39 · −420 · 267 |

**L'aspettativa dichiarata prima dei numeri era: "la cella nuda sara'
probabilmente brutta, un motore a incroci nudo sovra-trada per costruzione".
E' esattamente cosi'**: cella A con **PF sotto 1 in IS su entrambi i mercati**
e drawdown mostruosi (**21,8% oro, 20,4% DAX**). Il muro del rischio firmato
(DD > 15,0% = bocciatura secca a qualunque n) **le boccia tutte e due**.

**L'unica gamba che regge il rischio e' C (EMA 200) sull'oro**: unica cella con
PF > 1 in **entrambe** le finestre (1,107 IS / 1,183 OOS) e DD sotto la soglia
in IS (10,92%). Ma OOS 12,30% resta alto, e nessuna cella arriva ai cancelli
firmati per aggiungere una gamba (PF campione intero >= PF nuda + 0,10 con DD
non peggiore).

📌 **I volumi confermano la loro storia**: sul DAX affondano (OOS 0,87), sull'oro
alzano il PF ma dimezzando i trade — e in IS restano a 0,56. Terza bocciatura
consecutiva della stessa gamba (R84 PF 0,917 · R26 0/3 · R86).

➡️ **Verdetto: il CrossEma nudo NON ha un edge**, e per la
**Regola della Seconda Caccia** (firmata il 19/08) parte la ricerca di
**meccanismi alternativi**, non di altri parametri dello stesso motore.
L'unica pista interna che vale una misura e' **C sull'oro con un limite di
rischio**: il filtro di trend fa quello che deve, e' il resto del motore a
essere troppo largo.

---

## 4. Cosa esce da questa notte, in tre righe

1. **Nessuna promozione, da nessuno dei tre round.** Nessun parametro in campo
   cambia.
2. **R87 e' il piu' importante e il piu' scomodo**: i 3 fix restano (sono
   correzioni di difetti), ma dicono che il GoldenCross **senza il difetto** e'
   piu' debole di come lo conoscevamo. Le quattro sedie vive girano ancora
   sulla v1.00: **la decisione se ricompilarle e' di Claudio**, e va presa
   sapendo che significa mettere in campo un motore piu' lento e — su tre
   simboli su quattro — con numeri peggiori nel passato misurato.
3. **R89 e R86 non hanno prodotto un edge**, ma hanno prodotto due direzioni
   precise: swing piu' corti per il LiquiditySweep, e per il CrossEma la
   seconda caccia sui meccanismi.
