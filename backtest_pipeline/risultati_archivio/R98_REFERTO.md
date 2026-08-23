# R98 — REFERTO: l'intraday momentum sul NASUSD non paga. 0/6. BOCCIATO.

**Data verdetto: 23/08/2026 mattina. Corsa: tick reali, pin `81d1314`,
zip `R98_MOMENTUM_NASUSD_CORSA_20260823_0654`, durata 0,3 ore, 32 passate,
ESITO tecnico OK (nessun problema di corsa). Criteri FIRMATI il 22/08
(opzione A: PF OOS >= 1,20 + cancello zero S0) — letti prima dei numeri.**

## I gate, prima dei numeri
- Autotest: 45x4 PASS, 0 FAIL. Conversione: citata da R97 (=100), non rimisurata.
- Canarino MISURATO (cella nuda): **149 operazioni IS, 261 OOS** (attese
  [INFERITE] ~180/~270). n IS sotto 150: cancello S4 gia' zoppo in partenza
  sulla nuda; sotto ~100 no, quindi il merito IS si legge, con prudenza.
- **CANCELLO ZERO S0 — la bocciatura secca e' qui.** Il risultato medio per
  operazione della cella nuda su TUTTA la finestra e' **−0,31 punti indice**
  (410 operazioni), GIA' al netto dello spread. La condizione firmata
  "lordo >= 3x spread" diventa "netto >= 2x spread": con un netto NEGATIVO,
  **nessuno spread positivo puo' mai soddisfarla**. S0 e' matematicamente
  impossibile da superare. I criteri (par. 5.2) la chiamano bocciatura
  secca, ed e' una RISPOSTA del round, non un guasto: la macchina ha
  funzionato perfettamente, il motore no.

## I numeri (IS 2024.09.26–2025.06.09 · OOS 2025.06.10–2026.06.30)

| cella | IS Profit | IS PF | n IS | OOS Profit | OOS PF | OOS DD | n OOS | cancelli |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| **rif (nuda, il paper)** | **−10.476** | 0,60 | 148 | +6.586 | 1,24 | 4,7% | 261 | S3 KO, S4 KO |
| a (no overnight) | +5.777 | 1,22 | 165 | **−6.459** | 0,80 | 9,4% | 261 | S1 KO, S2 KO |
| b (secondo segnale) | −7.447 | 0,48 | 72 | +5.526 | 1,48 | 2,1% | 133 | S3 KO, S4 KO |
| c (soglia 0,10) | −7.458 | 0,65 | 132 | +5.342 | 1,22 | 4,4% | 229 | S3 KO, S4 KO |
| d (SLatr 3,0) | −6.726 | 0,61 | 148 | +4.305 | 1,24 | 3,2% | 261 | S3 KO, S4 KO |
| e (slippage 1pt — misura, non cella) | −10.533 | 0,60 | 148 | +6.568 | 1,24 | 4,7% | 261 | (fragilita': scala poco) |

Diagnostiche sui lati (si DICHIARANO, non scelgono — regola R52):
- solo SHORT: IS −7.420 (PF 0,37), OOS −987 (PF 0,92) — **gli short perdono ovunque**.
- solo LONG: IS −3.316 (PF 0,78), OOS +7.688 (PF 1,54, DD 2,0%) — i long
  volano in OOS e perdono comunque in IS.

**VERDETTO: 0/6. Nessuna cella passa i cancelli firmati. S0 impossibile.
BOCCIATO.**

## La lettura onesta — perche' l'OOS verde NON salva il round
1. **La falsificazione firmata (par. 1) e' scattata**: S0 fallito -> "la
   risposta e' NO e il capitolo si chiude. Niente 'riproviamo con un'altra
   soglia'".
2. **IS e OOS si contraddicono in modo speculare**: la nuda perde forte in
   IS e vince in OOS; la variante senza overnight (r98a) fa l'ESATTO
   CONTRARIO (vince in IS, perde in OOS). Due predittori cugini che si
   ribaltano fra le due meta' della finestra non sono un edge: sono rumore
   di regime. Un segnale vero non cambia segno cambiando meta' campione.
3. **Il verde OOS e' spiegato dal regime, non dal segnale**: la diagnostica
   dice che TUTTO il verde OOS sta nei long (solo-long PF 1,54; solo-short
   perde anche in OOS) dentro un 2025-26 prevalentemente rialzista.
   Comprare il Nasdaq alle 20:30 in un anno che sale e' il mercato, non il
   motore. E "teniamo solo i long" e' esattamente la decisione che R52
   vieta di prendere guardando i risultati.
4. Il paper non e' "sbagliato": SPY 1993-2013 non trasferisce su NASUSD a
   BCM nel 2024-2026, coi nostri costi. Come da par. 6: non giudichiamo il
   paper, misuriamo il nostro strumento.

## La conclusione di capitolo — e vale piu' dei due referti presi da soli
**Due meccanismi radicalmente diversi** (breakout d'apertura R97, momentum
di chiusura R98), **entrambi bocciati con campione pieno sullo stesso
mercato in due giorni.** Come scritto nei criteri firmati (par. 6): "due
meccanismi diversi bocciati sullo stesso mercato dicono qualcosa sul
mercato". **La seconda caccia sul NASUSD si chiude qui.** Il Nasdaq 2024-26
a BCM, coi nostri costi e nelle fasce che sappiamo misurare, non ci ha dato
un edge — e smettere di cercarlo li' e' una decisione misurata, non una
resa. Le risorse (round, macchina, attenzione) tornano dove gli edge
misurati ESISTONO: Dow (R88), DAX, oro, e la coda dei round gia' firmati
(R95 LiquiditySweep JPY, R96 CrossEmaApertura).

L'EA `ABTG_IntradayMomentum` resta in casa, sano e testato: se un giorno
il regime cambia (il paper dichiara che il momentum intraday si rafforza
in volatilita'/recessione), la macchina per rimisurarlo e' gia' pronta —
riga di lancio, driver, criteri. Un motore in garage non e' un motore
buttato.
