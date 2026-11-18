# Probabilita storica di raddoppiare prima di perdere il 50% (finestre mobili) — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Dati: profitto REALIZZATO per giorno dei report archiviati dei test a 4.000 EUR (Stability low/mediumlow, Daytrade Pro Max9/20/50, Luna 4DD/lowrisk, Apex Conservative/Elevated; anni 2013, 2017, 2020, 2022, 2025) e del trio oro a 3.745 EUR (21 mesi), esportati da `ESPORTA_SERIE_GIORNALIERE.ps1`. Solo analisi di risultati gia misurati; nessun consiglio su lotti/taglie.
## Metodo (nessuna soglia ritoccabile)
- Per ogni serie e ogni giorno di partenza s: cumulata del profitto realizzato da s in avanti, in % del deposito iniziale (4.000 / 3.745), senza ricomposizione. Eventi: **RADDOPPIO** = +100%, **STOP** = -50%. Finestra massima: fino a fine serie (un anno; 21 mesi per l'oro).
- Esiti per partenza: raddoppio prima dello stop / stop prima del raddoppio / nessuno dei due entro la fine. **P(raddoppio)** = quota di partenze con raddoppio prima dello stop sul totale (le partenze troppo vicine alla fine della serie contano come "nessuno dei due", cioe sfavoriscono il raddoppio: si riporta anche la quota calcolata solo sulle partenze con almeno 180 giorni davanti). Mediana dei giorni al raddoppio.
- Limiti dichiarati: solo profitti realizzati (il flottante puo toccare -50% prima: **la P(stop) e una stima per difetto**); un percorso per anno, anni non contigui (finestre dentro l'anno); depositi 4.000/3.745 non 2.000.
## Previsioni
- Set prudenti (Stability low, Daytrade Max9, Luna 4DD): P(raddoppio) < 5% in ogni anno: **80%**.
- Almeno un set ad alto rischio (Daytrade Max50, Apex Elevated, Luna lowrisk, Stability mediumlow) con P(raddoppio) >= 30% in almeno un anno: **75%**; ma stesso set con P(stop) >= 10% in almeno un altro anno: **55%**.
- Trio oro L2 (21 mesi): P(raddoppio) >= 60%: **80%**.
