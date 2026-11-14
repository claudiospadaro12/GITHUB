# Confronto candele da 1 minuto (Modello 1) contro tick reali (Modello 4) sui nostri EA: CRITERI E PREVISIONI (scritti PRIMA di guardare i numeri, 14/11/2026)

**Domanda**: i nostri test a Modello 1 (OHLC 1 minuto, usato per 2013/2018/2020 e in parte 2025) sono affidabili rispetto ai tick reali? Soglie prese dal video UBS Optimizer di Wim (lette da un fotogramma a bassa risoluzione, quindi da ricontrollare), applicate a coppie dello STESSO set, STESSO anno e STESSO deposito 80.000 EUR gia in archivio.

**Coppie disponibili** (cartelle `risultati_archivio/`): Reaper `ANNO80K_REAPER_MAXDD_20261029_0416` (2025_M1 contro 2025_M4, DD12 e DD15; il M4 copre 2025.01.01-2026.10.01, lo confronto solo sulle operazioni chiuse nel 2025); Goldbot `ANNO80K_GOLDBOT_ZIP_1608` (2025_M1 contro 2025_M4); Daytrade Pro `ANNO80K_DTP_20261028_0253` (PROPFIRM_R27, 2025_M1 contro 2025_M4); Goldbot set venditore `ANNO80K_GOLDBOT_SETVEND_20261030_0145` (21M_M1 contro 21M_M4, PF105). Phantom e Gold Trade Pro: NON ci sono coppie M1/M4 (non confrontabili).

**Metriche e soglie (di Wim, per un candidato)**: rapporto profit factor tick/M1 >= 0,7 = PASS, < 0,5 = FAIL, in mezzo = CAUTION; drawdown a tick reali <= 1,5 volte quello M1; numero di operazioni diverso al massimo 10%; win rate diversa al massimo 10 punti percentuali. Aggiungo (MIA misura, non di Wim): rapporto del profitto netto tick/M1 e drawdown sul SALDO (le operazioni chiuse): il drawdown dell'equity del solo 2025 non si ricava dal M4 a 21 mesi.

**Previsioni (fissate ora)**
1. Reaper: ordini pendenti con trailing e filtri sul candle; con M1 le operazioni di ingresso/uscita nella stessa barra sono risolte in modo ottimistico. Prevedo PF tick tra 0,6 e 0,95 del PF M1 (CAUTION o PASS), numero di operazioni diverso piu del 10%, win rate vicina (entro 10 punti), DD saldo tick >= DD saldo M1.
2. Goldbot: strategie su barre; prevedo PASS su tutte le metriche (PF ratio >= 0,8, operazioni entro 10%).
3. Daytrade Pro (D1): prevedo PASS pieno.
4. Direzione dell'errore: il M1 sovrastima il profitto netto rispetto ai tick reali nella maggior parte delle coppie (previsione: 4 coppie su 5 con netto tick < netto M1).
**Cosa farebbe cambiare i miei numeri**: se il Reaper risulta FAIL (PF ratio < 0,5) o DD tick > 1,5 volte M1, le stime su Reaper a Modello 1 (P4, REAPER_SOLO, bundle) vanno ridimensionate; se risultano PASS, restano come sono.

**Limiti dichiarati prima**: 1 anno (2025) e 5 coppie; il saldo parte uguale ma i lotti dipendono dal saldo (MaxAllowedDD), quindi i profitti si compongono diversamente; il Reaper ha Randomization (rumore proprio, anche tra due run identiche); i set confrontati non sono tutti i nostri set Prop (DD12/DD15 sono varianti di MaxAllowedDD).

---
# RISULTATI (14/11/2026, dopo i criteri sopra)

**Metodo**: dai report HTML del tester (BCM, deposito 80.000 EUR, XAUUSD) ho estratto le operazioni chiuse (tabella "Affari") e calcolato, sulla STESSA finestra, PF, win rate, numero di operazioni, netto e drawdown sul saldo (operazioni chiuse). I totali coincidono con le intestazioni dei report (es. Goldbot 237 operazioni; Reaper M4 791 su 21 mesi). Un errore mio iniziale (confronto di date con punti contro trattini, che troncava la finestra dei 21 mesi) e stato corretto prima di scrivere i risultati. Script: `/tmp/claude-0/work/m1tick.py` (non nel repo). Daytrade Pro: la run a tick reali risulta **KO** (manifest vuoto): NON CONFRONTABILE. Phantom e Gold Trade Pro: nessuna coppia.

| Coppia (stesso set, stesso deposito) | Finestra | PF M1 / tick (rapporto) | Netto M1 / tick (rapporto) | Operazioni M1 / tick | Win rate M1 / tick | DD saldo M1 / tick (rapporto) | Peggior giorno chiuso M1 / tick |
|---|---|---|---|---|---|---|---|
| Reaper DD12 | 2025 | 2,81 / 2,63 (0,94) | 43.316 / 39.912 (0,92) | 497 / 499 (+0,4%) | 72,0 / 71,5 | 4,08% / 4,36% (1,07) | -1,49% / -1,50% |
| Reaper DD15 | 2025 | 2,34 / 2,19 (0,94) | 42.477 / 38.353 (0,90) | 491 / 493 (+0,4%) | 70,7 / 70,2 | 5,39% / 5,50% (1,02) | -4,20% / -4,04% |
| Goldbot (set ZIP) | 2025 | 2,58 / 2,38 (0,92) | 8.571 / 7.871 (0,92) | 237 / 236 (-0,4%) | 54,9 / 55,1 | 1,26% / 1,33% (1,05) | -0,85% / -0,86% |
| Goldbot (set venditore PF105) | 21 mesi (2025-01 / 2026-09) | 1,85 / 1,67 (0,90) | 31.847 / 26.557 (0,83) | 451 / 449 (-0,4%) | 52,8 / 53,0 | 5,76% / 7,75% (1,35) | -2,57% / -2,96% |

Drawdown dell'equity sull'intera durata (dai report): Goldbot PF105 6,05% (M1) contro 7,62% (tick) = 1,26; Goldbot ZIP 1,55% contro 1,58%. Per il Reaper il DD equity dei report non e confrontabile (M1 = 2025, tick = 21 mesi).

## Verdetto con le soglie di Wim (PF >= 0,7; DD <= 1,5 volte; operazioni entro 10%; win rate entro 10 punti)
**4 coppie su 4 PASS su tutte le metriche.** Confronto con le previsioni scritte prima:
1. Reaper: PF ratio previsto 0,6-0,95 -> 0,94 (nei limiti, a fondo scala alto); "operazioni diverse piu del 10%" -> **SBAGLIATA** (+0,4%); win rate entro 10 punti -> giusta; DD saldo tick >= M1 -> giusta (1,02-1,07).
2. Goldbot: PASS -> giusta.
3. Daytrade Pro: NON VERIFICABILE (run a tick reali KO).
4. Direzione: netto tick < netto M1 in 4 coppie su 4 -> giusta. **Il Modello 1 sovrastima il netto di circa 8-17% e il PF di circa 6-10%.**
Nessuno dei criteri che cambierebbero le mie stime e scattato (nessun FAIL, nessun DD tick > 1,5 volte M1).

## Cosa ne segue (e cosa NON ne segue)
- Le stime a Modello 1 sono **affidabili nella forma** (stesse operazioni, stesso win rate, giorni peggiori quasi uguali), ma **ottimistiche sui profitti**: i tempi per +10% / +5% (che dipendono dal netto) sono sottostimati di circa 10-20% se la differenza vale anche per gli altri anni. NON MISURATO su 2013/2018/2020: i tick reali BCM esistono solo dal 2025 nei nostri dati.
- Il **drawdown e piu alto a tick reali**, da +2% a +35%; la coppia con la finestra piu lunga (21 mesi, Goldbot) ha il rapporto peggiore (1,35 sul saldo, 1,26 sull'equity). Il peggior giorno chiuso del Goldbot PF105 passa da -2,57% a -2,96% (+15%).
- **Il margine di P1 sul limite del 5% e stretto**: la parte oro (Goldbot L0 + Phantom L1) ha avuto il peggior giorno equity -4,46% (31/12/2013, M1; -4,69% con i costi centrali): margine 0,3-0,5 punti. Se a tick reali il giorno peggiore salisse del 15% (come il Goldbot PF105) andrebbe a -5,1/-5,4%. Non e una previsione: la differenza M1-tick e stata misurata solo nel 2025 e su altri set; per il 2013 NON MISURATO. Rafforza pero la regola gia fissata: Guardian a 4,3% e nessuna taglia aumentata.
- I **fail% a 0%** di P1/P3/P4 e la tabella Reaper v2 vanno letti con questa avvertenza (non cambio le cifre: non ho dati per correggerle).
- Il comportamento del Reaper (trailing, ordini pendenti) NON mostra la differenza che prevedevo: il Modello 1 ricostruisce le sue operazioni quasi identiche.
- **Limiti**: 1 anno e 4 coppie; Reaper con Randomization (in questi test valore non verificato qui); le coppie Reaper sono varianti DD12/DD15, non il set Prop L0/L3; Phantom, Gold Trade Pro e Daytrade Pro non sono coperti.
