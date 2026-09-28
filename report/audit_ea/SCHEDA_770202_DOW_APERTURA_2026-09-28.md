# SCHEDA AUDIT `770202` -- ABTG_Dow_Apertura_US -- 28/09/2026 (BOZZA: solo i criteri dello stress, congelati PRIMA dei numeri)

Questa prima versione contiene **solo** i criteri della sezione C, committati prima di far girare lo stress.
Le sezioni A-E arrivano nel commit successivo. Nessun EA, preset, sedia o conto toccato.

## C.0 Criteri dello stress dei costi -- CONGELATI PRIMA DEI NUMERI

- **Cella**: ABTG_Dow_Apertura_US, magic di misura della cella OOS di contratto (`CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` §2),
  simbolo U30USD (BCM) / US30.cash (FTMO), M5, tick reali, deposito 100.000, rischio 1,00%.
- **Per-trade**: `backtest_pipeline/risultati_prove/aperture_r47/abtg_trades_ABTG_Dow_Apertura_US_U30USD_772505.csv` (solo deal d'uscita, OOS 2025.06.10 -> 2026.06.30).
- **Strumento**: `backtest_pipeline/stress_pertrade.py` (non modificato), `--k 0` (commissione indici misurata 0,0000
  su 302 deal BCM, `CANCELLO_COSTO_FLOTTA_2026-09-10.md` r.186; su FTMO "swap e commissioni 0,00",
  `TERZO_STOP_FTMO_2026-09-25.md` r.13), `--C 1` (q misurato dal file), `--punto 1.0` (1 punto INDICE),
  `--deposito 100000 --rischio 1.0`, `--taglio 2026.01.01`.
- **Spread di base**: 3,00 (lato pessimista; l'archivio tick dice 2,00: si stampano tutte e due, decide 3,00). Stampato anche: 2,10 (US30.cash FTMO all'apertura, SPREAD_APERTURA_FTMO_2026-09-21.md §1, 1 giornata).
- **Scala**: spread +0% / +25% / **+30% (briefing)** / +50% / +100% dello spread di base; slippage 0 / 1 / 2 punti
  indice su ingresso **e** su ogni deal d'uscita (pessimista: l'ingresso e' un LIMIT e nella realta' non slitta
  contro); sensibilita' 5 punti. Il +30% si calcola importando le funzioni dello script (nessuna modifica).
- **Gradino che decide**: slippage **2 punti** (scala severa: sedia d'apertura).
- **MERITO sotto stress** (PF in POSIZIONI):
  - **PASS**: a +50% di spread e slippage 2 il PF resta >= 1,10 (soglia di casa);
  - **FRAGILE**: PF >= 1,00 a +25% ma sotto 1,10 a +50% -> si scrive il margine, decide Claudio;
  - **BOCCIATO**: PF < 1,00 gia' a +25% con slippage 2.
- **RISCHIO sotto stress**: DD a saldo chiuso del per-trade x2 (scala lineare alla taglia di volo 2,00%,
  [DERIVATO], convenzione di casa) contro il muro statico 10% FTMO, e peggior giornata a saldo chiuso x2 contro
  il 5% giornaliero (e, per informazione, contro pausa 3,5% / taglio 4,5% del Guardian in campo). Un DD che sfonda
  un muro in QUALUNQUE gradino si scrive come fatto, a qualunque n. Il DD a saldo chiuso e' un limite INFERIORE
  del DD equity del tester (non vede il flottante).
- **Frontiera del costo**: quota di posizioni con stop < 40 x spread, stop per posizione ricostruito dallo
  script (classe 846), a ogni spread di base.
- **Controesempi obbligatori** (dallo script): degrado zero == PF e DD del per-trade ricontati a mano; +1000% ->
  PF < 1; monotonia del PF sui gradini.
- **Non coperto, dichiarato prima**: l'insieme degli ingressi che cambia con lo spread (un LIMIT con spread largo
  si riempie in giorni diversi), requote, rifiuti, slippage favorevole, gap, esecuzione vera FTMO.
- ⚠️ Il VERDETTO stampato dallo script usa soglie dell'ORO (`COLLAUDO_ORO_770402_LONG_CRITERI.md`): **non si
  legge**. Si legge solo contro le righe qui sopra.
