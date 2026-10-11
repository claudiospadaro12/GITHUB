# GBA R2U -- ingressi COMUNI contro ingressi AGGIUNTI/TOLTI: quanto e' uscita e quanto e' selezione (11/10/2026)

> **Bozza, NON passata dal cancello.** Strumento: `backtest_pipeline/gba_ingressi_comuni.py`
> (strumento di analisi, NON passato dal cancello; autotest `--autotest` OK). Misura a costo zero sui
> deal gia' in archivio (MEMORIA par. 4). Nessun criterio cambiato, nessun verdetto di archivio.

## Perche'
Il cancello ha trovato che nell'R2U il contrasto K15 -> KOFF (la "pendenza" +0,052 della lettura
`report/GBA_R2_USCITA_LETTURA_2026-10-11.md`) **non misura l'uscita**: le due celle non operano sugli
stessi ingressi (una posizione per volta: se l'uscita cambia la durata, cambiano anche i segnali che
trovano il posto libero). Quel risultato veniva da uno script di scratch non passato dal cancello. Qui
e' **rifatto con un parser indipendente scritto da zero** (non ho aperto `scratchpad/s7/overlap.py`) ed
esteso a tutte le 8 celle d'uscita contro la REPL: e' la misura che separa l'effetto d'USCITA
dall'effetto di SELEZIONE (S9 del piano R2).

## Metodo
- **Dati**: `GBA_R2_USCITA_20261011/` (R2UBE, R2UATRFIX, R2UTEMPO, R2UKTRAIL) + ancora REPL
  `GBA_R0_R1A_20261010/GBA_R0_R1A.zip` (magic 775800). La gemella G1 (REPL T1 magic 775850 in R2UBE)
  e' tenuta a parte come controllo d'identita'.
- **Parser**: `html.parser` sui report `.htm` (UTF-16) del tester; riga deal = 13 celle; tabella Ordini
  (11 celle) letta solo per lo S/L iniziale. Posizioni **FIFO per lato** (un out sell chiude la buy
  aperta piu' vecchia e viceversa); volume parziale -> errore esplicito (mai capitato: tutti i 8.636
  ingressi hanno volume 1,0). PF_V = profitto+swap+commissione di in e out; la regola "commissione
  totale zero -> 3,90 per lotto" non e' mai scattata (tutte le 28 passate hanno commissione).
- **Ingresso** = (tranche, data-ora server del deal d'ingresso, lato). Per ogni coppia A -> B:
  COMUNI (in entrambe), SOLO-A (= REMOVED passando a B), SOLO-B (= ADDED).
- **Scomposizione ADDITIVA del netto** (il PF non e' additivo, il netto si'):
  `netto(B) - netto(A) = [netto_B - netto_A sui comuni] + netto(ADDED) - netto(REMOVED)`.
- **Bootstrap per GIORNO** (giorno server del deal d'ingresso; 168 giorni), 5.000 repliche, seed
  12345, del delta PF_V(B) - PF_V(A) **sugli ingressi comuni**, appaiato (stessi giorni per le due celle).

## Controlli prima dei numeri
| controllo | atteso | misurato |
|---|---|---|
| n e PF_V per cella contro la lettura | 933/0,8546 REPL, 1.131/0,8483 K15, 859/0,8998 KOFF, e le altre 6 | **tutte e 9 identiche** al lettore (`R2U_tabella.csv`, 4 decimali) [MISURATO] |
| coerenza comuni + solo-A = n(A), comuni + solo-B = n(B) | sempre | vera in tutte le 10 coppie (assert nel codice) [MISURATO] |
| **identita'**: REPL T1 (R1A) contro gemella G1 (magic 775850) | 128 comuni, 0 aggiunti/tolti, 0 uscite diverse, delta 0 | 128/0/0, 128 uscite identiche, somma\|delta netto\| **0,00** [MISURATO] |
| chiavi duplicate in una cella | 0 | 0 in tutte le 28 passate [MISURATO] |
| sui comuni: prezzo d'ingresso, volume, S/L iniziale | identici | **0 differenze** in tutte le 9 coppie [MISURATO] |
| la chiave discrimina? ingressi di B spostati di +1 minuto / lato invertito | quasi 0 comuni | REPL-K15: 3 e 0 (contro 931); REPL-KOFF: 2 e 0 (contro 851) [MISURATO] |
| aperte a fine passata | 0 | 0 in tutte [MISURATO] |

### Contro-esempio: TOFF (uscita a tempo spenta) deve dare ~0
- REPL 933 -> TOFF 932: **932 comuni, 1 tolto, 0 aggiunti** [MISURATO].
- Sui comuni **924 su 932 hanno la stessa uscita, al secondo, e lo stesso netto (somma\|delta\| 0,00)**.
  Le **8** con uscita diversa sono **esattamente** le 8 chiusure a mercato (commento vuoto = uscita a
  tempo) della REPL: in TOFF le stesse 8 finiscono sullo SL qualche minuto dopo (netto 22.918,82 ->
  19.702,47) [MISURATO].
- Delta PF_V sui comuni **-0,0087** (sd bootstrap 0,0038): non e' zero, ma e' **tutto** in quelle 8
  posizioni -- e' l'effetto vero (piccolo) dell'uscita a tempo, non un errore dello strumento. L'unico
  ingresso tolto (T3 18/03 13:51 sell, -1.209,72) esiste nella REPL **perche'** la sua uscita a tempo
  alle 13:47 ha liberato il posto, mentre in TOFF la posizione delle 12:59 era ancora aperta fino alle
  13:52:05: e' il meccanismo della selezione, visto su un caso solo [MISURATO].
- Lo strumento quindi da' **zero dove la verita' e' zero** (gemella; 924 posizioni identiche) e
  localizza il non-zero esattamente dove l'uscita cambia. Contro-esempio superato.

## (1) K15 -> KOFF (la "pendenza")
Riconferma, con parser indipendente, dei numeri del cancello -- **tutti identici** [MISURATO]:

| insieme | n | PF_V | netto medio | netto | T1 PF (n) | T2 PF (n) | T3 PF (n) |
|---|---:|---:|---:|---:|---|---|---|
| cella K15 | 1.131 | 0,8483 | -49,28 | -55.732 | 0,890 (148) | 0,906 (286) | 0,826 (697) |
| cella KOFF | 859 | 0,8998 | -40,60 | -34.878 | 0,976 (118) | 0,669 (233) | 0,971 (508) |
| comuni, uscita K15 | 857 | **0,8957** | -30,67 | -26.287 | 0,883 (118) | 0,879 (233) | 0,904 (506) |
| comuni, uscita KOFF | 857 | **0,8774** | -49,79 | -42.668 | 0,976 (118) | 0,669 (233) | 0,937 (506) |
| solo K15 (REMOVED) | 274 | 0,7447 | -107,46 | -29.445 | 0,914 (30) | 1,004 (53) | 0,683 (191) |
| solo KOFF (ADDED) | 2 | -- | +3.894,92 | +7.790 | -- (0) | -- (0) | 2 operazioni |

- Scomposizione del netto [DERIVATO, somma esatta]: **+20.854 = uscita sui comuni -16.380 + ADDED
  +7.790 - REMOVED (-29.445)**. Per tranche: T1 +3.081 = +2.315 + 0 + 766; **T2 -20.645 = -20.575
  (uscita)** + 0 - 70; T3 +38.419 = +1.880 + 7.790 + 28.749.
- I 2 ingressi solo-KOFF: uno e' **+7.797,59 da solo** (28/01 21:26 buy, chiuso alle 00:05) -- in quel
  minuto K15 era dentro una buy delle 21:20; l'altro -7,75 [MISURATO].
- Ordine: dei 857 comuni, **127 hanno la stessa ora d'uscita** (119 anche lo stesso netto), **730 no**
  (in KOFF 118 di quelle 730 chiudono a mercato, cioe' a tempo, in K15 tutte a SL) [MISURATO].
- **Bootstrap per giorno sui comuni** (857, 168 giorni): delta PF_V **-0,0183, sd 0,127, IC 95%
  [-0,262 ; +0,231]**, P(delta <= 0) 0,57 [MISURATO]. Non appaiato (per confronto): sd 0,157.
- **Lettura** [DERIVATO]: il +0,052 aggregato della pendenza viene **dalla selezione** (274 ingressi
  che K15 prende in piu', PF 0,745, quasi tutti in T3, e 1 operazione da +7.798 in KOFF), non
  dall'uscita: sugli stessi ingressi togliere il trailing **peggiora** di 0,018 (segno opposto),
  dentro un rumore di 0,13. L'esito scritto prima ("nessuna pendenza oltre il rumore") non cambia; cambia
  cosa misurava quel contrasto: la pendenza **non** e' una misura dell'uscita.

## (2) Le 8 celle d'uscita contro la REPL (933, PF_V 0,8546)
| cella | n | PF_V cella | comuni | PF_V REPL sui comuni | PF_V cella sui comuni | **delta uscita** (sd boot; IC 95%) | REMOVED n / PF_V | ADDED n / PF_V | d_netto = uscita + ADDED - REMOVED |
|---|---:|---:|---:|---:|---:|---|---|---|---|
| BEOFF | 882 | 0,8432 | 880 | 0,8427 | 0,8424 | -0,000 (0,049; -0,100/+0,094) | 53 / 1,031 | 2 / 5,68 | -13.566 = -13.176 + 325 - 715 |
| BE05 | 1.074 | 0,7780 | 927 | 0,8607 | 0,7309 | **-0,130** (0,055; **-0,236/-0,020**) | 6 / 0,369 | 147 / 1,119 | -14.692 = -22.058 + 4.460 + 2.906 |
| BE15 | 898 | 0,8462 | 895 | 0,8398 | 0,8454 | +0,006 (0,038; -0,069/+0,083) | 38 / 1,246 | 3 / 1,031 | -9.393 = -6.141 + 54 - 3.306 |
| ATRFIX | 926 | 0,8864 | 899 | 0,8544 | 0,8928 | +0,038 (0,048; -0,054/+0,133) | 34 / 0,859 | 27 / 0,763 | +10.318 = +12.431 - 4.497 + 2.384 |
| TOFF | 932 | 0,8487 | 932 | 0,8574 | 0,8487 | -0,009 (0,004; -0,017/-0,003) | 1 / 0,000 | 0 / -- | -2.007 = -3.216 + 0 + 1.210 |
| K15 | 1.131 | 0,8483 | 931 | 0,8547 | 0,8742 | +0,020 (0,071; -0,117/+0,163) | 2 / 0,000 | **200 / 0,758** | -1.913 = +17.880 - 19.850 + 56 |
| K35 | 873 | 0,9107 | 868 | 0,8455 | 0,9094 | **+0,064** (0,080; -0,082/+0,226) | 65 / 0,941 | 5 / 1,028 | +22.542 = +20.378 + 102 + 2.063 |
| KOFF | 859 | 0,8998 | 851 | 0,8554 | 0,8948 | +0,039 (0,112; -0,171/+0,264) | 82 / 0,849 | 8 / 1,114 | +18.942 = +10.961 + 911 + 7.070 |

[MISURATO: n, PF_V, comuni, REMOVED/ADDED, bootstrap; DERIVATO: la scomposizione del netto, somma esatta.]
Netto medio e dettaglio per tranche (T1/T2/T3) di ogni insieme sono nell'uscita dello strumento.

**Che cosa dice** [DERIVATO, in campione, 2026 T1-T3]:
- **K35**: il miglioramento sulla REPL (+22.542 di netto) e' per **~90% uscita sui comuni** (+20.378):
  e' la cella dove l'uscita fa la differenza, ma il delta +0,064 sta dentro una sd di 0,080
  (P(delta <= 0) 0,21). Non separabile da zero.
- **KOFF**: +18.942 = 58% uscita (+10.961) e 42% selezione (82 ingressi tolti, netto -7.070, + 8
  aggiunti +911). Delta sui comuni +0,039, sd 0,112: dentro il rumore, e **T2 va al contrario** (0,756
  -> 0,669 sui 232 comuni).
- **K15**: sugli stessi ingressi della REPL l'uscita **aiuta** (+0,020, +17.880 di netto), ma i **200
  ingressi in piu'** che il trailing stretto libera hanno PF 0,758 e mangiano tutto (-19.850). Il PF
  di cella invariato (0,848 contro 0,855) nasconde due effetti opposti.
- **ATRFIX**: +0,038 sui comuni, sd 0,048; la selezione pesa poco e contro (ADDED 27 PF 0,763).
- **BE05**: l'unica col delta uscita fuori dall'intervallo 95% del bootstrap: **-0,130, IC [-0,236 ;
  -0,020]**, P(delta <= 0) 0,991. Sulle 311 posizioni comuni con uscita diversa la REPL fa PF 1,168
  (netto +16.716), BE05 chiude a pareggio meno costi (PF 0,000, netto -5.342): il BE a 0,5 ATR
  **taglia i vincenti**. E' nella direzione di H1 della lettura. Attenzione: 8 confronti sulla stessa
  REPL; con Bonferroni (0,05/8, bilaterale) la soglia sarebbe p < 0,0063 contro p ~0,018 (2 x 0,009):
  **non passa la correzione** [DERIVATO].
- **BEOFF, BE15**: delta ~0 sui comuni (-0,000 e +0,006): quello che le distingue dalla REPL e' quasi
  tutto selezione (REMOVED 53 PF 1,031 e 38 PF 1,246).
- **La selezione non ha un segno fisso** [DERIVATO]: gli ingressi aggiunti da uscite piu' corte hanno PF
  0,758 (K15) ma 1,119 (BE05); quelli tolti da uscite piu' lunghe vanno da 0,849 (KOFF) a 1,246 (BE15).
  "I rientri ravvicinati sono cattivi" NON e' una regola che questi numeri sostengano.

## (3) Bootstrap per giorno del delta PF_V sui comuni (5.000, seed 12345)
| coppia | comuni | giorni | delta | sd | IC 95% | P(delta <= 0) |
|---|---:|---:|---:|---:|---|---:|
| K15 -> KOFF | 857 | 168 | -0,0183 | 0,1267 | [-0,262 ; +0,231] | 0,572 |
| REPL -> K35 | 868 | 168 | +0,0640 | 0,0800 | [-0,082 ; +0,226] | 0,213 |

Non appaiato (giorni ricampionati separatamente, per confronto): sd 0,157 e 0,138. La sd appaiata di
K15 -> KOFF sui comuni (0,127) e' **piu' alta** di quella della pendenza di cella misurata in
`gba_pendenza_appaiata.py` (0,094): sui comuni le due uscite divergono su 730 posizioni su 857, e il PF
di un insieme di soli comuni e' sensibile a poche operazioni grandi [INFERITO].

## (5) L'effetto dell'ordine: il matching per (data-ora, lato) basta?
- **Si', per identificare lo stesso ingresso** [MISURATO]: sui comuni prezzo d'ingresso, volume e S/L
  iniziale coincidono nel 100% dei casi in tutte le coppie; nessuna chiave duplicata; spostando di un
  minuto o invertendo il lato i comuni crollano a 0-3; la gemella e la TOFF danno identita' al secondo.
- **Ma comune non vuol dire "stessa storia"**: la posizione comune puo' uscire a un orario diverso, ed
  e' proprio l'effetto d'uscita. Stessa ora d'uscita / uscita diversa sui comuni [MISURATO]:
  K15-KOFF 127 / 730; REPL-BEOFF 604 / 276; BE05 616 / 311; BE15 734 / 161; ATRFIX 428 / 471; TOFF
  924 / 8; K15 138 / 793; K35 328 / 540; KOFF 324 / 527.
- Stessa ora d'uscita ma netto diverso (non zero in BEOFF 194,54, ATRFIX 1.567, K15 1.201, K35/KOFF
  756, K15-KOFF 768; zero in BE05, BE15, TOFF, gemella): SL a livelli diversi colpiti nello stesso
  secondo [INFERITO: non ho letto i tick].
- **Che cosa il matching NON separa** [INFERITO]: i comuni sono gli ingressi in cui **entrambe** le celle
  erano flat; non sono un campione casuale degli ingressi. L'effetto dell'uscita B sugli ingressi che
  solo A prende (e viceversa) non e' osservabile da questi deal: la scomposizione e' "uscita sui comuni
  + selezione indotta dall'uscita", e la selezione e' **causata** dall'uscita (non e' rumore esterno).

## Limiti e cosa NON ho verificato
- In campione, 2026 T1-T3, 168 giorni, un solo simbolo (XAUUSD M1, tick reali). Nessuna prova fuori
  campione o di regime.
- Bootstrap per giorno: ignora la dipendenza fra giorni vicini; 8 confronti sulla stessa REPL non sono
  indipendenti ne' corretti per molteplicita' (salvo la nota su BE05).
- Il PF di un sottoinsieme e' dominato da poche operazioni: solo-KOFF (K15 -> KOFF) e' in pratica **una**
  operazione da +7.798.
- NON verificato: la ragione EA-interna dei 118-119 "chiusure a mercato" di KOFF (inferisco uscita a
  tempo dal commento vuoto, come gli 8 casi REPL/TOFF, ma non ho letto il giornale dell'EA); se l'EA ha
  altri stati (contatori giornalieri, cooldown) che dipendono dalla storia; i livelli di SL successivi
  (trailing/BE) -- solo lo S/L iniziale.
- Lo strumento non e' passato dal cancello: questi numeri sono **[MISURATO] da uno strumento in bozza**,
  con le identita' e i totali sopra come uniche garanzie.

## Riproduzione
```
python3 -I backtest_pipeline/gba_ingressi_comuni.py --autotest
A=backtest_pipeline/risultati_archivio
python3 -I backtest_pipeline/gba_ingressi_comuni.py $A/GBA_R0_R1A_20261010/GBA_R0_R1A.zip \
  $A/GBA_R2_USCITA_20261011/GBA_R0_R2UBE.zip $A/GBA_R2_USCITA_20261011/GBA_R0_R2UATRFIX.zip \
  $A/GBA_R2_USCITA_20261011/GBA_R0_R2UTEMPO.zip $A/GBA_R2_USCITA_20261011/GBA_R0_R2UKTRAIL.zip
```
Tempo ~13 s. Il primo zip e' l'ancora (REPL).

## ERRATA (11/10/2026, ottavo cancello sul pacchetto Gemini delle uscite; il testo sopra NON e' riscritto)
L'attribuzione della pendenza K15 -> KOFF (+0,052) e' sbagliata nella sez. (1), «Lettura» (che la attribuiva alla selezione e non all'uscita): viene in gran parte da posizioni aperte durante la pausa. Rifatto dal correttore sui report e sui giornali di `GBA_R0_R2UKTRAIL.zip`: KOFF ha **6 posizioni aperte durante la pausa giornaliera dei prezzi** (buco letto nei giornali: 23:00-00:05 server fino all'08/03/2026, 22:00-23:00 dal 09/03), tutte in T3, netto **+19.491,52**; 5 hanno la chiusura a tempo rifiutata per mercato chiuso (giornale) ed escono alla riapertura delle 00:05, la sesta entra alle 21:23 del 24/03 ed esce alle 23:21. Una e' l'operazione solo-KOFF da +7.797,59 (28/01 21:26 -> 29/01 00:05). K15 ne ha 1 (+647,56). Il netto KOFF - K15 (+20.854) viene per il 90% da queste posizioni. Tolte in entrambe le celle: pendenza di cella **-0,003** (non +0,052); sugli **852 comuni** rimasti l'uscita K15 -> KOFF da' PF_V 0,8847 -> 0,8436, **-0,041**, bootstrap per giorno sd 0,13, P(<=0) 0,64. Il dossier `report/GBA_PROPOSTA_MARKET_REGIME_2026-10-10.md` (sez. 0 punto 3) chiamava le posizioni attraverso la pausa "un'estrazione, non un edge". Classe 1314 della checklist.

## ERRATA (11/10/2026, nono cancello; RITIRA un'attribuzione dell'ERRATA precedente, il testo sopra NON e' riscritto)
Ritirata l'attribuzione delle posizioni aperte durante la pausa a "un effetto d'esecuzione attorno alla pausa" e la frase "la pendenza viene in gran parte da posizioni aperte durante la pausa" come spiegazione causale. Restano i FATTI, ricontrollati dal correttore sui report: 6 posizioni in KOFF (+19.491,52, tutte in T3), 1 in K15 (+647,56); sugli altri 5 ingressi K15 chiude dopo 1-7 minuti con +2.613,55, KOFF +11.693,93; posizioni cosi' in tutte e 9 le celle (1-6, tutte in T3). I due numeri sui comuni: con queste posizioni dentro 857 comuni, -0,018 (sd 0,127); togliendole 852 comuni, -0,041 (sd 0,13). Pendenza di cella senza di loro: -0,003 se ogni posizione e' tolta dalla sua cella, +0,005 se gli stessi 7 ingressi sono tolti da entrambe. **Attribuzione della differenza: [NON ATTRIBUITA]**: arrivare aperte alla pausa dipende dalla leva (KOFF tiene piu' a lungo), quindi togliere quel gruppo e' una selezione su una conseguenza del trattamento; la parte dovuta alla pausa e' stimata dal nono cancello in 0-4.000 su 19.491,52 (prezzi close dei giornali all'uscita prevista, bid, senza swap e commissioni; stima non rifatta dal correttore). Classe 1315.

## ERRATA (11/10/2026, verifica delle risposte di Gemini, `docs/RISPOSTA_A_GEMINI_USCITE_BREAKOUT_ORO_2026-10-11.md`; il testo sopra NON e' riscritto)
Nei comuni c'e' **una** posizione, 29/01 15:48 sell, che sposta tre letture: K15 -1.288,65 (SL dopo 73 s) contro KOFF +30.700,83 (uscita a tempo alle 16:36). Senza di lei: K15 -> KOFF da **-0,018 a -0,111**; REPL -> K35 da **+0,064 a +0,012**; REPL -> KOFF da **+0,039 a -0,045**. Quindi la frase della sez. «Che cosa dice» su K35 («e' la cella dove l'uscita fa la differenza») poggia per **~80% del delta** (+0,052 su +0,064) su **quella sola operazione**: va letta come non separabile da zero, non come una cella dove l'uscita lavora. La conclusione generale «l'uscita non migliora il PF oltre il rumore sui comuni» regge (senza quella posizione KOFF va peggio, non meglio). Niente pulizia degli outlier: il leave-one-out si riporta accanto al numero (misura M2 della risposta a Gemini). Misura fatta dalla verifica delle risposte di Gemini con uno strumento in bozza non passato dal cancello (`backtest_pipeline/gba_verifica_gemini_uscite.py`), quindi [MISURATO in bozza], da ricontrollare se si usa il numero in un verdetto.
