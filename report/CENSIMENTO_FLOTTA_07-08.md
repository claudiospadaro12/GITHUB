# 📋 CENSIMENTO DELLA FLOTTA — 07/08/2026, ore 21:46

Primo censimento **misurato** di cosa gira sul VPS, fatto con `elenco_ea_attaccati.ps1`
(riscritto stasera dopo che la prima versione aveva trovato 0 EA su un VPS che ne fa girare
più di trenta). Due fonti: i **log di MT5** (ogni riga porta in testa `Nome (SIMBOLO,TF)`,
lo scrive il terminale, non l'EA — quindi compaiono anche gli EA muti) e i **profili dei
grafici** (`.chr`, cosa è attaccato adesso).

## Il numero che cambia tutto

```
righe dichiarate in flotta_attesa.csv (fino a stasera):   34
coppie EA+simbolo TROVATE nei log degli ultimi 3 giorni:  51
grafici con un EA nel profilo attivo ('ORO'):             52
```

**La flotta reale è circa metà più grande di quella dichiarata.** E la parte non dichiarata
non è fatta di doppioni: sono **mercati interi mai discussi** — il Nikkei (`225JPY`),
l'argento (`XAGUSD`), l'ASX 200 (`200AUD`), lo S&P (`SPXUSD`), più NZDUSD, USDCAD, USDCHF,
EURJPY, AUDJPY, GBPJPY. Su **nessuno** di questi esiste una misura.

## Esito 1 — CONFERMATI (le ipotesi diventate fatti)

Le 20 righe `da_confermare` erano ipotesi costruite dallo storico. Ora:

- **13 confermate attaccate** → passate a `in_prova` con `verificato=censimento`:
  SUPERWAVE EA 3, NIGHTLY S, EMA200 OTT S1/S2, STREV S 1/3, STREV MULTI S 2/3,
  STREV CAC H4 L, STREV NAS H1 L, STREV L 1/3, STREV DAX H1 L, MaxMinNotte (D30EUR),
  SUPERWAVE DOW H1, FOMC PostNews.
- ✅ **`Apertura Marco` è davvero staccato** — lo spegnimento del 06/08 ha funzionato.
  Compare nei log dei giorni prima (15 righe) e su nessun grafico.
- Tre scoperte di struttura, che semplificano il quadro:
  - **NIGHTLY L e NIGHTLY S sono lo stesso EA**: un solo grafico `ABTG_Nightly` su EURUSD.
    L/S sono le due direzioni, non due EA.
  - **EMA200 OTT S1 e S2 sono lo stesso EA**: un solo grafico `_Ottimizzato` su XAUUSD.
  - **STREV su XAUUSD sono davvero due istanze**: 16 righe di log = 2×8, e due grafici.

## Esito 2 — STACCATI (dichiarati, ma non girano)

| riga | evidenza |
|---|---|
| EMA200 S1 / S2 (D30EUR) | **nessun EMA200 gira su D30EUR** — né log né grafici |
| DAX M3 | zero righe di log in 3 giorni, nessun grafico |
| Londra ORB (GBPUSD) | su GBPUSD ci sono solo grafici BULGE, in profili non attivi |
| BULGE MULTI SIGNAL | grafici solo in profili/terminali **non attivi**, muto nei log — coerente col "non opera da due mesi" |
| IchiCross | `Gold_Ichimoku` sta su un terminale non attivo |

## Esito 3 — NON DICHIARATI (girano, e non lo sapevamo)

**17 righe nuove** in `flotta_attesa.csv`, stato `non_dichiarato` (+1 `servizio` per il
TradeExporter). Nessuna ha una misura:

```
ABTG_EMA200 (base)      XAUUSD + 5 simboli: 200AUD AUDJPY GBPJPY GBPUSD SPXUSD  (6 grafici H4)
ABTG_GoldenCross        XAUUSD H1 + NZDUSD/USDCAD/USDCHF H4 + _Ottimizzato XAUUSD (5 grafici)
ABTG_SupertrendReversal XAGUSD (argento!) · 225JPY (Nikkei!) · D30EUR H4          (3 grafici)
ABTG_SupRev_*_Ott       DAX H4 · DOW H1 · DOW H4                                  (3 grafici)
ABTG_ORB_Fibo           NASUSD M5  (un SECONDO ORB sul Nasdaq)
ABTG_HARSI              EURUSD M5
ABTG_WOL                XAUUSD D1
ABTG_SupertrendInvert   XAUUSD H1
ABTG_MaxMinNotte (base) EURUSD M15
ABTG_PostNews           EURJPY M5  (seconda istanza)
```

Tutti i file esistono nel repo: non sono EA sconosciuti, sono EA **attaccati e mai censiti**.

## ⚠️ Anomalia da chiarire

`NIGHT_BREAK_BOX_BRK_UP` sta su un grafico XAUUSD **nel profilo attivo** ma ha **zero righe
di log in 3 giorni**, mentre tutti gli altri ne hanno almeno 8. O è un **indicatore** (il
rilevatore prende il primo `.ex5` che trova nel grafico, e gli indicatori compilati sono
`.ex5` anche loro), o è un EA che non sta girando. Si chiarisce guardando quel grafico sul VPS.

## Limiti dello strumento, dichiarati (per non prendere i suoi difetti per fatti)

1. **Simboli mal letti nei `.chr`**: `SERVER`, `MEDIE`, `EMA200`, `QCQQQ` non sono simboli —
   quando il simbolo vero non è nella lista nota (o comincia per cifra, come `225JPY`), il
   ripiego prende la prima parola maiuscola che trova. I log (FONTE 1) hanno il simbolo giusto.
2. **I 4 "ha girato ma non attaccato" oltre a Marco sono artefatti di questo stesso limite**:
   `225JPY`→`SERVER`, `NZDCAD`→`QCQQQ`, `NZDUSD`→`QCQQQ`, `200AUD`→`EMA200`. L'unico EA
   davvero staccato fra quelli che hanno girato è **Apertura Marco**, ed era voluto.
3. **Istanze multiple sullo stesso simbolo collassano in FONTE 1**: SUPERWAVE EA 1 e 2 oggi
   hanno operato allo stesso secondo, ma nei log sono UNA coppia `ABTG_SuperWave_EA|D30EUR`.
   Il conteggio 51 è quindi un **minimo**, non un massimo.
4. I log coprono 3 giorni: un EA attaccato prima e sempre muto non comparirebbe. Il riscontro
   incrociato coi grafici copre questo buco (è così che è saltato fuori NIGHT_BREAK_BOX).

## Cosa NE segue (decisioni di Claudio, non mie)

1. **17 EA non dichiarati girano su mercati mai misurati.** La regola scritta in testa a
   `flotta_attesa.csv` è chiara: *un parametro che gira in forward deve corrispondere a una
   cella misurata*. Qui non c'è la cella: non c'è nemmeno il censimento. **O si dichiarano
   (e si misurano), o si spengono.** Su un conto che conta, questa non è una scelta.
2. Il tetto di esposizione di `controllo_flotta.ps1` è calcolato su chi stampa `CONFIG IN
   USO`: **9 EA su ~52 grafici**. Il disclaimer che l'esposizione reale è più alta si è
   rivelato molto più vero del previsto.
3. NIGHT_BREAK_BOX: un minuto sul VPS per guardare quel grafico.
