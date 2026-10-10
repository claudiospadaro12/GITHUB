# NatCla - piano per MISURARE i parametri migliori, senza chiedere alla collega (10/10/2026)

**STATO: bozza dello Sviluppatore, NON passata dal cancello (strato 1 e strato 2 DA FARE).** Nessun backtest lanciato, nessun
file EA/driver/prova/preset/conto toccato. Questo documento non autorizza a lanciare niente: le righe di lancio hanno il loro
cancello. Le soglie T1-T8 e le attese A1-A6 citate sono quelle GIA' CONGELATE in `backtest_pipeline/prove/NATCLA_F1_STOP_2026-10-09.txt`
(r.136-178): qui non si cambia nessun criterio dopo i numeri. Dove propongo una soglia nuova (assi di F2) la scrivo ora, prima
di qualunque P/L, e diventa vincolante solo quando entra in un file prova passato dal cancello.

Etichette: **[MISURATO]** letto da un referto in repo · **[DERIVATO]** calcolo mio su numeri in repo · **[CALCOLO]** aritmetica/binomiale
rifatta qui (§A) · **[STIMA]** ancorata a un numero in repo · **[NOSTRA]** operativizzazione nostra · **[POST-HOC]** ipotesi nata
guardando dati: vale come ipotesi, mai come risultato · **[NON MISURATO]** buco dichiarato.
Sigle di fonte: **AUD** = `report/NATCLA_ANALISI_AUDIO_2026-10-06.md` · **SPE** = `report/NATCLA_SPECIFICA_2026-10-07.md` ·
**NOTE** = `report/NATCLA_CODICE_NOTE_2026-10-07.md` · **LEG** = `data/natcla/LEGGIMI.md` · **F1** = `backtest_pipeline/prove/NATCLA_F1_STOP_2026-10-09.txt` ·
**P0** = `report/NATCLA_F0_PILOTA_LETTURA_2026-10-07.md` · **F0A/F0C/F0D** = le letture dei lotti A/C/D · **V110/V111** = `report/NATCLA_V110_STOP_2026-10-09.md` / `..._V111_...` ·
**CHK** = `backtest_pipeline/CHECKLIST_RIGA_DI_LANCIO.md`. L'analisi del PDF (`NATCLA_ANALISI_PDF_2026-10-06.md`) e' stata letta a campione: il PDF
e' ESCLUSO da Claudio (LEG r.8-11) e qui non e' fonte di niente. Il piano B v1.06 (`NATCLA_PIANO_B_V106_2026-10-08.md`) e' stato letto: non
serve (C0 superata: `NATCLA_F0_C0_LETTURA_2026-10-08.md` r.8), non e' applicato.

---

## 0. In breve (per Claudio)

1. **Sei risposte tue (08-09/10) hanno gia' chiuso meta' delle "5 domande"**, per decisione e non per misura: direzione ENTRAMBI; stop 20 u oltre
   ST3,5/EMA200 (entrambe le letture); TP 10 punti di prezzo (10 pip sul forex); orari qualsiasi; TF tutti, soprattutto H1/H4; ADX quello di MetaTrader
   (LEG r.13-26). Quello che resta da MISURARE e' molto meno di 5 cose e costa meno di quanto sembra (§3).
2. **Nessuna misura di merito esiste.** F0 e' solo conteggio (Modello 1, nessun PF); F1 e' scritta e non lanciata; `REGISTRO_TEST.md` ha **zero**
   righe NatCla [MISURATO con grep]. Quindi **nessun "morto"** e nessun certificato da emettere: tutto e' "NON ANCORA MISURATO".
3. **Due muri, e stanno su celle diverse.** (i) *Il costo*: con il pedaggio di campo **nessuna cella forex passa 40x** (EURUSD in LINEA: 37,4x sull'ordine d'anticipo,
   30,0x sulla linea, 22,5x sul profondo [DERIVATO]); l'**oro passa** (99,7 / 79,8 / 59,8x). (ii) *Il campione*: solo FX7 AUDIO_H1 (475 long / 409 short di setup nell'IS) e
   FX7 M2_H1 (344 / 284) arrivano a 150 per lato; l'oro (62 / 38) e gli indici no. **Dove il merito e' misurabile il costo e' al limite; dove il costo e' sicuro il merito non e' misurabile**
   - e l'oro non ha gemelli (argento fuori scala, §3.3), quindi per la regola T2 **non puo' mai essere "VIVO"**.
4. **Strada piu' corta**: P (4 passate) -> oro O (20) -> **core forex H1** (FX7 x AUDIO_H1 e M2_H1, 70 passate, invece delle 140 di FA+FB) -> poi il resto. Totale ~94 passate, **~3-11 ore** [STIMA] contro le 200 / ~6-23 ore del piano scritto (§5).
   Nessuna famiglia ha "SENZA dubbio" piu' probabilita': lo dico e lo spiego in §4. **XAGUSD NON e' la strada**: "passa il lavoro su tutte le configurazioni" e' un artefatto
   dell'unita' (stop = 62% del prezzo); con un'unita' coerente non supera 17x (§3.3).
5. **Un secondo regime a tick reali non esiste** (tick BCM dal 05-10/07/2024, un solo toro: oro +39% nell'IS). Il resto e' OHLC, e l'OHLC puo' solo bocciare (§6).
6. **Il collo di bottiglia vero e' ingegneristico**: il driver F1 sostituisce **5 input** (`NATCLA_F1_PASSATE.ps1` r.98) e blocca gli altri; ADX, ATR, TP, scala, durata, placebo **non** si possono mettere ad asse senza un
   driver nuovo (pin nuovo + cancello). Il driver dei round non va bene (PF per DEAL, non per setup: F1 r.17-24).
7. **La risposta piu' probabile su periodo ADX e periodo ATR e' "il default va bene"** (l'ADX agisce sulla sola ST35, ~10% dei setup finali; §3.5). Non vanno spesi tick reali su quegli assi prima che una famiglia sia VIVA.
8. **Decisione vera per te: una sola** (§9): permettere la misura di TF sotto H1 (M30) come deviazione dichiarata dalla fonte. Il costo NON la esclude; la esclude solo la fonte (EA r.1139).

---

## 1. Cosa e' gia' stato fatto, cosa no (le fonti)

| cosa | stato | dove |
|---|---|---|
| F0 conteggio (Modello 1 OHLC M1, `InpSoloConta`), lotti PILOTA/A/B/C/D + C0 | fatto, circa 240 passate, ADX = MetaQuotes su tutte | P0, F0A, F0C, F0D, `NATCLA_F0_C0_LETTURA_2026-10-08.md` |
| frequenza AUDIO_H1 | ~218-244 setup/anno per simbolo forex; ST35 solo 41-55 su 1,99 anni (~10% dei setup) | F0A r.20-21 |
| costo, geometria letterale (stop 15/10/5 u) | forex 0 PASSA / 47 FRA / 19 ESCLUSO (lotto A, con commissione derivata); lotto B nessuna passa; indici tutti ESCLUSI; oro PASSA | F0A r.24-28, F0C r.22-23 |
| regola di stop di Claudio nel codice (LINEA, PIU) | scritta (v1.10/v1.11), collaudata a tavolino, **mai compilata/girata** | V110, V111 (cancello strato 2: PASS con riserve) |
| F1 (tick reali, merito, 3 modi di stop) | **preparata, NON lanciata, NON passata dal cancello** | F1 r.1-8; commit WIP `2453bfe8` "NON pronto" |
| regime | un solo (toro) in tutta la finestra tick | F0A r.9, F1 r.104-106 |
| REGISTRO_TEST | zero righe NatCla | grep di `natcla` e di `nat&cla` = 0 righe |
| MANOPOLE INERTI (censimento 09/09) | non applicabile: nessun round NatCla esiste. **Rischio a priori** di manopole inerti nei nostri assi: §7 | - |

**Priori di casa sui motori parenti (dati d'archivio, NON di NatCla; uscita e geometria diverse; PF a barre salvo dove detto)** - da leggere come ipotesi di contesto:
- **Rimbalzo al primo tocco della EMA200 = NULLO** su H4 forex (6 coppie Oanda 2005-2020, P 0,487 long / 0,470 short contro surrogati 0,478 / 0,491; n_cluster 634 / 591)
  e 13 NULLO + 8 ZONA GRIGIA su 21 celle M5-H1 su DAX/oro/S&P: `report/RESOCONTO_EA_G2_EMA200_SW_ORB_2026-10-05.md` r.95. SPE r.700-703 ne trae l'attesa "la base M2 deve uscire non distinguibile dal placebo".
- `ABTG_EMA200` (parente stretto di M2) nel censimento `CENSIMENTO_PF_TUTTI_2026-09-09.csv`: EURUSD H1 tick reali PF 1,195 su 641 deal; oro H1 1,167-1,182 (n 687-891, OHLC; altre corse dello stesso oro H1: IS 0,68 / OOS 0,94);
  ma USDJPY 0,875-0,883, USDCAD 0,823-0,827, USDCHF 0,773-0,798, AUDUSD 0,943-0,954, NZDUSD 0,744-0,756, GBPUSD 0,890-0,901 su H1. Cioe' **un solo forex su sette e' sopra 1** con quel motore.
  La cella migliore di casa per un motore EMA200 e' U30USD H1 (PF 1,20-1,52, n 237-517), simbolo che per NatCla e' escluso per costo (§4).
- `ABTG_SupertrendReversal` sul forex: "nessuna tipologia superata" (CHFJPY 0/12, AUDUSD solo celle a segno invertito), oro H4 default SOTTO 1: `report/RESOCONTO_EA_G5_SUPERTREND_GOLDEN_ORO_2026-10-05.md` (tabella riga 1-3 e verdetto 9). Uscite diverse da NatCla.
- Tabella B dell'audit uscite (`report/AUDIT_USCITE_2026-09-09.md` r.37-40, r.171-173): trailing sul Supertrend, uscita al flip, frazione d'ingresso e parziali diversi da 0/50 sulla famiglia Supertrend: **ZERO** celle. **Non sono nelle regole della collega** (SPE r.638-639) e la v1.04 rifiuta le manopole nate dal PDF (BE, parziale): restano fuori da questo piano (§6.4).

**Valori di riferimento esterni (solo per I VALORI, non strategie)**:
- Supertrend: default 10 / 3 (periodo ATR / moltiplicatore) con ATR a scelta RMA o SMA, default RMA, nello script TradingView ampiamente condiviso `https://www.tradingview.com/script/r6dAP7yi` (consultato 10/10/2026).
  Il nostro `iATR` di MT5 e' una media SEMPLICE (SPE r.122): se la collega guardasse un Supertrend con ATR RMA la linea sarebbe un po' diversa. **[NON MISURATO]** quanto; la domanda ADX analoga l'ha chiusa Claudio (MetaTrader), questa no.
- Lo strumento del coach (Lavorenti) ha ATR 10 e moltiplicatori 2,5/3,0/3,5 (screenshot del 19/08, `backtest_pipeline/caccia_strategie/biblioteca/schede/SUPERTREND_EX5_DISCO_CLAUDIO_2026-08-19.md`): indizio, NON fonte (NOTE r.291-295).
- ADX: periodo 14 in entrambe le piattaforme come uso comune; l'help di MT5 non fissa il default di `iADX` in modo leggibile e contiene due formule diverse (`https://www.metatrader5.com/en/terminal/help/indicators/trend_indicators/admi.md`).
  **Non decide niente**: la formula vera l'ha misurata la riga VERIFICA ADX (terminale = MetaQuotes al centesimo: 66/66, 65/65, 18/18, 4/4, 3/3, P0 r.54-62, F0A r.7).

---

## 2. Regole comuni del piano (vincolano ogni incognita)

- **Unita' = il SETUP**, non l'ordine ne' il deal (SPE r.547-550; F1 r.19-24). Il PF e' **PF_R** per setup (somma R positivi / somma R negativi). [Il "PF_V" del GBA e' un altro lettore; qui PF_R.]
- **Merito solo con n >= 150** per gamba (famiglia x config x lato x modo, somma dei simboli, T1). Sotto: MERITO SOSPESO; il RISCHIO si legge a qualunque n (Emendamento B).
- **VIVO** (T2): n >= 150 **e** PF_R >= 1,15 **e** media R > 0 con p < 0,05 **e** segno PF_R > 1 in almeno 2/3 dei simboli con n >= 30 (minimo 2 votanti). **VIVO e' un permesso di aprire gli assi di F2, mai una promozione.**
  PERDENTE MISURATO (T3): n >= 150, PF_R < 1, media R < 0, p < 0,05. Tutto il resto con n >= 150 = NON DISTINGUIBILE (T4).
- **Il nullo (nessun edge) dice dove cade il rumore** [CALCOLO, §A]: PF_R nullo per setup EURUSD 0,846 (GEOM) / 0,881 (LINEA) / 0,905 (PIU, EMA200 oltre di 38 u) (CHK r.38025); per ordine 0,89-0,91 (LINEA, U=20) e
  oro 0,96. **Con n = 150 il nullo supera PF 1,15 nel 9,6% dei casi (LINEA, U=20) e 17% sull'oro; con n = 300 nel 2,8% e 7,8%** (§A). Per questo T2 non basta il solo 1,15.
  Ogni gamba ha circa il 10% di probabilita' di passare 1,15 per caso a n = 150: con 12-16 gambe ne passa in media piu' di una. E' il motivo dei tre criteri in piu' di T2.
- **IS/OOS**: IS = dal pavimento dei tick al 30/06/2025, OOS = 01/07/2025-30/06/2026 **non toccato** fino a F3, usato **una volta** (F1 r.92-96). Dove si collochi il taglio non e' regola di casa (Emendamento A): e' dichiarato.
- **Regimi - Firma 1 del 10/10/2026** (`report/FIRME_2026-10-10.md`, non retroattiva): "regge" solo se PF_V > 1,0 in OGNI regime con >= 150 operazioni, long e short separati, nessun DD oltre il promesso; regime con < 150 = NON MISURATO;
  finestre scelte con regola oggettiva sul prezzo scritta prima; **a tick reali si misura solo cio' che i tick coprono; i regimi vecchi in OHLC sono screening, mai verdetto.** Per NatCla il criterio si AGGIUNGE come lettura per regime (F3/F4).
- **Centro dell'altopiano, mai il picco**; per assi a tre celle si prende il centro se i vicini tengono; una cella che sporge da sola e' rumore (SPE r.579-582). **Si tiene una variante solo se migliora la famiglia, non l'aggregato.**
- **Una variabile per file prova** (`controlla_prova.py`). *Nota di onesta'*: il file F1 NON la rispetta nello spirito (lato, modo, config, simbolo stanno in blocchi `@F1-...`, l'unico asse "vero" e' tecnico: `InpMagic=0||0||1||1||Y`);
  passa il controllo perche' ogni confronto e' a parita' di tutto il resto. In F2 si torna a **un file per asse**, e serve il driver nuovo (§5.3).
- **Nessuna griglia sui decimali.** Ogni asse qui sotto ha 1-4 celle, ciascuna una lettura diversa di una frase della collega o un meccanismo diverso.
- Tutto su PC di backtest `DESKTOP-H4D7CAJ`, terminale BCM demo 50503392 di QUELLA macchina; mai sul VPS, mai `C:\MT5_Backtest` (regola 21/09).

---

## 3. Le cinque incognite

Quadro d'insieme (cosa e' chiuso da una DECISIONE, cosa resta misura):

| # | incognita | stato dopo LEG 08-09/10 | cosa si MISURA | passate extra rispetto a F1 |
|---|---|---|---|---:|
| 1 | direzione | **ENTRAMBI** (LEG r.17) | long e short SEPARATI, e se la differenza e' regime o linea | 0 |
| 2 | stop | **20 u oltre ST3,5/EMA200**, "proviamole entrambe" (LEG r.18-20) | 3 modi (GEOM base, LINEA, PIU) + la regola "stop al costo minimo" | 0 + 14 (F2) |
| 3 | pip/punti, origine TP | **10 punti di prezzo / 10 pip forex** (LEG r.13-14, 25); origine **non decisa** | ancora del TP (linea o riempimento), distanza 10 vs 20, argento (unita') | 28 (F2) |
| 4 | simboli, orari | orari **qualsiasi** (LEG r.21); simboli **mai detti** | quali simboli reggono costo e scala; split orario descrittivo | 0 |
| 5 | periodi ADX/ATR | ADX **MetaTrader** (LEG r.23); periodo 14 e ATR 10 sono **[NOSTRA]** | conteggio di sensibilita'; poi 2 celle ADX significative | 28-56 (F2, condizionato) |

### 3.1 Direzione

**(a) Cosa sappiamo.**
- La collega non dice mai long/short/buy/sell (AUD r.104, R26; §3.2 r.119-131). "Sotto"/"sopra" (WA0092) e stop "sopra qualche resistenza" (WA0091) sono compatibili con tre letture: A (long), B (short, la piu' coerente con 4 indizi, r.127, **inferita non dichiarata**), C (entrambi).
- Claudio 08/10: **ENTRAMBI** (LEG r.17). L'EA lo fa per costruzione: long sul floor, short sul ceiling, il verso del rimbalzo e' fisso (SPE r.133-134, D1-D2).
- Regola di casa: due lati sempre separati (CLAUDE.md 25/08; SPE r.663). F1 li separa gia' (`@F1-LATO`, r.226-227).
- Regime dell'IS [PROXY F1 r.104-106]: oro +39% (2.369 -> 3.298); USDJPY -10,5%, USDCHF -10,6%, EURUSD +7,6%, GBPUSD +7,4%, AUDUSD -2,6%, NZDUSD -0,6%, USDCAD +0,2%; indici toro con crollo di aprile 2025.

**(b) Ipotesi, attesa, cosa la smentisce.**
- **H-DIR: "il lato non conta oltre il regime"**: senza edge il PF_R di long e short sta sul nullo (0,85-0,95 forex, 0,93-0,98 oro) e la differenza segue la deriva del simbolo.
- Attesa n (F1 `@F1-ATTESA`, banda x0,5-2,0 = COERENTE, A1): FX7 AUDIO_H1 long 475 / short 409; FX7 M2_H1 344 / 284; oro AUDIO_H1 62 / 38 (SOTTILE).
- **Cosa la smentisce**: un lato VIVO (T2) e l'altro PERDENTE MISURATO (T3) nella stessa famiglia **con il segno non spiegato dalla deriva**. Controllo di deriva [NOSTRA, esperimento naturale]: nell'IS i sette forex hanno deriva di segno opposto
  (USDJPY/USDCHF giu', EURUSD/GBPUSD su). Se il long vince solo dove sale e lo short solo dove scende e' tendenza, non rimbalzo; se il vantaggio e' dello stesso lato a prescindere dalla deriva, e' un'asimmetria della linea.
  Con 7 simboli e' un test debole (correlazione di rango, descrittiva), non un verdetto. Sull'oro l'attesa A5 resta: PF long > 1 e PF short < 1 = regime, non linea.

**(c) Asse.** Il lato e' GIA' una variabile di F1 (2 valori). Nessun file nuovo.

**(d) Costo.** 0 passate extra. (Il lato raddoppia le passate di ogni cella: e' gia' dentro le 200.)

**(e) Validazione.** IS >= 150 per lato **solo** per FX7 AUDIO_H1 e FX7 M2_H1; tutte le altre gambe sono SOTTILI (SPE e F1 r.99-103). OOS: una volta in F3. **Secondo regime a tick: NON ESISTE.** Altopiano: non applicabile (nessun parametro continuo).
Se emerge un'asimmetria, la scelta "ENTRAMBI oppure solo il lato forte" e' una decisione sul **rischio/fedelta'** (SPE r.655-657), quindi tua - ma solo dopo il numero.

**(f) Strada piu' corta.** Nessun lavoro in piu': e' gia' nelle passate di FX7 H1 (§4-§5).

### 3.2 Stop

**(a) Cosa sappiamo.**
- La collega: "leggermente sopra qualche resistenza, se c'e'", nessun numero (AUD r.101, R23; B4 r.173).
- Claudio 08/10: 20 punti oltre l'EMA200 oppure oltre il Supertrend 3,5; il 09/10 sull'"oppure": "proviamole entrambe" (LEG r.18-20). Implementati: `InpStopModo` = `GEOMETRIA_ATTUALE` (ordine profondo + 5 u, v1.05), `OLTRE_LINEA_ESTERNA` (ST3,5 nei setup Supertrend, EMA200 in M2), `OLTRE_PIU_ESTERNA` (la piu' esterna delle due) (V111 r.23-45).
- Scelte [NOSTRE] da V110/V111: linea esterna discorde = setup scartato; X4 (mai piu' vicino dell'ordine profondo + 5 u) resta; il placebo sposta tutte le linee.
  **Peso degli scarti sull'oro (HistData, NON BCM)**: modo LINEA scarta 47/222 (21%) ST2,5, 16/186 (9%) ST3,0, 0/193 ST3,5 (totale 63/601 = **10,5%**); modo PIU scarta 29/222, 10/186, 0 (**6,5%**) (V111 r.121-127, domanda 1 r.207-212). Sul forex [NON MISURATO]: il CSV v1.05 non ha il verso della EMA200 (V111 r.137, r.200).
- Costo, **pedaggio di campo** (SPE r.462-472: EURUSD 0,667 pip; GBPUSD 0,845; USDJPY 0,915; oro 0,25 USD), ordine d'anticipo / linea / profondo:

  | | GEOM (15/10/5 u) | LINEA/PIU pavimento (25/20/15 u) | U minimo perche' TUTTA la scala passi 40x |
  |---|---|---|---:|
  | EURUSD | 22,5 / 15,0 / 7,5 | 37,4 / 30,0 / 22,5 | **31,7 u** |
  | GBPUSD | 17,8 / 11,8 / 5,9 | 29,6 / 23,7 / 17,8 | 38,8 u |
  | USDJPY | 16,4 / 10,9 / 5,5 | 27,3 / 21,9 / 16,4 | 41,6 u |
  | XAUUSD | 59,8 / 39,9 / 19,9 | 99,7 / 79,8 / 59,8 | 15,0 u |

  [CALCOLO sui pedaggi di SPE §5.3; U minimo = 5 + 40 x pedaggio, perche' l'ordine profondo sta a U - 5 dallo stop.] LEG r.26 riporta 29,9x / 23,8x / 22x (ordine sulla linea): coincide.
  **Attenzione**: il file F1 sceglie i simboli con lo **spread del tester** (S1 r.60-64, tabella r.76: EURUSD 43,9x PASSA in LINEA); con lo spread di campo e' 37,4x (FRA). La mediana del tester e' meta' di quella di campo (P0 r.134-136). Il verdetto vero lo da' lo spread del riempimento a tick reali (colonna del CSV), non quello della selezione.
- Pareggio richiesto (SL+ped)/(TP+SL), ordine sulla linea, TP 10: EURUSD **68,9%** a U=20, **77,8%** a U=32; oro 67,5% a U=20 (F1 r.149-151; V111 r.186-192). **Uno stop piu' largo migliora il costo e alza il pareggio insieme.**

**(b) Ipotesi, attesa, cosa la smentisce.** (attese F1 A1, A2, A3, A6 - non le cambio)
- **H-STOP: "la regola di stop e' un asse di COSTO, non di merito"**: senza edge il PF_R resta sotto 1 in tutti e tre i modi e sale solo di +0,03/+0,06 da GEOM a LINEA a PIU per il solo peso del pedaggio (CHK r.38025: EURUSD 0,846 -> 0,881 -> 0,905; USDJPY fino a +0,08).
- **n**: n(LINEA)/n(GEOM) attesa **0,85-1,00** e n(PIU)/n(LINEA) **1,00-1,06** (oro HistData: 1 - 10,5% e 1 - 6,5%; forex [NON MISURATO]); fuori da 0,5-2,0 (A1) = DA GUARDARE, sotto 0,1x o sopra 10x = STOP.
- **Costo**: vedi tabella sopra. EURUSD LINEA FRA (37,4x anticipo); oro PASSA in LINEA e PIU.
- **PF_R**: attesa in assenza di edge **0,80-0,95 forex, 0,93-0,98 oro** (A2).
- **Cosa la smentisce**: un modo MIGLIORE di un altro solo se VIVO, con differenza di PF_R >= 0,10 e segno concorde in almeno 2/3 dei simboli con n >= 30 (T5, r.170-171). Con meno, **NESSUNA DIFFERENZA DISTINGUIBILE**: la scelta fra LINEA e PIU e' tua (fedelta' o misura) e va scritta cosi'.
  Il test sostanziale di H-STOP e' T5 con il *nullo misurato sulla geometria vera* stampato accanto (diagnostica della classe 1215): un guadagno entro il delta del nullo non distingue niente.

**(c) Asse.**
- *F1 (gia' scritto)*: `InpStopModo` in {GEOM, LINEA, PIU} - **un meccanismo, non un decimale**. M2: solo GEOM e LINEA (PIU e' identico per costruzione, V111 r.29).
- *F2, una cella nuova*: **regola "stop al costo minimo"** `InpStopOltreU = 5 + 40 x pedaggio` per simbolo (EURUSD 32, GBPUSD 39, USDJPY 42; oro resta 20, gia' sopra). E' una regola, non una griglia: risponde a "il metodo regge quando lo si costringe a passare il cancello?".
  La misura di spread vivo c'e' solo per 8 simboli (EURUSD, GBPUSD, USDJPY, XAUUSD, 225JPY, D30EUR, NASUSD, U30USD: `data/spread_vivo/SPREAD_VIVO_2026-09-12_orario.csv`); per **AUDUSD, NZDUSD, USDCAD, USDCHF, SPXUSD, 100GBP, 200AUD non c'e'** [NON MISURATO]. Prerequisito a costo CPU zero (sonda di sola lettura).
  *Soglia nuova, scritta ora*: la cella conta come "passa il lavoro" solo se la mediana stop/(spread del riempimento + commissione) del CSV a tick reali e' >= 40 sull'ORDINE PIU' VICINO ALLO STOP (il profondo), non sull'anticipo.
- Valori fuori piano: nessuno. `InpStopOltreU` = 20 e' il numero di Claudio; 32-42 e' una **misura di costo**, non una fedelta' (lo scrivo accanto a ogni risultato).

**(d) Costo.** F1: gia' nelle 200 passate (nessuna in piu'). F2: 14 passate per cella su FX7-H1 (7 simboli x 2 lati) = **21-84 minuti** [STIMA, forex 1,5-6 min/passata, F1 r.186].

**(e) Validazione.** IS >= 150 solo per FX7 AUDIO_H1/M2_H1. L'oro non puo' decidere LINEA contro PIU (n 62/38). **Regime**: la deriva dell'oro (+39%) gonfia i long; per il forex un solo regime. Altopiano: la scelta fra modi e' discreta; per la cella `U` si leggono i vicini
(U=20 / costo minimo / un valore intermedio) e si prende il centro se il PF_R e' monotono, si scarta se sporge una cella sola.

**(f) Strada piu' corta.** F1 sui tre modi **solo su FX7 H1 e oro**, poi PIU solo se LINEA e' VIVA (altrimenti PIU e' un'altra misura su un motore NON DISTINGUIBILE).

### 3.3 Pip o punti, e origine del TP

**(a) Cosa sappiamo.**
- WA0091 "10 pip", WA0092 "10 punti dal Supertrend o EMA"; il simbolo non e' mai nominato (AUD r.100, §3.3 r.133-135, §3.4 r.137-138).
- Claudio 08/10: "10 PUNTI, NON 10 PIP", poi "PUNTI DI PREZZO, NON MT5"; forex 10 pip confermato (LEG r.13-14, 25). `AUTO_CLASSE`: forex pip, indici 1,0 punto, metalli 1,0 USD (SPE r.170).
  **Quindi l'UNITA' e' chiusa** salvo l'argento. **L'ORIGINE no**: `DALLA_LINEA` (letterale di WA0092: i tre ordini hanno TP a 5/10/15 u dal proprio riempimento con scala (5,5)) contro `DAL_RIEMPIMENTO` (10 u da ciascun riempimento) - asse A1 (SPE r.360).
- Pareggio per ordine in LINEA (U=20), EURUSD: DALLA_LINEA **85,6 / 68,9 / 52,2%** (anticipo / linea / profondo); DAL_RIEMPIMENTO **73,3 / 68,9 / 62,7%** [CALCOLO: (SL+c)/(TP+SL) con SL 25/20/15, TP 10 da ciascun fill; i primi tre = F1 r.149]. Cambia la forma del profilo, non il costo.
- **Il TP di 10 u dipende dall'unita' di scala**: in ATR14 H1 il TP vale 0,83 (EURUSD), 0,66 (GBPUSD), 0,44 (USDJPY), 1,01 (oro) ma **0,16-0,18 su NASUSD/D30EUR** e **56 ATR14 sull'argento** (F1 r.65-69, 86-90; V111 r.213-225).
- **Argento, derivato** [DERIVATO da V111 par. 4b e par. 6 punto 3]: ATR14 H1 ~0,154 USD (20 u = 130 ATR, TP 10 u = 65 ATR), pedaggio ~0,046 USD (20 u / 434,8x). Se "10 punti di prezzo" fosse 10 centesimi (u = 0,01 USD): stop 20 u = 0,20 USD = **4,3x** il pedaggio -> **ESCLUSO**.
  Per stare nella banda di scala S2 (TP 0,22-2,06 ATR14 = 0,034-0,317 USD, quindi u <= ~0,032) lo stop a 20 u vale al massimo 0,63 USD = **13,8x** (anticipo 25 u: 17,2x) -> **FRA bassa, mai sopra il lavoro**. Con u = 1 USD (letterale) e' fuori scala di due ordini di grandezza.
  **L'argento non e' il gemello dell'oro in nessuna unita'**: o fuori scala o sotto il lavoro. Il "434,8x" e' un rapporto senza contenuto (CHK classe 1210).

**(b) Ipotesi, attesa, cosa la smentisce.**
- **H-TP1: l'ancora conta poco**: DALLA_LINEA e DAL_RIEMPIMENTO non distinguibili (delta PF_R < 0,10, T5). Il profilo di vittoria per ordine cambia (sopra) ma la somma sul setup no, perche' il rischio del setup e' fisso.
  **Attesa n**: identica (l'ancora non cambia i riempimenti); se n cambia oltre l'1-2% e' un errore del driver, non un risultato.
- **H-TP2: 10 u e' troppo corto per lo stop largo** (pareggio 68,9-85,6% a U=20). Attesa: TP 20 abbassa il pareggio a ~52% (linea: (20,67)/(40)) e allunga la durata; senza edge il PF_R nullo di LINEA resta 0,9 (la geometria non crea edge).
  **E1** (F1 A4, SPE E1): durata mediana <= 60 min = fedele a "un'oretta neanche"; 60-180 compatibile; > 180 non e' il metodo della collega. Con TP 20 la mediana sale: se supera 180 min **la cella e' fuori fonte**.
- **Cosa le smentisce**: delta PF_R >= 0,10 con segno concorde in 2/3 dei simboli e famiglia VIVA. Altrimenti "il default (DALLA_LINEA, 10 u) va bene" - **ed e' un risultato**.

**(c) Asse (F2, solo su famiglie VIVE, T8).** `InpTPCriterio` DALLA_LINEA contro DAL_RIEMPIMENTO (1 cella, **comune al certificato di morte, casella 3**); `InpTPDistanza` 10 contro 20 (1 cella, **fuori fonte: misura, non fedelta'**).
  `InpUnita` non e' un asse: pip-vs-punto-MT5 e' "escluso per aritmetica" (SPE r.170) e Claudio ha scelto i punti di prezzo.
  *Meccanismo candidato, NON proposto ora*: TP e stop in multipli di ATR (renderebbe indici e argento confrontabili con l'oro). E' un EA diverso da quello della collega e richiede codice: lo tengo come F2-bis condizionato (§6.4).

**(d) Costo.** 2 celle x 14 passate (FX7-H1) = 28 passate = **0,7-2,8 h** [STIMA].

**(e) Validazione.** Come 3.2. In piu' per la durata: le celle F2 sono confrontate a **durata mediana dichiarata** (E1), perche' una cella che vince allungando la durata non e' la strategia descritta.

**(f) Strada piu' corta.** Non misurare l'argento: dichiararlo "unita' non riconciliabile" col numero (4,3x / 13,8x / 17,2x) e togliere la domanda Q3 dalle decisioni (default: XAG fuori, F1 r.197-199).

### 3.4 Simboli e orari

**(a) Cosa sappiamo.**
- Simboli mai nominati (AUD r.105, R27); orari: **qualsiasi fascia** (LEG r.21). F0 ha coperto 36 simboli: forex 22 + EURJPY/EURCHF, oro, argento, 10 indici (lotti A, B, C, D).
- Frequenza AUDIO_H1 forex 218-244 setup/anno per simbolo (circa 1 al giorno di borsa); H4 49-67/anno; H12 28-52 e D1 17-29 **per simbolo nella finestra di 1,99 anni** (F0A r.14-20); oro AUDIO_H1 207,7/anno (P0 r.37).
- **Costo per simbolo, ordine sulla linea, LINEA 20 u, spread del tester** (V111 r.141-178): NZDUSD 41,8x, EURGBP 36,7x, AUDUSD 35,8x, EURUSD 35,1x, GBPUSD 27,3x, USDCHF 26,3x, USDJPY 25,8x ... EURNZD 8,3x, GBPNZD 4,9x; indici SPXUSD/100GBP 14,3x, D30EUR 12,1x, NASUSD 11,8x, U30USD/F40EUR 10,0x, E50EUR 9,3x, E35EUR 3,7x, 225JPY 1,7x.
  Sull'ordine d'anticipo (25 u) i numeri salgono x1,25 [DERIVATO]. **Il campo e' peggio**: dove c'e' lo spread vivo (EURUSD/GBPUSD/USDJPY) la mediana del tester e' meta' di quella reale.
- **Orologio**: sul forex il cambio di orologio BCM (26/12/2024-02/02/2025) cade DENTRO l'IS: le candele H4 forex sono costruite su due orologi (setup H4 prima del cambio 18-24%, dopo 71-76%, zona dubbia il resto: F0A r.36; SPE r.553-558). H1 e' invariante (SPE r.508).
- **[POST-HOC]** "Che cosa tratta la collega?" - **non e' decidibile dal parlato**: "punti" e "qualche secondo" sono coerenti con gli indici (TP = 0,16 ATR, si tocca in secondi), "pip" e "un'oretta" con il forex (TP = 0,4-1,0 ATR). Le due letture danno la stessa predizione: nessuna. Quindi **la domanda sul broker/strumento della collega non serve a niente per misurare**: il costo e la scala decidono dove il metodo, con la sua geometria, e' *schierabile*.

**(b) Ipotesi.**
- **H-SIM: la scelta dei simboli la fa il costo, poi la scala; il merito si somma sulla famiglia.** Attesa scritta ora: con U = 20 **nessuno dei sette forex supera 40x sull'ordine profondo** (15 u: EURUSD 22,5x, il migliore dei tre con spread vivo); sull'ordine d'anticipo (25 u) possono superarlo solo EURUSD, AUDUSD, NZDUSD, e solo se lo spread di riempimento resta vicino alla mediana del tester.
  Smentita: lo spread di riempimento a tick reali e' >= 2 volte quello del tester -> anche questi tre scendono sotto 40x sull'anticipo. La attesa si legge dalla colonna spread-di-riempimento del CSV, **non** dal tester M1.
- **H-ORA: nessun filtro orario (Claudio); ma il costo ha un'ora**: GBPUSD e USDJPY hanno mediane di 8,0 e 6,8 pip al rollover (ore 22 server, SPE r.488-489). Attesa: i riempimenti all'ora del rollover pagano 10-30x il pedaggio tipico e abbassano il PF_R.
  Smentita: nessuna differenza di PF_R fra riempimenti in/fuori ora di rollover a n sufficiente.

**(c) Asse.** Simboli: nessun asse, **selezione per regola** (S1 costo, S2 scala, S3 elenco; F1 r.60-72). Orari: **split descrittivo** del PF_R per ora-server del riempimento dal CSV (0 passate); eventuale cella `InpMaxSpreadPunti` = 2 x mediana del simbolo solo se lo split mostra concentrazione del danno al rollover [POST-HOC: se la cella nasce dallo split resta ipotesi finche' non gira su OOS].
- *Candidato nuovo (post-hoc, [NON MISURATO])*: **EURGBP** (36,7x in LINEA, anticipo ~45,9x [DERIVATO]) ha un costo migliore di USDJPY (25,8x), USDCAD (23,4x) e USDCHF (26,3x) ma non e' in S3 (S3 prende "i maggiori" per convenzione, non per costo). Da aggiungere come gemello **solo dopo** una sonda di spread vivo; non lo aggiungo al piano.

**(d) Costo.** Simboli: 0. Spread vivo dei 7 simboli mancanti: costo CPU 0 (sonda di sola lettura sul VPS, perimetro runner: nessuna estensione se il logger li ha gia' in lista - **[NON VERIFICATO]**).

**(e) Validazione.** Il selezionare i simboli dal costo e' fatto sull'IS; il costo e' una proprieta' del broker, non del PF, quindi non contamina l'OOS. L'orologio: per H4 forex il PF_R si legge anche **separato prima/dopo il cambio** (diagnostica; < 150 per meta' -> NON MISURATO).

**(f) Scarto PER COSTO, col numero (regola dura 13,3x; lavoro 40x)** - tutti [DERIVATO dalle tabelle citate], per modo:
- **GEOM su qualsiasi forex**: scartato come *sedia* (non come baseline di misura): EURUSD 22,5 / 15,0 / **7,5x**; 0 PASSA su 132 passate F0 (lotti A+B, F0A r.24, r.28).
- **Indici in GEOM**: SPXUSD 10,7x, 100GBP 10,7x, 200AUD 9,4x, NASUSD 8,3x, D30EUR 8,8x (F1 r.83-87): ESCLUSI.
- **Forex in LINEA**: **GBPNZD 4,9x (anticipo 6,1x)** e **EURNZD 8,3x (anticipo 10,4x)**: ESCLUSI. GBPJPY 10,8x, CHFJPY 11,3x, GBPCAD 12,6x: sotto 13,3 sull'ordine sulla linea, **13,5-15,8x sull'anticipo** - al bordo, non li chiamo esclusi.
- **Indici in LINEA**: E35EUR 3,7x, 225JPY 1,7x, E50EUR 9,3x, U30USD/F40EUR 10,0x: ESCLUSI. NASUSD 11,8x, D30EUR 12,1x, 200AUD 12,5x: sotto il duro sulla linea, FRA sull'anticipo (14,8-15,6x).
- **Correzione che propongo al file F1 (non lo tocco)**: F1 r.88 scrive che U30USD, F40EUR, E50EUR, E35EUR e 225JPY sono "ESCLUSI PER COSTO **in tutti i modi**". Per **PIU** il numero e' un **pavimento** (il modo non e' mai piu' stretto di LINEA, V111 r.29): un pavimento sotto 13,3 non prova che PIU sia sotto 13,3.
  I tetti di V111 par. 4b in PIU sono U30USD 173,9x, F40EUR 42,9x, E50EUR 20,3x, E35EUR 41,8x, 225JPY 46,9x. Quello che esclude davvero quei simboli in PIU **non e' il costo**: e' il profilo
  (stop di centinaia di punti contro un TP di 10; pareggio U30USD 354/362 = **97,8%**, V111 r.190 e r.252) e la scala (TP 10 punti = 0,07-0,18 ATR14 su NASUSD/D30EUR; U30USD e 225JPY 'fuori scala', F1 r.86-88). Il motivo giusto da scrivere e' "scartato per profilo/scala, col numero", non "per costo in tutti i modi".

### 3.5 Periodi di ADX e di ATR del Supertrend

**(a) Cosa sappiamo.**
- ADX: "a 20, non di piu'" (AUD r.90, R12), periodo e tipo **non detti**; lo dice solo il paragrafo del 3.5. Claudio 08/10: **MetaTrader** (`iADX`) (LEG r.23). Periodo 14 = [NOSTRA]. L'EA applica l'ADX **solo** alla linea 3,5 (`InpAdxAmbito = SOLO_ST35`, EA r.281).
- La formula del terminale e' **MetaQuotes** (VERIFICA ADX 100% delle passate F0: PILOTA 3/3, A 66/66, C 65/65, C0 4/4, D 18/18) [MISURATO].
- Effetto del filtro: l'ADX agisce solo sulla ST35, e **dopo il filtro quella linea pesa ~10% dei setup** (EURUSD 51/475 = 10,7%, XAUUSD 41/410 = 10,0%: P0 r.27-29; ST35 41-55 per simbolo su 434-485: F0A r.21).
  Prima del filtro la ST35 vale circa un terzo degli episodi (88 su 273) e il filtro ne toglie circa l'80%: oro H1, episodi l'anno entro il limite di tocchi 101/84/88 (ST25/30/35) contro 16 sulla ST35 con `iADX` <= 20 (SPE r.521) -> **spegnere il filtro aggiunge circa +36% di setup sull'oro** [DERIVATO: 72 ST35 l'anno su 201].
  Su H4: 5/1/1 episodi l'anno -> **il filtro letterale su H4 e' quasi inerte per assenza di campione**.
- ATR del Supertrend: 10, unica fonte il PDF (P-p07) -> da 07/10 [NOSTRA] (SPE r.120, I1; NOTE r.291-295). Indizi: coach Lavorenti ATR 10 con 2,5/3,0/3,5; TradingView default 10 (§1). Nessuna fonte per 7 o 14.

**(b) Ipotesi, attesa, cosa le smentisce.**
- **H-ADX**: il filtro ADX <= 20 sulla sola ST35 cambia poco il risultato di FAMIGLIA. Se la frase della collega e' vera (le ST35 con ADX > 20 "sfondano"), le ST35 in piu' che entrano spegnendo il filtro hanno PF_R piu' basso, ma pesano ~1/4 dei setup:
  l'effetto sul PF_R di famiglia e' dell'ordine di qualche centesimo [CALCOLO illustrativo: +36% di setup con PF_R 0,70 contro 0,90 del resto -> famiglia ~0,85, cioe' circa -0,05], **sotto la soglia T5 di 0,10**. Attesa scritta: **|delta PF_R famiglia| < 0,10 -> NESSUNA DIFFERENZA DISTINGUIBILE anche se la collega ha ragione**.
  *Il test che puo' dire qualcosa non e' il periodo e non e' T5 sulla famiglia: e' lo SPLIT dentro una passata ad ADX spento*, con il taglio gia' dichiarato dalla collega (20, MetaTrader, periodo 14) e quindi non scelto sui dati: PF_R delle ST35 con ADX <= 20 contro > 20, dalla colonna ADX del CSV per-setup (SPE r.343-346). Zero passate in piu' oltre alla cella "ADX spento".
  Anche `TUTTE` (filtro sul 100% dei setup) testa la frase: E6 della SPE, filtro tenuto solo se migliora il PF nello stesso verso in >= 6/8 (o 9/12) simboli; il nullo lo fa passare nel 14,5% (7,3%) dei casi. Con 7 simboli la regola e' debole: **riportare il numero di simboli accanto**.
- **H-ATR**: periodo 7/10/14 sposta le linee di pochi punti percentuali; attesa **plateau**: n e PF_R entro +-10% e +-0,05 sul valore 10. Una cella che sporge da sola = rumore (centro dell'altopiano). **Se vale H-ATR la risposta e' "il default (10) va bene"** - che e' un risultato, non un fallimento.
- **Attesa n e plateau**: soglia scritta ora, non misura: ATR 7 e 14 devono dare n entro +-10% e PF_R entro +-0,05 del valore 10 per parlare di plateau. Quanto cambi il numero di setup e' **[NON MISURATO]** (nessun dato in repo): lo dice il conteggio di sensibilita'.

**(c) Asse.** Ordine d'informazione:
1. `InpAdxUsa` spento (con lo split per ADX nel CSV) e `InpAdxAmbito` TUTTE (2 celle): testano la frase. **Periodo ADX 10/20 e soglia 25: ultimi** (agiscono sulla ST35, ~10% dei setup finali; le 6 celle di A5 sono 24 passate/simbolo, il 29% delle 84 passate AUDIO di SPE r.364, per una manopola debole). La cella Wilder di A5 **decade** (Claudio ha scelto MetaTrader).
2. `InpStAtrPeriodo` {7, 14} attorno al 10 (2 celle).
3. Un file prova per asse (regola di casa), quindi con driver nuovo (§5.3).
*Gratis, subito*: il conteggio dei setup per ATR/ADX sull'oro HistData con gli specchi Python gia' nel collaudo (`collaudo_natcla.py`: `py_stcore`, `py_adx_mt5`) **non e' stato eseguito qui** ed e' calcolo, non backtest; lo propongo come "conteggio di sensibilita'" a costo CPU trascurabile.

**(d) Costo.** ADX ambito/spento: 2 celle x 14 = 28 passate (0,7-2,8 h). ATR: 2 celle x 14 = 28 (0,7-2,8 h). Periodo/soglia ADX: 3 celle x 14 = 42 (1,1-4,2 h) **solo se TUTTE mostra un effetto**. Tutto **condizionato a famiglia VIVA** e a driver nuovo.

**(e) Validazione.** IS >= 150: **le gambe "solo ST35" non ci arrivano mai** (ST35 ~25 setup/anno/simbolo x 7 simboli = ~175 l'anno in totale, al piu' ~88 per lato, e circa la meta' con il filtro di inclinazione P50). Quindi il filtro ADX sulla sola ST35 non e' valutabile per il MERITO a tick reali sull'IS: e' *sospeso per n*.
La cella TUTTE si valuta sulla gamba intera (>= 150). OOS una volta. Secondo regime: nessuno a tick.

**(f) Strada piu' corta.** Non spendere tick reali su periodo ADX e ATR prima che F1 dia una famiglia VIVA; sono i primi candidati a restare *default* (e' la risposta onesta).

---

## 4. Quale famiglia per prima, quale scartare (la risposta alla domanda (f))

**Non esiste una famiglia con "SENZA dubbio" piu' probabilita'.** Le cinque cose che contano, per famiglia:

| famiglia | costo con pedaggio di campo (anticipo/linea/profondo, LINEA) | n IS per lato (F1 `@F1-ATTESA`) | gemelli | prior di casa | puo' diventare sedia? |
|---|---|---|---|---|---|
| **XAUUSD** AUDIO_H1 | 99,7 / 79,8 / 59,8x **PASSA** | L 62 / S 38 (**SOTTILE**); intera finestra L 121 / S 84 (F1 r.102-103) | **NO** (argento: §3.3) | EMA200 oro H1 PF 1,17-1,18 n 687-891 OHLC (parente) | **No per T2** (1 solo simbolo); resta lettura descrittiva e di RISCHIO |
| **FX7** AUDIO_H1 | 37,4 / 30,0 / 22,5x EURUSD (**FRA**); AUDUSD/NZDUSD 45-52x solo con spread del tester | **L 475 / S 409** | si' (7) | forex Supertrend: nessuna tipologia superata | si', solo se il costo tiene a tick reali |
| **FX7** M2_H1 | uguale | **L 344 / S 284** | si' | rimbalzo EMA200 NULLO; 1 forex su 7 sopra 1 col parente | si', ma il prior dice "base = placebo" |
| FX7 H4 (AUDIO/M2) | uguale | L 117 / S 110; 68 / 55 (**SOTTILE**) | si' | idem | solo come rischio e per il certificato (casella 5) |
| IDX3 (SPX, 100GBP, 200AUD) | 14-18x in LINEA (**FRA**), 9-11x in GEOM (**ESCLUSO**) | L 140 / S 119 (**SOTTILE**) | si' (3) | motore EMA200: U30USD sopra 1 (ma escluso qui) | no: FRA per definizione (< 40x) |
| XAGUSD | senza contenuto (u = 1 USD) / <= 17x (u coerente) | n/d | n/d | SupertrendReversal XAG PF 0,51-1,28 su n 8-31 | no (§3.3) |

Ragionamento, in ordine, **con la sua smentita**:
1. **P e' il prerequisito di tutto, non una scommessa**: l'EA v1.11 non e' mai stato compilato e il ramo ordini non e' mai stato eseguito (F1 r.208-211). Senza P nessun numero ha senso.
2. **Il primo numero di MERITO viene da FX7 H1** (AUDIO_H1 e M2_H1), perche' sono le uniche gambe che arrivano a n >= 150 per lato nell'IS. E' li' che si puo' ottenere un VIVO o un PERDENTE MISURATO.
   Dentro FX7 si parte da **EURUSD, AUDUSD, NZDUSD** (costo migliore: 44-52x sull'anticipo col tester; EURUSD 37,4x col campo, che e' l'unico dei tre con spread vivo). Smentita di questa scelta: se lo spread del riempimento a tick reali fa scendere AUDUSD/NZDUSD sotto 40x sull'anticipo, il vantaggio sparisce e restano FRA come gli altri.
3. **L'oro serve a un'altra cosa**: e' l'unico posto dove il costo NON e' l'obiezione (59,8x anche sul profondo) quindi dice se la *meccanica* (scala, TP, stop, durata) fa quello che dovrebbe e quanto vale il rischio in R. Non puo' dare merito (n) ne' VIVO (un simbolo).
   **Se il PF_R dell'oro in LINEA/PIU sta sul nullo (0,93-0,98) non e' una prova di assenza di edge** (n < 150, un regime toro): e' "NON DISTINGUIBILE/SOSPESO".
4. **Prior a sfavore**: il rimbalzo al primo tocco della EMA200 e' nullo su H4 forex 2005-2020; i parenti forex sono quasi tutti sotto 1. Non e' un motivo per non misurare (certificato di morte) ma e' l'attesa scritta: **base M2 non distinguibile dal placebo**. Se esce diversa, prima si cerca l'errore, poi si festeggia (SPE r.703-704).
5. **Da scartare PER COSTO col numero** (non da misurare): vedi §3.4 (f): GEOM su forex (22,5 / 15,0 / 7,5x EURUSD), EURNZD 8,3x, GBPNZD 4,9x, E35EUR 3,7x, 225JPY 1,7x, E50EUR 9,3x, U30USD/F40EUR 10,0x in LINEA.
   **Da scartare per SCALA/PROFILO, non per costo**: XAGUSD (56-130 ATR), gli indici in PIU (pareggio fino a 97,8%).
   **Da NON scartare** (il verdetto e' "non ancora misurato"): D1/H12 (non per costo ma per n: 28-52 e 17-29 setup per simbolo in 1,99 anni; in famiglia 461 e 252 su 11 forex), NASUSD/D30EUR (fuori scala S2, 0,16-0,18 ATR: domanda, non esclusione).

---

## 5. Il pilota F1 (P) e il piano di passate

### 5.1 Cosa misura P (F1 r.294, `RIGA_LANCIA_NATCLA_F1_P.txt`)

4 passate singole, Modello 4 (tick reali), finestra IS (fino al 30/06/2025), deposito 1.000.000 EUR, 0,25% di rischio per setup (segnaposto), nessun ordine fuori dal tester:

| # | passata | cosa prova | n atteso (banda A1 x0,5-2,0) |
|---|---|---|---|
| 1 | XAUUSD AUDIO_H1 LONG GEOM | prima esecuzione del ramo ordini (scala, TP, SL, export CSV), costo oro | 62 (31-124) |
| 2 | XAUUSD AUDIO_H1 LONG PIU | selezione ST3,5/EMA200, scarti di stop | ~58 (53-62: 0,85-1,00 x cella 1; V111) |
| 3 | EURUSD AUDIO_H1 SHORT LINEA | lato short, stop LINEA, costo forex FRA, spread di riempimento | 61 (30-122), ~52-61 in LINEA |
| 4 | EURUSD M2_H1 SHORT GEOM | motore M2 | 39 (20-78) |

- **Verifica della colla** (non del merito): righe SETUP riempite = operazioni del report entro -3 (driver `NATCLA_F1_PASSATE.ps1` r.43-47), somma dei soldi del CSV = profitto del report entro 2 rischi, lato e modo giusti, riga `VERIFICA ADX` MetaQuotes, R degli stop pieni a -1 (banda mediana [-1,10 ; -0,85], classe 1214), nessuna riga "lotto sotto il minimo", nessun `INVIO FALLITO` 10019.
- **Determinismo**: le 4 passate sono rigirate in O e FA; il lettore le conta una volta (classe 1212).
- **Non risponde a niente di merito**: n = 39-62 per cella, SOTTILE per T1. Se PF_R esce 1,5 o 0,6 su 40 setup **non vale niente**.

### 5.2 La riga di P e' pronta?

| controllo | esito oggi |
|---|---|
| `controlla_prova.py` sul file F1 | **OK** (74 pin, asse tecnico, 4 passate; rieseguito il 10/10) [MISURATO] |
| `controlla_riga.py --oggetto riga` su `RIGA_LANCIA_NATCLA_F1_P.txt` | **"nessun difetto meccanico"**, 5 rilievi da leggere a mano (menzioni di `C:\MT5_Backtest`/`BCM_Reale`/`50504263`/`10105439` dentro stringhe di GUARDIA, e che la riga "puo' terminare un processo": chiude il banco) [MISURATO] |
| bersaglio dichiarato nella riga | finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`, terminale BCM `50503392` di QUELLA macchina; NON tocca `C:\MT5_Backtest`, `C:\FundedNext_Manuale`, il VPS e tutte le sue cartelle (regola 12/09) [letto] |
| strato 2 (`controllo-preventivo`) su driver + riga P | **non trovo in repo un PASS**: l'ultimo commit di cancello sul giudizio F1 e' `2453bfe8` "WIP ... NON pronto"; le classi CHK 1211-1215 documentano difetti trovati e corretti (lettore e righe O/FA/FB/I) **[NON VERIFICATO da me]** |
| pin e SHA | `PIN=f2d47079...`; il lettore a HEAD e' cambiato rispetto a quel pin (+140 righe), ma la riga non scarica il lettore: nessun effetto sulla passata |
| compilazione di v1.11 | **mai fatta**; il driver si ferma prima del tester con lo zip del log di MetaEditor se fallisce (F1 r.208-211) |
| tempo | 8-32 min + compilazione 1-3 min [STIMA, ancora R290A: 154,9 M tick = 12 min]; tick per passata forex [NON MISURATI], oro [NON MISURATO] |

**Quindi**: la riga P e' *scritta e meccanicamente pulita*, **NON e' consegnabile a Claudio finche' il cancello di giudizio non da' un PASS esplicito** (regola 09/09). Cosa manca: (1) il PASS dello strato 2 sul driver e sulla riga; (2) PC di backtest libero (MT5 e MetaEditor chiusi, nessun altro giro F0/F1/GBA vivo); (3) per i lotti dopo P: il suo `RIEPILOGO_F1.txt`/`MANIFEST_F1.csv` con lo stesso pin.

### 5.3 Il piano di passate (con costo)

Tempi per passata [STIMA, F1 r.181-190; ancora unica misurata: R290A]: forex 1,5-6 min (centro ~2,5); oro 2,5-10 (~5); indici 2-8 (~4). **P misura i numeri veri**: riaggiornare la tabella dopo P.

| passo | cosa | passate | tempo [STIMA] | note |
|---|---|---:|---|---|
| **P** | pilota | 4 | 8-32 min | prerequisito |
| **O** | oro, 4 config x 2 lati x 3 modi (M2: 2) | 20 | 50-200 min | rischio e meccanica; merito SOSPESO |
| **core H1** | FX7 x AUDIO_H1 (3 modi x 2 lati = 6) + M2_H1 (2 x 2 = 4) = 10 per simbolo | **70** | 1,8-7,0 h | prima misura di MERITO |
| FX7 H4 | AUDIO_H4 + M2_H4 = 10 per simbolo | 70 | 1,8-7,0 h | **dopo** il core; serve al certificato (casella 5) e al rischio; n SOTTILE |
| I (IDX3) | SPXUSD/100GBP/200AUD, LINEA e PIU | 36 | 72-288 min | per ultimo; FRA per definizione |
| **totale piano scritto** | P + O + FA(80) + FB(60) + I | 200 | ~5,7-23 h, centro ~10 h | F1 r.186-190 |
| **totale proposto (P + O + core)** | | **94** | **~2,7-10,9 h** | H4 forex e indici rimandati |

- **Perche' ridurre**: FA+FB sono 140 passate di cui la meta' (H4) non puo' mai arrivare a n >= 150 per lato (117/110 e 68/55). Si rimandano, **non si cancellano** (il certificato le richiede prima di scrivere MORTO).
  *Costo di questa scelta*: servono un lotto nuovo (blocco `@F1-LOTTO`) -> file prova nuovo -> SHA/pin/riga nuovi -> cancello. Se si preferisce zero modifiche, FA e FB interi si lanciano come scritti.
- **F2 (condizionato, T8: assi pieni SOLO sulle gambe VIVE; sulle altre solo le due celle d'uscita del certificato A1/A9)**. Tre livelli per informazione/passata, ogni cella = 14 passate su FX7-H1 (1,5-6 min): 

  | livello | celle | passate | tempo [STIMA] |
  |---|---|---:|---|
  | 1 | **placebo** (linea spostata di 1 ATR; E7), ADX spento, ADX TUTTE, tocchi illimitati (A4), SFIORA (A3), TP DAL_RIEMPIMENTO (A1), durata 60 (A9) | 7 x 14 = 98 | 2,5-9,8 h |
  | 2 | stop al costo minimo, linea solo ST2,5, solo ST3,0, inclinazione spenta / P25 / P75 | 6 x 14 = 84 (+ CONCORDE 14) | 2,1-8,4 h |
  | 3 | scala (10,5) e (5,10), ATR 7 e 14, TP 20 | 5 x 14 = 70 | 1,8-7,0 h |
  | (ultimo) | periodo ADX 10/20, soglia 25 | 3 x 14 = 42 | 1,1-4,2 h |

  Il **placebo viene prima di qualunque parametro** (E7: "la linea conta, non solo un ritracciamento qualsiasi"): se il placebo guadagna come la linea vera, stringere un parametro sulla linea e' misurare rumore.
  Se **nessuna** gamba e' VIVA: F2 si riduce alle celle d'uscita (A1, A9) = 28 passate = 0,7-2,8 h, e il verdetto e' "NON ANCORA MISURATO" (non morto: manca il resto del certificato).
- **Collo di bottiglia ingegneristico (cosa MANCA)**: il driver F1 sostituisce solo `InpModalita, InpTF, InpDirezione, InpStopModo, InpInclMinAtr` e **blocca** per nome gli altri (`NATCLA_F1_PASSATE.ps1` r.98, r.341-345; esce con errore se un pin cambia). Per gli assi di F2 serve un driver nuovo che
  (i) legga l'asse dal file prova e lanci una passata singola per cella, (ii) abbia il Modello come parametro (serve anche per la **calibrazione OHLC contro tick** di §6: 4 passate, ~33 s ciascuna in SoloConta nei lotti F0; con ordini [NON MISURATO]), (iii) abbia finestra OOS/storica come parametro. **E' un cambiamento al driver = pin nuovo + collaudo + cancello**, non una riga.
  Strada alternativa scartata: il driver dei round con `OptFrame` (PF per DEAL, non per setup: n gonfiato fino a 3x e nullo falso; F1 r.17-24).

---

## 6. Validazione: IS, OOS, regime, altopiano

### 6.1 Cosa c'e' e cosa no
- **IS** (dal pavimento tick al 30/06/2025): FX7 AUDIO_H1 L 475 / S 409; M2_H1 344 / 284 (sono setup di F0 con inclinazione >= P50; F1 r.97-98). Oro, indici, tutto H4: SOTTILE.
- **OOS** (01/07/2025-30/06/2026): una volta in F3, su celle scelte sull'IS col centro dell'altopiano. Setup attesi ~700-900 in FX7 AUDIO_H1 [DERIVATO: 7 simboli x ~454 setup senza filtro (P0 r.35) x ~0,5 per il P50 = ~1.590 sull'intera finestra, oppure 2 x 884 dell'IS = ~1.770; meno 884]. Stesso regime dell'IS (toro oro e indici; dollaro debole sul forex): **non e' un OOS di regime**.
- **Secondo regime a tick**: **non esiste** (tick BCM dal 05/07/2024 forex, 10/07/2024 oro, 26/09/2024 indici). Lo screening di regime e' OHLC su M1 (forex dal 01/01/2010, oro H1 dal 2004, Nasdaq `NASUSD_EXT`): **mai verdetto, puo' solo bocciare** (SPE r.562-566; Firma 1 punto 5).
- **Prima di fidarsi di un OHLC su NatCla serve la calibrazione**: il rapporto PF_OHLC/PF_tick di casa e' 1,72-3,51x su altri motori (SPE r.442); per NatCla (limit e TP di 10 u dentro la stessa barra M1) la direzione dell'errore e' **[NON MISURATO]**. Rigirare le 4 passate di P a Modello 1 costa pochi minuti (~33 s a passata in SoloConta; con ordini [NON MISURATO]) ma **richiede il Modello come parametro nel driver nuovo**.
  *Soglia scritta ora*: una cella viene BOCCIATA dallo screening OHLC solo se PF_R < 1,00 su >= 150 setup (OHLC gonfia, quindi < 1 e' piu' severo di quanto sembri); un OHLC > 1 non vale niente.
- **Orologio**: H4 forex = due orologi dentro l'IS (F0A r.36); H1 invariante. Se una gamba H4 forex e' VIVA, la si rilegge separata prima/dopo il cambio (meta' sotto 150 -> NON MISURATO).

### 6.2 Per ogni asse
| asse | IS >= 150? | OOS vero | secondo regime | altopiano |
|---|---|---|---|---|
| direzione (lato) | solo FX7 H1 | si' (F3) | no a tick; deriva opposta fra simboli come esperimento naturale | n/a |
| modo di stop | solo FX7 H1 | si' | no | discreto (3 modi); T5 con nullo stampato |
| stop al costo minimo | solo FX7 H1 | si' | no | 3 punti (20 / min / intermedio): centro se monotono |
| ancora TP, durata | solo FX7 H1 | si' | no | binario |
| distanza TP | solo FX7 H1 | si' | no | 2 punti, nessun centro: **cella singola, non si 'sceglie'** |
| ADX ambito/spento | si' (gamba intera) | si' | no | binario |
| periodo ADX, soglia | **no** (ST35 ~88 per lato) | n/a | n/a | SOSPESO per n |
| ATR {7,10,14} | solo FX7 H1 | si' | no | 3 punti: centro 10 se plateau |
| inclinazione P25/P50/P75 | solo FX7 H1 | si' | no | 3 punti: centro P50 (e' il default di F1) |
| placebo | solo FX7 H1 | si' | no | confronto, non asse |

### 6.3 Il default
Per ogni asse si scrive *accanto* se la cella e' migliore del default (DALLA_LINEA, 10 u, ADX MetaQuotes 14 solo ST35, ATR 10, P50, scala (5,5), LINEA 20 u). **Se il guadagno e' dentro il rumore del nullo (delta < 0,10 di PF_R, T5) la risposta e' "il default va bene".**

### 6.4 Cosa NON propongo, e perche'
- **Griglie fitte** su ADX/ATR/tocchi/soglie: nessuna (regola 19/08). Su una famiglia NON DISTINGUIBILE gli assi di F2 non partono.
- **Meccanismi d'uscita fuori fonte** (trailing sul Supertrend, uscita al flip, parziali 25/33/75, BE): mai provati sulla famiglia (Tabella B), ma **non sono nelle regole della collega** e la v1.04 li rifiuta (manopole PDF). Aprirli = modifica EA + decisione tua (fedelta' o misura). Li tengo come **F2-bis**, solo se una famiglia e' VIVA e solo come misura dichiarata "NatCla-piu'".
- **Geometria in ATR** (TP e stop in multipli di ATR) per rendere confrontabili oro, indici e argento: stesso discorso.
- **Argento**: fuori (§3.3).

---

## 7. Manopole che rischiano di essere INERTI (ricerca a priori, perche' F0 non ha mai variato niente)

Il censimento del 09/09 ha trovato 874 CSV su 1.960 con esiti identici: manopole girate senza che mordessero. Per NatCla non c'e' storia da leggere; ecco dove e' *prevedibile* un asse inerte, **da dichiarare prima di spendere passate**:
- `InpAdxPeriodo`, `InpAdxMax`: agiscono sulla sola ST35 (~10% dei setup finali) e, su H4, su 1-5 episodi l'anno. **Alto rischio di inerzia** (§3.5).
- `InpDurataMaxMin` = 60: morde solo se la durata mediana supera i 60 min; se E1 dice <= 60 con grande margine l'asse e' inerte. Si decide dopo F1 leggendo la durata, non a priori.
- `InpScalaAnticipo/Oltre` (10,5): con `DALLA_LINEA` e anticipo 10 il TP dell'ordine d'anticipo sta a distanza 0 e l'ordine **non viene piazzato** (SPE r.197, X5): la manopola *morde togliendo ordini*, non spostandoli. Va letto nell'imbuto (`ordini scartati`), non nel PF.
- `InpStopOltreU` con **LINEA**: non cambia nulla del TP; cambia solo costo e pareggio.
- Controllo del cancello F1 per tutti gli assi: la **somma delle righe SETUP deve cambiare** fra due celle; se due celle hanno SHA dei CSV identici, la manopola e' inerte e la cella **non conta come "provata"**.

---

## 8. Buchi dichiarati / cosa NON ho verificato

- **Non ho eseguito niente**: nessun backtest, nessun script del repo, nessuna compilazione; solo lettura, grep, `controlla_prova.py`, `controlla_riga.py --oggetto riga` e un calcolo binomiale/aritmetico (§A).
- **Non ho ricalcolato** i numeri dei referti F0/V110/V111 dai CSV originali: li cito come scritti, con file e riga. Le tabelle di costo (§3.2, §3.4) sono mie **derivazioni** dei pedaggi di SPE §5.3 e di V111 par. 4b; l'ancora x1,25 sull'anticipo assume lo stesso pedaggio dell'ordine sulla linea.
- **Spread vivo**: solo 8 simboli (5 giornate, 04-11/09/2026). AUDUSD, NZDUSD, USDCAD, USDCHF, SPXUSD, 100GBP, 200AUD: spread **[NON MISURATO]**; qualunque verdetto di costo su di loro e' del tester (ottimista).
- **Commissione**: derivata (forex 0,004% del prezzo, oro 0,04 USD/oncia) nei referti F0; il tester BCM l'ADDEBITA sul forex (GBPUSD M5, CCOMM_R258) e non sugli indici [MISURATO su altri report]; per l'oro **[NON MISURATO]**.
- **Stato del cancello su driver/riga P**: non trovo un PASS in repo [NON VERIFICATO]; non ho invocato `controllo-preventivo`.
- **Priori di casa**: provengono da motori con uscita diversa (trailing, parziali) e, per il censimento, da celle "unica" (una corsa) con deal e non setup. Sono contesto, non confronto.
- **EURGBP**, **U minimo per tutta la scala**, **ATR del Supertrend con RMA contro SMA**, **conteggio di sensibilita' ATR/ADX**: ipotesi [POST-HOC] o calcoli non eseguiti.
- **Tempo macchina**: l'unica ancora cronometrata su questo PC e' R290A (154,9 M tick = 12 min); numero di tick per passata forex/oro/indici nella finestra IS **[NON MISURATO]**. Le stime di §5.3 sono ancorate, non misurate; P le misura.
- **Il "PF_V" dell'incarico**: ho usato PF_R (per setup in R) come nel lettore F1; il PF_V del GBA e' un altro lettore.
- **Nessun file prova nuovo**: il file F1 esiste e passa `controlla_prova.py`; i file prova degli assi di F2 dipendono dal driver nuovo (§5.3) e dai numeri di F1, quindi non li scrivo ora (le soglie e le attese sono gia' qui, prima dei numeri).
- **Registro**: le esclusioni per costo di §3.4 (f) non sono 'morti': quando si archivia F1 vanno in `REGISTRO_TEST.md` come ESCLUSO PER COSTO col numero e con la casella mancante del certificato.
- Il file `RIGA_LANCIA_GBA_R2_SENZA_CODICE.txt` risulta modificato nel working tree: **non e' mio e non lo committo**.

---

## 9. Decisioni che servono a Claudio (solo quelle vere)

1. **TF sotto H1 (M30): si o no, come deviazione dichiarata dalla fonte?** La fonte dice "non sotto H1" (AUD R8/R9) e l'EA rifiuta (EA r.1139: `TF sotto H1: vietato dalla fonte`). Il cancello del costo **non** lo esclude: lo stop e' in unita' fisse, quindi stop/pedaggio non dipende dal TF
   (quello che cambia e' quanto la linea sta vicina al prezzo). Il vantaggio e' il campione: i setup crescono con il numero di barre (atteso circa x2 su M30 [STIMA ancorata: da H1 a H4, 4 volte meno barre, i setup forex passano da 5.089 a 1.225, cioe' x4,15, F0A r.14-15; sull'M30 **NON MISURATO**], misurabile con un conteggio F0 da ~33 s a passata dopo una modifica minima dell'EA).
   E' la leva piu' diretta sul muro dei 150 (oro: 121 / 84 su tutta la finestra). Costo: modifica dell'EA (cancello) e perdita di fedelta' alla collega. E' la domanda "fedelta' o misura" di SPE r.655-657, che nessun backtest decide.
2. *(Condizionata, non ora)* **Se il numero lo dira'**: (a) LINEA e PIU entrambe VIVE e NON DISTINGUIBILI (T5) -> scelta tua; (b) una cella "stop al costo minimo" o "TP 20" batte il default di piu' del nullo -> seguire la misura o restare sulla lettera della collega; (c) rischio e taglia: il backtest consegna `r_max` in R, il rischio per setup (0,25% segnaposto) lo firmi tu.

**Non servono decisioni tue su**: direzione, stop numerico, pip/punti, orari, ADX tipo (gia' risposte); argento (default: fuori da F1, §3.3); simboli (decide il costo); periodi ADX/ATR (default finche' i dati non dicono altro); riduzione del piano a 94 passate (e' una proposta operativa mia: se la vuoi la preparo e passa dal cancello, altrimenti si lancia il piano scritto).

---

## A. Appendice - i calcoli rifatti qui (nessun backtest)

Modello: passeggiata casuale senza edge, probabilita' di toccare il TP prima dello stop `p = SL/(TP+SL)`, vincita `TP - c`, perdita `SL + c`, `c` = pedaggio; PF su `n` prove indipendenti con la binomiale esatta.
Ordine sulla linea, TP 10 u, c = 0,667 pip (EURUSD) o 0,25 USD (oro):

| cella | p nullo | PF nullo | pareggio | P(PF >= 1,15) n=150 | n=300 | 95-esimo percentile PF n=150 / 300 |
|---|---:|---:|---:|---:|---:|---|
| EURUSD stop 20 | 0,667 | 0,903 | 0,689 | 9,6% | 2,8% | 1,20 / 1,11 |
| EURUSD stop 32 | 0,762 | 0,914 | 0,778 | 11,5% | 5,1% | 1,30 / 1,17 |
| EURUSD profondo (stop 15) | 0,600 | 0,894 | 0,627 | 7,7% | 1,9% | 1,19 / 1,09 |
| EURUSD GEOM linea (stop 10) | 0,500 | 0,875 | 0,533 | 4,3% | 0,9% | 1,14 / 1,06 |
| oro stop 20 | 0,667 | 0,963 | 0,675 | 17,1% | 7,8% | 1,28 / 1,18 |

(Il confronto con SPE r.606: TP 10 / stop 27, c = 0,67 -> PF nullo 0,910, P(>=1,15) 13,3% / 4,9%: i miei numeri interpolano.) Sono per ORDINE singolo e prove indipendenti; il PF per SETUP (3 ordini che condividono linea e stop) ha un nullo piu' alto (CHK r.38025) e **meno prove indipendenti**: la soglia vera e' piu' alta di questa. Il 95-esimo percentile e' il PF sopra il quale cade il solo caso nel 5% delle prove.

U minimo = 5 + 40 x pedaggio: EURUSD 31,7; GBPUSD 38,8; USDJPY 41,6; oro 15,0 (pedaggi di SPE r.464-471: 0,667 / 0,845 / 0,915 / 0,2507).
Costo ordini LINEA = (U + 5, U, U - 5) / pedaggio con U = 20; GEOM = (15, 10, 5) / pedaggio.
Argento: ATR14 H1 = 20/130 = 0,154 USD; pedaggio = 20/434,8 = 0,046 USD [da V111 r.144, r.221-225]; u massimo nella banda S2 = 0,317/10 = 0,032; stop 20 u = 0,63 USD -> 13,8x; anticipo 25 u -> 17,2x.
