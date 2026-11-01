# A5 — Utilizzo, adozione ed economia (R008) — Breaking Band su XAUUSD
Etichette: FATTO_VERIFICATO (letto/calcolato da me), INFORMAZIONE_DEL_COMMITTENTE, INFERENZA, IPOTESI, DA_VERIFICARE.
Nessun backtest delle regole. Dei dati ho usato solo distribuzioni marginali di spread, ATR(14), sigma20 (nessun pattern, nessun PnL).
Script e output: `agents/A5/a5_potenza_montecarlo.py` (+ `potenza_output.md`), `agents/A5/a5_costi_spread_atr.py` (+ `costi_output.md`). Rieseguibili con `python3 -I`.

## 0. Sintesi in 6 righe
1. Il test sui 4 periodi, con le frequenze ipotizzate, NON puo distinguere PF 1,15 da 1,0 (serve ~1.300 trade; ne avremo 30-430 per variante). Puo solo trovare un vantaggio grande (PF >= ~1,5-2) o escluderne uno grande. Un esito "inconcludente" e il piu probabile (IPOTESI).
2. Lo spread dell'oro e piccolo rispetto allo stop 3 ATR su H1 (mediana 0,5-3%) e medio su M15 (1-6,5%, code fino al 12-18% in 2013/2018). Il costo non e il problema: lo e la geometria (distanza della mediana ~1,4-2,0 ATR contro stop 3 ATR => serve win rate 62-70% per pareggiare).
3. In repo NON c'e un "Bulge" per l'oro, ma c'e un EA di laboratorio ABTG_BreakingBand (1.857 righe, 87 input) e ABTG_Bulge/BULGE_MASTER (forex, H1) sul branch `lavoro` — non sul branch corrente. Riutilizzabili come scheletro, non come prova.
4. TROVATO (da segnalare a C0): sul branch `lavoro` esistono `docs/breaking_band/GUIDA_OPERATIVA_11.txt` e `DICHIARAZIONE_TEST.txt`, i due documenti dichiarati MANCANTI nel brief. Non li ho letti (indipendenza); non verificato se sono quelli ufficiali.
5. Per il committente (conti piccoli, prop): stop 3 ATR su H1 = mediana 45 USD/oncia nel 2025-26 (era 12 USD nel 2013): a 0,01 lotto la perdita per stop e comparabile a 0,5-4,5% di un conto 10.000-1.000 USD (DA_VERIFICARE contratto 100 oz). Decide lui, non do taglie.
6. Passo proporzionato in ogni caso: indicatore con allarme + diario, mai EA subito.

---
## (a) Cosa serve per applicare la strategia e quanto e fattibile in MQL5

### a.1 Tre modi di applicarla
| Modo | Cosa serve | Pro | Contro |
|---|---|---|---|
| Discrezionale + checklist (anche con valutazione AI dello screenshot, prompt in materiali/) | schermo con Bollinger 20/2, Standard Deviation + SMA50, ATR; compilare ~35 voci SI/NO + invalidazioni; screenshot standard (MANCANTE) | zero sviluppo; applicabile subito su demo | soggettivo (tocco "visivo", sigma "in dubbio = NO"); tempo per setup (INFERENZA: 10-15 min); non scalabile su M15; non produce statistica |
| Indicatore con allarme (alert/push quando "bulge valido" e poi "test della banda opposta/dell'impulso") | indicatore MQL5 su criteri oggettivi + l'umano chiude le voci qualitative | costo basso; mantiene il giudizio umano; i trigger sono loggabili (misura oggettiva del numero di allarmi, forward) | l'umano reintroduce soggettivita; richiede disciplina nel diario |
| EA | tutti i criteri binari + gestione (stop 3 ATR, TP mediana ricalcolato, chiusura forzata) + guardie prop (perdita giornaliera/massima, news, spread max, magic dedicato) | nessuna soggettivita, test ripetibili | tutte le interpretazioni vanno fissate in numeri (rischio sovrafit: ~87 input nell'EA lab); per FTMO servono guardie proprie |

### a.2 Fattibilita per criterio (MQL5)
Fattibili con funzioni standard (iBands, iStdDev, iMA su handle di iStdDev per la SMA50, iATR, CopyRates). Livello: F = facile/oggettivo; M = fattibile ma serve una soglia scelta (interpretazione dichiarata); D = difficile/soggettivo.
| Criterio della Checklist | Livello | Nota |
|---|---|---|
| Bande, mediana, ampiezza (calo 15-30%) | F | iBands(20,2); periodo/deviazione non scritti nei materiali (DA_VERIFICARE: la checklist non li indica; l'EA lab usa 20/2 citando la guida) |
| Sigma sotto/sopra SMA50; sigma in calo >=2 candele, >=10-15 candele | F | binari nel prompt ("2 candele consecutive di discesa o sotto SMA50") |
| Candela > 1,0 / 1,5 x ATR; impulso 1,5-3 x ATR; impulso <= 20 candele | F | ATR periodo 14 nel PDF (indicatore "ATR (14)" visibile negli esempi) |
| Tocco banda (corpo o spike interseca) | F | high >= banda / low <= banda; il "visivamente" del prompt diventa numerico |
| Nessun tocco della banda opposta (inversione) | F | |
| Bulge: bande molto aperte, mediana molto distante, movimento netto unidirezionale | M | tre soglie "molto" da dichiarare (ampiezza in ATR, distanza in ATR, efficienza direzionale) |
| Inizio/fine della fase bulge | M | segmentazione non definita dalla checklist; altera tutto il resto |
| CS (4/5): compressione, range omogeneo, laterale, nessun micro-impulso | M | "omogeneo/laterale/micro" = soglie |
| Range ridotto 30-50% vs bulge; ombre <= 1,5 x corpo | M | oggettivi una volta fissata la finestra |
| Banda piatta/inclinata a favore; SMA50 inclinata | M | soglia di pendenza |
| CDA: movimento ordinato in canale/flag; ritracciamento "ordinato"; zig-zag | D | richiede fit di canale o proxy; la nota "assenza di violenza" non e una soglia |
| Spike profondi, engulfing impulsivi | M/D | definibili, ma ogni definizione e una scelta |
| Assenza news ad alto impatto imminenti | M | serve calendario (l'EA lab legge un file news "abtg_news.csv"); DA_VERIFICARE se aggiornato |
| Bonus (pin bar/doji, rigetto evidente, reazione immediata, ritmo costante) | D | non pesati: escluderli dal test, come fa la checklist |
| Pesi % (25/25/20/15/10/5) e soglie "solidita" | M | i pesi sono per categoria, non per voce: ripartizione interna da dichiarare (compito A2) |
Conta indicativa (INFERENZA da mia lettura della checklist, non da A2): circa meta delle voci F/M obbligatorie, quasi tutti i bonus e la struttura "ordinata" D. => un EA fedele alla checklist e sempre una "interpretazione di chi scrive", non la strategia.

### a.3 Cosa esiste gia (solo letture)
- Branch corrente (`claude/creating-agents-SgGpD`, /home/user/GITHUB/mql5): NESSUN indicatore/EA Bulge o Breaking Band. Unico scheletro con iBands + iATR + CTrade + rischio % + spread max: `mql5/Experts/IchiTrend_Gold_Base.mq5` (Ichimoku+Bollinger su XAUUSD M5; non e Breaking Band).
- Branch `lavoro` (FATTO_VERIFICATO con git ls-tree/show, sola lettura): `mql5/Experts/ABTG_BreakingBand.mq5` (1.857 righe, 87 input; v1.00 12/08/2026 ... v1.05 29/08/2026; dichiara di implementare la guida: bulge detector, CONT/INV, invalidazioni, SL 3 ATR, TP mediana mobile, solidita pesata), `ABTG_Bulge.mq5` (2.234 righe, motore di Claudio migrato; segnali ARANCIO/BLU/VIOLA; forex basket H1; SL 3 ATR, TP mediana) e `BULGE_MASTER.mq5` (originale).
- Cautele: (i) quell'EA dichiara taratura su dati (v1.02 "CAL1": larghezza 1,35, netto 1,0 ATR da un altopiano di frequenza su EURUSD) => parametri NON a priori, non riusabili come interpretazione "pulita" per il nostro test; (ii) mai compilato/validato da me; (iii) EURUSD/forex, non oro.
- Confronto Bulge vs Breaking Band (da header e messaggi di commit, non ho riletto i risultati): stessa geometria di uscita (SL 3 ATR, TP mediana). Il Bulge ha entrata semplice (pochi test sulle bande), la Breaking Band ha ~35 voci a SI/NO: attesa molto piu selettiva e molto piu interpretabile. Backtest di riferimento del Bulge (INFORMAZIONE_DEL_COMMITTENTE dall'header, "non e nostro e non e una promessa"): 268 trade, win rate 80,2%, media vincita 131,6 / media perdita 325,4 (payoff 0,40 => pareggio a 71% di win rate), PF 1,599, 6 simboli H1, 2022-01..2026-03, qualita dati 40%, nessun IS/OOS. Un commit successivo (a796e0e6) riporta: "niente regola ne simbolo distinguibile dal caso su 19-221 posizioni" => stesso problema di potenza descritto sotto, gia incontrato in casa.
- Mai testato sull'oro: nessun EA di quelli sopra ha un risultato su XAUUSD (non verificato fino in fondo: ho letto solo header e log; DA_VERIFICARE).
- Guardie prop: i commit citano un "Guardian" lato EA (flags perdita consecutive ecc.) — non ho verificato il contenuto; per FTMO servono comunque limiti di perdita giornaliera/massima nell'EA o nel gestore (DA_VERIFICARE se gia coperti).

---
## (b) Frequenza attesa e potenza statistica

### b.1 Ipotesi di frequenza (IPOTESI DICHIARATA, nessuna misura)
Ancora: il Bulge di Claudio (regole piu semplici) fa ~0,9 trade/mese/simbolo su H1 (268 trade / 6 simboli / 51 mesi, dato del committente, non verificato). La Breaking Band e piu restrittiva (tutti SI sul bulge, 4/5 su CS o tutti su CDA, >=80% ritracciamento, nessuna invalidazione) => assumo meno o simile. Mesi nei dati: 12 + 12 + 12 + 21 = 57.
| Variante (per mese, oro) | basso | centrale | alto | N trade su 57 mesi (basso / centrale / alto) |
|---|---|---|---|---|
| H1 CONT | 0,3 | 1 | 3 | 17 / 57 / 171 |
| H1 INV | 0,1 | 0,5 | 1,5 | 6 / 29 / 86 |
| M15 CONT | 0,75 | 2,5 | 7,5 | 43 / 143 / 428 |
| M15 INV | 0,25 | 1,25 | 3,75 | 14 / 71 / 214 |
(M15 = 2,5 x H1: scelta mia, la struttura scala male con il timeframe.) Per periodo (centrale H1 CONT): ~12 / 12 / 12 / 21 trade. Il setup non e indipendente: si concentra in regimi di volatilita (INFERENZA), quindi gli N efficaci sono piu bassi dei nominali.

### b.2 Potenza: quante operazioni per distinguere PF 1,0 da 1,15 (win rate 60%)
Modello: perdita = -1R (stop 3 ATR); vincita w tale che PF = 0,6 w / 0,4. PF 1,0 => w = 0,667R; PF 1,15 => w = 0,767R; aspettativa per trade 0,060R, dev. std. 0,865R. Test: PF osservato contro soglia al 95o percentile sotto PF=1 (1 coda 5%). 20.000 simulazioni, seed 12345.
- Formula chiusa (normale, 80% potenza): N = ((1,645+0,842) x 0,865 / 0,060)^2 = **~1.290 trade** (MC: potenza 81% a N=1.300, 93% a N=2.000; con payoff rumoroso 78% a 1.300).
| N trade | potenza vs PF 1,15 | vs PF 1,30 | vs PF 1,50 |
|---|---|---|---|
| 30 | 9% | 18% | 29% |
| 120 | 15% | 39% | 68% |
| 200 | 26% | 59% | 89% |
| 400 | 40% | 81% | 99% |
| 800 | 60% | 98% | 100% |
| 1.300 | 81% | 100% | 100% |
(Con N piccolo il PF e discreto: soglie/potenze non monotone, vedere `potenza_output.md`. Modello rumoroso: stessi numeri entro 2-3 punti.)
- Effetto minimo rilevabile (potenza 80%, alpha 5%, binario): N=17 -> PF ~3,0; 29 -> ~2,95; 57 -> 2,0; 86 -> 1,75; 143 -> 1,60; 214 -> 1,45; 428 -> 1,30; 1.300 -> 1,20.
- Intervallo 90% del PF osservato se il PF vero e 1,15: N=57: 0,74-1,80; N=114: 0,85-1,60; N=340: 0,96-1,39.
- "PF>1 in tutti e 4 i periodi": con PF vero 1,0 ha probabilita ~5-9% (trade per periodo 14-85); con PF vero 1,15 solo ~21-26%; con 1,30 e ~49-62% se 57-85 trade/periodo. Dunque non e una prova di edge e la sua assenza non e una prova di assenza.
- Confronti multipli: 4 varianti x 4 periodi = 16 celle; alpha effettivo piu severo, potenza piu bassa di quanto sopra.

### b.3 Cosa significa per il test
Con le frequenze centrali (57 / 29 / 143 / 71 trade) il test e un SETACCIO: trova un vantaggio forte (PF >= ~1,6-2,0 per 143 / 57 trade) o un difetto grave (PF netto < 1 con N >= 100-150), non conferma un PF 1,15. Un risultato "PF 1,15 con 60 trade" e indistinguibile dalla fortuna (P(PF osservato >= 1,30 | PF vero 1,0, N=60) = 18%). Nessuna regola va ritoccata sui dati per "salvare" il risultato (vincolo del brief).
Utilita economica anche se vero: PF 1,15 = 0,06R/trade; a 24 trade/anno (H1 CONT centrale) = 1,4R/anno contro una deviazione std annua di ~4,2R: edge reale ma invisibile e irrilevante per un conto prop. Servirebbe frequenza alta (M15, piu simboli) per contare. 3 perdite di fila in un anno da 24 trade: 64% di probabilita (WR 60%); 4 di fila: 30%.

---
## (c) Costi: spread dell'oro contro stop 3 ATR(14)
Metodo: da M1 (4 CSV), barre H1/M15 per bucket di tempo server, ATR Wilder(14), spread = ultimo M1 della barra precedente (proxy dell'ingresso alla barra dopo), 1 punto = 0,01 USD. Solo distribuzioni marginali su tutte le barre. Dettaglio: `costi_output.md`.
| Periodo | Spread M1 mediana / P90 / P99 (USD) | ATR14 H1 mediana (USD) | Stop 3 ATR H1 (USD) | Spread/stop H1 mediana / P90 | Spread/stop M15 mediana / P90 | M15: barre con spread > 10% dello stop |
|---|---|---|---|---|---|---|
| 2013 | 0,36 / 0,52 / 0,84 | 4,16 | 12,5 | 2,8% / 5,1% | 6,1% / 11,9% | 17,5% |
| 2018 | 0,21 / 0,27 / 0,40 | 2,24 | 6,7 | 3,1% / 4,7% | 6,5% / 10,9% | 15,4% |
| 2020 | 0,17 / 0,41 / 1,60 | 5,37 | 16,1 | 1,0% / 2,8% | 2,1% / 6,2% | 3,2% |
| 2025-26 | 0,21 / 0,30 / 0,45 | 15,02 | 45,1 | 0,5% / 1,3% | 1,0% / 2,6% | 0,1% |
(Stop M15 mediano 2025-26: 20,8 USD; H1: ATR P10-P90 6,9-26,0 => stop 21-78 USD.) La caduta dell'incidenza e dovuta al prezzo/volatilita dell'oro, non a spread migliori. Spread storici: DA_VERIFICARE se reali del broker o modellati; prop/FTMO live puo avere spread, commissioni, slippage diversi.

Geometria (indicativa, NON condizionata al pattern; il calcolo condizionato e di A3/R002): distanza ingresso(banda)->mediana ~ 2 sigma20; in unita ATR(14), mediana su tutte le barre: H1 1,77-2,00; con sigma < SMA50 (stato del test "ideale"): 1,42-1,61; con sigma > SMA50: 2,63-2,90. M15 simile (1,73-1,92; 1,43-1,56; 2,39-2,67).
Effetto sul target a distanza mediana (perdita = 3 ATR + s, guadagno = d - s, win rate 60%):
| Caso | d (ATR) | PF lordo | PF netto di spread (H1, 2025-26 / 2018) | Win rate di pareggio netto (H1 2025-26 / 2018; M15 2018) |
|---|---|---|---|---|
| tutte le barre | 2,0 / 1,94 | 1,00 / 0,97 | 0,99 / 0,90 | 60,3% / 62,6%; M15 65,3% |
| sigma < SMA50 | 1,61 / 1,56 | 0,80 / 0,78 | 0,79 / 0,71 | 65,4% / 67,8%; M15 70,8% |
| sigma > SMA50 | 2,85 / 2,63 | 1,43 / 1,31 | 1,41 / 1,23 | 51,5% / 55,0%; M15 57,6% |
Lettura: (1) lo spread toglie 1-6% dal guadagno su H1 (13% al peggio su M15 2013) — secondario; sul M15 2013/2018 (spread/stop mediano 6%) conta, e raddoppiando lo spread live l'effetto raddoppia. (2) Il fattore dominante e d/3: con stop 3 ATR e target breve, a win rate 60% si e in pareggio o sotto se il test avviene a volatilita gia scesa. (3) La tabella "probabilita" della checklist (Ottimo 65-75%, Buono 55-65%, Medio 45-55%) implica, se vera (non verificata), che solo setup Ottimo/Buono alto sono sopra il pareggio (52-70% a seconda di d). Un filtro di solidita minima e quindi una componente economica del test, non un dettaglio.

---
## (d) Cosa cambierebbe la decisione del committente e prossimi passi
Soglie PROPOSTE da A5 (non congelate: il congelamento e di C0/A1, R005). Da applicare al PF NETTO di spread, per variante, dichiarando N:
| Esito | Condizione (tutte) | Che cosa significa | Passo proporzionato |
|---|---|---|---|
| Positivo | N >= 100 (o variante pooled); PF netto >= 1,30; PF>1 in >=3 periodi su 4; PF resta > 1,10 con spread x1,5; nessun singolo periodo >50% del profitto | edge grande e non fragile, ma con N~100 l'intervallo 90% va ancora sotto 1 (a PF vero 1,15 si osserva >=1,30 col 31-43% di probabilita: falso positivo non trascurabile) | 1) validazione fuori campione su dati nuovi (anni oro mancanti 2021-2024 / 2019; script ABTG_HistoryDownloader.mq5 esiste), variante congelata prima; 2) indicatore + allarme su demo con diario, 3 mesi; 3) solo dopo, EA lab su demo con magic dedicato, in parallelo e mai in sostituzione di Gold Reaper/Goldbot/Gold Phantom; 4) FTMO/reale solo dopo forward demo con N dichiarato |
| Negativo | N >= 150 e PF netto <= 1,0 (o <=1,0 in >=3 periodi) | esclude un edge grande (PF vero 1,30 darebbe PF<=1,0 col 5% a N=150); NON esclude un PF 1,05-1,15 | Si ferma: niente EA. Eventuale uso solo come checklist di disciplina nel diario, dichiarando che non ha edge dimostrato |
| Inconcludente | N < 100, o PF netto 1,0-1,3, o instabile tra periodi, o dipende da un'interpretazione | e l'esito piu probabile (IPOTESI) | Non costruire l'EA. Opzioni a basso costo: (i) leggere Guida Operativa 11 se risulta quella ufficiale e rifare la specifica con meno ambiguita (rischio: nuova serie di ipotesi = nuovo test, criteri congelati prima); (ii) indicatore-allarme su oro per accumulare trade forward senza capitale; (iii) accorpare piu simboli solo se il committente allarga il perimetro (oggi fuori perimetro) |
Altre soglie che cambiano la decisione, indipendenti dal PF:
- Frequenza: se la variante migliore da meno di ~2 trade/mese su oro, non e un EA primario ma al piu un filtro; 1,4R/anno (sopra) non giustifica sviluppo.
- Compatibilita prop: stop 3 ATR H1 mediano 2025-26 = 45 USD/oncia (21-78 USD tra P10 e P90; nel 2013 era 12 USD). A 0,01 lotto (1 oz se contratto 100 oz, DA_VERIFICARE su BCM/FTMO) un stop = 45 USD, cioe 4,5% di 1.000 USD, 0,9% di 5.000, 0,45% di 10.000: su conto piccolo un solo stop puo consumare gran parte del limite giornaliero (limiti prop tipici 5% giornaliero / 10% massimo: DA_VERIFICARE sul regolamento corrente). Due stop ravvicinati sono comuni (una serie di 2 perdite consecutive compare quasi sempre in 24 trade, 96%; "stesso giorno" non misurato). Lotti e rischio decide Claudio; segnalo solo che la distanza dello stop in USD varia di 3-4x tra regimi (2013 vs 2025-26), quindi il rischio per lotto fisso non e stabile.
- Correlazione con gli EA gia attivi sull'oro: un setup Breaking Band in contemporanea a posizioni di Reaper/Goldbot/Phantom somma il rischio verso lo stesso limite giornaliero (non verificato come si sovrappongono: nessun dato letto).
- Costo/tempo: modo discrezionale costa tempo del committente; EA costa sviluppo + validazione + manutenzione delle guardie prop.

---
## (e) Rischi di adozione
1. Sovrafit su regole soggettive: ~35 voci con soglie "molto", "ordinato", "evidente" => ogni soglia e un grado di liberta; con N 30-400 trade se ne possono "trovare" a decine che sembrano funzionare (l'EA lab ha gia 87 input e una taratura CAL1 su dati). Mitigazione: interpretazioni dichiarate e congelate prima, tutte le varianti riportate, OOS vero.
2. Confusione fra valutazione AI dello screenshot e test numerico: l'AI che compila la checklist (prompt) legge pixel, e istruita a rispondere NO nel dubbio, assegna "probabilita 65-75%" prese dalla tabella (non misurate) e non e riproducibile. Non e un test: va trattata come un'opinione, non come evidenza; il suo output non puo alimentare ne sostituire il PF misurato.
3. Cambio di definizione fra test e uso: l'EA/indicatore realmente usato deve calcolare esattamente quello che e stato testato (stesso ATR 14, stesse bande 20/2, stessa fine-bulge); in caso contrario il verdetto non si trasferisce.
4. Fonte normativa primaria assente (Guida Operativa 11, Dichiarazione di Test, screenshot): ogni numero e interpretazione mia/del consiglio, non della scuola. I documenti sembrano esistere sul branch `lavoro` (docs/breaking_band/), non letti da me.
5. Dati/costi: spread storico forse non rappresentativo di FTMO live; test su barre M1 dei 4 anni, non sui tick; 2013 con spread alti e sistema di prezzi diverso; le 4 finestre non coprono i regimi 2021-2024 (tassi) ne i livelli attuali 4.000+ USD in modo continuo.
6. Pressione del risultato positivo precoce: con N<100 un PF alto e spesso fortuna (vedi tabella falsi positivi); rischio di passare a demo/reale con aspettative non giustificate. Rischio inverso: un PF<1 con N<60 non prova l'assenza di edge.
7. Rischio operativo prop: perdita giornaliera/massima, news, weekend/spread alti, hedging: servono guardie esplicite prima di qualsiasi EA su FTMO; nessun test qui tocca conti reali/demo.
8. Dipendenza dagli altri EA sull'oro (correlazione) e dalla capacita di seguire manualmente setup su H1/M15 durante la giornata (modo discrezionale).

## Limiti e controlli non eseguiti
- Frequenze, ripartizione CONT/INV e M15=2,5xH1 sono IPOTESI; il vero numero sara noto solo dal motore di A4.
- Potenza calcolata con WR 60% fisso e payoff semplificato; non include autocorrelazione/regime, quindi e ottimistica.
- Geometria d = 2 sigma20/ATR e un proxy marginale, non misura le distanze reali dei setup (A3).
- Non ho compilato ne eseguito alcun EA, non ho letto i risultati dei test passati del Bulge/BreakingBand oltre ai messaggi di commit, non ho letto GUIDA_OPERATIVA_11/DICHIARAZIONE_TEST (esistenza verificata solo da `git ls-tree lavoro`).
- Contratto oro, lotto minimo, regole e limiti FTMO/BCM, commissioni: non verificati.
