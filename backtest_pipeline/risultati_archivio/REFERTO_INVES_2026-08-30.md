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

## CONSEGUENZA
La chiave firmata (E1 esaurimento ADR) e' bocciata onestamente. Ma il round NON e'
un buco: E3 (conferma) e' un candidato VERDE a basso DD che batte i caduti, e
allinea la misura di casa con le due cacce di oggi. Prossimo passo: lettura per
regime di E3 (serve il per-trade CSV), poi conferma a tick. Nessun forward toccato.
