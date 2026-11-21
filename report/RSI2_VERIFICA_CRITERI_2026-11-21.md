# RSI(2) long sugli indici USA: verifica con dati M1 reali 2016-2026 (criteri PRIMA dei numeri, 21/11/2026)

**Perche':** nella scoperta A-D (`SCOPERTA_CANDIDATI_CRITERI_2026-11-21.md`) solo Dow30 e Nasdaq100 hanno passato il cancello per l'RSI(2) long (2 mercati su 11, la regola ne chiede 3 per classe) con dati D1 Yahoo di qualita' incerta (aperture finte). **Cosa si puo' e non si puo' fare qui:** il Dow su M1 non c'e' (nativo BCM solo 2024-26, non sul server); NASUSD e SPXUSD M1 (BCM `_EXT`, ora di New York, apertura cash 09:30 verificata dal picco di ampiezza) esistono 2015-31/07/2026. **Il 2025-26 e' gia' dentro l'OOS di Yahoo, quindi NON e' un fuori campione puro: e' una riprova con apertura/chiusura vere (RTH 09:30-16:00) e una seconda sorgente dati; non vale come dati nuovi indipendenti.** Lo stesso sottostante e' correlato con Yahoo.
## Regola (identica alla scoperta, nessun parametro nuovo)
RSI(2) Wilder < 10 e chiusura > SMA200 -> LONG all'apertura del giorno dopo; uscita alla prima chiusura > SMA5, massimo 10 barre; costo 0,03% a operazione + swap long 0,04% per notte (notti di calendario tenute). Barre giornaliere **RTH 09:30-16:00 ora di New York** costruite dai M1 (apertura = prima barra 09:30, chiusura = ultima barra prima delle 16:00). Periodo 2016-01 (dopo 200 giorni di riscaldamento) - 31/07/2026.
## Prove
- **P1 (M1 reali):** NASUSD e SPXUSD, tutto il periodo + il solo sotto-periodo 2025-01..2026-07 (informativo). Diagnostica: stesso periodo e stessa regola sui D1 Yahoo (Nasdaq100, SP500) per vedere se le due sorgenti danno lo stesso PF.
- **P2 (stabilita', solo Yahoo):** quattro indici USA (Dow30, Nasdaq100, SP500, Russell2000) insieme: media netta per operazione, t, **t sugli "episodi"** (operazioni di indici diversi con ingresso entro 5 giorni dal primo dell'episodio fuse in una, media) perche' i segnali scattano insieme nelle stesse discese; anni con rendimento netto >= 0 (solo anni con >= 3 operazioni); ultimi 2 anni.
## Previsioni (prima dei numeri)
- P1: **PF > 1,2 con n >= 40 in ENTRAMBI NASUSD e SPXUSD: 40%.** Il PF su SPXUSD e' piu' basso di NASUSD: 75%.
- P1: sotto-periodo 2025-26 (n piccolo): PF > 1,0 in entrambi: 55%. Le due sorgenti (M1 reali e Yahoo) danno lo stesso segno del risultato: 80%.
- P2: t sugli episodi >= 2: 45%. Anni con R >= 0: almeno il 60%: 65%.
## Regola di esito (invariata dopo i numeri)
**IPOTESI DA TESTARE A TICK** solo se: P1 PF > 1,2 con n >= 40 in NASUSD e SPXUSD, **e** P2 t episodi >= 2 **e** anni >= 0 almeno 60%. Altrimenti chiusa. **Anche se passa non e' un candidato EA**: serve un test su tick BCM con costi reali, e il Dow non e' verificabile (dati assenti). Nessun consiglio di taglie.
