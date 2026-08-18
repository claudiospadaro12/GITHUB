# 🧾 REFERTO R81 — PREPARAZIONE: "PROCESSO ALLE USCITE", capitolo `MaxMin DAX Short`

**18/08/2026. Questo referto NON contiene risultati: contiene la PREPARAZIONE
del round e la riga di lancio.** I numeri arriveranno dal PC di backtest di
Claudio, e si leggeranno **dopo** i criteri, che sono congelati in
`backtest_pipeline/prove/R81_USCITE_CRITERI.md`.

---

## 1. 🎯 La domanda, e da dove nasce

> **A PARITA' DI INGRESSI, la gestione attuale della sedia viva estrae piu'
> valore delle alternative?**

Nasce da un trade vero del 18/08: `MAXMIN DAX SHORT` (magic **770411**, copia
100k a rischio 0,65%) ha chiuso **+324,48 EUR** e **il trailing ha incassato
prima di un rimbalzo che avrebbe riportato il prezzo sopra l'ingresso**.

⚠️ **Quel trade e' un ANEDDOTO** — riportato da Claudio in chat, non presente in
nessun referto — ed entra qui solo come **motivo di aprire il round**. Il round
si chiude coi numeri.

🔒 **Nessun tocco al forward, in nessun caso.** Se una variante vince, fa la
trafila della candidata (firma → eventuale duello su magic nuovo).

## 2. ✅ Le sei varianti sono TUTTE realizzabili con gli input esistenti — due con un accorgimento dichiarato

**Nessuna modifica all'EA in questo round.** `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5`
resta la v1.10 esattamente com'e'.

| | variante | realizzabile? | come |
|---|---|---|---|
| **A** | sedia viva (baseline esatta) | ✅ | tutti i default del sorgente |
| **B** | lasciar correre puro | ✅ | `TP1Pct=0` `Breakeven=0` `TP2Pct=0` `EMA200=0` `Trailing=0` `TPfinal_R=4.0` |
| **C** | solo breakeven, poi correre | ✅ **con accorgimento** | `TP1Pct=1` → **parziale simbolica dell'1%** (vedi §3) |
| **D** | gestione A con trailing 3,5 ATR | ✅ | `TrailAtrMult=3.5`, una variabile sola |
| **E** | gestione A con trailing 1,0 ATR | ✅ | `TrailAtrMult=1.0`, una variabile sola |
| **F** | TP secco 2R | ✅ **con correzione della ricetta** | `TPfinal_R=2.0` invece di `TP1_R=2.0/TP1Pct=100` (vedi §4) |

## 3. 🔓 IL NODO DEL BREAKEVEN — sciolto, con la riga di codice che lo prova

Il commento dell'input (`// Stop in pari dopo la 1a parziale`) **dice la
verita'**: lo stop in pari sta **dentro** il blocco della prima parziale, e il
blocco e' chiuso da questa condizione — `ManagePos`, **riga 295**:

```mql5
if(!gPart1 && InpTP1_R>0 && InpTP1Pct>0 && InpTP1Pct<100 && risk>0)
```

➡️ **Con `InpTP1Pct = 0` non gira niente: niente parziale E NIENTE BREAKEVEN.**
Quindi **"breakeven puro senza parziale" NON e' realizzabile** con gli input
esistenti, e in questo round **il codice non si tocca**.

**Come si realizza C: `InpTP1Pct = 1`** — parziale **simbolica dell'1%**,
dichiarata. Perche' funziona (righe 301-314):

```mql5
double cv=NormVol(vol*InpTP1Pct/100.0);
bool parzOK = (cv>0 && cv<vol && gTrade.PositionClosePartial(ticket,cv));
if(parzOK) gPart1=true;
...
bool beFatto = (InpBreakeven && (...lo stop in pari migliora lo stop...));
if(beFatto) gTrade.PositionModify(ticket,bePari,tp);
```

- il breakeven **non dipende** dalla riuscita della parziale (correzione del
  07/08, `report/BUG_BREAKEVEN_lotto_minimo.md`): scatta comunque;
- la contaminazione e' **circa l'1% del lotto** chiuso a 1R, e va **a favore**
  di C: se C perde lo stesso contro A, il verdetto regge a maggior ragione;
- 🔴 `InpTP2Pct = 0` in C e' **obbligatorio**: se la parziale dell'1% va a
  segno, `gPart1` diventa `true` e sbloccherebbe la seconda parziale (riga 321);
- **come si legge cos'e' successo davvero**: nella serie per-trade, 2 chiusure
  per posizione = parziale avvenuta; 1 sola = breakeven puro (a lotto piccolo
  `NormVol` arrotonda l'1% a zero). A 100k il lotto e' ben sopra il minimo.

## 4. 🔓 IL NODO DEL TP SECCO — la ricetta originale era irrealizzabile

`InpTP1_R=2.0` + `InpTP1Pct=100` **non funziona**: la stessa riga 295 pretende
`InpTP1Pct < 100`, quindi a 100 il blocco e' **spento** e il TP a 2R **non
esisterebbe** — si misurerebbe la variante B una seconda volta.

**F si fa con `InpTPfinal_R = 2.0`**, il TP piazzato **sull'ordine** (righe
249-251, lato short):

```mql5
double dist = sl - sellPx;                          // = 1R esatta
double tp   = NormalizePrice(sellPx - dist*InpTPfinal_R);
```

Con tutto il resto spento, F esce **solo** per TP 2R, stop iniziale o flat delle
17:30. E' il TP secco **vero**.

## 5. 📚 I file congelati (prima dei numeri)

| file | cos'e' |
|---|---|
| `backtest_pipeline/prove/R81_USCITE_CRITERI.md` | domanda, tabella input per input, metro di giudizio, clausola di segno, limiti dichiarati |
| `backtest_pipeline/prove/R81a_uscita_A_viva.txt` | A — sedia viva (baseline) |
| `backtest_pipeline/prove/R81b_uscita_B_correre.txt` | B — lasciar correre puro |
| `backtest_pipeline/prove/R81c_uscita_C_breakeven.txt` | C — solo breakeven |
| `backtest_pipeline/prove/R81d_uscita_D_trail35.txt` | D — trailing 3,5 ATR |
| `backtest_pipeline/prove/R81e_uscita_E_trail10.txt` | E — trailing 1,0 ATR |
| `backtest_pipeline/prove/R81f_uscita_F_tp2r.txt` | F — TP secco 2R |
| `backtest_pipeline/lancia_r81.ps1` | il driver (ASCII puro, nessun parse numerico, marcatore di versione, guardia MT5, raccolta+zip) |

**Fonte dei valori pinnati** (dichiarata anche dentro ogni file prova):
1. **default del sorgente** `.mq5` v1.10 (i valori "OTT" commentati nel file);
2. **censimento `.chr` del 18/08 09:41** (`censimento_rischio_2026-08-18_0941.txt`,
   righe 27 e 48-49) per `InpRiskPercent`: **1,0** sul conto principale,
   **0,65** sulle copie del dry-run 100k. **Il round gira a 1,0**, che e' anche
   il rischio del contratto (`report/CONTRATTI_SEDIE.md`: DD promesso **1,27%**);
3. **`FLOTTA_ATTIVA.md` riga 39** per il grafico: **D30EUR M15** → `@PERIODO M15`;
4. il censimento `.chr` registra **solo il rischio**: per tutto il resto la
   fonte e' il **sorgente**, e nessun valore e' stato scelto qui.

## 6. ⚙️ Come gira (parametri della corsa)

| voce | valore | perche' |
|---|---|---|
| simbolo / grafico | `D30EUR` / **M15** | come la sedia viva |
| `@DAQUANDO` | **2024.09.26** | **misurato**: e' il tetto dello storico indici a BCM, gia' congelato in `prove/R2_MaxMinNotte_DAX_Short.txt` |
| `-Fino` | **2026.06.30** (default di casa) | e' la data dei CSV `_ptb`/R16 con cui si fa il controllo d'igiene |
| finestre | IS 40% / OOS 60% | **non si sceglie niente sull'IS**: ogni variante e' UNA cella. Le due finestre valgono come **due sotto-periodi** |
| modello | **4 = tick reali** | il modello di VALIDAZIONE della pipeline. Un OHLC non e' mai un verdetto |
| deposito | **100.000** | e' la taglia della copia viva sul dry-run, ed **e' necessario**: a lotto schiacciato sul minimo le parziali non partono, e questo round misura proprio le parziali |
| passate | **6 × 2 finestre × 2 magic = 24** | il doppio magic e' l'unico asse inerte: due passate che **devono** uscire identiche |
| magic | **778110-778161** (nuovi) | niente cache del tester, serie per-trade separate, **nessun magic vivo toccato** |

## 7. 🚨 I limiti, dichiarati PRIMA

- 🔢 **Il campione e' sottile**: ~20 "trades" per finestra, e su questo EA il
  tester **conta le chiusure parziali** → le **posizioni** sono circa la meta'.
  L'emendamento della finestra chiede **>= 150 operazioni**: siamo un ordine di
  grandezza sotto. **Il round PROPONE, non promuove** (regola B: il rischio si
  giudica lo stesso, il merito no).
- 🌍 **La lettura per regime NON e' possibile**: le finestre di casa (ORSO 2022,
  CROLLO 2020, CROLLO_ANNO 2020, TORO 2021, LATERALE 2019) sono **tutte prima
  del 2024.09.26**, cioe' prima dell'inizio dei dati D30EUR a BCM. **Non verra'
  inventato nessun numero.** Il surrogato — le due sotto-finestre IS/OOS — sono
  **due pezzi dello stesso regime**, e va detto nel referto finale.
- 🧪 **Un broker solo** (BCM), **un simbolo solo**, costi di quel feed.
- 📄 **L'EA lo scarica `walkforward_generico.ps1` dal branch `lavoro` HEAD**
  (riga 78-79: `$EABranch="lavoro"` e' cablato dentro il driver generico, e non
  segue il `-Rif`). Non e' un problema in questo round — **l'EA non viene
  modificato** — ma va saputo: la v1.10 deve restare intatta fino a corsa
  finita.

## 8. 🧪 IL CONTROLLO D'IGIENE (si guarda per primo)

La variante **A** e' la sedia viva a parametri identici, stesso driver, stesse
date, stesso deposito dei CSV `_ptb` gia' agli atti:

| finestra | profitto | PF | Equity DD % | trades |
|---|---:|---:|---:|---:|
| IS | **+4.766,96** | 1,87803 | 3,0977 | 20 |
| OOS | **+6.143,38** | 2,15985 | 1,9213 | 21 |

🔴 **Se A non li riproduce, il round non si legge.** Il driver stampa la
tabella a fine corsa e ricorda questa riga da solo.

Secondo controllo, gratis: **B e F devono avere lo STESSO numero di posizioni**
(nessuna delle due parzializza). Se differiscono, gli ingressi non sono
identici e il round e' invalido.

---

# 9. 🚀 LA RIGA DI LANCIO (pinnata a `f2f9030`)

> ⚠️ **PC DI BACKTEST, MT5 CHIUSO.** Una macchina, un lavoro: se sul PC sta
> girando un altro round, si aspetta che finisca. Lo script si rifiuta di
> partire se trova `terminal64` aperto.

### 9.1 PRIMA il giro a vuoto (obbligatorio, ~1 minuto, NON apre MT5)

```powershell
$p="$env:USERPROFILE\lancia_r81.ps1"; Remove-Item $p -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/f2f9030/backtest_pipeline/lancia_r81.ps1" -OutFile $p -ErrorAction Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R81-PROCESSO-ALLE-USCITE' -Quiet)){ throw 'SCRIPT VECCHIO O SCARICATO MALE' }; $global:LASTEXITCODE=0; powershell -ExecutionPolicy Bypass -File $p -Rif f2f9030 -SoloControllo; if($LASTEXITCODE -ne 0){ throw 'GIRO A VUOTO FALLITO: leggi le righe rosse sopra' }
```

**Cosa fa:** scarica il driver pinnato all'hash, verifica il marcatore, scarica
i 6 file prova + i criteri, e per ogni variante stampa **le celle che
spazzolerebbe** e **il BLOCCO USCITE che finirebbe in `[TesterInputs]`**.
**Cosa deve dire, variante per variante:**

```
    spazzolati                  : 1
        InpMagic                   2 celle
    celle per finestra          : 2   ->  4 pass a tick reali in tutto
```

e poi le 11 righe del blocco uscite, da confrontare con la tabella del §3 dei
criteri. **Se anche una sola non coincide, ci si ferma li'.**

### 9.2 POI la corsa vera (24 passate a tick reali)

```powershell
$p="$env:USERPROFILE\lancia_r81.ps1"; Remove-Item $p -ErrorAction SilentlyContinue; irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/f2f9030/backtest_pipeline/lancia_r81.ps1" -OutFile $p -ErrorAction Stop; if(-not (Select-String -Path $p -SimpleMatch -Pattern 'R81-PROCESSO-ALLE-USCITE' -Quiet)){ throw 'SCRIPT VECCHIO O SCARICATO MALE' }; $global:LASTEXITCODE=0; powershell -ExecutionPolicy Bypass -File $p -Rif f2f9030; if($LASTEXITCODE -ne 0){ throw 'R81 FALLITO O INCOMPLETO: leggi le righe rosse sopra' }; $d=Join-Path ([Environment]::GetFolderPath("Desktop")) "R81_USCITE"; Get-ChildItem $d | Select-Object Name,Length | Format-Table -AutoSize; Write-Host ("ZIP DA MANDARE: " + (Join-Path (Split-Path $d) "R81_USCITE.zip")) -ForegroundColor Cyan
```

**Cosa fa, in ordine:**
1. riscarica il driver pinnato a `f2f9030` (cancellando prima la copia vecchia,
   con `-ErrorAction Stop` sull'`irm` e controllo del marcatore: se il download
   fallisce **la riga muore li'**, non gira la copia vecchia);
2. si rifiuta di partire se MT5 e' aperto;
3. scarica walkforward + i 6 file prova + i criteri **dallo stesso hash**;
4. lancia **A → B → C → D → E → F**, tick reali, deposito 100k, e dopo ogni
   variante raccoglie la **serie per-trade** (magic nuovi = niente cache);
5. copia tutto in **`Desktop\R81_USCITE\`**, stampa **l'elenco dei file attesi
   uno per uno**, stampa la **tabella di lettura**, scrive
   `REFERTO_RACCOLTA_R81.txt` (con dentro una riga **`data:` che deve essere di
   ADESSO**) e crea **`Desktop\R81_USCITE.zip`**;
6. la coda della riga rielenca il contenuto della cartella e stampa il percorso
   dello zip.

**Durata: STIMA, non misura — 1-3 ore.** 24 passate a tick reali su D30EUR,
21 mesi di storico. Il driver stampa l'avanzamento variante per variante; si
puo' interrompere e rilanciare la stessa riga (i CSV gia' fatti non si rifanno).

**File attesi nello zip (12 CSV + contorno):**

```
ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_IS_r81a.csv    (e _OOS_r81a)
ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_IS_r81b.csv    (e _OOS_r81b)
ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_IS_r81c.csv    (e _OOS_r81c)
ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_IS_r81d.csv    (e _OOS_r81d)
ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_IS_r81e.csv    (e _OOS_r81e)
ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_IS_r81f.csv    (e _OOS_r81f)
pertrade_r81a_778110.csv ... pertrade_r81f_778161.csv   (fino a 12, SOLO finestra OOS)
R81_USCITE_CRITERI.md + i 6 file prova + REFERTO_RACCOLTA_R81.txt
```

⚠️ **Le serie per-trade sono della SOLA finestra OOS**: l'EA scrive il file col
proprio magic, e la corsa OOS sovrascrive quella IS. E' voluto e dichiarato —
servono per il **test della singola operazione** (§6 dei criteri), che si fa
sull'OOS.

### 9.3 Se serve rilanciare una sola variante

```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\lancia_r81.ps1" -Rif f2f9030 -Solo D
```

---

## 10. ✅ La checklist della riga di lancio, eseguita (non promessa)

| # | controllo | esito |
|---|---|---|
| 1 | **Ho aperto lo script a cui punto** | ✅ letti `walkforward_generico.ps1` (696 righe) e l'EA (605 righe) riga per riga; da li' vengono i due nodi del §3-4 |
| 2 | **Difetti gemelli** | ✅ cercati `Desktop` e `fermoDa -ge`: nessuna euristica del silenzio in `lancia_r81.ps1`; la raccolta sul Desktop c'e' |
| 3 | **Il file dei parametri e' quello giusto: CERCA o VERIFICA?** | ✅ **VERIFICA**: sei celle congelate, un solo asse inerte (il magic). Nessuna griglia da cui scegliere |
| 4 | **Il SHA contiene la correzione che annuncio** | ✅ `f2f9030` e' il commit che introduce tutti e 8 i file. Verificato con `git log --oneline -1 -- <file>` |
| 5 | **Giro a vuoto prima** | ✅ e' il §9.1, ed e' **obbligatorio**: senza, la riga vera non va mandata |
| 6 | **Cache di raw ~5 minuti** | ✅ la riga punta **all'hash**, non al branch, e controlla un **marcatore** (`R81-PROCESSO-ALLE-USCITE`) |
| 7 | **Script che scrivono nei file di MT5** | ✅ questo **non** scrive in `MetaQuotes\Terminal` (tranne la copia dell'EA in `MQL5\Experts`, che fa il driver generico da sempre); pretende comunque **MT5 chiuso** |
| 8 | **`irm` che fallisce e la riga tira dritto** | ✅ tutti e tre i pezzi: `Remove-Item` + `-ErrorAction Stop` + marcatore |
| 9 | **Sicurezza del gemello** | ✅ ripreso da `lancia_r55.ps1` (guardia MT5, `-SoloControllo`, elenco file attesi, zip) **e migliorato**: marcatore di versione, `$LASTEXITCODE` azzerato prima, referto con `data:`, rinomina delle anteprime |
| 10 | **`$ErrorActionPreference=Stop` + ciclo su file** | ✅ le copie e le cancellazioni sono in `try/catch`, il ciclo prosegue e il referto si scrive **sempre** |
| 11 | **`exit 1` dello script chiamato** | ✅ `$global:LASTEXITCODE=0` **prima**, e il controllo e' `-ne 0` (non `-eq 0`) |
| 12 | **Backup senza guardia** | n/a: questo script non sovrascrive niente di Claudio |
| 13 | **Emoji nei `.ps1`** | ✅ **ASCII puro verificato** (0 caratteri non-ASCII) e `lint_ps1.py` passato |
| 14 | **InvariantCulture** | ✅ **non c'e' nessun parse numerico**: la tabella stampa i campi CSV **come stringhe**, esattamente come li scrive MT5. Il problema non esiste per costruzione |

---

## 11. 🧭 Cosa succede dopo

1. Claudio esegue **§9.1** e incolla l'output (o dice "torna").
2. Claudio esegue **§9.2** e manda `R81_USCITE.zip`.
3. Si legge **prima il controllo d'igiene** (A = `_ptb`), **poi** la tabella, e
   si scrive `REFERTO_R81_USCITE.md` con il verdetto secondo i criteri gia'
   congelati — compreso il **test della singola operazione** e la
   dichiarazione del **campione sottile**.
4. 🛑 **Qualunque sia il risultato, oggi il forward non si tocca.**
