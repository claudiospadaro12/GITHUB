# CONSEGNA — SALA-BIAS-001: replica del MULTI TF BIAS DASHBOARD e studio del segnale
Data: 26/10/2026 · Modalità: MISTA (agenti A2, A3, A4, A6, A7 reali; C0, A1, A5 sintetici) · Metodo: La Sala del Consiglio V2

## 1. Risultato e stato
**Stato: VALIDAZIONE_NECESSARIA** (punteggio **83,2** su 100, soglia 90). Nota di correzione: l'evento E014 del registro riporta 83,5; il totale calcolato dalla griglia è 83,2 ed è quello valido.

**Verdetto sul valore del bias (replica, solo oro, W1+D1, orizzonte 5 e 20 giorni): C — NON CONCLUSIVO (potenza).**
Frasi obbligatorie:
1. È un verdetto sulla **replica, non validata contro l'originale** (non abbiamo il sorgente; il .ex5 e la guida PDF non permettono di ricostruire le formule).
2. Vale solo per **oro, W1+D1, rendimenti a 5 e 20 giorni**.
3. **Nessun vantaggio dimostrato non significa nessun vantaggio.** Differenza minima rilevabile (MDE): h=20 → 2,21% (lettura primaria) / 2,10% (robustezza); h=5 → 0,59% / 0,54%.
4. **Nessuna regola EA tarabile su questi dati. Nessun EA proposto.**

Numeri principali (lettura primaria, h=20, definizione (a), dati D1 fusi 2008-07 → 2026, 5.763 barre; fonte `agents/A4/studio_S1_output.txt`):
- BULL: 2.240 giorni, media +0,847% · BEAR: 1.162 giorni, +0,632% · tutti: +0,733%.
- Spread BULL−BEAR **+0,214%**; IC95 approssimato **[−1,07% ; +1,50%]** (A6). t di Welch per offset 0,86 / 0,41 / 0,86 / −0,33 / 0,49 (mediana 0,49). Permutazione circolare: p 0,267.
- Benchmark banali: B1 (close vs EMA200 D1) spread +0,13% (t 0,42); B2 (rendimento a 250 giorni) +0,04% (t −0,20). **La replica non è distinguibile da questi due benchmark.**
- 3 anni positivi su 12 valutabili (soglia 8). I cinque criteri della lettura primaria falliscono tutti; nessun t ≤ −2 (la regola 14 non scatta). Robustezza (dal 2010-04): solo il criterio 3 passa.

## 2. Perché C (motivazione riscritta, D004)
Con la regola R7 ("potenza sufficiente se MDE ≤ |deriva|") **B è irraggiungibile con questo campione per costruzione**: servirebbero circa 657 osservazioni non sovrapposte per stato contro 107/56 disponibili. **C è quindi del disegno, non dei dati: nessun campione di questa lunghezza avrebbe potuto produrre B.** A è escluso perché tutti i criteri falliscono. Cosa dicono i dati: l'effetto puntuale è vicino a zero (+0,2% a 20 giorni, +0,02% a 5 giorni) e l'IC esclude, al 95%, spread medi sopra circa +1,5% a 20 giorni e sopra circa +0,36% a 5 giorni. Effetti piccoli (≤ 1%) non sono né esclusi né dimostrati.
Sensibilità dichiarate: il criterio 3 dipende dalla data di inizio (prima metà −0,396% in lettura primaria, +0,456% togliendo luglio 2008–marzo 2010); la "robustezza" taglia i primi 21 mesi ma non elimina il peso del seme della EMA su W1; `h20_b` della lettura primaria è **non valutabile** (non FAIL; nessun effetto sull'esito perché `h5_b` fallisce davvero).

## 3. Artefatti (tutti in `report/sala_bias/`)
| Cosa | Dove |
|---|---|
| Prompt master | `PROMPT_MASTER_SALA_V2.md` |
| Brief, scheda del Consiglio, stato, eventi, decisioni | `brief.md`, `scheda_consiglio.md`, `state.json`, `events.jsonl`, `decisions.md` (D001–D004) |
| Criteri congelati prima dei numeri | `criteri_studio_S1_v2.md` (v1 superata per D002) |
| Specifica della replica (17 scelte S01–S17) | `agents/A2/specifica_replica.md` |
| Qualità dati | `agents/A3/` |
| Replica + studio (A4) | `agents/A4/bias_replica.py` (33 autotest), `studio_S1.py`, `SHA256_CONGELAMENTO.txt`, `studio_S1_output.txt` |
| Ricalcolo indipendente (A7) | `agents/A7/replica_indipendente.py`, `verifica_studio/` |
| Critiche (A6) | `reviews/A6_critica_criteri.md`, `reviews/A6_critica_risultati.md` |

Riesecuzione: `python3 -I agents/A4/bias_replica.py --autotest` (33/33 PASS, ~8 s) e `python3 -I agents/A4/studio_S1.py` (~16 s, output identico).

## 4. Decisioni
- **D001** impostazione del progetto (replica dichiarata, modalità MISTA).
- **D002** criteri v2 congelati (adottate le 16 modifiche di A6; domeniche fuse nel lunedì; test di causalità; due soli esiti sostituiti da A/B/C).
- **D003** EMA valida da n barre (v2) come lettura di riferimento; la specifica letterale (2n) riportata come corsa equivalente. Esito identico (C). Con 2n il Trend W1 manca fino al 2012-03-12.
- **D004** ratifica R1–R10 di A4 con riscrittura di R7 (vedi §2).

## 5. Verifiche
- A7, implementazione indipendente: 5.763 barre fuse, **0 differenze**; spread/t/episodi coincidenti. Accordo A4–A7 sullo score: 95,5% sulle classi, kappa 0,866, correlazione 0,982. La corsa con lo score di A7 dà anch'essa C (nota A6: in quella corsa i test di causalità di A7 non sono stati eseguiti dal gate → non vale come verdetto di A7 finché non li esegue).
- A6, causalità: nessun look-ahead (test del prefisso su 980 date, differenza massima 5e-11); mutanti M1–M5 individuati dai test, tranne quelli nel solo ramo di produzione.
- SHA256 di congelamento: 6 file su 6 coincidono con i file attuali (verifica di A6).
- **Limite noto (I004):** i test di causalità percorrono il ramo `only=lista`, non quello di produzione `only=None` (equivalenza verificata su 824 date, differenza 0). **Prima di qualsiasi eventuale esito A va aggiunto un test di equivalenza** con nuova decisione e nuovo SHA.
- Non fatto: compilazione MQL5 (nessun codice MQL5 prodotto), confronto con l'indicatore originale.

## 6. Griglia di qualità (pesi 20/20/15/15/10/10/10)
| Dimensione | Peso | Voto | Evidenza / limite |
|---|---|---|---|
| Aderenza all'obiettivo | 20 | 80 | replica dichiarata, verdetto C, risposta sull'EA; mancano fedeltà all'originale e quadro a 5 timeframe |
| Correttezza ed evidenze | 20 | 85 | ricalcolo indipendente (A7), mutanti e prefisso (A6), SHA, 33 autotest; replica non validata |
| Completezza | 15 | 80 | requisiti essenziali coperti; 5 timeframe e MQL5 non fatti |
| Fattibilità e robustezza | 15 | 80 | riesecuzione in 16 s; buco nei test del ramo di produzione accettato con riserva |
| Utilizzabilità | 10 | 85 | report e comandi di riesecuzione |
| Verificabilità | 10 | 92 | SHA256, comandi, file di output |
| Qualità espositiva | 10 | 85 | documento di consegna; nessuna dashboard HTML |
| **Totale** | 100 | **83,2** | sotto soglia 90 → VALIDAZIONE_NECESSARIA (nessuna dimensione < 80) |

## 7. Dissenso e limiti
- A6 ha sollevato 7 obiezioni: due bloccanti (domeniche, causalità) risolte; R7 (Alta) accettata con motivazione riscritta; le altre accettate o risolte come da `state.json` (I001–I007).
- Non si afferma che l'indicatore originale non funzioni: si afferma che **questa replica**, sul solo oro e W1+D1, non mostra un vantaggio misurabile con questo campione.

## 8. Ipotesi esplorative da pre-registrare — NON concluse
Trovate da A6 **dopo** aver visto i numeri, con più tagli (almeno 8) e senza correzione per confronti multipli.
- **H-A**: spread BULL−BEAR negativo *dentro* l'anno (−2,58% a 20 giorni; p di permutazione dentro-anno 0,0007). **Identico nei benchmark** (B1 −3,15%, B2 −2,67%): è una proprietà degli stati lenti di trend dell'oro (ribassi seguiti da rimbalzi), non dell'indicatore; pochi episodi dominano. Il +0,21% complessivo è un effetto di composizione fra anni.
- **H-B**: gradiente per volatilità ex-ante (ATR14/close, terzili espansivi): spread basso +1,53%, medio +0,59%, alto −2,42%; differenza p 0,007 non corretto (≈0,04 con Bonferroni); seconda metà del campione molto più debole.
- **H-C** (debole, nessuna pre-registrazione autonoma): BEAR deciso seguito da rimbalzo a 5 giorni; non regge in robustezza.
Per una v3: dati nuovi (forward, altri strumenti), effetto minimo di interesse dichiarato in anticipo (es. pareggio dopo costi) o test di equivalenza al posto di R7, ipotesi scritte prima di guardare.

## 9. Uso e prossime azioni
1. **Nessun EA su questa evidenza.** Un EA basato sul bias richiederebbe prima: fedeltà verificata e uno studio con potenza/ipotesi dichiarate.
2. **Fedeltà all'originale** (opzionale, solo lettura): script che registra i testi del dashboard originale per W1/D1 in tempo reale + screenshot; poi si confronta con la replica.
3. **Quadro a cinque timeframe**: richiede l'export M1 dell'oro (`RIGA_LANCIA_EXPORT_M1_ORO.txt`, da lanciare sul PC di backtest).
4. Decisioni di acquisto, lotti e rischio restano di Claudio.

## 10. Parere finale del Consiglio
Replica costruita, verificata in modo indipendente e riproducibile; il segnale **W1+D1 sull'oro non mostra un vantaggio dimostrabile con questo campione e non è una base per un EA**. Il progetto resta in VALIDAZIONE_NECESSARIA per mancanza di fedeltà all'originale e di studio a cinque timeframe, non per errori nei numeri.
