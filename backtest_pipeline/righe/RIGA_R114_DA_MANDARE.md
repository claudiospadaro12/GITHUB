# 📬 R114 — **LA RIGA DA MANDARE** (la prova della leva: chi sale sulla prop a 1:15?)

**Round**: R114 — **LA PROVA DELLA LEVA** (fase 2 della prova della taglia).
**La domanda**: con leva prop **1:15** (indici e oro) e deposito challenge
**200.000**, quali sedie ricevono **RIFIUTI DI MARGINE**, e come cambiano i
loro numeri rispetto al banco di casa? **4 celle × 3 passate**:

| passata | deposito | leva | cosa misura |
|---|---:|---:|---|
| **P0 aggancio** | 100.000 | 100 | il banco è LO STESSO dell'antenato? |
| **P1 taglia** | 200.000 | 100 | il raddoppio di taglia da solo |
| **P2 leva** | 200.000 | **15** | **LA DOMANDA DEL ROUND** |

| cella | motore | simbolo/TF | banco | finestra |
|---|---|---|---|---|
| `C0_ORB` | ABTG_ORB_Ottimizzato | U30USD M5 | tick reali (4) | 2024.09.26 → 2026.06.30 |
| `C1_EMADOW` | ABTG_EMA200 (metro R112) | U30USD H1 | tick reali (4), **2 gambe IS/OOS** | 2024.09.26 → 2026.06.30 |
| `C2_MAXMIN` | ABTG_MaxMinNotte_DAX_Short_Ott. | D30EUR M15 | tick reali (4) | 2024.09.26 → 2026.06.30 |
| `C3_ORO` | ABTG_SupertrendReversal_Ott. | XAUUSD H4 | **OHLC M1 (1)** | **2020.01.01** → 2026.06.30 |

Più il **CANARINO G-CAN** (deposito **2.000** / leva 15 sugli input di C0,
magic 763690/763691: **DEVE** produrre almeno un rifiuto, è il controllo
positivo del rilevatore) e la **sonda G-SPEC** (`ABTG_SondaMargine` sui 3
simboli a banco 200k/leva 15: stampa le specifiche margine viste dal tester).

Magic: `763600 + C×20 + P×2 + G`, gemello **+1** (blocco vergine **7636xx**;
nel file prova sta la coppia di P0, P1/P2 le riscrive il driver nell'.ini).
**Vietati e controllati nel codice**: 770611, 771531, 771501, 770411, 970901
e tutto **763300–763599** (R110/R112/R113).

**Criteri**: `risultati_archivio/R114_CRITERI.md` — ✅ **GIÀ FIRMATI** («**FIRMO
R114**», Claudio, 27/08/2026 mattina): il gate legge lo stato **al pin** e con
il lucchetto tolto la corsa vera **parte da sola, senza switch** — nessuno
switch di bypass sta in questa pagina (checklist 82).
**Driver**: `righe/RIGA_R114_PROVA_LEVA.ps1` (marcatore `MARCATORE_RIGA_R114_v1`).
**File prova**: `prove/R114_C{0..3}_{ORB,EMADOW,MAXMIN,ORO}.txt` — **quattro**,
uno per cella (le passate vivono negli `.ini` del driver, decisione D2).

---

## 🧨 LE TRE COSE DA SAPERE PRIMA DI LEGGERE I NUMERI

1. **Le attese sono PRE-DICHIARATE** (criteri § 3): P1 deve avere **n identico
   a P0**; P2, se il margine non morde, deve essere **IDENTICA a P1 al
   centesimo**. **Qualunque** differenza P2−P1 è margine che ha morso e va
   spiegata riga per riga. Il driver stampa i **metri**; il verdetto
   🟢/🟡/🔴/⬜ si scrive **a mano** (soglia rifiuti 5% degli ingressi, DD
   promesso, riduzione al 20% del conto — D7).
2. **Il rilevatore dei rifiuti viene PROVATO prima di essere creduto**
   (checklist 84-bis): il canarino gira **prima** delle celle, nel **modo
   gemelle** delle celle. La stringa del journal si **impara** dal suo log
   (VPS in italiano: mai assunta). Se il canarino non morde, il driver
   disambigua da solo con un **canarino B a passata singola** (due cause, due
   nomi: journal muto in ottimizzazione ↔ tester che non simula la leva) e il
   round si ferma con **exit 2**. Nessuno "zero rifiuti" si legge con un
   rilevatore mai visto mordere.
3. **G0-B**: `C1_EMADOW` P0 deve riprodurre **al centesimo** i CSV R110
   congelati (`prove/R110_CSV_EMADOW/`, gambe IS e OOS — per questo C1 gira a
   due gambe). Per C0/C2/C3 **non esiste un CSV di riferimento congelato**: il
   P0 si confronta con l'archivio **come INFO**, G4 a mano. ⚠️ E c'è un
   **disallineamento dichiarato** (nota (a2) del driver): per C0/C2 i criteri
   scrivono "tick reali" come modello antenato, ma i numeri R103 archiviati
   sugli indici sono di una corsa **OHLC M1** (lo switch `-TickReali` di R103
   non fu mai firmato). Quindi per C0/C2 il confronto P0-vs-archivio è
   **indicativo** (banchi diversi); l'aggancio **dimostrato** al centesimo
   resta quello di C1. Per C3 oro banco e archivio coincidono (OHLC M1).

E le note di costruzione: **niente `walkforward_generico`** (scrive
`Leverage=100` fisso — nota dei criteri): la fabbrica `.ini` è quella di R113,
con `Deposit`/`Leverage`/`Currency`/`Model` **propri per passata**, stampati
dal giro a vuoto per ogni `.ini`. **C3 ORO non esporta i per-trade** (misurato
nel sorgente): vol max e righe a 100 sono **n/d per costruzione** su quella
cella, rilevatore = journal + delta n. **Pulizia per lancio** (checklist 88);
un lancio col CSV già presente viene **raccolto con l'età dichiarata**, si
rifà solo con `-Rifai`. **G5**: nessun deploy — il round produce la **LISTA
DELLE SEDIE AMMISSIBILI stampata VUOTA**, che si compila nella delibera.

---

## 📌 IL PIN — ⚠️ NON ANCORA ASSEGNATO (si assegna DOPO il push, mai prima)

```
@@PIN@@
```

⚠️ **Il pin si rilegge DOPO il push, non prima** (checklist 6 e 55). Il commit
da pinnare deve contenere **TUTTI** gli artefatti che il driver riscarica al
pin: il driver, i **4** file prova `R114_C*_*.txt`, i criteri
`R114_CRITERI.md`, i **4 antenati**
(`R103_ABTG_ORB_Ottimizzato_U30USD_770611.txt`, `R112_00_metro.txt`,
`R103_ABTG_MaxMinNotte_DAX_Short_Ottimizzato_D30EUR_770411.txt`,
`R103_ABTG_SupertrendReversal_Ottimizzato_XAUUSD_970901.txt`), i **2 CSV di
riferimento** `R110_CSV_EMADOW/ABTG_EMA200_U30USD_{IS,OOS}_00_metro.csv`, i
**4 sorgenti** dei motori + **`ABTG_SondaMargine.mq5`** (la sonda G-SPEC,
nuova di R114) e `mql5/Include/ABTG_PausaGuardian.mqh`.

La riga passa il pin a `-Pin` e **si rifiuta di partire senza**: un default
silenzioso (`lavoro`) farebbe girare la punta del branch spacciandola per un
commit congelato.

---

## ⚠️ COSA SAPERE PRIMA DI LANCIARE

- **MT5 e MetaEditor DEVONO essere chiusi.** La riga si rifiuta di partire
  altrimenti. (Poi è **lei** ad aprire il tester, anche nel giro a vuoto —
  vedi sotto.)
- **NESSUNA SEDIA VIVA VIENE TOCCATA** (G5). Ma ⚠️ **questo round RICOMPILA
  i `.ex5` di QUATTRO sedie che operano sul 100k** (più la sonda): backup
  datato mai sovrascritto di `.mq5` e `.ex5`, ripristino se una compilazione
  fallisce. Gli `.ini` girano con `AllowLiveTrading=false`, **verificato
  nell'artefatto** riletto.
- **15 lanci di misura** (C0/C2/C3 a finestra unica ×3 passate = 9; C1 a due
  gambe ×3 passate = 6), **2 passate gemelle** l'uno (magic +1), **30
  passate** + il canarino. `Spread=0` scritto nell'ini = *spread corrente del
  simbolo*, convenzione di casa.
- ⏱️ **Durata attesa — È UNA STIMA, dichiarata tale**: 12 passate logiche
  di cui 9 a **tick reali** (ORB M5 e MaxMin M15 su 21 mesi sono le lente)
  + l'oro OHLC + canarino + sonde → **40–90 minuti** più le 5 compilazioni,
  **da verificare al primo giro**. `-OreMax 4` è un tetto **sull'inizio** dei
  lanci, non ammazza quello in corso.
- **Il canarino a 2.000/leva 15 è un banco APPOSTA strozzato**: se sul tuo
  schermo vedi errori "not enough money" durante il canarino, **è quello che
  deve succedere** — è il rilevatore che impara la stringa.

---

## 1️⃣ PRIMA il giro a vuoto (pochi minuti, **nessuna passata di misura**)

> ⚠️ Non è a costo zero sul terminale: scarica gli artefatti al pin, installa
> l'include, **COMPILA i 5 EA** (checklist 39) e — **novità di R114,
> deviazione dichiarata** — fa girare nel tester le **3 sonde G-SPEC**
> (pochi secondi l'una: i criteri § 4 esigono le specifiche margine **nel
> giro a vuoto**). Quello che **non** fa: nessuna passata di misura, nessun
> canarino, **nessun numero di round** — niente n, niente PF, niente G0-C.
> Scrive e **verifica gli STESSI 20 `.ini`** della corsa vera (15 misura +
> canarino A/B + 3 sonde, checklist 33) e li mette nello zip con
> `Deposit`/`Leverage`/`Currency`/`Model` stampati per ognuno.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R114.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R114_PROVA_LEVA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R114_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin -SoloControllo;
    if($LASTEXITCODE -ne 0){ Write-Host '!!! CONTROLLO NON PASSATO: NON lanciare la corsa vera. Leggi i PROBLEMI nel REFERTO.' -ForegroundColor Red } }
```

**Cosa deve dire**, in ordine (⚠️ attesi **dichiarati dal codice**, il driver
non è mai girato sul PC di backtest: al primo giro fa fede il referto):

- `lanci di misura .............. 15` e `sonde G-SPEC ................. 3`;
- `criteri: FIRMATI (nessun lucchetto nel file al pin)` — **e dev'essere
  questa**: se legge `NON FIRMATI`, il file al pin è tornato col lucchetto;
- `4 file prova R114 + 4 antenati + 2 CSV riferimento G0-B scaricati al pin, righe vive verificate (56/46/55/45)`;
- `G0-A: ogni file prova e' la copia riga per riga del suo antenato, delta il solo InpMagic`;
- per ognuno dei 4 motori: `...mq5 al pin, version ..., InpMagic sorgente ..., OPTFRAME 8 colonne` (con `export per-trade ASSENTE (dichiarato)` **solo** sull'oro);
- `COMPILATO` ×5 (i 4 motori + `ABTG_SondaMargine`);
- i **20 `.ini`** elencati con `Deposit= Leverage= Currency=EUR Model=` giusti
  (P0 100000/100, P1 200000/100, P2 200000/**15**; canarino 2000/**15**);
- `STELLA fra le passate: ... i tre .ini differiscono SOLO su Deposit/Leverage/Report e InpMagic`;
- `G-SPEC <simbolo>: N righe estratte` per i 3 simboli, con le righe
  `GSPEC;...` a video (margine osservato per 1 lotto compreso);
- in fondo: `.ini scritti e verificati in sosta: 20 su 20`, **nessun PROBLEMA**
  e `ESITO: GIRO A VUOTO COMPLETATO`.

---

## 2️⃣ POI la corsa vera — **le dieci decisioni sono già firmate**

Il gate si apre da solo: il driver cerca il lucchetto della firma nel file dei
criteri **al pin, in tutto il file**, e nel file firmato («FIRMO R114», 27/08
mattina) non lo trova più — quindi questo blocco parte **senza switch**.

> ⚠️ **Se la corsa vera uscisse con codice 2**, sono DUE casi diversi, e si
> distinguono **da cosa trovi sul Desktop** (verificato eseguendo):
> - **(a) i criteri al pin sono tornati col lucchetto** → la riga si ferma
>   **due secondi dopo il lancio, PRIMA di produrre qualunque artefatto**:
>   sul Desktop **non c'è nessuna cartella e nessuno zip**, e non deve
>   essercene. Quello che serve è **il riquadro rosso a schermo** («NON
>   PARTO: I CRITERI DI R114 NON RISULTANO FIRMATI AL PIN»): copiamelo. Si
>   legge il documento, non si aggira il gate.
> - **(b) il canarino non ha morso** → round fermo per costruzione
>   (checklist 84-bis): qui la raccolta **è stata fatta**, **lo zip esiste e
>   va mandato**, e la diagnosi col nome della causa è nei PROBLEMI del
>   referto.

```powershell
& { $ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;
    if(Get-Process terminal64,metaeditor64 -EA SilentlyContinue){ throw 'MT5 O METAEDITOR APERTO: chiudili e rilancia.' };
    $pin='@@PIN@@'; $p="$env:USERPROFILE\RIGA_R114.ps1"; Remove-Item $p -EA SilentlyContinue;
    irm "https://raw.githubusercontent.com/claudiospadaro12/GITHUB/$pin/backtest_pipeline/righe/RIGA_R114_PROVA_LEVA.ps1" -OutFile $p;
    if(-not (Select-String -Path $p -SimpleMatch -Pattern 'MARCATORE_RIGA_R114_v1' -Quiet)){ throw 'SCRIPT VECCHIO' };
    $global:LASTEXITCODE=0; & $p -Pin $pin;
    if($LASTEXITCODE -ne 0){ Write-Host 'ESITO: PARZIALE O FERMO - lo zip esiste lo stesso: mandalo, e leggi il REFERTO' -ForegroundColor Yellow } }
```

Si incolla **il blocco INTERO**: è **un comando solo** (checklist 21).

> ⚠️ Nella corsa vera `exit 1` può voler dire *"la corsa è riuscita e c'è
> qualcosa da leggere nei PROBLEMI"*: gli artefatti **esistono** e vanno
> mandati lo stesso.

### 🔁 Se serve riprendere

**Una cella sola**: si rilancia il **blocco 2 intero** aggiungendo alla riga
`& $p -Pin $pin` la coda `-SoloCella 'R114_C2_MAXMIN.txt'` (fra apici; nomi
validi: i quattro `R114_C{0..3}_*.txt`). `-SoloCella` prende **la cella
intera** (P0 è il denominatore di P1/P2); **canarino e sonde girano comunque**
(il rilevatore si riprova a ogni corsa). I lanci col CSV già presente **non si
rifanno**: raccolti con l'età dichiarata (checklist 88) — i loro **rifiuti
journal restano n/d** (non rimisurabili su un lancio saltato); per rifarli si
aggiunge `-Rifai`. ⚠️ **Ogni ripresa è il blocco intero con il suo `irm`**
(checklist 42).

---

### 📅 LE DUE RIGHE CHE CLAUDIO DEVE LEGGERE NEL REFERTO, PRIMA DI MANDARE LO ZIP

1. **`modo:`** — sono **TRE**, e stanno anche nel nome della cartella e dello
   zip: `CORSA` (il round pieno), `CONTROLLO` (giro a vuoto: **non è il round,
   non si manda come risultato**), `RIPRESA` (giro con `-SoloCella`: contiene
   **solo** i lanci di quella cella — verificato eseguendo);
2. **`data:`** — **deve essere di ADESSO**. Se è di ieri è un referto stantio.

---

## 📦 COSA MANDARE (cosa torna indietro)

Cartella e zip sul Desktop: `R114_LEVA_<MODO>_<data>_<ora>` (`<MODO>` =
`CORSA` / `CONTROLLO` / `RIPRESA`) — dentro:

- **`REFERTO_R114.txt`** ← **è questo che conta**: le approssimazioni del
  banco (§ 1 dei criteri, ristampate), le righe **G-SPEC** per simbolo
  (margine atteso FASE 1 **contro** osservato dal tester, `VOLUME_MAX` di
  XAUUSD compreso), la sezione **G-CAN** con la stringa imparata, la
  **tabella madre** (lancio × deposito × leva: PROF/PF/DD/n + **rifiuti
  journal** + vol max + righe a 100), i **DELTA P1−P0 e P2−P1** per cella con
  l'INFO *"P2 identica a P1 al centesimo? SI/NO"*, la **lettura pre-dichiarata**
  🟢/🟡/🔴/⬜ (verdetto **a mano**) e la **LISTA DELLE SEDIE AMMISSIBILI
  stampata VUOTA**;
- i **15 CSV** `R114_C*_P*.csv` (2 righe l'uno: le gemelle) + `R114_canarino_A.csv`;
- i **per-trade** `pertrade_*.csv` (C0/C1/C2; l'oro non li ha, dichiarato);
- le **evidenze rifiuti** `rifiuti_*.txt` e `gspec_*.txt`;
- i **4 file prova al pin** + i **4 antenati** + i **2 CSV di riferimento
  G0-B** (`RIF_*`): chi apre lo zip fra un mese rifà G0-A e G0-B a mano;
- i **20 `gen_R114_*.ini` scritti-e-riletti** e i `compile_*.log` (5).

**MANDA IN CHAT QUESTO FILE**: lo **zip** `R114_LEVA_*.zip`.

---

## 🚦 LE TRE USCITE

| codice | vuol dire | cosa fare |
|---|---|---|
| **0** | OK / COMPLETO CON RILIEVI (i rilievi sono risultati o note) | manda lo zip |
| **1** | parziale, fermato a metà, o completo con problemi | **manda lo zip lo stesso** e leggi i PROBLEMI |
| **2** | **due casi**: **canarino che non morde** (round fermo per costruzione, 84-bis) → **lo zip c'è**; oppure **criteri al pin col lucchetto** (coi criteri già firmati NON deve succedere) → **niente zip**, la riga muore prima | zip se c'è, altrimenti copiami il riquadro rosso |

⚠️ **Quando NON c'è nessuno zip** (e va bene così: la riga si è fermata prima
di produrre qualcosa, quindi non esiste nessun referto da leggere) — verificato
eseguendo: **MT5 o MetaEditor aperto**, **`-Pin` mancante**, **`-SoloCella` con
un nome che non esiste**, **criteri col lucchetto**. In tutti e quattro i casi
quello che conta è il **messaggio rosso a schermo**: copiami quello.

---

## 🔧 PER LA SESSIONE (non per Claudio) — assegnare il pin

La pagina esce con un **segnaposto** al posto del commit. Va sostituito nei
**punti d'uso**, mai su tutta la pagina (checklist 77). Il token si **compone**
in una variabile, così la ricetta non contiene mai la stringa che sta cercando.

```bash
cd ~/GITHUB && git pull --rebase --autostash
SHA=$(git rev-parse HEAD)
F=backtest_pipeline/righe/RIGA_R114_DA_MANDARE.md
TOK='@@PIN'"@@"
sed -i "s|\$pin='$TOK'|\$pin='$SHA'|g; s|^$TOK\$|$SHA|" "$F"
grep -c "\$pin='$SHA'" "$F"    # DEVE dare 2   <- i punti d'uso (i 2 blocchi powershell)
grep -c "$TOK" "$F"            # DEVE dare 0   <- nessun segnaposto rimasto
```

⚠️ **Servono TUTTI E DUE i conteggi** (un `sed` che non ha matchato niente
passa comunque il solo "0 rimasti"). E quando il pin è assegnato, va
aggiornato **a mano** il titolo del riquadro (da «NON ANCORA ASSEGNATO» ad
«ASSEGNATO il …»): è prosa.

**Ri-pinnatura** (checklist 77-bis). Il pin vecchio si legge **dai punti
d'uso**, mai con un `grep` largo:

```bash
NUOVO=<lo sha nuovo, 40 caratteri>
F=backtest_pipeline/righe/RIGA_R114_DA_MANDARE.md
VECCHIO=$(grep -oE "\\\$pin='[0-9a-f]{40}'" "$F" | head -1 | grep -oE '[0-9a-f]{40}')
echo "vecchio: $VECCHIO"
sed -i "s|\$pin='$VECCHIO'|\$pin='$NUOVO'|g; s|^$VECCHIO\$|$NUOVO|" "$F"
grep -c "\$pin='$NUOVO'" "$F"     # DEVE dare 2
grep -c "\$pin='$VECCHIO'" "$F"   # DEVE dare 0
```

⚠️ Il conteggio atteso si **riconta sulla pagina vera** a ogni ri-pinnatura.

### E la firma dei criteri

Il gate del driver cerca una **stringa letterale** dentro `R114_CRITERI.md`,
in **tutto il file**. I criteri sono **già firmati** (27/08 mattina): il
controllo è un conteggio, non un colpo d'occhio (il token si compone, mai
scritto per esteso — checklist 82), e **deve restare a zero**:

```bash
TOKF='[DA '"FIRMARE]"
F=backtest_pipeline/risultati_archivio/R114_CRITERI.md
grep -cF "$TOKF" "$F"    # oggi, a criteri FIRMATI: DEVE dare 0
```

E si prova **nei due versi** (checklist 82): col lucchetto tolto la corsa vera
deve **partire senza switch**; col lucchetto rimesso deve tornare a **uscita 2**.
