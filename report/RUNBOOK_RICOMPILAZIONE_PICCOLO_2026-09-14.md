# 🔧 RUNBOOK DI RICOMPILAZIONE — CONTO PICCOLO 50503392

**Esecuzione di decisioni già prese. Non contiene nessuna decisione nuova.**
_Scritto il 14/09/2026 — architetto-prop. Sintesi di due referti già in casa._

---

> ## 🛑 PERIMETRO, dichiarato prima di ogni riga
>
> - 🪟 **Bersaglio unico: terminale `50503392`**, cartella programma
>   `C:\Program Files\BCM Markets MT5 Terminal` — **SENZA** `-V3`.
> - 🔴 **NON si tocca**: `50504263` (`... MT5 Terminal -V3`, il 100k) ·
>   **`10105439` (`C:\BCM_Reale`, il REALE)** · `50504400` (`C:\MT5_Backtest`) ·
>   le cartelle Pepperstone e Tickmill. Sul VPS convivono **sei** cartelle dati:
>   *"sul VPS"* è un indirizzo, non un bersaglio.
> - 👤 **Ogni gesto di questo runbook lo esegue CLAUDIO.** Nessun agente fa F7,
>   nessun agente apre un terminale, nessun agente tocca un grafico. Motivo
>   scritto e non negoziabile: **ricompilare cambia i volumi delle sedie vive**,
>   e le taglie sono firma di Claudio.
> - 🚫 **Questo documento non propone di cambiare nessun rischio e nessuna
>   taglia.** Dove una ricompilazione ne toccherebbe una, il runbook **si ferma
>   e lo segnala** (§3.4) invece di proporre.
> - 📄 **Niente saldi, equità o P/L**: il repo è pubblico.

---

# 1. 🕐 L'ORDINE DELLE OPERAZIONI — e perché il Guardian viene prima

## 1.1 La regola generale, e la ragione (non solo l'ordine)

> **Il Guardian è la PROTEZIONE, non una strategia.**
> Una sedia ricompilata prima che il Guardian sia verificato **gira senza rete
> per tutto il tempo che passa in mezzo** — ore o giorni, non secondi. E il
> tempo in mezzo è esattamente il momento in cui il rischio è più alto, perché
> è il momento in cui il codice della sedia è appena cambiato.

Tradotto: la sequenza `sedia → poi Guardian` produce una finestra in cui **un
binario nuovo e mai girato su quel conto opera con protezione assente**. La
sequenza `Guardian → poi sedia` non produce nessuna finestra del genere. È lo
stesso ordine già scritto in `PIANO_CHALLENGE_OTTOBRE_v2.md` **A5-bis** e in
`IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md` §«Cosa serve da Claudio» punto 1.

## 1.2 🔴 MA sul piccolo 50503392 c'è un fatto misurato che cambia il PASSO 0

**Il Guardian non è attaccato a nessun grafico sul piccolo, ed è una decisione,
non un guasto.**

| misura | fonte |
|---|---|
| `ABTG_Guardian` **non compare** fra le 40 sedie del profilo attivo `ORO` | `CODA_01_sedie_attaccate_20260913_033003.log` rr.15–54 |
| Giornale 12 e 13/09: *"GUARDIAN: nessuna riga in questo giorno"* su log **non vuoti** (48 e 7 righe) | `CODA_09_giornale_operativo_20260913_033003.log` rr.25–39 |
| **È voluto**: *"decisione di Claudio del 06/09 — NIENTE Guardian sul piccolo, perché il DD della flotta si deve vedere NON FRENATO"* | `CENSIMENTO_CONTRATTI_v2.md` §4 |

👉 **Quindi «Guardian prima» sul piccolo non significa «ricompila il Guardian
adesso». Significa che il PASSO 0 è una decisione di Claudio, e ha due rami.**

### ⚖️ PASSO 0 — la scelta che apre il runbook (👤 firma di Claudio)

| ramo | cosa comporta | effetto sulle 22 sedie del §2 |
|---|---|---|
| **A — si tiene la decisione del 06/09**: niente Guardian sul piccolo | ✅ **nessun gesto sul Guardian**. «Guardian prima» è soddisfatta per costruzione: non c'è nulla da mettere prima | Le sedie ricompilate avranno `InpUsaGuardian = true`, ma **la guardia è fail-open** senza Guardian sul terminale (`ABTG_PausaGuardian.mqh` r.765 — `if(!ABTG_CanaleEsiste()) return(true)`). 🟢 **Nessuna regressione**: è già lo stato di oggi |
| **B — si rovescia il 06/09** e si vuole il Guardian anche sul piccolo | 🔴 **il Guardian va ricompilato PRIMA**, e non è opzionale | vedi trappola qui sotto |

### 🕳️ LA TRAPPOLA DEL RAMO B, misurata

| | ver | righe | `.ex5` scritto il | commit |
|---|---|---:|---|---|
| **campo (piccolo)** | **1.10** | **413** | **09/08 19:23** | `a53820e` 18/08 |
| **HEAD `lavoro`** | **1.14** | **899** | — | `a21d0c0` 08/09 |

🔴 **L'`.ex5` è di NOVE GIORNI PIÙ VECCHIO del `.mq5` che gli sta accanto.** Al
09/08 il Guardian nel repo aveva **208 righe** (v1.00): **i cap firmati il 18/08
in quel binario non esistono.** Su 70 sorgenti ABTG dei quattro terminali BCM,
**questo è l'UNICO caso** di `.ex5` più vecchio del sorgente.

> 👉 **Se qualcuno trascinasse il Guardian su un grafico del piccolo senza fare
> F7 prima, metterebbe in campo una protezione che NON contiene il cap 3,25% né
> la pausa 4,0/4,9.** Sembrerebbe protetto e non lo sarebbe. **Questo è il modo
> in cui questo runbook può fare danno: è scritto qui in grande apposta.**

✅ **Nel ramo B l'ordine è: F7 sul Guardian → verifica 0 errori → solo allora
attaccarlo → e solo dopo si comincia il §2.**
⚠️ Il Guardian a HEAD è `a21d0c0` (v1.14), **non** è toccato da nessun WIP: da
questo lato è compilabile. Ma **quali valori debba portare il suo preset sul
piccolo non è materia di questo runbook** — è una firma, ed è un buco (§6).

## 1.3 🔢 La sequenza completa

```
PASSO 0   👤 Claudio sceglie il ramo A o il ramo B (§1.2).
          Nel ramo B: F7 sul Guardian PRIMA di tutto il resto.
PASSO 1   Le 5 sedie GIÀ ALLINEATE: nessun gesto. Si saltano. (§2, blocco 🟢)
PASSO 2   Le 22 sedie SICURE: UNA PER VOLTA, con la verifica del §4 fra una
          e la successiva. (§2, blocco 🟡 + §3)
PASSO 3   Le 13 sedie BLOCCATE: NON SI TOCCANO OGGI. (§2, blocco 🔴 + §5.2)
```

---

# 2. 🪑 LA TABELLA ESEGUIBILE — 40 sedie su 40

Ordine e dati del profilo `ORO`, da `INVENTARIO_CAMPO_PICCOLO_2026-09-14.md` §2.
`bersaglio` = il commit che va compilato. `ver/righe bersaglio` = quello che
deve risultare **dopo** il gesto. **Tutte le righe-conteggio sono `wc -l`**, già
corrette del `+1` dello strumento CODA_06.

## 🟢 BLOCCO 1 — GIÀ ALLINEATE: **non si toccano**, 5 sedie

Nessun gesto. Ricompilarle non aggiunge niente e apre un rischio gratis.

| # | EA | magic | sym · TF | campo | bersaglio (= campo) |
|---:|---|---|---|---|---|
| 1 | `ABTG_TradeExporter` | *(utility, nessun magic)* | NZDCAD H1 | 1.00 · 211 | `76c79de` ✅ |
| 36 | `ABTG_ORB_Ottimizzato` | **770611** | U30USD M5 | 1.04 · 1463 | `19312c8` ✅ |
| 38 | `ABTG_PostNews` | **771203** | USDJPY M5 | 1.10 · 666 | `61dc18c` ✅ |
| 39 | `ABTG_PostNews` | **771201** | EURJPY M5 | 1.10 · 666 | `61dc18c` ✅ |
| 40 | `ABTG_PostNews` | **771202** | EURUSD M5 | 1.10 · 666 | `61dc18c` ✅ |

## 🟡 BLOCCO 2 — SICURE DA HEAD OGGI: **22 sedie**, una per volta

HEAD di `lavoro` per questi file **non porta nessun marcatore WIP**: verificato
file per file con `git log -1` il 14/09 (HEAD = `5fe259d`).

| # | EA | magic | sym · TF | campo: ver · righe | ➡️ bersaglio **HEAD** | ver · righe attesi | 💰 tocca i lotti? |
|---:|---|---|---|---|---|---|:---:|
| 3 | `ABTG_BreakingBand` | **772161** | GBPUSD H1 | 1.02 · 1577 | `2a1fa24` 29/08 | **1.05 · 1857** | 🟢 no (tutti opt-in a default storico) |
| 4 | `ABTG_BreakingBand` | **772162** | EURUSD H1 | idem | idem | idem | 🟢 no |
| 5 | `ABTG_BreakingBand` | **772163** | AUDUSD H1 | idem | idem | idem | 🟢 no |
| 6 | `ABTG_GapFill` | **772231** | GBPUSD H1 | 1.00 · 790 | `26a1856` 19/08 | **1.00 · 805** | 🟢 no (solo il filo Guardian) |
| 7 | `ABTG_GapFill` | **772232** | EURUSD H1 | idem | idem | idem | 🟢 no |
| 8 | `ABTG_GapFill` | **772233** | AUDUSD H1 | idem | idem | idem | 🟢 no |
| 9 | `ABTG_GapFill` | **772234** | U30USD H1 | idem | idem | idem | 🟢 no |
| 10 | `ABTG_GapFill` | **772235** | 225JPY H1 | idem | idem | idem | 🟢 no |
| 11 | `ABTG_PunteLarry` | **772341** | U30USD H1 | 1.00 · 1199 | `5fc0bc3` 19/08 | **1.00 · 1214** | 🟢 no (solo il filo) |
| 12 | `ABTG_PunteLarry` | **772342** | EURAUD H1 | idem | idem | idem | 🟢 no |
| 13 | `ABTG_PunteLarry` | **772343** | XAUUSD H1 | idem | idem | idem | 🟢 no |
| 14 | `ABTG_PunteLarry` | **772344** | GBPJPY H1 | idem | idem | idem | 🟢 no |
| 15 | `ABTG_PunteLarry` | **772345** | GBPUSD H1 | idem | idem | idem | 🟢 no |
| 16 | `ABTG_PunteLarry` | **772346** | EURCAD H1 | idem | idem | idem | 🟢 no |
| 19 | `ABTG_EasyTrend` | **772421** | CHFJPY H1 | 1.00 · 1605 | `5fc0bc3` 19/08 | **1.00 · 1620** | 🟢 no |
| 20 | `ABTG_EasyTrend` | **772422** | GBPUSD H1 | idem | idem | idem | 🟢 no |
| 25 | `ABTG_MaxMinNotte` | **770402** | XAUUSD M15 | 1.10 · 539 | `7d0da9f` 03/09 | **1.11 · 918** | 🔴 **SÌ, tre volte** — vedi §3.4 |
| 26 | `ABTG_DAX_Apertura_EU` | **770101** | D30EUR M5 | 1.00 · 2132 | `9638318` 02/09 | **1.01 · 2367** | 🔴 **SÌ** — vedi §3.4 |
| 27 | `ABTG_Dow_Apertura_US` | **770202** | U30USD M5 | 1.00 · 2064 | `d83c196` 19/08 | **1.01 · 2147** | 🔴 **SÌ** (guardia A4 `8b92214`) |
| 28 | `ABTG_MaxMinNotte_DAX_Short_Ott` | **770411** | D30EUR M15 | 1.10 · 604 | `5fc0bc3` 19/08 | **1.10 · 619** | 🟢 no |
| 34 | `ABTG_SupRev_DAX_H4_Ott` | **970912** | D30EUR H4 | 1.00 · 577 | `872dba8` 08/09 | **1.01 · 615** | 🔴 **SÌ** (pavimento del lotto) |
| 35 | `ABTG_SupRev_NAS_H1_Ott` | **970913** | NASUSD H1 | 1.00 · 577 | `872dba8` 08/09 | **1.01 · 652** | 🔴 **SÌ** (pavimento del lotto) |

📌 **L'ordine consigliato dentro il blocco 2**: prima le **16 🟢** (BreakingBand,
GapFill, PunteLarry, EasyTrend, MaxMinNotte_DAX_Short), che non toccano i lotti
e servono da collaudo del gesto; **poi** le **6 🔴**, una alla volta, perché
quelle cambiano un volume e la prova del §4.3 va guardata davvero.

## 🔴 BLOCCO 3 — BLOCCATE DAL MARCATORE «NON COMPILARE»: **13 sedie**

`b45dd00` (11/09), messaggio **testuale** del commit:

> *"questi file NON sono verificati, NON sono passati dal cancello, e gli agenti
> che li stanno scrivendo NON hanno ancora consegnato. **NESSUNO DI QUESTI EA VA
> COMPILATO O CARICATO** finché non c'è un PASS."* — ~2.000 righe aggiunte.

🔎 **Verificato il 14/09 su HEAD `5fe259d`**: `git log -1` su ognuno di questi
file restituisce **ancora `b45dd00`** (o `b5d904a` per il Nasdaq). **Nessun
commit successivo ha chiuso il WIP.** I 5 commit che toccano `mql5/Experts/`
dopo `b45dd00` riguardano **altri** EA (`CYCLE`, `VolExpBreak`,
`Nasdaq_PreOpen_Breakout` esterno): nessuno di loro riapre queste 13 sedie.

| # | EA | magic | sym · TF | campo | 🚫 HEAD è | ➡️ bersaglio **pre-WIP** | ver · righe pre-WIP |
|---:|---|---|---|---|---|---|---|
| 2 | `ABTG_PTE` | **771321** | U30USD H1 | 1.00 · 525 | `b45dd00` | `26a1856` 19/08 | **1.01 · 649** |
| 22 | `ABTG_PTE` | **771332** | GBPUSD H1 | idem | `b45dd00` | `26a1856` 19/08 | **1.01 · 649** |
| 23 | `ABTG_PTE` | **771322** | GBPUSD H1 | idem | `b45dd00` | `26a1856` 19/08 | **1.01 · 649** |
| 17 | `ABTG_CostToCost` | **772361** | EURJPY H4 | 1.00 · 1078 | `b45dd00` | `26a1856` 19/08 | **1.00 · 1093** |
| 18 | `ABTG_CostToCost` | **772362** | GBPCAD H4 | idem | `b45dd00` | `26a1856` 19/08 | **1.00 · 1093** |
| 21 | `ABTG_GapContinuation` | **774101** | 225JPY M1 | 1.50 · 1551 | `b45dd00` | `26a1856` 19/08 | **1.50 · 1568** |
| 24 | `ABTG_SuperWave` | **770531** | U30USD H4 | 1.00 · 563 | `b45dd00` | `872dba8` 08/09 | **1.01 · 637** |
| 33 | `ABTG_SuperWave_DOW_H1_Ott` | **770511** | U30USD H1 | 1.00 · 563 | `b45dd00` | `872dba8` 08/09 | **1.01 · 645** |
| 29 | 🔴 `ABTG_EMA200` | **771531** | U30USD H1 | 1.00 · 486 | `b45dd00` | `26a1856` 19/08 | **1.00 · 552** |
| 30 | `ABTG_EMA200_Ottimizzato` | **971501** | XAUUSD H4 | 1.00 · 486 | `b45dd00` | `65de32c` 11/09 | **1.00 · 606** |
| 31 | `ABTG_SupertrendReversal` | **770924** | 225JPY H2 | 1.00 · 604 | `b45dd00` | `872dba8` 08/09 | **1.01 · 665** |
| 32 | `ABTG_SupertrendReversal_Ott` | **970901** | XAUUSD H4 | 1.00 · 576 | `b45dd00` | `872dba8` 08/09 | **1.01 · 614** |
| 37 | `ABTG_Nasdaq_Apertura_US` | **770250** | NASUSD M15 | 1.00 · 2032 | **`b5d904a`** 29/08 *"WIP FASE 2 DRIVE"* | `d83c196` 19/08 | **1.02 · 2382** |

### ✅ AGGIORNAMENTO 15/09/2026 — S1 CHIUSO, il bersaglio giusto oggi è HEAD, non "pre-WIP"

**Le colonne "bersaglio pre-WIP" qui sopra sono la strada S2 (mai scelta,
sconsigliata). Con S1 chiuso stanotte (`b45dd00` e `b5d904a` PASS del doppio
cancello, verificato riga per riga: nessuna riga tocca `OrderSend`/
`PositionModify`/`PositionClose`/lotto/rischio/stop/target/ingresso-uscita —
`CHECKLIST_RIGA_DI_LANCIO.md` classi 339), il bersaglio corretto per queste 13
sedie è **HEAD di oggi**, esattamente come per il Blocco 2. Verificato ORA
(15/09, `git log -1` su ciascun file — nessun commit successivo a `b45dd00`/
`b5d904a` li tocca, HEAD è ancora quel commit) che versione e righe (`wc -l`+1,
stessa convenzione di CODA_06) da leggere DOPO l'F7 sono:**

| # | EA | magic | sym · TF | ➡️ bersaglio **HEAD oggi** | ver · righe attesi |
|---:|---|---|---|---|---|
| 2, 22, 23 | `ABTG_PTE` (×3, sedie 771321/771332/771322) | vedi sopra | U30USD/GBPUSD H1 | `b45dd00` | **1.01 · 777** |
| 17, 18 | `ABTG_CostToCost` (×2, sedie 772361/772362) | vedi sopra | EURJPY/GBPCAD H4 | `b45dd00` | **1.00 · 1211** |
| 21 | `ABTG_GapContinuation` | **774101** | 225JPY M1 | `b45dd00` | **1.50 · 1655** |
| 24 | `ABTG_SuperWave` | **770531** | U30USD H4 | `b45dd00` | **1.01 · 767** |
| 33 | `ABTG_SuperWave_DOW_H1_Ott` | **770511** | U30USD H1 | `b45dd00` | **1.01 · 775** |
| 29 | 🎯 `ABTG_EMA200` **(priorità)** | **771531** | U30USD H1 | `b45dd00` | **1.00 · 691** |
| 30 | `ABTG_EMA200_Ottimizzato` | **971501** | XAUUSD H4 | `b45dd00` | **1.00 · 749** |
| 31 | `ABTG_SupertrendReversal` | **770924** | 225JPY H2 | `b45dd00` | **1.01 · 795** |
| 32 | `ABTG_SupertrendReversal_Ott` | **970901** | XAUUSD H4 | `b45dd00` | **1.01 · 744** |
| 37 | `ABTG_Nasdaq_Apertura_US` | **770250** | NASUSD M15 | `b5d904a` | **1.02 · 2567** |

🔴 **Attenzione alla versione**: a differenza dei 6 rossi del Blocco 2 (dove
`872dba8` alza il `#property version` apposta per il riconoscimento), il commit
`b45dd00` **NON alza la versione** su nessuno dei 10 file (resta quella di
campo, es. EMA200 resta `1.00`). **Il discriminante qui è SOLO la scheda
Input**: cerca l'input `InpLogImbuto` (default `true`) nell'elenco dei
parametri — se c'è, hai ricompilato da HEAD; se non c'è, sta ancora girando il
binario vecchio. Le righe restano comunque una prova indipendente via CODA_06
la notte dopo.

👉 **Ordine consigliato dentro il Blocco 3**: `ABTG_EMA200` (771531) **per
prima** — è il file più corto del gruppo (buon canarino), zero include
condivisi con gli altri 9 (verificato: un errore su questa non implica un
errore sulle altre), ed è la sedia che sblocca il pilastro del piano di
ottobre. Le altre 12, in qualunque ordine dopo.

### ❓ COSA MANCA PRIMA DI POTERLE TOCCARE — e chi lo deve chiudere

**Due strade, e sono alternative, non sequenziali:**

| strada | cosa serve | 👤 chi |
|---|---|---|
| **S1 — far passare il WIP dal cancello** | Le ~2.000 righe di `b45dd00` (l'*imbuto di mortalità*, dichiarato "solo log") + `b5d904a` sul Nasdaq devono ricevere un **PASS** dai due strati del cancello (`controlla_riga.py` + agente `controllo-preventivo`). Poi HEAD torna a essere un bersaglio legittimo e queste 13 rientrano nel blocco 2 | 🤖 **agenti** — ~~lavoro già dichiarato aperto~~. 🟢 **CHIUSO IL 15/09/2026**: `b45dd00` **PASS 10/10 EA** (verificato riga per riga, nessuna riga tocca OrderSend/PositionModify/lotto/rischio/stop/target/ingresso-uscita — `CHECKLIST_RIGA_DI_LANCIO.md` classe 339 per il dettaglio; ha anche trovato un buco reale nello strato 1 del cancello stesso, classe 339, in correzione separata). `b5d904a` **PASS** (cambio di meccanismo FASE 2/F1 su Nasdaq, opt-in via `InpMinBreakoutRangeATR`, default 0.0 = comportamento storico provato bit-a-bit identico per la sedia viva 770250 — nessun ramo morto, dispatch esaustivo). Compilazione VERA non verificata (nessun MetaEditor in sessione): resta il primo collaudo di un F7/del runner. **Bonus trovato**: la nota del 12/09 che aveva ritirato `r133a` dalla coda si è rivelata più severa del necessario — a `InpEntryMode=0`/default il meccanismo NON cambia; `r133a` potrebbe rientrare, decisione di chi gestisce l'imbuto/Claudio, non presa qui.
| **S2 — compilare il commit pre-WIP** | Riportare il file alla versione del commit in colonna *«bersaglio pre-WIP»*, compilare quella, e **non** HEAD | 👤 **Claudio decide se vuole questa strada**; ⚠️ **serve una procedura di checkout selettivo che questo runbook NON detta** (è una riga verso il VPS/repo, e va al cancello prima). **Buco dichiarato, §6** |

🔴 **Finché nessuna delle due è chiusa: queste 13 sedie NON si toccano.**
Un `F7` su tutto il progetto in MetaEditor **le prende dentro lo stesso**, ed è
il modo più facile di sbagliare tutto il runbook. **Si compila file per file,
mai il progetto intero.**

---

# 3. 🖱️ IL PASSO PRATICO DENTRO MT5 — 👤 lo esegue CLAUDIO

> 🪟 **BERSAGLIO: terminale MT5 `50503392`**, quello la cui cartella programma è
> `C:\Program Files\BCM Markets MT5 Terminal`.
> 🔴 **NON `... MT5 Terminal -V3` (100k 50504263). NON `C:\BCM_Reale` (REALE
> 10105439). NON `C:\MT5_Backtest` (50504400).**
> ✋ Se c'è il minimo dubbio su quale finestra sia, **prima** si stampa
> l'identificazione: `Get-Process terminal64 | select Id, MainWindowTitle, Path`
> — 🖥️ **su una finestra PowerShell del VPS**. È di sola lettura e non apre
> né chiude niente. Il riconoscimento dev'essere un fatto stampato, non un
> colpo d'occhio sul titolo.

## 3.1 La sequenza, per UNA sedia

1. 🪟 **Sul terminale `50503392`**: si apre **MetaEditor** con `F4` **da quel
   terminale**, così MetaEditor eredita la cartella dati giusta.
   ⚠️ **Non si tocca il pulsante `AlgoTrading` (`Ctrl+E`)**: spegnerlo
   fermerebbe tutte e 40 le sedie, non solo quella in lavorazione.
2. 📂 In MetaEditor: `Navigator` → `Experts` → **si apre il singolo `.mq5`
   della sedia in tabella**, e si compila **quel file aperto**.
3. ⌨️ **`F7`** (Compila) con il file della sedia in primo piano.
   🔴 **Mai la compilazione di cartella** (tasto destro sulla cartella
   `Experts` → `Compila`): prenderebbe dentro le **13 sedie bloccate** del
   blocco 3, che il commit stesso dice di non compilare.
4. 👀 Scheda **`Errori`** in basso: deve dire **`0 errori, N avvisi`**.
   🔴 **Se c'è anche UN solo errore: ci si ferma qui e non si tocca il
   grafico.** Il `.ex5` vecchio resta al suo posto e la sedia continua a
   girare com'era. Nessun danno. L'errore si porta in chat.
5. 🔄 Tornare sul terminale `50503392`. MT5 **ricarica da solo** l'EA sui
   grafici che lo usano dopo un F7 riuscito. Per averne conferma **e** per
   forzare un `OnInit` pulito: **tasto destro sul grafico → `Lista degli
   Expert Advisor` / `Proprietà` → `OK`**.
6. ✅ Si fa la verifica del **§4** su quella sedia. **Solo dopo** si passa alla
   successiva.

## 3.2 ⚠️ «Ricarica» oppure «rimuovi e rimetti»? — non è la stessa cosa

| gesto | cosa succede agli input | quando serve |
|---|---|---|
| **F7 + ricarica** *(consigliato qui)* | Gli input **già presenti sul grafico mantengono il valore salvato**. Gli input **NUOVI** prendono il loro **default dal sorgente** | ✅ È il gesto giusto per **tutte e 22** le sedie del blocco 2, perché la cosa nuova (`InpUsaGuardian`) è un **input nuovo** e prende `true` da sola |
| **rimuovi e rimetti** | 🔴 **Si perde tutta la configurazione del grafico** e ogni input torna al default del sorgente | ⚠️ **NON serve per nessuna sedia di questo runbook**, e **su una sedia tarata è un modo di cancellare una taratura**. Se mai servisse, **prima** si salva il preset (`Salva` nella finestra degli input) |

## 3.3 🟢 Perché `InpUsaGuardian` non richiede nessuna decisione

In **tutte e 10** le famiglie del blocco 2 la riga è **identica al byte** ed è
il **PRIMO** input del file:

```
input bool InpUsaGuardian = true;  // Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)
```

Con la **ricarica** prende `true` da solo. E nel **ramo A** del PASSO 0 (niente
Guardian sul piccolo) **non cambia il comportamento di un tick**, perché la
guardia è **fail-open** quando il canale non esiste
(`mql5/Include/ABTG_PausaGuardian.mqh` r.765). 👉 **È un filo, non una rete: si
posa ora e servirà il giorno del ramo B.**

## 3.4 🔴 LE TRE SEDIE DOVE LA RICOMPILAZIONE TOCCA UN VOLUME — **si segnala, non si decide**

| sedia | cosa cambia col bersaglio | ⚖️ effetto del gesto |
|---|---|---|
| **26 · `DAX_Apertura_EU` 770101** | `9638318` 02/09 porta `ABTG_DEF_RISK` da **2.0 a 1.0** — cioè il **default** di `InpRiskPercent` | 🟡 **Con la RICARICA il valore sul grafico NON cambia**: `InpRiskPercent` è un input **già esistente**, quindi vince quello salvato. 🔴 Con «rimuovi e rimetti» invece **passerebbe a 1.0**. 👉 **Questo runbook non propone né l'uno né l'altro: è una taglia, ed è firma di Claudio.** Porta anche `bc11093` (guardia A4 `storicoOk`) e `c88d160`/`InpAllowReverse` (opt-in) |
| **27 · `Dow_Apertura_US` 770202** | `8b92214` 14/08, guardia A4 `storicoOk`: la giornata si timbra **solo se lo storico ha risposto**. Difetto corretto: a storico non sincronizzato la guardia «un solo ciclo» passava e non si ripeteva mai più | 🟢 **Rende più stretto un limite, non più largo**: può togliere un ciclo, non aggiungerne |
| **34 · `SupRev_DAX_H4_Ott` 970912** · **35 · `SupRev_NAS_H1_Ott` 970913** | `872dba8` 08/09: **pavimento del lotto minimo PRIMA di `lotPend`**. Il difetto piazzava fino al **doppio** del rischio dichiarato (misurato in campo il 20/08: **1,42% su un contratto da 1,0%**) | 🟢 **Il gesto ABBASSA un volume che era sbagliato in alto.** Non alza niente |
| **25 · `MaxMinNotte` 770402** | `d4da7d7` (breakeven staccato dal parziale) · `3af47ed` (sizing) · `7d0da9f` 03/09 (**`InpOneTradePerDay` ora letto davvero**: prima era dichiarato e mai usato) | 🟡 **`InpOneTradePerDay` da inerte diventa attivo**: a `true` questa sedia passerà da *"quanti ne capitano"* a **uno al giorno**. È un cambio di **frequenza**, non di taglia — ma va **visto**, non scoperto |

🟢 **E il declassamento che evita un allarme sbagliato**: il fix di sizing
`3af47ed` è stato **misurato su 225JPY**, e **nessuna** delle sedie a cui manca
gira su un simbolo JPY. Resta 🟠 `[NON MISURATO]`, non 🔴.

---

# 4. 🔍 LA VERIFICA POST-RICOMPILAZIONE — una riga per ogni sedia toccata

## 4.1 🔴 PRIMA, la brutta notizia, detta chiaramente

**Ho cercato nel codice una stampa che identifichi la versione all'avvio, e NON
C'È.** Nessuno di questi EA stampa la propria versione in `OnInit`: le uniche
`Print` trovate nell'inizializzazione sono **messaggi di errore** dei controlli
sugli input, che a EA sano **non escono mai**.

👉 **Quindi la risposta alla domanda «c'è un log che esiste solo nel sorgente
nuovo?» è: NO, non uno che si stampi da solo a ogni caricamento.**
*(Unica eccezione trovata, e non usabile: `Dow`/`DAX` stampano* `"storico deal
non ancora pronto: rimando il controllo A4 al prossimo tick."` *— stringa che
esiste solo nel codice nuovo, ma che esce solo in una condizione di gara allo
startup: se non esce non prova niente.)*

**Ma esistono due prove migliori del log, e sono tutte e due binarie.**

## 4.2 ✅ PROVA 1 — la scheda `Input`, **una sola occhiata, vale per 22 sedie su 22**

> 🪟 Terminale **`50503392`** · tasto destro sul grafico → **`Lista degli Expert
> Advisor`** → doppio clic sulla sedia → scheda **`Parametri di ingresso`**.
>
> ## 👉 **La PRIMA riga dell'elenco deve dire:**
> ## `Guardian: rispetta pausa giornaliera (B1) e cap rischio aperto (C1)` → `true`

**Perché è una prova e non un indizio:** il censimento CODA_06 dice `GUARD = no`
per **36 sedie su 40**, e `GUARD = no` significa che **la parola
`InpUsaGuardian` non compare affatto nel sorgente in campo** — né come input né
come chiamata (generatore `CODA_06_quale_codice_gira.ps1` r.89). Quindi:

- **riga assente** → sta ancora girando il binario di agosto → **il gesto NON ha morso**;
- **riga presente in cima** → sta girando un binario post-migrazione Guardian → **il gesto ha morso**.

✅ **Verificato da me file per file**: `InpUsaGuardian` è presente **e primo**
nel bersaglio di tutte e 22 le sedie del blocco 2.

## 4.3 ✅ PROVA 2 — il numero di versione, dove cambia

Sei sedie su 22 cambiano numero di versione, e il commit `872dba8` dichiara
**testualmente** che l'ha alzato apposta *"per riconoscere dal titolo della
finestra MT5 se il terminale ha l'EA corretto o quello vecchio"*:

| sedia | versione ATTESA dopo il gesto |
|---|---|
| 3-4-5 `BreakingBand` 772161/2/3 | **1.02 → 1.05** |
| 25 `MaxMinNotte` 770402 | **1.10 → 1.11** |
| 26 `DAX_Apertura_EU` 770101 | **1.00 → 1.01** |
| 27 `Dow_Apertura_US` 770202 | **1.00 → 1.01** |
| 34 `SupRev_DAX_H4_Ott` 970912 | **1.00 → 1.01** |
| 35 `SupRev_NAS_H1_Ott` 970913 | **1.00 → 1.01** |

⚠️ **`[NON VERIFICATO DA ME]`**: *dove esattamente* MT5 mostri quel numero. Lo
riporto **come lo dichiara l'autore del commit**, non come misura mia. Il punto
dove il numero è certamente leggibile è **MetaEditor**, sulla riga
`#property version` del file appena compilato.
🔴 **Per le altre 16 sedie del blocco 2 la versione NON cambia** (es. `GapFill`
resta 1.00, `PunteLarry` resta 1.00): **su quelle la versione non è un
discriminante e la PROVA 1 è l'unica che serve.**

### 🎁 Bonus: una discriminante scritta nell'etichetta, per la 770402
`MaxMinNotte` a bersaglio ha, nella scheda `Input`:
`Un solo trade al giorno (v1.11: ora e' applicato davvero)` — **il numero di
versione è dentro l'etichetta dell'input.** Se si legge quella frase, la 770402
è nuova. Se si legge la vecchia etichetta, no.

## 4.4 ✅ PROVA 3 — quella che non richiede occhi: **la data dell'`.ex5`**

Il censimento notturno **CODA_06** stampa già, per ogni EA, *versione · righe ·
GUARD · data dell'`.ex5` accanto*. Dopo un F7 riuscito **la data dell'`.ex5`
diventa quella di oggi**.

👉 **Il referto CODA_06 della notte successiva è la prova indipendente e
automatica che il gesto ha morso**, sedia per sedia, senza che nessuno debba
ricordarsi di guardare niente. 🟢 **Non serve nessuna riga nuova**: il giro
gira già. *(È anche la prova che chiude il `[LIMITE DICHIARATO]` del §1.4
dell'inventario: si può leggere il sorgente e la data, mai il binario.)*

## 4.5 🧾 La riga da compilare per ogni sedia toccata

```
sedia <magic> · ricompilata il 14/09 alle __:__ ·
  F7: 0 errori / __ avvisi
  scheda Input, prima riga = "Guardian: rispetta pausa..."   [ SI / NO ]
  versione letta = ____   (attesa: ____ , oppure "non cambia")
  CODA_06 della notte: .ex5 datato ____                      [ da riempire domani ]
```

---

# 5. 💣 PERCHÉ NON SI RICOMPILA TUTTO IN UN COLPO

## 5.1 La ragione, non solo la regola

Era già scritto in `PIANO_CHALLENGE_OTTOBRE_v2.md` **A5-bis** e in
`IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md`, e si ripete qui **con il motivo**:

> **Un «F7 su tutto» porterebbe in campo, in un colpo solo e senza collaudo, un
> mese di modifiche mai girate su quel conto — comprese quelle che cambiano le
> taglie.**

I numeri dietro la frase:

| fatto misurato | numero |
|---|---:|
| sedie vive sul piccolo 50503392 | **40** |
| sedie il cui binario in campo **non è** quello del repo | **35** |
| di cui quelle a cui manca **una riparazione che tocca i lotti o gli ordini** | **15** |
| sedie il cui sorgente in campo **non nomina nemmeno** la guardia | **36 su 40 (90%)** |
| **sedie su cui HEAD porta lavoro dichiarato NON VERIFICATO dall'autore stesso** | **13** |
| righe mai passate dal cancello che un «F7 su tutto» metterebbe in campo | **~2.000** |

## 5.2 🔴 E il difetto specifico del «tutto insieme»: **non si sa più chi è stato**

Se si ricompilano 40 sedie in un pomeriggio e il giorno dopo il conto si muove
in modo strano, **non c'è modo di sapere quale delle 40 l'ha fatto**. Questo non
è un rischio teorico: **15 sedie cambiano un volume**, e i loro effetti si
sommano sullo **stesso** conto, sulle **stesse** ore.

Con «una per volta» invece ogni cambiamento ha **un nome**, e il gesto si può
**disfare** (basta ricompilare il commit precedente di quel singolo file). Con
«tutto insieme» l'unico modo di tornare indietro è ricompilare 40 file.

📌 **È la stessa disciplina del criterio di uscita firmato il 18/08**: *si spegne
la SEDIA colpevole, non la famiglia*. Un riallineamento «tutto insieme» rende
**impossibile** applicare quel criterio, perché cancella l'attribuzione.

## 5.3 ✅ LA RACCOMANDAZIONE, in una riga

> ## 🛡️ **Guardian prima (o il ramo A del PASSO 0, dichiarato). Poi UNA SEDIA PER VOLTA, con la verifica del §4 fra una e la successiva. Mai una compilazione di cartella o di progetto — perché lì dentro ci sono le 13 sedie che il commit stesso dice di non compilare.**

---

# 6. 🕳️ I BUCHI — dichiarati, non indovinati

Cose che **servirebbero a questo runbook e NON sono scritte nei due referti**.
Le elenco invece di riempirle a intuito.

| # | buco | perché pesa | 👤/🤖 chi lo chiude |
|---:|---|---|---|
| **B1** | 🔴 **Chi chiude il WIP `b45dd00`+`b5d904a`, e quando.** Verificato il 14/09: **ancora aperto**, nessun commit successivo lo tocca. Le **13 sedie** del blocco 3 restano ferme finché resta così | Sono **13 sedie su 40**, e dentro c'è `EMA200` **771531** — la sedia che il censimento del 09/09 indica come l'unica a passare i cancelli di oggi alla lettera | 🤖 **agenti** (far passare l'imbuto di mortalità dal cancello). Se non succede entro pochi giorni, **è una domanda per Claudio**: vale la pena la strada S2? |
| **B2** | ⚠️ **La procedura per compilare un commit pre-WIP (strada S2) non esiste scritta da nessuna parte.** Richiederebbe un checkout selettivo verso la cartella del terminale — cioè una **riga nuova**, che deve passare dal cancello prima di esistere | Senza questa, la strada S2 è un'idea, non un'opzione eseguibile | 🤖 agente + 🚦 cancello, **prima** che la riga arrivi a Claudio |
| **B3** | 🔴 **Quali input porta oggi ogni grafico del piccolo** (i `.chr`/preset). `A2_I_PRESET_DEL_CONTO_CHALLENGE_2026-09-13.md` **copre il 100k `50504263`, non il piccolo** — l'ho aperto e verificato | Serve per sapere se, dopo la ricarica, `InpRiskPercent` della **770101** resta a 2.0 o è già a 1.0. **Senza questo, §3.4 riga 1 resta un'ipotesi con due rami** | 🤖 agente su `CODA_08_preset_dai_chr` (sola lettura), oppure 👤 Claudio con un'occhiata alla scheda Input |
| **B4** | ⚠️ **La distinzione «arancione» vs «rosso» esiste per FAMIGLIA, non per singola sedia.** L'inventario dà i conteggi (20 🟠 / 15 🔴) e il raggruppamento per famiglia al §3, **non una colonna per sedia**. La colonna *«tocca i lotti?»* del §2 qui sopra è **ricavata dal raggruppamento per famiglia**, non letta riga per riga | Per le famiglie a più sedie (GapFill ×5, PunteLarry ×6) l'attribuzione è la stessa per tutte, quindi regge. **Ma è una derivazione mia, e la dichiaro** | 🤖 già derivabile dai commit: non serve una misura nuova, serve una colonna in più al prossimo giro dell'inventario |
| **B5** | 🔴 **Quale preset debba portare il Guardian sul piccolo, nel ramo B.** Il referto dice che il Guardian sul 100k e sul reale c'è, ma **quale configurazione avrebbe sul piccolo non è scritta** | Nel ramo B è il primo gesto in assoluto: senza il preset, si attaccherebbe un Guardian con i default | 👤 **firma di Claudio** — è un parametro di rischio, fuori da questo runbook per costruzione |
| **B6** | ⚠️ **`[NON MISURATO]` e lo resta: il CONTENUTO dei binari `.ex5`.** Si legge il sorgente accanto e la data, non l'eseguibile. Per il **Guardian del piccolo** la data **contraddice** il sorgente (§1.2) | È il limite strutturale di tutta questa famiglia di misure, e va ripetuto ogni volta che si cita un numero di righe «in campo» | — *(non chiudibile con gli strumenti di oggi)* |

---

# 7. ✅ COSA HO FATTO IO QUI · 🚫 COSA NON HO FATTO

## 🟢 Fatto (sola lettura + sintesi)
1. Letti **per intero** i due referti e ricostruita la tabella delle 40 sedie in
   forma **eseguibile** (bersaglio per sedia, non solo diagnosi).
2. 🔎 **Verificato su git il 14/09** (HEAD `5fe259d`) che il WIP `b45dd00`
   **non è stato chiuso**: `git log -1` su tutti e 10 i file torna ancora
   `b45dd00`, e su `Nasdaq_Apertura_US` torna `b5d904a`.
3. 🔎 **Trovato e verificato il commit pre-WIP per tutte e 13** le sedie
   bloccate, con versione e righe attese.
4. 🔎 **Cercata la stampa di versione all'avvio: non esiste** — e al suo posto
   ho verificato due discriminanti migliori (`InpUsaGuardian` primo input,
   identico al byte in 10 famiglie · la data dell'`.ex5` letta da CODA_06).
5. ⚖️ Trasformato *«Guardian prima»* nella sua versione **vera sul piccolo**:
   il Guardian **non è attaccato** e la ragione è una **decisione del 06/09** —
   quindi il PASSO 0 è una scelta, e ho scritto la trappola del ramo B.

## 🚫 Non fatto, per costruzione
- **Nessun terminale aperto, nessun F7, nessun grafico toccato, zero righe verso
  il VPS.** Il conto reale **10105439** non compare e non è stato letto.
- **Nessuna proposta su rischi, taglie, preset o acquisti.** Dove il gesto ne
  tocca uno, §3.4 lo **segnala** e si ferma.
- **Nessuna ricerca nuova**: questo documento sintetizza, e ogni numero ha la
  sua fonte accanto.

---

_Fonti: `report/IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md` ·
`report/INVENTARIO_CAMPO_PICCOLO_2026-09-14.md` (§2 tabella, §3 commit mancanti,
§4 Guardian, §5.1 le 13 WIP) · `report/PIANO_CHALLENGE_OTTOBRE_v2.md` r.302
(A5-bis) e r.379 · `report/A2_I_PRESET_DEL_CONTO_CHALLENGE_2026-09-13.md`
(verificato: copre il 100k, non il piccolo) · `report/CENSIMENTO_CONTRATTI_v2.md`
§4 (decisione 06/09) · `mql5/Include/ABTG_PausaGuardian.mqh` r.765 (fail-open) ·
`backtest_pipeline/righe/CODA_06_quale_codice_gira.ps1` r.89 (definizione di
`GUARD`) · `git log`/`git show` su `lavoro`, HEAD `5fe259d` del 14/09._
