# Disegno del test v1 — Breaking Band su XAUUSD (A1, R005 preparazione, R006 disegno)
Stato: proposta congelabile insieme a specifica_v1.md. Nessun backtest eseguito. Ordine cronologico dichiarato: fonti -> geometria A3/A5 (descrittiva, nessun P&L) -> specifica -> disegno -> criteri/previsioni -> HASH -> codice dei segnali -> test di correttezza (A7) -> UNICO run sui dati reali.

## 1. Ipotesi primaria UNICA
**H-P**: "Su XAUUSD, barre H1, la strategia Breaking Band cosi come specificata in specifica_v1.md (CONTINUAZIONE e INVERSIONE, insieme, 4 periodi 2013/2018/2020/2025-26) produce un risultato medio per trade, NETTO di spread, maggiore di quello di ingressi casuali con geometria identica, e positivo."
- Unita: i trade eseguiti delle due varianti H1 uniti (CONT U INV). Statistica decisionale: media di R netto per trade `m` (R = P&L / (3 ATR)); PF netto e win rate sono riportati ma non sono la statistica di decisione (PF su pochi trade e dominato da 1-2 operazioni: A5, A6 T12).
- Perche H1: e il TF di tutti gli esempi, e ammesso dalla Guida, ha lo spread/stop piu basso (A5: 0,5-3% mediana) e il campione piu numeroso fra i TF ammessi che hanno senso (H4/D1: ~1/4 e ~1/24 delle barre).
- Perche pooled: la domanda del brief e "ha la strategia un vantaggio?", non "quale dei due pattern"; unire raddoppia circa N (A5: N e il vincolo vincolante). I due pattern sono comunque analizzati separatamente e riportati (descrittivi, non decisionali).
- Tutto il resto e ESPLORATIVO: M30 (CONT, INV, pooled), CONT e INV separati, strati (n_prev, solidita, congestione, lato, periodo), sensibilita. Nessuno di questi puo cambiare il verdetto; al piu motiva una validazione pre-registrata (sez. 9).
- Numero totale di configurazioni dichiarate (molteplicita): 1 primaria + M30 (3 sotto-viste) + 7 sensibilita H1 (Sa, Sb, Sc, Sd, Se20, Se50, Sf) = 8 simulazioni complete oltre la primaria piu i sotto-gruppi. Il numero e scritto nella relazione.

## 2. Varianti, periodi, celle (R006 aggiornato)
- Varianti: {CONT, INV} x {H1, M30}. M15 sostituito da M30 perche la Guida ammette D1/H4/H1/M30 e NON M15 (decisione D2). Celle: 2 x 2 x 4 periodi = 16, piu i totali per variante e i pooled H1/M30. Tutte riportate anche con n=0 o PF non definito.
- Periodi: 4 file (2013, 2018, 2020, gen 2025 - set 2026), serie SEPARATE (nessuna concatenazione, nessun warm-up condiviso). Sono 4 regimi, non 4 campioni dello stesso processo (A6 R-B3): i risultati per periodo sono descrittivi. Totale barre H1 ~27.900 (A3), ~57 mesi.
- Dati: sha256 dei 4 CSV registrato prima del run; righe uguali all'audit A3 (348.647 / 349.730 / 351.258 / 611.062).
- Nessuna ottimizzazione: tutti i parametri sono nella tabella flat di specifica_v1.md sez. 9.

## 3. Trattamento delle righe con spread = 0 (A3: 439 / 94 / 144 / 0)
- Sostituzione PRIMA di costruire le M1 per il motore: spread 0 -> mediana degli spread non nulli dello stesso periodo e della stessa ora server (tabella A3). I segnali non dipendono dallo spread, quindi la sostituzione tocca solo i costi.
- Riportare: numero di trade con spread 0 alla M1 di ingresso o di uscita (previsto 0-1) e il risultato primario escludendoli (controllo, non alternativa).
- Il costo medio pagato (R) per periodo e per lato e riportato; se i periodi 2013-07 e 2020-04/05 hanno trade, sono marcati.

## 4. Linea di base con ingressi casuali (distingue pattern da geometria e deriva)
Scopo: con stop 3 ATR e target SMA20 la geometria sola produce un win rate di pareggio ~60-68% (A3) e una deriva (oro in forte rialzo nel 2025-26) favorisce i long; un PF > 1 non e un vantaggio del pattern. Si stima la distribuzione del risultato di ingressi casuali che subiscono la STESSA geometria.
- Motore e convenzioni IDENTICHI: stesso stop 3 ATR_tau, target SMA20, ricalcolo 3 ore, stesse barre H1, spread executable, fill, max gap ingresso, nessun limite a tempo.
- **B1 (linea di base primaria, ipotesi nulla di H-P)**: per ogni trade del pattern `i` (periodo `P_i`, lato `side_i`, distanza `D_i` in ATR fra fill e target0) si estrae una barra `j` casuale dello STESSO periodo e dello STESSO TF con: (a) ingresso del lato `side_i` possibile (target0 dalla parte giusta del prezzo); (b) `D_j in [0,85 D_i ; 1,15 D_i]`; (c) stato di volatilita come il pattern: `sd_j < S50_j` e `sd_j <= sd_(j-3)`; (d) `j` non e una barra di segnale del pattern; (e) barre dopo il warm-up. Cosi lato, periodo (quindi deriva), geometria e stato di volatilita sono abbinati; resta libera solo la struttura bulge/retest.
- **B0 (riferimento, non decisionale)**: come B1 senza il vincolo (c): "mean reversion verso la SMA20 a quella distanza, in generale".
- **B2 (esplorativa, bulge-context)**: barre casuali nelle finestre `[p+3, p+30]` degli episodi ARMATI (stesso lato del pattern, `D` abbinato, periodo uguale) che NON soddisfano le condizioni del pattern: isola l'effetto del test specifico (tocco/retest + sequenza + sd) dal semplice trovarsi dopo una bulge.
- Procedura: si SIMULA UNA VOLTA ogni barra idonea (lato per lato) con `simula_trade`, conservando `R`, `D`, periodo, lato; poi si fanno 2000 estrazioni di `N` trade abbinati (un'estrazione per trade del pattern, con reinserimento fra estrazioni, seed fisso 20261101). Statistica: media di R netto e PF netto per estrazione. Le estrazioni NON applicano il filtro "una posizione alla volta" (si confrontano medie per trade).
- Output: distribuzione nulla (media, p5, p50, p95), percentile del pattern, `p_B1 = (1 + #{media_nulla >= m_oss}) / 2001`, per pooled, per variante, per periodo, per lato.
- Complemento analitico: win rate atteso in assenza di vantaggio `WR0 = media_i[ 3 / (3 + D_i) ]` (martingala, senza costi) e con costo `media_i[(3 + c_i)/(3 + D_i)]`; eccesso `WR_oss - WR0` con errore standard binomiale. (A3 3.5: confrontare con il pareggio DELLE barre dove scatta il segnale, non con quello medio).
- Deriva: rendimento buy&hold per periodo in ATR e risultati separati long/short (CK-36).

## 5. Test placebo su passeggiata casuale (proporzionato: correttezza, non statistica sull'oro)
- Serie sintetica M1 -> H1 con rendimenti a media zero e volatilita raggruppata (GARCH(1,1) semplice, parametri fissati nel codice), spread realistico costante, prezzo inizialmente ~2000, lunghezza tale da produrre almeno ~1500 segnali (decine di anni sintetici), una serie per variante.
- Atteso: per una martingala ogni regola di ingresso/uscita causale ha P&L LORDO medio per trade = 0 (fino ai bordi dei dati) e netto = -costo medio di spread. Criterio: `|z| <= 3` sul lordo medio in R (CK-13 [B]); un lordo positivo e il segnale piu forte di look-ahead. Eseguito per ogni variante e TF con TUTTI i parametri reali.
- Un secondo placebo (opzionale, esplorativo): rendimenti H1 reali rimescolati a blocchi (blocchi di 24 barre, 200 rimescolamenti): conserva distribuzione e raggruppamento di volatilita, distrugge la struttura locale; il risultato deve coincidere con B1 entro il rumore.
- Il placebo NON entra nella decisione statistica; entra nei controlli di correttezza (checklist di accettazione A7).

## 6. Campione minimo e regime di verdetto (A5 + A3)
Soglie scelte da A5: a N=30 il PF osservato supera 1,83-2,00 solo nel 5% dei casi a PF vero 1,0; a N=100 la soglia scende a 1,38-1,47; effetti minimi rilevabili (potenza 80%, alpha 5%, WR 60%): N=57 -> PF 2,0; N=86 -> 1,75; N=143 -> 1,60; N=1300 per PF 1,15. Quindi con N realistici il test e un SETACCIO per effetti grandi.
- N = trade ESEGUITI della primaria (H1 pooled), dopo gli scarti.
- N < 30: **INCONCLUSIVO** (frequenza insufficiente per qualsiasi enunciato). Non si allentano soglie. Si riportano imbuto, N per variante, e quanti anni di dati servirebbero (N/anni).
- 30 <= N < 100: verdetto PRELIMINARE (potenza bassa: solo effetti molto grandi sono visibili; la relazione lo scrive).
- N >= 100: verdetto PIENO.
- Per i sotto-gruppi (CONT, INV, M30, strati) N < 30 -> si riportano solo i conteggi; sotto N=10 nemmeno medie per fascia.
- Il campione atteso e basso (previsioni Q2): l'INCONCLUSIVO e un esito previsto e legittimo, non un fallimento da "sistemare".

## 7. Stratificazione (descrittori, MAI filtri; stessi trade, nessuna nuova simulazione)
n_prev {0, 1, >=2}; fascia di solidita {Ottimo, Buono, Medio, Debole} e coppie raggruppate se N basso (>=70 / <70); congestione valida {si, no}; flag "Checklist-stretta" (congestione valida + rientro >= 80% + nessuna invalidazione A2); lato {long, short}; periodo; ora server (fasce 0-7, 8-15, 16-23). Confronto fascia per fascia con la "probabilita associata" della Checklist (Ottimo 65-75%, Buono 55-65%, Medio 45-55%, Debole < 45%) con intervallo di Wilson 90%. Le probabilita della Checklist non dicono rispetto a quale target/stop: si confronta anche con `WR0` della fascia.

## 8. Tabelle da produrre (tutte; nessuna omessa, A7 V16)
- **T1 Imbuto, per variante x TF x periodo**, a due livelli (A6 CK-37; Riassunto, trappola 3: "dove muore ogni setup"):
  - Stadi cumulativi per EPISODIO (un episodio supera lo stadio k se esiste una barra di tocco che soddisfa le condizioni 1..k nell'ordine): F0 barre valide; F1a-F1f criteri B1..B6 (marginali e cumulativi); F2 episodi ARMATI; F3 raggiunto `p` + `MIN_RETR`; poi CONT: C0 tocco banda opposta entro T_MAX -> **C3 SEQUENZA (contata a parte: quanti muoiono per mediana->banda impulso)** -> C1 nessuna candela > 1,5 ATR (separando "nel ritracciamento" e "sulla candela del test") -> sd<S50 -> sd<=sd(-3) -> SEGNALE; INV: I0 mediana toccata -> I1 banda opposta mai toccata -> retest banda impulso -> I2 candela -> I3 banda piatta -> sd<S50 -> sd<=sd(-3) -> SEGNALE.
  - Poi: segnali -> scartati per posizione aperta / gap ingresso / target oltre ingresso / indicatori non pronti / no barra dopo -> trade eseguiti. Segnali = trade + scartati (riconciliato, A7 V10).
  - Per ogni stadio: conteggio, percentuale condizionata allo stadio precedente, causa principale di morte. Contatore informativo: "ritorno alla banda dell'impulso senza tocco di mediana" (regola larga del Riassunto) e "episodi che cadrebbero con IMPULSIVA 1,0".
  - Diagnostica: se un singolo stadio elimina > 90% degli episodi che lo raggiungono, si segnala "filtro quasi auto-colpente" ma NON si modifica nulla (solo documentazione).
- **T2 Risultati per variante x TF x periodo (16 celle + totali + pooled)**: N, win%, PF lordo, PF netto, media R netta, mediana R, somma R, drawdown massimo in R, costo spread medio in R, uscite per motivo (TP/SL/FINE_DATI/uscite a mercato per target superato), eventi stop+target nella stessa M1, `D` medio, pareggio atteso medio, WR0, durata (mediana, max), quota long/short, trade con spread 0 sostituito.
- **T3 Fasce**: per fascia di solidita, per `n_prev`, per congestione, per flag Checklist-stretta (N, WR, IC Wilson, media R, WR0).
- **T4 Linea di base**: B1, B0, B2: media nulla, p5/p50/p95, percentile e `p_B1` del pattern, per pooled/variante/periodo/lato.
- **T5 Robustezza della primaria**: bootstrap della media R con blocchi per settimana di ingresso (10.000 replicati, seed 20261101), IC 90%; PF con e senza i 3 migliori trade; PF e media escludendo ciascun periodo (leave-one-period-out); quota del profitto per periodo; spread x1,5.
- **T6 Sensibilita Sa, Sb, Sc, Sd, Se (20 e 50), Sf**: stessi campi di T2 pooled H1; "riportate per intero, non selezionabili".
- **T7 Placebo**: lordo medio, z, netto, per variante e TF.
- **T8 Deriva**: buy&hold per periodo in ATR, lato long/short.
- **T9 Dati/esecuzione**: sha256 CSV e codice, spread=0, gap ingresso, trade chiusi a FINE_DATI, ricalcoli del target, target-oltre-ingresso, tocchi con penetrazione < 1 spread.
- Ogni numero del rapporto finale deve essere riconducibile a una cella delle tabelle (A7 V16).

## 9. Estensione dei dati pre-registrata (rimedio al campione, NON all'allentamento delle soglie)
Se N < 100 (e in particolare se N < 30), l'unico rimedio autorizzato e AGGIUNGERE dati non ancora visti (anni mancanti: 2014-2017, 2019, 2021-2024; A5 cita lo script ABTG_HistoryDownloader.mq5 per scaricare lo storico M1 sul PC di backtest) con regole e parametri IDENTICI (hash invariato). Regole: (i) al massimo UNA estensione; (ii) il primo run resta riportato per intero e non viene rieseguito; (iii) l'estensione ha un nuovo file di criteri che replica questo, con le stesse soglie; (iv) il verdetto sull'insieme (vecchi + nuovi) si calcola una sola volta, senza fermarsi in base a risultati intermedi. Se N resta < 30 il verdetto e INCONCLUSIVO per frequenza: la strategia, cosi tradotta, e troppo rara sull'oro per essere misurata.

## 10. Controlli di correttezza che condizionano l'accettazione (da A6 [B] e A7)
Eseguire PRIMA del run reale, su dati sintetici e piantati, e riportare: troncamento (V01/CK-01), perturbazione del futuro (V02/CK-03), ispezione anti look-ahead (V03; in particolare `p` solo running extreme, nessun `center=True`, nessuna statistica globale), simmetria rialzo/ribasso del segnale e del motore (V04/V05), contabilita dello spread (V06), stop prima del target (V07), ingresso alla barra dopo (V08), nessuna sovrapposizione (V09), imbuto riconciliato (V10), riproducibilita (V11), 20 trade ricalcolati a mano (V12), statistiche finali ricalcolate (V13), hash congelato (V14), 16 celle (V16), **pattern piantati con gemello negativo per OGNI criterio B1..B6, C0-C3, I0-I4** incluso lo scenario "mediana -> banda dell'impulso -> banda opposta" che DEVE essere scartato in CONT (CK-14), placebo (CK-13), reimplementazione indipendente del nucleo di rilevazione su un mese reale (CK-16). Un controllo non eseguito = non superato.

## 11. Registro e congelamento
- File congelati con sha256 (C0, prima del run): specifica_v1.md, disegno_test_v1.md, il file criteri/previsioni definitivo (da proposta_criteri_previsioni.md), il codice dei segnali, il codice del motore, gli sha256 dei 4 CSV. L'hash dei criteri deve coincidere con quello citato nel rapporto.
- Registro delle esecuzioni sui dati reali: TUTTE (anche debug). Dopo il primo run reale, nessuna soglia, interpretazione o ipotesi primaria cambia; un bug scoperto dopo si corregge solo con approvazione di A7, registrazione, e riportando i risultati di tutte le versioni.
- Ordine cronologico dichiarato nel rapporto: geometria A3 (descrittiva) e potenza A5 prima delle previsioni; previsioni prima di qualunque esecuzione del motore con i segnali sui dati reali.
