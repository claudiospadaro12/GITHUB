# Quanto costerebbe chiudere le posizioni oro prima della pausa giornaliera (10/11/2026)

**Natura: STIMA da report gia raccolti, senza passate nuove.** Nasce dall'idea di non tenere posizioni attraverso la pausa dell'oro (BCM 23:00-24:00 ora server; probabilmente 00:00-01:00 su FTMO, NON VERIFICATO) per evitare le richieste di modifica respinte che gonfiano il conteggio (`RICHIESTE_AL_SERVER_STIMA_DAI_TEST_2026-11-10.md`). Script `ORO_GRADINI_dati/pausa_giornaliera_oro.py`, dati `pausa_giornaliera_oro.json`. 80k, anni 2013/2018/2020/2025, Modello 1, un percorso per anno (Reaper e Phantom: Randomization 50, rumore).

## Metodo
Per ogni posizione oro dei report (apertura e chiusura dai deal) si guarda se e **aperta alle 22:55** ora server BCM; se si, si calcola quanto avrebbe ancora guadagnato o perso da quel momento: profitto finale lordo meno il profitto virtuale alle 22:55 (prezzo di chiusura della barra M1, cambio medio dell'anno). Quella differenza e **cio a cui si rinuncerebbe chiudendo alle 22:55**. Non include le riaperture dopo la pausa (gli EA rimetterebbero i pendenti e potrebbero rientrare), ne spread e commissioni della chiusura: e una stima diretta, non un backtest della regola.

## Risultato (somma dei 4 anni, 80k)
| EA, livello | Posizioni | Aperte alle 22:55 | Netto 4 anni | Rinuncia stimata chiudendo alle 22:55 (% del netto) | Per anno 2013 / 2018 / 2020 / 2025 |
|---|---|---|---|---|---|
| Reaper L0 Prop | 2,501 | 418 (17%) | 98,315 | 20,993 (**21%**) | -9% / 35% / 54% / 14% |
| Reaper L3 Combo | 2,506 | 446 (18%) | 24,750 | 5,484 (**22%**) | -38% / 52% / 49% / 17% |
| Phantom L0 Prop | 4,888 | 919 (19%) | 20,200 | 4,525 (**22%**) | -15% / 58% / 48% / 22% |
| Phantom L1 Gradino 1 | 4,858 | 891 (18%) | 48,215 | 11,585 (**24%**) | -22% / 59% / 47% / 25% |
| Phantom L3 Combo | 4,834 | 946 (20%) | 21,346 | 5,107 (**24%**) | -14% / 54% / 52% / 23% |
| Goldbot L0 Prop | 1,082 | 279 (26%) | 43,991 | 11,377 (**26%**) | 1% / 59% / 38% / 43% |
| Goldbot L3 Combo | 1,082 | 279 (26%) | 34,365 | 8,887 (**26%**) | 1% / 59% / 38% / 43% |
| Gold Trade Pro Combo | 1,219 | 246 (20%) | 38,818 | 3,580 (**9%**) | -3% / 1% / 27% / 25% |

## Letture
- **Il 17-26% delle posizioni e aperto alle 22:55**: la pausa giornaliera interessa una posizione su 4-6; i giornalieri (Goldbot) il 26%.
- **Chiudere prima della pausa costerebbe circa il 21-26% del netto** per Reaper, Phantom e Goldbot, **9% per il Gold Trade Pro** (che resta in posizione meno nelle notti utili). **Molto piu della chiusura del venerdi (7-12%)**, perche capita ogni notte.
- **Dipende dall'anno**: nel 2013 (oro in calo) la chiusura avrebbe **migliorato** il risultato (rinuncia negativa: da -3% a -38% per quasi tutti); nel 2018 e 2020 il costo e il 35-59%; nel 2025 il 14-43%. E la stessa asimmetria vista sul weekend: le posizioni tenute di notte guadagnano nei trend e perdono nelle inversioni.
- **E un massimo realistico?** E probabilmente un **limite superiore** del costo, perche gli EA rientrerebbero dopo la pausa; ma gli ingressi dopo la pausa sono su prezzi diversi, quindi NON si puo dire di quanto. Il costo reale va misurato con un test, non stimato.

## Limiti
Un percorso per anno (Reaper e Phantom Randomization 50), barre da 1 minuto (prezzo di chiusura della barra delle 22:55), cambio medio annuo, 2018 ipotesi di cambio, nessun costo di spread/commissione della chiusura e della riapertura, riaperture non simulate, orario di pausa FTMO NON verificato. Non dimostra che la pausa sia la causa delle richieste (serve il conteggio dal VPS). Nessun giudizio su lotti, taglie o su quale soluzione scegliere.
