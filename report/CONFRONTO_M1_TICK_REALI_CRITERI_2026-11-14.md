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
