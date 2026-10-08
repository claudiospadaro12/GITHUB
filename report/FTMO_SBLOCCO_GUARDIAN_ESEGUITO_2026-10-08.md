# Trial FTMO 1514806751 -- sblocco del Guardian ESEGUITO (08/10/2026)

Firma di Claudio (parametro di rischio): **`InpTotalDDPct` 9.3 -> 9.9** ("SBLOCCHIAMO IL GUARDIAN E SE USCIAMO PAZIENZA"; poi "OK. HO MESSO 9.9"). Procedura: `report/FTMO_SBLOCCO_GUARDIAN_PROCEDURA_2026-10-08.md` (cancello PASS con riserva). Terminale: `C:\FTMO`, conto 1514806751, Id processo 9160 (riconosciuto con `Get-Process terminal64`; gli altri tre aperti sul VPS erano 10105439 REALE, 50503392, 50503635, non toccati). Ore = ora locale del PC (log Esperti), dalle schermate di Claudio.

| ora | evento (fonte: scheda Esperti / F3 / pannello) |
|---|---|
| 09:06 | passo 0: Id 9160 = 1514806751 `C:\FTMO\terminal64.exe` |
| 09:16-09:19 | passo 1 (solo guardare): pannello `CHALLENGE FALLITA`, DD 14916.29 (9.32%/limite 9.3%), picco 160036.61; F3: FAILED=1.0, PAUSA_GIORNO=1791451014, PAUSA_FINO=1794046715, BLOCKDAY=0.0, DAYKEY=2026280, START=160000.0 |
| 09:25:25 | Algo Trading spento |
| 09:26:01 | Guardian reinizializzato: `Saldo iniziale=160000.00 DailyLoss=4.5% DD=9.9% (statico) Azione=CHIUDI+BLOCCA`; `filo verificato: 5 GlobalVariable su 5` |
| 09:27:17 | Algo Trading riacceso; 09:29:23 spento di nuovo |
| ~09:30 | passo 3: cancellata `ABTG_GUARD_1514806751_FAILED`; 09:31:55 `stato=OK pausa=ON`, pannello `Stato: OK - operativo`, nessun `DD TOTALE SFONDATO` |
| ~09:34 | passo 4: cancellate `ABTG_PAUSA_GIORNO_1514806751` e `ABTG_PAUSA_FINO_1514806751`; 09:34:20 MaxMinNotte DAX: `via libera, il blocco e' rientrato`; stessa riga: `cutoff ingressi superato: pendenti cancellati` |
| 09:35:00 | `DAX Apertura EU: RETEST armato: range 24915.94-24821.84, buffer 500 pt` (rischio configurato 2.00%) |
| dopo 09:35 | Claudio: "ALGO TRADING ACCESO" (le sedie possono mandare ordini) |

## Numeri a fine sblocco
Equity 145.083,71 · pavimento del Guardian a 9,9% = 144.160 (margine 923,71) · muro FTMO 144.000 (margine 1.083,71) · rischio configurato DAX Apertura EU / MaxMin DAX 2,00% = ~3.000-3.300 EUR a stop pieno: **un solo stop pieno su GER40 chiude il trial**, e Claudio lo sapeva.

## NON verificato
- Stato di F3 dopo le cancellazioni (confermato indirettamente dalla riga di MaxMinNotte, non da una schermata).
- Salvataggio del profilo (File > Profili): chiesto, risposta non vista. Se non salvato, un riavvio ricarica 9.3 dal `.chr` e il Guardian rimette FAILED.
- Prima riga periodica `stato=OK pausa=off` del Guardian: da leggere in `CODA_09` della notte.
