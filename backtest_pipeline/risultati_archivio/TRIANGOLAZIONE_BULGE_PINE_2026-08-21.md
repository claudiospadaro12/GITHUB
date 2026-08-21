# TRIANGOLAZIONE DI FEDELTA' — BULGE: Pine di Claudio vs EA
**21/08/2026** — fonte: `docs/breaking_band/indicatore_inbulge_claudio.pine` (sorgente
integrale, salvato oggi) contro `mql5/Experts/BULGE_MASTER.mq5` righe 745-905.

## VERDETTO: e' IL PINE GIUSTO
L'IN-BULGE del Pine e' **condizione per condizione identico** a `origLong1`/`origShort1`
dell'EA, che e' la base da cui nascono ARANCIO e BLU. Non serve cercarne altri.

| # | condizione (Pine)                        | EA (`origLong1`, riga 840)          | esito |
|---|------------------------------------------|-------------------------------------|-------|
| 1 | `isBulge` = width >= SMA50(width) x 1.1  | `isBulge1`, `Bulge_Multi=1.1`, `BB_Width_Len=50` | = |
| 2 | `barsSinceImpDown >= 1`                  | idem                                 | = |
| 3 | `barsSinceImpDown <= lookbackBars` (20)  | `<= Lookback_Bars` (20)              | = |
| 4 | `not midAfterImpDown`                    | `!midAfterImpDown`                   | = |
| 5 | `not oppAfterImpDown`                    | `!oppAfterImpDown`                   | = |
| 6 | `bullReaction` = close>open and low<=lower | `bullReaction1` su barra 1         | = |

Anche impulso (`tocco banda + corpo >= 0.2 ATR`), mediana toccata, banda opposta toccata
e banda piatta (`|banda - banda[6]| <= 0.6 ATR`) coincidono. L'EA misura su **barra 1**
(chiusa) invece che su barra 0: traduzione corretta, distanza di 6 barre conservata
(`bbUSeries[7]` contro `bbUpper1`).

## COSA CHIUDE (domanda aperta dal 12/08)
L'IN-BULGE entra **in fade sulla banda DELL'IMPULSO**, non sul retest della banda
opposta come dice la guida di Leonardo. Il Pine lo dimostra: `bullReaction` chiede
`low <= lower` DOPO un `impulseDown` che aveva toccato la **stessa** banda inferiore,
e `not oppAfterImpDown` **esclude** che la banda opposta sia stata toccata.
Non e' piu' "da chiarire": e' dichiarato.

## LE TRE DIFFERENZE (EA - Pine)
1. **ARANCIO** = IN-BULGE + `closes[1] >= meta' della candela d'impulso`.
   Non c'e' nel Pine: e' un cancello aggiunto dopo da Claudio.
2. **BLU** = IN-BULGE + conferma su barra 0 (`close0>open0`, non ritocca la banda,
   `close0 > lows[1]`). Non c'e' nel Pine: aggiunto dopo, esattamente come Claudio
   ricordava ("l'arancio era + rischioso, ho fatto la seconda candela di conferma").
3. **VIOLA — DIVERGENZA VERA.** Il Pine chiede come ultima condizione `close > open`
   (candela di reazione verde). L'EA l'ha **sostituita** con
   `candleNotImpulsive = |close0-open0| <= 1.5 x ATR`.
   Conseguenza misurabile: l'EA apre POST-BULGE long anche su **candele rosse**, che
   il Pine scartava. E' il segnale piu' usato (Use_Purple=true): la differenza NON e'
   cosmetica. [DA DECIDERE di Claudio: quale delle due versioni e' quella che ha
   prodotto il backtest PF 1,599 / 80,22%?]

## CANARINO GROSSO (trovato dall'agente, confermato qui)
`OnTick` righe 298-306: `CheckSignal` gira **solo al primo tick di una barra H1 nuova**
(`barTime != g_lastBarTime`). A quell'istante `closes[0] == opens[0]`, quindi
`confirmLong = closes[0] > opens[0]` e' **falso per costruzione**.
=> Il **BLU non puo' scattare** sul simbolo del grafico. I 268 trade del backtest di
Claudio sarebbero quindi quasi tutti **VIOLA**.
Verifica tentata sul suo `BULGE_MULTI_SIGNAL_CLAUDIO_3.xlsx`: il foglio **non contiene
la colonna dei commenti** (zero stringhe nel worksheet), quindi da li' non si decide.
Si decide con **una passata singola** che stampa `[BULGE-CONTA] BLU=x VIOLA=y ARANCIO=z`
(contatore gia' scritto nell'EA nuovo). Se BLU=0, il round misura solo il VIOLA.
