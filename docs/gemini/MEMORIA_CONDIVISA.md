# MEMORIA CONDIVISA CLAUDE <-> GEMINI (aggiornata dalla sessione, mandata a Gemini a OGNI scambio)

Perche' esiste: la memoria dell'app Gemini (account Pro di Claudio) vive nell'app e NON e' raggiungibile dall'API. La
corrispondenza automatica usa l'API, che non ha memoria: la memoria gliela diamo noi, con questo file, in testa a ogni pacchetto.
Regola: qui stanno SOLO fatti misurati e decisioni prese, con la fonte nel repo. Niente ipotesi non etichettate.

## 1. Chi siamo e cosa vogliamo (28/09/2026)
- Progetto ABTG: EA MQL5 per passare le challenge prop. Challenge FTMO 2-Step 80k `541452707` viva dal 22/09; sette sedie a 2,00%.
- Obiettivo dichiarato da Claudio: PIU' SEDIE SCHIERABILI. Metodo: imbuto (file prova -> cancello -> riga -> referto -> firma).
- Ruoli: Claude = sviluppatore + cancello (misura, verifica, propone); Gemini = Agente 1-4 (legge, audita, propone, contro-esempio);
  Claudio = firma taglie/rischio/conti/spese. Nessuna proposta si esegue senza cancello.

## 2. Cosa e' CHIUSO (non si riapre senza tesi nuova)
- Long DAX 770101, uscita: soglia d'armo del trailing (agosto, 5x5: rinviare peggiora), TrailMode (R270: il vivo vince), TP1_R (R270:
  inerte 1-2R). APERTA: `InpTP1_ClosePct=0` (migliore in 4/4 misure ma dentro il rumore; firma di Claudio pendente).
- Short DAX 770105 alla cella specchio del long: senza merito, DD sopra il muro (R251, R270). Motore short NON ANCORA MISURATO.
- Oro EMA200 H4 (griglia C2): NO PER RISCHIO su 2017-23 con certificato completo; 2024-26 buono ma non confrontabile (G0 rosso,
  causa non dimostrata). Short Dow 770212: bocciata per rischio (R255 con S1 emendata); stH8/stH12 indizi (n < 150).
- EURUSD EMA200 H4: escluso per costo (35-37x < 40x), NON ANCORA MISURATO (`InpSLatr` mai ad asse).

## 3. Cosa e' in coda (proposte di Gemini accolte come candidati, in ordine)
1. Misure a costo zero dai per-trade: ClosePct=0 «esposizione o selezione»; short «giorni senza fill» (in corsa la notte 28/29-09).
2. Meccanismi d'uscita nuovi sul long (uscita a tempo, trailing armato dopo 2 candele): richiedono codice + round.
3. Tokenizer PowerShell vero nel cancello (`controlla_riga.py`).
4. MFE/MAE nell'export per-trade (ponteggio). 5. Filtro di regime EX ANTE sull'oro EMA200 (contro-esempio obbligatorio).

## 4. Regole che Gemini deve rispettare in ogni risposta
Finestre solo dallo storico esistente (indici BCM dal 2024.09.26); «passate» = celle x 2 finestre; niente griglie su motori senza
edge; stop >= 40x (spread+commissione); centro dell'altopiano mai il picco; due lati sugli indici; ogni numero con la fonte o NON
MISURATO; prima della macchina, la misura a costo zero nei per-trade gia' in archivio.

## 5. Storico degli scambi
- 28/09 notte: canale API aperto (credenziale dell'ambiente); primo scambio automatico sui due documenti del giorno
  (`docs/gemini/RISPOSTA_GEMINI_2026-09-28_2207.md`), da verificare al cancello il 29/09 mattina.
- 28/09: consegna 1 (4 consigli: 3 gia' noti, 1 candidato); consegna 2 (guida al PF: 7/9 gia' nel repo); consegna 3 (proposte su
  R270: formato giusto, 3 correzioni di metodo). Risposte in `docs/RISPOSTA_A_GEMINI_*.md`.
