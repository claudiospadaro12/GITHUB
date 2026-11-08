# Giro B forex: tick reali contro barre da 1 minuto, 2025 (08/11/2026)

Criteri e previsioni B1-B8 scritti PRIMA: `CRITERI_FOREX_GIRI_B_C_2026-11-07.md`. Dati: `ANNO4K_WIM_FOREX_TICK_20261108_2241.zip`, manifest in `FOREX_OOS_dati/tick_manifest/`. Riferimenti a barre (Modello 1): `FOREX_4K_dati/forex4k_res.json` (giro 4k del 05/11). Deposito 4.000 EUR, terminale BCM, solo tester, finestra 2025.01.01-2026.01.01, set invariati.

## Validita
- **4 passate su 4 valide**: stato OK, qualita **100% tick reali** (24.112.414 tick), inizio dei tick EURUSD 2024.07.05 prima della finestra, deposito 4.000, input confermati dal report (`si` per Luna e Apex, `nessuno_imposto` per Daytrade Pro e Stability), 0 stop out, 0 "no money".
- La prima passata di Daytrade Pro del giro precedente era KO (report non scritto, PC spento per batteria alle 18:35): **non era un problema sistematico dei tick**. Rifatta, finisce in 9.093 s (circa 2,5 ore), OK.
- Durate: Stability 17 min, Apex 35 min, Luna 13 min, Daytrade Pro 2,5 ore.

## Confronto
| Set | Netto barre -> tick | Variazione | DD equity barre -> tick | Operazioni barre -> tick | PF barre -> tick | Giorno peggiore barre -> tick (EUR) | Esito |
|---|---|---|---|---|---|---|---|
| Stability Pro low | 562 -> **482** | -14% | 18,6% -> 17,4% | 458 -> 425 | 1,86 -> 1,72 | -11 -> -18 | **ROBUSTO** |
| Apex Conservative | 913 -> **836** | -8% | 22,5% -> 21,7% | 1.778 -> 1.678 | 2,30 -> 2,17 | -9,1 -> -9,1 | **ROBUSTO** |
| Luna 4DD | 1.130 -> **197** | **-83%** | 2,1% -> 3,4% | 790 -> **434** (-45%) | 2,96 -> 1,39 | -49 -> -57 | **SENSIBILE** |
| Daytrade Pro Max9 | 131 -> **70** | **-46%** | 5,9% -> 6,5% | 415 -> 416 | 1,13 -> 1,07 | -87 -> -87 | **SENSIBILE** (base minuscola) |

Regola scritta: ROBUSTO se netto entro +-30%, DD entro +-5 punti, stesso segno; SENSIBILE oltre; ROVESCIATO se il segno cambia o DD > 50% o stop out. **Nessun set ROVESCIATO**: tutti restano in guadagno, nessuno oltre il 22,5% di DD.

## Previsioni B1-B8 contro i risultati
| # | Previsione | Esito |
|---|---|---|
| B1 | DTP Max9 ROBUSTO: 75%; netto cambia oltre 30%: 40% | ROBUSTO **falso**; netto oltre 30% **vero** (-46%, ma su 131 EUR: la differenza e 61 EUR) |
| B2 | Luna netto piu basso: 80%; SENSIBILE: 65%; ROVESCIATO: 15% | **vero, vero, falso** (-83%, ma ancora positivo) |
| B3 | Apex DD a tick >= barre: 65%; SENSIBILE: 60%; ROVESCIATO: 15% | **falso, falso, falso** (DD 21,7% contro 22,5%) |
| B4 | Stability SENSIBILE: 55%; ROVESCIATO: 15% | **falso, falso** |
| B5 | Almeno un set SENSIBILE o ROVESCIATO: 85%; tutti robusti: 5% | **vero** (Luna e Daytrade Pro) |
| B6 | Netto a tick piu basso in almeno 2 dei 3 set non D1: 75% | **vero** (3 su 3) |
| B7 | Almeno una passata esclusa per tick mancanti o qualita < 95%: 35% | **falso** |
| B8 | Operazioni cambiano oltre 10% in almeno uno: 70% | **vero** (Luna -45%) |

## Letture
- **Luna 4DD e la sorpresa**: a tick fa meno della meta delle operazioni (434 contro 790) e il netto scende da 1.130 a 197 EUR (PF da 2,96 a 1,39). Una Luna "a barre" e ottimista. Non so perche (ordini limit, spread, riempimenti): **NON VERIFICATO**. Resta positiva e con DD basso (3,4%).
- **Apex e Stability reggono**: -8% e -14% di netto, DD invariato.
- **Daytrade Pro Max9** passa da +131 a +70: il 2025 e il suo anno peggiore, il margine e piccolo in entrambe le modalita.
- **Limite grosso**: i tick reali del BCM partono dal 10/07/2024, quindi vale **un solo anno** (2025). Non si puo estendere ai 12 anni del giro A: per Luna i 12 anni a barre restano da leggere con una correzione verso il basso non quantificabile.

## Effetto sul cancello (voci `CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md`)
- **F-B fatto.** Per gli EA forex: Stability low e Apex Conservative "tenuta ai tick: ROBUSTO"; Luna 4DD "SENSIBILE ai tick: limite dichiarato"; Daytrade Pro Max9 "SENSIBILE ma su una base minuscola".
- Luna 4DD e Daytrade Pro Max9 non ricevono "TESTATO BENE" senza limiti; la riga finale dira "TESTATO CON QUESTI LIMITI".
- Nelle combo prop il Daytrade Pro pesa meno nel 2025 di quanto dicano i test a barre: l'impatto sul totale non e calcolato.
