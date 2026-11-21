# UBS sugli indici (Indicement): criteri e previsioni per l'ottimizzazione — 21/11/2026, scritti PRIMA di qualunque numero
**Natura: CRITERI. Nessuna passata lanciata.** Solo tester/demo. VPS e reale 10105439 non toccati. Nessun giudizio su lotti/taglie/acquisti. Soglie non si abbassano dopo i numeri.
Fonte del metodo: manuale UBS (`UBS_MANUALE_PROCEDURA_2026-11-21.md`) + video app (`UBS_OPTIMIZER_VIDEO_2026-11-14.md`). Set di partenza: `Indicement/USTEC(H1)/optimization.set` (NASUSD_EXT), `Indicement/US500/optimization.set` (SPXUSD_EXT). EA `Ultimate_Breakout_EA_WSC_V9.5`, Run_Strategy=1 (S/R breakout), ST1 su H1.

## 1. Cosa e noto
- `NASUSD_EXT`/`SPXUSD_EXT`: 17 anni (2010-2026) solo nel terminale principale BCM, NON nel portable `C:\MT5_BCM_Opt` (`COPERTURA_BTC_INDICI_2026-11-18.txt`). Nessun dato per il Dow prima del 2024: **Dow escluso**.
- Dati `_EXT`: spread = 0, tickvol = 1, nessun tick reale. Orologio verificato solo nei blocchi 2015, 2020, 2025-26 (CLAUDE.md). Il S/R breakout su H1 non dipende dall'ora di apertura, ma il limite resta dichiarato; GMT/news/orari restano spenti (come Wim).
- Tick reali BCM solo da 07/2024 e solo sui simboli nativi (`NASUSD`, `SPXUSD`).
- Wim stesso dice che i dati MetaQuotes sugli indici non bastano (usa IC Markets): rischio di dati.

## 2. Passo 0 (CORRETTO prima dei numeri: nessuna esportazione/importazione)
`ANNO80K_WIM_TESTER.ps1` ha come bersaglio il terminale PRINCIPALE BCM, dove `NASUSD_EXT`/`SPXUSD_EXT` esistono gia (17 anni). **Le ottimizzazioni sugli indici girano nel terminale principale, non nel portable**: nessuna copia di simboli. Il Passo 0 e una riga di sola lettura (`RIGA_PREP_INDICI_UBS.txt`): anni dello storico `_EXT`, tick nativi, presenza dell'EA V9.5, dei set Indicement e dei file di ottimizzazione, MT5 aperti, spazio libero. Resta da fare, prima della passata: copiare i set di ottimizzazione nel terminale e una passata di prova di pochi giorni (fumo) che dimostri che l'EA apre operazioni su `NASUSD_EXT`.

## 3. Finestre (fisse, non si cambiano)
- **Dentro-campione IS: 2010-01-01 -> 2019-12-31** (10 anni, come Wim). **OOS: 2020-01-01 -> 2023-12-31.** **Hold-out: 2024-01-01 -> 2024-12-31**, aperto UNA volta, solo sui finalisti. **Test a tick (V3): 2025-01-01 -> 2026-10-31 su `NASUSD`/`SPXUSD` nativi**, Modello 4 contro Modello 1 stessa finestra (non si sovrappone all'hold-out).
- Modello 1 (1 minuto OHLC), deposito 100000 EUR, leva 1:100, lotto fisso 0,1 con "Adjust Lotsize to Variable Values" (come i set), no forward, no delay, agenti locali, no cloud.

## 4. Ottimizzazione
Genetica veloce, criterio **Custom max** (6), intervalli e minimi (EP, RF, TR) **cosi come nei set di Wim**, nessun intervallo modificato. Una per simbolo (NASUSD_EXT poi SPXUSD_EXT), tetto 300 minuti l'una. **Contatore tentativi = passaggi realmente eseguiti (da riportare nel referto)**, sommati al conteggio di campagna.
**Controllo C0:** i set pubblicati di Wim (US100_1-4, US500a-f) provati sulle stesse finestre senza ottimizzare. Se i suoi set non passano l'IS, lo scriviamo prima di guardare gli ottimizzati.

## 5. Selezione e cancelli
- Selezione: ordinati per Result, per recovery e per DD; fino a **10 candidati per simbolo** scelti per curve DIVERSE (regola 40% migliori / 30% piu diversi / 30% a caso fra idonei, come l'app). Idoneo IS: PF >= 1,30, operazioni >= 100, recovery >= 1,5, profitto > 0, anni positivi >= 60%.
- **V1 (OOS 2020-23):** PF >= 1,20, operazioni >= 30, profitto > 0, anni non negativi >= 60%.
- **V2 perturbazione:** variando di un passo ciascun parametro libero, >= 70% delle varianti con PF > 1,0 in IS e in OOS.
- **V3 (tick):** PF tick/M1 >= 0,7; DD tick <= 1,5 x M1; operazioni +-10%. Sotto 0,5 = bocciato.
- **V4 (hold-out 2024):** PF > 1,0 se operazioni >= 8, una sola volta.
- **Costi:** spread `_EXT` = 0. Fino a quando non si misura lo spread BCM reale (foto del Market Watch), ogni PF e dichiarato **lordo**; dopo, si sottrae per operazione 1x e 2x lo spread misurato.
- **Correlazione:** tra finalisti e con Donchian D1 / EA oro, a parte, sulle operazioni (non per forza esclusione).
- Se due finalisti hanno correlazione giornaliera > 0,7, se ne tiene uno.

## 6. Previsioni (scritte ora)
- **I-1** La passata di fumo apre operazioni su `NASUSD_EXT` al primo tentativo: 70%.
- **I-2** I set di Wim (C0) hanno PF >= 1,30 in IS su NASUSD_EXT: 35%; su SPXUSD_EXT: 35%.
- **I-3** Almeno un ottimizzato passa i filtri IS: 85% (ottimizzare lo garantisce).
- **I-4** Almeno un candidato per simbolo passa V1: 30%.
- **I-5** Almeno uno passa V1 + V2: 15%. V1 + V2 + V3 + V4: 5%.
- **I-6** Verdetto indici: "nessun candidato" 60%, "vantaggio debole non confermato" 30%, "candidato credibile" 10%.
- **I-7** Il rapporto PF tick/M1 sugli indici e >= 0,7 per i finalisti: 55%.

## 7. Cosa NON sappiamo
Se i dati `_EXT` 2010-2014 e 2016-2019 sono affidabili (verificati solo 3 blocchi); spread reale; se il nativo e confrontabile con l'EXT nel 2025-26; se 5 ore per simbolo bastano.

## 8. Peso
Passo 0 (sola lettura, pochi secondi) + passata di fumo + 2 ottimizzazioni da circa 5 ore ciascuna + circa 40 passate di convalida: **circa 12 ore di PC**, da lanciare solo a test a tick finito.
