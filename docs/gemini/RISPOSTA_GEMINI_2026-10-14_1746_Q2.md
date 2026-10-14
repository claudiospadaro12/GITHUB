# RISPOSTA DI GEMINI -- 14/10/2026 17:46 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_ROUTINE_2026-10-04.md` (INIZIO..FINE COMANDO), modalita routine
- `docs/gemini/MEMORIA_CONDIVISA.md` (35100 byte, SHA256 41109783E118863A)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_ATR_H1_DAX_2026-10-14.md` (12926 byte, SHA256 337BDFB9414EDE91)
- domanda del giorno: Q2 (ruolo B, sez. 3 del pacchetto): rispondi SOLO alla Q2. Quale statistica dell'ATR (quantile, ora d'ingresso, regime del mese) dovrebbe governare il cancello di costo stop>=40 x spread senza abbassare la soglia, dato che la mediana (51,6x) lo fa passare ma il 24,6% delle letture e' sotto 40x e all'ora d'apertura la mediana sta a 40,0x? Dai l'attesa scritta prima, il contro-esempio con i numeri (compreso il rischio del filtro a tempo di esecuzione) e la misura che separa la tua statistica dalla mediana.

---

### Ruolo B: Avvocato del diavolo

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| B1 | La statistica corretta è il **p10 dell'ATR all'ora d'ingresso** (es. 08:00 server), calcolato su una finestra mobile di 3 mesi. | IPOTESI | [INFERITO] | Confronto tra p10 e mediana all'ora d'ingresso nel CSV | 0 (già in archivio) |
| B2 | Attesa: il p10 all'apertura (08:00) è ~30x, quindi il cancello escluderebbe il 90% delle entrate all'apertura, rendendo il motore inoperativo. | CALCOLO | [DERIVATO] (p10 29,87 -> 1,5 * 29,87 / 1,7 = 26,3x) | Verifica del p10 nel CSV | 0 |
| B3 | Contro-esempio: un filtro a tempo ("entra solo se ATR > 45,33") seleziona solo i giorni ad alta volatilità, gonfiando il PF rispetto a un ingresso sistematico. | IPOTESI | [INFERITO] | Test di backtest con filtro ATR vs senza filtro | 2 min macchina |
| B4 | Misura: confrontare il PF di una sedia con ingresso sistematico vs ingresso filtrato (ATR > 45,33) su OOS. | IPOTESI | [INFERITO] | Confronto PF su OOS | 2 min macchina |

**Risposta alla Q2:**
La statistica che dovrebbe governare il cancello è il **p10 dell'ATR calcolato specificamente per l'ora d'ingresso della sedia**, poiché la mediana (51,6x) maschera il rischio di esecuzione in condizioni di bassa volatilità (24,6% delle letture sotto 40x). 
L'attesa è che il p10 all'apertura (08:00 server) sia circa 30x, il che porterebbe il cancello a escludere sistematicamente le entrate all'apertura, rendendo il motore inoperativo (falso negativo: la sedia è buona ma il cancello la blocca). 
Il contro-esempio è il filtro a tempo ("entra solo se ATR > 45,33"): esso garantisce il superamento del cancello di costo, ma seleziona solo i giorni ad alta volatilità, rendendo il PF misurato non trasferibile a un'operatività reale (il PF reale sarebbe inferiore perché il filtro "sceglie" i giorni migliori). 
La misura per distinguere questa statistica dalla mediana è il confronto del PF su OOS tra una sedia con ingresso sistematico e una con ingresso filtrato: se il PF della sedia filtrata è significativamente superiore, l'edge è nel filtro e non nel motore. Il rischio di aver fissato il quantile (p10) guardando questi 24 mesi è alto: la misura corretta richiede di testare il p10 su una finestra di 12 mesi e applicarlo ai successivi 12 (OOS).
