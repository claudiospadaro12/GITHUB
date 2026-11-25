# Post News BCE/FOMC: criteri scritti PRIMA dei numeri (25/11/2026)

**Cosa si misura:** l'EA `ABTG_PostNews` (regole di Bertacchi, ricostruite dalle live; la lezione 10 del corso non e' nel repo): dopo la conferenza stampa BCE o FOMC, 2 ordini pendenti sul massimo/minimo delle ultime due candele M5. Il corso dichiara +20%/anno a rischio 3%, 2009-2024, un solo anno negativo. Mai misurato da noi.

## Regole simulate (identiche all'EA, `ABTG_PostNews.mq5` e preset `mql5/Presets/inverno/`)
- Range = max/min delle 2 candele M5 CHIUSE prima dell'azione (da M1 aggregate). BUY STOP = max + 3 pip, SELL STOP = min - 3 pip. TP 50 pip, SL 25 pip, OCO (al primo scatto cancella l'altro). Un ordine pendente e' valido solo se il prezzo di azione e' sotto/sopra il livello.
- **Orario azione:** BCE = **16:00 ora italiana** (come i preset: 15 server in estate, 16 in inverno; l'ora legale si ricava dalla data, Europe/Rome); scadenza = azione + 195 min (19:15 IT), posizione chiusa alla scadenza. FOMC = **ora evento del calendario + 10 min**, scadenza = azione + 65 min (come i preset).
- Trailing solo BCE: a +25 pip lo SL va a ingresso - 15 pip (cosi' e' scritto nell'EA). FOMC senza trailing.
- Eventi: `report/POSTNEWS_dati/eventi_ECB_FOMC.csv` (195: BCE 2013-2026, FOMC 2016-2026; **FOMC 2013-2015 assenti dal calendario: limite dichiarato**). Orari del calendario in ora server GMT+1 fisso (misurata la regola del CLAUDE.md).
- Dati: M1 BCM 2013-2026 attorno agli eventi (da -1h a +7h), `ABTG_EV_<SIMBOLO>_<ANNO>.csv`. Barre = bid.

## Costi e ambiguita' (scelte fatte ORA, nel verso peggiore)
- Spread = colonna `spread` della barra M1 (punti). Acquisto: scatta quando massimo + spread >= livello; vendita: quando il minimo <= livello. SL/TP sul lato corretto (bid/ask). Slippage avverso 0,5 pip sul prezzo di scatto e sullo SL, 0 sul TP.
- Stessa barra M1 tocca SL e TP: vale lo SL. Stessa barra scatta BUY e SELL: perdita di 25 pip + costi (conteggiata e dichiarata).

## Celle e soglie (cella = tipo evento x simbolo: BCE e FOMC x EURUSD, GBPUSD, USDJPY, EURJPY = **8 celle**)
| Evento | In campione (IS) | Fuori campione (OOS) | Hold-out |
|---|---|---|---|
| BCE | 2013-2020, PF >= 1,3 con >= 50 operazioni | 2021-2024, PF > 1,2 con >= 25 op. | 2025-26 PF > 1,0 (conferma) |
| FOMC | 2016-2021, PF >= 1,3 con >= 30 op. | 2022-2024, PF > 1,2 con >= 20 op. | 2025-26 PF > 1,0 |
- **Candidata** = IS e OOS passano nella STESSA cella e l'hold-out conferma. Soglie non abbassate; con 8 celle un solo passaggio isolato va ripetuto prima di crederci.
- **Controllo di deriva:** stessa cella con direzione invertita (BUY al minimo-3, SELL al massimo+3, stessi TP/SL). Se anche l'inversa ha PF > 1,2 e' un artefatto di deriva, non un vantaggio.
- Si riporta anche: operazioni, % vincenti, pip medi, pip per anno, rendimento annuo approssimato a "3% di rischio ogni 50 pip" (per confrontarlo con il +20% dichiarato), barre doppie.

## Previsione (scritta ora)
PF 0,90-1,15 in tutte le celle, nessuna candidata. Il +20%/anno a rischio 3% non si riproduce (< +10%/anno medio). Spread allargato e slippage dopo la notizia mangiano il margine di un ordine stop con SL 25 / TP 50 (pareggio al 33% di vincenti).
