# RISPOSTA DI GEMINI -- 11/10/2026 18:05 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (18782 byte, SHA256 B8649B532A8AF200)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/PER_GEMINI_NATCLA_P003_OPZIONI_2026-10-11.md` (31648 byte, SHA256 C1B6AA859C0528C0)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- domanda del giorno: Q2 (ruolo C, auditor, UN conto solo): rispondi SOLO alla Q2 della sez. 7 del pacchetto PER_GEMINI_NATCLA_P003_OPZIONI_2026-10-11 -- formula, valore per k = 9 e n = 450, controllo di verso, cosa assume il conto; NON LO SO e il nome del dato dove manca. Non rispondere a Q1 ne' a Q3.

---

Ecco la risposta per il ruolo **C (Auditor dei numeri)**, limitatamente alla **Q2** richiesta.

### Ruolo C — Auditor dei numeri

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| C1 | Formula intervallo binomiale esatto (Clopper-Pearson) per $k=9, n=450$: $P(X \ge 9) = \sum_{i=9}^{450} \binom{450}{i} p^i (1-p)^{450-i}$ | CALCOLO | mia conoscenza statistica | calcolo software (es. R `binom.test`) | 1 min |
| C2 | Valore dell'intervallo al 95% per $k=9, n=450$: $[0,0092; 0,0378]$ (ovvero $0,92\% - 3,78\%$) | CALCOLO | formula C1 | calcolo software | 1 min |
| C3 | Controllo di verso: se $k$ scende a 4 (n fisso), l'intervallo si sposta verso lo zero (estremi inferiori); se $n$ scende a 201 ($k=4$ fisso), l'intervallo si allarga (maggiore incertezza statistica) | CALCOLO | mia conoscenza statistica | confronto estremi | 1 min |
| C4 | Il conto assume che i 450 episodi siano indipendenti e identicamente distribuiti (i.i.d.) | IPOTESI | mia conoscenza statistica | confronto con i fatti 1 e 2 del pacchetto | 1 min |
| C5 | I dati scritti nel pacchetto NON sostengono l'assunzione di indipendenza (fatto 2: 4 adozioni oro su 5 eventi totali sono concentrate in soli 4 weekend) | FATTO | pacchetto sez. 2, fatto 2 | confronto date/passate | 1 min |

**Risposta alla domanda sui dati mancanti:**
Per validare l'intervallo, il dato mancante è il **numero di episodi effettivamente indipendenti** ($n_{eff}$). Il pacchetto riporta 450 episodi totali, ma il fatto 2 indica che le 9 adozioni sono raggruppate in soli 5 eventi temporali (weekend). Poiché gli episodi sono estratti da 7 passate che condividono tick e date, il numero reale di prove indipendenti è **NON LO SO**. Senza conoscere la correlazione temporale e tra le passate, il denominatore $n=450$ è una sovrastima della numerosità campionaria, rendendo l'intervallo calcolato in C2 una sottostima dell'incertezza reale.
