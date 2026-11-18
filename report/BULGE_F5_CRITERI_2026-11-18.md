# Bulge: filtro F5 (bulge simmetrico) del Pine di Claudio — criteri e previsioni scritti PRIMA dei numeri (18/11/2026)
Origine: Pine "IN-BULGE v5 FILTERED [Claudio]" (incollato da Claudio). E' il segnale BLU di Bulge (stessa logica: bulge, impulso, niente mediana/opposta, reazione, conferma) piu il **filtro F5**: sull'ultima barra, banda alta **sopra** com'era 5 barre prima **e** banda bassa **sotto** com'era (bande che si aprono in modo simmetrico, scarta le bande inclinate). Ipotesi di Claudio: l'"uccellino" di Leonardo e la forma simmetrica delle bande.
**Esplorativo gia fatto (replica Python, EURUSD H1 2014-2020, una coppia):** F5 passa l'84% dei segnali BLU (124 su 148), R 0,026 contro 0,029 senza filtro (i 24 scartati: R 0,043): **nessun miglioramento visibile** su quella coppia. Con BLUS (entro al segnale S): 150 su 174, R 0,215 contro 0,195 (scartati 0,070): lieve.
## Cosa si prova
- Copia di prova `ABTG_Bulge_F5.mq5` = `ABTG_Bulge_S` + input `Blu_F5_Filter` (false = identico) e `F5_Lookback` (5, come il Pine). Il filtro agisce solo sul Blu. Viola spento (`Use_Purple=false`); Guardian/verbose/autotest spenti; deposito 10.000, rischio di default.
- Varianti nuove (2): **BLUC_F5** (Blu con conferma, F5 acceso) e **BLUS_F5** (Blu al segnale S, F5 acceso). Si confrontano con le righe **gia misurate** BLUC e BLUS (`BULGE_S_dati/`: stessi 22 cross, 2022-2025, stesse impostazioni; PF aggregato BLUC 0,851 con 1.620 operazioni, BLUS 0,926 con 3.465).
- 22 cross x 4 anni (2022, 2023, 2024, 2025) x 2 = **176 passate**.
## Porte (scritte ora, nessuna ritoccabile)
Per ciascuna coppia (BLUC_F5 contro BLUC; BLUS_F5 contro BLUS): **MIGLIORA** se (a) PF aggregato >= PF base + 0,10; (b) meglio della base in almeno 3 anni su 4 (PF per anno); (c) operazioni >= 70% della base. **MIGLIORA MA SOTTO 1** se (a)-(c) vere e PF aggregato <= 1,00. **NON MIGLIORA** altrimenti. Si riporta anche il PF delle operazioni **scartate** da F5 (calcolato per differenza di somme lorde fra base e F5): se e < PF di quelle tenute, il filtro e coerente col motivo per cui e stato scritto.
## Previsioni
- F5 lascia passare fra il 75% e il 92% delle operazioni: **85%**.
- BLUC_F5 MIGLIORA: **12%**; BLUS_F5 MIGLIORA: **12%**; almeno uno dei due: **20%**; qualunque variante con PF aggregato > 1,00: **8%**.
## Limiti
Barre da 1 minuto, un percorso per anno, 22 cross correlati, Viola spento, spread del tester molto basso e nessuna commissione (vedi VOLSPREAD), F5 valutato con una sola finestra (5 barre) senza soglie sull'ampiezza dell'inclinazione.

## Risultato (18/11/2026; 176 passate su 176 OK; `BULGE_F5_dati/RISULTATI_BULGE_F5.csv`; PF aggregato = somma vincite lorde / somma perdite lorde dei report; confronto con `BULGE_S_dati/`)
| Variante | Operazioni | Netto EUR | PF aggr. | PF per anno 2022/23/24/25 | Cross con PF > 1 | PF delle operazioni scartate da F5 |
|---|---|---|---|---|---|---|
| BLUC (base) | 1.620 | -3.160 | 0,851 | 0,84 / 0,85 / 0,83 / 0,88 | 8 | |
| **BLUC_F5** | 1.217 (75%) | -2.879 | **0,830** | 0,86 / 0,83 / 0,82 / 0,81 | 8 | 0,935 (403 op.) |
| BLUS (base) | 3.465 | -4.412 | 0,926 | 0,92 / 0,86 / 0,90 / 1,03 | 7 | |
| **BLUS_F5** | 2.826 (82%) | -4.037 | **0,919** | 0,96 / 0,82 / 0,87 / 1,06 | 7 | 0,963 (639 op.) |
**Verdetto con le regole scritte: NON MIGLIORA, per entrambe le coppie** ((a) PF +0,10: no, -0,021 e -0,007). **F5 scarta le operazioni migliori, non le peggiori:** il PF degli scartati (0,935 e 0,963) e piu alto di quello delle tenute (0,830 e 0,919). Previsioni: F5 lascia passare il 75-92% (si: 75% e 82%); MIGLIORA (12% + 12%) -> no; PF > 1,00 in una qualunque (8%) -> no.
**Lettura onesta:** il filtro "bulge simmetrico" del Pine di Claudio non migliora ne il Blu con conferma ne il Blu al segnale S sul tester a 22 cross 2022-2025. Se l'"uccellino" di Leonardo e la simmetria delle bande, questa misura di simmetria (5 barre, solo il verso) non la cattura o non conta. Il Blu resta sotto 1 (0,83-0,93) in tutte le varianti testate.
