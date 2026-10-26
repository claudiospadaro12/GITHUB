# DD giornaliero FTMO con l'EQUITA (flottante compreso): criteri scritti PRIMA dei numeri (26/10/2026)
**Natura: CRITERI. Non controllata da agenti.** Richiesta di Claudio (26/10): "si, fallo con l'equity". Segue `GIORNI_DD_GIORNALIERO_PROP_*_2026-10-26.md` (solo realizzato). Nessuna scelta di EA, lotto o acquisto e mia.

## Il problema e come lo risolvo
I report del tester contengono le operazioni **chiuse** con prezzo e ora; l'equita intraday no. La ricostruisco: per ogni posizione aperta in un minuto, flottante = segno x (prezzo - prezzo d'ingresso) x volume x 100 once x cambio USD->EUR, con il prezzo dalle **barre M1 dell'oro BCM** (esportate dal terminale con `ABTG_ExportM1.mq5`, 01/01/2025-01/10/2026, ora del server) e il saldo realizzato dalle operazioni chiuse. Pezzi dichiarati:
- **Cambio USD->EUR:** ricavato dalle stesse operazioni (profitto in EUR / profitto in USD implicito), vicino nel tempo; deve cadere fra 0,78 e 1,00 (plausibile per EUR/USD 1,0-1,28): se la mediana esce da li, il contratto non e 100 once e la corsa e NON ATTENDIBILE.
- **Accoppiamento ingressi/uscite:** esatto per le corse con **una sola posizione alla volta** (Rocket, Entry Points, ORB Revolution, Umbra, Microedge, Gold Snap, Prop Firm Gold EA, Smart Gold Hunter). **STIMA** per Vortex (fino a 4 posizioni), SixtyNine (7), SomaGold (31): accoppiamento per direzione e volume, a parita il piu vicino per profitto implicito. Le uscite non accoppiabili si contano e si dichiarano.
- **Due ricostruzioni:** **centrale** (flottante al prezzo di chiusura di ogni barra M1) e **pessimistica** (flottante al minimo della barra per le posizioni long e al massimo per le short: un limite alto, perche dentro la stessa barra low e high non possono valere insieme).
- Costi: commissione e swap sono gia nelle operazioni; il flottante non include lo swap non ancora addebitato.

## Definizioni
Giorno FTMO = mezzanotte CE(S)T (server BCM UTC+1: in estate +1 ora). Perdita del giorno = (base - equita minima del giorno) / base. **Base principale: saldo a inizio giorno** (conservativa, comprende il flottante che arriva dal giorno prima); **base secondaria: equita alla mezzanotte** (piu vicina a come FTMO sembra misurare; NON VERIFICATO dal regolamento). Soglie 3%, 4%, 5%; per le corse a 80.000 EUR anche 4.000 EUR fissi (5% del capitale iniziale). Le corse sono quelle gia archiviate a 80.000 EUR (le stesse di `GIORNI_DD_GIORNALIERO_PROP`): 8 EA del 25/10, SomaGold, Microedge e Umbra con guardia del venditore, Prop Firm Gold EA e Smart Gold Hunter; Arena a parte (3 mesi).
Lettore `backtest_pipeline/leggi_equita_prop.py`, congelato prima dei dati completi, con `--autotest` (test sintetico + plausibilita del cambio sulle corse reali). Prima del CSV completo, **anteprima di verifica del metodo** sulle barre M1 gia in repo (luglio-settembre 2026): vale come collaudo, non come risultato.

## Previsioni dichiarate ORA
- E1: per ogni EA il numero di giorni >= 5% con l'equita e **maggiore o uguale** a quello del solo realizzato: 99% (e un vincolo, non una scommessa).
- E2: almeno 3 EA con giorni >= 5% in equita (centrale) dove il realizzato ne aveva zero: 65%.
- E3: Gold Snap, SixtyNine e SomaGold hanno almeno 3 giorni >= 5% in equita (centrale): 55%.
- E4: Smart Gold Hunter, Prop Firm Gold EA e Entry Points restano a zero giorni >= 5% anche in equita: 75%.
- E5: la mediana del cambio USD->EUR sta fra 0,78 e 1,00 per tutte le corse: 90%.
