# The Gold Reaper a 80.000 EUR: stress di latenza, lettura (22/10/2026)

Previsioni scritte prima: `GOLD_REAPER_LATENZA_ATTESE_2026-10-20.md`. Materiale: `risultati_archivio/GRLAT_20261022` (MANIFEST, REFERTO, .ini; i report .htm da 3 MB stanno nello zip di Claudio).

## Numeri (XAUUSD H1, ticks reali 100%, 01/01/2025-01/10/2026, deposito 80.000, stessi 4 input del set, .ex5 invariato prima e dopo: SHA256 AB636AF9...F7E4)

| | Base 0 ms | 200 ms | 1000 ms |
|---|---|---|---|
| operazioni | 791 | 791 | 787 |
| netto EUR | 59.796,28 | 59.620,09 (-0,3%) | 59.067,85 (-1,2%) |
| PF | 2,89 | 2,88 | 2,82 |
| DD equity EUR (% di 80.000) | 3.854 (4,8%) | 3.909 (4,9%) | 4.047 (5,1%) |
| lotti min-max | 0,07-0,42 | 0,07-0,42 | 0,07-0,42 |
| stop out / no money | 0 / 0 | 0 / 0 | 0 / 0 |
| durata | ~3 h | 2 h 56 min | 2 h 56 min |

(Il 3,13% / 3,01% del MANIFEST e il DD in % del picco di equity, non degli 80.000.)

## Contro le previsioni
- **GL1** (1000 ms: ops 712-870, netto positivo fra -35% e 0%, PF > 2,0): **CENTRATA**, anzi molto meglio del previsto (-1,2% invece di fino a -35%).
- **GL2** (200 ms fra 1000 ms e base, entro -15%): **CENTRATA** (monotona: 59.796 > 59.620 > 59.068).
- **GL3** (DD <= 8% degli 80.000, niente stop out): **CENTRATA** (5,1% al massimo).
- **GL4** (lotti 0,07-0,42): **CENTRATA**, identici.
- **GL5** (3-9 h, nessun timeout): nessun timeout, ma la durata e **sotto** l'intervallo (2 h 56 min contro "fra 3 e 9"): mancata di pochi minuti sul limite basso, l'ordine di grandezza era giusto.
- **ExecutionMode non inerte**: i tre set di numeri sono diversi al centesimo, quindi il ritardo agisce. Nei giornali ci sono righe "failed ... [Invalid price]" e "Modification failed ... close to market" (conteggio grezzo sui log, con doppioni fra file: circa 280 righe a 1000 ms contro circa 150 a 200 ms; non e un conteggio pulito).

## Soglia (netto > 0 e PF > 1,10 con lo stress)
**Passata a 1000 ms e a 200 ms.** Il Gold Reaper regge il ritardo fisso: perde circa 730 EUR su 59.800 a 1 secondo.

## Cosa NON dice (resta vero)
- Un ritardo fisso in ms non e lo slippage che cresce con la volatilita' o coi lotti (0,3-0,4): non misurato.
- Requote, spread in notizia e latenza reale del VPS non sono qui. Il filtro news usa un calendario MQL5 che nel tester non esiste.
- Il rapporto fra lotto massimo e minimo e 6,0: il **S-NOSCALA (<= 3) resta fallito**, come nel base. Questa prova non lo cambia.
- Il Gold Reaper e un cesto a H1 con poche operazioni al giorno: e normale che un secondo conti poco. Non vale per EA piu veloci.
- Il costo reale si verifica solo col forward su demo (fill reali contro tester). Nessuna taglia: la scelta resta di Claudio.
