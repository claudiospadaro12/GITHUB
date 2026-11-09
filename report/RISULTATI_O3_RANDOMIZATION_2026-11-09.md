# O-3: Randomization 0 contro 50 contro 60, Reaper e Phantom L0 (09/11/2026)

Criteri e previsioni scritti PRIMA: `CANCELLO_MINIMO_PRIMA_DI_UBS_2026-11-08.md`, sezione O-3. Dati: `ANNO_ORO_GRADINI_RANDOM_20261108_2351.zip` (12 passate), parser e confronto in `FOREX_OOS_dati/rnd_new.json` e `rnd_confronto.json`. Riferimento Randomization 50: le passate L0 dei 96 test del 06/11 (stessi set, stessi input; cambia solo `Randomization`). XAUUSD H1 (Reaper, Phantom), deposito 80.000 EUR, Modello 1, terminale BCM, solo tester; anni 2013, 2020, 2025.

## Validita
12 passate su 12 valide: stato OK, deposito 80.000, input confermati dal report (`si`), 0 stop out, 0 "no money". Qualita dello storico 99% nel 2013 e 100% negli altri anni (come nei test base).

## Risultati (EUR; DD = equity relativa; operazioni = aperture; gg = peggior giorno realizzato)
| EA, anno | R=50 (base) | R=0 | R=60 |
|---|---|---|---|
| Reaper 2013 | 24.148 / DD 6,7% / 631 op / gg -4.713 | 22.289 / 5,3% / 506 / -3.690 | 21.754 / 7,0% / 668 / -5.663 |
| Reaper 2020 | 23.657 / 5,0% / 570 / -1.645 | 20.465 / 3,8% / 460 / -1.605 | 20.574 / 5,9% / 631 / -1.821 |
| Reaper 2025 | 35.635 / 3,3% / 612 / -1.016 | 29.474 / 3,0% / 497 / -884 | 30.458 / 3,6% / 653 / -1.636 |
| Phantom 2013 | 5.487 / 2,0% / 1.243 / -617 | 3.993 / 1,4% / 851 / -463 | 5.731 / 2,1% / 1.350 / -608 |
| Phantom 2020 | 4.366 / 1,2% / 1.163 / -551 | 3.992 / 0,8% / 778 / -242 | 4.591 / 1,1% / 1.213 / -434 |
| Phantom 2025 | 7.806 / 1,1% / 1.135 / -433 | 5.448 / 1,0% / 711 / -191 | 7.352 / 1,1% / 1.156 / -381 |

## Classificazione contro R=50 (regola scritta: NEUTRA se netto entro +-10% e DD entro +-2 punti; COSTOSA se il netto cala oltre il 10%)
| EA, anno | R=0: netto, DD | esito | R=60: netto, DD | esito |
|---|---|---|---|---|
| Reaper 2013 | -7,7%, -1,4 pp | NEUTRA | -9,9%, +0,3 pp | NEUTRA (al limite) |
| Reaper 2020 | -13,5%, -1,2 pp | **COSTOSA** | -13,0%, +0,9 pp | **COSTOSA** |
| Reaper 2025 | -17,3%, -0,3 pp | **COSTOSA** | -14,5%, +0,3 pp | **COSTOSA** |
| Phantom 2013 | -27,2%, -0,6 pp | **COSTOSA** | +4,5%, +0,1 pp | NEUTRA |
| Phantom 2020 | -8,6%, -0,5 pp | NEUTRA | +5,1%, -0,2 pp | NEUTRA |
| Phantom 2025 | -30,2%, -0,1 pp | **COSTOSA** | -5,8%, 0,0 pp | NEUTRA |

## Previsioni R1-R4 contro i risultati
| # | Previsione | Esito |
|---|---|---|
| R1 | 60 e 50 danno risultati simili (netto +-10%): 70% per ogni EA | **Phantom vero** (3 anni su 3); **Reaper falso** (solo il 2013, per un soffio; 2020 e 2025 a -13/-14%) |
| R2 | R=0 ha netto piu alto del 50 in almeno 4 coppie su 6: 50% | **Falso**: 0 su 6; R=0 rende **meno** in tutte e 6 le coppie (da -8% a -30%) |
| R3 | Il numero di operazioni cambia di meno del 5% fra 0 e 60: 70% | **Falso**: +31...+37% (Reaper) e +56...+63% (Phantom): la Randomization **aggiunge** aperture |
| R4 | Il peggior giorno non peggiora di oltre 10% col 60: 60% | **Falso per il Reaper** (+11%, +20%, +61% rispetto al 50), **vero per il Phantom** (-1,5%, -21%, -12%) |

## Letture
- **La Randomization non e neutra e non e un puro rumore sul tempo degli ordini**: con 0 si aprono molte meno posizioni (-20...-35% sul Reaper, -30...-40% sul Phantom) e si guadagna meno in tutti i test. Il DD scende (R=0 e piu basso in tutte e 6) ma il netto scende di piu nel Phantom.
- **Reaper**: 50 e meglio sia di 0 sia di 60 in tutti e 3 gli anni; con 60 aumenta il peggior giorno (2025 da -1.016 a -1.636). **Non conviene alzarla a 60.**
- **Phantom**: 50 e 60 sono equivalenti; 0 costa 9-30%.
- **Non so se la differenza fra 50 e 60 sul Reaper sia sistematica o un caso**: la Randomization e per definizione casuale e ogni valore genera un percorso diverso. **NON MISURATO**: nessuna passata ripetuta con lo stesso valore. Per saperlo basta rifare il Reaper a 50 (2020, 2025) e vedere se il risultato cambia rispetto ai test base.
- **Rilievo pratico (ipotesi, NON verificata)**: i set prop di Wim usano 50 sul Reaper e sul Phantom; con piu conti sugli stessi EA una randomizzazione diversa dei tempi di ingresso diminuisce le operazioni perfettamente identiche fra conti. Se il valore influisce sulla regola FTMO delle operazioni "identiche o sostanzialmente simili" non lo sappiamo: va chiesto per iscritto.
- Limiti: tre anni, un solo percorso per valore, tester a barre da 1 minuto; il Goldbot e il Gold Trade Pro non hanno il parametro nei set letti.

## Effetto sul cancello (voce O-3: fatta)
- Reaper e Phantom: **Randomization da lasciare a 50 come nei set prop**; 0 costa il 8-30% del profitto, 60 non aiuta sul Reaper. Resta il limite "la differenza fra 50 e 60 puo essere rumore".
