# Gold Reaper: come si comportano le 7 strategie (osservato nei report del tester; 18/11/2026)

**Natura:** LETTURA di report di tester gia nostri (nessun accesso al codice o al file .ex5). Fonte: `backtest_pipeline/risultati_archivio/ANNO80K_REAPER_FISSO_20261029_1000/{2019,2023}_M1_GR_FISSO_H1/report/*.htm.gz` (su `lavoro`): BCM, XAUUSD H1, Modello 1, 80.000 EUR, set con `TradeFrequency=2` (strategie 1-7; mai 8-9). Script: `REAPER_dati/reaper_comportamento.py` (`python3 -I script file.htm`). Numeri = ordini PENDENTI del Reaper raggruppati per il suffisso del commento `The Gold Reaper_XAUUSD_N`.
**Limiti:** solo ordini pendenti (non il risultato per strategia: gli esiti non sono abbinati), un solo broker (BCM, orari server BCM), due anni (2019 e 2023), nessuna conoscenza della regola con cui sceglie il livello del prezzo. La mappatura "N = strategia del manuale" e quella del suffisso.

| N | Tipo | Stop $ (med 2019) | Target $ | Target/Stop | Vita ordine mediana | % riempiti | Ore di piazzamento (server BCM) piu frequenti |
|---|---|---|---|---|---|---|---|
| 1 | stop grande, target piccolo | 42,6 | 10,1 | 0,24 | 35 h | 8% | 00, 11, 23, 10 |
| 2 | **stop stretto, target grande** | 7,0 | 28,5 | 4,1 | 154 h (~6 giorni) | 30% | 00, 16, 17 |
| 3 | **stop stretto, target grande** | 4,7 | 22,0 | 4,7 | 182 h (~7,5 giorni) | 49% | 00, 16 |
| 4 | **stop stretto, target grande** | 7,1 | 43,5 | 6,1 | 158 h (~6,6 giorni) | 39% | 00, 16, 20, 04 |
| 5 | stop grande, target piccolo | 28,5 | 4,9 | 0,17 | 30 h | 32% | 00, 06, 12, 16, 11 |
| 6 | stop molto grande, target piccolo | 59,6 | 4,7 | 0,08 | 20 h | 22% | 00, 16, 20, 12 |
| 7 | medio | 12,2 | 7,8 | 0,64 | 60 h | 35% | 00, 16, 12, 04 |

## Cosa si legge
1. **Sempre ordini stop su entrambi i lati** (buy stop e sell stop quasi pari); l'ordine opposto si cancella al riempimento.
2. **Le distanze si scalano con la volatilita:** tra 2019 e 2023 TUTTE le distanze di stop e target crescono dello stesso fattore, circa **x1,39** (es. strategia 2: stop 7,0 -> 9,7, target 28,5 -> 39,7; strategia 6: 59,6 -> 82,0). Quindi stop e target sono multipli di una misura di volatilita (tipo ATR), non punti fissi.
3. **Due famiglie opposte:** strategie 2, 3, 4 = **stop stretto e target 4-6 volte piu grande, ordini che restano 6-7 giorni** (poche vincite, grandi); strategie 1, 5, 6 = **stop molto grande e target piccolo, ordini di 20-35 ore** (molte vincite piccole, coda larga); la 7 e di mezzo.
4. **Gli ordini nascono a ore precise**, soprattutto **00:00 e 16:00 server BCM** (altre 04, 06, 11, 12, 20): non a ogni barra. Il lunedi e il venerdi sono i giorni con piu piazzamenti.
5. **Percentuale di riempimento molto diversa:** 8% (strategia 1) - 49% (strategia 3).
6. **Il confronto con i nostri disegni:** il disegno 1 usava stop e target in punti FISSI e al massimo target = 3 x stop; le strategie 2-4 del Reaper hanno stop circa 0,4-0,7 ATR e target 4-6 volte lo stop, con distanze che crescono con la volatilita. Ipotesi (NON verificata): i punti fissi invecchiano male quando la volatilita cambia (+39% tra 2019 e 2023), e target = 3 x stop non esplora la zona del Reaper.

## Cosa NON sappiamo ancora (serve per scrivere un EA simile)
- A che livello esatto mette gli ordini (distanza dal prezzo, massimo/minimo di quale periodo) e perche proprio a 00:00 e 16:00.
- Quale misura di volatilita usa e con che moltiplicatori esatti (qui solo i rapporti).
- Come gestisce break-even/trailing/modifiche dopo il riempimento (visto solo `UseHL_TrailingSL=true` negli input).
- I risultati per singola strategia (servono gli esiti abbinati agli ordini).
Per questi punti servono le **pagine del manuale** sulle strategie 1-7, oppure i **dati di prezzo** (M1/H1 esportati) per misurare dove stanno gli ordini rispetto ai massimi/minimi precedenti.


## AGGIORNAMENTO (18/11/2026): cosa dicono i 4 manuali di Profalgo (Reaper, Phantom, Gold Trade Pro, Goldbot One)
Letti i manuali PDF mandati da Claudio (documentazione pubblica per i clienti; non li ho copiati nel repository).
- **CORREZIONE a quanto scritto sopra:** le distanze NON si scalano con l'ATR ma con il **prezzo dell'oro**. Il manuale del Reaper (`UseVariableValues`) dice che "scala ogni distanza di ingresso, stop, target e trailing in proporzione al prezzo corrente dell'oro". Verifica sui report: prezzo medio degli ordini 1.388 (2019) contro 1.935 (2023): rapporto **1,394**, uguale al fattore 1,39 delle distanze. Espresse in % del prezzo (2019): S2 stop 0,50% / target 2,05%; S3 0,34% / 1,58%; S4 0,51% / 3,13%; S1 3,07% / 0,73%; S5 2,05% / 0,35%; S6 4,29% / 0,34%; S7 0,88% / 0,56%.
- **Tutti e quattro sono sistemi di breakout sui livelli di supporto/resistenza GIORNALIERI dell'oro**, con piu strategie interne (Reaper 9, Phantom 9, Gold Trade Pro 8, Goldbot One 8) ciascuna con propria regola di ingresso, uscita e trailing. Il Goldbot One lavora sul grafico **D1**, "un solo trade per strategia alla volta". Non danno la regola esatta del livello ne degli algoritmi di conferma.
- **Meccanismi dichiarati nei manuali:** stop e target fissi dall'inizio + trailing; **HL trailing** (stop dietro agli ultimi massimi/minimi); **Fake Breakout Filter** (dopo l'ingresso, se la candela su cui e entrato chiude CONTRO la posizione, la chiude subito; livelli Off/Low/Medium/High = piu timeframe controllati; default Medium); filtro NFP/tassi/CPI (chiude ordini e posizioni intorno alle news); chiusura del venerdi opzionale; spread massimo scalato col prezzo; "Strategia 1-3 basso rischio, 4-7 medio, 8-9 alto".
- **Nota informativa dal manuale del Reaper (Randomization):** il venditore scrive che far girare lo stesso EA su piu conti prop con operazioni identiche "puo essere segnalato come copy trading". Conferma che le prop guardano le operazioni dei conti, non il nome dell'EA. Non e un'indicazione di cosa fare: non costruiremo niente pensato per non farsi riconoscere.
