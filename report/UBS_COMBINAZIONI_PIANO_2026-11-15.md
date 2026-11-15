# UBS: piano per trovare le combinazioni giuste (15/11/2026, scritto PRIMA dei numeri)

**Natura: PIANO e criteri.** Nessuna riga lanciata, nessun numero nuovo. Solo tester; reale, FTMO e VPS non si toccano; nessun giudizio su lotti, taglie o acquisti (decisioni di Claudio). Segue `UBS_OTTIMIZZAZIONE_A_C_CRITERI_2026-11-14.md` e `RISULTATI_UBS_C_PILOTA_2026-11-15.md`.

## 1. Che cosa cerchiamo
Una **combinazione** = un gruppo di set UBS (e, se serve, un componente oro) con un lotto per ciascuno. Obiettivo dichiarato da Claudio: EA **non correlati con l'oro**, meno "affollati" dagli altri utenti di Wim, che insieme riducano il rischio di fallire la challenge FTMO 2-Step (5% giorno, 10% totale).
Misura finale (una sola, scelta prima): **quota di partenze che falliscono** (metodo "fail-rate" su partenze di tutto l'anno, costi centrale/prudente) e **tempo mediano al superamento** della combinazione, confrontati con P1/P3 (oro puro) negli stessi anni.

## 2. Perche non si provano "tutte"
Le combinazioni sono praticamente infinite (lo dice Wim, ed e vero: 20 set forex presi a gruppi da 3-5 sono gia migliaia, per ogni scelta di lotti). Con tante prove, qualcuna va bene per puro caso. Quindi: **pochi candidati, regole di scelta scritte prima, selezione su un periodo e verifica su un altro**, e si conta quante combinazioni abbiamo guardato.

## 3. Le fasi (ogni fase ha una regola di arresto)
- **F1 — Set singoli (in corso):** pilota fatto; forex 20 set x 2 periodi lanciato. Un set passa se, in entrambi i periodi: >= 150 operazioni, PF >= 1,20, netto > 0, nessuno stop out, DD stabile fra i periodi (criteri del 14/11). Sotto 150 operazioni: NON VALUTABILE, non scartato. Controllo per ogni passata che ci siano operazioni in ogni anno della finestra.
- **F2 — Serie giornaliere:** per ogni sopravvissuto, profitto realizzato giornaliero ricostruito dalle operazioni del report. LIMITE: manca il flottante (non abbiamo le barre M1 forex nel repository), quindi correlazioni e DD sono **sottostimati**; da dichiarare in ogni tabella.
- **F3 — Matrice di correlazione:** fra sopravvissuti e con l'oro P1/P3/P4 sugli stessi anni. Soglie dei criteri: <= 0,30 verso l'oro, <= 0,60 fra loro. Si guardano anche i giorni di coda (le correlazioni salgono nelle crisi): correlazione sui soli giorni peggiori del portafoglio.
- **F4 — Costruzione, senza ottimizzare:** regole fisse scritte qui, niente algoritmo che cerca il massimo: (a) un solo set per simbolo e famiglia; (b) al massimo 4 componenti non oro; (c) partendo dal set migliore per recovery factor, si aggiunge il successivo solo se la correlazione resta sotto soglia; (d) lotto per componente in modo che ognuno abbia lo **stesso rischio** (stesso DD a lotto fisso), non lotti scelti a posteriori. Ordine di scelta e numero di combinazioni provate registrati.
- **F5 — Selezione/verifica:** le combinazioni si costruiscono con i dati del periodo 1 (2013-2018) e si valutano **solo** sul periodo 2 (2019-2025), poi si invertono i ruoli. Una combinazione vale solo se regge in entrambi i sensi. Prova di perturbazione: lotti +-20% e rimozione di un componente alla volta (la quota di varianti ancora accettabili >= 0,7).
- **F6 — Costi e tick:** spread e commissioni reali (lo spread del forex su FTMO e BCM NON e ancora misurato: foto di lunedi a mercato aperto), poi un anno a tick reali per i sopravvissuti (soglie: rapporto PF >= 0,7, DD tick <= 1,5 x M1). I forex scalper con vincite da pochi pip sono i piu sensibili.
- **F7 — Fail-rate della combinazione** con la stessa simulazione delle challenge (partenze di tutto l'anno), contro P1/P3.
- **F8 — Forward demo:** minimo 4 settimane su demo/trial prima di qualunque pensiero su conti veri.

## 4. Il ramo A (EA oro "rimbalzo sul livello")
Resta in attesa delle tre risposte di Claudio (quali livelli, stop/target, ore). Quando c'e, entra in F2 come un componente qualunque: stessa matrice, stesse soglie.

## 5. Previsioni (scritte prima)
- **C-1** Dopo F1 sui 20 forex passano 2-6 set: 55%; zero: 20%; piu di 6: 25%.
- **C-2** Tra i sopravvissuti forex, la correlazione con l'oro (sul realizzato giornaliero) e <= 0,30 per almeno l'80%: 75%.
- **C-3** Una combinazione che passa F5 in entrambi i sensi esiste: 40%.
- **C-4** Aggiungere componenti non oro riduce il fail-rate rispetto al solo oro di almeno 2 punti percentuali: 35%; lo lascia uguale o lo peggiora: 45% (il flottante mancante rende la diversificazione apparente piu bella del vero).
- **C-5** Dopo i costi reali (F6) resta almeno un candidato: 50%.
- **C-6** Gli indici (ORB) non entrano in nessuna combinazione finale: 85% (poche operazioni, finestra oraria da correggere, prior sfavorevole).

## 6. Cosa non sappiamo
Il flottante forex; lo spread forex reale; se piu EA di Wim sullo stesso conto si comportano come la somma delle passate singole (margine, ordini simultanei: da provare con una corsa vera combinata, NON verificato); quanti altri utenti usano gli stessi set (non misurabile); cosa conta come "stessa strategia" per il tetto FTMO (in attesa della risposta).

## 7. Decisioni che spettano a Claudio
1. Obiettivo principale: **meno rischio di fallire** oppure **piu velocita** oppure **meno correlazione con l'oro**? (cambia la misura di F4/F7).
2. Numero massimo di EA non oro nel portafoglio (proposta: 4).
3. Le combinazioni devono includere l'oro P1/P3 o essere un portafoglio a parte?
