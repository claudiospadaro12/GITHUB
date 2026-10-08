# RISPOSTA DI GEMINI -- 08/10/2026 08:52 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (11488 byte, SHA256 2653A18D855849E4)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_EMA200_DOW_H1_771531_2026-10-08.md` (14087 byte, SHA256 69C5E850296CD033)

---

Ecco la risposta strutturata secondo il **Protocollo di Squadra (08/10/2026)** per l'EA `771531` (EMA200 Dow H1).

### Ruolo A — Cacciatore di meccanismi alternativi
| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| A1 | Filtro regime: `InpADR_Filter` (ADR > 1.5x media 20gg) per evitare giornate a bassa volatilità | IPOTESI | mia conoscenza (Dow) | Test su finestra OOS 2025-2026 | 2 passate |
| A2 | Uscita: `InpTimeStop` (chiusura forzata dopo 24h) per evitare DD da posizioni "incastrate" | IPOTESI | mia conoscenza (Dow) | Test su finestra OOS 2025-2026 | 2 passate |

### Ruolo B — Avvocato del diavolo
| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| B1 | L1 (PF 1,52): Il PF è gonfiato dal 39,5% del profitto in un solo mese (settembre 2025); senza quello, il PF scende a 1,33. | FATTO: sez 2.3 | `pertrade_00_metro_763400.csv` | Ricalcolo PF escludendo settembre 2025 | 0 |
| B2 | L2 (Stagionalità): La differenza di PF (1,93 vs 1,08) è dovuta al fatto che il Dow ha avuto trend rialzisti più marcati in estate, non all'orologio. | IPOTESI | mia conoscenza (Dow) | Confronto PF per regime di trend (non orario) | 4 passate |
| B3 | L3 (Demo): Il forward 0,68 su 23 posizioni è un segnale di "degrado" del motore, non rumore. | IPOTESI | mia conoscenza | Analisi MFE/MAE del forward vs backtest | 1 ora umana |

### Ruolo C — Auditor dei numeri
| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| C1 | Sigma: $z = (0,607 - 0,435) / \sqrt{0,607 \cdot 0,393 / 23} \approx 1,71$. Non è statisticamente significativo (p > 0,05). | CALCOLO | sez 2.4 | Formula Z-test per proporzioni | 0 |
| C2 | Accumulo: Con 20,2 posizioni/mese, servono ~7,4 mesi per 150 posizioni. | CALCOLO | sez 2.1 | 150 / 20,2 | 0 |
| C3 | DD Lineare: Il margine di errore del 6% è corretto; il lineare sottostima il DD reale perché non considera la capitalizzazione composta. | IPOTESI | `PIANO_REGIME` | Verifica formula DD composto | 0 |

### Ruolo D — Sintesi
1. **Misura 1**: Test PF escludendo settembre 2025 (Finestra OOS, Cella controllo: `InpMinDistAtr`, Attesa: PF > 1,30, Falsificatore: PF < 1,20, Costo: 0, Firma: NO).
2. **Misura 2**: Test filtro `InpADR_Filter` (Finestra OOS, Cella controllo: `InpADR_Filter`, Attesa: DD < 7%, Falsificatore: DD > 9%, Costo: 2 passate, Firma: NO).
3. **Misura 3**: Prova di regime (Piano Dukascopy, Finestre W1-W4, Attesa: PF > 0,90 in avverse, Falsificatore: PF < 0,80, Costo: 90-348h PC, Firma: SI).
4. **Contraddizioni**: La nostra lettura L1 (PF 1,52 come fatto) contrasta con l'audit B1 (PF 1,33 senza settembre 2025). La misura 1 risolverà il disaccordo.

**Sezione E (Protocollo)**:
1. **Critica**: Il protocollo non prevede un ruolo per la "pulizia dei dati" (es. rimuovere outlier come settembre 2025 prima di calcolare il PF).
2. **Ruolo mancante**: "Analista di Sensibilità" (testa come cambiano i risultati variando lo spread/commissioni di +/- 10%).
3. **Regola da misurare**: Il limite di 150 operazioni per il merito. Misurerei se il PF si stabilizza a 100 o 200 operazioni per decidere se il limite è troppo alto.
