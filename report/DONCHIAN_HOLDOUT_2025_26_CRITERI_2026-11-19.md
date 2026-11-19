# Donchian su Nasdaq/S&P, hold-out 2025-2026 — criteri scritti PRIMA di vedere i dati (19/11/2026)
**Ipotesi unica, congelata ora** (dal test 2015-2024, `DONCHIAN_INDICI_CRITERI_2026-11-19.md`): canale 40, filtro EMA 400, stop 3 ATR (la cella scelta con stop 4 ATR e quella con stop 3 sono le due vicine migliori; si valutano ENTRAMBE, senza scegliere dopo), conferma doppia, long+short, H1, ingresso all'apertura successiva, stesse regole di costo (Nasdaq 2,0 / S&P 0,7 punti). Dati: `NASUSD_M1` e `SPXUSD_M1` 2025-2026 dallo stesso storico esterno (EST fissa) del test 2015-2024. Nessun parametro viene toccato.
**Porte:** il periodo 2025-26 e' una conferma, non un'ottimizzazione. CONFERMATA se su ENTRAMBI gli indici: >= 30 operazioni, R medio netto > 0, PF > 1,2. Separare long e short: se il PF dei soli long e' > 1,2 e quello dei soli short < 1,0 su entrambi gli indici, il risultato e' **trascinamento del rialzo**, non un vantaggio del sistema (declassato).
## Previsioni
- Conferma su entrambi gli indici (PF > 1,2 con entrambe le varianti di stop): **25%**.
- Almeno un indice con PF > 1,0 (una variante): **55%**.
- Nel caso di conferma, i soli short hanno PF < 1,0 su entrambi: **60%** (il vento di coda degli indici).
## Limiti
~1,5 anni (2025 + parte del 2026): ~25-60 operazioni a indice per variante; un periodo breve non basta a un verdetto definitivo (si legge solo se i segni sono coerenti col 2015-2024). Il file sorgente potrebbe finire prima della fine del 2026: si usa quello che c'e'.
