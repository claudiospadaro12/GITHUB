# Specifica integrata v1 — Breaking Band su XAUUSD (A1, R001 integrazione)
Stato: CONGELABILE (proposta a C0). Nessun backtest eseguito, nessun parametro scelto guardando dati. Data: 2026-11-01.
Fonti integrate: Guida Operativa (GUIDA_OPERATIVA_11.txt, "versione didattica"), Checklist Tabellare 15/02/2026, Prompt, Protocolli di Leonardo (versione incollata da Claudio il 01/11, con i due screenshot descritti da C0), RIASSUNTO_PER_TERZI.md (lezioni, non normativo), specifica A2, audit A3, motore A4, potenza A5, critica A6, verifica A7.
Etichette: GUIDA / CHECKLIST / PROTOCOLLO = soglia o regola scritta nella fonte; INTERP = scelta mia (motivo e alternativa dichiarati); DESCRITTORE = calcolato e registrato, MAI usato come filtro.
Avvertenza di fonte (DA_VERIFICARE da Claudio): non e provato che GUIDA_OPERATIVA_11.txt sia il documento ufficiale "Guida Operativa 11" citato dal Comunicato (e una "versione didattica" del 23/12/2025, estratta da PDF con frasi troncate: es. "Il bulge e considerato concluso quando l'espansione di volatilita mostra segnali chiari di" finisce li). La specifica la tratta come fonte primaria.

---------------------------------------------------------------------
## 1. Gerarchia delle fonti applicata
1. Regole di ingresso/uscita e di validita del pattern: Guida > Protocolli (non normativi, ma concordi) > Checklist > Riassunto/Sintesi/Esempi.
2. Solidita (%): Checklist (pesi 25/25/20/15/10/5, categorie Ottimo/Buono/Medio/Debole) — solo DESCRITTORE.
3. Validita del pattern secondo il Prompt: pattern valido = Bulge (TUTTI i criteri) + identificazione CONT/INV + nessuna invalidazione assoluta. Una sezione "non valida" (congestione, rientro < 80%) NON rende invalido il pattern ("sezione non valida" e diverso da "pattern non valido", Prompt) : abbassa la solidita.
4. Dettagli non normativi (entry limit sulla banda, buffer 0,1-0,2 ATR, break-even dopo 1 ATR, riduzione rischio, news) NON entrano nel test base.

## 2. Contraddizioni tra le fonti e scelte (ogni punto: scelta, motivo, alternativa, dove e testata)
| # | Contraddizione | Scelta (PRIMARIA) | Motivo | Alternativa / dove compare |
|---|---|---|---|---|
| K1 | Aggiornamento target: Guida "ogni 2-3 candele" (riga TP) vs "ogni 2-3 ore" (Gestione); Protocolli "ogni 2-3 ORE"; R003 "ogni 3 barre" | Ogni 3 ORE dall'ingresso: H1 = ogni 3 barre, M30 = ogni 6 barre | Tre fonti su quattro dicono ore (Guida Gestione, 2 Protocolli); su H1 "3 candele" e "3 ore" coincidono, quindi il test primario non dipende dalla scelta. Estremo alto di "2-3" per non inventare una media | M30 con 3 barre (lettura "candele") non testata: M30 e esplorativo |
| K2 | Dev. std sotto SMA50: condizione di ingresso (Guida "Conferme tecniche fondamentali": "non entrare finche..."; Protocollo In-Bulge punto 3; Checklist invalidazione assoluta "sd ancora alta/instabile") vs conferma al 5% "idealmente" (Checklist, Guida lettera D) | CONDIZIONE DI INGRESSO per entrambi i pattern: `sd_tau < S50_tau` E `sd_tau <= sd_(tau-3)` | La Guida prevale per le regole di ingresso; i Protocolli concordano per ENTRAMBI i pattern; la Checklist stessa la tratta come invalidazione assoluta ("sd ancora alta"). Costo dichiarato: A5 mostra che con sd<S50 la distanza dalla mediana e ~1,4-1,6 ATR e il pareggio sale a ~65-68%: la regola della scuola si impone una geometria piu sfavorevole, e va misurata con la linea di base abbinata alla stessa distanza | Sensibilita Sa: gate `sd<S50` spento (resta `sd_tau <= sd_(tau-3)`), riportata, non selezionabile |
| K3 | Candela impulsiva 1,0 vs 1,5 ATR | 1,5 ATR (range/ATR) per ENTRAMBI i pattern | Guida: definizione generale e tabella invalidazioni = 1,5; il "1,0 nel rientro/retest" compare solo in una riga della Guida e nella Checklist INV. Riassunto (lezione pagata): 1 candela da 1,0 ATR "uccideva il 99% delle inversioni"; la Guida dice "candele impulsive" (plurale, ~1,5). Aritmetica: il range/ATR supera 1,0 in una quota rilevante delle barre ordinarie; su un rientro di 5-15 barre un divieto assoluto a 1,0 non lascia quasi nulla = filtro auto-colpente (trappola 3 del Riassunto). NB: non e ottimizzazione sui dati: 1,5 e il numero della Guida | Sensibilita Sb: INV con 1,0 letterale (Checklist). Atteso quasi vuota: si riporta l'imbuto |
| K4 | Tipo di bulge e numero di bulge precedenti per CONT vs INV (Guida: CONT "molto piu efficace" su bulge che chiudono un trend o primo bulge dopo laterale; INV "molto piu probabile" in trend con >=2 bulge precedenti, 3a = massimo) | NON e un filtro. Registrato `n_prev` in {0, 1, >=2} come DESCRITTORE di stratificazione | La Guida lo formula come probabilita, non come regola; la Checklist non lo contiene; gli esempi lo contraddicono (Ex2 CONT valido con 2a bulge, Ex8 INV valido con 1a); il Prompt vieta di aggiungere filtri | Previsione esplorativa nel file previsioni (la scuola afferma una dipendenza: e testabile in modo descrittivo, N permettendo) |
| K5 | Perimetro: Guida "Pairs: MAJOR e MINOR, TF D1-H4-H1-M30" vs oro (metallo) e TF del brief H1/M15 | Strumento: XAUUSD, FUORI dallo scopo dichiarato dalla Guida -> il verdetto lo dice. TF: H1 (primario), M30 (esplorativo, ammesso dalla Guida). M15 NON ammesso dalla Guida: non testato. H4/D1: ammessi ma non testabili per frequenza (1/4 e 1/24 delle barre H1) | La Guida elenca TF e strumenti; M15 e una scelta del brief senza fonte. H1 e il TF di tutti gli esempi | M15 solo se C0 lo vuole comunque (decisione D2): sarebbe fuori dalla Guida |
| K6 | Fine della bulge: "larghezza sotto soglia" vs "esaurimento"; frase della Guida troncata | La bulge termina al PICCO CAUSALE `p` (massimo corrente, vedi 4.2); l'esaurimento si verifica al test con `sd_tau < S50_tau` ("la bulge e finita", Guida) e `sd_tau <= sd_(tau-3)`. Nessuna soglia fissa di larghezza | Il Riassunto riporta che la soglia fissa di larghezza tagliava meta dei casi; la Guida definisce la fine tramite la dev. std. Band riding > 20 barre = impulso > 20 barre (gia in B6) | — |
| K7 | Bande dopo la bulge nella CONT: "devono essere in fase di chiusura" (Principi) vs "possono restare gonfie, il ritracciamento e il vero filtro" (Comportamento bande); stessa cosa dice il Riassunto | Nessun criterio separato sull'ampiezza della banda. La "chiusura" e rappresentata SOLO dalla regola K2 (sd) | Evita di contare due volte la stessa serie (larghezza = 4 sd, A6 F23) e risolve la contraddizione interna con una sola condizione | — |
| K8 | Congestione (CS/CDA) come cancello vs punteggio | PUNTEGGIO + stratificazione, non cancello. La compressione-espansione e comunque imposta da B1 (ampiezza >= 2x pre-bulge) e B2 | Prompt: "sezione non valida" != "pattern non valido"; Guida: la congestione e "fase preparatoria" e il criterio discriminante e il cambio di regime della volatilita (che B1/B2 misurano); dieci soglie INTERP di A2 per CS/CDA ridurrebbero N (A2: -60/75%) con N gia critico (A5). I pattern testati sono quindi un SOPRAINSIEME dei pattern validi secondo l'autore (CK-33): il verdetto lo dice | Stratum "congestione valida si/no" e flag "Checklist-stretta" (congestione valida + rientro >= 80% + nessuna invalidazione A2): sottoinsiemi degli stessi trade. **OBIEZIONE A2 NON RISOLTA** (A2 la tratta come cancello) |
| K9 | "Ritracciamento ordinato >= 80% dei criteri", "range ridotto 30-50%", "ombre <= 1,5 x corpo" | Solo DESCRITTORE di solidita. Cancelli veri: nessuna candela > 1,5 ATR in (p, tau] e sd (K2) | La Guida stessa dice che 30-50% e 'linee guida facoltative non presenti nelle lezioni originali' e che l'ordine va giudicato su 'assenza di violenza', non su linearita: quindi niente rapporto di efficienza (ER) come cancello (A2 B2c scartato) | Flag "rientro >= 80% (A2)" come stratum |
| K10 | Misura della candela: A2 usa TR, la Guida dice "range" | `range = High - Low`, rapporto a `ATR_(u-1)` (ATR della barra precedente, gia noto) | Guida: "nessuna candela con range > 1,5xATR"; evita che un gap di riapertura (TR) produca finti impulsi (A6 R-B2) | TR nel log come descrittore |
| K11 | Direzione del bulge: colore della prima candela (errata) vs movimento netto | Direzione `d = sign(C_t - M_t)` al momento di armamento, con ER netto (B4) e distanza dalla mediana (B5) | Lezione 2 del Riassunto: la direzione si prende dal movimento netto dell'espansione | — |
| K12 | Sequenza nella CONT (Protocollo In-Bulge punto 2 + screenshot "da evitare"): mediana -> ritorno alla banda dell'impulso -> poi banda opposta | Regola esplicita SEQ (vedi 5.1, C3): se tra `p` e `tau` il prezzo tocca la mediana e poi una barra successiva ritocca la banda dell'impulso (con High <= High_p), il segnale e invalidato. Morti per SEQ contati A PARTE nell'imbuto | Richiesta di C0; coerente con Riassunto ("la continuazione muore se torna sulla banda dell'impulso") | Contatore informativo "ritorno alla banda dell'impulso SENZA tocco di mediana" (regola larga del Riassunto): non e un filtro, serve a misurare quanto cambierebbe |
| K13 | Ingresso "al tocco" (Guida) / entry limit con buffer (Protocollo) vs barra chiusa | Segnale alla CHIUSURA della barra di tocco/retest `tau`, ingresso a mercato all'APERTURA della barra `tau+1` (conservativo e causale, equivale a "a mercato alla prima reazione" del Protocollo). Registrata la distanza fra livello di banda e prezzo d'ingresso (ATR) | Guida e Protocollo non sono eseguibili in modo causale su barre OHLC con una candela valutata a chiusura; il limit con buffer e dettaglio non normativo | Ordine limite sul livello: escluso (decisione D13) |
| K14 | Pesi: 20% rientro include le righe "Bande", ma esiste anche 15% Bande | Rientro 20% = A+B; Bande 15% = C (come A2) | Evita doppio conteggio | Solo descrittore |
| K15 | Chiusura forzata: assente nella Guida ("si chiude alla mediana, oppure in Stop Loss"); A2 propone 48 barre, A4 default 150 | Nessuna uscita a tempo: `maxhold = 1000` barre (non vincolante in pratica) + chiusura a fine dati del periodo. Le chiusure a fine dati sono contate a parte | Fedelta alla Guida; A6 T11: ogni limite temporale e una scelta che puo decidere il segno | Sensibilita Sc: maxhold 150 |
| K16 | Pendenza della banda "sulle tre candele precedenti la candela di retest" (Guida, A2 includeva la barra di retest) | `U_(tau-1) - U_(tau-4)` (banda dell'impulso; per d=-1 e il suo specchio con L), piatta o a favore se `<= +0,10 ATR_(tau-1)` | Guida: valutata "esclusivamente sulle tre candele immediatamente precedenti" il retest. 0,10 ATR = tolleranza A2 (INTERP) | tolleranza 0,20 non testata (troppe sensibilita) |
| K17 | Gestione opzionale (a +1 ATR ridurre rischio/BE) | NON applicata | Guida: "opzionale"; Protocollo: dettaglio; aggiunge gradi di liberta e cambia il PF | decisione D12 |
| K18 | "In-Bulge" nel Pine di Claudio (indicatore_inbulge_claudio.pine): long sul secondo tocco della banda dell'IMPULSO prima della mediana | NON usato come riferimento | Non coincide con la CONTINUAZIONE della Guida/Riassunto/Protocolli (ingresso sulla banda OPPOSTA). Se Claudio intende il Pine, e un'altra strategia | decisione D15 |
| K19 | Esempi PDF: etichette "INVERSIONE RIALZISTA" incoerenti (Ex7/Ex9/Ex10) | Convenzione esplicita: `d` = segno del bulge; `side` = segno del trade | A2/A6 F17 | — |

## 3. Notazione e indicatori (identici ad A4; ogni periodo e una serie a se, nessuna concatenazione)
Barre TF costruite da M1 (prezzi BID; spread = campo del CSV, in punti, 1 punto = 0,01 USD), bucket = `t // periodo` in ora server del CSV (A4). Valori calcolati alla CHIUSURA della barra `t` con sole barre `<= t`.
- `M_t` = SMA(close,20) (la "mediana"). `sd_t` = dev. std. di POPOLAZIONE (ddof=0) delle ultime 20 chiusure. `U_t = M_t + 2 sd_t`, `L_t = M_t - 2 sd_t`, `W_t = 4 sd_t`. `S50_t = SMA(sd,50)`. `ATR_t` = ATR(14) di Wilder (seme SMA dei primi 14 TR). `R_t = High_t - Low_t`. `z_t = R_t / ATR_(t-1)`.
- Tocco: banda alta `High_t >= U_t`; banda bassa `Low_t <= L_t`; mediana `Low_t <= M_t <= High_t` oppure barra interamente oltre; tolleranza 0 (Prompt: "prossimita non basta"). Si registrano (descrittore) i tocchi con penetrazione < 1 spread.
- Warm-up: le prime 200 barre di ogni periodo non generano segnali.
- Simmetria: per `d=-1` si applicano le formule specchiate (prezzi -> -prezzi, High<->Low, U<->L). UN SOLO percorso di codice (A6 T09). Nessuna asimmetria long/short voluta.
- Direzione: `d` = segno del bulge (+1 su). `side` = segno del trade (+1 long). CONT: `side = d`. INV: `side = -d`.
- Tipo di contatto (da "Dichiarazione di Test", DESCRITTORE): al bar di test, spike (solo ombra oltre la banda) / corpo (max(O,C) oltre la banda), e test (close dentro la banda) / violazione (close oltre).

## 4. Bulge (Guida 3.3 + Checklist Bulge; TUTTI i criteri obbligatori)
### 4.1 Armamento (alla chiusura di `t`, per direzione `d=+1`; `d=-1` specchio)
- `s` = barra del minimo Low nella finestra `[t-19, t]` (a parita, la prima). Inizio dell'impulso.
- `W_ref` = mediana di `W` su `[s-14, s]` (la fase che precede l'impulso).
- B1 bande molto aperte: `W_t >= 2,0 * W_ref` (INTERP: "molto"=raddoppio).
- B2 dev. std. in espansione: `sd_t > S50_t` (Checklist: "sopra la sua SMA50"; scartata l'alternativa "accelerazione 1,25x" di A2: piu semplice, e la formula della Checklist).
- B3 candele impulsive: almeno una barra `u` in `(s, t]` con `R_u >= 1,5 * ATR_s`, corpo nella direzione `d` (GUIDA/CHECKLIST 1,5; il tetto "3" non e applicato; si conta nel log il numero di barre > 3 ATR come descrittore di spike da news).
- B4 movimento netto: `ER(s,t) = |C_t - C_s| / sum|C_i - C_(i-1)| >= 0,50` e `C_t > C_s` (INTERP).
- B5 mediana distante: `C_t - M_t >= 2,0 * ATR_s` (INTERP; il segno stabilisce `d`).
- B6 impulso <= 20 barre: `t - s <= 20` (CHECKLIST); in seguito `p - s <= 20` (altrimenti bulge disarmata: "band riding prolungato").
- La bulge e ARMATA alla prima `t0` in cui B1-B6 sono tutte vere. Un episodio nuovo nella stessa direzione richiede `s_nuovo > p_precedente` (impulsi distinti). Una bulge di direzione opposta che si arma disarma quella in corso.
### 4.2 Picco causale `p` e vita dell'episodio
- `p_t` = barra del massimo High nell'intervallo `[s, t]` (a parita, la prima), ricalcolato a ogni barra con soli dati `<= t` (running extreme). Se una barra `u` fa `High_u > High_p`, allora `p := u` e la fase di ritracciamento RIPARTE (tocchi di mediana/bande precedenti annullati). Nessun pivot a destra, nessun `center=True`.
- Il test puo avvenire solo a `tau` con `3 <= tau - p <= 30` (`MIN_RETR=3`, `T_MAX=30`, INTERP: lacuna delle fonti; esempi 1-3 = 13-25 barre H1). Oltre `T_MAX` la bulge e disarmata.
- Un tocco della banda opposta a `tau - p < 3` (ritracciamento troppo rapido/violento) CONSUMA l'episodio (nessun segnale CONT).
- Un solo segnale per episodio e per variante: dopo il primo segnale (eseguito o scartato) l'episodio e consumato.

## 5. Pattern (valutati a ogni barra `tau` di tocco; il segnale e la PRIMA barra che soddisfa TUTTE le condizioni; l'episodio muore se una condizione cumulativa non puo piu essere soddisfatta)
Per `d=+1`; specchio per `d=-1`.
### 5.1 CONTINUAZIONE (trade nel verso del bulge: `side = d`)
- C0 Tocco: `Low_tau <= L_tau` (banda opposta), primo tocco con `tau - p >= 3`.
- C1 Nessuna candela impulsiva: per ogni `u` in `(p, tau]`, `R_u <= 1,5 * ATR_(u-1)` (include la candela del test: GUIDA "test non impulsivo"; copre anche il "corpo grande" dello screenshot da evitare).
- C2 Dev. std: `sd_tau < S50_tau` E `sd_tau <= sd_(tau-3)`.
- C3 SEQUENZA (esplicita, richiesta di C0 / Protocollo In-Bulge): NON esiste una coppia `p < r < u < tau` con `Low_r <= M_r` (tocco della mediana) e `High_u >= U_u` (ritorno sulla banda dell'impulso) senza che `High_u > High_p` (altrimenti sarebbe un nuovo estremo e riparte la fase). Rappresenta "zig-zag: mediana -> banda dell'impulso -> poi banda opposta".
- Nessun requisito sull'inclinazione/compressione della banda opposta (GUIDA).
- Trade: LONG se `d=+1`, SHORT se `d=-1`.
### 5.2 INVERSIONE (trade contro il bulge: `side = -d`)
- I0 Sequenza: dopo `p` esiste `r` con `Low_r <= M_r` (ritorno alla mediana, puo superarla); poi `tau > r` con `High_tau >= U_tau` (retest della banda dell'impulso), `3 <= tau - p <= 30`; il retest non e un nuovo estremo (`High_tau <= High_p`).
- I1 Banda opposta mai toccata: `Low_u > L_u` per ogni `u` in `[s, tau]`. (se toccata: non e piu inversione; l'episodio e consumato per la variante INV.)
- I2 Nessuna candela impulsiva: `R_u <= 1,5 * ATR_(u-1)` per ogni `u` in `(p, tau]` (K3; sensibilita Sb: 1,0).
- I3 Banda dell'impulso piatta o a favore: `U_(tau-1) - U_(tau-4) <= +0,10 * ATR_(tau-1)` (K16).
- I4 Dev. std: `sd_tau < S50_tau` E `sd_tau <= sd_(tau-3)` (K2; "non si gonfia di nuovo", "sd in calo").
- Trade: SHORT se `d=+1`, LONG se `d=-1`.
### 5.3 Esclusivita e conteggio
CONT e INV sono varianti SEPARATE (due run, due insiemi di trade). Possono coesistere sullo stesso episodio (INV prima, CONT poi): il numero di coppie e riportato. Una posizione alla volta PER VARIANTE (A4); i segnali durante una posizione aperta sono scartati e contati.

## 6. Gestione del trade e convenzioni di esecuzione (per A4/A7)
1. Ingresso: all'apertura della prima M1 della barra `tau+1`. LONG paga `ask = open + spread` (spread della M1 di ingresso); SHORT vende a `bid = open`. Scartato (e contato) se la M1 di ingresso e a piu di 180 minuti dalla fine nominale della barra `tau` (buchi/weekend; `max_gap_ingresso_min=180`: copre la pausa giornaliera, anche con orario legale sfasato).
2. Stop: `entry -/+ 3 * ATR_tau` (ATR della barra segnale, congelato, MAI allargato; da prezzo di fill). Regola fissa (GUIDA).
3. Target iniziale: `M_tau`. Ricalcolo ogni 3 ORE dall'ingresso (K1): `ricalcolo_ogni = 3` su H1, `6` su M30; la mediana a chiusura della barra `tau+k*r` vale dalla M1 successiva. Il target e un ordine limite.
4. Regola sul TARGET GIA OLTRE IL PREZZO: (a) all'ingresso: LONG con `target0 <= ask` o SHORT con `target0 >= bid` -> NESSUN TRADE, contato come `TARGET_OLTRE_INGRESSO` nell'imbuto. (b) durante il trade: se dopo un ricalcolo il nuovo target e gia superato dal prezzo, uscita a mercato all'apertura della prima M1 successiva, classificata dal P&L (puo essere una perdita), non dall'etichetta (A6 T06-iv).
5. Convenzione di spread "executable" di A7 (= quella di A4): prezzi dei dati = BID, `ask = bid + spread` della stessa M1. LONG: entra ad ask, esce a bid (stop se `Low <= stop`, target se `High >= target`). SHORT: entra a bid, esce ad ask (stop se `High + spread >= stop`, target se `Low + spread <= target`). Spread di ogni M1 = suo campo. Costo in R = spread / (3 ATR).
6. Stop prima del target nella stessa M1 (anche nella M1 di ingresso e in quella di ricalcolo). Eventi contati.
7. Gap: lo stop si riempie all'apertura se peggiore del livello. Target: **si riempie AL LIVELLO, senza miglioramento di prezzo** (A6 T06-v, A7 sez. 2). NOTA: A4 oggi riempie il target all'apertura se migliore -> difformita da allineare (sezione 9, U-A7-2).
8. Uscite ammesse: target, stop, fine dati del periodo (`FINE_DATI`, riempimento alla chiusura dell'ultima M1). Nessuna chiusura a tempo (K15: `maxhold=1000`). Nessun BE, trailing, parziali.
9. SPREAD = 0 (A3: 677 righe: 2013 luglio, 2020 aprile-maggio; anomalia probabile): prima di costruire le M1 per il motore, lo spread 0 e sostituito con la MEDIANA degli spread non nulli dello stesso periodo e della stessa ora server (tabella di A3). I segnali non usano lo spread; la sostituzione riguarda solo i costi. Si riporta quanti trade avevano spread 0 in ingresso/uscita e il risultato escludendoli.
10. Nessun filtro per orario, spread, news (K: news NON_MISURABILE, nessun calendario nei dati).

## 7. Descrittori e solidita (Checklist; nessun filtro)
- `n_prev` in {0, 1, >=2}: numero di episodi precedenti della stessa direzione senza bulge opposto in mezzo, nelle 200 barre precedenti `s` (impulsi distinti: `s_nuovo > p_precedente`).
- Congestione CS/CDA su 15 barre che terminano in `s`: ESATTAMENTE come in A2 sez. 1.1 (soglie A2 congelate, usate solo per il punteggio).
- Criteri del rientro (A2 sez. 1.4), banda (C), test, conferme K1-K3, bonus (A2 sez. 1.9) come descrittori. K4 (news) esclusa da numeratore e denominatore.
- Solidita = 25*cong + 25 (bulge, sempre pieno) + 20*quota(rientro A+B) + 15*quota(bande C) + 10*quota(test) + 5*quota(conferme). Fasce: Ottimo >= 85, Buono 70-84, Medio 55-69, Debole < 55 (Checklist).
- Altri descrittori registrati per ogni trade: `D = |target0 - fill| / ATR` (distanza in ATR), pareggio atteso `(3 + c)/(3 + D)` con `c` = spread/ATR, distanza fra livello di banda e fill (ATR), durata, motivo di uscita, tipo di contatto, lato, periodo, ora server, `n_prev`, presenza di barra > 3 ATR nel bulge, `gap_ingresso_min`.

## 8. Tabella interpretazioni (CK-33): cosa e misurabile e cosa no
- Misurabile, soglia dalla fonte: B2, B3 (1,5), B6 (20), tocco, impulsiva 1,5 (range), stop 3 ATR, target SMA20, sd<S50, ricalcolo 3 ore, MAI allargare lo stop.
- Misurabile con soglia INTERP (dichiarata): B1 (2,0), B4 (0,50), B5 (2,0 ATR), `T_MAX` 30, `MIN_RETR` 3, tolleranza banda 0,10 ATR, `sd<=sd(-3)`, finestra 15 barre di `W_ref`, SEQ (formalizzazione), n_prev.
- NON_MISURABILE / non applicato: news ad alto impatto; "ordinato/di scarico/rigetto evidente" oltre le proxy di A2 (solo descrittori); screenshot standard; Dichiarazione di Test oltre al tipo di contatto; giudizio visivo "bocca di coccodrillo".
- Fuori perimetro del test: entry limit/buffer, BE/riduzione rischio, doppio TP di Emiliano (InpTPMode=1), scaling, sessioni.

## 9. Parametri congelabili (tabella flat per l'hash; ogni valore e stato scelto PRIMA di guardare i dati)
```
BB_N=20 BB_K=2.0 SD_DDOF=0 S50_N=50 ATR_N=14 ATR_METODO=wilder WARMUP=200
TF_PRIMARIO=60min TF_ESPLORATIVO=30min RICALCOLO_ORE=3 (H1: 3 barre; M30: 6 barre)
WIN_IMPULSO=20 REF_BARRE=15 B1_W=2.0 B2=sd>S50 B3_ATR=1.5 B3_TETTO=nessuno B4_ER=0.50 B5_ATR=2.0 B6_BARRE=20
MIN_RETR=3 T_MAX=30 IMPULSIVA_ATR=1.5 (range/ATR_prec) SD_GATE=sd<S50 & sd<=sd[-3] BANDA_TOL_ATR=0.10 BANDA_FINESTRA=U[-1]-U[-4]
STOP_ATR=3.0 TARGET=SMA20 MAXHOLD=1000 MAX_GAP_INGRESSO_MIN=180 FILL_TARGET=livello FILL_STOP=peggiore SPREAD_MODELLO=executable SPREAD0=mediana_periodo_ora
UN_SEGNALE_PER_EPISODIO=si UNA_POSIZIONE_PER_VARIANTE=si
SENSIBILITA (una alla volta, tutte riportate, non selezionabili): Sa sd_gate_off | Sb INV_impulsiva=1.0 | Sc MAXHOLD=150 | Sd spread x1.5 | Se T_MAX=20 e 50 | Sf tocco con penetrazione >= 1 spread
```

## 10. Obiezioni NON RISOLTE (da A2, A6, A7) e altri punti aperti
**A2**
- U-A2-1 Congestione come cancello (A2 la voleva obbligatoria, "senza congestione non c'e setup"). Io: punteggio (K8). Se C0 preferisce il cancello, la specifica A2 sez. 1.1 e pronta, con N molto minore.
- U-A2-2 Misura candela TR (A2) vs range (K10); uscita forzata 48 barre (A2) vs nessuna (K15); `ER(p,tau)>=0,40` come cancello di "direttezza" (A2 B2c): non adottato (K9); regola 80% come cancello: non adottata; X2 a 1,0 ATR: non adottato (K3).
- U-A2-3 A2 raccomandava di decidere "12 barre M15 / 3 barre" per il ricalcolo: superata da K1 (M15 escluso), ma per M30 la lettura "3 barre" resta non testata.
- U-A2-4 Esempi: ancora nessuna verifica visiva di Ex6/Ex7 con la nuova specifica (R010 fuori da questo incarico).
**A6**
- U-A6-1 "Il test e un ibrido arbitrario" (F00): ridotto ma non eliminato: stop/target/ricalcolo ora vengono dalla Guida, ma restano ~10 soglie INTERP e il perimetro oro e fuori scopo.
- U-A6-2 F17/F18 (etichette degli esempi, CDA con candele > 1,5 ATR): DA_VERIFICARE su immagini; non risolto.
- U-A6-3 Tutti i controlli [B] CK-01..CK-15 e CK-20..CK-35 restano da eseguire: richiedono che il codice dei segnali ESISTA (oggi NON esiste: A4 ha il motore, nessuno ha scritto la macchina a stati di questa specifica).
- U-A6-4 CK-23/CK-24 (DST/origine barre, storia di data snooping dei CSV): non risolti.
**A7**
- U-A7-1 Interfaccia: A7 chiede `signal_fn(bars)`, log con SCHEDULE completa dei target e contatori d'imbuto; A4 espone `n_agg_target` e `target_finale`, non la schedule. Da colmare.
- U-A7-2 Riempimento del target in gap: A7/A6 = al livello; A4 = all'apertura se migliore. Questa specifica sceglie il livello: serve parametro/modifica in A4 oppure A7 ricalcola con la convenzione di A4 e lo dichiara (decisione D11).
- U-A7-3 Chiusura forzata: A7 = all'open della prima M1 dopo l'istante; A4 = all'ultima M1 della barra. Qui irrilevante (nessuna chiusura a tempo), ma `FINE_DATI` va definito uguale (close dell'ultima M1).
- U-A7-4 V16 elenca 16 celle con M15: con M30 al posto di M15 il piano V16/checklist va aggiornato da A7.
- U-A7-5 A7 non puo usare git per V15: l'ordine criteri->risultati si prova solo con l'hash registrato da C0 in events.jsonl PRIMA del run.

## 11. Cosa NON viene misurato (limite dichiarato)
News; esecuzione reale (slippage, requote, swap, commissioni); spread FTMO (i dati sono BCM); drawdown e regole prop (perdita giornaliera/massima); EURUSD; giudizio discrezionale su grafico. Un risultato vale per questa traduzione, su XAUUSD, H1 (e M30 esplorativo), 4 periodi che sono 4 regimi.
