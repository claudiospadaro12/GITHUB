# 📬 R100 — LE DUE RIGHE DA MANDARE A CLAUDIO

**Round**: R100 — **la misura del RISCHIO di TUTTA la flotta ORO su 22 anni**
(`XAUUSD`, `2004.06.11 → 2026.06.30`, modello **OHLC M1**).
**Criteri**: `backtest_pipeline/risultati_archivio/R100_CRITERI.md` — sono i
criteri **firmati di R99** (23/08, _"FIRMO R99, PARTIAMO CON L'ORO"_), estesi
**INVARIATI** sedia per sedia. **L'ordine di Claudio del 23/08 — _"FAI PARTIRE
R99 SULLE ALTRE SEDIE ORO"_ — è la firma dell'estensione**, verbalizzata al
§0 dei criteri.
**Driver**: `backtest_pipeline/righe/RIGA_R100_ORO_FLOTTA.ps1`
(marcatore `MARCATORE_RIGA_R100_v1`).

## 📌 IL PIN

```
9fbe18dec0e0fcd0441a99571f376c5b07d72fdb
```

È il commit che contiene **il driver, i 12 file prova e i criteri**. Le righe
qui sotto lo passano a `-Pin` e **rifiutano di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** Col terminale aperto il tester non
  gira ed escono zero risultati; con MetaEditor aperto la compilazione torna
  subito **senza compilare**. La riga si rifiuta di partire in tutti e due i
  casi.
- **Il round COMPILA 12 SEDIE VIVE** sul terminale collegato al conto vero. Per
  ognuna il `.mq5` **e** il `.ex5` vanno in un **backup datato**
  (`.prima_r100_<stamp>`) prima di essere toccati, e **se la compilazione
  fallisce il `.mq5` viene rimesso com'era**: sorgente e binario restano sempre
  la stessa versione.
- **Nessuna sedia viva viene toccata nei test.** Si gira su magic **vergini**
  del blocco `78xxxx` (verificato: **zero occorrenze in tutto il repo**). Sono
  **vietati e controllati nel codice** tutti i magic vivi dell'oro, i `7799xx`
  di R99 e la collisione `770901`.
- **Niente tick, e non si tocca `bases\<server>\ticks`.** Il modello è
  **OHLC M1** per criterio: i tick reali di BCM partono dal **2024.07.05**, su
  22 anni **non esistono**. 👉 **Ogni numero che esce è un LIMITE INFERIORE del
  rischio, mai un permesso.**
- **Durata**: **[STIMA] 2–6 ore**. R99 ha fatto **una** sedia in pochi minuti;
  qui sono **12**, e le barre M1 si scaricano **una volta sola** all'inizio
  (stesso simbolo per tutte). `-OreMax` è **20** ed è un tetto sull'**inizio**
  di nuovi lavori, non un'interruzione.
- **Le sedie si fanno UNA ALLA VOLTA** e la **ripresa è attiva**: se la corsa
  si interrompe, si rilancia la stessa riga e i CSV già presenti vengono
  **saltati e dichiarati** (con la data del file nel referto).

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, nessuna passata di test)

> ⚠️ **Non è a costo zero sul terminale**: il giro a vuoto scarica gli
> artefatti al pin (12 file prova, 12 `.mq5`, l'include, `CONTRATTI_SEDIE.md`)
> e **installa `ABTG_PausaGuardian.mqh`**. Quello che **non** fa: non
> ricompila, non apre MT5 per testare, non svuota la cache del tester, non
> cancella niente. **Zero passate, zero CSV.**

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='9fbe18dec0e0fcd0441a99571f376c5b07d72fdb'; $p="$env:USERPROFILE\RIGA_R100.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R100_ORO_FLOTTA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R100_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire** (altrimenti la corsa vera non parte):

- in testa: `sedie ....  12   (di cui GRUPPO 1 censite: 3, GRUPPO 2 non
  censite: 9)` e `passate TOTALI ....  180`;
- `include installato: ABTG_PausaGuardian.mqh`;
- per **ognuna** delle 12 sedie, tre righe verdi:
  - `file prova: NN righe vive (NN parametri + 3 direttive), rischio X%, asse Y = InpMagic 78SS10/78SS11`
  - `<EA>.mq5 al pin, version V (magic sorgente NNNNNN, include Guardian, OPTFRAME e Log d'ingresso presenti)`
  - `DD promesso ESTRATTO: …` **oppure** `DD promesso: RIGA NON TROVATA → il confronto 2x sarà NON CALCOLABILE`
- **le righe vive attese, sedia per sedia** (se una non torna, l'artefatto è
  cambiato e la riga si ferma da sola):

| id | EA | TF | righe vive | parametri | magic gemelle |
|---|---|---|---:|---:|---|
| S01 | `ABTG_EMA200_Ottimizzato` | H4 | 46 | 43 | 780110 / 780111 |
| S02 | `ABTG_MaxMinNotte` | H2 | 55 | 52 | 780210 / 780211 |
| S03 | `ABTG_PunteLarry` | H1 | 23 | 20 | 780310 / 780311 |
| S04 | `ABTG_SupertrendReversal_Multi_Ottimizzato` | H4 | 45 | 42 | 780410 / 780411 |
| S05 | `ABTG_GoldenCross_Ottimizzato` | H1 | 56 | 53 | 780510 / 780511 |
| S06 | `ABTG_SupertrendReversal` | H4 | 47 | 44 | 780610 / 780611 |
| S07 | `ABTG_SupertrendReversal_Multi` | H4 | 45 | 42 | 780710 / 780711 |
| S08 | `ABTG_EMA200` | H4 | 46 | 43 | 780810 / 780811 |
| S09 | `ABTG_GoldenCross` | H1 | 62 | 59 | 780910 / 780911 |
| S10 | `ABTG_SupertrendInvert` | H1 | 49 | 46 | 781010 / 781011 |
| S11 | `ABTG_PTE` | H4 | 47 | 44 | 781110 / 781111 |
| S12 | `ABTG_WOL` | D1 | 43 | 40 | 781210 / 781211 |

- e in fondo: **nessun PROBLEMA in elenco** e `ESITO: GIRO A VUOTO COMPLETATO`.

> ⚠️ **Quello che il giro a vuoto NON può fare, detto prima.**
> **`-SoloControllo` non apre MT5**, quindi **non esiste nessuno dei tre
> numeri**: niente DD lungo, niente peggior giornata, niente DD di regime,
> niente `n`, niente data di prima operazione, **niente tabella madre**. Può
> confermare gli **artefatti** (file prova, celle, finestre, magic, `.ini`,
> DD promessi estratti), **mai i numeri**. Sta scritto anche **dentro il suo
> referto**, perché nessuno lo scambi per il round (checklist 57).

---

## 2️⃣ POI la corsa vera

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='9fbe18dec0e0fcd0441a99571f376c5b07d72fdb'; $p="$env:USERPROFILE\RIGA_R100.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R100_ORO_FLOTTA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R100_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**, è un comando solo (checklist 21): tre righe
staccate sarebbero tre comandi indipendenti e un `throw` alla prima non
fermerebbe le altre.

> ⚠️ **Perché qui il messaggio è GIALLO e nel giro a vuoto è ROSSO.** Nella
> corsa vera `exit 1` può voler dire *"la corsa è riuscita e la risposta non ti
> piace"* (una sedia con finestra accorciata, un criterio B non misurabile, un
> round parziale): gli artefatti **esistono** e vanno mandati lo stesso — un
> `throw` qui butterebbe via una risposta buona (checklist 26-bis). Nel **giro
> a vuoto** `exit 1` vuol dire una cosa sola: **non si lancia niente.**

### 🔁 Se la corsa si interrompe

Si **rilancia la stessa identica riga**: le sedie e le finestre già fatte
vengono **saltate e dichiarate**. Per rifare tutto da capo si aggiunge
`-Rifai`; per una sedia sola, `-SoloSedia S03` (e il referto lo scrive: **una
sedia sola NON è il round**).

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

Aprire `REFERTO_R100.txt` e guardare **due righe in testa**, in quest'ordine:

1. **`modo:`** — dice `CORSA` (il round), `CONTROLLO` (giro a vuoto: **non è il
   round, non si manda come risultato**) o `SENZAPASSO0`;
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri, è un referto
   **stantio**: si guarda il **nome della cartella** sul Desktop (porta data e
   ora) e si rifà.

---

## 📦 COSA TORNA INDIETRO

Cartella e zip sul Desktop: `R100_ORO_FLOTTA_<MODO>_<data>_<ora>` — dentro:

- **`REFERTO_R100.txt`** ← **è questo che conta**, e in testa c'è **LA TABELLA
  MADRE**: `sedia | rischio | DD promesso | DD 22 anni | 2x? | peggior giornata
  | verdetto corsia RISCHIO`. **È la fotografia del rischio di tutta la
  concentrazione oro**;
- gli `.ini` di **ogni** passata (quelli VERI, gli stessi del giro a vuoto);
- gli `OptResults` di ogni sedia e di ogni finestra (`R100_*_ohlc.csv` — il
  suffisso `_ohlc` è la regola di casa: un OHLC non deve nemmeno poter finire
  nella stessa tabella di un tick reale);
- i **report `.htm`** delle passate singole e i **dump delle righe d'ingresso**
  dei log: sono la prova cartacea dei gate;
- i log di compilazione di ogni EA;
- `CONTRATTI_SEDIE_al_pin.md`, cioè **il documento da cui è stato letto ogni DD
  promesso**.

---

## 🚩 LE COSE DA GUARDARE PER PRIME NEL REFERTO

1. **La colonna `2x?` della tabella madre.** `SI` = quella sedia va in
   **REVISIONE** sulla corsia RISCHIO (firma 18/08), **senza altre
   discussioni**. È l'unica decisione del round, ed è meccanica.
2. **Quante righe hanno `DDPROM% = n/d`.** Sono le sedie oro **senza DD
   promesso**: su di loro la C3 **non può nemmeno scattare**. ⚠️ **Non è un via
   libera: è il rilievo.** Le attese sono **nove**.
3. **La colonna `PEGGGIOR`** contro il muro prop giornaliero del **5%**.
4. **La `FINESTRA` di ogni sedia.** Se è `ACCORCIATA`, quella riga va scritta
   **accanto a ogni numero** di quella sedia: il DD non copre 22 anni.
5. **I `GEMELLI`.** Se divergono, di quella sedia **non si legge niente**:
   banco sporco.
6. **I DD di regime.** Se una finestra sola fa il DD di tutta la storia, il
   rischio è concentrato in un regime — e con dodici sedie sullo **stesso**
   simbolo quella è la domanda che conta di più.

> 🔴 **E LA COSA CHE R100 NON DICE, da ricordare quando si legge la tabella:**
> **il drawdown di PORTAFOGLIO dell'oro NON c'è.** Dodici sedie sullo stesso
> simbolo **non** fanno un DD pari alla somma dei loro, né pari al massimo:
> dipende da **quanto si sovrappongono nel tempo**, e questo round misura le
> sedie **una per una, mai insieme**. È **un round diverso** (macchina dei
> round di portafoglio R16/R34/R37/R41) ed è la **domanda successiva ovvia**.

> 🔴 **E la sedia che manca del tutto**: `Gold_Ichimoku_TK_ATR_EA` XAUUSD
> `250604` (rischio vivo 0,5%) **non è misurabile con questa macchina** — non
> ha il blocco OPTFRAME, quindi non scrive nessun `OptResults` e non esiste
> nessun DD. È **l'ultima sedia a contratto PARZIALE** della flotta. Il referto
> lo dichiara in un paragrafo suo, col perché e col come si misurerebbe.
