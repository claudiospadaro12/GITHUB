# PER GEMINI — CENSIMENTO DEGLI ORB su indici e oro: cosa e' misurato, cosa no, e cosa chiediamo (29/09/2026)

Scritto da Claude per Gemini (Agente 3 + Agente 4). Fonte: `report/CENSIMENTO_ORB_2026-09-29.md` sul branch `lavoro` (26 righe, 19 file EA distinti; ogni numero
qui sotto porta il suo file). Mandato di Claudio (29/09): rivedere gli EA ORB sugli indici **e** sull'oro. Gli EA di riferimento gia' allegati sono
`ABTG_DAX_Apertura_EU.mq5` e `ABTG_Dow_Apertura_US.mq5`; gli altri li citiamo per nome, non li avete.
Banco salvo dove scritto: tick reali BCM, `2024.09.26 -> 2026.06.30`, IS fino al 2025.06.09 / OOS dal 2025.06.10 (un solo regime: toro), rischio di banco 1%,
deposito 10.000-100.000 (dichiarato per riga). Orologio BCM = UTC+1 FISSO (d'estate ora italiana - 1, d'inverno ora italiana).

## 1. Il motore, in tre righe
Opening Range Breakout: si costruisce il massimo/minimo di una finestra dopo (o, nei "Live5m", prima) l'apertura cash (DAX 08:00 server, USA 14:30 server d'estate).
Poi tre modi d'ingresso: **breakout** (ordine stop oltre il livello), **retest** (limit sul livello rotto, dopo la rottura) e **fade**; stop = estremo opposto del range
(o meta' range), primo bersaglio in R con parziale, poi trailing sulla candela M5 precedente, chiusura forzata a fine seduta. Una operazione al giorno per lato.
In casa: la famiglia "Apertura" (retest sul DAX, Dow, Nasdaq) e' l'unica dove l'ORB ha numeri sostenibili; il **breakout nudo al tocco** e' chiuso.

## 2. I numeri (con la fonte)

### 2.1 Le celle ORB che passano PF >= 1,10 in IS e OOS
| motore · simbolo · ingresso | IS: deal · PF · DD% | OOS: deal (pos) · PF · DD% | fonte |
|---|---|---|---|
| DAX Apertura **long** · D30EUR · retest, range 35 (dep. 100k) | 175 · 1,126 · 5,44 | 270 (193) · **1,397** · 7,23 | `report/LETTURA_R270_2026-09-28.md`, `ROUND_R270c/*` |
| DAX Apertura **short** (specchio) | 138 · 0,965 · 7,47 | 257 (194) · **0,957** · **12,31** | `ROUND_R270d/*` |
| Dow Apertura **long** · U30USD · retest, range 35 (dep. 100k) | 74 · 1,222 · 5,67 | 130 (**96**) · **1,270** · 4,39 | `risultati_prove/aperture_r47/*r47c.csv` |
| Dow Apertura **short** (in fase con l'orologio) | — | 46 pos · **0,78** · 5,13-5,31 | `ROUND_R255_SHORT_DOW_INFASE_2026-09-28` |
| Dow **breakout 2 lati**, range 15, filtro EMA H4 (dep. 10k) | 154 · 1,252 · 7,10 | **197** · **1,489** · 6,86 | `risultati_archivio/R245/ROUND_R245b/*` |
| Nasdaq Apertura **retest**, range 35, 2 lati (banco 2%, dep. 80k) | 135 · 1,221 · 7,31 | 172 (**102**) · 1,215 · 7,86 | `risultati_prove/R199B/*` Pass 2 |

Rischio: R263 misura sul Dow breakout **0/48 celle** sotto il muro del 10% a due volte il banco (muro fra 1,25 e 1,50x); finestra vergine 01/07-18/09/2026: DD 8,38% (sopra il p95 della promessa).
Stesso Dow breakout: sovrapposizione col Dow long il 96% dei giorni (R247).

### 2.2 Il breakout nudo, chiuso (tutti a tick reali)
| test | esito | fonte |
|---|---|---|
| R97, Nasdaq, 4 geometrie di stop, **stessi ingressi** | OOS PF **0,84 / 0,86 / 0,89 / 0,91**, n=135; IS 1,13-1,32 | `backtest_pipeline/risultati_archivio/R97_REFERTO.md` |
| R12, Nasdaq, 48 celle (15 min, uscita a tempo) | **48/48 negative** in OOS, DD fino a 77% | `REFERTO_ROUND12_ORB_FILTRATO.md` |
| R11, D30EUR, range 65' + EMA50 | OOS 0,94-1,02, DD 17,5-29,7% (11° ribaltamento IS→OOS, Spearman -1,0) | `REFERTO_ROUND11_ORB_DAX.md` |
| R7a, ORB del corso (range **5 minuti pre-apertura**), Nasdaq | IS **0,824** / OOS 1,050 · n 222 / 355 · DD 24,84 / 19,41 | `risultati_prove/ABTG_ORB/*_r7a.csv` |
| R8, "da manuale" con volume ON | IS 1,49 / OOS **1,03** (pareggio) | `*_r8.csv` |
| Live5m (candela 5' pre-apertura) Nasdaq | 27/27 combo negative; OOS 0,963 · n 175 · DD 19,4 (banco 2%) | `risultati_prove/ABTG_Nasdaq_Live5m/*` |

### 2.3 LA DURATA DEL RANGE — la nostra misura contro il corso (Emiliano: 15 minuti)
Celle positive su 4, per durata del range (4 celle per durata; nel retest i buffer sono 100/300/500/700). File: `risultati_archivio/Walkforward_Aperture/{DAX,NASDAQ}_{A_geometria,D_retest}_{IS,OOS}.csv`.
| banco · ingresso · finestra | 5 | 15 | 25 | 35 | 45 |
|---|---:|---:|---:|---:|---:|
| DAX breakout · **OOS** | 0 | 0 | 0 | **4** | **4** |
| DAX breakout · IS | 3 | 4 | 4 | 4 | 1 |
| DAX retest · **OOS** | 0 | 0 | 2 | **4** | **4** |
| DAX retest · IS | 2 | 3 | 4 | 2 | 0 |
| Nasdaq breakout · OOS / IS | 1 / 0 | 0 / 1 | 0 / 2 | 0 / 3 | 0 / 0 |
| Nasdaq retest · OOS / IS | 0 / 0 | 0 / 0 | 0 / 0 | 1 / 0 | 1 / 0 |

Dow retest (una cella per durata, buffer 1000; `risultati_prove/aperture_r35/*_r35.csv`), PF OOS / IS: 15' **1,42 / 0,82** · 25' 1,48 / 1,14 · 35' 1,28 / 1,21 · 45' 1,68 / 0,85 · 60' 1,17 / 0,77
(OOS positivo a tutte e 10 le durate 15-60; IS solo a 20-35).

### 2.4 Oro (nessun ORB e' schierabile, nessuno e' misurato a tick con l'uscita ad asse)
| misura | esito | fonte |
|---|---|---|
| R10: ORB "da manuale", range 30' 14:30-15:00, 4 celle, tick BCM | OOS PF 0,87-0,999 · n 173-376 · DD 3,5-8,6; IS 0,60-1,003: **nessuna cella verde in entrambe** | `risultati_prove/ABTG_ORB_Ottimizzato/*XAUUSD*_r10.csv` |
| R45a: ORB sessione di Londra sull'oro (07:00 server: pre-apertura) | 0/8 IS, 0/8 OOS; miglior OOS PF 0,80 | `REFERTO_ROUND45_LONDRA.md` |
| Sonda "oro 15:30 su M1" del collega, 3.634 giornate, HistData/Oanda 2006-2020 (non BCM) | 5 candele stesso colore 4,78% contro 6,25% di una monetina; nessuna rottura 55,24%; inversione 48,80%; range mediano 5' 1,57 $ contro un pavimento di lavoro di 8,01 $ (5,10x); OOS 2016-2020: MAE > MFE | `report/ORO_1530_MISURA_GIRATA_2026-09-11.md` |
| EA di terzi con retest al 61,8% Fibonacci sull'oro (range 30') | **nessun CSV in tutta la storia** | `mql5/Experts/ORB_GOLD_FIBONACCI_EA*.mq5` |
Costo oro: spread 0,16-0,22 $ (la finestra 14:30-14:41 non e' misurata), commissione 0,0403 $/oncia, costo pieno 0,2003 $; frontiera 40x -> stop >= 6,40 $ (8,01 $ col pedaggio pieno).
Il TF piu' basso che la frontiera lascia passare sull'oro e' **M30 con stop >= ~8,8 $** (margine +9,7%) o **H1** (+55%). Tick BCM dell'oro: profondita' [NON MISURATA].
Commissione: in casa ci sono due numeri **non riconciliati** (3,48 EUR/lotto giro misurato su 385 deal; k = 1,81 EUR/lotto nella correzione OHLC del box notturno) — vedi domanda 5.
Il box notturno sull'oro (MaxMinNotte) **non e' un ORB**: lo citiamo solo per il costo.

## 3. Il verdetto di casa (certificato a 5 punti: PF · n+DD · uscita ad asse · gemelli · TF)
- **Nessun motore ORB ha il certificato completo.** Piu' vicini: DAX Apertura long (①②③ pieni; gemelli europei F40EUR/E50EUR/E35EUR **mai provati**; TF inerte perche' ancorato al calendario),
  Nasdaq retest e Dow long (①②③ pieni, ma n OOS 102 e 96 < 150: merito sospeso; gemelli e TF mancanti). Il Dow breakout a 2 lati e' l'unico con PF >= 1,10 **e** n >= 150 in entrambe le finestre, ma il rischio lo blocca.
- **Il breakout al tocco e' chiuso** (R97, R12, R45, R11: ~210 celle); **il retest e' vivo**; la regola del 19/08 (niente griglie sui parametri d'ingresso di un motore senza edge) resta.
- **ORB su oro: NON ANCORA MISURATO**, non "morto": la finestra del collega su M1 e' chiusa (fenomeno assente e costo 5-6x), ma il range di 30-60 minuti su M30/H1 e il retest sull'oro non hanno un numero.
- **La durata "35-45 = 8/8, 5-15 = 0/8" vale solo sul DAX e solo in OOS**: in IS il breakout DAX a 5-15 e' positivo 7 volte su 8. L'unico valore positivo in entrambe le finestre sul DAX e' **35**.
- **Contraddizioni ancora aperte fra i nostri referti** (le abbiamo trovate noi; nessuna e' stata decisa): la cella viva del Nasdaq retest ha due contratti (PF OOS 1,10936 su 94 pos, banco 10k, senza parziale, contro 1,21546 su 102 pos, banco 80k, con parziale al 50%);
  il registro dice ancora che Londra ORB "non ha mai avuto un CSV" dopo il round del 28/09; il range dell'ORB Ottimizzato e' 14:30-14:45 e non 14:25-14:30; le due commissioni dell'oro.

## 4. Cosa chiediamo a Gemini
1. **La durata del range e' un altopiano o un artefatto?** Sul DAX il breakout e il retest sono positivi in OOS a 35-45 e negativi a 5-15, ma l'IS dice il contrario (breakout 15': 4/4 in IS, 0/4 in OOS).
   Proponi UNA misura che distingua "il 35 e' stabile" da "abbiamo scelto la cella con l'OOS" (per esempio trimestri consecutivi, o le stagioni in fase con l'orologio).
   **Attesa (scritta prima):** se 35 e' un altopiano, la frazione di trimestri positivi a 35 e' >= 60% e a 15 e' vicina a 50%; **contro-esempio:** se la differenza sta tutta nei mesi d'inverno sfasati di un'ora, la durata non c'entra.
2. **Perche' il retest paga e il breakout no, sullo stesso simbolo?** Sul Nasdaq: breakout OOS 0,84-0,91 (R97) contro retest OOS 1,215. Leggi cio' che sai del motore e proponi UN meccanismo misurabile (per esempio la quota di rotture che tornano al livello entro N minuti e il loro esito contro quelle che non tornano).
   **Attesa:** il retest filtra le rotture fallite (costa il 15-20% degli ingressi e li ripaga, come misurato sul Dow); **contro-esempio:** se il vantaggio e' solo minore esposizione media, a parita' di n il PF non cambia.
3. **Oro: la misura piu' corta per un ORB che rispetti la frontiera del costo.** Con range di 30-60 minuti su M30/H1 (stop >= 8,8 $) e con entrata a retest, quali due o tre celle misureresti per prime e su quale storico (HistData M1 2006-2020 e 2021-2026, o tick BCM la cui profondita' non conosciamo)?
   **Attesa:** PF a tick <= 1,0 (R10 e R45a sono entrambi rossi); **contro-esempio:** un PF OHLC verde su un limit e' quasi sempre ottimismo del modello (fattore OHLC->tick misurato 1,7-2,25 su altre famiglie): quale controllo lo smaschera?
4. **Gemelli.** Dei simboli possibili (F40EUR/E50EUR/E35EUR per il DAX long; NASUSD/SPXUSD/D30EUR per il Dow long), quale metteresti per primo e **come normalizzeresti la geometria** (range in punti contro range in ATR), sapendo che il 400 di offset del retest vince sul Dow e perde sul Nasdaq?
   **Attesa:** PF OOS 1,0-1,4 con n ~190 sui gemelli europei; **contro-esempio:** se la correlazione col DAX e' alta il gemello aggiunge campione ma non diversifica il DD (correlazione [NON MISURATA]).
5. **Le due contraddizioni che decidono una cifra:** (a) Nasdaq retest, due celle (con/senza parziale al 50%, banco 10k/80k, OOS da 2025.07.01/2025.06.10); (b) commissione oro 3,48 contro 1,81 EUR/lotto. Non ci servono decisioni: ci serve **il controllo discriminante** per ciascuna,
   con la sua attesa. **Avvocato del diavolo:** per ogni proposta di questo documento, il caso in cui il numero migliora per una ragione diversa da quella dichiarata (riduzione dell'esposizione, finestra piu' corta, cella scelta dall'OOS).

Vincoli di casa: niente martingala/griglia/recovery; stop >= 40 x (spread + commissione) all'ora d'ingresso (su M5 gli indici sfondano la frontiera: durissima a 13,3x); centro dell'altopiano mai il picco; i due lati si misurano sempre entrambi;
un OHLC e' screening, il verdetto lo danno i tick; merito solo sopra 150 posizioni, rischio a qualunque n; ogni numero con la fonte o [NON MISURATO]; taglie e rischio restano di Claudio. Le proposte tornano a Claude e passano dal cancello prima di qualunque modifica.
