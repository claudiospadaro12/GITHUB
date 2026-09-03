# 🚀 DEPLOY v1.04 ORB SUL SOLO PICCOLO — REFERTO DI PREPARAZIONE (PASSO 2)

_03/09/2026, pomeriggio. Perimetro firmato da Claudio alle 11:05 («FIRMO IL
PERIMETRO PICCOLO», `report/FIRME_2026-09-03.md`). PASSO 1 chiuso alle 14:18
con `0 errors, 0 warnings` (`REFERTO_COMPILA_ORB104_2026-09-03.txt`)._

> ⚠️ **Nota di ambiente, dichiarata subito.** Questa sessione **non ha il VPS e non
> fa nessun deploy**: costruisce il driver e la pagina, li esegue su un **banco
> stubbato** (Linux + `pwsh` 7.4.6, MetaEditor finto, cartelle dati finte) e li
> verifica. Il VPS ha **Windows PowerShell 5.1**: il parse reale su 5.1 **non è
> stato possibile** (vedi NON COPERTO). Lo strumento `Agent` per invocare il
> `verificatore-stringhe` **non è disponibile in questa sessione**: la sua lista
> (`.claude/agents/verificatore-stringhe.md`, §1–§6) è stata **eseguita a mano, punto
> per punto, dalla sessione stessa**, e il verdetto è scritto qui sotto nel suo
> formato fisso. È una deviazione dal compito, dichiarata.

## 1. 📦 COSA È STATO CONSEGNATO

| pezzo | dove | commit |
|---|---|---|
| driver | `backtest_pipeline/righe/RIGA_DEPLOY_ORB104_PICCOLO.ps1` (marcatore `MARCATORE_RIGA_DEPLOY_ORB104_PICCOLO_v1`) | `dddb028` → `6387cf5` → **`8167c77`** |
| pagina | `backtest_pipeline/righe/RIGA_DEPLOY_ORB104_PICCOLO_DA_MANDARE.md` (CONTROLLO + CORSA + PASSO 3) | `7cfaf68` (segnaposto) → `8167c77` → pin inserito |
| questo referto | `backtest_pipeline/risultati_archivio/REFERTO_DEPLOY_ORB104_PICCOLO_PREPARAZIONE.md` | — |

**Pin della pagina: `8167c772ac15df23ef177fa5754839232829869b`** — verificato via
`raw` (HTTP 200, sha256 identico) per driver, `.mq5` (identico al fix `19312c8`) e
`.mqh` (v1.51).

`aggiorna_verifica_orb.ps1` (22/08) **non è stato toccato**: viola il perimetro
(aggiorna entrambe le istanze, default `1.02`) e resta agli atti com'era.

## 2. 🧭 LE SCELTE SEVERE, DICHIARATE (dove il compito era ambiguo)

1. **Il fatto che sceglie la cartella dati è QUADRUPLO**, non doppio come nel
   compito («`bases\BCMMarkets-Server` e niente `-V3`»): (1) `bases\BCMMarkets-Server`;
   (2) nessuna traccia del 100k — `-V3` in `origin.txt`/percorso **o il login
   `50504263` nei log** (il login è un fatto, `-V3` è un'etichetta nostra usata solo
   per escludere); (3) il login `50503392` nei log = **conferma** (rilievo se manca);
   (4) **la cartella sta sotto il profilo della sessione che lancia** (`%APPDATA%`).
   Il (4) nasce da un fatto misurato: il 100k gira sotto **Administrator** (HANDOFF
   03/09) e il 14/08 sotto Administrator c'era **anche** una copia della stessa
   installazione del piccolo, «collegata al conto» (`report/DAX_14-08_DUE_MOTORI.md`
   righe 402-403). Con i soli fatti 1-3 sarebbero **due eleggibili** e un giro a vuoto;
   scegliere «quella sotto Master» per nome sarebbe la classe 115. Il profilo della
   sessione è una proprietà del sistema, non un nome.
2. **Il gate dei processi vede tutta la macchina**, sessione Administrator compresa:
   in CORSA si pretendono chiusi **tutti** i `terminal64`/`metaeditor64`, come nella
   procedura del 22/08. Chiudere e riaprire il terminale del 100k **non ne tocca i
   file** (fotografati). È più disturbante che rifiutare solo il terminale del
   piccolo, ma rifiutare «solo quello» richiederebbe di riconoscerlo dal percorso
   dell'exe prima di aver scelto la cartella dati — cioè dal nome.
3. **In CONTROLLO MT5 aperto è tollerato** (rilievo): non scrive niente, e serve a
   vedere di giorno l'elenco delle cartelle e la cartella scelta. La pagina lo dice.
4. **Sentinella trovata in CONTROLLO = PROBLEMA e `exit 1`, nessun ripristino**:
   il CONTROLLO non scrive nel terminale, nemmeno per rimettere a posto. In CORSA
   rimette a posto dal backup e lo dichiara come rilievo.
5. **`.ex5` fresco ma `Result` con errori > 0 = FALLITA e ripristino**: il log è il
   contratto, un binario nato con errori nel log non va in forward (contraddizione
   scritta nei PROBLEMI).
6. **`COSA SUCCEDE DOPO` non manda a cercare `v1.04` nel Giornale**: l'`OnInit` della
   v1.04 **non stampa il numero di versione** (verificato nel sorgente: `Log("avviato
   su ...")` senza versione). Il compito lo chiedeva, ma un controllo che cerca un
   token che il codice non scrive è la classe 82. La prova di identità è la riga
   **`ORB AUTOTEST: 10 blocchi su 10 passati, 33 casi dichiarati, 0 falliti`** nella
   scheda **Esperti** (la v1.02 non la stampa: 0 occorrenze di `ORB AUTOTEST` e di
   `ORB INIT` nel sorgente `3125e34`), più `loaded successfully` nel Giornale.
7. **Versione installata letta, non assunta**: il `.mq5` sul piccolo è 39.456 byte del
   27/08 (foto del PASSO 1) = **v1.02** (`3125e34`, 39.456 byte). L'unico input nuovo
   fra v1.02 e v1.04 è `InpAutoTest` (diff degli `input` fra i due commit): i
   parametri del grafico restano, il nuovo prende il default `true`.
8. **Orario**: la CORSA fra le 07:30 e le 22:15 non è bloccata (MT5 chiuso è
   misurato, quindi la flotta è ferma per costruzione) ma è un rilievo.

## 3. 🧪 IL BANCO STUBBATO — 27 casi ESEGUITI (pwsh 7.4.6)

Stub: `Join-Path` con `/`, `Get-Process` pilotato da env, `Invoke-WebRequest` che copia
dal repo locale (o da una cartella di **mutazioni**), `metaeditor64.exe` finto che
scrive il log **in UTF-16 con BOM** e torna **`1`** come sul VPS. Cartelle dati finte
con `origin.txt`, `bases\BCMMarkets-Server`, log UTF-16 con le righe di login,
`Presets\`, `Profiles\Charts\`, `config\`. `.mq5` installato = v1.02 vera (`3125e34`).

| # | caso | exit | zip | backup | esito nel referto |
|---|---|---|---|---|---|
| C01 | CONTROLLO pulito | 0 | sì | no | `NON TENTATA (modo CONTROLLO)`, tutte le foto `INVARIATO`, `-V3 INVARIATO` |
| C02 | CORSA, MetaEditor ok | 0 | sì | sì | `OK (91 KB ...)`, `DEPLOY: AVVENUTO`, tre `CAMBIATO` (nuovi byte), `-V3 INVARIATO`, parametri `INVARIATI` |
| C03 | CORSA con `terminal64` vivo | 1 | sì | no | `!!! FERMATO: MT5 O METAEDITOR APERTI` prima di scaricare |
| C04 | CONTROLLO con MT5+MetaEditor vivi | 0 | sì | no | rilievo «tollerato», foto `INVARIATO` |
| C05 | `-Pin abc123` | 1 | sì | no | `FERMATO: -Pin deve essere ... 40 caratteri` |
| C06 | download 404 | 1 | sì | no | `FERMATO: SCARICO FALLITO ... cache ~5 min, rilancia LA STESSA riga` |
| C07 | sorgente mutato a `#property version "1.03"` | 1 | sì | no | `FERMATO: VERSIONE SBAGLIATA` (gate rosso sulla mutazione) |
| C08 | sorgente mutato con un `PositionSelect(_Symbol)` vivo | 1 | sì | no | `FERMATO: IL FIX NON E' COMPLETO ... 1 occorrenze` |
| C09 | include mutato: `ABTG_GuardiaIngressoRINOMINATA` | 1 | sì | no | `FERMATO: l'include ... non definisce ABTG_GuardiaIngresso(...)` (116-ter) |
| C10 | nessuna cartella con `bases\BCMMarkets-Server` | 1 | sì | no | `FERMATO: NON SO QUALE CARTELLA ... eleggibili sotto questo profilo 0` + elenco |
| C11 | due cartelle eleggibili sotto lo stesso profilo | 1 | sì | no | `FERMATO: ... eleggibili sotto questo profilo 2` + elenco |
| C12 | come C11 + `-CartellaDati` sulla giusta | 0 | sì | sì | `IMPOSTA A MANO ... ha passato gli stessi gate`, deploy OK |
| C13 | `-CartellaDati` sulla `-V3` | 1 | sì | no | `FERMATO: -CartellaDati ... NON passa i gate: E' IL 100k/-V3` |
| C14 | `-CartellaDati` inesistente | 1 | sì | no | `FERMATO: -CartellaDati ... non esiste` |
| C15 | CORSA, MetaEditor con 2 errori | 1 | sì | sì | `FALLITA (... errori dal log: 2) -- RIMESSO dal backup`, tre `PICCOLO ... INVARIATO` (sha256 e data), prime 30 righe del log |
| C16 | CORSA, MetaEditor muto | 1 | sì | sì | `FALLITA -- METAEDITOR MUTO`, ripristinato, `INVARIATO` |
| C17 | CORSA ok con 1 warning | 0 | sì | sì | `OK ..., 0 errors, 1 warning` + rilievo col testo del warning |
| C18 | CORSA, `metaeditor64.exe` non avviabile | 1 | sì | sì | `FALLITA -- METAEDITOR NON PARTITO`, `ripristino: ... dopo un'eccezione`, `INVARIATO` |
| C19 | sentinella di un giro interrotto, CORSA | 0 | sì | sì (2) | rilievo «giro precedente interrotto ... RIMESSI dal backup», poi deploy OK |
| C20 | sentinella, CONTROLLO | 1 | sì | — | PROBLEMA «rilancia in CORSA o ripristina a mano», nessuna scrittura, sentinella lasciata |
| C21 | `Include\Trade\Trade.mqh` assente | 1 | sì | no | `FERMATO: INCLUDE DI LIBRERIA NON TROVATO` (ambiente, prima di scrivere) |
| C22 | nessuna cartella `-V3` | 0 | sì | sì | rilievo «NESSUNA candidata con traccia del 100k ... foto non possibile», deploy OK |
| C23 | login `50503392` assente dai log | 0 | sì | no | rilievo «login NON compare ... la scelta si regge su bases + assenza del 100k» |
| C24 | copia della stessa installazione sotto `Administrator`, stesso login | 0 | sì | sì | scelta la cartella sotto il profilo della sessione; rilievo «altre 1 ... sotto un ALTRO profilo, NON toccate»; `-V3 INVARIATO su 9 foto (3 cartelle)` |
| C25 | `-CartellaDati` sulla copia sotto `Administrator` | 0 | sì | sì | accettata, rilievo «sta sotto un ALTRO profilo: l'hai scelta tu» |
| C26 | lanciata dalla sessione sbagliata (`%APPDATA%` vuoto) | 1 | sì | no | `FERMATO: ... 1 cartelle passano i fatti ma NESSUNA sta sotto il profilo di questa sessione (Administrator ...)` |
| C27 | installazione portable in `Program Files` | 0 | sì | no | trovata, elencata come «altro profilo», non scelta da sola |

Due difetti trovati **eseguendo** e corretti prima del pin (commit `6387cf5`):
- `ripristino:` nel ramo OK diceva «il terminale non e' mai stato scritto» — falso
  (classe 94): ora `NON NECESSARIO (compilazione OK ...)`;
- `compilazione:` con l'invocazione stessa di MetaEditor che esplode (C18) diceva
  `NON TENTATA` (classe 94-ter): ora si timbra **prima** del lancio.

Il terzo, trovato **leggendo** (HANDOFF + report del 14/08) e corretto in `8167c77`:
la copia sotto Administrator (C24). Registrato in checklist come **115-bis**.

## 4. ✅ IL VERDETTO DEL VERIFICATORE (lista eseguita a mano, formato fisso)

```
VERDETTO   PASS
STRINGA    i due blocchi di RIGA_DEPLOY_ORB104_PICCOLO_DA_MANDARE.md al pin
           8167c772ac15df23ef177fa5754839232829869b, cosi' come sono
DIFETTI    nessuno residuo. Trovati e corretti PRIMA del pin:
           1. classe 94   (ripristino: falso nel ramo OK)          -> 6387cf5
           2. classe 94-ter (compilazione: NON TENTATA su eccezione) -> 6387cf5
           3. classe 115-bis (copia sotto altro profilo = 2 eleggibili) -> 8167c77
NON COPERTO
           - parse reale su Windows PowerShell 5.1: qui c'e' pwsh 7.4.6. Controlli
             statici fatti: nessun operatore ternario, nessun && / || fra comandi,
             nessun -AsHashtable, nessun ?? ; costrutti usati gia' girati sul VPS
             il 03/09 nel driver gemello (RIGA_COMPILA_ORB104.ps1: stesse
             funzioni LeggiTesto/Compila/Foto, stesso blocco di lancio).
           - la scansione di C:\Users\* e di Program Files sul VPS vero: qui e'
             simulata (SystemDrive/ProgramFiles finti). Se Master NON legge il
             profilo Administrator, le cartelle del 100k non compaiono e il
             referto lo dice (rilievo C22), senza fermarsi.
           - il formato della riga di login nei log MT5 ('NNNN': login on ...):
             preso da RIGA_COLLAUDO_FASE1_S1.ps1 v2; qui e' un ancoraggio a
             sottostringa, e se manca e' un rilievo, non un blocco.
           - la finestra dei 20 s del "MUTO" e' una grazia DOPO che metaeditor64
             e' gia' uscito (il | Out-Null aspetta il processo): non e'
             un'euristica del silenzio su un processo vivo. Identica al driver
             del PASSO 1, che sul VPS ha misurato l'.ex5 dopo 4 s.
```

Controlli §2 della lista, uno per uno: (1) non-ASCII nel `.ps1` e nei due blocchi:
**0**; (2) formati `.NET` invalidi: **0** (nessuna `-f`); (3) cultura: ogni `Parse`/
`ToString` porta `$INV`, `CurrentCulture` forzata a invariante; (4) cache raw: pin a
40 hex + `Select-String` sul marcatore prima di eseguire; (5) file sul remoto:
`git ls-tree origin/lavoro` OK per driver e pagina, `git status` pulito; (6) guardia
MT5: nel driver (CORSA, prima di tutto) **e** nel blocco CORSA (prima dell'`irm`); la
pagina lo dice in testa a caratteri grandi; (7) niente stringhe vuote come argomento
(`-CartellaDati` solo quando serve); (8) `fermoDa`: 0; (9-11) ora server / TP1 PTE /
`@DAQUANDO`: non applicabili (nessun `.ini`, nessuna prova); (12) quoting: i due
blocchi **parsano** (`Parser::ParseFile`), apici raddoppiati nelle stringhe a
singolo apice, `$` solo dentro doppi apici voluti. §3: `irm` davanti al pin, raccolta
sul Desktop con zip e file attesi in console, riga `data:` = ora di **avvio**
calcolata dal `$t0` del blocco (classe 110), Desktop calcolato nel blocco con le tre
righe del driver (116-bis). Codice di uscita a tre stati (108) nel blocco.

## 5. ➡️ COSA SUCCEDE DOPO
La pagina è lanciabile. Sequenza per Claudio: **CONTROLLO** (anche di giorno) → zip
in chat → se pulito, **CORSA** con MT5 e MetaEditor chiusi e flotta ferma → zip in
chat → **PASSO 3** (scheda Esperti: `ORB AUTOTEST ... 0 falliti`; Giornale: `loaded
successfully`; F7: `InpRiskPercent = 1.0`) → screenshot. La cartella di backup
resta sul Desktop finché il PASSO 3 non è chiuso.
