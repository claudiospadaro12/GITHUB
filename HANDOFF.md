# HANDOFF — messaggio di passaggio per una chat nuova

> **Da incollare in una chat nuova:** *"Leggi `HANDOFF.md`, `PROGETTO_STATO.md` e `RIEPILOGO_COMPLETO.md` nel branch `claude/creating-agents-SgGpD` e riprendi da lì."*
> Ultimo aggiornamento: **2026-07-27**.

---

## Chi sono / contesto
- Trader retail, conto **DEMO BCM Markets 50503392** (EUR, Hedge). Strumento principale: **ORO**.
- Sviluppo su **GitHub** repo `claudiospadaro12/GITHUB`, branch di lavoro/default: **`claude/creating-agents-SgGpD`**.
- Backtest sul PC fisso; gli EA girano in **forward su demo** (VPS/PC).

## ⏰ REGOLA FISSA — fuso BCM
**Server BCM = ora italiana − 1** (in questo periodo). Negli EA/.ini gli orari vanno in **ORA SERVER**:
- DAX apre 09:00 IT = **08:00 server** · Nasdaq 15:30 IT = **14:30 server**.

## 🔧 REGOLE FISSE — EA
- Ogni EA è **tutto-in-uno** (.mq5, compila con F7, niente Include).
- Ogni EA ha **magic univoco** + **InpComment** riconoscibile (anche da cellulare).
- Gli `_Ottimizzato` girano **in parallelo** ai nativi (magic diversi), mai sostituirli.
- Backtest a **tick reali** (Model 4), periodo **2024.01.01 → 2026.06.30**, rischio 1%.

---

## Stato attuale (cosa gira e cosa abbiamo fatto)

### 3 sistemi automatici
1. **Report mercato giornaliero** (email 07:00, GitHub Actions). Ora con sezioni **Banche Centrali** (calendario settimanale) + **COT** (posizionamento CFTC). Fallback se manca la chiave AI.
2. **Report settimanale** (sabato): analisi trade per EA/simbolo + verifica bias (legge `STATEMENT_FILE`).
3. **Pipeline backtest** (`backtest_pipeline/`): `run_all.ps1` ottimizza tutti gli EA a tick reali; `scan_market.ps1` scansiona un EA su tutti i simboli in OHLC.

### Portafoglio FORWARD validato (14 `_Ottimizzato`, real-tick)
Top: SupRev_Multi Oro H4 (PF 3.17) · SupRev_DOW_H4 (2.77) · SupRev Oro H4 (2.74) · MaxMinNotte_DAX_Short M15 (2.05) · SupRev_DAX_H4 (1.96) · EMA200 Oro (1.92) · SupRev_CAC_H4 (1.79) · GoldenCross Oro (1.58) · SupRev_NAS_H1 (1.57, DD 1.2%) · SuperWave_DOW_H1 (1.52) · DAX_Apertura_EU LONG (1.49) · SupRev_DAX_H1 (1.45) · SuperWave_DAX_H4 (1.28) · SupRev_DOW_H1 (1.20, DD 10%).
Dettaglio in `backtest_pipeline/RIEPILOGO_FORWARD.md` e `CLASSIFICA_PF.md`.

### Fatto in questa sessione
- **Scan MinMax** (48 simboli): migliore = **EURUSD** → preset `ABTG_MaxMinNotte_EURUSD.set`.
- **Scan Nightly** (48 simboli): migliore = **EURUSD** → preset `ABTG_Nightly_EURUSD.set`. (Nightly esclude JPY/AUD/NZD di default.)
- Nuovo EA **HARSI** (`ABTG_HARSI.mq5`, magic 772001, scalping contro-trend, EURUSD M5) + preset. Scheletro meccanico; SL/TP da ottimizzare; **non validato**.
- Nuovo EA **SuperFilter** (`ABTG_SuperFilter.mq5`, magic 771801) — parte meccanica; i segnali proprietari (Filter Indicator, S&D) NON inclusi.
- `scan_market.ps1` ora supporta **-Robot ABTG_HARSI** (TF M5).
- **Fix collisioni magic**: DAX_M3 **770501→770502**, Apertura_Marco **770301→770311** (keeper: SuperWave 770501, GoldenCross 770301). *Nel codice fatto; da riapplicare a mano sui 2 grafici quando flat.*
- **Commenti**: aggiunto `InpComment` a 22 EA (nativi+ottimizzati) mantenendo direzione/gamba. Gli 8 aperture/live avevano già commento via `ABTG_DEF_NAME`.
- `scarica_ottimizzati.ps1`: ora scarica/compila **tutti i 40 EA**.
- Agente: nuovo modulo `agent/cot.py` + calendario CB in `agent/macro_calendar.py` + sezioni in `agent/report.py`.
- Artefatto **Classifica prop** pubblicato (PF/DD/idoneità).

---

## 📌 PROMEMORIA APERTI (7)
1. **Scan OHLC esteso** → SupertrendReversal, EMA200, GoldenCross su tutti i simboli → poi tick-real sui vincitori.
2. **Forward test** → statement periodico → pagella forward (PF/DD reale per EA); riempire colonna "PF forward" in `CLASSIFICA_PF.md`.
3. **Short M5 DAX** → decidere long-only vs filtro-trend, col backtest (i nativi apertura Apertura_EU/Live5m/Marco hanno InpAllowShort=true; l'ottimizzato è LONG-only).
4. **Guardiano di portafoglio** (`ABTG_Guardian`, da creare): daily-stop + stop DD totale + limite esposizione. Modo A (autonomo) o B (interruttore condiviso). Serve per le prop.
5. **Applicare i magic** → ricaricare DAX_M3 (770502) e Apertura_Marco (770311) sui grafici.
6. **Ricompilare per i commenti** → lanciare `scarica_ottimizzati.ps1`.
7. **Scan HARSI** → `-Robot ABTG_HARSI` (script pronto).

## Note per l'attribuzione forward
- d30eur magic 770501 chiuso **a mano** il 27/07 → escludere da DAX_M3.
- 2 trade **eurnzd senza magic** → non sono nostri EA (manuali o altro).

## Prop firm — sintesi
Basso DD è necessario ma non basta: contano **perdita giornaliera (~5%)**, **DD totale (~10%)**, **consistenza**, **track record forward** e **regole EA ammessi**. Candidati migliori: SupRev_NAS_H1, oro (SupRev_Multi/EMA200/GoldenCross), MaxMinNotte_DAX_Short.

## Stile richiesto
Precisione sopra tutto. Etichettare i fatti [VERIFICATO]/[INFERITO]/[INCERTO]. Niente riempitivi. Segnalare le premesse sbagliate PRIMA di rispondere. Mai inventare.

## Comandi utili (PowerShell)
```powershell
# Aggiorna/compila tutti gli EA (applica i commenti nuovi)
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/creating-agents-SgGpD/backtest_pipeline/scarica_ottimizzati.ps1' -OutFile scarica_ottimizzati.ps1; .\scarica_ottimizzati.ps1"
# Scan di un EA su tutto il market (OHLC): ABTG_MaxMinNotte | ABTG_Nightly | ABTG_HARSI
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/creating-agents-SgGpD/backtest_pipeline/scan_market.ps1' -OutFile scan_market.ps1; .\scan_market.ps1 -Robot ABTG_HARSI"
```
