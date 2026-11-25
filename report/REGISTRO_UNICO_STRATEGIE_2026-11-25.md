# Registro unico delle strategie di Claudio (25/11/2026)
Compilato dai file gia nel repository: `backtest_pipeline/REGISTRO_TEST.md` (regole di Emiliano da 18 live aprile-maggio, di Paolo e di Marco; test 2024-26), `CLASSIFICA_PF.md`, `report/CATALOGO_ABTG_FAMIGLIE_E_PARERE_2026-11-18.md`, `CORSO_FOREX_REGOLE_STRATEGIE_2026-11-19.md`, `LEZIONI_LIVE_EMILIANO_PAOLO_2026-11-18/-23.md`, `ORB_EMILIANO_WEBINAR_REGOLE_2026-11-20.md`, i referti dei test 20-24/11 e il piano personale di Claudio (luglio 2026). **Non ho riletto le trascrizioni originali: dove la regola e vaga o assente e scritto "MANCA".** Orari: ora italiana (server BCM = ora italiana in inverno, un'ora indietro in estate). Nessun consiglio su taglie.
**Legenda stato:** CHIUSO = misurato senza vantaggio; NON PROVATO = regola esistente, mai misurata fuori campione; PICCOLO = campione forward troppo piccolo.

## A. Apertura e notte (Emiliano, Paolo)
| # | Strategia | Regola esplicita | Cosa MANCA o e ambiguo | Misure nostre | Stato |
|---|---|---|---|---|---|
| 1 | **ORB DAX** (09:00-10:00) | Range = prima candela M15 09:00-09:15; si opera dalle 09:15; ingresso alla rottura SOLO se il corpo chiude fuori dal range, volumi >= 1,5x media 20, medie 9/21 inclinate nel verso; se apre lontano, entra sul RETEST. Direzione dal Daily (max/min crescenti, ultime 3 candele) e correlazione S&P H1. Stop ~40 punti sotto media/Supertrend/minimo; RR 1:1-1:2; parziale 50% dopo 20-30 punti + stop a pari; blackout 09:00 BCE/11:00/14:30; mai overnight | Buffer esatto (7 punti? ATR?), filtro ampiezza, soglia "volumi" per lo spot, regola del retest (Paolo: seconda candela M5 di conferma, stop un po fuori dalla linea) | `DAX_Apertura_EU` solo LONG PF 1,49 (314 op, tick reali 2024-26, ottimizzato sullo stesso periodo); **forward demo 24 op PF 0,24 (-659 EUR)**; ORB del Toolkit su 4 mercati t fino a -6; max-min DAX con fill realistico 0/16; ORB+Fibo del webinar 6 celle senza vantaggio; filtri volumi/correlazione non migliorano (PF 1,21-1,24) | **Vantaggio NON dimostrato** |
| 2 | **ORB USA / Nasdaq** (15:30-16:00) | ORB 5 min sull'oro 15:30, mercati USA dalle 15:45 (range 15'); stesse conferme di (1); Paolo: bot pre-market con box M1 a 15:30, due ordini a 5 punti, Dow TP pieno, Nasdaq 50% | Range e regole di ingresso/stop/target USA NON specificati nelle live; Paolo non mostra il backtest | `Nasdaq_Apertura_US` PF 0,91; ORB M5 PF 1,15 (marginale); Nasdaq M3 0/20 set; **forward +250 (21 op) e ORB +352 (20 op), ORB OTT Dow -283 (13 op)** | **CHIUSO nei test, forward PICCOLO** |
| 3 | **Max/min della notte** (08:00-09:00) | Ordini pendenti a 3 pip (forex) o 10 punti (indici) oltre max/min della notte; GBPUSD "il migliore"; stop oltre il livello, se lontano a meta canale | **Breakout o fade?** (18/11 ambiguo, 23/11: breakout nella direzione weekly+daily). Ore della "notte", target, uscita, validita ordini: MANCANO | Forex H1 breakout 0/16 celle (24/11), filtro weekly+daily PEGGIORA il lordo; `MaxMinNotte` DAX SHORT con correlazione S&P PF 2,05 (41 op, 2024-26) ma fill realistico 0/16 e forward 8 op +168; **fade: NON provato** | **Breakout CHIUSO, fade NON PROVATO** |
| 4 | **Strategia dei 5 minuti** (15:25-15:29:59) | Ordini pendenti alle 15:29:59 su Nasdaq "per sfruttare un'inefficienza", anche "senza stop, con triplo ordine" | Quasi tutto; in contraddizione con "stop sempre" | nessuna | **NON PROVATA, regola vaga** |
| 5 | **Direzione weekly + daily concordi** (Emiliano 23/11) | ++ solo long, -- solo short, discordi fermo; contesto: ultime 3 weekly con max/min crescenti o decrescenti | Se usa la candela chiusa o in corso; "forza" | Provata come filtro sulla notte forex: peggiora il lordo (0,85-0,93 contro 1,0) | Non utile in quel contesto |

## B. Breaking Band e Bulge (Leonardo, Massimo)
| 6 | **Breaking Band v4 / v4.2** | Bollinger 20/2, bulge = tocco banda; 1a e 2a nella stessa direzione = CONTINUAZIONE, entry limit al livello SALVATO della banda opposta; 3a = INVERSIONE (mediana, poi ritorno alla banda); SL 3 ATR, TP mediana, BE a +1 ATR, timeout 40 barre | Come classifica Claudio i bulge (sufficiente/buono/ottimo) e quando entra "con l'occhio" | v4 tester 2013-24: R medio -0,05 (H1) / -0,09 (M30); filtri Leonardo nessuno regge; **v4.2 replica Python 6.967 op PF 0,87-0,95** (anche ottimistica 1,01/0,97); Bulge motore corretto PF 0,83 (2.300-3.200 op), forward Bulge -2.599 (699 op) | **CHIUSO come EA; resta come avviso e allenamento** |

## C. Corso forex (106 lezioni)
| 7 | **Post News** | 2 ordini pendenti sulla candela della conferenza stampa BCE e FOMC; dichiarato +20%/anno a rischio 3%, 2009-2024, un solo anno negativo (16 op/anno) | Distanza degli ordini, stop, target, uscita, filtri | **`ABTG_PostNews` esiste ma non e MAI stato misurato**; date BCE/FOMC nel nostro calendario (2013+) | **NON PROVATO, scorrelato dal resto** |
| 8 | **Easy Trend** (EURUSD H1) | Divergenza CCI; prima candela che taglia il plot 8-18, stesso colore; 3 candele precedenti sotto la media; ingresso alla chiusura | Impostazioni CCI e "plot" | forward -297 (28 op); fuori campione mai misurato | NON PROVATO (forward negativo) |
| 9 | **Fibo H4** | Fine trend + candela inghiottita; Fibonacci max-min; entry zone 1,88 e 2,88; distanza 50-60 pip; non in laterale | Definizione di "fine trend" | `FiboH4_Multi` esiste, **mai misurato fuori campione** | NON PROVATO |
| 10 | **Media 200** | Ordini limite vicino alla EMA200 (50-70 pip), conferma H1, TP EMA14/2 ATR, meta posizione e BE | Cross H4/D1: nessun numero dichiarato | EMA200 oro 2015-23 PF 0,80; forward PF 0,97 (30 op), Dow 0,68; **cross forex mai provati** | Oro CHIUSO; forex NON PROVATO |
| 11 | **Mediazione** (EURUSD, GBPUSD, EURGBP H1) | Williams %R 140 + Supertrend; 6 livelli | **Foglio Excel proprietario non nelle trascrizioni** | non riproducibile | NON TESTABILE |
| 12 | **Breakout corso** (cross JPY + oro, M15) | Rettangolo 20 candele M15, Williams %R 140, Supertrend, TP 3R | -- | 16 passate PF 0,63-0,95 | **CHIUSO** |
| 13 | **PTE / WOL** | Doji, canali, fine trend EMA200 | Canali per coppia (serve `Setting_canali_PTE.pdf`) | PF IS 0,76 / 0,66, sette varianti senza candidati; HAM PF 0,48-0,80 | **CHIUSO** |

## D. Nostri (non di Emiliano)
| 14 | **GoldenZoe** (oro H4 solo long) | Canale 55, stop 3 ATR, Chandelier | -- | Simulato 12 anni; pronto per forward demo (PROP/MEDIO/ALTO) | **Candidato della flotta** |
| 15 | **Supertrend Reversal / SuperWave** (10 dei 14 "Ottimizzati": oro, DAX, Dow, CAC, Nasdaq) | Rimbalzo sul Supertrend H1/H4 | -- | Oro fuori campione 2015-23 PF 0,80-1,10 (**0 su 4**); indici valutati solo 2024-26 (stesso periodo dell'ottimizzazione, **nessun fuori campione: Dow, DAX, CAC non hanno storico prima del 2024 su BCM**); forward oro STREV 0/10, SuperWave Dow H1 +541 (23 op) | **Un solo motore in molte copie; non verificato** |
| 16 | **Dow volatility M15** (set `g` di Wim) | -- | -- | PF 2,0 su 22 mesi (113 op); i 7 anni non verificati (feed FTMO scaduto) | Misura di riferimento, fuori dalla flotta |

## E. Idee discusse e mai provate
- **Russell/Dow pomeriggio, mean reversion** (Marco): aprono sotto la media, 2-3 candele M5 forti, poi tornano al livello pre-apertura; Russell non e quotato su BCM. **NON PROVATA.**
- **Canale notturno 21-22, rottura della mediana M5** (Marco): "buono per conto personale, non per prop". NON PROVATO.
- **Tonino, cicli**: target = minimo H4 + 2 ATR(14) H4 + 13%; indicatore non fornito.
- **Piano personale di Claudio (luglio):** discrezionale solo con Fibo H4 + Supertrend(3) + media 200 su H4 o retest dopo rottura ORB, solo setup A/A+, nessun oro "a naso", nessun trade dopo le news.

## F. Cosa resta da fare, in ordine di valore
1. **Post News** (7): strategia scorrelata dalle altre e mai misurata; calendario e dati forex gia disponibili. Test con criteri scritti prima.
2. **Fibo H4 e Media 200 sui cross forex H4** (9, 10): il corso li usa sui cross, noi li abbiamo provati su oro/indici.
3. **Fade del max/min della notte** (3): l'altra lettura della live del 18/11.
4. **Storico degli indici prima del 2024** per verificare davvero i nostri EA (15): senza quello restano non verificati.
5. **Domande per Emiliano e Paolo** (le regole che MANCANO nella colonna 4): buffer ORB, retest, range USA, "notte", target e uscita, canali PTE, foglio della Mediazione.
