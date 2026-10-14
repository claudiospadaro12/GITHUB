# RISPOSTA DI GEMINI -- 14/10/2026 20:23 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_ROUTINE_2026-10-04.md` (INIZIO..FINE COMANDO), modalita routine
- `docs/gemini/MEMORIA_CONDIVISA.md` (35100 byte, SHA256 41109783E118863A)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/gemini/PROTOCOLLO_MARKET_2026-10-13.md` (12489 byte, SHA256 54646CBDC3D3CBC8)
- `docs/PER_GEMINI_ARENA_SONDA_TESTER_2026-10-14.md` (12677 byte, SHA256 8F3640BCA07261CE)
- domanda del giorno: Q1 (ruolo B, sez. 5 del pacchetto): rispondi SOLO alla Q1. Da dove prende la leva il tester MT5 (conto/server o file di configurazione)? Per ciascuna spiegazione dai l'attesa, il numero che la rende vera o falsa e la misura a costo zero che le separa.

---

Ecco la risposta alla Q1 (ruolo B), basata sui dati del pacchetto e sulle regole di casa.

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| 1 | Il tester MT5 ignora la leva nel file di configurazione e usa quella del conto/server. | [IPOTESI] | `docs/PER_GEMINI_ARENA_SONDA_TESTER_2026-10-14.md` | Confronto margine richiesto nel tester vs margine calcolato con leva 500. | 0 (lettura) |
| 2 | Se il margine per 1 lotto nel tester equivale a (prezzo x contratto) / 500, la leva stampata nel report è un'etichetta errata. | [CALCOLO: M = (P*C)/L] | `docs/PER_GEMINI_ARENA_SONDA_TESTER_2026-10-14.md` | Calcolo del margine teorico su un simbolo noto. | 0 (lettura) |
| 3 | La misura a costo zero è il confronto del margine richiesto per 1 lotto tra un test su simbolo X e un test su simbolo Y (se la leva fosse del server, il margine scalerebbe col prezzo). | [IPOTESI] | `docs/PER_GEMINI_ARENA_SONDA_TESTER_2026-10-14.md` | Esecuzione di due test brevi (1 tick) su simboli a prezzo diverso. | 2 min macchina |

**Analisi delle spiegazioni (Ruolo B):**

*   **(a) Il tester usa la leva del conto:** È la spiegazione più coerente con il fatto che il file di configurazione (che chiedeva 500) sia stato ignorato in favore di 100. **Contro-esempio:** Se il margine calcolato dal tester per 1 lotto di oro (es. 4.250 USD) fosse ~8,5 USD (4250/500), allora la leva 500 è attiva nel calcolo del margine nonostante il report stampi 100. Se invece il margine è ~42,5 USD (4250/100), il tester sta effettivamente operando a leva 100.
*   **(b) Il server impone un tetto:** Il server potrebbe limitare la leva in base all'esposizione o al simbolo. **Contro-esempio:** Se testando un simbolo con prezzo molto basso (es. 225 JPY) il margine richiesto fosse coerente con leva 500, allora il tetto è specifico per l'oro o per l'esposizione raggiunta.
*   **(c) Errore di stampa del report:** Il report stampa la leva del conto ma il margine è calcolato diversamente. **Contro-esempio:** Se il margine richiesto nel tester non corrisponde né a 100 né a 500, il tester sta usando una leva interna non dichiarata (es. leva 1:1 o leva fissa per simbolo).

**Misura a costo zero:**
Per separare le spiegazioni, non serve correre il tester: basta leggere il **margine richiesto** per una singola operazione di 1 lotto nel "Journal" o nella scheda "Trade" del tester. Se il margine è `(Prezzo * DimensioneContratto) / 100`, la leva 100 è attiva nel calcolo. Se è `(Prezzo * DimensioneContratto) / 500`, la leva 500 è attiva. Se il margine non scala col prezzo, la leva è fissa o il tester usa un calcolo di margine non standard.

*Nota: La mia attesa è che il tester MT5 utilizzi la leva definita nelle impostazioni del conto demo a cui è collegato il terminale, ignorando il file `.set` o `.ini` per quanto riguarda la leva, poiché il tester simula l'ambiente del broker.*
