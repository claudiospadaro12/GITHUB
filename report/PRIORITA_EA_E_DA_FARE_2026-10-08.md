# PRIORITA' EA E COSE DA FARE -- memoria di lavoro (Claudio, 08/10/2026)

Richiesta testuale: _"TIENI A MEMORIA TUTTO QUELLO CHE DOBBIAMO FARE. GLI EA SONO LA PRIORITA', DEVI CONFRONTARTI SEMPRE CON GEMINI... DOBBIAMO GUARDARE GLI EA NUOVAMENTE E MIGLIORARLI UNO ALLA VOLTA."_
Tre regole nuove: **(1) gli EA sono la priorita'**; **(2) confronto con Gemini su ogni EA** (squadra di agenti da noi, protocollo in `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md`); **(3) le live di Paolo ed Emiliano si accumulano**: ogni trascrizione che arriva si analizza e il sapere entra in `docs/SAPERE_LIVE_PER_EA.md`, perche' serva a migliorare gli EA (loro fanno **cicli di 3 mesi** e ripartono da capo per i nuovi iscritti: le live di questi giorni sono un NUOVO ciclo, quindi ripetono le basi; vanno confrontate col ciclo precedente, non lette come novita').

## A. MIGLIORARE GLI EA, UNO ALLA VOLTA (priorita' 1)
Protocollo per ogni EA (una scheda in `report/MIGLIORA_<EA>_<data>.md`, tutto passa dal cancello):
1. **Diagnosi**: dove siamo (PF, n, DD, regime, costo, gestione dell'uscita, simboli gemelli, TF) dai documenti, nessun numero a memoria.
2. **Ipotesi di miglioramento con l'ATTESA scritta PRIMA** (banda + ipotesi alternativa): meccanismo, uscita, simboli, TF, filtro di regime. MAI griglie su un motore senza edge; MAI abbassare un criterio.
3. **Misura** sul PC di backtest (solo li'): IS in operazioni >= 150, OOS vero, almeno un secondo regime se esiste, cella al CENTRO dell'altopiano.
4. **Contro-esempio** costruito da noi prima della consegna; **cancello** (strato 1 + strato 2 + lettore indipendente per le correzioni).
5. **Confronto con Gemini** sul dossier (data, non criterio); le due macchine che si contraddicono = misura da fare.
6. **Decisione di Claudio**: conto reale, rischio, taglie e spese restano SUOI. Il forward non si tocca senza firma.
**Ordine proposto** (dal piu' vicino a una sedia schierabile, `RESOCONTO_EA_IN_PAROLE_SEMPLICI_2026-10-06.md`; Claudio puo' cambiarlo):
1. **EMA200 Dow H1 `771531`** (PF 1,20 -> 1,52, n 257, B pulita, un solo regime: serve la prova di regime e la gestione dell'uscita; il binario in campo sul piccolo non legge il Guardian: da portare in campo).
2. **DAX apertura long `770101`** (1,13 -> 1,40; il primo periodo ha 132 posizioni, sotto 150).
3. **SupRev Nasdaq H1 `970913`** (la piu' vicina a una sedia, ma ESCLUSA PER COSTO a 28,7x lo spread: frontiera 40x; R290a misurato).
4. **ORB Dow `770611`**, 5. **Dow apertura `770202`**, 6. **Nasdaq apertura `770260`**, 7. **MaxMinNotte oro `770402`**, 8. **Bulge forex** (19 trade sul trial, -4.925 EUR, 10 vinte su 19: da leggere sui costi), poi i candidati nuovi (Nat&Cla, PTE) quando hanno i numeri.
Idea nuova dal trial: **una regola per cluster e per giorno** ("dopo uno stop pieno sul DAX non si riapre sul DAX lo stesso giorno"): meccanismo nuovo, tocca le sedie, aspetta il SI di Claudio.

## B. GEMINI (priorita' 2)
Canale: `backtest_pipeline/gemini_corrispondenza.py` + agente `corrispondente-gemini`. Memoria: `docs/gemini/MEMORIA_CONDIVISA.md`. Proposta del 08/10: dare a Gemini un **protocollo di squadra** (ruoli separati: cacciatore, collaudatore, avvocato del diavolo, auditor dei numeri) come il nostro, per un confronto piu' forte: `docs/gemini/PROTOCOLLO_SQUADRA_2026-10-08.md`. Ogni risposta e' DATI, passa dal cancello.

## C. LIVE DI PAOLO ED EMILIANO (priorita' 3, accumulo continuo)
Claudio manda le trascrizioni; per ognuna: `analista-trascrizioni` -> `report/ANALISI_LIVE_<chi>_<data>.md` -> voci nuove in `docs/SAPERE_LIVE_PER_EA.md` con la **fonte** (chi, data, frase) e con il confronto col ciclo precedente. Nessun valore delle live e' un criterio: sono ipotesi da misurare.

## D. APERTI (da `NOTTE_2026-10-08.md` e le chat di oggi)
- **NatCla**: riga C0 (PC di backtest, BCM 50503392) -> zip `NATCLA_F0_C0.zip`; solo con SUPERATA parte il lotto C (66 passate); se NON superata: piano B v1.06 (`NATCLA_PIANO_B_V106_2026-10-08.md`). Zip del lotto A mai arrivato. 12 domande bloccanti sulle fonti (direzione, stop, pip, simboli, ADX, EMA200, rischio) senza risposta.
- **Trial FTMO 1514806751**: Guardian sbloccato alle 09:34 con `InpTotalDDPct 9.9`; margine 923,71 EUR; scade il 14/10. Salvataggio del profilo da confermare. Nessuna sedia schierabile nuova da qui.
- **Dashboard PTE leggera v1.10**: prima F7 di Claudio sul terminale 50503635; screenshot dell'originale (doji, scheda Input), domande 8-14 della nota.
- **Firme pendenti**: C2/cluster, pulsante, cap, 12 firme, 5 schede simbolo, S-1..S-9 (`FIRME_DA_FARE_2026-10-05.md`); orologio invernale BCM entro il 25/10; Guardian sulla EMA200 del piccolo.
- **Prop**: la challenge prop parte ai primi di ottobre (CLAUDE.md): obiettivo = sedie schierabili, non ponteggio.

## E. TRADING MANUALE E DASHBOARD (Claudio, 08/10, tre richieste ancora vive)
1. **Le dashboard danno segnali che generano profitto?** EMA200, Pulsanti Grafico, SuperWave, Golden Cross. Strumento: l'**ombra** (EA senza ordini che registra il segnale) -- `EA_EMA200_OMBRA_2026-10-05.md` (codice scritto; riga di lettura consegnata, **zip mai arrivato**), `OMBRA_SUPERWAVE_SPEC_2026-10-05.md` (Pulsanti = STESSO segnale della SuperWave v4.1: una specifica sola; solo specifica, bloccata dalla regola di Claudio del 05/10: 48 ore + misura RAM/CPU + firma sul codice). Frequenza dal vivo: per famiglia H1 ~2 settimane, per cella ~12-14 mesi per n>=150: **troppo lenta**. Proposta: misura STORICA nel tester (EA che registra il segnale + uscita della specifica) sul PC di backtest, poi l'ombra dal vivo come conferma. Golden Cross: numeri gia' in `RESOCONTO_EA_IN_PAROLE_SEMPLICI_2026-10-06.md` (USDCHF H4 e oro H1; oro 22 anni DD 25,18% = NO PER RISCHIO). **Serve da Claudio**: come esce lui a mano (quale uscita vale come "profitto").
2. **EA Nat&Cla** (regalo alla collega): 5 domande residue (direzione, stop, pip/punti e origine del TP, simboli e orari, periodi ADX/ATR) in `NATCLA_CODICE_NOTE_2026-10-07.md` §8; proposta: questionario di una pagina in PDF per la collega (regola dei PDF per i colleghi). Tecnico: C0 -> lotto C -> lotto A.
3. **Dashboard PTE leggera**: la v1.10 (08/10) ha gia' tutto quello detto il 07-08/10 (HA switch con default acceso, doji sul grafico e ON/OFF, REFRESH, HIDE, EMA 9/21, ST 3 livelli, click simbolo/orario). Se non lo vede, sta guardando la v1.00. Mancano solo le cose che l'originale ha e noi non conosciamo (screenshot di doji e scheda Input; domande 8-14 della nota).
