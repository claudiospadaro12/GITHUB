# 🔧 LA TOPPA È PRONTA — **chiusura per TICKET**, censita, misurata e mai applicata

**19/09/2026** · branch `lavoro` · 🚫 **SOLA LETTURA su `mql5/`: nessun `.mq5` e nessun `.set`
è stato modificato in questo giro.** Le toppe sono **diff**, qui sotto e in
`/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/toppa/`.
**Ricompilare e mettere in campo è firma di Claudio.**

Mandato: chiudere il punto ② di `report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md` («strada 1»),
allargandolo a tutta la flotta come chiedeva `report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md`.

---

## ① 🔴 LA NOTIZIA CHE NON C'ERA IN NESSUNO DEI DUE REFERTI: **non chiude UNA posizione del vicino. Le chiude A CATENA.**

I due punti di chiamata dell'Apertura girano a **OGNI TICK**, non una volta:

```mql5
// ABTG_OnTick(), @3af47ed9 r.556-560 — NESSUNA guardia di stato prima
if(TimeInMinutes(now) >= InpCloseHour*60 + InpCloseMin)
  { EndOfSession(); return; }
```

Verificato riga per riga: in `ABTG_OnTick()` **non esiste** un `if(gPhase==PH_DONE) return;`
prima di quel controllo (le uniche occorrenze di `PH_DONE` sono rr. 296, 543, 583, 640, 1176,
1184, 1861 — nessuna è un'uscita anticipata di tick). E `EndOfSession()` è:

```mql5
if(InpCloseAtEnd && SelectMyPosition())
  { gTrade.PositionClose(_Symbol); ... }
```

👉 **Finché la NOSTRA posizione esiste, la guardia resta vera e la chiusura per simbolo
riparte: un vicino per tick, dal più vecchio in giù, finché la nostra non diventa la più
vecchia.** Su `U30USD` del piccolo, dove `ABTG_Dow_Apertura_US 770202` ha **7 vicini**, non è
un incidente: è un **flatten di simbolo** mascherato da chiusura di fine sessione.

🟢 Il meccanismo era già stato nominato in casa — nel commento di `ABTG_ORB_Ottimizzato` v1.04
(*«il ciclo che chiude i vicini a catena»*). **Non era mai stato riportato sulla famiglia
Apertura**, che è quella in campo su tre conti.

### 🔫 E la sicura è tolta: `InpCloseAtEnd=true` in **tutti** i preset
| preset | `InpCloseAtEnd` | `InpUseNewsFilter` |
|---|---|---|
| `ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` | **true** | false |
| `ABTG_DAX_Apertura_EU_LEGACY_2pct.set` | **true** | false |
| `ABTG_Dow_Apertura_US_U30USD_M5_770202_100K.set` | **true** | false |
| `ABTG_Nasdaq_Apertura_US.set` | **true** | **true** |

👉 Sul DAX e sul Dow il sito del **blackout notizie** è **morto** (`InNewsBlackout()` esce
subito se `!InpUseNewsFilter`): resta vivo **solo** `EndOfSession()`. Sul Nasdaq sono vivi
**tutti e due**.

---

## ② 💯 LA MISURA — **la condizione che arma il difetto si presenta nel 21,8% dei trade. È andata bene per FORTUNA.**

Non l'ho argomentato: sono andato a contarlo su `data/statements/trades_auto.csv`
(1.322 righe, 30/03/2026 → 18/09/2026). Per ogni posizione di un magic 🟠, al suo **istante
di chiusura**, esisteva sullo stesso simbolo una posizione **aperta PRIMA**, di altro magic?

| | |
|---|---:|
| posizioni di EA 🟠 nel campione (770101, 770202, 770201, 770250) | **55** |
| di cui con almeno un **vicino più vecchio aperto** alla chiusura | **12 (21,8%)** |
| di cui chiuse **dall'EA** (`close_reason=expert`, cioè il pulsante premuto davvero) | **3** |
| 🟢 **sovrapposizione fra i due insiemi** | **0** |

I tre casi in cui l'EA ha **davvero** chiamato `PositionClose(_Symbol)`:

| quando | simbolo | magic | vicino più vecchio? |
|---|---|---|---|
| 2026.07.28 17:30:00 | D30EUR | 770101 | **no** |
| 2026.08.07 17:30:00 | U30USD | 770202 | **no** |
| 2026.08.28 17:30:00 | D30EUR | 770101 | **no** |

I dodici in cui il vicino più vecchio **c'era** (estratto):
`2026.07.29–30` — **cinque** posizioni `770101` su D30EUR mentre `970911` stava aperta dal
29/07 07:00 al 31/07 07:01 · `2026.08.28 16:05` — `770202` su U30USD mentre `772341`
(PunteLarry) stava aperta dal **25/08 al 31/08**. **Tutte e dodici chiuse dallo `sl`**: lo stop
del broker è arrivato prima, e l'EA non ha mai premuto il pulsante.

> ## 🔴 **Il danno non è mai stato osservato perché le due condizioni non si sono mai incrociate in 55 trade. Non perché il codice lo impedisca.** Stima di casa, dichiarata come stima: 5,5% × 21,8% ≈ **1,2% per trade**, cioè **~0,65 eventi attesi** su 55. Zero osservati è **coerente col caso**, non una prova di sicurezza.

🔴 **E per le due sedie nuove sul Nasdaq la probabilità non c'entra più**: `770260`/`770261`
flattano alle **17:30**, `770250` per contratto vive fino alle **20:45**. La condizione non è
casuale, è **scritta nei preset**. Quello non è un rischio: è un appuntamento.

---

## ③ 🗺️ IL CENSIMENTO — 76 siti, 21 file, e l'ordine giusto è **per DANNO**, non per numero

`mql5/Experts/*.mq5` (escluso `standalone/` ed `esterni/`): **76 chiamate `CTrade` che prendono
il SIMBOLO invece del TICKET**, in **21 file**. Ma il numero di occorrenze non dice niente, e
la ragione è una sola:

> 🔑 **Solo un EA che legge BENE e scrive MALE può fare danno al vicino.**
> Un EA 🔴 (legge male *e* scrive male) è **cieco ma coerente**: se la sua guardia è vera,
> vuol dire che la più vecchia È la sua, e la chiude. Non fa danni a nessuno — **non fa
> niente**. Sono gli **8 🟠** i fail-open attivi.

### 🏆 CLASSIFICA PER DANNO REALE = (scrittura cieca ATTIVA) × (sedia ATTACCATA) × (vicini VERI sullo stesso terminale)

| # | EA · magic | terminale (conto) | simbolo | vicini | perché è lì |
|---:|---|---|---|---:|---|
| **1** | `ABTG_Dow_Apertura_US` **770202** | `BCM Markets MT5 Terminal` (**50503392**) | U30USD | **7** | 771321, 772234, **772341** (pluri-giorno: misurata 25→31/08), 770531, **771531** (EMA200: 33-35 op/mese = la macchina che tiene U30USD occupato più di tutte), 770511, 770611. **Catena fino a 7 chiusure.** Flat 17:30 ogni giorno |
| **2** | `ABTG_Nasdaq_Apertura_US` **770250** | `BCM Markets MT5 Terminal` (**50503392**) | NASUSD | **1 → 3** | è **il blocco dichiarato**: con `770260`/`770261` la collisione passa da probabilistica a **strutturale** (17:30 contro 20:45) |
| **3** | `ABTG_DAX_Apertura_EU` **770101** | `BCM Markets MT5 Terminal` (**50503392**) | D30EUR | **2** | 770411 (M15) e **970912** (SupRev H4, pluri-giorno). È il magic 🟠 con **più trade in assoluto** nel campione (39) |
| **4** | `ABTG_Dow_Apertura_US` **770202** | `... MT5 Terminal -V3` (**50504263**) | U30USD | **1** | 770611, M5, **negli stessi minuti** (`PIANO_MIGRAZIONE_100K`, `report/ORB_DOW_100K_COMPRESENZA_2026-09-13.md`) |
| **5** | `ABTG_DAX_Apertura_EU` **770101** | `... MT5 Terminal -V3` (**50504263**) | D30EUR | **1** | 770411 |
| **6** | `ABTG_DAX_Apertura_EU` **770101** | `C:\BCM_Reale` (**10105439**) | D30EUR | **0** | 🟢 **INERTE OGGI** — vedi ④ |
| — | `ABTG_Nasdaq_Apertura_US_Ottimizzato` · `ABTG_DAX_Apertura_EU_Ottimizzato` · `ABTG_Apertura_3Ingressi` · `ABTG_Apertura_Marco` | — | — | — | 🟠 ma **su nessun grafico** (CODA_01 del 18/09). Toppa pronta, rischio zero, nessuna urgenza |
| — | `ABTG_DaxValueArea` r.913 | — | — | — | 🟠 di **un solo carattere**: `ticket` è già in mano due righe sopra (r.873 `ulong ticket = (ulong)PositionGetInteger(POSITION_TICKET);`, usata a r.900). Non in campo |

### 🔵 I 🔴 — ciechi, non pericolosi per i vicini. Elencati **per nome**, non «tutto il resto»
`ABTG_MaxMinNotte` (**attaccato**, XAUUSD 770402, 3 vicini · si auto-acceca, non tocca nessuno) ·
`Gold_Ichimoku_TK_ATR_EA` (**attaccato**, ma su **Tickmill**, dove è **solo** su XAUUSD) ·
`ABTG_DAX_Live5m` · `ABTG_DAX_Live5m_v2` · `ABTG_Nasdaq_Live5m` · `ABTG_ORB` · `ABTG_ORB_Fibo` ·
`ABTG_Londra_ORB` · `ABTG_DAX_M3` · `ABTG_IntradayMomentum` · `GoldBreakout_Levels` ·
`Gold_Scalper_TK_BB_BE_EA` · `IchiCross_Gold_722` · più **11 copie in `standalone/`** e la
libreria madre `mql5/Include/ABTG/ABTG_ApertureCore.mqh` (rr. 385, 884, 898, 904, 1016).

### 🟢🆕 DUE CORREZIONI ALL'AUDIT DEL 03/09, e cambiano le priorità
1. **`Gold_Ichimoku_TK_ATR_EA` non è il #3 della flotta.** L'audit lo metteva lì perché
   *«XAUUSD = 13-14 vicini»* — ma quei vicini stanno sul **piccolo BCM**, e lui gira sul
   terminale **Tickmill**, dove le sedie attive sono **due** e su **simboli diversi**
   (XAUUSD e USDJPY). **Le posizioni non attraversano i terminali**: è di fatto **solo**.
2. **Cinque EA che l'audit dava «accesi» non sono su nessun grafico**: `ABTG_DAX_Live5m`,
   `ABTG_DAX_Live5m_v2`, `ABTG_Nasdaq_Live5m`, `ABTG_ORB`, `ABTG_ORB_Fibo` (+ `Londra_ORB`,
   `DAX_M3`). Il sorgente è sul disco del piccolo, **il grafico no** (CODA_01 del 18/09,
   40 sedie elencate per nome). Il loro «campione sporco» è un problema **storico**, non vivo.

---

## ④ 🟢 LA BUONA NOTIZIA, che va detta con la stessa forza della brutta

**Sul conto REALE 10105439 il difetto oggi è INERTE.** Le quattro sedie attive sono
`ABTG_DAX_Apertura_EU 770101` su **D30EUR**, `ABTG_ORB_Ottimizzato 770611` su **U30USD**,
`ABTG_SlippageLogger` su EURJPY, `ABTG_Guardian 779002` su EURGBP. 👉 **Un EA per simbolo:
la posizione più vecchia di D30EUR è sempre la sua.** In più `ABTG_ORB_Ottimizzato` lì è la
**v1.04** (1464 righe), cioè quella **già corretta** a settembre.

🔴 **Ma è a UN grafico di distanza dal diventare attivo.** La condizione che lo tiene innocuo è
la stessa che il round del Nasdaq ha appena tolto altrove (classe **441**). Va scritta nel
pacchetto della prossima sedia su D30EUR reale, non lasciata implicita.

---

## ⑤ 🔧 LA TOPPA — una funzione nuova, due righe di chiamata, **zero API inventate**

Forma scelta: **NON** la sostituzione secca `PositionClose(_Symbol)` → `PositionClose(ticket)`,
ma il travaso nella funzione già collaudata in campo di `ABTG_ORB_Ottimizzato` v1.04
(`ChiudiPosizioniMie`). Tre hunk per file, sempre gli stessi tre.

### 🧾 Il diff (bersaglio: `ABTG_Nasdaq_Apertura_US.mq5` @ `3af47ed9` = **il binario in campo sul 50503392**)

```diff
--- a/mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5 (3af47ed9)
+++ b/mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5 (3af47ed9 + toppa ticket)
@@ -550,7 +550,7 @@
    if(newsBlk && InpNewsFlatten)
      {
       CancelMyPendings();
-      if(SelectMyPosition()) gTrade.PositionClose(_Symbol);
+      ChiudiMiePosizioni("blackout notizie");   // TOPPA 19/09: per TICKET, non per simbolo
      }
 
    //--- a fine sessione: cancella i pendenti ed (eventualmente) chiudi
@@ -1853,11 +1853,11 @@
    // cancella eventuali ordini pendenti dell'EA
    CancelMyPendings();
    // chiudi la posizione se richiesto
-   if(InpCloseAtEnd && SelectMyPosition())
-     {
-      gTrade.PositionClose(_Symbol);
-      ABTGLog("fine sessione: posizione chiusa.");
-     }
+   // TOPPA 19/09: per TICKET, non per simbolo. ChiudiMiePosizioni() ha gia'
+   // dentro la guardia (se non abbiamo niente non chiama niente) e chiude
+   // ENTRAMBE le nostre quando il whipsaw ha riempito tutti e due i lati.
+   if(InpCloseAtEnd)
+      ChiudiMiePosizioni("fine sessione");
    gPhase = PH_DONE;
   }
 
@@ -1879,6 +1879,64 @@
 bool HasOpenPosition() { return(SelectMyPosition()); }
 
+//+------------------------------------------------------------------+
+//| TOPPA HEDGE-SAFE (19/09/2026) -- chiude TUTTE e SOLE le NOSTRE    |
+//| posizioni, PER TICKET.                                            |
+//|                                                                   |
+//| IL DIFETTO CHE CURA:                                              |
+//|   gTrade.PositionClose(_Symbol), su conto HEDGING, chiude la      |
+//|   posizione PIU' VECCHIA del simbolo, DI CHIUNQUE SIA. La guardia |
+//|   SelectMyPosition() qui sopra era gia' hedge-safe: e' l'AZIONE   |
+//|   che non lo era. Il mezzo fix e' PEGGIO del bug intero, perche'  |
+//|   l'EA trova la PROPRIA posizione, decide di chiuderla, e chiude  |
+//|   quella DEL VICINO.                                              |
+//|                                                                   |
+//|   E non ne chiudeva UNA: le chiudeva A CATENA. I due punti di     |
+//|   chiamata girano a OGNI TICK (il controllo dell'ora sta PRIMA    |
+//|   dello switch e non ha guardia di stato). Finche' la NOSTRA      |
+//|   esiste, la guardia resta vera e la chiusura per simbolo         |
+//|   riparte: un vicino per tick, dal piu' vecchio in giu', finche'  |
+//|   la nostra non diventa la piu' vecchia.                          |
+//|                                                                   |
+//| PERCHE' I TICKET SI FOTOGRAFANO PRIMA E SI CHIUDONO DOPO:         |
+//|   un while(SelectMyPosition()) sarebbe un ciclo su una lettura    |
+//|   che il terminale aggiorna in modo ASINCRONO -> ciclo infinito   |
+//|   e doppia chiusura. La lista si legge UNA volta sola.            |
+//|   Stesso schema gia' in campo in ABTG_ORB_Ottimizzato v1.04       |
+//|   (ChiudiPosizioniMie): non c'e' niente da inventare.             |
+//|                                                                   |
+//| Se non abbiamo NIENTE non parte NESSUNA chiamata: la funzione     |
+//| resta muta invece di ritentare all'infinito.                      |
+//| Ritorna quante ne ha chiuse.                                      |
+//+------------------------------------------------------------------+
+int ChiudiMiePosizioni(const string motivo)
+  {
+   ulong miei[];
+   int   q = 0;
+   for(int _i = PositionsTotal()-1; _i >= 0; _i--)
+     {
+      ulong _tk = PositionGetTicket(_i);
+      if(_tk > 0 && PositionGetString(POSITION_SYMBOL) == _Symbol &&
+         PositionGetInteger(POSITION_MAGIC) == InpMagic)
+        { ArrayResize(miei, q+1); miei[q] = _tk; q++; }
+     }
+   int chiuse = 0;
+   for(int _k = 0; _k < q; _k++)
+     {
+      ResetLastError();
+      if(gTrade.PositionClose(miei[_k]))
+        {
+         chiuse++;
+         ABTGLog(StringFormat("%s: chiusa la posizione #%I64u.", motivo, miei[_k]));
+        }
+      else
+         ABTGLog(StringFormat("%s: PositionClose(#%I64u) FALLITA, retcode %u (%s), err=%d. Riprovo al prossimo tick.",
+                              motivo, miei[_k], gTrade.ResultRetcode(),
+                              gTrade.ResultRetcodeDescription(), GetLastError()));
+     }
+   return(chiuse);
+  }
+
 //+------------------------------------------------------------------+
 //| Spread accettabile?                                              |
 //+------------------------------------------------------------------+
```

### 🔴 Il ticket È disponibile — verificato nel sorgente, non assunto
`SelectMyPosition()` **non salva il ticket in nessuna variabile**. Ma il suo commento dichiara
il contratto, e il codice lo rispetta: `PositionGetTicket(_i)` **seleziona** la posizione, e la
funzione fa `return(true)` **senza toccare altro**. Quindi ci sono **due strade legittime**, e
nessuna delle due inventa un'API:

| | come si prende il ticket | dove è già in campo, provato |
|---|---|---|
| **A · minima, 1 riga** | `gTrade.PositionClose((ulong)PositionGetInteger(POSITION_TICKET));` subito dopo la guardia | `ABTG_MaxMinNotte_DAX_Short_Ottimizzato.mq5` rr. **165** e **389** — compilato e in campo su **tre** terminali |
| **B · quella scelta qui** | la funzione rifà da sé la scansione hedge-safe e si porta via i ticket | `ABTG_ORB_Ottimizzato.mq5` rr. **988-1017** (`ChiudiPosizioniMie`), v1.04, in campo su piccolo e **reale** |

**Perché B e non A**, in una riga: **`770261` può avere DUE posizioni nostre** — verificato nel
sorgente, non dedotto (`BuyStop` r.844 **e** `SellStop` r.868 nello stesso giro, e `HandleOCO()`
r.498 cancella l'opposto solo al **tick dopo** il riempimento). La A ne chiuderebbe una per
tick; la B le chiude entrambe subito. Stesso binario per `770250`/`770260`/`770261`, quindi
serve la B.

---

## ⑥ 🧪 IL CONTRO-ESEMPIO — **ho provato a rompere la mia stessa toppa**

### (a) ❓ Esiste un punto dove la chiusura per SIMBOLO è **VOLUTA** (flatten d'emergenza)?
✅ **NO, e non è una supposizione: i due flatten intenzionali della casa NON compaiono nel
censimento perché chiudono GIÀ per ticket.**
- `ABTG_Guardian.mq5` — `FlattenAll()` r.681, e la chiusura vera è **r.690
  `gTrade.PositionClose(tk)`**, in un ciclo su tutto il conto. Globale **per disegno**, già a
  ticket. **Non si tocca.**
- `mql5/Scripts/ABTG_ChiudiSedie.mq5` — **r.431 `gTrade.PositionClose(tk)`**. Idem.
- `HARSI_Assistant.mq5` filtra per **solo simbolo** (scelta: assistente di trade manuali) ma
  itera **per ticket**: non ha nessuna `PositionClose(_Symbol)`. **Non si tocca.**

👉 Tutti e 76 i siti censiti stanno **dentro una guardia di magic**: nessuno di loro vuole
chiudere roba altrui. **Zero siti dove la toppa sarebbe un peggioramento.**

### (b) ❓ `PositionClosePartial` per ticket ha la **stessa firma**?
✅ **Sì: `(ticket, volume)` ha la stessa arità di `(symbol, volume)`** — è un overload, non una
funzione diversa. Prove **in casa, già compilate**: `ABTG_DaxValueArea.mq5:900` ·
`DAX_MASTER_PROP.mq5:2164` · `ABTG_AllineaLondra.mq5:810` ·
`esterni/Nasdaq_PreOpen_Breakout_EA.mq5:686`.

🔴 **MA c'è una trappola, ed è di TIPO**: `PositionGetInteger()` torna un **`long`**, e
l'overload vuole un **`ulong`**. In tutti e quattro i casi in casa la variabile passata è
**dichiarata `ulong`**, e `ABTG_DaxValueArea.mq5:873` usa proprio il cast esplicito
`ulong ticket = (ulong)PositionGetInteger(POSITION_TICKET);`. 👉 **Nella toppa il cast a
`ulong` non è cosmetica: è la forma provata.** (La forma nuda
`PositionClose(PositionGetInteger(POSITION_TICKET))` di `MaxMinNotte_DAX_Short_Ottimizzato`
compila lo stesso — è in campo — ma si appoggia alla conversione implicita, e non è quello che
consegno.)

### (c) ❓ Su conto **NETTING** la toppa si comporta uguale?
✅ **Sì — e i conti non sono NETTING: è MISURATO, non assunto.**
`backtest_pipeline/coda/referti/CODA_03_conti_dei_terminali_20260918_033004.log`, letto dai
**giornali dei terminali**: **50503392 HEDGING · 50504263 HEDGING · 10105439 HEDGING** ·
50504400 HEDGING · 50503635 HEDGING. (Pepperstone e Tickmill: *«NON TROVATO nel testo — NON
vuol dire netting»*, e lo strumento lo dichiara.)
Sul merito: su netting esiste **una sola posizione per simbolo**, quindi il suo ticket **è**
quella posizione e `PositionClose(ticket)` ≡ `PositionClose(_Symbol)`. **La toppa è neutra.**
⚠️ Onestà: su netting la **guardia** `SelectMyPosition()` diventa fragile (la posizione fusa
porta il magic dell'ultimo deal), ma quello è un difetto **preesistente della lettura**, **non
introdotto dalla toppa**, e su BCM non esiste.

### (d) ❓ La toppa può creare un **ciclo infinito** o una **doppia chiusura**?
✅ **No, e la variante che l'avrebbe creato l'ho scritta e scartata.** La prima stesura era
`while(InpCloseAtEnd && SelectMyPosition()) { ...close... }`. 🔴 **Sbagliata**: `PositionsTotal()`
è una lettura che il terminale aggiorna in modo **asincrono** rispetto al ritorno di
`PositionClose()` — un `while` su quella lettura può rigirare sulla stessa posizione (doppia
chiusura) o non uscire mai. La forma consegnata **fotografa i ticket una volta** e poi cicla su
un array a lunghezza fissa. È la stessa ragione per cui `ABTG_ORB_Ottimizzato` v1.04 lo fa così.

### (e) ❓ La toppa rompe qualcosa **a valle**?
| controllo | esito |
|---|---|
| `ChiudiMiePosizioni` collide con un nome esistente nel repo? | 🟢 **zero occorrenze** prima della toppa |
| `gTrade`, `InpMagic`, `ABTGLog` esistono in **tutti** e 7 i bersagli? | 🟢 **7/7** |
| variabili `miei` / `q` già globali (shadowing)? | 🟢 **nessuna** |
| `gPhase = PH_DONE;` sopravvive in `EndOfSession()`? | 🟢 **sì**, riga subito sotto |
| qualche strumento (`.py`/`.ps1`) dipende dalla stringa `"fine sessione: posizione chiusa."`? | 🟢 **nessuno** |
| funzione **usata prima di essere definita**: MQL5 lo permette? | 🟢 **sì, e lo prova il codice già compilato**: `EndOfSession()` è chiamata a r.675 e definita a r.2098 nello stesso file |
| restano scritture per simbolo dopo la toppa? | 🟢 **zero** — il generatore **rifiuta** il file se ne trova una |
| hunk per file | 🟢 **3**, sempre gli stessi |
| costo a tick | 🟢 **invariato**: prima `SelectMyPosition()` faceva già il giro di `PositionsTotal()` |

### (f) 🔴 IL CONTRO-ESEMPIO CHE **NON** SI DISINNESCA, ed è il più importante di tutti
> ## 🛑 **La toppa costa una riga. La RICOMPILAZIONE costa 534 righe e 21 input.**

Il binario in campo di `ABTG_Nasdaq_Apertura_US` sul **50503392** è **`3af47ed9` del 08/08**
(v1.00, **2033 righe** in CODA_06 = 2032 + EOF ✅). **HEAD è v1.02, 2566 righe.** Fra i due ci
sono **6 commit**, fra cui uno che si chiama, testualmente:
`b5d904ab  WIP FASE 2 DRIVE: modifica in corso su ABTG_Nasdaq_Apertura_US (build agente)`.

E ci sono **21 input nuovi**, fra cui `InpUsaGuardian = true` — **default ACCESO**.
🔴 **I `.set` di `770260`/`770261` hanno 80 input, verificati contro il binario `3af47ed9`.**
Se si ricompila da HEAD, quei 21 input **non sono nel `.set`** e prendono il **default
compilato**: si schiererebbe un EA **diverso da quello che il walk-forward ha validato**, e la
validazione Pass 6 / Pass 8 **decadrebbe**.

🟢 *Attenuante misurata, per non fare allarmismo*: `ABTG_GuardiaIngresso` ha
`pretendi_guardian=false` di default (`mql5/Include/ABTG_PausaGuardian.mqh` r.1589), quindi
senza Guardian **non blocca** gli ingressi. Il problema non è che l'EA si spegne: è che **non è
più l'EA misurato**.

👉 **Conseguenza operativa: la toppa del Nasdaq va applicata a `3af47ed9`, NON a HEAD.** Il
diff pronto è `ABTG_Nasdaq_Apertura_US__3af47ed9.diff`. Se invece si vuole HEAD, allora il round
Pass 6 / Pass 8 **va rifatto**, e va detto prima, non dopo.

---

## ⑦ 💰 IL COSTO, in ricompilazioni e in firme

**Sei binari** coprono tutto il campo (lo stesso `.mq5` è in campo in **vintage diversi** su
terminali diversi: si ricompila **per cartella dati**, non per file).

| # | EA | vintage da patchare | righe (CODA_06) | terminale / conto | siti | diff pronto |
|---:|---|---|---:|---|---|---|
| 1 | `ABTG_Dow_Apertura_US` | `3af47ed9` | 2065 | `BCM Markets MT5 Terminal` · **50503392** | 585 · 1890 | `..__3af47ed9.diff` |
| 2 | `ABTG_Nasdaq_Apertura_US` | `3af47ed9` | 2033 | `BCM Markets MT5 Terminal` · **50503392** | 553 · 1858 | `..__3af47ed9.diff` |
| 3 | `ABTG_DAX_Apertura_EU` | `3af47ed9` | 2133 | `BCM Markets MT5 Terminal` · **50503392** | 602 · 1907 | `..__3af47ed9.diff` |
| 4 | `ABTG_Dow_Apertura_US` | **HEAD** | 2148 | `... MT5 Terminal -V3` · **50504263** | 609 · 1936 | `..__HEAD_lavorativo.diff` |
| 5 | `ABTG_DAX_Apertura_EU` | `d83c1960` | 2361 | `... MT5 Terminal -V3` · **50504263** | 662 · 2098 | `..__d83c1960.diff` |
| 6 | `ABTG_DAX_Apertura_EU` | **HEAD** | 2368 | `C:\BCM_Reale` · **10105439** | 669 · 2105 | `..__HEAD_lavorativo.diff` |

🔴 **La #6 è GIÀ ESCLUSA da una firma, non da una mia opinione.**
`report/FIRMA_2026-09-19_CHIUSURA_PER_TICKET.md` (commit `999b082d`) autorizza la toppa per
ticket e dichiara testualmente che **NON autorizza «ricompilazioni sul conto reale 10105439»**.
👉 Quindi le ricompilazioni **autorizzabili oggi sono 5, non 6**, e la #6 resta ferma —
il che è anche la lettura tecnica giusta (zero vicini, ④: lì il difetto è inerte).
🟢 E la sequenza firmata punta proprio al terminale **50503392**: sono le **#1, #2, #3**, cioè
esattamente le tre righe in cima alla classifica per danno.

📌 **La firma chiedeva un numero che non c'era** (*«Costo: NON MISURATO finché il censimento non
dice quante ricompilazioni»*). 👉 **Eccolo: 6 binari in totale, 5 autorizzabili, 3 che valgono
davvero** (quelle sul piccolo, dove i vicini sono 7 / 1→3 / 2).

Pronti ma **non urgenti** (nessun grafico): `ABTG_Nasdaq_Apertura_US_Ottimizzato` ·
`ABTG_DAX_Apertura_EU_Ottimizzato` · `ABTG_Apertura_3Ingressi` · `ABTG_Apertura_Marco`.
**11 diff generati su 11 bersagli**, tutti passati il controllo dei residui.

### 🧪 Come si misura che la toppa non ha rotto niente
🟢 **Nel tester il difetto è INVISIBILE** (l'EA è solo sul simbolo, nessun vicino): la stessa
cella, prima e dopo, deve dare un risultato **identico al centesimo**. **Se cambia, la toppa ha
rotto altro.** È un test di **non-regressione, non di merito**.
🔴 **Il merito si vede solo in forward**, e si legge nel giornale: la riga nuova
`«fine sessione: chiusa la posizione #<ticket>»` deve portare **il ticket NOSTRO**. E la prova
che il difetto c'era: **nessuna chiusura `expert` di un magic estraneo a 17:30**.
🚫 **Non promettiamo più profitto**: promettiamo che l'EA farà quello che dice il suo pannello,
e che non toccherà la roba dei vicini. Che sia meglio, lo dice il forward.

---

## ⑧ 📌 Difetti di classe NUOVA depositati
- **442** — il costo di una toppa non è la toppa: è il **delta fra HEAD e il binario in campo**.
- **443** — la scrittura cieca dentro una funzione richiamata **a ogni tick** non fa UN danno:
  lo fa **a catena**, e scala col numero di **vicini**, non di errori.

---

*Fonti, per nome: `mql5/Experts/*.mq5` a HEAD e ai vintage `3af47ed9` / `d83c1960` ·
`report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` rr. 39, 89 ·
`report/DUE_SEDIE_NASDAQ_IL_BLOCCO_2026-09-19.md` ②③ ·
`backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_20260918_033004.log` (53 sedie) ·
`CODA_03_conti_dei_terminali_20260918_033004.log` (modo di margine) ·
`CODA_06_quale_codice_gira_20260918_033004.log` (vintage per cartella dati) ·
`data/statements/trades_auto.csv` (1.322 righe) · `mql5/Presets/*.set` ·
`mql5/Include/ABTG_PausaGuardian.mqh` r.1587-1589 ·
`mql5/Experts/ABTG_ORB_Ottimizzato.mq5` rr. 988-1017 e 1119 (il modello) ·
`mql5/Experts/ABTG_Guardian.mq5` r.690 e `mql5/Scripts/ABTG_ChiudiSedie.mq5` r.431 (i flatten
voluti, già a ticket) · script generatore:
`/tmp/claude-0/-home-user-GITHUB/c2d73886-9ef2-5105-8937-d770bc36d6df/scratchpad/genera_toppa.py`*
