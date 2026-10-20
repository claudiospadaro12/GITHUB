# The Gold Reaper a 80.000 EUR: stress di latenza, previsioni scritte PRIMA dei numeri (20/10/2026)

**Non controllata da agenti.** Claudio chiede se i backtest tengono conto di spread, slippage e costi (risposta: spread, commissioni e swap si; slippage e requote no) e la riga per la latenza del Gold Reaper. Riferimento a 0 ms: `GOLD_REAPER_80K_LETTURA_2026-10-20.md` (+59.796,28 / PF 2,89 / 791 operazioni / DD equity 3.854 = 4,8% degli 80.000 / lotti 0,07-0,42). Tabella memorizzata: `CONFRONTO_DATI_MEMORIZZATI_80K_2026-10-20.md`.

## Cosa si fa
Due corse continue 01/01/2025-01/10/2026, XAUUSD H1, ticks reali, **deposito 80.000**, gli stessi 4 input del set (`TradeFrequency=2`, `MaxAllowedDD=9.0`, `PropFirmMaxDailyDD=4.0`, `OnlyUp=false`) imposti e verificati: **TRANCHE1 = ritardo 1000 ms (quella che decide), TRANCHE2 = 200 ms (caso realistico di un VPS)**. Script `GRLAT_TESTER_TRANCHE.ps1`, derivato da `GRSET80K` cambiando SOLO `ExecutionMode`.
## Soglia (invariata dal 19/10)
Con lo stress l'EA resta candidato solo se netto > 0 e PF > 1,10. Accanto: DD in % degli 80.000 iniziali.
## Previsioni dichiarate ORA
- **GL1** (1000 ms): operazioni entro +/-10% di 791 (712-870); netto **positivo** e **entro -35%/0%** del base (+38.900..+59.800); PF > 2,0. Fiducia circa 60%. Motivo: profitto medio 75,6 EUR per operazione (circa 5,8 USD per 0,01 lotto): un secondo di ritardo sull'oro vale in media meno di 1 USD per lato.
- **GL2** (200 ms): netto fra quello a 1000 ms e il base (monotono), entro -15% del base. Fiducia circa 65%.
- **GL3**: DD di equity <= 8% degli 80.000 iniziali in entrambe; nessuno stop-out, nessun "no money". Fiducia circa 75%.
- **GL4**: il lotto resta nel gruppo 0,07-0,42 (il ritardo non cambia il dimensionamento). Fiducia 80%.
- **GL5 (durata)**: [NON MISURABILE a priori] il base ha impiegato 10.835 s (3 h). Con la latenza Smart Gold Hunter e' passato da 1 h a oltre 6 h a 200 ms (timeout), mentre il Prop Firm e' rimasto uguale. Previsione: ogni corsa **fra 3 e 9 ore**; fiducia circa 55% che nessuna vada in timeout (timeout impostato a 900 minuti = 15 h). Un timeout e' una MISURA MANCANTE, non un verdetto sull'EA.
- Se i risultati sono **identici al centesimo** al base a 0 ms, `ExecutionMode` e' inerte con questo EA e il test non prova niente: lo scrivo cosi'.
## Cosa NON dice (anche se passa)
Non misura slippage che cresce con la volatilita' o con lotti grandi (0,3-0,4), requote, spread in notizia, latenza reale del VPS: un ritardo fisso in ms e' solo una parte di cio che manca. Il costo reale va verificato col forward su demo (fill reali contro tester).
