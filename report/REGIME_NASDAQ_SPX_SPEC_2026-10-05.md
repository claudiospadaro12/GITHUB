# Prova di regime sulle sedie con Nasdaq e S&P 500: SPECIFICA (05/10/2026)

Autore: `cercatore-parametri`. Perimetro: **SOLA SPECIFICA, sola lettura del repo** (branch `lavoro`, HEAD alla partenza `c9c5ca5a`). Nessun backtest, nessuna riga di lancio, nessun file prova, nessun terminale, preset, EA, taglia, forward o conto toccato. Il solo calcolo eseguito e' su file gia' in repo (serie giornaliere dell'anatomia aperture) e su file HistData dello specchio pubblico `FutureSharks/financial-data` (S&P 2010-2018, stessa fonte dell'`SPXUSD_EXT`), descritto in §4 e §12.
Mandato: Claudio, 05/10/2026, *"PARTI CON GLI ALTRI INDICI IN BACKGROUND. VISTO CHE CI SIAMO FACCIAMO TUTTO ALLA PERFEZIONE"*, dopo *"LA MAIL PER EMILIANO E' PRESTO: poco storico: prima i test per ampliare lo storico e BACKTESTARE GLI EA CON + STORICO"*. Motivo: la tabella "quanti anni sono stati davvero misurati" del dossier (`report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md`) dice 10 NO / 2 PARZIALE / 0 SI.
Dove girerebbe: **solo il PC di backtest `DESKTOP-H4D7CAJ`**, terminale `C:\Program Files\BCM Markets MT5 Terminal` (conto demo `50503392` di QUEL PC), dove vivono i simboli `_EXT` (`LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` §1.0). **Mai il VPS** (firma 21/09). Il terminale `C:\FTMO` (trial `1514806751`), `50503392` del VPS, `50504263`, `10105439` e `50504400` non vengono toccati.
Etichette: [MISURATO] letto da un file con il percorso; [DERIVATO] calcolo su numeri misurati; [INFERITO] ragionamento mio, dichiarato; [NON MISURATO] il dato non c'e'.
Stato del cancello: **`controllo-preventivo` 05/10: FAIL corretto in loco** (quattro correzioni marcate "[corretto dal cancello 05/10]": meccanismo del filtro volumi su M5 e ramo di fallimento di P0c; residuo di banco del dossier; stop della RETEST = range + buffer; rischio 0,65% e tetto classe 1102 della `770250`). Serve una **passata indipendente** sulle correzioni prima che il file vada a Claudio. Nessun file prova esiste ancora: ognuno passera' dai due cancelli.
**Passata indipendente 05/10 (secondo `controllo-preventivo`): FAIL corretto in loco**, marcato "[passata indipendente 05/10]": (a) il "residuo di banco" del dossier era in realta' un **taglio IS/OOS diverso** (30/06/2025 contro 09/06/2025); (b) **W1 e' MISTO alla lettera** (CROLLO 26,4% in 2,6 mesi dentro l'ORSO); (c) bande numeriche di P0c e premessa sul volume `nsxusd`; (d) deposito e unita' del tetto 1102 della `770250`; (e) rinvio all'armonizzazione delle regole di etichettatura con DAX e Dow.
**Terza lettura 05/10 (`controllo-preventivo`): PASS con un'aggiunta di forma**: ricontati dai CSV i numeri toccati (1,14498/1,10936 su 91/94; 1,11621/1,14894 su 82/102; 185/184; taglio 09/06/2025 da 642 giorni x 0,40; -26,4% su 3 mesi mobili 30/03-17/06/2022) e le righe citate (r.2520, r.2530, r.2577, `RIGA_SHORTGATE.ps1` r.120, `walkforward_aperture.ps1` r.131-132, `walkforward_generico.ps1` r.934); aggiunta in §4.1 la tabella **"stessi dati, etichette diverse"** con le tre regole affiancate (emerso: con la regola D-K del DAX **W2 2020 diventa MISTO**), senza scegliere la precedenza.

---

## 0. In dodici righe

1. **Sedie con Nasdaq o S&P: quattro "in perimetro", una sola viva.** Viva: `770260` (Nasdaq RETEST due lati, Free Trial FTMO `1514806751` a 2,00%). Ferme dal 25/09 (sospensione firmata, divieto FTMO di posizioni opposte fra conti): `770250` (gated short NASUSD M15) e `970913` (SupRev NAS H1). `771514` (EMA200 H4 SPXUSD, solo long) e' un preset di forward mai operato (0 posizioni dal 01/08) e non risulta attaccata. Fuori perimetro con motivo: `770201`, `770203`, `770601`, `774690` (§1).
2. **Su `NASUSD_EXT` e' gia' girata una sola sedia con criteri congelati prima: SupRev H1 (R113, 18 celle, esito "non conclusiva").** Le altre corse EXT sul Nasdaq (SHORTGATE, FASE2, INVES, 29-30/08) hanno fatto la lettura per regime DOPO aver visto il numero e armato alle 09:30 (§3.3). **Nessuna cella di apertura RETEST e' mai girata su EXT** e **nessuna cella e' mai girata su `SPXUSD_EXT`** (§2).
3. **Il filtro volumi della `770260` non gira su EXT, e la mappa del 03/10 §7 sbaglia il modo.** L'import scrive `tick_volume = (v>0 ? v : 1)` (`ABTG_ImportaStoricoEsterno.mq5` r.325) e il feed HistData ha volume 0 in 822.911 righe su 822.911 [MISURATO su S&P 2013/2016/2018]. La mappa sbaglia il meccanismo (`avg <= 0 -> return true` non scatta mai: il volume minimo e' 1). Ma **attenzione [correzione del cancello 05/10]**: la cella gira su **M5** e `VolumeOK()` legge la barra del grafico (r.2530, chiamata in `MonitorRetest` r.1544/1578): il volume di una barra M5 e' la **somma** delle M1 (= numero di minuti presenti, <= 5 nello storico; nel tester a Modello 1 puo' essere il conteggio dei tick generati: `[NON MISURATO]`). Il filtro passa quindi solo se l'ultima barra M5 **chiusa** prima del tick di rottura ha >= 1,5 volte il "conteggio" medio delle 20 precedenti, cioe' **quando le barre prima hanno buchi** (minuti mancanti; i minuti piatti contano solo se il tester conta i tick generati) [precisato dalla passata indipendente 05/10: `CopyTickVolume(_Symbol,tf,1,n+1)` r.2520 legge da shift 1, quindi `v[0]` e' la barra PRECEDENTE a quella in cui il prezzo tocca il livello, non "la barra di rottura"; con 5 minuti pieni il volume massimo e' 5 e la media deve scendere a <= 3,33 perche' passi]: attesa **n ~ 0 (pochi giorni, bande in §7.1 P0c)**, NON identita'. Premessa `[INFERITO]`: il volume 0 e' misurato sull'S&P, **non** su `nsxusd` (§3, riga "volume"): se il CSV Nasdaq portasse volumi > 0 l'import li scriverebbe (r.325) e il filtro leggerebbe quelli. Si conta la colonna volume del CSV Nasdaq al passo P0a, **prima** di P0c. **In nessuno dei due esiti il filtro misura il volume**: e' un contatore di buchi del feed. Attesa dichiarata, falsificabile da una passata (§7).
4. **Quindi la sedia viva non si misura su EXT: si misura la sua gemella SENZA filtro volumi.** E' un'altra cella: a tick (BCM, 1%, ClosePct 0) fa IS 0,814 / OOS 1,041, mentre la viva fa 1,221 / 1,215. La prova di regime dice come si comporta lo scheletro, **non** se il filtro volumi regge. Per quello serve un feed con volumi (Dukascopy tick, §6.1 strada B, 62-244 ore di PC acceso, firma nuova).
5. **Orologio: due convenzioni in conflitto nel repo, e una e' quasi certamente sbagliata.** HistData e' ora di New York CON ora legale (canarino mensile verde nell'anatomia; la specifica "EST fisso" e' smentita) e l'import ha aggiunto +5 ore fisse (prima barra 23:01 contro 18:01 del CSV, ultima 21:13 contro 16:13). Quindi su `NASUSD_EXT` **14:30 = apertura cash tutto l'anno**. SHORTGATE, FASE2 e INVES (29-30/08) hanno invece armato alle **09:30** "perche' il feed e' in ora di New York" = 04:30 a New York se lo shift e' applicato (§3.3). Va letto prima di fidarsi dei loro verdetti.
6. **Costo: la cella e' scritta in punti indice e l'indice vale 13 volte meno nel 2011.** Stop/spread a 1,80 idx (mediana, range 35' misurato): 2011-12 **7,5x**, 2013-14 **8,6x**, 2015-16 **13,5x**, 2018 **23,7x**, 2020 **44,6x**, 2021 **46,6x**, 2022 **77,8x**. Con la regola `stop >= 40 x spread` il **nucleo e' di tre finestre 2020-2022**; il laterale 2015-16 e' escluso PER COSTO col numero (§4.3).
7. **Etichette misurate (non a memoria).** Nasdaq: ORSO 2022 (-30,7%, DD -36,6%), CROLLO 2020.02-04 (DD -27,6% in un mese), TORO 2021 (+26,9%, DD -9,2%), **2019 e' TORO (+40,2%) e non "laterale"**, LATERALE_NAS 2015.01-2016.06 confermato (+2,6%). S&P 2018 e' ORSO (-6,8%) mentre il Nasdaq 2018 e' LATERALE (-1,5%): le etichette non si ereditano fra simboli (§4.1).
8. **Il fattore OHLC -> tick "1,7-1,85" e' del DAX, non del Nasdaq.** Misurato in casa: DAX Live5m 1,72 e 1,85; **Nasdaq Live5m 2,25**; Dow H4 3,51; per la cella a limite RETEST **[NON MISURATO]**. Regola: **le barre possono solo BOCCIARE, mai promuovere** (§5).
9. **S&P 500: non si lancia niente adesso, per tre ostacoli indipendenti.** `SPXUSD_EXT` e' ancora in frigo (rapporto 0,203 contro 0,20); l'unica sedia S&P (`771514`) sta sotto la frontiera del costo anche a BCM oggi (~13-39x, centrale ~25x [DERIVATO], spread 1,40 istantanea del 17/08); il suo campione e' 27-40 posizioni/anno, quindi il merito per regime e' non misurabile (§6.4).
10. **Costo in tempo di tester: nucleo `770260` 34 passate = ~8-20 minuti; tutta la rosa nucleo (`770260` + `770250` + SupRev) 63 passate = ~14-36 minuti.** Il costo vero e' di orologio e di firme, non di CPU (§8). La strada con i volumi veri e' 62-244 ore di PC acceso.
11. **Firme nuove: una necessaria, tre opzionali** (§9). Gia' firmato e sufficiente: D-A, D-B (NASUSD,SPXUSD,D30EUR), D-C (solo prova di regime), D-D, D-H, "FIRMO FRIGO NASUSD", la regola del 21/09 (round sul PC di backtest).
12. **Se la prova passa la riga "anni/dati" del dossier passa da NO a PARZIALE, mai a SI** (3 finestre 2020-22 = 34 mesi di barre + 21 mesi di tick). Solo con la traslazione di scala delle finestre 2011-2018 (firma F-B) si arriverebbe a ~11 anni, ma sarebbero barre di una cella traslata (§10).

---

## 1. Che cosa esiste: le sedie e il loro stato

Fonti: `FLOTTA_ATTIVA.md`, `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`, `report/APERTURE_NASDAQ_MAPPA_2026-10-03.md`, `report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`, `HANDOFF.md` (blocchi 29/09 e 01/10), `mql5/Presets/`.

| sedia | EA, simbolo, TF | stato in campo | simboli del feed | in questa specifica |
|---|---|---|---|---|
| **`770260`** | `ABTG_Nasdaq_Apertura_US`, RETEST due lati, M5 | **VIVA**: Free Trial FTMO `1514806751` (`chart03`), 2,00% (`NFP_2026-10-02_SEDIE_TRIAL.md`, `TRIAL_14_GIORNI_CRITERI_2026-10-01.md`); la challenge `541452707` e' chiusa dal 30/09 | BCM `NASUSD` / FTMO `US100.cash` | **SI, priorita' 1** (§6.1) |
| **`770250`** | stesso EA, BREAKDOWN short gated (EMA 50x200 H4), M15, 0,35% | **FERMA** dal 25/09 (era sul piccolo `50503392`, grafico NASUSD M15 tolto dal profilo ORO) | `NASUSD` | SI, priorita' 2: rilettura con orologio verificato (§6.2) |
| **`970913`** (forward `770925`) | `ABTG_SupRev_NAS_H1_Ottimizzato`, NASUSD H1, L+S | **FERMA** dal 25/09 (tolta con le altre 15) | `NASUSD` | SI, priorita' 3: solo la coda A5 di R113 (§6.3) |
| **`771514`** | `ABTG_EMA200` H4 SPXUSD, solo long (preset `ABTG_EMA200_FW_SPXUSD_H4.set`) | **MAI OPERATA**: 0 posizioni dal 01/08 contro ~20 attese per i 5 gemelli H4 (`REGISTRO_TEST.md` r.2635); HANDOFF 29/09: "25 forex/oro, nessuna sugli indici". [DA CONFERMARE a Claudio: e' ancora attaccata sul `50503392`?] | `SPXUSD` | SI, ma **bloccata** da tre ostacoli (§6.4) |
| `770201` | stesso EA, BREAKOUT L+S | spenta il 18/08; config viva 1,241 / 0,859 (n 165 / 316) | `NASUSD` | NO: sedia spenta con numeri propri (`APERTURE_NASDAQ_MAPPA` §2.2) |
| `770203` | `ABTG_Nasdaq_Live5m` | "NON ANCORA MISURATO" (27/27 celle negative a tick; stop minimo 13,33x) | `NASUSD` | NO: costo al pavimento duro |
| `770601` | `ABTG_ORB` Nasdaq | spenta dal 10/08; OOS 1,050 con DD ~38,8% a 2% | `NASUSD` | NO |
| `774690` | `ABTG_Relativo` NASUSD | demo osservativo del 07/09 | `NASUSD` | NO: gamba DAX bocciata per rischio, nessun numero da regime richiesto ora |

Nota: `US500.cash` e `SPXUSD` compaiono nei preset FTMO solo come `InpCorrSymbol`, con `InpUseCorrelation=false`: **non sono simboli negoziati** (classe 444, `R185_SONDA_SPXUSD_CRITERI.md` §1a).

### 1.1 Le celle congelate, esatte

**`770260`** (cella viva = `R199B` Pass 2, copiata nei file `prove/R274a..d` con 97 input verificati a macchina contro la riga del CSV; preset di campo `mql5/Presets/FTMO/ABTG_Nasdaq_Apertura_US_RETEST_770260_FTMO.set`). Ore in ORA SERVER BCM (la rimappatura FTMO e' +2):
`InpEntryMode=2` (RETEST) · `InpRangeMode=0`, `InpRangeMinutes=35` · `InpSessionHour=14`, `InpSessionMin=30` · `InpCloseHour=17`, `InpCloseMin=30`, `InpCloseAtEnd=true` · `InpBufferPoints=200` · `InpRetestOffsetPts=0` · `InpUseVolumeFilter=true`, `InpVolMult=1,5`, `InpVolAvgBars=20` · `InpTP1_R=0,5`, `InpTP1_ClosePct=50`, `InpBreakevenAtTP1=true` · `InpUseTrailing=true`, `InpTrailMode=1`, `InpTrailTF=5` · `InpMinStopPts=500` · `InpMinRangePts=0` · `InpOneTradePerDay=true` · `InpAllowLong=true`, `InpAllowShort=true` · rischio 2,00% (preset FTMO; R199B: deposito 80.000).
Contratto misurato (R199B Pass 2, tick, 2,00%, 80.000): **IS PF 1,221 / 82 posizioni (135 uscite) / DD 7,3069%; OOS PF 1,215 / 102 posizioni (172 uscite) / DD 7,8576%** [MISURATO, `risultati_prove/R199B/*_R199B.csv`; posizioni da `APERTURE_NASDAQ_MAPPA` §2.1]. Merito **sospeso** (102 < 150).
**Rilievo per il dossier (B1 e §B2.4):** le due misure Nasdaq "non riconciliate" (1,14 / 1,11 su 91 / 94 contro 1,22 / 1,22 su 82 / 102) sono **due celle diverse E due banchi** [corretto dal cancello 05/10, ricontato dai CSV]: la prima e' `Walkforward_Aperture/NASDAQ_B_motore_{IS,OOS}.csv` Pass 8 (1,14498 / 1,10936, DD 5,9528 / 3,6753, Trades 91 / 94; preset BCM del 20/09 `ABTG_Nasdaq_Apertura_US_RETEST_770260.set`: `InpTP1_ClosePct=0`, `InpBreakevenAtTP1=false`, 1% su 10.000, binario `2ce7abce`); la seconda e' la cella accesa al 50% con BE (commit `496408a9`, "ACCENDILA AL 50%") sul binario `28c18463`. La differenza GROSSA (1,14 contro 1,22) e' la cella. **[Corretto dalla passata indipendente 05/10: il "residuo di banco" era un TAGLIO DIVERSO, non un binario.]** R199B Pass 0 (ClosePct 0; input in comune diversi dal Pass 8: rischio 2 contro 1, `InpBreakevenAtTP1` inerte a ClosePct 0, magic; piu' **20 input che il binario `2ce7abce` non ha**, tutti spenti o a zero salvo `InpUsaGuardian=1`) fa **1,116 / 1,149 su 82 / 102** contro **1,145 / 1,109 su 91 / 94**. Ma le finestre NON sono le stesse: `walkforward_aperture.ps1` r.131-132 taglia IS **2024.09.26 -> 2025.06.30** / OOS 2025.07.01 -> 2026.06.30; R199B usa `walkforward_generico.ps1` r.934 con FrazioneIS 0,40 su 2024.09.26 -> 2026.06.30 (642 giorni) = IS **-> 2025.06.09** / OOS 2025.06.10 -> (come la riga "IS contratto BCM" di §4.1). Le ~3 settimane spostate da IS a OOS spiegano il -9 / +8: sul totale **185 contro 184 posizioni** [DERIVATO]. Quindi: a cella uguale il residuo di binario e' **<= 1 posizione su 21 mesi**; i PF per finestra **non sono confrontabili** (finestre diverse) e il DD del Pass 8 viene da un binario **precedente al fix di sizing `3af47ed9`** (`NASDAQ_RETEST_VOLUMI_LA_SEDIA_2026-09-18.md` §5: PF e n reggono, DD e profitto no). Il dossier va corretto in "due celle e due tagli IS/OOS diversi; a cella e finestra uguali il PF non e' stato ricontato" (per riconciliarlo al centesimo serve il per-trade del Pass 8 sulle stesse date: `[NON MISURATO]`).

**`770250`**: `InpEntryMode=0` (BREAKOUT) · `InpAllowLong=false`, `InpAllowShort=true` · `InpUseEmaFilter=true`, EMA 50 x 200, `InpFilterTF=H4` · `InpRangeMinutes=15` · sessione 14:30, flat 20:45 · `InpBufferPoints=300` · `InpTP1_R=1,0`, `ClosePct 50` · trailing PREVBAR M5 · `InpMinStopPts=500` · `InpUseVolumeFilter=false` · rischio 0,35% (`mql5/presets/ABTG_GatedShort_NASUSD_770250_LIVE.set`). Contratto: tick 2024.09-2026.06 PF 1,097 / n 104 / DD 4,54% a 0,65%; OHLC EXT 2020-2024 PF 1,84 / n 93 (`REFERTO_SHORTGATE_2026-08-30.md`).

**`970913`**: `InpStMult=3,0`, `InpStAtrPeriod=10`, `InpTP_RR=3,0`, `InpTP1Pct=50`, `InpUsePending=true`, L+S, rischio 1% (`prove/R110_SUPNAS_00_metro.txt`). Contratto: `valid_SupRevRT_NASUSD_H1.csv` Pass 6, PF 1,57491, 155 uscite, DD 1,1706%, **griglia di 8 passate su una sola finestra senza split** (`CENSIMENTO_CONTRATTI_v2.md` r.316).

**`771514`**: `InpTF=H4`, EMA 200, `InpAllowLong=true`, `InpAllowShort=false`, `InpOrder1Atr=0,10`, `InpOrder2Atr=0,35` (**interpolazione, non una cella dell'asse d'archivio**, `REGISTRO_TEST.md` r.2842), `InpSLatr=1,0`, `InpTP_RR=2,5`, `InpTP1Pct=50`, BE e trailing accesi, rischio 1% (`mql5/Presets/ABTG_EMA200_FW_SPXUSD_H4.set`). Archivio: 31/31 celle long in utile, PF mediana 1,5914, DD 1,96-3,79%, 138-200 uscite (69-99 posizioni) su 30 mesi nominali (`REGISTRO_TEST.md` r.2625-2632).

---

## 2. Che cosa e' gia' stato fatto su `NASUSD_EXT` e `SPXUSD_EXT`, e che cosa NO

| corsa | simbolo EXT, TF, finestra | motore | criteri congelati prima? | esito | dentro questa specifica |
|---|---|---|---|---|---|
| **R113** (27/08) | NASUSD_EXT H1, 6 finestre (TORO 2021, ORSO 2022.01-10, CROLLO 2020.02-04, CROLLO_ANNO, LATERALE_NAS 2015.01-2016.06, VECCHIA 2011-12), 18 celle, 5,4 min | SupRev H1 (`970913`, 3 celle: metro, long, short) | **SI** (firmato "FIRMO R113") | **NON CONCLUSIVA**: orso 2022 short n=0, 2020-22 quasi muto (n 5-8 uscite), LATERALE rosso con n pieno (metro 0,664 su 55); DD massimo 1,81%; **coda A5 mai fatta** | §6.3 |
| SHORTGATE (30/08) | NASUSD_EXT M15 2020.01-2024.01, una tranche | `770250` BREAKOUT short gated | **NO**: per-regime letto dopo | PF 1,84 n 93 DD 2,07%; orso 2022 +4.020 su 49 trade; **ora 9:30** | §6.2 |
| FASE2 DRIVE / CASSA, INVES (29-30/08) | NASUSD_EXT M15 2017.01-2020.07 | drive-following BREAKOUT; inversione da esaurimento | in parte (contratto FASE 2 firmato 29/08) | baseline drive PF 1,32 su 832; **ora 9:30** | solo come rilievo (§3.3) |
| CRT Turtle Soup, Chaos Lyapunov (31/08) | NASUSD_EXT M15 2020-2024 | motori diversi | si | bocciati | NO |
| Anatomia aperture (26/08) | NASUSD_EXT M1, 2010-2020 / cassaforte 2021-2026 | nessun EA: statistica del primo movimento | si | giorni sospetti 2023: **22,9%** | fonte delle etichette (§4.1) |
| **qualunque cella di apertura RETEST su EXT** | | | | **MAI GIRATA** | **§6.1, il buco principale** |
| **qualunque cella su `SPXUSD_EXT`** | | | | **MAI GIRATA** (frigo 0,203; `R185` §1b: "EXT puo' servire alla prova di regime, mai al duello") | §6.4 |

Perche' R113 non basta: gira un solo motore, a H1, con stop a candela (28,7x, escluso per costo a BCM), e non dice se il feed e' innocente: la misura che separa "feed" da "epoca" (stesse celle sulla sovrapposizione 2024.09.26-2026.06.30, confrontare solo `n`) e' scritta in `R113_REFERTO.md` ("Scoperta n.1") e in `LO_STORICO_ESTERNO_MAPPA_2026-09-23.md` come **A5**, con la clausola "va fatta PRIMA di qualunque altra corsa `_EXT`". **Non risulta eseguita** (nessun file `prove/` ne' CSV in `risultati_archivio/`).

---

## 3. I dati e l'orologio

### 3.1 Cosa e' stato misurato sul feed

| voce | valore | fonte |
|---|---|---|
| `NASUSD_EXT` | 5.233.590 barre M1, 2010.11.14 23:01 -> 2026.07.31 21:13, 0 scartate; copertura H1 97,0%; diff media H1 0,0756% (0,0662% fuori finestre DST); rapporto diff/vol **0,199 contro 0,20** | `STORICO_INDICI_20260826_2334/ABTG_ImportEsterno_referto.csv`; `LETTURA_MISURE_LAMPO_2026-08-26.md` |
| `SPXUSD_EXT` | 4.598.932 barre M1, stesse date; diff media 0,0608% (0,0527% fuori DST); rapporto **0,203** | idem |
| ammissione | **solo `NASUSD_EXT`**, alla prova di regime a parametri congelati, mai promozione: "FIRMO FRIGO NASUSD" (26/08). `SPXUSD_EXT` e `225JPY_EXT` **restano in frigo**; "si riesaminano solo con una misura nuova" | `PROVA_REGIME_CRITERI.md` §2; `LETTURA_MISURE_LAMPO` §3 |
| 2023 | il Nasdaq 2023 ha 47 giorni sospetti e ~52 feriali senza apertura (104 giorni senza apertura meno ~52 domeniche) su ~257: **22,9%** | `LETTURA_ANATOMIA_APERTURE_2026-08-26.md` §1; ricontato dal CSV per-giorno |
| volume | colonna volume = **0 in 822.911 righe su 822.911** (S&P 2013/2016/2018); per `nsxusd` [INFERITO dallo stesso fornitore e formato; le prime e le ultime righe dell'anteprima `NASUSD_M1_ANTEPRIMA.txt` mostrano 0] | calcolo di sessione su `DAT_ASCII_SPXUSD_M1_{2013,2016,2018}.csv` |
| proprieta' del simbolo | digits, point, tick size/value, contract size **copiati dal nativo** (0 proprieta' guaste); `spread = 0` per barra | `ABTG_ImportaStoricoEsterno.mq5` r.191-210, r.326 |
| nota `REGISTRO_TEST.md` r.71-72 | scrive ancora `NASUSD_EXT` "IN FRIGO": **e' una riga rimasta indietro** rispetto alla firma del 26/08 (la tabella r.60-80 e' del 23/09). Prevale la firma | |

### 3.2 Orologio: HistData, il simbolo importato, BCM, FTMO

1. **HistData e' ora locale di New York CON ora legale**, non "EST fisso": canarino mensile verde (pausa 16:14 in tutti i 12 mesi, eccetto marzo), e la cosa vale anche per gli 8 forex (`LETTURA_ANATOMIA_APERTURE` §0; `REFERTO_IMPORT_6_SIMBOLI.md` §2). Controprova di sessione: sul CSV grezzo S&P il range medio al minuto passa da 0,026-0,035% alle 09:29 a **0,066-0,082% alle 09:30** (2013, 2016, 2018), contro 0,016-0,026% alle 04:30 [MISURATO].
2. **Lo shift importato e' +5 ore FISSE** (`ShiftOre +5`, import v1; la "cura DST" v2 peggiorava la diff del 7,7-8,6%, `STORICO_INDICI_CRITERI.md` §0). Prova indipendente: prima barra del CSV `2010.11.14 18:01`, del simbolo `23:01`; ultima barra del CSV `2026.07.31 16:13`, del simbolo `21:13` [MISURATO, `CENSIMENTO_FONTE.txt` e `ABTG_ImportEsterno_referto.csv`].
3. **Conseguenza [DERIVATO]: sul simbolo `NASUSD_EXT` le 14:30 sono SEMPRE le 09:30 di New York** (feed NY locale + 5 fisso), anche nelle settimane in cui Stati Uniti ed Europa cambiano ora in date diverse. La frase "tranne ~20 feriali l'anno" (`APERTURE_NASDAQ_MAPPA` §5, `OROLOGIO_BCM` §5.1.4) vale per un import DST-aware, che **non e' quello in terminale**.

| orologio | 09:30 New York (cash) cade a | note |
|---|---|---|
| `NASUSD_EXT` (NY + 5 fisso) | **14:30 tutto l'anno** | la cella con `InpSessionHour=14:30` arma alla cash ogni giorno |
| BCM nativo, UTC+1 fisso (indici dal 2024.09.26) | 14:30 con gli USA in ora legale (2a dom. marzo - 1a dom. novembre); **15:30 d'inverno** | d'inverno `InpSessionHour=14:30` arma alle 8:30 New York, un'ora prima: 90 giorni su 183 in IS (49,2%) e 90 su 276 in OOS (32,6%) (`APERTURE_NASDAQ_MAPPA` §5) |
| FTMO (calendario europeo, +2/+3) | 16:30 FTMO tutto l'anno tranne ~20 feriali di sfasamento | la rimappatura +2 vale d'estate; d'inverno FTMO = BCM + 1 (`OROLOGIO_BCM` §5.3) |

**Cosa si misura quindi su EXT con la cella BCM (14:30, flat 17:30):** la cella ARMATA ALLA CASH tutto l'anno = **quello che la sedia FTMO fara' d'inverno** (alla cash) e anche d'estate. **Non** riproduce ne' l'inverno BCM nativo (8:30 NY, misurato da R274, non girato) ne' la settimana 26-30/10/2026. L'etichetta in ogni tabella: *"armata alla cash USA tutto l'anno, feed NY + 5 fisso, barre M1 HistData"*.

### 3.3 RILIEVO: SHORTGATE, FASE2 e INVES hanno armato a `InpSessionHour=9`, `InpSessionMin=30` su EXT

I file prova `SHORTGATE_NAS_BREAKDOWN.txt` r.62-69 e r.93-94, `FASE2_NAS_00_baseline.txt` r.31-37 e r.101-102, `INVES_NAS_00_baseline.txt` r.41-42 e r.112-113 scrivono: *"su NASUSD_EXT l'anatomia ha MISURATO che le 09:30 del file sono l'apertura cash tutto l'anno (feed a ora di NEW YORK) ... Se l'import MT5 avesse shiftato i timestamp a ora server, questo 9 va riportato PRIMA di girare"*. L'anatomia misurava il **CSV grezzo** (ora New York); il simbolo in MT5 ha **+5 ore** (§3.2, due referti). Se cosi' e', quelle corse hanno armato alle **04:30 di New York** (pre-mercato): PF 1,84 di SHORTGATE, "orso 2022 +4.020 su 49", FASE2 baseline PF 1,32 su 832, sarebbero numeri di un'ora sbagliata. **Non e' provato**: nessun per-trade di quelle corse (767120, 767200) e' in repo [NON MISURATO]. Il controllo costa **zero tester**: l'ora di ingresso nei per-trade `abtg_trades_*_767120.csv` e `..._767200.csv` (sul PC, `Common\Files`) e il profilo orario del range medio al minuto del simbolo (§7, K-clock). **Va chiuso prima di leggere qualunque numero EXT del Nasdaq, vecchio o nuovo.** R113 non e' toccato (motore a barre H1 senza ora d'ingresso).

---

## 4. Le finestre

### 4.1 Etichette MISURATE

Metodo [MISURATO in sessione, riproducibile al passo P0a]: serie giornaliera del prezzo **all'apertura 09:30 New York**, dal CSV per-giorno dell'anatomia (`ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`, 4.877 righe, giorni `OK`) per il Nasdaq; per l'S&P, dal primo minuto >= 09:30 di ogni giorno nei file HistData `SPXUSD` 2010-2018 (stessa fonte di `SPXUSD_EXT`). Rendimento = ultimo/primo - 1; DD = massimo scostamento dal picco **sulla serie delle aperture** (**sottostima il DD infragiornaliero**: il DD sulle chiusure H1 sara' >= a questo e si rimisura in P0a). Sanita': livelli di fine anno e rendimenti annui coerenti con i valori di mercato noti [FONTE ESTERNA, solo per controllo].

Regola di etichettatura, **scritta prima dei numeri di cella** (stessa del piano Dow del 05/10, §1.3; soglie da firmare in F-A): TORO se rendimento >= +10% **e** DD < 15%; ORSO se rendimento <= -5% **e** DD >= 15%; CROLLO se DD >= 25% in <= 3 mesi; LATERALE se |rendimento| <= 5%. Nessuna regola o due regole = **MISTO** (la finestra non entra nella classe AVVERSE senza nuova firma). **Un caso limite emerso misurando:** `CROLLO 2020.02-04` fa scattare insieme CROLLO (DD 27,6% in un mese) e LATERALE (rendimento -0,1%, e' una V): alla lettera sarebbe MISTO. Si propone, **prima di ogni numero di cella**, la **precedenza CROLLO > LATERALE** (il rendimento non cancella un DD >= 25% in <= 3 mesi), da firmare in F-A; la finestra e' comunque la finestra di shock congelata il 14/08 e serve solo al rischio. Se l'etichetta misurata differisce dall'attesa, la finestra si **rinomina**, non si scarta.
**[Passata indipendente 05/10] Le regole di etichettatura in circolazione sono TRE** (Dow `D-I`, questa `F-A` con la precedenza CROLLO > LATERALE, DAX `D-K` con CROLLO su <= 4 mesi esclusivo: `REGIME_DAX_SPEC_2026-10-05.md` §3.1) e **si armonizzano in una sola prima della prima firma**. Non e' cosmetico: con la regola scritta qui **W1 e' MISTO** (tabella sotto), quindi senza una precedenza firmata il nucleo avverso si riduce al solo 2020 (W2, piu' W2r solo se si firma CROLLO > LATERALE; con la regola del DAX resterebbero invece W1 e W2r, e W2 diventerebbe MISTO: tabella qui sotto) e la regola dei due banchi (`PROVA_REGIME_CRITERI` §4D) non ha la sua seconda finestra. Numerazione: se F-A..F-D diventano righe `@DECISIONE` in `STORICO_INDICI_CRITERI.md`, prendono lettere **dopo D-L** (D-I Dow, D-J..D-L DAX gia' proposte).

**[Terza lettura 05/10] Stessi dati, etichette diverse.** Le tre regole affiancate, poi applicate agli **stessi numeri** gia' scritti nelle specifiche (nessun numero nuovo di prezzo; ricontati W1, W2, W2r, W3 Nasdaq dal CSV dell'anatomia). Questo documento **non sceglie**: la precedenza e la regola unica sono una **firma di Claudio**, da dare prima della prima fra D-I, D-K, F-A.

| regola | fonte | prezzo | struttura | TORO | ORSO | CROLLO | LATERALE | due regole / nessuna |
|---|---|---|---|---|---|---|---|---|
| **D-I** (Dow) | `PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` §1.3 | chiusure H1 DK | non esclusiva | r >= +10% e DD < 15% | r <= -5% e DD >= 15% | DD >= 25% in <= 3 mesi | \|r\| <= 5% | MISTO |
| **F-A** (Nasdaq/S&P) | questo §4.1 | aperture 09:30 NY (DD sottostimato) | non esclusiva + precedenza **proposta** CROLLO > LATERALE | come D-I | come D-I | come D-I | come D-I | MISTO, salvo CROLLO+LATERALE = CROLLO (se firmata) |
| **D-K** (DAX) | `REGIME_DAX_SPEC_2026-10-05.md` §3.1 | chiusure H1 | **esclusiva per durata**: >= 9 mesi TORO/ORSO/LATERALE; <= 4 mesi solo CROLLO (DD >= 25%); 4-9 mesi MISTO | solo >= 9 mesi | solo >= 9 mesi | solo <= 4 mesi | solo >= 9 mesi | MISTO |

| finestra | durata | rend. / DD max / DD max su 3 mesi mobili | D-I | F-A | D-K |
|---|---|---|---|---|---|
| **W1 Nasdaq** 2022.01-10 | 10 mesi | -30,7% / 36,6% / **26,4%** (30/03 -> 17/06) | ORSO+CROLLO = **MISTO** | **MISTO** (la precedenza proposta non copre ORSO+CROLLO) | **ORSO** |
| **W2 Nasdaq** 2020 anno | 12 mesi | +46,0% / 27,6% / 27,6% (20/02 -> 23/03) | **CROLLO** | **CROLLO** | **MISTO** (finestra lunga: niente CROLLO; non TORO perche' DD >= 15%) |
| **W2r Nasdaq** 2020.02-04 | 3 mesi | -0,1% / 27,6% / 27,6% | CROLLO+LATERALE = **MISTO** | **CROLLO** (solo se firmata) | **CROLLO** |
| W3 Nasdaq 2021 | 12 mesi | +26,9% / 9,2% / <= 9,2% | TORO | TORO | TORO |
| **W1 DAX** 2011.05-2012.04 | 12 mesi | -10,6% / 34,3% / **33,6%** (Q3 2011, 2,2 mesi; DAX §3.1-3.2) | ORSO+CROLLO = **MISTO** | **MISTO** | **ORSO** |
| **Dow** W1-W3 (stesse date del Nasdaq) | | `[NON MISURATO]`: lo storico DK su disco copre solo 2024.10-2025.06 (piano Dow §1.4); l'etichetta la da' P0 del piano Dow | - | - | - |

Lettura (solo conteggio, non una scelta): **nessuna delle tre regole tiene in classe tutte e tre le finestre avverse del Nasdaq** (W1, W2, W2r): D-I ne tiene una (W2), F-A due (W2, W2r), D-K due (W1, W2r). Fuori dal nucleo la differenza tocca anche le due sotto-finestre corte di §4.1 (2011-07-15 -> 10-04 e 2018-09-20 -> 12-31: ORSO per D-I/F-A, MISTO per D-K perche' DD < 25%). Per il DAX, le finestre W2/W3 non hanno qui il DD su 3 mesi mobili (classe 1124): `[NON MISURATO]` in questa tabella.

| finestra | giorni | Nasdaq: rend. / DD (periodo del DD) | S&P: rend. / DD | etichetta Nasdaq | etichetta S&P |
|---|---:|---|---|---|---|
| VECCHIA 2011-01 -> 2012-12 | 508 | +16,0% / -15,2% (2011-07-26 -> 08-19) | +10,3% / -21,1% (2011-05-02 -> 10-04) | **MISTO** (DD 15,2 sopra il 15) | MISTO |
| sotto-finestra 2011-07-15 -> 10-04 | 58 | -12,5% / -15,2% | -17,8% / -19,6% | ORSO (DD **sul bordo** del 15%) | ORSO |
| TORO 2013-14 | 498 | +57,6% / -9,9% | +43,5% / -9,1% | **TORO** | TORO |
| LATERALE_NAS 2015.01 -> 2016.06 | 377 | **+2,6%** / -17,4% | +0,3% / -14,6% | **LATERALE** (R113 F4 adattamento confermato) | LATERALE |
| 2017 | 251 | +31,8% / -4,9% | +19,6% / -3,0% | TORO | TORO |
| 2018 | 257 | **-1,5%** / -22,7% | **-6,8%** / -19,6% | **LATERALE** | **ORSO** |
| 2018-09-20 -> 12-31 | 71 | -15,9% / -22,7% | -14,4% / -19,6% | ORSO | ORSO |
| 2019 | 258 | **+40,2%** / -10,1% | `[NON MISURATO]` | **TORO, non "laterale"** | n.d. |
| CROLLO 2020.02.01 -> 04.30 | 63 | -0,1% / **-27,6%** (2020-02-20 -> 03-23) | n.d. | **CROLLO + LATERALE = MISTO alla lettera** (V: finisce dove e' partito); **CROLLO** con la precedenza proposta | n.d. |
| CROLLO_ANNO 2020 | 258 | +46,0% / -27,6% | n.d. | **CROLLO** (unica regola che scatta) | n.d. |
| TORO 2021 | 256 | +26,9% / -9,2% | n.d. | **TORO** | n.d. |
| ORSO 2022.01.01 -> 10.31 | 215 | **-30,7%** / **-36,6%** (2022-01-04 -> 10-13) | n.d. | **ORSO + CROLLO = MISTO alla lettera** [corretto dalla passata indipendente 05/10: il DD massimo e' in nove mesi, ma DENTRO la finestra le aperture 09:30 fanno **-26,4% in 2,6 mesi** (2022-03-30 -> 06-17, `ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`), e la regola CROLLO chiede "DD >= 25% in <= 3 mesi", non "il DD della finestra"]. Entra nelle AVVERSE solo con una precedenza **firmata** (ORSO > CROLLO a rendimento <= -5%?), da decidere nell'armonizzazione delle tre regole (sotto) | n.d. |
| 2023 | 158 validi | +53,2% / -9,7% | n.d. | **ESCLUSO**: feed malato (22,9% giorni sospetti) | n.d. |
| IS contratto BCM 2024.09.26 -> 2025.06.09 | 178 | +7,3% / **-24,3%** (2025-02-18 -> 04-07) | n.d. | **MISTO** (DD 24,3 < 25: nessuna regola) | n.d. |
| OOS contratto BCM 2025.06.10 -> 2026.06.30 | 267 | +36,5% / -11,3% | n.d. | TORO | n.d. |

Tre fatti che le etichette misurate dicono:
- **Il 2019 e' un anno di rialzo pieno sul Nasdaq** (+40,2%, DD -10,1%): la macchina di casa lo chiama LATERALE perche' nata sul forex. Il "laterale" del Nasdaq e' il 2015-16 (R113 lo aveva gia' sostituito, ora e' misurato).
- **L'IS del contratto della `770260` contiene la discesa feb-apr 2025 (-24,3% dal picco) ma NON e' una finestra ORSO per la regola**: e' MISTO. "Il contratto e' misurato in un regime solo, il toro" va quindi detto "un toro con una correzione del 24%".
- **Lo S&P non eredita le etichette del Nasdaq**: 2018 e' LATERALE per l'uno e ORSO per l'altro; correlazione dei rendimenti giornalieri open-to-open 2011-2018 = 0,915 su 2.016 giorni [MISURATO], alta ma non identita'. Per l'S&P 2019-2026 le etichette sono **[NON MISURATE]** (i CSV stanno sul PC di backtest): passo P0a.

### 4.2 Le finestre della prova, per ruolo (congelate PRIMA dei numeri di cella)

Regola A dell'emendamento: l'unita' e' l'operazione (>= 150 posizioni per il merito), il regime si dichiara; regola B: **il vecchio giudica il rischio, il recente il merito**; regola C: la prova di regime batte la storia contigua; regola D: non ci si sposta nell'altro fosso.

| sigla | periodo | etichetta | ruolo | classe |
|---|---|---|---|---|
| **W1 ORSO** | 2022.01.01 -> 2022.10.31 | ORSO **solo con precedenza firmata** (alla lettera MISTO: CROLLO 26,4% in 2,6 mesi, §4.1) | rischio + merito L+S (al bordo dei 150) | **nucleo** |
| **W2 CROLLO_ANNO** | 2020.01.01 -> 2020.12.31 | CROLLO (con D-I/F-A; **MISTO** con la regola D-K del DAX, §4.1 tabella delle tre regole) | merito (l'anno) | **nucleo** |
| **W2r CROLLO** | 2020.02.01 -> 2020.04.30 | CROLLO (con la precedenza CROLLO > LATERALE, §4.1) | **solo rischio** (valvola E.3: a qualunque n) | **nucleo** |
| **W3 TORO** | 2021.01.01 -> 2021.12.31 | TORO | riferimento sullo stesso feed | **nucleo** |
| W4 LATERALE | 2015.01.01 -> 2016.06.30 | LATERALE | rischio + merito | estensione (F-B) |
| W5 2018 | 2018.01.01 -> 2018.12.31 | LATERALE (NAS) / ORSO (SPX) | rischio | estensione (F-B) |
| W6 TORO LUNGO | 2013.01.01 -> 2014.12.31 | TORO | rischio | estensione (F-B) |
| W7 VECCHIA | 2011.01.01 -> 2012.12.31 | MISTO | **solo rischio** (regola B) | estensione (F-B) |
| C1, C2 calibrazione | 2025.06.10 -> 2025.10.24; 2026.03.30 -> 2026.06.30 | TORO (da misurare) | **solo feed** (n e trade-match), **mai regime** | gate |

**Perche' C1 e C2 cosi'**: sono finestre nelle quali **sia gli USA sia l'Europa sono in ora legale** (USA 2025-03-09 -> 11-02, Europa 2025-03-30 -> 10-26; 2026: USA dal 03-08, Europa dal 03-29), quindi sul nativo BCM le 14:30 sono la cash come su EXT [DERIVATO da `OROLOGIO_BCM` §5.1 e dal calendario]; stanno **dentro l'OOS** del contratto. Si evitano cosi' i giorni sfasati d'inverno, nei quali nativo ed EXT armerebbero a ore diverse per costruzione.

**Classe 1102 (finestra che non cade dentro un IS gia' misurato di quella cella):** nessuna finestra W1-W7 si sovrappone al contratto BCM (2024.09.26 -> 2026.06.30; scarto >= 23 mesi dalla piu' recente, W1); `770260` non e' mai girata su EXT; per **`770250`** invece W1, W2, W2r, W3 sono **gia' state lette** (SHORTGATE, 2020-2024): per quella cella sono **RILETTURE**, non fuori campione, e vanno etichettate cosi' in ogni tabella. C1 e C2 stanno dentro il contratto: servono solo al feed (non si legge DD ne' PF come regime). Cassaforte dell'anatomia (2021-2026 "sigillata per le ipotesi"): qui non si genera nessuna ipotesi, la cella e' congelata.

**Il tetto delle ~100.000 barre del tester** (regola 25/08): il referto R199B stampa `MaxBars=100000000` sul PC di backtest, ma **non e' provato** che una corsa M5 su EXT parta senza troncare [NON MISURATO]; nessuna finestra del nucleo supera i 12 mesi (M5 ~70.000 barre/anno), quindi e' in regola comunque.

### 4.3 La frontiera del costo `stop >= 40 x spread`, finestra per finestra (MISURATA)

Il TF del grafico NON entra nello stop dei meccanismi a range (stop = range, calcolato su M1): `APERTURE_NASDAQ_MAPPA` §4. Quello che entra e' **l'ampiezza del range in punti indice, che cambia di un ordine di grandezza nel tempo**, mentre le uniche quantita' in punti della cella (`InpBufferPoints=200`, `InpMinStopPts=500`, spread) restano ferme. Ampiezza mediana del range dei primi 35' / 15' dal CSV `ANATOMIA_MOVIMENTI_M5_PERGIORNO_NASUSD.csv` [MISURATO su HistData, giorni `OK`], contro lo **spread BCM mediano 1,80 idx** (P95 2,70; `spread_flotta/spread_orario_NASUSD.csv`, ora 14):

| finestra | prezzo mediano | range 35' mediano (x spread 1,80) | p10 35' | range 15' mediano (x) | MinStop 5 idx = % del range 35' | esito per la `770260` (stop = range 35') |
|---|---:|---|---|---|---:|---|
| VECCHIA 2011-12 | 2.395 | 13,5 idx (**7,5x**) | 8,2 (4,6x) | 9,8 (5,4x) | 37% | **ESCLUSA PER COSTO** (sotto il duro 13,3x) |
| TORO 2013-14 | 3.502 | 15,5 (**8,6x**) | 8,8 | 10,8 (6,0x) | 32% | **ESCLUSA PER COSTO** |
| LATERALE 2015-16 | 4.410 | 24,3 (**13,5x**) | 14,2 (7,9x) | 17,0 (9,4x) | 21% | **ESCLUSA PER COSTO** (13,5x e' un soffio sopra il duro 13,3x, lontano dal 40x) |
| 2018 | 6.966 | 42,6 (**23,7x**) | 24,0 (13,3x) | 31,1 (17,3x) | 12% | ESCLUSA PER COSTO (sotto il 40x) |
| CROLLO 2020 (anno) | 10.185 | 80,3 (**44,6x**) | 42,8 (23,8x) | 55,3 (30,7x) | 6,2% | **AMMESSA** (sopra il 40x al mediano, al bordo al p10) |
| TORO 2021 | 14.535 | 83,8 (**46,6x**) | 50,2 (27,9x) | 60,1 (33,4x) | 6,0% | **AMMESSA** |
| ORSO 2022.01-10 | 12.841 | 140,1 (**77,8x**) | 88,3 (49,1x) | 99,3 (55,2x) | 3,6% | **AMMESSA** |
| IS BCM (riferimento) | 20.842 | 130,7 (72,6x) | 69,7 (38,7x) | 90,9 (50,5x) | 3,8% | riferimento |
| OOS BCM (riferimento) | 24.965 | 145,0 (80,5x) | 78,9 (43,8x) | 98,4 (54,7x) | 3,4% | riferimento |

Regola di ammissione al nucleo (**[NUOVO, F-A]**): range 35' mediano **>= 40x** lo spread; fra 13,3x e 40x = "sotto il pavimento di lavoro, sopra il duro" (ammessa solo come estensione con riserva); sotto 13,3x = sotto il duro. Lettura: con la cella in punti e lo spread di oggi, **il nucleo e' 2020-2022**. Il **laterale** (2015-16) e **tutto il Nasdaq prima del 2020** sono fuori costo col numero accanto, **non** "perche' i TF bassi vanno evitati". Per la **`770250`** (range 15') i numeri sono piu' stretti: 2020 **30,7x**, 2021 **33,4x** (sotto il 40x), 2022 55,2x. Nota [corretta dal cancello 05/10, letta nel codice]: per la RETEST lo stop NON e' una frazione del range. `MonitorRetest` (r.1531-1548): ingresso LIMIT su `gRangeHigh` (o `gRangeLow`), SL su `sellTrig = gRangeLow - gBuffer` con `InpSLMode=0` (preset FTMO r.293): **stop = range 35' + buffer 2 idx >= range**. La colonna "x" e' quindi un **limite INFERIORE** del rapporto stop/spread, e lo "stop stimato 83,2" di `APERTURE_NASDAQ_MAPPA` §4 (che darebbe 2020-21 a 32-34x) **contraddice il codice**: va riletto la', non usato qui. Riserva che resta: lo spread 1,80 e' la mediana dell'ora server 14 intera (14:00-14:59, pre-cash compresa), non del minuto di ingresso; al P95 2,70 il 2020 scende a ~30x e il 2021 a ~32x: **una bocciatura in W2/W3 si scrive col costo relativo accanto** (in W2/W3 lo spread pesa ~1,6x piu' che nel contratto BCM, 44,6-46,6x contro 72,6-80,5x).

**Che cosa recupera le finestre vecchie (F-B, da firmare):** la **traslazione di scala dei soli input in punti** (buffer, MinStop, trailing fisso, slippage e spread) col rapporto fra prezzo mediano della finestra e prezzo mediano del contratto BCM (22.900 circa; es. 2015-16: x0,19). Non e' taratura (nessun valore e' scelto sui dati) ma **cambia la cella**, e lo spread scalato e' un'ipotesi benigna (nel 2012 il costo vero in punti era ben piu' alto di 0,25 idx). Si fa solo come estensione, con riserva scritta, mai come evidenza di costo.

---

## 5. Il bias barre contro tick, e come si usa

**Il numero della casa, corretto.** La richiesta cita "1,7-1,85 per il Nasdaq". I conti in casa (`LO_STORICO_ESTERNO_MAPPA` §2.0, `APERTURE_NASDAQ_MAPPA` §7, dossier §D):

| motore | PF OHLC / PF tick | fattore | simbolo |
|---|---|---:|---|
| `DAX_Live5m` v1 / v2 | 1,47 / 0,857; 1,71 / 0,925 | **1,72 / 1,85** | **DAX** |
| `Nasdaq_Live5m` (`770203`) | 2,16249 / 0,96265 | **2,25** | **Nasdaq** |
| `SupRev_DOW_H4` | 2,77 / 0,79 | **3,51** | Dow |
| `Nasdaq` drive-following a tick (FASE 2 CASSA) | OHLC ~1,32-1,37 (2017-2020) / tick 1,083 (2024-26) | non e' un fattore: **finestre diverse** | Nasdaq |
| **cella RETEST a limite (`770260`)** | `[NON MISURATO]` | | |

Il fattore **non e' uno**, e per la cella a ordini limite e filtro volumi non e' mai stato misurato. Lo si misura al passo P1 (§8): **stessa cella (senza volumi), stesse date, nativo BCM a Modello 1 contro Modello 4** (isola il modello), e nativo Modello 1 contro EXT Modello 1 (isola il feed).

**La regola d'uso, scritta ora e vale per ogni numero di questa prova:**
1. **Le barre possono solo BOCCIARE.** Nei casi misurati l'OHLC e' piu' ottimista del tick sul PF (1,72-3,51x) e **piu' basso sul DD** (DD 6,48% a barre contro 7,21% / 7,83% a tick, finestre diverse quindi **indicativo**: R103 / R29b / R112, `CONTRATTI_DELLE_SEDIE_FTMO` §3.1). Quindi un PF a barre sotto 0,90, o un DD a barre sopra la soglia di rischio, vale a maggior ragione a tick; **un PF a barre sopra 0,90 o un DD sotto soglia NON conferma niente**.
2. **Nessuna soglia viene ammorbidita** e nessuna viene "corretta" dividendo per un fattore: i numeri si leggono come **limite inferiore del DD e limite superiore del PF**.
3. **Nessun EFFETTO e' promosso da barre.** Un esito favorevole si scrive "NON BOCCIATA a barre: e' un candidato per la misura a tick, non un verdetto".
4. **Confronti solo dentro lo stesso feed** (D-C punto 4): periodo calante contro periodo crescente su EXT, mai "EXT 2022 contro BCM 2025". L'eccezione e' **solo** la calibrazione del conteggio `n` (non e' merito: `LO_STORICO` §5.2 caso A5).
5. Spread: **fisso, dichiarato, canarino obbligatorio** (checklist 89: su un simbolo custom il parametro del banco copiato dal gemello puo' voler dire un'altra cosa). Il driver ha `-Spread N` (`walkforward_generico.ps1` r.202-214, r.955-973); a `Spread=-1` non scrive la riga e MT5 usa quello in memoria: **si passa `-Spread 180`** (1,80 idx = mediana BCM) e si controlla con un secondo spread assurdo (P0d). Lo stress a 270 (P95) solo su W1 e W2.

---

## 6. Le schede per sedia

### 6.1 `770260`, Nasdaq RETEST due lati (priorita' 1)

**(1) Cella e motore.** Come §1.1, con tre deltas **dichiarati** rispetto al file `R274a` (97 input): `@SIMBOLO NASUSD_EXT`; date di finestra; magic vergine. Piu' il delta di sostanza della gemella: **`InpUseVolumeFilter` true -> false** (e `InpUseAtrFilter` resta false). **Non e' la sedia.** E' "la cella viva senza filtro volumi" (da qui "X0"), e la firma F-A la autorizza esplicitamente (un delta non e' taratura, ma cambia la cella). Ore: `InpSessionHour=14`, `InpSessionMin=30`, `InpCloseHour=17`, `InpCloseMin=30` (ore del simbolo EXT = cash tutto l'anno, §3.2). Banco: 80.000, rischio 2,00% (la taglia di campo, per confrontare con 7,3069 / 7,8576), Modello 1 (OHLC su M1), `-Spread 180`.

**(2) Finestre.** W1, W2, W2r, W3 (nucleo); estensione W4-W7 con firma F-B; calibrazione C1, C2. Etichette e costo in §4.

**(3) Giudizio con la regola A-D.** n >= 150 posizioni per il merito; il DD si legge a qualunque n; barre = limite inferiore del DD. **Il vecchio giudica il rischio**: W7/W6/W5 (se firmate) solo R1-R2; **il recente il merito**: nel nucleo il merito si legge solo nelle finestre con >= 150 posizioni (§7.2) e solo come "regge fuori dal toro", mai come PF promesso. Il merito della **sedia** (con volumi) resta **sospeso** (102 < 150 in BCM) e NON cambia con questa prova.

**(4) Bias.** §5. Il fattore per questa cella e' misurato al passo P1b.

**(5) Orologio.** §3.2: la cella e' armata alla cash tutto l'anno. Etichetta: *"X0, armata alla cash, EXT NY+5, OHLC, spread fisso 1,80, senza volumi"*. Prerequisito: P0b (§3.3).

**(6) Due lati.** In ogni finestra: L+S, solo long, solo short (`InpAllowLong/Short` come asse). La L+S compare in **tutti e due** i file della finestra (file 1 = {L+S, long}, file 2 = {L+S, short}), e vale da cancello di determinismo G1 gratuito (stessa tolleranza di R274: Trades e DD esatti, Profit entro 1 EUR). Dalla serie `NASDAQ_M` (retest, 1%): il solo long ha ~0,71 e ~0,65 delle posizioni della L+S, il solo short ~0,65 [DERIVATO da 156/220, 142/220, 196/301, 197/301]; i due lati **si ribaltano a specchio fra IS e OOS** (long 0,963 -> 1,130; short 1,165 -> 0,823; R107 short 3,220 -> 0,460): impronta di regime, non di edge per lato (`APERTURE_NASDAQ_MAPPA` §2.4).

**(7) Attese, controesempi, parole di verdetto: §7.** **Via piu' corta al numero:**

- **Strada A (EXT, barre, vol OFF): ~34 passate, 8-20 minuti di tester** (§8). Risponde a: frequenza e rischio dello scheletro per regime, segno dei due lati, se il feed e' innocente. **Non** risponde al filtro volumi.
- **Strada B (feed con volumi veri: Dukascopy `USATECHIDXUSD`, tick):** e' l'unica che misura la sedia vera nei regimi. Costo: **62-244 ore di PC acceso** per il nucleo (914 giorni, 2019.12.01 -> 2022.10.31, a 4,1-16,0 min/giorno: ritmo e intervallo da `PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md` §3.4, classe 1103: tempo / ore-file scaricate, non giorni) piu' ~0,2-1 ora di tester a tick [DERIVATO]. **Non si propone adesso**: dipende dall'esito del cancello DK del Dow (F2 firmata il 05/10, P0-P1), dal fatto che il volume-tick di Dukascopy somigli a quello BCM (filtro relativo 1,5 x media di 20 barre: indipendente dalla scala ma **non** dalla distribuzione; si misura con una calibrazione tipo K1 del piano Dow) e da una firma nuova (F-D). `[NON MISURATO]` se i tick Dukascopy dell'indice portano un volume utilizzabile.
- **Strada A' (sostituto ATR del filtro volumi, calibrato sul nativo):** il filtro `InpUseAtrFilter` (ATR dell'ultima barra >= mult x media a 20 barre) e' il parente piu' vicino disponibile in prezzo. Si puo' misurare la sua **fedelta'** al filtro volumi sul nativo BCM tick (le due celle sulla stessa finestra, trade-match >= 70% con controllo nullo a +1 giorno, come K1 del piano Dow): 4 passate native. **Solo se la fedelta' passa** il sostituto entrerebbe in una gemella X1 su EXT. E' una cella nuova (mai misurata a tick con questo scopo): firma F-A2 separata, opzionale; **non si fa se non c'e' fedelta'**.

### 6.2 `770250`, gated short (priorita' 2: rilettura con l'orologio giusto)

**(1) Cella.** §1.1, simbolo `NASUSD_EXT`, M15, sessione **14:30** (non 9:30), rischio **0,65%** [corretto dal cancello 05/10: SHORTGATE e' girata a 0,65%, `SHORTGATE_NAS_BREAKDOWN.txt` r.135 e `REFERTO_SHORTGATE` r.7, non all'1%: per confrontare il DD con SHORTGATE e col contratto il rischio dev'essere lo stesso], Modello 1, `-Spread 180`.
**Classe 1102 (tetto gia' misurato):** la replica a `InpSessionHour=9` su W1 (punto 7) e' una SOTTOFINESTRA di SHORTGATE (2020.01-2024.01, stessa cella, stesso modello, 0,65%, **deposito 100.000** come SHORTGATE: `righe/RIGA_SHORTGATE.ps1` r.120 [aggiunto dalla passata indipendente 05/10: il tetto regge per sottosequenza solo a rischio % sullo stesso deposito, altrimenti cambia l'arrotondamento del lotto]): il suo DD ha come TETTO **2,07%** e le sue **uscite <= 49** (le 49 righe "ORSO 2022" sono deal di uscita del per-trade, `ABTG_Nasdaq_Apertura_US.mq5` r.2577, con ClosePct 50: le posizioni sono ancora meno). Superarli e' un segnale di banco o di confine (o di simbolo re-importato), non un verdetto: e' un cancello di riproduzione gratuito, da scrivere nel file prova PRIMA della corsa. Di NUOVO la replica porta solo il confronto con la cella 14:30.
**(2-3) Finestre e giudizio.** W1, W2, W2r, W3, **etichettate RILETTURA** (la cella e' gia' girata su 2020-2024). Costo del range 15': 2020 **30,7x**, 2021 **33,4x** (sotto il 40x), 2022 55,2x (§4.3): due finestre su tre sono **al bordo**, si leggono con riserva scritta. 2023 escluso (feed malato) anche se la corsa di agosto lo conteneva. n atteso: SHORTGATE ha dato 93 trade in 4 anni (~23/anno) con 49 nel solo 2022 [MISURATO]: **nessuna finestra del nucleo arriva a 150** -> merito **sospeso ovunque**, il rischio si legge.
**(6) Due lati.** Il contratto e' short-only: la regola dei due lati chiede la **gemella gated L+S** (`InpAllowLong=true`, stesso filtro EMA: la direzione la sceglie il trend) in ogni finestra, piu' il solo short come sedia. Passate: 2 celle (short, L+S) x L+S duplicata come G1 = 4 per finestra.
**(7) La misura che vale di piu' e' di orologio, non di regime:** la cella a `InpSessionHour=9` (come girata il 30/08) contro `14` sulla stessa finestra (W1): 4 passate (due ore x gemelle sul magic). Attesa scritta ora: con shift +5 applicato (§3.2), le entrate della cella 14:30 cadono fra 14:35 e ~16:30 dell'orologio del simbolo (cash); quelle della 9:30 fra 09:45 e ~11:45 (pre-mercato, 04:45-06:45 a New York); n e PF **diversi** fra le due. Se invece n e PF fossero **uguali al centesimo** il parametro e' inerte (o il pin non e' arrivato: si apre il `.ini`), e la domanda sull'ora si chiude per un'altra strada. Il verdetto "SHORTGATE su EXT e' del pre-mercato" si scrive **solo** se (a) il profilo orario del simbolo mostra lo scatto a 14:30 e non a 09:30 e (b) le ore d'ingresso del per-trade 767120 stanno nel pre-mercato.
**Costo:** 4 + 16 = **20 passate**, M15 OHLC a 13,5-33 s = **4,5-11 minuti**. **Firma:** nessuna oltre F-A (e' una rilettura a criteri nuovi).
**Perche' e' sospesa la sedia:** firma del 25/09 (divieto FTMO di posizioni opposte fra conti anche su demo e su indici correlati). Nessuna decisione di campo dipende da questa misura.

### 6.3 `970913` / `770925`, SupRev NAS H1 (priorita' 3: chiudere la coda A5)

**(1) Cella.** `prove/R110_SUPNAS_00_metro` e le gemelle long e short, parametri congelati come R113 (copia riga per riga dell'antenato, delta ammessi: simbolo, date, magic).
**(2) Finestre.** Gia' fatte: le sei di R113. **Resta una sola misura: A5**, la sovrapposizione 2024.09.26 -> 2026.06.30 (tre celle), e confrontare `n` con R110 (nativo tick: metro 96 uscite, long 62, short 34 [MISURATO, `R110_REFERTO.md`]).
**(4-5) Bias e orologio.** Il motore e' a barre H1 e senza ora d'ingresso: l'orologio e' inerte (R113). **Miglioramento rispetto alla proposta del 23/09:** si aggiunge la corsa **nativa a Modello 1** (stesse tre celle): il confronto EXT-M1 contro nativo-M1 isola il **feed**; il solo EXT-M1 contro nativo-M4 (come scritto in `LO_STORICO` A5) confonde feed e modello. Passate: 3 celle x (EXT con gemella 2 + nativo-M1 1) = **9 passate, ~2 minuti** (R113: 36 passate in 5,4 min = 9 s/passata).
**Verdetto della calibrazione (parole congelate, §7.3):** NULLO se rapporto `n` EXT / nativo-M1 in [0,85; 1,15] su tutte e tre le celle; EFFETTO se fuori [0,70; 1,30] su almeno una; ZONA GRIGIA fra le due. Se NULLO: le finestre R113 2020-22 con 5-8 uscite sono **epoca** (il motore era quasi muto), e **la frequenza promessa del forward non e' una proprieta' del motore**; se EFFETTO: ogni lettura delle finestre EXT di R113 porta la riserva "feed".
**Perche' la priorita' e' bassa:** a BCM lo stop a candela H1 e' **28,7x** (sotto il 40x; `CANCELLO_COSTO_FLOTTA` r.660, `CENSIMENTO_CONTRATTI_v2` r.316) e il contratto e' una griglia di 8 passate su una sola finestra: anche un esito favorevole non porterebbe a una sedia. **Firma:** nessuna oltre F-A.

### 6.4 `771514`, EMA200 H4 SPXUSD (S&P 500): BLOCCATA, e perche'

Tre ostacoli, **indipendenti** (ne basta uno):

1. **Frigo.** `SPXUSD_EXT` ha rapporto 0,203 contro 0,20: sopra di 0,003, cioe' **1,5% della soglia**; `NASUSD_EXT` sta sotto di 0,001 (0,5%). Fra i due c'e' il 2% di una soglia, "meno del rumore di qualunque rimisura" (`LO_STORICO` §3.3): **e' un confine, non una differenza di qualita' dei dati**. La soglia e' valida perche' scritta prima: **non si abbassa e non si arrotonda**. La via e' una **misura nuova pre-dichiarata**, firma F-C: ricalcolare il rapporto con la volatilita' oraria sulla **stessa finestra di sovrapposizione 2024.09-2026.07 su cui e' misurata la diff** (oggi la volatilita' e' del solo 2025 e la diff di 22 mesi: finestre diverse). **Simmetrica sui tre simboli**, scritta prima dei numeri; se SPX scende sotto 0,20 solo cambiando finestra e non con la finestra 2025, **si scrive cosi'** ("passa con la finestra X, non con la Y") e la decisione resta a Claudio. Attesa dichiarata: e' una misura che puo' far salire o scendere anche il Nasdaq (che e' al bordo opposto); se il Nasdaq uscisse sopra 0,20 con la finestra nuova, **si dice**, perche' sarebbe il caso che la firma del 26/08 poggia su un bordo.
2. **Costo.** Spread `SPXUSD` BCM: **1,40 idx, una sola istantanea** (sonda 17/08, `215D85D7_ABTG_InfoBroker.csv`); la distribuzione e' **[NON MISURATA]** (`spread_flotta/` ha solo D30EUR, NASUSD, U30USD). Stop = 1 ATR(H4): sui dati HistData 2011-2018 l'**ampiezza media della barra H4** dell'S&P e' 5,7-14,2 idx, cioe' **4,1x-10,1x** lo spread 1,40 [MISURATO sul CSV grezzo, orologio EXT]; per il 2024-26 l'ATR(H4) dell'S&P a BCM e' **[NON MISURATO]**: il rapporto ampiezza H4/prezzo del 2011-18 sta fra 0,24% e 0,70% (mediana degli anni 0,45%), applicato a ~7.690 (ultima barra dell'anteprima del 31/08/2026: 7.685,9) da' 18-54 idx, cioe' **13x-39x (centrale ~25x)**: **sotto il 40x in tutti i casi** (il caso con ampiezza maggiore, 0,70%, sta a 38,5x, di un soffio; quello con ampiezza minima, 0,24%, a 12,9x, appena sotto il duro 13,3x) [DERIVATO]. La sedia sta gia' sotto la frontiera **oggi, prima di ogni prova di regime**; coerente con la voce "S&P escluso per costo" del dossier (§B2.6).
3. **Campione.** 69-99 posizioni in 30 mesi nominali = **0,11-0,16 posizioni/giorno** [`REGISTRO_TEST.md` r.2625-2638]: **27-40 posizioni/anno**. Nessuna finestra di regime del nucleo arriva a 150; per i 150 servirebbero 4-5 anni accorpati. Il **merito per regime e' non misurabile**; il rischio si' (a qualunque n), ma con un'unica corsa lunga si hanno 430-630 posizioni solo sommando 16 anni, senza separare i regimi.

Inoltre: **lato corto mai misurato su SPX H4** (la riga lato per lato dell'archivio e' solo LONG, 31/31 celle); il TF H4 su EXT dipende dall'allineamento delle barre (EXT = NY+5 fisso contro BCM UTC+1 fisso): **non misurabile su un solo import** [dichiarato, nessuna prova possibile].

**Verdetto di stato:** `771514` = **"NON ANCORA MISURATO"**, non morta (certificato del 09/09: mancano il lato corto, il TF cambiato, l'uscita ad asse, e il PF per regime). **Via piu' corta al numero**, se Claudio la vuole: (i) P0a su SPX 2019-2026 (zero tester); (ii) misura dello spread SPXUSD sui tick nativi (il logger della flotta non lo copre: [NON MISURATO], zero tester, uno script nuovo); (iii) F-C; (iv) poi 4 finestre x 4 passate (long, short, L+S, gemella) + una corsa lunga L / S / L+S con gemella = **20 passate** H4 OHLC (barre H4 ~24.000 in 16 anni: nessun tetto), **4,5-11 minuti**. Fino a quel momento: **non si lancia niente**.

---

## 7. Criteri congelati PRIMA dei numeri, attese, controesempi, parole di verdetto

Sono il testo da copiare nei file prova. Marcati: **[CASA]** (criteri di casa, fonte) e **[NUOVO, F-A]** (da firmare; valgono perche' scritti prima di ogni numero EXT del Nasdaq).

### 7.1 Gate in ordine (se uno fallisce, si ferma)

| gate | cosa | passa se | se fallisce |
|---|---|---|---|
| **P0a** | etichette dai CSV veri sul PC (Nasdaq e S&P, 2010-2026), regola §4.1 | etichette = §4.1 (o rinominate dichiarando) | finestra rinominata, non scartata |
| **P0b** | orologio del simbolo (§3.3) | profilo orario del range medio al minuto sul simbolo `NASUSD_EXT` con scatto a **14:30** (H-A) e non a 09:30 | se scatta a 09:30: ipotesi H-B vera, **la tabella §3.2 si riscrive** e il nucleo gira con `InpSessionHour=9` |
| **P0c** | canarino volumi: cella viva (volumi ON) su W1 primi 3 mesi (2022.01.03 -> 03.31), gemelle sul magic (asse tecnico, rischia zero passate) | **n ~ 0 in entrambe**: **n <= 15** sui 63 giorni (quelli con buchi nelle 20 barre M5 prima della rottura) [bande fissate dalla passata indipendente 05/10, prima dei numeri] | **n >= 38** (0,6 x 63 = fascia della mappa meno 30%): il filtro non filtra. **16-37 = ZONA GRIGIA**: non si riscrive nulla finche' il per-trade non dice se i giorni passati sono giorni con buchi. Nel ramo n >= 38: il filtro non filtra (la mappa aveva ragione nell'esito), si riscrive §6.1. **[corretto dal cancello 05/10]** Un n piccolo ma > 0 NON vuol dire "filtro testabile": su EXT il volume M5 e' un conteggio di minuti (o di tick generati), non un volume; **la strada B NON decade in nessun esito**. Il per-trade del canarino dice in che giorni e' passato: se sono giorni con buchi, e' confermato |
| **P0d** | canarino spread: stessa cella X0, `-Spread 180` contro `-Spread 5000` | numeri **diversi** (PF e DD) | uguali: lo spread e' ignorato nel banco (classe 89): **stop**, nessun numero di costo si legge |
| **P1a** | calibrazione feed C1 + C2 (§8) | verdetto **NULLO** o **ZONA GRIGIA** (§7.3) | **EFFETTO**: nessun numero EXT di questa cella si legge come regime |
| **P1b** | contratto a tick della gemella X0 su BCM IS e OOS (due passate x gemelle) | gemelle identiche | serve per ancorare R1 (§7.2): senza, R1 non e' calcolabile |
| **G1** | gemelle identiche in ogni finestra (la L+S duplicata) | Trades e DD esatti, Profit entro 1,00 EUR, PF entro 0,0002 (tolleranza di banco R274) | la finestra non si legge |

### 7.2 Rischio e merito (per finestra e cella)

- **R1 [CASA, `PROVA_REGIME_CRITERI.md` §4A]**: in W1 e W2/W2r il DD (equity, 2,00%, 80.000) **<= min(2 x DD_OOS(X0, tick, P1b), 20%)**. L'ancora e' la **gemella X0**, non la sedia (la sedia a tick fa 7,8576%): applicare 2 x 7,86 = 15,7% a una cella senza filtro volumi vorrebbe dire confrontare due celle diverse. Il numero di P1b si scrive nel file prova **prima** della corsa EXT. [Nota del cancello 05/10: `PROVA_REGIME_CRITERI` §4 misura "a rischio 1% su 100k"; qui si misura a 2,00% su 80.000. Il doppio-DD e' invariante se ancora e corsa hanno lo stesso rischio; il tetto del 20% a 2,00% e' **piu' severo** (vale ~10% a 1%), quindi nessun ammorbidimento, ma la deviazione dalla [CASA] va dichiarata cosi' nel file prova.]
- **R2 [NUOVO]**: peggior giornata realizzata >= **-4,0%** a 2,00% (resta sotto il 5% giornaliero FTMO con margine; per-trade, giorno server).
- **R3 [NUOVO, flag prop, non e' una bocciatura]**: DD **<= 10,0%** a 2,00% (muro FTMO statico 10%; il DD del tester e' dal picco, il muro e' dal saldo iniziale: `CONTRATTI_DELLE_SEDIE_FTMO` §10). Il superamento si scrive **ROSSO-PROP** e informa la **taglia, che e' di Claudio**.
- **M1 [CASA]**: **PF >= 0,90** nelle avverse (W1, W2) **con n >= 150 posizioni**; sotto 150 si scrive **"MERITO: NON ANCORA MISURATO"** in chiaro; sotto 8: NON MISURATO.
- **M2 [CASA, `PIANO_LATI` §6]**: regge fuori dal toro se PF(LONG, ORSO) >= 0,90 **e** PF(SHORT, TORO) >= 0,90; se uno dei due < 0,70 la cella e' **DIREZIONALE** ("non e' una bocciatura: e' un'etichetta che cambia il contratto"). Giudizio sulla **coppia** di finestre, mai su una (regola D del 14/08). Con n_lato < 150 per finestra, il PF per lato si legge sull'**unione delle avverse W1 + W2** (n atteso §7.4).
- **Asimmetria delle barre (§5):** R1, R2, M1 possono solo **bocciare**; non esiste una soglia che "promuova".

### 7.3 Parole di verdetto

Per ogni finestra x cella: **(a)** RISCHIO: VERDE / ROSSO (R1, R2) / ROSSO-PROP (R3); **(b)** MERITO: LEGGIBILE (n >= 150) / SOSPESO (8 <= n < 150) / NON MISURATO (n < 8).
Per la cella: **BOCCIATA IN REGIME (a barre)** se R1 o R2 e' violato in W1 o W2/W2r, **oppure** M1 e' violato con n >= 150 in **entrambe** le avverse; **DIREZIONALE** (M2); **NON BOCCIATA (SCREENING)** negli altri casi (nessuna promozione, nessun effetto di campo); **NON ANCORA MISURATO** se n < 150 ovunque nel merito e il rischio e' VERDE. **Mai** "promossa", **mai** "morta" (certificato del 09/09: gemelli, TF e uscita ad asse restano da fare).
Per la calibrazione di feed (stesse parole del 19/08: NULLO / ZONA GRIGIA / EFFETTO): **NULLO** se rapporto `n` EXT / nativo (stesso modello) in [0,85; 1,15] **e** trade-match >= 70% (stesso lato, ingresso entro +-1 barra M5) **e** il controllo nullo (stessi trade spostati di +1 giorno) <= meta' del match; **EFFETTO** se il rapporto esce da [0,70; 1,30] **o** il match e' < 50%; **ZONA GRIGIA** in mezzo. Con ZONA GRIGIA si leggono solo i **segni** del rischio e delle frequenze.

### 7.4 Attese numeriche, scritte prima (basi dichiarate; fasce larghe e oneste)

| grandezza | attesa | base | cosa falsifica |
|---|---|---|---|
| **P0c** n (volumi ON su EXT) | **~0: n <= 15** su 63 giorni | `tick_volume=1` per M1 (r.325); su M5 il volume e' la somma (<= 5 nello storico; tick generati nel tester `[NON MISURATO]`), `VolumeOKtf` r.2513-2525 chiede che l'ultima barra chiusa sia >= 1,5 x media delle 20 precedenti: passa solo con buchi (o, se il tester conta i tick generati, minuti piatti) prima della rottura | **n >= 38**; 16-37 zona grigia (§7.1) |
| posizioni/giorno X0 (L+S) | **0,87-0,96** | NASDAQ_B vol OFF: 176 / 183 giorni IS e 240 / 276 OOS (1%, tick) [DERIVATO] | fuori fascia di oltre +-30% per regime: e' un **risultato**, non un errore |
| posizioni X0 per finestra (L+S) | W1 187-206 · W2 224-248 · W2r 55-60 · W3 223-246 | giorni validi 215, 258, 63, 256 (§4.1) x 0,87-0,96 | idem |
| posizioni X0 solo long / solo short | **0,65-0,71 x** la L+S | NASDAQ_M [DERIVATO] | |
| merito leggibile per finestra | W1 **al bordo** (187-206), W2, W3 si; W2r no | | |
| merito per lato | **solo** sull'unione W1+W2: solo long ~270-320, solo short ~265-300 posizioni | 0,65-0,71 x (187-206 + 224-248) | |
| rapporto `n` EXT / nativo-M1 in C1+C2 | **~1,0 (0,85-1,15)** | il rumore di Poisson su 140 posizioni e' ~+-8-11%: la fascia e' ~1,3 sigma | R80: calo sistematico **20-55%** su 16 celle (`LO_STORICO` §5.1): **disgiunto** dalla fascia |
| DD X0 a 2,00% nelle finestre avverse | **non si dichiara una fascia numerica**: la gemella senza filtro ha a tick DD 16,25% (IS) / 8,79% (OOS) a 1% **senza** gestione d'uscita; con ClosePct 50 + BE il DD della sedia scende di -41% (IS) e -14% (OOS) [R199B Pass 0 -> 2]. Applicare quel rapporto alla gemella e' un'**ipotesi** non misurata: P1b da' l'ancora vera. | | |
| segno dei lati | **ribaltamento a specchio**: PF(short) in W1 > PF(short) in W3 **e** PF(long) in W3 > PF(long) in W1 | `NASDAQ_M`, R107, R115 | entrambi i lati positivi in tutte e tre le finestre = H_EDGE (vedi controesempi) |

### 7.5 Controesempi (l'altra spiegazione, e il numero che produce)

| misura | l'altra spiegazione | che numero produce l'altra | separa? |
|---|---|---|---|
| **P0c volumi** | "con volume 0 il filtro non filtra e la cella gira come volumi OFF" (`APERTURE_NASDAQ_MAPPA` §7) | **n ~ 0,87-0,96 x giorni** (55-60 posizioni nei 63 giorni della finestra) invece di ~0 (<= 15) | **si**, bande disgiunte; mi serve **un solo** risultato per chiudere la questione |
| **P0b orologio** | "le barre EXT sono ora di New York, la cella a 9:30 e' quella giusta" | scatto del range a **09:30** (0,066-0,082% al minuto sul grezzo, 2-2,5 volte 09:29) e profilo piatto a 14:30 (~0,03-0,06%) | si: misura il **simbolo**, non il CSV |
| **770250 ora** | "l'ora e' inerte" | n e PF **identici** fra 9:30 e 14:30 | si: sotto l'ipotesi H-A sono **diversi** |
| **P1a feed** | "il feed e' innocente, le epoche sono vere" | `n` ~1,0 con trade-match >= 70% e controllo nullo <= meta' | si; **un `n` che combacia da solo non basta** (la cella e' vicina a un tetto: una sola operazione al giorno): per questo il trade-match e il controllo nullo (classe 178) |
| **P0d spread** | "il costo non morde perche' lo spread e' zero nel banco" (R113, checklist 89) | PF/DD identici a spread 180 e 5000 | si |
| **etichette** | "il 2019 e' laterale" (etichetta del forex) | rendimento **+40,2%**, DD -10,1% [MISURATO] | si: cade |
| **orso della cella** | "il DD basso e' merito della cella e non del banco" | DD OHLC e' un **limite inferiore** (R103 6,48 contro R112 7,83 a tick, finestre diverse: indicativo) | **non separabile** dal banco: R1-R3 si leggono come **limite inferiore**, dichiarato accanto a ogni numero |
| **regime vs edge** | "i due lati si ribaltano per il regime" | PF(short) W1 > W3 e PF(long) W3 > W1 | si, ma **solo come descrizione**: nessun lato si spegne guardando i risultati (malattia R52) |

---

## 8. Il costo in tempo macchina (PC di backtest `DESKTOP-H4D7CAJ`)

Ancore **misurate**: OHLC **2,9-33,0 s/passata, mediana 13,5** (27 round cronometrati, R88; `MANOPOLE_INERTI_2026-09-09.md` r.73, `PIANO_LATI` §7); R113 36 passate in 5,4 min = **9 s/passata**; tick **20,1 s/passata** sul Dow M5 (R202A, 8 passate in 2 min 41 s); Nasdaq 156,1 M tick contro 64,7 M del Dow nella stessa finestra -> **<= 48 s/passata a tick** per l'intera finestra, molto meno per C1 e C2 [DERIVATO lineare].

| blocco | passate | modello | s/passata | **minuti** |
|---|---:|---|---|---|
| **P0c** canarino volumi (2 gemelle) | 2 | OHLC | 13,5-33 | 0,5-1,1 |
| **P0d** canarino spread | 2 | OHLC | 13,5-33 | 0,5-1,1 |
| **P1a** calibrazione: C1, C2 x {EXT-M1 con gemella (2), nativo-M1 (1), nativo-M4 (1)} | 8 (6 OHLC + 2 tick) | misto | OHLC 13,5-33 / tick <= 48 | 1,8-4,9 |
| **P1b** ancora a tick della gemella X0: IS e OOS x gemelle | 4 | tick | <= 48 | <= 3,2 |
| **P2** nucleo: 4 finestre x 4 passate (L+S, long, short, L+S duplicata) | 16 | OHLC | 13,5-33 | 3,6-8,8 |
| **P2s** stress spread 270 su W1 e W2 (solo L+S) | 2 | OHLC | 13,5-33 | 0,5-1,1 |
| **TOTALE `770260` (strada A)** | **34** | | | **~8-20 min** (0,13-0,34 h) |
| `770250`: ora (4) + 4 finestre x 4 | 20 | OHLC | 13,5-33 | 4,5-11 |
| `970913`: A5 (3 celle x 3) | 9 | OHLC | 9-33 | 1,4-5 |
| **nucleo NASDAQ complessivo** | **63** | | | **~14-36 min** (0,23-0,6 h) |
| estensione F-B (`770260`): W4-W7 x 4 passate | 16 | OHLC | 13,5-33 | 3,6-8,8 |
| `771514` (se sbloccata: F-C, spread, costo): 4 finestre x 4 + corsa lunga x 4 | 20 | OHLC H4 | 13,5-33 | 4,5-11 |
| **strada B** (Dukascopy tick, F-D): crawl nucleo + tester | | | | **62-244 ore di PC acceso** + ~0,2-1 h di tester |

Il costo di tester e' trascurabile: **il costo vero e' l'orologio** (compilazione, driver, trasferimento zip: ~15 file prova per la `770260` = 8 file di finestra + 4 di calibrazione + 2 canarini + 1 di ancora, **[DERIVATO dalla struttura]**) e le **firme**. Una griglia grande non serve e non e' proposta: **nessuna manopola d'ingresso viene mossa** (regola del 19/08; la cella non e' dichiarata senza edge, ma l'asse volume si paga con prova di regime e qui non e' testabile).

---

## 9. Le firme: che cosa e' gia' firmato e che cosa serve

**Gia' firmato e sufficiente (nessuna nuova firma):** D-A (HistData, barre M1) · D-B (SIMBOLI = NASUSD,SPXUSD,D30EUR: lo scarico e' fatto) · **D-C (USO = SOLO_PROVA_REGIME: parametri congelati, nessuna promozione, confronti dentro lo stesso feed, intestazione "dati di un ALTRO broker")** · D-D (finestra 2010-2026) · D-H (finestra per simbolo) · **"FIRMO FRIGO NASUSD" (26/08): `NASUSD_EXT` ammesso alla prova di regime** · la regola del 21/09 (i round girano sul PC di backtest) · il mandato del 05/10 ("parti con gli altri indici in background"), che autorizza a **preparare**, non a fissare criteri.

**Nuove firme richieste:**

| id | che cosa | perche' serve | obbligatoria? |
|---|---|---|---|
| **F-A** | **"FIRMO REGIME NASDAQ"**: i criteri di §4-§7 (finestre del nucleo, regola di etichettatura, cella derivata X0 senza filtro volumi con `-Spread 180`, canarini P0c/P0d, gate P0b e P1a/P1b, R1-R3, M1-M2, parole di verdetto, esclusione per costo delle finestre <= 2018, esclusione del 2023), applicati a `770260`, `770250` (rilettura) e `970913` (A5) | i criteri si firmano prima dei numeri (R113 lo aveva fatto): "FIRMO FRIGO NASUSD" ammette il simbolo, **non** questi criteri ne' il delta di cella | **SI** |
| F-A2 | cella sostituta X1 (filtro ATR calibrato sul nativo, §6.1 strada A') | misurerebbe qualcosa di piu' vicino alla sedia vera su EXT | no, solo se la fedelta' di §6.1 passa |
| **F-B** | traslazione di scala dei soli input in punti per W4-W7 (§4.3) | e' l'unico modo di avere un laterale (2015-16) e piu' di 10 anni totali | no |
| **F-C** | riesame di `SPXUSD_EXT` con **misura nuova pre-dichiarata** (§6.4) | senza, nessuna cella S&P puo' girare su EXT (D-C punto 3 vale ancora per SPX) | no, solo se Claudio vuole l'S&P |
| **F-D** | strada B: Dukascopy `USATECHIDXUSD` come prova di regime con volumi veri | l'unico modo di misurare la **sedia vera** nei regimi | no; **dopo** l'esito di "FIRMO CANCELLO DK DOW" (F2 del 05/10, P0-P1) |

Non c'e' nessun passo che tocchi rischio, taglie, preset, EA in campo, conto reale `10105439`, ne' soldi: **tutte le decisioni di campo restano di Claudio**. Una domanda aperta e **sua**: la taglia 2,00% sulla trial e il muro statico del 10% (R3 §7.2 la informa, non la cambia).

---

## 10. La riga "anni/dati" del dossier, se la prova passasse

Il dossier usa una regola unica (dossier, ultima colonna): **SI** = circa 10 anni o piu' **e** piu' regimi misurati uno per uno con un esito leggibile; **PARZIALE** = solo una delle due; **NO** = nessuna.

**Riga oggi (tabella "Quanti anni sono stati davvero misurati"):**
`Apertura Nasdaq, ritest, due lati | ~21 mesi a tick (IS ~9,1 mesi, OOS ~12,0); esistono 15,7 anni esterni a barre M1, non usati su questa cella | tick reali (21 mesi) | toro; il resto NON MISURATO su questa cella | NO`

**Riga se passa il nucleo (P0-P2, F-A):**
`Apertura Nasdaq, ritest, due lati | ~21 mesi a tick + 3 finestre di regime su barre M1 HistData (2020 crollo/anno, 2021 toro, 2022 orso = ~34 mesi) | tick reali (21 mesi) + barre M1 OHLC (screening: PF ottimista, DD limite inferiore) di una gemella SENZA filtro volumi, armata alla cash | toro con una correzione del 24% (tick); crollo, toro, orso a barre; laterale NON MISURATO (2015-16 escluso per costo: 13,5x); **il filtro volumi non e' testabile su barre** | PARZIALE (regimi si', anni ~4,6 totali, sedia vera non misurata nei regimi)`
Se il nucleo **non** passa il rischio: la riga diventa `NO, con "bocciata in regime a barre" nella colonna regimi` (e questo e' un risultato).
**Riga con anche l'estensione F-B** (W4-W7): mesi totali 21 + 34 + 18 + 12 + 24 + 24 = **133 mesi = ~11 anni**: la regola dei 10 anni sarebbe **tecnicamente** soddisfatta, ma con barre M1 di una **cella traslata, senza filtro volumi, a costo benigno**. Va scritto cosi' nella colonna del tipo di dati, e **va chiesto a Emiliano se quel tipo di evidenza vale**: non si scrive SI per aritmetica.

**Altre righe del dossier che cambierebbero:** nessuna (Dow, DAX, Nikkei, oro, forex: fuori da questa specifica). Il dossier dice (§C) che il Nasdaq esterno "gia' usato (18 celle su 16 anni, altro motore)": resta vero, e va completato con "R113 e' SupRev H1, non una cella di apertura". `NASUSD_EXT` e' ammesso, quindi anche la frase del dossier "il controllo di qualita' del feed passa per un soffio: 0,199 contro 0,20" resta giusta.

---

## 11. Buchi dichiarati (per nome)

1. **Il filtro volumi** non e' testabile su barre: la sedia vera non si misura su EXT.
2. **Orologio del simbolo** letto da due referti e da un controllo sul grezzo, **non** dal simbolo in MT5 (P0b). La contraddizione con SHORTGATE/FASE2/INVES non e' chiusa.
3. **Volume `nsxusd`** `[INFERITO]` da `spxusd` (822.911 righe a 0) e dalle prime righe dell'anteprima.
4. **Etichette**: Nasdaq da serie giornaliera delle aperture (DD sottostimato); S&P 2019-2026 **non misurate**; la soglia 15% della regola e' sul bordo per VECCHIA (15,2%) e per il sotto-periodo 2011 (15,2%).
5. **Spread storico**: fisso 1,80 (BCM mediana 2024-26); quello vero di BCM/FTMO nel 2020-22 e' sconosciuto; lo spread FTMO `US100.cash` alle 16:30 e' `[NON MISURATO]` (`APERTURE_NASDAQ_MAPPA` §4); la commissione FTMO sui CFD indici pure.
6. **Sessioni di trading del simbolo custom**: non risulta che l'import copi le sessioni; ordini fuori sessione nel tester `[NON VERIFICATO]`.
7. **Il simbolo `NASUSD_EXT` esiste oggi sul PC?** [NON VERIFICATO oggi]: ultima conferma 26/08 (import) e 10/09 (solo riconversione dei CSV, non nuovo import). Il passo P0 lo controlla in sola lettura.
8. **R274** (orologio BCM nativo d'inverno, 16 passate) **non e' girato**: questa prova non lo sostituisce, lo completa (alla cash tutto l'anno contro 8:30 NY).
9. **La settimana 26-30/10/2026** (FTMO) non e' coperta da nessuna misura.
10. **Il fattore barre -> tick per la cella RETEST** e' misurato solo da P1: fino ad allora il solo numero in casa e' 1,72-3,51x di altri motori.
11. **Sedia vera nei regimi: nessuna via entro 24 ore.** La strada B e' 62-244 ore di PC acceso, condizionata a F-D e al cancello DK del Dow.
12. **`771514`**: spread SPX non misurato, ATR(H4) 2024-26 non misurato, stato in campo da confermare a Claudio.
13. Gli script di lettura (etichette P0a, profilo orario P0b, trade-match P1a, giudizio per finestra) **non esistono**: vanno scritti PRIMA di aprire i per-trade, con questo documento come specifica e `--autotest` (come `r246_giudizio_d1.py`). `[NON FATTO in questa sessione]`.

---

## 12. Fonti e verifiche eseguite in questa sessione

Letti: `CLAUDE.md`, `FLOTTA_ATTIVA.md`, `HANDOFF.md` (righe sulle sedie del piccolo e della trial), `report/DOSSIER_EXPERT_PER_EMILIANO_2026-10-05.md`, `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md`, `report/APERTURE_NASDAQ_MAPPA_2026-10-03.md`, `report/LO_STORICO_ESTERNO_MAPPA_2026-09-23.md`, `report/STORICO_INDICI_SCARICATO_2026-09-10.md`, `report/OROLOGIO_BCM_2026-09-24.md`, `report/PIANO_REGIME_DOW_DUKASCOPY_2026-10-05.md`, `report/PIANO_LATI_REGIME_2026-09-09.md`, `report/DUELLO_GEMELLI_DOW_SPX_2026-09-18.md`, `report/SOSPENSIONE_SEDIE_DEMO_2026-09-25.md`, `report/FIRME_2026-10-05.md`, `backtest_pipeline/risultati_archivio/{STORICO_INDICI_CRITERI,R113_CRITERI,R113_REFERTO,R110_REFERTO,REFERTO_SHORTGATE_2026-08-30,REFERTO_FASE2_DRIVE_2026-08-30,REFERTO_FASE2_CASSA_2026-08-30,REFERTO_INVES_2026-08-30,LETTURA_MISURE_LAMPO_2026-08-26,LETTURA_ANATOMIA_APERTURE_2026-08-26}.md`, `.../ANATOMIA_APERTURE_20260826/{CENSIMENTO_FONTE.txt,ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv}`, `.../ANATOMIA_MOVIMENTI_M5_2026-09-29/NASUSD/ANATOMIA_MOVIMENTI_M5_PERGIORNO_NASUSD.csv`, `.../STORICO_INDICI_20260826_2334/ABTG_ImportEsterno_referto.csv`, `.../import_ext_v2_referto_2026-08-19.csv`, `.../spread_flotta/spread_orario_NASUSD.csv`, `.../sonda_storico_17-08/215D85D7_ABTG_InfoBroker.csv`, `.../R199B/REFERTO_ROUND_R199B.txt`, `backtest_pipeline/prove/{PROVA_REGIME_CRITERI.md,R274a_orologio_d0_B_NASDAQ_NASUSD.txt,R110_SUPNAS_00_metro.txt,R185_SONDA_SPXUSD_CRITERI.md,SHORTGATE_NAS_BREAKDOWN.txt,FASE2_NAS_00_baseline.txt,INVES_NAS_00_baseline.txt}`, `backtest_pipeline/REGISTRO_TEST.md` (righe 60-82, 108, 2525-2640, 3736-3760), `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md` (classi 1102-1106), `mql5/Presets/` (770260 BCM e FTMO, 770250, FW SPXUSD), `mql5/Scripts/ABTG_ImportaStoricoEsterno.mq5`, `mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5` (r.2498-2530), `backtest_pipeline/walkforward_generico.ps1` (r.202-214, 955-973).

Calcoli eseguiti (python3, sola lettura, nessun file scritto in repo): (1) rendimento e DD sulla serie delle aperture 09:30, finestre di §4.1, Nasdaq da `ANATOMIA_APERTURE_PERGIORNO_NASUSD.csv`, S&P da `DAT_ASCII_SPXUSD_M1_{2010..2018}.csv` (2010-2012 scaricati dallo specchio `raw.githubusercontent.com/FutureSharks/financial-data`, 2013-2018 dalla cache cloud del 22/09); (2) correlazione giornaliera Nasdaq-S&P 2011-2018 = 0,915 su 2.016 giorni; (3) mediane del range 35' e 15' per finestra; (4) volume = 0 su 822.911 righe; (5) profilo del range al minuto per orario sul grezzo S&P; (6) ampiezza media della barra H4 dell'S&P 2011-2018 con orologio EXT (4,1x-10,1x di 1,40; mediano 3,4x-7,5x); (7) conteggi di giorni e passate di §8. Tutti i numeri di §4 e §8 sono ricalcolabili con il passo P0a sui CSV del PC.

**Perimetro rispettato:** nessun file prova, riga, preset, EA, forward o taglia toccato; nessun conto toccato; nessun backtest; nessun download di dati di mercato (solo tre file HistData S&P 2010-2012 dallo specchio pubblico, per le etichette); nessun file di altri agenti (DUKA, righe, dukascopy, ombra) toccato.
