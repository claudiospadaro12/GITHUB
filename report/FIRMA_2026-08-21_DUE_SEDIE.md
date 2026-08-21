# ✍️ FIRMA DI CLAUDIO — 21/08/2026: le due sedie senza contratto

> ## In chat, testuale: **"A, SU JPY, B SU NASDAQ"**

Risposta alle tre strade poste nella pagella del 21/08
(`report/giornata_2026-08-21.md` §5), sul buco formale trovato dal censimento
dei contratti del 18/08 (`report/CONTRATTI_SEDIE.md` §"LE SEDIE SENZA CONTRATTO").

| sedia | strada scelta | cosa vuol dire |
|---|---|---|
| **BREAKOUT_EA_JPY_v3** (USDJPY) | **(a) SPEGNERE** | via dal forward finche' non c'e' una misura che le dia una ragione |
| **ABTG_Nasdaq_Apertura_US** (NASUSD, 770201) | **(b) ROUND** | si spende un round per scriverle un contratto vero |

---

## 🔴 MA PRIMA — I DOCUMENTI DICEVANO IL CONTRARIO DEI FATTI

**Verificato sui censimenti dei `.chr`, non a memoria.** Le sette misure
agli atti in `backtest_pipeline/risultati_archivio/censimento_rischio_*.txt`:

| censimento | `ABTG_Nasdaq_Apertura_US` | `BREAKOUT_EA_JPY_v3` |
|---|---|---|
| 17/08 | ✅ presente (0,25%) | ✅ presente |
| 17/08 23:45 | ✅ presente | ✅ presente |
| **18/08 00:01** ← fonte di CONTRATTI_SEDIE | ✅ presente | ✅ presente |
| **18/08 09:41** | ❌ **SPARITA** | ✅ presente |
| 19/08 11:53 | ❌ assente | ✅ presente |
| 19/08 15:24 | ❌ assente | ✅ presente |
| **19/08 15:34** (ultima misura) | ❌ assente | ✅ **ANCORA PRESENTE** |

> ### 🎯 La situazione reale e' ESATTAMENTE INVERTITA rispetto a quello che c'e' scritto in giro:
> - **Il Nasdaq e' GIA' SPENTO** dal 18/08 mattina — sparisce fra il censimento
>   delle 00:01 e quello delle 09:41, cioe' **nella stessa esecuzione** della
>   FIRMA 5 (*"SPEGNILE TUTTE E TRE"*, verificata alle 09:41).
>   Ma `CONTRATTI_SEDIE.md` — scritto lo stesso giorno usando il censimento
>   delle **00:01**, cioe' la foto di **nove ore prima** — lo elenca ancora
>   fra le sedie accese. Ed e' da li' che l'ho preso io nella pagella di oggi.
> - **Il BREAKOUT JPY NON e' spento.** `report/STATO_QUATTRO_STRATEGIE_2026-08-21.md`
>   (di stamattina) scrive *"la vecchia BREAKOUT_EA_JPY_v3 e' SPENTA (era gia'
>   fantasma)"*. **Il suo `.chr` c'e' in tutti e sette i censimenti**, ultimo
>   compreso.

⚠️ **Limite dichiarato della misura**: il censimento legge i `.chr`, cioe' i
**template dei grafici salvati**. Un `.chr` presente prova che **il grafico con
quell'EA sopra esiste**, non che l'EA stia operando (Algo Trading potrebbe
essere spento, o l'EA staccato senza risalvare il profilo). Va nella stessa
riga: **nessun trade recente e' attribuibile al BREAKOUT JPY** — negli
statement del 21/08 non c'e' nessuna operazione su USDJPY, e la pagella del
19/08 ne attribuisce una alla PTE, non a lui. Quindi le due letture possibili
sono **"accesa e muta"** oppure **"`.chr` orfano"**, e si distinguono solo
guardando il VPS.

---

## ✅ COSA CAMBIA NELLE DUE DECISIONI (e cosa no)

**Nessuna delle due decisioni di Claudio viene ribaltata.** Cambia solo cosa
significano operativamente:

### (a) BREAKOUT_EA_JPY_v3 — **c'e' davvero da spegnerla**

Non era gia' fatta, come i documenti lasciavano credere. La decisione e'
**eseguibile e va eseguita**. Motivo, che resta quello scritto: famiglia
**scartata prima del progetto** (paniere 7 cross JPY 2022-24: **−20.853 €**,
PF **0,67-0,95 su TUTTE**, DD **30-48%**), della v3 **nessun referto esiste**,
e il torneo R82 del 18/08 ha chiuso il capitolo con **zero vincitori su 7
cross**.

### (b) ABTG_Nasdaq_Apertura_US — **il round non serve a tenerla accesa: e' gia' spenta**

Il round non decide se *tenerla*, decide se **RIACCENDERLA**. E' esattamente
la **porta di rientro** della C3 (*"una sedia spenta non e' cancellata —
rientra se una misura nuova le rida' una ragione"*). Sostanza identica —
serve un contratto vero prima che torni in campo — ma il round parte da
**sedia ferma**, quindi **non c'e' fretta e non c'e' rischio aperto** mentre
si misura.

📌 E questo **e' un vantaggio**, non un contrattempo: si puo' progettare il
round con calma, e la misura non compete con nessuna sedia viva.

---

## 🧯 LA LEZIONE, PERCHE' NON SUCCEDA ANCORA

**Un censimento invecchia in nove ore.** `CONTRATTI_SEDIE.md` e'
stato costruito su una foto delle 00:01 e pubblicato dopo le 09:41, quando
quella foto era gia' falsa su una riga. E `STATO_QUATTRO_STRATEGIE` ha
dichiarato spenta una sedia senza aprire il censimento.

**Regola che ne esce** (proposta, non ancora firmata): _qualunque documento
che elenca sedie ACCESE deve dichiarare in testa **quale censimento** sta
usando, con data e ora — e chi lo legge per decidere qualcosa deve
**rimisurare**, non fidarsi._

---

## 📋 STATO DELL'ESECUZIONE

- [ ] **(a)** censimento nuovo sul VPS → verificare se il `.chr` del BREAKOUT
      JPY e' ancora li' e se l'EA e' attaccato con Algo Trading attivo
- [ ] **(a)** rimozione della sedia + risalvataggio del profilo
- [ ] **(a)** censimento di controllo → la riga deve **sparire**
- [ ] **(b)** criteri del round Nasdaq, scritti e **firmati PRIMA dei numeri**
- [ ] correzione di `CONTRATTI_SEDIE.md` (Nasdaq: spenta dal 18/08) e di
      `STATO_QUATTRO_STRATEGIE_2026-08-21.md` (BREAKOUT JPY: non spenta)
