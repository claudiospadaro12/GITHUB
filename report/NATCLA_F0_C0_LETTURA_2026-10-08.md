# NATCLA F0 - lotto C0 (verifica del rimedio v1.05) - 08/10/2026 14:48-14:51

Fonte: `backtest_pipeline/risultati_archivio/NATCLA_F0_C0_20261008/` (PC di backtest DESKTOP-H4D7CAJ, BCM demo 50503392, pin d6586360, EA v1.05, compilazione 0 errori / 0 avvisi). Lettore `leggi_natcla_f0.py`.

## Esito: VERIFICA DEL RIMEDIO SUPERATA
Attesa scritta PRIMA: su tutte e 4 le passate AVVIO v1.05, VERIFICA ADX MetaQuotes e righe CONTA > 0; data attesa della VERIFICA 2024.10.16.
- 4 passate su 4 OK (28-35 s). AVVIO v1.05 x 4; VERIFICA ADX **MetaQuotes x 4**; finestra girata 2024.09.26-2026.06.30 su tutte.
- **VERIFICA ADX di U30USD AUDIO_H1 alla barra 2024-10-16 11:00**: la data attesa, cioe' la barra in cui la diagnosi era guarita (302 barre H1 di storia). Il tocco a 1 elemento basta: il piano B v1.06 NON serve.
- Setup (n = setup): U30USD AUDIO_H1 440 (ST25 215, ST30 181, ST35 44), M2_H1 268; D30EUR AUDIO_H1 345 (176/137/32), M2_H1 312. Riga CONTA nei CSV: 1061 / 401 / 845 / 431.
- Il pilota di ieri dava ZERO per U30USD: la causa era lo stallo del tester pigro, ora tolto.
- Incoerenze interne dei CSV: 0 righe fuori tolleranza. Spread del tester coerente con lo spread vivo (D30EUR 1,06; U30USD 1,00).

## Cosa NON e' ancora misurato
- Nessun PF, nessun DD (Modello 1 OHLC): conteggio dei setup.
- Costo con la geometria AUDIO letterale: tutti e 4 ESCLUSI PER COSTO (come previsto dalla specifica 5.3); con la nuova regola di stop (20 u oltre la linea, Claudio 08/10) il costo si ricalcola dal CSV.
- Regime: un solo (rialzo, proxy +22/+27%).
- H4/H12/D1 degli indici: non girati in C0 (partono nel lotto C).
