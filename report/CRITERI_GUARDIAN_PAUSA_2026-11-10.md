# Guardian: comportamento in pausa senza ciclo "piazza e cancella" — CRITERI e PREVISIONI (10/11/2026, scritti PRIMA di scrivere o provare il codice)

**Natura: CRITERI, nessun codice scritto, nessuna modifica al Guardian di `lavoro`.** Nasce dal ciclo osservato sul trial FTMO e su un demo BCM (`RICHIESTE_AL_SERVER_STIMA_DAI_TEST_2026-11-10.md`) e dall'avviso di iperattivita di FTMO (2.000 richieste al giorno, modifiche e annullamenti compresi). Il reale 10105439, il trial FTMO e il VPS non si toccano da parte mia: le prove si fanno su un **demo BCM**, con il tuo ok.

## Cosa fa oggi (letto nel codice `mql5_patch/copia_v1_17/ABTG_Guardian_v117_PROVA.mq5` = v1.15 + patch 1.16 e 1.17)
- `OnTimer` gira **ogni secondo** (`EventSetTimer(1)`).
- Quando scatta il blocco giornaliero (perdita >= limite) o la challenge e fallita, e `InpAction==0`: `FlattenAll()` **una volta**, poi "continuo a ricacciare indietro ogni nuovo trade": **a ogni secondo, se esiste anche un solo ordine o posizione, richiama `FlattenAll()`** (chiude tutte le posizioni e cancella **tutti** i pendenti, di qualsiasi magic perche `InpCloseAllMagics=true`).
- **Conseguenza**: ogni pendente rimesso da un EA di terzi viene cancellato entro un secondo; gli EA lo rimettono alla barra dopo (H1, M15...). Ogni cancellazione e ogni piazzamento sono richieste al server. Osservato: 760 piazzati e 796 annullati tra le 02:32 e le 06:35 sul trial (748 nello stesso minuto); "Annullato 1.337" alle 08:32; 314 piazzati il 09/11 sul demo 50504263.
- **La chiusura del venerdi (v1.16, spenta di default)** ha lo stesso schema ("ricaccia indietro ogni nuovo ordine ogni secondo"): se la si accendesse, ripeterebbe il ciclo per tutte le ore della finestra.
- La **pausa "morbida"** (`SetPausa`) vale solo per gli EA ABTG nostri: gli EA di Wim non la leggono.

## Requisiti del nuovo comportamento in pausa
1. **Sicurezza invariata**: dopo il limite giornaliero nessuna posizione nuova resta aperta oltre qualche secondo, e le posizioni gia aperte si chiudono una volta (come oggi).
2. **Richieste al server ridotte**: in pausa, il Guardian non deve produrre un flusso continuo di cancellazioni; obiettivo: **meno di 100 richieste all'ora in totale (Guardian + EA)** dopo la chiusura iniziale, e **mai piu di 300 richieste al giorno dovute al Guardian**.
3. **Log compatto**: FTMO conta le righe del registro; il Guardian non deve scrivere una riga per ogni cancellazione (al massimo un riepilogo ogni 5 minuti).
4. **Contatore delle richieste del Guardian stesso** (v1.17 conta solo le transazioni viste; le richieste respinte probabilmente no): da includere nel riepilogo.
5. **Valida anche per la chiusura del venerdi** e per qualunque stato "bloccato".
6. **Retrocompatibile**: la modalita attuale resta disponibile (`modo 0`), la nuova si attiva solo con un input nuovo.

## Varianti da provare (decisione presa dopo la prova, non ora)
- **Modo 1, "solo vicini"**: in pausa si cancellano solo i pendenti entro N punti dal prezzo (quelli che possono scattare); i pendenti lontani (per esempio i buy stop a 4.699 con il prezzo a 4.125) restano. Rischio: un pendente che scatta dopo che il prezzo si avvicina.
- **Modo 2, "solo fill"**: in pausa non si cancella niente; ogni **nuova posizione** (fill di un pendente) si chiude entro 1 secondo. Meno richieste (solo sui fill); costo: spread e slippage di ogni fill chiuso; rischio: un fill con gap vicino al limite del 5%.
- **Modo 3, "frequenza limitata"**: si cancella al massimo ogni N secondi (per esempio 60). Dimezza ma non elimina il ciclo (gli EA rimettono comunque i pendenti alla barra dopo).

## Come si prova (solo su un DEMO BCM, con il tuo ok; mai sul trial, sul reale o sul VPS FTMO)
1. Rileggere il codice, scrivere la versione (copia, non toccare `lavoro`), compilare (stessa procedura della v1.17), **autotest** con valori di soglia bassi.
2. Su un demo BCM con gli stessi EA, **soglia giornaliera abbassata** (per esempio 0,1%) per far scattare il blocco in pochi minuti, per **2 ore**: prima la versione attuale (per riprodurre il ciclo e avere il riferimento), poi i modi 1, 2 e 3.
3. Misure: ordini piazzati e annullati per ora (scheda Storico → Ordini), righe del registro del terminale per ora, tempo di chiusura di ogni nuova posizione, perdita aggiuntiva dopo il blocco.

## Regole di lettura (fissate ora)
- **RIDUCE** il ciclo se gli ordini piazzati + annullati all'ora in pausa calano di almeno il **90%** rispetto alla versione attuale; **RIDUCE POCO** tra il 50% e il 90%; **NON RIDUCE** sotto il 50%.
- **SICURO** se, dopo il blocco, nessuna posizione resta aperta piu di **5 secondi** e la perdita aggiuntiva da fill dopo il blocco e **inferiore allo 0,3% del conto**.
- **Verdetto per modo**: **ADOTTABILE** se RIDUCE e SICURO e le righe del registro restano sotto 200 all'ora; altrimenti **DA SCARTARE** o **DA RIVEDERE**.

## Previsioni dichiarate ORA (non misurate)
- **P1** La versione attuale riproduce il ciclo sul demo (oltre 300 ordini piazzati+annullati all'ora): 85%.
- **P2** Il modo 1 RIDUCE (>= 90%) e resta SICURO: 55%.
- **P3** Il modo 2 RIDUCE (>= 90%) e resta SICURO: 65%; almeno un fill in 2 ore: 35%.
- **P4** Il modo 3 NON RIDUCE (< 50%): 70%.
- **P5** Nessun modo supera lo 0,3% di perdita aggiuntiva dopo il blocco: 90%.
- **P6** Gli EA rimettono comunque i pendenti anche se non si cancellano (il ciclo persiste nel modo 1 o 2): 15%.
- **P7** Il codice compila senza errori al primo tentativo: 60%.
- **P8** Il registro del terminale resta sotto 200 righe all'ora in pausa con il modo scelto: 70%.
- **P9** Almeno un modo e ADOTTABILE: 70%; nessuno: 10%.

## Limiti dichiarati
Un demo, due ore per modo, un percorso di mercato; la pausa e il comportamento degli EA dipendono dalla volatilita del momento; le richieste del Guardian si stimano dalla scheda Ordini e dal registro, non dal conteggio di FTMO; l'effetto su FTMO non si puo provare senza usare un conto FTMO (trial in scadenza il 16/11). Resta aperta la domanda a FTMO sul conteggio (richieste respinte, orario del giorno, soglia dell'avviso). Nessun giudizio su acquisti, taglie o lotti.
