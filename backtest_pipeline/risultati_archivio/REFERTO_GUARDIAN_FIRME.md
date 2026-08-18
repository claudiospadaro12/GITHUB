# 🛡️ REFERTO — LE FIRME DEL 18/08 DENTRO IL GUARDIAN (codice, non ancora prova)

**Cosa e' questo**: la traduzione in codice del verbale
`report/FIRME_2026-08-18.md` (firme B1/B2/B3 e C1). Commit `a53820e` sul
branch `lavoro`.

> ⚠️ **NIENTE QUI E' STATO COMPILATO NE' PROVATO.** In questo ambiente non
> esistono MetaEditor ne' MT5: quello che segue e' codice scritto e riletto,
> non codice verificato dal compilatore. La compilazione (F7) e la prova sul
> **DRY-RUN 100k** le fa Claudio. Sul conto vero **non si tocca niente**
> finche' non ha visto girare il tutto sul 100k (lo dice il verbale, §
> "attuazione a gradini").

---

## 1. 🅰️ GRADINO A — le soglie e il reset (preset)

File: `mql5/Presets/ABTG_Guardian_FTMO_2Step.set`

| riga | prima | dopo | perche' |
|---|---|---|---|
| `InpDailyLossPct` | `5.0` | **`4.9`** | emergenza un decimo PRIMA del muro FTMO del 5% |
| `InpTotalDDPct` | `10.0` | **`9.9`** | idem sul muro del 10% |
| `InpDailyResetHour` | `0` | **`23`** | 23:00 server BCM = 00:00 CET (BCM e' 1 ora indietro sull'ora italiana) |

Sopra `InpDailyResetHour` c'e' un blocco di commento che dichiara il valore
**[INCERTO]**: vale per il server BCM, resta da confermare col supporto FTMO
per iscritto quale fuso usino, e **su un altro server va ricalcolato**
(`InpDailyResetHour` = l'ora server che corrisponde a 00:00 del fuso FTMO;
cambia anche col passaggio ora legale/solare).

Aggiunte in coda al preset le righe dei gradini B e C:
`InpDailyPausePct=4.0`, `InpMaxOpenRiskPct=3.25`, `InpRiskMode=0`,
`InpWarnNoSL=true`.

## 2. 🅱️ GRADINO B — la pausa morbida (non chiude niente)

File: `mql5/Experts/ABTG_Guardian.mq5` (v1.00 -> **v1.10**)

**Input nuovo**: `InpDailyPausePct = 4.0` (0 = spenta).

Quando la **perdita giornaliera su equity** (la misura era gia' su equity:
`dailyLoss = dayStart - eq`) raggiunge la soglia, il guardiano **non chiude
e non cancella nulla**: chiama `SetPausa()` e scrive due GlobalVariable.

- `ABTG_PAUSA_GIORNO_<login>` = **timestamp di accensione** (si scrive una
  volta sola: e' un *latch*, non si spegne se l'equity risale).
- `ABTG_PAUSA_FINO_<login>` = **timestamp di scadenza** = prossimo reset
  giornaliero (`NextResetTime()`).

⚠️ **Perche' due variabili e non una** (scelta mia, da bocciare se non
piace): con la sola "ora di accensione", se il guardiano muore mentre la
pausa e' accesa **nessuno la spegne piu'** e la flotta resta ferma per
sempre. La scadenza rende la pausa **auto-estinguente** senza dipendere da
chi l'ha scritta. Il timestamp di accensione richiesto dal verbale c'e' lo
stesso ed e' quello che finisce nel log.

La pausa si accende **anche** quando scatta il blocco duro giornaliero o il
fallimento totale: se il guardiano sta chiudendo tutto, gli EA non devono
nemmeno provare a riaprire (prima si combattevano: l'EA apriva, il guardiano
richiudeva).

Azzeramento: al cambio di **giorno prop** (stessa riga del reset esistente)
e in `OnInit` quando il giorno e' cambiato a terminale spento.

**Battito**: `ABTG_GUARDIAN_BATTITO_<login>` viene riscritta con
`TimeCurrent()` **a ogni giro di timer (1 s)**, come prima istruzione di
`OnTimer`, e messa a **0** in `OnDeinit`. Serve agli EA per accorgersi che
il guardiano e' morto.

Extra informativo: `ABTG_RISCHIO_APERTO_<login>` = rischio aperto corrente in
%, sempre aggiornata (comoda per pannelli/raccolta, non decide niente).

## 3. 🅲 GRADINO C — il cap C1 sul rischio aperto (3,25%)

**Input nuovi**: `InpMaxOpenRiskPct = 3.25` (0 = spento), `InpRiskMode = 0`,
`InpWarnNoSL = true`.

`OpenRiskPct()` scorre **tutte** le posizioni del conto (qualsiasi magic: la
regola prop e' sul conto) e somma, per ognuna con SL, la perdita che si
materializzerebbe se lo SL venisse colpito, poi divide per l'equity.

- Il valore in valuta lo calcola **`OrderCalcProfit()`** (gestisce da solo
  contratto, tick e conversione valuta del conto). Solo se fallisce si
  ripiega sull'aritmetica `distanza/tick_size * tick_value * volume`.
- **`InpRiskMode=0` (default) = distanza INGRESSO -> SL**: e' la convenzione
  della misura M2 su cui e' tarato il 3,25% ("5 stop pieni vivi da 0,65%").
  Con lo SL portato a pareggio il contributo va a zero da solo.
- **`InpRiskMode=1` = distanza PREZZO CORRENTE -> SL**: "quanto posso ancora
  perdere da qui", la lettura piu' coerente col limite giornaliero su equity.
  ⚠️ **Le due letture danno numeri diversi**: il cap 3,25% e' tarato sulla
  prima. Cambiare modo senza rimisurare la soglia sarebbe cambiare due cose
  insieme.
- SL in profitto (posizione gia' blindata) -> contributo **0**, mai negativo:
  un profitto bloccato non "finanzia" altro rischio.

Quando il totale raggiunge la soglia scrive `ABTG_CAP_RISCHIO_<login>` = il
timestamp **rinfrescato a ogni secondo**; sotto soglia la rimette a 0. Cosi'
il cap **scade da solo** se il guardiano si spegne (fail-open: un cane da
guardia morto non deve bloccare la flotta a tempo indeterminato).

**Posizioni senza SL** = rischio **ignoto**: non entrano nella somma, **non
bloccano**, ma vengono contate e scritte nel Journal come warning ogni 5
minuti con ticket e simbolo (`[GUARDIAN] ATTENZIONE: N posizioni SENZA SL`).

Pannello: due righe nuove (`Pausa morbida`, `Rischio aperto: x% / cap y%`) e
il log periodico dei 5 minuti ora riporta `rischioAperto`, `pausa`, `cap`.

## 4. 🔌 Il contratto lato EA — l'include

File **nuovo**: `mql5/Include/ABTG_PausaGuardian.mqh` (nessuna dipendenza,
nessuna classe, include guard, nessun `#property` che possa sovrascrivere
quello dell'EA ospite).

```
#include <ABTG_PausaGuardian.mqh>
if(PausaGiornoAttiva()) return;   // pausa morbida B1
if(CapRischioAttivo())  return;   // cap C1
// oppure:  if(!ABTG_PuoAprire()) return;
```

- `PausaGiornoAttiva()` — pausa attiva e non scaduta.
- `CapRischioAttivo()` — cap attivo e "fresco" (tolleranza 120 s).
- `GuardianVivo()` — battito recente: per l'EA che vuole essere prudente
  ("se il cane da guardia non c'e', non apro"). Non e' un default.
- `RischioApertoPct()` — solo informativo.
- `ABTG_PuoAprire(pretendi_guardian=false)` — scorciatoia.

I nomi delle GlobalVariable sono **per conto** (suffisso login) come gia'
faceva il guardiano, cosi' due conti nello stesso terminale non si mischiano.
Sono scritti in due posti (EA e include): se si cambiano, si cambiano in
entrambi — c'e' il commento di avviso in tutti e due i file.

## 5. ✅ Retrocompatibilita'

- La logica di **lockdown** (chiudi tutto + blocca), `FlattenAll()`, il
  magic, il DD trailing/statico, la baseline giornaliera: **non toccati**.
- I due input nuovi **non chiudono e non impediscono nulla da soli**:
  scrivono GlobalVariable. **Nessun EA le legge ancora** (nessun EA e' stato
  modificato in questo lavoro), quindi sul conto **il comportamento oggi non
  cambia di una virgola** — tranne le soglie del preset (gradino A), che
  fanno scattare l'emergenza un decimo di punto prima.
- Ripulite due `·` non-ASCII gia' presenti nei commenti degli input (regola
  di casa: sorgenti in ASCII puro).

## 6. 🧪 Cosa deve fare Claudio — compilare e caricare sul DRY-RUN 100k

1. Copia `ABTG_Guardian.mq5` in `MQL5\Experts\` e
   **`ABTG_PausaGuardian.mqh` in `MQL5\Include\`** (senza l'include il
   guardiano compila lo stesso: l'include serve agli EA, dopo), poi apri il
   `.mq5` in MetaEditor e **F7**. Zero errori attesi; se ne esce uno,
   mandami il testo esatto della riga.
2. Sul **DEMO 100k del dry-run** (MAI sul conto vero), trascina il Guardian
   su un grafico qualsiasi e carica il preset
   `ABTG_Guardian_FTMO_2Step.set` (Input -> Load). Verifica sul pannello:
   `limite 4.9%`, `Pausa morbida (4.0%)`, `Rischio aperto: x% / cap 3.25%`.
3. Lascialo girare una giornata e guarda il Journal: devono comparire la riga
   d'avvio con `pausa morbida=4.00% cap rischio aperto=3.25%`, il log ogni 5
   minuti con `rischioAperto=`, e — se ci sono posizioni senza stop — il
   warning `posizioni SENZA SL`. Poi mandami quelle righe.

## 7. 🔜 Cosa resta da fare (NON e' in questo commit)

1. **Migrazione degli EA all'include** — decide Claudio quali e quando. E'
   una riga per EA, ma tocca file che girano in forward: si fa con la regola
   di casa (un EA per volta, magic separato, confronto).
2. **Prova vera sul 100k**: la pausa e il cap non sono mai scattati per
   davvero. Finche' non li vediamo accendersi e spegnersi in un giorno vero,
   sono codice, non regole in vigore.
3. **Verifica del fuso FTMO** (E1 del verbale): finche' non risponde il
   supporto, `InpDailyResetHour=23` resta [INCERTO].
4. **La scelta di `InpRiskMode`**: il default 0 e' quello coerente con la
   misura M2. Se si passa a 1, va rimisurata la soglia.
5. **Censimento dei contratti** (prerequisito della FIRMA 2): non c'entra col
   Guardian, ma senza quello la C3 resta inchiostro.

---

## DEPLOYMENT (18/08, in giornata)

- Installazione sul VPS con `installa_guardian.ps1` (hash `4bf741b`), riga
  verificata dal verificatore-stringhe (FAIL con correzioni applicate:
  referto sul Desktop, guardia sull'exit code, backup con guardia).
- **Trovati DUE Guardian su due grafici del 100k** — rimosso il doppione,
  lasciato UNO col preset nuovo (limite 4,9%). Regola nata sul campo:
  **UN Guardian per conto, sempre** (le GlobalVariable sono per-conto:
  due istanze si sovrascrivono a vicenda, e in emergenza chiuderebbero
  le stesse posizioni in doppio).
- In attesa di conferma visiva che giri la v1.10 (righe "Pausa morbida"
  e "Rischio aperto/cap" sul pannello = codice nuovo compilato, non solo
  preset nuovo su codice vecchio).
