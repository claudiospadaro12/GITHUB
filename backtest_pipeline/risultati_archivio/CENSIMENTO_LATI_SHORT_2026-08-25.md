# 🧭 CENSIMENTO DEI LATI SHORT SUGLI INDICI — cosa e' misurato, cosa e' bocciato, cosa NON e' mai stato provato (25/08/2026)

_Richiesto da Claudio la sera del 25/08, dopo i verdetti short di R107
("non si possono provare i vari motori?"). Questo documento e' la mappa che
la REGOLA DELLA SECONDA CACCIA esige prima di proporre qualunque round:
**motore senza edge → si cercano MECCANISMI alternativi, MAI parametri
diversi del motore morto.** Solo lettura d'archivio: nessuna prova, nessun
criterio, nessuna riga di R107/R108/R109 e' stata toccata._

_Perimetro: indici (D30EUR · U30USD · NASUSD, piu' 225JPY e i cugini
100GBP/F40EUR/E50EUR dove misurati). Fonti: `REGISTRO_TEST.md` intero,
referti R42/R43/R45/R51/R54/R88/R96/R97/R98/R101/R103/R104/R107,
`FLOTTA_ATTIVA.md`, `report/CONTRATTI_SEDIE.md`,
`caccia_strategie/CACCIA_M5M15_INDICI_2026-08-25.md`, `R109_CRITERI.md`,
`ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md`._

> ⚠️ **La frase da tenere davanti a ogni riga di questa tabella** (da
> `R107_CODA_LATI_SHORT.md`, scritta PRIMA dei numeri): _"La finestra e' 21
> mesi di INDICI IN SALITA: il lato short parte svantaggiato PER REGIME. Un
> 'niente edge short' qui non chiude la domanda per sempre — la chiude PER
> QUESTA EPOCA."_ L'unica eccezione misurata e' il DAX apertura short, rosso
> ANCHE nella sotto-finestra che conteneva la discesa feb-apr 2025.

---

## 1. 📊 LA TABELLA MADRE — motore per motore, geometria per geometria

_Geometrie diverse dello stesso EA = righe diverse (retest ≠ rottura secca ≠
fade: ai fini del registro sono motori diversi)._

### 1a. Famiglia APERTURE (la campanella)

| Motore / geometria | Sym | LONG misurato? | SHORT misurato? | Stato short |
|---|---|---|---|---|
| **Apertura RETEST** (sedia viva 770101) | D30EUR | 🟢 VIVO (A2 26/07 PF 1,49 · R46 · R101 conferma · R103 3° posto) | 🔴 **R107: PF IS 0,965 / OOS 0,957, n 257** — rosso in ENTRAMBE le finestre, discesa feb-apr 2025 COMPRESA. Unico short con merito MISURABILE (n≥150) | ⛔ **BOCCIATO, non si ripropone** (riga A3 del registro chiusa dopo un anno) |
| **Apertura RETEST** (sedia viva 770202) | U30USD | 🟢 VIVO (R16 · R46 · R54 · R101) | 🔴 **R54: OOS PF 0,840, n 73** (IS 1,511 = il 28° ribaltamento) — **R107 riproduce al millesimo** | ⛔ bocciato per questa epoca; merito formale SOSPESO (n<150) — riapribile SOLO da prova di regime |
| **Apertura RETEST** (geometria Dow su NAS) | NASUSD | 🔴 morto (A4 31/07 PF 0,82-0,91 · WF 19/20 celle OOS negative · sedia 770201 SPENTA 18/08) | 🔴 **R107: OOS PF 0,460** (IS 3,220! — l'edge short vive nelle discese, [INFERITO]) | ⛔ "la geometria del Dow non si trasporta" — verdetto pre-dichiarato nei criteri R107 |
| **Rottura secca (STOP) M5** — Live5m, DAX_M3, aperture v2 | D30EUR/NASUSD | 🔴 morti (registro §2, real tick 27/27 negative) | 🔴 misurato dentro le celle "entrambe" — DAX_M3 short 0% pos | ⛔ **capitolo BREAKOUT M5 CHIUSO** (verdetto definitivo 26/07) |
| **FADE degli estremi del range** (RANGE_FADE) | NASUSD + D30EUR | 🔴 R42: dentro lo 0/48 | 🔴 **R42: 0/48 celle positive** (IS E OOS, campioni 195-333 trade) | ⛔ "la nettezza piu' totale mai vista in un round" |
| **Rimbalzo ORL (solo long) / ORH (solo short)** | NASUSD + D30EUR | 🔴 R43: 0/8 + 0/8 | 🔴 **R43: ORH short 0/8 OOS su entrambi** (le 2 celle IS verdi ribaltate: la scelta era il lato PIU' tossico) | ⛔ capitolo "estremi del range di apertura" **chiuso per sempre** (criterio 4 congelato) |
| **REVERSE (stop-and-reverse)** su apertura | D30EUR | — (e' una gestione, non un lato) | 🟡 **R51: RISERVA, non promosso** — reverse ON peggiora DD (8,79 vs 7,20) e raddoppia la peggior giornata | ⛔ lo "short automatico dopo lo stop" e' gia' stato misurato: non paga |
| **CrossEma d'apertura** (9/21) | U30USD + NASUSD | 🔴 R96: bocciato | 🔴 R96: bocciato (motore bidirezionale, DD 29-35%) | ⛔ chiuso |

### 1b. Famiglia ORB (open range + EMA200)

| Motore / geometria | Sym | LONG | SHORT | Stato short |
|---|---|---|---|---|
| **ORB_Ottimizzato** (sedia viva 770611, long-only) | U30USD | 🟢 VIVO (R15 · R16 · R88 stop largo · R103: 1° posto normalizzato +58k) | 🔴 **R54: OOS PF 0,520 · DD 26,37%** — rosso in ENTRAMBE le finestre: **asimmetria strutturale**, non regime | ⛔ **DISTRUTTO** — il caso piu' netto dell'archivio, non si ripropone |
| **ORB su Nasdaq** (halfrange + opprange) | NASUSD | 🔴 R97: 0/4, tutte PF OOS <1 (il problema sono gli INGRESSI) | (celle geometria-uscita, stessi ingressi) | ⛔ capitolo Nasdaq chiuso (R97+R98: due meccanismi, stesso mercato, 0 edge) |
| **ORB Londra** | GBPUSD/oro (non indici, per memoria) | 🔴 R45: 0/48 | 🔴 idem | ⛔ famiglia ORB chiusa su ogni sessione misurata |

### 1c. La NOTTE

| Motore / geometria | Sym | LONG | SHORT | Stato |
|---|---|---|---|---|
| **MaxMinNotte** (breakout box notturno) | D30EUR | 🔴 **misurato e morto** (sweep direzione×buffer 26/07, real tick: l'unica cella viva e' SHORT-only) | 🟢 **VIVO** — 770411, corr S&P ON, PF 2,05→2,26 in R103, **l'UNICO short vivo del progetto sugli indici** | ✅ qui il lato bocciato e' il LONG — caso inverso, gia' agli atti |
| **MaxMinNotte** | 100GBP/F40EUR/E50EUR | 🔴 morti (max PF 0,67/1,0/0,59, entrambi i lati nel sweep) | 🔴 idem | ⛔ |
| **Nightly FADE del box notturno** | U30USD/D30EUR | ⚪ **MAI MISURATO** | ⚪ **MAI MISURATO** — rettifica 23/08: il filtro QB (`InpMaxNightVolPips` vs `PipSize()`) fa **ZERO trade sugli indici**. _"Su quei mercati il fade non e' stato bocciato: NON E' STATO MISURATO"_ | 🟡 **candidato naturale** (serve fix del filtro, EA esiste) |
| **BREAKIN del box notturno** (falsa rottura → reversal, motore `ABTG_LiquiditySweep`) | indici | ⚪ MAI misurato sugli indici | ⚪ **MAI MISURATO** — spec gia' scritta (`ANALISI_NIGHTLY_PDF` §7b): il box notturno da' ~250 livelli/anno per lato (R89 su GBPUSD era morto di fame: 14 trade) | 🟡 **candidato naturale** — nessun file prova ancora scritto |

### 1d. Motori SIMMETRICI vivi in forward (long+short nella stessa cella — lati MAI separati)

| Motore | Sym / magic | Com'e' promosso | Lato short da solo? |
|---|---|---|---|
| **SupRev_NAS_H1** (la prop-friendly ⭐) | NASUSD 970913 | L+S insieme (PF 1,57 · DD 1,17% · R103: PF 1,65) | ⚪ mai misurato separato |
| **SupRev_DAX_H1 / H4** | D30EUR 970911/970912 | L+S insieme | ⚪ mai misurato separato |
| **SupertrendReversal Nikkei** | 225JPY 770901/770924 | L+S insieme | ⚪ mai misurato separato |
| **SuperWave_DOW_H1** | U30USD 770511 | L+S insieme (PF 1,52 · 227 tr · 9/9 combo pos.) | ⚪ mai misurato separato |
| **SuperWave H2** | U30USD 770531 | L+S insieme (R23) | ⚪ mai misurato separato |
| **EMA200 Dow** | U30USD 771531 | L+S insieme (R29 regione 30/30 PASS · 712 tr in R103 — il campione piu' grosso degli indici) | ⚪ mai misurato separato |
| **PTE Dow** | U30USD 771321 | L+S insieme (R23) | ⚪ mai separato su Dow (lezione famiglia: GBPUSD ok / USDJPY no) |
| **PunteLarry Dow** | U30USD 772341 | **L+S dichiarato nel contratto** (PF 1,78→1,91) | ⚪ mai misurato separato |
| **GapFill Dow / Nikkei** | U30USD 772234 · 225JPY 772235 | simmetrico per costruzione (la direzione la sceglie il gap) | ⚪ mai misurato separato |
| **GapContinuation Nikkei** | 225JPY 774101 | simmetrico — **MA il lato short e' MISURATO IN PERDITA** (−2.182 OOS, scritto nel contratto): gira lo stesso per la regola R52 (_"non si spegne un lato guardando i risultati"_) | 🔴 misurato, perde — dichiarato, non e' un buco |

> 📌 **Nota di metodo su questa tabella (1d):** misurare i lati di questi
> motori NON e' "accendere uno short nuovo": e' la **diagnostica dei lati**
> che R54/R98/R107 hanno gia' fatto altrove — si DICHIARA, non si sceglie
> (regola R52). Ma e' anche l'unico posto del parco dove la parola "short
> sugli indici" **non ha ancora nessun numero accanto.**

### 1e. Altri motori morti sugli indici (per completezza, entrambi i lati)

| Motore | Sym | Verdetto |
|---|---|---|
| IntradayMomentum (paper Gao/Han/Li/Zhou) | NASUSD | 🔴 R98: 0/6, S0 impossibile. Diagnostica lati: **short PF 0,37 IS / 0,92 OOS — perde OVUNQUE** |
| SuperWave DAX H1 / NAS H4 / oro | vari | 🔴 morti allo screen (registro §SuperWave) |
| SupRev_DOW_H4 (970914) | U30USD | 🔴 promozione REVOCATA (illusione OHLC, RT 0,79) — gira "scartata in osservazione" |
| Aperture FTSE / Dow (motore aperture) | 100GBP/U30USD | 🔴 morti 26/07 ("il breakout d'apertura funziona SOLO sul DAX, SOLO LONG") |

---

## 2. ⛔ GLI SHORT GIA' BOCCIATI — la lista dei caduti (NON si ripropongono)

1. **DAX Apertura-retest SHORT** — R107, PF 0,957 OOS · **n 257** (l'unico
   misurabile a pieno titolo) · rosso anche nell'IS con la discesa dentro.
2. **Dow Apertura-retest SHORT** — R54 (PF OOS 0,840, n 73), riprodotto al
   millesimo da R107.
3. **NASUSD Apertura-retest SHORT** — R107 (PF OOS 0,460): la geometria del
   Dow non si trasporta.
4. **ORB Dow SHORT** — R54: PF OOS 0,520 · DD 26,37% — asimmetria
   STRUTTURALE (rosso coerente in entrambe le finestre).
5. **ORH rimbalzo SHORT (NASUSD + D30EUR)** — R43: 0/8 OOS su entrambi.
6. **FADE estremi apertura (che include gli short)** — R42: 0/48.
7. **REVERSE (short automatico dopo lo stop) DAX** — R51: riserva, peggiora.
8. **IntradayMomentum SHORT NASUSD** — R98 diagnostica: perde in IS e OOS.
9. **GapContinuation SHORT 225JPY** — misurato in perdita (−2.182 OOS),
   dichiarato nel contratto; gira per la regola R52, ma NON e' un modello da
   estendere.
10. _(caso speculare, per memoria)_ **MaxMinNotte DAX LONG** — sweep 26/07:
    morto; la famiglia vive SOLO short.

## 3. 📣 I VIVI LONG-ONLY (o short-only) PER MISURA — dichiarati, gia' coperti da R107

- `ABTG_DAX_Apertura_EU` 770101 → **long-only per misura** (short: R107 ⛔).
- `ABTG_Dow_Apertura_US` 770202 → **long-only per misura** (short: R54+R107 ⛔).
- `ABTG_ORB_Ottimizzato` 770611 → **long-only per misura** (short: R54 ⛔).
- `ABTG_MaxMinNotte_DAX_Short_Ottimizzato` 770411 → **short-only per misura**
  (long: sweep 26/07 ⛔).
- Tutti gli altri vivi sugli indici (tabella 1d) girano **simmetrici**: il
  loro short e' in campo, ma **non ha mai avuto un numero suo**.

## 4. 🏗️ COSA E' GIA' IN CANTIERE dalla caccia M5/M15 (25/08) — lo short simmetrico arriva da qui

| Candidato | Short simmetrico? | Stato |
|---|---|---|
| 🥈 **P2 — ATR Exhaustion & Volume Spike** (`ABTG_AtrExhaustVol.mq5`, porting FATTO) | ✅ **SI' — R109 ha GIA' 3 celle `01_short` esplicite** (D30EUR 774420 · U30USD 774440 · NASUSD 774460), lato per lato, magic vergini | 📋 criteri scritti, **[DA FIRMARE]**; prima compilazione ancora da fare |
| 🥇 **P1 — VWAP Mean Reversion** (motore, non filtro — differenza misurata 0/5 vs 30/30) | ✅ specchio esatto per lo short (banda +1σ) — **ed e' lo short "di meta' seduta" che la flotta non ha** (fascia 10-16 server VUOTA, caccia §5.6) | 📝 bozza prova congelata (`VWAPREVERT_DAX_M15_BOZZA.txt`); **EA da scrivere** (5-7 ore) |
| 🥉 **P3 — Out of the Noise (Zarattini)** | ✅ short simmetrico sotto il cono | 🟡 in coda (7/10), dopo P1/P2 |

👉 **La Seconda Caccia sui lati short delle aperture e' quindi GIA' assolta**
(lo dice R107 stesso, §A REGISTRO): i meccanismi alternativi sono questi tre,
non un'altra griglia sul motore apertura.

---

## 5. 🎯 LA LISTA ORDINATA — gli "short mai misurati" proponibili come round

_Ordine di casa: motore gia' vivo di suo > porting gia' fatto > da costruire.
Esclusa R109, che e' gia' in coda con le sue 3 celle short (non serve
proporla: serve la firma)._

| # | Proposta | Perche' | Costo |
|---|---|---|---|
| 1 | **I LATI del SupertrendReversal indici** — celle `solo-long`/`solo-short` su NAS H1 (970913, la prop-friendly) e DAX H1/H4 | Motore VIVO e validato che gira simmetrico da luglio senza che lo short abbia MAI avuto un numero suo. Zero codice: schema celle di R109, vivi mai toccati (modello R107) | zero righe di codice |
| 2 | **I LATI di SuperWave Dow H1 + EMA200 Dow** | Gli altri due simmetrici vivi, e coi campioni piu' GRASSI degli indici (227 e 712 trade in R103): l'unico posto dove un verdetto short puo' arrivare con n≥150 senza aspettare anni | zero righe di codice |
| 3 | **BREAKIN del box notturno su DAX/Dow** (falsa rottura → reversal, motore `ABTG_LiquiditySweep`) | Meccanismo ALTERNATIVO vero sull'inefficienza della notte (sweep, non breakout): il lato short (sweep del massimo → giu') non e' mai stato misurato su un indice. R89 era morto di FAME di livelli (14 trade), non di merito: il box notturno ne da' ~250/anno per lato. Spec gia' scritta (§7b ANALISI_NIGHTLY_PDF) | file prova da scrivere, EA esiste |
| 4 | **Nightly FADE sugli indici** — il round che il bug ha impedito | _"Non e' stato bocciato: non e' stato misurato"_ (rettifica 23/08, ZERO trade per il filtro QB rotto su indici). Fade = meccanismo opposto al breakout vivo di MaxMinNotte: complementare, non doppione | fix di un filtro, EA esiste |
| 5 | **VWAP Mean Reversion, lato short** (P1 della caccia) | Il candidato n.1 della caccia e' ANCHE il candidato short piu' pulito: simmetrico dal primo giorno, lavora a meta' seduta (buco di scorrelazione dichiarato) e nel laterale. Bozza prova gia' congelata | EA da scrivere (5-7 h) |

### ⚠️ La nota di regime che vale per TUTTE e cinque (scritta prima, per non raccontarsi storie dopo)

**Lo storico indici a BCM e' 21-23 mesi quasi tutti di salita: QUALUNQUE
short parte svantaggiato per regime, e un rosso qui boccia l'epoca, non il
meccanismo** (l'ha dimostrato R107: NAS short PF 3,22 nell'IS con la discesa
dentro, 0,46 nell'OOS di salita). **La prova vera e' la PROVA DI REGIME
(decisione D3 dei criteri R107: round dedicato) — che oggi e' BLOCCATA dal
frigo dei dati esterni indici**: `NASUSD_EXT` / `225JPY_EXT` / `SPXUSD_EXT`
non passano il cancello 0,05% e la decisione metro-assoluto vs metro-relativo
aspetta le due misure lampo sul PC di Claudio
(`ANALISI_CANCELLO_ZERO_EXT_2026-08-25.md` §6: con le stime attuali _"il
frigo, oggi, e' giusto con entrambi i metri"_). Finche' quel cancello non si
scioglie, ogni verdetto short di questa lista nasce con l'etichetta
**"per questa epoca"** — e le proposte 1-2, che misurano lati di motori GIA'
vivi, sono le uniche che valgono la pena anche dentro il regime unico,
perche' il loro rischio (DD del lato) e' un fatto, non una stima
(Emendamento B: _"il vecchio giudica il rischio, il recente il merito"_).

---

_Compilato il 25/08/2026, solo lettura d'archivio. Nessun numero nuovo,
nessun file di R107/R108/R109 toccato. Se un referto e questa mappa
divergono, comanda il referto._
