# 🔴 IL CANARINO DEL GUARDIAN ERA CIECO — diagnosi e riparazione (08/09/2026)

_Scritto dall'**agente MQL5** l'**08/09/2026**, branch `lavoro`.
Origine del rilievo: `report/GUARDIAN_BASELINE_GIORNALIERA_2026-09-08.md` §5.1
("**lo dico, non lo aggiusto**" — oggi lo aggiusto)._

> ## LA RIGA CHE SERVE A CLAUDIO, SUBITO
> **Cinque spie su sei del canarino guardavano caselle che non esistono più.**
> Il Guardian, dalla **v1.12 del 06/09/2026**, scrive le sue GlobalVariable
> interne con il suffisso `_V2`; il canarino cercava ancora i nomi **senza**.
> Corretto: ora **6 nomi su 6 combaciano**, verificati con un confronto
> testuale vero fra i due sorgenti (§5).
> ⚠️ **NON COMPILATO** qui (niente MetaEditor): la prova è l'F7 di Claudio.
> ⚠️ **Nessun Guardian, nessun EA, nessun preset, nessuna soglia toccati.**

---

# 1. ⏱️ DA QUANDO ERA CIECO

| fatto | data |
|---|---|
| Guardian **v1.12** — rename delle GV con `_V2` (commit `d884f7e`) | **06/09/2026, 14:22 UTC** |
| Canarino **v1.01** — ultima versione che cercava i nomi **vecchi** (`40cf70d`) | 02/09/2026 |
| Rilievo scritto ma non riparato (§5.1 del referto baseline) | 08/09/2026 |
| **Riparazione (questo lavoro), canarino v1.02** | **08/09/2026** |

👉 **Finestra di cecità: dal 06/09 pomeriggio all'08/09 — circa due giorni.**
Non è "un bug scoperto": è **uno strumento di controllo rimasto muto** proprio
nei giorni in cui il Guardian veniva modificato due volte (v1.12 baseline
dall'equità, v1.14 modo dichiarato). Il paradosso è tutto qui: **il rename
serviva a rendere onesta la misura, e ha spento chi la controllava.**

## Perché il rename esisteva (non è un errore del Guardian)
`ABTG_Guardian.mq5`, `OnInit`, righe **544-549**: il nome nuovo **forza** la
ricattura della baseline col criterio corretto (dall'equità) invece di
rileggere il numero vecchio persistito dalla v1.11. Le GlobalVariable
sopravvivono a riavvii e ricompilazioni: **senza cambiare nome, il fix non
sarebbe servito a niente.** La scelta del Guardian è giusta. **Sbagliato era
non aggiornare lo strumento che la legge.**

---

# 2. 🕳️ QUALI SPIE ERANO MORTE, E COSA NON AVREMMO VISTO

Le sei GlobalVariable **interne** del Guardian (quelle con cui misura la
challenge; le GV.1-GV.5 del **canale verso gli EA** NON sono state rinominate
e **non erano cieche**).

| spia | dove nel canarino | stato prima | **cosa NON avremmo visto** |
|---|---|---|---|
| `DAYSTART` (D-STA) | sez. 3, riga 607 | ❌ cieca | **la baseline della giornata**: il numero su cui si misura la perdita del giorno e la pausa B1. È esattamente l'oggetto del lavoro v1.12/v1.14 di questi due giorni: **non era verificabile** |
| `START` | sez. 3, riga 609 | ❌ cieca | il **saldo iniziale della challenge**, base dei limiti 4,9% / 9,9%. Se fosse stato catturato storto, il canarino non l'avrebbe detto |
| `PEAK` | sez. 3, riga 611 | ❌ cieca | il **picco di equity** (DD trailing con `InpDDMode=1`) |
| `DAYKEY` (D-KEY) | sez. 3, riga 582 | ❌ cieca **e peggio** | **quale giornata sta contando il Guardian** e **quale ora di reset usa** (0 o 23, firma del 18/08). Vedi §2.1: qui la cecità produceva un **allarme sbagliato**, non solo un silenzio |
| `BLOCKDAY` (GV.6) | sez. 4, riga 636 **e** autotest blocco 2, riga 381 | 🔴 **cieca, ed è la più pericolosa** | il **BLOCCO DURO**. Se resta timbrato con `InpAction=0` il Guardian **chiude tutto** al primo timer. Il canarino avrebbe stampato `0 = spenta` **anche con la bandiera alzata**: un "tutto a posto" falso sull'unica GV che può liquidare il conto |
| `FAILED` (FAIL) | sez. 3, riga 613 | ✅ **vedeva** | unica non rinominata: la sola lettura di cui potersi fidare |

## 2.1 ⚠️ Non era solo silenzio: poteva essere un ALLARME SBAGLIATO
Le GlobalVariable **persistono**. Su un terminale dove aveva girato il Guardian
**v1.11**, i nomi vecchi **esistono ancora**, con i **valori di allora**. Quindi
il canarino, in quei due giorni, poteva:
- leggere `DAYKEY` **vecchia** e confrontarla con la giornata di oggi → rilievo
  *"LA CHIAVE SCRITTA NON COMBACIA NÉ CON RESET 0 NÉ CON RESET 23"* → si sarebbe
  cercato un difetto **nell'ora di reset del Guardian**, che non c'era;
- oppure, su un terminale pulito, non trovarla e urlare *"IL GUARDIAN NON HA MAI
  SCRITTO LA CHIAVE DEL GIORNO SU QUESTO CONTO"* — allarme vero nella forma,
  **falso nella sostanza**: la chiave c'era, col nome nuovo;
- stampare **numeri vecchi come se fossero di oggi** (`START`, `PEAK`,
  `DAYSTART`). L'unico indizio era la colonna `modificata=`, che nessuno stava
  guardando come cancello.

🔴 **Un referto del canarino datato 06/09 - 08/09 non è utilizzabile** per le
cinque righe qui sopra. Va riletto con questa chiave: `esiste=NO / grezzo=0`
**non voleva dire "bandiera spenta", voleva dire "casella sbagliata"**.

---

# 3. 🔧 IL DIFF

File toccati: **due**, nessuno dei quali gira in campo.
`mql5/Scripts/ABTG_CanarinoGuardian.mq5` (script di **sola lettura**) e
`backtest_pipeline/attese_enforcement_fase1.txt` (artefatto di attese).
**Nessun Expert, nessun preset, nessun `.ini`.**

## 3.1 I sei punti che cercavano il nome sbagliato
I nomi non si scrivono più a mano in sei posti diversi: si costruiscono in
**uno solo** (`NomeGuardInterna`), che è la ragione per cui il difetto era
possibile — sei copie separate si aggiornano una per una, e una si dimentica.

```
-#define ART_GV6 "ABTG_GUARD_50504263_BLOCKDAY"
+#define ART_GV6 "ABTG_GUARD_50504263_BLOCKDAY_V2"

+string NomeGuardInterna(const long login,const string radice,const string suffisso)
+  { return(StringFormat("ABTG_GUARD_%I64d_%s%s",login,radice,suffisso)); }

-   string b2_blockday=StringFormat("ABTG_GUARD_%I64d_BLOCKDAY",login);      // riga 381
+   string b2_blockday=NomeGuardInterna(login,"BLOCKDAY",CANARINO_SUFFISSO_V2);
-   string nDayKey=StringFormat("ABTG_GUARD_%I64d_DAYKEY",login);            // riga 582
+   string nDayKey=NomeGuardInterna(login,"DAYKEY",CANARINO_SUFFISSO_V2);
-   RigaGV("D-STA",StringFormat("ABTG_GUARD_%I64d_DAYSTART",login),3,        // riga 607
+   RigaGV("D-STA",NomeGuardInterna(login,"DAYSTART",CANARINO_SUFFISSO_V2),3,
-   RigaGV("START",StringFormat("ABTG_GUARD_%I64d_START",login),3,           // riga 609
+   RigaGV("START",NomeGuardInterna(login,"START",CANARINO_SUFFISSO_V2),3,
-   RigaGV("PEAK", StringFormat("ABTG_GUARD_%I64d_PEAK",login),3,            // riga 611
+   RigaGV("PEAK", NomeGuardInterna(login,"PEAK",CANARINO_SUFFISSO_V2),3,
-   RigaGV("FAIL", StringFormat("ABTG_GUARD_%I64d_FAILED",login),4,          // riga 613: era GIA' GIUSTA
+   RigaGV("FAIL", NomeGuardInterna(login,"FAILED",""),4,
-   RigaGV("GV.6",StringFormat("ABTG_GUARD_%I64d_BLOCKDAY",login),2,         // riga 636
+   RigaGV("GV.6",NomeGuardInterna(login,"BLOCKDAY",CANARINO_SUFFISSO_V2),2,
```

📌 La riga 613 (`FAILED`) è passata da `StringFormat` alla funzione **senza
cambiare il nome cercato**: era già corretta, ora è corretta **nello stesso
posto delle altre cinque**.

## 3.2 🆕 LA SPIA CHE IMPEDISCE IL BIS — nuova sezione "4b"
Il difetto vero non è "un nome sbagliato": è che **un rename ha reso muto lo
strumento senza un solo messaggio**. La riparazione, da sola, non impedisce
che risucceda al prossimo `_V3`. Quindi il canarino ora, **per ognuna delle
sei**, guarda **anche il nome VECCHIO**:

```
[CANARINO] 4b) SPIA DEL RENAME -- esistono ancora GlobalVariable col nome VECCHIO (senza _V2)?
```
- nome vecchio **presente e diverso da 0** → **RILIEVO** (maiuscolo, ripetuto
  nel riepilogo): *"trovata la GV col nome VECCHIO '…' (valore …, modificata …):
  su questo terminale gira — o ha girato — una versione del Guardian PRECEDENTE
  alla v1.12"*, **con accanto il nome di oggi**;
- nome vecchio presente ma **a 0** → riga informativa (residuo spento, si
  cancella da F3), **non** un rilievo;
- **assente** → riga che lo dichiara: coerente con un Guardian v1.12+.
- **`FAILED`**: il controllo si stampa come **NON APPLICABILE** e si spiega
  perché — vecchio e nuovo sono lo **stesso** nome, cercare il "vecchio" darebbe
  un **falso positivo garantito** ogni volta che la bandiera è scritta. Un
  controllo che grida sempre è rumore, e il rumore è come si torna ciechi.

## 3.3 Cosa NON è stato toccato (verificato, non promesso)
❌ Nessun cambio a: logica dei rilievi esistenti, soglie, frasi cercate nei log
(`ART_TESTO_B1`, `ART_TESTO_C1`, `PRE.*`, `C5.*`-`C9.*`), `ABTG_GVNome` e le
GV.1-GV.5 del canale, `CANARINO_BLOCCHI_ATTESI` (**resta 8**: non ho aggiunto
blocchi d'autotest), numerazione delle sezioni 1-11 (la nuova è **4b**, non un
"12" che avrebbe spostato i numeri del verbale), invarianti dell'artefatto
(nessun ordine, nessuna scrittura di GlobalVariable, prefisso `[CANARINO]` su
ogni riga, token `*** ROSSO CANARINO ***`).
`#property version` **assente → "1.02"**, `CANARINO_VERSIONE` **v1.01 → v1.02**,
nota di versione in testata nello stile del file.

---

# 4. 📜 LA DECISIONE SULL'ARTEFATTO — aggiornato, e dichiarato dentro

**Il problema, riconosciuto:** `ART_GV6` nel canarino è una **copia a mano**
della riga `GV.6` di `backtest_pipeline/attese_enforcement_fase1.txt`, e
l'autotest **blocco 2** confronta i nomi generati con quelle copie. Aggiornare
**solo il canarino** avrebbe fatto scattare *"BLOCCO 2 FALLITO: 1 nome su 6 non
combacia — RENAME SILENZIOSO DELL'INCLUDE"*: **un allarme vero nella forma e
falso nella sostanza**, sul rename **già noto e già recepito**. È il modo
migliore per insegnare a ignorare un allarme.

## ✅ DECISIONE: aggiornati **entrambi**, nello stesso commit, e l'artefatto lo dichiara al suo interno
Riga `GV.6` → `ABTG_GUARD_50504263_BLOCKDAY_V2`, seguita da un **blocco di nota
firmato e datato** dentro il file stesso (non di nascosto), che scrive: cosa è
cambiato, **perché** (v1.12 del 06/09, rename voluto), che le **GV.1-GV.5 del
canale NON sono toccate**, che **nessuna riga ATTESA/VIETATA/CAMPO e nessun
criterio cambia**, che le due copie devono restare allineate, e **come si
rileggono i referti vecchi**.

⚖️ **Perché toccarlo è legittimo e conservativo**: quel file è un **elenco di
attese**, e la riga GV.6 non è un'attesa — è **documentazione operativa** (il
nome da cercare in F3). L'unica cosa che cambia è **un nome che nel terminale
non esiste più**. **Zero criteri toccati**: la parte che fa cancello (righe
`ATTESA` / `VIETATA` / `CAMPO`) è **bit per bit la stessa**.

⚠️ **Il rovescio, dichiarato:** un artefatto di attese congelate che viene
modificato è, di per sé, un rischio. La mitigazione è che **la modifica si
legge nel file**, con data, autore e motivo: chi rileggerà un referto del
02-08/09 troverà scritto **perché** i numeri di allora dicevano quello che
dicevano. Un file "congelato ma sbagliato" non protegge nessuno: mente e basta.

---

# 5. ✅ LA VERIFICA — confronto TESTUALE fra i due sorgenti (non a memoria)

Metodo: uno script legge `ABTG_Guardian.mq5`, estrae le assegnazioni
`GV_… = StringFormat("ABTG_GUARD_%I64d_…", acc)` di `OnInit`, e le confronta
con le chiamate `NomeGuardInterna(login,…)` di `ABTG_CanarinoGuardian.mq5`,
rendendo entrambe col login del collaudo **50504263**.

| # | il Guardian **SCRIVE** | il canarino **CERCA** | esito |
|---|---|---|---|
| 1 | `ABTG_GUARD_50504263_START_V2` | `ABTG_GUARD_50504263_START_V2` | ✅ COINCIDONO |
| 2 | `ABTG_GUARD_50504263_PEAK_V2` | `ABTG_GUARD_50504263_PEAK_V2` | ✅ COINCIDONO |
| 3 | `ABTG_GUARD_50504263_DAYKEY_V2` | `ABTG_GUARD_50504263_DAYKEY_V2` | ✅ COINCIDONO |
| 4 | `ABTG_GUARD_50504263_DAYSTART_V2` | `ABTG_GUARD_50504263_DAYSTART_V2` | ✅ COINCIDONO |
| 5 | `ABTG_GUARD_50504263_BLOCKDAY_V2` | `ABTG_GUARD_50504263_BLOCKDAY_V2` | ✅ COINCIDONO |
| 6 | `ABTG_GUARD_50504263_FAILED` (senza `_V2`) | `ABTG_GUARD_50504263_FAILED` | ✅ COINCIDONO |

**6 su 6.** Controlli aggiuntivi passati:
- **residui**: `0` occorrenze di nomi `ABTG_GUARD_%I64d_…` costruiti a mano nel
  canarino (prima erano 7) → non può restarne indietro uno;
- `ART_GV6` (canarino) **==** riga `GV.6` (artefatto) **==** nome scritto dal
  Guardian per `BLOCKDAY`;
- `ART_GV1`…`ART_GV5` **==** righe `GV.1`…`GV.5` dell'artefatto (invariati);
- **ASCII puro**: `0` caratteri non-ASCII in entrambi i file (niente emoji);
- **parentesi bilanciate** su codice ripulito di stringhe e commenti:
  `{}` 54/54, `()` 652/652, `[]` 59/59, profondità finale 0, mai negativa;
- `NomeGuardInterna` è **definita prima** di ogni suo uso (MQL5 lo pretende).

---

# 6. ⚠️ QUELLO CHE NON È STATO FATTO

- 🔴 **NON COMPILATO.** Qui non c'è MetaEditor: nessun `.ex5`, nessun warning
  letto. Solo controlli statici (§5). **La prova è l'F7 di Claudio.**
- 🔴 **NON ESEGUITO.** Il canarino v1.02 non ha ancora letto nessun terminale:
  la tabella §5 dice che i nomi **combaciano nel sorgente**, non che sul VPS le
  GV esistano. Quello lo dirà la prima corsa.
- ✅ **NON toccati**: `ABTG_Guardian.mq5`, `ABTG_PausaGuardian.mqh`, gli EA in
  forward, i preset, i `.ini`, le soglie (pausa 4,0 / emergenza 4,9 e 9,9 /
  reset 23), il cap C1 3,25%.

## 📋 Cosa deve fare Claudio, in ordine
1. **F7** su `mql5/Scripts/ABTG_CanarinoGuardian.mq5` in MetaEditor → 0 errori.
   ⚠️ **Nota sul divieto `NO.5`** dell'artefatto ("in fase 1 non si ricompila
   nulla"): quel divieto protegge **i binari in campo** (Guardian ed EA). Il
   canarino è uno **script di sola lettura che non sta su nessun grafico**:
   ricompilarlo non tocca nessun binario in campo. **Lo segnalo perché la
   decisione è di Claudio, non mia.**
2. Lanciarlo **a mano** sul **demo 50503392** (cartella `BCM Markets MT5
   Terminal`) — trascinare su un grafico qualsiasi, OK.
3. Nel referto `MQL5\Files\ABTG_Canarino_*.txt` leggere:
   - **sezione 3**: `D-STA`, `START`, `PEAK`, `D-KEY` ora devono avere
     `esiste=SI` e numeri sensati (se il Guardian gira lì);
   - **sezione 4b**: quali nomi **vecchi** sono rimasti popolati sul terminale;
   - **sezione 10, AUTOTEST 2**: deve dire `PASS (0 differenze)` — sul 50504263;
     sul 50503392 dirà **SOSPESO**, che non è un PASS (è per disegno).
4. Ripetere sul **100k 50504263** (cartella `… -V3`).
5. Sul **REALE 10105439** (`C:\BCM_Reale`) **solo se Claudio lo decide**: lo
   script non manda ordini e non scrive nulla, ma sul reale non si tocca niente
   senza la sua firma.

---

# 7. 🧠 LA LEZIONE (che vale più della riparazione)

**Uno strumento di controllo che dipende da nomi copiati a mano si spegne al
primo rename, e si spegne in SILENZIO.** Non ha dato errore, non ha dato un
avviso: ha continuato a stampare righe pulite e rassicuranti per due giorni.

Le due difese messe oggi:
1. **una sola sorgente per i nomi** (`NomeGuardInterna`) — non si può più
   dimenticare "una copia su sei";
2. **la spia 4b** — un rename futuro **si vede**, perché il canarino va a
   cercare **anche** il nome che non dovrebbe più esistere.

🔴 E la regola generale, da tenere: **a ogni rename di GlobalVariable nel
Guardian, si aggiorna il canarino NELLO STESSO COMMIT.** Il Guardian è la
protezione della challenge; il canarino è **l'unico modo che abbiamo di sapere
se la protezione è viva**. Un Guardian perfetto con un canarino cieco è un
sistema **non verificato** — e a ottobre, sulla prop, "non verificato" e
"non protetto" valgono la stessa cifra.
