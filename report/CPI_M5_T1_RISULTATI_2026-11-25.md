# EA ABTG_CpiM5, oro BCM, test T1 (tick reali), risultato (25/11/2026)

Fonte: `testergraph.report.2026.11.25.csv` (curva saldo/equity del tester, 01/07/2024 -> 19/11/2026, deposito 100.000, lotto 0,10 = 10 oz; assunto: preset predefinito = B100, modello tick reali: **non verificabile dal solo CSV**, da confermare col report HTML). Criteri: `CPI_M5_CRITERI_2026-11-25.md`.

| Misura | Valore |
|---|---|
| Eventi con operazione | 27 (su circa 29 CPI) |
| Saldo finale | 99.959 -> **netto -41 USD** (-0,04%) |
| Vincenti / perdenti | 13 / 14 |
| Somma vincite / perdite | 1.428,5 / 1.469,5 USD -> **PF 0,97** |
| Media per evento | -1,5 USD (circa -0,15 USD/oz) |
| Estremi per evento | +655 USD (+65,5 USD/oz, luglio 2026), -382 (-38,2 USD/oz, ago-set 2026), -269 (-26,9 USD/oz) |

Esiti per evento in USD/oz: +10,1; -4,0; -4,7; -3,8; +1,2; +1,1; +0,6; -6,4; +4,8; -8,3; +1,1; +13,4; -3,7; -7,2; -12,4; +7,4; +5,5; +19,5; -7,5; +10,1; +2,6; -5,5; +65,5; -8,1; -38,2; -26,9; -10,4.

## Lettura
- **Non candidato** secondo i criteri scritti (T1 primario: profitto <= 0, PF < 1,0). La previsione "PF 0,9-2,0, probabilita' di PF >= 1,3: 35%" e' compatibile con il risultato (PF 0,97).
- La simulazione M1 della Fase 1 dava +2-4 USD/oz per evento nel 2020-26: **sui tick reali del 2024-26 resta circa -0,15 USD/oz.** Lo scarto e' esattamente quello che i criteri indicavano come rischio principale: spread allargato e prezzi di esecuzione dei primi secondi della CPI, che il M1 non vede.
- Tre eventi pesano quasi tutto (+65,5, -38,2, -26,9: somma +0,5 USD/oz). Senza di essi 24 eventi fanno circa -0,19 USD/oz: nessun vantaggio strutturale, ma un esito molto dipendente da pochi eventi estremi (campione 27).
- Non misurato: Journal con richiesto/eseguito, B50 e B200, T2 (M1 2013-2026). Non cambiano il verdetto per i criteri (T1 primario fallito) a meno di errori del test.
