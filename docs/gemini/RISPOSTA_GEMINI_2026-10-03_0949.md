# RISPOSTA DI GEMINI -- 03/10/2026 09:49 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO)
- `docs/gemini/MEMORIA_CONDIVISA.md` (7511 byte, SHA256 704B4722AD8EA3EE)
- `docs/PER_GEMINI_TRIAL_GIORNO3_2026-10-03.md` (13432 byte, SHA256 12321B78B5EF59A5)

---

Ecco la risposta dell'Agente 3 e dell'Agente 4, strutturata secondo i vincoli del progetto ABTG.

### Le tre cose più importanti trovate
1. **Rischio di correlazione**: Il 72,7% del netto negativo del trial deriva da 2 short DAX, ma il 1,49% del conto è bruciato in 6 secondi da 2 buy forex correlati (EURNZD/GBPAUD). La protezione non è il blocco giornaliero, ma il limite di esposizione per cluster di valuta.
2. **Fallacia del Payoff**: Il Bulge ha un payoff atteso negativo (-677,81) e win-rate 6/10, ma le vinte sono concentrate su GBPNZD. Senza questa coppia, il motore è in perdita netta.
3. **Mancanza di indipendenza**: L'aggregazione di 28 coppie forex per la misura EMA200 è statisticamente viziata dalla correlazione (es. NZD presente in 7/10 posizioni).

---

### AGENTE 3 — Proposte di miglioramento

| Proposta | Componente | Evidenza | Costo | Firma Claudio? |
| :--- | :--- | :--- | :--- | :--- |
| **1. Limite Cluster Valuta** | Gestione Rischio | Audit `AUDIT_RISCHIO_FLOTTA_2026-10-01.md` | 0 (Analisi) | SI |
| **2. Filtro Correlazione Temporale** | Motore (Ingressi) | Report Trial 03/10 (stop 6s) | 2 passate | NO |
| **3. Validazione EMA200 (n efficace)** | Metodo (Statistica) | `EMA200_D1_SU_M5_MISURA_2026-10-02.md` | 4 ore uomo | NO |

#### Schede complete
**1. Limite Cluster Valuta**
*   **Cosa**: Introdurre un `InpMaxClusterRisk` (es. 1,5% max su valute correlate come NZD/AUD).
*   **Perché**: Il 02/10, due posizioni hanno bruciato l'1,49% del conto in 6 secondi. Il rischio non è la singola sedia, ma l'esposizione al paniere NZD.
*   **Misura**: Analisi storica dei per-trade: calcolo del DD massimo su cluster NZD vs DD su singola sedia. Falsificabile se il DD del cluster è <= DD singola sedia.
*   **Costo**: 0 (analisi dati esistenti).

**2. Filtro Correlazione Temporale**
*   **Cosa**: `InpMinTimeBetweenTrades` (es. 300 secondi) per sedie dello stesso sottostante o cluster.
*   **Perché**: Evita l'esecuzione di stop multipli su news o spike di volatilità che colpiscono l'intero paniere.
*   **Misura**: Backtest su 2 finestre (2024.09.26 - oggi) con e senza filtro. Falsificabile se il PF scende di >0,05.
*   **Costo**: 2 passate tester.

**3. Validazione EMA200 (n efficace)**
*   **Cosa**: Calcolo dell'n efficace tramite matrice di correlazione dei rendimenti delle 28 coppie prima di aggregare.
*   **Perché**: L'aggregazione semplice sovrastima la significatività statistica (n nominale vs n reale).
*   **Misura**: Confronto tra P-value aggregato e P-value medio delle coppie singole. Falsificabile se la differenza è < 0,02.
*   **Costo**: 4 ore uomo (analisi statistica).

---

### AGENTE 4 — Avvocato del diavolo (Contro-esempi)

**Contro-esempio Proposta 1 (Limite Cluster)**:
*   **Situazione**: Il cluster NZD è in trend forte. Il limite blocca l'ingresso su una sedia vincente mentre la sedia già aperta è in profitto.
*   **Risultato**: Il limite riduce il profitto totale del 20% in un trend di 3 giorni. Se il guadagno perso è > della protezione dal DD, la misura è in perdita.

**Contro-esempio Proposta 2 (Filtro Temporale)**:
*   **Situazione**: Il mercato esegue un breakout reale. Il filtro blocca la seconda sedia (che sarebbe stata vincente) perché la prima è entrata 10 secondi prima.
*   **Risultato**: Il filtro riduce il numero di operazioni (n) e il PF. Se il PF scende sotto la soglia di stabilità (es. < 1,2), la misura è bocciata.

**Contro-esempio Proposta 3 (n efficace)**:
*   **Situazione**: L'n efficace risulta 1/4 di quello nominale.
*   **Risultato**: La significatività statistica crolla. Se il P-value sale sopra 0,05, la strategia EMA200 viene dichiarata "rumore" e il lavoro di mesi viene invalidato.

---

### Risposte alle domande (Sez. 4)

**(a) Misure su challenge 5%/10%**:
1. **Simulazione "Stress Test Correlazione"**: Simulare il DD di un paniere di 7 sedie NZD-correlate. *Falsificabile*: se il DD simulato è < 4%, il rischio è accettabile.
2. **Misura "Recovery Post-Soglia"**: Analisi dei per-trade: quante operazioni vincenti servono per recuperare il 5% di DD? *Falsificabile*: se servono > 50 trade, il sistema è troppo lento per la challenge.

**(b) Disegno misura EMA200**:
*   **Congelamento**: Definire "tocco" come *minimo 1 pip di penetrazione del corpo della candela*.
*   **Indipendenza**: Usare la correlazione di Pearson sui rendimenti a 1H. *Falsificabile*: se la correlazione media > 0,6, l'n efficace deve essere ridotto del 50%.

**(c) Regole gestione manuale**:
*   **Stop in pari**: Nessuna evidenza pubblica solida (fonte: *NON MISURATO*).
*   **Contro-esempio**: Se il mercato ha un rumore (ATR) di 10 pips e lo stop in pari viene messo a 5 pips, la probabilità di essere stoppati in pari prima del TP è > 80%. *Numero soglia*: se > 60% delle operazioni chiudono in pari, la regola costa più di quanto protegge.

**(d) Punti dimenticati**:
1. **Regola del "Giorno di Reset"**: Non sappiamo se il limite 5% si resetta alle 00:00 server o 24h dopo l'ultima perdita. *Misura*: Analisi dei log FTMO del 01/10 e 02/10.
2. **Costo commissioni**: Nel trial, le commissioni pesano per 204,04 EUR su 8.811,59 di perdita. *Misura*: Incidenza % delle commissioni sul payoff. *Falsificabile*: se > 10% del payoff, il motore è insostenibile.
