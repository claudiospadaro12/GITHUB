# Portafoglio scelto da Claudio per i tre conti prop: 160k + 80k + 80k (11/11/2026)

**Decisione di Claudio (11/11)**: "puntiamo su questa". Questa e la combinazione salvata. Natura: stima da backtest (tester BCM, 3 anni 2013 / 2020 / 2025, costi "centrali"), NON una previsione. Fonti: `RISULTATI_D160_ORO_2026-11-09.md`, `TRE_PROP_PROPOSTA_2026-11-11.md` (confronto e tabella dei costi), script `ORO_GRADINI_dati/tre_port.py`.

## I tre conti
| Conto | Combo | Componenti e set di Wim (nomi usati nei test) | Media annua a 80k (dopo costi) | Sul conto | PF (2013 / 2020 / 2025) | DD realizzato | Peggior giorno |
|---|---|---|---|---|---|---|---|
| **160k** | **P1** | Gold Phantom Gradino 1 (`GoldPhantom_Propfirm.set`) + Goldbot One Prop (`Goldbot_PropFirm_5_2.5.set`) + Daytrade Pro Max9 (`Daytrade_Pro_Max9%DD_lowrisk.set`) | 30.582 | **61.164** (x2) | 1,68 (1,52 / 1,82 / 1,75) | 6,5% | -4,4% |
| **80k** | **P3** | Goldbot One Combo 3GOLD (`Goldbot_PropFirm_combo_3GOLD.set`) + Gold Trade Pro Combo (`Goldtrade_V4.0_prop firm_combo.set`; nei test Risk=3, MaxRiskPerStrategy 0,5, PropFirmMaxDailyDD 4,0) + Daytrade Pro Max9 | 25.685 | **25.685** | 1,76 (1,81 / 1,92 / 1,51) | 6,7% | -4,1% |
| **80k** | **P4** | Gold Reaper Combo 3GOLD (`Gold_reaper_propfirm_combo_3GOLD.set`) + Goldbot One Prop (`Goldbot_PropFirm_5_2.5.set`) + Daytrade Pro Max9 | 24.788 | **24.788** | 1,67 (1,55 / 1,95 / 1,52) | 6,6% | -3,7% |
| **Totale** | | 320k di capitale equivalente | | **111.637 EUR/anno** (lordo, prima del profit split) | | congiunto 6,6% (2013) | congiunto -4,1% di 320k |
Per anno (totale): 2013 117.440 / 2020 132.871 / 2025 84.600. Variante P5 al posto di P4 (Phantom Prop + Goldbot Prop + Daytrade Pro): 111.227.
I nomi dei set sono quelli dei test (`gen_riga_d160_oro.py`, `gen_riga_d160_dtp.py`); prima di caricarli su un conto va verificato file per file che siano quelli delle versioni correnti di Wim (versioni EA sul VPS e sul trial NON verificate).

## Rischi noti di questa scelta (gia detti, qui per memoria)
1. **Peggior giorno realizzato -4,4% (P1) e -4,1% (P3)**: a ridosso del Guardian (4,3%) e del limite FTMO (5%). Un giorno oltre -4,3% nei 3 anni per P1.
2. **DD equity: limite superiore 12,6-13,2% per conto nel 2013** (somma dei massimi dei singoli EA, non ricostruita): sopra il 10% di FTMO. Il valore vero e sconosciuto per i conti con Daytrade Pro (nessuna barra forex).
3. **Posizioni opposte fra conti** (FTMO le vieta in modo rigoroso): oro su tutti e tre i conti, 2.451-10.718 ore a coppia in 3 anni nel tester; domanda 1 della seconda mail a FTMO ancora senza risposta (mail non inviata).
4. **Stessa strategia su piu conti** (tetto 400k per strategia valutato con altri utenti): Daytrade Pro su 3 conti, Goldbot Prop su 2, Goldbot su 3 con Combo.
5. **Costi**: nei numeri c'e l'ipotesi mia di 36 EUR/lotto oro e 4 EUR/lotto forex; costi FTMO veri (commissione, spread, swap) NON ancora letti (raccolta in corso, `PROMPT_ESTENSIONE_CHROME_FTMO_COSTI_2026-11-11.md`). Sensibilita: 130.079 (tester puro) / 120.664 / 111.637 / 94.134 (prudente). Non applicati: venerdi (-7/-12%), tick reali (-3/-8%), profit split.
6. Backtest su 3 anni, un percorso per anno, rumore su Phantom e Reaper; nessun forward su questa combinazione; margine/leva oro FTMO 1:50 e limiti di lotto NON verificati.

## Cose da chiudere prima di caricare i set (ordine)
1. Risposta di FTMO sulle posizioni opposte e sulla strategia identica (mail seconda bozza, 7 domande): da leggere e inviare da Claudio.
2. Costi FTMO veri (zip della raccolta) e ricalcolo.
3. Guardian v1.18 provato su un demo (richieste al server) e input dei set verificati su trial/reale.
4. Test Virtual SL/TP (righe pronte, da lanciare sul PC di backtest).
5. Forward su demo della combinazione, se Claudio lo vuole.
Nessuna indicazione di acquisto, lotto o taglia: la scelta e di Claudio.
