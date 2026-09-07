# 🚀 R118 — LA RIGA DA MANDARE (il pavimento dello stop sotto slippage)

_Scritta il **07/09/2026**. **NON ancora passata dal verificatore delle
stringhe**: prima di arrivare a Claudio deve passarlo, e questo documento e'
scritto pensando che qualcuno la eseguira' su un banco per romperla._

**Criteri CONGELATI** (si leggono PRIMA delle tabelle):
`backtest_pipeline/prove/R118_PAVIMENTO_STOP_CRITERI.md`.
Questa riga **non cambia i criteri**: li traduce in file eseguibili.

---

## 📌 IL PIN — **da riempire con il SHA del commit che contiene questi file**

> ⚠️ **Il `-Rif` di default e' `lavoro` (la punta).** Va bene per una prova
> immediata; per una corsa che dura ore si scrive il **SHA** del commit che
> contiene `lancia_r118.ps1`, i tre file prova e i criteri (checklist punto 4:
> se il commit del file fosse piu' nuovo del SHA scritto qui, il SHA sarebbe una
> bugia). Comando per prenderlo:
> ```
> git log --oneline -1 -- backtest_pipeline/lancia_r118.ps1
> ```

🔴 **E un limite che il pin NON copre, dichiarato**: `walkforward_generico.ps1`
ha `$EABranch = "lavoro"` **scritto fisso** e riscarica i `.mq5` dalla **PUNTA**
del branch, non dal SHA. Questo round **non modifica nessun EA**, quindi la
punta e' la versione voluta — **ma se qualcuno tocca
`ABTG_ORB_Ottimizzato.mq5` o `ABTG_DAX_Apertura_EU.mq5` fra il pin e il lancio,
gira un EA diverso da quello letto**. 👉 **Le ancore di riproduzione (§ANCORE)
sono esattamente il controllo che lo prenderebbe.**

---

## ⛔ PRIMA DI LANCIARE — traffico e prerequisiti

- 🖥️ **PC di BACKTEST. MAI sul VPS.** Questo round non tocca nessun terminale
  del VPS e nessuna sedia viva.
- 🧯 **UNA MACCHINA, UN LAVORO**: il PC di backtest ha **un solo MT5**. Prima di
  lanciare va dichiarato che non c'e' nessun altro round in corso.
- 🔒 **MT5 e MetaEditor CHIUSI.** Lo script si rifiuta di partire se li trova
  aperti (col terminale aperto il tester non gira → zero CSV).
- ✅ **Cosa NON tocca**: nessun `.mq5`, nessun `.set`, nessun preset, nessun
  parametro di forward, nessun conto. Magic **VERGINI** `778220` / `778230` /
  `778240`: **non sfiora il 770611 ne' il 770101**, che sono gli stessi due EA
  vivi sul conto **REALE 10105439**.
- ⏱️ **Durata: [NON MISURATA].** 170 passate a tick reali (85 celle × 2
  finestre). Unico riferimento di casa sulla stessa finestra e sugli stessi
  simboli: **R88, 27 file in 2h16**. Non prometto un numero che non ho.

---

## 1️⃣ PRIMA il giro a vuoto (~1 minuto, nessuna passata, MT5 mai aperto)

```powershell
$p="$env:USERPROFILE\lancia_r118.ps1"; Remove-Item $p -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/lancia_r118.ps1" -OutFile $p -ErrorAction Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'ROUND 118' -Quiet)){ throw 'SCRIPT VECCHIO O SCARICATO MALE' }; & powershell -ExecutionPolicy Bypass -File $p -Rif lavoro -SoloControllo
```

**I tre pezzi ci sono tutti e tre** (checklist punto 8): `Remove-Item` (niente
copia vecchia da eseguire) · `-ErrorAction Stop` sull'`irm` (l'errore e'
TERMINANTE, la riga muore li') · `Select-String` su un marcatore che esiste solo
in questo script (copre insieme la cache di `raw.githubusercontent`, che tiene
**~5 minuti**, e il download andato a male).

### 🔍 COSA DEVE STAMPARE, e cosa fare se non lo stampa

| corsa | `celle per finestra` attese |
|---|---|
| `r118c` (DAX RETEST) | **10** |
| `r118a` (ORB U30USD) | **25** |
| `r118b` (DAX a STOP) | **50** |

E, in `spazzolati`, esattamente questi assi:

```
r118c :  InpMinStopPts 5 celle · InpSkipIfTight 2 celle
r118a :  InpSLBufferPts 5 celle · InpSlippagePts 5 celle
r118b :  InpMinStopPts 5 celle · InpSkipIfTight 2 celle · InpSlippagePts 5 celle
```

> 🛑 **Se i numeri non coincidono, CI SI FERMA LI'.** Costa un minuto adesso,
> due ore di tick reali dopo. E' il punto 5 della checklist, ed esiste perche'
> in R58 un file con tutte le righe a flag `N` fece girare **la griglia di
> default dell'EA** senza che nessuno se ne accorgesse.

---

## 2️⃣ La corsa vera

```powershell
$p="$env:USERPROFILE\lancia_r118.ps1"; Remove-Item $p -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/lavoro/backtest_pipeline/lancia_r118.ps1" -OutFile $p -ErrorAction Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'ROUND 118' -Quiet)){ throw 'SCRIPT VECCHIO O SCARICATO MALE' }; & powershell -ExecutionPolicy Bypass -File $p -Rif lavoro
```

L'ordine e' **fisso e voluto**: `c` (20 passate, la piu' corta ed e' il
**cancello**) → `a` (50) → `b` (100, la piu' cara, per ultima).

**Si puo' spezzare**, e con una corsa lunga conviene:
```powershell
… -File $p -Rif lavoro -SoloC      # solo il cancello, 20 passate
… -File $p -Rif lavoro -SoloA      # solo l'ORB, 50 passate
… -File $p -Rif lavoro -SoloB      # solo il DAX a STOP, 100 passate
```

### 📦 La raccolta e' dentro lo script (regola delle righe di lancio, punto 2)
A fine corsa: cartella **`Desktop\r118`** + **`Desktop\r118.zip`**, con
**l'elenco dei file attesi controllato uno per uno** in console.

**I 6 CSV attesi:**
```
ABTG_DAX_Apertura_EU_D30EUR_IS_r118c.csv    ABTG_DAX_Apertura_EU_D30EUR_OOS_r118c.csv
ABTG_ORB_Ottimizzato_U30USD_IS_r118a.csv    ABTG_ORB_Ottimizzato_U30USD_OOS_r118a.csv
ABTG_DAX_Apertura_EU_D30EUR_IS_r118b.csv    ABTG_DAX_Apertura_EU_D30EUR_OOS_r118b.csv
```
Nello zip vanno anche i **tre file prova e il file dei criteri**: il pacchetto
si legge da solo, senza il repo davanti.

---

## ⚓ LE ANCORE — si controllano **PRIMA** di leggere qualunque altra riga

| corsa | cella | deve dare | fonte |
|---|---|---|---|
| **c** | `InpMinStopPts=0` | **IS** 282,12 / PF 1,07810 / DD 7,0257 / n **197** · **OOS** 999,42 / PF 1,18776 / DD 10,5984 / n **311** | R83 cella V (18/08) — ed e' il **DD del contratto** della 770101 |
| **a** | buffer 0, slippage 0 | **OOS** 41.057,00 / PF 1,67419 / DD 9,7623 / n **119** | R54b · R55 · R88, identici a quattro decimali |
| **a** | buffer 500 e 1000, slippage 0 | 29.295,20 / 1,51284 / 9,5573 · 28.466,13 / 1,55394 / 8,0454 | R88 (`r88_csv`) |
| **b** | pavimento 0, slippage 0 | ≈ R83 D0: OOS 251,22 / 1,04089 / 13,2624 / 325 | ⚠️ **ATTESO, NON garantito**: D0 e' girata sul **fork**, e l'equivalenza fork↔vivo non e' mai stata verificata su D0 del DAX |

> 🛑 **Se le ancore di `c` o di `a` non tornano, i numeri del round NON si
> leggono.** Non si spiega dopo: si cerca cosa e' cambiato (EA riscaricato dalla
> punta, cache del tester, dati) e si ferma tutto.

E i **gemelli gratis**, da verificare a risultati usciti:
- `c`: le 2 celle a pavimento 0 devono essere **identiche al centesimo**;
- `b`: le 5 coppie a pavimento 0 (una per gradino di slippage), **identiche**;
- `a`: **n deve restare 71 (IS) e 119 (OOS) in tutte e 25 le celle** — ne' il
  buffer ne' lo slippage toccano gli ingressi di quell'EA.

---

## 🧨 COSA PUO' ROMPERSI — trovato leggendo, non sperato

| # | rischio | cosa succede | contromisura gia' dentro |
|---|---|---|---|
| 1 | l'`irm` fallisce e il `;` tira dritto | girerebbe una **copia vecchia** nel profilo (il bug `maxmin_oro.ps1` del 10/08) | `Remove-Item` + `-ErrorAction Stop` + marcatore `ROUND 118` |
| 2 | cache di `raw.githubusercontent` (~5 min) | file **vecchio** scaricato senza errori | il marcatore, e i marcatori **dentro ciascuno dei 5 file** che lo script riscarica (fra cui le righe di sweep esatte) |
| 3 | MT5 aperto | **zero CSV** dopo ore | guardia `Get-Process terminal64` (e `metaeditor64`) |
| 4 | MT5 ricorda i **flag di griglia** dell'ultima corsa | rispazzola una griglia vecchia nonostante i pin | il driver scrive **tutti** i pin in forma completa `v||v||0||v||N` (difetto pt6c del 09/08) |
| 5 | `InpSkipIfTight` e' un `bool` | forma `false\|\|…\|\|true` **mai provata** in casa | scritto **`0\|\|0\|\|1\|\|1\|\|Y`**, la forma che il driver produce da solo per i bool e con cui sono girati tutti i round |
| 6 | l'EA arriva dalla **punta** di `lavoro`, non dal pin | numeri diversi senza spiegazione | **le ancore**: e' esattamente il caso che prendono |
| 7 | il round e' lungo e qualcuno lo interrompe | CSV parziali | le tre corse sono **separate** (`-SoloA/-SoloB/-SoloC`) e la raccolta elenca cosa manca |

---

## 🕳️ COSA QUESTA CORSA **NON** DIRA' (versione corta — quella completa e' §10 dei criteri)

1. **Non dice quanto slippage c'e' davvero**: `ABTG_SlippageLogger` sul conto
   reale ha **0 deal**. Tutti i gradini sono **SCENARI ASSUNTI**.
2. **Non simula requote, rifiuti, riempimento parziale, book, no-fill del
   limit.** MT5 non li modella.
3. **Non copre il ramo C sull'ORB**: il codice non ce l'ha, e **il codice non
   si tocca**.
4. **Non copre lo slippage sulla cella VIVA del DAX** (e' un LIMIT): la corsa
   `c` **sottostima** il valore del pavimento, e il verso del bias e'
   dichiarato.
5. **Non promuove niente, non spegne niente, non cambia niente in forward.**
   Da qui esce una **raccomandazione**, e decide Claudio.

---

*Riga preparata, non eseguita. MT5 sta sul PC di Claudio.*
