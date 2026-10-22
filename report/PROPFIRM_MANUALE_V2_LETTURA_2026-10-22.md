# Prop Firm Gold EA v2.5 secondo il manuale del venditore: lettura (22/10/2026)

Fonte: `PF2_PROPFIRMGOLDEA.zip` (12 passate, XAUUSD M30, OHLC 1 minuto, 80.000, input confermati dal report in tutte). Archivio `risultati_archivio/PF2_20261022`. Previsioni: `PROPFIRM_MANUALE_V2_ATTESE_2026-10-22.md`. Non controllata da agenti. Percentuali del DD = **DD di equity / 80.000** (criterio S-DD dal deposito), non quelle del MANIFEST (che sono sul picco).

**Nota sul "KO" delle T7-T12:** il MANIFEST le segna KO per la regola prudente "barre generate >= 100.000: finestra troncata dal tetto del tester" (103.009 barre M30). **Il primo affare e del 02/01/2018 e l'ultimo del 30/09/2026 [MISURATO sul report]: la finestra e INTERA**, la regola e un falso allarme. Le T7-T12 si leggono.

## Mappa dei menu: CONFERMATA
`InpRiskType=1` = rischio manuale: la perdita peggiore di una singola operazione e **-399 con lo 0,5%** (0,5% di 80.000 = 400) e **-800 con l'1,0%**; con Automatic Low e -1.197 (1,5%).

## W1 = 2025.01.01 -> 2026.10.01 (673 operazioni in tutte le celle)
| cella | netto | PF | DD equity (% di 80K) | rapporto lotti | S-DD (<=10%) |
|---|---|---|---|---|---|
| c1 Automatic Low, protezione spenta | +32.870 | 1,24 | 11.666 = **14,6%** | 2,0 | NO |
| c2 Automatic Low, protezione 4% | +37.526 | 1,27 | 10.021 = **12,5%** | | NO |
| c3 Manual 0,5%, spenta | +10.335 | 1,23 | 3.615 = **4,5%** | 2,0 | si |
| c4 Manual 0,5%, protezione 4% | +11.772 | 1,27 | 3.334 = **4,2%** | | si |
| c5 Manual 1,0%, spenta | +24.922 | 1,28 | 6.968 = **8,7%** | 1,9 | si |
| c6 Manual 1,0%, protezione 4% | +22.998 | 1,25 | 6.985 = **8,7%** | | si |
Mesi positivi 14-15 su 21 (67-71%), posizioni aperte insieme al massimo 3.

## W2 = 2018.01.01 -> 2026.10.01 (circa 3.828 operazioni)
| cella | netto | PF | DD equity (% di 80K) | rapporto lotti | S-DD |
|---|---|---|---|---|---|
| c1 | +51.002 | 1,08 | 27.634 = **34,5%** | | NO |
| c2 | +47.285 | 1,08 | 25.827 = **32,3%** | | NO |
| c3 | +14.735 | 1,07 | 9.010 = **11,3%** | 5,2 | NO (di poco) |
| c4 | +15.973 | 1,08 | 8.296 = **10,4%** | | NO (di poco) |
| c5 | +31.339 | 1,08 | 17.143 = **21,4%** | 4,8 | NO |
| c6 | +27.528 | 1,07 | 19.156 = **23,9%** | | NO |
Con la cella piu prudente (c3, 0,5%): **mesi positivi 54 su 105 = 51% (S-M richiede 60%)**; per anno: 2018 **-1.152**, 2019 **-3.953**, 2020 +4.520, 2021 **-2.151**, 2022 +204, 2023 **-950**, 2024 +6.248, 2025 +6.083, 2026 +5.887. **Cinque anni su nove sono in perdita o a zero.**

## Contro le previsioni (scritte prima)
- E1 input applicati: **CENTRATA**. E2 mappa: **CENTRATA**. E3 DD(1%) fra 1,5 e 2,5 volte DD(0,5%): **CENTRATA** (1,67 in W1, 1,86 in W2).
- E4 protezione abbassa il DD con netto >= 70% in 2 coppie su 3: **CENTRATA** (aiuta c1->c2 e c3->c4, non c5->c6, in entrambe le finestre). L'effetto e **modesto**.
- E5 riferimento (c1 W1 netto +/-25% di +34.130, DD 9,5-18%): **CENTRATA** (+32.870, 14,6%).
- E6 cicli vecchi con PF < 1,2 o DD > 10%: **CENTRATA** (PF 1,07-1,08 in tutte).
- **E7 (almeno una cella TIENE in entrambe le finestre): NESSUNA.** Previsione 35%: non e successa.
- E8 durata: W1 68 s a passata, W2 circa 18 minuti: **CENTRATA**.

## Lettura
- Negli **ultimi 21 mesi** il rischio manuale rende il Prop Firm molto piu prudente: con **0,5%** DD 4,2-4,5% di 80K e +10.335/+11.772; con **1,0%** DD 8,7% e +22.998/+24.922. **Passa S-DD.**
- **Sul periodo lungo dal 2018 l'edge e debole** (PF 1,07-1,08, mesi positivi 51%), **S-DD e S-M non passano** nemmeno con lo 0,5%, e il rapporto lotti sale a 5. I guadagni vengono da **2020 e 2024-26** (rialzi dell'oro); 2018, 2019, 2021, 2023 in perdita. Non conferma una "stabilita a lungo termine" su BCM.
- **Limite grosso:** BCM e GMT+1, il venditore vuole GMT+2/+3: puo cambiare i risultati [NON VERIFICATO].
- Nessuna taglia e nessun consiglio di acquisto: decisioni di Claudio.
