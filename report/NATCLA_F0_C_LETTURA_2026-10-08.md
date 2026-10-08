# NATCLA F0 - lotto C (oro + 10 indici) - 08/10/2026 14:55-15:50

Fonte: `backtest_pipeline/risultati_archivio/NATCLA_F0_C_20261008/` (PC di backtest DESKTOP-H4D7CAJ, BCM demo 50503392, pin d6586360, EA v1.05, compilazione 0/0, 55 minuti, media 32 s a passata). Lettore `leggi_natcla_f0.py`. Modello 1 OHLC M1, InpSoloConta: **nessun PF, nessun DD, nessun merito**.

## Esito
- **66 passate: 65 OK, 1 KO, 0 non lanciate.** VERIFICA ADX **MetaQuotes su tutte le 65**. AVVIO v1.05 x 65.
- **KO: E35EUR AUDIO_D1**, timeout di 20 minuti (1215 s contro 28-58 s delle altre). L'EA e' partito (AVVIO e VERIFICA ADX alla barra 2025-11-28, 690 righe IMBUTO), il CSV ha solo 9 righe CONTA. **Causa NON MISURATA** (ipotesi non provata: il tester si e' piantato sull'unico simbolo con storia D1 piu' corta). 1 passata su 66: non blocca la lettura, ma E35EUR D1 non e' misurato.
- **Determinismo**: XAUUSD AUDIO_H1 e M2_H1 con v1.04 (pilota) e v1.05 (lotto C): CSV **identici** (senza la riga #AVVIO). La v1.05 non cambia niente dove la v1.04 funzionava.
- Incoerenze interne dei CSV: 0 righe fuori tolleranza.

## Setup per famiglia (n = setup; soglia E3 = 300)
| famiglia | simboli letti | setup | E3 |
|---|---:|---:|---|
| AUDIO_H1 | 11 | 3.775 | SOPRA |
| AUDIO_H4 | 11 | 934 | SOPRA |
| AUDIO_H12 | 11 | 262 | SOTTO (merito sospeso per n) |
| AUDIO_D1 | 10 | 81 | SOTTO (merito sospeso per n) |
| M2_H1 | 11 | 2.672 | SOPRA |
| M2_H4 | 11 | 616 | SOPRA |
Tutti gli 11 simboli sono "vivi" su AUDIO_H1 (>= 70 setup nella finestra).

## Costo (stop >= 40 x pedaggio, geometria AUDIO letterale)
**Solo XAUUSD passa il lavoro, su tutte le configurazioni. Tutti i 10 indici sono ESCLUSI PER COSTO.** Con la regola di stop di Claudio (20 u oltre la linea) i rapporti, dai pedaggi del tester (spread D30EUR 1,7, U30USD 2,0), restano ~10-12x sugli indici e ~80x sull'oro (calcolo della specifica 5.3): l'esclusione per costo degli indici NON dipende dal tipo di stop scelto fra quelli noti.

## Regime
Un solo regime (rialzo; proxy prezzo della linea: E35EUR +66%, indici +22-27%): NON MISURATO come regime.

## NON misurato / limiti
- Nessun PF, DD, merito. H12 e D1: campione sotto la soglia.
- Il timeout di E35EUR D1.
- Forex: il lotto A e' ancora da ricevere.
