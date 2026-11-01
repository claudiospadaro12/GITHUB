# Specifica numerica Breaking Band (A2) — R001, R010
Autore: A2 (strategia e competenza di dominio). Stato: bozza per il consiglio, NESSUN dato M1 letto, NESSUN backtest, nessuna soglia ottimizzata.
Fonti lette integralmente: Checklist Tabellare 15/02/2026, Prompt 15/02/2026, Sintesi utente + Comunicato, Esempi Operativi (PDF, 13 pagine = copertina + indice + disclaimer + 10 esempi, tutte viste; pagine 8 e 10 riviste a 200 dpi per il target).

Etichette usate:
- `FONTE` = la soglia e scritta nel testo (Checklist/Prompt).
- `INTERP` = soglia mia, il testo e qualitativo; indico motivo e alternativa ragionevole. Le alternative sono SENSIBILITA dichiarate in anticipo: non vanno scelte guardando i risultati.
- `NON_MISURABILE` = non calcolabile su barre OHLC; indico il trattamento.
- Gerarchia delle fonti (dal Prompt): Guida Operativa (MANCA) > Checklist (vincolante) > Esempi (solo comparativi, non normativi). La Sintesi utente e "probabile output di una AI, NON normativa" (Claudio): ne uso solo stop/target/entrata, perche e l'unica fonte che li dice, e lo dichiaro.

---------------------------------------------------------------------
## 0. Indicatori, notazione, parametri (per A4)
Barre del timeframe TF (H1 o M15) costruite da M1 (prezzi bid, spread dal CSV). Tutto e calcolato alla CHIUSURA della barra t e usa solo barre <= t.

| Simbolo | Definizione | Stato |
|---|---|---|
| M_t | SMA(close, 20) = mediana | FONTE (Bollinger 20/2 dal brief) |
| sd_t | deviazione standard POPOLAZIONE (ddof=0) delle ultime 20 chiusure | INTERP: TradingView/MT5 usano ddof=0; con ddof=1 le bande cambiano di ~2,6% (irrilevante). Lunghezza 20 = quella delle bande: il Comunicato dice solo "Standard Deviation + SMA50" |
| U_t, L_t, W_t | M ± 2·sd ; W = U − L = 4·sd | FONTE |
| S50_t | SMA(sd, 50) (linea gialla sotto) | FONTE |
| TR_t | max(H−L, \|H−C_{t−1}\|, \|L−C_{t−1}\|) | standard |
| ATR_t | ATR 14 di Wilder (RMA, seme = SMA dei primi 14 TR) | INTERP: negli esempi compare "ATR (14)" di TradingView, che e Wilder. Alt: SMA(TR,14) |
| Taglia della barra t | TR_t / ATR_{t−1} (ATR della barra PRECEDENTE, per non contaminare con la barra stessa) | INTERP; alt: ATR_t |
| d | direzione del bulge: +1 su, −1 giu. Segni: per bulge giu si specchiano tutte le formule | — |
| s | barra di inizio impulso (minimo low nelle 20 barre fino al bulge, o massimo high se d=−1) | INTERP |
| p | barra del massimo estremo corrente dopo l'armamento del bulge (running extreme, causale) | INTERP |
| τ | barra del test (quella che tocca la banda); segnale a chiusura di τ | — |
| ER(a,b) | efficienza di Kaufman = \|C_b − C_a\| / Σ\|C_i − C_{i−1}\| | INTERP (misura di "diretto/netto") |
| Warm-up | scartare le prime 200 barre (50 sd + 20 close + stabilizzazione ATR) | INTERP |

Tocco della banda (Prompt, REGOLA VINCOLANTE): "il corpo o lo spike interseca la linea; non basta la prossimita".
- Tocco della banda alta alla barra t: `High_t >= U_t`. Banda bassa: `Low_t <= L_t`. Tolleranza = 0 (nessuna "prossimita"). Tocco della mediana: `Low_t <= M_t <= High_t` oppure barra interamente oltre.
- U_t, L_t, M_t sono i valori che la barra t ha a CHIUSURA (includono la sua chiusura): e quello che si vede sul grafico a barra chiusa; nessun look-ahead se si entra alla barra dopo.
- "NON verificabile -> NO": numericamente non esiste ambiguita; l'equivalente e il tocco marginale. Variante di sensibilita: tocco valido solo se penetrazione >= 1 spread (Prompt: il dubbio vale NO). Le penetrazioni < 1 spread vanno contate e riportate.

Deviazione standard (Prompt, REGOLA VINCOLANTE), traduzione:
- IN ESPANSIONE(t) = `sd_t > S50_t` (per almeno 1 barra completa = a chiusura) OPPURE accelerazione `sd_t >= 1.25 · sd_{t−3}` (INTERP: "evidente accelerazione" non e quantificato; alt: 1.5).
- IN CALO(t) = (`sd_t < sd_{t−1}` E `sd_{t−1} < sd_{t−2}`) [2 barre consecutive di discesa, INTERP: leggo "2 candele consecutive di discesa" come 2 discese = 3 valori] OPPURE `sd_t < S50_t`.
- Nota: le due definizioni NON sono mutuamente esclusive (sd sopra S50 con 2 discese = entrambe vere) e "IN CALO" e vero anche con sd in salita se sta sotto S50 -> vedi §3 (ambiguita).
- "In caso di dubbio -> NO": equivale a usare maggiore stretto e nessuna tolleranza.

---------------------------------------------------------------------
## 1. Criteri della Checklist tradotti (comuni a CONTINUAZIONE e INVERSIONE)

### 1.1 CONGESTIONE INIZIALE (25%) — finestra: 15 barre che terminano in s (la barra prima dell'impulso). Parametro N_cg = 15 (FONTE parziale: "10-15 candele" nel CDA; il testo non da una finestra per la CS)
Precedenza: si valuta prima CS; se <4/5 si valuta CDA; se nessuna e valida, congestione = 0 -> setup scartato (Nota operativa: senza congestione non c'e setup). CS e CDA danno entrambe il 25% pieno.

**CS (valida se >= 4/5 — FONTE)**
| # | Testo | Condizione numerica | Stato / motivo / alternativa |
|---|---|---|---|
| CS1 | Bande in compressione chiara e progressiva | `W_s <= 0.85·W_{s−15}` E pendenza di regressione lineare di W su 15 barre < 0 | INTERP. 0.85 preso dal CDA (calo 15-30%). Alt: 0.70 |
| CS2 | Range ridotto e omogeneo | media(TR, 15 barre) <= 0.90 · media(TR, 50 barre precedenti la finestra) E CV(TR,15) <= 0.60 | INTERP ("ridotto" rispetto a cosa non e detto: scelgo il contesto precedente). Alt: confronto con ATR 50 |
| CS3 | Lateralita | ER(s−15, s) <= 0.30 | INTERP. Alt: spostamento netto <= 1.5 ATR |
| CS4 | Nessun micro-impulso significativo | max TR_t/ATR_{t−1} in finestra <= 1.5 | INTERP (stessa soglia 1.5 del CDA). Alt: 1.25 |
| CS5 | Dev. std bassa e stabile | `sd_s < S50_s` E (max sd − min sd)/media sd su 10 barre <= 0.5 | INTERP ("bassa" = sotto SMA50, coerente col Prompt; "stabile" scelto da me). Alt: stabilita <= 0.35 |

**CDA (usare SOLO se CS assente; valida se TUTTI SI — FONTE)**
| # | Testo | Condizione numerica | Stato |
|---|---|---|---|
| CDA1 | Dev. std in calo costante >= 10-15 candele | in 12 barre fino a s: almeno 10 con `sd_t < sd_{t−1}` E `sd_s < sd_{s−12}` | INTERP: "costante" letto in senso stretto sarebbe 10 discese CONSECUTIVE, quasi mai vero (sd su finestra mobile di 20). Alt rigida: 10 consecutive (riportarla come variante; attesa: CDA quasi vuota) |
| CDA2 | Dev. std < SMA50 | `sd_s < S50_s` | FONTE |
| CDA3 | Restringimento reale (ampiezza in calo 15-30%) | `W_s / W_{s−15} <= 0.85` | FONTE (15%); INTERP: tetto del 30% NON applicato (un calo >30% e piu compressione, non meno). Alt letterale: 0.70 <= rapporto <= 0.85 |
| CDA4 | Nessuna candela > 1.5 ATR | TR_t <= 1.5·ATR_{t−1} per ogni t in finestra | FONTE |
| CDA5 | Movimento ordinato in canale/flag senza impulsi contrari | regressione lineare sulle 15 chiusure: R² >= 0.50 E nessuna barra in direzione opposta alla pendenza con corpo >= 1.0 ATR | INTERP. Alt: R² >= 0.65 |
Contesto direzionale (descrittore, non criterio): `dir_cong = sign(pendenza)`; se CDA: `dir_cong` relativo a d (concorde / opposta). Vedi §3.

### 1.2 BULGE (25%) — TUTTI i criteri SI (FONTE). Armamento: alla chiusura della barra t0 in cui tutti e 6 sono veri sulla finestra impulso [t0−19, t0]. Il bulge "latch-a" (resta armato) per max T_max=30 barre dal running extreme p.
| # | Testo | Condizione numerica | Stato / alternativa |
|---|---|---|---|
| B1 | Bande molto aperte ("bocca di coccodrillo") | `W_t >= 2.0 · mediana(W su finestra congestione)` | INTERP ("molto" non quantificato; 2.0 = larghezza raddoppiata). Alt: 1.5 / 3.0 (sensibilita) |
| B2 | Dev. std sopra la sua SMA50 | IN ESPANSIONE(t) (def. Prompt, §0) | FONTE (Prompt) |
| B3 | Candele impulsive (1.5-3x ATR) | almeno 1 barra t nell'impulso con `TR_t / ATR_s >= 1.5` (ATR di riferimento pre-impulso, barra s) e corpo nella direzione d | FONTE per 1.5. Il "3" e ambiguo (tetto? descrizione?): non applico tetto. Alt: escludere barre > 3 (possibile spike da news) |
| B4 | Movimento netto e unidirezionale | `ER(s,p) >= 0.50` | INTERP. Alt: 0.40 |
| B5 | Mediana molto distante dal prezzo | `\|C_p − M_p\| >= 2.0 · ATR_s` | INTERP (equivale a sd >= 1 ATR). Alt: 3.0 ATR (= distanza dello stop) |
| B6 | Impulso <= 20 candele | `p − s <= 20` | FONTE |
Descrittori (non criteri, vedi §3): `n_prev` = numero di bulge precedenti della stessa direzione senza bulge opposto in mezzo, in 200 barre (INTERP: nell'Esempio 4 i 3 bulge coprono ~190 barre H1); `ctx` in {laterale, direzionale concorde, direzionale opposta}.

### 1.3 IDENTIFICAZIONE (0%): il tipo non e scelto da un giudizio ma dal percorso del prezzo dopo il bulge (causale)
- Dopo il bulge armato con direzione d, il prezzo si ritrae. Se al test τ ha toccato la banda OPPOSTA (`d=+1: Low_τ <= L_τ`) -> candidato CONTINUAZIONE (trade nella direzione d, LONG se d=+1).
- Se prima ha toccato la MEDIANA senza mai toccare la banda opposta (dall'inizio impulso s a τ) e poi ritocca la banda dell'IMPULSO (`d=+1: High_τ >= U_τ`) -> candidato INVERSIONE (trade contro d, SHORT se d=+1).
- Sono mutualmente esclusivi per la stessa fase (CONT richiede tocco opposto, INV lo vieta). Se il prezzo fa un nuovo estremo oltre p prima del test, p si aggiorna e la fase di ritracciamento riparte (il test precedente e annullato).
- Lacuna: tempo massimo tra p e τ non nelle fonti -> T_max = 30 barre (INTERP; esempi 1-3: 13-25 barre H1; Esempio 5, invalido, ~45+). Alt: 20 / 50.

### 1.4 RITRACCIAMENTO / RIENTRO ORDINATO (20%) — finestra R = barre (p, τ]; lunghezza minima 3 barre (INTERP, sotto non c'e "scarico"). Soglia validita: >= 80% dei criteri SI (FONTE) = >= 8 su 10 (A=4, B=3, C=3 per ciascun tipo). Le Note tecniche (micro-rotazioni ammesse; ordine = assenza di violenza) sono implementate sotto A2/B1/B3.
| # | Testo | CONT | INV | Condizione numerica | Stato / alternativa |
|---|---|---|---|---|---|
| A1 | Range ridotto 30-50% vs bulge | si | si | media(TR in R) <= 0.70 · media(TR in [s,p]) | FONTE (30%); tetto 50% non applicato (INTERP). Alt letterale: rapporto in [0.50,0.70] |
| A2 | Nessuna candela > 1.5 ATR | si | si | TR_t <= 1.5·ATR_{t−1} per ogni t in R | FONTE |
| A3 | Ombre <= 1.5x corpo | si | si | Σ ombre / Σ corpi (su R) <= 1.5 | INTERP: per-candela e indefinito per i doji (corpo→0) e contraddice il bonus "pin bar, doji". Alt: >= 75% delle barre con ombre <= 1.5·max(corpo, 0.1·TR) |
| A4 | Assenza di spike profondi o engulfing impulsivi | si | si | nessuna ombra singola >= 1.0 ATR in R; nessuna barra con corpo che ingloba il corpo precedente E corpo >= 0.75 ATR | INTERP. Alt: ombra >= 0.75 ATR |
| B1 | Movimento ordinato (no impulsi contrari) | si | si | nessuna barra in R in direzione del bulge con corpo >= 1.0·ATR | INTERP |
| B2c | Procede diretto verso la banda opposta | si | — | ER(p,τ) >= 0.40 | INTERP (l'Esempio 5 e invalido proprio per "ritracciamento non diretto"). Alt: 0.30 |
| B2i | Rientra verso la mediana senza toccare la banda opposta | — | si | esiste r in (p,τ) con tocco della mediana E nessun tocco della banda opposta in [s,τ] | FONTE (Checklist) + Esempio 9 (mediana non toccata = invalido) |
| B3 | Micro-rotazioni accettate se non impulsive | si | si | = (A2 vero) E (B1 vero): criterio NON indipendente, conta SI se non ci sono barre impulsive | INTERP; segnalo la ridondanza (§3) |
| C1 | Bande in restringimento dopo il bulge | si | si | `W_τ < W_{τ−3}` E `W_τ <= 0.90 · max(W in [p,τ])` | INTERP. Alt: solo `W_τ < W_{τ−3}` |
| C2i | Banda del test piatta o inclinata a favore | — | si | banda dell'impulso (d=+1: U): `U_τ − U_{τ−3} <= +0.10·ATR_τ` (piatta o in discesa; per d=−1 specchio) | INTERP (piatta = ±0.10 ATR su 3 barre: l'Esempio 6/8 valutano "le 3 candele precedenti"). Alt: ±0.20 ATR |
| C3 | Nessuna espansione contraria | si | si | in R nessuna barra con `sd_t >= 1.05·sd_{t−1}` accompagnata da una chiusura in direzione del bulge (nuova spinta) | INTERP |
| C4c | Banda opposta NON richiede compressione ne inclinazione | si | — | sempre SI (criterio di non-richiesta: nessun test); non lo conto nel denominatore | INTERP |
Nota di struttura: la Checklist mette le righe C ("Comportamento delle bande") DENTRO la sezione 20%, ma il modello a pesi ha "Comportamento delle bande" 15% separato. Vedi §3.

### 1.5 TEST CHIAVE (10%)
| # | Tipo | Testo | Condizione numerica | Stato |
|---|---|---|---|---|
| T1 | CONT | Test della banda opposta (obbligatorio) | `d=+1: Low_τ <= L_τ` (tocco, tolleranza 0); τ = PRIMO tocco dopo p, con τ − p <= 30 | FONTE + INTERP (T_max) |
| T2 | CONT | Candela del test NON impulsiva | `TR_τ < 1.5·ATR_{τ−1}` | FONTE (1.5 = definizione di impulsiva nel bulge e nell'invalidazione CONT) |
| T3 | INV | Test della banda dell'impulso | dopo il tocco mediana in r, primo `d=+1: High_τ >= U_τ` con r<τ, τ−p<=30 | FONTE + INTERP |
| T4 | INV | NO contatto precedente con banda opposta | `d=+1: Low_t > L_t` per ogni t in [s, τ) | FONTE |
| T5 | INV | Banda dell'impulso piatta/in compressione | SI se (piatta: `U_τ − U_{τ−3} <= +0.10·ATR_τ` per d=+1) OPPURE (compressione: `W_τ <= W_{τ−3}`) | INTERP ("/" letto come "o") |

### 1.6 CONFERME TECNICHE (5%) — NON bloccanti (peso, non invalidano); riportare come descrittori
| # | Testo | Numerico | Stato |
|---|---|---|---|
| K1 | Dev. std in calo | IN CALO(τ) (§0) | FONTE (Prompt) |
| K2 | Idealmente sotto SMA50 | `sd_τ < S50_τ` | FONTE; "idealmente" = non obbligatorio (INTERP) |
| K3 | SMA50 inclinata a favore | SMA(close,50): `sign(SMA50_τ − SMA50_{τ−5}) = sign(direzione trade)` | INTERP: "SMA50" qui non dice di cosa; leggo SMA50 dei prezzi (la pendenza di S50 non ha "a favore"). Alt: pendenza di S50 |
| K4 | Assenza news ad alto impatto imminenti | NON_MISURABILE: nessun calendario nei dati | Trattamento: escluso da numeratore e denominatore della solidita; riportato come limite. Proxy opzionale (sensibilita, grezzo): saltare entrate nelle 2 ore prima delle 13:30 UTC dei primi venerdi del mese (NFP) — solo se A3 conferma il fuso dei timestamp |

### 1.7 INVALIDAZIONI ASSOLUTE (un solo SI -> scarto). Tipo: C = solo CONT, I = solo INV, CI = entrambi (come nella Checklist)
| # | Tipo | Testo | Numerico | Stato |
|---|---|---|---|---|
| X1 | C | Candela impulsiva > 1.5 ATR durante ritracciamento/test | max TR_t/ATR_{t−1} su (p, τ] > 1.5 | FONTE |
| X2 | I | Candela impulsiva > 1.0 ATR durante rientro/test mediana | max TR_t/ATR_{t−1} su (p, τ] > 1.0 (include la barra del test τ) | FONTE (nota: 1.0, piu stretto di X1 e di A2: vedi §3) |
| X3 | I | Banda inclinata contro la direzione del trade | banda dell'impulso: `U_τ − U_{τ−3} > +0.10·ATR_τ` (d=+1, short) | INTERP (soglia 0.10) |
| X4 | I | Banda si gonfia nel momento del test | `sd_τ >= 1.05 · sd_{τ−1}` | INTERP. Alt: qualsiasi aumento |
| X5 | CI | Ritracciamento disordinato, spike profondi | A4 falso O B1 falso (nessun nuovo criterio inventato) | INTERP; "disordinato" residuo soggettivo = NON_MISURABILE, trattato solo tramite A2-A4/B1 |
| X6 | I | Tocco della banda opposta (inversione) | `d=+1: Low_t <= L_t` per qualche t in [s, τ] | FONTE (= T4) |
| X7 | CI | Dev. std ancora alta/instabile | ALTA: `sd_τ > S50_τ` E NON(2 discese consecutive); INSTABILE: `sd_τ >= 1.10·sd_{τ−2}` | INTERP |

### 1.8 SOLIDITA (%) — calcolo descrittivo, non gate
Validita del setup = CONG ok E BULGE tutti SI E RIENTRO >= 80% E TEST tutti SI E nessuna invalidazione. La solidita non e una soglia di ingresso nelle fonti (lacuna). Proposta: validita = sopra; solidita calcolata come Σ peso × (quota di SI nella sezione): Congestione 25% (CS/CDA valida = 25 pieno), Bulge 25% (tutti SI = 25), Rientro (A+B) 20% × quota, Bande (C) 15% × quota, Test 10% × quota, Conferme 5% × quota. Categoria: >=85 Ottimo, 70-84 Buono, 55-69 Medio, <55 Debole (FONTE). Uso: STRATIFICARE i risultati per categoria e confrontare l'esito reale con la "probabilita associata" (65-75 / 55-65 / 45-55 / <45): e una previsione verificabile dell'autore. Nessun filtro per solidita nelle varianti primarie.

### 1.9 BONUS (non pesati; solo descrittori da stratificare, mai filtri)
| # | Testo | Numerico (INTERP salvo dove indicato) |
|---|---|---|
| A1 | Candela test non impulsiva a inversione (pin bar/doji/piccolo engulfing) | TR_τ <= 1·ATR E (corpo <= 0.3·TR_τ, oppure ombra dal lato del test >= 2·corpo con close nel terzo favorevole, oppure engulfing del corpo precedente con corpo <= 0.75 ATR) |
| A2 | Rigetto pulito | close_τ rientra dentro la banda testata (long: `C_τ > L_τ`; short: `C_τ < U_τ`) |
| A3 | Candela <= 1 ATR | `TR_τ <= ATR_{τ−1}` (FONTE: 1x ATR) |
| B1 | Reazione immediata | NON usa barre future: close_τ nella direzione del trade e nella meta favorevole del range di τ |
| B2 | Test allineato alla micro-inclinazione | banda testata: `|slope 3 barre| <= 0.10 ATR` oppure a favore |
| B3 | Nessuno spike profondo nella candela precedente | ombra di τ−1 < 1.0 ATR |
| C1 | Ritmo costante fino al test | CV(\|ΔC\|) sulle barre di R <= 0.75 |
| C2 | Nessuna impulsiva nelle 3 precedenti | TR/ATR <= 1.5 su τ−3..τ−1 (alt 1.0) |
| C3 | Dev. std in continuo calo fino al test | `sd_t <= sd_{t−1}` per le ultime 5 barre |
| D1 (CONT) | Leggera perdita di inclinazione banda opposta | \|ΔL su (τ−5..τ)\| < \|ΔL su (τ−10..τ−5)\| |
| D2 (CONT) | Micro-range prestabilizzato | range (max H − min L) delle 4 barre prima di τ <= 1.0 ATR |
| D3 (CONT) | Corpo piccolo, spike ordinato | corpo_τ <= 0.40·TR_τ E ombra dal lato del test <= 1.0 ATR |
| E1 (INV) | Banda impulso perfettamente piatta ultime 3 | `|U_τ − U_{τ−3}| <= 0.05·ATR` |
| E2 (INV) | Rientro molto graduale | lunghezza del rientro >= 5 barre E max TR in R <= 0.75 ATR |
| E3 (INV) | Rigetto evidente al retest | close_τ rientra dalla banda E ombra dal lato del test >= 1.5·corpo |
Conteggio: 0-1 valido, 2-3 buono, 4+ superiore (FONTE). Totale bonus possibili: CONT 12, INV 12 (A3+B3+C3+3).

---------------------------------------------------------------------
## 2. Definizione operativa di ingresso, stop, target, uscite

### 2.1 Segnale e ingresso
- Segnale a chiusura della barra τ (test). Tutte le condizioni sopra valutate con dati <= τ.
- INGRESSO (primario, causale): ordine a mercato all'APERTURA della barra τ+1. LONG compra ad `Open_{τ+1} + spread_{τ+1}` (ask), SHORT vende a `Open_{τ+1}` (bid). Lo spread si paga entrando; la chiusura di una posizione short si paga al prezzo ask.
- Direzione: CONT = nella direzione d del bulge (bulge su -> LONG all'ingresso sul test della banda bassa). INV = contro d (bulge su -> SHORT sul retest della banda alta). Fonte: Sintesi (non normativa) + esempi 1-3 (LONG dopo bulge su) e 6, 8 (SHORT dopo bulge su), 7, 10 (LONG dopo bulge giu).
- Variante secondaria: la Sintesi dice "entrata al livello della banda" (ordine limite). Fedele all'autore ma NON causale se le condizioni sulla candela del test si valutano a barra chiusa. Se A4 la implementa: limite al valore della banda di τ−1, riempito solo se il prezzo lo tocca in τ, e senza condizioni sulla chiusura di τ (quindi setup diverso). Raccomando di NON includerla nelle varianti primarie.
- Un solo trade aperto per variante (lacuna delle fonti): segnali durante una posizione aperta ignorati. Alt: contare tutti i segnali (sovrapposti). Riportare entrambi i conteggi.

### 2.2 Stop
- `Stop = Entry ∓ 3·ATR_τ` (ATR 14 Wilder del TF alla chiusura del test, congelato all'ingresso, non trascinato). Fonte: Sintesi ("stop loss = 3 x ATR"). Misurato dal prezzo di ingresso reale. Alt: dal livello della banda testata. La Checklist e il Prompt non parlano di stop.
- Lo stop di uno SHORT scatta quando `High + spread >= stop` (ask). Nella stessa barra/minuto stop e target: vince lo STOP (brief).

### 2.3 Target = mediana, aggiornata ogni 2-3 ore
- Target iniziale = `M_τ` (SMA20 delle chiusure del TF alla chiusura di τ).
- Aggiornamento: la Sintesi dice "aggiornato ogni 2-3 ore"; R003 dice "ricalcolato ogni 3 barre". Su H1 coincidono (3 barre = 3 ore): ogni 3 barre dall'ingresso (τ+3, τ+6, ...) il target diventa la mediana a chiusura di quella barra, valido dalla barra successiva. Su M15 NON coincidono: 3 barre = 45 minuti, 2-3 ore = 8-12 barre. Raccomando letteralmente 12 barre M15 (= 3 ore, fedele alla fonte) come primaria e 3 barre come sensibilita; da decidere a C0/A1 prima di scrivere i criteri (R005).
- Il target e un ordine limite: LONG chiude quando `High_bid >= target` al prezzo target (se l'apertura e gia oltre, all'apertura); SHORT quando `Low_ask <= target`. Se all'aggiornamento il nuovo target e gia "superato" (long con prezzo > mediana), chiusura all'apertura della barra successiva (INTERP). Non esistono trailing, break-even, parziali: Sintesi "se vince chiudere SEMPRE alla mediana".

### 2.4 Uscite (lista completa)
1. Target (mediana aggiornata). 2. Stop 3 ATR. 3. Chiusura forzata: nessuna regola nelle fonti -> INTERP: dopo 48 barre dal segnale (H1 = 2 giorni; M15 = 12 ore) e comunque alla chiusura di mercato del venerdi (ultima barra). Alt: nessun limite. Il numero di uscite forzate va riportato a parte. 4. Nessuna invalidazione in corso di trade (non prevista dalle fonti).

### 2.5 "Tocco della banda" e "deviazione standard in espansione/calo": definizioni vincolanti del Prompt, gia tradotte in §0. Nota di fedelta: il Prompt le definisce "visivamente"; la versione numerica e piu rigorosa (nessun "a occhio") e piu riproducibile, ma NON identica: soglie di accelerazione e "stabile" sono mie.

---------------------------------------------------------------------
## 3. Ambiguita, contraddizioni, lacune delle fonti
**Target e uscite**
1. Target: la Checklist e il Prompt non lo citano. Solo la Sintesi (non normativa, probabile output AI) dice mediana, stop 3 ATR, aggiornamento 2-3 ore. La Checklist dice "CONTINUAZIONE -> deve arrivare alla banda opposta" (e il punto del TEST, non il target): rischio di scambiarlo per target. Negli esempi 1, 2, 3, 6, 7, 8 il marcatore "Target" cade vicino alla mediana (verifica a 200 dpi su Esempi 6 e 8; per gli altri e a bassa risoluzione: DA_VERIFICARE), non a prezzi precisi.
2. Aggiornamento target: "2-3 ore" (Sintesi) vs "ogni 3 barre" (R003): su M15 divergono (vedi §2.3). Su cosa fare se la mediana si sposta oltre il prezzo: non detto.
3. Mai detto: tempo massimo, chiusura forzata, gestione del weekend, un solo trade alla volta, spread massimo, sessione. Nessuna regola di invalidazione a trade aperto.
4. Entrata: "al livello della banda" (Sintesi) vs "a chiusura della candela del test" (implicito nel Prompt/Checklist, che valutano candele chiuse, e nei bonus sulla candela di reazione).

**Direzione e nomenclatura**
5. Direzione del trade mai esplicita nella Checklist. Dedotta: CONT = nella direzione del bulge (LONG dopo bulge su, test banda bassa); INV = contro il bulge. Nomenclatura degli esempi incoerente: "INVERSIONE RIALZISTA" = LONG dopo bulge giu (Ex 7, 10), ma Ex 9 e intitolata "INVERSIONE RIALZISTA" con bulge su (il trade sarebbe SHORT: titolo incoerente); l'indice dell'esempio 9 dice "NON VALIDO", il titolo no; Ex 7, 8, 9, 10 nell'indice non hanno etichetta valido/non valido.
6. Esempio 9: nota "banda inclinata rialzista OK" per un retest di banda alta: per uno short una banda alta in salita e CONTRO il trade (invalidazione X3 della Checklist); i punti 4 e Checklist si contraddicono (il verdetto "non valido" resta, per il mancato test della mediana).

**Numero di bulge (continuazione vs inversione)**
7. Sintesi: CONT = "prima spinta dopo laterale", INV = "2a/3a spinta, trend maturo". Esempi: Ex 1, 3 = 1° bulge (CONT valido); Ex 2 = 2° bulge, CONT VALIDO, ma la sua stessa nota dice che per l'inversione sarebbe stato "ottimo"; Ex 4 = 3° bulge, CONT NON VALIDO "sarebbe stato ottimo per inversione"; Ex 8 = 1° bulge, INV VALIDA ("sarebbe stato ottimo con la 3^"); Ex 10 = 1° bulge, INV "discreto". La Checklist non contiene alcuna regola sul numero di bulge. Il Prompt vieta di introdurre criteri non ufficiali. Contraddizione: Ex 2 vs Ex 4 vs Sintesi. Scelta: n_prev solo come descrittore da stratificare, non filtro (altrimenti Ex 2 e 8 diventerebbero invalidi contro l'etichetta dell'autore). Pre-dichiarare come variante di sensibilita: CONT richiede n_prev <= 1, INV richiede n_prev >= 1 (non primarie).
8. Contesto (laterale / canale concorde / canale opposto) usato negli esempi come criterio ("ottimo per continuazione", "meno per inversione") ma assente dalla Checklist. Incoerente: Ex 7 e INV valido dopo un laterale ("meno per inversione"); Ex 9, 10 laterale -> non validi (ma per altri motivi).
9. Il bulge "debole" negli esempi 4 e 7: Ex 7 e VALIDO con "bulge debole... accettabile", contro la Checklist ("tutti SI, se uno NO invalido") e il Prompt ("nessuna compensazione"). Ex 4 e scartato anche per bulge debole.

**Soglie interne e pesi**
10. "Candela impulsiva": >= 1.5 ATR (bulge, X1, A2, CDA4), > 1.0 ATR (X2, solo INV), <= 1 ATR (bonus). Il bulge dice "1.5-3x" senza dire se oltre 3 e peggio. Quale ATR (barra corrente o precedente?) non detto.
11. Sezioni a peso ma solidita non definita: la Checklist ha 7 sezioni, il modello 6 pesi. "Comportamento delle bande" (15%) non ha tabella propria: le sue righe stanno dentro "Ritracciamento" (20%). Il credito parziale (es. rientro 7/10) non e specificato. Congestione CS 4/5 vale pieno 25%? Soglia minima di solidita per operare: NON detta. Il Prompt dice "se un solo criterio obbligatorio e NO -> non valido", la Checklist ammette 80% nel rientro: quali sono "obbligatori"? Le probabilita (45-75%) non dicono rispetto a quale target/stop.
12. "Ombre <= 1.5x corpo" per candela e indefinito su doji, e il bonus premia doji/pin bar: contraddizione.
13. "Micro-rotazioni accettate" (B3) e implicata da A2 e B1: criterio ridondante. "La banda opposta non richiede compressione" non e un criterio testabile. "Banda del test piatta" compare sia nel rientro (C) sia nel test (T5): doppio conteggio.
14. Deviazione standard: "in calo" e vero anche sotto SMA50 a prescindere dalla direzione; "in espansione" e "in calo" possono essere veri insieme; la Checklist usa "sd in calo" come conferma e "sd ancora alta/instabile" come invalidazione: sovrapposizione non risolta. "SMA50 inclinata a favore": SMA50 di cosa? (prezzo vs sd).
15. "Dev. std in calo costante >= 10-15 candele" (CDA1): se letta in senso stretto la CDA e quasi inesistente.
16. Finestre non date: lunghezza della congestione (esempi: ~40-60 barre H1), distanza massima bulge-test, definizione di inizio impulso, quante barre minime per il rientro.
17. Timeframe: tutti gli esempi sono EURUSD H1 (TradingView, feed FXCM, repliche di marzo-agosto 2025). Nessuna fonte dice che valga su M15 o sull'oro. Il PDF e datato 23/12/2025: esempi scelti a posteriori dall'autore, con follow-up SOLO per i validi (nessuna informazione sugli esiti dei non validi): bias di selezione. I grafici NON mostrano il pannello Standard Deviation/SMA50 introdotto dal Comunicato: i criteri sulla sd non sono verificabili visivamente negli esempi.
18. Il testo della Checklist ha artefatti di estrazione (stringhe "0216535", "020000" e la Nota tecnica duplicata): innocui, ma indicano che il documento e stato incollato da PDF.

**Cosa serve dalla Guida Operativa 11 (MANCA, fonte normativa primaria)**
(i) definizione di congestione/finestra e di CDA-vs-CS; (ii) regola sul numero di bulge e quando e CONT/INV; (iii) ingresso, stop, target, gestione, uscite (la Sintesi AI e l'unica fonte oggi); (iv) timeframe/strumenti ammessi; (v) parametri esatti degli indicatori (BB, StdDev, ATR, lunghezze); (vi) soglia minima di solidita per operare e significato delle probabilita; (vii) gestione news e sessioni; (viii) cosa sono Dichiarazione di Test e screenshot standard; (ix) tempo massimo del test. Fino ad allora ogni risposta e "regole della Checklist + mie interpretazioni", non "la strategia di Bardolla".

---------------------------------------------------------------------
## 4. Lettura qualitativa dei 10 esempi (R010) — su immagini a bassa risoluzione, senza dati OHLC: sono giudizi di A2, non misure
Cosa si vede sempre: bande, mediana, candele, ATR(14) come numero in basso a sinistra, nota dell'autore. NON si vede: pannello sd/SMA50, ATR per barra, spread. Quindi i criteri su sd e sull'ATR relativo si giudicano solo "a occhio".
| Ex | Etichetta autore | Cosa dice la mia specifica (ipotesi) | Coincide? | Verificabile visivamente |
|---|---|---|---|---|
| 1 | CONT VALIDO (bulge su dopo canale ribassista lungo) | Valido: CDA/CS plausibile, bulge forte (bande molto aperte), rientro con candele piu piccole verso la banda bassa, tocco finale | SI (probabile; sd non verificabile) | canale, apertura bande, tocco, taglia candele; no sd |
| 2 | CONT VALIDO (2° bulge, trend su) | Valido SENZA filtro sul numero di bulge; con filtro "CONT = prima spinta" sarebbe invalido | SI solo se n_prev non e un criterio | tocco/rientro/dimensioni; doji-pin sul livello |
| 3 | CONT VALIDO (1° bulge, canale ribassista) | Valido: bulge molto ampio, rientro ordinato | SI (probabile) | si (bande enormi, candela del bulge) |
| 4 | CONT NON VALIDO (3° bulge debole) | Non valido: A1 falsa (candele del rientro simili a quelle dell'impulso), B1 del bulge debole; congestione dubbia | SI | taglia relativa delle candele; non il conteggio |
| 5 | CONT NON VALIDO (test in fase laterale) | Non valido: B2c falsa (ER basso, il rientro e un nuovo laterale) e/o T_max superato | SI, ma dipende dalla mia T_max e da ER (INTERP) | forma del rientro (laterale vs diretto) |
| 6 | INV VALIDO (bulge su dopo canale rialzista) | Probabile valido: tocco mediana, nessun tocco banda bassa, retest banda alta con banda in discesa. Rischio: la candela del retest sembra larga (ombra lunga) -> X2 (> 1.0 ATR) potrebbe scattare | SI incerto (RISCHIO DIVERGENZA) | si: nessun tocco banda opposta, pendenza banda; taglia candela solo a occhio |
| 7 | INV (rialzista) VALIDO (bulge giu dopo laterale) | Il bulge e dichiarato "debole" dall'autore; con B3 (barra >= 1.5 ATR) potrebbe risultare falso -> la mia specifica potrebbe scartarlo | INCERTO (RISCHIO DIVERGENZA); contesto "meno per inversione" | rientro su mediana, retest, banda piatta/rialzista |
| 8 | INV (ribassista) VALIDA (1° bulge dopo canale rialzista) | Valida senza filtro sul numero di bulge; con filtro INV >= 2° sarebbe invalida | SI solo se n_prev non e un criterio | rientro su mediana, retest, banda a 3 barre |
| 9 | INV NON VALIDO (mediana non testata) | Non valido: B2i/T3 falsi (mediana non toccata). Anche X3 (banda in salita contro lo short) | SI (doppio motivo) | si: mancato tocco mediana e immediato |
| 10 | INV (rialzista) NON VALIDO (candela retest ampia) | Non valido: X2 (TR di τ > 1.0 ATR) e X4 (sd in rialzo) | SI | si: candela del retest vs candele dell'impulso (relativa) |
Sintesi: attese 8/10 coincidenze piene, 2/10 a rischio (Ex 6 e 7), e Ex 2 e 8 coincidono SOLO se il numero di bulge non e un criterio. Il PDF non permette di calcolare nulla: non e una verifica delle soglie, e un controllo di sanita. Un cambio di soglia per far tornare gli esempi sarebbe sovradattamento (R007).

---------------------------------------------------------------------
## 5. Selettivita attesa su H1 oro (IPOTESI, NON misurata; da confrontare con l'imbuto di A4)
Ragionamento: ~5.800-6.000 barre H1/anno (oro ~23h x ~255 giorni). Imbuto ipotizzato (probabilita condizionata a ogni stadio, tutte stime mie):
1. Barre con TR >= 1.5 ATR in direzione netta: ~3-5% -> ~200-300/anno (eventi correlati, cluster).
2. Bulge completo (6 criteri, W >= 2x congestione, ER >= 0.5): ~10-25% di quelli -> ~30-70 eventi/anno (cluster -> 15-40 indipendenti).
3. Congestione valida (CS >= 4/5 o CDA stretta) prima del bulge: ~25-40% -> ~8-20/anno.
4. Test raggiunto entro 30 barre con rientro >= 80% e nessuna invalidazione: CONT ~15-30%, INV ~10-25% (la sd ancora alta al test X7 e il filtro piu duro).
Previsione (H1): CONTINUAZIONE ~2-8 setup/anno (mediana ~4), INVERSIONE ~1-6/anno (mediana ~3). Se i file coprono ~4,8 anni in tutto (DA_VERIFICARE da A3): ~10-40 trade CONT e ~5-30 INV su H1 in totale. M15: barre x4 ma struttura meno pulita: ~3-5x piu eventi (~10-40/anno per variante).
Probabilita che il campione H1 per variante sia < 30 trade in tutto: ~60%; < 100: ~95%. Conseguenza: con n~20-30 e win rate ~60%, l'errore standard e ~9-11 punti: un profit factor non sara distinguibile da 1 salvo effetto molto grande. Raccomando di dichiarare PRIMA (R005) una soglia di campione minima sotto la quale il verdetto e "INCONCLUSIVO", e che A4 riporti l'imbuto stadio per stadio.
Fattori che cambierebbero molto la stima: CDA1 in senso stretto (-), T_max (+/−), tolleranze di piattezza 0.10 ATR (+/−), X7 (−), uso di sd ddof 0/1 (irrilevante).
Nota per A3/A5 (geometria, non verificata): con stop 3 ATR e target = mediana a distanza T ATR dal test, il win rate di pareggio e p = (3 + c)/(3 + T), con c = costo (spread) in ATR; con c~0 e T = 1.5 / 2 / 2.5 ATR il pareggio e ~67% / 60% / 55%. Le probabilita dell'autore (Ottimo 65-75%, Buono 55-65%, Medio 45-55%) sarebbero quindi vicine o sotto il pareggio per T piccolo. IPOTESI: da verificare con i numeri di A3.

---------------------------------------------------------------------
## 6. Cosa e MISURABILE e cosa no (riassunto per R001)
- Misurabile con soglia dal testo: CDA2, CDA3 (15%), CDA4, B2 (def. Prompt), B3 (1.5), B6 (20 barre), A1 (30%), A2, X1 (1.5), X2 (1.0), T2, X6, tocco/espansione/calo (Prompt), bonus A3, punteggi/categorie.
- Misurabile ma con mia soglia (INTERP, con alternativa): tutto il resto della congestione CS, B1, B4, B5, A3, A4, B1 del rientro, B2c, C1-C3, T5, X3, X4, X7, conferme K1-K3, bonus (tranne A3), T_max, n_prev, ctx.
- NON_MISURABILE: K4 (news: assenza di calendario; trattamento: escluso e dichiarato; proxy opzionale NFP), "disordinato/ordinato/di scarico" oltre le proxy sopra (soggettivo residuo), "rigetto evidente"/"ritmo costante" (solo proxy), qualunque giudizio "somiglianza con gli esempi".
- Non usabile affatto: Guida Operativa 11, Dichiarazione di Test, screenshot standard (mancano).
