# Mappa dei LATI (long / short) delle sedie di apertura e dello storico ampio sugli indici (23/10/2026)

**Natura: LETTURA. Nessun test nuovo, nessun numero nuovo, nessun file di EA, preset o conto toccato da questa mappa.** Richiesta di Claudio: *"ricontrollare tutti gli EA sulle aperture con lo storico piu' ampio sugli indici, esaminando i lati long e soprattutto gli short"* (+ *"dobbiamo fare ORB anche con Dow Jones: Emiliano dice che e' meglio di DAX"*).
Metodo: sala del consiglio, **7 sottoagenti reali** in sola lettura (DAX, Dow, Nasdaq, ORB+MaxMin short, storico esterno, ORB Dow contro DAX con le parole di Emiliano, avvocato del diavolo sul piano). **Ricontrollati da me alla fonte**: ORB short R54b (PF 0,681/0,520, DD 26,37%), Dow short R54a (1,511/0,840), DAX short R107 (0,965/0,957), Dow orologio (0,916 alla cash d'inverno, 1,492 un'ora prima). Tutto il resto e' **[DICHIARATO DA AGENTE]**: un agente che legge un file non e' una conferma indipendente della fonte. Convenzione: PF IS/OOS; T = tick reali, B = OHLC; deal e posizioni non sempre separati dalle fonti.

## 1. La mappa per lato (misurato)
| Sedia | LONG | SHORT | DUE LATI | Regime coperto |
|---|---|---|---|---|
| **DAX Apertura** (770101 solo long; 770105 short su FTMO) | RETEST r35: 1,13/1,42 (10k), 1,13/1,40 (100k, T) | 0,85/1,07 (10k); **0,965/0,957 (100k, geometria viva)**; DD OOS 12,3%; "NO PER RISCHIO"; certificato "NON ANCORA MISURATO" | 1,00/1,24 (lo short "si prende il posto" del long) | solo 2024.09-2026.06 (toro con calo feb-apr 2025) |
| **Dow Apertura** (770202 solo long; 770212 short mai in campo) | 1,22/1,27 (T, OOS 96 pos < 150) | R54a **1,511/0,840** (IS laterale/OOS toro: "28° ribaltamento"); in fase con la cash **0,77/0,78**; 14:30 d'inverno IS 1,46 (38 pos), 15:30 d'inverno 0,45 (24) | RETEST 1,37/1,10; breakout 15' filtro EMA H4 OOS 40/40 >= 1,10 (celle da 150 pos: 12) | solo BCM; **nessuna finestra di ribasso/crollo** |
| **Nasdaq Apertura** (770250 **solo short**, gated; 770260 L+S) | retest L 0,96/1,13; RETEST nativo 1,62/0,56 | gated 770250: T **1,097 (104 deal) ma OOS 0,948**; B 2020-24 (EXT) 1,84; retest S 1,17/0,82 | 770260: 1,22/1,22 (2%, 80k) o 1,14/1,11 (1%) | tick solo 2024-26; **orso/crollo solo in OHLC** (orso 2022 +4.020 su 49 trade, crollo 2020 +2.037) |
| **ORB Ottimizzato** (770611 solo long) | **1,25/1,67** (T, 100k, 1%, 119 pos; 49% del netto OOS da gen-feb 2026) | **R54b 0,68/0,52, DD OOS 26,4%** (unica misura) | 0,96/1,05 | solo 2024-26; l'asse "lato" mai esplorato sul Nasdaq |
| **MaxMin DAX Short** (770411 solo short) | 0 su 41 celle sopra 1,00 (long) | 1,88/2,16 (100k, 20/21 deal); 2,05 con filtro S&P, 1,18 senza | 0,83-0,99 | 1 regime (toro); d0 inverno 2,56 (16 pos) |
| **ORB di Emiliano (regola 5 min PRE) sul Dow** (R278, NON la 770611) | - | - | OOS **0,64 / 0,71 / 0,68** (nostra gestione, 2%): nessuna cella passa | 2024-26 |

**Lettura onesta:** gli short sugli indici **misurati finora a tick vanno male** (ORB, DAX Apertura, Dow in fase); l'unico short vivo con numeri buoni, il MaxMin DAX, e' un meccanismo notturno con pochissime operazioni (circa 13/anno). I rovesci IS/OOS "a specchio" (Dow 1,51/0,84; Nasdaq 3,22/0,46) sono **firma di regime**, non di lato: con un solo regime nel feed BCM non si separano. **Il feed BCM non contiene nessun ribasso ne' crollo.**

## 2. Lo storico ampio: cosa c'e' davvero (dichiarato da agente, fonti in `LO_STORICO_ESTERNO_MAPPA`, `STORICO_INDICI_*`, `REGIME_*_SPEC`)
| Simbolo | Dati | Stato | Anni utili |
|---|---|---|---|
| **NASUSD** | HistData M1 2010-11 -> 2026 (5,2 M barre, PC di backtest) | `NASUSD_EXT` esiste, ammesso alla prova di regime per firma, rapporto diff/vol **0,199 contro 0,20** | 15,7 |
| **SPXUSD** | idem | `SPXUSD_EXT` **in frigo** (0,203 > 0,20): regola D-C n.3, resta fuori | - |
| **DAX D30EUR** | HistData `GRXEUR` 2010-11 -> 2018-12 (1,7 M barre, CSV sul VPS) | **non importato**; zero giorni in comune col nativo (cancello ZERO inapplicabile); serve convertitore con ora legale per giorno e firma D-J | 8,1 (tre orsi: 2011-12, 2015-16, 2018; **manca 2020 e 2022**) |
| **Dow U30USD** | **nessuna barra M1 esterna**; Dukascopy (dal 2012) a zero byte; `U30USD_DK` in frigo e tutto dentro il nativo | **NON TESTABILE su storico profondo.** Dal cloud Dukascopy e HistData sono bloccati (403); dal PC serve la sequenza di sonde K0/K1 prima del download | 0 |

**"17 anni" era sbagliato:** Nasdaq 15,7, DAX 8,1, Dow 0. Tutto e' **OHLC M1** (modello 1, spread impostato a mano, nessun tick): **screening, mai verdetto** (regola D-C: sugli `_EXT` non si tara e non si promuove niente). Fattore OHLC->tick misurato in casa: da 0,98 a **3,51** secondo il meccanismo.

## 3. I rischi di validita' (avvocato del diavolo, da scrivere nei criteri PRIMA dei numeri)
1. **Fuso/ora legale.** HistData e' ora di New York con ora legale (non "EST fisso"); l'importatore sceglie uno shift fisso **+5 ore**: su `NASUSD_EXT` le 14:30 sono SEMPRE la cash USA, mentre sul nativo BCM (UTC+1 fisso) d'inverno la cash e' alle 15:30. Una cella "ore 14:30" arma quindi **alla cash** sull'esterno e **un'ora prima** sul nativo d'inverno. **Non si confrontano feed diversi senza dichiarare la variante d'orario** (InpAutoUSDST su BCM, off su EXT).
2. **Contraddizione aperta sull'orario di SHORTGATE/FASE2** (armati a 09:30 del file): con lo shift +5 sarebbero **pre-mercato** (04:30 NY): PF 1,84 e 1,32 "non provati". [NSPEC §3.3]
3. **OHLC contro tick e costi:** lo spread nelle barre importate e' zero; gli spread del 2010 non sono quelli di oggi; il cancello ZERO confronta solo le chiusure H1.
4. **Short = asimmetria strutturale** (deriva rialzista): il confronto giusto e' con una entrata casuale alla stessa ora e stessa geometria, non solo PF contro 1. Le etichette di regime sono scritte **dopo** (uno short "in orso" vince per costruzione).
5. **Confronti multipli:** parametri scelti sul feed BCM 2024-26 (range 35, buffer 5) e "confermati" altrove; buffer in valore assoluto non scalano nei decenni (DAX 6.500 nel 2011 contro ~24.500 oggi).
6. **Non indipendenza:** NASUSD e SPXUSD nello stesso giorno contano una volta; DAX 2010-2018 puo' rispondere a una sola domanda ("regge in un orso?") e un esito positivo vale al massimo **PARZIALE**.

## 4. Il piano che questa mappa PROPONE (bozza, da firmare prima di qualunque numero)
**Regola di perimetro:** con le regole firmate oggi si puo' girare solo su **`NASUSD_EXT`**. DAX = bloccato (convertitore + firma D-J), Dow = bloccato (download dal PC + K0/K1), SPX = in frigo. Dire il contrario sarebbe una scorciatoia.

| Passo | Cosa | Criterio scritto prima |
|---|---|---|
| P0 | Questa mappa (fatta) | - |
| P1 | **Taratura G0-C OHLC contro tick** sul nativo BCM 2024-26, per EA e **per lato separato** | soglie: operazioni 0,85-1,15; \|dPF\| <= 0,15; DD 0,80-1,20; se NON FEDELE si legge solo il rischio |
| P2 | **ORB_Emiliano** (`ABTG_ORB_Emiliano.mq5`, regola dell'indicatore, set Nasdaq) su `NASUSD_EXT`, lato **L / S / L+S**, finestra 2010-2026, orologio EXT (cash alle 14:30 tutto l'anno, AutoUSDST spento) | numero di celle **fisso prima** (3 lati x 1 set = 3); riportato "k su N", mai la migliore |
| P3 | Stessa cella sul nativo BCM tick 2024-26 (AutoUSDST acceso) come confronto di calibrazione | idem |
| P4 | Lettura per **regime e per anno** (crollo 2020, orso 2022, laterale 2015-16, toro 2019/2021) e per lato | soglia di merito **n >= 150**; sotto "NON ANCORA MISURATO"; M2: PF(short, toro) >= 0,90 e PF(long, avverso) >= 0,90; nessun anno oltre una quota firmata del PF aggregato; **nessuna cella aggiunta dopo aver visto un numero** |
| P5 | Dow: solo se Claudio firma il download dal PC (K0/K1); fino ad allora **"NON TESTABILE su storico profondo"**, nessun proxy nei totali |

**Il confronto "Dow contro DAX" di Emiliano:** nelle trascrizioni **non c'e' una misura**: dice che Nasdaq e US30 sono i due indici piu' volatili (US30 "leggermente superiore"), "il DAX non e' il piu' volatile", e consiglia l'US30 dopo due giornate. La sua ORB sul Dow/Nasdaq (candela M5 14:25-14:30, due pendenti a 10 punti, filtro 17-38 detto per il Nasdaq, Piano A) e quella sul DAX (range M15, trigger M3) sono **due regole diverse**: "Dow meglio di DAX" non si misura finche' non c'e' la stessa regola su entrambi.

## 5. Decisioni che servono da Claudio
1. **Firma di perimetro:** si parte con `NASUSD_EXT` (unico ammesso) per l'ORB di Emiliano e per il Nasdaq Apertura; DAX e Dow restano fuori finche' mancano convertitore/firma D-J e dati.
2. **Dow:** scaricare dal PC (sequenza K0/K1) oppure restare "NON TESTABILE".
3. **Orologio** del DAX e degli USA dal 26/10 e dal 02/11 (aperta da stamattina).
4. **ORB di Emiliano:** la regola dell'indicatore e' quella della variante `ABTG_ORB_Emiliano` (nuova, non compilata): vedi `report/ORB_EMILIANO_SALA_V2_2026-10-23.md`.

## 6. Mai misurato (sintesi)
Short su indice in orso/crollo con tick; ORB lato short su Nasdaq/DAX (R125d scritto, mai girato); DAX Apertura per lato in fase (R252/PRV_DAXAP_04: nessun CSV); long/short separati del Dow breakout; 770260 per lato (R231a mai girato); la regola ORB di Emiliano sul DAX; Dow e DAX con la stessa regola e lo stesso orologio; spread storici 2010-2018 in bp; swap indici BCM.

## 7. Limiti
7 agenti in lettura; nessun numero ricalcolato da me tranne i quattro citati; documenti con numeri incongruenti fra loro (PF OOS short DAX 0,957 contro 1,065 su banchi diversi; "770250 OOS 1,097" della mappa e' la finestra intera, con split 0,948); tre firme (D-J, D-K, D-L) non risultano date; il regime non e' firmato (etichette provvisorie).
