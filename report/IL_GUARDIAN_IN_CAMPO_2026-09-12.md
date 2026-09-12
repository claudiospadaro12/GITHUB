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

## 1. 🔍 QUALE VERSIONE GIRA — identificata, e con che forza

Storia delle righe di `mql5/Experts/ABTG_Guardian.mq5`:

| commit | data | righe |
|---|---|---:|
| `a21d0c0` | 08/09 | **899** ← il repo di oggi |
| `cdb2037` | 07/09 | 705 |
| `1b6a095` | 06/09 | 512 |
| `d884f7e` | 06/09 | 498 |
| `1f4c92b` | 19/08 | 467 |
| **`a53820e`** | **18/08** | **413** ← 👈 **il campo ne ha 414** |
| `6b9b8c3` | 31/07 | 208 |

👉 **Nessun'altra versione e' vicina a 414.** La piu' prossima e' `a53820e`
(18/08) a **una riga di distanza**.

⚠️ **E qui dichiaro la forza della prova, che non e' massima.** L'ho
identificata **per CONTEGGIO DI RIGHE**, non confrontando i byte: il file del
campo non e' nel repo. Un conteggio di righe **non e' un'impronta**. In piu'
il referto di ieri riporta la compilazione al **09/08**, che con un sorgente
del **18/08** non torna — probabilmente l'`.ex5` e' piu' vecchio del `.mq5`
copiato accanto (si copia senza ricompilare), ma **non l'ho misurato**.
🔴 **Quindi: candidata forte, non certezza.** La certezza costa una riga di
sola lettura sul VPS (impronta SHA del file in campo contro i blob di git), e
va chiesta.

🟢 **Ma la parte utile del verdetto NON dipende da quale delle due sia**: fra
`a53820e` (413) e `1f4c92b` (467) **le quattro manopole qui sotto mancano in
tutte e due**. L'elenco regge per qualunque versione di agosto.

---

## 2. 🔴 LE QUATTRO PROTEZIONI CHE IL CAMPO NON HA

Confronto degli `input` dichiarati: **campo 15, repo 19**. Le quattro che
mancano, **per nome**:

| manopola | che cos'e' |
|---|---|
| 🚨 **`InpMaxClusterRiskPct`** | **il CAP C2: tetto di rischio aperto per CLUSTER/valuta, firmato il 07/09 al 3,0%** |
| **`InpClusterMappa`** | la mappa dei cluster su cui quel tetto si applica |
| **`InpDailyBaseline`** | la linea di base giornaliera (serve ai muri sul DD del giorno) |
| **`InpAutotest`** | l'autotest del Guardian |

🟢 **E nessuna regressione al contrario**: non c'e' **nessuna** manopola che il
campo ha e il repo no. Il campo e' un sottoinsieme, non un ramo diverso.

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
