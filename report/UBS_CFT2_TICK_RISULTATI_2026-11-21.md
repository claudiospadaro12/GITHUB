# UBS forex a TICK REALI, 22 mesi (21/11/2026): risultati delle 17 passate
**Natura: MISURA.** Sorgente: `ANNO_ORO_GRADINI_UBSCFT2_20261121_2342.zip` (17 passate, Modello 4 = tick reali BCM, 01/01/2025-13/11/2026, deposito 100.000 EUR, lotto fisso 0,1, qualita 100% tick reali in tutte, nessuno stop out, input ok). Criteri di fondo: `UBS_NON_ORO_F2F7_CRITERI_2026-11-21.md` (lente tick informativa).

| Set | Famiglia | Operazioni | Profitto EUR | PF | DD equity |
|---|---|---|---|---|---|
| CLI_HJP09 | D1 (OTH/CLI) | 34 | -129.77 | 0.84 | 0.44% |
| CLI_HJP10 | D1 (OTH/CLI) | 34 | 63.93 | 1.08 | 0.42% |
| OTH_EU_b | D1 (OTH/CLI) | 28 | -257.99 | 0.80 | 0.56% |
| OTH_GU_a | D1 (OTH/CLI) | 49 | -621.21 | 0.70 | 1.10% |
| SCALP_EU_SL17 | scalper | 304 | -75.55 | 0.88 | 0.25% |
| SCALP_EU_SL22 | scalper | 300 | 82.80 | 1.20 | 0.07% |
| SCALP_GU_H1 | scalper | 243 | 13.35 | 1.03 | 0.08% |
| SCALP_UJ_H1 | scalper | 503 | -155.08 | 0.82 | 0.19% |
| SCALP_UJ_H4 | scalper | 489 | -77.01 | 0.94 | 0.25% |
| VOL_C10 | volatility | 35 | 163.32 | 1.32 | 0.20% |
| VOL_C20 | volatility | 41 | -56.03 | 0.92 | 0.27% |
| VOL_C37 | volatility | 28 | 151.91 | 1.42 | 0.12% |
| VOL_C63 | volatility | 42 | -5.13 | 0.99 | 0.14% |
| VOL_e | volatility | 31 | -30.47 | 0.91 | 0.15% |
| VOL_f | volatility | 43 | -42.04 | 0.92 | 0.19% |
| VOL_k | volatility | 25 | -47.57 | 0.88 | 0.15% |
| VOL_o | volatility | 39 | 37.10 | 1.07 | 0.11% |

**Somme (lotto 0,1, EUR):** tutte e 17 = -985; 5 scalper = -211 (PF 0,82-1,20, mediana 0,94); 8 volatility = 171 (PF 0,88-1,42, 25-43 operazioni ciascuno); 4 D1 (OTH/CLI) = -945 (PF 0,70-1,08, 28-49 operazioni).
**Lettura (esito di Claudio da leggere con prudenza):**
- **Pool A (i 7 set che avevano passato F5 a barre M1) a tick: somma -216 EUR in 22 mesi, 3 su 7 con PF > 1** (SCALP_EU_SL22 1,20, SCALP_GU_H1 1,03, VOL_o 1,07). **Conferma la lente tick del 15-21/11: F5 a barre M1 non regge a tick.** Gli scalper (Wim stesso: "scalpers always perform well in demo, much less in live") non danno un vantaggio misurabile.
- **Nessun set raggiunge 60 operazioni con PF >= 1,2 e DD basso** a parte SCALP_EU_SL22 (300 operazioni, PF 1,20, +83 EUR in 22 mesi = circa 3,8 EUR al mese a 0,1 lotti): vantaggio economico minimo; da solo non e un candidato.
- **I volatility e i D1 hanno 25-49 operazioni in 22 mesi: campione troppo piccolo.** Sopra 1,2: VOL_C10 (1,32; 35), VOL_C37 (1,42; 28); sono indizi, non candidati. OTH_GU_a (PF 0,70) e il peggiore.
- **Conseguenza per le ottimizzazioni:** su dati forex pre-2024 esiste solo il Modello 1 (barre da 1 minuto), che regala agli scalper circa 1,4-2,0 EUR per operazione. Un'ottimizzazione forex a barre M1 senza un minimo di payoff per operazione selezionera quel regalo: **per ogni gruppo forex H1/M15/M5 il criterio Custom max deve avere un expected payoff minimo che copra il costo a tick** (da fissare nei criteri della campagna) e ogni candidato va riconvalidato a tick sul 2025-26.
- Limiti: 22 mesi, un solo regime; set di Wim non ottimizzati da noi; nessuna commissione oltre allo spread dei tick reali.
