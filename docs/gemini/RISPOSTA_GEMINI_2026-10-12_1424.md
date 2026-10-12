# RISPOSTA DI GEMINI -- 12/10/2026 14:24 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (22148 byte, SHA256 EF45A2EB2523AC6B)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_GBA_R2S_STADIO_A_2026-10-12.md` (18178 byte, SHA256 E249D667CD33753E)
- domanda del giorno: Sonda costi simboli gemelli: rispondi SOLO alla Q2 della sez. 5 del PACCHETTO, nel ruolo B del protocollo (avvocato del diavolo); ignora l'indicazione Agente 3 e Agente 4; niente ruoli A, C, D e niente sezione E; al massimo 3 esiti; tabella N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo; NON LO SO dove manca un dato.

---

Ecco la risposta alla **Q2** (ruolo B: Avvocato del diavolo) riguardante la distorsione del Modello 1 sui CFD indice e sull'argento.

### Ruolo B: Avvocato del diavolo (Q2)

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| B1 | La distorsione di Modello 1 su spread/ATR è diversa per segno sugli indici fuori cassa: le barre con spread registrato a zero o fisso (tipico dei dati storici CFD fuori sessione) producono righe `-1,0x` (costo infinito), invertendo il segno della distorsione rispetto all'oro. | IPOTESI | `docs/PER_GEMINI_GBA_R2S_STADIO_A_2026-10-12.md` sez. 5 | Confronto righe `-1,0x` nel giornale EA tra Modello 1 e Tick Reali | 2 min macchina |
| B2 | Sull'argento, la distorsione di Modello 1 è amplificata dall'arrotondamento a 2 decimali: un ATR di 0,02 USD (M1) con spread 0,04 USD genera un rapporto `stop/spread` che oscilla violentemente per variazioni di 0,01 USD, rendendo la mediana del C3G instabile rispetto ai tick reali. | IPOTESI | `docs/PER_GEMINI_GBA_R2S_STADIO_A_2026-10-12.md` sez. 4 | Analisi varianza `stop/spread` su passata argento M1 | 2 min macchina |
| B3 | La misura minima per confermare la distorsione è una passata a tick reali (R1A) su un trimestre per ogni simbolo: il valore che conferma la distorsione è un delta C3G > 15% rispetto a Modello 1; il valore che la smentisce è un delta < 5%. | CALCOLO | `docs/PER_GEMINI_GBA_R2S_STADIO_A_2026-10-12.md` sez. 3 | Confronto C3G cella (Modello 1 vs Tick Reali) | 5 min macchina |

**Contro-esempio alla tesi della distorsione:**
Se la distorsione di Modello 1 fosse puramente legata allo spread (come nell'oro), ci aspetteremmo che il C3G a tick reali sia sempre inferiore a quello di Modello 1. Tuttavia, se sugli indici (fuori cassa) il Modello 1 riporta spread "fissi" (es. 2,0 punti) mentre i tick reali mostrano spread variabili che si restringono durante i picchi di volatilità, il C3G a tick reali potrebbe risultare **superiore** a quello di Modello 1. In tal caso, la misura di Modello 1 non sarebbe una "sovrastima prudenziale" del costo, ma una sottostima, portando a un falso positivo ("PASSA") per una cella che a tick reali risulterebbe "ESCLUSA". Il valore che produrrebbe questa smentita è un delta C3G negativo (Tick Reali > Modello 1).
