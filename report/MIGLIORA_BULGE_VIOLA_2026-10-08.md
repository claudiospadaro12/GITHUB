# MIGLIORA BULGE VIOLA (08/10/2026) -- diagnosi, simulazione di carta, simboli e volatilita', piano delle misure

Decisione di Claudio, non negoziabile (08/10): _"OGNI TOCCO DOPO UN IMPULSO, COM'E' ORA"_. Il motore del VIOLA **non cambia**: nessun controllo del bulge, nessuna stretta dell'entrata. Si migliora **cio' che sta dopo l'entrata e attorno**: uscita, filtri di regime, simboli, TF, rischio di portafoglio, cluster/correlazione, orari/news. Mai la frequenza dell'entrata. Aggiunta di Claudio (08/10): _"se ci sono simboli che hanno statisticamente volatilita' migliori rispetto ad altri, cioe' che profittano di +"_ (sezione 3).

**SOLA LETTURA.** Nessun EA, preset, forward, conto o riga di lancio toccato. Nessun backtest eseguito. Tre script nuovi, di sola lettura sui file del repo: `backtest_pipeline/sim_bulge_viola_dati.py` (loader comune), `sim_bulge_viola_portafoglio.py`, `sim_bulge_viola_simboli.py`. Si riproduce tutto con `python3 backtest_pipeline/sim_bulge_viola_portafoglio.py` e `python3 backtest_pipeline/sim_bulge_viola_simboli.py` dalla radice (~11 e ~12 secondi); `--autotest` lancia solo gli autotest.

Etichette: **[LETTO]** file del repo, fonte citata · **[MISURATO]** calcolato dagli script qui sopra · **[DERIVATO]** conto da numeri scritti, mostrato · **[INFERITO]** ragionamento non verificato · **[NON MISURATO]** il dato non c'e'.

**Stato del cancello (Regola del 09/09 e protocollo 13/09).** Questo e' un dossier di lettura e piano, non una riga di lancio ne' un verdetto che archivia un candidato. Fatta l'autoverifica dello Sviluppatore (parte 8: autotest con risposta nota e contro-esempi, riconti incrociati con numeri gia' scritti da altri). **Lo strato 2 (`controllo-preventivo`) e il lettore indipendente NON sono stati invocati da me**: il piano della parte 6 non va lanciato, e nessuna domanda della parte 7 va mandata a Gemini, prima di quel PASS.

---

## 0. Risposta in dodici righe

1. **Il VIOLA com'e' ora e' sotto 1 su ogni misura nostra, anche lordo di costi.** Pool v5.20 (R92BAB VIOLA 190 + piccolo v5.20 VIOLA 31 su cross): n 221, **PF(r) 0,72**, vincita media 0,25 R contro perdita media 0,95 R, win rate **72,9% contro 78,9% di pareggio** [MISURATO]. Trial FTMO (19 posizioni VIOLA): PF(r) 0,40, -4.925,49 EUR. Antenato VIOLA (50): 0,68. Piccolo v5.20 (33): 0,47. Il solo numero buono (PF 1,599, n 268) e' di Claudio e **il suo xlsx non e' nel repo** [NON LEGGIBILE].
2. **I costi non sono il problema del VIOLA** (lo sono del Bulge BLU+VIOLA dell'antenato, 56%): sul VIOLA commissioni+swap valgono 8-23% della perdita netta e **il PF lordo e' gia' 0,43-0,75**. Tagliare costi non porta sopra 1 [MISURATO].
3. **La forma e' il problema**: la mediana BB dista in media ~0,7 ATR dall'entrata (vincita mediana 0,24 R, 90-esimo percentile 0,46 R, massimo 0,83 R, **zero vincite >= 1 R su 161**) con stop a 3 ATR. Cosi' BE a 1 R, trailing da 1,5 R e parziale a 1 R sono **inerti per costruzione**: casella libera, non provata [MISURATO + [DERIVATO]].
4. **Simulazione di carta sulle regole di portafoglio (parte 2): nessuna regola e' distinguibile dal caso in due fonti indipendenti.** 14 regole x 4 fonti. L'unico p<0,05 non corretto (cluster cap 1 firmato sul trial, +3,51 R, p 0,043) **cambia segno** sulle altre due fonti (v520 +0,92 R p 0,74; antenato -1,74 R p 0,94). Campione sottile: 19, 33, 50 posizioni.
5. **Simboli (parte 3): la volatilita' non spiega chi profitta.** Spearman volatilita' ATR/prezzo contro r medio per simbolo: **rho -0,01, p 0,98** (20 simboli); stratificato NZD/altro: rho -0,01. Dispersione fra i 22 simboli **p 0,97** (i simboli sono *meno* distinti di quanto il caso darebbe). Nessun simbolo passa la soglia congelata (p caso < 0,05/22): il migliore (USDCHF, 6 su 6 vinte, +0,26 R) ha p 0,073.
6. **Ma il test non vede effetti piccoli**: con ~10 segnali per simbolo un vantaggio lineare di 0,25 R fra i simboli si trova solo nel 43% dei casi (51/120 nell'autotest). Per vedere **+0,10 R** servono **~490 segnali per simbolo** (Bonferroni su 22; 255 senza), cioe' **~8,8 anni** a 56 segnali/simbolo/anno; per **+0,25 R** ~79 segnali (1,4 anni).
7. **L'unica traccia che merita una misura vera e' oraria**, non di simbolo: i VIOLA aperti 08-13 ora BCM (07-12 UTC) hanno r medio -0,51 (n 18, PF 0,15) contro ~0 negli altri blocchi (p 0,011 sulla dispersione dei 4 blocchi; 0,006 con un R unico per l'antenato: il numero e' sensibile all'unita'). Ma i blocchi sono stati scelti il 03/10 guardando l'antenato, l'antenato e' dominato da **un episodio** (5 stop il 13-15/04) e il trial non la conferma (-0,16, n 7). **Ipotesi, non esito.**
8. **La valuta NZD e' la peggiore** (-12,05 R su 69 posizioni, media -0,175 contro -0,073 del pool) ma il test "peggiore fra le 8 valute" da' **p 0,17**: coerente col caso.
9. **Cosa il repo non puo' dire e dove sta la risposta**: MFE/MAE, ora d'ingresso su R92BAB, ATR e spread dei 22 cross. Una sola copia di banco con telemetria + un solo script di sonda (parte 5) li chiudono tutti; costo macchina [STIMA] 15-60 minuti per cella.
10. **Prima misura da fare**: `BULGE_M1_cella_campo_lunga.txt` (gia' pronto dal 03/10, mai girato: nessuna cartella di risultati nel repo): 4 passate, 15 cross, 2010-2026.06, **15-60 min [DERIVATO]**, nessuna firma. Con la sua gamba OOS (n atteso 1.000-2.500) il test sui simboli arriva a ~70-170 segnali per simbolo, cioe' alla soglia del +0,25 R.
11. **La frequenza non e' piu' un mistero**: R92BAB fa 190 VIOLA in 41 giorni di borsa = **4,6 al giorno**; il piccolo v5.20 ne fa 5,5 al giorno. Il "salto di 5 volte" sull'antenato (1,0 al giorno) e' coerente con la correzione della barra 1 (v5.20), non con un regime [DERIVATO; la causa e' [INFERITA]]. Conseguenza utile: i 150 segnali arrivano in ~6 settimane di forward.
12. **Il Bulge non compare ne' in `REGISTRO_TEST.md` ne' nei censimenti del 09/09** (grep, zero righe): il certificato di morte non e' mai stato scritto. Verdetto resta **NON ANCORA MISURATO** (parte 1.8).

---

## 1. DIAGNOSI (ogni numero con la fonte)

### 1.1 Il motore VIOLA, come sta nel codice (v5.20)
[LETTO] `mql5/Experts/ABTG_Bulge.mq5`: blocco VIOLA in `CheckSignal` (r.1555-1580): `postBulgeLong = relImpDown >= 1 && relImpDown <= Lookback_Bars*2 && midAfterImpDown && !oppAfterImpDown && lows[iCnf] <= bbLowerCnf && lowerFlat && reactionLongCnf`; **nessun `isBulgeSig`** (usato solo da ARANCIO e BLU). Impulso = una barra direzionale con corpo >= 0,2 ATR che tocca la banda; finestra 40 barre H1 (`Lookback_Bars*2`); condizione di reazione `|corpo| <= 1,5 ATR` (VIOLA-EA). **Questa e' la decisione di Claudio: resta cosi'.** Dopo il segnale, nel codice:
- `OpenOrder` (r.1243): `HasOpenTrade(sym, comment)` (una posizione per simbolo e commento) e `CountOpenTrades() >= Max_Trades` (4 nel preset, **sul numero di posizioni dell'intero cesto**), `CalcLots` a rischio fisso `Risk_Percent` (0,8), SL = 3 ATR, TP = mediana BB, `ABTG_GuardiaIngresso` subito prima di `trade.Buy/Sell`.
- `UpdateAllTP` (r.1922-1964): riscrive il TP **ad ogni tick** sulla mediana della barra 1, solo se il nuovo TP e' oltre l'entrata e a >= 10 punti dal prezzo. Sul trial 6 TP riscritti su 10, **6 su 6 verso l'entrata** [LETTO, `BULGE_COME_MIGLIORARLO_2026-10-03.md` par. 2.5].
- Uscite spente di default: `Enable_Partial_Close`, `Enable_BE_1R`, `Enable_Trailing_R`. Kill switch `Use_Kill_Switch` (4 SL/giorno, 3 consecutivi, -2,0% del saldo; `KillSwitchEvaluate` r.965-1022 conta **qualunque** deal in perdita come SL). `Risk_Mode = RISK_PER_TRADE`. Filtro ATR `Use_ATR_Filter` (0,5-1,8 della media a 20): acceso nel preset trial, spento nell'AMPIA di R92BAB. News: `News_Block_Hours` in ore UTC fisse, spento.
- **TF cablato H1** (`iTime(sym, PERIOD_H1, 0)` in OnTick e in `CheckSignal`): un file con `@PERIODO M30` misurerebbe di nuovo H1 [LETTO, 03/10].

### 1.2 Le misure, riga per riga (nessun numero a memoria)
| Misura | n | PF | Altro | Regime / finestra | Fonte |
|---|---:|---:|---|---|---|
| Claudio, BLU+VIOLA, 6 cross, rischio 3%, dati al 40% | 268 | 1,599 | WR 80,22%, DD 10,17-10,35%, vincita +131,63 / perdita -325,39 | 2022.01.01-2026.03.30, nessun IS/OOS | `ABTG_Bulge.mq5` r.27-39; **xlsx non nel repo** [NON LEGGIBILE] |
| R92 (21/08), v5.10 col difetto della barra 0 | 106 su 22 cross (max 11 GBPUSD) | senza senso (n 1-11) | **0 simboli su 22** passano S1; ~1,07 op/simbolo/anno contro ~10,5 dichiarate | 2022.01-2026.06, Modello 1 | `R92_REFERTO.md`; **per-trade non nel repo** |
| R92b (30/09), v5.20, 22 cross, 26 passate | **mai girato** | -- | controllo R92b0 CSV assenti; `OnTesterInit works too long` | -- | `ROUND_R92B_2026-09-30*/` |
| R92BAB (01/10), v5.20 AMPIA, 22 cross, 0,80%, dep. 10.000 | OOS 363 (VIOLA 190) / IS 410 | CSV OOS 0,816 / IS 0,871; **VIOLA sola OOS PF(r) 0,78** [MISURATO] | DD equity 22,78% OOS (CSV, intero cesto); DD sulle sole chiusure VIOLA **14,9%** a 0,8% per R [MISURATO] | 4 mesi 2026, Modello 1 (screening, **non misura merito**) | `PERTRADE/`, CSV di `ROUND_R92BAB_20261001_2201` |
| Antenato forward (versione col primo tick), piccolo | 297 (BLU 238, VIOLA 50, ARANCIO 9) | 0,83 (lordo 0,92); **VIOLA 50: 0,68** | costi 56% della perdita (tutti i segnali); VIOLA: costi 23% | 01/04-08/06/2026 | `data/statements/trades_auto.csv` |
| Piccolo v5.20 forward | VIOLA 33 (2 XAUUSD) | **0,47** | WR 70%, DD sulle chiusure 5,4% | 30/09-07/10 (6 giorni di borsa) | idem |
| Trial FTMO 1514806751 | **19 VIOLA** (10 vinte) | **0,40** | -4.925,49 EUR; DD sulle chiusure 3,6% a 0,8% | 01-06/10, 4 giorni con aperture | `ReportHistory_trial_1514806751_2026-10-08.xlsx`; somma netto = autopsia al centesimo |
| **Pool v5.20 (R92BAB VIOLA + piccolo v5.20 VIOLA su cross)** | **221** | **0,72** | media r -0,073; sigma del singolo trade 0,570 R | maggio-giugno (Modello 1) + fine settembre-ottobre (reale) | `sim_bulge_viola_simboli.py` |

Avvertenze [LETTO/DERIVATO]: il piccolo e il trial **condividono le stesse operazioni** sui cross comuni (non campioni indipendenti); R92BAB e l'antenato si sovrappongono nel tempo (stessa tempesta vista due volte); il trial contiene **due istanze** con rischio diverso (R per posizione 1.195-1.596 EUR su 160.000: ~0,8% per `BULGE_V520_FT`/`BULGE VIOLA_VIOLA`, ~1,0% per `BULGE_VIOLA`, in linea con il "1,0/3" dichiarato da Claudio il 01/10 [DERIVATO]). Il per-trade di R92BAB somma -945,78 (tutti i segnali) contro -1.149,43 del CSV: **-203,65 non spiegati**.

### 1.3 Uscita (la leva piu' grossa) [MISURATO, pool n 221]
- 161 vincite: percentili 10/25/50/75/90/99 = **0,04 / 0,13 / 0,24 / 0,35 / 0,46 / 0,76 R**, massimo **0,83 R**; **0 vincite >= 1 R**; 12 > 0,5 R. 60 perdite, media -0,951 R. Payoff 0,267; win rate 72,9% contro **78,9%** di pareggio: manca ~6 punti di win rate, o ~0,07 R a trade.
- Distanza TP in ATR = 3 x vincita mediana: **0,73 ATR** (mediana fra simboli): la mediana BB sta a ~0,7 ATR dall'entrata, lo stop a 3 ATR. `ABTG_Bulge.mq5` (testata) dice di **non aggiustare il rapporto rischio/rendimento senza una decisione di Claudio**: e' una domanda per lui (parte 7, Q3).
- Conseguenza [DERIVATO]: un trade favorevole non supera 1 R se non e' una rarita'; BE a 1 R / trailing da 1,5 R / parziale a 1 R scattano ~mai. Il canarino 4 di R92 (gestita = nuda su 21 simboli su 22) e' la stessa cosa. **Il time-stop non esiste** nel codice (zero `MaxBars/TimeStop`), il TF e' cablato, il TP e' dinamico.
- Durata: mediana 4,7 ore (v520, n 31: vincite 4,2 ore, perdite 5,1 ore): non separa. L'antenato (tutti i segnali) mostra 12-24 ore con PF 0,18 (n 64), ma **la durata dipende dall'esito** (trappola dichiarata il 03/10): senza MTM all'ora N non e' una misura.

### 1.4 Costo [MISURATO]
| Fonte | n | lordo | commissioni | swap | netto | PF lordo -> netto |
|---|---:|---:|---:|---:|---:|---|
| v520 VIOLA | 33 | -4,81 R | -0,39 | -0,16 | -5,36 R | 0,52 -> 0,47 |
| antenato VIOLA | 50 | -2,96 | -0,66 | -0,24 | -3,87 | 0,75 -> 0,68 |
| antenato TUTTI (BLU domina) | 297 | -4,37 | -3,36 | -2,52 | -10,24 | **0,92 -> 0,83** (riproduce il 0,92 del 03/10) |
| trial | 19 | -3,84 | -0,29 | -0,06 | -4,19 | 0,43 -> 0,40 |
- La commissione e' **0,77-1,93% di R** per simbolo (mediana per simbolo, piccolo+trial+antenato). **Lo spread dei cross e' [NON MISURATO]**; `data/spread_vivo/` ha solo EURUSD (0,2 pip), GBPUSD (0,3), USDJPY (0,3), rispetto a un ATR H1 al segnale di 13-18 pip (spread/ATR 1,5-2,8%).
- Frontiera `stop >= 40 x (spread + commissione)`: **M30 escluso per costo** (NZDCHF: SL ~11,9 pip -> budget 0,30 pip contro 0,41 di sola commissione; EURGBP fuori anche a H1: 14,1 pip -> 0,35 contro 0,37) [LETTO, 03/10 par. 2.2, ricalcolo da EUR/pip/lotto]. M15/M5 piu' lontani: stesso verso, escluso per costo con lo stesso conto.

### 1.5 La storia dei difetti (perche' le misure vecchie non valgono)
1. **R92 (21/08): la condizione "candela di reazione" era SVUOTATA a B=0.** `CheckSignal` girava una volta per barra al primo tick, dove `close == open`: VIOLA-PINE (`close > open`) sempre falso = **0 operazioni su 44 celle su 44**; VIOLA-EA (`|0| <= 1,5 ATR`) sempre vero = VIOLA **con un filtro in meno**; BLU 0 per costruzione. Le 106 operazioni di R92 sono VIOLA senza la reazione (`R92_REFERTO.md`, canarini 1-2-2bis).
2. **v5.20 (21/08, "VAI CON BARRA 1")**: `Signal_Bar_Offset = 1` (barre chiuse), un solo input nuovo; `Signal_Bar_Offset = 0` riproduce la v5.10 per rifare R92. Costo dichiarato: l'ingresso avviene una barra dopo. Round nuovo, criteri da firmare prima (fatto il 29/09: `FIRME_2026-09-29_BULGE_R92B.md`).
3. **R92b mai girato** (`OnTesterInit works too long` nel controllo, CSV R92b0 assenti); **R92BAB** e' una riga diagnostica: 2 gambe su 12 morte con la stessa firma, il guasto colpisce anche un EA a un simbolo (P). **Nessun merito misurato per costruzione.**
4. **Il banco ha due irregolarita'** [LETTO]: -203,65 fra per-trade e CSV, e la gemella `+50` ha in IS un Profit piu' basso di 0,02-0,06 (causa [NON MISURATA]; la tolleranza e' scritta nel file M1 prima dei numeri).
5. **Il "tetto dei 63 caratteri"** della stringa dichiarata e' escluso dai deal (208 deal su simboli oltre il carattere 63).
6. **Il campo non e' il preset**: il file M1 misura il PRESET trial, non il campo (Risk/Max_Trades post-ripristino del 01/10 [NON NOTI]); 2 delle 33 VIOLA del piccolo sono **XAUUSD**, fuori dalla lista dei 22 e dai preset del repo (universo in campo [NON VERIFICATO]).
7. **Il "salto di 5x" non e' un salto**: [DERIVATO] 190 VIOLA / 41 giorni di borsa (4 maggio-29 giugno) = 4,6 al giorno in R92BAB e 5,5 al giorno nel forward v5.20, contro 1,0 dell'antenato col primo tick. Causa [INFERITA]: la correzione della barra 1.

### 1.6 I simboli gemelli e il TF
Cella di campo: 15 cross (7 sono rimasti sul piccolo a un'altra istanza). Il gemello "22 cross" e' misurato solo da R92BAB (4 mesi). **Nessuna misura lunga** per nessuno dei due. TF: H1 cablato; M30 escluso per costo (par. 1.4); H4 non escluso per costo ma ~1/4 della frequenza [DERIVATO], quindi contro il muro dei 150.

### 1.7 Chi ha perso, in due frasi [MISURATO]
Nel pool le perdite sono distribuite: **nessun simbolo con IC95 tutto sotto 0**, peggiori NZDCHF (-3,27 R su 14), EURNZD (-3,82 su 18), NZDUSD, CADCHF; valuta peggiore NZD -12,05 R (69 posizioni). Nel trial le due perdite piu' grosse (EURNZD, GBPAUD) sono **stop alle 15:30:00 e 15:30:06** (NFP del 02/10) su due cross **senza valute in comune**: un cluster per valuta non le prende (par. 2.4).

### 1.8 Certificato di morte: le 5 caselle (CLAUDIO 09/09)
| # | Casella | Stato |
|---|---|---|
| 1 | PF misurato | **si, ma solo 2026** (R92BAB 4 mesi Modello 1; forward 6 giorni-3 mesi). La cella di campo a lungo: `BULGE_M1_cella_campo_lunga.txt`, **scritta e non girata** |
| 2 | n e DD | si, stesso limite (n 190-221; DD solo sulle chiusure, o per il cesto intero) |
| 3 | Gestione dell'uscita ad asse | **NO**: BE/trailing/parziale a default spenti sono inerti per costruzione (par. 1.3); R92: gestita = nuda 21/22 su n minuscoli; TP dinamico, time-stop, SL mai messi ad asse |
| 4 | Simboli gemelli | **NO** a lungo (22 vs 15) |
| 5 | TF cambiato | **IMPOSSIBILE** con l'EA com'e' (H1 cablato); M30 escluso per costo |
**Verdetto: NON ANCORA MISURATO**, non "morto". Mancano 3 caselle su 5 e la prima a lungo. **Registro**: `REGISTRO_TEST.md` e i censimenti del 09/09 (Tabella A "127 vicini alla soglia", Tabella B "13 meccanismi mai messi ad asse") **non contengono nessuna riga Bulge** (grep su `REGISTRO_TEST.md`, `CENSIMENTO_PF_MISURATI`, `AUDIT_USCITE`, `CENSIMENTO_PF_TUTTI...csv`: zero occorrenze). Riga da aggiungere al registro (non scritta qui: e' un file condiviso): _"Bulge VIOLA v5.20, NON ANCORA MISURATO: manca PF a lungo sulla cella di campo (M1), uscita ad asse (BE basso, parziale basso, TP fisso, time-stop), gemelli 22 cross, TF (H1 cablato, M30 escluso per costo)"._
**Manopole inerti (il giacimento del mandato)**: `Enable_BE_1R` a `BE_At_R=1,0`, `Enable_Trailing_R` da 1,5 R, `Enable_Partial_Close` a 1 R: tre manopole che nei round passati "non hanno morso" perche' 1 R non si raggiunge. Sono **caselle libere**, non provate (dato: 0 vincite >= 1 R su 161).

---

## 2. LA SIMULAZIONE DI CARTA -- regole di portafoglio

Script: `backtest_pipeline/sim_bulge_viola_portafoglio.py` (+ `sim_bulge_viola_dati.py`). **Cosa fa**: prende posizioni **gia' accadute** con apertura e chiusura (trial 19; piccolo v5.20 VIOLA 33; antenato VIOLA 50; antenato TUTTI 297 come stress), le ordina per apertura (a parita': ordine di `Symbols_List`), applica una regola di portafoglio che **rifiuta** un ingresso se il portafoglio *accettato fin li'* viola la regola, e misura il delta in R. **Unita'**: r = netto/R, con R esatto per posizione sul trial (EUR per unita' di prezzo dal P/L lordo x |entrata-SL|) e R = mediana (mensile per l'antenato) delle perdite a SL per il piccolo (CV 6% v520, 12% antenato). **Nullo**: togliere **lo stesso numero k di posizioni a caso** (10.000 permutazioni, seme 20261008); p = frazione dei casi con delta >= osservato. **Eccezione dichiarata**: R92BAB (190 VIOLA, il campione piu' grande) ha **solo l'ora di chiusura** -> per le regole che ordinano le aperture **non e' simulabile**; vi si calcolano solo concentrazione e orari di chiusura.

### 2.1 ATTESE scritte PRIMA dei numeri (nel header dello script, 08/10, viste solo le 19 righe del trial e i conteggi grezzi)
- **H0** : la regola toglie posizioni "a caso" rispetto all'esito (delta dentro la distribuzione di una rimozione casuale).
- **H1** : la regola toglie le perdenti piu' delle vincenti: delta >= +2 R e p < 0,05 in **almeno due fonti indipendenti** (v520 e antenato: periodi disgiunti; il trial non e' indipendente da v520).
- **Banda attesa**: |delta| < 3 R e p > 0,10 per ogni regola e fonte; cluster cap 1: 15-45% delle posizioni su trial e v520, **meno del 15% sull'antenato**; kill piu' stretto: 0-3 posizioni; massimo di aperte contemporanee 4-6.
- **Soglie congelate**: "indizio" p < 0,05; "promuovibile" solo p < 0,05/14 in due fonti indipendenti; mai "promuovibile" da un'ora sola di un solo regime.
- **Cosa e' andato fuori attesa (dichiarato)**: (i) sull'antenato cluster cap 1 toglie il 26-30% (non < 15%); (ii) kill piu' stretto toglie fino a 6 posizioni sul v520 e 5 sul trial (non 0-3; sull'antenato 3-4); (iii) due delta superano 3 R: trial cluster cap 1 firmato **+3,51 R, p 0,043** e v520 max aperte 2 **+3,01 R, p 0,21**; (iv) v520 cluster cap 1 non firmato 48% (soglia 45%). L'attesa sulle concorrenze (4, 4, 5) e' invece centrata.

### 2.2 Risultati (delta in R = somma r dopo - prima; "tolte" = posizioni rifiutate; V/P = vinte/perse; p = rimozione casuale)
| Regola | Trial (n 19) | v520 (n 33) | Antenato VIOLA (n 50) |
|---|---|---|---|
| cluster cap 2, non firmato | 3 tolte, +0,34, p 0,65 | 4, +0,40, p 0,56 | 6 (6V), -1,34, p 0,91 |
| cluster cap 2, firmato | 2, +0,45, p 0,54 | 2, -0,20, p 0,58 | 5 (5V), -1,16, p 0,90 |
| cluster cap 1, non firmato | 7 (3V/4P), +3,28, p 0,099 | 16 (12V/4P), +1,55, p 0,73 | 15 (13V/2P), -0,88, p 0,87 |
| cluster cap 1, firmato | 6 (2V/4P), **+3,51, p 0,043** | 12 (9V/3P), +0,92, p 0,74 | 13 (12V/1P), **-1,74**, p 0,94 |
| stop pieno -> niente su quella valuta, non firmato | 3, +0,07, p 0,73 | 5, +1,96, p 0,15 | 7, -0,35, p 0,74 |
| stop pieno -> idem, firmato | 2, +0,17, p 0,62 | 5, +1,96, p 0,15 | 6, -0,10, p 0,67 |
| max aperte 3 | 1, -0,11, p 0,63 | 3, +0,85, p 0,27 | 8, -0,40, p 0,73 |
| max aperte 2 | 3, +0,29, p 0,67 | 11, **+3,01**, p 0,21 | 15, -0,65, p 0,83 |
| kill: 3 SL/giorno | 0 | 1, -0,05, p 0,46 | 3, -0,39, p 0,60 |
| kill: 2 SL/giorno | 3, +0,07, p 0,73 | 3, +0,76, p 0,33 | 4, -0,53, p 0,68 |
| kill: 2 SL consecutivi | 3, +0,07, p 0,72 | 0 | 4, -0,53, p 0,69 |
| kill: perdita giorno 1,5 R | 3, +0,07, p 0,73 | 3, +0,76, p 0,32 | 3, -0,39, p 0,62 |
| kill: perdita giorno 1,0 R | 5, -0,01, p 0,82 | 6, +0,25, p 0,65 | 4, -0,53, p 0,69 |
| max 1 apertura/simbolo/giorno | 4 (4V), -1,51, p 0,995 | 1, -0,15, p 0,57 | 14 (12V/2P), -0,29, p 0,78 |
Concorrenza massima osservata: trial 4, v520 4, antenato VIOLA 5 (antenato tutti: 10).
**Lettura**: nessuna regola raggiunge la soglia "promuovibile" (p < 0,0036); H1 e' falsa (nessuna regola ha delta >= +2 R con p < 0,05 in due fonti). Il trial dice "cluster cap 1 aiuta", l'antenato dice "lo stesso cluster cap 1 toglie 12 vincite su 13 e costa 1,74 R": il segno **non si conserva** -- e' la firma del caso o di un regime. Stesso verso sull'antenato tutti (297): cap 1 firmato -2,29 R p 0,95; max aperte 3 -2,94 R; kill 2 SL consecutivi **-8,52 R** (nell'antenato BLU, dove le serie di stop sono seguite da vincite).

**Il caso che l'autopsia ha chiamato "dopo uno stop pieno niente sul cluster"** [MISURATO]: sul trial la regola avrebbe tolto 3 posizioni del 02/10 successive allo stop alle 15:30 (GBPNZD +0,31, NZDJPY +0,09, EURGBP -0,48 R): **netto +0,07 R**. E gli stop dell'NFP erano **contemporanei** (15:30:00 e 15:30:06): nessuna regola "dopo lo stop" li avrebbe evitati; e nessun cap per valuta (non hanno valute in comune). Cio' che li avrebbe fermati e' un **filtro news** (fuori da questa simulazione: `data/abtg_news.csv` e' vuoto).

### 2.3 (c) Pausa giornaliera a soglia piu' bassa
Il kill switch dell'EA e' gia' attivo (4 SL, 3 consecutivi, -2,0% = ~2,5 R a 0,8%): nei dati c'e' gia' dentro. Le soglie piu' basse (righe kill) tolgono 0-6 posizioni con delta fra -0,53 e +0,76 R, p >= 0,32: **dentro il caso**. Perche' non puo' valere di piu' [DERIVATO]: con payoff 0,27 e win rate 73% le serie di stop sono seguite da vincite ripetutamente, e una pausa tronca anche il rimbalzo.

### 2.4 (a) Cluster per valuta e correlazione
- Il cap per valuta **non firmato** (qualsiasi posizione che contiene la valuta) e quello **firmato** (stessa direzione) differiscono poco sui dati (una copertura short/long sulla stessa valuta e' rara).
- Cap 1 e' una restrizione grossa: toglie il **26-48%** delle posizioni (le 22 coppie hanno solo 8 valute: NZD compare nel 31% delle posizioni del pool (69 su 221) e in 11 su 19 (58%) del trial). **Questo e' vicino a "stringere l'entrata" nei fatti**: la regola non cambia il segnale, ma scarta un quarto-metà dei segnali. Va detto a Claudio (Q1).
- Il fattore comune vero osservato non e' una valuta ma un **evento** (NFP, parte 1.7): per questo il tetto C2 per cluster (firmato, non attivo) non lo avrebbe preso.

### 2.5 (d) Orario e giorno di apertura
| Fonte | Blocchi orari BCM (p dispersione) | Giorno (p) |
|---|---|---|
| v520 + antenato VIOLA (83, versioni diverse) | **p 0,011** (0,006 con R unico): Europa 08-13 n 18, r medio **-0,51**, PF 0,15; Asia -0,02 (22), USA +0,02 (17), sera 0,00 (26) | p 0,62 |
| v520 da solo (33) | p 0,66: Europa -0,30 (n 10, PF 0,25), USA -0,26 (8) | p 0,67 |
| antenato VIOLA da solo (50) | p 0,001: Europa **-0,77** (n 8, PF 0,09) | p 0,59 |
| trial (19) | p 0,95: Europa -0,16 (7) | p 0,95 |
| R92BAB (190), per ora di **chiusura** | p 1,00 (r medio -0,05 in tutti i blocchi) | p 0,044 (mer -0,24 su 39; lun +0,15 su 34) |
- **Lettura**: nell'antenato 5 dei 8 VIOLA del blocco sono i 5 stop del **13-15/04** (CADJPY, NZDJPY+NZDCAD aperti alla stessa ora, AUDUSD x2): **un episodio**; nel v520 il segno e' lo stesso ma e' dentro il caso (p 0,66). I 4 blocchi sono stati fissati il 03/10 guardando l'antenato (297, BLU compreso): sull'antenato e' "visto", non replicato. Il giorno di **chiusura** di R92BAB (p 0,04) non e' l'apertura: non vale come test. **Ipotesi H-F, da misurare con l'ora d'ingresso** (parte 4).
- In UTC il blocco e' **07-12**: `News_Block_Hours = "7,8,9,10,11"` lo chiuderebbe con **un input esistente, zero codice**, a patto che il tester interpreti `TimeGMT()` come in campo ([NON VERIFICATO], vedi parte 5).

### 2.6 (e) Concentrazione per simbolo
- Aperture: nel v520 18 simboli, top-3 EURNZD 5, USDCHF 3, USDJPY 3 (33%); P(max >= 5 | uniforme) = 0,52; nell'antenato VIOLA 15 simboli, top-3 NZDCAD 9, CADJPY 9, NZDJPY 8 (52%, P(max >= 9) = 0,07); R92BAB 22 simboli, top-3 EURGBP 17, GBPUSD 13, EURNZD 13 (23%, P(max >= 17) = 0,13). Il nullo uniforme e' debole (i simboli non sono equiprobabili).
- Perdita: i tre simboli peggiori hanno somma -7,90 R in R92BAB (EURNZD, NZDCHF, GBPNZD), p(permutazione) 0,84; nel v520 -3,26, p 0,89; antenato -4,39, p 0,76; trial -4,22, p 0,40. **Nessuna concentrazione fuori dal caso.**
- Valute peggiori: R92BAB NZD -9,40, p 0,22; v520 AUD -3,84, p 0,38; antenato NZD -2,86, p 0,83; trial AUD -3,83, p 0,21 (la statistica e' il minimo fra le valute: la molteplicita' e' gia' nel p).
- Ripetizioni dello stesso simbolo+lato entro 40 ore (H3: stesso impulso riaperto): v520 4 su 33 (+0,73 R), antenato 15 su 50 (-2,69 R), trial 4 su 19 (+1,51 R). Descrittivo, non si propone di fermarle (e' una stretta di entrata).

### 2.7 (f) Costi: vedi 1.4 (VIOLA costi 8-23% della perdita netta; il PF lordo e' gia' < 1).

### 2.8 Cosa NON si puo' simulare, e il modo piu' corto per misurarlo davvero
| Cosa | Perche' non dai dati del repo | Modo piu' corto | Costo macchina (PC di backtest `DESKTOP-H4D7CAJ`) |
|---|---|---|---|
| BE a R basso, parziale basso, trailing | serve il tracciato intra-trade (MFE/MAE): **assente** (per-trade: solo chiusura/netto) | **corsa tester del solo VIOLA con l'asse acceso**: `Enable_BE_1R=1`, `BE_At_R` in {0,10; 0,20; 0,30} (input esistenti, zero codice, una variabile per file), contro la cella nuda di M1 | 3 celle x 2 gambe = 6 passate; a ~4-15 min per passata [DERIVATO da 15-60 min per 4 passate] = **25-90 min** |
| Parziale a R basso | idem; il codice `DoPartialCloseIfNeeded` contiene anche un break-even | `Enable_Partial_Close=1`, `Partial_Close_R` {0,15; 0,25}, `Partial_Close_Pct` 0,5 fisso | 4 passate = 15-60 min |
| TP fisso all'ingresso (contro TP dinamico) | il per-trade non ha TP d'ingresso (sul trial 6/6 riscritti verso l'entrata) | input nuovo `TP_Mode` in una **copia di banco** (`mql5-ea-developer` + cancello; il campo non cambia) | 2 celle x 2 gambe + sviluppo |
| Time-stop condizionato | serve l'MTM all'ora N | input nuovo `Max_Bars` nella copia di banco; N in {6, 12, 24, spento} | 4 celle x 2 gambe |
| SL a 2,5 / 3 / 4 ATR | serve il MAE dei vincitori | `SL_ATR_Mult` (input esistente) -- **ma la testata dice di non toccare il rapporto senza decisione di Claudio** (Q3) | 3 celle x 2 gambe |
| Cap per valuta, stop-cluster, Max_Trades: **conferma** | la simulazione rimuove e non aggiunge: quando una regola libera uno slot, parte un altro segnale che non vediamo | prima, con `open_time` nel per-trade, le stesse regole offline su n 1.000-2.500 (nessuna passata in piu'); poi codice di banco solo se c'e' lift | 0 min poi 2 celle x 2 gambe |
| Ora d'ingresso su R92BAB/M1 | il per-trade ha solo `close_time` | **telemetria**: colonne `open_time`, `entry_sl`, `entry_tp`, MFE, MAE in `ExportTrades` della copia di banco (comportamento di trading identico) | stesso costo della cella M1 |
| Eventi/news (NFP) | `data/abtg_news.csv` e' vuoto | fonte del calendario da Claudio; poi `News_Block_Hours` / filtro nuovo | -- |

---

## 3. SIMBOLI: la volatilita' spiega chi profitta?

Domanda di Claudio: fra i 22 cross, ci sono simboli che profittano **piu'** degli altri sul VIOLA, e quel vantaggio e' spiegato da una volatilita' piu' adatta al motore? Uso possibile: **selezionare/pesare i simboli** (lista simboli, rischio per cluster); mai restringere l'entrata. Script: `backtest_pipeline/sim_bulge_viola_simboli.py`.

### 3.1 Attese scritte PRIMA dei numeri (header dello script)
- **H0** (la volatilita' non spiega niente): i simboli differiscono per r medio solo per rumore. Con ~10 segnali per simbolo il rumore di un r medio e' ~0,17 R (sigma del singolo trade ~0,55 R): differenze di +-0,3 R fra simboli sono **attese**.
- **H1** (la volatilita' spiega): rho di Spearman fra volatilita' relativa (ATR14/prezzo al segnale) e r medio per simbolo con **|rho| >= 0,50, p(permutazione) < 0,05, stesso segno sul campione di replica**, e che **resta dopo aver tolto il confondente** (cluster NZD; costo).
- **Altre spiegazioni da separare**: (1) valuta/regime (cross NZD/AUD concentrano perdita o guadagno: test per stratificazione); (2) costo (commissione e spread relativi allo stop).
- **Banda attesa**: |rho| < 0,35, p > 0,10; simboli con PF >= 1,30 (n >= 5) per puro caso: 2-4 su 22; simboli con media > 0 e t > 1,96: 0-2 per caso; la commissione spiega al massimo ~0,03 R di differenza fra simboli; numero minimo di segnali per vedere +0,10 R (Bonferroni su 22, potenza 80%): 400-600; per +0,25 R: 65-100.
- **Soglie congelate**: "simbolo migliore" = n >= 5 **e** p(caso) < 0,05/22 (media del simbolo contro n estrazioni a caso dal pool) **e** IC95 bootstrap per **segnale** tutto sopra 0. Il bootstrap da solo non basta: con zero perdite nel campione e' degenere. Tutto il resto = "e' il caso".
- **Esito rispetto all'attesa**: centrata su rho/p, sul "per caso" (osservati 3 simboli con PF >= 1,30 contro 4,9 attesi; 1 con t > 1,96 contro 1,3) e sui minimi (492 e 79); PF >= 1,30 per caso e' stato **piu' alto** (media 4,9, non 2-4).

### 3.2 I dati (e quelli che mancano)
- **Pool (test principale)** = R92BAB VIOLA 190 + piccolo v5.20 VIOLA 31 (scartate 2 XAUUSD, fuori lista) = **n 221**; periodi disgiunti; stessa versione v5.20. Replica = antenato VIOLA 50 (versione col primo tick, sovrapposto nel tempo a R92BAB). Il trial (19) serve solo per l'ATR al segnale.
- **NON NEL REPO**: il per-trade di R92 (106, v5.10), l'xlsx del backtest di Claudio (268): [NON LEGGIBILI]. **Nessuna barra, nessun ATR, nessuna larghezza delle bande, nessun spread per i 22 cross**: `data/spread_vivo/` ha solo EURUSD/GBPUSD/USDJPY fra i forex; `data/snapshots/` ha 6 maggiori su 22 (dato giornaliero di fonte esterna: non usato).
- **Volatilita' misurata al segnale** (proxy): dalle uscite a SL, ATR = |entrata - uscita| / 3, piu' lo SL dei 19 del trial. **Selezione**: solo i trade stoppati hanno la misura (n_vol 1-7 per simbolo; sensibilita' sui 18 con n_vol >= 3 nel test).

### 3.3 Per simbolo (pool, r = multiplo del rischio, IC95 = bootstrap per segnale) [MISURATO]
| Simbolo | n | wr% | PF(r) | media r | IC95 | p caso | ATR/prezzo % (n_vol) | TP/ATR |
|---|---:|---:|---:|---:|---|---:|---|---:|
| USDCHF | 6 | 100 | inf | +0,255 | degenere (0 perdite) | 0,073 | 0,218 (3) | 0,80 |
| AUDJPY | 8 | 88 | 2,32 | +0,149 | [-0,18; +0,36] | 0,131 | 0,151 (3) | 0,91 |
| CADJPY | 13 | 85 | 1,59 | +0,093 | [-0,21; +0,31] | 0,138 | 0,115 (5) | 0,95 |
| EURGBP | 18 | 72 | 1,12 | +0,029 | [-0,25; +0,28] | 0,219 | 0,054 (4) | 0,92 |
| USDCAD | 9 | 67 | 1,00 | -0,001 | [-0,52; +0,46] | 0,362 | 0,059 (1) | 1,49 |
| AUDUSD / USDJPY / GBPUSD | 10 / 10 / 15 | 80 / 80 / 73 | 0,86 / 0,85 / 0,79 | -0,03 / -0,03 / -0,04 | tutti attraversano 0 | 0,42-0,43 | 0,148 / 0,067 / 0,134 | 0,77 / 0,56 / 0,60 |
| GBPCAD, CHFJPY, AUDCAD, GBPJPY, NZDCAD, GBPAUD, GBPNZD, AUDNZD | 5-13 | 60-80 | 0,48-0,75 | da -0,06 a -0,17 | attraversano 0 | 0,49-0,70 | 0,088-0,128 | 0,12-0,86 |
| EURNZD | 18 | 67 | 0,36 | -0,212 | [-0,48; +0,03] | 0,86 | 0,138 (5) | 0,48 |
| CADCHF, NZDUSD | 8, 8 | 50, 62 | 0,43 | -0,22 | attraversano 0 | 0,76 | 0,093, 0,163 | 1,26, 0,63 |
| NZDCHF | 14 | 64 | 0,36 | -0,233 | [-0,56; +0,05] | 0,86 | 0,120 (6) | 0,58 |
| NZDJPY, EURUSD | 3, 4 | -- | -- | n < 5: non leggibili | -- | -- | -- | -- |
(Tabella completa e ordinata: output dello script. EURUSD n 4 e NZDJPY n 3 non leggibili. XAUUSD escluso.)
- **Simboli con IC95 tutto sopra 0: USDCHF, che NON passa la soglia congelata (p caso 0,073 > 0,0023)**; **simboli con IC95 tutto sotto 0: nessuno**.
- **Per caso, su 20 simboli con n >= 5** (r rimescolato fra posizioni, 2.000 simulazioni): PF >= 1,30: osservati **3**, per caso media **4,9** (95% fino a 7); t > 1,96: osservati **1**, per caso **1,3** (fino a 3); migliore media osservata +0,255, per caso mediana +0,243 (95% fino a +0,358). **Il migliore simbolo e' esattamente quello che il caso da' sul migliore di 20.**
- Dispersione fra simboli (permutazione delle etichette): **p 0,97**.

### 3.4 Volatilita' per simbolo, e il test [MISURATO con i limiti di 3.2]
- ATR H1/prezzo al segnale: da **0,054% (EURGBP, 4,7 pip)** a **0,218% (USDCHF)**: un fattore ~4 fra i simboli, quindi il test ha *leva*; ma 16 simboli su 22 hanno n_vol <= 5.
- **Spearman volatilita' -> r medio**: **rho -0,01, p 0,977**; stratificato NZD/altro rho -0,01, p 0,986; solo simboli con >= 3 misure di volatilita' (18): rho +0,09, p 0,74. **Replica antenato: non eseguibile** (solo 5 simboli con n >= 3 e volatilita'; soglia 6). Frequenza dei segnali (R92BAB) contro volatilita': rho -0,31, p 0,164.
- **TP/ATR -> r medio**: rho +0,35, p 0,133 (20 simboli), **parzialmente circolare** (la vincita fa parte del r medio): non e' una conferma indipendente di niente.
- **Costo -> r medio**: rho +0,18, p 0,45; volatilita' -> r medio **a parita' di costo**: rho parziale +0,30, p 0,21 (20 simboli). Soglia di Bonferroni per le tre ipotesi vol/costo: 0,017: **nessuna passa**.
- **Valuta/regime** (par. 2.6): NZD peggiore -12,05 R su 69 posizioni (media -0,175); p del minimo fra 8 valute **0,166**; JPY l'unica positiva (+0,61 R, n 55, PF 1,06, p del massimo 0,66).

### 3.5 (d) Separare volatilita', valuta e costo [MISURATO + [DERIVATO]]
- **Volatilita'**: nessuna relazione col r medio (rho -0,01). Contro-esempio provato a macchina (autotest): se l'effetto fosse dovuto al cluster NZD, la correlazione globale sembrerebbe forte (rho -0,70, p 0,0005 sui dati finti) e **sparirebbe stratificando** (p 0,31); qui ne' globale ne' stratificata mostrano niente.
- **Costo**: la commissione vale 0,77-1,93% di R per simbolo: **al massimo ~0,02 R** di differenza fra simboli per sola commissione, contro differenze di r medio di +-0,2 R. Lo **spread dei cross e' [NON MISURATO]** (solo 3 maggiori, 1,5-2,8% dell'ATR): e' il buco che impedisce di dire "un simbolo non profitta per il suo spread alto".
- **Valuta/regime**: NZD e' la candidata (p 0,17); il test sulla sua stabilita' nel tempo non c'e' (2 mesi, un regime).
- **Verdetto onesto**: **non c'e' evidenza che la volatilita' relativa spieghi chi profitta; non c'e' evidenza di simboli migliori. Con n ~10 per simbolo il test non esclude effetti piccoli (potenza del 43% per +0,25 R di range lineare).** Non e' "il default va bene": e' "con questi dati non si seleziona nessun simbolo".

### 3.6 Quanti segnali per simbolo servono per distinguere un simbolo migliore dal caso [DERIVATO, sigma 0,570 R misurata sul pool]
Formula: `n = (sigma x (z(alpha/2) + z(0,80)) / delta)^2`, test z a due code con sigma nota. Frequenza: R92BAB 190 VIOLA / 22 simboli / 1,85 mesi = **56 segnali per simbolo e anno**.
| Vantaggio da vedere | n (alpha 0,05) | n (alpha 0,05/22) | Anni a 56/anno (Bonferroni) |
|---:|---:|---:|---:|
| +0,05 R | 1.019 | 1.968 | 35,1 |
| +0,10 R | 255 | 492 | 8,8 |
| +0,15 R | 114 | 219 | 3,9 |
| +0,25 R | 41 | 79 | 1,4 |
| +0,40 R | 16 | 31 | 0,6 |
Oggi: 3-18 segnali per simbolo nel pool (mediana 10). La cella M1 (15 cross, OOS 2022-2026.06, n atteso 1.000-2.500) darebbe **~70-170 per simbolo**: basta per +0,25 R (79), non per +0,15 R (219) se non sul solo cesto. **Un vantaggio di simbolo sotto +0,15 R non e' misurabile in anni realistici: per pesare i simboli serve un'altra ragione (spread, costo, cluster di rischio), non il PF per simbolo.**

### 3.7 SONDA da far girare sul PC di backtest (i dati non sono nel repo) -- solo piano
**Cosa misura** (per ciascuno dei 22 simboli, mese per mese 2010.01-2026.06): ATR14 H1 / chiusura; range medio H1 in pip; larghezza media BB(20; 2) / prezzo; spread medio e P95 (campo `spread` delle barre H1) in pip; rapporto spread/ATR (costo relativo) e `40 x spread` contro SL = 3 ATR (frontiera del costo); conteggio dei candidati VIOLA per mese (impulso con corpo >= 0,2 ATR che tocca la banda) come proxy di frequenza. Output CSV in `MQL5\Files`, **sola lettura**, uno script (non un EA) **nuovo** da far scrivere a `mql5-ea-developer` e passare dal cancello: **non scritto qui**.
**Costo [STIMA, NON MISURATO]**: 22 simboli x 16,5 anni x ~6.100 barre H1 all'anno = ~2,2 milioni di barre: `CopyRates` H1, **5-15 minuti** su `C:\MT5_Backtest` (50504400), mai sul VPS (regola 21/09). Con M1 (per lo spread vero) servirebbero ~134 milioni di barre: sconsigliato; lo spread di barra H1 basta per un primo ordine di grandezza.
**Cosa permette**: (i) la volatilita' *vera* di tutti i 22, non il proxy dai trade stoppati; (ii) il rapporto spread/ATR e la frontiera 40x per simbolo (M30 incluso); (iii) la frequenza attesa per simbolo; poi lo stesso Spearman con **n simboli = 22 e volatilita' priva di selezione**, sul per-trade lungo di M1.
**Contro-esempio gia' costruito per il test**: se lo spread alto e la volatilita' sono correlati (tipico dei cross esotici), la volatilita' *sembra* spiegare il profitto ma e' il costo: il test deve girare con il rho parziale a parita' di spread (autotest `costo`: rho globale -0,95, parziale -0,08).

---

## 4. IPOTESI CLASSIFICATE PER MECCANISMO

Regola del 19/08 applicata: Bulge e' **NON ANCORA MISURATO** (non "senza edge dichiarato"), quindi si possono mettere ad asse **meccanismi** (uscita, filtri di regime, simboli, TF); **niente griglie sui parametri d'ingresso** (BB_Period, BB_Deviation, Bulge_Multi, Lookback_Bars, ATR_Period, 0,2 ATR dell'impulso, 0,6 ATR della banda piatta, 1,5 ATR della reazione) **e nessun controllo del bulge**: escluse per decisione di Claudio *e* per regola. Se M1 dara' PF OOS < 1,05 (atteso 0,80-1,05) tutte le righe qui sotto restano **misure di meccanismo da pagare con prova fuori campione**, mai "ottimizzazioni". Picco di rumore: rumore A3 10,5% relativo sul PF; cella = centro dell'altopiano a 3 celle monotone; una cella che sporge con le vicine che non la seguono = "non c'e' configurazione robusta".

| ID | Classe | Cosa tocca | Attesa scritta prima (banda) | Altra spiegazione / numero che produce | Picco di rumore: criterio | Costo macchina | Firma |
|---|---|---|---|---|---|---|---|
| **U1** | Uscita | `Enable_BE_1R=1`, `BE_At_R` in {0,10; 0,20; 0,30} (input esistenti) | PF netto fra -10% e +10% della nuda (rumore A3), win rate -3..-8 punti; **condizione di pareggio**: il BE aiuta solo se per ogni vincitore che torna a BE dopo +b R c'e' almeno 0,267 perdenti salvate (0,254/0,951 R) | "BE aiuta" = PF >= +15% con DD in calo; "BE nuoce" = PF <= -15%. Il rimbalzo che torna a BE e poi a TP e' il rischio: a BE 0,1 R lo stop e' a ~0,3 ATR (NZDCHF ~1,7 pip) **contro lo spread e il livello minimo di stop del broker [NON MISURATO]** | 3 celle monotone nello stesso verso; una cella isolata = rumore | 6 passate, **25-90 min** | no (banco) / si' (campo) |
| **U2** | Uscita | `Enable_Partial_Close`, `Partial_Close_R` {0,15; 0,25}, `Partial_Close_Pct` 0,5 | PF -10..+10%; raddoppia la commissione sulla meta' del volume (+~1% di R per posizione) | come U1 | idem | 4 passate, 15-60 min | si' (campo) |
| **U3** | Uscita | TP fisso all'ingresso (contro dinamico) -- input nuovo `TP_Mode` in copia di banco | vincita media +10..+30%, win rate -2..-8 punti, **segno del PF [NON PREVEDIBILE]** | PF entro il 10,5% = il default va bene | 2 celle | 2x2 passate + sviluppo | si' |
| **U4** | Uscita | Time-stop condizionato (`Max_Bars` nuovo; "dopo N barre non sei a +X R, esci") | le posizioni che superano N barre escono a perdita media meno grave di -0,95 R; N in {6, 12, 24, spento} | durata dipende dall'esito: se l'uscita forzata e' vicina allo SL non salva nulla | 4 celle monotone | 4x2 passate + sviluppo | si' |
| **U5** | Uscita | `SL_ATR_Mult` {2,5; 3,0; 4,0} | rapporto TP/SL cambia con lo stop: win rate sale con stop piu' largo, payoff scende; PF [NON PREVEDIBILE] | la testata dice di non toccare il rapporto senza decisione di Claudio | 3 celle | 3x2 passate | **chiede Claudio (Q3)** |
| **R1** | Filtro di regime | `Use_ATR_Filter` acceso/spento (input esistente) | l'AMPIA (spento) e il preset trial (acceso) non sono mai stati confrontati a parita'; PF entro il 10,5% | filtro ATR toglie frequenza (**stretta di entrata?** Q1) | 2 celle | 4 passate | no (banco) |
| **R2** | Filtro di regime / orario | blocco 07-12 UTC: `Use_News_Filter=1`, `News_Block_Hours="7,8,9,10,11"` (input esistenti) | se l'ipotesi regge, il r medio del blocco 08-13 BCM resta < -0,3 R anche su n >= 150 in OOS e la sua esclusione porta PF netto >= +15% | e' un episodio (13-15/04) o il 2026: blocchi uguali entro il rumore. **`TimeGMT()` nel tester [NON VERIFICATO]** | confrontare con un blocco di controllo scelto *prima* (es. 12-17 UTC) | 2 celle x 2 gambe | si' (campo) |
| **R3** | News | filtro nuovo con calendario (NFP/FOMC) | stop su rilascio USA > 5% degli SL a lungo | `data/abtg_news.csv` vuoto: manca il dato | -- | dato esterno | si' |
| **P1** | Portafoglio | cap posizioni per valuta (nuovo input in banco; offline prima) | delta dentro il caso (parte 2); se con n >= 1.000 il delta resta >= +1,5 R/1.000 e p < 0,0036 -> da confermare | trial +3,51, antenato -1,74: il segno non si conserva | p < 0,05/14 in due fonti | offline: 0 min | si' (qualunque cap) |
| **P2** | Portafoglio | "dopo uno stop pieno niente sul cluster, stesso giorno" | idem | gli stop NFP erano contemporanei: la regola non li ferma | idem | offline: 0 | si' |
| **P3** | Portafoglio | `Max_Trades` 4 -> 3/2; kill switch piu' stretto | idem; con payoff 0,27 la pausa tronca i rimbalzi | idem | idem | offline: 0 | si' |
| **S1** | Simboli | lista simboli (15 contro 22); peso per simbolo | nessun simbolo migliore (parte 3); potenza fino a +0,25 R con M1 | spread alto = costo, non volatilita' | p caso < 0,05/22 + IC; 2 regimi | M1 + sonda | si' (lista) |
| **T1** | TF | `Signal_TF` nuovo (H1 cablato) | M30 **escluso per costo** (NZDCHF 0,30 contro 0,41); H4 non escluso ma ~1/4 della frequenza | -- | -- | 2x2 passate + sviluppo | si' |
| **ESCLUSA E1** | Costo | uscita prima del weekend/rollover (taglio swap) | swap = **1,4-6% della perdita netta** del VIOLA (-0,06..-0,24 R su 4-5): non puo' portare sopra 1 | -- | -- | -- | -- |
| **ESCLUSA E2** | Ingresso | qualunque parametro d'ingresso, controllo del bulge, riduzione della frequenza dell'entrata | decisione di Claudio 08/10 + regola 19/08 | -- | -- | -- | -- |
**Cosa si guadagna se tutto va bene, in numeri** [DERIVATO]: per passare da PF(r) 0,72 a 1,00 servono ~+0,07 R a trade (win rate di pareggio 78,9% contro 72,9%). Nessuna delle voci del par. 2 raggiunge questo ordine; U1-U5 sono le sole che possono muovere la forma del payoff.

---

## 5. PIANO DELLE MISURE, in ordine (solo piano: nessuna riga di lancio, nessun round)

| # | Misura | Cosa decide | Costo macchina (PC di backtest) | Firma |
|---|---|---|---|---|
| **0** | Fatta: simulazione di carta + simboli (questo dossier) | niente regola e niente simbolo e' distinguibile dal caso su 19-221 posizioni | 0 | -- |
| **1** | **`BULGE_M1_cella_campo_lunga.txt`** (pronto dal 03/10, mai girato): VIOLA solo, 15 cross, 2010.01.01-2026.06.30, IS 2010-2021 / OOS 2022-2026.06, 4 passate (2 celle gemelle sul magic = G1) | PF OOS: < 1,05 = nessuna griglia sull'ingresso e solo meccanismi; 1,05-1,30 = si apre l'uscita; >= 1,30 = tick reali. Il per-trade OOS (n 1.000-2.500) alimenta simboli, NZD, payoff, orario *di chiusura* | **15-60 min [DERIVATO]**; un job su 6 puo' morire con `OnTesterInit` (R92BAB 2 gambe su 12) e il driver non riprova senza RETRY | nessuna |
| **2a** | **Copia di banco con telemetria** (`open_time`, `entry_sl`, `entry_tp`, MFE, MAE in `ExportTrades`; comportamento di trading identico, SHA256 e confronto riga per riga): chiude le colonne mancanti | abilita (a)-(d) a n grande, BE/time-stop senza altra passata | sviluppo 1 sessione + la stessa cella di M1 (15-60 min) | firma sul codice del banco; il campo non cambia |
| **2b** | **Sonda di volatilita'/spread** sui 22 (parte 3.7) | volatilita' vera, spread/ATR, frontiera 40x per simbolo | **5-15 min [STIMA]** | nuovo script, passa dal cancello |
| **3** | **Offline sulle misure 1+2a**: rilanciare `sim_bulge_viola_portafoglio.py` e `sim_bulge_viola_simboli.py` con il loader esteso su n 1.000-2.500 (cap per valuta, stop-cluster, Max_Trades, kill, ora d'ingresso, concentrazione, Spearman con n simboli = 15-22) | P1-P3, S1, R2 *prima* di qualunque passata in piu' | 0 minuti di tester | -- |
| **4** | **Asse uscita a zero codice** (U1, U2): `BE_At_R` {0,10; 0,20; 0,30}; `Partial_Close_R` {0,15; 0,25}; una variabile per file prova; controllo di determinismo G1 sulla cella nuda | meccanismi d'uscita; chiude la casella 3 del certificato (mezza) | 10 passate x 4-15 min = **40-150 min** [DERIVATO] | no (banco) |
| **5** | **Asse uscita con codice di banco** (U3 TP fisso, U4 time-stop, U5 SL) | idem, casella 3 completa | 3-4 celle x 2 gambe ciascuno + sviluppo | U5 chiede Claudio (Q3) |
| **6** | **Cesto 22 contro 15** (casella 4 del certificato) e **R1** (ATR acceso/spento) | simboli gemelli | 4 + 4 passate | nessuna |
| **7** | **Tick reali** per qualunque sopravvissuto, e una **prova di regime** (toro/orso/laterale/crollo del tester: finestre gia' usate in R50-R56-R59) | il verdetto | dipende | -- |
**Dove un risultato smette il piano**: M1 con PF OOS >= 1,30 e S3 -> si va ai tick prima di tutto; M1 con n OOS < 150 per gamba -> il merito e' sospeso (il rischio si legge comunque, Emendamento B), si allarga la finestra, non la griglia.
**Opzione che e' di Claudio, non mia**: il forward del piccolo fa ~5,5 VIOLA al giorno: **150 posizioni in ~27 giorni di borsa** per cella. Una seconda istanza in *demo*, con magic diverso e un solo asse d'uscita acceso (es. `BE_At_R=0,20`), darebbe in ~6 settimane una prova A/B che il tester da solo non da' (spread vero, slippage). E' una modifica del forward e di un conto: **solo con la sua firma**; io non la propongo come gia' decisa.

---

## 6. LIMITI E BUCHI DICHIARATI
1. **Campione sottile**: 19 (trial), 33 (v520), 50 (antenato VIOLA), 221 (pool). Il merito sotto 150 e' sospeso; i delta di 3 R su 19 posizioni sono 2,6 volte la sigma del singolo trade.
2. **Trial e piccolo = stesse operazioni** sui cross comuni; **R92BAB e antenato = stessa tempesta** (maggio-giugno): non sono conferme indipendenti.
3. **R92BAB e' Modello 1** (screening, non merito) su 2 mesi e un regime; **solo ora di chiusura**.
4. **Il test toglie, non aggiunge**: nessuna stima di cosa farebbe un segnale rimpiazzante dopo lo slot liberato.
5. **R unico per fonte**: CV 6% (v520), 12% (antenato mensile); il trial e' esatto per posizione. L'arrotondamento dei lotti puo' spostare un r di qualche punto percentuale.
6. **Fuso**: i blocchi orari sono in ora BCM = UTC+1 (fisso dal 24/09: orologio BCM); il trial e' FTMO UTC+3 d'estate (verificato sul NFP: 15:30 FTMO = 12:30 UTC); il 25/10-02/11 cambiano gli orologi: gli stessi script non valgono in inverno senza ricalibrare.
7. **ATR al segnale su trade stoppati**: bias di selezione non misurato.
8. **Spread dei cross [NON MISURATO]**; **nessuna barra dei 22 cross nel repo**; **news storiche assenti**; **MFE/MAE assenti**.
9. **Due fonti non leggibili** (R92 per-trade, xlsx di Claudio 268).
10. **`REGISTRO_TEST.md` non ha nessuna riga Bulge** (e nemmeno i censimenti del 09/09): il certificato e' da scrivere.
11. **Autotest**: coprono la logica di rimozione, i cap firmati/non firmati, lo stop-cluster, il kill switch, la permutazione, la potenza e due confondenti; **non** provano che i dati del repo siano completi (es. posizioni ancora aperte all'ultima riga del CSV mancano: 33 VIOLA del v520 e' un limite inferiore).

## 7. DOMANDE E FIRME PER CLAUDIO
- **Q1 (interpretazione della tua regola).** Cap per valuta, "dopo lo stop niente sul cluster", filtro orario/news e filtro ATR **non cambiano il segnale ma scartano segnali**: sulla carta il cap 1 per valuta scarta il 26-48% delle posizioni. Contano come "attorno all'entrata, permesso" o come "stringere la frequenza dell'entrata, vietato"? Finche' non rispondi, le tengo come **ipotesi da misurare**, non da proporre.
- **Q2.** `max 1 apertura/simbolo/giorno` e il blocco oraria 08-13: stesso tipo di domanda.
- **Q3.** La testata dice di non toccare il rapporto rischio/rendimento (SL a 3 ATR, TP mediana) senza una tua decisione. Posso mettere **ad asse** `SL_ATR_Mult` {2,5; 3,0; 4,0} in banco (misura, non campo)?
- **Q4 (firma sul codice, solo banco).** Autorizzi la copia di banco con telemetria (`open_time`, `entry_sl`, `entry_tp`, MFE, MAE) e il nuovo script-sonda di volatilita'/spread, entrambi su `C:\MT5_Backtest`, mai sul VPS, mai in campo?
- **Q5.** Lanci tu M1 (15-60 min, nessuna firma) sul PC di backtest, con la riga che passa dal cancello?
- **Q6.** XAUUSD (2 delle 33 VIOLA del piccolo) e' voluto? Non e' nei 22 ne' nei preset del repo.
- **Q7.** Che rischio e Max_Trades hanno oggi le **due istanze** del trial (R per posizione ~0,8% e ~1,0%)?
- **Q8 (un buco che puoi chiudere tu).** Hai ancora l'xlsx del tuo backtest BULGE_MULTI_SIGNAL (268 operazioni)? Con quello avremmo il primo per-trade con apertura e chiusura su 6 cross e 4 anni.
- **Firme gia' pendenti che toccano il Bulge**: nessuna nuova; tetto per cluster (C2) firmato non attivo (`FIRME_2026-09-07.md`); orologio invernale BCM entro il 25/10.

## 8. DOMANDE PER GEMINI -- protocollo di squadra (`docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md`), quattro ruoli separati
**Non inviate** (cancello prima). Pacchetto da allegare, solo `.md`: questo dossier, `BULGE_COME_MIGLIORARLO_2026-10-03.md`, `CONFRONTO_BULGE_VIOLA_VS_BREAKING_BAND_2026-10-08.md`, `FTMO_TRIAL_AUTOPSIA_2026-10-08.md`; mai preset, script, conti. Decisione di Claudio in testa, in chiaro: _"il motore VIOLA non si tocca; non stringere l'entrata"_.

**Ruolo A -- Cacciatore (max 2+2 meccanismi, niente parametri del motore).**
- A-1. _Sulla stessa inefficienza (fade di un tocco di banda dopo un impulso, SL 3 ATR, TP mediana, payoff 0,27, win rate 72,9%), proponi al massimo 2 meccanismi di USCITA diversi da BE/parziale/trailing a R (che qui sono inerti: 0 vincite su 161 arrivano a 1 R). Per ognuno: nome esatto dell'input o "nome da verificare", attesa con banda e numero dell'ipotesi alternativa, falsificatore, costo in passate._
- A-2. _Proponi al massimo 2 filtri di REGIME esterni al segnale (orario, evento, volatilita' del cesto, correlazione fra valute) che non cambino la condizione d'ingresso e non richiedano di conoscere il futuro. Dichiara se ognuno riduce il numero di ingressi e di quanto._
**Ruolo B -- Avvocato del diavolo.** Per ogni proposta di A e per queste nostre letture, il contro-esempio concreto (cosa produce l'ipotesi alternativa e se cade nella banda):
- B-1. _"Il blocco 07-12 UTC e' peggiore": spiega con un episodio (5 stop il 13-15/04) o con il regime; quale numero atteso se e' solo l'episodio?_
- B-2. _"Il cap per valuta non aiuta (trial +3,51 R, v520 +0,92, antenato -1,74)": quando una regola di portafoglio che toglie 26-48% dei segnali sembra neutra e invece lo e' (o viceversa) per un effetto che la simulazione "solo rimozione" non vede?_
- B-3. _"La volatilita' relativa non spiega il r medio per simbolo (rho -0,01, 20 simboli, volatilita' misurata sui soli trade stoppati)": in quale caso concreto la misura della volatilita' fatta cosi' darebbe zero anche se l'effetto esistesse?_
**Ruolo C -- Auditor dei numeri (un conto per volta; formula, numeri, controllo di verso; solo dati del pacchetto; NON LO SO se manca).**
- C-1. _Win rate di pareggio: vincita media 0,254 R, perdita media 0,951 R. Con `WR_pareggio = L/(W+L)`, quanto vale? Confrontalo con il 72,9% osservato e dimmi di quanti punti e' sotto. (Atteso a mano: 78,9%; sotto di 6,0 punti.)_
- C-2. _Segnali per simbolo per distinguere +0,10 R da zero: sigma 0,570 R, alpha = 0,05/22, potenza 80%, `n = (sigma x (z(alpha/2)+z(0,80))/delta)^2`. Quanto vale? (Atteso: ~492.)_
- C-3. _A 56 segnali per simbolo e anno (190 VIOLA / 22 simboli / 1,85 mesi), quanti anni per 492 segnali? (Atteso: 8,8; verifica anche che 190/22/(1,85/12) = 56,0.)_
- C-4. _Condizione di pareggio del BE a b R basso: ogni vincitore che torna a BE dopo +b R perde la vincita media 0,254 R; ogni perdente salvata guadagna 0,951 R. Rapporto minimo perdenti salvate / vincitori clippati? (Atteso: 0,267.)_
- C-5. _Su 22 simboli, con alpha = 0,05 per simbolo e simboli indipendenti, quanti "migliori" per puro caso? E la probabilita' di almeno uno? (Atteso: 1,1; 1 - 0,95^22 = 67,6%.)_
- C-6. _Frequenza: 190 VIOLA in 41 giorni di borsa e 33 in 6: quante al giorno ciascuno? In quanti giorni di borsa il forward raggiunge 150 posizioni al passo di 5,5 al giorno? (Atteso: 4,6; 5,5; 27,3.)_
**Ruolo D -- Sintesi.** Al massimo 5 cose da MISURARE, in ordine, ognuna con asse unico, finestra, cella di controllo, attesa con banda, falsificatore, costo (usa quelli del pacchetto), "Firma Claudio SI/NO"; poi l'elenco dei punti dove lui e noi ci contraddiciamo. _Ordina le misure del piano (parte 5) e dimmi quale toglieresti._

**Come si usano le risposte**: dati, mai criteri; tabella "punto / verifica nel repo / cosa se ne fa" dal cancello; due macchine che si contraddicono = una misura da fare.

## 9. Autoverifica dello Sviluppatore (prima di consegnare)
- **Autotest** `--autotest` di entrambi gli script, tutti OK: logica di rimozione dei cap (firmato e non firmato) con risposta nota, **controesempio della copertura** (short NZD con long NZD aperto non e' bloccato dalla versione firmata), stop-cluster (giorno dopo libero, valute estranee libere), max aperte e concorrenza (chiusura e apertura allo stesso istante non si sovrappongono), kill switch (una vincita spezza la sequenza di SL), permutazione (rimozione delle sole perdenti: delta +5,00, p 0,0002; **contro-esempio**: rimozione delle sole vincenti: p 1,000; dati tutti uguali: nessun effetto), falsi positivi su esiti casuali (3/40 e 3/120, attesi ~5%), potenza (effetto grande 120/120; modesto 51/120; piccolo con n~2: 18/120), **confondente NZD** (globale rho -0,70 p 0,0005, stratificato p 0,31) e **confondente costo** (rho -0,95, parziale -0,08), bootstrap per segnale (gambe doppie non gonfiano la precisione), n minimo (283 a mano 282,5).
- **Riconti incrociati con numeri scritti da altri**: somma netto del trial 19 posizioni = -4.925,49 EUR (autopsia, al centesimo); PF lordo dell'antenato 0,92 -> netto 0,83 (dossier 03/10); VIOLA R92BAB 190 e n per simbolo (22 simboli, somme coerenti con `RIEPILOGO_ROUND_R92BAB.txt`); concorrenza max 4 sul v520 = `Max_Trades 4`.
- **Un'attesa sbagliata dichiarata**: nell'autotest avevo scritto "effetto +0,25 R trovato nell'85% dei casi": e' il 43%. Corretta la **descrizione** (potenza *misurata*, non attesa), non la soglia di niente.
- **Un errore mio trovato e tolto prima della consegna**: la prima versione moltiplicava per 8 un p che era gia' il p del minimo fra 8 valute (doppia correzione); rimosso in entrambi gli script. E il bootstrap da solo avrebbe proclamato USDCHF (6 su 6) "simbolo migliore": aggiunta la soglia p(caso) < 0,05/22 e la nota "IC degenere".
- **Non verificabile da me**: che il campo giri il preset del repo; `TimeGMT()` nel tester; lo spread dei cross; l'xlsx di Claudio.

## 10. File prodotti
- `report/MIGLIORA_BULGE_VIOLA_2026-10-08.md` (questo)
- `backtest_pipeline/sim_bulge_viola_dati.py`, `backtest_pipeline/sim_bulge_viola_portafoglio.py`, `backtest_pipeline/sim_bulge_viola_simboli.py` (sola lettura, ASCII, seme 20261008)
- Nessun file prova creato: il piano della parte 5 usa `backtest_pipeline/prove/BULGE_M1_cella_campo_lunga.txt` (gia' presente, gia' passato dal controllo del 03/10); i file prova di U1/U2 si scrivono dopo il SI di Claudio e passano da `controlla_prova.py` e dal cancello.
