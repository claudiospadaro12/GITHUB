# MIGLIORA EMA200 Dow H1 (sedia 771531) -- scheda dell'11/10/2026: diagnosi, quattro ipotesi con l'attesa scritta prima, il Guardian, le domande a Claudio

**Bozza, NON passata dal cancello.** Strato 1 (`controlla_riga.py --oggetto md`) e strato 2 (`controllo-preventivo`): esiti in sez. 7; finche' lo strato 2 non da' PASS questo file non esce verso Claudio.
Richiesta: EA n. 1 di `report/PRIORITA_EA_E_DA_FARE_2026-10-08.md` sez. A (protocollo a sei passi), dopo _"GLI EA SONO LA PRIORITA'... MIGLIORARLI UNO ALLA VOLTA"_ (Claudio, 08/10).
**Perimetro**: sola lettura del repo (`origin/lavoro` @ `0cfbc49f`, 11/10) + calcoli Python su CSV e per-trade GIA' in repo. Nessun backtest, nessuna macchina, nessuna riga di lancio, nessun file prova, nessun EA/preset/magic/sedia/terminale toccato, nessuna taglia proposta, nessuna spesa, nulla mandato a Gemini. Il campo non si tocca senza la firma di Claudio.
**Etichette**: `[MISURATO]` letto da un file · `[DERIVATO]` calcolo mio su numeri misurati (metodo in Appendice A) · `[INFERITO]` ragionamento · `[DICHIARATO]` scritto in un referto, non riaperto · `[NON MISURATO]` · `[NON TROVATO]` cercato e assente · `[NON RICONCILIATO]` due fonti di casa discordi · `[DA VERIFICARE A VISTA]` solo Claudio puo' chiuderlo.
**Sigle delle fonti**: `EA` = `mql5/Experts/ABTG_EMA200.mq5` (690 righe) · `VIVA` = `mql5/Presets/ABTG_EMA200_U30USD_H1_771531_VIVA.set` · `C136` = `backtest_pipeline/risultati_prove/dal_vps/ABTG_EMA200/ABTG_EMA200_U30USD_{IS,OOS}_<sigla>.csv` (sigle r136a-d, r146b, r147a, cemad05; "r.N" = riga del CSV, intestazione = r.1) · `PT` = `backtest_pipeline/risultati_archivio/R112_CORSA_20260826/pertrade_00_metro_763400.csv` · `EG2` = `backtest_pipeline/risultati_archivio/ROUND_EMAGEM2_20261004_2217/` · `G2` = `report/RESOCONTO_EA_G2_EMA200_SW_ORB_2026-10-05.md` · `PORTA` = `report/EMA200_LA_PORTA_DEL_TRAILING_2026-09-18.md` · `DUE` = `report/EMA200_I_DUE_REQUISITI_2026-09-12.md` · `GEM` = `report/EMA200_GEMELLI_STATO_2026-10-03.md` · `DK` = `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` · `GUARD` = `report/IL_GUARDIAN_CHE_SCHIEREREMO_2026-09-12.md` · `RUN` = `report/RUNBOOK_RICOMPILAZIONE_PICCOLO_2026-09-14.md` · `C01`/`C06` = `backtest_pipeline/coda/referti/CODA_0{1,6}_*_20261011_033004.log` (sonde di sola lettura di stanotte) · `TA` = `data/statements/trades_auto.csv` · `PS` = `report/PRIMO_STOP_FTMO_2026-09-22.md` · `OR` = `report/OROLOGIO_BCM_2026-09-24.md` · `RG` = `docs/RISPOSTA_A_GEMINI_2026-10-08.md` · `M08` = `report/MIGLIORA_EMA200_DOW_771531_2026-10-08.md` (la scheda precedente) · `C00` = `backtest_pipeline/prove/COLLAUDO_EMADOW_00_manopola_maxspread.txt`.

---

## 0. IN BREVE -- la diagnosi in dieci righe

1. `[MISURATO]` **La cella**: U30USD H1 L+S, PF **1,2011 IS / 1,5237 OOS**, DD equity **5,73% / 7,83%** a rischio 1%, 237 / 517 deal = **132 / 257 posizioni**, tick reali, 2024.09.26-2026.06.30, deposito 100.000 (C136 r136a IS r.2, OOS r.3; EG2 `RIEPILOGO_ROUND_EMAGEM2.txt`; 132 pos: `report/LETTURA_BACKLOG_NOTTE_2026-09-13.md` r.80-82, **non ricontabile dal repo**). Il tester ha riprodotto la cella cifra per cifra quattro volte.
2. `[DERIVATO]` **Le 257 sono gambe, non decisioni**: ~**157 segnali** (100 a due gambe, 57 a una), 82 coppie su 100 con lo stesso esito. **Lo short fa il 75,7% del profitto** (17.643 su 23.321). **Tre mesi su tredici (set-25, feb-26, mar-26) fanno il 72,5%**; senza settembre 2025 PF 1,3338 su 230; bootstrap a blocchi mensili PF **1,05-2,23** (95%), P(PF<1) = 1,4%.
3. `[DERIVATO]` **Regime: un solo, confermato, con un episodio dentro.** Dai prezzi di uscita del per-trade il Dow passa da ~42.400 (giu-25) a ~50.900 (giu-26), **+20%**, con una correzione di **-7%** a marzo 2026 (mediana feb 49.484, minimo mar 46.119) in cui la cella ha fatto **15 gambe short, 0 long, +4.199**. Per la regola di etichettatura di DK (TORO = rendimento >= +10% e DD < 15%) e' TORO. Orso, crollo, laterale: `[NON MISURATO]`.
4. `[MISURATO]` **Costo**: stop della gamba debole / spread = **28,7x** (campo 22/09) ... **33,6-45,2x** (banco) ... **54,9x** (stop pieno mediano): la frontiera 40x cade DENTRO la banda e le quattro convenzioni non sono riconciliate (sez. 1.4).
5. `[MISURATO]` **Uscita**: sette manopole gia' messe ad asse (SLatr, TP1 ATR, TP1 %, trailing, BE, chiusura venerdi', RR) -> casella 3 del certificato chiusa; ma tutte nel toro, e il trailing OFF cambia segno fra IS e OOS (sez. 1.5).
6. `[MISURATO]` **Gemelli e TF**: D30EUR H1 0,928/**0,783**, NASUSD H1 0,755/**0,693**; H1 e' il bordo di un tratto (H2 1,17 OOS ma IS 127 deal; M15-M30 esclusi per costo e PF OOS < 1). Dei gemelli manca la casella 3 (uscita ad asse) -> **NON ANCORA MISURATO, non morti** (sez. 1.6-1.7).
7. `[MISURATO]` **Dove sta la sedia (sonda di stanotte, 03:30)**: **in nessun profilo salvato** (47 sedie attive, 0 con magic 771531). Ha lasciato il piccolo `50503392` il **24/09 03:30** e la cartella `C:\FTMO` (challenge `541452707`, poi trial `1514806751`) fra il 30/09 e il 01/10; `ABTG_EMA200_Ombra` e' attaccata sul piccolo dal 07/10. Il binario sul piccolo ha 487 righe e `GUARD=no`: **non legge il Guardian** (C01 r.12-48; C06 r.97). Il live puo' differire dal profilo salvato: `[DA VERIFICARE A VISTA]`.
8. `[MISURATO]` **Forward**: demo 14/08-22/09, 23 gambe = 14 segnali, PF **0,684** (gambe) / **0,675** (segnali), p esatto 0,071 / 0,145: dentro il rumore, nessun verdetto di merito (Emendamento B). **Il 22/09 il demo e FTMO hanno preso lo STESSO evento: aperture a 0 e 1 secondo di distanza, stop allo stesso secondo** (sez. 1.10): non si sommano.
9. `[INFERITO]` **Dopo l'08/10 non e' stata fatta nessuna misura nuova su questa sedia.** Il collo di bottiglia e' la prova di regime: P1 (<= ~8,5 h di PC, F2 gia' firmata) non risulta lanciata (`[NON TROVATO]` esito) e il PC di backtest ha in coda GBA/NatCla (`report/MATTINA_2026-10-11_COSA_LANCIARE.md` r.6-8); il crawl Dukascopy e' 63-244 h (CORE-A) o 90-348 h (nucleo).
10. `[INFERITO]` **Le quattro ipotesi** (sez. 3): H1 stop piu' largo (costo e DD), H2 la coda senza trailing (+ cella-certificato sui gemelli), H3 il lato long d'inverno (lettura prima, filtro mai senza >= 6 inverni su 7), H4 il costo vero (il tester porta lo spread vero? + ora 23). Tutte sull'asse USCITA/FILTRO di un motore VIVO sul Dow (26/26 celle positive nello scan H1): consentite; nessuna griglia su motori senza edge.

### 0.1 Cosa cambia rispetto alla scheda dell'08/10 (M08)
M08 resta l'archivio dei numeri completi (317 righe). Questa e' la riscrittura corta e aggiornata a stanotte. **Riletti da capo tutti i numeri di M08 su CSV e per-trade: nessuno cambia** (salvo il bootstrap, 1,05 contro 1,06, flusso casuale diverso). **Nuovo o corretto**:
- `[MISURATO]` **CORRETTO**: M08 sez. 1.8 mette la rimozione della 771531 dal piccolo al "25/09 03:30" (sospensione). Le sonde dicono **24/09 03:30** (grafico `ORO\chart33.chr` presente il 23/09, assente il 24/09; C01 del 23/09 r.43) e la tabella dei 15 grafici sospesi il 25/09 **non la contiene** (`report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md` tab. 1) mentre `HANDOFF.md` r.68 la conta fra le 16 sparite: `[NON RICONCILIATO]`, chi e quando l'ha tolta e' `[NON TROVATO]`.
- `[MISURATO]` **CHIUSO**: M08 teneva `[DA VERIFICARE A VISTA]` se la sedia fosse sulla trial. Ora **11 sonde consecutive (01/10 -> 11/10)** non la trovano nel profilo di `C:\FTMO` (trial `1514806751`; 10 sedie, nessun 771531). Resta aperto solo il live (profilo non salvato).
- `[MISURATO]` **CHIUSO**: M08 teneva `[NON VERIFICATO]` che i segnali di demo e FTMO coincidessero: il 22/09 coincidono (aperture a 0 e 1 s, stop allo stesso secondo; sez. 1.10).
- `[DERIVATO]` **NUOVO**: concentrazione in tre mesi (72,5%), la correzione di marzo 2026 (OOS) come episodio non-rialzista, accanto alla discesa feb-apr 2025 dell'IS, scan H1 (Dow 26/26 celle positive, cella viva al 18o posto su 26), controllo dell'oro come caso-limite.
- `[MISURATO]` **PRECISATO**: l'IS ha operato dal 2024.10.22 al 2025.06.06 (7,5 mesi), non 8,5: 132 pos = **17,6/mese** (non 15,5). Cambia i conti "mesi per 150 posizioni" di DK §1.5 (IS: 8,5 mesi invece di 9,7).

---

## 1. DIAGNOSI

### 1.1 Che cosa fa la cella (EA r.319-445; VIVA)
- A ogni barra H1 nuova, se non ha posizioni ne' pendenti (r.322) e il prezzo sta fra **0,3 e 1,5 ATR** dalla EMA200 (r.331) con la EMA14 dallo stesso lato (r.341), piazza **due LIMIT** (r.354-367): gamba 1 a EMA200 +0,2 ATR verso il prezzo, gamba 2 a EMA200 -0,3 ATR oltre; stop unico = gamba 2 -1,0 ATR; TP 2R; scadenza pendenti 6 barre; rischio diviso per due gambe (gamba 1 rischia 1,5 ATR, gamba 2 1,0 ATR). **Max 2 gambe per segnale** (correzione del cancello a Gemini, RG par. 3 "Altre imprecisioni").
- Gestione (r.392-445): a EMA14 raggiunta parziale 50% + stop in pari (`InpBreakeven`); poi trailing sulla EMA14, attivo solo con stop gia' in pari (`beDone`, r.408/r.436). Parziale, pari e trailing non si separano da soli.
- **Nessun filtro d'ora attivo**: `InpUseCutoff=false`, `InpFridayClose=false`, news e ADR spenti, `InpMaxTradesPerDay=0`, `InpMaxSpread=0` (VIVA). Ho elencato ogni lettura di orologio nel sorgente: `FridayCloseCheck` r.277-284, `CutoffCheck` r.447-453, scadenza pendenti relativa (r.378), imbuto del solo log (r.243-249) e azzeramento del tetto giornaliero, spento (r.299): **con questi preset la logica di trading non legge l'ora**.
- `[MISURATO]` Uscite OOS (257 gambe): utile via BE/trailing 145 (56,4%), perdita parziale 23, stop pieno 78 (30,4%), TP finale a 2R solo **11 (4,3%)** (DUE r.339-343). Il guadagno viene da parziale + coda, non dal TP.
- **Default dell'EA = trappola**: `InpTF` H4, `InpRiskPercent` 1,0, `InpMagic` 771501 (EA r.68-69, r.74; `VIVA` r.33-36): un "Ripristina" senza preset cambia TF, taglia e identita'. La cella vive nei preset (VIVA 0,65% · piccolo 1,0% · FTMO 2,00%).

### 1.2 I numeri, con la fonte
| cosa | valore | fonte |
|---|---|---|
| PF IS / OOS | **1,20110 / 1,52365** | C136 r136a IS r.2, OOS r.3 |
| profitto IS / OOS (100k, 1%) | 4.585,40 / 23.321,47 | idem |
| deal IS / OOS | 237 / 517 | idem |
| posizioni IS / OOS | **132** `[non ricontabile]` / **257** | LETTURA_BACKLOG r.80-82; PT (518 righe) |
| DD equity IS / OOS | 5,7325% / 7,8323% | C136 r136a |
| DD a 0,65% / 1,5% / 2,00% (OOS, lineare) | 5,09% / 11,75% / **15,66%** `[DERIVATO]` | 7,8323 x taglia; la linearita' sovrastima salendo (RG par. 2 C3, R29->R112: 8,29 contro 7,83) |
| peggior giornata a 1% | -2,45% chiusi / -1,98% equity | G2 r.133 `[DICHIARATO]` |
| PF con costi prop | 1,43-1,46 | G2 r.133 `[DICHIARATO]` |
| frequenza | **0,945 gambe/giorno** feriale (257/272) · ~0,58 segnali/giorno `[DERIVATO]` | DUE r.320 |
| ritmo | OOS 20,6 pos/mese (257 in 12,5 mesi, 2025-06-12 -> 2026-06-26) · IS 17,6 | PT; LETTURA_BACKLOG |
| finestre / modello | IS 2024.09.26-2025.06.09, OOS 2025.06.10-2026.06.30, Modello 4 | G2 r.123 |
| classe | **B** (n OOS >= 150, un regime), merito sospeso (IS 132 < 150) | G2 r.154-155 |

### 1.3 Dentro le 257 `[DERIVATO]` (PT, script in scratchpad; Appendice A)
| misura | valore | lettura |
|---|---|---|
| per lato | long 121 gambe PF **1,224** (+5.678) · short 136 gambe PF **1,921** (+17.643) | quadra con R110 (long-only 1,241, short-only 1,891); lo short porta il 75,7% |
| segnali | **157** (100 doppi, 57 singoli), PF per segnale 1,557, vinti 66,9% | le decisioni indipendenti sono 157 |
| coerenza delle coppie | 82 su 100 stesso esito | a caso sarebbe ~50% |
| dipendenza seriale (segnali) | P(vince \| precedente vincente) 65,4% (104) · \| perdente 69,2% (52) | nessuna: non sostiene "dopo uno stop si sta fermi" |
| profitto per mese di chiusura | giu +2.551 · lug +2.931 · ago -180 · **set +9.220** · ott +2.478 · **nov -2.712 · dic -1.085 · gen -2.304** · **feb +3.484 · mar +4.199** · apr +1.222 · mag +3.846 · giu -328 | set+feb+mar = **16.903 = 72,5%** |
| concentrazione | senza settembre PF 1,3338 su 230 · senza le 5 gambe migliori 1,389 · senza le 10 migliori 1,265 · **un mese fuori alla volta: 1,334-1,666** | settembre e' il minimo; togliere il mese migliore abbassa il PF di qualunque serie (RG B1): misura di concentrazione, non PF "corretto" |
| intervallo del PF | bootstrap a blocchi mensili (13 blocchi, seme 7, 5000): **1,05 / 1,51 / 2,23** (2,5/50/97,5), P(PF<1) 1,4% | e' il rumore DENTRO il toro: non misura selezione ne' regime |
| lato x semestre | **long nov-mar 38 gambe PF 0,241 (-9.176)** · long apr-ott 83 PF 2,119 · short nov-mar 65 PF 2,197 · short apr-ott 71 PF 1,677 | riproduce la verifica del cancello (RG B2); i long invernali stanno tutti in nov-feb (10/9/8/11 gambe), marzo ne ha 0 |
| short in feb-mar 2026 | 38 gambe, +9.380 = **53,2% del profitto short** | lo short vive di episodi correttivi |

### 1.4 Il costo: quattro convenzioni, nessuna riconciliata `[NON RICONCILIATO]`
| convenzione | numeratore | spread | rapporto | fonte |
|---|---|---|---|---|
| A. stop pieno mediano | 104,3 pt (n=8) | 1,90 | **54,9x** | DUE r.160 |
| B. gamba 2 (la debole), banco | 78,0-88,2 pt | 1,95 (sessione) | **33,6-45,2x** (la soglia 40x cade dentro: FRAGILE) | DUE r.174 |
| C. gamba 2, formula GEM | 78,0-88,2 | 2,00 / 2,60 (mediana 24 ore) | 39,0-44,1x / **30,0-33,9x** | GEM r.77 |
| D. campo 22/09 | gamba 2 68,21 pt · gamba 1 97,71 pt | 2,38 | **28,7x** / 41,1x `[DERIVATO da PS r.17-18]` | PS |
Sul campo lo stop si e' riempito **7,83 punti oltre** (3,3x lo spread): perdita **1.757,68** contro 1.590,37 promessi = **+10,5%**, n=1 (PS r.37). Spread di coda: p95 dell'ora 23 server = **7,0 pt**, la sedia apre anche a quell'ora (DUE r.185) -> gamba 2 a 9,4-12,6x, **sotto il pavimento duro 13,3x**. Il **44,3% delle uscite cade nelle ore 0-13 e 23**, dove la mediana dello spread e' 2,6-2,8 (C00 r.77-86); l'ora d'ingresso non e' nel per-trade (`[NON MISURATO]`): se l'ingresso cadesse nelle stesse fasce, il rapporto della gamba debole sarebbe **28-34x** `[INFERITO]`. **TF**: M30 28,3-32,0x, M20 23,1-26,1x, M15 20,0-22,6x, M5 11,5-13,1x -> **ESCLUSI PER COSTO col numero** (DUE r.14); H2 56,6-64,0x, H3 69,3-78,3x, H4 80,0-90,5x passano il costo ma non il campione.

### 1.5 La gestione dell'uscita: gia' messa ad asse (casella 3 chiusa) -- tutte nel toro
Righe C136 (IS PF/DD, OOS PF/DD). P/DD e "scala pura" = profitto del default x (DD variante / DD default): `[DERIVATO]`.
| manopola | valori | IS | OOS | lettura |
|---|---|---|---|---|
| `InpSLatr` (r136a) | 0,8 / **1,0** / 1,2 / 1,4 / 1,6 | PF 1,189 / **1,201** / 1,255 / 1,218 / 1,072 · DD 5,13 / **5,73** / 4,73 / 4,27 / 4,76 | PF 1,612 / **1,524** / 1,462 / 1,595 / 1,458 · DD 8,19 / **7,83** / 5,97 / 5,77 / 6,25 | altopiano 0,8-1,6; DD cala in IS e OOS a 1,2-1,4 (-18/-25% e -24/-26%); n OOS 519-529 (+0-2%) |
| `InpSLatr` P/DD vs scala pura | 1,2 / 1,4 | IS +38% / +18% | OOS **+4%** / **+14%** | a 1,2 in OOS e' "un lotto piu' piccolo" (profitto -20,5%, DD -23,8%); a 1,4 e' coerente in tutte e due (+18/+14) |
| `InpTP1_ATRmult` (r136b) | 0 (EMA14) / 0,25 / 0,5 / 0,75 / 1,0 / 1,25 / 1,5 | **1,201** / 0,994 / 1,014 / 0,900 / 0,869 / 0,837 / 0,762 | **1,524** / 1,590 / 1,409 / 1,436 / 1,549 / 1,540 / 1,587 · DD OOS 7,83 / **2,10** / 3,21 / 7,52 / 8,63 / 9,46 / 9,87 | IS decresce (non strettamente: 0,994 a 0,25 e 1,014 a 0,50); il default e' il massimo dell'IS; a 0,25 DD 2,10% ma IS 0,994 |
| `InpTP1Pct` (r136c) | 0 / 25 / **50** / 75 | 0,935 / 1,200 / **1,201** / 1,200 | 1,281 / 1,518 / **1,524** / 1,526 · DD OOS **13,94** / 7,87 / 7,83 / 7,82 | parziale ON si tiene (spento: DD 13,94% > 10%); taglia 25-75 inerte (7 millesimi) |
| `InpUseTrailing` (r136d) | 1 / 0 | **1,201** / 1,107 · DD 5,73 / 5,50 · profitto 4.585 / 2.045 | **1,524** / 1,771 · DD 7,83 / 7,42 · profitto 23.321 / 28.250 · deal 517 / 427 | **segno invertito**: IS -0,094 PF e -55% profitto, OOS +0,247 PF e +21%; DD meglio in entrambe, Sharpe peggio in entrambe (PORTA tab. 2) |
| `InpBreakeven` (r147a) | 1 / 0 | 1,201 / 1,288 | 1,524 / 1,528 · DD 7,83 / 8,90 · profitto -31% | PF invariato, DD sale: il BE si tiene |
| `InpFridayClose` (r146b) | 0 / 1 | 1,201 / 1,213 | 1,524 / 1,425 · profitto -20% | prezzo noto: -0,099 PF |
| `InpTP_RR`, O1, O2 (r29b, 30 celle, deposito 10k) | RR 1,5-2,5 · O1 0,10-0,30 · O2 0,2-0,3 | PF 1,05-1,33 (30/30 > 1) | PF 1,44-1,61 (30/30 > 1) | altopiano; O1 alto aiuta in IS (1,152 -> 1,276) e danneggia in OOS (1,557 -> 1,481): segno invertito = niente da guadagnare nell'ingresso; O2 mai oltre 0,3 in tick |
Rumore: dalla banda bootstrap qui sopra, il PF OOS di una singola finestra ha un'incertezza di **~+-0,3**; la banda di casa A9 = 0,10 e' piu' stretta. Conseguenza (sez. 3): nessuna variante si giudica su una finestra sola.

### 1.6 Simboli gemelli e timeframe
| cella | IS PF (n deal) | OOS PF (n deal) | DD OOS | fonte |
|---|---|---|---|---|
| **U30USD H1** (la sedia) | 1,201 (237) | **1,524** (517) | 7,83% | C136 |
| D30EUR H1 | 0,928 (295) | **0,783** (568) | 15,18% | EG2 `ROUND_EMAGEM2b` OOS r.3, IS r.3 |
| NASUSD H1 | 0,755 (244) | **0,693** (508) | 20,97% | EG2 `ROUND_EMAGEM2c` OOS r.3, IS r.3 |
| D30EUR H4 | 1,133 (40) | 1,052 (156) | 5,54% | EG2b r.6 (campione sottile) |
| NASUSD M30 | 0,728 (518) | 1,092 (1043) | 5,99% | EG2c r.2 (segno invertito, esclusa per costo 23,6x) |
| U30USD H2 / H3 / H4 | 2,599 (127) / 2,152 (36) / 1,660 (26) | 1,173 (266) / 0,908 (170) / 1,425 (116) | 6,12 / 9,00 / 4,45% | C136 cemad05 IS r.4,6,8; OOS r.5,7,8 |
| U30USD M15 / M20 / M30 | 0,771 / 1,117 / 1,034 | 0,954 / 0,833 / 0,907 | 26,3 / 30,7 / 15,9% | cemad05 IS r.3,5,7; OOS r.3,4,6 |
Scan OHLC H1 su 45 simboli con celle L+S >= 100 trade (`backtest_pipeline/risultati_archivio/EMA200/H1_OHLC/`, finestra unica 2024.01.01-2026.06.30, `[B]` screening) `[DERIVATO]`: **il Dow e' l'unico indice con 26/26 celle in utile** (PF max 1,55, mediana 1,41); D30EUR 0/28, NASUSD 0/26, SPXUSD 0/27, 225JPY 45% delle celle (escluso per costo). Sulle 1.287 celle L+S il 10,3% ha PF > 1 (mediana 0,805). **La cella viva non e' il picco: 18a su 26 per PF** (1,361 contro max 1,549; il suo DD 6,58% e' il piu' alto delle 26). Controesempio che tiene a freno l'entusiasmo: XAUUSD H1 ha anch'esso 26/26 celle positive nello scan, ma in tick nell'IS fa **0,564** (G2 r.143, 30 celle su 30 in perdita): una superficie positiva su 30 mesi non garantisce l'IS. Le celle di un simbolo non sono indipendenti.

### 1.7 Il certificato di non-morte, casella per casella
| casella | stato | cosa c'e' / cosa manca |
|---|---|---|
| 1 PF | SI | 1,2011 / 1,5237 a tick |
| 2 n e DD | SI, con riserva | OOS 257 pos (157 segnali) DD 7,83%; **IS 132 < 150, non ricontabile** (M0a) |
| 3 uscita ad asse | SI per la sedia | sette manopole (1.5); **mancano**: nessuna misura fuori dal toro; per i **gemelli** l'uscita non e' mai stata ad asse (grep su `prove/`: nessun file con `InpUseTrailing...||Y` e simbolo D30EUR/NASUSD che sia ABTG_EMA200) |
| 4 gemelli | SI a tick (DAX/Nasdaq H1, M30-H4) | non passano; manca solo la casella 3 su di loro |
| 5 TF | SI, 7 TF | H1 e' il bordo |
| **mancano davvero** | (a) prova di regime; (b) IS in posizioni misurate; (c) posizioni/segnali/peggior giornata **misurati** delle varianti; (d) convenzione del costo; (e) per-trade con ora d'ingresso e MFE/MAE (nel per-trade c'e' solo `close_time`: EA r.622); (f) `COLLAUDO_EMADOW_00/01/06` (spread, latenza): file scritti, `[NON TROVATO]` CSV | |

### 1.8 Il regime: verifica del "un solo regime" `[DERIVATO]`
Il per-trade ha il prezzo di uscita di ogni deal: la mediana mensile e' una **proxy grezza** del livello del Dow (non una serie di chiusura). Mediana (min-max): giu-25 42.424 · lug 44.660 · ago 44.235 · set 45.772 · ott 46.319 · nov 47.290 · dic 48.040 · gen 49.029 · **feb 49.484 (max 49.703)** · **mar 46.467 (min 46.119)** · apr 46.474 · mag 49.582 · giu 50.896 (max 51.884). Cioe' **+20% in 12 mesi, un -7% a marzo**. Quindi: `OOS = TORO con un episodio correttivo` (DD proxy ~7%, sotto il 15% della regola), l'IS aggiunge la discesa feb-apr 2025 (DD cella 5,73%, `report/LATI_A1_FINESTRA_DENTRO_L_IS_2026-10-05.md` r.3-8). Il campione contiene **due episodi correttivi brevi e nessun orso, crollo o laterale**. Il numero vero (buy&hold e DD del feed) lo da' la regola di etichettatura di DK §1.3 al passo P5. Per i tre mesi che fanno il 72,5% del profitto: **set-25** e' un rialzo di ~+3,5% in un mese (mediana 44.235 -> 45.772); **feb/mar-26** e' il picco e la correzione; i mesi **nov-gen** salgono di ~+3,7% in due mesi (47.290 -> 49.029) e li' il long perde **-7.480** in tre mesi. Un rialzo simile (set-25, nov-gen) da' esiti opposti al lato long: **da qui non si capisce perche'** (stagione, fase o caso) e non invento un meccanismo. E' la domanda che H3 mette alla prova.

### 1.9 L'orologio
`[DERIVATO da sorgente + OR]` A H1 la griglia delle barre non cambia con l'ora legale (scarti di ore intere), e con i preset in uso nessun ramo legge l'ora (1.1): **inerte per costruzione**, coerente con OR 5.1.1 e GEM r.98. BCM sugli indici e' UTC+1 fisso su tutto l'arco 2024.09.26+ (`CLAUDE.md` r.440-475): **il campione non mescola due orologi** (a differenza di 770101/770202/770411). FTMO = BCM + 2 ore (verificato sul 22/09, sez. 1.10). **Eppure il PF oscilla**: stesso motore, mezzo anno contro mezzo anno, **2,05 (347 deal) contro 0,87 (170)** (OR r.225, 247-252) e 1,93 contro 1,08 per mese di chiusura. Quel numero e' il **gruppo di controllo dell'orologio**: una sedia SENZA orologio mostra un'oscillazione dello stesso ordine di grandezza delle sedie con orologio, quindi la colpa dell'orologio per 770202 (PF 0,78 contro 1,66) **non e' dimostrata** (OR 5.1.3). Per la 771531 la causa e' direzionale: il crollo invernale e' tutto del lato long (RG B2, riletto da me: 0,241 su 38). Dal 25/10 (EU) e 02/11 (USA) cambia il rapporto con l'apertura cash ma non la griglia: **nessuna azione sull'orologio per questa sedia**. Conferma indipendente: la pagina di decisione sull'orologio d'inverno (`report/DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md` r.83-85) usa la stessa 771531 come controllo (2,05 contro 0,87). L'unico input orario nell'ecosistema EMA200 e' quello dell'**Ombra** (`InpNotteDaOra=23` / `InpNotteAOra=4:59`, ivi r.65), che riguarda il suo log e non la sedia.

### 1.10 Il campo: dove sta la sedia, e che cosa ha fatto
| data | fatto | fonte |
|---|---|---|
| 04/08-06/08 | binario `344a11b9` sul piccolo: **486 righe, 0 `InpUsaGuardian`** (`git show 344a11b9`, verificato ora) | CLAUDE.md; VIVA r.14-18 |
| 14/08-22/09 | demo piccolo: **23 gambe = 14 segnali**, netto -54,71, 10 gambe vinte (1 a zero), long 12 (+3,18, 6 vinte), short 11 (-57,89, 4 vinte), PF 0,684; per segnale 7 vinti su 14, PF 0,675 | TA r.1169-1334 (23 righe `;771531;`) |
| 18/09 | criterio di merito del 18/08 scattato (famiglia EMA200, -127): Claudio "lasciamole in demo piccolo", revisione aperta | `report/DECISIONE_EMA200_RESTA_SUL_DEMO_2026-09-18.md` |
| 20/09 | FTMO `541452707` (`C:\FTMO`): `CLAU12_EMA200`, pin `26a18566`, 552 righe (+1 = 553 in C06 r.191/218), 2 occorrenze di Guardian | `report/SCHIERAMENTO_FTMO_2026-09-20.md`; C06 |
| **22/09** | **due gambe, un evento, due conti**: demo S1 10:52:01 @52.157,70 / S2 10:52:32 @52.191,40, chiuse a stop 12:45:51; FTMO S1 12:52:01 @52.160,28 / S2 12:52:31 @52.189,78, chiuse 14:45:51 a 52.265,82. Con FTMO = BCM +2 h **le aperture distano 0 e 1 secondo e lo stop cade allo stesso secondo**. FTMO: -1.757,68 EUR (2,197% di 80k) contro -1.590,37 promessi | TA r.1333-1334; PS r.17-18, r.37 |
| **24/09 03:30** | la 771531 **non c'e' piu'** sul piccolo (`ORO\chart33.chr`) | C01 del 23/09 r.43 vs 24/09 |
| 30/09 | FTMO 541452707: challenge finita (Max Loss violato, comunicato di Claudio); 03:30 ultima volta sul profilo `Default` | HANDOFF r.49; C01 del 30/09 r.48 |
| 01/10-11/10 | trial `1514806751` (`C:\FTMO`): profilo `Default` con 10 sedie, **senza 771531** (e senza 770101); Guardian sbloccato 08/10 a 9,9%; scade il 14/10 | C01 (11 sonde); `report/FTMO_SBLOCCO_GUARDIAN_ESEGUITO_2026-10-08.md`; PRIORITA r.29 |
| 07/10 -> oggi | `ABTG_EMA200_Ombra` (EURUSD M15) sul piccolo: registra il segnale della cella sulla tabella dei simboli, **senza ordini**; dati `[NON TROVATO]` (nessun CSV/zip letto) | C01 r.42; `report/EA_EMA200_OMBRA_2026-10-05.md` |
Conseguenza: i 23 gambe del demo contengono 2 gambe del 22/09 che sono **lo stesso evento** dello stop FTMO: i campioni forward dei due conti **non si sommano**. Dal 24/09 il campo non accumula campione nuovo su questa sedia.

---

## 2. CHE COSA E' GIA' STATO MISURATO, E COSA NO
| domanda | stato | note |
|---|---|---|
| PF/n/DD a tick, IS e OOS | SI (4 riproduzioni) | EG2 T1 PASS 04/10 |
| Uscita ad asse (7 manopole) | SI nel toro | 1.5 |
| Gemelli e TF a H1 | SI, non passano | 1.6; uscita sui gemelli NO |
| Costo, scala di spread | PARZIALE | il banco gira `Spread=0`; **non si sa se il tester porti lo spread vero** (C00 r.87-107: canarino mai letto) |
| **I numeri sono su un solo regime?** | **SI, verificato** (1.8): TORO +20% con correzione -7% a marzo 2026; IS con la discesa feb-apr 2025 | orso, crollo, laterale `[NON MISURATO]`; buy&hold del feed `[NON MISURATO]` |
| Selezione del simbolo | **PARZIALE** | scan H1 con finestra 2024.01-2026.06 che CONTIENE l'OOS (G2 r.111-112): il Dow non e' stato scelto per un picco (cella al 18o posto su 26, 26/26 positive), ma l'OOS non e' vergine rispetto alla scelta del simbolo; come fu scelto: `[NON RICOSTRUITO]` |
| Orologio | inerte per costruzione (1.9) | oscilla lo stesso: e' il controllo per le sedie con orologio |
| Prova di regime (W1-W4) | NO | piano pronto (DK); P1 non lanciata; F1 non firmata |
| Posizioni IS misurate | NO | M0a |
| Posizioni/peggior giornata delle varianti | NO | solo deal e DD dei CSV |
| Ora d'ingresso, MFE/MAE | NO | il per-trade ha solo `close_time` |
| Slippage/latenza dell'esecuzione vera | n=1 (+10,5%, 22/09) | `COLLAUDO_EMADOW_01/06` mai letti |
| Merito forward | rumore | 14 segnali, p=0,145 |
| Con il Guardian acceso | NO | nel tester il Guardian e' fail-open (EA r.31-41: le GlobalVariable non esistono): il DD 7,83% **non** contiene l'effetto dei cap |

---

## 3. LE QUATTRO IPOTESI (attesa scritta PRIMA dei numeri)

**Metro unico** (dalla casa): PF letto con rumore A9 = 0,10 ma **nessuna variante si giudica su una finestra sola**: serve la stessa direzione in **>= 3 finestre su 4** (W1 orso 2022 · W2 crollo/anno 2020 · W3 toro 2021 · W4 laterale 2015-16, DK r.43-52); centro dell'altopiano, mai il picco; n >= 150 posizioni (e dichiaro anche i segnali); rischio a qualunque n (Emendamento B); "dopo" non c'e' promozione e non c'e' taglia (A10). Criteri e attese vanno **congelati nei file prova prima di ogni numero nuovo**. **Prima della regime run: M0** (il pacchetto di misure a banco, sotto) produce posizioni, segnali, peggior giornata e il **bootstrap appaiato a blocchi mensili del Delta PF** di ogni variante: e' la banda di rumore vera che oggi manca.

### H1 -- Stop piu' largo: `InpSLatr` 1,2 e 1,4 (asse 1,0 / 1,2 / 1,4) -- USCITA, consentito
- **Meccanismo**: stop piu' lontano dal rumore, meno sensibile a spread e slittamento. Gamba 2 = SLatr x ATR (EA r.356-358): a 1,2 vale 93,6-105,8 pt = **48,0-54,3x** (convenzione B); sul campo del 22/09 vale 81,9 pt = **34,4x**; solo l'1,4 arriva a 95,5 pt = **40,1x** `[DERIVATO, lineare]`. Leva di COSTO e di DD, non di PF.
- **Dato oggi** (1.5): DD concordante in IS e OOS (4,73 e 4,27 contro 5,73; 5,97 e 5,77 contro 7,83), PF IS su, PF OOS +-0,10, n invariato (+0-2%), profitto OOS -20,5% / -15,9%.
- **ATTESA** (banda, tre esiti scritti prima). Nelle 4 finestre, in **>= 3 su 4**: (a) **leva di costo e DD confermata** se |Delta PF| <= 0,10, DD(variante)/DD(1,0) in **[0,70 ; 0,95]**, posizioni +-5% e P/DD(variante)/P/DD(1,0) **>= 0,90**; (b) **miglioramento oltre la scala** solo se in piu' il rapporto P/DD sta **>= 1,10** e sopra la banda appaiata di M0 (i vicini 0,8-1,4 del banco oscillano +-13-15%: senza la banda appaiata 1,10 non basta); (c) fra 0,90 e 1,10 = **taglia travestita**. Oggi (banco, un solo regime): 1,2 -> IS 1,38 / OOS 1,04; 1,4 -> IS 1,18 / OOS 1,14. Costo a banco: nessuna firma oltre il lancio (4 passate).
- **Altra spiegazione e il numero che la produce**: "e' solo una taglia piu' piccola travestita". Se vale, P/DD(1,2)/P/DD(1,0) = **1,00 +-0,10 in tutte le finestre** e il DD cala come il lotto (profitto -20% con DD -24%). Oggi in OOS il rapporto di 1,2 e' **1,04**: l'altra spiegazione e' gia' viva in una finestra su due, e per 1,4 (1,14) non e' esclusa.
- **La smentisce**: DD che cala in meno di 3 finestre su 4; oppure Delta PF < -0,10 in >= 2 finestre; oppure P/DD < 0,90 in >= 2 (allora l'esito e' "stop piu' largo = meno profitto del DD risparmiato"). Se l'altra spiegazione vince, la risposta onesta e' **"il default va bene; il DD si abbassa con la taglia, che e' di Claudio"**: a 1,5% il DD OOS lineare e' 11,75% con 1,0, **8,95% con 1,2, 8,65% con 1,4** `[DERIVATO]`.
- **Costo macchina** (PC di backtest): banco 4 passate (~2 min); regime 2 celle x 4 finestre = **8 passate** (~8-16 min a 1-2 min per passata-anno, `[stima di casa non cronometrata a tick]`).
- **Classe**: stop = gestione dell'uscita di un motore vivo (30/30 celle): consentito; non e' una griglia (tre valori contigui, il centro e' il default).

### H2 -- La coda senza trailing: `InpUseTrailing` 0 (parziale e BE restano) -- USCITA, consentito (+ cella-certificato sui gemelli)
- **Meccanismo**: la EMA14 come trailing taglia la coda; senza, la gamba resta fino a pari o TP 2R. In OOS il profitto **per posizione** passa da 90,75 a **131,40 (+44,8%)** con 215 posizioni contro 257 `[MISURATO, PORTA r.348-379]`; in IS, per deal, da 19,3 a **10,5 (-46%)** `[DERIVATO da C136 r136d IS r.2-3]`. Frequenza -16% (~0,79 gambe/giorno, sotto il pavimento 1,00 per famiglia).
- **Dato oggi**: IS 1,201 -> 1,107, OOS 1,524 -> 1,771; il criterio congelato 1 (concordanza IS/OOS) FALLISCE (PORTA tab. 3); DD meglio in entrambe, Sharpe peggio in entrambe.
- **Lettura aggiunta (mia)**: l'inversione (-0,094 / +0,247) sta **dentro il rumore** di un PF a 132-257 posizioni (banda a blocchi 1,05-2,23): non prova una dipendenza dal regime e non prova il contrario. Per questo serve il regime.
- **ATTESA**: Delta PF (OFF - ON) **>= +0,10 in W3 (toro 2021)** e **<= 0 in almeno 2 fra W1, W2, W4** (il trailing protegge nelle discese e nei range: e' l'IS di r136d, che contiene feb-apr 2025). Sui **gemelli** (cella-certificato, 4 passate: D30EUR H1 e NASUSD H1, OFF, IS e OOS): PF OOS resta **< 1,00** su entrambi (bande D30EUR 0,70-0,95, NASUSD 0,60-0,90: i valori ON 0,783 / 0,693 +-0,15 `[INFERITO]`) e Delta PF OOS in [-0,10 ; +0,25].
- **Altra spiegazione e il numero**: "OFF e' meglio dappertutto e l'IS negativo era rumore di 132 gambe" -> Delta PF >= +0,10 in **>= 3 finestre su 4**. Sui gemelli: "il Dow non e' speciale" -> Delta PF OOS >= +0,25 su **entrambi**.
- **La smentisce / picco di rumore**: l'effetto sta nella sola W3 (toro) -> e' deriva, non meccanismo: si scrive "REGIME, non edge", **non** morto. Sui gemelli, una cella con **OOS >= 1,10 e IS >= 1,00 e DD OOS <= 10%** la falsifica come "senza edge": va in coda come CANDIDATA gemella, mai in campo.
- **Costo macchina**: banco 2 passate (dentro M0); gemelli 4 passate (~1-3 min: EG2b 102 s e EG2c 386 s per 10 passate); regime 4 passate (1 cella x 4 finestre, ~4-8 min).
- **Limite dichiarato**: anche se confermata come regime-dipendente, **non e' un miglioramento schierabile** senza un filtro di regime ex-ante, che non esiste e non si inventa qui. Il suo valore e' dire DOVE sta l'edge e chiudere la casella 3 dei gemelli.
- **Classe**: uscita su motore vivo + un simbolo gemello a una sola variabile: consentito.

### H3 -- Il lato long d'inverno (lato x semestre) -- FILTRO DI REGIME, lettura prima, mai un filtro senza >= 6 inverni su 7
- **Osservazione** (riletta da me, RG B2): long nov-mar **38 gambe PF 0,241 (-9.176)**, short nov-mar 65 gambe PF 2,197; long apr-ott 2,119 (83), short apr-ott 1,677 (71). Togliendo i long invernali l'OOS sarebbe PF **2,00** su 219 gambe, +32.497 (contro +23.321, **in-sample, un solo inverno: non e' un risultato, e' la grandezza della posta**). Frequenza -15%.
- **Meccanismo**: NESSUNO dimostrato. Due spiegazioni che si separano: **stagione** (la debolezza del long compare in nov-mar ogni anno) contro **fase** (compare in certe fasi di mercato, qualunque sia il calendario). Dai prezzi di uscita, set-25 (+3,5% in un mese, long +8.188) e nov-gen (+3,7% in due mesi, long -7.480) hanno una salita simile ed esiti opposti: la sola direzione del prezzo non spiega.
- **ATTESA** (scritta ora): su ogni inverno disponibile (2015/16, 2019/20 (parziale: da dicembre), 2020/21, 2021/22 dentro il nucleo DK; 2024/25 IS; 2025/26 OOS; 2026/27 dall'Ombra) PF(long, nov-mar) < PF(short, nov-mar) (per inverno le gambe per lato saranno poche, ~10-40: si legge la direzione, non il PF puntuale). **Supportata se la stessa direzione compare in >= 6 inverni su 7** (test del segno a una coda: p = 8/128 = **0,0625**); 5 su 7 = indizio (p = 0,227); meno = cade. Oggi gli inverni misurati sono 1 (OOS) piu' forse l'IS (n posizioni IS per lato `[NON MISURATO]`).
- **Altra spiegazione**: "fase, non stagione" -> la debolezza del long compare anche in mesi **non** invernali (ad esempio ago-25: long -1.080 su 8 gambe) e **manca** in alcuni inverni; il calendario non separa. Il numero che la produce: nelle finestre W1-W4 la tabella lato x mese mostra mesi negativi del long **fuori** da nov-mar, oppure inverni senza debolezza.
- **La smentisce**: <= 4 inverni su 7 nello stesso verso. Anche a 6/7 la mossa resta un'ipotesi di filtro: per diventare codice servono il cancello, un file prova e la firma di Claudio.
- **Costo macchina**: **zero passate nuove**. Si legge dal per-trade di M0a (IS), dalle finestre W1-W4 (per lato e per mese) e dal secondo inverno che l'Ombra sta gia' registrando. Serve uno script di lettura nuovo (cancello).
- **Classe**: filtro di regime su motore vivo: consentito; **non** e' un parametro di un motore senza edge. Rischio principale: curve fitting su un inverno (mitigato dal 6/7 scritto prima).

### H4 -- Il costo vero: il tester porta lo spread vero? + igiene dell'ora larga (`InpMaxSpread`) -- FILTRO D'ESECUZIONE, consentito
- **Meccanismo**: `SpreadOK()` (EA r.507) confronta `SYMBOL_SPREAD` all'istante del segnale (r.325) con `InpMaxSpread` (punti MT5: 100 = 1 punto indice). Domanda doppia: (1) il banco gira `Spread=0` = tick reali; **se il tester non portasse lo spread vero ogni numero di costo di questa scheda sarebbe ottimista** (C00 r.87-107, canarino sulla prova 01: `-Spread 0` contro `-Spread 99999`, 4 passate, `COLLAUDO_EMA200_DOW_CRITERI.md` r.45-85); (2) accendere la manopola che l'EA ha gia' toglie le ore larghe (p95 dell'ora 23 = 7,0 pt)?
- **ATTESA** (congelata da C00 il 12/09, riportata): n(100) quasi a zero, n(200) perde una fetta grossa, **n(300) quasi un no-op (p95 = 3,0)**, n(400) identico alla base (OOS PF 1,52365 / 517 deal; IS 1,20110 / 237). Per la lettura di miglioramento: a 300 **|Delta PF| <= 0,05**, n **0,93-1,00 x** base `[INFERITO: ~5% di segnali sopra il p95 di 3,0]`, DD <= base.
- **Altra spiegazione e il numero**: "il tester vede uno spread costante": le cinque celle **identiche alla cifra** -> due letture opposte non risolvibili da qui (C00 r.98): il canarino 01 le separa. Se n non e' monotono (n(100) > n(300)) = **guasto di banco**: non si conclude niente.
- **La smentisce**: Delta PF > 0,10 in un verso o nell'altro a 300 -> il filtro non agisce sul costo ma sull'edge: si legge e non si porta avanti; n(300) < 0,85 x base -> lo spread al segnale supera 3,0 molto piu' del 5% atteso (cost problem piu' grande del noto).
- **Costo macchina**: 10 passate (C00) + 4 (canarino 01) = 14, **~7-10 min** a 30 s per passata (EG2a: 4 passate in 122 s).
- **Classe**: filtro d'esecuzione su motore vivo: consentito; non cambia il segnale.
- **Canarino di manopola (gratis, 2 passate in M0)**: `InpUseAdrFilter` a `InpAdrDistMax` 0,8 e' **inerte per costruzione** (distanza massima 1,5 x ATR(H1) = 117-132 pt = 0,31-0,42 dell'ADR 314,5-379,5; `report/ANCORA_ADR_FLOTTA_INDICI_2026-09-18.md` r.99, r.159-163). **Attesa**: PF/n/DD identici alla cifra. Se si muovono, la mia derivazione e' sbagliata. (Era la proposta A1 di Gemini, con il nome sbagliato: RG tab. 2 A1.)

### 3.1 Tenute fuori dalle quattro, con il numero (nessuna e' "morta")
- `InpTP1_ATRmult` 0,25 (U3 di M08): OOS PF 1,590 e **DD 2,10%**, ma IS **0,994** e P/DD IS negativo; il default e' il massimo dell'IS. Aggiunge una cella per finestra al giudizio e la piu' probabile come picco di rumore: **entra come sentinella** solo se Claudio firma la regime run (2 passate per finestra, attesa DD(0,25) < DD(0) in 4 finestre su 4 e PF in [-0,25 ; +0,10]).
- `InpOrder2Atr` piu' profondo (0,4-0,6), nuovo: nello scan OHLC a O1 0,20 il passaggio O2 0,3 -> 0,5 lascia PF 1,36 -> 1,35, taglia il DD 6,58 -> 4,57 e le operazioni 547 -> 457 (-16%). **Scartato per ora**: costa frequenza, che e' il requisito principale (`CLAUDE.md` r.3-16), e H1 abbassa il DD (-24%) a n invariato. In tick O2 e' stato provato solo 0,2/0,3.
- Time-stop a 24 h (A2 di Gemini): non esiste input (RG A2); **non misurabile** senza ora d'ingresso (M6).
- Ingresso, MinDist/MaxDist, ADR a 0,8: superficie piatta (30/30), niente da guadagnare, rumore da trovare: nessuna griglia.
- DAX/Nasdaq H1 con griglie: vietato (motore senza edge su quei simboli, regola 19/08). SPXUSD, 225JPY: ESCLUSI PER COSTO (7,4x; 4,7-7,2x).
- Forex e oro: altre schede.

### 3.2 Il piano delle misure (solo piano: niente righe, niente file prova)
Bersaglio unico: **finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`**, terminale `C:\Program Files\BCM Markets MT5 Terminal` (demo 50503392 **di quel PC**, non il piccolo del VPS che ha lo stesso numero e una cartella omonima); mai il VPS, mai `C:\FTMO` (`541452707`/`1514806751`), mai `C:\BCM_Reale` (`10105439`). Una riga alla volta (`MATTINA_2026-10-11_COSA_LANCIARE.md` r.3).
| ord. | misura | chiude | firma | passate | macchina |
|---|---|---|---|---:|---|
| **M0** | pacchetto per-trade a banco: cella viva gamba IS con magic vergine (le 132 pos misurate) + H1 (1,2 e 1,4) + H2 (OFF) + canarino ADR; sentinelle dalle righe C136 r136a/d; bootstrap appaiato del Delta PF; peggior giornata e posizioni per variante e per lato/mese | 132 posizioni; banda di rumore vera; letture H3 | nessuna oltre il lancio | ~16 | ~8-10 min |
| **M1** | H4: `COLLAUDO_EMADOW_00` (10) + canarino 01 (4) | spread vero nel tester? | nessuna oltre il lancio | 14 | ~7-10 min |
| **M2** | gemelli H2: D30EUR e NASUSD H1, trailing OFF, IS+OOS | casella 3 dei gemelli | nessuna | 4 | ~1-3 min |
| **M3** | P1 del Dow (orologio dei dati Dukascopy, `RIGA_LANCIA_DUKA_P1.txt`) + P3 (canarino di ritmo + **una** richiesta per le candele Dukascopy, via B) | sblocca ogni misura di regime; la via B puo' portare il crawl da 90-348 h a una frazione | F2 gia' firmata; la lancia Claudio | -- | P1 fino a ~8,5 h; P3 1-2 h |
| **M4** | regime W1-W4: base DK (16 passate + 10 di calibrazione) + varianti pre-dichiarate H1 (8), H2 (4) [+ U3 (8) se firmata] | giudica H1-H2; chiude l'Emendamento C | R-0, F1 (tetto 250 h, 12 GB) + **firma varianti** | 26 + 12 | tester ~40-80 min; **crawl 63-244 h (CORE-A) / 90-348 h (nucleo)** |
| **M5** | lettura a zero macchina: lato x mese x finestra, inverni, bootstrap | H3 | nessuna | 0 | minuti |
| **M6** | export per-trade v2 (`open_time`, MFE, MAE) nel sorgente: solo log, nessun deploy | ora d'ingresso, uscita a tempo, "il parziale scatta subito?" | **si' di Claudio sul sorgente** | 2-4 | sviluppo + cancello |
Ordine: M0 -> M1 -> M2 (stesso terminale, MT5 chiuso, stesso giro di ~25 min) | M3 in parallelo come decisione | M4 dopo M3 e dopo le firme | M5 sempre. **Criteri di stop**: se la sentinella di M0 non riproduce la quarta cifra, la lettura delle varianti e' sospesa ("NON MISURATO"); se K1/K2 di DK falliscono nessun numero DK si legge come regime; il crawl non deve coincidere con altri round. Ogni file prova: `controlla_prova.py` + `controlla_riga.py` + `controllo-preventivo` + lettore indipendente delle correzioni.
**Coda del PC**: R2U (~35 min), lotto notte (6-10 min), pilota NatCla P (`MATTINA_2026-10-11_COSA_LANCIARE.md` r.6-8); P1/M0 non sono nell'elenco di stamattina.

### 3.3 Gemini: dati, non criteri
- **08/10** (primo pacchetto a squadra, `docs/gemini/RISPOSTA_GEMINI_2026-10-08_0852.md`, partito PRIMA del cancello: errore di processo dichiarato, classe 1178). Verificato punto per punto da RG: **numeri di B1/B2 confermati** (set-25 39,53%, PF 1,334 senza; apr-ott 1,927 / nov-mar 1,075); **A1 falso sul nome** (`InpADR_Filter` non esiste; esiste `InpUseAdrFilter` ed e' un filtro di distanza); **A2 falso sul nome e sul costo** (nessun time-stop nel sorgente); **C1** z = 1,691 giusto, binomiale esatto 0,071 e a livello di segnale 0,145; **C3 sbagliato nel verso** (il lineare sovrastima, non sottostima) -> ruolo C non verificato, deroga caduta; D1 gia' fatta da noi (attesa scritta dopo il numero), D3 = il nostro piano di regime con una soglia 0,80 inventata. Esito: nessun criterio cambiato, nessuna proposta eseguita; due idee utili entrate qui: l'ADR come canarino (H4) e la forbice "un mese fuori" come colonna di sensibilita'.
- **Nuovo giro (automatico, `CLAUDE.md` r.609-615): domande pronte, NON INVIATE.** Servono il pacchetto `docs/PER_GEMINI_EMA200_DOW_H1_2026-10-11.md` (non scritto), il cancello sul pacchetto, nessun numero di conto/preset/script, UNA domanda per chiamata, risposta = dati. Proposta (una domanda per chiamata, ruolo B/C):
  - Q1 (avvocato del diavolo): "Per H1 le attese sono: |Delta PF| <= 0,10, DD in [0,70 ; 0,95] e P/DD >= 0,90 in >= 3 finestre su 4; l'altra spiegazione e' 'taglia piu' piccola' con P/DD = 1,00 +-0,10. Dato che in OOS il rapporto e' gia' 1,04, la banda di 0,10 su P/DD e' troppo larga o troppo stretta? Con quale numero la falsifichi?"
  - Q2 (auditor, un conto): "Test del segno su 7 inverni: p a una coda per 6/7 e per 5/7; e dato che i 7 inverni non sono indipendenti (trend condiviso), dimmi quale correzione proponi e con quale n effettivo."
  - Q3 (avvocato): "Il canarino InpMaxSpread: le tre uscite (A/B/C) sono esaustive? Quale quarta lettura manca?"

---

## 4. IL GUARDIAN SULL'EMA200 -- che cosa serve davvero (NIENTE e' eseguito qui)
**La premessa "il binario in campo sul piccolo non legge il Guardian: da portare in campo" e' vera ma NON basta, e oggi non e' il passo giusto.** Fatti (tutti `[MISURATO]`):
- **Il piccolo `50503392` non ha nessun Guardian attaccato** (oggi ancora cosi': C01 r.12-44, 29 sedie, nessuna `Guardian`). E' una decisione di Claudio del **06/09** ("NIENTE Guardian sul piccolo, perche' il DD della flotta si deve vedere NON FRENATO", RUN r.52). Il file `ABTG_Guardian.mq5` li' e' v1.10, 414 righe, `.ex5` del **09/08**, **piu' vecchio dei cap firmati il 18/08** (C06 r.105; RUN r.64-83: "mette in campo una protezione che NON contiene il cap 3,25% ne' la pausa 4,0/4,9").
- **Il binario `ABTG_EMA200` sul piccolo**: 487 righe, versione 1.00, `GUARD=no`, `.ex5` 06/08 (C06 r.97) = commit `344a11b9` (486 + 1). **La sedia non e' attaccata** (dal 24/09).
- **Dove il Guardian c'e'**: `C:\FTMO` (conto `1514806751`; `CLAU12_Guardian` v1.12, 499 righe, C06 r.192/219, attaccato: C01 r.52), 100k `50504263` (v1.11) e reale `10105439` (v1.12). Su FTMO la sedia ha **il binario che legge il Guardian**: `ABTG_EMA200.mq5` e `CLAU12_EMA200.mq5` 553 righe `GUARD=SI` (C06 r.191, 218) = pin `26a18566`.
- **Il sorgente a HEAD** (690 righe) ha l'input a r.42 e la chiamata a r.381. Differenza fra `26a18566` e HEAD: **solo l'imbuto** (contatori e `Print`; ho riletto `git diff 26a18566 origin/lavoro -- mql5/Experts/ABTG_EMA200.mq5`: 154 righe aggiunte, 16 tolte, nessuna riga di logica di trading). Il commit `b45dd009` ("NON COMPILARE") e' stato chiuso dal doppio cancello il 15/09: bersaglio = HEAD, `1.00 · 691` righe attese, discriminante nella scheda Input = presenza di `InpLogImbuto` (RUN r.184-222).
- **Nel tester il Guardian e' fail-open** (EA r.31-41): il banco non simula pausa B1 ne' cap C1. Il cap C1 sul Guardian FTMO era 4,00% al 01/10 (HANDOFF r.17), `InpTotalDDPct` 9,9% (sblocco 08/10): a 2,00% per sedia **la 771531 verrebbe rifiutata dal cap appena altre due sedie sono aperte**: l'effetto sulla frequenza di famiglia e' `[NON MISURATO]` (`dd_portafoglio.py` esiste).
- **Un buco specifico di questa sedia**: tiene posizioni attraverso il reset (`InpUseCutoff=false`): **4 posizioni su 21 attraversano le 23:00 server** (GUARD r.42; 770101: 0 su 36). Il Guardian v1.12 su FTMO non ha `InpDailyBaseline` (arriva con la v1.14, che non e' in campo): la baseline giornaliera e' l'equita', FTMO usa il saldo (GUARD r.37-42). Quale modo per quale conto = firma di Claudio.

**Lista di passi per "Guardian sull'EMA200" -- tutti da NON eseguire senza firma; ognuno passa dal cancello se produce una stringa o un file**
| # | passo | chi decide / esegue | cancello |
|---|---|---|---|
| G0 | **Dove deve operare la 771531 al prossimo giro?** (a) FTMO, conto `1514806751` (trial, scade il 14/10) o la prossima challenge, cartella `C:\FTMO`: il binario legge gia' il Guardian, **non serve nessuna ricompilazione**; (b) piccolo, conto `50503392`, cartella `C:\Program Files\BCM Markets MT5 Terminal` (senza `-V3`); (c) 100k, conto `50504263`, cartella `C:\Program Files\BCM Markets MT5 Terminal -V3` (Guardian v1.11 attivo); (d) nessuno ancora | **Claudio** | -- |
| G1 | Divieto di posizioni opposte fra conti, anche sui demo e sugli indici correlati (FTMO 25/09, `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md`): **la rimozione e' VOLUTA e firmata il 25/09**: "le sedie indice NON vanno riattaccate finche' vale il divieto" (HANDOFF r.68), quindi riattaccare un'EMA200 sul piccolo rovescia una firma. Mia lettura `[INFERITO]` della risposta FTMO: la stessa strategia nello stesso verso su due conti e' permessa (il 22/09 i due conti hanno preso lo stesso segnale), ma le altre sedie FTMO (770202 long US30, 770411 short DAX) possono essere in verso opposto: il rischio non e' solo di questa sedia. Cosa vale oggi lo decide Claudio (e' la domanda n. 3 della pagina di decisione sull'orologio, r.164: "le sedie indice di BCM restano sospese oltre il 25/10?") | **Claudio** | si' (mappa delle sedie indice per conto) |
| G2 | **Solo se (b): PASSO 0 del runbook** -- ramo A (si tiene il 06/09: nessun Guardian sul piccolo) oppure ramo B (si rovescia). Nel ramo A la ricompilazione dell'EA con `InpUsaGuardian=true` **non protegge niente** (fail-open senza Guardian sul terminale, `mql5/Include/ABTG_PausaGuardian.mqh` r.765 (`ABTG_PuoAprire`), RUN r.61) | **Claudio** | -- |
| G3 | **Solo ramo B**: F7 sul Guardian da HEAD v1.14 (899 righe, 19 input) **prima** di ogni altra cosa; verificare 0 errori e data dell'`.ex5`; poi attaccarlo e leggere la riga `filo verificato: 5 GlobalVariable su 5`. Valori del preset del Guardian per il piccolo: **non esistono in nessun preset** (RUN §6) -> Claudio firma `InpAction` (0 CHIUDI+BLOCCA / 1 SOLO ALLARME), `InpCloseAllMagics` (true chiude **tutti** i magic: tutte le sedie del piccolo, 29 grafici nel profilo), `InpStartBalance`, soglie (`mql5/Experts/ABTG_Guardian.mq5` r.129-174). B1/C1 non chiudono: scrivono GlobalVariable | Claudio (firma) + F7 a mano | si' (preset e istruzioni) |
| G4 | F7 di `ABTG_EMA200.mq5` da **HEAD** sul terminale scelto, a mano in MetaEditor; atteso `1.00 · 691 righe`, `.ex5` a data nuova, input `InpLogImbuto` presente. La sera dopo C06 deve dire `GUARD=SI` | **Claudio** (F7 a mano; nessun agente) | si' (stringa con PID + titolo + cartella) |
| G5 | Preset da usare e taglia: VIVA (0,65%, DD OOS 5,09% lineare) / piccolo (1,0%, 7,83%) / FTMO (2,00%, **15,66%: sfonda da sola il 10%**). Con H1 firmata a 1,4: 3,75 / 5,77 / 11,54% `[DERIVATO]`. **Mai attaccare con i default dell'EA** (H4, 1,0, 771501) | **Claudio** (taglia = firma) | si' |
| G6 | Verifica la notte dopo (sola lettura, gia' pianificata): C01 sedia attaccata con magic e rischio giusti; C06 `GUARD=SI` e righe 691; C09 righe del Guardian e `[EMA200-IMBUTO] ... guardian N`; confronto con il tester a parita' (RFWD) | sonde del runner (03:30) | gia' passate |
| G7 | Se la sedia va su FTMO: decidere il modo della baseline giornaliera (equita'/saldo) e se portare il Guardian FTMO a v1.14 (altra F7 e altro preset) | **Claudio** | si' |
Il runner notturno resta di sola lettura e **non puo' fare nessuna di queste cose**; la corsia ROUND resta armata ma scarica (`CLAUDE.md` r.476-537).

---

## 5. COSA SERVE DA CLAUDIO (domande secche) -- e cosa NON e' una decisione sua
1. **P1 + P3 del Dow** (<= ~8,5 h + 1-2 h di PC, nessun download salvo UNA richiesta di prova per le candele, F2 gia' firmata): quando il PC di backtest `DESKTOP-H4D7CAJ` e' libero, **si' o no**? Sblocca ogni misura di regime; se K0 fallisce si risparmiano 90-348 ore. Le righe passano dai cancelli prima di arrivarti.
2. **R-0 + F1** («FIRMO DK DOW REGIME»: tetto 250 ore di PC, 12 GB, CORE-A 63-244 h): dopo l'esito di P1/P3, **si' o no**? W1 sola (20-77 h) non basta per due finestre avverse distinte.
3. **«FIRMO VARIANTI IN REGIME»** (parola proposta, nuova): autorizzi H1 (SLatr 1,2/1,4) e H2 (trailing OFF) come celle **pre-dichiarate** nelle stesse finestre, sola lettura, nessuna promozione? F1 da sola vieta "tarare".
4. **Dove opera la 771531 al prossimo giro** (FTMO conto `1514806751` in `C:\FTMO` / piccolo conto `50503392` in `C:\Program Files\BCM Markets MT5 Terminal` / 100k conto `50504263` in `...\BCM Markets MT5 Terminal -V3` / nessuno)? Cambia tutto il blocco Guardian (G0-G7). La stessa domanda (771531 e 770101 sono sparite dal profilo di `C:\FTMO`: tolte di proposito o no?) e' gia' la n. 2 della pagina di decisione sull'orologio (`DECISIONE_OROLOGIO_INVERNALE_BCM_2026-10-11.md` r.163): **una risposta sola le chiude entrambe**.
5. **Solo se il piccolo**: ramo A o B del PASSO 0 (Guardian sul piccolo si' o no)? E se B: `InpAction` e `InpCloseAllMagics`?
6. **Unita' del pavimento di frequenza**: gambe (0,93-1,0/giorno) o segnali (~0,58)? E' la firma pendente DOS Q1; cambia la lettura di tutte le sedie a due gambe.
7. **Convenzione del costo**: stop pieno mediano (54,9x) o gamba debole (28,7-45,2x)? Decide FRAGILE/PASS e il peso di H1.
8. **M6** (export per-trade v2, solo log, nessun deploy): ok a toccare il sorgente? Sblocca ora d'ingresso e uscita a tempo.
**Cosa NON e' una decisione sua** (la facciamo noi, la leggi tu): quale riga di misura prima (M0-M2 sono a costo quasi zero e partono appena passano i cancelli); se un numero e' rumore (le bande sono scritte prima); la scelta del bersaglio di compilazione (HEAD, per il runbook del 15/09); i difetti dei nostri strumenti; se Gemini ha ragione (e' dato, passa dal cancello). **Resta SUO**: taglia, conto reale, spesa, quale sedia va su quale conto, firma sul sorgente, ogni tocco al campo. **Nessun candidato e' archiviato**: dove una cella non regge il verdetto e' "NON ANCORA MISURATO" con cosa manca.

---

## 6. NON COPERTO (e perche')
- `[NON TROVATO]` esito di P1 (nessun `DUKA_P1_*` in archivio; ultima traccia: nome citato in `3b27d536`, 10/10).
- `[NON TROVATO]` il per-trade IS (132 pos): `cemad02` IS e' un CSV vuoto per scelta `@FRAZIONEIS`; M0a.
- `[NON TROVATO]` i CSV di `COLLAUDO_EMADOW_00`, `_01`, `_06` (spread, canarino, latenza).
- `[NON TROVATO]` i dati dell'Ombra (attaccata dal 07/10, nessuno zip letto).
- `[NON TROVATO]` chi ha tolto la 771531 dal piccolo il 24/09 e perche'; `[NON RICONCILIATO]` con HANDOFF r.68 e la tabella del 25/09.
- `[DA VERIFICARE A VISTA]` il live: le sonde leggono il profilo **salvato**; se il salvataggio dopo l'accensione del 01/10 non e' stato fatto (HANDOFF r.17: "NON confermato"), la 771531 potrebbe essere attaccata alla trial senza comparire. Il ReportHistory del 08/10 non ha colonna del commento: non distingue le sedie.
- `[NON MISURATO]` buy&hold e DD del Dow su una serie vera nelle finestre IS/OOS (qui solo la proxy dei prezzi di uscita); orso, crollo, laterale; effetto del cap C1 sulla frequenza; baseline giornaliera usata dal Guardian FTMO v1.12; come il Dow fu scelto fra i simboli.
- `[NON MISURATO]` slittamento dello stop oltre n=1 (+10,5%); latenza.
- Non rimisurato nulla sul tester: ogni PF/DD viene dai CSV di casa; ho ricalcolato solo derivati.
- Gemini: nulla inviato oggi (sez. 3.3).

## 7. CONTROLLO FATTO PRIMA DI CONSEGNARE (Sviluppatore contro Agente dei Controlli)
- **Numeri**: ogni cella di 1.5-1.6 riletta dal CSV con uno script mio (scratchpad): coincide con M08 e con i file. **Per-trade**: ricostruito con un'implementazione indipendente da M08; coincide su 257/157/100/82, long/short, 13 mesi, PF senza settembre; il bootstrap a blocchi differisce (1,05 / P 1,4% contro 1,06 / 1,1%): riporto il piu' largo.
- **Contro-esempi costruiti**: (1) _"il Dow e' il massimo di ~95 estrazioni"_ -> scan: 26/26 positive e cella al 18o posto; ma l'**oro** ha 26/26 e IS in tick a 0,564: scritto accanto. (2) _"l'orologio non conta"_ -> ho elencato ogni lettura d'ora del sorgente; la prova che l'oscillazione c'e' lo stesso e' il 2,05/0,87 di OR. (3) _"la sedia e' sulla trial"_ -> 25 sonde giornaliere nel periodo 15/09-11/10 (mancano 21-22/09) piu' quelle 07-14/09: giorno esatto di scomparsa su ciascun terminale; limite: profilo salvato, non live. (4) _"H1 e' un vero miglioramento"_ -> la scala pura dice che in OOS a 1,2 e' un lotto piu' piccolo: scritto come altra spiegazione viva. (5) _"i due conti sono due campioni"_ -> i timestamp del 22/09 convertiti con offset +2 h coincidono (aperture 0 e 1 s, stop 0 s).
- **Premesse del compito verificate**: binario piccolo `344a11b9` 486 righe, 0 `InpUsaGuardian` (`git show`, ricontato); `26a18566` 552/2; HEAD 690; il sorgente a HEAD ha il Guardian (EA r.42, r.381).
- **Cancello**: strato 1 = `python3 backtest_pipeline/controlla_riga.py --oggetto md report/MIGLIORA_EMA200_DOW_H1_2026-10-11.md`, esito registrato nel commit; **strato 2 (`controllo-preventivo`) NON invocabile da questo agente: da lanciare dal coordinatore**. Nessuna stringa di lancio e' contenuta in questo file.

## 8. COSA E' ANDATO BENE (un elenco di difetti descrive male la realta')
- Il banco descrive il campo: il 22/09 il tester riproduce le due gambe allo stesso minuto, e ora sappiamo che il demo e FTMO hanno preso lo stesso segnale (stop allo stesso secondo).
- Sette manopole d'uscita gia' ad asse, con altopiani veri e una superficie piatta sugli ingressi (30/30): la sedia non vive di un picco, e nello scan e' l'unico indice con tutte le celle in utile.
- La sedia guadagna agli estremi del toro (set-25, feb-mar-26) con tutti e due i lati; il campione contiene due episodi correttivi e la cella ne ha tratto profitto (short +9.380 in feb-mar-26). La domanda aperta e' quando il long dorme (H3), non se la cella funzioni.
- Le quattro ipotesi costano **nessuna spesa**: i passi a banco (M0-M2) sono ~25 minuti di tester, la regime run ~40-80 minuti di tester piu' il crawl che decide il regime. La strada piu' corta al numero e' P1 + P3: una notte di PC e UNA richiesta.

---
## Appendice A -- Metodo dei miei calcoli (riproducibile)
Input `PT` (518 righe, `;`, colonne `close_time;symbol;magic;position_id;deal_type;volume;price;net_profit`): posizione = `position_id` (257), profitto = somma dei `net_profit`; lato dal `deal_type` dell'uscita (1 = chiude un long); segnale = id consecutivi, stesso lato, ultima chiusura entro 3 giorni, al massimo 2 gambe (157); mese = mese di chiusura. Bootstrap a blocchi: 13 blocchi mensili, ricampionati con reinserimento, 5000, seme 7. Test del segno a una coda: somma di C(7,k)/128, k = 6..7 = 8/128 = 0,0625; k = 5..7 = 29/128 = 0,227. Binomiale: P(X <= 10 | 23, 0,607) = 0,0713; P(X <= 7 | 14, 0,669) = 0,145. Scan H1: per ciascuno dei 48 CSV, celle con `AllowLong=AllowShort=1` e `Trades >= 100`. Proxy del prezzo: mediana/min/max dei `price` di uscita per mese. Forward: 23 righe `;771531;` di `TA`, segnale = etichetta `...1` + `...2` stessa direzione entro 6 h. Rapporti di costo = numeratore / spread dichiarati in 1.4. Nessuno script e' stato aggiunto al repo: se serve la riproduzione si scrive come strumento e passa dai due strati.

## Appendice B -- Fonti lette
`CLAUDE.md` · `report/PRIORITA_EA_E_DA_FARE_2026-10-08.md` · `M08` · `RG` · `docs/gemini/RISPOSTA_GEMINI_2026-10-08_0852.md` · `G2` §1.1 · `PORTA` · `DUE` · `GEM` · `DK` §0-3 · `GUARD` §0-1 · `RUN` §1-2 · `OR` §5.1 · `COLLAUDO_EMA200_DOW_CRITERI.md` · `C00` · `LATI_A1_FINESTRA_DENTRO_L_IS` · `LETTURA_BACKLOG_NOTTE_2026-09-13` · `SOSPENSIONE_SEDIE_DEMO_2026-09-25` · `DECISIONE_EMA200_RESTA_SUL_DEMO_2026-09-18` · `PRIMO_STOP_FTMO_2026-09-22` · `FTMO_SBLOCCO_GUARDIAN_ESEGUITO_2026-10-08` · `MATTINA_2026-10-11_COSA_LANCIARE` · `docs/RISPOSTA_SUPPORTO_FTMO_2026-09-25.md` · CSV `C136` (r136a-d, r146b, r147a, cemad05, r29b), `EG2`, `PT`, scan `EMA200/H1_OHLC/` · `TA` · `C01` (15/09-11/10), `C06` 11/10 · `EA` r.1-690, `VIVA`, `Presets/FTMO/ABTG_EMA200_771531_FTMO.set`, `ABTG_Guardian.mq5` r.100-175 · `git show 344a11b9 / 26a18566` e `git diff 26a18566 origin/lavoro`.
