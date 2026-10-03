# Bulge: come migliorarlo (03/10/2026) -- dal contratto ai meccanismi, e la prima misura

Mandato di Claudio (03/10): *"indagate anche per migliorare l'EA Bulge, fa tanti trade e si puo' ancora migliorare, vediamo di trovare come."*
Sola lettura del repo. Nessun backtest eseguito, nessun input/EA/preset toccato, il trial FTMO 1514806751 non si tocca per 14 giorni, nessuna taglia proposta.
Etichette: **[MISURATO]** letto o calcolato da file del repo (script: `backtest_pipeline/bulge_analisi_contratto.py`, seme 20261003) · **[DERIVATO]** calcolato da numeri scritti · **[NON MISURATO]** il dato non c'e'.
Stato del cancello: file prova passato dallo **strato 1** (`controlla_prova.py` OK, `controlla_riga.py --oggetto prova` nessun difetto). **Lo strato 2 (`controllo-preventivo`) NON e' stato invocato da me: il file non va lanciato ne' il dossier consegnato come definitivo prima di quel PASS.**

---

## 0. Risposta in dieci righe

1. **L'edge del Bulge non e' dimostrato da nessuna misura nostra** [MISURATO]. Il solo numero buono (PF 1,599, WR 80,22%, n 268) e' di Claudio, su 6 cross scelti, rischio 3%, dati al 40%, nessun IS/OOS. Tutto cio' che e' nostro sta sotto 1: v5.20 AMPIA Modello 1 PF 0,87 (IS, n 410) e 0,82 (OOS, n 363); antenato forward PF 0,83 (n 297); piccolo xlsx PF 0,86 (n 159); v5.20 forward PF 0,27 (n 24). **Lordo di commissioni e swap l'antenato fa PF 0,92: anche senza costi e' sotto 1.**
2. Quindi, per la regola del 19/08, **niente griglie sui parametri d'ingresso**. Non e' "motore morto": il certificato di morte e' vuoto su 3 punti su 5 (uscita, gemelli, TF) e il merito a lungo e' **[NON MISURATO]**.
3. **La forma del motore e' il problema, non un parametro**: vince poco, perde tanto (vincita media 19 contro perdita media 64 in backtest, 7 contro 35 sul v5.20 forward). Win rate di pareggio 77% (backtest) / 84% (v5.20 forward) contro 74% / 58% osservati.
4. **I costi valgono il 56% della perdita forward dell'antenato** (commissioni -371,69 + swap -277,66 su -1.158,06) [MISURATO].
5. **Il TP riscritto accorcia sempre la vincita, non la allunga mai**: 6 posizioni del trial su 10 hanno avuto il TP riscritto, **6 su 6 verso l'ingresso** (-1,2 / -6,8 pip) [MISURATO, n=10]. Il meccanismo e' strutturale (la mediana a 20 barre segue il prezzo).
6. **Scegliere/potare i cross NON e' sostenuto dai dati**: la dispersione per cross e' dentro il rumore (permutazione p~0,3 in backtest, 0,75 in forward) e il ranking per cross non persiste (Spearman -0,01 fra meta' del forward; 0,09 fra backtest e forward). Il "problema NZD" e' un sospetto (p grezzo 0,009 in backtest, ~0,07 corretto per 8 valute; 0,09 in forward ma sullo **stesso periodo**), da verificare a lungo, non da applicare.
7. **Il rischio per fattore comune e' reale come coda (NFP del 02/10), non come causa media**: le coppie dello stesso ingresso H1 che condividono una valuta con lo stesso segno perdono insieme l'11,9% delle volte contro il 9,4% dell'indipendenza (n 151 coppie, ~1 errore standard) [DERIVATO].
8. **Tre cose del motore non sono misurabili senza una modifica al codice** (da fare in copia per il banco, mai in campo): il TF e' **cablato H1** (r.605-607, 849, 1092-1095: un file con `@PERIODO M30` misurerebbe di nuovo H1), il TP fisso/dinamico, il time-stop. Il per-trade non ha l'ora d'ingresso ne' TP/SL d'ingresso.
9. **Prima misura pronta**: `backtest_pipeline/prove/BULGE_M1_cella_campo_lunga.txt` = la cella che e' davvero in campo sulla trial (Viola solo, 15 cross), 2010-2026.06, 4 passate. **Nessuna misura del repo copre quella cella.**
10. **Niente da firmare per eseguirla** (e' un file prova per il PC di backtest, 4 passate, nessun input in campo). Cambiare input o codice in campo resta firma di Claudio.

---

## 1. Il contratto del Bulge: cosa e' misurato e cosa NO

| Misura | Cella / versione | Finestra e regime | n | PF | WR | DD | Payoff e note | Fonte |
|---|---|---|---:|---:|---:|---:|---|---|
| Claudio (agli atti, NON nostra) | `BULGE_MULTI_SIGNAL`, BLU+VIOLA, GBPUSD + 5 cross, rischio 3%, dati 40% | 2022.01.01-2026.03.30, un periodo, un broker, **nessun IS/OOS** | 268 | 1,599 | 80,22% | 10,17% bil. / 10,35% eq. | vincita +131,63 / perdita -325,39 (0,40) | `mql5/Experts/ABTG_Bulge.mq5` r.27-39 |
| R92 (21/08) | v5.10 con il difetto della barra 0, 1 cross per passata | 2022.01.01-2026.06.30, Modello 1 | 106 su 22 cross (max 11 su GBPUSD) | senza senso (n 1-11) | non letto | 3,17% max | frequenza ~1,07 op/anno/cross contro ~10,5 dichiarate; **0 simboli su 22 passano S1**; gestita = nuda su 21 su 22 | `R92_REFERTO.md` |
| R92b (30/09) | v5.20, 22 cross, 26 passate | -- | **mai girato**: controllo R92b0 CSV assenti, `OnTesterInit works too long` | -- | -- | -- | -- | `ROUND_R92B_2026-09-30*/` |
| R92BAB (01/10) -- **analizzato qui per la prima volta** | v5.20 **AMPIA** (Blu+Viola+Arancio, ATR spento, Multi 1,0), 22 cross, Modello 1, deposito 10.000, rischio 0,80% | IS 2026.03.02-04.30 (n 410) / OOS 2026.05.02-06.29 (n 363): **4 mesi, un solo regime** | 410 / 363 | **0,871 / 0,816** | per-trade OOS 73,8% | **13,67% / 22,78%** | OOS: vincita media 19,03, perdita media 63,64, payoff 0,30, WR di pareggio 77,0%. VIOLA 190: PF 0,78. VIOLA sui 15 cross trial 128: PF 0,79 | `PERTRADE/` + CSV di `ROUND_R92BAB_*` |
| R92BAB, 8 cross (C e D) | stessa AMPIA su 8 cross dollaro | IS (n 242) / OOS (n 233) | 242 / 233 | 0,742 / 1,096 | -- | 13,04% / 10,55% | -- | idem |
| Piccolo xlsx (30/04-30/09) | versione vecchia (difetto primo tick), BLU+VIOLA, 22 cross | forward | 159 | 0,86 | 69,8% | -- | vincita 24,88 / perdita 66,88, WR di pareggio 72,9% | `BULGE_PICCOLO_PER_CROSS_2026-10-01.md` |
| Forward antenato `BULGE_MULTI_SIGNAL` | 22 cross, BCM 50503392 | 01/04-08/06/2026 | **297** | **0,83** (lordo 0,92) | 69,4% | -- | vincita 26,71 / perdita 73,19, payoff 0,365, WR di pareggio 73,3%; commissioni -371,69, swap -277,66 | `data/statements/trades_auto.csv` (la `giornata_2026-10-02.md` cita n 288, PF 0,8268: stesso insieme, filtro leggermente diverso) |
| Forward v5.20 piccolo | BLU+VIOLA, mix di giorni | 30/09-02/10/2026 | **24** | 0,27 | 58,3% | -- | vincita media 6,83 / perdita 35,27, payoff 0,19, WR di pareggio 83,8%. VIOLA 14: PF 0,36; BLU 10: PF 0,16 | idem |
| Trial FTMO (13 posizioni, 10 Bulge) | v5.20 Viola, 15 cross | 01-02/10/2026 | 10 | -- | 6 su 10 | -- | netto -1.870,73 su 10 (merito sospeso) | `TRIAL_GIORNO1_ANALISI_2026-10-01.md`, `ReportHistory_trial_1514806751_2026-10-03.xlsx` |

**Avvertenze di lettura [MISURATO]:**
- Il forward del piccolo e il trial **condividono le stesse operazioni** sui cross comuni (EURNZD buy 13:00 del 02/10 e' la stessa posizione sui due conti): non sono campioni indipendenti.
- Il backtest R92BAB e il forward dell'antenato **si sovrappongono nel tempo** (maggio-giugno 2026): sono la stessa tempesta vista due volte, non due conferme.
- R92BAB e' Modello 1 (OHLC) e **non** misura merito (R57: con i tick il segno puo' ribaltarsi). Il per-trade del backtest somma -945,78 contro il Profit del CSV -1.149,43: **-203,65 non spiegati** [NON MISURATO se commissioni/swap]; il PF letto dal CSV (0,816) e dal per-trade (0,84) differiscono per questo.
- **Cosa NON c'e'** [NON MISURATO]: qualunque misura v5.20 oltre i 4 mesi del 2026; qualunque misura della cella VIOLA solo a 15 cross a lungo; il costo vero per cross (spread dei cross: il `SPREAD_VIVO` copre solo EURUSD, GBPUSD, USDJPY fra i forex); il per-trade di R92b.

**Il banco ha un'altra irregolarita'** [MISURATO]: la gemella `+50` ha in IS un Profit piu' basso di 0,02-0,06 (A -860,62/-860,67; B -92,23/-92,29; C -1.014,25/-1.014,27), Trades uguali, in OOS identica. Un G1 esatto a 1e-6 (R92b_CRITERI E2) avrebbe **bocciato** quei file. La causa e' [NON MISURATA]. Nel file prova di M1 la tolleranza e' scritta prima dei numeri.

### Certificato di morte (CLAUDE.md 09/09): quali dei 5 punti ci sono
1. PF misurato: **si**, ma solo su 2026 (e col difetto o AMPIA, non la cella del campo). 2. n e DD: si, stesso limite. 3. **Gestione dell'uscita ad asse: NO** (R92: gestita = nuda su 21/22 per n minuscoli; in R92b nuda fissa). 4. **Simboli gemelli: NO** per i 7 cross fuori dai 15. 5. **TF cambiato: IMPOSSIBILE con l'EA com'e'** (H1 cablato). Verdetto: **NON ANCORA MISURATO**, non "morto".

---

## 2. Dove nasce la perdita: cosa dicono i dati che abbiamo gia' in casa

### 2.1 Payoff: il motore e' a vincite piccole e perdite grandi, e il pareggio sta troppo in alto [MISURATO]
| | vincita media | perdita media | payoff | WR di pareggio | WR osservato |
|---|---:|---:|---:|---:|---:|
| backtest AMPIA OOS (n 363) | 19,03 | 63,64 | 0,30 | 77,0% | 73,8% |
| antenato forward (n 297) | 26,71 | 73,19 | 0,365 | 73,3% | 69,4% |
| v5.20 forward (n 24) | 6,83 | 35,27 | 0,19 | 83,8% | 58,3% |
| trial, TP:SL per posizione (n 10) | -- | -- | da 0,03 a 0,64 | da 61% a 97% | 6 su 10 |

Distribuzione delle vincite del backtest in multipli della perdita tipica: decili 2,1 / 6,0 / 10,3 / 14,0 / 17,1 / 20,1 / 24,1 / 28,5 / 36,9 su una perdita di ~64: **mediana ~0,3 R, 90-esimo percentile ~0,6 R; 79 vincite su 268 sono sotto 10 (circa 0,15 R)**. Il disegno e' voluto dal coach ("ATR x 3 difficile da toccare, e' fatto apposta"): `ABTG_Bulge.mq5` dice di **non aggiustare il rapporto rischio/rendimento senza una decisione di Claudio**.

### 2.2 Costi: commissioni piu' swap [MISURATO]
- Antenato forward 297 posizioni: lordo -508,71 · commissioni -371,69 · swap -277,66 = **-1.158,06; i costi sono 649,35 = 56%**. PF lordo 0,92, PF netto 0,83.
- FTMO trial: commissione 2,21 EUR per lotto per lato (GBPNZD 6,25 su 2,83 lotti). Per posizione, commissione andata-ritorno in pip: EURGBP 0,37 · NZDCHF 0,41 · AUDUSD 0,50 · GBPAUD 0,71 · NZDJPY 0,79 · EURNZD 0,88 · GBPNZD 0,89 [DERIVATO da EUR/pip/lotto ricavato dai P/L delle posizioni]. **Lo spread dei cross e' [NON MISURATO]** (nessun file del repo lo contiene per questi simboli).
- TP mediano dai TP del forward BCM (n 229), per cross dei 15: NZDCHF 2,5 · USDCHF 3,7 · NZDUSD 3,7 · EURGBP 4,8 · NZDCAD 5,0 · NZDJPY 5,4 · CADCHF 5,9 · USDCAD 6,0 · AUDNZD 6,4 · CADJPY 7,1 · GBPNZD 8,0 · AUDCAD 12,2 · AUDJPY 12,3 · EURNZD 14,3 · GBPAUD 18,8 pip (pochi punti per cross: 4-23). **Per i 7 cross con la commissione in pip calcolata (EURGBP, NZDCHF, AUDUSD, GBPAUD, NZDJPY, EURNZD, GBPNZD) la sola commissione vale 4-16% del TP mediano, prima dello spread** (NZDCHF 16%, NZDJPY 15%, GBPNZD 11%).
- Trial, commissioni (gia' andata-ritorno nel report) contro TP lordo della posizione [DERIVATO]: GBPNZD del 02/10 (TP 2,7 pip) **33%** (12,57 su 38), NZDJPY 16% (24,57 su 152), NZDCHF **14%** (31,95 su 224, il numero gia' scritto il 01/10), EURNZD 13%, AUDUSD 6%, EURGBP 6%, GBPAUD 3,5%, le tre GBPNZD con TP largo 2-3%.
- **Cancello di costo della casa (stop >= 40 x (spread + commissione))** sullo SL del Bulge (3 ATR H1; mediane degli SL del forward BCM, n 71, 1-6 per cross): NZDCHF 16,8 pip -> budget 0,42 pip, commissione da sola 0,41: **resta 0,01 pip per lo spread**; EURGBP 14,1 -> 0,35, commissione 0,37: **fuori anche a spread zero**; NZDJPY 40,1 -> 1,00, commissione 0,79; GBPAUD 69,3 -> 1,73; EURNZD 76,7 -> 1,92; GBPNZD 80,3 -> 2,01. **Il cancello non si chiude per i cross a SL corto, e per gli altri dipende da uno spread che non abbiamo** [DERIVATO]. Il TF **M30 e' escluso PER COSTO**: lo SL scala ~0,7 (ATR M30 ~ ATR H1 / radice di 2 [DERIVATO, regola pratica non misurata]) -> NZDCHF ~11,9 pip, budget 0,30 pip contro 0,41 di sola commissione.

### 2.3 Selezione dei cross: la dispersione e' rumore [MISURATO + DERIVATO]
- Permutazione delle etichette dei cross fra le 363 posizioni del backtest OOS (5.000 permutazioni): p(dispersione >= osservata) ~ **0,29**; p(peggiori quattro <= osservati) ~ **0,35**. Stesso test sul forward antenato (297): **0,75 e 0,86**.
- Persistenza: forward antenato diviso a meta' per data di apertura, Spearman del netto per cross fra le due meta' (22 cross): **-0,01**. Backtest OOS contro forward dello stesso periodo (dal 04/05): **0,09**.
- **Conseguenza**: la tabella per cross del piccolo (AUDUSD PF 22, AUDNZD 0,10...) e' la forma del rumore, come gia' scritto lì; **nessun cross si promuove e nessuno si pota** su questi dati.
- **Gruppo NZD** (ipotesi nata guardando il report del piccolo, quindi post hoc): backtest OOS 109 posizioni con NZD, netto -1.139,8 su un totale -945,8 (il resto vale +194): p(sottoinsieme a caso <= osservato) = **0,009**, ~0,07 corretto per le 8 valute guardate. Forward antenato 95 posizioni NZD, -999 su -1.158: p = 0,091. **Non e' indipendente** (stesso periodo, e l'ipotesi viene dal piccolo). Nel backtest le posizioni NZD perdono **sia long sia short** (-674 e -466): non e' un NZD che trenda da una parte. Verdetto: **sospetto da verificare a lungo (M1 lo permette), non una regola**.

### 2.4 Rischio per fattore comune [MISURATO, DERIVATO]
- Forward antenato, coppie di ingressi nella stessa ora H1 su cross diversi: stesso segno su una valuta (n 151) -> entrambe perse 18 (11,9%); nessuna valuta in comune (n 80) -> 7 (8,8%); segno opposto (n 9) -> 2. Attesa sotto indipendenza 0,306^2 = 9,4%. **Lift ~1,27, scarto ~1 errore standard (~2,4 punti)**: non dimostrato come causa media. Le coppie si sovrappongono (la stessa posizione compare in piu' coppie): il conto e' indicativo.
- **Le due coppie NZD dello stesso secondo nel trial NON hanno perso insieme**: 01/10 06:00:00 GBPNZD sell (NZD long) + NZDCHF buy (NZD long): stesso segno, esiti +436,34 (TP 20:37) e -1.357,14 (SL 10:43); 02/10 16:00:00 GBPNZD buy (NZD short) + NZDJPY buy (NZD long): **segno opposto**, +385,13 e +139,57.
- **La coda vera e' l'evento**: il 02/10 EURNZD (entrata 13:00) e GBPAUD (entrata 15:00) vanno a SL alle **15:30:00 e 15:30:06 server FTMO** (rilascio NFP), -1.190,59 e -1.158,58. **Non hanno nessuna valuta in comune** (e nessuna ha il dollaro): hanno in comune un fattore firmato "lungo Europa contro corto antipodi (AUD/NZD)". Un cluster per valuta condivisa non li avrebbe presi. Sul piccolo, stesso minuto (13:30 server BCM): USDJPY, EURNZD, NZDCAD a SL. **Sono 4 posizioni uniche, non 5** (EURNZD e' la stessa sui due conti). Senza quelle due (-2.382,66 con commissioni) il Bulge del trial fa +511,93 invece di -1.870,73 [DERIVATO]: una coda da evento, non il difetto medio. Storia: **4 SL su 71** del forward Bulge sono alle 13:30 server BCM: il fenomeno e' reale ma e' una frazione piccola (6%) dei 71 stop.
- Il filtro news del Bulge e' `News_Block_Hours` in **ore UTC fisse, senza calendario**; acceso blocca 6 ore al giorno ogni giorno (`NFP_2026-10-02_SEDIE_TRIAL.md`); `data/abtg_news.csv` nel repo e' **vuoto** [MISURATO: 0 righe]. Quanti SL a lungo coincidono con eventi: [NON MISURATO] (manca la storia delle news).

### 2.5 Il TP riscritto [MISURATO sul trial, DERIVATO dal codice]
- `UpdateAllTP` (r.1922-1964) riscrive il TP ad **ogni tick** sulla mediana BB della barra 1, tenendo solo due condizioni: nuovo TP oltre l'ingresso e a >= 10 punti dal prezzo. Nessun minimo di distanza alla partenza: all'ingresso `OpenOrder` controlla solo `tp > ask` (long) / `tp < bid` (short).
- Trial: confronto fra il TP dell'ordine d'apertura e quello della posizione: **6 riscritti, tutti verso l'ingresso** (GBPNZD 01/10 sell -4,7 pip; GBPNZD B -6,8; AUDUSD -1,2; GBPNZD 02/10 -2,4 [TP finale 2,7 pip contro SL 87,8]; EURNZD -5,2 [da 12,2 a 7,0 pip]; EURGBP -1,8); 4 invariati; **0 allungati**.
- Meccanismo [DERIVATO]: si entra dopo una discesa (long), la media a 20 barre scende verso il prezzo, la mediana (il TP) lo segue verso l'ingresso. E' un accorciamento sistematico delle vincite, non un rumore.
- Segno dell'effetto sul PF: **non prevedibile**. TP piu' vicino = piu' tocchi (win rate su) e vincita piu' piccola (payoff giu'). Il test e' a due code.
- 4 posizioni del trial con TP/SL < 0,2 (NZDCHF, GBPNZD 02/10, EURNZD, NZDJPY) hanno fatto -2.372 (2 vinte +175, 2 perse -2.547); le altre 6 hanno fatto +706. **n=10: aneddoto, nessuna inferenza.**

### 2.6 La durata in posizione [MISURATO, con una trappola]
Forward antenato per tenuta: **<=4h n 88, PF 1,57, +887 · 4-12h n 129, PF 0,96, -98 · 12-24h n 64, PF 0,18, -1.301 · >24h n 16, PF 0,17, -646**. Le 80 posizioni oltre 12 ore: 41 vinte (+10,3 in media, swap incluso), 39 perse (-60,8): -1.948; le 217 entro 12 ore: +790.
**Trappola dichiarata**: la durata dipende dall'esito (chi vince col TP lo fa in fretta), quindi questa non e' una misura di cosa avrebbe fatto un time-stop: serve il mark-to-market all'ora N, che il per-trade non ha. Il Bulge **non ha nessuna uscita a tempo** nel codice (grep: zero `MaxBars/TimeStop/Hold`), e nell'audit `AUDIT_USCITE_2026-09-09.md` r.194 e 227 il time-stop condizionato ha zero occorrenze in 111 EA e il time-stop a barre e' "MAI" su asse.

### 2.7 Orario [DERIVATO, non significativo]
Ingressi per blocco d'ora server BCM (antenato): Asia 00-08 n 60, PF 1,07 · Europa 08-13 n 54, PF 0,54, -747 · USA 13-17 n 69, PF 0,80 · sera 17-24 n 114, PF 0,95. Il blocco 08-13 scelto dopo aver guardato 4 blocchi: p(sottoinsieme a caso <= osservato) = **0,082**. **Ipotesi, non esito.** Il per-trade del backtest ha solo l'ora di chiusura, non d'ingresso.

### 2.8 Uscite BE/trailing/parziale: inerti per costruzione [DERIVATO]
Con vincite a mediana ~0,3 R e 90-esimo percentile ~0,6 R, `Enable_BE_1R` a `BE_At_R=1,0`, trailing da 1,5 R e parziale a 1 R **quasi mai vengono raggiunti prima del TP**. E' coerente con il canarino 4 di R92 (gestita = nuda su 21 simboli su 22) e **cosi' le tre manopole sono "girate senza che mordessero"**: una casella libera, non provata. Per mordere servirebbe un BE sotto la vincita tipica (es. 0,1-0,3 R), ma li' converte molte vincite future in pareggi.

---

## 3. Le ipotesi, con attesa scritta PRIMA

Legenda "serve": **I** = solo input esistenti, nessun codice · **C** = serve una copia del banco con codice nuovo (telemetria o input nuovo), `mql5-ea-developer` + cancello; il campo non cambia · **F** = cambiarla in campo e' **firma di Claudio**.
Costo macchina = PC di backtest; riferimenti: R92BAB_A 95 s per 4 passate di 4 mesi su 22 cross; R92b proiettava ~3,7 minuti a passata di 16,5 anni su 22 cross; una gamba su 6 muore con `OnTesterInit works too long` (2 su 12 in R92BAB) e il driver non riprova.

| ID | Ipotesi (meccanismo) | Attesa scritta prima | Controesempio (cosa produce l'altra spiegazione) | Dato necessario | Serve | Costo macchina | Firma in campo |
|---|---|---|---|---|---|---|---|
| **M1** | **Il contratto della cella del campo** (Viola solo, 15 cross) a 16,5 anni | PF OOS 0,80-1,05; WR 70-77%; payoff 0,28-0,40; DD OOS 8-25% a 0,80%; n OOS ~1.000-2.500 (`BULGE_M1_cella_campo_lunga.txt`) | se PF OOS >= 1,30 e WR >= 65%, la tesi "motore buono" sopravvive in screening: banda 0,80-1,05 falsa | niente di nuovo | **I** | 4 passate, 15 cross: [DERIVATO] 15-60 min | no |
| **H-A** | Fattore firmato comune (Europa lunga / antipodi corti) + eventi come coda: un cluster per valuta condivisa non lo vede | lift della perdita congiunta >= 1,5 sul per-trade lungo = cluster firmato da valutare; lift <= 1,3 = il Guardian C1 basta | lift ~1 come nel forward (11,9% contro 9,4%) = nessun cap necessario; la perdita del 02/10 era un evento | `open_time` nel per-trade (oggi solo chiusura); in alternativa prossimita' di chiusura come proxy gia' misurabile da M1 | **C** (per l'ora d'ingresso) / **I** (proxy) | 0 dopo M1 | si (qualunque cap) |
| **H-B** | Il TP piccolo non copre costi: TP minimo in multipli di (spread + commissione) | Win rate delle posizioni con TP < 5x costo sotto il WR di pareggio di quella classe; filtrarle migliora il PF netto oltre il rumore A3 10,5% | win rate in classe bassa >= WR di pareggio (>= 90% per TP/SL 0,1): il filtro toglie edge | **spread per cross e ora** (script di sola lettura su `MqlRates.spread` M1 del PC di backtest: [NON VERIFICATO] che BCM lo registri); TP e SL d'ingresso per posizione | **C** (nuovo input, default spento) | sonda spread: minuti; round: 2 celle x 2 gambe ~ M1 | si |
| **H-C** | TP dinamico che si accorcia contro la vincita; payoff 1:3-1:30 | a due code: dinamico contro fisso all'ingresso -> vincita media +10-30%, win rate -2-8 punti, **segno del PF [NON PREVEDIBILE]** | PF uguale entro il 10,5% = il default va bene (risultato, non fallimento) | input `TP_Mode` nuovo; TP/SL d'ingresso in colonna | **C** | 2 celle x 2 gambe | si |
| **H-D1** | BE a soglia bassa (0,10-0,30 R), mai provato: le manopole attuali sono inerti | BE a 0,2 R trasforma una parte delle perdite in pareggi ma anche vincite in pareggi: PF netto tra -10% e +10% | PF > +10,5% con DD sotto = gestione utile | niente di nuovo (`Enable_BE_1R=1`, `BE_At_R` {0,1; 0,2; 0,4}) | **I** | 3 celle x 2 gambe | si |
| **H-D2** | Time-stop condizionato ("se dopo N barre non sei a +X R, esci"): la mean reversion che non e' tornata e' fallita | le posizioni oltre 12 barre (80 su 297 nel forward, PF 0,18) escono a una perdita media minore di -60,8 | se gli oltre-12-barre sono in perdita media vicina allo SL al momento dell'uscita, il time-stop non salva niente; se le vincite di 12-24 h (34 su 64) valgono piu' di quanto si evita, peggiora | MTM per posizione all'ora N (non nel per-trade); input `Max_Bars` nuovo | **C** | 4 celle {6,12,24,spento} x 2 gambe | si |
| **H-E** | Selezione dei cross | nessuna potatura: dispersione per cross p~0,3; **un test solo ha senso**: NZD contro resto a lungo | NZD con p < 0,05 su OOS 2022-26 (per-trade di M1) = ipotesi regge; p > 0,20 = era il regime 2026 | per-trade OOS di M1 | **I** (dopo M1) | 0 | no (ma togliere cross dalla lista = si) |
| **H-F** | Ora d'ingresso e tenuta attraverso le news | blocco Europa 08-13 PF < 1 anche a lungo se vero; stop sul rilascio USA > 5% degli SL | blocchi uguali entro il rumore = e' stato il 2026 | `open_time`; calendario news (`data/abtg_news.csv` e' vuoto: [NON MISURATO]) | **C** + dato esterno | 0-1 h | si |
| **H-G** | TF | M30 **escluso per costo** (sez. 2.2); H4 non escluso per costo ma frequenza ~1/4 [DERIVATO] | -- | input `Signal_TF` nuovo (oggi H1 cablato) | **C** | 2 celle x 2 gambe | si |

**Regola del 19/08 applicata**: M1 viene prima e decide. Se PF OOS < 1,05 nessuna delle righe H-B..H-D e' una *ottimizzazione*: restano **misure di meccanismo** da pagare con una prova fuori campione, e il percorso giusto e' la **seconda caccia** (meccanismi alternativi sulla stessa inefficienza) piu' che una griglia sul Bulge. Se 1,05 <= PF < 1,30, si apre solo l'uscita (H-D1, H-C, H-D2). Se PF >= 1,30 con S3, si va a tick reali prima di qualunque altra cosa.

---

## 4. La prima misura: `backtest_pipeline/prove/BULGE_M1_cella_campo_lunga.txt`

**Perche' questa e non un'altra** (miglior informazione per costo):
- E' l'**unica cella senza nessuna misura lunga** e la sola che e' in campo. R92b ha la P col Blu e l'ADX acceso (non e' la cella del trial), R92BAB ha l'AMPIA su 4 mesi.
- Costa 4 passate (2 celle identiche x 2 gambe), come R92b0, ed e' **un lavoro a cella sola**: nessun asse di strategia, quindi nessuna griglia.
- Il per-trade OOS (2022-2026.06, ~1.000-2.500 posizioni) alimenta **da solo** H-E (NZD contro resto), H-A (proxy di chiusura) e la forma del payoff, a costo zero; il TP/SL d'ingresso e l'ora d'ingresso restano [NON MISURATI] finche' non c'e' la copia con telemetria.
- n >= 150 per gamba e' una stima ampia [DERIVATA da 128 Viola su 15 cross in 2 mesi con l'AMPIA, scontata 30-70% per i due filtri in piu']. Se n < 150, il file lo dichiara e il merito e' sospeso (il rischio si legge lo stesso).

**Finestra e regime**: IS 2010.01.01-2021.12.31 (12 anni, regimi multipli: debito euro, calma 2013-14, shock SNB 15/01/2015 che tocca NZDCHF/USDCHF/CADCHF, Brexit, COVID), OOS 2022.01.01-2026.06.30 (dollaro forte, disinflazione 2023-24, 2025-26). Stessa finestra firmata da Claudio il 30/09 per R92b (`R92b_CRITERI.md` par. 0, 2): non e' una scelta nuova. GBPNZD parte dal 2010.05.10 (muro misurato), dichiarato nel file.

**Cosa il file impone prima dei numeri** (testo dentro il file): attese (n, PF, WR, payoff, DD), soglie congelate (S1 n>=150, S2 PF OOS >=1,30, S3 WR>=65% con profitto>0, PF<1,05 = niente griglie sull'ingresso, rumore A3 10,5%), controlli P0/G1/SHA256, e la verifica **somma del per-trade = Profit del CSV** da fare prima di leggere un PF.

**Contro-esempio costruito**: se il motore e' quello di Claudio (PF 1,60, WR 80%) la banda 0,80-1,05 e' falsa e le due ipotesi sono disgiunte; se la cella che gira non e' quella del campo (es. `Use_Blue=1` scivolato dentro), P0 la vede perche' legge le colonne del CSV. Confronto riga per riga col preset trial fatto a macchina: **tre** differenze (`InpMagic`, `InpVerbose`, `InpAutoTest`).

**Cosa M1 NON fa**: non misura il merito a tick reali (Modello 1 = screening, R57); non misura il cancello di costo (spread [NON MISURATO]); non e' un punto del certificato di morte oltre il primo; non propone nessuna taglia (Risk_Percent 0,80 e Max_Trades 4 sono quelli del preset trial copiati).

---

## 5. Buchi dichiarati
1. **Telemetria**: il per-trade del Bulge (`ExportTrades`) ha solo ora di chiusura; mancano `open_time`, `entry_sl`, `entry_tp`, MFE/MAE. Senza, H-B/H-C/H-D2/H-F non si testano. Serve una copia del banco (codice nuovo, comportamento di trading identico), mai il campo.
2. **Spread dei cross** per ora: [NON MISURATO]. Il cancello di costo non si chiude.
3. **-203,65** fra per-trade e Profit CSV di R92BAB_A: [NON SPIEGATO].
4. **Gemella +50 in IS** (scarto 0,02-0,06): causa [NON MISURATA].
5. **Tick reali**: tutto il backtest qui e' Modello 1; il verdetto non c'e'.
6. **Il piccolo e il trial** sono le stesse operazioni su 15 cross: il forward conta una volta.
7. **Calendario news**: `data/abtg_news.csv` vuoto; il peso storico degli eventi sugli SL e' [NON MISURATO].
8. Il passo 0 (profondita' dei dati) copre 21 cross su 22 dal 2010; la cella di M1 non ha il simbolo ospite fuori lista (grafico NZDCHF, dentro i 15).

## 6. Cosa NON ho fatto
Nessun backtest, nessuna riga di lancio, nessun preset, nessuna taglia, nessuna modifica all'EA, al campo, al forward, ai conti. `controllo-preventivo` non invocato. Fonti riaperte: `report/BULGE_PICCOLO_PER_CROSS_2026-10-01.md`, `TRIAL_GIORNO1_ANALISI_2026-10-01.md`, `TRIAL_SFORTUNA_O_EA_2026-10-03.md` (solo la sezione 0, ancora senza risultati), `R92BAB_LETTURA_2026-10-01.md`, `R92b_CRITERI.md`, `R92_REFERTO.md`, `FIRME_2026-09-29_BULGE_R92B.md`, `AUDIT_USCITE_2026-09-09.md`, `docs/RISPOSTA_A_GEMINI_2026-10-03.md`.
