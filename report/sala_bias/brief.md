# La sala del consiglio - Replica del MULTI TF BIAS DASHBOARD (brief comune, 26/10/2026)
**Prompt master:** `PROMPT_MASTER_SALA_V2.md` (V2, caricato da Claudio). Regole di casa che restano sopra: criteri scritti PRIMA dei numeri; fatti con fonte o NON VERIFICATO; nessun acquisto, taglia o lotto proposto (decisioni di Claudio); BCM server UTC+1 fisso; nessun test su VPS/reale.

## 1. Problema e risultato
Claudio ha un indicatore compilato (`MULTI_TF_BIAS_DASHBOARD.ex5`, "BAN_MULTI_TF_BIAS_DASHBOARD 1.00", **senza sorgente**) di cui "dicono sia ottimo". Chiede: **(a) una replica**, **(b) capire se il bias ha valore**, **(c) se si puo creare un EA**. Sorgenti disponibili: la **guida PDF** (testo in `GUIDA_BIAS_testo.txt`) e due **screenshot degli input** (D30EUR M5), trascritti in `report/INDICATORE_MULTI_TF_BIAS_ANALISI_2026-10-26.md`.
## 2. Destinatari e uso
Claudio, per decidere se questo bias merita di diventare un filtro o un EA nel suo portafoglio (conto personale 5.000 EUR e prop FTMO 80K).
## 3. Deliverable e maturita richiesta
(1) specifica formale della replica con le scelte esplicite dove la guida e ambigua; (2) implementazione di riferimento in Python con autotest; (3) **studio pre-registrato del segnale** su oro (storia D1 BCM dal 2004) per regime; (4) verdetto: il bias, cosi replicato, ha un vantaggio misurabile? (5) **solo se si**: proposta di EA con regole dichiarate e porting MQL5; altrimenti un "no motivato". Maturita: **verificato localmente** (Python su dati storici); l'MQL5 non si compila qui (nessun MetaEditor): sarebbe `bozza` finche non compilato sul PC.
## 4. Vincoli e risorse
Dati: oro D1 BCM 2004-06-11/2026-10-21 (repo), M1 BCM parziali 2026 (repo) e export M1 2025-26 in attesa; indici solo sul PC di Claudio. Nessuna spesa. Python senza numpy.
## 5. Dati disponibili e mancanti
Mancano: formule esatte dell'indicatore (la guida le descrive a parole), M15/H1/H4 su storia lunga, valori della dashboard dal vivo per validare la replica. **Dichiarato: la replica NON coincide con il prodotto originale.**
## 6. Ipotesi iniziali
H1: ricostruire punteggio per timeframe e Overall dalla guida e possibile con scelte ragionevoli. H2: il bias dei soli timeframe alti (W1, D1) puo essere studiato su 22 anni di oro con dati completi. H3: un filtro di tendenza cosi ha valore dipendente dal regime. H4: senza intraday lungo non si puo giudicare il quadro a cinque timeframe: lo studio dei cinque timeframe resta rinviato all'export M1.
## 7. Criteri di accettazione
Specifica con ogni scelta dichiarata e giustificata; implementazione che passa l'autotest e **una seconda implementazione indipendente** (A7) che concorda sulle direzioni nella grande maggioranza dei casi (soglia nei criteri); studio eseguito esattamente come pre-registrato; verdetto con limiti.
## 8. Autorizzato / da demandare
Autorizzato: scrivere codice e report nel repo, eseguire analisi locali. Da demandare: qualunque acquisto, taglia, uso su conti, messa in produzione.
## 9. Fuori perimetro
Compilazione MetaEditor sul PC, test nel tester MT5 dell'EA (solo dopo un esito positivo e una riga dedicata), qualunque ottimizzazione di parametri sullo stesso dataset del verdetto.
