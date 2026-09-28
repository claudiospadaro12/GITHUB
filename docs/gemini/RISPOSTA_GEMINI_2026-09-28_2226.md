# RISPOSTA DI GEMINI -- 28/09/2026 22:26 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO)
- `docs/gemini/MEMORIA_CONDIVISA.md` (3152 byte, SHA256 33018A574BF8B1C1)
- `docs/BRIEFING_PER_GEMINI_2026-09-27.md` (18967 byte, SHA256 C34D4F97CF2DB420)
- `docs/PER_GEMINI_EA_FUORI_GIOCO_2026-09-29.md` (111954 byte, SHA256 5CF98A787723712E)
- domanda del giorno: CACCIA CONGIUNTA (mandato di Claudio, 29/09: 'chiediamogli cosa farebbe lui e insieme cercate parametri migliori, andate a caccia insieme'). Hai il briefing del progetto, la memoria condivisa e il dossier di TUTTI i motori fuori gioco con i parametri esatti delle celle misurate. Rispondi in tre parti: (1) COSA FARESTI TU, in ordine di priorita', per ottenere PF migliori su questi motori SENZA violare la regola zero (mai griglie su un motore senza edge): per ogni motore che vale la pena, l'errore di configurazione se lo vedi (input incoerenti, filtro spento da accendere, ora sbagliata, stop fuori scala) con la riga o il parametro, e UN meccanismo alternativo con attesa dichiarata, contro-esempio, piano di misura nel nostro imbuto e costo in celle x 2 finestre; (2) quali motori consideri CHIUSI DAVVERO e perche' (con il certificato in mano); (3) la DIVISIONE DEL LAVORO: cosa misuri tu leggendo codice e parametri, cosa misuriamo noi sul PC di backtest, e cosa ti serve da noi al prossimo giro. Massimo 10 proposte in tutto, ordinate; ogni numero con la fonte o NON MISURATO; le finestre solo dallo storico esistente.

---

Ecco la risposta dell'Agente 3 e dell'Agente 4.

### Le 3 cose più importanti
1. **Stop-Loss fuori scala**: Molti motori (Londra, EMA200, Live5m) hanno stop che violano il pavimento 40x. Non è un problema di "ottimizzazione", è un problema di **costo strutturale** che rende il motore un "mangia-spread".
2. **Filtri di regime "taglienti"**: L'oro (R260d) e il Dow (R255) mostrano che i filtri (EMA, Supertrend) non separano l'edge, ma "tagliano" il campione. Se il PF migliora solo perché il filtro rimuove i trade perdenti senza che il meccanismo di base sia sano, è rumore.
3. **Orologio BCM**: La divergenza tra ora server (UTC+1 fisso) e ora cash (FTMO) è la causa principale del "PF estivo vs PF invernale". Ogni proposta di meccanismo deve essere testata con l'orologio "in fase" (righe estive + invernali).

---

### Tabella Proposte e Stato Motori

| # | Motore | (a) Errore Config. | (b) Meccanismo + Attesa + Costo | (c) Chiuso/Aperto |
|---|---|---|---|---|
| A4 | EMA200 EURUSD | `InpSLatr` inerte | **Meccanismo**: Allargare `InpSLatr` a 1.5 per stop >= 26.5 pip. **Attesa**: PF > 1.10, n > 150. **Costo**: 10 celle x 2. | Aperto (manca misura) |
| A7 | Dow Short | `InpRetestOffsetPts` mai ad asse | **Meccanismo**: Testare `InpRetestOffsetPts` 0-800. **Attesa**: PF > 1.10, DD < 8%. **Costo**: 12 celle x 2. | Aperto (manca misura) |
| A1 | Londra ORB | `InpMinRangePips` = 0 | **Meccanismo**: Filtro volatilità asiatica (ATR). **Attesa**: PF > 1.10. **Costo**: 8 celle x 2. | Chiuso (Rischio) |
| A11 | MaxMinNotte DAX | `InpMgmtTF` inerte | **Meccanismo**: Uscita a tempo (timestop). **Attesa**: PF > 1.10. **Costo**: 6 celle x 2. | Chiuso (Merito) |

---

### Analisi Agente 3 (Proponente) e Agente 4 (Avvocato del Diavolo)

**1. EMA200 EURUSD (A4)**
*   **Proposta**: Allargare `InpSLatr` a 1.5.
*   **Perché**: Lo stop attuale (1.0) è sotto il pavimento 40x (35.3x). Allargando, il costo diventa sostenibile.
*   **Contro-esempio (Agente 4)**: Se allargando lo stop il PF scende sotto 1.10, significa che l'edge era basato solo su stop stretti che "scappavano" dal rumore.
*   **Misura**: Walk-forward su 2017-2023.

**2. Dow Short (A7)**
*   **Proposta**: Testare `InpRetestOffsetPts` (0-800).
*   **Perché**: Il retest è la chiave del Dow. L'offset attuale è fisso; un asse permetterebbe di trovare il punto di ingresso meno "rumoroso".
*   **Contro-esempio**: Se il PF non sale, il motore è intrinsecamente privo di edge short (il Dow ha un bias long strutturale).
*   **Misura**: Test su finestra 2024-2026 (tick).

**3. Londra ORB (A1)**
*   **Proposta**: Filtro volatilità asiatica (ATR).
*   **Perché**: Il range di 1 ora è troppo variabile. Senza filtro, il motore entra in giornate "piatte" dove lo spread mangia tutto.
*   **Contro-esempio**: Se il filtro riduce n sotto 150, il motore muore per campione.
*   **Costo**: Escluso per costo (3-8 pip = 3.6-9.5x < 40x). **Proposta esclusa per costo.**

---

### Divisione del lavoro
*   **Cosa misuro io (Gemini)**: Analisi dei sorgenti per identificare manopole inerti (es. `InpMgmtTF` in `MaxMinNotte`).
*   **Cosa misurate voi (Backtest)**: Lancio dei file prova con le correzioni (es. `InpSLatr` su EMA200).
*   **Cosa mi serve**: Il sorgente di `ABTG_Londra_ORB` e `ABTG_MaxMinNotte` per verificare se `InpMgmtTF` è effettivamente letto dal ramo attivo.

**Motori CHIUSI DAVVERO**:
*   **Londra ORB (A1)**: Chiuso per costo (stop < 40x) e rischio (DD > 30%).
*   **MaxMinNotte DAX (A11)**: Chiuso per merito (0/41 celle positive).
*   **VwapRevert (B6)**: Chiuso per falsificazione (S0 negativo).
*   **PostNews (B4)**: Chiuso per merito (PF < 1 su n pieno).
