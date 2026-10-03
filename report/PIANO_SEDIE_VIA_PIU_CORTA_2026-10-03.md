# PIANO SEDIE: LA VIA PIU' CORTA (03/10/2026)

Autore: architetto-prop. Mandato di Claudio, 03/10/2026: *"abbiamo un unico obiettivo, creare una flotta di EA per le prop... sotto col lavoro e portatemi risultati"*.
Sola lettura sul repo: nessun backtest lanciato, nessun EA / preset / taglia / parametro di rischio / conto / terminale toccato, nessuna riga di lancio scritta
(dove una misura ne richiede una e' descritta soltanto: passera' dal cancello `controlla_riga.py` + `controllo-preventivo` prima di uscire).
Nessuna ricerca web. Nessuna chiamata a Gemini. Il trial FTMO 1514806751 non e' toccato (`report/TRIAL_14_GIORNI_CRITERI_2026-10-01.md`, 03/10: "lasciamo tutto cosi'").
Etichette: [MISURATO] letto o ricontato da me su un file; [LETTO] riportato da un documento del repo; [DERIVATO] calcolo mio su numeri scritti (formula esplicita); [INFERITO] giudizio mio; [NON MISURATO] il dato non esiste.
Dove un file prova citato qui e questo piano divergono, vincono i criteri scritti nel file prova (congelati prima dei numeri). Le attese scritte qui sono mie e non sostituiscono le loro.
**Lavori di altri agenti letti oggi, non rivisti da me**: `report/EMA200_GEMELLI_STATO_2026-10-03.md` + `backtest_pipeline/prove/EMAGEM_{a,b,c}_*.txt` (commit `2fe2e26b`, 10:08 UTC); `backtest_pipeline/prove/BULGE_M1_cella_campo_lunga.txt` (**non committato** al momento della lettura: puo' cambiare). Li uso, li cito col loro stato, non li ho passati dal cancello.

---

## 0. LA RISPOSTA, IN 15 RIGHE

Ordine = rapporto fra quanto la misura avvicina una sedia schierabile e il suo costo (ore macchina sul PC di backtest DESKTOP-H4D7CAJ, firme, rischio).

| # | azione | candidato | ore macchina (PC) | firme di Claudio | perche' in questa posizione |
|---|---|---|---|---|---|
| 1 | Prova di REGIME + DD nella discesa 2025 (4 file scritti il 09/09, mai girati) | `771531` EMA200 Dow H1 | 8 passate: **1,2 min (metro di casa) - 3 min (stima 12/09) - 24 min (tetto)** | nessuna per girare | unica sedia che passa i cancelli alla lettera; manca proprio il regime; il DD in discesa si legge a qualunque n |
| 2 | Contratto d'INVERNO del DAX Apertura (serie "come FTMO") + B10 + orologio | `770101` DAX Apertura long retest | **0** (dati in repo); opzionale 4-12 passate = 1-18 min | **orologio entro 25/10**; B10 gia' pronta | seconda sedia per numeri (193 pos OOS, 295 pos serie FTMO); il contratto vecchio mescola due orologi |
| 3 | Bulge: prima la cella in campo (BULGE_M1, 4 passate), poi R92b solo se serve | Bulge v5.20 | M1: **15-60 min** [DERIVATO da altro agente]; R92b condizionato: ~95 min (+~11) | via libera al tempo; magic nuovi o cache | 10 posizioni su 13 del trial, contratto assente: la misura piu' vicina a una decisione di rischio gia' viva |
| 4 | Gemelli di 771531 a tick: EMAGEM_a/b/c (cella intera, asse TF su D30EUR e NASUSD) | gemelli indici | 24 passate = **8-34 min** (stima dell'autore) | nessuna | chiude la casella "gemelli a tick" del certificato; probabilita' di una sedia bassa, dichiarata dall'autore |
| 5 | Toppa classe 294 su copia di BANCO + PRV_DAXAP_01 | `770101` / `770105` (stesso EA) | 12 passate = **~2,2 min** | vivo = firma; banco = solo cancello | sblocca `InpMaxSpread` (costo ora 09); ma l'attesa e' "il default va bene" |

Totale macchina: **~30 min - ~2h35** senza R92b; **fino a ~4h20 con R92b**. Le sei "scartate per frequenza" NON sono in classifica (sez. 5): una e' chiusa (M27, 12/09), una e' morta per segno (gap cash, 07/09), una raccomandazione e' stata ritirata (770512, 08/09), una ha solo il file prova scritto e non la sonda (riconquista), le altre costano giorni o sono letture a macchina zero.
**La decisione piu' urgente per Claudio**: l'orologio d'inverno (azione 2), scadenza **25/10**. **La piu' economica da dire "si'"**: le 8 passate della 771531 (azione 1).
**Conflitto da sciogliere prima di far girare qualunque cosa**: il 29/09 sera Claudio ha deciso "A" (nessun round di sabato, crediti solo su cancello + Gemini fino a domenica 08:00, `HANDOFF.md` r.60). Oggi e' sabato 03/10 e il mandato di oggi e' successivo: lo leggo come "i round possono partire", ma e' una scelta sua, non mia.

---

## 1. FATTI RICONTATI CHE CAMBIANO IL PIANO (misurati da me oggi, non copiati)

1. **`770101` e `771531` NON compaiono nel profilo salvato di `C:\FTMO` dal 01/10.** CODA_01 del 30/09 elenca 10 sedie con `770101` (chart01) e `771531` (chart04); CODA_01 del 01, 02 e 03/10 (03:30) ne elenca 10 **senza** quelle due (al loro posto ORB 770621 e Bulge 772720) [MISURATO sui quattro log `backtest_pipeline/coda/referti/CODA_01_sedie_attaccate_*`]. Il `HANDOFF.md` 01/10 dice "sette sedie vecchie attaccate". La sonda rilegge il **profilo salvato**, non lo stato vivo (la nota `report/NFP_2026-10-02_SEDIE_TRIAL.md` lo aveva scritto: "decide la faccina"). **[NON VERIFICATO] quale lettura e' vera.** Conseguenza: le 13 posizioni del trial (770411, 770105, Bulge x10, ORB) non dicono niente su `770101` e `771531`. Un'occhiata a vista (terminale `C:\FTMO`, conto 1514806751, grafici GER40.cash M5 e US30.cash H1) costa zero.
2. **I gemelli di `771531` sono coperti, ma solo cosi'.** Ricontati dai CSV `risultati_archivio/EMA200/{H1_OHLC,H4_OHLC}/` [MISURATO; "best PF" = massimo del Profit Factor fra le celle vive, **qualunque n**: non e' il PF della cella esatta della sedia ne' il PF mediano, due letture che la classe 1086 distingue]: a **H1, OHLC (screening)**: D30EUR **0/85** celle positive (best PF 0,92752), NASUSD **1/85** (best 1,01974; l'altra scansione in `risultati_prove` dice 2/83, best 1,0285 [LETTO]); E50EUR 0/88, SPXUSD 1/79 [LETTO]. A **H4, OHLC a finestra unica 2024.01.01-2026.06.30** (finestra dichiarata dal driver, non dal CSV): D30EUR **54/92** (best PF 1,80839, max 200 deal), SPXUSD **75/86** (1,86702; 147), U30USD **77/85** (3,02473; 82); `scan_ABTG_EMA200_H4_NASUSD.csv` **non esiste**. Tick H1: solo U30USD ed EURUSD; tick H4: 200AUD, 225JPY, AUDJPY, GBPJPY, GBPUSD, SPXUSD, USDNOK, XAUUSD (non D30EUR, NASUSD, U30USD) [MISURATO con `ls`]. **Round gia' fatti sul corto a TF multipli, a tick**: R234b (D30EUR) e R234c (NASUSD) del 23/09: D30EUR corto OOS PF M30 0,950, H1 0,724, H2 0,540, H3 0,758, H4 0,662 (morto a tutti e cinque); NASUSD corto M30 OOS 1,230 su 569 ma escluso per costo (23,7x), H4 OOS 1,166 con **IS 0,318 su n=15** [LETTO da `EMA200_GEMELLI_STATO_2026-10-03.md` sez. 2, che cita il referto 23/09: i CSV R234 **non sono in repo**]. Nessun altro round (R112-R175 e seguenti) tocca EMA200 su D30EUR o NASUSD: l'elenco dei file prova `# EA: ABTG_EMA200` contiene solo Dow, AUDJPY, GBPUSD, GBPJPY, XAUUSD, EURUSD piu' R234b/c e i tre EMAGEM di oggi [MISURATO con `grep`].
3. **Il lato forte dei tre indici a H4 e' uno solo: il long** [MISURATO, ricontato]: D30EUR L 30/30 positive (PFmed 1,44) contro S 1/34 (0,77); SPXUSD L 32/32 (1,53) contro S 14/25 (1,07); U30USD L 30/30 contro S 19/27. E' lo schema "segue il toro" che `report/EMA200_RIMBALZO_STATO_DELLARTE_2026-09-30.md` §2.2 attribuisce alla deriva [INFERITO li']. Su AUDJPY e GBPUSD la stessa famiglia di celle H4 e' caduta alla finestra lunga (DD 15,4-20,4% e 17,7-20,3%) [LETTO R139a/b]. **SPXUSD e' escluso per COSTO a ogni TF** (H1 7,4x, H4 14,9x contro la frontiera 40x [DERIVATO in `EMA200_GEMELLI_STATO` sez. 2-3; `MAPPA_COSTO`: "esclusa in modo definitivo su BCM"]): non e' un gemello da misurare.
4. **Il ripescaggio dell'08/09 (`report/RIPESCAGGIO_FREQUENZA_2026-09-08.md`) e' parzialmente vecchio**:
   - R4 **M27 overnight**: *non e' piu' "mai misurato"*. Misurato il 12/09 sul DAX 2010-2018 (2.053 notti, notte +0,04488% t=+2,86; giorno -0,01575% t=-1,13): merito SI', **rischio NO**: la peggior notte (-11,66%, 16/03/2020) costa 1,51 volte un anno intero di edge, rapporto invariante rispetto allo stop. Verdetto: "il candidato non entra nell'imbuto" (`report/SECONDA_CACCIA_2026-09-12.md` §4) [LETTO].
   - R2 **gap di sessione cash**: passo 0 del 07/09 su NASUSD: tick BCM **-0,0487%** contro -0,0134% (esterno +0,0988% contro +0,0112%), segno rovesciato, monotonia rotta 4/7 (`REFERTO_GAPCASH_PASSO0_2026-09-07.md`) [LETTO]. Rientra "per la regola, non perche' prometta".
   - R3 **IU Gap Fill / riconquista**: esiste il file prova `GAPCASH_RICONQUISTA_PASSO0.txt` (08/09) che dice "LA SONDA NON ESISTE ANCORA" (nome previsto `ABTG_SondaGapRiconquista.mq5`); in `mql5/Experts` non c'e' [MISURATO con `ls`].
   - R1 **SuperWave DAX H4 (770512)**: la raccomandazione di metterlo in corsia demo e' stata **ritirata** l'08/09 sera (`report/DA_FIRMARE.md` §6): il DD 3,3% e' misurato a 1,00% (non 0,65%), sul piccolo il pavimento del lotto morde (D30EUR VOLUME_MIN 0,10) [LETTO]. n=56, 0,12 op/g.
5. **Cluster C2 e fattore con segno**: il Guardian HEAD (v1.14) calcola il rischio di cluster come **somma di `LossIfStopHit` per simbolo membro**, senza usare la direzione per attribuire l'esposizione, e non conta i pendenti (buco B6) (`ABTG_Guardian.mq5` r.434-465) [MISURATO sul sorgente]; **nessun EA lo legge** (0 occorrenze di `cluster_mappa` fuori dal Guardian, ricontato 03/10 in `docs/RISPOSTA_A_GEMINI_2026-10-03.md`) [LETTO]. Vedi sez. 4.
6. **Il tester del PC ha un guasto intermittente**: R92BAB (01/10) 2 gambe morte su 12 (17%), anche con un EA a un solo simbolo; il driver con RIPROVA (`walkforward_generico_RETRY.ps1`, PASS `d949f705`) e' stato usato in DAXAP03 (02/10) con zero riprove scattate [LETTO `R92BAB_LETTURA_2026-10-01.md`, `PRV_DAXAP_03_LETTURA_2026-10-02.md`]. Causa non nota: ogni round porta il rischio di rifare una gamba su ~6.

### La coda (`backtest_pipeline/coda/`)
- `CODA.txt` ha **12 righe di sola lettura accese** (CODA_01..12) e **115 righe ROUND commentate** dal 21/09 (82 a tick) col marcatore `[SOSPESO 21/09 -- CHALLENGE VIVA]`; si riaccendono solo quando i round non girano su una macchina che ospita sedie vive [LETTO; `grep` del marcatore = 117 occorrenze: 115 righe + 2 menzioni in intestazione].
- Referto del 03/10 03:30 (`REFERTO_RUNNER_20261003_033003.txt`): **12 righe eseguite, 0 rifiutate, 0 fallite, in corsia ROUND: 0** [MISURATO].
- **La coda NON e' la lista del da-fare**: parecchie righe commentate sono round gia' girati e letti per un'altra strada (es. r136a-d e cemad02/05 sono nella lista sospesa e hanno i CSV in `risultati_prove/dal_vps/ABTG_EMA200/`). I round del PC partono con righe bootstrap dirette (DAXAP02/03, R92BAB, RFWD), non dal runner. **Nessuna delle 5 azioni passa dalla coda**; il runner notturno sul VPS resta di sola lettura e il piano non lo tocca.
- Pericolo ancora armato-ma-scarico (`CLAUDE.md` 24/09): se qualcuno riaccendesse una riga ROUND, parte sul `C:\MT5_Backtest` del VPS. Qui non succede.

---

## 2. COME HO ORDINATO (e dove il mio giudizio e' debole)

Punteggio per azione: **beneficio** (quale casella del certificato a 5 punti PF / n+DD / uscita ad asse / gemelli / TF, piu' regime, chiude per una sedia vicina al campo) x **probabilita' di esito utile** [INFERITO, qualitativa] diviso **costo** (ore macchina, firme, rischio). Le probabilita' sono mie e non hanno una misura dietro: se l'ordine fra #3, #4 e #5 cambia con altre probabilita', la sostanza non cambia (i primi due restano primi).
Regole di casa rispettate: un candidato non si archivia senza certificato; la grinta cerca una misura in piu', mai un criterio piu' morbido; niente griglie su motori senza edge; ogni allargamento si paga con una prova fuori campione o di regime; l'unita' e' l'operazione, non l'anno; il vecchio giudica il rischio, il recente il merito.
Orologio (dichiarato per ogni orario del documento): server BCM = UTC+1 fisso; d'estate BCM = ora italiana - 1, **d'inverno BCM = ora italiana** (cambio DAX 25/10, USA 01/11; `report/OROLOGIO_BCM_2026-09-24.md`). Server FTMO = ora italiana + 1 tutto l'anno [LETTO, misurato sul trial il 30/09: 00:12 contro 23:12]. Quindi: **apertura cash DAX 09:00 IT = 08:00 BCM (estate) / 09:00 BCM (inverno) / 10:00 FTMO (tutto l'anno)**; apertura cash USA 15:30 IT = 14:30 BCM (estate) / 15:30 BCM (inverno) / 16:30 FTMO. Una sedia con `InpSessionHour=8` (DAX) su BCM d'inverno arma **un'ora prima** dell'apertura cash.

---

## 3. LE CINQUE AZIONI

### AZIONE 1 -- `771531` EMA200 U30USD H1: la prova di regime e il rischio nella discesa 2025

**Candidato.** `ABTG_EMA200` U30USD H1, magic 771531 (due gambe per segnale, rischio ripartito, massimo 2 posizioni e <=1,00% del saldo per costruzione, `ABTG_EMA200.mq5` r.322/361) [LETTO].
**Certificato a 5 punti.**

| punto | stato | fonte |
|---|---|---|
| 1 PF | SI, tick: IS 1,20110 / OOS 1,52365 | `R112_CORSA_20260826/*_00_metro.csv` [LETTO] |
| 2 n e DD | OOS **257 posizioni** SI; DD OOS 7,8323%, IS 5,7325% (a rischio 1%); **IS 132 posizioni = SOTTO 150** | cemad02, registro r.109 [LETTO] |
| 3 uscita ad asse | SI: `InpSLatr`, `InpTP1_ATRmult`, `InpTP1Pct`, `InpUseTrailing` (R136a-d); `InpTP_RR` governa il 4,3% delle uscite (R208a scritto, CSV non in repo) | registro r.105-108 [LETTO] |
| 4 gemelli | H1: SI in OHLC (sez. 1.2), **a tick sulla cella intera NO** (azione 4); H4: screening | [MISURATO sez. 1] |
| 5 TF | SI: M15/M20/M30 bocciati (PF<1 e costo 20-32x), H2/H3 OOS<=1,17, H4 fuori per frequenza | `cemad05` [LETTO] |
| REGIME | **NO**: 4 file prova scritti il 09/09, mai girati (`LATI_A1_..._DISCESA_{long,short}`, `LATI_A2_..._TORO_{long,short}`) | `CENSIMENTO_CASELLE_VUOTE_2026-09-22.md` r.165/183 [LETTO]; nessun CSV in archivio [MISURATO: `grep`, `ls`, 03/10] |

Buco in piu': il binario in campo della 771531 era `344a11b` (04/08, 486 righe, senza `InpUsaGuardian`) contro le 690 di HEAD [LETTO `CLAUDE.md` 12/09; `STATO_DELLARTE` 30/09: "ricompilato dopo [NON VERIFICATO]"]. Sul PC di backtest `ABTG_EMA200.mq5` e' compilato il 21/09, 691 righe, GUARDIA=SI [MISURATO CODA_06 03/10]: i round girano su HEAD.
**La misura.** `backtest_pipeline/prove/LATI_A1_*` e `LATI_A2_*`: tick reali, finestra DISCESA 2025.02.01-2025.04.30 (89 giorni, dentro i 21 mesi che BCM ha sugli indici: partenza 2024.09.26) e finestra TORO come termine di paragone. Asse unico `InpAllowShort` 1/0: 2 celle per file = 8 passate. Il conto "16 P = 24 min" del censimento 22/09 non si riconcilia con le 8 passate dei file [NON MISURATO]: uso il tetto 24 min. Una sola riga potrebbe includere come sentinella `EMAGEM_a` (stessa cella, deve riprodurre IS 1,20110 / OOS 1,52365 al centesimo): decide il cancello.
**Attesa scritta prima (dai file, non mia).** LONG puro in discesa: n 32-62, PF 0,60-1,30, DD 3-14%; L+S: n 70-135 (ritmo IS 0,926 op/g, OOS 1,343 op/g sui 89 giorni). "Se esce PF 2,0 con DD 1% in una discesa del 19%, il primo sospetto e' un baco." T1: la cella L+S del file long e quella del file short devono uscire **identiche al centesimo**, altrimenti il banco non e' deterministico e nessun numero si legge.
**Soglie congelate nei file.** T2 rischio a qualunque n: DD del LONG puro <= 10,00% a rischio 1,0%. T3: peggior giornata, allarme -3,00% (muro giornaliero 5%). T4: se PF(LONG, discesa) < 0,80 con PF(LONG, toro) = 1,24, la sedia va scritta "direzionale" (cambia la taglia, non l'accensione). T5: nessuna promozione, nessuno spegnimento (n sotto 150: merito sospeso).
**Contro-esempio mio (scritto prima).** La discesa sta *dentro* la finestra IS: l'IS PF 1,20 contiene gia' febbraio-aprile 2025; se in discesa il PF fosse < 1, l'IS lo nasconderebbe: per questo la misura vale. Al contrario, un PF alto in una sola discesa **non** soddisfa l'Emendamento C (una sola discesa; 2008/2020/2022 non esistono sugli indici BCM; il Dow esterno non esiste): il verdetto massimo possibile e' "il RISCHIO regge in una discesa", mai "il regime e' provato".
**Costo.** 8 passate: 1,2 min (metro di casa `T = 0,6 + 0,077 x passate`), ~3 min (stima 12/09, `EMA200_I_DUE_REQUISITI` r.14), tetto 24 min [DERIVATO/LETTO]. **Bersaglio previsto della riga: finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ**; il terminale banco li' e' `C:\Program Files\BCM Markets MT5 Terminal`, loggato sul conto 50503392 (avvertenza dei referti di round: il 14/08 da quella macchina sono partiti ordini veri; la guardia EA sui grafici salvati sta dentro le righe di round); NON tocca il VPS, 50504263, 10105439, `C:\FTMO` (541452707 / 1514806751), 50504400. **Prerequisito**: i file hanno 3 settimane: vanno rifatti passare da `controlla_prova.py` e dallo strato 2 contro i pin di oggi; non li ho rilanciati io.
**Firme.** Nessuna per girare. Dopo i numeri, a Claudio: (a) se T2/T3 passano, la 771531 resta "sedia #1 candidata" (non e' una promozione: T5); (b) se T2 sfonda, la taglia va rivista prima di riattaccarla; (c) ricompilazione del binario di campo a HEAD con Guardian: **dopo** il trial (non si tocca `C:\FTMO` per 14 giorni).
**Rischio.** Sul campo: nullo. Operativo: guasto intermittente del tester (sez. 1.6).
**Cosa decide Claudio.** Ora solo "si' al tempo macchina"; la lettura T2-T4 e le sue conseguenze dopo.
**Agente.** Lettura: `collaudatore-prop` (misura di rischio che decide una sedia). Cancello: `controllo-preventivo`.

---

### AZIONE 2 -- `770101` DAX Apertura: il contratto d'INVERNO e la firma B10

**Candidato.** `ABTG_DAX_Apertura_EU` M5 D30EUR LONG retest, magic 770101 (nel preset FTMO: GER40.cash, `InpSessionHour=10` = 10:00 FTMO, rischio del preset 2,00%) [LETTO].
**Certificato a 5 punti.**

| punto | stato | numeri |
|---|---|---|
| 1 PF | SI | contratto OOS 1,39709 / IS 1,12634; **193 pos** OOS (270 deal), **132 pos** IS [LETTO `CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.63] |
| 2 n e DD | n SI in OOS; DD OOS **7,2328%**, IS 5,4362% a rischio 1%; a 2,00% del preset = 14,47% (sopra il 10% statico) [LETTO r.63/421; il x2 e' la convenzione di casa, DERIVATO] | |
| 3 uscita | SI sul long: `TrailMode`, `TP1_R`, `BEatR`, `TrailStartR` (R270c/e, R201A, R202B, R46a); `InpCloseHour` 11/13/15/17 (PRV_DAXAP_02, 01/10): **il default va bene**, G0 identica al centesimo | [LETTO] |
| 4 gemelli | F40EUR **FAIL** (r138a: PF OOS 0,76965, DD 11,82%) | registro r.114 [LETTO] |
| 5 TF | **NON ANCORA MISURATO**: `R140c` (M15) scritto, "esito non letto"; M5: stop mediano 74 idx = 56x su spread P95 1,33 (ora 10), ma il 30,5% delle posizioni sta sotto 53,2 idx | `PARAMETRI_DAX_APERTURA_2026-10-01.md` [LETTO] |
| OROLOGIO | il contratto **mescola due orologi**: nei mesi d'inverno il backtest armava un'ora prima della cash (PF 1,48 sfasato contro 1,27 allineato, finestra 2025.06-2026.06; 126 su 270 uscite sfasate = 47%) | `OROLOGIO_BCM_2026-09-24.md` §5.1.1 [LETTO] |

**Il numero nuovo (gia' in repo, non ancora riscritto come contratto).** `report/LETTURA_R246_INVERNO_2026-09-29.md`: serie ricostruita **come la vedrebbe FTMO** (d0 estate UE + d+1 inverno UE, 457 feriali) per il DAX 770101: **PF 1,143, 295 posizioni, DD saldo 9,50% a rischio 1%** contro 6,06% del d0 tutto l'anno; frequenza d'inverno alla cash **0,627 pos/g** (d+1) contro 0,764 (d0 d'inverno) e 0,662 (d0 d'estate); serie complessiva 295/457 = **0,646 pos/g** [DERIVATO] contro 0,699 promessa. Le due stagioni stanno sopra 1,10 (d+1 inverno 1,184 su 138 pos; d0 estate 1,108 su 157 pos): la serie non e' tenuta in piedi da una stagione sola. Ma la serie e' **[INFERITA]** (calendario UE per FTMO, feed BCM, rischio 1 invece di 2, Guardian assente, un solo regime), sono **2 inverni**, il d+1 ha 138 posizioni (sotto 150).
**Cosa manca.** (i) Riscrivere il **contratto** del 770101 con questi numeri (DD e frequenza promessi: prerequisito del criterio di uscita del 18/08). (ii) La **peggior giornata** della serie "come FTMO" (il referto da' il DD saldo, non la peggior giornata): dai per-trade `risultati_archivio/ROUND_R246_INVERNO_2026-09-29/PERTRADE/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_794615/6/65/66.csv` [MISURATO: esistono]. (iii) Se la firma **B10** (`InpTP1_ClosePct` 50->0: PF OOS 1,49140, DD 6,2719% = 12,54% a 2,00%, 193 posizioni; `CONTRATTI` r.391; "batte in 4 misure su 4") regge anche con l'orologio d'inverno: **mai misurata d'inverno**.
**La misura.** (i)+(ii): zero macchina, Python sui per-trade gia' in repo (`mc_challenge_ftmo_allineati.py` e `r246_giudizio_d1.py` esistono; il Monte Carlo a mesi allineati e' gia' stato fatto il 24/09, `MC_MESI_ALLINEATI_2026-09-24.md`). (iii): clone di R246 inverno sul solo 770101, `InpTP1_ClosePct` 50 / 0 x finestre A e B, d+1 d'inverno con `@ORARIO_INVERNALE` (classe 763 risolta, "non ancora scritta") = ~4-12 passate.
**Attesa scritta prima.** (i) DD "come FTMO" a 1% >= 9% e PF >= 1,10 (come nel referto: 9,50% / 1,143). (iii) ClosePct 0 mantiene il vantaggio sul DD (circa -1 punto a 1%) e un PF d+1 d'inverno >= quello con ClosePct 50 (1,184).
**Contro-esempio (prima).** (iii) Se PF(d+1 inverno, ClosePct 0) < PF(d+1 inverno, ClosePct 50) o il DD sale, B10 e' un artefatto dell'orologio misto e **non si firma**. (i) Se la serie "come FTMO" fosse tenuta in piedi dai soli d'inverno (o dai soli d'estate), il PF di una stagione sarebbe < 1,10: non lo e' (1,184 / 1,108).
**Costo macchina.** (i)+(ii): 0. (iii): 4-12 passate = 1-18 min. **Firme.** (1) **Orologio delle sedie a ora fissa entro il 25/10** (DAX 26/10; USA 02/11): lasciarle "come il backtest" (BCM d'inverno armano 1h prima) oppure riportarle alla cash; le sedie FTMO armano gia' alla cash d'inverno [se FTMO segue il calendario UE: NON verificato]. (2) B10: pronta, e' una firma sua. **Nota che la decisione deve avere davanti**: d'estate il pre-cash sul DAX ha perso (PF 0,774 contro 1,108, DD 14,05% contro 5,55%); il vantaggio del pre-cash sta nei due inverni misurati. (3) La **taglia** resta sua: a rischio 1% il DD "come FTMO" consuma il 95% del 10% statico; a 2,00% la cifra "non si deriva" (`LETTURA_R246_INVERNO` §3), e il contratto vecchio e' gia' 14,47%.
**Rischio.** Nullo ((i)-(ii) senza terminali); (iii) come azione 1.
**Cosa decide Claudio.** Orologio (25/10), B10 si'/no, e se `770101` si riattacca al trial dopo il ~15/10 (oggi [NON VERIFICATO] se e' attaccata).
**Agente.** `collaudatore-prop` per (i)-(iii); `architetto-prop` riscrive la riga del contratto in `CENSIMENTO_CONTRATTI`.

---

### AZIONE 3 -- Bulge v5.20: prima la cella in campo (BULGE_M1), poi R92b solo se serve

**Candidato.** `ABTG_Bulge` v5.20, H1, cesto forex (22 cross sul piccolo, magic 772700; 15 cross sulla trial, magic 772720, "solo viola"). E' la sola famiglia veloce in campo: **10 posizioni su 13** del trial (-1.870,73, media -187,07; GBPNZD +1.810,41 su 4 posizioni, senza -3.681,14 [DERIVATO da `docs/RISPOSTA_A_GEMINI_2026-10-03.md`]). Contratto: **non esiste** (nessun IS/OOS; backtest dichiarato nel sorgente r.27-39: WR 80,22%, vincita media +131,63, perdita media -325,39, n 268, rischio 3%, dati al 40%, altro cesto) [LETTO `PACCHETTO_BULGE_ORB_TRIAL` §7.4]. Forward dell'antenato solo viola sul piccolo: n=50, PF 0,6949; 297 trade a -1.158,06 fino al 08/06 [LETTO `TRIAL_SFORTUNA_O_EA` §0.2, `HANDOFF` 29/09].
**Certificato a 5 punti.** PF: nessuno a lungo (n=106 solo sulla cella base R92 OHLC). n e DD: nessuno. Uscita ad asse: no. Gemelli (i 7 cross fuori dai 15): no. TF: solo H1. Regime: nessuno. Passo 0 (profondita' barre dei 22 cross): **fatto** (`risultati_archivio/MISURA_STORICO_CROSS22_2026-09-29/`). Il primo tentativo di R92b (30/09) e' fermato dal controllo R92b0 (CSV assenti, tester guasto: `ROUND_R92B_2026-09-30`).
**Passo 3a, costo zero.** Contare nel forward esistente (`data/statements/trades_auto.csv`: 24 righe v5.20 magic 772700, 297 dell'antenato 20250001; piu' le 10 del trial) (a) gli **ingressi entro 300 s nello stesso fattore** e (b) i giorni con >=2 stop pieni entro 10 minuti, **etichettati per fattore con segno** (sez. 4). Attesa scritta prima: con questi n **non decide niente**; da' un denominatore alla domanda. Contro-esempio: permutare gli orari d'ingresso entro la stessa ora (stessa composizione di cross) e contare le coincidenze attese: se le osservate stanno dentro il 95% delle permutazioni, e' rumore.
**Passo 3b, la misura (e il suo costo e' piu' basso di R92b).** `backtest_pipeline/prove/BULGE_M1_cella_campo_lunga.txt` (scritto oggi da un altro agente, **non ancora committato**): la **cella che e' in campo sulla trial** (VIOLA solo, Blu e ADX spenti, 15 cross, `Risk_Percent`/`Max_Trades` del preset trial copiati senza scelta), Modello 1 (screening), finestra 2010.01.01-2026.06.30 (IS 2010-2021, OOS 2022-2026.06), **4 passate**, costo [DERIVATO da loro] **15-60 min**; criteri S1 n>=150, S2 PF OOS>=1,30, S3 WR>=65% e profitto>0; **PF OOS < 1,05 = "nessun edge in screening: niente griglie sull'ingresso" (regola 19/08)**; 1,05-1,30 = zona grigia, si apre solo la gestione dell'uscita. Attesa dell'autore: PF OOS 0,80-1,05, WR 70-77%, DD OOS 8-25% alla taglia 0,80%, perche' le tre misure 2026 su questa famiglia stanno sotto 1 (Modello 1 VIOLA 15 cross PF 0,79 n=128; AMPIA 22 cross 0,85 n=773; forward antenato 0,83, lordo di commissioni e swap 0,92) [LETTO dal file]. Contro-esempio dell'autore: se e' il motore di Claudio (PF 1,60, WR 80%), la banda e' falsa e PF OOS >= 1,30: le due bande sono disgiunte.
**Passo 3c, condizionato.** R92b (firmata da Claudio il 29/09, `report/FIRME_2026-09-29_BULGE_R92B.md`: 24 celle di meccanismo + 1 controllo `Signal_Bar_Offset=0` che deve ridare n=106; stessi criteri, DD<=10%, stop>=40x, centro dell'altopiano, A3 10,5%) **solo se 3b cade in zona grigia o sopra**. Se 3b da' PF OOS < 1,05, R92b diventerebbe una griglia di filtri su un motore senza edge in screening: **contraddice la regola del 19/08 e va sospesa o ridotta ai soli assi di meccanismo con una prova di regime**. Costo R92b: proiezione 94,98 min (`RIEPILOGO_ROUND_R92b.txt`, "proiezione dal controllo", calcolata su un controllo poi fallito: ordine di grandezza) + ~11 min di riprove (P=17% su ~50 gambe x ~80 s) [DERIVATO].
**Attese mie, in aggiunta.** (1) Il controllo `Signal_Bar_Offset=0` / il G1 gemello devono tornare (altrimenti banco rotto). (2) Probabilita' che la cella in campo passi **tutti** i cancelli: **bassa** [INFERITO: l'antenato ha PF 0,69 in forward; l'80% di WR a payoff 0,40 R chiede p>=0,71 per pareggiare]. (3) I cross NZD pesano piu' del loro numero (AUDNZD, NZDCHF, GBPNZD, NZDCAD: -731 su un totale di -448, n=6-8 per cross, `BULGE_PICCOLO_PER_CROSS_2026-10-01.md` r.33 [LETTO]): in R92b dev'essere visibile **per cross su anni**.
**Contro-esempio (prima).** Se nelle misure per cross i NZD non sono peggiori dei non-NZD a parita' di n (IC 95% che include la stessa media per posizione), l'indizio dell'01-02/10 e' rumore e **nessun cap di fattore e' giustificato dal Bulge**. Se invece escludere un cross migliora il PF solo in IS, e' selezione che insegue il rumore (centro dell'altopiano, mai il picco).
**Costo macchina.** 3b: 15-60 min; 3c solo se serve: ~95-106 min. **Bersaglio**: finestra PowerShell sul PC di backtest DESKTOP-H4D7CAJ (terminale banco come in azione 1; MT5 chiuso, nessun EA attaccato; guardia nella riga); **magic nuovi o cache del tester svuotata** (scelta sua, `R92BAB_LETTURA`: "cache non svuotata: decide Claudio"). **Firme.** Via libera al tempo macchina (e magic/cache); i criteri sono gia' firmati; **nessuna firma sul Bulge in campo**. **Rischio.** Nullo sul campo; il PC fa girare un tester che e' guasto al 17% per gamba (il driver con RIPROVA riprova una volta). **Cosa decide Claudio.** Se 3b parte (questa notte o quando e' al PC) e che il Bulge in campo nel frattempo **non cambia** (regola dei 14 giorni); poi, sui numeri, la taglia del Bulge (tetto attuale `Risk_Percent` x `Max_Trades` = 3,0-3,2%) e se R92b serve ancora.
**Agente.** 3a: `collaudatore-prop`. 3b/3c: `collaudatore-prop` per la lettura; il file prova e' dell'agente che lo sta scrivendo e passa dal cancello.

---

### AZIONE 4 -- Gemelli di `771531` a tick: EMAGEM_a/b/c

**Candidato.** `ABTG_EMA200`, **la stessa cella della sedia** (O1 0,20 / O2 0,30, SLatr 1,0, TP_RR 2,0, TP1Pct 50, BE e trailing accesi, due lati, rischio 1,0) su D30EUR e NASUSD, asse unico il TF (M30, H1, H2, H3, H4). Commit `2fe2e26b` (03/10): `prove/EMAGEM_a_ancora_U30USD_H1_LS.txt` (cancello T1: riproduce IS 1,20110 / OOS 1,52365 al centesimo; magic 766801/766802; 4 passate), `EMAGEM_b_D30EUR_LS_tf.txt` (magic 766811; 10 passate), `EMAGEM_c_NASUSD_LS_tf.txt` (magic 766821; 10 passate); `controlla_prova.py` 0 problemi e `controlla_riga.py --oggetto prova` nessun difetto meccanico, secondo strato **non ancora fatto** [LETTO].
**Cosa chiude.** La casella 4 del certificato di `771531` ("gemelli") **a tick sulla cella intera**: oggi D30EUR/NASUSD hanno solo il corto a tick (R234b/c, morto o escluso per costo) e screening OHLC. NASUSD H4 e' la cella 5 del file c: **chiude anche l'unico buco della matrice gemelli** (`scan_ABTG_EMA200_H4_NASUSD.csv` non esiste).
**Attese scritte nei file (dell'autore, prima dei numeri).** H1 su DAX e Nasdaq: OOS PF 0,70-0,95 (centri 0,82 e 0,80), DD OOS 8-16%, n 450-1.100 deal (DAX) e 400-800 (Nasdaq); M30 PF < 1; H2-H4 non letti per il merito (IS ~130/40/30 deal). **Smentita (T6 congelato)**: H1 o H2 con OOS PF >= 1,10, OOS n >= 300 deal, IS PF >= 1,00 e DD OOS <= 10% -> la cella non e' "del Dow" per quel simbolo e entra in coda come CANDIDATA gemella (mai in campo in automatico). Se nessuna cella ha OOS n >= 300: "NON ANCORA MISURATO PER IL MERITO". Il costo: a H1 la cella e' al massimo FRAGILE al 40x (DAX 41,2x/25,9x, NASUSD 44,6x/33,4x su mediana di sessione/24 mediane [DERIVATO da loro]): "il round serve a chiudere la casella, non a trovare una sedia".
**Mia attesa, coerente.** Il lato forte dei tre indici a H4 e' il long (sez. 1.3: schema "segue il toro"): **probabilita' di una sedia da questo round: bassa** [INFERITO]. Cio' che il round fa, a basso costo, e' togliere un "non misurato" dal certificato della sola sedia schierabile.
**Contro-esempio (prima).** L+S non e' L+S additivo (un long aperto impedisce uno short: i lati si escludono, `ABTG_EMA200.mq5` r.322): il lato debole non va interpretato da solo. Se il long fosse verde anche in IS e nella discesa, la "deriva" non sarebbe l'unica spiegazione.
**Costo macchina.** 24 passate: **8-34 min** (loro: base 11-34 s/passata sul Dow x tick relativi; tetto 1,41 min/passata dalla media dei 13 round del 23/09) [LETTO]. D30EUR 35,4 M tick (0,52x il Dow), NASUSD 166,5 M (2,46x). **I tre file nella STESSA riga, a per primo, con `-Deposito 100000`** (il driver non ha `@DEPOSITO`: a 10.000 il lotto si tronca e T1 fallirebbe) [LETTO]. **Bersaglio**: PC di backtest, come azione 1.
**Estensione condizionata, solo se una cella H2-H4 sopravvive** (mia): prova di regime su `NASUSD_EXT` (2010.11.14-2026.07.31; importato e ammesso alla sola prova di regime dalla firma 26/08 "FIRMO FRIGO NASUSD"; parametri CONGELATI, mai promozione) = 6-8 passate OHLC. Il DAX esterno (GRXEUR 2010-2018, 1.718.805 barre M1) esiste ma **non e' importato**: l'import e' una decisione sua, non stimata [NON MISURATO]. Il Dow esterno non esiste.
**Firme.** Nessuna per le 24 passate. **Rischio.** Nullo sul campo. **Vincolo FTMO da tenere:** i tre indici sono lo stesso cluster e il divieto di hedging fra conti conta anche gli strumenti correlati (risposta 25/09 punto 4): un gemello indice si decide insieme al piccolo.
**Cosa decide Claudio.** Se le 24 passate partono nella stessa sessione dell'azione 1; e, se qualcosa sopravvive, l'import DAX_EXT.
**Agente.** Lettura: `collaudatore-prop`; cancello strato 2: `controllo-preventivo`.

---

### AZIONE 5 -- La toppa classe 294 (su copia di BANCO) e PRV_DAXAP_01

**Candidato.** `ABTG_DAX_Apertura_EU` (770101 long retest, 770105 short retest, stesso binario). Il difetto (classe 294, `report/FIRME_2026-09-12.md` §2): sul rifiuto di `SpreadOK()` -- e, per il cancello del 01/10, anche dei filtri `InpMinRangePts`/`InpMaxRangePts` -- `ArmRetest()` fa `return(true)` e la fase passa ad ARMED con `gBuffer=0`: la giornata **non salta**, entra con la soglia abbassata di 5 punti e senza filtro di tendenza. E' **dormiente** perche' in campo le tre guardie valgono 0 in tutti i preset [LETTO]. **Accendere `InpMaxSpread` oggi renderebbe la sedia piu' aggressiva proprio quando lo spread e' alto.**
**Cosa sblocca.** (a) PRV_DAXAP_01 (`InpMaxRangePts` 0/50/100/150/200/250 idx sul 770101 long): 12 passate x ~11 s = **~2,2 min** [LETTO]; (b) la firma di `InpMaxSpread`, la leva sul rilievo del 01/10: il 770411 arma nell'ora 09 FTMO (09:59), spread P95 2,33 idx contro 1,33 dell'ora 10, `67,75/2,33 = 29x`, sotto 40x a quel minuto [DERIVATO da `PARAMETRI_DAX_APERTURA`; vale per la coda dei fill precoci, non per la sedia]. Nota: `InpMaxSpread` e' dentro `ABTG_DAX_Apertura_EU` (770101/770105); il 770411 e' un altro EA.
**Attesa scritta prima (dai file).** "Il default va bene" (A5). `cap150` taglia 10 posizioni OOS (netto -1.544) e 8 IS (+1.094): **segni opposti = ribaltamento atteso**. H-TAIL (PF IS e OOS salgono >=0,05 in entrambe le gambe a 150 e 200) e' il contro-esempio.
**Il mio giudizio sul valore.** Basso come misura di merito [INFERITO]; medio come **igiene** (leva sul costo, difetto latente chiuso). E' per questo che e' quinta.
**Firme.** Toppa sul **sorgente vivo** (`mql5/Experts/ABTG_DAX_Apertura_EU.mq5`) = firma di Claudio, e agisce in campo solo dopo ricompilazione dei terminali (non durante il trial; il binario in campo e' CLAU12 di agosto, diverso da HEAD). **Copia di banco con la toppa, mai in campo** = nessuna firma, solo cancello. **Proposta: copia di banco ora; toppa sul vivo dopo il ~15/10 con tutte le ricompilazioni insieme.**
**Costo.** ~2,2 min (tetto 18 min) + il lavoro dell'EA developer (non ore macchina). **Bersaglio**: PC di backtest (come azione 1); nessuna riga nuova se si riusa il driver con RIPROVA. **Rischio.** Nullo con la copia; sul vivo, la ricompilazione dei terminali (dopo il trial) rientra nella regola dei terminali multipli.
**Cosa decide Claudio.** "Copia di banco si'/no" e "toppa sul vivo dopo il trial si'/no".
**Agente.** `mql5-ea-developer` (toppa), `controllo-preventivo` (cancello), `collaudatore-prop` (lettura).

---

## 4. IL FATTORE NZD E LA DIVERSIFICAZIONE DEI CLUSTER: cosa si puo' fare ORA e cosa no

**I fatti** (da `docs/RISPOSTA_A_GEMINI_2026-10-03.md`, rilettura del cancello; i versi sono derivati da me dai lati scritti).

| ingresso (server FTMO) | coppie | verso | esposizione NZD (derivata) | esito |
|---|---|---|---|---|
| 01/10 06:00:00 (stesso secondo) | GBPNZD sell + NZDCHF buy | sell GBPNZD = vendi GBP, compri NZD; buy NZDCHF = compri NZD | **long NZD + long NZD: stesso verso** | NZDCHF -1.389,09 |
| 02/10 16:00:00 (stesso secondo) | GBPNZD buy + NZDJPY buy | buy GBPNZD = compri GBP, vendi NZD; buy NZDJPY = compri NZD | **short NZD + long NZD: versi opposti, netto ~0** | NZDJPY +115,00 |
| 02/10 13:00 e 15:00 (uscite 15:30:00 e 15:30:06) | EURNZD buy, GBPAUD buy | compri EUR/vendi NZD; compri GBP/vendi AUD | **short NZD + short AUD: stesso fattore (dollari antipodei)** | -1.204,96 e -1.177,70 = -2.382,66 = 1,49% di 160.000 |

Il filtro "300 s per cluster" rifiuterebbe il secondo ingresso di ciascuna coppia: +1.274,09 netti sul trial = +1.389,09 (coppia 1) - 115,00 (coppia 2) [DERIVATO, n=2: nessun valore di merito, come scrive la verifica].
**Conseguenze, in ordine di certezza.**
1. **Il cap di cluster C2 del Guardian non puo' esprimere un fattore con segno.** Somma `LossIfStopHit` per simbolo membro, direzione ignorata (sez. 1.5): una coppia long-NZD + short-NZD **si somma** invece di compensarsi. Valorizzare C2 con una lista NZD/AUD (il jolly `NZD*` prende solo i prefissi: la lista va elencata) avrebbe fermato la coppia 2 del 02/10 (coperta) esattamente come la coppia 1 (stesso verso). Serve **rischio netto per valuta** (somma con segno): una **funzione nuova**, non "una manopola da valorizzare" [INFERITO dalla lettura del Guardian; non ho letto il codice dei 70 EA].
2. **Anche se ci fosse, nessun EA lo legge** (0 chiamate con `cluster_mappa`). Per il Bulge servirebbe una modifica al Bulge stesso (tetto oggi `Risk_Percent` x `Max_Trades`; `Total_Risk_Percent` e' inerte con `Risk_Mode=0`, classe 1006) o al Guardian piu' ricompilazione. **Nessuna delle due si fa durante il trial.**
3. **Quello che si puo' fare ora a costo zero** e' il passo 3a dell'azione 3, con la definizione di fattore **con segno** scritta prima: se non esce nulla di piu' dell'atteso sotto indipendenza, il cap e' inutile; se esce, 3b/3c daranno il DD di fattore a livello di contratto.
4. **Diversificazione reale oggi**: due indici (DAX, Dow) piu' il Bulge forex; l'oro e' fermo da vincoli FTMO (hedging fra conti con le sedie oro dei demo, pausa oro da firmare: `SEDIA_ORO_LONG_FTMO_BOZZA_2026-09-27.md`) e dai numeri (oro solo long: 22 anni PF 1,096 con DD 10,30% a rischio 0,5%, fuori dal 10%, `CANDIDATI_TRIAL_PF115` R1). Nessun gemello EMA200 e' una sedia pronta. **Non c'e' oggi una seconda classe di rischio con un contratto**: e' il motivo per cui l'azione 3 vale piu' del suo costo.

---

## 5. FUORI CLASSIFICA: i sei "scartati per frequenza" e le altre piste

| candidato | stato corretto a oggi | cosa misurerebbe | costo | perche' non e' tra le 5 |
|---|---|---|---|---|
| R7 `Power Hour Money Strategy` + `ICT Opening Gap [Momentum1]` | sorgenti **mai aperti** [LETTO] | se passano il §4 (stop vero, niente griglia/martingala, due lati) | **1 ora di lettura, 0 macchina** | massimo ritorno per ora spesa se cadono al §4, ma ~1 occasione/giorno per simbolo, nessun PF, nessun DD: non avvicina una sedia entro il trial. **Da fare in parallelo a costo zero**, agente `cacciatore-strategie` |
| R3 `IU Gap Fill / riconquista` | non misurato; file prova scritto, **sonda .mq5 da scrivere**; il ramo "riconquista fallita -> SELL" da' DAX/Dow short in apertura (buco "lato short") [LETTO] | quota di sedute con gap >=0,2% e riconquista | sonda ~mezza giornata [LETTO] + scrittura dell'EA sonda | il fenomeno gap sul Nasdaq e' a segno rovesciato (sez. 1.4); la clausola FTMO sul gap trading (risposta 29/09 punto 5: vietato aprire <=2h prima di una chiusura >=2h attorno a eventi annunciati) non blocca la riapertura ma resta da leggere per ogni sedia |
| R5 `M0PB` | **non e' morto**: F1 decaduta il 07/09, 5 celle su 12 passano H8 (RR>=0,70), famiglia **1,516 op/g** (supera il pavimento da sola), DD/PF/peggior giornata **zero misure** [LETTO] | EA nuovo + round a tick | **giorni, non ore** [LETTO] | il piu' promettente come frequenza, il piu' costoso; stop su NASUSD M5 42-64 pt (vicino alla frontiera di lavoro 64-72) |
| R6 `RSI Ea MT5` | non misurato; `MaxOpenPositions=1` | sonda di conteggio `RSI(14)` rientro sopra 20, per simbolo | una sonda + porting | frequenza ignota; servirebbero 7 o 22 simboli |
| R4 M27 overnight | **CHIUSO 12/09: rischio** (sez. 1.4) | -- | -- | non va riletto come "mai misurato": il certificato esiste |
| R2 gap cash | passo 0 fatto 07/09: segno rovesciato su NASUSD; 0,14 op/g per simbolo, 8 simboli per 1,00 | resta da fare su DAX/Dow/SPX | minuti per simbolo | un simbolo morto per segno; 4 indici fanno 0,56 op/g |
| R1 `SuperWave DAX H4` (770512) | raccomandazione ritirata 08/09 (DD a 1,00%, lotto minimo sul piccolo) | peggior giornata e due lati della cella `StMult 3,0 / TP_RR 2,0` | un round corto, EA gia' compilato | n=56, 0,12 op/g; la famiglia SuperWave non arriva a 1,00 neanche con lui (0,80) |

**Ordine consigliato per il sacco dei sei (non e' una proposta di round):** R7 (0 h) -> sonda R3 -> sonda R6 -> R5. Il pavimento di frequenza e' per famiglia (firma 07/09): una sedia sotto 1,00 non e' piu' scartabile per sola frequenza, ma **non entra in campo in automatico**.
**Altre piste lette e lasciate fuori, col motivo.** `EMA200 H4/D1 su 28 coppie forex` (criteri congelati 03/10, errata 1 `0205a221`): e' una misura di FENOMENO per il piano manuale di Claudio, non una sedia (nessun PF, nessuna taglia; "non dice nulla sulle sedie `ABTG_EMA200`"); il rimbalzo H1 "quasi sempre" e' gia' escluso su DAX/oro (P primaria 0,403-0,545, IC alto max 0,622, 01/10) [LETTO]: e' **ponteggio**, va dichiarato tale. Oro solo long, EMA200 H4 GBPJPY, EURUSD corto (`CANDIDATI_TRIAL_PF115` "con riserva"): nessuno ha n>=150 e PF OOS >=1,15, costano un round ciascuno e non danno una seconda classe di rischio meglio del Bulge.

---

## 6. DECISIONI DI CLAUDIO, IN ORDINE DI URGENZA

| # | decisione | scadenza | se non decide | costo |
|---|---|---|---|---|
| 1 | **Orologio delle sedie a ora fissa d'inverno** (DAX 08:00 BCM, USA 14:30 BCM; `770101`, `770411`, `770202`, `770250`, ORB 770611...) | **25/10** (DAX 26/10, USA 02/11) | le sedie BCM armano 1h prima dell'apertura cash; il contratto d'inverno non e' riscritto | firma, 0 macchina |
| 2 | Via libera ai round sul PC di backtest (e superamento della decisione "A" del 29/09: sabato senza round) | oggi | le azioni 1, 3, 4, 5 non partono | solo crediti |
| 3 | Controllo a vista: `770101` e `771531` sono attaccate su `C:\FTMO` (conto 1514806751)? | oggi | le inferenze sul trial restano sospese | un'occhiata |
| 4 | Bulge: via libera a BULGE_M1 (15-60 min); magic nuovi o cache del tester; R92b solo dopo | prima del lancio | il Bulge resta senza contratto; il 02/10 ha gia' fatto -2.382,66 in 6 secondi (due posizioni) | firma sul tempo |
| 5 | B10 (`InpTP1_ClosePct` 50->0 su 770101) | dopo l'azione 2 (iii) | il contratto resta a PF 1,397 / DD 7,23% a 1% | firma |
| 6 | Toppa 294: copia di banco ora, vivo dopo il trial | prima di PRV_DAXAP_01 | il tappo sullo spread non e' firmabile | firma |
| 7 | Import DAX_EXT come prova di regime (solo se una cella H2-H4 dell'azione 4 sopravvive) | -- | -- | mezza giornata [NON MISURATO] |
| 8 | Quali dei sei ripescati entrano in coda e con che priorita' | quando vuole | restano in coda senza priorita' | -- |

---

## 7. COSTO TOTALE SUL PC DI BACKTEST (DESKTOP-H4D7CAJ)

| azione | passate | metro di casa (`0,6 + 0,077 x p`) o stima dell'autore | tetto |
|---|---:|---:|---:|
| 1 (771531, LATI_A1/A2) | 8 | 1,2 min (stima 12/09: ~3) | 24 min |
| 2 (iii) 770101 d+1 inverno | 4-12 | 0,9-1,5 min | 18 min |
| 3b BULGE_M1 | 4 | 15 min (derivato dall'autore) | 60 min |
| 3c R92b (condizionato) | 25-26 | 94,98 min (proiezione) | ~106 min con riprove |
| 4 EMAGEM_a/b/c | 24 | 8 min | 34 min |
| 5 PRV_DAXAP_01 | 12 | ~2,2 min (11 s/passata) | 18 min |
| **totale senza 3c** | ~52-60 | **~27 min** | **~2h35** |
| **totale con 3c** | ~78-86 | ~2h (**~122 min**) | **~4h20** |

Le passate sono quelle dei file/round gia' descritti, non una griglia nuova. Il metro di casa e' calibrato sulle passate a celle veloci del Dow (4,7 min per 16 passate, R112): sul Bulge (15-22 cross) non vale e uso le stime dei file. **Le stime sono intervalli, non misure** [NON MISURATO].

---

## 8. COSA NON HO POTUTO VERIFICARE

1. Se `770101` e `771531` sono **attaccate e vive** su `C:\FTMO` (la sonda legge il profilo salvato, sez. 1.1).
2. Se il tester del PC e' sano **adesso** (ultimo dato: R92BAB del 01/10 sera, 2/12 gambe morte; DAXAP03 del 02/10 00:04 senza gambe morte).
3. Se i 4 file `LATI_A*` superano ancora `controlla_prova.py` e lo strato 2 con gli EA di oggi (scritti il 09/09; l'`ABTG_EMA200.mq5` sul PC e' del 21/09).
4. I **tempi macchina**: tutti derivati (metro di casa, tetto prudente, proiezione R92b calcolata su un controllo fallito, stime dei file di altri agenti). Il conto "8 passate" dei LATI contro "16 P" del censimento non si riconcilia.
5. La **persistenza** del per-trade IS dell'EMA200 Dow (`cemad02` ha scritto le 132 posizioni, ma l'IS di un magic viene sovrascritto dall'OOS): non ho trovato in repo un per-trade IS dell'EMA200 Dow; quindi **non ho proposto di ri-spaccare lo split** (Emendamento A: lo split si sposta solo con il numero in mano).
6. Che il calendario di FTMO segua l'**ora legale europea** d'inverno (assunto in `OROLOGIO_BCM`, "[NON VERIFICABILE]" sulla settimana 26/10-30/10).
7. Il **verso e il fattore** delle coppie NZD li ho derivati dai lati scritti nella verifica (sell/buy); non ho riaperto il report del trial (`data/statements/`) e non ho letto il codice dei 70 EA.
8. Se le regole della **Free Trial** coincidono col 2-Step (limite giornaliero, reset): [NON VERIFICATO] (`TRIAL_SFORTUNA_O_EA` sez. 0.8).
9. I **risultati** di `TRIAL_SFORTUNA_O_EA_2026-10-03.md`: ho letto solo la sezione 0 (criteri congelati); le sezioni A-F e gli script `trial_sfortuna_o_ea.py` / `lettura_trial_senza_aperte.py` sono file non tracciati di un altro lavoro e non li ho toccati.
10. `BULGE_M1_cella_campo_lunga.txt` e' **non committato**: i suoi numeri (attese, 15-60 min) sono [LETTI] cosi' come stavano; il dossier che cita (`report/BULGE_COME_MIGLIORARLO_2026-10-03.md`) **non e' ancora in repo**. `EMAGEM_a/b/c` sono committati ma senza strato 2, e **EMAGEM_b/c risultano modificati nell'albero di lavoro (non committati) mentre scrivevo** (correzione di numeri di screening, classe 1086): le attese e i costi che cito sono quelli del commit `2fe2e26b`.
11. `PIANO_PROP.md` e' fermo alla v22 del 13/09: **non l'ho aggiornato** in questo giro (questo piano e' mirato; i giri di aggiornamento della tabella madre restano da fare).
12. Nessuna fonte esterna riletta: i numeri di Quantpedia, MQL5, paper citati nei documenti letti sono [LETTO], non riverificati. I CSV R234a-c, R208a, R146b, R147a non sono in repo: i loro numeri sono quelli dei referti.

---

## 9. COSA MANCA E CHI LO PORTA

| buco | agente | domanda esatta |
|---|---|---|
| prova di regime e DD in discesa della 771531 | `collaudatore-prop` | "Esegui LATI_A1/A2 al pin di oggi: qual e' il DD del LONG puro e della L+S nella discesa 2025.02.01-04.30 a rischio 1%, e T1-T5 passano?" |
| contratto d'inverno 770101 + peggior giornata della serie "come FTMO" | `collaudatore-prop` + `architetto-prop` | "Dai per-trade R246-inverno: peggior giornata, DD saldo e frequenza della serie come FTMO; riscrivi la riga del contratto 770101 con i due orologi separati" |
| 770101 inverno x ClosePct 50/0 | `collaudatore-prop` (file prova nuovo, cancello) | "B10 regge a d+1 d'inverno?" |
| conteggio NZD con segno sul forward | `collaudatore-prop` | "Coincidenze di ingresso entro 300 s per fattore con segno e giorni con >=2 stop pieni entro 10 min, contro permutazioni entro l'ora" |
| cella in campo del Bulge a lungo | agente autore di BULGE_M1 + Claudio (via libera) | "PF/WR/DD OOS 2022-2026 della cella viola a 15 cross: sopra o sotto 1,05?" |
| R92b | Claudio (via libera) | "Serve ancora dopo BULGE_M1? magic nuovi o cache?" |
| gemelli a tick | `controllo-preventivo` (strato 2 su EMAGEM) poi `collaudatore-prop` | "Passano il cancello? T1 riproduce la sedia?" |
| toppa 294 su banco | `mql5-ea-developer` | "Chiudi la giornata (PH_DONE) sul rifiuto di SpreadOK/MinRange/MaxRange in ArmRetest e ArmOpenConfirm, in copia di banco" |
| sorgenti R7 | `cacciatore-strategie` | "Power Hour e ICT Opening Gap passano il §4 e il C7 (due lati)?" |
| presenza 770101/771531 su C:\FTMO | Claudio | "Faccina sui grafici GER40.cash M5 e US30.cash H1 del 1514806751" |
| stato vivo di FTMO per l'orologio | `cacciatore-config-prop` | "FTMO segue l'ora legale UE sui server Free Trial/Challenge? Risposta scritta del supporto" |

---

## 10. CONTROLLI FATTI SUL PIANO STESSO (contro-esempi cercati prima di consegnare)

- *"Le due sedie piu' vicine sono davvero la 771531 e la 770101?"* Ho cercato chi altro ha n>=150 e PF OOS >=1,15 a tick fuori dalla flotta: `CANDIDATI_TRIAL_PF115` dice nessuno; ho ricontato i CSV degli scan (sez. 1.2) e coincidono con le tabelle di altri (U30USD H4 77/85, SPXUSD 75/86, D30EUR 54/92, lato forte long 30/30 e 32/32): numeri riprodotti da una seconda mano.
- *"Il mio primo piano proponeva di misurare i gemelli indici da zero."* Il contro-esempio e' arrivato dal repo: R234b/c e i tre EMAGEM di oggi c'erano gia' (e SPXUSD e' escluso per costo). Ho rifatto l'azione 4 sul lavoro esistente invece di duplicarlo.
- *"La coppia 2 del 02/10 (GBPNZD buy + NZDJPY buy) e' un caso di fattore comune?"* La lettura semplice e' stata **smentita**: i versi sono opposti. Per questo la sez. 4 chiede il segno e dice che C2 non basta.
- *"M27 e' ancora da misurare?"* No: chiuso il 12/09 per rischio; la riga dell'08/09 e' corretta in sez. 1.4 e 5.
- *"La coda e' la lista del da-fare?"* No: r136a-d e cemad02/05 sono commentati e hanno gia' CSV (sez. 1, coda).
- *"R92b e' il passo giusto per il Bulge?"* Non per primo: BULGE_M1 (4 passate) costa meno e puo' dire "nessun edge" prima di spendere ~95 min su una griglia di filtri (regola del 19/08).
- *"Il costo dell'azione 1 e' davvero minimo?"* La forchetta 1,2-24 min e' il peggior caso fra due documenti che non si riconciliano: dichiarato, non scelto il numero piu' comodo.
- *Processo*: questo file non contiene blocchi di codice eseguibili ne' righe di lancio: `controlla_riga.py` non e' applicabile; il passaggio dal `controllo-preventivo` e' **da fare** prima che le azioni diventino righe per il PC o per Claudio. Il piano e' una proposta: **nessuna azione e' stata eseguita**.
