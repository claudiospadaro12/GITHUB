# EMA200 a H4 e D1 sulle coppie forex: la MISURA (03/10/2026)

> **Stato: NON ancora passato dal cancello (`controllo-preventivo`). Nulla di questo e' stato mandato a Claudio.**
> Misura del fenomeno "al primo tocco la EMA200 respinge il prezzo" (convinzione di Claudio, Piano B, trading manuale)
> a **H4 e D1**, sul forex. **Non e' un backtest**: niente PF, niente stop in pip, niente costo dentro la P, nessuna
> taglia. Zero tester, zero VPS, nessun EA/preset/conto toccato.
> Criteri congelati PRIMA dei dati: `report/EMA200_H4_D1_FOREX28_CRITERI_2026-10-03.md` (commit `1576e01b`, errata 1
> `0205a221`, errata 2 `85262ed9`; leggere le due errata: cambiano le premesse di quattro autotest, non i criteri di
> verdetto). Strumento: `backtest_pipeline/ema200_forex28.py` (involucro che IMPORTA, senza modificarli,
> `ema200_rimbalzo.py` SHA256 `dd4fb376...9eb2` e `ema200_d1_su_m5.py` SHA256 `b8a75d35...33f9`).
> Archivio: `backtest_pipeline/risultati_archivio/EMA200_H4_D1_FOREX28_2026-10-03/`.
> Etichette: [MISURATO] letto dai CSV di questa corsa; [DERIVATO] calcolo su numeri misurati; [NON MISURATO]; [INFERITO].

## 0. In otto righe (con l'etichetta di copertura: **6 coppie su 28, Oanda, 2005-2020**)

1. **H4, cella che decide (rimbalzo di 1 ATR prima di uno sfondamento di 1 ATR): NULLO su tutti e due i lati.**
   P = **0,487 long / 0,470 short** contro i surrogati **0,478 / 0,491** (effetto **+0,009 / -0,021**), IC95 **0,448-0,526 /
   0,431-0,512**, `n_cluster` **634 / 591** (eventi 725 / 678) [MISURATO]. Dopo il primo tocco la EMA200 del H4 respinge
   il prezzo **quanto prevede il null (prezzo con la stessa deriva e volatilita' ma senza il legame con la EMA200), non di piu'**.
   (I placebo EMA100/150/250/SMA200 non sono stati rifatti: la regola li chiede solo se la primaria e' EFFETTO o ZONA GRIGIA con
   |effetto| >= 0,03, e non e' successo; quindi qui **non si afferma niente sulle "altre medie"**.)
2. **La forma forte ("quasi sempre rimbalza", P >= 0,75) e' ESCLUSA a H4 su queste sei coppie**: l'estremo alto dell'IC
   piu' largo e' **0,526**, contro 0,75 (la banda dell'alternativa, criteri sez. 9). La cella "piccola" della collega
   (rimbalzo di 0,25 ATR contro sfondamento di 1 ATR) fa **0,781 / 0,793**, e il random walk fa **0,800** (surrogati
   0,780 / 0,786): "quasi l'80%" e' quello che fa gia' qualunque linea.
3. **Il verdetto sul FENOMENO a H4 resta NON ANCORA MISURATO**, per la regola scritta prima (sez. 7.2 dei criteri):
   la parola "senza contenuto" richiede NULLO anche in ogni classe di regime con `n_cluster` >= 150, e **4 classi su 5
   escono ZONA GRIGIA per imprecisione** (semi-ampiezza dell'IC 0,062-0,076 contro 0,06; nessuna e' EFFETTO o
   CONTRARIO; la quinta, LATERALE long, e' NULLO; short TORO ha solo 144 cluster). Non e' un buco di risultato: e' un buco
   di campione dentro i regimi.
4. **D1: NON ANCORA MISURATO.** `n_cluster` **86 / 84** (eventi 92 / 89) contro 150. P **0,413 / 0,494**, con IC larghi
   (+/-0,10): non dicono niente. Era previsto (attesa E2: 55-135 eventi per lato). **Serve piu' storia e piu' coppie.**
5. **Asse "allineamento" (EMA200 del TF di contesto dal lato giusto del prezzo, SENZA filtro):** a H4 (contesto D1)
   **Delta -0,040 / +0,012, ZONA GRIGIA**, dentro la banda dei surrogati: nessun effetto leggibile. **A D1 l'asse non
   e' misurabile, e per un motivo strutturale, non di mercato**: la mappa D1 -> H4 del mandato mette come contesto una
   EMA200 piu' VELOCE (33 giorni contro 200), che dopo una separazione di 20 barre sta sempre dal lato del prezzo:
   **0 eventi allineati su 181**, verificato a mano su tutte e sei le coppie (sez. 5).
6. **M30 e H1 (riferimento, mai decisivi)**: stesso quadro, NULLO su 3 righe su 4 (M30 short ZONA GRIGIA, effetto
   -0,013): P 0,48-0,50 con `n_cluster` 1.956-3.203. Coerente con le misure del 01/10 su oro e DAX.
7. **Per chiudere D1 e allargare a CHF e NZD servono le altre 22 coppie** (HistData dal PC di backtest, solo dal 2007):
   sez. 9. Con un ritmo di ~1,15 primi tocchi per lato per coppia-anno a D1 [DERIVATO], bastano **~140 coppia-anni** per
   150 cluster: **circa 8 coppie nuove con 17 anni ciascuna** [DERIVATO, ordine di grandezza].
8. **Controlli**: autotest **40/40** su soli sintetici (prima dei dati); ricalcolo INDIPENDENTE a cicli espliciti di
   tutti i primi tocchi H4 e D1 delle sei coppie (**24 verifiche su 24 identiche** al minuto del tocco e alle sei celle,
   con e senza filtro ATR; **12 su 12** etichette di allineamento identiche) + un mutante che DEVE e VIENE visto.

Per Claudio, in una riga e senza tono di condanna: **su sei coppie e quindici anni, la EMA200 a H4 al primo tocco non fa
nulla di piu' di quanto farebbe il caso (null dei surrogati); a D1 non si sa ancora, e il numero per saperlo costa tempo del PC di backtest (download
HistData [NON MISURATO] e circa un'ora di calcolo [DERIVATO]) e nessun euro.** Quello che questa misura NON dice e' sotto, sez. 8: non misura la SUA regola (limite, parziali, stop in pip,
contesto a occhio).

## 1. Ordine criteri / dati (dichiarato con gli orari)

| fatto | ora UTC (03/10/2026) | note |
|---|---|---|
| criteri pushati | **09:57:52** (`1576e01b`) | sonda di esistenza sul mirror fatta PRIMA: solo HEAD e GET scartate su /dev/null, mai il contenuto |
| errata 1 (G-DATI per coppia-mese) | **10:01:07** (`0205a221`) | trovata rileggendo la sez. 2.4, prima di aprire un prezzo |
| 1.110 file del mirror scaricati | 10:05:38 - 10:06:27 | **non aperti** da nessun codice fino al 11:49 |
| errata 2 + involucro + autotest 40/40 pushati | **11:40:08** (`85262ed9`) | solo dati sintetici |
| **primo file di prezzi veri letto** (conversione in `.npz`) | **11:49:41 - 11:50:00** | dopo l'autotest dentro la stessa corsa |
| tentativo 1 della corsa | 11:40:16 -> **crash al D1** | una guardia mancante per un sottoinsieme vuoto (`boot_mesi_delta`, 0 eventi allineati); H4 era gia' uscito |
| corsa definitiva (autotest 40/40 in 547 s + dati 538 s) | 11:56 -> 12:13 | H4 **identico al decimale** fra i due tentativi (diff dei log vuoto) |

Dopo aver visto i numeri di H4 **non e' cambiato nessun criterio, nessuna soglia, nessuna cella**: e' cambiata una sola
riga di codice, la guardia che evita il crash su un sottoinsieme vuoto (`np.quantile` su un array vuoto), che non
tocca nessuna definizione.

## 2. Dati, orologio, campione [MISURATO]

| coppia | barre M1 | dal | al (UTC) | barre H4 | barre D1 | eventi H4 (PRIM) | eventi D1 (PRIM) |
|---|---|---|---|---|---|---|---|
| AUDJPY | 5.715.036 | 2005-01-02 18:47 | 2020-05-14 07:59 | 25.461 | 4.002 | 229 | 41 |
| AUDUSD | 5.386.026 | 2005-01-02 18:47 | 2020-05-14 07:59 | 25.486 | 4.002 | 249 | 31 |
| EURJPY | 5.678.821 | 2005-01-02 18:47 | 2020-05-14 07:59 | 25.485 | 4.002 | 228 | 23 |
| EURUSD | 5.583.561 | 2005-01-02 18:38 | 2020-05-14 07:59 | 25.499 | 4.002 | 234 | 26 |
| GBPUSD | 5.458.319 | 2005-01-02 19:29 | 2020-05-14 07:59 | 25.443 | 4.002 | 228 | 31 |
| USDCAD | 5.396.427 | 2005-01-02 18:53 | 2020-05-14 07:59 | 25.406 | 4.002 | 236 | 29 |

- **Finestra reale: 2005-01 -> 2020-05-14 (15,4 anni).** Eventi dal riscaldamento (600 barre del TF): H4 da ~aprile 2005, D1 da ~2007.
- **G-OROLOGIO (feed Oanda, pooled): PASSA**: picco d'inverno **13:30** (n 5.612.734), d'estate **12:30** (n 8.206.871), cioe'
  esattamente -60 minuti sull'ancora dei dati USA. Informativo per coppia: EURJPY/EURUSD/USDCAD 13:30 -> 12:30;
  **GBPUSD 09:30 -> 08:30** (dati UK, fuori dalle ancore ma con lo spostamento giusto); **AUDJPY/AUDUSD 00:30 -> 01:30**
  (dati australiani delle 11:30 locali: lo spostamento e' di +60 perche' l'Australia ha l'ora legale opposta, coerente con un
  feed in UTC [INFERITO]).
- **G-DATI (errata 1): l'unico mese escluso e' 2020-05**, per tutte e sei le coppie (il feed finisce il 14 maggio: meno del 50%
  della mediana mensile ~29.300-31.100 barre). Nessun altro mese e' sotto il 50% [MISURATO].
- **Barre H4 e D1**: UTC+1 fisso come il 01/10; **D1 con sabato/domenica nel lunedi'** (differenza dichiarata, criteri 2.2).
- **ATR(14) mediano** [MISURATO, in pip]: H4 **30,5-44,6**; D1 **90,2-123,3**; H1 15,1-22,1; M30 10,4-15,2. Spread sul feed Oanda
  [NON MISURATO]; per EURUSD l'all-in di casa e' 0,86 pip (`MISURA_SPREAD_FOREX_2026-09-12`, non rimisurato qui):
  1 ATR H4 / 0,86 = **41x** [DERIVATO], appena sopra la frontiera `stop >= 40 x spread`. Non entra nella P.
- **Regimi per coppia-anno** (TORO >= +5%, ORSO <= -5%), in `REFERTO_A6.txt`: 96 coppia-anni; classi misurate, non scelte.

## 3. H4 e D1, cella primaria e cella della collega [MISURATO]

Definizione identica al 01/10 (primo tocco d'ombra dopo 20 barre pulite con almeno una a >= 1 ATR; esiti in ATR del TF sui
minuti M1; livello e ATR congelati). Lati separati. Filtro ATR 0,1 x mediana (dal 02/10); IC del verdetto = il piu' largo fra
Wilson su `n_cluster` e bootstrap a blocchi di mese; null = 100 surrogati a blocchi di 40 barre per coppia, P pooled.

### T1. Cella primaria (X = Y = 1,0; N0 = 0,500), **la sola che decide**

| TF | lato | n | n_cluster | coppie | mesi | P | IC95 verdetto | N0 | surr. mediana [p2,5; p97,5] | effetto | verdetto |
|---|---|---|---|---|---|---|---|---|---|---|---|
| H4 | long | 725 | 634 | 6 | 175 | 0.487 | 0.448-0.526 | 0.500 | 0.478 [0.438; 0.510] | +0.009 | NULLO |
| H4 | short | 678 | 591 | 6 | 168 | 0.470 | 0.431-0.512 | 0.500 | 0.491 [0.450; 0.532] | -0.021 | NULLO |
| D1 | long | 92 | 86 | 6 | 65 | 0.413 | 0.315-0.519 | 0.500 | 0.490 [0.393; 0.594] | -0.077 | NON ANCORA MISURATO |
| D1 | short | 89 | 84 | 6 | 63 | 0.494 | 0.390-0.600 | 0.500 | 0.485 [0.389; 0.567] | +0.010 | NON ANCORA MISURATO |
| H1 | long | 2758 | 2023 | 6 | 183 | 0.493 | 0.471-0.514 | 0.500 | 0.487 [0.467; 0.502] | +0.006 | NULLO |
| H1 | short | 2685 | 1956 | 6 | 183 | 0.484 | 0.462-0.506 | 0.500 | 0.496 [0.478; 0.510] | -0.012 | NULLO |
| M30 | long | 5311 | 3203 | 6 | 184 | 0.499 | 0.482-0.517 | 0.500 | 0.491 [0.475; 0.503] | +0.009 | NULLO |
| M30 | short | 5004 | 3023 | 6 | 184 | 0.480 | 0.462-0.498 | 0.500 | 0.493 [0.482; 0.503] | -0.013 | ZONA GRIGIA |

Lettura: a **H4** le due righe sono NULLO con `n_cluster` 634 / 591 (la regola NULLO richiede ~267 cluster per una
semi-ampiezza di 0,06: soddisfatta, semi-ampiezza 0,039 / 0,041). A **D1** `n_cluster` 86 / 84 < 150: **NON ANCORA
MISURATO**. Il -0,077 del D1 long non e' un risultato: IC95 0,315-0,519, la banda dei surrogati arriva a 0,594.
M30 short e' ZONA GRIGIA con effetto -0,013 (dentro 0,03: la P e' fuori dalla banda dei surrogati per un soffio, non per
effetto). Nessun placebo e' stato "dovuto" (la regola della sez. 5 li chiede solo se la primaria e' EFFETTO, o ZONA GRIGIA con
|effetto| >= 0,03: mai successo).

### T2. Cella della collega (X = 0,25, Y = 1,0; N0 = 0,800), descrittiva

| TF | lato | n | n_cluster | coppie | mesi | P | IC95 verdetto | N0 | surr. mediana [p2,5; p97,5] | effetto | verdetto |
|---|---|---|---|---|---|---|---|---|---|---|---|
| H4 | long | 725 | 634 | 6 | 175 | 0.781 | 0.747-0.811 | 0.800 | 0.780 [0.752; 0.816] | +0.001 | NULLO |
| H4 | short | 678 | 591 | 6 | 168 | 0.793 | 0.759-0.825 | 0.800 | 0.786 [0.761; 0.823] | +0.007 | NULLO |
| D1 | long | 92 | 86 | 6 | 65 | 0.761 | 0.661-0.849 | 0.800 | 0.778 [0.708; 0.860] | -0.017 | NON ANCORA MISURATO |
| D1 | short | 89 | 84 | 6 | 63 | 0.775 | 0.675-0.857 | 0.800 | 0.788 [0.713; 0.865] | -0.013 | NON ANCORA MISURATO |
| H1 | long | 2760 | 2024 | 6 | 183 | 0.759 | 0.740-0.777 | 0.800 | 0.763 [0.752; 0.781] | -0.004 | NULLO |
| H1 | short | 2690 | 1955 | 6 | 183 | 0.763 | 0.744-0.781 | 0.800 | 0.768 [0.753; 0.782] | -0.006 | NULLO |
| M30 | long | 5341 | 3216 | 6 | 184 | 0.755 | 0.740-0.769 | 0.800 | 0.749 [0.739; 0.761] | +0.006 | NULLO |
| M30 | short | 5028 | 3041 | 6 | 184 | 0.747 | 0.731-0.762 | 0.800 | 0.754 [0.743; 0.763] | -0.007 | NULLO |

La cella piccola **non arriva mai a 0,80** (il random walk): 0,781 / 0,793 a H4, 0,747-0,763 a M30-H1. "Rimbalza quasi
sempre di pochi punti" **e' il caso**, non la media. Il criterio per dargli contenuto (P >= 0,85 e sopra p97,5) non e'
raggiunto da nessuna riga.

### T2b. Tutte le celle H4 e D1 (descrittive; nessuna promuove niente)

| TF | lato | cella (X, Y) | n | B | P | P_B | N0 | surr. mediana | effetto |
|---|---|---|---|---|---|---|---|---|---|
| H4 | long | 0.25 ; 0.50 | 725 | 471 | 254 | 0.650 | 0.667 | 0.646 | +0.004 |
| H4 | long | 0.50 ; 0.50 | 725 | 377 | 348 | 0.520 | 0.500 | 0.486 | +0.034 |
| H4 | long | 1.00 ; 0.50 | 725 | 242 | 483 | 0.334 | 0.333 | 0.318 | +0.015 |
| H4 | long | 0.25 ; 1.00 | 725 | 566 | 159 | 0.781 | 0.800 | 0.780 | +0.001 |
| H4 | long | 0.50 ; 1.00 | 725 | 482 | 243 | 0.665 | 0.667 | 0.651 | +0.014 |
| H4 | long | 1.00 ; 1.00 | 725 | 353 | 372 | 0.487 | 0.500 | 0.478 | +0.009 |
| H4 | short | 0.25 ; 0.50 | 678 | 437 | 241 | 0.644 | 0.667 | 0.651 | -0.007 |
| H4 | short | 0.50 ; 0.50 | 678 | 318 | 360 | 0.469 | 0.500 | 0.497 | -0.028 |
| H4 | short | 1.00 ; 0.50 | 679 | 209 | 470 | 0.308 | 0.333 | 0.325 | -0.017 |
| H4 | short | 0.25 ; 1.00 | 678 | 538 | 140 | 0.793 | 0.800 | 0.786 | +0.007 |
| H4 | short | 0.50 ; 1.00 | 677 | 432 | 245 | 0.638 | 0.667 | 0.660 | -0.022 |
| H4 | short | 1.00 ; 1.00 | 678 | 319 | 359 | 0.470 | 0.500 | 0.491 | -0.021 |
| D1 | long | 0.25 ; 0.50 | 92 | 58 | 34 | 0.630 | 0.667 | 0.659 | -0.029 |
| D1 | long | 0.50 ; 0.50 | 92 | 47 | 45 | 0.511 | 0.500 | 0.477 | +0.033 |
| D1 | long | 1.00 ; 0.50 | 92 | 26 | 66 | 0.283 | 0.333 | 0.314 | -0.031 |
| D1 | long | 0.25 ; 1.00 | 92 | 70 | 22 | 0.761 | 0.800 | 0.778 | -0.017 |
| D1 | long | 0.50 ; 1.00 | 92 | 62 | 30 | 0.674 | 0.667 | 0.647 | +0.026 |
| D1 | long | 1.00 ; 1.00 | 92 | 38 | 54 | 0.413 | 0.500 | 0.490 | -0.077 |
| D1 | short | 0.25 ; 0.50 | 89 | 53 | 36 | 0.596 | 0.667 | 0.663 | -0.068 |
| D1 | short | 0.50 ; 0.50 | 89 | 39 | 50 | 0.438 | 0.500 | 0.505 | -0.067 |
| D1 | short | 1.00 ; 0.50 | 89 | 30 | 59 | 0.337 | 0.333 | 0.317 | +0.020 |
| D1 | short | 0.25 ; 1.00 | 89 | 69 | 20 | 0.775 | 0.800 | 0.788 | -0.013 |
| D1 | short | 0.50 ; 1.00 | 89 | 55 | 34 | 0.618 | 0.667 | 0.663 | -0.045 |
| D1 | short | 1.00 ; 1.00 | 89 | 44 | 45 | 0.494 | 0.500 | 0.485 | +0.010 |

La deviazione positiva piu' grande fra le 12 celle H4 e' **H4 long (0,5; 0,5): P 0,520, effetto +0,034, ZONA GRIGIA**:
una cella descrittiva su dodici, con il resto a +/-0,03 e nessuna cella dell'altro lato: e' esattamente cio' che ci si
aspetta dal caso su 12 confronti. **Non si scrive "la cella (0,5; 0,5) funziona".**

## 4. Regimi, sensibilita' e per coppia [MISURATO]

### T3. Per classe di regime (coppia-anno), cella primaria

| TF | lato | regime | n | n_cluster | coppie | mesi | P | IC95 verdetto | N0 | surr. mediana [p2,5; p97,5] | effetto | verdetto |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| H4 | long | TORO | 215 | 197 | 6 | 108 | 0.498 | 0.429-0.567 | 0.500 | 0.507 [0.434; 0.571] | -0.009 | ZONA GRIGIA |
| H4 | long | LATERALE | 315 | 295 | 6 | 128 | 0.498 | 0.442-0.555 | 0.500 | 0.475 [0.416; 0.536] | +0.024 | NULLO |
| H4 | long | ORSO | 195 | 180 | 6 | 89 | 0.456 | 0.381-0.533 | 0.500 | 0.465 [0.399; 0.514] | -0.009 | ZONA GRIGIA |
| H4 | short | TORO | 154 | 144 | 6 | 76 | 0.416 | 0.328-0.503 | 0.500 | 0.475 [0.391; 0.546] | -0.060 | NON ANCORA MISURATO |
| H4 | short | LATERALE | 264 | 243 | 6 | 120 | 0.508 | 0.445-0.570 | 0.500 | 0.498 [0.443; 0.556] | +0.010 | ZONA GRIGIA |
| H4 | short | ORSO | 260 | 235 | 6 | 109 | 0.465 | 0.403-0.529 | 0.500 | 0.509 [0.434; 0.569] | -0.043 | ZONA GRIGIA |
| D1 | long | TORO | 20 | 20 | 5 | 20 | 0.350 | 0.150-0.567 | 0.500 | 0.548 [0.353; 0.793] | -0.198 | NON ANCORA MISURATO |
| D1 | long | LATERALE | 49 | 46 | 6 | 43 | 0.490 | 0.352-0.636 | 0.500 | 0.486 [0.322; 0.674] | +0.003 | NON ANCORA MISURATO |
| D1 | long | ORSO | 23 | 22 | 6 | 17 | 0.304 | 0.130-0.513 | 0.500 | 0.449 [0.280; 0.613] | -0.145 | NON ANCORA MISURATO |
| D1 | short | TORO | 18 | 18 | 6 | 17 | 0.444 | 0.176-0.684 | 0.500 | 0.429 [0.297; 0.579] | +0.016 | NON ANCORA MISURATO |
| D1 | short | LATERALE | 40 | 37 | 6 | 34 | 0.500 | 0.347-0.653 | 0.500 | 0.512 [0.369; 0.678] | -0.012 | NON ANCORA MISURATO |
| D1 | short | ORSO | 31 | 30 | 6 | 25 | 0.516 | 0.345-0.683 | 0.500 | 0.515 [0.317; 0.712] | +0.001 | NON ANCORA MISURATO |
| H1 | long | TORO | 777 | 674 | 6 | 143 | 0.507 | 0.469-0.545 | 0.500 | 0.504 [0.469; 0.559] | +0.003 | NULLO |
| H1 | long | LATERALE | 1115 | 966 | 6 | 167 | 0.504 | 0.473-0.535 | 0.500 | 0.492 [0.466; 0.512] | +0.012 | NULLO |
| H1 | long | ORSO | 866 | 709 | 6 | 141 | 0.465 | 0.429-0.502 | 0.500 | 0.474 [0.438; 0.501] | -0.008 | NULLO |
| H1 | short | TORO | 674 | 572 | 6 | 138 | 0.494 | 0.453-0.535 | 0.500 | 0.492 [0.458; 0.521] | +0.002 | NULLO |
| H1 | short | LATERALE | 1032 | 899 | 6 | 169 | 0.470 | 0.438-0.504 | 0.500 | 0.489 [0.466; 0.516] | -0.019 | NULLO |
| H1 | short | ORSO | 979 | 797 | 6 | 146 | 0.492 | 0.458-0.528 | 0.500 | 0.509 [0.478; 0.533] | -0.017 | NULLO |
| M30 | long | TORO | 1532 | 1187 | 6 | 147 | 0.510 | 0.482-0.539 | 0.500 | 0.508 [0.483; 0.533] | +0.002 | NULLO |
| M30 | long | LATERALE | 2101 | 1682 | 6 | 172 | 0.508 | 0.484-0.532 | 0.500 | 0.489 [0.476; 0.506] | +0.019 | ZONA GRIGIA |
| M30 | long | ORSO | 1678 | 1266 | 6 | 148 | 0.478 | 0.451-0.506 | 0.500 | 0.475 [0.458; 0.497] | +0.004 | NULLO |
| M30 | short | TORO | 1252 | 995 | 6 | 146 | 0.485 | 0.454-0.516 | 0.500 | 0.487 [0.464; 0.509] | -0.003 | NULLO |
| M30 | short | LATERALE | 1946 | 1537 | 6 | 172 | 0.467 | 0.442-0.492 | 0.500 | 0.490 [0.476; 0.508] | -0.024 | ZONA GRIGIA |
| M30 | short | ORSO | 1806 | 1315 | 6 | 148 | 0.491 | 0.464-0.518 | 0.500 | 0.498 [0.481; 0.523] | -0.008 | NULLO |

Il segno dell'effetto a H4: long -0,009 / +0,024 / -0,009 (TORO/LATERALE/ORSO), short -0,060 / +0,010 / -0,043. Short TORO ha
`n_cluster` 144 < 150 (NON ANCORA MISURATO). **Nessuna classe esce EFFETTO o CONTRARIO**. Le ZONA GRIGIA di H4 sono tutte
per semi-ampiezza (0,062-0,076 > 0,06), non per effetto (P dentro la banda dei surrogati in tutte). E' la ragione per cui
il verdetto sul fenomeno non puo' dire "senza contenuto".

### T4. Sensibilita': senza filtro ATR e con la barra che chiude alle 17:00 di New York (NYCLOSE)

| TF | lato | variante | n | n_cluster | P | IC95 | effetto (contro la banda PRIM) | verdetto |
|---|---|---|---|---|---|---|---|---|
| H4 | long | PRIM | 725 | 634 | 0.487 | 0.448-0.526 | +0.009 | NULLO |
| H4 | long | NOFILT | 725 | 634 | 0.487 | 0.448-0.526 | +0.009 | NULLO |
| H4 | long | NYCLOSE | 723 | 629 | 0.492 | 0.454-0.531 | +0.014 | NULLO |
| H4 | short | PRIM | 678 | 591 | 0.470 | 0.431-0.512 | -0.021 | NULLO |
| H4 | short | NOFILT | 678 | 591 | 0.470 | 0.431-0.511 | -0.021 | NULLO |
| H4 | short | NYCLOSE | 667 | 584 | 0.474 | 0.434-0.514 | -0.018 | NULLO |
| D1 | long | PRIM | 92 | 86 | 0.413 | 0.315-0.519 | -0.077 | NON ANCORA MISURATO |
| D1 | long | NOFILT | 92 | 86 | 0.413 | 0.315-0.519 | -0.077 | NON ANCORA MISURATO |
| D1 | long | NYCLOSE | 92 | 86 | 0.424 | 0.325-0.529 | -0.066 | NON ANCORA MISURATO |
| D1 | short | PRIM | 89 | 84 | 0.494 | 0.390-0.600 | +0.010 | NON ANCORA MISURATO |
| D1 | short | NOFILT | 89 | 84 | 0.494 | 0.384-0.610 | +0.010 | NON ANCORA MISURATO |
| D1 | short | NYCLOSE | 89 | 84 | 0.506 | 0.401-0.611 | +0.021 | NON ANCORA MISURATO |
| H1 | long | PRIM | 2758 | 2023 | 0.493 | 0.471-0.514 | +0.006 | NULLO |
| H1 | long | NOFILT | 2767 | 2029 | 0.491 | 0.469-0.513 | +0.004 | NULLO |
| H1 | short | PRIM | 2685 | 1956 | 0.484 | 0.462-0.506 | -0.012 | NULLO |
| H1 | short | NOFILT | 2687 | 1957 | 0.484 | 0.462-0.506 | -0.013 | NULLO |
| M30 | long | PRIM | 5311 | 3203 | 0.499 | 0.482-0.517 | +0.009 | NULLO |
| M30 | long | NOFILT | 5321 | 3207 | 0.499 | 0.481-0.516 | +0.008 | NULLO |
| M30 | short | PRIM | 5004 | 3023 | 0.480 | 0.462-0.498 | -0.013 | ZONA GRIGIA |
| M30 | short | NOFILT | 5008 | 3026 | 0.479 | 0.462-0.497 | -0.013 | ZONA GRIGIA |

Il filtro ATR **non cambia nulla a H4 e D1** (eventi identici) e cambia pochi eventi a H1 e M30 (2.767 contro 2.758 long a H1,
5.321 contro 5.311 a M30; la P si sposta di -0,0004 / -0,0016). **NYCLOSE sposta la P
di +0,005 / +0,004 a H4 e di +0,011 / +0,012 a D1**, mai di un verdetto: la convenzione di chiusura della barra non pesa.

### T5. Per coppia (cella primaria)

| TF | coppia | lato | n | P | surr. mediana [p2,5; p97,5] | effetto |
|---|---|---|---|---|---|---|
| H4 | AUDJPY | long | 125 | 0.480 | 0.477 [0.387; 0.557] | +0.003 |
| H4 | AUDJPY | short | 104 | 0.500 | 0.523 [0.422; 0.594] | -0.023 |
| H4 | AUDUSD | long | 132 | 0.500 | 0.488 [0.383; 0.599] | +0.012 |
| H4 | AUDUSD | short | 117 | 0.470 | 0.505 [0.422; 0.585] | -0.035 |
| H4 | EURJPY | long | 119 | 0.462 | 0.443 [0.367; 0.538] | +0.020 |
| H4 | EURJPY | short | 109 | 0.550 | 0.474 [0.400; 0.571] | +0.077 |
| H4 | EURUSD | long | 116 | 0.448 | 0.468 [0.371; 0.555] | -0.020 |
| H4 | EURUSD | short | 117 | 0.444 | 0.488 [0.411; 0.566] | -0.043 |
| H4 | GBPUSD | long | 114 | 0.553 | 0.498 [0.394; 0.566] | +0.055 |
| H4 | GBPUSD | short | 114 | 0.439 | 0.486 [0.411; 0.559] | -0.048 |
| H4 | USDCAD | long | 119 | 0.479 | 0.486 [0.402; 0.592] | -0.007 |
| H4 | USDCAD | short | 117 | 0.427 | 0.491 [0.396; 0.572] | -0.063 |
| D1 | AUDJPY | long | 21 | 0.333 | 0.453 [0.215; 0.724] | -0.120 |
| D1 | AUDJPY | short | 20 | 0.550 | 0.467 [0.250; 0.735] | +0.083 |
| D1 | AUDUSD | long | 19 | 0.526 | 0.500 [0.189; 0.713] | +0.026 |
| D1 | AUDUSD | short | 12 | 0.417 | 0.469 [0.200; 0.692] | -0.052 |
| D1 | EURJPY | long | 11 | 0.273 | 0.462 [0.184; 0.742] | -0.189 |
| D1 | EURJPY | short | 12 | 0.500 | 0.455 [0.200; 0.652] | +0.045 |
| D1 | EURUSD | long | 10 | 0.400 | 0.538 [0.240; 0.800] | -0.139 |
| D1 | EURUSD | short | 16 | 0.438 | 0.464 [0.273; 0.723] | -0.027 |
| D1 | GBPUSD | long | 16 | 0.375 | 0.467 [0.207; 0.655] | -0.092 |
| D1 | GBPUSD | short | 15 | 0.333 | 0.529 [0.239; 0.771] | -0.196 |
| D1 | USDCAD | long | 15 | 0.533 | 0.500 [0.286; 0.778] | +0.033 |
| D1 | USDCAD | short | 14 | 0.714 | 0.500 [0.246; 0.699] | +0.214 |

A H4 gli effetti per coppia stanno fra -0,063 e +0,077 con ~115 eventi a lato: **7 coppie-lato su 12 negative, 5 positive**,
nessuna fuori dalla propria banda [p2,5; p97,5] dei surrogati: i segni sono sparsi, come ci si aspetta quando non c'e' nulla da
confermare (la regola di concordanza per coppia serve solo se c'e' un EFFETTO). A D1 con 10-21 eventi per coppia-lato i numeri non
dicono niente: l'unica riga fuori banda e' USDCAD short (P 0,714 con n 14, banda 0,246-0,699), una su 12 coppie-lato, cioe'
il numero atteso dal caso (~0,6).

## 5. L'asse "allineamento" [MISURATO]

Regola congelata (criteri sez. 8): al minuto del tocco, la EMA200 dell'ultima barra CHIUSA del TF di contesto sta dal lato
giusto del livello toccato (long: contesto sotto; short: contesto sopra; uguale = contro). Mappa: M30 -> H1, H1 -> H4,
**H4 -> D1, D1 -> H4**. **Non e' un filtro**: la cella primaria resta senza filtro.

### T6. Allineamento (surrogati: stessa etichettatura rifatta su ogni surrogato)

| TF | contesto | lato | NA | allineato: P (B/P, n_cluster) | contro: P (B/P, n_cluster) | Delta | IC95 mesi | surr. Delta mediana [p2,5; p97,5] | verdetto |
|---|---|---|---|---|---|---|---|---|---|
| H4 | D1 | long | 98 | 0.480 (182/197, 339) | 0.520 (129/119, 223) | -0.040 | -0.120-0.041 | 0.003 [-0.062; 0.079] | ZONA GRIGIA |
| H4 | D1 | short | 84 | 0.489 (195/204, 350) | 0.477 (93/102, 183) | +0.012 | -0.066-0.085 | 0.005 [-0.075; 0.076] | ZONA GRIGIA |
| D1 | H4 | long | 0 | - (0/0, 0) | 0.413 (38/54, 86) | - | --- | 0.420 [0.382; 0.457] | NON ANCORA MISURATO |
| D1 | H4 | short | 0 | - (0/0, 0) | 0.494 (44/45, 84) | - | --- | 0.008 [-0.465; 0.480] | NON ANCORA MISURATO |
| H1 | H4 | long | 51 | 0.499 (894/896, 1402) | 0.484 (444/473, 761) | +0.015 | -0.021-0.051 | 0.006 [-0.032; 0.041] | NULLO |
| H1 | H4 | short | 50 | 0.497 (845/856, 1312) | 0.463 (432/502, 789) | +0.034 | -0.009-0.080 | -0.000 [-0.039; 0.035] | ZONA GRIGIA |
| M30 | H1 | long | 28 | 0.504 (1968/1934, 2580) | 0.485 (670/711, 1118) | +0.019 | -0.010-0.048 | 0.002 [-0.023; 0.025] | NULLO |
| M30 | H1 | short | 12 | 0.480 (1762/1909, 2408) | 0.481 (635/686, 1071) | -0.001 | -0.033-0.032 | 0.005 [-0.027; 0.041] | NULLO |

- **H4 (contesto D1)**: Delta **-0,040 long / +0,012 short**, IC95 a blocchi di mese **-0,120/+0,041 e -0,066/+0,085**, tutti dentro la
  banda dei surrogati (+/-0,07): **nessun effetto**. Eventi NA (contesto D1 con meno di 600 barre al tocco): 98 / 84.
- **M30 (contesto H1) NULLO, H1 (contesto H4) NULLO long e ZONA GRIGIA short (+0,034)**: indizi non rimisurabili qui.
- **D1 (contesto H4): NON MISURABILE, per costruzione.** Il verificatore indipendente stampa, per ogni coppia, la distanza fra
  la EMA200 di contesto e il livello toccato: EURUSD, **long: mediana +2,46 ATR (min +1,81, max +3,78); short: mediana -2,33
  (min -5,03, max -1,00)**: la EMA200 del H4 (33 giorni) sta SEMPRE oltre il livello D1 dal lato del prezzo, a 1-5 ATR. Per
  definizione ogni tocco D1 e' CONTRO: **allineati 0 su 181**, in tutte le sei coppie. Le righe "surrogati" del D1 in tabella
  non hanno significato (calcolate sui pochissimi surrogati con entrambi i gruppi). **E' un difetto della mappa D1 -> H4 del mandato, non un risultato**: il contesto giusto sarebbe un TF
  PIU' LENTO (W1), la cui EMA200 chiede ~3,85 anni di riscaldamento. Una variante "D1 -> W1" e' una misura nuova con criteri
  nuovi, da congelare prima.

## 6. Controlli (lo Sviluppatore e l'Agente dei Controlli)

1. **Autotest 40/40 prima dei dati** (`autotest.log`): F0 l'autotest del 01/10 (21/21); F1 identita' con `R.eventi_h1` a H1/H4/D1
   (1.075 / 250 / 36 eventi); F2 random walk H4 pooled: P **0,519 / 0,526**, NULLO / ZONA GRIGIA (non EFFETTO), `n_cluster`
   1.159 / 1.203, e con fattore comune `n_cluster` 990 contro 1.178 eventi; **F3 rimbalzo PIANTATO a H4: P 0,984 / 0,989,
   EFFETTO** (surrogati 0,537 / 0,557), **F4 sfondamento piantato: P 0,096 / 0,093, CONTRARIO**; F5 asse (piantato solo se allineato
   Delta +0,274 / +0,294 EFFETTO; piantato sempre +0,007 / +0,041 ZONA GRIGIA) e F5a etichetta ricalcolata a mano 100% uguale;
   F6 orologio (+1 h cambia gli eventi; il cancello boccia EST fisso a -120 e un feed UTC letto come NY); F7 domenica (D1 = 50
   barre in 10 settimane); F8 cluster a mano; F9 IC di mese 3,3 volte Wilson sui mesi tutti-B/tutti-P; F10 `n_cluster` < 150 ->
   NON ANCORA MISURATO; F11 mutazione X 1,0 -> 0,25 sposta P di +0,30; F12 placebo (EMA100 non EFFETTO; **EMA150 gemella
   LEGGE l'effetto**, vedi errata 2); F13 look-ahead del contesto.
2. **Ricalcolo INDIPENDENTE** (`backtest_pipeline/verifica_indipendente_forex28.py`, cicli Python espliciti, nessuna funzione degli
   strumenti): per le **sei coppie a H4 e D1**, con e senza filtro, **24 su 24 liste di eventi identiche** (lato, minuto del tocco,
   sei celle B/P/AMB/TO) e **12 su 12 etichette di allineamento identiche** (`verifica_indipendente.log`). **Mutante** (EMA con
   alpha 2/211 invece di 2/201): 231 eventi contro 234, **DIFFERENZE**: la verifica non e' cieca.
3. **Contro-esempio costruito prima di consegnare**: (a) *"la banda dei surrogati e' troppo stretta perche' le coppie sono
   permutate indipendentemente"* -> l'EFFETTO richiede anche l'IC a blocchi di mese sopra la mediana, e il test F2 con fattore
   comune non lo vede; qui nessuna riga e' EFFETTO, quindi la banda stretta non puo' aver fabbricato un falso positivo;
   (b) *"il NULLO di H4 e' perche' il filtro o la barra D1 sono sbagliati"* -> senza filtro identico, NYCLOSE +0,005, independente
   a mano uguale; (c) *"lo strumento non sa vedere un rimbalzo a H4"* -> F3: lo vede (0,984, EFFETTO, +0,45 sui surrogati).
4. **Classi candidate per `CHECKLIST_RIGA_DI_LANCIO.md`** (non scritte nel file condiviso: le propongo, le scrive chi ha la
   numerazione): (i) *unita' di un cancello dei dati scelta sulla carta* (anno contro mese: l'anno parziale finale veniva escluso);
   (ii) *placebo gemello*: un livello con periodo vicino (EMA150) riproduce un effetto piantato alla 200, quindi "placebo
   EFFETTO" non prova "linea qualsiasi" senza guardare la distanza dalla linea; (iii) *asse con contesto piu' veloce del livello
   misurato*: allineati 0 per costruzione; (iv) *mondo sintetico degenere* (forza troppo alta: zero eventi del gruppo di confronto,
   prezzo sotto zero).

## 7. Confronto con l'alternativa (classe 178) e con le attese

- **Convinzione di Claudio alla lettera** ("respinge al primo tocco", "quasi sempre"): prevede P >= 0,75 alla primaria. **H4, sei
  coppie: P 0,487 / 0,470, IC alto 0,526 / 0,512: escluso**, con `n_cluster` 634 / 591. A D1 la domanda e' aperta (IC 0,32-0,60).
- **Forma debole** (+0,05): non separabile con meno di ~1.500 cluster per lato [DERIVATO]. A H4 gli effetti misurati sono
  **+0,009 / -0,021** e l'IC dell'effetto (P - mediana dei surrogati) e' **[-0,030; +0,048] long, [-0,061; +0,021] short**
  [DERIVATO dagli IC]: un +0,05 sul long e' al limite dell'IC (non escluso con sicurezza), sul short e' escluso. Una forma debole
  di +0,02 sul long non e' esclusa.
- **Contro le attese scritte prima** (sez. 12 dei criteri): **E1** (H4 effetto entro +/-0,05, NULLO o ZONA GRIGIA, P 0,42-0,55):
  confermata. **E2** (H4 360-810 eventi per lato; D1 55-135): **H4 725 / 678, D1 92 / 89**, dentro. **E3**: confermata (NULLO a
  `n_cluster` > 267). **E4** (cella della collega 0,65-0,80): 0,781 / 0,793, confermata. **E5** (asse entro +/-0,05): confermata a H4
  (-0,040 / +0,012); a D1 non misurabile (non prevista). **E6** (la P grezza segue la deriva, l'effetto no): la prima meta' **non e' stata misurata** qui; la seconda e' confermata
  (effetto +0,009 / -0,021 contro i surrogati, che conservano la deriva).
- **Confronto descrittivo col 01/10 a H4** (altri simboli, n piccoli): DAX 0,381 / 0,333, S&P 0,426 / 0,390, oro A 0,472 / 0,542, oro B
  0,474 / 0,500, tutti NON ANCORA MISURATO. Il forex pooled (0,487 / 0,470, `n_cluster` ~600) cade nello stesso intervallo, con un campione
  6-20 volte piu' grande dei singoli simboli del 01/10.

## 8. Che cosa questa misura NON dice (limiti, uno per uno)

- **Solo 6 coppie su 28**: manca CHF, NZD e molti incroci; 4 coppie su 6 contengono USD (il cluster tiene conto della correlazione,
  non la elimina). **Nessun verdetto sul "forex" in generale**.
- **Un solo feed (Oanda) e un solo periodo (2005-2020)**; nessun confronto di feed (A e B non si concatenano). Il feed non e'
  quello su cui Claudio opera (BCM / altri broker): barre H4 e D1 dipendono dal broker (NYCLOSE misurata come sensibilita').
- **Non e' la sua regola**: ordini limite sulla linea, parziali, stop in pip, "uno prima e uno dopo", contesto a occhio, filtri di
  sessione. Il "primo tocco" qui e' d'ombra dopo 20 barre pulite con una a >= 1 ATR; altre definizioni (tocco di corpo, 10 barre,
  distanza 0,5 ATR) **non sono misurate**.
- **Il nulla di un lato non e' il nulla del motore**: niente PF, niente gestione dell'uscita; la sedia `ABTG_EMA200` non e'
  spiegata ne' smentita (stessa conclusione del 01/10, sez. 0-ter di quel referto). Questa misura **non archivia niente** (mancano
  PF, DD, gestione, simboli gemelli del forex intero).
- **D1 e' aperto, non chiuso**: `n_cluster` 86 / 84. **L'asse a D1 e' difettoso nella mappa** (sez. 5).
- **Il surrogato permuta le coppie in modo indipendente**: la banda puo' essere piu' stretta del vero (guardia: IC a blocchi di mese).
- **Le classi di regime hanno pochi eventi a D1** (17-49 per classe): nessuna lettura possibile.

## 9. Che cosa manca, e come si chiude (preparato, NON consegnato)

**Obiettivo:** portare D1 (e il resto dell'universo) a `n_cluster` >= 150 e togliere "6 coppie su 28".
Ordine di grandezza [DERIVATO da questa corsa]: D1 fa **1,17 / 1,13 primi tocchi per lato per coppia-anno**; HistData dal 2007 e'
~17,4 anni utili a D1 (19,7 meno 2,3 di riscaldamento): **22 coppie x 17,4 = 383 coppia-anni -> ~450 / 430 eventi per lato**;
**bastano ~140 coppia-anni (circa 8 coppie) per 150 cluster**.

| voce | contenuto |
|---|---|
| **dove** | **finestra PowerShell sul PC di backtest `DESKTOP-H4D7CAJ`** (NON il VPS, NON un terminale MT5: nessun terminale viene aperto, chiuso o toccato; i round restano fuori dal VPS finche' la challenge e' viva, firma del 21/09) |
| **fonte** | HistData M1 (zip annuali `HISTDATA_COM_ASCII_<COPPIA>_M1_<AAAA>.zip`, anno in corso mensile), dal PC, stessa meccanica gia' riuscita il 15/08 e il 22/09 con `backtest_pipeline/oro_m1_histdata.ps1 -Simbolo <COPPIA> -Da 2007 -A 2026` |
| **coppie** | le 22 mancanti: AUDCAD AUDCHF AUDNZD CADCHF CADJPY CHFJPY EURAUD EURCAD EURCHF EURGBP EURNZD GBPAUD GBPCAD GBPCHF GBPJPY GBPNZD NZDCAD NZDCHF NZDJPY NZDUSD USDCHF USDJPY |
| **anni** | **solo >= 2007** (la regola USA dell'ora legale e' quella dello strumento; 2000-2006 non entrano). Anni disponibili per coppia: **[NON MISURATO]**, li dira' il download e il referto li scrive |
| **formato** | `AAAAMMGG HHMMSS;O;H;L;C;V`, **ora di New York con ora legale** (shift +5 misurato in casa su 8 simboli su 8, forex incluso, 15/08); lo strumento converte in UTC con `ny_to_utc` |
| **dimensione** | ~430 zip, **2-4 GB** [INFERITO, non misurato] + cache `.npz` ~220 MB per 5,5 M barre (qui) quindi ~280 MB a coppia dal 2007, ~6 GB per 22 coppie [DERIVATO]; **spazio libero sul PC [NON MISURATO]; il tempo di scarico e' [NON MISURATO]** (HistData e' lento e a token) |
| **calcolo** | `python backtest_pipeline/ema200_forex28.py --corri B --zip <cartella zip> --cache <cartella> --uscita <cartella>` (autotest prima, G-OROLOGIO pooled sul feed HistData, G-DATI, stessi criteri). Tempo [DERIVATO]: ~538 s per 6 coppie con 4 processi -> **~35-60 minuti** per 22 |
| **requisito da verificare per primo** | **numpy sul python del PC [NON MISURATO]**: se manca, la riga deve fermarsi e dirlo (non installare niente da sola) |
| **uscita** | `EMA200_FOREX28_B_SINTESI.csv`, `_ASSE.csv`, `_COPPIE.csv`, `REFERTO_B.txt`, `autotest.log`, `EVENTI_*.npz`: **copiati sul Desktop del PC e zippati con `Compress-Archive`**, con l'elenco dei file attesi stampato in console (regola delle righe di lancio) |
| **riga di lancio** | **NON scritta**: deve avere l'`irm` pinnato a un commit, il controllo del marcatore, la guardia sul nome macchina, ASCII puro, la raccolta sul Desktop, e passare `controlla_riga.py` + `controllo-preventivo` prima di qualunque consegna. Da scrivere solo se Claudio vuole la misura |
| **costo** | nessun euro; tempo macchina del PC di backtest (non del VPS) |
| **cosa NON fa** | non apre MT5, non scrive nei dati dei terminali, non tocca preset/EA/taglie; **se HistData cambia il sito non si insiste** |

Alternative per D1 gia' congelabili: (a) **mappa D1 -> W1** per l'asse (warm-up ~3,85 anni: usabile solo dal 2009 in poi sulla fonte A);
(b) **piu' anni sulle stesse sei** (BCM nativo dal 1993-1999, ma senza esportatore in repo: nuovo MQL5, fuori perimetro).

## 10. File prodotti

- `backtest_pipeline/ema200_forex28.py` (involucro, MARCATORE_EMA200_FOREX28_v1) e `backtest_pipeline/verifica_indipendente_forex28.py`.
- `backtest_pipeline/risultati_archivio/EMA200_H4_D1_FOREX28_2026-10-03/`: `EMA200_FOREX28_A6_SINTESI.csv` (tutte le righe: 4 TF x 2 lati x 6 celle
  + regimi + sensibilita'), `_ASSE.csv`, `_COPPIE.csv`, `EVENTI_{H4,D1,H1,M30}.npz` (eventi senza prezzi), `REFERTO_A6.txt`, `corsa_A6.log`,
  `corsa_A6_tentativo1_crash_D1.log`, `autotest.log`, `verifica_indipendente.log`, `ora_corsa.txt`.
- Nel repo **non** entrano prezzi grezzi (il mirror e' GPL-3.0 sul repository, dati Oanda con condizioni d'uso [NON VERIFICATE]).
