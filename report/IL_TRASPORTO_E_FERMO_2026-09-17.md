# 🚚 IL TRASPORTO È FERMO DAL 13/09 — 47 round misurati e illeggibili (17/09/2026)

> **In una riga**: il runner gira ogni notte e produce numeri, ma **i CSV non
> entrano più nel repo dal 13/09**. Ci sono **47 round con i numeri già fatti**
> che da qui **nessuno può leggere**.
>
> 🧭 **Bussola**: questo è più grave del pedaggio della coda. `-Rifai` spreca
> **tempo macchina**; questo spreca **tutto**, perché il risultato non arriva
> mai a chi deve giudicarlo. A tredici giorni dal 1° ottobre è il tappo n.1.
>
> Sola lettura: nessuno script toccato, nessun preset, nessun conto. Il conto
> reale 10105439 non è coinvolto.

---

## 🔎 IL FATTO, verificato in quattro modi

**1. Il runner pubblica SOLO il referto.** `backtest_pipeline/runner_abtg.ps1`
r.829: `$base = "backtest_pipeline/coda/referti/"`. È l'unico prefisso di
destinazione. I CSV **non sono nel suo mandato** — ed è scritto nella sua
stessa intestazione (r.11-14): la metà che pubblica i CSV è un **altro**
script.

**2. Nessuno script `.ps1` del repo fa `git push`.** Grep secco su tutto
`backtest_pipeline/`: **zero occorrenze** di `git add` / `git commit` /
`git push`. Il canale è l'API GitHub, e va invocato.

**3. L'ultimo carico di risultati è del 13/09.**
`git log -- backtest_pipeline/risultati_prove/dal_vps/` →
`714d3d63  2026-09-13  "Risultati dal VPS: ..._P0CONTA.csv (2026-09-13 23:07)"`.
Le etichette presenti in `dal_vps` si fermano a **`r142c`**. Da `r143` in
avanti: **niente**.

**4. Il conto del buco.** Incrociando le etichette con **uscita 0 o 3** in
tutti i referti veri con i CSV effettivamente presenti nel repo:

| | |
|---|---:|
| etichette con NUMERI PRODOTTI nei referti | **82** |
| di queste, con almeno un CSV nel repo | 35 |
| 🔴 **senza nessun CSV → illeggibili da qui** | **47** |

---

## 📋 I 47, per famiglia — e ci sono dentro le sedie di ottobre

| n | famiglia | etichette |
|---:|---|---|
| 8 | `ABTG_PunteLarry` | r160a-d · r169b · r169d · r169e · r169f |
| 7 | `ABTG_ORB_Ottimizzato` | r125a-f · r147b |
| 6 | 🎯 `ABTG_Dow_Apertura_US` | r152a · **r172a-e** |
| 3 | `ABTG_Cycle` | r148a · r148bl · r148bs |
| 3 | `ABTG_SuperWave_DOW_H1_Ottimizzato` | r165a · r173a · r173b |
| 2 | 🎯 `ABTG_DAX_Apertura_EU` | canfrz · r147c |
| 2 | 🎯 `ABTG_EMA200` | r146b · r147a |
| 2 | `ABTG_PTE` | r153a · r164a |
| 2 | `ABTG_EasyTrend` | r171a · r171b |
| 2 | `ABTG_MaxMinNotte` | r151a · r170b |
| 2 | `ABTG_CostToCost` | r146a · r146c |
| 2 | `ABTG_VolExpBreak` | r145a · r145b |
| 1 ×6 | `DaxValueArea` · `Nasdaq_Live5m` · `BreakingBand` · `SupRev_NAS` · `Nasdaq_Apertura_US` · `MaxMinNotte_DAX_Short` | r141e · r150a · r161a · r163a · r170a · r170c |

🎯 = sedia nella rosa di ottobre. `ABTG_DAX_Apertura_EU` è **770101, quella che
gira anche sul conto reale 10105439**; `ABTG_EMA200` è il motore che il
censimento del 09/09 ha trovato **fermo sul demo** con PF OOS 1,52 su n=517.

**E 19 di questi 47 sono girati per la PRIMA VOLTA stanotte**: 11 a uscita 0
(`r163a` `r165a` `r170a` `r170c` `r172a-e` `r173a` `r173b`) e 8 a uscita 3
(`r164a` `r169b` `r169d-f` `r170b` `r171a` `r171b`).

---

## 🟢 LA BUONA NOTIZIA, ed è grossa: **lo strumento ESISTE GIÀ e i percorsi COMBACIANO**

`backtest_pipeline/carica_risultati.ps1` (239 righe) è nato **esattamente per
questo** — la sua intestazione lo dice: *"i CSV dei round girati sul VPS
entrano nel repo (nasce dalla classe 307: il runner pubblica il REFERTO, mai i
CSV)"*.

**Verificato che i percorsi combaciano** — non dato per buono:

| chi | percorso |
|---|---|
| dove **scrive** il driver | `RIGA_ROUND_VPS.ps1` r.95 `$Work = "$env:USERPROFILE\abtg_round"` → r.622 `$Ris = Join-Path $Work ("risultati_prove\" + $Expert)` |
| dove **legge** l'uploader | `carica_risultati.ps1` r.38 `$SorgenteLocale = Join-Path $env:USERPROFILE "abtg_round\risultati_prove"` |

✅ **Stessa cartella.** Lo script è pronto, corretto e già disegnato coi
cancelli di casa (bersaglio dichiarato, nessun terminale MT5 toccato, token
mai stampato, destinazione `dal_vps` separata dall'archivio curato per non
sovrascriverlo — classe 311).

🔴 **L'unica cosa che manca è che qualcuno lo LANCI.** Non è installato come
attività pianificata: `grep -c "Register-ScheduledTask\|schtasks"` su
`carica_risultati.ps1` dà **0**, mentre `runner_abtg.ps1`,
`pubblica_trades.ps1`, `scarica_pagella.ps1`, `setup_news_task.ps1` e
`archivia_test_desktop.ps1` **si auto-installano**. Questo no.

👉 **È l'unico anello della catena rimasto a mano** — e la catena gira da sola
tutte le notti per il resto.

---

## 🎯 LE DUE COSE DA DECIDERE, e sono di Claudio

1. **SUBITO, una riga sola** su una finestra PowerShell del VPS: lanciare
   `carica_risultati.ps1` e far entrare i ~94 CSV dei 47 round. Costo: pochi
   minuti di rete, **zero tempo macchina**. Sblocca 47 misure già pagate.
   🚦 La riga è in preparazione e **non esce senza il PASS del cancello**.
2. **STRUTTURALE**: installare `carica_risultati.ps1` come **attività
   pianificata dopo il runner**, così il trasporto smette di essere l'unico
   anello manuale. Tocca le attività del VPS → **firma di Claudio**.

⚠️ E va detto per onestà di misura: finché il punto 1 non è fatto, **ogni
notte di macchina produce numeri che nessuno legge**. Sommato al pedaggio della
coda (`-Rifai`, ~11 h a notte rifatte), le due cose insieme spiegano perché la
macchina sembra piena e la rosa di ottobre non si muove.
