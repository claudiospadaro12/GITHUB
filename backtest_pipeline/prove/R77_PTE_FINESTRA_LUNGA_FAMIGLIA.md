# R77 — LA FINESTRA LUNGA SULLA FAMIGLIA: la selezione valida regge su USDJPY?

**Criteri congelati PRIMA dei numeri. 17/08/2026, dopo R76.**

## Perche' esiste

R76 ha aperto ventisei anni: con `-DaQuando 2000.01.01 -FrazioneIS 0.5` il
tester legge davvero (n IS **440-631**, n OOS **461-695** su GBPUSD), e **per
la prima volta in nove round la SELEZIONE non e' sospesa** dal punto A.

Su GBPUSD la cella scelta col metodo (**centro dell'altopiano, `buf 25 / TP
2,0`**) ha battuto la viva **su entrambi i fronti**: OOS **+8.919 contro
+5.747**, DD **8,99% contro 16,11%**.

👉 **Ma un simbolo non e' una famiglia.** In R71, con campione valido, i due
cambi si erano **contraddetti** sulla domanda della finestra. Qui si chiede
la stessa cosa alla seconda gamba.

## Le tre domande, scritte adesso

1. 🎯 **Su USDJPY la selezione col metodo batte la viva su entrambi i fronti,
   come su GBPUSD?**
   - SI  -> **verdetto di famiglia**: la taratura viva del buffer e' sbagliata
     su tutti e due i cambi, misurata su tredici anni per parte con campione
     pieno. E' la cosa piu' forte che questa serie possa produrre in OHLC.
   - NO  -> **un simbolo per parte, di nuovo**, ed e' la terza volta
     (R71 finestra, R72/R73 merito, questa). A quel punto la conclusione
     onesta e' che **la PTE non ha una taratura di famiglia**, e va detto.

2. 📉 **Il DD scende col buffer anche qui, sulla finestra lunga?**
   Sarebbe la **quindicesima e sedicesima** conferma. Se si rompe proprio ora,
   si rompe il risultato piu' replicato del progetto e si scrive.

3. 🧱 **A 0,65% di rischio, la config viva sfonda il muro del 10% anche su
   USDJPY?** Su GBPUSD lo fa (13,7%). E' un fatto di RISCHIO, quindi si
   giudica anche se il merito e' incerto (regola B).

## Criteri

0. **n >= 150 in IS e in OOS**, altrimenti la selezione torna sospesa e si
   dichiara. Atteso ~500-700 (USDJPY fa piu' trade di GBPUSD).
1. La cella si sceglie **SOLO sull'IS**, **centro dell'altopiano MAI il picco**
   (regola meccanica: le tre righe di buffer col miglior profitto medio IS,
   si prende **quella di mezzo**; poi il TP migliore su quella riga).
2. La candidata entra in discussione solo se **abbassa il DD SENZA perdere
   profitto OOS** contro la viva (`buf 5 / TP 2,0`).
3. 🔴 **NESSUNA MODIFICA IN FORWARD.** E' **OHLC**, e R73 a tick reali dice il
   contrario su due anni. Il conflitto fra i due banchi **resta aperto e non
   si risolve con questo round**.

## Limiti dichiarati

- **OHLC.** R57 ha misurato che cambiando solo il modello il segno di questo
  motore si ribalta.
- 🔴 **Il round a tick reali su tredici anni NON SI PUO' FARE**: i tick BCM
  partono dal 2024.07.05. **O la finestra lunga o il riempimento vero.**
- L'OOS di R77 (2013-2026) **contiene** quello di R72/R73 (2025-2026):
  **non sono misure indipendenti** e non si sommano.
- Il Dow resta fuori: li' il broker ha 21 mesi e `COMPLETO`, non c'e' tetto
  da alzare. Serve Dukascopy.

## Come si lancia

Stessa griglia di R68/R71/R76 (28 celle), stesso file prova
`PTE_FINESTRA_VECCHIA_O_RECENTE.txt`, cambia solo il simbolo:

    -Simbolo USDJPY -DaQuando 2000.01.01 -FrazioneIS 0.5 -Modello 1
