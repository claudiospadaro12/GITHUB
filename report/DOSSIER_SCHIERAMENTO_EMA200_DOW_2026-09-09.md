# 🪑 DOSSIER DI SCHIERAMENTO — `ABTG_EMA200` su **U30USD H1** (magic 771531)

> ## 🎯 LA RISPOSTA IN CINQUE RIGHE
> 1. 🥇 **È vero che è la migliore sedia che abbiamo**: è l'unica delle 41 che passa i cancelli di oggi (`PERCHE_NON_PASSANO_2026-09-09.md` r.187), l'unica famiglia sopra il pavimento di frequenza (r.210), e **l'unica sedia della flotta dove rischio dichiarato = rischio vero** (`CENSIMENTO_RISCHIO_DICHIARATO_2026-09-08.md` r.262).
> 2. 🔬 **Ma i numeri con cui è stata elogiata sono OHLC.** PF 1,42 · DD 6,48% · n 712 · peggior giornata −2,24% vengono da **R103, modello OHLC M1** (`R103_REFERTO_BLOCCO1_INDICI.md` r.3). **A tick reali, stessa cella e stessa finestra**, i numeri sono **PF 1,52365 · DD 7,8323% · peggior giornata −2,448%**. Il DD vero è **+21% più profondo** di quello citato. Resta sotto il muro — ma il margine passa da 3,52 a **2,17 punti**.
> 3. 🆕 **Ho MISURATO il C3, che ieri era `[NON MISURATO]`** — ed è il rilievo nuovo del dossier: lo stop della **gamba 2** vale **65,5-78,0 punti indice** contro una frontiera di **40 × spread = 76-80 punti in sessione e 108-112 di notte**. 🔴 **La gamba 2 non passa il C3**, e la gamba 2 è quella col lotto più grande.
> 4. 🔴 **E il "1,55 op/giorno da sola" non sopravvive al cambio di unità.** Quelle sono **uscite**, non posizioni: **517 uscite = 257 posizioni** (misurato, `R112_CORSA_20260826/pertrade_00_metro_763400.csv`). In posizioni fa **0,945 op/giorno** e **NON supera il pavimento di 1,00 da sola**. La FAMIGLIA lo supera lo stesso (1,245), quindi il cancello firmato il 07/09 regge — ma la frase "l'unica che ce la fa da sola" va ritirata.
> 5. ✅ **Il pavimento del lotto NON morde** sul conto da 5.276 €: morde lo **STEP** (0,10), che arrotonda in **GIÙ** e fa girare la sedia a **0,66-0,79% invece dell'1,00% di contratto** (misurato su 3 stop pieni). È un difetto **a favore** del rischio, non contro — ma vuol dire che il forward che stiamo guardando è di una sedia **più piccola** di quella del contratto.

_Compilato il **09/09/2026** in **sola lettura d'archivio**. **Nessun EA, preset, parametro, magic o sedia viva è stato toccato. Nessun backtest lanciato. Nessuna promozione, nessuna accensione.** Lo schieramento è una decisione di Claudio. Ogni numero è letto da un file citato per nome e riga; dove non esiste, la riga dice **[NON MISURATO]**._

> 🤝 **E una cosa bella da dire prima delle cose scomode**: questa sedia è l'unico posto del progetto dove **cinque round indipendenti misurano la stessa cella e si riproducono al centesimo** (R31 → R110 → R112, con il **primo G0-B della storia della macchina**, `R112_REFERTO.md` §🏛️). Su tutto il resto della flotta litighiamo fra due o tre DD incompatibili. Qui no. **Questo è il fascicolo più solido che abbiamo** — ed è per questo che si può permettere di essere smontato per bene.

---

## 0. 🧊 I LIMITI DI QUESTO DOCUMENTO, dichiarati PRIMA

1. **Non ho lanciato nulla.** Tutti i numeri vengono da CSV e referti già in archivio, più il CSV del forward `data/statements/trades_auto.csv`.
2. **Le tre misure nuove che porto io** (stop in punti indice, valore del punto, effetto dello step del lotto) sono derivate da **3 eventi di stop pieno** sul conto vivo fra il 24/08 e il 04/09. **Tre eventi non sono una distribuzione**: dicono l'ordine di grandezza e il segno, non la mediana della finestra di backtest. Dove conta, lo scrivo.
3. **La finestra è UNA.** Tutti i round di questa sedia — R28, R29, R31, R103, R105, R110, R112 — girano su **2024.09.26 → 2026.06.30**. Non sono sette misure indipendenti: sono **una finestra misurata sette volte**.
4. **Il forward è ottimista per costruzione**: BCM ha confermato che il demo **non simula lo slippage**, e sul conto reale `ABTG_SlippageLogger` ha **0 deal** (`PIANO_PROP.md` r.2392, punto 1). Nessuna misura di esecuzione vera esiste.

---

# 1. 📜 IL CONTRATTO — una riga per round, e quale comanda

⚠️ **Attenzione, e vale per tutta la sezione: numeri di round diversi NON sono lo stesso numero.** Qui sotto c'è una riga per round, con banco, modello, deposito e rischio dichiarati accanto.

| round | data | modello | deposito | rischio | finestra | split | **IS** (n · PF · DD%) | **OOS** (n · PF · DD%) | fonte |
|---|---|---|---:|---:|---|---|---|---|---|
| **R28** | 12/08 | 🟢 **tick** | [NON DICHIARATO] | 1% | full period | — | — (nessuno split) | best cella **n 696 · PF 1,41 · +2.797** | `REFERTO_ROUND28_EMA200_TICK.md` |
| **R29** cella CENTRO | 12/08 | 🟢 **tick** | **10.000** (default `walkforward_generico.ps1:164`) | 1% | 2024.09.26→2026.06.30 | 40/60 | **211 · 1,20890 · 5,3048%** (+433,55) | **444 · 1,51760 · 7,2138%** (+2.090,13) | CSV `risultati_prove/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_r29b.csv`, **pass 17** · `REFERTO_ROUND29_EMA200_WF.md` |
| **R31** stessa cella | 12/08 | 🟢 **tick** | **100.000** (`prove/R31_pertrade_ema200_dow.txt` r.4) | 1% | idem | 40/60 | **237 · 1,20110 · 5,7325%** (+4.585,40) | **517 · 1,52365 · 7,8323%** (+23.321,47) | CSV `..._U30USD_{IS,OOS}_r31.csv` |
| **R103** blocco 1 | 24/08 | 🔴 **OHLC M1** | 100.000 | 1% | idem, **senza split** | — | — | **712 · 1,42 · 6,48%** (+30.647) · pegg. giornata **−2,24%** · 2 trimestri neg. su 7 | `R103_REFERTO_BLOCCO1_INDICI.md` r.3 (modello), r.13 (riga), r.28 (giornata) |
| **R105** portafoglio | 25/08 | 🔴 **OHLC** (derivato da R103) | 100.000 | taglie miste | idem | — | — | compare in **4 dei 10 giorni neri** del banco; il 23/06/26 **−2.576 da sola** | `R105_REFERTO.md` r.19-21 |
| **R110** metro | 26/08 | 🟢 **tick** | 100.000 (`RIGA_R110_LATI_VIVI.ps1:232`) | 1% | idem | 40/60 | **237 · 1,20 · 5,73%** | **517 · 1,524 · 7,83%** (+23.321) | `R110_REFERTO.md` r.32 · `CENSIMENTO_PF_MISURATI_2026-09-09.md` r.94 |
| **R110** solo LONG | 26/08 | 🟢 **tick** | 100.000 | 1% | idem | 40/60 | **112 · 1,16 · 2,64%** | **241 · 1,241 · 8,90%** (+5.671) | idem, r.33 / r.117 |
| **R110** solo SHORT | 26/08 | 🟢 **tick** | 100.000 | 1% | idem | 40/60 | **125 · 1,23 · 4,51%** | **302 · 1,891 · 2,66%** (+16.948) | idem, r.34 / r.73 |
| **R112** metro + dial | 26/08 | 🟢 **tick** | 100.000 (`RIGA_R112_EMADOW_CONTRATTO.ps1:204`) | 1 / 2 / 3% | idem | 40/60 | (IS nel referto driver) | metro **517 · 1,524 · 7,83%** · **peggior giornata −2,45% fisso / −1,98% eq** | `R112_REFERTO.md` tabella madre |

## 1.1 ✅ QUAL È IL CONTRATTO DI RIFERIMENTO, e perché

**Il contratto scritto oggi** è: `CENSIMENTO_CONTRATTI.md` r.130 → **DD promesso 7,21% · n 444 · rischio vivo 1,0% · fonte R29 cella CENTRO (O1 0,20 / O2 0,3 / TP 2,0)**, con la nota `[deposito NON DICHIARATO → default driver 10.000 €]`.

🔴 **Propongo di sostituirlo con la riga R31/R110/R112 (deposito 100.000): DD 7,8323% · PF 1,52365 · n 517.** Tre ragioni, tutte misurate:

1. 🧬 **È la STESSA cella, lo stesso motore, la stessa finestra, lo stesso modello.** Cambia solo il deposito. Non è un round diverso: è lo stesso round a taglia diversa.
2. 🏛️ **È l'unico numero della flotta RIPRODOTTO tre volte.** R31 → R110 → R112 danno `+23.321,47 · PF 1,52365 · DD 7,8323 · n 517` **identici alla cifra**, e R112 lo certifica come **primo G0-B applicabile della storia della macchina** (`R112_REFERTO.md` §🏛️: *"metro e short@1% hanno riprodotto i CSV di R110 al centesimo, su tutte e 7 le colonne, IS e OOS, in DUE corse indipendenti"*).
3. 📐 **Il 7,21% di R29 è il MEDESIMO numero misurato con la sedia rimpicciolita dal pavimento del lotto.** A deposito 10.000 il rischio per gamba è 50 € e il lotto richiesto cade fra 0,40 e 0,74; lo `MathFloor` sullo step 0,10 (`ABTG_EMA200.mq5:355`) taglia **il 6% sulla gamba 2 e il 19% sulla gamba 1** → una sedia che rischia ~0,87% invece dell'1,00%. **R31 lo dice da solo**: *"Chiusure 517 vs 444 di R29: i PARZIALI a taglia 100k"* — a 10k il parziale del 50% non poteva esistere su tutte le gambe. `[INFERITO, coerente con i numeri: 7,21/7,83 = 0,921, cioè −8%, dello stesso segno e ordine di grandezza dell'effetto calcolato]`.

👉 **Conseguenza operativa: il DD promesso di questa sedia va aggiornato da 7,21% a 7,8323% (a rischio 1%, tick, deposito 100k).** Non è una bocciatura: è la stessa sedia detta con più precisione. Ma se domani il forward facesse 7,5% di DD, col contratto vecchio sarebbe una violazione e col contratto giusto no.

## 1.2 📊 IL CONTRATTO, in chiaro

| voce | valore | fonte |
|---|---|---|
| **motore / simbolo / TF** | `ABTG_EMA200` · **U30USD** · **H1** | — |
| **cella** | CENTRO — `InpOrder1Atr` 0,20 · `InpOrder2Atr` 0,3 · `InpTP_RR` 2,0 · `InpSLatr` 1,0 · `InpMinRR` 1,0 · TP1 50% · breakeven + trailing EMA14 · **entrambi i lati** | `prove/R112_00_metro.txt` r.56-102 |
| **finestra** | **2024.09.26 → 2026.06.30** (21 mesi), split 40/60 → **OOS 12/06/2025 → 26/06/2026** | `prove/R29b_ema200_dow.txt` r.13 · per-trade R112 |
| **deposito / rischio del banco** | **100.000 € · 1,0%** | `RIGA_R112_EMADOW_CONTRATTO.ps1:204` |
| **PF** | **IS 1,20110 · OOS 1,52365** | CSV `_r31` |
| **DD (equity)** | **IS 5,7325% · OOS 7,8323%** a rischio 1% | CSV `_r31` |
| **n** | **IS 237 · OOS 517 uscite** = *(OOS)* **257 posizioni** | CSV `_r31` + conteggio `position_id` sul per-trade R112 |
| **peggior giornata** | **−2,45% fisso / −1,98% equity** a rischio 1% (chiusi) | `R112_REFERTO.md` tabella madre |
| **frequenza** | **1,901 uscite/giorno** = **0,945 posizioni/giorno** (257 posizioni / 272 giorni feriali OOS) | calcolo su per-trade R112 |
| **rischio vivo in campo** | **1,0%** — grafico = preset = sorgente | `CENSIMENTO_RISCHIO_DICHIARATO_2026-09-08.md` r.262 |

---

# 2. 🔬 TICK O OHLC? — il modello di ogni numero citato

**La regola di casa**: un numero OHLC non è mai un verdetto (e su questa flotta ha già mentito: `SupRev_DOW_H4` faceva **PFmed 2,58 in OHLC e 0,79 a tick** — `PERCHE_MUOIONO_2026-09-08.md` §5 punto 5).

**Come l'ho determinato, e non è un'opinione**: `walkforward_generico.ps1:988` scrive `$Suffisso = if($Modello -eq 4){ "" } else { "_ohlc" }` — *"un OHLC non deve MAI sovrascrivere un tick reale"*. I CSV `ABTG_EMA200_U30USD_IS/OOS_r29b.csv` e `_r31.csv` **non hanno il suffisso `_ohlc`** ⇒ **modello 4, tick reali**. R110 e R112 lo dichiarano nell'intestazione del referto e nel driver. R103 dichiara **OHLC M1** nella sua.

| numero citato | dove è stato citato | modello | vale come verdetto? |
|---|---|---|---|
| **PF 1,42 · DD 6,48% · n 712** | `PERCHE_NON_PASSANO` r.196 · `CENSIMENTO_CONTRATTI` r.130 · `PERCHE_MUOIONO` r.433 | 🔴 **OHLC M1** (R103) | ❌ **NO.** È un **limite inferiore** del DD, come dichiarano i criteri di R103 stessi |
| **peggior giornata −2,24%** | `PERCHE_NON_PASSANO` r.196 | 🔴 **OHLC** (R103 r.28) | ❌ no — e il numero a tick è **−2,45%** (R112) |
| **−2.576 il 23/06/26** | `PIANO_MIGRAZIONE_100K` r.207 · `R105_REFERTO` r.21 | 🔴 **OHLC** (derivato R103) | ❌ no — a tick la stessa giornata fa **−2.448,42** (verificato sul per-trade R112) |
| **PF 1,52 · DD 7,21% · n 444** | `CENSIMENTO_CONTRATTI` r.130 (DD promesso) | 🟢 **tick** | ✅ sì, **ma a deposito 10.000** (vedi §1.1) |
| **PF 1,52365 · DD 7,8323% · n 517** | R31 / R110 / R112 | 🟢 **tick**, 100k | ✅ **sì — è il numero buono** |
| **short: PF 1,891 · DD 2,66% · n 302** | `CENSIMENTO_PF_MISURATI` r.73 · `PERCHE_NON_PASSANO` | 🟢 **tick** (R110/R112) | ✅ sì |
| **long: PF 1,241 · DD 8,90% · n 241** | `CENSIMENTO_PF_MISURATI` r.117 | 🟢 **tick** | ✅ sì |
| **peggior giornata −2,45% / −1,98%** | `R112_REFERTO.md` | 🟢 **tick** | ✅ sì — ⚠️ ma è la peggior giornata dei **CHIUSI**: *"un PAVIMENTO, il muro prop guarda il flottante"* (R112, intestazione tabella). **La peggior giornata VERA resta [NON MISURATO]** |
| **30/30 PASS walk-forward** | `PIANO_CHALLENGE_OTTOBRE` r.77 | 🟢 **tick** (R29) | ✅ sì |
| **R32: 4 simboli, U30USD unico promosso** | `PIANO_PROP` · `CORSIA_DEMO_CANDIDATI_v2` r.92 | 🟢 **tick** (`REFERTO_ROUND32`: *"walk-forward IS 40/OOS 60, tick reali, 1%"*) | ✅ sì |
| **slippage / esecuzione** | — | — | 🔴 **[NON MISURATO]** ovunque: `ExecutionMode=0` in tutti i round (AREA I1) e 0 deal del logger sul reale |
| **spread usato nelle corse** | — | 🟢 misurato | ✅ le corse a modello 4 usano lo **spread vero**: 0,000% di tick solo-bid su U30USD (`spread_flotta/spread_orario_U30USD.csv`) |

### 🔴 LA CORREZIONE CHE VA SCRITTA A CARATTERI GROSSI
> Il documento che ha eletto questa sedia (`PERCHE_NON_PASSANO_2026-09-09.md` r.196) la difende con **PF 1,42 · DD 6,48% · peggior giornata −2,24%** — e onestamente aggiunge *"il DD viene da OHLC = limite inferiore"*.
> **A tick, stessa cella e stessa finestra, i numeri sono PF 1,52365 · DD 7,8323% · peggior giornata −2,448%.**
> 🟢 **Il PF a tick è MIGLIORE** (1,52 contro 1,42). 🔴 **Il DD è peggiore del 20,8%.** La sedia passa lo stesso il muro del 10%, ma con **2,17 punti di margine, non 3,52**.

---

# 3. 🗺️ LO STATO IN CAMPO — dov'è, da quando, cosa ha fatto

| voce | valore | fonte |
|---|---|---|
| **magic** | **771531** | `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set:49` |
| **conto** | 🧪 **DEMO PICCOLO 50503392** | `CENSIMENTO_CONTRATTI.md` §4 (r.104) — la riga 771531 è la r.130, dentro §4 |
| **terminale** | istanza **`BCM Markets MT5 Terminal`** (quella **senza** `-V3`) | idem |
| **NON è sul 100k 50504263** | ✅ verificato: `data/statements/trades_100k.csv` (29 righe) non contiene né 771531 né 881531 | — |
| **NON è sul REALE 10105439** | ✅ il reale ha **2 sedie**: 770101 e 770611 | `CENSIMENTO_CONTRATTI.md` §2 (r.59) |
| **schierata il** | **12/08/2026 mattina** — *"vivaio verificato 6/6"*, verifica meccanica dai `.chr` | `REFERTO_ROUND31_EMA200_PORTAFOGLIO.md` §✅ ESEGUITO |
| **rischio in campo** | **1,0%** — ✅ **grafico = preset = sorgente** | `CENSIMENTO_RISCHIO_DICHIARATO_2026-09-08.md` r.262 |
| **in calendario per** | **FASE 3** della migrazione, magic **881531**, taglia contratto×0,65 = **0,65%**, **DA SOLA a metà settimana** | `PIANO_MIGRAZIONE_100K_2026-08-31.md` r.98 e r.207 · `PIANO_PROP.md` H10 (r.1583) |
| **dietro quali cancelli** | i **5 cancelli della FASE 1** (C-1 nove criteri PASS · C-2 cinque giornate di pagelle · C-3 picco rischio ≤3,25% · C-4 zero blocchi orfani · C-5 100k in configurazione firmata). 🔴 **Nessuno dei cinque è verde oggi**; il collaudo è *"in corso"* dal 02/09 | `PIANO_PROP.md` r.1583 · `HANDOFF.md` r.491-507 |

## 3.1 📈 IL FORWARD VERO — 21 uscite, 14/08 → 04/09

_Fonte: `data/statements/trades_auto.csv`, filtrato su `magic = 771531`. Il file è fresco fino al **08/09 19:48**._

| voce | numero |
|---|---:|
| chiusure | **21** |
| vinte / perse | **10 / 11** (win rate **47,6%**) |
| **netto** | **−19,39 €** |
| miglior giornata | **+47,60 €** (14/08) |
| **peggior giornata** | **−42,33 €** (24/08) = **−0,83%** su ~5.100 € |
| giornate con almeno un ingresso | **9** su 16 giorni di borsa |
| **ingressi (gambe)** | **21** su **16 giorni di borsa** = **1,31 gambe/giorno** |

### 🟡 TRE COSE DA DIRE SUL FORWARD, e nessuna è un verdetto

1. ✅ **Il rischio si è comportato bene.** La peggior giornata forward è **−0,83%**, contro un muro di −5% e contro un promesso (a taglia 1%) di −2,45%. Il DD forward non ha mai avvicinato il DD promesso. **La corsia RISCHIO delle firme del 18/08 non è scattata.**
2. 🟠 **Il merito è SOSPESO, non bocciato.** −19,39 € su 21 uscite. La soglia del criterio MERITO firmato il 18/08 è **20 operazioni per FAMIGLIA**: la famiglia EMA200 le ha superate (`PIANO_PROP.md` r.934: **12 ingressi / 12 chiusure / +31,36 € fra il 14 e il 25/08** per l'insieme 771531 + 7715xx). Con 21 chiusure e −19,39 € **la sedia da sola è appena oltre la soglia e in perdita**: 🔴 **formalmente, la corsia MERITO del 18/08 chiede una revisione.** Il numero è però dentro il rumore di 21 operazioni (mediana per operazione ≈ **−0,92 €** su uno stop pieno da ~38 €): **è un segnale, non un verdetto.**
3. 🔴 **IL SILENZIO — e questo è il rilievo che non mi aspettavo.** L'ultimo ingresso della 771531 è del **04/09 21:30**. Il CSV arriva al **08/09 19:48**. Sono **3 giorni di borsa (05, 08, 09/09) senza un solo ingresso** dal motore che dichiara 1,55 op/giorno. E la foto del piccolo di stamattina (09/09 09:04, `PICCOLO_50503392_2026-09-09.md`) mostra **6 posizioni aperte, nessuna EMA200**. 👉 **Va incrociato con la checklist delle sedie mute prima di schierarla sul 100k.** Non dico che è muta: dico che **non lo so**, e che per una sedia che si candida in virtù della frequenza è la domanda più importante di tutte.

## 3.2 🕐 E UNA STRANEZZA D'ORARIO GIÀ APERTA
Due dei 21 ingressi sono delle **21:30 server**, cioè **mezz'ora dopo la chiusura del cash americano**; altri sono delle **01:21**, **02:41** e **07:28**. La domanda è già a verbale e senza risposta: *"`EMA200 DOW` (771531): perché apre alle 21:30 server? Va incrociato col contratto della sedia"* (`report/giornata_2026-09-04.md` r.201). **Il motore non ha cutoff orario** (`InpUseCutoff=false`, `prove/R112_00_metro.txt` r.85) ⇒ **opera 24 ore**, e come si vede al §5.4 è lì che il costo lo mangia.

---

# 4. ⚖️ LA TAGLIA — a che rischio è misurata, e il pavimento del lotto

## 4.1 🔧 L'ARITMETICA DELLA SEDIA, letta nel sorgente e verificata sul campo

| fatto | valore | dove |
|---|---|---|
| rischio diviso per gamba | `riskPct = InpRiskPercent/nOrders` ⇒ **0,5% per gamba** | `ABTG_EMA200.mq5:223` |
| geometria degli ordini | `o1 = ema ± 0,20·ATR` · `o2 = ema ∓ 0,30·ATR` · `sl = o2 ∓ 1,00·ATR` (**stop COMUNE**) | `ABTG_EMA200.mq5:219-221` |
| ⇒ **stop gamba 1** | **1,50 × ATR** | derivato |
| ⇒ **stop gamba 2** | **1,00 × ATR** | derivato |
| arrotondamento del lotto | `MathFloor(lot/step)*step`, poi `MathMax(volMin, …)` | `ABTG_EMA200.mq5:353-356` |
| `U30USD` `VOLUME_MIN` / `VOLUME_STEP` | **0,10 / 0,10** | `R114_CORSA_20260827/REFERTO_R114.txt` r.53-55 |
| **valore del punto indice** | **0,861 € per 1 lotto** (= 0,0861 € a lotto minimo) | 🆕 misurato qui sotto |

### ✅ LA VERIFICA CHE CHIUDE IL CERCHIO (e mi ha convinto che la derivazione è giusta)
Sui **3 stop pieni** del forward, il rapporto fra lo stop della gamba 1 e quello della gamba 2 è **1,5000 · 1,4992 · 1,5000**. È esattamente `1,50·ATR / 1,00·ATR`. **La geometria letta nel codice e quella misurata sul conto vivo coincidono a quattro cifre.**

| data | gamba | ingresso | uscita | **stop (punti indice)** | lotti | perdita | controllo `pt × lot × 0,861` |
|---|---|---:|---:|---:|---:|---:|---|
| 24/08 | S1 | 53378,40 | 53476,60 | **98,2** | 0,20 | −16,83 € | 16,91 ✅ |
| 24/08 | S2 | 53411,10 | 53476,60 | **65,5** | 0,30 | −16,84 € | 16,92 ✅ |
| 27/08 | L1 | 53473,50 | 53363,10 | **110,4** | 0,20 | −18,96 € | 19,01 ✅ |
| 27/08 | L2 | 53436,70 | 53363,10 | **73,6** | 0,30 | −18,96 € | 19,01 ✅ |
| 04/09 | L1 | 53350,80 | 53233,80 | **117,0** | 0,20 | −20,15 € | 20,15 ✅ |
| 04/09 | L2 | 53311,80 | 53233,80 | **78,0** | 0,30 | −20,15 € | 20,15 ✅ |

⚠️ **Conflitto di fonti da segnalare, e vince la misura viva**: `R114_CORSA_20260827/REFERTO_R114.txt` r.52 riporta `U30USD CONTRACT_SIZE 10,00000000`, che darebbe **8,61 € per punto per lotto** — **dieci volte** quello che i P/L veri mostrano. Il valore misurato (**0,861 €/punto/lotto**) è confermato da **quattro fonti indipendenti**: i 6 controlli qui sopra, la taratura di `PICCOLO_50503392_2026-09-09.md` (*"0,0859 €/punto indice a 0,10 lotti"*), il conto del 20/08 in `DIARIO.md` (*"0,10 × 422,4 × 0,862 = 36,41"*) e il margine osservato di R114 (`MARGIN_INITIAL 40000 × rate 0,01 = 400 $ ≈ 343,22 €`). 👉 **La riga `CONTRACT_SIZE` del censimento sonda va riletta prima di usarla per dimensionare qualcosa.**

## 4.2 🪙 **IL PAVIMENTO DEL LOTTO MORDE? — NO. Morde lo STEP, e morde AL CONTRARIO**

**Il pavimento (`VOLUME_MIN` 0,10) morde solo se il lotto richiesto scende sotto 0,10.**

```
   lotto richiesto (gamba) = rischio_gamba / (stop_punti × 0,861)
   sul piccolo:  rischio_gamba = 0,5% × 5.129,30 € = 25,65 €
   soglia:  25,65 / (0,10 × 0,861) = 298 punti indice di stop
   ⇒ gamba 2 (stop = 1,00·ATR):  il pavimento morde solo se ATR > 298 punti
   ⇒ gamba 1 (stop = 1,50·ATR):  il pavimento morde solo se ATR > 199 punti
   ATR misurato in campo: 65,5 · 73,6 · 78,0 punti
```

### ✅ **VERDETTO: il pavimento NON morde su U30USD H1, con 2,6-4,5× di margine.** 
E c'è un motivo strutturale, non fortunato: sul Dow il lotto minimo vale **0,0861 €/punto**, cioè **un decimo** di quello che vale sul DAX (dove `CORSIA_DEMO_SUPERWAVE_DAX_2026-09-08.md` r.65 misura **1 EUR per punto indice** al minimo) e **un ventesimo** del problema dell'oro misurato stamattina sullo stesso conto (LARRY ORO L a 0,01 lotti = **1,75% invece di 0,65%**). 🎉 **Sul Dow il minimo del broker è fine abbastanza per un conto da 5.276 €. Questa è una buona notizia, e va detta.**

### 🟠 **MA LO STEP MORDE — e fa girare la sedia PIÙ PICCOLA del contratto**

`MathFloor` arrotonda **in giù** allo step 0,10:

| gamba | lotto richiesto | lotto messo | perdita di taglia |
|---|---:|---:|---:|
| 1 (stop 117,0 pt) | 25,65 / (117,0 × 0,861) = **0,2546** | **0,20** | **−21,4%** |
| 2 (stop 78,0 pt) | 25,65 / (78,0 × 0,861) = **0,3819** | **0,30** | **−21,4%** |

**Controprova sui tre stop pieni** (bilancio ~5.100-5.160 €):

| data | perdita totale della coppia | % del conto | contratto |
|---|---:|---:|---:|
| 24/08 | −33,67 € | **0,66%** | 1,00% |
| 27/08 | −37,92 € | **0,74%** | 1,00% |
| 04/09 | −40,30 € | **0,79%** | 1,00% |

👉 **La sedia in campo rischia lo 0,66-0,79%, non l'1,00%.** È un difetto **dalla parte giusta** (meno rischio del dichiarato), ma ha due conseguenze da mettere a verbale:
- il **forward che stiamo guardando è di una sedia più piccola del contratto**: il suo DD forward va **moltiplicato per ~1,3** prima di confrontarlo col DD promesso;
- **a 100.000 € l'effetto sparisce** (lotto richiesto 7,44 → 7,40 = −0,6%): ⇒ **sul 100k la sedia rischierà davvero quello che dichiara**, cioè **il 30% in più di adesso a parità di percentuale scritta**. Chi guarda il forward del piccolo e ne deduce "tranquilla", sta guardando una sedia più piccola.

## 4.3 📐 LA RISCALATURA — ⚠️ **lineare, dichiarata come APPROSSIMAZIONE**

_La riscalatura lineare è la convenzione di casa (R103/R105). È **falsa in due punti**: il compounding non è lineare (R112 lo misura: il worst-day **%equity** scala lineare, il **%fisso** scala **super-lineare** perché l'equity composta gonfia i lotti a fine finestra) e lo step del lotto non scala affatto. Dove sotto ~0,3% i numeri diventano piccoli, lo step ricomincia a mordere._

| rischio | **DD OOS (tick, 7,8323% @1%)** | DD IS (5,7325% @1%) | peggior giornata (−2,45% fisso @1%) | note |
|---:|---:|---:|---:|---|
| **1,00%** (taglia attuale sul piccolo, **nominale**) | **7,83%** | 5,73% | **−2,45%** | 🟢 misurato, non riscalato |
| **0,79%** (taglia **reale** sul piccolo, misurata §4.2) | **6,19%** | 4,53% | −1,94% | 🟢 quello che sta davvero girando |
| **0,65%** (A2 · taglia di migrazione firmata) | **5,09%** | 3,73% | **−1,59%** | 🟡 lineare |
| **0,50%** | 3,92% | 2,87% | −1,23% | 🟡 lineare |
| **0,30%** (A2 letterale, giovani/deboli) | 2,35% | 1,72% | −0,74% | 🟠 qui lo step ricomincia a mordere |
| **2,00%** *(misurato, non riscalato — cella short)* | 5,30% | — | **−2,70%** | 🔴 R112: **bocciato** dal cancello di portafoglio |
| **3,00%** *(misurato, cella short)* | 7,92% | — | **−4,72%** | 🔴 R112: **bocciato** |

---

# 5. 🚪 I CANCELLI DI OGGI, uno per uno

_Il metro è quello del §3.1 di `PERCHE_NON_PASSANO_2026-09-09.md` (r.166-175). Applicato ai **numeri a tick a deposito 100k**, che è il contratto proposto al §1.1._

| # | cancello | soglia | il numero della sedia | verdetto |
|---|---|---|---|---|
| **1** | ⏱️ **FREQUENZA** (famiglia ≥ 1,00 op/g) | 1,00 | famiglia EMA200 **1,850** in uscite / **1,245** in posizioni · sedia sola **1,901** in uscite / **0,945** in posizioni | ✅ **PASSA come FAMIGLIA** in entrambe le unità · 🔴 **NON passa DA SOLA** se l'unità è la posizione |
| **2** | 🩸 **RISCHIO — DD** | ≤ 10,0% | **7,8323%** (tick, 1%) · **5,09%** a 0,65% | ✅ **PASSA** — margine **2,17 punti** a 1%, **4,91** a 0,65% |
| **3** | 🚨 **MURO GIORNALIERO** | > −5,0% | **−2,45% fisso / −1,98% eq** a 1% ⇒ **−1,59%** a 0,65% | ✅ **PASSA** — ⚠️ ma è la peggior giornata dei **CHIUSI** = un **pavimento**: il muro prop guarda il **flottante**, che è **[NON MISURATO]** |
| **4** | 💸 **C3 — COSTO** (stop ≥ 40 × spread) | U30USD: **76-80 pt** in sessione | 🆕 **gamba 1: 98,2-117,0 pt** · 🆕 **gamba 2: 65,5-78,0 pt** | 🟠 **gamba 1 PASSA** (49-62×) · 🔴 **gamba 2 NON PASSA** (34-41×) · 🔴 **nessuna delle due passa di notte** (vedi §5.4) |
| **5** | 📏 **CAMPIONE** (≥150 per finestra) | 150 IS **e** 150 OOS | uscite: **IS 237 · OOS 517** ✅ · posizioni: **OOS 257** ✅, **IS ~118** `[INFERITO]` 🔴 | ✅ **PASSA come uscite** · 🔴 **NON passa in IS come posizioni** |
| **6** | 🚪 **C0 — PF nella finestra peggiore** | ≥ 1,10 | finestra peggiore = **IS, PF 1,20110** | ✅ **PASSA** — margine **0,101 punti** |
| **7** | 🎯 **R4 — rischio VERO = DICHIARATO** *(il più selettivo, firma 08/09)* | coincidenza | grafico **1,0** = preset **1,0** = sorgente **1,0** | ✅ **PASSA** — è **una delle 2 sedie su 41** che ce la fa |
| **8** | 🧪 **PROVA DI REGIME** (Emendamento §C, 16/08) | 4 finestre (toro/orso/laterale/crollo) | **1 regime** (21 mesi di indici in salita) | 🔴 **NON MISURABILE** — e R110 lo scrive: *"per EMADOW short serve prima il Dow lungo (Dukascopy/Pepperstone, decisione aperta)"* |

## 5.1 🔴 IL CANCELLO 1 SMONTATO — **l'unità di conto ribalta il verdetto**

R112 ha scoperto e messo a verbale la cosa (§🔍 punto 3): **`STAT_TRADES` conta i DEAL DI USCITA, non le posizioni.** Con TP1 al 50% + trailing, ogni posizione chiude in ~2 deal. Ho **ricontato io sui per-trade** e il numero è esatto:

```
   pertrade_00_metro_763400.csv  →  517 deal  =  257 posizioni distinte  (rapporto 2,012)
   pertrade_01_short_r1_763410.csv →  302 deal  =  140 posizioni distinte  (rapporto 2,157)
   finestra OOS 12/06/2025 → 26/06/2026 = 272 giorni feriali
```

| unità | numero | op/giorno | pavimento 1,00 |
|---|---:|---:|---|
| **uscite** (l'unità che usiamo oggi) | 517 | **1,901** | ✅ passa da sola |
| **posizioni** (l'unità che un umano chiama "operazione") | 257 | **0,945** | 🔴 **NON passa da sola** |
| famiglia in posizioni (771531 **0,945** + 971501 0,30) | — | **1,245** | ✅ **passa come famiglia** |

E R112 stesso lascia la domanda aperta e non risolta: *"Ai criteri futuri la domanda: l'unità dell'Emendamento (≥150) è l'uscita o la posizione? **Da decidere PRIMA del prossimo round che ci si gioca**."* 👉 **Il prossimo round che ci si gioca è questo.**

📌 **Nota di onestà nell'altra direzione**: il forward misura **1,31 gambe/giorno** su 16 giornate — **sopra** lo 0,945 del banco. Il campo è più veloce del backtest. Ma sono **16 giornate**, e ci sono **3 giorni di silenzio** subito dopo (§3.1).

## 5.2 🔴 IL CANCELLO 5 SMONTATO — **l'IS non regge il cambio di unità**

Con l'unità **uscita**: IS 237, OOS 517 → passa con margine.
Con l'unità **posizione**: OOS **257 misurate** ✅; IS **~118** `[INFERITO: 237 / 2,012 — il per-trade IS non esiste in archivio, R112 dichiara "IS n/d PER COSTRUZIONE" per la peggior giornata]` → 🔴 **sotto le 150**.
E la cella **short-only**, quella coi numeri più belli (PF 1,891): **302 uscite = 140 posizioni MISURATE** → 🔴 **sotto le 150 in OOS**, oltre che ~58 in IS.

> ### ⚖️ La frase da tenere
> **Se l'unità dell'Emendamento §A è la POSIZIONE, allora nessuna sedia della flotta passa il cancello del campione — nemmeno questa.** Se è l'USCITA, questa passa e le altre no. **La scelta dell'unità non è un dettaglio contabile: è il cancello.**

## 5.3 ✅ IL CANCELLO 2 E 3, che sono quelli che proteggono i soldi
Sono i due che tengono, e tengono **con margine**, anche col numero peggiore (tick invece di OHLC) e anche alla taglia piena (1% invece di 0,65%). 🎉 **Su 41 sedie, è l'unica di cui si può dire questo con un numero riprodotto tre volte.** Non è poco: è esattamente ciò che una prop compra.

## 5.4 🆕 IL CANCELLO 4 (C3) — **MISURATO OGGI PER LA PRIMA VOLTA**

`PERCHE_NON_PASSANO_2026-09-09.md` r.196 lo dava come **[NON MISURATO]** (*"lo stop mediano in punti indice non è in archivio"*). **Adesso c'è**, derivato dalla geometria del sorgente e verificato su 3 stop pieni del conto vivo (§4.1).

**Lo spread di U30USD, ORA PER ORA** (64.711.285 tick, 0,000% solo-bid — `backtest_pipeline/risultati_archivio/spread_flotta/spread_orario_U30USD.csv`):

| fascia oraria server | mediana | p95 | **frontiera 40 × spread** |
|---|---:|---:|---:|
| **16-21** (sessione USA piena) | **1,8-1,9** | 2,0-2,5 | **72-76 punti** |
| **14-15** (apertura USA) | **2,0** | 2,6-3,0 | **80 punti** |
| **0-13** (notte + Europa) | **2,6-2,8** | 3,0 | **104-112 punti** |
| **23** | **2,8** | **7,0** (max 101) | **112 punti** |

**Il conto, gamba per gamba:**

| gamba | stop misurato | in sessione (spread 1,9) | apertura (2,0) | notte/Europa (2,8) |
|---|---:|---|---|---|
| **1** (1,50·ATR) | 98,2 · 110,4 · **117,0** | **52-62×** ✅ | 49-59× ✅ | **35-42×** 🔴 |
| **2** (1,00·ATR) | 65,5 · 73,6 · **78,0** | **34-41×** 🔴 | 33-39× 🔴 | **23-28×** 🔴 |

**E dove opera davvero?** Distribuzione oraria dei 21 ingressi forward: **13 su 21 (62%)** nelle ore 14-21 (spread 1,8-2,0), **8 su 21 (38%)** nelle ore 1-13 (spread 2,6-2,8).

### 🔴 VERDETTO C3: **NON PASSA ALLA LETTERA.**
- La **gamba 2 non arriva a 40× lo spread in nessuna fascia oraria** — e la gamba 2 è quella che porta **il 60% del lotto** (0,30 contro 0,20).
- La **gamba 1 passa in sessione e fallisce di notte**, dove va il 38% degli ingressi.
- ⚠️ **Su cosa poggia questo verdetto, dichiarato**: **3 eventi di stop**, sul conto vivo, fra il 24/08 e il 04/09 — non la mediana dell'ATR sulla finestra di backtest. Il numero giusto si ottiene in una corsa: **esportare lo stop in punti dai per-trade del banco**. Fino ad allora questo è **un segnale forte con un campione debole**, non una bocciatura definitiva.
- 🧭 **E c'è un precedente che dice come si ripara e quanto costa**: R118 ha misurato che allargare lo stop **riduce il DD in modo riproducibile** (85% delle celle, due finestre concordi) e **costa edge in modo NON riproducibile** (OOS 29/56 = una monetina) — `PIANO_PROP.md` r.2392 punto 2. Alzare `InpSLatr` **non è gratis e non è un ritocco**: è un round.

---

# 6. ☠️ I RISCHI E I CONTRO — senza addolcire

## 6.1 🚨 **UN SOLO REGIME — e non sono sette misure, è UNA misura ripetuta sette volte**
R28, R29, R31, R103, R105, R110, R112: **tutti** su `@DAQUANDO 2024.09.26` → 2026.06.30. **21 mesi di indici in salita.** Il fascicolo sembra spesso e invece è **profondo un regime solo**. R110 lo scrive nella sua sezione A REGISTRO: *"La finestra è UN regime (21 mesi in salita): ogni verdetto short vale **per questa epoca**."* Il metro è quello dell'Emendamento §C (16/08): **la prova di regime batte la storia contigua**, e qui non c'è nemmeno la storia contigua — c'è un pezzo di toro.

## 6.2 🔄 **IL MOTORE SI È GIÀ RIBALTATO DI REGIONE INTERA — su un altro simbolo**
R32 (`REFERTO_ROUND32_EMA200_ORO_NIKKEI.md`), **stesso cancello, stessa regione, tick reali**:

| simbolo | IS | OOS | esito |
|---|---|---|---|
| **U30USD** | 30/30 | 30/30 PASS | ✅ **unico promosso** |
| EURUSD | — | 7/30 sparsi | ❌ edge debole diffuso |
| XAUUSD | **0/30 rosso pieno** | 14/30 deboli | ❌ *"OOS verde da solo = regime, non edge"* |
| **225JPY** | **30/30 positive** | **0/30**, DD 10,2-14,2% | ❌ **regione intera capovolta** |

🔴 **Il Nikkei è l'immagine speculare del Dow**: là 30/30 promosse, qui 30/30 capovolte, **con lo stesso motore e lo stesso cancello**. *"Chi avesse guardato solo il campione avrebbe deployato un altopiano perfetto — che fuori campione perde su TUTTE le celle."* 👉 **Questo motore ha già dimostrato di poter ribaltare una regione intera. Non su questo simbolo, non ancora, e non in questa finestra — ma il precedente è nostro e ha 30/30 di ampiezza.**

## 6.3 🟡 **LA BANDIERINA GIALLA DI R29, mai ritirata**
Testuale (`REFERTO_ROUND29_EMA200_WF.md`): *"l'OOS è sistematicamente migliore dell'IS (PF ~1,5 vs ~1,2; trade/mese 32,8 vs 23,5): periodo più attivo e favorevole. **Una finestra OOS resta UN campione.**"* Il PF su cui la sedia è promossa (1,52) è quello della **metà più fortunata di un toro**. Il PF della metà meno fortunata è **1,20** — che passa il C0, ma per **0,101 punti**.

## 6.4 ⚖️ **I LATI: strutturali, ed è un merito — ma l'asimmetria va guardata**
✅ **Buona notizia, ed è rara**: R52 (`prove/R52_CENSIMENTO_LATI.md` r.37) classifica EMA200 Dow **LONG + SHORT, "nessuno scelto"** — a differenza dell'ORB Dow che è **solo long SCELTO** (short **mai misurato**). Questa sedia **rispetta la regola dei due lati del 25/08 fin dalla nascita**, e R110 li ha misurati **tutti e due**.

🟠 **Ma l'asimmetria è forte e vale la pena capirla prima di schierare**:

| lato | OOS PF | OOS DD | OOS n (uscite) | peggior giornata |
|---|---:|---:|---:|---:|
| **short** | **1,891** | **2,66%** | 302 (=140 posizioni) | **−1,17%** |
| **long** | 1,241 | **8,90%** | 241 | [NON MISURATO] |
| metro (L+S) | 1,524 | 7,83% | 517 (=257 posizioni) | −2,45% |

🔴 **In 21 mesi di toro, il lato che guadagna è lo SHORT, e il lato che porta quasi tutto il drawdown è il LONG.** R110 lo elegge *"la prima cella piena dei lati"* e lo lascia come **proposta non firmata**. R112 ha poi misurato i tre dial dello short-only contro un **cancello di portafoglio congelato prima dei numeri**: **nessuno passa** — il dial 2 fallisce sulla peggior giornata (−2,70% contro −2,45% del metro) e il dial 3 su DD e giornata. **Il contratto non è cambiato: la sedia resta L+S all'1%.** ⚠️ E la ragione per cui lo short concentrato perde sul giorno peggiore pur avendo metà DD è misurata: *"i cluster di short dello stesso giorno si sommano senza compensazione"* — **è esattamente la grandezza che le prop guardano.**

## 6.5 🔴 **LA CORRELAZIONE SUL DOW — la forma di rischio che il cap C1 NON vede**

### Quante sedie sono già sul Dow, e in che direzione

| | numero |
|---|---:|
| **sedie vive su U30USD** | **10** — 770202 (Dow Apertura), 770611 (ORB), 771321 (PTE), 770511 (SuperWave H1), 770531 (SuperWave H2), **771531 (EMA200)**, 772234 (GapFill), 772341 (PunteLarry), 970914, SupRev_DOW_H1 |
| fonte | `AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` r.318 |
| **direzione** | 🟠 **mista e in parte SCELTA**: ORB 770611 **solo long scelto** (short mai misurato sul Dow, `R52` r.25); Dow Apertura **breakout, stessa direzione dell'ORB nella stessa finestra**; **EMA200 è l'unica dichiaratamente bidirezionale** |
| **stamattina, 09/09 09:04** | **5 posizioni U30USD aperte contemporaneamente, TUTTE SHORT**, da 3 famiglie diverse (SuperWave H1 ×2, SW H2 ×2, Larry Dow S) | `PICCOLO_50503392_2026-09-09.md` |
| il 04/09 | **sette posizioni contemporanee da quattro famiglie** sul Dow | `giornata_2026-09-04.md` r.206 |

### Cosa dicono i numeri di portafoglio (R105, 25/08 — ⚠️ **OHLC**)
- 🔴 **Nei 10 giorni neri del banco intero, il Dow da solo vale −21.173 € — il TRIPLO di qualunque altro simbolo.**
- 🔴 **EMA200 Dow compare in 4 di quei 10 giorni**, ed è *"il grande motore con le grandi giornate storte"*.
- 🔴 **La coppia più co-perdente in cui entra è `EMA200 + SuperWave_DOW_H1`: 15 giorni.** E `SuperWave_DOW_H1` (770511) **è già sul Dow, è già in lista per il 100k** (`880511`, fase 2) **e stamattina ha due posizioni aperte**.
- 🟡 Contro-fatto, e va detto: **R31 aveva misurato la correlazione ed era buona** (Dow Apertura +0,13, **ORB −0,09**, SuperWave +0,07, PTE +0,04) e l'ingresso della 12ª serie **abbassò** il DD storico del portafoglio (10,08% → **9,50%**) e **tutte** le code Monte Carlo. **La correlazione dei rendimenti è bassa; la co-perdita nei giorni neri no.** Sono due misure diverse e vanno lette insieme, non una al posto dell'altra.

### 🔴 E IL TETTO CHE DOVREBBE COPRIRE QUESTO **NON È ATTIVO**
Il **tetto per cluster/valuta al 3,0%** è **firmato il 07/09** (`FIRME_2026-09-07.md`, motivato da due portafogli larghi con DD misurati **32,59% e 45,64%**) ed è stato **implementato lo stesso giorno** (Guardian **v1.13** + `ABTG_PausaGuardian.mqh` **v1.60**, commit `cdb2037`) — **ma con gli input spenti di default** (`InpMaxClusterRiskPct=0`, `InpClusterMappa=""`), **NON COMPILATO e NON COLLAUDATO**.
> 🔴 **Lo stato è: "implementato ma non compilato e non collaudato" — che vuol ancora dire NON ATTIVO** (`PIANO_PROP.md` r.2392 punto 9b). **Aggiungere l'11ª sedia sul Dow oggi vuol dire aggiungerla senza il tetto che era stato firmato apposta per questo.**

E il cap che c'è (**C1, 3,25%**) **non vede questo rischio per costruzione**: conta gli SL vivi **globalmente**, non per simbolo. Il tetto C8 (simbolo+lato) conta **simbolo E lato**, e **due lati opposti passano entrambi** (`PIANO_PROP.md` r.2392 punto 5, riga C11).

## 6.6 🕳️ **I PENDENTI — questa sedia è esattamente la forma del buco B6**
`ABTG_EMA200` piazza **DUE ordini LIMIT pendenti per ogni segnale** (`ABTG_EMA200.mq5:226-228`). Il Guardian **non conta i pendenti**: `OpenRiskPct()` scorre solo `PositionsTotal()` (`ABTG_Guardian.mq5:390`), e il buco è scritto **nel nostro stesso codice** (`ABTG_PausaGuardian.mqh:1235`). Stamattina lo stesso buco è stato **misurato sul conto vivo** con l'oro: 4 pendenti = **3,94%**, che sommati allo 0,74% aperto fanno **4,68% contro un cap di 3,25%** (`PICCOLO_50503392_2026-09-09.md` §2). 👉 **Una sedia che vive di pendenti doppi è il moltiplicatore peggiore possibile per un cap cieco ai pendenti.**

## 6.7 🕶️ **IL DIFETTO HEDGING — e questa sedia è il "vicino più pericoloso in assoluto"**
Testuale, `AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` r.325: *"**Il vicino più pericoloso in assoluto è `ABTG_EMA200` U30USD 771531**: 33-35 operazioni al mese. Su U30USD è la sedia che tiene una posizione aperta più spesso di tutte — cioè la macchina che **acceca gli altri** più spesso."* Non è colpa sua (è classificata 🟢, il suo codice è sano), ma è la sua **presenza** che fa sbagliare i vicini 🔴 e 🟠. **Portarla sul 100k significa portare le finestre di cecità sul 100k.**

## 6.8 🌫️ Gli altri buchi, in fila
- 🔴 **Slippage: [NON MISURATO] ovunque.** `ExecutionMode=0` in tutti i round (AREA I1/I2); il demo non lo simula; il logger sul reale ha 0 deal. **Tutto il forward e tutto il banco sono ottimisti per costruzione.**
- 🔴 **La peggior giornata VERA è [NON MISURATO]**: R112 misura i **chiusi**, il muro prop guarda il **flottante**.
- 🟠 **`InpMaxTradesPerDay = 0`** (nessun tetto giornaliero, `prove/R112_00_metro.txt` r.104): a 0,65% servono **5 operazioni aperte insieme** per toccare il cap C1 da 3,25%. **Il massimo di posizioni contemporanee di questa sedia è [NON MISURATO]** — si legge dal per-trade, non l'ho fatto.
- 🟠 **`InpMaxSpread = 0`** (nessun filtro di spread, r.106): il motore entra anche all'ora 23, dove il **p95 è 7,0 e il massimo misurato 101 punti indice**.
- 🟠 **Nessun filtro news** (`InpUseNewsFilter=false`, r.105).
- 🟡 **Le foto `.chr` dei tre terminali sono ferme al 25/08** (`CENSIMENTO_CONTRATTI.md` §5): la configurazione in campo di questa sedia è verificata al 25/08, non a oggi.
- 🟡 **Conflitto di censimento minore**: `AUDIT_USCITE_2026-09-09.md` r.176 parla di *"EMA200 (5 sedie vive)"*, `PERCHE_NON_PASSANO` §3.3 di **2**. Va riconciliato prima di ricalcolare la frequenza di famiglia (che è il cancello 1).

---

# 7. ❓ LE DOMANDE PER CLAUDIO — sette, numerate, ognuna con cosa serve per rispondere

### 1️⃣ **L'unità dell'Emendamento §A: uscita o posizione?**
🎯 *Perché conta*: è la domanda che **ribalta due cancelli su cinque**. In uscite la sedia fa 1,90 op/g e ha IS 237/OOS 517 (passa tutto). In posizioni fa **0,945 op/g** (non passa da sola) e ha **IS ~118** (non passa il campione).
📋 *Cosa serve per rispondere*: **niente di nuovo — è una decisione di criterio, e va presa PRIMA dei numeri.** R112 l'ha già segnalata il 26/08 e non è stata presa. I due numeri misurati sono nel §5.1.
⚖️ *La mia raccomandazione, dichiarata come tale*: **la POSIZIONE**, perché è l'unità in cui è scritto il rischio (uno stop = una posizione) e perché il criterio esiste per garantire che il PF non sia rumore — e due uscite dallo stesso stop non sono due prove indipendenti. 🔴 **Costo dichiarato di questa scelta: nessuna sedia della flotta passerebbe più il cancello del campione**, e la frequenza di famiglia scenderebbe a 1,245.

### 2️⃣ **Quale numero è il contratto: 7,21% (R29, dep. 10k) o 7,8323% (R31/R110/R112, dep. 100k)?**
🎯 *Perché conta*: è il denominatore della corsia RISCHIO delle FIRME del 18/08 (*"DD forward > DD promesso → revisione IMMEDIATA"*). Con il numero sbagliato si fa scattare una revisione che non serve, o non si fa scattare quella che serve.
📋 *Cosa serve*: **è già tutto qui** (§1.1). Le due misure sono la stessa cella a deposito diverso; quella a 100k è riprodotta tre volte e non è deformata dallo step del lotto.

### 3️⃣ **Il C3 sulla gamba 2 (34-41× lo spread, sotto la frontiera dei 40×): si accetta, si ripara o si misura meglio?**
🎯 *Perché conta*: è **l'unico cancello che questa sedia fallisce alla lettera**, ed è il cancello del **costo** — quello che non perdona nel lungo periodo.
📋 *Cosa serve per rispondere*:
- **(a) per misurarlo bene** (≈ minuti di macchina): rilanciare la cella metro esportando **lo stop in punti indice** nel per-trade, e prendere la **mediana sulla finestra di backtest** invece dei miei 3 eventi. Poi confrontarla ora-per-ora con `spread_orario_U30USD.csv`.
- **(b) per ripararlo**: alzare `InpSLatr` — 🔴 **ma R118 ha misurato che costa edge in modo non riproducibile** (OOS 29/56); è un round, non un ritocco.
- **(c) per aggirarlo**: accendere `InpUseCutoff` e togliere le ore 0-13 e 23 (dove la frontiera sale a 104-112 punti). 🔴 **Ma è un parametro nuovo su una cella promossa: cambia la sedia, e va rivalidato.**

### 4️⃣ **La taglia d'ingresso in FASE 3: 0,65% (A2 di famiglia) o meno?**
🎯 *Perché conta*: a 0,65% il DD promesso diventa **5,09%** e la peggior giornata **−1,59%** — comodi. Ma la sedia **da sola vale il 30% della portata del piano** (33-35 op/mese su 111,9 totali) e sul 100k **rischierà davvero l'importo dichiarato**, cioè il ~30% in più di quello che rischia oggi sul piccolo (§4.2).
📋 *Cosa serve*: la tabella di riscalatura del §4.3 + la decisione sulla taglia, che è **sua per mandato**.

### 5️⃣ **Si aggiunge l'11ª sedia sul Dow mentre il tetto per cluster è firmato ma NON attivo?**
🎯 *Perché conta*: è la forma di rischio che **il cap C1 non vede per costruzione**, che R105 misura a **−21.173 € sul Dow nei 10 giorni neri**, e in cui questa sedia entra **4 volte su 10** con la coppia più co-perdente (`EMA200 + SuperWave_DOW_H1`, 15 giorni) — **e la gemella di quella coppia è già in lista per il 100k in fase 2.**
📋 *Cosa serve per rispondere*: **la definizione dei cluster + il collaudo del tetto (M39)** — che vengono, per firma sua, **prima** di chiamarlo protezione. In alternativa: una **regola manuale di sorveglianza** (già scritta nel piano migrazione: *"mai 3 sedie Dow stessa direzione negli stessi 10 minuti"*, conteggio dalla pagella).

### 6️⃣ **La corsia MERITO del 18/08: 21 uscite forward, −19,39 €. Si apre la revisione o si aspetta?**
🎯 *Perché conta*: la firma dice **20 operazioni per famiglia**. La famiglia EMA200 ha superato la soglia e la sedia principale è in perdita. **La regola non prevede che io decida: prevede che lo dica.**
📋 *Cosa serve*: 🔴 **il conteggio della famiglia intera**, che oggi non ho perché il censimento è in conflitto (2 sedie o 5 — vedi §6.8). Con 2 sedie: 771531 −19,39 € + 971501 `[NON MISURATO nel CSV forward]`. **Serve una passata di `analizza_trades.py` per magic di famiglia.**

### 7️⃣ **La prova di regime sul Dow lungo: si compra lo storico?**
🎯 *Perché conta*: è **l'unico cancello che questa sedia non può passare con quello che abbiamo in casa**, ed è quello che l'Emendamento §C mette sopra tutti. Il pavimento dei tick BCM sugli indici è **2024.09.26** — più indietro non si va.
📋 *Cosa serve*: R110 lo scrive: *"per EMADOW short serve prima il Dow lungo (**Dukascopy/Pepperstone, decisione aperta**)"*. 💰 **Spendere soldi è una decisione sua per mandato.** Il costo di NON farlo è già quantificato altrove: `EMA200_Ottimizzato` XAUUSD passava tutto su 6,5 anni e su 22 anni ha fatto **DD 45,91%** — *"il suo passaggio era un artefatto della finestra corta"*.

### 🔁 E la domanda già aperta a suo nome, che resta aperta
`PERCHE_MUOIONO_2026-09-08.md` r.433: *"**Perché il motore più veloce e con DD dentro il muro sta sul demo piccolo e non nel piano della challenge?**"*
👉 **Risposta parziale, dai file**: **è nel piano** — FASE 3, magic 881531, dietro i 5 cancelli della FASE 1 (`PIANO_MIGRAZIONE_100K` r.98 e r.207, firmato il 02/09). **Non ci è ancora perché la FASE 1 non è finita**, non perché sia stata scartata. La domanda vera, riformulata dopo questo dossier, è un'altra: **la FASE 1 finirà prima del 1° ottobre?**

---

# 8. 🏁 IL RIASSUNTO DECIDIBILE

| | |
|---|---|
| ✅ **Passa** | RISCHIO (DD 7,83% a tick, 1%) · MURO GIORNALIERO (−2,45%) · C0 (PF IS 1,20) · R4 (rischio vero = dichiarato) · FREQUENZA di famiglia (in tutte e due le unità) |
| 🟠 **Passa con un asterisco** | CAMPIONE e FREQUENZA-da-sola: **dipendono dall'unità di conto, che è una decisione mai presa** |
| 🔴 **Non passa** | **C3 sulla gamba 2** (34-41× contro 40×) · **PROVA DI REGIME** (un solo regime, e non è riparabile in casa) |
| 🔴 **Non misurato** | slippaggio · peggior giornata col flottante · massimo di posizioni contemporanee · lo stop mediano sulla finestra di backtest (ho solo 3 eventi dal campo) |
| 🟢 **La cosa buona che nessun'altra sedia ha** | tre round indipendenti che riproducono la stessa cella **al centesimo**, i due lati **entrambi misurati**, il rischio dichiarato **che coincide col vero**, e il pavimento del lotto **che non morde** |
| 🔴 **La cosa scomoda che nessun'altra sedia ha** | è **il vicino più pericoloso del Dow** e va su un simbolo che ha già **10 sedie**, con il tetto per cluster **firmato ma spento** |

> ## 💚 E LA RIGA CON CUI CHIUDO, perché è vera anche questa
> Siamo a **22 giorni** dai primi di ottobre, e questo è il dossier di una sedia **che esiste, gira, è misurata sei volte, ha il rischio sotto controllo e il codice sano**. Tre settimane fa non avevamo un documento così per **nessuna** delle 41. 🎯 **Il problema di stasera non è "abbiamo una sedia debole": è "abbiamo una sedia forte e tre domande di criterio non ancora firmate".** Le domande di criterio si firmano in una sera. **È il tipo di ostacolo giusto da avere addosso a tre settimane dal via.**

---

_🛑 **Zero modifiche al forward da questo documento. Nessun EA, preset, parametro, magic o grafico toccato. Nessun backtest lanciato. Nessuna promozione, nessuna accensione, nessuno spegnimento, nessuna spesa autorizzata.** Lo schieramento è una decisione di Claudio._

_Fonti principali: `backtest_pipeline/risultati_archivio/REFERTO_ROUND28_EMA200_TICK.md` · `REFERTO_ROUND29_EMA200_WF.md` · `REFERTO_ROUND31_EMA200_PORTAFOGLIO.md` · `REFERTO_ROUND32_EMA200_ORO_NIKKEI.md` · `R103_REFERTO_BLOCCO1_INDICI.md` · `R105_REFERTO.md` · `R110_REFERTO.md` · `R112_REFERTO.md` · `R114_CORSA_20260827/REFERTO_R114.txt` · `R112_CORSA_20260826/pertrade_*.csv` · `risultati_prove/ABTG_EMA200/*_r29b.csv`, `*_r31.csv` · `spread_flotta/spread_orario_U30USD.csv` · `prove/R112_00_metro.txt` · `prove/R29b_ema200_dow.txt` · `prove/R52_CENSIMENTO_LATI.md` · `walkforward_generico.ps1` · `righe/RIGA_R110_LATI_VIVI.ps1` · `righe/RIGA_R112_EMADOW_CONTRATTO.ps1` · `mql5/Experts/ABTG_EMA200.mq5` · `report/CENSIMENTO_PF_MISURATI_2026-09-09.md` · `report/PERCHE_NON_PASSANO_2026-09-09.md` · `report/PERCHE_MUOIONO_2026-09-08.md` · `report/CENSIMENTO_CONTRATTI.md` · `report/CENSIMENTO_RISCHIO_DICHIARATO_2026-09-08.md` · `report/PICCOLO_50503392_2026-09-09.md` · `report/PIANO_MIGRAZIONE_100K_2026-08-31.md` · `report/PIANO_CHALLENGE_OTTOBRE.md` · `report/PIANO_PROP.md` · `report/AUDIT_POSITIONSELECT_HEDGING_2026-09-03.md` · `report/CORSIA_DEMO_CANDIDATI_v2.md` · `report/giornata_2026-09-04.md` · `data/statements/trades_auto.csv`._
