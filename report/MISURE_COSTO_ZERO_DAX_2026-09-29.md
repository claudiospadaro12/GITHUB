# MISURE A COSTO ZERO sul DAX Apertura (770101 LONG, 770105 SHORT), notte 28/29-09-2026

Mandato: Claudio, notte 28/29-09 («fate tutto in background, l'obiettivo e' avere piu' sedie per le prop»). Domande nate da
`docs/RISPOSTA_A_GEMINI_R270_2026-09-28.md` (righe 1 e 4) e da `report/LETTURA_R270_2026-09-28.md` (PASS f01d18d2).
**Niente MT5, niente macchina: solo Python sui per-trade gia' in archivio.** Nessuna taglia, nessuna sedia toccata, nessuna
promozione. E' materiale per la firma pendente di Claudio su `InpTP1_ClosePct=0` e per il prossimo round short.

## PER CLAUDIO, IN 5 RIGHE
1. **Misura 1, verdetto: «NON SEPARABILE con questi file».** Il vantaggio del senza-parziale (**+4,83 R** in un anno) c'e', ma
   **sta in 4-5 giornate**: la mediana e' **negativa** (-0,047 R), 51 runner su 77 escono sotto il livello della parziale, e **le 5
   giornate migliori valgono il 141% del totale**: tolte quelle 5, il senza-parziale PERDE (-1,97 R). 🔴 **Il «toro» di Gemini
   questa gamba NON lo puo' ne' confermare ne' escludere**: l'anno OOS e' piatto (DAX +2,0%), e il tetto di deriva e' basso **per
   costruzione** (runner mediano 9 minuti: anche un anno a +25% darebbe circa 0,24 R; per spiegare 4,83 R servirebbe un DAX a circa
   +500%), quindi il suo «no» non e' un contro-esempio. Il dato utile e' un altro: **il vantaggio esiste anche in un anno senza toro**,
   ma sono sempre le stesse code (4 delle 5 migliori cadono in mesi GIU': tolte quelle 5, mesi SU e mesi GIU' sono negativi TUTTI E DUE).
2. 🔴 **Da tenere davanti alla firma (NON e' una scoperta: e' scritto dal 12/09 in `LE_QUATTRO_FIRME` r.714 e dal 22/09 in
   `LA_CELLA_SENZA_BREAKEVEN`, qui lo si PESA): con `InpTP1_ClosePct=0` il PAREGGIO A TP1 NON SCATTA MAI**, anche con
   `InpBreakevenAtTP1=1` (annidato in `if(!partialDone && InpTP1_ClosePct > 0 ...)`, dall'08/08 a HEAD). La cella misurata e'
   **«niente parziale E niente pareggio»**. Sui dati: 2 giornate su 77 divergono (05/01/2026 +2,51 R, 25/02/2026 -1,48 R), insieme
   **+1,03 R dei 4,83 (21%)**. La cella pulita (`ClosePct=0` + `InpBEatR=1.0`) e' **gia' scritta, `R207b`, dal 22/09, e non ha
   nessun risultato in archivio**: mai girata. Stato nel repo: preset REALE a 0 dal 14/09 (firma r137c) **con `InpBEatR=0`: il REALE
   gira GIA' esattamente la cella misurata qui (niente parziale E niente pareggio), non quella pulita**; FTMO, 100k, piccolo a 50.
   👉 **Cosa cambia nella firma FTMO**: firmare oggi ClosePct 0 vuol dire comprare 4-5 giornate di coda e togliere il pareggio;
   la misura che separa le due cose e' `R207b` (tetto 17 minuti di PC di backtest, da ri-passare dal cancello). La firma resta tua.
3. **Misura 2, verdetto: «NON MISURABILE dai per-trade».** Lo short ha il fill in **194 giornate su 268** (72,4%); 74 restano a
   secco, e il per-trade non dice se il range non si e' rotto o si e' rotto senza ritorno. Sulla parte che SI' si puo' misurare
   (15 rotture ribassiste CERTE, riconosciute dallo stop pieno del long) il retest ha preso **13 su 15**; lo specchio sul lato
   rialzista da' **33 su 36**: il retest manca circa una rottura su 8-12, **in tutte e due le direzioni**. Niente che dica «i crolli
   in particolare». 🔴 Cautela: il controllo della premessa congelato e' CADUTO (8 su 13 entro 1 punto), quindi per regola quel
   conteggio e' fuori dal verdetto; il verdetto non cambia con o senza. Il P/L dei crolli mancati non sta in nessun file.
4. **La misura corta che risponde** (file NON scritto, proposta al §4): tre celle short (RETEST vivo con il suo per-trade, che oggi
   manca · BREAKOUT scadenza 120 · BREAKOUT scadenza 535), circa 3 minuti di PC di backtest. Per la misura 1 il file c'e' gia':
   **`R207b`** (`ClosePct` 0/50 con `InpBEatR=1.0`), scritto il 22/09 e mai lanciato: va ri-passato dal cancello e mandato.
5. **Buchi dichiarati**: il per-trade copre solo la gamba OOS (un anno, un regime); l'IS c'e' solo come aggregato; l'ora
   d'ingresso non e' nell'export; il per-trade dello short VIVO non esiste (R270 ha esportato TrailStartR 1,5 e FIXED).
   Nessuna taglia, nessuna sedia, nessun preset toccato.

## 0. CRITERI CONGELATI PRIMA DEI NUMERI (questa sezione e' committata DA SOLA, prima di qualunque calcolo)

**Cosa avevo gia' visto quando ho scritto questa sezione** (per onesta' di tracciabilita'): i numeri aggregati dei CSV R47a/R47b
(gia' in `LETTURA_R270`: IS PF 1,126 vs 1,183, OOS 1,397 vs 1,491, DD OOS 7,23 vs 6,27), le teste dei file prova, e le
prime ~12 righe di `772501`/`772503` e le prime 2 di `786322`/`786324` (solo per il formato). Nessun conteggio, nessuna somma.

### 0.1 Fatti di struttura letti PRIMA (dai file, non assunti)
- **Chi e' chi (dalla testa, non assunto)**: `prove/R47a_pertrade_DAX_base.txt` = `InpTP1_ClosePct=50`, magic **772501/772502**
  (sweep gemello) = **il VIVO**; `prove/R47b_pertrade_DAX_cand.txt` = `InpTP1_ClosePct=0`, magic **772503/772504** = **SENZA
  PARZIALE**. Tutti gli altri input identici riga per riga (BE a TP1 = 1 in TUTTE E DUE; trailing PREVBAR M5 da 0R; TP1 1R).
- **Il per-trade copre SOLO la gamba OOS** (prima chiusura 2025.06.11): l'export per magic viene sovrascritto dall'ultima passata,
  che e' l'OOS. **La gamba IS 2024.09.26-2025.06.10 NON ha per-trade**: per l'IS esistono solo i CSV aggregati. Quindi il
  «semestre 2024.09-2025.03» chiesto dal mandato NON e' misurabile per giornata: lo sostituisce il confronto aggregato IS (gia'
  noto, dichiarato sopra).
- **I `position_id` NON sono confrontabili fra le due celle** (il vivo consuma un ticket in piu' a ogni parziale: la terza
  posizione e' id 7 nel vivo e id 6 nel senza-parziale). L'abbinamento si fa per **GIORNATA** (data di chiusura): e' lecito
  perche' `InpOneTradePerDay=1` e `InpCloseAtEnd=1` (flat 17:30) -> una posizione al giorno, chiusa lo stesso giorno. Si verifica.
- **Il lotto dipende dal SALDO** (`CalcLotByRisk`: 1% di `ACCOUNT_BALANCE`, arrotondato per DIFETTO al passo): il senza-parziale
  accumula di piu' e quindi apre lotti piu' grossi nel tempo. Una parte del vantaggio in EURO e' **composizione**, non gestione.
  Per questo l'unita' di misura del confronto e' la **R del giorno** = P/L / (1% del saldo prima della giornata, stessa cella).
- **Meccanica (dal sorgente, da VERIFICARE sui dati)**: le due celle hanno la stessa entrata, lo stesso stop e lo stesso BE a TP1.
  Differiscono SOLO dopo TP1: il vivo chiude meta' a 1R e tiene l'altra meta' sul trailing; il senza-parziale tiene tutto.
  Quindi, per costruzione: nelle giornate SENZA TP1 le due celle sono **identiche per lotto** (stesso prezzo d'uscita); nelle
  giornate CON TP1 la differenza e' **0,5 x (X - 1R)**, con X = uscita del runner in R. 🔴 **Conseguenza da dire subito**: la
  misura (c) del mandato («nelle giornate perse il senza-parziale perde di piu' o uguale?») per costruzione da' UGUALE, e la
  regola «se viene anche da minori perdite = selezione» NON PUO' scattare mai: il senza-parziale non ha nessun modo di perdere
  di meno. Quel criterio e' degenere; lo si verifica sui dati (contro-esempio S3) e poi si usano le misure che separano davvero.

### 0.2 MISURA 1 — LONG 770101: vivo (ClosePct 50) contro senza parziale (ClosePct 0). SELEZIONE o ESPOSIZIONE?
Fonti: `risultati_prove/aperture_r47/abtg_trades_ABTG_DAX_Apertura_EU_D30EUR_77250{1,2,3,4}.csv` (`;`) e
`ABTG_DAX_Apertura_EU_D30EUR_{IS,OOS}_r47{a,b}.csv` (`,`).

Definizioni:
- Giornata **P** = il vivo ha >= 2 deal (TP1 preso, parziale chiusa). Giornata **N** = 1 deal (TP1 mai preso).
- `R_cella(g)` = somma P/L della giornata / (0,01 x saldo della cella prima della giornata; saldo iniziale 100.000).
- `D(g)` = R_senzaparziale(g) - R_vivo(g).
- **Esposizione extra MISURABILE** (non era chiesta, ma i file la danno): nelle giornate P l'ora della parziale (deal 1 del vivo)
  e l'ora d'uscita del runner (deal 2) ci sono: l'esposizione in piu' del senza-parziale e' `(V/2) lotti x (t2 - t1) minuti`.
  L'ora d'INGRESSO resta ignota: l'esposizione PRIMA di TP1 e' uguale nelle due celle per costruzione, quindi non serve.
- **Tetto di deriva (beta del toro)**: `mu` = (ultimo prezzo - primo prezzo del D30EUR nella gamba, dai deal dei file) /
  (giorni di borsa della gamba x 570 minuti di sessione 08:00-17:30). E' un **TETTO**: attribuisce tutto il rialzo dell'anno alle
  sole ore di sessione (niente ai gap notturni). Contributo di deriva in R della giornata P =
  `0,5 x V x k x mu x (t2 - t1) / (0,01 x saldo)`, con `k` = EUR per punto per lotto misurato dai deal (due deal della stessa
  posizione: `k = (pnl1/V1 - pnl2/V2) / (p1 - p2)`). `Dtetto` = somma sulle giornate P.
- **Direzione del mese**: mese SU / GIU' dal primo e dall'ultimo prezzo dei deal D30EUR del mese (unione dei file DAX della gamba).
  Proxy grezzo del regime, dichiarato tale.
- **Tratti** (i confini del mandato dove ci sono dati): IS 2024.09.26-2025.06.10 (solo aggregato CSV) · T2 = 2025.06.10-2025.09.30
  · T3 = 2025.10.01-2026.06.30. In piu', descrittivo e fuori dal verdetto: estate/inverno (orologio BCM, `CLAUDE.md` 24/09).

Controlli di struttura (se uno cade, la scomposizione non vale e il verdetto e' NON SEPARABILE salvo spiegazione scritta):
- **S1** gemelli identici: 772501 = 772502 e 772503 = 772504 riga per riga (a meno del magic).
- **S2** stesse giornate: l'insieme delle date di chiusura e' lo stesso nelle due celle, una posizione per data, n = 193.
- **S3** giornate N: prezzo d'uscita identico e |D| <= 0,02 R in almeno il 95% delle giornate N.
- **S4** giornate P: prezzo d'uscita del senza-parziale = prezzo del deal 2 del vivo in almeno il 95% delle giornate P.

Verdetto (una riga, regole fissate ORA):
- **«SELEZIONE»** se TUTTE: somma D sulle P > 0; somma D >= 3 x `Dtetto`; somma D > 0 in T2 E in T3 (e IS aggregato: senza-parziale
  >= vivo in PF); somma D > 0 sulle giornate P dei mesi GIU' (servono almeno 10 giornate P in mesi GIU', altrimenti la condizione
  e' non verificabile e SELEZIONE non si puo' dare); somma D senza le 5 giornate migliori > 0.
- **«ESPOSIZIONE»** se ALMENO UNA: somma D <= `Dtetto` (la deriva del toro basta a spiegarla); oppure, con almeno 10 giornate P in
  mesi GIU', somma D <= 0 nei mesi GIU' mentre > 0 nei mesi SU.
- **«NON SEPARABILE con questi file»** in tutti gli altri casi.

**Attesa dichiarata PRIMA**: S1-S4 reggono (>= 95%). Mediana di D sulle giornate P **negativa** (la maggior parte dei runner
rende indietro sotto 1R col PREVBAR), media positiva: guadagno portato dalle code. Somma D **molto sopra** il tetto di deriva
(ordine 10x: un rialzo annuo del 4-5% spalmato sui minuti di sessione e' piccolo). Togliendo le 5 migliori mi aspetto che la somma
**cambi segno** (code grasse). Esito atteso: **«NON SEPARABILE»** (ne' deriva pura, ne' selezione robusta).

Contro-esempi dello strumento (autotest dello script, prima di leggere i dati veri):
- due celle IDENTICHE -> D = 0 ovunque, verdetto NON SEPARABILE (nessuna differenza da spiegare, somma D = 0 non e' > 0);
- una cella col P/L RADDOPPIATO solo sulle giornate vinte (e con durata del runner che rende la deriva sufficiente) -> ESPOSIZIONE;
- una cella che guadagna di piu' in tutti i tratti e in tutti i mesi, anche senza le 5 migliori, molto sopra la deriva -> SELEZIONE.

### 0.3 MISURA 2 — SHORT 770105: il RETEST «lascia a secco i crolli veri»?
Fonti: `risultati_archivio/ROUND_R270_USCITA_DAX_2026-09-28/PERTRADE/abtg_trades_..._786322.csv` (TrailStartR 1,5) e
`..._786324.csv` (TrailMode 2 FIXED) — 🔴 **nessuno dei due e' l'uscita del vivo** (TrailStartR 0, mode 1): il per-trade esiste
solo per la passata identificata. Le ENTRATE pero' non dipendono dall'uscita (una posizione al giorno, flat 17:30): le giornate
di fill sono le stesse, e si VERIFICA (786322 contro 786324). Gamba OOS 2025.06.10-2026.06.30 (`@FINOA` della prova).

Meccanica dal sorgente al pin `e6b89c2b` (`MonitorRetest`): armo alle 08:35 server; la ROTTURA ribassista conta quando
`bid <= minimo_range - 5 punti` in qualunque momento fino alle 17:30; allora si piazza un SELL LIMIT a `minimo_range + 2 punti`
che scade dopo 120 minuti. Nessun filtro attivo (volumi, spread, EMA, news spenti nella prova) -> **ogni rottura piazza il pendente**.

(a) **Giornate di borsa**: calendario A = giorni feriali della gamba meno le chiusure Xetra: 24, 25, 26, 31/12/2025, 1/1/2026,
3/4/2026 (Venerdi' Santo), 6/4/2026 (Pasquetta), 1/5/2026. (3/10 e Pentecoste: Xetra aperto, contati.) Calendario B (empirico) =
date con almeno un deal in uno qualunque degli 8 per-trade DAX della gamba (772501-4, 786322-5): e' un PAVIMENTO dei giorni in
cui il CFD era operabile. Si dichiara anche con e senza il 30/06/2026 (inclusivita' della data finale del tester NON verificata).
Giornate senza fill = A - fill. Dai soli per-trade **NON si distingue** «range non rotto» da «rotto senza retest».
- 🟢 **Ma una parte SI' si distingue, ed e' una misura in piu'**: lo stop INIZIALE del long (`InpSLMode=0`) e' esattamente
  `minimo_range - 5 punti` = il grilletto dello short, e scatta sulla stessa condizione (`bid <=`). Quindi **ogni giornata in cui il
  long 770101 (vivo, 772501) ha preso lo stop PIENO e' una giornata di rottura ribassista CERTA**. Stop pieno riconosciuto cosi':
  perdita >= 1,00 R del saldo (col lotto arrotondato per difetto, uno stop trascinato sopra il livello non puo' arrivare a 1,00 R),
  chiusura prima delle 17:29. Banda larga dichiarata a parte (>= 0,97 R) come stima, non come certezza. Commissioni: si verifica
  che non ci siano (se `k` costante e somme = CSV).
  Su quelle giornate: short con fill = «rotto CON retest»; short senza fill = «rotto SENZA retest entro 120 minuti» (CERTO).
  🔴 Campione DISTORTO e dichiarato: sono giornate che prima sono salite (il long e' entrato) e poi sono crollate; non sono un
  campione pulito dei «crolli veri». Danno un conteggio minimo, non una frequenza.
- **Contro-esempio della premessa** (non circolare: due backtest diversi, due file diversi): nelle giornate con stop pieno del
  long E fill dello short, il prezzo d'uscita del long deve stare a `ingresso_short - 7 punti` (ingresso short ricostruito dal
  suo P/L con `k`). Attesa: scarto <= 1 punto in almeno l'80% dei casi. Se cade, il conteggio delle «rotture certe» si ritira.
(b) Giornate con fill: distribuzione del P/L (EUR e R), quota vinte, ora di chiusura (server), per le DUE uscite disponibili.
(c) **P/L virtuale dei crolli senza retest: NON MISURABILE** dai per-trade (servono i prezzi del giorno dopo la rottura). Si propone
la misura corta (file prova NON scritto).

Verdetto (una riga, regole fissate ORA): la tesi ha due meta' — (1) il RETEST manca molte rotture; (2) quelle rotture mancate
erano crolli in utile. La (2) non e' nei file, quindi:
- **«tesi NON SOSTENUTA»** solo se sulla parte misurabile il RETEST prende il fill in >= 90% delle rotture certe (non lascia a secco
  quasi niente, e allora la meta' (2) non conta);
- altrimenti **«NON MISURABILE dai per-trade»**, con accanto il numero della meta' (1) (X rotture certe senza retest su Y).
- «tesi SOSTENUTA» NON e' raggiungibile da questi file (servirebbe la meta' (2)).
**Attesa dichiarata PRIMA**: fill short in circa 194 giornate su ~258 (circa 75%); rotture certe dal long: qualche decina; di
queste mi aspetto che una quota NON piccola (30-60%) resti senza retest -> esito atteso «NON MISURABILE dai per-trade».

Autotest dello script (contro-esempi): due celle identiche -> nessuna differenza; cella col P/L raddoppiato solo sulle vinte ->
ESPOSIZIONE (vedi 0.2).

---
## 1. Controlli di nullita' e struttura (eseguiti, dallo script)
Script: `backtest_pipeline/misure_costo_zero_dax.py` (autotest 8 su 8 prima delle misure; senza `--autotest` stampa tutto).

| controllo | esito |
|---|---|
| S1 gemelli: 772501 = 772502, 772503 = 772504 riga per riga | **SI'** |
| C0 somma per-trade = Profit CSV OOS | vivo 18.029,58 = 18.029,58 · senza 23.607,28 = 23.607,28 |
| S2 stesse giornate, una posizione per giornata | **SI'**: 193 = 193 (vivo 270 deal = 116 giornate da 1 deal + 77 da 2) |
| lotto totale uguale nelle due celle | 29/193: il resto e' la **composizione del saldo** (per questo si ragiona in R) |
| S3 giornate N: stessa uscita, abs(D) <= 0,02 R | **116/116** (soglia 95%) |
| S4 giornate P: uscita del senza = deal 2 del vivo | **75/77** = 97,4% (soglia 95%): passa. Le 2 fuori sono spiegate al §2.2 |
| k (EUR per punto per lotto) | 1,0000 (p5 = p95 = 1,0000, 77 posizioni long e 86 short): nessuna commissione nel netto |
| short: fill 786322 = 786324 | **SI'**: 194 = 194 stesse date, una posizione per giornata (l'entrata non dipende dall'uscita) |

✏️ **Nota di implementazione, dichiarata**: la prima stesura dello script dava «ESPOSIZIONE» a due celle IDENTICHE (somma D = 0 <=
tetto = 0). L'autotest congelato al §0.2 chiede NON SEPARABILE: la regola ESPOSIZIONE ora richiede un guadagno da spiegare
(somma D > 0). E' la lettura della regola congelata, non un criterio nuovo; l'ha trovato l'autotest prima dei dati veri.
✏️ **Aggiunta del controllo preventivo (29/09)**: il difetto stava nel CRITERIO, non nello script: la regola «ESPOSIZIONE se somma D
<= tetto» e l'autotest «celle identiche -> NON SEPARABILE» erano in contraddizione dentro la sezione 0, e la correzione sceglie
l'autotest. Sui dati veri e' **non vincolante** (somma D = 4,827 > 0: il verdetto e' lo stesso con e senza). 🔴 E la mutazione
dice una cosa in piu': l'autotest 2 ottiene ESPOSIZIONE solo con `mu` = 2,0 punti/minuto (**627 volte** la deriva vera); sui
per-trade VERI, «P/L raddoppiato solo sulle vinte» con la deriva vera esce **SELEZIONE**, e resta SELEZIONE anche con la deriva
moltiplicata per 10, 100, 300. **Il ramo «deriva» di ESPOSIZIONE su questo EA non puo' scattare** (servirebbe `mu` = 0,81 punti/
minuto, 254 volte quella vera): l'unico ramo di ESPOSIZIONE raggiungibile e' quello dei mesi SU/GIU' (verificato: guadagno solo nei
mesi SU -> ESPOSIZIONE). Classe 916.

## 2. MISURA 1 — LONG 770101: SELEZIONE o ESPOSIZIONE?
Gamba OOS 2025.06.10-2026.06.30, 193 giornate, unita' = R della giornata (1% del saldo della stessa cella prima della giornata).

### 2.1 I numeri
| misura | valore | fonte |
|---|---|---|
| somma R: vivo / senza parziale | 17,025 / 21,830 -> **+4,805 R** | per-trade 772501 / 772503 |
| di cui giornate N (116, TP1 mai preso) | **-0,022 R** (= zero: stesse uscite, conferma della meccanica) | S3 |
| di cui giornate P (77, TP1 preso) | **+4,827 R** | S4 |
| in EURO | 18.029,58 / 23.607,28 (+5.577,70: include la composizione) | C0 |
| D sulle P: mediana · media · quota D>0 | **-0,047** · +0,063 · 33,8% (26 su 77) | |
| D sulle P: quantili 10/25/50/75/90% | -0,160 / -0,114 / -0,047 / +0,094 / +0,480 | |
| livello REALE della parziale (R iniziali) 5/25/50/75/95% | 0,213 / 0,379 / **0,568** / 0,876 / 1,070 (59 su 77 sotto 0,9R) | formula: 2 x P/L del deal 1 / (1% del saldo); l'ingresso non serve perche' il lotto e' tarato perche' lo stop pieno valga 1% del saldo. **Limite: e' un LIMITE INFERIORE** (lotto arrotondato per difetto; deal 1 = 48,5-50% del lotto, mediana 49,7%): corretto per il volume la mediana e' 0,573. Il bersaglio di TP1 si misura dallo stop CORRENTE, che il PREVBAR alza (`InitialSL` con `partialDone=false`). Riconferma su un file diverso della mediana 0,57R di `LA_BANDA_BASSA` errata 25/09 (R246) |
| D<0: runner uscito sotto il livello della parziale | **51** su 77 (a prezzo, deal 2 < deal 1: 52); senza parziale al TP duro 3R: 6 | |
| somma D>0 / somma D<0 | +11,261 (26 giornate) / -6,434 (51 giornate) | |
| durata del runner t2-t1 (minuti) 10/25/50/75/90% | 5 / 6 / **9** / 14 / 21 | ore dei deal |
| esposizione extra totale | 6.764 lotti x minuti | |
| **tetto di deriva** (mu = 0,00319 punti/minuto: 24.115,5 -> 24.602,7 = +2,0% in 268 giornate x 570 min) | **0,019 R** contro 4,827 R: **254x** | prezzi dei deal |
| T2 (2025.06.10-09.30) / T3 (2025.10.01-2026.06.30) | +0,823 R su 17 P / +4,004 R su 60 P | |
| IS aggregato (CSV): vivo / senza | PF 1,126 / 1,183 · DD 5,44% / 4,96% · Profit 3.789 / 5.569 | `_IS_r47a/b.csv` |
| mesi SU (7) / mesi GIU' (6) | +0,454 R su 39 P / **+4,373 R su 38 P** | direzione dal primo/ultimo deal del mese |
| top 5 D | 2,511 · 1,176 · 1,052 · 1,030 · 1,026 = **141% del totale** | |
| somma senza le top-k, k = 1..5 | 2,316 · 1,140 · 0,088 · **-0,942 · -1,968** | |
| DD della curva in R (dal picco) | vivo 6,36 R · senza 5,48 R — **NON VIOLATO su n = 193** in tutte e due (classe 804: nessun «passato») | |

Descrittivo, FUORI verdetto (non era nei criteri come condizione): tre terzi di giornate P = +1,874 / +3,997 / **-1,044**; estate
+1,071 R su 37 P, **inverno +3,756 R su 40 P** (inverno = mesi in cui il banco BCM a ora 8 arma **un'ora prima** dell'apertura cash,
`CLAUDE.md` 24/09: il grosso del vantaggio sta nella meta' dell'anno che il campo FTMO NON replica nell'orario).

### 2.2 🔴 Le due giornate divergenti: il pareggio a TP1 e' spento dal codice quando ClosePct = 0 (gia' noto dal 12/09, qui pesato)
| giornata | vivo (ClosePct 50) | senza parziale (ClosePct 0) | D |
|---|---|---|---|
| 05/01/2026 | TP1 alle 09:02:52 (+536,13), runner a PAREGGIO alle 09:05:38 (-11,27) | tenuto intero fino alle 09:20:10, esce al TP duro 3R (+3.283,42) | **+2,511** |
| 25/02/2026 | TP1 alle 09:05:10 (+593,02), runner a PAREGGIO alle 09:08:09 (-10,50) | tenuto intero, **stop pieno** alle 09:14:56 (-1.230,88 = circa -1R) | **-1,482** |

Nel vivo, a TP1 lo stop va a pareggio; nel senza-parziale NO: `ManageOneTicket` mette il pareggio a TP1 dentro
`if(!partialDone && InpTP1_ClosePct > 0 && InpTP1_ClosePct < 100)` (pin `e6b89c2b` r.2359/2391; identico a `6074126d` 08/08,
`c88d160a` e `bc110939` 14/08, e HEAD). Con ClosePct 0 il blocco intero e' saltato, e con `InpBEatR=0` nessun altro pareggio.
Nelle altre 75 giornate P il trailing PREVBAR da 0R aveva gia' portato lo stop sopra l'ingresso, e il pareggio non cambiava niente.
- ✏️ **Correzione alla sezione 0** (che resta com'e', congelata): li' ho scritto «BE a TP1 = 1 in TUTTE E DUE». **Vero come input,
  falso come effetto** — e il fatto era gia' in archivio (`LE_QUATTRO_FIRME_2026-09-12.md` r.714, con lo stesso -1,482 R del
  25/02/2026; `LA_CELLA_SENZA_BREAKEVEN_2026-09-22.md`; commento del preset REALE r.124-133). L'ho riletto dal codice DOPO averlo
  visto nei dati: avrei dovuto cercarlo prima. Non tocca i controlli (S3 116/116, S4 75/77 sopra soglia) ne' il verdetto.
- ✏️ **Seconda correzione alla sezione 0**: «TP1 a 1R» e' il NOME dell'input, non il punto dove la parziale scatta. Il bersaglio e'
  `ingresso + (ingresso - stop CORRENTE) x 1`, e il PREVBAR da 0R alza lo stop prima: la parziale scatta a **mediana 0,568 R
  iniziali** (tabella 2.1). Quindi D = 0,5 x (X - T) con T il livello vero della parziale, non 0,5 x (X - 1). La misura di D (in R
  del saldo) non cambia; cambia solo la frase «il runner oltre 1R», che va letta «il runner oltre il livello della parziale».
- **Peso nel risultato**: le due giornate insieme valgono **+1,029 R** dei 4,827 (21%). Senza di loro: 75 giornate P, somma
  **+3,798 R**, senza le top-k (k = 1..5) = 2,622 · 1,570 · 0,540 · **-0,486 · -1,471**: il quadro non cambia.
- **Cosa vuol dire per la firma pendente**: firmare «ClosePct = 0» come e' stato misurato vuol dire firmare **niente parziale E
  niente pareggio a TP1**. Chi lo leggesse come «stessa gestione, solo senza la parziale» sbaglierebbe la sedia.

### 2.3 Verdetto (regole del §0.2, applicate alla lettera)
- ESPOSIZIONE? somma D 4,827 > tetto 0,019 (no) · mesi GIU' +4,373 > 0 con 38 >= 10 giornate (no) -> **non scatta**.
- SELEZIONE? somma > 0 **si'** · >= 3 x tetto **si'** · T2 e T3 > 0 **si'** · IS senza >= vivo **si'** · mesi GIU' > 0 **si'** ·
  senza le 5 migliori > 0 **NO (-1,968)** -> **non scatta**.

> **MISURA 1: «NON SEPARABILE con questi file».** Il vantaggio del senza-parziale esiste in un anno senza toro (DAX +2,0%), ma e'
> una **scommessa sulle code** che non regge senza le sue
> 3-4 giornate migliori, su un anno solo, e con dentro un secondo meccanismo (niente pareggio) che l'archivio conosce dal 12/09 ma
> che il confronto di agosto non separa dalla parziale.

🔴 **Cosa NON dice questo verdetto (controllo preventivo, 29/09)**: che «non e' il toro». Il «no» del ramo deriva e' scontato per
costruzione (vedi §1: il ramo non puo' scattare su runner da 9 minuti), e il «no» del ramo SU/GIU' e' portato dalle stesse code: 4
delle 5 giornate migliori (05/01, 25/03, 27/11, 03/11) cadono in mesi GIU', e tolte le 5 migliori la somma e' **-0,598 R** nei mesi
SU e **-1,370 R** nei mesi GIU'. La tesi di Gemini riguarda il «biennio toro», cioe' la gamba IS, che qui ha solo l'aggregato: su
questa gamba l'esposizione **non e' ne' confermata ne' esclusa**. Il verdetto (NON SEPARABILE) non cambia.

Attesa dichiarata al §0.2: **confermata** in tutti i punti (S1-S4, mediana negativa, media positiva, somma ~250x sopra la deriva
contro la «10x» attesa, segno che si ribalta senza le 5 migliori, esito NON SEPARABILE). Non previsti da me (ma gia' in
archivio, vedi §2.2): il pareggio spento e la parziale che scatta a 0,57 R iniziali invece che a 1.
Il criterio (c) del mandato («nelle giornate perse perde di piu'?») e' **degenere, come dichiarato prima**: nelle 116 giornate
senza TP1 la differenza e' -0,022 R su 116 (zero), e nelle giornate P il senza-parziale non ha modo di perdere di meno.

## 3. MISURA 2 — SHORT 770105: il RETEST lascia a secco i crolli?
### 3.1 Giornate e fill (gamba OOS 2025.06.10-2026.06.30)
| misura | valore |
|---|---|
| calendario A (feriali meno le 8 chiusure Xetra del §0.3) | **268** (267 senza il 30/06/2026) |
| calendario B (almeno un deal in uno degli 8 per-trade DAX) | 250; **nessun** deal fuori da A (niente sabati, niente festivi Xetra) |
| date A senza nessun deal in nessun file (18) | 07, 09, 11, 29/07 · 06, 11, 18/08 · 09/09 · 06, 13/11 · 29/12/2025 · 18/02 · 10, 31/03 · 19, 25/05 · 16, 30/06/2026 |
| fill short | **194** (72,4%) · **senza fill 74** (27,6%) |
| incrocio col long vivo 772501 (193 fill) | solo long 56 · solo short 57 · tutti e due 137 · nessuno dei due 18 |

Le 74 giornate senza fill **non si separano** in «range non rotto al ribasso» contro «rotto senza ritorno entro 120 minuti»: nel
per-trade non c'e' ne' l'ora d'ingresso ne' il livello del range, e i log del tester di R270 hanno solo le righe di configurazione
(nessuna riga giornaliera «RETEST armato» / «SELL LIMIT», verificato su `0003_Agent...log`).

### 3.2 La parte che SI' si misura: le rotture CERTE
Stop iniziale del long = `minimo - 5 punti` = grilletto dello short, stessa condizione `bid <=`. Uno stop pieno (>= 1,00 R, un deal
solo, prima delle 17:29) e' quindi una rottura ribassista certa: col lotto arrotondato per difetto e `k` = 1,0000, una perdita di
1,00 R vuol dire uscita **al livello o sotto**.
| fonte long | soglia | rotture certe | short CON fill | short SENZA fill |
|---|---|---|---|---|
| 772501 vivo (R47a) | >= 1,00 R | **15** | **13** | **2** (10/09/2025, 10/10/2025: stop del long alle 09:33 e 09:20) |
| 772501 vivo (R47a) | >= 0,97 R (stima) | 35 | 32 | 3 |
| 786325 TP1 2R (R270, al pin) | >= 1,00 R | 16 | 14 | 2 (le stesse due date) |
| 786325 TP1 2R (R270, al pin) | >= 0,97 R (stima) | 36 | 33 | 3 |

**Contro-esempio della premessa (congelato: scarto <= 1 punto nell'80% dei casi): CADUTO.** Uscita del long contro ingresso dello
short ricostruito meno 7 punti: entro 1 punto in **8 su 13** (62%); scarti -3,0 · -2,5 · -1,5 · -1,5 · -1,0 x4 · -0,5 x4 · -0,2.
Per la regola scritta prima, **il conteggio delle rotture certe esce dal verdetto**. Letto dopo (e quindi NON usato): gli scarti
sono tutti <= 0, cioe' il long e' uscito sempre al livello o sotto, come serve alla premessa; la banda simmetrica era troppo stretta
per uno stop eseguito in un mercato che scende (o per un limit short riempito meglio del prezzo: le due cose qui non si separano).
Il verdetto non cambia in nessuno dei due casi (vedi sotto).

**Lo specchio (descrittivo, fuori verdetto)**: lo stop pieno dello SHORT e' una rottura RIALZISTA certa. Su 786322: **36** rotture
certe, il long ha preso il retest in **33** (91,7%), mancate 3; su 786324: 7 su 7. A 0,97 R: 74 su 79 e 16 su 17. **Il retest
manca circa una rottura su 8-12 in TUTTE E DUE le direzioni**: sul campione misurabile non c'e' niente di specifico ai crolli.

### 3.3 Le giornate CON fill (b) — con le due uscite che esistono (nessuna delle due e' quella del vivo)
| cella | giornate | vinte | PF per giornata | R: 10/25/50/75/90% | somma R | peggiore / migliore | ora di chiusura (server) |
|---|---|---|---|---|---|---|---|
| 786322 TrailStartR 1,5 | 194 | 99 (51,0%) | 1,072 | -1,00 / -0,99 / +0,22 / +0,97 / +1,11 | +7,05 | -1,13 / +2,03 | 8:2 · 9:61 · 10:32 · 11:21 · 12:13 · 13:11 · 14:12 · 15:15 · 16:8 · 17:19 |
| 786324 FIXED 410 | 194 | 161 (83,0%) | 0,734 | -0,06 / +0,01 / +0,05 / +0,09 / +0,17 | -4,94 | -1,02 / +0,67 | 8:46 · 9:83 · 10:21 · 11:14 · 12:13 · 13:6 · 14:5 · 15:1 · 16:4 · 17:1 |
La cella VIVA (TrailStartR 0, mode 1) ha solo l'aggregato R270b: OOS 257 deal, PF 0,957, DD 12,31% (R1 VIOLATO, `LETTURA_R270` §3).

### 3.4 Verdetto (regole del §0.3)
Rotture certe senza la premessa: fuori dal verdetto -> nessuna parte misurabile -> NON MISURABILE. Anche tenendole: 13/15 = 86,7%
< 90% -> NON MISURABILE (e la banda larga, 32/35 = 91,4%, e' una stima, non una certezza: non puo' dare «NON SOSTENUTA»).

> **MISURA 2: «NON MISURABILE dai per-trade».** Parte misurabile: 74 giornate su 268 senza fill; sulle rotture ribassiste certe il
> retest ne manca 2 su 15 (lo specchio rialzista 3 su 36). Il P/L dei crolli mancati **non e' in nessun file**.

Attesa dichiarata al §0.3: fill ~194 su ~258 **confermata** (194 su 268); rotture certe «qualche decina» **confermata** (15-36);
quota senza retest attesa 30-60% **SMENTITA**: e' 8-13%. L'esito atteso (NON MISURABILE) e' uscito, ma per la ragione opposta a
quella che mi aspettavo: il retest lascia a secco **poche** rotture certe, non tante.

## 4. Le misure corte che rispondono (4.1 NON scritto: proposta con attesa, contro-esempio e costo · 4.2 gia' scritto, mai girato)
Tutte sul **PC di backtest** (regola del 21/09: niente tester sul VPS con la challenge viva), a tick reali, stessa finestra di R270
(`@DAQUANDO 2024.09.26 @FINOA 2026.06.30 @FRAZIONEIS 0.40`, deposito 100.000, rischio 1,00 di banco), magic in sweep gemello come
R47a (per avere il per-trade di ogni cella e il controllo d'igiene). Ogni file passa dai due strati del cancello prima di uscire.

**4.1 Short, RETEST contro BREAKOUT** (tre file, una cella ciascuno):
- **S0** = la cella VIVA dello short (R270b riga TrailStartR 0), solo per avere il suo **per-trade**, che oggi manca. G0: deve
  rifare R270b al centesimo (IS 138 · -995,51 · 0,96513 · 7,4732 / OOS 257 · -1.865,37 · 0,95734 · 12,3052).
- **S1** = S0 con `InpEntryMode=0` (BREAKOUT), `InpPendingExpiryMin=120`: il motore com'e'.
- **S2** = S1 con `InpPendingExpiryMin=535`. 🔴 **Serve, ed e' il contro-esempio della prova stessa**: in BREAKOUT il SELL STOP si
  piazza alle 08:35 e scade dopo 120 minuti (10:35), mentre il RETEST sorveglia la rottura fino alle 17:30 (`TryPlaceBreakout` contro
  `MonitorRetest`, letto al pin). Senza S2, «giornate solo del breakout» mescolerebbe i crolli mancati con l'effetto della scadenza.
- **Misura**: giornate in S1/S2 e non in S0 = «prese solo dal breakout»; il loro P/L **in R per giornata**, non in euro (lo stop del
  breakout e' range+10 punti, quello del retest range+3: lotti diversi).
- **Attesa**: giornate solo-breakout 15-40 per gamba OOS; PF in R di quelle giornate **< 1,0** (il breakout e' il motore sostituito
  il 06/08 sul long perche' perdeva fuori campione).
- **Contro-esempio** (la spiegazione alternativa, e il numero che darebbe): se ha ragione la **mean-reversion dei gap-down**, le
  giornate solo-breakout hanno molti stop pieni sul massimo+5 e quota vinte < 40%. La tesi di Gemini e' SOSTENUTA solo se quelle
  giornate fanno PF in R >= 1,2 su n >= 30 **in tutte e due le gambe**; PF alto in una gamba sola = il ribaltamento IS/OOS gia' visto
  in R270b (rumore).
- Regola dei due lati (25/08): se S1/S2 danno segnale, lo stesso trio si rifa' sul long prima di qualunque proposta.
- **Costo**: 3 file x 2 gemelli x 2 gambe = 12 passate; al passo di R270 (28 passate in 5 minuti) sono **circa 2-3 minuti** di tester.

**4.2 Long, separare «niente parziale» da «niente pareggio»: il file ESISTE GIA', non va scritto.**
`backtest_pipeline/prove/R207b_parziale_e_breakeven_DAX_D30EUR.txt` (asse `InpTP1_ClosePct` 0/50 con `InpBEatR=1.0`, stessa finestra
2024.09.26-2026.06.30) e la sua riga `backtest_pipeline/righe/RIGA_R207B_DA_MANDARE.md` (22/09, «si lancia DOPO R207A»): **nessun
risultato in archivio** (cercato `*r207*` fuori da `prove/`: solo le due righe). 🔴 Prima di mandarla va **ri-passata dai due strati
del cancello**: il pin dell'EA e' cambiato dal 22/09. Letto nel sorgente: il bersaglio di `InpBEatR` usa la stessa formula del
bersaglio della parziale (`InitialSL` con `partialDone=false`), quindi `ClosePct 0 + BEatR 1,0` porta lo stop a pari **nello stesso
istante** in cui il vivo chiuderebbe la meta': e' il vivo meno la sola chiusura parziale.
Attesa di questo referto (da confrontare, non sostituisce quella del file): somma D contro il vivo vicina a **+3,80 R** (il valore
senza le due giornate divergenti); le 116 giornate N identiche a R47b. Contro-esempio: se il vantaggio crolla sotto +1 R, il merito
era del pareggio spento, non della parziale tolta. Costo dichiarato nella riga: 4 passate, tetto 17 minuti.

## 5. Cosa NON copre questo referto
- **IS per giornata**: il per-trade copre solo la gamba OOS; il «semestre 2024.09-2025.03» del mandato NON e' misurato per giornata
  (solo l'aggregato IS, che va nella stessa direzione: PF 1,183 contro 1,126).
- **Un solo regime**: un anno OOS, con il DAX a +2,0% dal primo all'ultimo deal. Il «biennio toro» della tesi di Gemini, su questa
  gamba, non c'e': l'IS lo era forse, ma l'IS non ha per-trade (nessun numero di indice inventato qui).
- **Ora d'ingresso, MFE, livelli del range**: non nell'export. L'esposizione PRIMA di TP1 e' uguale per costruzione e non serve;
  quella DOPO e' misurata dalle ore dei due deal.
- **Direzione dei mesi**: proxy grezzo (primo e ultimo deal del mese), non una misura di regime.
- **Short vivo**: nessun per-trade della cella in campo; la distribuzione (b) e' su due uscite diverse.
- **Esecuzione vera**: fill di stop e limit del tester, non della prop; orologio FTMO diverso da quello BCM d'inverno.
- Niente di questo referto e' una taglia, una promozione o una modifica: la sedia `770101` e la sedia `770105` restano come sono.
