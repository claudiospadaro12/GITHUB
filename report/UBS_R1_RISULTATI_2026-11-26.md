# UBS replica R1: risultati (26/11/2026) — criteri: `UBS_REPLICA_CRITERI_2026-11-25.md`

**Condizioni:** 98 set non oro, EA V9.5, BCM, 01/01/2020-01/11/2026, Modello 1 (1 minuto OHLC), deposito 100.000 EUR, Risk=0, StartLots=0,1, ForceSymbol. 98/98 report letti; 67 risultati distinti (i set copia danno lo stesso numero). Dati per set: `UBS_NOTTE/RISULTATI_R1_2026-11-26.csv`.

## Esito sui 43 con PF dichiarato nell'Excel (criteri applicati come scritti)
- CONFERMATO 32 (74%), PARZIALE 8, NON CONFERMATO 3 (EURJPY J003, USDCAD J023, XAGUSD H4 J043).
- Mediana PF nostro / PF Excel = **1,25** (28 su 43 sopra 1). Correlazione di rango = **0,22**.
- **La previsione scritta prima era sbagliata:** mediana 0,7, correlazione 0,4-0,6, confermati 25-40%. Il risultato e' nella direzione opposta: i nostri numeri sono PIU' ALTI di quelli dichiarati, e poco correlati.

## Perche' NON si legge come "set confermati" (cause da verificare, non misurate)
1. **Costi.** Le famiglie H1/H4 ad alta frequenza (J013-16, J021, J038, J040: 1.000-1.700 operazioni, guadagno medio 1-2 pip a 0,1 lotti) hanno stesso numero di operazioni dell'Excel ma PF 1,9-2,9 contro 1,1-1,2. Compatibile con costi (spread, commissione) non modellati allo stesso modo nel nostro Modello 1 su BCM. NON MISURATO: serve un rerun a tick reali (BCM dal 10/07/2024).
2. **Lotto non fisso.** `StartLots=0,1` non vale per tutti: nei report USDJPY (hangsan/Telegram) gli ordini sono da 3,67 lotti, sull'argento 1,79: il set impone altro sizing. PF poco toccato, ma netto e DD non confrontabili fra set.
3. **Modello 1:** "qualita 99%" e' un artefatto del tester a barre da 1 minuto, non una misura di fedelta.
4. Parametri V9.8 ignorati dalla V9.5 (alcuni set); periodo identico all'Excel solo sulla carta.
5. **Argento D1/H4:** 6-20 operazioni nostre contro 127-156 dichiarate: non confrontabili (non confermati per il criterio sulle operazioni).
6. Duplicati dell'inventario (stesso risultato per nomi diversi) gonfiano i conteggi: 14 USDJPY D1 "confermati" sono in parte copie.

## Senza PF dichiarato (55): 39 con PF >= 1,2 e >= 30 operazioni. Non c'e' riferimento: informativo.
PF < 1: solo J023 (USDCAD), J043/J097/J098 (stesso set argento H4, 6 operazioni).

## Cosa NON si puo' dire
Nessun set e' "buono" da questa prova. Tutto e' sul periodo in cui l'autore ha scelto i set (in campione per lui), con costi non verificati. I criteri prevedono R2 (2013-2019, fuori campione) per CONFERMATO/PARZIALE: non lanciata. Proposta prima di R2: rerun a tick reali (2024-07..2026-11) di un campione per misurare quanto il Modello 1 gonfia il PF.
