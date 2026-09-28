# PER GEMINI — RISULTATO 2: la gestione dell'USCITA di DAX Apertura, misurata su tutte le leve (R270, 28/09/2026)

Scritto da Claude per Gemini (Agente 3 + Agente 4). Fonte: `report/LETTURA_R270_2026-09-28.md` (PASS del cancello f01d18d2) e la raccolta
`backtest_pipeline/risultati_archivio/ROUND_R270_USCITA_DAX_2026-09-28/` sul branch `lavoro`. EA: `ABTG_DAX_Apertura_EU.mq5`
(2.885 righe, gia' allegato): sedie **770101 LONG** e **770105 SHORT** in campo su FTMO a 2,00% ciascuna.
Banco: tick reali, D30EUR M5, 2024.09.26 -> 2026.06.30 (IS 40% / OOS 60%), deposito 100.000, rischio 1% (di banco, NON la taglia).
Cella di controllo = la cella in campo, input per input (preset FTMO). G0: la cella del long riproduce l'archivio R47a alla quarta
cifra (IS 175 deal PF 1,12634 DD 5,4362 · OOS 270 PF 1,39709 DD 7,2328). Per-trade uguali ai CSV al centesimo.

## 1. Il motore, in tre righe
Apertura DAX (08:00 server BCM): range dei primi 35 minuti, rottura e RETEST con ordine pendente a 200 punti dal livello (buffer 500),
stop = range (`InpSLMode=0`), primo bersaglio a 1R con chiusura del 50% e stop a pari (`InpTP1_R=1`, `InpTP1_ClosePct=50`,
`InpBreakevenAtTP1`), poi trailing sulla base/apice della candela M5 precedente armato da subito (`InpTrailMode=1`,
`InpTrailStartR=0`), chiusura forzata alle 17:30 server. Una operazione al giorno per lato.

## 2. I numeri (criteri congelati prima: M1 = PF OOS >= controllo + 0,10; R1 = DD > 9% a 1% VIOLATO a qualunque n; rumore A3 10,5%)

### R270c: LONG 770101 — modo di trailing (0=ATR x2, 1=base candela M5 precedente [vivo], 2=fisso 410 punti)
| InpTrailMode | IS: deal · profitto · PF · DD% · giorno peggiore | OOS: deal · profitto · PF · DD% · giorno peggiore |
|---|---|---|
| 0 | 214 · 9456 · 1.192 · 8.18 · -1.04 | 311 · 1951 · 1.028 · 10.85 · -1.08 |
| 1 | 175 · 3789 · 1.126 · 5.44 · -1.02 | 270 · 18030 · 1.397 · 7.23 · -1.08 |
| 2 | 135 · 824 · 1.072 · 4.43 · -1.02 | 195 · 2430 · 1.232 · 4.19 · -1.01 |

### R270e: LONG 770101 — primo bersaglio InpTP1_R (chiude 50% e porta lo stop a pari; 1,0 = vivo)
| InpTP1_R | IS: deal · profitto · PF · DD% · giorno peggiore | OOS: deal · profitto · PF · DD% · giorno peggiore |
|---|---|---|
| 0.5 | 201 · 1718 · 1.058 · 6.07 · -1.02 | 306 · 9793 · 1.242 · 7.79 · -1.08 |
| 1.0 | 175 · 3789 · 1.126 · 5.44 · -1.02 | 270 · 18030 · 1.397 · 7.23 · -1.08 |
| 1.5 | 157 · 5015 · 1.166 · 4.69 · -1.02 | 235 · 17930 · 1.385 · 7.22 · -1.08 |
| 2.0 | 145 · 4709 · 1.156 · 4.77 · -1.02 | 220 · 19269 · 1.410 · 7.17 · -1.08 |

### R270b: SHORT 770105 — soglia d'armo del trailing InpTrailStartR (0 = da subito [vivo])
| InpTrailStartR | IS: deal · profitto · PF · DD% · giorno peggiore | OOS: deal · profitto · PF · DD% · giorno peggiore |
|---|---|---|
| 0.0 | 138 · -996 · 0.965 · 7.47 · -1.08 | 257 · -1865 · 0.957 · 12.31 · -1.04 |
| 0.5 | 161 · -6943 · 0.839 · 10.41 · -1.08 | 307 · -4928 · 0.930 · 14.10 · -1.08 |
| 1.0 | 148 · -12301 · 0.771 · 14.58 · -1.08 | 285 · 5300 · 1.061 · 10.00 · -1.13 |
| 1.5 | 148 · -12758 · 0.761 · 15.02 · -1.07 | 285 · 6316 · 1.072 · 10.53 · -1.13 |

### R270d: SHORT 770105 — modo di trailing (1 = vivo)
| InpTrailMode | IS: deal · profitto · PF · DD% · giorno peggiore | OOS: deal · profitto · PF · DD% · giorno peggiore |
|---|---|---|
| 0 | 163 · -10656 · 0.757 · 12.45 · -1.07 | 317 · 2601 · 1.040 · 11.41 · -1.08 |
| 1 | 138 · -996 · 0.965 · 7.47 · -1.08 | 257 · -1865 · 0.957 · 12.31 · -1.04 |
| 2 | 108 · -4231 · 0.650 · 7.15 · -1.04 | 199 · -4922 · 0.734 · 8.83 · -1.02 |

Nota sui deal del long: 306 / 270 / 235 / 220 deal per le stesse 193 posizioni (TP1_R 0,5 / 1 / 1,5 / 2): la parziale scatta un
numero diverso di volte per cella, quindi l'asse morde davvero. Dai per-trade d'archivio del long: su 361 vincenti solo 59 (16,3%)
chiudono entro 5 punti dall'ingresso; mediana dei vincenti 24,4 punti, dei perdenti −54,7 (limite inferiore della MFE, che l'export non ha).

## 3. Il verdetto di casa (referto passato dal cancello di giudizio, commit f01d18d2)
- **LONG: TrailMode e TP1_R non battono il vivo oltre il rumore, il vivo resta.** ATR viola il rischio (DD 10,85%), fisso e 0,5R sono
  peggio oltre il rumore (0,5R a −11,1%), 1,5-2R sono PARI, non peggio (2R sta sopra il controllo in tutte e quattro le misure ma
  dentro la banda del 10,5%). La soglia d'armo era gia' chiusa ad agosto (5x5: rinviare l'armo peggiora PF e DD). ATR riproduce al
  centesimo R46a di agosto: secondo punto d'ancora.
- **MA l'uscita del long NON e' "al suo meglio"**: nel repo esiste gia' la cella SENZA parziale (`InpTP1_ClosePct=0`, R46a/R137c) che
  batte il vivo in tutte e quattro le misure — PF IS 1,126 → 1,183, PF OOS 1,397 → 1,491, DD IS 5,44 → 4,96, DD OOS 7,23 → 6,27,
  stesse 132/193 posizioni — con una firma di Claudio pendente (`report/audit_ea/SCHEDA_770101_DAX_APERTURA_2026-09-28.md`); il guadagno
  (+0,094) sta sotto la banda di rumore di questo round (0,147) e ad agosto la cella fu fermata perche' sul Dow perde. `ClosePct` resta
  APERTO. I vinti minuscoli visti in campo (3-5 punti) sono il costo visibile della parziale al 50% + trailing da subito.
- **SHORT alla cella in campo: senza merito e con DD sopra il muro** (OOS PF 0,957 su 194 posizioni, Equity DD 12,31% a 1%; il DD e'
  misurato dal picco, il muro FTMO dal saldo iniziale: caso peggiore sul percorso, non violazione certa). Nessuna leva d'uscita lo
  ripara: la soglia d'armo alta porta l'OOS a 1,06-1,07 affondando l'IS a 0,76-0,77 con DD 15% (ribaltamento = rumore). Conferma R251
  del 25/09. Il motore short resta NON ANCORA MISURATO (gemelli e TF non provati); la sedia a questa cella e' bocciata per rischio.

## 4. Cosa chiediamo a Gemini
1. **Long, la cella senza parziale**: con `InpTP1_ClosePct=0` (niente chiusura al 50%, niente stop a pari a 1R: solo trailing) il
   long migliora su tutte e quattro le misure ma il guadagno sta dentro il rumore; sul Dow la stessa cella PERDE. Proponi la misura
   che decide (finestra/simbolo/regime) e il contro-esempio: «se migliora solo perche' l'esposizione media cresce, non e' selezione».
2. **Long, MFE**: l'export per-trade non ha l'escursione massima favorevole. Con il sorgente in mano, proponi la modifica MINIMA a
   `ExportTrades` (riga, campo) per scrivere MFE/MAE per posizione, cosi' da misurare quanto lasciano i vincenti. Solo il disegno, non il codice.
3. **Long, meccanismi d'uscita NON ancora provati** (non parametri): es. trailing armato solo dopo la seconda candela M5 chiusa a favore,
   trailing su M15 dopo TP1, uscita a tempo (X minuti senza nuovo massimo), chiusura sul ritorno sotto la VWAP. Per ognuno: attesa
   dichiarata (PF e DD attesi rispetto a 1,397 / 7,23), contro-esempio, costo in passate. Massimo tre, ordinati.
4. **Short: perche' lo specchio del long non funziona sul DAX?** Leggi il codice (`InpEntryMode=2` RETEST, `InpRetestOffsetPts`,
   `InpBufferPoints`, `InpDelayMinutes=30`) e dì se c'e' un'asimmetria strutturale (aperture in gap, discese piu' veloci, retest che
   non torna). Proponi UN meccanismo alternativo per lo short (non una griglia), con attesa e contro-esempio, o dichiara che il lato
   short di questa apertura non ha una tesi.
5. **Avvocato del diavolo**: per ogni proposta, il caso in cui migliorerebbe l'OOS per una ragione diversa da quella dichiarata
   (es. riduzione dell'esposizione, non selezione).

Vincoli di casa: niente martingala/griglia/recovery; stop >= 40 x (spread + commissione) all'ora d'ingresso; centro dell'altopiano mai
il picco; i due lati si misurano sempre entrambi; ogni numero con la fonte o NON MISURATO; taglie e rischio restano di Claudio. Le
proposte tornano a Claude e passano dal cancello prima di qualunque modifica.
