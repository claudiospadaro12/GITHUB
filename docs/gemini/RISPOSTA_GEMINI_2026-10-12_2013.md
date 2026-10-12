# RISPOSTA DI GEMINI -- 12/10/2026 20:13 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (24464 byte, SHA256 4CF6B16678775F6F)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_GBA_R2S_LETTURA_2026-10-12.md` (17687 byte, SHA256 99AD989C8735F5CF)
- domanda del giorno: Lettura sonda costi simboli gemelli: rispondi SOLO alla Q3 della sez. 6 del PACCHETTO, nel ruolo B del protocollo (avvocato del diavolo); ignora l'indicazione Agente 3 e Agente 4; niente ruoli A, C, D e niente sezione E; al massimo 3 esiti; tabella N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo; NON LO SO dove manca un dato.

---

Ecco la risposta alla **Q3** (ruolo B: avvocato del diavolo) sulla sonda dei costi dell'argento, basata sui dati forniti nel pacchetto.

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| 1 | La causa primaria dello scarto è il rapporto spread/ATR, non un errore di unità o di cifre decimali. | FATTO | PACCHETTO sez. 4 | Confronto spread/ATR nel giornale EA | 0 (già in archivio) |
| 2 | Il filtro 0,05 x ATR è calcolato in doppia precisione: un errore di arrotondamento nel giornale non implica un errore nel filtro. | IPOTESI | PACCHETTO sez. 4 | Verifica funzione `OnInit` o `OnTick` nel sorgente | 0,5 ore umane |
| 3 | Una passata a tick reali su una settimana di argento M1/M15 è l'unica misura che separa il costo reale dall'artefatto di Modello 1. | FATTO | PACCHETTO sez. 6 | Esecuzione tester su 1 settimana | 5 min macchina |

### Analisi della Q3 (Ruolo B)

**Contro-esempio alla causa "costo"**:
Se la causa fosse un errore di unità (es. ATR in punti vs prezzo), il rapporto `spread / ATR` sarebbe costante indipendentemente dalla volatilità. Invece, il giornale mostra che lo spread (0,05) è sistematicamente superiore all'ATR (0,03-0,05). Se l'ATR fosse espresso in punti e lo spread in prezzo (o viceversa), vedremmo una dispersione del rapporto `spread/ATR` molto più ampia o incoerente con la dinamica di mercato. Il fatto che il rapporto sia costantemente > 100% (contro il 5% richiesto) indica che il costo è effettivamente proibitivo per il motore su quel timeframe.

**Risposta alle alternative**:
*   **(a) Unità dell'ATR**: Il filtro `0,05 * ATR` opera internamente in `double`. Se l'ATR fosse in punti e lo spread in prezzo, il filtro sarebbe logicamente errato, ma il risultato (scarto totale) sarebbe identico. **Misura**: confrontare il valore di `ATR` stampato nel giornale con il `TickSize` del simbolo. Se `ATR / TickSize` è coerente con la volatilità storica, l'unità è corretta.
*   **(b) Dimensione del tick**: L'argento a 3 decimali (es. 63,565) rende lo spread di 0,05 (50 tick) molto pesante. Se il broker avesse cambiato la precisione del simbolo rispetto alla nostra scheda, il filtro potrebbe essere troppo stretto. **Misura**: verificare il `Digits` del simbolo nel tester. Se `Digits` è 3, lo spread 0,05 è 50 tick; se fosse 2, sarebbe 5 tick.
*   **(c) Spread di riferimento**: Modello 1 usa lo spread registrato nella barra. Se il tick reale fosse 0,01-0,02 (come ipotizzato), il C3G salirebbe a 6-12x. **Misura**: una passata a tick reali su 1 settimana. Se il numero di ingressi passa da 0 a > 0, l'ipotesi "artefatto di Modello 1" è confermata.

**Conclusione**:
L'ipotesi che il costo sia la causa reale è la più solida. L'unica situazione in cui la "tutto scartato" è un artefatto è che lo spread reale sia significativamente inferiore a quello registrato nelle barre OHLC di Modello 1. La passata a tick reali è l'unico test dirimente.
