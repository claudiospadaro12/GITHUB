# RISPOSTA DI GEMINI -- 10/10/2026 17:50 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (14766 byte, SHA256 ACA56A598DBAA359)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_ORO_DOCENTE_2026-10-10.md` (37353 byte, SHA256 712C52CD1A7650A2)
- domanda del giorno: EA oro del docente: rispondi nei ruoli A, B, C, D del protocollo; nel ruolo C solo Q5; sezione E solo con punti nuovi.

---

Ecco la risposta strutturata secondo il **Protocollo di Squadra (08/10/2026)**.

### Ruolo C — Auditor dei numeri
*Nota: Rispondo solo alla Q5 come richiesto dal protocollo (deroga punto 9).*

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| C1 | Probabilità 7 notti positive su 7 con p=1/3: (1/3)^7 = 1/2187 ≈ 0,000457 | CALCOLO | BASE sez. 7 (formula binomiale) | Calcolatrice | 1 min |
| C2 | Se p=0,5, P(7/7) = (1/2)^7 = 1/128 ≈ 0,0078 | CALCOLO | BASE sez. 7 | Calcolatrice | 1 min |
| C3 | Se p=0,9, P(7/7) = (0,9)^7 ≈ 0,478 | CALCOLO | BASE sez. 7 | Calcolatrice | 1 min |

*Controllo verso:* La probabilità diminuisce all'aumentare della probabilità di insuccesso (p=1/3 è molto più raro di p=0,9). Il calcolo è corretto.

---

### Ruolo B — Avvocato del diavolo

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| B1 | La divergenza di win rate (26% vs 47%) può essere causata da "chiusure manuali" che tagliano i loss prima dello stop, alzando il WR senza cambiare il payoff medio delle vincenti. | IPOTESI | PACCHETTO sez. 4 | Analisi export trade (Q7) | 2h |
| B2 | Se il docente usa un feed con spread 2-3 volte inferiore, il suo EA "vede" segnali che la nostra replica scarta, rendendo il confronto tra insiemi di segnali non valido. | IPOTESI | PACCHETTO sez. 2 | Test con filtro spread variabile | 1h |
| B3 | La probabilità 0,000457 (C1) è un'illusione statistica: le notti non sono indipendenti; un trend favorevole sull'oro trascina tutte le notti in positivo. | IPOTESI | PACCHETTO sez. 4 | Correlazione notti | 1h |

---

### Ruolo A — Cacciatore di meccanismi

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| A1 | Meccanismo 1: Uscita su "Time-Exit" dinamico basato su volatilità (input `InpTimeExitBars` variabile). Attesa: PF > 1,05. Falsificatore: PF < 0,95. | IPOTESI | PACCHETTO sez. 1 | Test su 12 passate | 10 min |
| A2 | Meccanismo 2: Filtro di regime basato su "Range giornaliero" (input `InpMaxTradesPerDay` come proxy). Attesa: PF > 1,1. Falsificatore: PF < 0,9. | IPOTESI | PACCHETTO sez. 5 | Test su 12 passate | 10 min |

---

### Ruolo D — Sintesi

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| D1 | La replica non riproduce il docente: la divergenza è strutturale (feed/spread/manuale). | FATTO | PACCHETTO sez. 4 | Confronto R1A vs Docente | 0 |
| D2 | Proposta misura 1: Richiesta export trade (orari, prezzi, flag manuale) al docente. Attesa: Identificazione uscite manuali. Falsificatore: Dati non forniti. | IPOTESI | PACCHETTO Q7 | Richiesta a Claudio | 0 |
| D3 | Proposta misura 2: Test su feed BCM con filtro spread "largo" (L3) vs "stretto" (REPL). Attesa: PF invariato. Falsificatore: PF > 1,1. | IPOTESI | PACCHETTO sez. 3.2 | Round tester | 10 min |

**Disaccordo:** Il ruolo A propone meccanismi basati su input esistenti, mentre il ruolo B suggerisce che il problema sia l'insieme dei segnali (feed) non replicabile. La sintesi D privilegia la verifica dei dati (export trade) prima di ulteriori test di ottimizzazione.

---

### Sezione E — Avvocato del diavolo (Metodo)
1. **Critica al metodo**: Il protocollo attuale rischia di sprecare tempo macchina su motori che, come dimostrato in sez. 3.2, hanno una deriva lorda negativa. **Proposta**: Prima di ogni test di meccanismo, eseguire un test di "deriva lorda" (senza commissioni/spread) per verificare se il motore ha edge statistico. Se la deriva è indistinguibile da zero, il motore è morto a prescindere dall'uscita.
2. **Ruolo mancante**: Un "Analista di Microstruttura" che confronti i tick del docente con i nostri per validare se l'insieme dei segnali è lo stesso.
3. **Regola da misurare**: La regola del "40x spread" è corretta, ma su M1 oro potrebbe essere troppo severa per motori che lavorano su code lunghe. Misurerei l'impatto di un pavimento a 20x su 1000 operazioni per vedere se il PF cambia significativamente.
