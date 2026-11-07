# Trio oro sul conto reale (3.745 EUR), 21 mesi: risultati (07/11/2026)

Criteri e previsioni scritti prima: `CRITERI_ORO_REALE21_2026-11-06.md`. Zip `ANNO_ORO_GRADINI_R21_20261107_1213`. **21 passate su 21 valide**: stato OK, deposito 3.745, finestra 01/01/2025 - 01/10/2026, qualità storico 99% (barre da 1 minuto) e 100% (tick reali), nessuno stop out, nessuna riga "no money", input del report uguali ai set di Wim (0 differenze). Dati e script: `ORO_REALE21_dati/`.

## Trio (Reaper + Phantom + Goldbot), somma di tre corse indipendenti
| Livello | Modello | Netto (% di 3.745) | Conto finale | Giorni per raddoppiare | DD limite assoluto (% di 3.745) | DD relativo dei tre EA, somma | DD sul saldo realizzato dal picco | Peggior giorno realizzato |
|---|---|---|---|---|---|---|---|---|
| L2 Medium | barre 1 min | +30.163 (+805%) | 33.908 | 134 | 3.293 (87,9%) | 31,6% | 14,6% | −741 (23/04/2026) |
| L2 Medium | tick reali | +23.889 (+638%) | 27.634 | 147 | 3.203 (85,5%) | 37,8% | 15,6% | −709 (05/05/2026) |
| L1 Gradino 1 | barre 1 min | +13.659 (+365%) | 17.404 | 265 | 1.576 (42,1%) | 23,2% | 10,5% | −457 |
| L1 Gradino 1 | tick reali | +12.085 (+323%) | 15.830 | 271 | 1.589 (42,4%) | 26,5% | 10,9% | −438 |
| L0 Prop | barre 1 min | +8.552 (+228%) | 12.297 | 299 | 1.058 (28,3%) | 21,9% | 6,9% | −253 |
| L3 Combo | barre 1 min | +6.825 (+182%) | 10.570 | 376 | 1.160 (31,0%) | 22,5% | 6,9% | −346 |
| L3 Combo | tick reali | +6.078 (+162%) | 9.823 | non raggiunto in 21 mesi... | 1.202 (32,1%) | 23,8% | 7,4% | −354 |
(Il L0 Prop a tick reali non era in programma. Per L3 a tick reali il raddoppio avviene dopo il periodo letto dal calcolo dei 21 mesi in modo non confermato: leggere con cautela.)

## Esito secondo i criteri scritti (limite superiore del DD assoluto, % di 3.745)
- **L2 Medium: SCARTATO** per il criterio scritto (87,9% e 85,5% contro il 50%).
- **L1 Gradino 1: ZONA GRIGIA** (42%).
- **L0 Prop e L3 Combo: ACCETTABILI** (28-32%).
- **Avvertenza sul criterio**: il limite superiore era misurato in euro sul deposito iniziale, ma qui il conto cresce molto (Medium: da 3.745 a circa 28.000-34.000) e con `OnlyUp` il lotto sale col saldo. Il DD assoluto in euro include quindi perdite su saldi più alti. Misurato rispetto al saldo di quel momento: somma dei DD relativi dei tre EA 32-38% per il Medium, DD sul saldo realizzato dal picco 15% (solo realizzato, senza flottante di gruppo). Il verdetto scritto resta SCARTATO; la lettura relativa non supera il 50%, ma la somma dei DD relativi non è il DD vero combinato.

## Previsioni Q1-Q10
| # | Previsione | Esito |
|---|---|---|
| Q1 | Tutte le passate valide: 70% | **Vero** (21 su 21) |
| Q2 | L2 (barre 1 min) limite DD > 35%: 65%; > 50%: 35% | **Vero in entrambi** (87,9%) |
| Q3 | Quota a 0,01 sopra quella del 2025 da solo per ogni EA: 80% | **Falso**: Reaper 18% (29% nel 2025 da solo), Goldbot 34% (36%), Phantom 96% (97%). Il saldo cresce e i lotti salgono |
| Q4 | Netto L2 >= 2 volte quello di L0 (barre 1 min): 70% | **Vero** (3,5 volte: 30.163 contro 8.552) |
| Q5 | Netto L0 entro ±25% di +7.481 (test del 31/10): 50% | **Vero** (+8.552, +14%) |
| Q6 | Per L2 il netto a tick reali <= 0,9 volte quello a barre in almeno 2 EA su 3: 60% | **Vero** (Reaper 0,78, Goldbot 0,68, Phantom 0,93: 2 su 3) |
| Q7 | Nessuno stop out: 85% | **Vero** |
| Q8 | Peggior giorno del trio L2 <= −375: 45% | **Vero** (−741 = −19,8% di 3.745 nel giorno, a saldo 2026 più alto) |
| Q9 | L3 (barre 1 min) limite DD < 20%: 65% | **Falso** (31,0%) |
| Q10 | Righe "no money" in L2: 30% | **Falso** (zero) |

## Letture
- **A tick reali il Medium rende meno**: −21% sul trio (Goldbot −32%, Reaper −22%, Phantom −7%) e il Goldbot ha DD relativo 21% invece di 14%. Per i livelli prudenti la differenza è del 6-12%.
- **Il Medium sul reale**: +638% a tick reali in 21 mesi con un periodo di oro in forte rialzo, raddoppio dopo circa 4,5-5 mesi e triplicato dopo circa 9. Ha DD sul saldo realizzato del 15%, ma il peggior giorno è quasi il 20% del saldo di allora.
- **Un periodo, un percorso**: 21 mesi di oro in rialzo, possibile periodo di ottimizzazione dei set di Wim.
- Confronto col test del 31/10 (set prop nostri): il trio Prop di Wim fa +8.552 contro +7.481, DD sul saldo 6,9% contro 10,7%.

## Limiti
Un percorso storico, slippage e spread reali non simulati (a 3.745 il lotto minimo 0,01 e l'oro a 4.000 dollari rendono lo spread pesante), bonus non simulato, flottante del gruppo non ricostruito, somma di tre corse indipendenti senza margine condiviso. Nessun Guardian.
