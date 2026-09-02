# 🛡️🧪 COLLAUDO DELL'ENFORCEMENT — FASE 1 della migrazione 100k

_Deliverable della **fase 1** di `report/PIANO_MIGRAZIONE_100K_2026-08-31.md`
(§4): «zero sedie nuove: si collauda il Guardian-enforcement (i 9 criteri
congelati) sui 5 mirror esistenti». E' l'esecuzione dell'**opzione (b)** del §2
di quel piano — l'enforcement come **cancello della fase 2**._

> ⚠️ **LIMITE OPERATIVO DICHIARATO SUBITO.** Questa sessione **non compila e non
> fa backtest**: niente MetaEditor, niente Strategy Tester, nessun accesso al
> VPS. Qui c'e' **revisione statica del meccanismo + piano operativo + artefatti
> di verifica**. Ogni gesto in campo lo fa **Claudio a mano**, con la **legge
> dello screenshot**. Nessuna riga qui dentro dice "funziona": dicono "e'
> coerente col codice letto" e "si prova cosi'".
>
> 🛑 **In questo giro NON e' stato toccato nessun `.mq5`, nessun `.mqh`, nessun
> `.set`, nessun grafico, nessun EA vivo, nessun forward.** I difetti trovati
> sono **RILIEVI con proposta** (§6): decide Claudio.

---

## 0️⃣ LO STATO MISURATO OGGI (fatti dal repo, non ricordi)

| fatto | misura | dove l'ho letto |
|---|---|---|
| I 5 mirror + Guardian sul 100k sono **compilati dal pin `d0241ff`** il 19/08 ore 23:10, 6 su 6, "0 errors, 0 warnings" | 6 file | `guardian_REFERTO_BLOCCO4_100K_2026-08-19.txt` + esiti in fondo al referto 19/08 |
| DAX_Apertura_EU · Dow_Apertura_US · MaxMinNotte_DAX_Short_Ott · SupertrendReversal · Guardian: **sorgente a `d0241ff` IDENTICO a HEAD** (`git rev-parse` sui blob) | 5 su 6 identici | verifica fatta oggi |
| **ABTG_ORB_Ottimizzato: campo ≠ HEAD.** Dopo il pin e' arrivato `3125e34` (19/08 15:27 UTC, v1.02 `InpSLBufferPts`, **default 0 = neutro**). Il binario sul 100k **non ha** quella riga | 1 su 6 divergente | vedi **R6** |
| L'include compilato dentro quei 6 binari e' la **v1.20**; in repo oggi c'e' la **v1.40** (P1 perdite consecutive 22/08 + S1 stop a obiettivo 23/08) | 3 commit di scarto | `git log` su `ABTG_PausaGuardian.mqh` |
| 🔑 **Il nucleo di decisione B1/C1 e' IDENTICO fra v1.20 e v1.40** — confronto funzione per funzione: `ABTG_PausaAttiva_Calc`, `ABTG_CapAttivo_Calc`, `ABTG_GuardianVivo_Calc`, `ABTG_MotivoStop_Calc`, `ABTG_GVNome`, `ABTG_CanaleEsiste` **tutte e sei identiche byte a byte** | 6/6 identiche | verifica fatta oggi — **e' la ragione per cui NON serve ricompilare, §2.0** |
| Punti d'innesto della guardia **sui 5 mirror**: 18 | 7 DAX + 7 Dow + 1 MaxMin + 2 ORB + 1 STREV | vedi **Appendice B** |
| Il filo e' **vivo sul 100k**: `[GUARDIAN] filo verificato: 5 GlobalVariable su 5 ... (conto 50504263)` letto in campo il 19/08 23:10 | 5/5 | referto 19/08, verifica dopo il riavvio |
| Rischio aperto letto dal Guardian sul 100k quella sera | **0,00%** | foto del pannello, 19/08 23:06 |

---

## 1️⃣ I NOVE CRITERI CONGELATI — citati, non riscritti

Fonte unica e non modificabile: `backtest_pipeline/risultati_archivio/REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md`,
tabella «📋 Criteri di successo — CONGELATI PRIMA DELLA PROVA».
🔴 Regola che resta in vigore: **sono tutti e nove obbligatori, uno solo che
fallisce ferma la migrazione.**

| # | criterio (testo congelato) | stato | riferimento agli atti |
|---|---|---|---|
| 1 | «49/49 file compilano, 0 errori» | ✅ **VERDE 19/08 15:43** | `guardian_REFERTO_FASE0_2026-08-19.txt` — 49/49 compilati ADESSO; i 2 warning su PTE erano **pre-esistenti** al pin `2458b33` |
| 2 | «autotest: 19/19 casi PASS» | ✅ **VERDE 19/08 15:49-15:52** (PC di backtest, conto 50503392, Guardian **disarmato**) | referto 19/08 §ESITI. ⚠️ vedi **R5**: su HEAD i casi oggi sono **75**, non 19 |
| 3 | «filo verificato: 5/5 nomi coincidono» | ✅ **VERDE due volte**: 19/08 15:49 sul PC (50503392) **e** 19/08 23:10 sul **100k (50504263)** | referto 19/08, §VERIFICA FINALE DOPO IL RIAVVIO |
| 4 | «backtest identico al centesimo prima/dopo» | ✅ **VERDE 19/08 15:56** — 8 confronti su 8 identici (Profit, PF, Equity DD %, Trades), ricontrollati con diff byte-a-byte | `guardian_REFERTO_CRITERIO4_2026-08-19.txt` |
| 5 | «pausa B1: il giornale dell'EA la nomina e l'ordine non parte» | 🟡 **DA COLLAUDARE** | procedura §2.3 |
| 6 | «posizioni aperte gestite normalmente durante la pausa» | 🟡 **DA COLLAUDARE** | procedura §2.4 |
| 7 | «cap C1: l'ingresso in eccesso viene rifiutato» | 🟡 **DA COLLAUDARE** | procedura §2.5 |
| 8 | «fail-open: Guardian rimosso → la flotta riparte entro ~2 min» | 🟡 **DA COLLAUDARE** | procedura §2.6 |
| 9 | «3 giorni di dry-run senza blocchi inspiegati» | 🟡 **DA COLLAUDARE** | procedura §2.7 |

📌 **Nota sui criteri 1-4:** sono verdi **sui binari che sono in campo oggi**
(include v1.20). Non sono verdi "per sempre": se un giorno si ricompila su
HEAD, **il 4 va rifatto** — e' il senso stesso del criterio 4.

---

## 2️⃣ LE PROCEDURE, CRITERIO PER CRITERIO

### 2.0 🔧 LA DOMANDA CHE VIENE PRIMA: serve RICOMPILARE i 5 mirror?

**Risposta misurata: NO. Per i criteri 5-9 la ricompilazione NON serve, e
conviene NON farla.** Tre ragioni, tutte verificabili:

1. **I binari in campo GIA' chiamano la guardia.** I 6 `.ex5` del 100k sono
   compilati dal pin `d0241ff`, che **contiene la migrazione**; nei sorgenti a
   quel pin i 5 mirror hanno **18 punti** `ABTG_GuardiaIngresso(...)` (Appendice B)
   e l'input `InpUsaGuardian = true` di default. Non c'e' niente da collegare:
   e' gia' collegato.
2. **La semantica B1/C1 non e' cambiata da allora.** Le sei funzioni che
   decidono (nucleo + nomi delle GV + esistenza del canale) sono **identiche
   byte a byte** fra la v1.20 compilata dentro i binari e la v1.40 di HEAD.
   Le novita' v1.30/v1.40 (freno P1, stop S1) entrano **solo** con argomenti
   in coda che nessuno dei 5 mirror passa: a default sono **no-op puri**
   (`ABTG_GuardiaIngresso` righe 1015-1027 di HEAD). Quindi ricompilare non
   cambierebbe il comportamento sotto collaudo — cambierebbe **solo** il rischio.
3. **Ricompilare COSTA un criterio.** Il criterio 4 (backtest identico) e'
   verde **su quei binari**. Sostituirli con altri, compilati da HEAD, invalida
   la prova: si dovrebbe **rifare il 4** prima di rimetterli in campo. E su
   ORB si porterebbe dentro anche `v1.02 InpSLBufferPts` (default neutro, ma
   "neutro" e' un'ipotesi finche' non la misura il tester, **R6**).

> 🎯 **Decisione proposta a Claudio (D1): fase 1 SENZA ricompilazioni. Zero
> `.mq5` toccati, zero `.ex5` riscritti, zero `.set` cambiati.** Si collauda
> **esattamente il software che sta in campo** — che e' anche l'unica cosa che
> il collaudo deve dimostrare.

**SE INVECE Claudio vuole allineare il 100k a HEAD** (serve solo per accendere
un giorno P1/S1, o per la proposta P1-pendenti di `CONFIG_PROP` §5), allora
**e' un round SEPARATO, non la fase 1**, e l'ordine e' questo — un file per
volta, con la sua verifica, **fuori sessione** (mai 08:00-22:00 server) e col
terminale `-V3` chiuso da _File > Esci_:

| ordine | file | perche' proprio li' | verifica post-compilazione (fa fede) |
|---:|---|---|---|
| 0 | *(nessun file)* backup | regola di casa | esiste `<nome>.mq5.prima_migrazione` accanto a ogni file (il BLOCCO 4 del 19/08 li ha gia' creati: **non sovrascriverli**) |
| 1 | `MQL5\Include\ABTG_PausaGuardian.mqh` | e' il file che tutti includono: se e' tronco, tutto il resto fallisce | marcatore **`v1.40`** presente nel file (⚠️ il vecchio controllo cercava `v1.20`, **R5**) |
| 2 | `ABTG_Guardian.mq5` | e' **lo scrittore**: se il filo si e' rotto, deve urlare **prima** che si tocchino i lettori | log `Result: 0 errors, 0 warnings` + al riavvio `[GUARDIAN] filo verificato: 5 GlobalVariable su 5 ... (conto 50504263)` |
| 3 | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` | 1 solo punto: il caso piu' semplice, si sbaglia per primo dove costa meno | 0 errori + all'avvio la riga `[MaxMinNotte] avviato su D30EUR...` |
| 4 | `ABTG_SupertrendReversal.mq5` | 1 punto | 0 errori + `[STReversal] avviato su 225JPY PERIOD_H2` |
| 5 | `ABTG_ORB_Ottimizzato.mq5` | 2 punti — 🔴 **e qui entra v1.02**: da NON fare senza aver prima rifatto il criterio 4 su questo EA | 0 errori + `[ORB_OTT] avviato su U30USD...` + nella finestra parametri compare `InpSLBufferPts` **a 0** |
| 6 | `ABTG_DAX_Apertura_EU.mq5` | 7 punti, uno dei due "grossi" | 0 errori + `[DAX Apertura EU] avviato su D30EUR ... motore=ABTG_RETEST` |
| 7 | `ABTG_Dow_Apertura_US.mq5` | 7 punti | 0 errori + `[Dow Apertura US] avviato su U30USD ... motore=ABTG_RETEST` |

E in ogni caso, per **tutti e 7**: `.ex5` con timestamp **di adesso** (un `.ex5`
di ieri non e' una compilazione riuscita — cancello gia' usato nel BLOCCO 1 del
19/08) e, alla riapertura, `InpUsaGuardian` visibile e **true** nella scheda
Parametri di ogni EA (legge dello screenshot).
🛑 **I `.set` e i grafici li tocca solo Claudio: nessuna procedura qui sopra li
modifica.**

---

### 2.1 🧭 PREREQUISITI COMUNI a tutte le prove (si fanno UNA volta, prima)

| # | gesto | cosa deve risultare | perche' |
|---|---|---|---|
| P-1 | `conto_attivo.ps1` sull'istanza `-V3` | **50504263** | prerequisito (c) della fase 0 del piano; se esce un numero diverso, **tutto il resto e' teatro**: le GlobalVariable portano il login nel nome (`ABTG_CAP_RISCHIO_<login>`) e su un conto nuovo il canale **non esiste** → fail-open silenzioso |
| P-2 | menu **Finestra** dell'istanza `-V3`: contare i Guardian | **UNO SOLO** | regola B9. Due Guardian sullo stesso conto si timbrano addosso a vicenda |
| P-3 | screenshot del pannello Guardian **PRIMA** | soglie **4,9 / 9,9 / pausa 4,0 / cap 3,25**, `Azione: CHIUDI+BLOCCA` | e' la foto "prima" contro cui si confronta il "dopo". La foto del 19/08 23:06 e' agli atti nel referto: serve quella **di oggi** |
| P-4 | annotare **saldo, equity, perdita del giorno in %** dal pannello | tre numeri | senza il `dailyPct` di adesso **non si puo' scegliere la soglia** della prova 5 (§2.3) |
| P-5 | annotare **quante posizioni aperte** ha il 100k e il `Rischio aperto: X%` del pannello | due numeri | senza almeno **una posizione aperta con SL** il criterio 7 **non e' innescabile** (**R1**) |

⏰ **E la regola dell'orologio (CLAUDE.md):** le schede **Esperti/Giornale sono
in ora LOCALE del VPS** (= ora italiana), il **grafico e' in ora SERVER** (=
italiana − 1). Le finestre operative qui sotto sono in **ora SERVER**; nel log
le si cerca **un'ora dopo**. Chi confronta le due ore senza saperlo conclude
sempre la cosa sbagliata (successo il 06/08).

🕐 **Le finestre in cui i 5 mirror TENTANO davvero di entrare** (server), letto
dalle righe di avvio del 19/08:

| ora server | chi | funzione che ospita la guardia |
|---|---|---|
| **07:59** | MaxMinNotte DAX short (box 23:00-04:59, piazza 07:59) | `TryPlace()` — 🥇 **il tentativo piu' regolare della giornata** |
| 08:00 → 08:35 e oltre (flat 17:30) | DAX Apertura EU, `motore=ABTG_RETEST` | `MonitorRetest()` (2 punti) |
| 14:30 → 15:05 e oltre (flat 17:30) | Dow Apertura US, `motore=ABTG_RETEST` | `MonitorRetest()` (2 punti) |
| 14:30-14:45 → ingresso, fine 21:00 | ORB Ottimizzato | `TryPlace()`, `TryCloseConfirmEntry()` |
| chiusura di ogni barra **H2** | SupertrendReversal 225JPY | `Enter()` |

---

### 2.2 🔴 LA DIFFICOLTA' CENTRALE, detta prima delle procedure

**La guardia sta immediatamente PRIMA dell'invio dell'ordine** (regola di casa
del 19/08, §1.3 trappola 1). Conseguenza che decide tutto il collaudo:

> **La riga `[GUARDIA] ... INGRESSO BLOCCATO` compare SOLO se, mentre la
> bandiera e' alzata, un EA aveva davvero deciso di entrare.** Non esiste un
> modo di "forzare un tentativo d'ingresso" dall'esterno.

Da qui due fatti scomodi e onesti:

- **il silenzio nei log NON e' una prova.** Zero righe `[GUARDIA]` in una
  settimana e' compatibile sia con "l'enforcement funziona e non e' mai servito"
  sia con "l'enforcement e' morto";
- **le prove 5, 7 e 8 sono opportunistiche**: si presidia una finestra in cui
  un ingresso e' probabile e si guarda. La finestra piu' affidabile e' **07:59
  server (MaxMin)**, perche' quel `TryPlace()` viene chiamato tutti i giorni.

📌 **Ecco perche' in §6 c'e' la proposta P-C1 (il "canarino"):** un pezzo di
codice di **sola lettura** che chiama la guardia a comando e stampa, senza
poter mandare **nessun** ordine. E' l'unico modo di rendere i criteri 5/7/8
**deterministici** invece che fortunati. **Non l'ho scritto** (in questo giro
non si tocca codice): e' una proposta, decide Claudio.

⚖️ **E il costo va detto:** un blocco forzato dentro una finestra utile **fa
perdere quel trade, non lo rimanda** (limite noto n.2 del referto 19/08). Il
collaudo costa **1-2 trade del dry-run**, e vanno **annotati nella pagella del
giorno**, altrimenti M27 e H5 misurano un buco senza sapere che e' nostro.

---

### 2.3 🅱️1 CRITERIO 5 — «la pausa che morde»

**Cosa si vuole dimostrare:** che quando il Guardian alza la bandiera di pausa,
un EA del 100k **la nomina nel giornale e non manda l'ordine**.

**Precondizione fisica (dal codice, `ABTG_Guardian.mq5` riga 400):**
`if(InpDailyPausePct>0 && dailyPct>=InpDailyPausePct)`. Siccome
`InpDailyPausePct = 0` significa **spenta**, la pausa e' innescabile **solo se
la giornata e' in perdita** di una frazione qualsiasi. 🔴 **Se il pannello (P-4)
mostra `Perdita oggi` ≤ 0, la prova NON si puo' fare oggi: si rimanda.**
_(Nel 19/08 la giornata era a −0,12%: sarebbe bastato mettere 0,1.)_

**Passi (in quest'ordine, e uno alla volta):**

1. **Scegliere la finestra.** Consigliata: **prima delle 07:59 server** (=
   08:59 italiane), cosi' il tentativo del MaxMin cade dentro la pausa. In
   alternativa 08:00-08:35 (DAX) o 14:30-14:45 (ORB).
2. Sul grafico del **Guardian** (istanza `-V3`): finestra parametri →
   **`InpDailyPausePct`** = un valore **appena sotto** la perdita del giorno
   letta in P-4 (es. giornata −0,12% → **0,10**). **Non toccare nient'altro.**
   🛑 **`InpDailyLossPct` NON si tocca MAI** (→ **R3**: e' la leva che chiude
   tutto il conto).
3. Attendere **un giro di timer (1 s)** e fotografare il pannello: deve dire
   `Pausa morbida (0.1%): ATTIVA (stop nuovi ingressi)`.
4. Presidiare la finestra e leggere la scheda **Esperti**.
5. **RIPRISTINO — l'ordine conta** (→ **R2**, la pausa e' un **latch**):
   **prima** rimettere `InpDailyPausePct = 4.0`; **poi** _Strumenti > Variabili
   globali_ (F3) e **cancellare** `ABTG_PAUSA_GIORNO_50504263` e
   `ABTG_PAUSA_FINO_50504263`. Se si cancella prima di rialzare la soglia, il
   giro di timer successivo la rimette.
6. Verificare il pannello: `Pausa morbida (4.0%): libera`.

**Righe che fanno fede** (Esperti dell'istanza `-V3`):

| chi | riga attesa |
|---|---|
| Guardian | `[GUARDIAN] * PAUSA NUOVI INGRESSI attiva: perdita giornaliera 0.12% >= 0.10% (fino a ... server)` |
| EA | `[GUARDIA] <nome>: INGRESSO BLOCCATO -- PAUSA GIORNALIERA del Guardian (firma B1). Rischio aperto X.XX%. La posizione eventualmente gia' aperta NON viene toccata.` |
| EA, al ripristino | `[GUARDIA] <nome>: via libera, il blocco e' rientrato (PAUSA GIORNALIERA del Guardian (firma B1)). Rischio aperto X.XX%` |

_`<nome>` e' uno di: `ABTG_MaxMinNotte_DAX_Short_Ott`, `ABTG_DAX_Apertura_EU`,
`ABTG_Dow_Apertura_US`, `ABTG_ORB_Ottimizzato`, `ABTG_SupertrendReversal`._

✅ **PASS:** la riga del Guardian **e** almeno una riga `INGRESSO BLOCCATO --
PAUSA GIORNALIERA` di un EA, **e nessun ordine nuovo** compare nella scheda
Trade/Storico in quella finestra.
❌ **FAIL:** la riga del Guardian c'e', l'EA prova a entrare (si vede un ordine
nuovo nello Storico con l'ora dentro la finestra) e **nessuna riga `[GUARDIA]`**
→ le bandiere sono scritte ma non lette. **Ci si ferma.**
🟡 **NON MISURATO** (≠ PASS): nessun ordine e nessuna riga `[GUARDIA]` → l'EA
semplicemente non voleva entrare. **Si ripete in un'altra finestra**, non si
promuove.

---

### 2.4 🧷 CRITERIO 6 — «le posizioni aperte restano gestite durante la pausa»

**E' il criterio che vale piu' di tutti** (parole del referto 19/08): la guardia
non deve **mai** toccare le uscite. Staticamente e' gia' dimostrato — l'audit
del 19/08 ha verificato che le 16 funzioni ospitanti sono **tutte imbuti
d'ingresso** e che `ClosePartial()` non e' stata toccata. Qui se ne cerca la
**conferma in campo**.

**Si fa DENTRO la stessa finestra di pausa del §2.3** (non e' una seconda prova:
e' la seconda osservazione della stessa prova) e **richiede almeno una posizione
aperta** sul 100k.

**Cosa si osserva, in ordine di forza della prova:**

1. 🥇 **un evento di gestione con timestamp DENTRO la pausa**: SL modificato
   (breakeven o trailing) oppure parziale eseguito — visibile nella scheda
   **Trade** (colonna S/L che cambia) e nello **Storico**;
2. 🥈 la posizione e' **ancora aperta** a fine pausa e non e' stata chiusa da
   nessuno;
3. 🥉 nel giornale dell'EA compaiono le sue righe abituali di gestione
   (BE/trailing/parziale) con orario dentro la finestra.

✅ **PASS:** almeno un evento del tipo 1 **oppure** (tipo 2 + tipo 3).
❌ **FAIL:** una posizione viene **chiusa** o **smette di essere gestita**
all'accensione della pausa (SL congelato mentre il prezzo corre e il trailing
avrebbe dovuto muoverlo).
🟡 **NON MISURATO:** nessuna posizione aperta durante la pausa → **si ripete**
in una finestra con posizione viva (tipicamente DAX fra 08:35 e 17:30, o la
posizione notturna del MaxMin la mattina).

---

### 2.5 🅲1 CRITERIO 7 — «il cap che rifiuta il sesto SL»

**Precondizione fisica (riga 413):** `if(InpMaxOpenRiskPct>0 && riskPct>=InpMaxOpenRiskPct)`.
🔴 **Con `riskPct = 0,00%` il cap NON e' innescabile a nessuna soglia**, perche'
l'unico valore che soddisferebbe `0 >= soglia` e' `0`, che significa "spento".
E il `riskPct` del 100k e' **0,00% per gran parte della giornata**, perche'
`OpenRiskPct()` cicla **solo** su `PositionsTotal()` e i mirror lavorano in
buona parte a **pendenti** (→ **buco B6**, §3 e **R1**).

**→ Quindi il criterio 7 si programma in una finestra con ALMENO UNA POSIZIONE
APERTA CON SL** (P-5). Finestre buone: DAX Apertura entrata (08:35-17:30), Dow
(15:05-17:30), posizione notturna del MaxMin al mattino, STREV 225JPY su H2.

**Passi:**

1. Leggere dal pannello del Guardian il campo `Rischio aperto: X.XX%` (deve
   essere **> 0**).
2. Finestra parametri del Guardian → **`InpMaxOpenRiskPct`** = un valore
   **appena sotto** X (es. rischio 0,63% → **0,50**). **Solo quel campo.**
3. Un giro di timer. Pannello: `Rischio aperto: 0.63% / cap 0.50% -> CAP ATTIVO`.
4. Presidiare una finestra d'ingresso (§2.1) e leggere gli Esperti.
5. **Poi si passa DIRETTAMENTE al criterio 8 (§2.6), senza ripristinare**: la
   prova del fail-open si fa **col cap attivo**.
6. **RIPRISTINO** (dopo il §2.6): `InpMaxOpenRiskPct = 3.25`. ✅ Il cap **non e'
   un latch**: rientra da solo entro un giro (riga 427, `GlobalVariableSet(GV_CAP,0)`)
   e scrive la sua riga di rientro. Nessuna GlobalVariable da cancellare a mano.

**Righe che fanno fede:**

| chi | riga attesa |
|---|---|
| Guardian | `[GUARDIAN] * CAP RISCHIO APERTO attivo: 0.63% >= 0.50% (nuovi ingressi sospesi)` |
| EA | `[GUARDIA] <nome>: INGRESSO BLOCCATO -- CAP RISCHIO APERTO raggiunto (firma C1). Rischio aperto 0.63%. ...` |
| Guardian, al ripristino | `[GUARDIAN] cap rischio aperto rientrato: 0.63% < 3.25%` |

✅ **PASS:** le tre righe **e** nessun ordine nuovo nella scheda Trade dentro la
finestra di blocco.
❌ **FAIL:** cap attivo + un ordine nuovo compare lo stesso **da un EA dei 5**,
senza nessuna riga `[GUARDIA]`.
🟡 **NON MISURATO:** nessun tentativo d'ingresso nella finestra → si ripete.
⚠️ **Non e' un FAIL** se scatta un **pendente piazzato prima**: quello e' il
limite noto n.1 (la guardia e' un cap sull'**AGGIUNTA** di rischio, non un cap
istantaneo). Va **annotato**, non contato come bocciatura.

---

### 2.6 🚪 CRITERIO 8 — «fail-open: Guardian rimosso → la flotta riparte»

> 🛑 **La prova si fa col CAP, MAI con la PAUSA.** E' scritto nel referto 19/08
> e nel codice: il **cap** e' un timestamp ri-timbrato ogni secondo e scade da
> solo entro `ABTG_BATTITO_TOLLERANZA = 120 s`; la **pausa** ha una scadenza
> dichiarata (il prossimo reset del giorno) e **deve** sopravvivere alla morte
> del guardiano. Chi prova col la pausa boccia una cosa che funziona.

**Passi (in coda al §2.5, col cap ancora attivo):**

1. **Togliere `ABTG_Guardian` dal grafico** dell'istanza `-V3` (tasto destro >
   Consulenti > Rimuovi). ⏱️ **Annotare l'orario al secondo.**
2. Attendere **oltre 120 secondi** (metterne 180 di margine).
3. Guardare se un EA torna a operare / a scrivere `via libera`.
4. **Rimettere il Guardian** sul grafico e **verificare campo per campo** che
   torni con **4,9 / 9,9 / pausa 4,0 / cap 3,25** e `Azione: CHIUDI+BLOCCA`
   (screenshot). 🔴 **Questo passo non e' opzionale: fino a quando il Guardian
   non e' tornato, il 100k e' senza rete.**

**Riga che fa fede:**
`[GUARDIA] <nome>: via libera, il blocco e' rientrato (CAP RISCHIO APERTO raggiunto (firma C1)). Rischio aperto X.XX%`
— **con timestamp entro ~2 minuti** dalla rimozione (nel log = ora locale VPS).

✅ **PASS:** la riga `via libera` compare entro ~2 min dalla rimozione, **oppure**
un ingresso regolare avviene dopo quell'istante da un EA che era bloccato.
❌ **FAIL:** l'EA continua a scrivere `INGRESSO BLOCCATO` oltre i 120 s con il
Guardian rimosso → **il fail-open non funziona e la migrazione e' pericolosa**:
un cane da guardia morto spegnerebbe la flotta.
🟡 **NON MISURATO:** nessuna chiamata alla guardia nei 3 minuti (nessun EA
voleva entrare) → si ripete. **E' proprio il caso in cui il canarino P-C1
farebbe la differenza fra una prova e una speranza.**

📐 **Nota tecnica:** togliere il Guardian esegue `OnDeinit`, che mette
`GV_BATTITO = 0` (riga 304). Il `GV_CAP` invece **resta timbrato all'ultimo
secondo** e scade per anzianita' entro i 120 s. E' esattamente il meccanismo
che si sta collaudando.

---

### 2.7 📅 CRITERIO 9 — «giorni di dry-run senza blocchi inspiegati»

**Testo congelato: 3 giorni.** ⚠️ Il **cancello della fase 1** del piano
(`PIANO_MIGRAZIONE_100K` §4) chiede di piu': _«una settimana di pagelle con
bandiere lette dagli EA, log alla mano»_. **Vale il piu' severo: una settimana
di borsa (5 giornate), di cui i 3 giorni del criterio 9 sono il minimo
sindacale.**

**Cosa si raccoglie, ogni giorno (artefatto, non impressione):**

| voce | dove sta | a cosa serve |
|---|---|---|
| tutte le righe `[GUARDIA]` dei 5 EA | Esperti dell'istanza `-V3` / `MQL5\Logs\AAAAMMGG.log` | ogni blocco dev'essere **spiegato** |
| tutte le righe `[GUARDIAN] * PAUSA` / `* CAP` / `rientrato` | idem | sono la **spiegazione** dei blocchi qui sopra |
| **il massimo** del campo `rischioAperto=` nella riga periodica `[GUARDIAN] eq=...` | idem, una riga ogni 300 s con `InpVerbose=true` | e' il numero del cancello: **picco ≤ 3,25%** |
| numero di righe `filo verificato` e il **conto** che nominano | idem | deve dire **50504263** |

✅ **PASS:** **ogni** `INGRESSO BLOCCATO` ha, nello stesso minuto, una riga del
Guardian che lo giustifica (pausa o cap). Zero blocchi orfani.
❌ **FAIL:** anche **un solo** blocco senza causa visibile nel giornale del
Guardian → e' un difetto, non un caso (parole del referto 19/08).

🔴 **E il caveat che rende onesto il numero (→ R7):** il picco di
`rischioAperto` e' **un LIMITE INFERIORE** del rischio davvero impegnato, per
due motivi cumulativi: **(a)** e' campionato **ogni 300 s** (un picco fra due
campioni non si vede); **(b)** e' **cieco sui pendenti** (B6). Dichiararlo
insieme al numero, altrimenti il verde non vuol dire niente.

---

## 3️⃣ ⚠️ LA MATRICE DEI RISCHI DEL COLLAUDO

_"Cosa puo' andare storto in campo" e, per ciascuno, **la spia osservabile** —
perche' un rischio senza spia e' solo una preoccupazione._

| # | cosa puo' andare storto | perche' e' insidioso | 🔦 **SPIA OSSERVABILE** | contromisura nel piano |
|---|---|---|---|---|
| **X1** | **Il fail-open maschera un enforcement rotto.** La guardia lascia passare tutto e sembra che vada bene | Il fail-open e' a **tre livelli** (input spento / canale inesistente / battito vecchio) e **nessuno dei tre logga niente**: e' silenzioso per disegno | `[GUARDIAN] filo verificato: 5 GlobalVariable su 5 ... (conto **50504263**)` all'avvio **+** in F3 esistono le 5 GV col login giusto **+** `InpUsaGuardian = true` nella scheda Parametri di **tutti e 5** gli EA | P-1, P-2, P-3; lettura F3 obbligatoria prima di ogni prova |
| **X2** | **Bandiere scritte ma mai lette** (il buco vero del 18/08: il Guardian vedeva, dall'altra parte non c'era nessuno) | Il Guardian scrive lo stesso: pannello e log del **Guardian** sembrano perfetti anche a canale morto | La spia **non e'** il log del Guardian: e' la riga **`[GUARDIA]`** — che appartiene all'**EA**. Nessuna `[GUARDIA]` in tutta la settimana **con** blocchi attivi e ordini partiti = canale morto | criteri 5/7 con presidio della finestra; **P-C1 (canarino)** e' l'unica prova deterministica |
| **X3** | **Conto sbagliato.** L'istanza `-V3` loggata su un conto diverso da 50504263 | I nomi delle GV portano il login: su un altro conto il canale semplicemente **non esiste** → `ABTG_CanaleEsiste()` = false → **passa tutto, in silenzio** | il login stampato nella riga `filo verificato ... (conto NNNN)` + `conto_attivo.ps1` | P-1 |
| **X4** | **Due Guardian sullo stesso conto** (violazione B9) | Si timbrano addosso: uno alza il cap, l'altro lo azzera nello stesso secondo → blocchi intermittenti e inspiegabili | due righe `[GUARDIAN] avviato.` ravvicinate nel log; nel menu **Finestra** due grafici col Guardian | P-2 |
| **X5** | 🔴 **I PENDENTI SONO INVISIBILI AL CAP (B6).** `OpenRiskPct()` riga 159 cicla **solo** `PositionsTotal()` | I mirror lavorano a pendenti (MaxMin straddle, ORB stop, DAX/Dow retest limit): **5 stop pendenti a 0,65% = 3,25% di rischio gia' promesso che il cap conta ZERO**. Il collaudo puo' passare 9/9 e la protezione restare **mezza** | `rischioAperto=0.00%` nel log **mentre** la scheda Trade mostra ordini **pendenti** con SL: e' la fotografia esatta del buco | dichiarato nel cancello (§4) come **limite inferiore**; **proposta P1** di `CONFIG_PROP` §5 (priorita' 2, ~2 h, prima in `InpAction=1` per una settimana) |
| **X6** | **Il criterio 7 non e' innescabile** perche' `rischioAperto = 0,00%` | Si prova, non succede niente, e si conclude "il cap non funziona" — bocciando una cosa che funziona (**R1**) | il campo `Rischio aperto` del pannello **prima** di iniziare | P-5: la prova si programma solo con **posizione aperta con SL** |
| **X7** | **La pausa resta accesa tutto il giorno** dopo la prova (**R2**: e' un latch) | Il 100k smette di aprire fino alle **23:00 server**: si perde una giornata di dry-run e M27/H5 misurano un buco che e' nostro | pannello: `Pausa morbida (4.0%): ATTIVA` **con la giornata a −0,1%** = incoerente → e' il latch rimasto su | ripristino a due passi del §2.3 (prima la soglia, **poi** F3) |
| **X8** | 🔴 **Si abbassa `InpDailyLossPct` invece di `InpDailyPausePct`** (**R3**) | Con `InpAction=0` il Guardian esegue **`FlattenAll()`**: chiude **tutte** le posizioni e cancella **tutti** i pendenti del conto, qualsiasi magic. E anche in `InpAction=1` resta **`GV_BLOCKDAY` timbrato**: tornando ad Action=0 lo stesso giorno, il primo timer chiude tutto (riga 392-395) | `[GUARDIAN] !! PERDITA GIORNALIERA SFONDATA: ...` — se compare questa riga, il danno e' gia' fatto | il campo si nomina **una volta sola** nel piano, con il divieto in grassetto. Recupero: azzerare `ABTG_GUARD_50504263_BLOCKDAY` da F3 |
| **X9** | **Il silenzio scambiato per successo** | Nessuna `[GUARDIA]` puo' voler dire "tutto bene" o "tutto morto": sono indistinguibili senza un tentativo d'ingresso | la scheda **Storico**: se in quella finestra **e' partito** un ordine di un mirror, il silenzio e' un **FAIL**; se non e' partito niente, e' **NON MISURATO** | i tre esiti **PASS / FAIL / NON MISURATO** sono nel piano apposta: 🟡 non promuove |
| **X10** | **Ore confuse** (log in ora locale VPS, grafico in ora server) | Si cerca il blocco delle 07:59 alle 07:59 del log e non c'e': e' alle **08:59**. Errore gia' fatto il 06/08 | l'ultima riga del log deve coincidere con l'orologio di Windows; l'ultima candela e' **un'ora indietro** | nota oraria in §2.1 |
| **X11** | **Il collaudo consuma trade veri del dry-run** | Un blocco forzato **perde** il trade (non lo rimanda): la serie del 100k acquista un buco non dichiarato | confronto fra i trade attesi della giornata e quelli fatti | **annotazione obbligatoria nella pagella del giorno**, §5 azione G7 |
| **X12** | **Finestra di fail-open a ogni cambio di parametri del Guardian** | Cambiare un input = `OnDeinit`+`OnInit`: `GV_BATTITO` va a 0 e **`GV_CAP` viene azzerato** (riga 283). Per ~1 s il canale e' "libero" | un `via libera` nel log **esattamente** all'ora in cui si e' premuto OK sui parametri | e' **per disegno**: si annota, non si indaga (**R8**) |
| **X13** | **Si ricompila "per sicurezza" e si perde il criterio 4** | I binari in campo sono quelli **dimostrati identici**; altri binari sono un'altra cosa e vanno ridimostrati | il `.ex5` con timestamp diverso dal 19/08 23:10 | §2.0: **fase 1 senza ricompilazioni** (decisione D1) |

---

## 4️⃣ 🚧 IL CANCELLO DI FASE — cosa dev'essere vero per dire "fase 1 chiusa"

**Tutte e cinque le condizioni, insieme. Nessuna compensa un'altra.**

| # | condizione | come si dimostra |
|---|---|---|
| **C-1** | **9/9 criteri PASS** — i 4 verdi agli atti **sui binari in campo** + i 5 collaudati con le procedure §2.3-§2.7 | referto 19/08 (criteri 1-4) + il verbale di questo collaudo con, per ogni criterio 5-9, **la riga di log copiata** e **l'ora** |
| **C-2** | **Una settimana di borsa (5 giornate) di pagelle** del 100k, consecutive, con gli EA che leggono le bandiere | il criterio 9 esteso: raccolta giornaliera dei log (§2.7) |
| **C-3** | **Picco `rischioAperto` osservato ≤ 3,25%** in quella settimana | massimo del campo `rischioAperto=` sulle righe periodiche del Guardian, **dichiarato con i suoi due caveat**: campionamento a 300 s e **cecita' sui pendenti (B6)** |
| **C-4** | **Zero blocchi orfani**: ogni `[GUARDIA] ... INGRESSO BLOCCATO` ha la sua causa nel giornale del Guardian nello stesso minuto | incrocio delle due liste di righe |
| **C-5** | **Il 100k e' tornato alla configurazione firmata**: 4,9 / 9,9 / pausa **4,0** / cap **3,25**, `CHIUDI+BLOCCA`, **un solo** Guardian, nessuna GV di pausa rimasta accesa | screenshot finale del pannello + F3 pulita |

🔴 **E una riga di onesta' che va nel cancello, non in una nota a pie' di
pagina:** anche con **9/9 verde**, l'enforcement collaudato copre **l'aggiunta
di rischio via posizioni**, non i pendenti gia' piazzati (B6) e non gli EA che
sparano nello stesso secondo (B7). Il cancello della fase 2 si apre su
**quello che e' stato dimostrato**, non su quello che si spera.

**Se anche una sola condizione manca:** la fase 2 (lotto swing, 8 sedie) **non
parte**, e il piano ricade sull'opzione **(a) scaglionare** del §2 — che non e'
enforcement, e' esposizione ridotta per via amministrativa, con i tempi che si
allungano.

---

## 5️⃣ 👤 COSA SERVE DA CLAUDIO — elenco secco, col conto della spesa

_Tutte azioni **manuali**, sull'istanza `-V3` del VPS (conto 50504263). Nessuna
tocca il conto piccolo 50503392 ne' il forward._

| # | azione | quando | ⏱️ tempo |
|---|---|---|---|
| **D1** | **Decidere: fase 1 SENZA ricompilazioni** (raccomandazione di casa, §2.0) — si' o no | prima di tutto | 5 min di lettura |
| **D2** | **Decidere sul canarino P-C1** (§6, R4): lo si scrive in un giro dedicato, oppure si accetta un collaudo opportunistico che puo' restare 🟡 NON MISURATO | prima di fissare le finestre | 5 min |
| **G1** | **Prerequisiti P-1…P-5**: `conto_attivo.ps1`, conteggio Guardian, screenshot pannello "prima", annotare perdita del giorno / posizioni aperte / rischio aperto | una volta, all'inizio | **15 min** |
| **G2** | **Criterio 7 (cap) + criterio 8 (fail-open) — stessa sessione**, in una finestra con **posizione aperta con SL**: abbassare `InpMaxOpenRiskPct`, presidiare, rimuovere il Guardian, attendere 3 min, rimetterlo e riverificare campo per campo | 1 sessione | **45 min** (di cui ~20 di presidio) |
| **G3** | **Criterio 5 (pausa) + criterio 6 (gestione) — sessione SEPARATA**, in una giornata **in perdita**, meglio a ridosso delle **07:59 server**; poi ripristino a due passi (soglia → F3) | 1 sessione, altro giorno | **40 min** |
| **G4** | **Screenshot dopo ogni gesto** (legge dello screenshot): pannello prima / bandiera attiva / riga `[GUARDIA]` / pannello ripristinato | dentro G2 e G3 | incluso |
| **G5** | **Criterio 9**: raccolta giornaliera dei log `-V3` per **5 giornate di borsa** | 5 giorni | **5 min/giorno = 25 min** |
| **G6** | **Verbale finale**: per ogni criterio 5-9, esito PASS/FAIL/NON MISURATO + la riga di log copiata + l'ora | alla fine | **20 min** |
| **G7** | **Annotare nella pagella** i trade **persi** a causa dei blocchi forzati (X11) | il giorno stesso | 5 min |
| **G8** | _(solo se D1 = "allineare a HEAD")_ round separato di ricompilazione, **fuori sessione**, 7 file in ordine (§2.0), **+ criterio 4 rifatto sul PC di backtest** | non in fase 1 | **2-3 h + un giro di tester** |

**Totale fase 1 come raccomandata (senza G8): ~2 h 30 di lavoro attivo di
Claudio, distribuite su 5-7 giorni di calendario.**

> 🛑 Le **stringhe di lancio** per la raccolta dei log e il conteggio delle
> righe **non sono in questo documento**: passeranno dal verificatore, con
> `irm` pinnato e raccolta+zip sul Desktop del VPS come da regola di casa.
> L'artefatto che quelle righe dovranno leggere e' gia' pronto:
> `backtest_pipeline/attese_enforcement_fase1.txt`.

---

## 6️⃣ 🔍 RILIEVI SUL MECCANISMO — trovati leggendo il codice, decide Claudio

> Nessuno di questi e' stato corretto: **in questo giro non si tocca codice.**
> Sono difetti/limiti **dichiarati**, ognuno con la sua proposta.

**R1 — Il cap non e' innescabile a rischio aperto zero.**
`ABTG_Guardian.mq5` riga 413: `InpMaxOpenRiskPct>0 && riskPct>=InpMaxOpenRiskPct`.
Con `riskPct=0` nessuna soglia **positiva** morde, e `0` significa "spento".
Non e' un bug (e' coerente), ma **vincola il collaudo**: il criterio 7 esige una
posizione aperta con SL. _Proposta: nessuna modifica; e' un vincolo di
procedura, gia' recepito in P-5._

**R2 — La pausa e' un LATCH e il criterio di uscita scritto il 19/08 e' sbagliato.**
Il referto (FASE 3) dice: _«rialzando la soglia, entro un giro compare "via
libera"»_. **Non e' vero per la pausa**: `SetPausa()` scrive `GV_PAUSA` e
nessuno la azzera finche' non cambia il **giorno prop** (riga 349) — riavviare
il Guardian **non basta** (OnInit azzera la pausa solo se cambia il day key,
riga 273-279). Vale invece per il **cap**, che si azzera da solo (riga 427).
_Proposta: **non toccare il codice** — il latch e' voluto (una pausa deve
sopravvivere alla morte del guardiano). Si corregge la **procedura**: uscita a
due passi (soglia → cancellazione GV da F3), come scritto in §2.3 passo 5._

**R3 — Trappola `InpDailyLossPct`: il campo che chiude il conto sta accanto a
quello della prova.** Con `InpAction=0` un abbassamento fa `FlattenAll()` su
**tutto il conto, qualsiasi magic**. E anche facendolo in `InpAction=1`,
`GV_BLOCKDAY` resta timbrato per la giornata: **rimettendo Action=0 lo stesso
giorno il Guardian chiude tutto al primo timer** (righe 392-395).
_Proposta: divieto esplicito in procedura (fatto) + **decisione di Claudio**: se
vuole, si puo' proporre in un giro futuro un `InpProvaDisarmata` che impedisca
`FlattenAll()` quando i limiti duri sono sotto una soglia di sicurezza. Costo
~1 h + un caso di autotest. **Non fatto qui.**_

**R4 — La guardia si vede solo quando un EA vuole entrare: i criteri 5/7/8 sono
opportunistici.** _Proposta **P-C1 — IL CANARINO**: uno **Script** (non un EA)
di sola lettura, da attaccare a un grafico qualsiasi dell'istanza `-V3`, che per
N minuti chiama `ABTG_GuardiaIngresso(true,"CANARINO_COLLAUDO")` ogni 10 s e
stampa l'esito. **Non include `Trade.mqh`, non puo' mandare nessun ordine per
costruzione.** Rende i criteri 5, 7 e 8 **deterministici** invece che fortunati,
e non tocca nessuno dei 5 EA vivi. Costo: ~1 h di scrittura + 1 compilazione +
2 casi di autotest. ⚠️ Limite dichiarato: il canarino prova **il canale e
l'include**, non che i **binari dei 5 mirror** chiamino la guardia — quella
prova resta la riga `[GUARDIA]` di un EA vero. Servono entrambi._

> 🐤 **AGGIORNAMENTO 02/09 (dopo la firma D2): P-C1 è COSTRUITO — `mql5/Scripts/ABTG_CanarinoGuardian.mq5`.** Script di sola lettura (un solo `OnStart`; zero `OrderSend`, zero `CTrade`, zero scritture di GlobalVariable), che legge le bandiere **con lo stesso include degli EA** e stampa il valore **grezzo accanto al ricalcolato**, più il **rischio pendente non visto dal cap** (misura del buco B6); 8 blocchi di autotest, fra cui il confronto dei nomi GV con le stringhe **hardcoded** dell'artefatto `attese_enforcement_fase1.txt`.
> 🚫 **Scelta di progetto da conoscere prima di leggere i log:** il canarino **non** stampa il prefisso `[GUARDIA]` né la frase di blocco degli EA (tutte le sue righe iniziano con `[CANARINO]`), altrimenti il censimento del criterio 9 conterebbe blocchi che nessun EA ha subito.
> 🟡 **Stato: COSTRUITO, IN ATTESA DI VERIFICATORE — non compilato** (qui non esistono MetaEditor né tester) e mai eseguito: prima corsa a mano di Claudio, come ogni artefatto nuovo.

**R5 — Il conteggio dell'autotest e' cambiato: 19 → 75.** Il criterio 2 congela
«19/19». Nel codice di HEAD (`ABTG_AutotestGuardia`, riga 1452) il conto e'
**19 (B1/C1/battito/decisione) + 26 (P1) + 30 (S1) = 75**, e il marcatore
stampato e' **`v1.40`**, non `v1.20`. Il **BLOCCO 2** delle righe del 19/08
cerca `"[AUTOTEST] ABTG_PausaGuardian v1.20"` e pretende **esattamente 19** casi:
🔴 **su HEAD fallirebbe, e fallirebbe dicendo la cosa sbagliata** ("log troncato").
_Proposta: il criterio 2 resta valido **come congelato** per i binari in campo
(v1.20, 19 casi). Se e quando si ricompila su HEAD, il cancello va aggiornato a
**75 casi e marcatore v1.40** — e la modifica va **dichiarata prima** dei
numeri, non dopo (regola di casa)._

**R6 — Campo ≠ HEAD su ORB.** Il binario sul 100k e' del pin `d0241ff`; HEAD ha
`v1.02` con `InpSLBufferPts` (default 0 = neutro, e i 2 punti di guardia sono
gli stessi). Non disturba il collaudo, **ma va scritto**: il 100k **non e'
HEAD**. _Proposta: nessuna azione in fase 1; se un giorno si allinea, ORB passa
**prima** dal criterio 4 (backtest identico a `InpSLBufferPts=0`)._

**R7 — Il picco di rischio del cancello e' un limite inferiore.** Campionamento
a 300 s + cecita' sui pendenti (B6). _Proposta: **P1 di `CONFIG_PROP` §5**
(secondo ciclo su `OrdersTotal()` con `ORDER_PRICE_OPEN`→`ORDER_SL`, input
`InpContaPendenti` **default false**), ~2 h, e — come dice quella scheda —
**prima si MISURA** per una settimana in `InpAction=1` leggendo `GV_RISKPCT`,
poi si decide se accendere il conteggio o alzare il cap. Senza questa, il
cancello della fase 2 misura mezza flotta._

**R8 — Ogni cambio di parametri del Guardian apre una finestra di ~1 s di
fail-open** (`OnDeinit` azzera il battito, `OnInit` azzera `GV_CAP`, riga 283).
E' per disegno. _Proposta: nessuna modifica; solo l'annotazione in procedura,
cosi' un `via libera` all'ora del click non viene scambiato per un difetto._

**R9 — Il collaudo costa trade veri.** Un blocco forzato **perde** il trade.
_Proposta: annotazione obbligatoria nella pagella del giorno (azione G7), cosi'
M27 e H5 sanno che quel buco e' nostro._

---

## 📎 APPENDICE A — le stringhe che fanno fede

Copia leggibile dell'artefatto `backtest_pipeline/attese_enforcement_fase1.txt`
(ASCII puro, pensato per essere letto da uno script del verificatore).

**Del Guardian** (`ABTG_Guardian.mq5`):
```
[GUARDIAN] filo verificato: 5 GlobalVariable su 5 con lo stesso nome fra guardiano e include (conto 50504263).
[GUARDIAN] * PAUSA NUOVI INGRESSI attiva: <motivo> (fino a <ora> server)
[GUARDIAN] * CAP RISCHIO APERTO attivo: <x>% >= <y>% (nuovi ingressi sospesi)
[GUARDIAN] cap rischio aperto rientrato: <x>% < <y>%
[GUARDIAN] eq=... dayLoss=...% totDD=...% rischioAperto=...% stato=... pausa=... cap=...
```
**Degli EA** (`ABTG_PausaGuardian.mqh`, `ABTG_GuardiaIngresso`):
```
[GUARDIA] <chi>: INGRESSO BLOCCATO -- PAUSA GIORNALIERA del Guardian (firma B1). Rischio aperto <x>%. La posizione eventualmente gia' aperta NON viene toccata.
[GUARDIA] <chi>: INGRESSO BLOCCATO -- CAP RISCHIO APERTO raggiunto (firma C1). Rischio aperto <x>%. ...
[GUARDIA] <chi>: via libera, il blocco e' rientrato (<motivo>). Rischio aperto <x>%
```
**I cinque `<chi>` del 100k** (stringhe letterali nei sorgenti):
`ABTG_DAX_Apertura_EU` · `ABTG_Dow_Apertura_US` ·
`ABTG_MaxMinNotte_DAX_Short_Ott` · `ABTG_ORB_Ottimizzato` ·
`ABTG_SupertrendReversal`

**Righe che NON devono comparire** (se compaiono, ci si ferma):
```
*** FILO ROTTO ***
[GUARDIAN] !! PERDITA GIORNALIERA SFONDATA
[GUARDIAN] !!! DD TOTALE SFONDATO
```

---

## 📎 APPENDICE B — i 18 punti d'innesto sui 5 mirror

_Contati oggi nei sorgenti a HEAD; per 4 EA su 5 il sorgente e' **identico** al
pin `d0241ff` da cui vengono i binari in campo (per ORB i 2 punti sono gli
stessi, cambia altro: R6). Numeri di riga a HEAD._

| EA (magic 100k) | punti | funzioni ospitanti | attivo sul 100k con `motore=` |
|---|---:|---|---|
| `ABTG_DAX_Apertura_EU` (770101) | **7** | `TryPlaceBreakout` 1049 · `TryPlaceRangeFade` 1138 · `TryPlaceDelayed` 1303 · `MonitorOpenConfirm` 1413 · `MonitorRetest` 1496 e 1529 · `TryPlaceGapFill` 1576 | `ABTG_RETEST` → i due punti di `MonitorRetest` |
| `ABTG_Dow_Apertura_US` (770202) | **7** | `TryPlaceBreakout` 893 · `TryPlaceRangeFade` 982 · `TryPlaceDelayed` 1147 · `MonitorOpenConfirm` 1257 · `MonitorRetest` 1334 e 1367 · `TryPlaceGapFill` 1414 | `ABTG_RETEST` → i due punti di `MonitorRetest` |
| `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` (770411) | **1** | `TryPlace` 245 | straddle piazzato alle **07:59 server** |
| `ABTG_ORB_Ottimizzato` (770611) | **2** | `TryPlace` 330 · `TryCloseConfirmEntry` 489 | range 14:30-14:45 _(⚠️ `TryCloseConfirmEntry` **e' un INGRESSO** su chiusura confermata, non una chiusura: verificato a mano il 19/08)_ |
| `ABTG_SupertrendReversal` (770901) | **1** | `Enter` 279 | chiusura barra **H2** su 225JPY |
| **totale** | **18** | | |

Tutti e cinque hanno `#include <ABTG_PausaGuardian.mqh>` e
`input bool InpUsaGuardian = true;` **(default acceso)**. 📌 I `.set` gia'
salvati **non contengono** quel campo: MT5 usa il default — coerente con la
firma, ma **va saputo** (limite noto n.3 del referto 19/08).

---

_Compilato il **02/09/2026**. Fonti: `REFERTO_MIGRAZIONE_GUARDIAN_PREPARAZIONE.md`
(19/08, criteri congelati + esiti 1-4) · `PIANO_MIGRAZIONE_100K_2026-08-31.md`
§2 opzione (b) e §4 fase 1 · `CONFIG_PROP_2026-08-31.md` (buco B6, proposta P1)
· `DEPLOY_GUARDIANO_100K.md` · sorgenti `ABTG_Guardian.mq5` v1.11 e
`ABTG_PausaGuardian.mqh` v1.40 letti riga per riga · `git` per i confronti
campo↔HEAD. **Nessun EA vivo, nessun preset, nessun grafico e nessun forward
sono stati toccati.**_
