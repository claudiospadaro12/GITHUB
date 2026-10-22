# Goldbot One + Gold Reaper sullo STESSO conto da 80.000 (22/10/2026)

**Nessuna riga nuova.** Il tester MT5 fa girare un solo EA per volta: le "passate gemelle" sarebbero le due gia fatte (GB4 step 3000/6000 e GR80K, stessa finestra 2025.01.01-2026.10.01, stesso deposito 80.000). Qui sono unite sulla linea del tempo dalle liste affari dei loro report. Script: `backtest_pipeline/gb_gr_insieme.py`. Nessuna soglia nuova: sono quelle gia scritte.

## Metodo e limite
Posizioni ricostruite dalle liste affari (accoppiamento in/out per direzione e volume), poi sommate. Il saldo (realizzato) e esatto. L'equity col flottante e SOLO stimabile: i report non hanno la curva, e l'unico dato intraday sono i DD di equity dei singoli test (Gold Reaper 3.854; Goldbot One 7.282 a step 3000, 3.213 a step 6000). La ricostruzione con chiusure D1 sottostima il DD di equity dei singoli (Gold Reaper 2.634 contro 3.854; Goldbot One 6.811 contro 7.282), quindi vale come limite INFERIORE. Limite SUPERIORE rigoroso: il DD della somma non supera la somma dei DD.

## Risultati (lotti dei due test sommati, nessuna riduzione)
| | GB step 3000 + GR | GB step 6000 + GR |
|---|---|---|
| netto 21 mesi | +84.953 | +70.970 |
| DD del saldo (realizzato) | 4.728 = 5,9% di 80K | 3.610 = 4,5% |
| DD equity: minimo ricostruito (chiusure D1) | 4.728 = 5,9% | 3.610 = 4,5% |
| DD equity: massimo rigoroso (somma dei DD singoli) | 11.136 = **13,9%** | 7.067 = **8,8%** |
| peggior giorno (chiusure) | -3.124 (3,9%), 23/03/2026 | -1.740 (2,2%), stesso giorno |
| correlazione giornaliera dei realizzi | 0,537 | 0,526 |
| correlazione delle variazioni giornaliere di equity | 0,678 | 0,668 |
| posizioni aperte insieme (massimo) | 17 | 17 |
| lotti aperti insieme (massimo) | 2,91 | 2,41 |

## Lettura contro i cancelli
- **S-DD (<= 10% dal deposito):** step 6000 + Gold Reaper PASSA in modo rigoroso (massimo 8,8%). Step 3000 + Gold Reaper NON e dimostrabile: fra 5,9% e 13,9%, la simultaneita intraday non e nei dati.
- **S-CORR (<= 0,5):** NON passa, ne sui realizzi (0,53) ne, peggio, sull'equity col flottante (0,67): i due soffrono insieme nelle stesse giornate (il peggior giorno e lo stesso per entrambi).
- **S-NOSCALA / S-PORT:** invariati rispetto alle letture precedenti; il portafoglio Goldbot One + Gold Reaper resta senza Prop Firm sotto il 10% di S-PORT sui realizzi.
- Posizioni aperte insieme fino a 17: sopra il tetto di 10 posizioni di S-NOSCALA, se il tetto si legge sul conto e non sul singolo EA.

## Cosa NON si puo sapere dai tester
Il DD intraday simultaneo reale dei due su un conto solo, i margini sommati (8.580 EUR a lotto nel tester contro 1.784 sul reale), e se due EA sullo stesso oro si disturbano a vicenda negli ordini. Solo un forward su demo con entrambi sullo stesso conto lo misura. Nessuna taglia proposta: la scelta e di Claudio.
