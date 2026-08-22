# 🚀 R97 — LA RIGA DA MANDARE (ORB stop-largo su NASUSD)

_Scritta il 22/08/2026. **NON è ancora passata dal verificatore**: prima del
verdetto di verifica questa riga non va a Claudio._

Criteri: `backtest_pipeline/risultati_archivio/R97_CRITERI.md` — **FIRMATI il
21/08/2026** ("FIRMIAMO R97, POI ANALIZZIAMO QUESTI EA BENE"), a numeri mai
visti. Questa riga **non cambia i criteri**: li traduce in file eseguibili.

---

## ⛔ PRIMA DI LANCIARE — traffico e prerequisiti

- **UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**: prima di
  lanciare, dichiarare che non c'è nessun altro round in corso.
- **MT5 E METAEDITOR CHIUSI.** Lo script si rifiuta di partire se li trova
  aperti (col terminale aperto il tester non gira → zero CSV; con MetaEditor
  aperto `metaeditor64 /compile` torna subito senza compilare).
- **Lo script tocca il terminale di backtest**: ci copia
  `ABTG_ORB_Ottimizzato.mq5` (v1.02) e `ABTG_PausaGuardian.mqh`, **ricompila**
  l'`.ex5` e svuota `Tester\cache`. Fa il **backup datato** di `.mq5` e `.ex5`
  prima di toccarli e, se la compilazione fallisce, **rimette a posto il
  sorgente** (checklist 54). Non tocca `bases\<server>\ticks`.
- **Non tocca nessuna sedia viva**: usa magic vergini `7797xx` e cancella i
  per-trade **solo dei propri magic, per nome**. In particolare **non tocca il
  magic 770611**, che è *questo stesso EA* vivo sul Dow.
- Durata stimata: **1–2 ore** (16 passate a tick reali; riferimento R88: 27
  file in 2h16). Il PASSO 0 misura una passata intera e stampa la stima.

---

## 1️⃣ PRIMA il giro a vuoto (dieci secondi, nessuna passata)

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R97.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R97_ORB_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R97_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo; if($LASTEXITCODE -ne 0){ Write-Host 'CONTROLLO NON PASSATO: leggi il REFERTO' -ForegroundColor Yellow } }
```

**Cosa deve dire** (altrimenti la corsa vera non parte):
- `anteprime .ini in sosta: 4 su 4`;
- dentro ogni anteprima, `[TesterInputs]` con **2 celle** (le due passate
  gemelle sul magic) e `FromDate/ToDate` = le finestre IS/OOS calcolate dal
  driver — **quelle vanno copiate nel referto**, non riscritte a memoria;
- `ESITO: GIRO A VUOTO COMPLETATO`.
- ⚠️ **Il giro a vuoto NON misura la conversione dei punti** (serve il tester
  vero). Il suo zip **non è il round**.

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='<PIN>'; $p="$env:USERPROFILE\RIGA_R97.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R97_ORB_NASUSD.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R97_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin; if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**, è un comando solo (checklist 21): tre righe
staccate sarebbero tre comandi indipendenti e un `throw` alla prima non
fermerebbe le altre.

---

## 🛑 IL PASSO 0 È UN GATE, E PUÒ FERMARE TUTTO — è previsto

Il par. 3 dei criteri (coperto dalla firma, punto **c**) dice: *"prima di
lanciare una sola passata si misura quanti PUNTI MT5 valgono 1 punto indice su
NASUSD"*. Lo script lo fa così, **senza artefatti nuovi**:

| | come |
|---|---|
| **misura 1 (il gate)** | due passate singole gemelle derivate dal file prova `R97-rif`, con `InpSLMode=2` (FIXED) e `InpVerbose=1`. In FIXED il sorgente fa `sl = entry - InpSLFixedPts*_Point` — **la stessa moltiplicazione che fa il buffer** di R97b/c. Dalla riga di log `BUY STOP @ X SL Y` esce `_Point = (X−Y)/1000`, quindi il fattore. |
| **misura 2 (controllo)** | i decimali della colonna `price` del per-trade, che l'EA scrive con `DoubleToString(price,_Digits)` → `10^digits`. |

Le due devono dire lo **stesso** numero.

- **Non misurabile** (zero log, zero ordini, misure discordi) → **la corsa non
  parte**. Un gate che non legge niente non è un gate verde.
- **Misurato ma diverso da 100** → **la corsa non parte lo stesso**, e non è un
  guasto: è la risposta. I file prova scrivono `InpSLBufferPts=500` perché su
  U30USD 100 punti = 1 punto indice, cioè **5 punti indice** (la cella regina di
  R88). Con un altro fattore quel 500 sarebbe un'altra cella — è l'errore di
  fattore dieci già pagato in R88. Il referto scrive il numero misurato **e** il
  valore corretto da usare; **lo script non riscrive da solo una cella firmata**:
  si rigenerano i file prova, si ri-pinna e si rifà un giro dal verificatore.
- Anche quando il gate ferma tutto, **la raccolta si fa lo stesso**: lo zip
  contiene il numero misurato, i due per-trade del gate e i due `.ini`.

---

## 📦 FILE ATTESI DI RITORNO

Sul Desktop: cartella e zip `R97_ORB_NASUSD_<MODO>_<data>_<ora>` (`MODO` =
`CORSA` / `CONTROLLO` / `SENZAPASSO0`). **È lo zip che si manda.**

Dentro lo zip, corsa completa:

| file | quanti | nota |
|---|---|---|
| `REFERTO_R97.txt` | 1 | la riga `data:` dev'essere di **adesso**; la riga `modo:` dice se è il round o un giro a vuoto; in testa c'è **la conversione misurata** |
| `ABTG_ORB_Ottimizzato_NASUSD_IS_r97rif.csv` (+ `_OOS_`) | 2 | 2 righe l'uno (le due passate gemelle) |
| `..._r97a.csv` IS/OOS | 2 | idem |
| `..._r97b.csv` IS/OOS | 2 | idem |
| `..._r97c.csv` IS/OOS | 2 | idem |
| `passo0_pertrade_779700.csv` / `..._779701.csv` | 2 | i gemelli del gate: devono essere identici |
| `passo0_a.ini` / `passo0_b.ini` | 2 | la prova cartacea di cosa ha girato nel gate |
| `abtg_trades_ABTG_ORB_Ottimizzato_NASUSD_7797xx.csv` | fino a 8 | i per-trade delle celle |
| `compile_r97.log` | 0 o 1 | c'è se MetaEditor ha scritto un log |

**Totale CSV di round attesi: 8** (4 file × IS/OOS), **2 righe ciascuno**,
**16 passate**. Con `-ConD` diventano 10 CSV e 20 passate.

Se un file manca, si vede **prima** di mandare lo zip: l'elenco lo stampa anche
la console a fine corsa.

---

## 🔎 COME SI LEGGE, IN ORDINE (è scritto anche dentro il referto)

1. **la conversione**: senza quel numero nessuna riga sul buffer vuol dire
   niente;
2. **il PASSO 0**: se è rosso, i numeri sotto non esistono;
3. **`R97-rif` per prima e da sola**: è la geometria della sedia viva sul Dow
   trasferita qui, e il suo **DD OOS fissa la soglia della bocciatura secca
   (2×)** — si scrive **prima** di guardare a/b/c;
4. i quattro cancelli **S1–S4** (DD OOS ≤ 7,00% · PF OOS ≥ 1,40 · IS profit > 0
   e PF IS ≥ 1,10 · n OOS ≥ 95 e n IS ≥ 57);
5. **il canarino del par. 2.1**: n IS sotto ~100 → **MERITO SOSPESO**, si legge
   il RISCHIO (Emendamento regola B, applicata **dall'inizio** come prevede la
   firma). Il **n va scritto accanto a ogni numero**;
6. **b e c insieme**: se dicono cose opposte, quello di b è un **punto singolo**
   e non un altopiano — e un punto singolo non si promuove;
7. **regime: uno solo** (indici USA 2024-2026, prevalentemente rialzista);
8. **R97 non produce sedie**: al massimo una **proposta** di round di deploy.

---

## 🧾 LE SCELTE FATTE, DICHIARATE (e cosa resta DA CONFERMARE)

**Prese dai criteri, senza margine:** simbolo `NASUSD`, TF `M5`, finestra
`@DAQUANDO 2024.09.26 → 2026.06.30`, split 40/60, deposito **100.000**, le 4
celle del par. 4, i cancelli del par. 5, il gate del par. 3, R97d **esclusa**.

**Scelte di traduzione, motivate qui perché i criteri non le scrivono:**

| scelta | valore | perché |
|---|---|---|
| **Model** | **4 = tick reali** | i criteri non lo scrivono a chiare lettere (il par. 0 dice *"scan OHLC quando possibile, tick reali per il verdetto"*), ma R97 confronta **numero contro numero con R88**, che è a tick reali, e sono solo 16 passate. Uno scan OHLC non sarebbe confrontabile. **[DA CONFERMARE CON CLAUDIO se preferisce prima uno scan OHLC]** — cambiare significa cambiare `-Modello` e rifare tutto: meglio deciderlo ora. |
| corpo delle celle | identico a `R88a_stoplargo_U30USD.txt`, solo `@SIMBOLO` cambiato | è la condizione perché R97 misuri **trasferibilità del meccanismo** e non un'altra strategia. Include `InpAllowShort=0` e il filtro EMA200: **ereditati dalla sedia viva del Dow, non assi di questo round.** |
| una griglia di 2 celle per file (magic gemelli) | `InpMagic=7797x0..7797x1` | il driver generico **rifiuta** un file prova senza almeno un asse `Y` (sarebbe un backtest singolo). L'asse gemello costa il doppio delle passate e in cambio dà il canarino del banco pulito, come in R96. |
| `InpSLFixedPts=1000` pinnato in tutti i file | inerte in OPPRANGE/HALFRANGE | serve al **gate della conversione**, che lo legge **dall'artefatto che gira** invece che da una costante nello script. |
| magic | `779700/01` gate · `779710..779751` celle | blocco vergine. Vietati e controllati: **770611** (questo EA, vivo sul Dow), 770601, 770201. |
| spread | `Spread=0` nell'`.ini` | = spread **corrente**, ma **dichiarato** invece che lasciato allo stato nascosto del terminale. Non è uno stress. |
| tick | **non riscaricati** | già misurati e agli atti: NASUSD **164.636.788 dal 2024.09.26** (`REFERTO_R83_R84_PREPARAZIONE.md` riga 620). Si scaricano solo le barre M1+M5. |
| `-ConD` | **spento** | R97d non è firmata. Se acceso, il referto e la console lo scrivono in rosso. |
| `-SaltaPasso0` | esiste, sconsigliato | serve solo a riprendere una coda già gatata. Se usato, il referto dichiara che **la conversione non è stata misurata in quella corsa** e che quei numeri sui buffer non si leggono da soli. |

**Nessun dettaglio è stato inventato**: dove i criteri tacevano (Model) la scelta
è dichiarata qui sopra con la sua ragione e marcata da confermare.

---

## 🔁 SE SERVE RILANCIARE UNA CELLA SOLA

`walkforward_generico.ps1` **salta le finestre il cui CSV esiste già**: un
rilancio senza `-Rifai` non rifà niente e stampa tutto verde (checklist 15).
Per rifare davvero: aggiungere **`-Rifai`**. Lo script marca comunque i file
ripresi come `SALTATO DAL DRIVER` / `A META'` e li mette nei **PROBLEMI**, non
in OK.
