# S-CORR e S-PORT: lettura (19/10/2026)

**Non controllata da agenti.** Metodo e previsioni scritti prima: `MARKET_SCORR_SPORT_ATTESE_2026-10-19.md` (commit 581e07b5). Strumento congelato `correlazione_pacchetto.py` (autotest OK), nessuna modifica. Uscite complete in `backtest_pipeline/risultati_archivio/SCORR_SPORT_20261019/`. Serie = 21 tranche mensili da 5.000 EUR per ciascun EA (Gold Reaper = set di Claudio, GRSET), tutte conformi (21/21).

## S-CORR (soglia: r <= 0,50 per OGNI coppia)
| coppia | r | co-attivi | intervallo 95% | esito strumento |
|---|---|---|---|---|
| Prop Firm / Smart Gold Hunter | 0,045 | 184 | [-0,06; 0,15] | regge |
| Prop Firm / Gold Trade Pro | 0,103 | 159 | [-0,03; 0,25] | regge |
| Prop Firm / Goldbot One | 0,123 | 104 | [0,03; 0,22] | regge |
| Prop Firm / Gold Reaper (set) | 0,171 | 196 | [0,06; 0,27] | regge |
| Smart Gold Hunter / Gold Trade Pro | 0,045 | 80 | [-0,03; 0,13] | regge |
| Smart Gold Hunter / Goldbot One | -0,027 | 50 | [-0,10; 0,04] | regge |
| Smart Gold Hunter / Gold Reaper | 0,096 | 104 | [-0,01; 0,21] | regge |
| Gold Trade Pro / Goldbot One | 0,422 | 102 | [0,04; 0,72] | NON MISURATA (intervallo contiene 0,50) |
| **Gold Trade Pro / Gold Reaper** | **0,508** | 139 | [0,30; 0,68] | NON MISURATA (intervallo contiene 0,50) |
| Goldbot One / Gold Reaper | 0,412 | 96 | [0,26; 0,56] | NON MISURATA (intervallo contiene 0,50) |
Variante B (netto/equita'): stessi verdetti (0,423 / 0,513 / 0,413). Nel 10% dei giorni peggiori del portafoglio (47 giorni, 44 usati) le correlazioni sono basse o negative, tranne GTP/Goldbot 0,459 e SGH/GR 0,245 (campione piccolo, solo descrittivo).

**Verdetto alla regola scritta (r puntuale <= 0,50 per tutte le coppie): S-CORR SMENTITA per l'insieme di 5**, per la coppia Gold Trade Pro / Gold Reaper (0,508, di 0,008 sopra la soglia, con intervallo che contiene 0,50). **Prop Firm e Smart Gold Hunter sono scorrelati da tutti gli altri** (r <= 0,17); il blocco correlato e' Gold Trade Pro + Goldbot One + Gold Reaper (0,41-0,51).

## S-PORT (soglia: TETTO <= 10% del conto; solo pavimento <= 10% = NON MISURATA)
| portafoglio (peso 1) | pavimento | tetto | verdetto |
|---|---|---|---|
| A: Prop Firm + Smart Gold Hunter | 6,44% | **7,05%** | **PASSA** |
| B: A + Gold Trade Pro + Goldbot One | 14,86% | 21,70% | NON PASSA (anche il pavimento supera il 10%) |
| C: B + Gold Reaper (set) | 15,94% | 24,83% | NON PASSA |
Il mese che affonda B e C e' **aprile 2026** (poi maggio 2026): e' il periodo in cui Gold Trade Pro, Goldbot e Gold Reaper hanno perso insieme.
**Esplorativo, POST-HOC (non scritto prima, non e' un verdetto):** Prop Firm + Smart Gold Hunter + Gold Reaper: pavimento 4,63%, tetto 8,85%; Prop Firm + Gold Reaper: 5,28% / 8,71%; A + Goldbot: 7,67% / 11,09% (non passa); A + Gold Trade Pro: 11,63% / 17,32% (non passa); A + Goldbot + Gold Reaper: 7,77% / 13,37% (non passa).

## Previsioni
- **P8** (almeno 3 coppie su 10 con r > 0,50): **SBAGLIATA**. Una sola coppia sta sopra 0,50 (0,508); le coppie con Prop Firm e Smart Gold Hunter sono tutte sotto 0,18.
- **P9** (SGH con r <= 0,30 con tutti, ma molte coppie NON MISURATE): **meta' giusta, meta' sbagliata**. r <= 0,10 con tutti (giusto); le coppie con SGH risultano tutte "regge", non NON MISURATE (50-184 giorni co-attivi bastano).
- **P10** (tetto > 10% in B e C, tetto <= 10% in A): **CONFERMATA** (21,7% / 24,8% / 7,05%). In piu', per B e C anche il pavimento supera il 10%.

## Limiti da tenere in mente
- Corse separate sommate, non un conto solo; ogni mese riparte da 5.000, quindi il DD a cavallo di due mesi non si vede; correlazione dei realizzi (giorno di chiusura), non dell'esposizione; niente DD intraday.
- Per Prop Firm la lettura usa le tranche mensili (DD peggiore 6,6% in un mese); nella corsa continua il DD e' 8,09%: il portafoglio A potrebbe avere un tetto piu' alto del 7,05% se i DD coincidessero a cavallo di mesi.
- Periodi di Gold Trade Pro (D1) e Goldbot One (H1) non confermati dal venditore.
- Nessun EA ha ancora prove su demo dal vivo.
