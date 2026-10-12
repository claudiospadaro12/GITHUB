# RISPOSTA DI GEMINI -- 12/10/2026 14:23 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (22148 byte, SHA256 EF45A2EB2523AC6B)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_GBA_R2S_STADIO_A_2026-10-12.md` (18178 byte, SHA256 E249D667CD33753E)
- domanda del giorno: Sonda costi simboli gemelli: rispondi SOLO alla Q1 della sez. 5 del PACCHETTO, nel ruolo B del protocollo (avvocato del diavolo); ignora l'indicazione Agente 3 e Agente 4; niente ruoli A, C, D e niente sezione E; al massimo 3 esiti; tabella N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo; NON LO SO dove manca un dato.

---

Ecco la risposta alla **Q1** (ruolo B: Avvocato del diavolo) relativa al piano di misura dello stadio A.

### Ruolo B: Avvocato del diavolo (Q1)

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| 1 | La regola della sez. 4 esclude a torto una cella se il C3G della cella è < 13,3x, anche se il motore ha un edge positivo e costante in una fascia oraria liquida con C3G > 40x. | IPOTESI | Sez. 4, punto (iii) | Confronto C3G cella vs C3G fascia oraria nel giornale | 5 min |
| 2 | Esempio: Cella con C3G=12,0x (esclusa), ma fascia USA (14-17) con C3G=45,0x e n=120. La regola la dichiara "ESCLUSA PER COSTO" ignorando l'edge della fascia. | IPOTESI | Sez. 4, punto (ii) e (iii) | Analisi giornale: filtrare righe per fascia e ricalcolare mediana | 10 min |
| 3 | La regola "PASSA" (esito A) è troppo permissiva: una cella con C3G=15,0x (FRA) passa allo stadio B perché il filtro 0,05xATR seleziona solo barre con spread bassissimo, nascondendo il costo reale del motore. | IPOTESI | Sez. 2 e 4, punto (A) | Confronto C3G cella vs C3G ingressi (filtrati) | 5 min |

**Contro-esempio alla regola di lettura (Q1):**
*   **Cella:** Dow M5.
*   **Dati:** C3G della cella = 12,5x (quindi < 13,3x).
*   **Dettaglio fasce:** Fascia "USA apertura" (14-17) con 150 righe di segnale e C3G = 42,0x. Tutte le altre fasce (Asia, Europa, Rollover) hanno C3G < 10x e n < 100.
*   **Esito della regola:** La regola della sez. 4, punto (iii), dichiara la cella "ESCLUSA PER COSTO" perché il C3G della cella è < 13,3x.
*   **Perché è un errore:** Il motore ha un edge misurabile e un costo ammissibile (> 40x) nella fascia USA, che è la più liquida. Escludendo l'intera cella, perdiamo l'opportunità di validare il motore limitandolo alla fascia oraria corretta.
*   **Etichetta corretta:** La cella non dovrebbe essere "ESCLUSA", ma "FRA" o "PASSA CON FILTRO ORARIO". La regola attuale non permette di distinguere l'edge di fascia, punendo il motore per la media ponderata con fasce (come il rollover) dove il costo è strutturalmente proibitivo.

**Nota:** Non ho potuto attaccare la condizione (i) della sez. 4, punto (B), perché la soglia di 100 righe è un filtro deterministico chiaro, ma la sua applicazione rigida sulla mediana dell'intera cella (punto iii) è il punto di rottura logica che ho dimostrato sopra.
