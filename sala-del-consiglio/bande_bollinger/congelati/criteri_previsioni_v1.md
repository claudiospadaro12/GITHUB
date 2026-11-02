# Criteri di verdetto e PREVISIONI — v1 (scritti prima dei risultati)

## Criteri (test primario, specifica_v1 sez. 9)
- C1: N trade >= 30. Se N < 30 -> INCONCLUSIVO (stop).
- C2: R medio > 0 e limite inferiore IC90 > 0.
- C3: win rate >= breakeven + 5 punti percentuali.
- C4: robustezza: R medio > 0 lasciando fuori uno alla volta ciascuno dei 3 periodi E ciascuno dei 2 strumenti (5 sottoinsiemi).
- C5: R medio > 0 con spread x2 (SPREAD_BP raddoppiato).
- C6: placebo S/R: R medio reale >= 90° percentile dei placebo (p <= 0,10).

## Classi di verdetto
- CONFERMATO: C1 e tutti C2–C6.
- INDIZIO: C1 e C2 vere ma almeno una tra C3–C6 falsa.
- NESSUN VANTAGGIO RILEVANTE: C1 vera, R medio <= 0 e limite superiore IC90 <= +0,10 R.
- NON DIMOSTRATO: C1 vera e nessuna delle classi precedenti.
- INCONCLUSIVO: N < 30.
Nota: B1 (solo bande) e' descrittivo: se B1 e' meglio del primario lo si riporta, ma non cambia la classe.
Qualunque verdetto vale SOLO per H1 su Nasdaq100/S&P500 CFD (dati `_EXT` clonati, 2015, 2020, 2025–26) con queste regole; non "smentisce" la strategia di Fasciano (che e' discrezionale, forex, S/R scelti a occhio).

## Previsioni (C0, prima di vedere nulla; il numero di eventi NON e' stato contato)
- N trade primario: <30 = 35%, 30–59 = 40%, >=60 = 25%.
- Win rate primario: mediana 50%, 80%: 35–65%. R medio: mediana 0,00, 80%: −0,35 / +0,35.
- Verdetto: CONFERMATO 6%, INDIZIO 10%, NON DIMOSTRATO 34%, NESSUN VANTAGGIO RILEVANTE 28%, INCONCLUSIVO 22%.
- Long meglio di short (deriva rialzista degli indici): 70%.
- B1 (solo bande) con R medio >= primario: 55%.
- Motivazioni: target = mediana a ~3 sigma dal prezzo (lontano, trend frequente dopo uscite dalle bande 37/3), stop largo 1,5 ATR oltre l'estremo; pochi segnali per 3 periodi.
