# CACCIA ACCADEMICA — anomalie intraday indici da paper — 30/08/2026

## RISULTATO IN UNA RIGA
~15 meccanismi mappati (SSRN, arXiv q-fin, journal), 5 filoni letti in dettaglio.
**ZERO promossi.** Non pigrizia: il filone "anomalia intraday su INDICE SINGOLO" e'
STRUTTURALMENTE CHIUSO per noi, per tre muri misurati. Sapere negativo: NON
ri-cacciare l'accademia sull'index-level intraday.

## I TRE MURI STRUTTURALI (perche' il filone e' chiuso)
1. **CROSS-SECTIONAL != mono-indice**: le anomalie piu' forti (End-of-Day Reversal
   di Baltussen-Da-Soebhag; Tug-of-War overnight/intraday di Lou-Polk-Skouras) sono
   spread di DECILI su 50-500 titoli. Non abbiamo 500 azioni USA su BCM, non e' il
   nostro mestiere. Non traducibili in EA mono-indice.
2. **La versione INDEX-LEVEL e' gia' caduta**: Market Intraday Momentum (Gao et al.,
   il primo mezz'ora predice l'ultimo sull'S&P) = morto in casa a tick (R98, lordo
   -0.31 pt/op su 410) e debole fuori (DAX: "no excess return positivo", R^2 ~0.9%).
3. **Niente dati orso/crollo a tick sugli indici**: tick BCM dal 26/09/2024 ->
   nessun orso nei dati. Ogni verdetto orso resta screening OHLC su _EXT, mai
   real-tick.

## I MECCANISMI ESAMINATI (tutti SCARTO)
- **M1 End-of-Day Reversal** (SSRN 5039009): cross-sectional, non traducibile. 2/10.
- **M2 Pre-FOMC Drift** (Lucca-Moench JoF 2015): index-level e scorrelato (sarebbe
  oro prop), MA documentato SCOMPARSO dopo il 2015 (Kurov-Wolfe-Gilbert, FRL); la
  nostra finestra dati (indici da 2024.09) e' tutta post-scomparsa; ~8 eventi/anno
  (mai 150 trade). SCARTO 3/10 — chiuso da dati+decadimento+frequenza.
- **M3 Tug-of-War intraday-short** (Lou-Polk-Skouras JFE 2019): reframe short-only
  flat-EOD riempirebbe il buco short, MA blanket-short combatte il drift azionario
  (melt-up mangia il cap prop 5%); l'unica forma difendibile (short GATED da regime
  orso) e' GIA' in caccia (SHORTGATE). SCARTO come blanket 4/10.
- **M4 Market Intraday Momentum** (Gao JFE 2018): CADUTO R98. 0/10.
- **M5 Intraday TSMOM international**: stesso motore R98. 1/10.

## L'UNICO LEAD (e non viene dall'accademia, viene da NOI)
La domanda che ha senso NON e' "quale paper proviamo" ma:
> **Il last-2h-reversal / first-2h-momentum gia' trovato per il Dow (caccia Dow
> 30/08) e' mai stato TESTATO come EA intraday-flat mono-indice, o solo "trovato"?**
E' l'unica anomalia insieme index-level + intraday-flat + reversal (!= R98 momentum,
!= R42 opening-fade, != R99 VWAP) + aggancio economico serio (hedging demand dei
leveraged-ETF a fine giornata, Baltussen). Se mai messa in griglia, quello e' il
round -- e viene dalla nostra scoperta sul Dow, non da fonte esterna.

## NON VISTO
PDF accademici egress-bloccati (nd.edu, efmaefm, pmc, alphaarchitect, reading);
numeri da abstract/snippet [NON verificati sulla pagina], regola/finestra/segno si'.
