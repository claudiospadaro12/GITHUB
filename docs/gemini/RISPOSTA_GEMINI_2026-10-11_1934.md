# RISPOSTA DI GEMINI -- 11/10/2026 19:34 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO), modalita completa
- `docs/gemini/MEMORIA_CONDIVISA.md` (20236 byte, SHA256 83B232D9D29247F5)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9933 byte, SHA256 C72E335B4DBAC6B4)
- `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md` (12256 byte, SHA256 35F7D669BAD564D9)
- `docs/PER_GEMINI_PIANO_PICCOLO_DEMO_2026-10-11.md` (37035 byte, SHA256 1D9BF4473DADD7FA)
- domanda del giorno: Piano conto demo: rispondi SOLO alla Q1 della sez. 4 del PACCHETTO, nel ruolo B del protocollo (avvocato del diavolo); ignora l'indicazione Agente 3 e Agente 4; niente ruoli A, C, D e niente sezione E; al massimo 3 esiti; tabella N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo; NON LO SO dove manca un dato.

---

Ecco la risposta alla **Q1** (ruolo B, avvocato del diavolo) relativa al piano di schieramento EMA200 Dow H1.

### Ruolo B: Avvocato del diavolo (Q1)

| N | Affermazione | Etichetta | Fonte | Verificabile da noi come | Costo |
|---|---|---|---|---|---|
| 1 | Un esito di 0 segnali in 5 giorni (15-21/10) non smentisce l'attesa di 2,9 segnali, essendo un evento con probabilità ~5,5% (Poisson). | CALCOLO | PACCHETTO sez. 4 | Verifica calcolo Poisson con $\lambda=2,9$ | 5 min |
| 2 | Se l'export per-trade mostra `ARMATE > 0` ma `PIAZZATI = 0` (riepilogo `[EMA200-IMBUTO]`), l'attesa di "entra da sola" è smentita da un filtro interno (es. `InpPendingExpiryBars` o spread). | IPOTESI | PACCHETTO sez. 4 | Lettura riga `[EMA200-IMBUTO]` nel giornale | 10 min |
| 3 | Un DD forward > 7,83% (a taglia 1%) in 5 giorni è impossibile per perdite normali; se accade, è prova di doppia sedia o errore di taglia. | IPOTESI | PACCHETTO sez. 2 (fatto 9) | Confronto DD cumulata vs soglia 7,83% | 15 min |
| 4 | L'ipotesi alternativa "mani sullo stesso conto" produce un DD > 7,83% (fatto 13: -26,9% il 08/10) che contamina il criterio di rischio della sedia. | FATTO | PACCHETTO sez. 2 (fatto 13) | Confronto P/L manuale vs soglia DD | 5 min |
| 5 | L'orologio del broker (UTC+1 fisso) esclude l'ipotesi che il PF diverso dal backtest sia causato da cambio d'ora nella prima settimana. | FATTO | PACCHETTO sez. 2 (fatto 7) | Verifica orario server BCM | 5 min |

**Analisi degli esiti smentitori:**

1.  **Esito A (Zero segnali con `ARMATE = 0`)**: Smentisce l'attesa di operatività. *Ipotesi alternativa*: Ottobre è un mese a bassa frequenza (fatto 5). *Verifica*: Se `ARMATE = 0`, l'EA non ha visto setup; se `ARMATE > 0` e `PIAZZATI = 0`, il filtro interno (spread/tempo) ha bloccato l'ingresso.
2.  **Esito B (DD > 7,83% sull'equity totale)**: Smentisce la tenuta del rischio. *Ipotesi alternativa*: Contaminazione da operazioni manuali (fatto 13). *Verifica*: Se il DD è causato dalle mani, il P/L della sedia (colonna `magic` nell'export) sarà coerente col backtest, mentre l'equity totale sarà in DD.
3.  **Esito C (Magic diverso da 771531)**: Smentisce l'attribuzione corretta. *Ipotesi alternativa*: Errore di configurazione nel preset o doppia sedia attiva. *Verifica*: Controllo colonna `magic` nell'export per-trade.

**Nota sul contro-esempio**: Se il DD forward viene calcolato sull'equity del conto (condivisa), il criterio di rischio fallisce per colpa delle mani (es. -26,9% del 08/10), rendendo la misura del merito della sedia EMA200 non determinabile. L'ipotesi alternativa (mani) cade nella banda di smentita del rischio, rendendo il test del DD non specifico per la sedia.
