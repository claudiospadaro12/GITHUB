# UBS volatility M15 sugli indici, cloni con tick size 0,01 (22/11/2026): risultati
Sorgente: `ANNO_ORO_GRADINI_UBSCLT_20261122_0751.zip` (17 passate su 25: 15 volatility M15 complete, 2 Indicement; le altre 8 non partite: MT5 bloccato sul salvataggio report). **Modello 1 (barre da 1 minuto, NIENTE tick), lotto 0,1, 100.000 EUR, 01/01/2025-13/11/2026.** Criteri: `UBS_INDICI_VOL_M15_CRITERI_2026-11-21.md` (scritti prima).
**Ipotesi sugli "Invalid stops": CONFERMATA.** Con tick size 0,01 gli ordini passano (0 rifiuti in 15/15 passate, 1 su un set); prima: 123 rifiuti e zero operazioni.

| Set | Ops | PF | P (01/01-12/05/2025) n / PF | Q (13/05/2025-) n / PF | Netto EUR | Netto/DD | Mesi >= 0 | Ops Wim (tick) / rapporto | G1 | G2 | G3 | G4 | G5 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| US30_U3V12 | 120 | 1.12 | 21 / 0.42 | 99 / 1.73 | 93 | 0.3 | 65% | 106 / 0.93 | NO | NO | NO | si | si |
| US30_U3V08 | 102 | 1.15 | 19 / 0.64 | 83 / 1.58 | 100 | 0.5 | 65% | 91 / 0.91 | NO | NO | NO | si | si |
| US30_a | 94 | 1.69 | 20 / 0.69 | 74 / 2.42 | 394 | 3.1 | 70% | 90 / 0.82 | si | NO | si | si | si |
| US30_b | 73 | 12.11 | 21 / 24.35 | 52 / 9.58 | 291 | 45.5 | 91% | 77 / 0.68 | si | si | si | si | si |
| US30_c | 110 | 1.57 | 22 / 1.96 | 88 / 1.48 | 172 | 2.1 | 78% | 92 / 0.96 | si | si | si | si | si |
| US30_g | 113 | 2.03 | 20 / 1.31 | 93 / 2.47 | 293 | 2.7 | 83% | 102 / 0.91 | si | si | si | si | si |
| SPX_U5W10 | 388 | 1.04 | 104 / 1.4 | 284 / 0.96 | 13 | 0.2 | 56% | 282 / 1.01 | NO | NO | NO | NO | si |
| SPX_a | 71 | 1.26 | 16 / 2.2 | 55 / 1.12 | 74 | 0.9 | 61% | 35 / 1.57 | si | si | NO | si | NO |
| SPX_c | 69 | 1.21 | 16 / 2.68 | 53 / 0.91 | 182 | 0.6 | 61% | 36 / 1.47 | si | NO | NO | si | NO |
| SPX_g | 348 | 1.19 | 110 / 1.32 | 238 / 1.12 | 311 | 1.5 | 61% | 162 / 1.47 | NO | si | NO | si | NO |
| NAS_A | 128 | 1.03 | 25 / 0.9 | 103 / 1.07 | 51 | 0.2 | 52% | 103 / 1.0 | NO | NO | NO | NO | si |
| NAS_B | 137 | 1.07 | 27 / 0.76 | 110 / 1.14 | 83 | 0.3 | 43% | 114 / 0.96 | NO | NO | NO | NO | si |
| NAS_C | 139 | 1.1 | 28 / 0.83 | 111 / 1.16 | 120 | 0.5 | 48% | 100 / 1.11 | NO | NO | NO | NO | si |
| NAS_D | 124 | 1.06 | 24 / 0.97 | 100 / 1.08 | 80 | 0.4 | 52% | 89 / 1.12 | NO | NO | NO | NO | si |
| NAS_E | 160 | 1.09 | 30 / 0.55 | 130 / 1.21 | 107 | 0.4 | 39% | 131 / 0.99 | NO | NO | NO | NO | si |

**Candidati provvisori (G1-G5 tutti si): `US30_VOL_M15_b`, `US30_VOL_M15_c`, `US30_VOL_M15_g`** (73-113 operazioni; PF 12,11 / 1,57 / 2,03; positivi anche nel segmento P, fuori dalla finestra di Wim). Sono **tutti e tre US30 e della stessa famiglia**: non sono tre prove indipendenti. **`US30_VOL_M15_b` ha PF 12 e perdite medie di 1,6 EUR contro vincite di 5,6: probabile effetto del Modello 1 (barre da 1 minuto) o di uno stop molto stretto: da verificare prima di crederci.**
**Non ancora fatto per i candidati:** controllo tick/1 minuto (V3: i cloni non hanno tick), perturbazione dei parametri (V2), hold-out; solo 22 mesi, un solo regime (Dow in rialzo). US500 e Nasdaq: nessun candidato (PF 0,9-1,26 in Q, rapporto operazioni fuori range per SPX_a/c/g).
**Previsioni scritte prima (`UBS_INDICI_VOL_M15_CRITERI`):** V-1 (>=10 su 15 entro +-35% di Wim): **si, 12 su 15**. V-2 (mediana PF Q >= 1,0): **si (1,16)**; >= 1,2: no. V-3 (almeno 1 candidato / almeno 3): **si / si (3)**. V-4 (US30 sopra US500 e Nasdaq): **si**. V-5 (i set con PF di Wim >= 2 scendono sotto 1,5): **no** (US30_a Q 2,42; US30_g Q 2,47). V-6 (almeno meta dei set con PF P >= 1,0): **no** (7 su 15).
**Indicement C0 su `_EXT_T` (2010-2019), solo 2 passate su 10 partite:** US100_1 KO (qualita storia 4%) 2.771 operazioni PF 1,89; US500f 890 operazioni PF 3,00 (qualita 14%): **non interpretabili**: la qualita della storia `_EXT` e bassissima, spread 0, nessun costo. Le altre 8 da rifare.
