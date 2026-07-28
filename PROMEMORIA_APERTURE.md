# PROMEMORIA — lavori in coda (branch claude/ea-market-openings-d79m8l)

> In attesa che finisca lo **scan SupertrendReversal** sul PC fisso (era a ~28/48).
> Entrambi i lavori qui sotto partono quando lo scan libera il PC (o con `-UseSpare` sull'installazione V3).

## 1) STUDIO APERTURE — FASE A (misurare)
- **Cosa:** lanciare `backtest_pipeline/studio_apertura.ps1` sul **PC fisso** (MT5 chiuso).
- Gira lo studio su 5 indici, ognuno alla sua apertura (ora server = IT−1):
  - EU (DAX D30EUR, CAC F40EUR): apertura **08:00 server**, cutoff 16:30.
  - USA (Nasdaq NASUSD, Dow U30USD, S&P SPXUSD): apertura **14:30 server**, cutoff 21:00.
- L'EA `ABTG_Apertura_Study_EA` misura per ogni giorno: **ampiezza range, MAE, MFE, durata**.
- **Dopo:** Claudio zippa `risultati_studio_apertura` → Claude analizza (FASE B) → consiglia
  **SL / BE / trailing / dimezza-lotto** per indice → poi **motore unico** `ABTG_Aperture_Universal` (FASE C).
- Comando:
  ```powershell
  powershell -ExecutionPolicy Bypass -Command "iwr 'https://raw.githubusercontent.com/claudiospadaro12/GITHUB/claude/ea-market-openings-d79m8l/backtest_pipeline/studio_apertura.ps1' -OutFile studio_apertura.ps1; .\studio_apertura.ps1"
  ```
- ⚠️ Verificare l'ora di apertura sul grafico BCM; se diversa, correggere `$Jobs` in cima allo script.

## 2) CONFRONTO H1 vs H4 (motori reversal)
- **Cosa:** rilanciare lo scan con `-Tf H1` per confrontare con l'H4 già in corso.
  ```powershell
  .\scan_market.ps1 -Robot ABTG_SupertrendReversal -Tf H1
  ```
- I risultati vanno in `risultati_scan_ABTG_SupertrendReversal_H1` (non sovrascrivono l'H4).
- **Perché:** Claudio preferisce **H1** — a volte l'operazione si chiude **in giornata**.
- Vale anche per EMA200 / GoldenCross quando arriva il loro turno.

## Nota
Entrambi sono su PC fisso. Il VPS resta ai soli EA in forward (non toccarlo per i backtest).

## Osservazioni forward (decisioni di Claudio)
- **28/07:** DAX Apertura EU nativo — **gamba SHORT lasciata ATTIVA** (InpAllowShort=true) per
  raccogliere dati forward. Oggi lo short ha perso −86,70 (falso break ribassista, DAX in range).
  Da rivedere tra qualche giorno: se lo short continua a perdere → passare a LONG-only.
- **Da verificare sul VPS:** DAX_M3 e Londra_ORB (decisi "morti") oggi hanno ancora tradato e
  perso −116 € insieme. Confermare che siano DAVVERO tolti dai grafici.
