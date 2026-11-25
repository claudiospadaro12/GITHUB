| cella | periodo | eventi | operazioni | PF | % vincenti | pip medi/op. | pip/anno | % anno a 3%/50pip |
|---|---|---|---|---|---|---|---|---|
| BCE EURJPY (con trailing, PRIMARIA) | IS 2013-2020 | 72 | 103 | 1.82 | 47 | 10.3 | 133 | 8.0 |
| BCE EURJPY (con trailing, PRIMARIA) | OOS 2021-2024 | 32 | 51 | 1.31 | 39 | 4.6 | 59 | 3.5 |
| BCE EURJPY (con trailing, PRIMARIA) | HO 2025-2026 | 16 | 25 | 0.70 | 24 | -5.2 | -65 | -3.9 |
  (BCE EURJPY (con trailing, PRIMARIA): eventi 120, senza dati 0, eventi con entrambi gli ordini scattati 59)
| FOMC EURUSD (PRIMARIA) | IS 2016-2021 | 36 | 38 | 0.93 | 34 | -1.1 | -7 | -0.4 |
| FOMC EURUSD (PRIMARIA) | OOS 2022-2024 | 24 | 23 | 1.22 | 39 | 3.5 | 27 | 1.6 |
| FOMC EURUSD (PRIMARIA) | HO 2025-2026 | 15 | 16 | 1.90 | 50 | 11.7 | 94 | 5.6 |
  (FOMC EURUSD (PRIMARIA): eventi 75, senza dati 0, eventi con entrambi gli ordini scattati 8)
| BCE EURJPY senza trailing (sensibilita) | IS 2013-2020 | 72 | 103 | 1.72 | 48 | 9.8 | 126 | 7.6 |
| BCE EURJPY senza trailing (sensibilita) | OOS 2021-2024 | 32 | 51 | 1.23 | 39 | 3.6 | 46 | 2.8 |
| BCE EURJPY senza trailing (sensibilita) | HO 2025-2026 | 16 | 25 | 0.77 | 28 | -4.2 | -52 | -3.1 |
  (BCE EURJPY senza trailing (sensibilita): eventi 120, senza dati 0, eventi con entrambi gli ordini scattati 59)

VERDETTO (soglie dei criteri V3):
- BCE EURJPY (con trailing, PRIMARIA): IS 1.82 (n=103), OOS 1.31 (n=51), HO 0.70 (n=25) -> non passa
- FOMC EURUSD (PRIMARIA): IS 0.93 (n=38), OOS 1.22 (n=23), HO 1.90 (n=16) -> non passa
- BCE EURJPY senza trailing (sensibilita): IS 1.72 (n=103), OOS 1.23 (n=51), HO 0.77 (n=25) -> non passa

## Pip per anno (BCE EURJPY con trailing + FOMC EURUSD, a 3% di rischio ogni 50 pip)
| anno | BCE | FOMC | totale pip | % anno |
|---|---|---|---|---|
| 2013 | 291 | - | 291 | 17,5 |
| 2014 | 336 | - | 336 | 20,1 |
| 2015 | 115 | - | 115 | 6,9 |
| 2016 | 76 | -29 | 47 | 2,8 |
| 2017 | 76 | 47 | 123 | 7,4 |
| 2018 | 213 | 21 | 234 | 14,0 |
| 2019 | 162 | -18 | 144 | 8,7 |
| 2020 | -206 | -34 | -240 | -14,4 |
| 2021 | 50 | -31 | 18 | 1,1 |
| 2022 | 187 | 94 | 281 | 16,9 |
| 2023 | 0 | 44 | 44 | 2,7 |
| 2024 | -2 | -57 | -60 | -3,6 |
| 2025 | -91 | 143 | 52 | 3,1 |
| 2026 | -38 | 44 | 6 | 0,4 |

## Lettura (25/11/2026)
**Esito V3 fedele: 0 candidate.** BCE EURJPY: IS 1,82 (103 op.) e OOS 1,31 (51 op.) passano, hold-out 2025-26 **0,70** (25 op.) fallisce. FOMC EURUSD: IS 0,93 (38 op.) fallisce; OOS 1,22 e HO 1,90 sono positivi ma con 23 e 16 operazioni.
- **Il dichiarato del corso e' in parte riprodotto:** la BCE 2013-2020 rende circa 133 pip/anno (corso: circa 190 pip/anno su 15,5 anni) e l'IS passa. La previsione "IS passa, HO fallisce" e' confermata.
- **Ma il guadagno e' concentrato nel 2013-2015:** 742 pip su 1.165 totali della BCE (64%) vengono da quei 3 anni. Dal 2016 al 2026: BCE PF 1,21 (133 op., t 1,0), FOMC PF 1,19 (77 op., t 0,7), nessuno dei due statisticamente distinguibile da zero. Totale 2016-2026 circa 649 pip = circa +3,5% annuo a rischio 3%, contro il +20% dichiarato.
- Il 2020 e' -240 pip (-14%): il corso salta il 2021, a noi il peggior anno e' il 2020.
- Il trailing non cambia il verdetto (senza trailing: IS 1,72 / OOS 1,23 / HO 0,77).
- Limiti: M1 BCM (bid), nessun tick/spread reale post-notizia, FOMC 2013-2015 non nel calendario, hold-out gia' visto in V1/V2, solo 2 celle ma campione piccolo. Orari BCE (14:30 poi 14:45) presi dal calendario.
- **Conclusione:** Post News FEDELE CHIUSO senza candidata. Esiste un vantaggio storico della BCE su EURJPY (anni di tassi e yen), ma non e' dimostrato dopo il 2016 e non supera l'hold-out. Non e' un EA da flotta prop. Resta una strategia da diario/allenamento a bassa frequenza (16 operazioni all'anno), senza promessa di profitto.
