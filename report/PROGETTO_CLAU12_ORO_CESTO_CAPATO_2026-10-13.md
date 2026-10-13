# PROGETTO CLAU12_ORO_CESTO_CAPATO (13/10/2026): la versione NOSTRA, CAPATA, del meccanismo osservato di «Arena Nexus Grid Smart XAU MT5 1.20»

Richiesta di Claudio (13/10/2026): _«PROCEDI CON LA VERSIONE NOSTRA CAPATA»_. Fonti: `report/MARKET_SCHEDA_FINLABX_CF_DZR_2026-10-13.md`, `report/MARKET_MOTORE_FINLABX_RICOSTRUZIONE_2026-10-13.md`, `docs/MARKET_EA_CENSIMENTO.md`, `docs/gemini/PROTOCOLLO_MARKET_2026-10-13.md`, `data/statements/ReportHistory_50503392_2026-10-13.xlsx` (SHA256 `2e4624c0…`, rianalizzato in sola lettura con `backtest_pipeline/analisi_cesti_commento_cid.py`: numeri identici alle schede). L'EA del venditore e' una **scatola nera**: nessun sorgente, nessuna decompilazione. Il codice di questo progetto e' **nostro**, scritto da zero nello stile di `ABTG_GoldBreakoutATR.mq5` v1.10.

**Consegna:** `mql5/Experts/CLAU12_ORO_CESTO_CAPATO.mq5` (v1.00, magic **775600**), `backtest_pipeline/prove/C12OC_A_AVVIO_2026-10-13.txt` (file prova, stadio A), questa specifica.
**Stato:** EA **mai compilato in MQL5** (MetaEditor assente qui), **mai girato nel tester**, **nessun PASS** del cancello. Niente in forward: e' uno strumento di misura per lo Strategy Tester. **Nessuna taglia proposta**: lotto base 0,01 (quello osservato), tetto di rischio per cesto = input **spento**, da decidere con Claudio.

Etichette: **[LETTO]** nel conto o nel pannello · **[INFERITO]** · **[PROXY]** = simulazione mia a barre M1 HistData, NON il feed BCM e NON il tester · **[NON MISURATO]** / **[NON VISTO]**.

---

## 0. In tre righe, scritte PRIMA del tester

1. **Il punto debole e' l'avvio**: il segnale che fa nascere un ciclo nell'EA del venditore **non si vede** [NON VISTO]. Qui ci sono due avvii semplici nostri (ROTTURA e RITORNO) e un **CONTROLLO NULLO** a istanti e lati pseudo-casuali, con la stessa identica struttura di cesto.
2. **L'attesa (proxy, 5 anni di M1 reali):** con la coda capata **tutto** fa PF per cesto **0,61-0,77**: rottura, ritorno, nullo (3-5 semi), direzione casuale, senza media (L=1), in tutte le 9 celle profondita' x passo e in tutti e tre i regimi; alzando il target a 2 o 4 USD sale a 0,78-0,91, sempre col nullo alla pari. **Non si distingue dal nullo, e il nullo non si distingue dal random walk.** Il motivo e' meccanico: il target di +1,00 USD sta **sotto la frontiera del costo di un fattore 8-10** (target/(spread+commissione) = 4,0x).
3. **Cosa togliamo capando:** nel proxy una versione "come il venditore" (15 livelli, lotti che salgono fino a 8x) ha il **giorno mediano positivo** (+180 USD a lotto base 0,01 in IS, 209 giorni verdi su 283): e' quello che si vede sul conto. Ma ha PF 0,53-0,83 e un **giorno peggiore da -3.100 a -12.000 USD**. Il +487 EUR del 13/10 e' **un giorno della meta' buona di una distribuzione con la coda sinistra lunga**. Il tester a tick reali serve a confermarlo o a smentirlo **a costo basso** (stadio A, 3-5 ore stimate).

---

## 1. Il meccanismo in parti: osservato / ipotesi / scelta nostra

| parte | osservato (fonte) | ipotesi | scelta nostra e perche' |
|---|---|---|---|
| **tipo di ordine** | tutti **pending STOP**, riempiti in 10-28 s mediani [LETTO, ricostruzione §1] | i livelli `[R]` aspettano un piccolo rimbalzo (trigger 0,2 = `InpCounterFlowTriggerPrice`) [INFERITO, non provato] | **ordini a mercato** su livelli virtuali, con il Guardian **immediatamente prima** di ogni invio. Un pendente piazzato quando il cap C1 era libero scatta lo stesso (`ABTG_PausaGuardian.mqh`, «cosa NON fa»): con una scala di ordini e' esattamente il rischio da non avere. Il rimbalzo prima dell'ingresso **non** si replica (non e' osservabile come regola): asse futuro, se serve |
| **avvio del ciclo** | [NON VISTO] | -- | **tre modi** (§3): ROTTURA, RITORNO, NULLO, piu' `InpDirezioneCasuale` |
| **moduli `[F]`** | TP fisso +1,00 USD (379 su 379), lotto 0,01, max 1 viva per lato; **in perdita** nel giorno (-54 EUR) [LETTO] | la "scintilla" del ciclo [INFERITO] | **non replicati come modulo a parte**: il nostro livello 1 con TP = P1 + 1,00 e' la stessa scommessa, **con SL**. La cella `InpLivelliMax=1` e' il `[F]` capato |
| **scala `[R]`** | stop nella stessa direzione a prezzo peggiore, ogni 5 min mediani, passo mediano **1,46 USD** (p10 -2,15, p90 +3,22) [LETTO] | il passo e' interno e variabile [NON VISTO] | griglia **fissa** da P1: livello k a P1 -/+ (k-1) x passo; passo = input, **asse 1,0 / 1,5 / 2,0**. Finestra di mezzo passo: dopo un gap il livello si **salta**, mai ammucchiato vicino allo SL |
| **lotti** | 0,01 -> 0,02 -> ... livello 5 ~0,03, livello 10 0,05-0,08, fino a 0,17 [LETTO] | scala ~ +0,5 x base per livello [INFERITO dai mediani] | default **PIATTA** (incremento 0); asse 0,5 (l'osservato) con **tetto 3x** e massimo assoluto 5x nel codice. Mai raddoppi |
| **profondita'** | 1:36, 2:15, 3-4:17, 5-9:9, >=10:3 cesti; il 3,75% profondo fa il 24,5% del profitto `[R]` [LETTO] | il tetto del venditore e' interno [NON VISTO] | **TETTO** = input, **asse 3 / 4 / 6** (piu' la cella **1** = nessuna media) |
| **uscita** | tutte insieme a **media ponderata + 1,19 USD** mediani (p10 -0,40, p90 +3,30) [LETTO, 24 cesti] | target "media + ~1 USD" [INFERITO] | **TP comune sul server** = media ponderata +/- `InpTargetUSD` (1,00), rimesso a ogni livello. Se il prezzo e' gia' oltre il target, chiusura a mercato (`SUP`) |
| **SL** | **assente all'ingresso** (122/132 e 93/97 `[R]`), arriva dopo e si sposta; 5 cesti su 24 usciti a SL [LETTO] | -- | **SL di cesto sul PRIMO ticket**, uguale per tutti i livelli: P1 -/+ ((Lmax-1) x passo + `InpSLOltreUltimoUSD`). Fisso. Nessuna posizione nasce senza SL |
| **lati** | `GOLDPULSE_BOTH_SIDES`, Buy 1 / Sell 1 vivi [LETTO] | -- | un cesto per lato; `InpDueLatiInsieme=false` = uno solo in tutto |
| **weekend** | `InpFridayGapProtection = false` [LETTO] | il rischio di gap e' **non cappato** | **chiusura prima di OGNI pausa di sessione** (giornaliera e weekend), dalle sessioni del simbolo, piu' il tetto del venerdi' (§2, difetto D6) |
| **spread** | 0,20 USD sul pannello [LETTO] | -- | filtro 0,40 su avvii e livelli nuovi |
| **intervento manuale** | pulsanti BUY/SELL/CLOSE ALL [LETTO] | qualcuno puo' averli premuti [NON VISTO] | nessun pulsante: l'EA parla solo col giornale |

## 2. I difetti tolti (scheda §4) e dove sono nel codice

| difetto | correzione | dove (funzione / input) |
|---|---|---|
| D1 nessuno SL all'ingresso | SL di cesto sul primo ticket, ripetuto su ogni livello, riparato se manca | `C12SLCesto`, `C12Apri`, sincronizzazione in `C12GestisciLato` |
| D2 rischio non cappato (28 posizioni, 1,18 lotti vivi) | tetto di profondita', tetto di lotto per livello, rischio pianificato calcolato **prima** del primo ticket, tetto in valuta (input) | `InpLivelliMax` (1..10), `InpScalaTettoMult` (1..5), `C12RischioPrezzoLotti`, `InpRischioMaxCesto` |
| D3 scala di lotti crescente | default piatta; crescita **lineare** e cappata solo come asse | `C12LottoLivello`, `InpScalaIncremento` (0..1) |
| D4 costo contro il target | dichiarato e **misurato per cesto** (non si puo' togliere: e' il cuore del meccanismo) | riga `[C12OC-AVVIO]`: `sl_su_spread`, `target_su_spread` |
| D5 pendenti che scattano senza Guardian | ordini a mercato, Guardian prima di **ogni** invio, mai sulle chiusure | `C12Apri` (2 invii, entrambi preceduti da `ABTG_GuardiaIngresso`) |
| D6 **gap del weekend e della pausa giornaliera** | chiusura `InpPausaChiudiMin` (90) minuti prima della fine della sessione in corso, niente cesti nuovi da `InpPausaStopNuoviMin` (120); il venerdi' la fine e' tagliata a `InpVenerdiFineMax` (22, ora server) | `C12LeggiSessioni`, `C12FineSessioneCorrente`, `C12TettoVenerdi`, `C12StatoPausa` |
| D7 hedging dentro la famiglia | dichiarato: con `InpDueLatiInsieme=true` lungo e corto possono convivere (rischio simultaneo = 2 x pianificato, stampato all'avvio). Conto netting = l'EA si ferma | `C12LatoLibero`, `OnInit` |
| D8 attribuzione dubbia (pulsanti manuali) | nessun pulsante, ogni cesto ha la sua riga `AVVIO` e `CESTO` | giornale |

**D6 nasce da un contro-esempio misurato, non da un principio.** Nella prima versione chiudevo il venerdi' alle 22:30 server. Nel proxy i cesti con perdita **oltre** quella pianificata (fino a -250 USD contro -41 pianificati, a 0,01 lotto) erano **tutti gap**: weekend (ultima barra del venerdi' alle 21:59 server d'estate: la mia 22:30 arrivava **dopo** la chiusura del mercato), pausa giornaliera (21:59 -> 23:00) e buchi di dati HistData. Con la regola delle pause i cesti oltre il pianificato scendono a **0-1 per cella in IS** e **0-9 in OOS** (15 mesi). Classificati alla cella centrale: nel VECCHIO **26 su 26** seguono un buco di almeno 30 minuti nei dati HistData; in OOS 2 (ROT) e 5 (NUL), gap piccoli all'apertura di una barra o un salto di 3 USD in un minuto (§6.4). **Il tetto delle 22:00 il venerdi'** viene dall'orologio misurato (BCM UTC+1 fisso; l'oro chiude alle 17:00 New York = 22:00 server d'estate, 23:00 d'inverno): vale in tutte e due le stagioni anche se le specifiche del simbolo non seguono l'ora legale. **Non e' un'ora d'ingresso**: e' una rete. Con 24 e' spento.

**Regola di casa che resta, e va detta:** con `InpLivelliMax > 1` questo resta un cesto che **media a prezzo peggiore** (scheda §4: _"proibita per la challenge di casa"_; protocollo §5). Capato e con SL, ma resta una media. **Questo EA e' uno STRUMENTO DI MISURA**, non una sedia. Se mai un avvio mostrasse un effetto, la candidata schierabile sarebbe la cella **`InpLivelliMax=1`** (un ingresso, SL e TP fissi), e anche quella passerebbe da una firma di Claudio.

## 3. Il segnale d'avvio: il punto debole, e il controllo nullo

Non sappiamo come nasce un ciclo nell'EA del venditore, ne' come sceglie il lato. Non lo indoviniamo: mettiamo ad asse **due meccanismi opposti** e un nullo.
- **ROTTURA (modo 1)**: alla chiusura di una barra M1, close **strettamente** sopra il massimo delle 20 barre precedenti (esclusa la barra di segnale) -> cesto lungo; sotto il minimo -> corto. **Momentum.**
- **RITORNO (modo 2)**: close oltre EMA50 +/- 2 x ATR14 (M1) -> cesto nel verso del **ritorno** alla media. **Mean reversion**: e' la scommessa implicita di una griglia, allineata fin dal primo ingresso.
- **NULLO (modo 0)**: a ogni barra M1 il cesto parte con probabilita' p, lato a moneta. Il generatore e' un mescolatore a 32 bit con **chiave = ora della barra** (non un contatore): lo stesso seme da' gli stessi istanti qualunque cosa sia successo prima (cesti vivi, riavvii). **p = 0,25** fissata il 13/10 dalla **frequenza dei segnali** dei due modi nel proxy IS (0,127 e 0,378 per barra), mai da un PF. Il generatore dell'EA e quello del proxy sono **lo stesso**: 80.000 estrazioni confrontate, 0 differenze (§13, CE3).
- **DIREZIONE CASUALE** (`InpDirezioneCasuale`, secondo controllo): gli **stessi istanti** del modo 1 o 2, con il lato a moneta. Separa "l'istante conta" da "il lato conta".

**Lettura:** se ROTTURA e RITORNO non si staccano dal NULLO, l'"edge" del meccanismo osservato e' il **payoff della griglia** (tante vincite piccole, poche perdite grandi), non un motore. Il confronto e' **PER CESTO** (PF per cesto, netto medio per cesto): il nullo fa piu' cesti (proxy IS 23.627 contro 19.599 e 12.903), quindi il netto totale non si confronta.

## 4. Parametri (tutti input; nessuna taglia)

| input | default | asse / uso | perche' |
|---|---|---|---|
| `InpModoAvvio` | 1 | **0 / 1 / 2** (stadio A) | §3 |
| `InpDirezioneCasuale`, `InpSemeNullo`, `InpProbNullo` | false, 1, 0,0 | stadi B/C; p = 0,25 nel file prova | §3. Con p = 0 il modo 0 rifiuta di partire |
| `InpRotturaBarre`, `InpRitornoEma`, `InpRitornoAtr`, `InpRitornoK` | 20, 50, 14, 2,0 | **fissi** (valori da manuale, nessuna griglia) | regola del 19/08: niente griglia su un motore senza edge |
| `InpLivelliMax` | 4 | **1 / 3 / 4 / 6** (stadio D, solo se A trova un EFFETTO) | 4: il 85% dei cesti osservati non supera 3-4 livelli (ricostruzione §4) |
| `InpPassoUSD` | 1,5 | **1,0 / 1,5 / 2,0** (stadio D) | 1,5 ~ passo mediano osservato (1,46) |
| `InpSLOltreUltimoUSD` | 8,0 | fisso | 8 = 40 x 0,20: lo stop dell'**ultimo** livello sta sulla frontiera dello SPREAD, ma e' 32x il costo pieno, **sotto** il pavimento di lavoro dell'oro (9,88 USD, par. 5); il primo livello ha stop (Lmax-1) x passo + 8 = 12,5 al centro |
| `InpTargetUSD` | 1,00 | asse dell'uscita **2,0 / 4,0** prima nel proxy (§6) | osservato: media + 1,19 mediani; [F] +1,00 esatti |
| `InpLottoBase` | 0,01 | fisso nel tester | il lotto osservato del venditore. **Non e' una taglia proposta** |
| `InpScalaIncremento`, `InpScalaTettoMult` | 0,0, 3,0 | 0,5 (l'osservato) solo nello stadio D | default piatta = rischio piu' basso |
| `InpRischioMaxCesto` | 0 (spento) | **DA DECIDERE CON CLAUDIO** | il rischio pianificato al centro e' 41,19 USD a 0,01 lotto (~35 EUR) con commissione stimata 4,00 EUR/lotto |
| `InpCommStimaLotto` | 0 (4,0 nel file prova) | solo stima nei log | il tester applica la sua commissione |
| `InpSpreadMaxUSD` | 0,40 | fisso | 2 x lo spread vivo del pannello |
| `InpPausaStopNuoviMin`, `InpPausaChiudiMin`, `InpVenerdiFineMax` | 120, 90, 22 | fissi | D6 |
| `InpDueLatiInsieme` | true | -- | come il venditore (`BOTH_SIDES`); false = niente hedging |
| `InpMagic` | **775600** | gemelle 775600/775650 (cancello G1) | blocco 7756xx: zero occorrenze in tutto `origin/lavoro` (2dacbe64) e nei file non tracciati del checkout principale, verificato il 13/10 |

## 5. Costo e frontiera (`stop >= 40 x spread`), con i numeri accanto

Spread 0,20 USD [LETTO sul pannello]; commissione 4,00 EUR/lotto A/R [LETTO nel conto] = ~0,047 USD/oncia; costo pieno ~**0,247 USD per oncia per ingresso**.
- **stop del livello 1** (cella centrale) = 3 x 1,5 + 8 = 12,5 USD -> **62x** lo spread, 51x il costo pieno: **PASSA**;
- **stop dell'ultimo livello** = 8 USD -> **40x** lo spread, **32x il costo pieno**: sulla frontiera **dello spread**, ma **SOTTO la frontiera di lavoro dell'oro**, che in casa si misura sul costo PIENO (MEMORIA sez. "frontiera": _"sull'oro ... 40 x il costo pieno = spread + commissione"_; `ORO_1530_MISURA_GIRATA` r.88: pavimento 8,01 $ con costo 0,2003). Con il costo di oggi (0,247) il pavimento e' **9,88 USD**. _(Corretto dal cancello, 13/10: qui c'era "sulla frontiera" senza dire contro quale grandezza; classe 1412.)_ **Conseguenza da non perdere:** la cella **`InpLivelliMax=1`**, l'unica che il par. 2 indica come candidata schierabile, ha stop = `InpSLOltreUltimoUSD` = **8 USD = 32x il costo pieno: oggi sarebbe esclusa PER COSTO**. Per lo stadio A non cambia niente (stessa geometria per i tre modi); se mai servisse la cella L=1, va misurata con `InpSLOltreUltimoUSD` >= 9,9;
- **TARGET** = 1,00 USD -> **5x** lo spread, **4,0x** il costo pieno: **sotto la frontiera di un fattore 8 (10 con la commissione)**. La frontiera di casa parla dello stop, non del target. Ma il target e' cio' che il cesto incassa nel 93-95% dei casi, e il costo se ne mangia **un quarto**. **E' la ragione meccanica dell'attesa negativa.**
- **Come si misura:** ogni riga `[C12OC-AVVIO]` stampa `dist_sl`, `spread`, `sl_su_spread`, `target_su_spread` allo spread **vero** del tick d'avvio; il netto delle righe `[C12OC-CESTO]` contiene la commissione **del tester** (se il tester BCM non la applica, il lettore la aggiunge a mano e lo dichiara: [NON MISURATO] se la applichi).

## 6. ATTESA, scritta PRIMA dei numeri del tester

**Fonte: PROXY** a barre M1 HistData 2021-01 -> 2026-09-18 (1.981.357 barre, ora New York -> server BCM come `atr_m1_oro_proxy.py`). Percorso dentro la barra O-L-H-C (rialzista) / O-H-L-C (ribassista), spread costante 0,20, commissione 0,047 USD/oncia, stesse regole dell'EA (pause in versione **ideale**: 17:00 New York e tetto delle 22:00 server il venerdi'). Unita': **USD a lotto base 0,01** (= 1 oncia).
**Contro-esempio del proxy, fatto prima di usarlo:** su un **random walk** (martingala, nessun edge possibile) il proxy da' PF **0,61-0,77** e un lordo per unita' di **-0,28 / -0,32** contro il **-0,20** teorico (lo spread). Quindi il proxy e' **pessimista di ~0,1 USD per unita'**: il prezzo supera il livello dentro un passo discreto. Lo stesso scarto si vede su un random walk a sottopassi gaussiani con percorso esatto. **Il pessimismo e' UGUALE per i modi e per il nullo**: le differenze fra celle si leggono, i livelli assoluti un po' meno.

### 6.1 La cella centrale (L=4, passo 1,5, target 1,00, scala piatta) [PROXY]

| finestra (regime) | ROT n / PF | RIT n / PF | NUL PF (semi 1/2/3), n | win per cesto | netto medio per cesto |
|---|---|---|---|---|---|
| IS 2024.07.10-2025.06.30 (rialzo, volatilita' bassa) | 19.599 / **0,729** | 12.903 / **0,738** | **0,713 / 0,729 / 0,731**, 23.627 | 0,938 (ROT) | -0,59 (ROT), -0,55 (RIT) |
| OOS 2025.07.01-2026.09.18 (volatilita' alta, 2026 senza direzione) | 38.998 / **0,664** | 39.697 / **0,646** | **0,672 / 0,660 / 0,665**, 57.477 | 0,939 (ROT) | -0,82 (ROT), -0,87 (RIT) |
| VECCHIO 2021-01 -> 2024.07.09 (solo RISCHIO) | 35.156 / 0,727 | 22.506 / 0,762 | 0,736 / 0,716 / 0,735, 38.966 | 0,924 | -0,58 (ROT) |

### 6.2 Le 9 celle profondita' x passo [PROXY], PF per cesto ROT / RIT / NUL(seme 1)

| L x passo | IS | OOS |
|---|---|---|
| 3 x 1,0 | 0,700 / 0,718 / 0,719 | 0,651 / 0,655 / 0,671 |
| 3 x 1,5 | 0,718 / 0,736 / 0,719 | 0,663 / 0,656 / 0,678 |
| 3 x 2,0 | 0,723 / 0,761 / 0,724 | 0,670 / 0,675 / 0,690 |
| 4 x 1,0 | 0,712 / 0,718 / 0,715 | 0,651 / 0,636 / 0,659 |
| **4 x 1,5** | **0,729 / 0,738 / 0,713** | **0,664 / 0,646 / 0,672** |
| 4 x 2,0 | 0,727 / 0,758 / 0,730 | 0,664 / 0,649 / 0,683 |
| 6 x 1,0 | 0,714 / 0,742 / 0,708 | 0,654 / 0,622 / 0,656 |
| 6 x 1,5 | 0,719 / 0,731 / 0,718 | 0,665 / 0,615 / 0,661 |
| 6 x 2,0 | 0,695 / 0,726 / 0,735 | 0,683 / 0,633 / 0,671 |

**L=1 (nessuna media)** [PROXY]: IS ROT 0,723 / RIT 0,768 / NUL 0,738; OOS 0,675 / 0,745 / 0,719. **Direzione casuale** (prima versione del proxy, senza la regola delle pause): stessi valori del modo d'origine entro +/-0,035.
**Asse dell'uscita** (cella 4 x 1,5) [PROXY], PF ROT / RIT / NUL: **target 2,0** IS 0,837 / 0,838 / 0,819, OOS 0,800 / 0,781 / 0,800; **target 4,0** IS 0,907 / 0,893 / 0,869, OOS 0,858 / 0,860 / **0,884**. Il PF sale verso 1 perche' il costo pesa meno sul target, ma il netto medio per cesto **peggiora** (ROT in IS: -0,59 a target 1, -0,70 a 2, -0,76 a 4; in OOS fino a -1,25) e il nullo resta alla pari (in OOS a target 4 sta **sopra** i due modi): e' quello che fa una martingala, non un edge.
**Lettura del proxy:** in **nessuna** cella un modo supera il nullo di 0,10 (scarto massimo +0,037). Il RITORNO in IS sta fra -0,01 e +0,04 dal nullo, in OOS fra -0,02 e -0,05 (**sotto**): **segno che cambia col regime = rumore**, non un effetto. In tutte le celle il PF e' molto sotto 1.

### 6.3 Bande, ipotesi alternativa, smentite, soglie (tester a tick reali)

- **A1 [n]**: per cella e finestra, 0,5x-2x del proxy (tabella 6.1). n >= 150 per cella: certo (decine di migliaia).
- **A2 [IPOTESI NULLA = la mia]**: PF per cesto di ROT, RIT, NUL in **0,60-0,90** in ogni finestra, e **|PF(modo) - PF(NUL)| <= 0,05**.
- **A3 [IPOTESI ALTERNATIVA, col suo numero]**: _"l'avvio porta edge"_ -> **PF(ROT o RIT) >= PF(NUL) + 0,10 in IS E in OOS**. 0,10 contro 0,05 e' il numero che le separa; **fra +0,05 e +0,10 = ZONA GRIGIA** (si risolve con i semi 2-5 del nullo, stadio B, **e con la direzione casuale, stadio C**). _"Il meccanismo osservato e' un motore"_ -> **PF per cesto >= 1,00 in IS E OOS**.
- **CORRETTO DAL CANCELLO (13/10, prima dei numeri del tester): il rumore di riferimento NON e' quello del seme.** Qui c'era scritto _"nel proxy i semi variano di +/-0,01, quindi 0,10 e' 5-10 volte il rumore del seme"_. Misurato il contro-esempio giusto: **proxy su RANDOM WALK** (nessun edge possibile, stessi tempi e ampiezze delle barre, due semi del RW, cella centrale): PF(modo) - PF(NUL, semi 1-3) = **IS da -0,019 a +0,021**; **OOS ROT da -0,012 a +0,011, RIT da -0,027 a -0,065** (RW IS: ROT 0,737/0,718, RIT 0,740/0,716, NUL 0,712-0,735; RW OOS: ROT 0,665/0,645, RIT 0,627/**0,592**, NUL 0,647-0,668; quindi anche il "PF 0,61-0,77 sul random walk" del par. 6 va letto **0,59-0,77**). Cioe' **l'ISTANTE d'avvio (la volatilita' del momento) sposta il PF per cesto fino a 0,065 senza nessun edge**, e il seme del nullo non lo vede (il nullo ha istanti casuali). Conseguenze, scritte prima dei numeri: (a) **0,10 resta la soglia di A3** (la differenza positiva senza edge arriva a +0,021: 0,10 e' circa 5 volte, ma su DUE semi del RW, non su una distribuzione); (b) **una differenza NEGATIVA fino a -0,07 e' gia' prodotta dal random walk**: NON e' un "anti-edge" e si legge NULLO; (c) la zona grigia e' solo quella **positiva**, e il controllo che tiene fermo l'istante e' la **direzione casuale** (stadio C), non i semi. Nel tester a tick reali il pregiudizio del percorso dentro la barra sparisce, ma lo spread vero (piu' largo nei momenti volatili) e' un confondente dello stesso verso: il lettore confronta la mediana di `spread` delle righe AVVIO fra modo e nullo prima di attribuire una differenza all'avvio.
- **A4 [forma, predizione]**: win per cesto 0,92-0,96; uscite a SL 4-7%; il 17-19% dei cesti arriva a 4 livelli; perdita a SL = rischio pianificato (41,19 USD a 0,01 = ~35 EUR); righe `oltre_rischio=SI` **0-2 per tranche**; righe `[C12OC-PAUSA-ATTRAVERSATA]` **zero FUORI dalle chiusure anticipate per festivita'**. _(Corretto dal cancello, 13/10: qui c'era "zero" e basta. Le chiusure anticipate dei giorni festivi USA (sull'oro di solito ~13:30 New York, poi riapertura alle 18:00) **non stanno nelle specifiche del simbolo**, quindi R8 non le vede: un cesto vivo a quell'ora attraversa un buco di ore. Sono ~10 all'anno e quasi certamente almeno una per tranche. Il lettore classifica ogni riga per DATA: festivita' nota = attesa, non difetto; il calendario usato si dichiara. [NON MISURATO] se BCM segue gli stessi orari.)_
- **A5 [costo]**: mediana di `target_su_spread` ~5 (4-6 con lo spread vero), `sl_su_spread` ~62.
- **Smentite:** (s1) ROT o RIT >= NUL + 0,10 in **tutte e due** le finestre -> A2 cade, si apre lo stadio D sul modo vincente; (s2) PF per cesto >= 1,00 in una cella e in tutte e due le finestre -> il costo non e' il collo di bottiglia: si cerca **perche'** prima di qualunque altra passata; (s3) PF del tester fuori da 0,60-0,90 per **tutte** le celle -> il proxy sbaglia in un modo da capire **prima** di leggere il merito; (s4) `[C12OC-PAUSA-ATTRAVERSATA]` > 0 **in un giorno che non e' una chiusura anticipata per festivita'** o `oltre_rischio=SI` > 2 per tranche -> D6 non regge sul feed BCM: difetto dell'EA, non verdetto sul motore.
- **Soglie per una sedia (se mai):** quelle di casa, non nuove: costo (stop >= 40 x spread sugli ingressi veri), IS/OOS su due regimi, n >= 150, DD dal VECCHIO, **niente media** (`InpLivelliMax=1`) o firma esplicita di Claudio. Il lettore **stampa**, non promuove: NULLO / ZONA GRIGIA / EFFETTO / NON ANCORA MISURATO.

### 6.4 DD per cesto e coda (a lotto base 0,01) [PROXY, cella centrale]
Perdita massima pianificata di un cesto **41,19 USD** (~35 EUR); simultanea con due cesti vivi **82,38 USD** (~70 EUR). Peggior cesto: IS -41,7, OOS -62,9 (ROT) / -62,2 (NUL), VECCHIO -114,9: **oltre il pianificato solo per gap** (OOS: 2-5 cesti su ~39.000-57.000, gap piccoli all'apertura di una barra o un salto; VECCHIO: 13-26 su 22.000-39.000, e alla cella centrale ROT **26 su 26** dopo un buco di almeno 30 minuti nei dati HistData, che nel feed a tick reali di solito non c'e'). **Il vero DD non e' il cesto, e' l'emorragia**: -0,59 / -0,82 USD per cesto x 78-124 cesti al giorno = **circa -46 USD al giorno in IS e -100 in OOS a lotto 0,01** [PROXY, pessimista di ~0,2 USD per cesto]. Il tester dira' il numero vero; il segno atteso e' quello.

## 7. Cosa ci perdiamo togliendo i difetti (protocollo §4, punto 3) [PROXY]

Versione "come il venditore" (approssimata: 15 livelli, passo 1,5, scala +0,5 per livello fino a 8x = 0,08 lotti, SL 20 USD oltre l'ultimo livello perche' senza SL il proxy non chiude mai):

| finestra | PF per cesto (NUL / ROT / RIT) | win | giorni positivi | giorno mediano | giorno peggiore | cesti >= 10 livelli: netto |
|---|---|---|---|---|---|---|
| IS | 0,726 / 0,832 / 0,644 | 0,987-0,990 | 209-231 su ~281 | **+105 / +189 USD** | **-3.110 / -3.214** | -54.793 / -89.440 |
| OOS | 0,630 / 0,591 / 0,525 | 0,994-0,995 | 201-238 su ~360 | +23 / +171 | **-7.822 / -11.993** | -212.382 / -291.774 |
| VECCHIO | 0,752 / 0,719 / 0,740 | 0,970-0,973 | 758-842 su ~985 | +55 / +81 | -3.129 / -3.984 | -73.620 / -134.563 |

**Togliendo i difetti si perde il giorno mediano positivo** (l'"apparenza": il +487 EUR del 13/10 sta nella meta' buona di questa distribuzione) **e si toglie un giorno peggiore che vale da 16 a ~500 giorni mediani** (IS 16-30, VECCHIO 38-73, OOS 46-511). Il 24,5% del profitto che la ricostruzione attribuiva ai 3 cesti profondi e', su 5 anni, il posto dove la stessa famiglia **perde tutto**: nel proxy i cesti >= 10 livelli valgono da -55.000 a -292.000 USD a lotto base 0,01.

**Contro-esempio del cancello (13/10): il proxy "come il venditore" riproduce il giorno osservato?** (rilanciato su HistData, NUL seme 1 e ROT; RIT non rifatto) **In parte si', in parte NO, e va detto.**
- ✅ **Riproduce** la quota di posizioni in profitto: **0,687-0,703** contro **69,2%** letto; il profilo di profondita' (proxy, posizioni per cesto: 1 = 53-55%, 2 = 18-20%, 3-4 = 15-16%, 5-9 = 8-9%, >= 10 = 2,3-3,0%; osservato, ingressi `[R]` su 80 cesti: 45 / 19 / 21 / 11 / 3,75%); e un giorno da **+570 USD (~+487 EUR)** e' possibile: lo fa il **0,7-4,9%** dei giorni in IS e il **9-26%** in OOS. Quindi "meta' buona" va letto **coda alta**: in IS e' oltre il 95esimo percentile del giorno.
- 🔴 **NON riproduce** il tasso di cesti in perdita: proxy **0,987-0,995** cesti vinti (>= 3 posizioni: **0,959-0,982**), osservato **75 su 80 = 0,94** (`[R]`) e **20 su 24 = 0,83** (>= 3 posizioni). Su 24 cesti vederne 4 o piu' in perdita succede **1,6 volte su 100** se il proxy ha ragione al suo meglio (0,959), **meno di 1 su 1.000** al suo peggio (0,982); sugli 80 cesti `[R]`, 5 o piu' in perdita: **0,4 su 100** o meno. La ragione e' nota: lo SL del venditore **arriva dopo e si sposta** (5 cesti su 24 usciti a SL, perdite piccole), il proxy invece ha uno SL fisso a 20 USD oltre il livello 15. **Il par. 7 descrive dunque una martingala PIU' pura di quella osservata**: i suoi giorni peggiori sono un limite superiore del rischio del venditore, non una sua misura. Le conclusioni sull'EA NOSTRO (par. 6) non dipendono da questa tabella.

## 8. Piano di test (una variabile per file; tick reali Modello 4; XAUUSD M1)

| stadio | file | cosa | passate | quando |
|---|---|---|---|---|
| **S0** sonda | `C12OC_A_AVVIO` lotto S0 | Modello 1, tranche O5: compila? `AUTOTEST VERDETTO: PASS`? righe `[C12OC] SESSIONI` lette? gemelle 775600/775650 identiche? minuti per passata? | 4 | prima di tutto |
| **A** avvio | `C12OC_A_AVVIO` lotti AIS, AOOS | ROT / RIT / NUL(seme 1) sulla cella centrale, IS (4 tranche) e OOS (5 tranche) | 12 + 15 | dopo S0 verde |
| B semi del nullo | da scrivere | NUL semi 2-5 (asse `InpSemeNullo`) | 36 | **solo se A = ZONA GRIGIA** |
| C direzione casuale | da scrivere | modo vincente con `InpDirezioneCasuale=true` | 9 | solo se A = EFFETTO |
| D geometria | da scrivere | `InpLivelliMax` 1/3/4/6 x `InpPassoUSD` 1,0/1,5/2,0 sul modo vincente, IS per scegliere il **centro dell'altopiano** (mai il picco), OOS per confermare | 2 file | solo se A = EFFETTO |
| V vecchio | da scrivere | Modello 1, 2021-2024.06 a tranche trimestrali: **solo RISCHIO** (cesto peggiore, `oltre_rischio`, giorno peggiore). Profondita' delle barre M1 BCM prima del 2024: [NON MISURATO] | ~14 | solo se A = EFFETTO |

**Regimi dichiarati:** IS = oro in rialzo con volatilita' M1 bassa; OOS = volatilita' alta, +64,5% nel 2025, 2026 senza direzione con il picco a 5.597 e il ritorno a 4.098. Nello stadio A **niente si sceglie in IS**: IS e OOS sono due regimi, non selezione e conferma.
**Se A = NULLO (l'attesa):** il verdetto e' **NON ANCORA MISURATO**, non MORTO, finche' il certificato a 5 caselle non e' completo. Oggi: (1) PF misurato: si' dopo A; (2) n e DD: si' dopo A; (3) **gestione dell'uscita ad asse**: target 2/4 USD e L=1 **fatti nel proxy** (§6.2: nessun effetto), nel tester no; (4) **simboli gemelli** (XAGUSD): no, servono i dati; (5) **TF cambiato** (avvio su M5): no. La via piu' corta: le caselle 3 e 5 **prima nel proxy** (minuti, zero tempo macchina di Claudio), poi una passata a tick reali per casella. **Niente griglia di parametri su un motore senza edge** (regola del 19/08): si allarga su uscita, TF e simbolo, una cosa alla volta.

## 9. Costo in tempo macchina [STIMA: nessuna passata di questo EA e' mai girata]

S0 ~10-20 min · AIS 12 passate x 4-10 min = **1-2 h** · AOOS 15 x 5-12 min = **1,5-3 h**. Riferimento: GBA R1A_01, 48 s a trimestre con 128 operazioni. Qui le operazioni sono ~10.000-30.000 a trimestre: il tempo lo detta il **giornale** (2 righe per cesto con `InpVerbose=false`) piu' che i tick. S0 lo **misura** prima di AIS. Solo PC di backtest, mai il VPS (regola del 21/09).

## 10. Cosa NON si puo' concludere da un giorno di dati altrui

- Un giorno (13/10, ~21 ore, 94 `CID`) e' **un regime**, non 633 prove indipendenti: PF 1,485 e +541 di `[R]` sono **descrizione**, non edge.
- La coda non e' misurata: nessun cesto del giorno ha incontrato un trend contro la serie; il report non ha MAE e il drawdown e' **di saldo**, non di equity.
- Lo spread vero degli ingressi e' [NON MISURATO] (il pannello dice 0,20 in un istante).
- Il segnale d'avvio, il passo e la scala del venditore sono [NON VISTI]: le nostre griglie **non** sono la sua; un risultato nostro non dice niente sul suo EA, e viceversa.
- I pulsanti manuali: non si sa se qualcuno li abbia premuti (attribuzione).
- **Il proxy non e' il tester**: niente tick, spread costante, percorso dentro la barra inventato, feed HistData e non BCM. E' pessimista di ~0,1 USD per unita' (misurato sul random walk). Ancora l'attesa, **non e' una misura**.

## 11. Cosa manca, cosa non ho potuto verificare

- **Compilazione MQL5**: mai fatta. Verificato a macchina: ASCII puro, LF, parentesi bilanciate fuori da commenti e stringhe, 31 `PrintFormat`/`StringFormat` con segnaposto = argomenti, nessuna chiamata vietata (`WebRequest`, `SendMail`, `#import`, `OrderSend`, `AllowLiveTrading`), 2 invii entrambi preceduti dal Guardian. Il **nucleo puro** (20 funzioni) e la logica delle sessioni sono stati **estratti dal `.mq5` e compilati con g++ -Wall -Wextra**: pulito. **Non verificati**: la semantica MQL5 di `uint` (moltiplicazione modulo 2^32: c'e' un caso d'autotest che lo controlla al primo avvio), `SymbolInfoSessionTrade` nel tester (le righe `[C12OC] SESSIONI` lo diranno in S0), `CTrade`, i riempimenti, `HistorySelect`/`DEAL_REASON`, il comportamento con lo spread vero.
- **Il driver**: `GBA_R0_PASSATE.ps1` e' cablato sul GBA (nome, versione 1.10, magic 775800/775850, prefissi `[GBA]`, blocchi `@GBA-*`). Serve un **adattamento parametrizzato** (EXPERT, versione, magic 775600/775650, prefisso `[C12OC]`, blocchi `@C12OC-*`, KO su `[C12OC] MARGINE INSUFFICIENTE` e `[C12OC][AUTOTEST] *** FAIL`) e un **lettore nuovo** (`leggi_c12oc.py`: PF per cesto, confronto col nullo, coda, giorno peggiore, costo). **Non scritti qui** (fuori dal mandato).
- **Il proxy** sta nella cartella di lavoro della sessione, **non in repo** (`proxy_cesto.py` e i suoi driver: percorsi e SHA nel messaggio di consegna). Se i numeri del §6-7 devono essere riproducibili da altri, va aggiunto al repo **passando dal cancello**.
- **Gemini**: il nuovo piano di misura andrebbe riletto da Gemini (regola dell'11/10). **Non chiamato** (divieto del mandato): resta da fare alla sessione principale.
- **Cancello**: strato 1 `controlla_prova.py` sul file prova = **OK, 0 problemi** (33 pin = 33 input, 4 deviazioni dichiarate); strato 2 (`controllo-preventivo`) **fatto il 13/10**, con tre correzioni all'EA (stessa v1.00: mai compilata): **(1) `OnInit` RIFIUTA fuori dallo Strategy Tester** (`INIT_FAILED`, come `EA_NatCla_Diag`): prima stampava solo un avviso, e l'EA media a prezzo peggiore e ha un modo a ingressi casuali; **(2)** l'identificativo della posizione entra nel cesto **subito dopo l'invio** (`ResultDeal` -> `DEAL_POSITION_ID`): prima entrava solo al tick dopo, e un cesto chiuso da TP/SL proprio a quel tick usciva con **netto 0 e prof 0** - un difetto che colpisce di piu' gli avvii seguiti da uno scatto veloce (la ROTTURA), cioe' correlato col modo; **(3)** `segnali` della riga CONTA non conta piu' due volte gli avvii falliti. Nella specifica: rumore di riferimento di A2/A3 rimisurato sul random walk (par. 6.3), festivita' in A4/s4, contro-esempio del venditore (par. 7).

## 12. Decisioni che servono a Claudio (3)

1. **Si spendono 3-5 ore del PC di backtest sullo stadio A, sapendo che il proxy prevede NULLO?** La mia raccomandazione e' **si', ma a gradini**: S0 (20 min) e poi solo AIS (1-2 h). Un proxy non e' una misura, e la regola di casa vuole **due misure diverse** prima di archiviare. Se AIS conferma il proxy (tutto in 0,60-0,90, nessun modo sopra il nullo di 0,05), AOOS si puo' risparmiare.
2. **Il tetto delle 22:00 server il venerdi' e la chiusura prima di OGNI pausa giornaliera** (default accesi): e' l'unica difesa contro i gap che lo SL non ferma, misurata nel proxy. Cambia il comportamento rispetto al venditore (`FridayGapProtection=false`). Va bene cosi'?
3. **Il rischio per cesto (`InpRischioMaxCesto`) e il lotto**: oggi spento e 0,01 nel tester. **Serve deciderli solo se A trova un EFFETTO**, e solo per la cella **senza media** (`InpLivelliMax=1`), perche' la media a prezzo peggiore resta fuori dall'imbuto prop senza una tua firma esplicita.

## 13. AUTOVERIFICA: i contro-esempi che ho costruito, e l'esito

| # | contro-esempio (cosa lo farebbe sbagliare) | come l'ho provato | esito |
|---|---|---|---|
| CE1 | **il proxy fabbrica edge** dove non c'e' | proxy su un random walk (stessi tempi e ampiezze, segni casuali) e su un random walk a sottopassi gaussiani con percorso esatto | **nessun edge** (PF 0,61-0,77). Trovato e **quantificato** uno scarto pessimista di ~0,1 USD per unita' (lordo -0,28/-0,32 contro -0,20 teorico): causa = sorpasso del livello dentro un passo. Dichiarato in §6 |
| CE2 | **la coda supera lo SL** (gap) | ho cercato nel proxy i cesti con netto < -rischio pianificato | trovati, fino a 6x il pianificato: **weekend** (la mia prima chiusura del venerdi' alle 22:30 arrivava DOPO la chiusura estiva delle 22:00 server), **pausa giornaliera**, buchi di dati. **Corretto l'EA** (D6) e il proxy: oltre il pianificato da 2 a 0-1 per cella in IS. Aggiunti nell'EA i contatori `oltre_rischio` e `[C12OC-PAUSA-ATTRAVERSATA]` |
| CE3 | il **nullo dell'EA non e' quello del proxy** | nucleo estratto dal `.mq5`, compilato con g++, 80.000 estrazioni (4 semi x 20.000 barre) confrontate con il Python | **0 differenze**; quota di avvii 0,2506 contro 0,25 attesa. Tre esiti fissati come casi d'autotest nell'EA |
| CE4 | **un valore di riferimento inventato** nell'autotest | il primo `C12Mix(1)` l'avevo scritto a mano (0x9C6A6D1A) | l'autotest compilato l'ha preso: **FAIL**. Ricalcolato in due modi indipendenti (g++ e Python): 0x477107AE. Corretto PRIMA della consegna |
| CE5 | **un'attesa d'autotest sbagliata** (sessione oltre la mezzanotte) | il caso "23:30 con fine all'01:00 = libero" falliva | sbagliato il caso, non il codice: a 90 minuti dalla fine si **chiude**. Riscritto con due casi (21:30 libero, 23:30 chiudere) |
| CE6 | **l'autotest non morde** | 16 mutanti ciechi sul nucleo (finestra, SL, rottura >=, segno del target, chiudi/stop invertiti, tetto del venerdi', floor/round del lotto, tetto del lotto, due lati, mescolatore, profondita', rischio, target superato, spread, decisione sul rischio, k del ritorno) | primo giro: **1 vivo** (spread uguale al massimo non coperto) -> aggiunti 3 casi di bordo. Secondo giro: **0 vivi su 16**. Autotest: **67 casi, 0 falliti** |
| CE7 | **le sessioni** (pausa giornaliera, venerdi' fino a mezzanotte, domenica che apre alle 23:00, tick fuori sessione, due sessioni con pausa di 15 min, sessioni non lette) | funzione estratta e compilata con g++, 15 scenari | **15 su 15** |
| CE8 | **gap attraverso due livelli** in un tick | caso d'autotest: Ask a 1996,5 con livelli 1998,5 / 1997 -> riempie il 3, salta il 2 | corretto; il 2 resta saltato per sempre (meno rischio del pianificato, mai di piu') |
| CE9 | **riavvio del terminale a meta' cesto** | lettura del codice: P1 = posizione piu' vecchia, SL letto dalle posizioni (o ricalcolato se manca), livelli dai prezzi | ricostruito; si perdono **solo** MAE, ora d'avvio e rischio pianificato, e la riga `CESTO` lo dice (`ricostruito=SI`, `oltre_rischio=?`) |
| CE10 | **ordine rifiutato a ripetizione** (margine, Guardian) | lettura del codice | trovato un difetto: ritentava **a ogni tick** (raffica di ordini e di righe d'errore). **Corretto**: un tentativo per barra (`g_tentativoKO`) |
| CE11 | **controllore statico cieco** | mutanti sul sorgente: un argomento tolto a un `PrintFormat`, il Guardian tolto prima di `trade.Sell` | **presi entrambi** (1 discordanza; "Sell preceduto dal Guardian: False") |
| CE12 | **ora legale e specifiche del simbolo** che non la seguono | ragionamento sull'orologio misurato (CLAUDE.md, 24/09) + caso d'autotest "venerdi' estate col tetto: 20:30 -> chiudere" | coperto dal tetto delle 22:00; **resta [NON MISURATO]** come BCM scriva le sessioni dell'oro: le righe `SESSIONI` di S0 lo diranno |
| CE13 | **conto netting** | lettura del codice | `OnInit` rifiuta (`INIT_FAILED`) |
| CE14 | **TP non sincronizzato** su una posizione (modifica fallita) | lettura del codice | ritenta a ogni tick (si frena solo la stampa). Se il resto del cesto chiude prima, la posizione rimasta diventa P1 di un cesto "ricostruito" nella stessa riga `CESTO`: caso raro, **dichiarato**, non risolto |
| CE15 | **un difetto da regola di casa** (griglia) | rilettura di scheda §4 e protocollo §5 contro il mandato | la media a prezzo peggiore **resta** con `InpLivelliMax > 1`: dichiarata in testa all'EA e in §2. La cella senza media (`InpLivelliMax=1`) e' l'unica candidata schierabile |
