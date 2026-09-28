# MISURE A COSTO ZERO sul DAX Apertura (770101 LONG, 770105 SHORT), notte 28/29-09-2026

Mandato: Claudio, notte 28/29-09 («fate tutto in background, l'obiettivo e' avere piu' sedie per le prop»). Domande nate da
`docs/RISPOSTA_A_GEMINI_R270_2026-09-28.md` (righe 1 e 4) e da `report/LETTURA_R270_2026-09-28.md` (PASS f01d18d2).
**Niente MT5, niente macchina: solo Python sui per-trade gia' in archivio.** Nessuna taglia, nessuna sedia toccata, nessuna
promozione. E' materiale per la firma pendente di Claudio su `InpTP1_ClosePct=0` e per il prossimo round short.

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
_Sezioni 1-4 (numeri, contro-esempi eseguiti, verdetti, proposta): scritte DOPO, nel commit successivo._
