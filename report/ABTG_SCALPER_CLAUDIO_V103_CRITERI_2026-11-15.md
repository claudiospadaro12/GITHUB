# Scalper Claudio 1.03: correzioni e ricerca del vantaggio (15/11/2026, criteri e previsioni scritti PRIMA dei numeri)

**Natura: CRITERI.** Nessuna passata lanciata con la 1.03. Solo DEMO e tester: l'EA parte in live solo sul demo 50503635 (controllo in `OnInit`, non modificato); **non va su FTMO e il conto reale non e abilitato**. Nessun giudizio su lotti, taglie o acquisti. Base: `RISULTATI_SCALPER_CLAUDIO_PASSATA_A_2026-11-14.md` (1.02: -96,5% in 3 mesi a tick reali, PF 0,29, direzione senza vantaggio 43,2% contro 44,4%).

## Obiettivo dichiarato da Claudio
Guadagnare circa 1.000 EUR al giorno e poi chiudere la giornata, sul conto reale (non FTMO). **Considerazioni, non decisioni:** 1.000 EUR al giorno sono una percentuale del capitale: su 10.000 EUR e il 10% al giorno, su 100.000 EUR l'1%. Nessuna strategia che conosciamo (nemmeno i portafogli di Wim su Karnek: +1,1% al mese) arriva a quei ritmi in modo stabile; chi li mostra usa rischi che azzerano conti. Un obiettivo giornaliero non crea un vantaggio: serve solo a smettere di operare dopo una buona giornata. L'EA ora ha `InpDailyTargetEuro` e `InpDailyLossEuro` (0 = spenti).
Claudio: "anche se porta piu guadagno" = sono ammesse varianti che si allontanano dall'idea originale (per esempio uno stop su ogni posizione al posto del recupero a zero), **ma il giudice e il risultato su dati nuovi, a tick reali e con i costi, non il guadagno nel periodo di prova.**

## Cosa cambia nella 1.03
1. **Niente spam a mercato chiuso:** pausa di 5 minuti dopo un rifiuto "market closed" (10 s per altri rifiuti), controllo `SYMBOL_TRADE_MODE`, pausa breve sulle chiusure rifiutate. Prima: 865.156 rifiuti in un trimestre, 44.460 richieste in un giorno.
2. **Conteggi corretti:** passi, segnali e misura S-9 solo se almeno un ordine si apre.
3. **Netto per motivo di uscita** (target, cesto, freno, a zero, altro/giornata) nel riepilogo.
4. **Obiettivo e perdita giornalieri:** se guadagno (chiuso + cesto aperto) o perdita raggiungono la soglia, chiude tutto e non riapre fino al giorno dopo (ora server).
5. **Misura del vantaggio (EDGE):** per ogni passo aperto registra la mossa del prezzo dopo 5, 30 e 120 secondi nel verso scelto, al lordo e al netto dello spread (1 spread = costo di andata e ritorno), per **velocita** (4 classi), **ora del giorno** (6 fasce da 4 ore) e **rapporto spread/mossa** (4 classi). Il riepilogo stampa n, media lorda, media netta e statistica t per ogni casella (42 righe `EDGE`). Le misure a cavallo di buchi di mercato (oltre 3 volte l'orizzonte) sono scartate.
6. **Non cambia la logica di ingresso e di uscita:** questa versione MISURA; non e una nuova strategia.

## Piano di misura (tester a tick reali, XAUUSD, deposito 10.000 EUR, lotto 0,01, input come la 1.02)
- **Periodo A (ricerca):** 2025-01-01 -> 2025-06-30. **Periodo B (conferma, non guardato prima di fissare le regole):** 2025-07-01 -> 2025-12-31.
- **Passata 1:** A, input della 1.02 (confronto con la prima misura e con i difetti corretti). **Passata 2:** B, stessi input.
- Se i tick reali di quei periodi non sono completi (qualita < 98%), si usano i mesi disponibili e lo scrivo.

## Regole di decisione (scritte ora)
- Una casella EDGE **"ha vantaggio"** se in A: n >= 300, media netta > 0 e **t >= 3,5** (soglia alta perche le caselle sono 42: troppe prove); e in B: stessa casella, n >= 150, media netta > 0 e t >= 2.
- **Se nessuna casella lo ha: "nessun vantaggio trovato".** L'EA resta cosi com'e, non si ritocchino soglie o orizzonti per cercarlo. Si valuta se fermarsi.
- **Se una o piu lo hanno:** seconda fase, scritta prima di partire: ingressi solo in quelle caselle, ogni posizione con SL e TP fissi (non recupero a zero), test su B a tick reali con costi.
- **I costi del guadagno giornaliero** (target/limite) NON si valutano in questa fase: senza vantaggio non hanno senso.

## Previsioni (scritte ora)
- **E-1** La 1.03 compila al primo tentativo: 70%.
- **E-2** I rifiuti "mercato chiuso" scendono sotto 1.000 per periodo (da 865.156): 90%.
- **E-3** La media netta (lordo - spread) su tutti i passi e negativa a tutti e tre gli orizzonti: 85%.
- **E-4** Almeno una casella con t >= 3,5 e media netta > 0 in A: 15%. Confermata in B: 5%.
- **E-5** Il netto per motivo mostra "a zero" non positivo e "freno" fortemente negativo (cioe il freno perde piu di quanto il recupero guadagni): 80%.
- **E-6** Il risultato complessivo dei due periodi resta negativo (PF < 1): 90%.

## Cosa NON sappiamo
Se il segnale (movimento del bid in 2 secondi) puo avere vantaggio con altri filtri; la latenza e lo slippage reali (il tester non li ha: in live peggio); le regole del tuo broker reale sulle richieste al giorno e sullo scalping; la velocita del tuo VPS verso il broker.
