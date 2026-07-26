# RIEPILOGO OPERATIVO — Forward Demo (aggiornato 26.07.26)

Portafoglio EA **_Ottimizzato_ validati in real-tick**, pronti per il forward su demo BCM 50503392.
Regola: rischio 1%, girano in parallelo ai nativi (magic diversi). NIENTE hedging/martingala.

---

## PORTAFOGLIO VALIDATO (12 EA, 5 strumenti)

| # | EA _Ottimizzato_ | Strumento | Grafico | TF | Direzione | PF | DD% | Magic |
|---|---|---|---|---|---|---|---|---|
| 1 | ABTG_SupertrendReversal_Multi_Ottimizzato | Oro | XAUUSD | H4 | L/S | 3.17 | basso | 971001 |
| 2 | ABTG_SupertrendReversal_Ottimizzato | Oro | XAUUSD | H4 | L/S | 2.74 | basso | 970901 |
| 3 | ABTG_EMA200_Ottimizzato | Oro | XAUUSD | H4 | L/S | 1.92 | basso | 971501 |
| 4 | ABTG_GoldenCross_Ottimizzato | Oro | XAUUSD | H1 | L/S | 1.58 | basso | 970301 |
| 5 | ABTG_DAX_Apertura_EU_Ottimizzato | DAX | D30EUR | M5 | **LONG** | 1.49 | 3.8 | 770111 |
| 6 | ABTG_SupRev_DAX_H1_Ottimizzato | DAX | D30EUR | H1 | L/S | 1.45 | 5.6 | 970911 |
| 7 | ABTG_SupRev_DAX_H4_Ottimizzato | DAX | D30EUR | H4 | L/S | 1.96 | 5.7 | 970912 |
| 8 | ABTG_MaxMinNotte_DAX_Short_Ottimizzato | DAX | D30EUR | M15 | **SHORT** | 2.05 | 3.1 | 770411 |
| 9 | ABTG_SupRev_NAS_H1_Ottimizzato | Nasdaq | NASUSD | H1 | L/S | 1.57 | **1.2** | 970913 |
| 10 | ABTG_SupRev_DOW_H4_Ottimizzato | Dow | U30USD | H4 | L/S | 2.77 | 4.0 | 970914 |
| 11 | ABTG_SupRev_CAC_H4_Ottimizzato | CAC 40 | F40EUR | H4 | L/S | 1.79 | 3.5 | 970915 |
| 12 | ABTG_SupRev_DOW_H1_Ottimizzato (opzionale) | Dow | U30USD | H1 | L/S | 1.20 | 10 | 970916 |

**In attesa di validazione real-tick (NON attaccare finche' non confermato):**
- SuperWave Dow H1 (PF 1.42 OHLC) + DAX H4 (PF 1.30 OHLC) — magic 770501.

---

## SETUP GRAFICI (1 EA per grafico, AutoTrading ON)

Apri questi grafici e trascina l'EA indicato:

**Oro — XAUUSD**
- 3 grafici **XAUUSD H4** → SupRev_Multi, SupRev, EMA200 (uno per grafico)
- 1 grafico **XAUUSD H1** → GoldenCross

**DAX — D30EUR**
- **D30EUR M5** → DAX_Apertura_EU (LONG mattina)
- **D30EUR H1** → SupRev_DAX_H1
- **D30EUR H4** → SupRev_DAX_H4
- **D30EUR M15** → MaxMinNotte_DAX_Short (night-box SHORT)

**Nasdaq — NASUSD**
- **NASUSD H1** → SupRev_NAS_H1

**Dow — U30USD**
- **U30USD H4** → SupRev_DOW_H4
- (opz.) **U30USD H1** → SupRev_DOW_H1

**CAC — F40EUR**
- **F40EUR H4** → SupRev_CAC_H4

**Totale: 11 grafici (12 col Dow H1 opzionale).**
Quando tutto e' a posto: File > Profili > Salva con nome ("FORWARD") per richiamarli in un click.

---

## INSTALLARE / AGGIORNARE sul VPS

```
powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/creating-agents-SgGpD/backtest_pipeline/scarica_ottimizzati.ps1' -OutFile scarica_ottimizzati.ps1; .\scarica_ottimizzati.ps1"
```
Poi in MT5: tasto destro su Expert Advisors > Aggiorna. Se un'icona e' grigia -> apri in MetaEditor e F7.
Sicuro anche con MT5 aperto (copia+compila, non lancia backtest).

---

## COSA NON RIPROVARE PIU' (morto in real-tick, con prove)
- **Breakout M5 in apertura**: DAX/Nasdaq aperture (tranne DAX LONG), Live5m, Live5m_v2, DAX_M3, ORB_Fibo, Londra_ORB. Anche coi filtri di Emiliano (correlazione/volumi) sul Nasdaq: morto.
- **Aperture su FTSE/Dow/Stoxx/CAC**: solo il DAX ha edge in apertura (LONG).
- **MaxMinNotte** su FTSE/CAC/Stoxx: solo il DAX (SHORT + correlazione) rende.
- **SuperWave (cross 14x200)** su oro/Nasdaq: morto. Vivo su Dow H1 / DAX H4.

## COSA FUNZIONA (i motori veri)
- **SupertrendReversal** (reversal su Supertrend): generalizza su oro, DAX, Nasdaq, Dow, CAC (H1/H4). E' la spina dorsale.
- **DAX aperture LONG** (M5 su livello): l'unica anomalia d'apertura che regge.
- **DAX night-box SHORT + correlazione S&P** (M15): complementare all'aperture.
- **SuperWave cross 14x200** su Dow (da validare): motore di trend.

## LEZIONE CHIAVE
Il filtro giusto dipende dalla strategia: la correlazione S&P NON salva il breakout M5 ma raddoppia il night-box DAX. Validare SEMPRE in real-tick prima del forward (l'OHLC inganna sui breakout intraday).

---

## MONITORAGGIO SETTIMANA
- Controlla che ogni EA abbia AutoTrading attivo (bottone verde) e magic corretto.
- I trade dei diversi EA non si pestano (magic distinti), anche piu' EA sullo stesso simbolo.
- Annota settimanalmente per ogni EA: n. trade, P/L, DD. Confronta col backtest.
- Se un EA in forward diverge molto dal backtest (es. DD doppio), segnalalo: si rivede.
