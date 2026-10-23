# S3b -- la barra della sera nel box notturno del MaxMin: criteri CONGELATI prima dei numeri (23/10/2026)
Origine: `report/SONDE_S1_S3_RISULTATI_2026-10-23.md`. In S3 il flag "contaminato" scattava sempre perche' D30EUR su BCM non ha barre fra la chiusura serale (21:54, il venerdi' 20:59/21:00) e le 00:00: **ogni box include la barra della sera prima**. S3b misura se quella barra CAMBIA il box. **Sola lettura**, stesso script (`ABTG_SondeAperture.mq5`, nuovo commit) e stessa procedura; nessun ordine.
**Onesta' sull'origine delle soglie:** le ho scelte DOPO aver visto i risultati di S3 (ampiezze per giorno della settimana) ma PRIMA di vedere un solo numero di S3b; sono arbitrarie e non calibrate sul rumore.

**Cosa si calcola, giorno per giorno (lun-ven, ultimi 450 giorni di calendario):** replica `ComputeBox()` del MaxMin (righe 199-219): `iBarShift(...,false)` su inizio (giorno prima 23:00) e fine (04:59), `iHighest/iLowest` fra i due indici = box dell'EA (hi_box, lo_box). Poi lo stesso box SENZA le barre che iniziano prima delle 23:00 del giorno prima ("contaminanti"): hi_nom, lo_nom, n_nom. cambia_alto = hi_box > hi_nom; cambia_basso = lo_box < lo_nom; delta in punti.
**Criteri:**
1. **MATERIALE** se la quota dei giorni con n_nom >= 1 in cui la barra della sera cambia il box (alto o basso) e' >= 10% E la mediana, fra quei giorni, di (delta massimo) / (ampiezza_nom) e' >= 5%. Altrimenti NON MATERIALE.
2. **LUNEDI'**: si riporta la stessa quota separata per lunedi' e per martedi'-venerdi'; "il lunedi' e' diverso" solo se la quota del lunedi' e' >= 2 volte quella degli altri giorni E >= 10%.
3. **GIORNI ANOMALI** (solo elenco, nessun giudizio): giorni con n_nom < 100 (box nominale quasi vuoto: festivi, riaperture) e giorni con n_nom = 0.
Nessun cambio di orario, soglia o EA per effetto di questa sonda.
