# REFERTO — Il weekend della flotta: 42 lavori, FASE 0 — 08/08/2026

La coda ha girato **tutta**: 84 CSV OHLC (42 lavori × 2 finestre) + **54 CSV a tick reali**
(27 lavori promossi × 2). Il cancello meccanico della coda e il mio ricalcolo indipendente
danno **lo stesso identico elenco di 27 promossi**: il meccanismo ha funzionato.

Finestre: IS 26/09/2024→09/06/2025 (8,5 mesi) · OOS 10/06/2025→30/06/2026 (12,7 mesi).
Rischio = default di ogni EA (non uniformato: confronti fra EA diversi solo sui rapporti,
non sugli euro).

## 0. Prima i rilevatori, poi i numeri

- **Coerenza magic-sweep**: le coppie di righe che DOVEVANO essere identiche lo sono,
  **8 su 8** al centesimo. ✅
- **Storico corto (trade/mese IS↔OOS)**: 🔴 **XAGUSD (argento) BOCCIATO come dato**: 71
  trade IS contro 336 OOS su tutti gli 11 TF insieme — la finestra IS è in gran parte
  **vuota**. Lo storico dell'argento su BCM parte molto dopo il 26/09/2024: **ogni numero
  IS su XAGUSD non vale.** ✅ Oro, Nikkei (225JPY) e i cross JPY/GBP hanno rapporti
  normali (~1,0–1,3): il loro storico copre la finestra — **B9 sull'oro è chiusa: i dati
  ci sono dal 26/09/2024.** ⚠️ SPXUSD ha rapporti normali sui TF bassi e anomali sugli
  alti: non è un buco dati, è la strategia che cambia frequenza — ma tiene i campioni IS
  piccoli proprio dove passa i criteri.
- **⚠️ Un criterio che MANCAVA, dichiarato adesso**: i criteri congelati non fissavano un
  **minimo di trade**. Risultato: celle con 11, 12, perfino 6 trade OOS "passano tutto"
  (una con PF 335: dodici trade senza una perdita = fortuna, non un sistema). **Da qui in
  avanti: minimo 30 trade OOS per dire qualsiasi cosa.** Le celle sotto soglia sono
  segnalate, non incoronate. Questo criterio nasce OGGI e vale per il futuro: sui numeri
  di questo referto è applicato dichiarandolo, non di nascosto.

## 1. 🔴 La notizia che tocca il conto: i Live5m misurati, e sono NEGATIVI

Per la prima volta i tre `Live5m` hanno numeri a tick reali, ed erano **promossi dallo
screening OHLC** — il che rende il risultato doppio:

| EA (config live) | IS | OOS | DD OOS | trade |
|---|---:|---:|---:|---:|
| DAX Live 5m | **−626,33** | **−2218,56** | **39,74%** | 225/342 |
| DAX Live5m v2 | +11,10 | −393,74 | 14,16% | 80/202 |
| Nasdaq Live 5m | +98,96 | −326,54 | 19,40% | 116/175 |

Negativi in OOS tutti e tre, il primo con un drawdown da **quasi 40%**. E girano live al
2% / 1% / 2%. **La decisione resta di Claudio, ma adesso non è più un'opinione del
diario: è una misura.**

🔎 **E la divergenza OHLC→tick è essa stessa una scoperta**: l'OHLC M1 li dava positivi,
il tick reale li massacra. Per strategie che entrano ed escono in minuti (M5), l'OHLC
non è "screening impreciso": è **fuorviante**. Regola nuova: sotto M15, lo screening
OHLC non fa nemmeno da filtro.

## 2. ❌ 15 lavori senza edge nemmeno in screening

Nessuna cella positiva in entrambe le finestre nemmeno in OHLC (che è generoso):
`EMA200@200AUD` · `GoldenCross@NZDUSD/USDCAD/USDCHF` · `MaxMinNotte@EURUSD` ·
`Nightly@EURUSD` · `ORB@NASUSD` · `ORB_Fibo@NASUSD` · **`PTE@XAUUSD`** ·
`PostNews@EURUSD/EURJPY` · `SupRev_CAC@F40EUR` · `SupertrendInvert@XAUUSD` ·
`SupertrendReversal@D30EUR` · `WOL@XAUUSD`.

**Sulla PTE**: la griglia TP1×TF (16 celle) non ha una sola cella positiva in tutte e
due le finestre. Lo storico dell'oro è ora **verificato buono**, quindi la scusa dei
dati non c'è più. È OHLC (per una strategia H4 è uno screening decente) — ma l'ipotesi
del breakeven anticipato esce molto ridimensionata.

## 3. 🥇 Chi passa i 4 criteri, a tick reali, coi vicini positivi

**`ABTG_SupertrendReversal` su 225JPY (Nikkei) — un ALTOPIANO vero: H2·H3·H4 passano
tutti e quattro i criteri**, e H1/H6/H12 sono comunque positivi in OOS:

| TF | IS | OOS | PF OOS |
|---|---:|---:|---:|
| H2 | +2,34 | +12,68 | 1,482 |
| H3 | +4,79 | +18,03 | 1,859 |
| H4 | +1,79 | +6,48 | 1,242 |

⚠️ Due caveat grossi come una casa: i **profitti assoluti sono minuscoli** (il lotto sul
Nikkei esce al minimo: euro, non centinaia di euro) e i campioni per cella sono 13–31
trade OOS, sotto il minimo dichiarato oggi. **La forma è quella giusta — l'unico
altopiano del weekend — ma serve un secondo giro con size sensata e celle aggregate
prima di parlare di prop.**

**`ABTG_EMA200` su SPXUSD H4**: OOS +567,07 · PF 1,595 · DD 2,22% (n=111), vicini H3 e
H6 positivi, e per la regola TF batte l'H1 (negativo) su tutto. ⚠️ IS a quel TF ha solo
21 trade: passa, ma con l'asterisco del campione.

## 4. 🥈 A un criterio dal traguardo (i più interessanti del weekend)

- **`MaxMinNotte_DAX_Short_Ottimizzato` @D30EUR** (config live): IS +477,51 PF 1,921 ·
  **OOS +618,31 PF 2,192 DD 1,88%**. Positivo ovunque, drawdown irrisorio. Il criterio 3
  (vicini) non è verificabile su una config unica: serve una griglia sulla SUA leva
  (finestra notturna). ~2 trade/mese: pochi ma selettivi. **Il migliore candidato "vero"
  del weekend insieme al Nikkei.**
- **`GoldenCross_Ottimizzato` @XAUUSD H1**: IS +299,35 PF 1,494 · OOS +308,30 PF 1,253
  DD 6,08% (n=57). Passa tutto il verificabile, ed è **H1** — il TF preferito.
- **`SuperWave_DOW_H1_Ottimizzato` @U30USD H1**: IS +1022,29 PF 1,849 · OOS +463,44
  PF 1,328 DD 3,91% (n=143). Fallisce il criterio 3 per **13,73 €**: H2 chiude a −13,73.
  Crinale, non altopiano — ma un crinale largo.
- **`SupRev_NAS_H1_Ottimizzato` @NASUSD**: H1 e H2 passano 1+2+4 **entrambi** (H1: OOS
  +300,61 PF 1,688 DD 0,86%) e sono adiacenti — un'isola di due celle chiusa da negativi.
  Il criterio 3 alla lettera dice no.
- `EMA200@AUDJPY H12/D1` e `SupRev_NAS H12`: passano formalmente tutti e 4 ma con
  **11, 12 e 6 trade OOS** — sotto il minimo. Segnalati, non incoronati.

## 5. 🖥️ Il resto: misurati, restano su MT5

Tutta la famiglia Supertrend su XAUUSD ha lo stesso disegno: **una cella H4 (o H3) forte
e isolata** fra vicini negativi — `_Multi_Ottimizzato` H4 fa OOS +2108 PF 2,907, ma H3 è
−701: il criterio 3 esiste esattamente per questi casi. `SupRev_DAX_H4` H4 (+320 OOS),
`SupRev_DOW_H1` H2/H4, `SupRev_DOW_H4` H4 (+622 OOS), `SupertrendReversal` NASUSD H1/H4,
XAUUSD H3, `Multi` H3: **picchi isolati, tutti**. `EMA200_Ottimizzato` @XAUUSD non passa
mai il criterio 1 (IS negativa quasi ovunque, OOS positiva quasi ovunque: un'inversione
di regime interessante ma non un candidato). `GoldenCross` base @XAUUSD: PF OOS 1,066,
sotto l'1,10. XAGUSD: non giudicabile (storico).

## Cosa NE segue

1. **Nessun cambio in forward da questi numeri** (regola di sempre). La decisione sui
   tre `Live5m` — che ora hanno misure negative — è di Claudio.
2. Prossimo giro mirato (poche ore, non un weekend): **Nikkei con size sensata**,
   **griglia sulla leva del MaxMinNotte DAX Short**, e le celle aggregate H2–H4 del
   Nikkei con minimo 30 trade.
3. Il minimo di 30 trade OOS entra nei criteri **da oggi, per iscritto**.
4. Il token sul PC di backtest resta da sistemare: stavolta i dati sono arrivati a mano.
