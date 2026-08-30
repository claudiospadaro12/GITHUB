# INVERSIONE DA ESAURIMENTO — screening OHLC: E1 (l'ipotesi firmata) FALLISCE, ma E3 (la conferma) e' VERDE e batte i fade caduti

_Corsa: 30/08/2026 14:29, pin `d13883a65af3890c4a2b895c570e6216570c8245`. EA nuovo
`ABTG_InvEsaurimento` v1.00 (compilato OK 81 KB, primo compile riuscito). Model 1
OHLC screening, NASUSD_EXT M15, finestra intera 2017.01.01->2020.07.01, rischio
0.65%, SL floor 500. Gemelli IDENTICI. Zip: INVES_DRIVE_CORSA_20260830_1429.zip._

## LA TABELLA (ablazione a stella, finestra intera)

| cella | n | PF | DD% | Profit | asp/trade | pegg.gio |
|---|---|---|---|---|---|---|
| **00_baseline** (inversione nuda al livello) | 323 | **1.00** | 9.25 | +14 | +0.04 | -1.30 |
| **01_E1** (esaurimento >=1.0x ADR14 — LA CHIAVE firmata) | 68 | **0.95** | 9.93 | -944 | -13.9 | -1.90 |
| **02_E3** (perdita di spinta, 2-3 barre calanti) | 215 | **1.16** | 8.16 | +6422 | **+29.9** | -1.29 |

## LA LETTURA (FORMA OHLC, non numeri fini)

**1. Il baseline nudo e' una MONETA — confermato.** PF 1.00, +14 su 323 trade =
zero. L'inversione nuda a un livello e' il fade morto del cimitero. Atteso.

**2. E1 (l'esaurimento ADR, l'ipotesi CHE HAI FIRMATO) NON FUNZIONA.** Il filtro
">=1.0x ADR14" taglia il campione a 68 e PERDE (-944, PF 0.95). Cioe': "la
giornata ha gia' speso troppo range" NON e' la variabile che seleziona le
inversioni vincenti. **Onesto: l'abbiamo misurato e la chiave firmata non gira.**

**3. E3 (la CONFERMA di spinta persa) e' l'UNICO VERDE — e sorprende.** Le 2-3
barre a range calante al livello alzano l'inversione da moneta (PF 1.00) a
**modestamente verde (PF 1.16, +30/trade)**, tenendo il DD BASSO (8.16%) e la
peggior giornata piccola (-1.29%). n=215 >= 150 -> **merito MISURABILE.**

## IL VERDETTO PROVVISORIO (e la lezione che CONVERGE con tutto oggi)
- **La variabile viva NON e' l'esaurimento grezzo (ADR), e' la CONFERMA** (la
  spinta che muore al livello). E3 batte E1 batte baseline.
- **E questo E' esattamente cio' che le cacce DAX e Dow di oggi hanno detto in
  parallelo**: il fade NUDO e' morto (R42/R60/R108/R109), la variabile
  discriminante e' la CONFERMA (Dow "Model B": failure-evidence + follow-through;
  DAX ReEntry: rottura-oltre + reclaim confermato). **Tre fonti indipendenti +
  una misura in casa dicono la stessa cosa: conferma, non esaurimento nudo.**
- **E3 BATTE i fade caduti** (R108/R109: DD 44-68%, in perdita): E3 ha DD 8.16% e
  +6422. Sul metro della firma (sez.5 "deve battere i caduti"), E3 lo fa, e su
  entrambi gli assi (edge E rischio). NON e' il fade morto.

## I DUE CANCELLI ANCORA CHIUSI (niente promozione)
1. **OHLC INGANNA**: PF 1.16 e' la FORMA. A tick puo' scendere (come FASE 2:
   1.32 OHLC -> 1.08 tick). Verdetto tick SOLO sulla cassaforte 2024.09->2026.
2. **LETTURA PER REGIME — la decisiva — DA FARE**: il totale 2017-2020 diluisce.
   E3 sopravvive al CROLLO 2020 (la prova firmata) o e' tutto toro/laterale?
   Serve il per-trade CSV `abtg_trades_ABTG_InvEsaurimento_NASUSD_EXT_769020.csv`
   (E3) in Common\Files, segmentato per regime.

## AGGIORNAMENTO: LETTURA PER REGIME DI E3 (769020) — il verde totale INGANNA

| regime | n | tot_net | asp/tr | win% |
|---|---|---|---|---|
| 2017 TORO | 59 | **-5604** | -95.0 | 57.6 |
| Q4-2018 ORSO | 18 | +2946 | +163.7 | 72.2 |
| 2019 LATERALE | 2 | -1107 | (n=2) | 0 |
| CROLLO-GIU 2020 | 3 | -73 | (n=3) | 66.7 |
| RIPRESA-V 2020 | 9 | +839 | +93.2 | 77.8 |
| resto 2020 | 9 | +5597 | +621.9 | 66.7 |

**E3 NON e' un motore robusto: e' una MEAN-REVERSION REGIME-CONDIZIONALE.**
- **PERDE nel toro pulito 2017** (-5604, -95/trade): un'inversione bleeda in un trend.
- **VINCE nel volatile/bilaterale** (orso Q4-2018 +2946, ripresa-V +5597 nel
  resto-2020): quando il mercato oscilla, l'inversione confermata paga.
- Il +6422 totale e' la SOMMA di questi opposti: **il totale diluisce, per regime
  e' una moneta SUL REGIME** (verde in volatilita', rosso in trend).
- Campioni per regime THIN (18/9/9/3/2 tranne 2017): merito per-regime SOSPESO.

**Conseguenza pesante e onesta**: la cassaforte tick 2024.09->2026 e' un TORO
PULITO -> E3 la' dentro PROBABILMENTE PERDE (come ha perso nel 2017). Quindi un
verdetto tick "cosi' com'e'" e' quasi certo rosso. E3 **non e' un mattone stabile**:
e' un motore che serve VOLATILITA', e per essere dispiegabile vorrebbe un GATE DI
REGIME (si accende solo in alta volatilita'/mercato bilaterale) -- lo stesso schema
dello short crash-only.

## CONSEGUENZA (aggiornata, onesta)
- La chiave firmata E1 (esaurimento ADR) e' bocciata. E3 (conferma) e' VERDE nel
  TOTALE ma REGIME-CONDIZIONALE per regime: paga in volatilita', perde nel toro.
- La lezione della CONFERMA (E3>E1>baseline) resta valida e converge con DAX/Dow.
  Ma E3 non e' promuovibile as-is: e' vol-dipendente, servirebbe un gate di regime.
- Questo allinea E3 allo SHORT crash-only e alla tesi pomeridiana Dow: sugli indici,
  i motori reversal/mean-reversion sono VOLATILITA'-condizionali, non all-weather.
- Prossimo utile: NON forzare E3 sulla cassaforte-toro (perderebbe); piuttosto il
  suo edge (e quello dello short) va cercato dietro un GATE DI VOLATILITA'/REGIME,
  misurato. Nessun forward toccato.
