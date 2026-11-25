# Post News V2: orario ancorato all'inizio della conferenza (criteri scritti PRIMA dei numeri, 25/11/2026)

**Motivo:** V1 ha 0 candidate (`POSTNEWS_RISULTATI_2026-11-25.md`). I preset dell'EA agiscono alle 16:00 IT per la BCE, cioe' 75-90 minuti DOPO l'inizio della conferenza, quando il range medio e' gia' sceso (EURUSD: circa 39 pip nel blocco dell'evento, circa 21 a +90 min). Il corso parla di "candela della conferenza stampa". L'orario esatto non e' noto (lezione 10 non nel repo): lo si prova come famiglia, non come scelta.

## Famiglia (tutto il resto identico a V1: range 2 candele M5, +-3 pip, SL 25, TP 50, OCO, slippage 0,5, trailing solo BCE, stesse regole di costo)
- Azione = ora evento del calendario + **D minuti**, D in {10, 25, 40, 70, 100}. Il range sono le 2 candele M5 che precedono l'azione. Scadenza = azione + 195 min (BCE) / + 65 min (FOMC). D=100 e' circa il V1 BCE; D=10 e' il preset FOMC.
- Celle: tipo (BCE, FOMC) x coppia (EURUSD, GBPUSD, USDJPY, EURJPY) x 5 orari = **40 celle**, tutte riportate. Stessi periodi e soglie di V1 (BCE IS 2013-20 PF>=1,3 n>=50; OOS 2021-24 PF>1,2 n>=25; FOMC IS 2016-21 n>=30, OOS 2022-24 n>=20; hold-out 2025-26 PF>1,0).
- **Hold-out non vergine** (il 2025-26 e' gia' stato visto in V1): quindi la candidata V2 richiede un PLATEAU, non una cella: nella stessa coppia e stesso tipo **almeno 3 orari consecutivi** che passano IS+OOS+HO. Una cella isolata resta "non candidata" (con 40 celle un passaggio isolato e' atteso per caso).
- Misure descrittive (non selettive): quando arriva il range maggiore dopo l'evento; correlazione fra mossa evento->azione e mossa azione->scadenza per periodo.

## Previsione (scritta ora)
Nessuna candidata V2. Orari piu' precoci aumentano range e spread/slippage reale (M1 li sottostima), quindi PF a D=10 non migliore di V1. Il segnale BCE di V1 (EURUSD 2013-20) e' instabile: correlazione 0,22 nel 2013-20, 0,01 nel 2021-26.
