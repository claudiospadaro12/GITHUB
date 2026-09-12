# 🛡️ CHE COSA PROTEGGE DAVVERO IL GUARDIAN IN CAMPO — 12/09/2026

> **Da dove nasce.** `report/IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md` ha
> trovato che **il Guardian in campo ha 414 righe e nel repo ne ha 899**, e ha
> scritto la frase giusta: *"non sappiamo cosa contenga la versione che gira
> davvero, e finche' non lo sappiamo non possiamo dire che le protezioni
> firmate siano attive"*.
>
> 🎯 **Quella frase si puo' trasformare in un ELENCO, e senza toccare il VPS**:
> la versione in campo sta nella storia di git. Ecco l'elenco.

---

## 1. ✏️ CORREZIONE DI QUESTO STESSO REFERTO — "il campo" non e' UNO

🔴 **La prima stesura di questo file, di poche ore fa, diceva "il Guardian in
campo ha 414 righe" e lo trattava come UNA versione.** E' falso: i terminali
sono quattro e le versioni **tre**. Ed era gia' scritto nel log del runner
dell'11/09 (`CODA_06`), che porta la **`#property version`** — cioe'
**l'identificatore giusto** — mentre io avevo identificato la versione
**contando le righe**.

📌 **E' la classe del 10/09, un'altra volta: il file che aveva la risposta era
gia' li' e non l'ho aperto.** Il conteggio di righe non e' un identificatore;
la versione dichiarata lo e'.

> ✏️ **CORRETTO IL 12/09 STESSO — questa frase era MEZZA VERA.** Misurato
> poche ore dopo su tutte e 51 le sedie: **nemmeno la versione basta.**
> `ABTG_DAX_Apertura_EU` sul 100k e' **v1.01 come il repo** ma ha **2361
> righe contro 2367** e porta `ABTG_DEF_RISK 2.0` invece di `1.0`. E al
> contrario il `Guardian` del reale ha **386 righe di scarto** e
> comportamento **identico**.
> 👉 **Versione + righe INSIEME identificano il commit; ma per sapere se la
> differenza MORDE serve il DIFF.** E non e' la sua dimensione a decidere:
> `872dba8` e' **+11/-2 righe** e **raddoppia il lotto**.
> Misura: `report/IL_CAMPO_SEDIA_PER_SEDIA_2026-09-12.md`.

### La mappa vera, con DUE segnali indipendenti che concordano

| cartella dati | `#property version` | righe in campo | commit del repo | data | righe nel commit |
|---|---|---:|---|---|---:|
| tre terminali | **1.10** | **414** | `a53820e` | 18/08 | 413 |
| **il 100k 50504263** | **1.11** | **468** | `1f4c92b` | 19/08 | 467 |
| un terminale | **1.12** | **513** | `1b6a095` | 06/09 | 512 |
| *il repo di oggi* | *1.14* | *899* | `a21d0c0` | 08/09 | 899 |

🟢 **Versione e righe concordano in tutti e tre i casi**, con uno scarto
**costante di +1 riga** (la copia in campo ha una riga in piu': coerente con
una copia, non con un file diverso). 👉 **Due segnali indipendenti che
convergono: questa non e' piu' una candidata, e' un'identificazione.** La
prima stesura si fermava a uno, e lo dichiarava come tale.

### 🚨 E una cosa che la versione fa vedere e le righe no
Sui tre terminali a **1.10**, l'`.ex5` (il binario che gira davvero) e' datato
**09/08**, ma il sorgente accanto e' del **18/08**. 👉 **Il sorgente e' stato
copiato SENZA ricompilare: quello che gira e' ancora piu' vecchio di quello che
si legge nella cartella.** Due dei tre non hanno nemmeno un `.ex5`.
🔴 Quindi **leggere il `.mq5` in campo non dice che codice gira.** Lo dice la
data dell'`.ex5`, e per due terminali non c'e' affatto.

---

## 2. 🔴 LE PROTEZIONI CHE MANCANO — e la risposta e' la STESSA per ogni terminale

Confronto degli `input` dichiarati, versione per versione contro la 1.14 del
repo (**19 input**):

| versione in campo | input | manca |
|---|---:|---|
| **1.10** (tre terminali) | 15 | `InpMaxClusterRiskPct` · `InpClusterMappa` · `InpDailyBaseline` · `InpAutotest` |
| **1.11** (il 100k) | 16 | `InpMaxClusterRiskPct` · `InpClusterMappa` · `InpDailyBaseline` |
| **1.12** | 16 | `InpMaxClusterRiskPct` · `InpClusterMappa` · `InpDailyBaseline` |

> ## 🔴 **In TUTTE E TRE mancano gli STESSI TRE.** Quindi il verdetto non dipende da quale terminale si guarda: **nessun Guardian in campo puo' accettare il tetto per cluster, e nessuno puo' accettare `InpDailyBaseline`.**

👉 **Il 3,0% firmato il 07/09 non ha nemmeno l'input dove scriverlo.** Non e'
"spento": **non c'e' il posto**. E `InpDailyBaseline` e' un campo che la firma
del cap C2 richiede: **oggi il binario non lo accetterebbe.**

🟢 E nessuna regressione al contrario: nessuna manopola che il campo ha e il
repo no. Il campo e' un **sottoinsieme**, in tutte e tre le versioni.

📌 `InpAutotest` manca **solo** nella 1.10 — quindi la mia prima stesura, che
elencava **quattro** manopole, descriveva **il piccolo**, non "il campo".

---

## 3. ✏️ E QUI SI CORREGGE UNA RIGA DI `CLAUDE.md`

`CLAUDE.md` riga 142 dice, del tetto per cluster:

> *"🔴 E' FIRMATO MA NON ATTIVO: nel Guardian il tetto per cluster **non esiste
> ancora**."*

🔴 **La conclusione e' giusta, la ragione e' sbagliata — ed e' una differenza
che conta, perche' cambia cosa si deve fare per accenderlo.**

**Misurato nel sorgente del repo:**

| | |
|---|---|
| r.165 | `input double InpMaxClusterRiskPct = 0;  // CAP C2 ... Firma 07/09: 3.0` |
| r.471-472 | il tetto **per singolo cluster**, con ripiego sul tetto globale |
| r.631 | il cancello di accensione: `if(InpMaxClusterRiskPct>0 && StringLen(InpClusterMappa)>0)` |
| r.877 / r.896 | l'applicazione e il log, col nome del cluster peggiore |

👉 **Il tetto per cluster ESISTE ed E' IMPLEMENTATO.** Non e' un'intenzione nel
codice: e' codice.

### 🟡 Ma e' spento in **TRE modi indipendenti**, e ognuno e' una cosa diversa da fare

| # | perche' e' spento | che cosa serve per accenderlo |
|---|---|---|
| 1 | **default `0` = no-op assoluto** (dichiarato in testa al file, r.84) | un valore nel preset |
| 2 | 🔴 **nessuno dei due preset del Guardian lo accende** — verificato riga per riga: `ABTG_Guardian_FTMO_2Step.set` e `conto_reale/ABTG_Guardian_REALE.set` portano `InpMaxOpenRiskPct=3.25` (il cap **C1**) e **nessuna riga di cluster** | ✍️ **firma di Claudio**: e' un parametro di rischio |
| 3 | 🔴 **la versione in campo non ha nemmeno la manopola** (par. 2) | una **compilazione** sul terminale |

🟢 **Confronto onesto col cap C1 (3,25%), che invece e' VIVO**: implementato
**e** acceso in tutti e due i preset (`InpMaxOpenRiskPct=3.25`). Quindi la
macchina dei cap funziona: **e' il C2 che non e' stato acceso, non il
meccanismo che manca.**

### ✅ Come va detta la frase, da oggi
> *Il tetto per cluster al 3,0% e' **implementato** nel Guardian (repo,
> r.165/471/631/877) ma **spento in tre modi**: default 0, nessun preset lo
> valorizza, e la versione in campo non ha la manopola. Finche' i tre non
> sono chiusi resta **un'intenzione, non una protezione**.*

📌 **La cautela di `CLAUDE.md` resta in piedi tutta** — *"va detto ogni volta
che si cita"*. Cambia solo **che cosa** si deve dire: non *"va implementato"*
(e' fatto), ma *"va valorizzato e portato in campo"*. **E la prima delle due
cose e' una firma, non un lavoro.**

---

## 4. 🧭 E LA BUSSOLA

Questo referto **non consegna una sedia**. Consegna una cosa che serviva prima:
sapere **per nome** quali protezioni firmate NON sono in campo, invece di
scrivere *"non lo sappiamo"* ogni volta che si cita un muro.

🔴 **E consegna un fatto che pesa sulla challenge**: se la challenge parte con
il campo com'e', **il cap per cluster non protegge niente** — e i portafogli
larghi letti in casa hanno DD misurati del **32,6%** e **45,6%**. Il tetto
serviva proprio a quello.

⚠️ **Niente di tutto questo l'ho cambiato io**: i parametri di rischio e le
taglie sono di Claudio. Qui c'e' la misura, non la decisione.

---

*Tutto ricavato dal repo, in sola lettura. Nessun accesso al VPS, nessun
terminale toccato.*
