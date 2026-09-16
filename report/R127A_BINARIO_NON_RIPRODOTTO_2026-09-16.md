# 🔍 R127a girato l'11/09, letto solo il 16/09 — e non torna

**Trovato da**: agente `mql5-ea-developer` lanciato nel turno continuo del 16/09
per un round che si credeva ancora da scrivere (`InpSLBufferPips` su `970913`,
`ABTG_SupRev_NAS_H1_Ottimizzato`, NASUSD H1). Verificato alla fonte da me
(sessione principale) prima di scrivere questa nota — niente qui e' dal
riassunto dell'agente senza controllo diretto.

## Il fatto, con i numeri

- `R127a_slbuffer_NASUSD.txt` e' **armato** in `backtest_pipeline/coda/CODA.txt`
  (r.1303, pin `3a0577fe`) dal 13/09.
- **E' girato** il 14/09: `backtest_pipeline/coda/referti/CODA_07_desktop_20260915_033005.log`
  r.3322-3403, marcato "ESITO: ROUND GIRATO", 18 passate (9 IS + 9 OOS), RILIEVI 0.
- **Nessuno lo ha mai letto**: la cifra `1.61295` (PF della cella-ancora in OOS)
  non compare in nessun altro file del repo. I due CSV del round non sono mai
  entrati in `backtest_pipeline/risultati_prove/ABTG_SupRev_NAS_H1_Ottimizzato/`
  (li' ci sono solo `_IS`/`_OOS`/`_r3` dell'archivio dell'08/08 — verificato con
  `ls`). **Rimediato oggi**: copiati in `backtest_pipeline/risultati_prove/r127a/`
  (stesso nome file del log, zero modifiche al contenuto).

## Il problema vero: l'ancora non torna

La cella `InpSLBufferPips=3` di R127a doveva riprodurre l'ancora dell'archivio
dell'08/08 (stessa cella, stessa sedia). Confronto cifra per cifra:

| finestra | archivio (08/08) | R127a (14/09) | scarto PF |
|---|---|---|---|
| IS | PF 1,34237 · n 69 | PF 1,29758 · n **71** | **-3,34%** |
| OOS | PF 1,68815 · n 86 | PF 1,61295 · n **87** | **-4,45%** |

La tolleranza congelata per questo tipo di confronto e' +/-0,5%: qui lo scarto
e' **6,7x-8,9x** la tolleranza, su un `n` diverso (non identico). Per la
regola di casa ("n identico, PF entro tolleranza, altrimenti il banco e'
sporco e il round si ferma") **R127a e' fermo per costruzione**, non
promuovibile.

**La causa strutturale, misurata**: il CSV dell'archivio ha **49 colonne** e
NON ha `InpUsaGuardian` (verificato: `head -1 ..._IS.csv | tr ',' '\n' | wc -l`
-> 49); quello di R127a ne ha **50** e ce l'ha. Sono due binari diversi
dell'EA. **La causa del perche' sono diversi non e' stabilita** — l'agente ha
escluso un candidato (il pavimento del lotto non poteva essersi acceso: servirebbe
uno stop oltre ~390 punti indice, il piu' largo mai misurato e' 151,9) ma non
ha isolato quale dei 3 candidati restanti sia quello vero.

## Perche' conta per la sedia vera

`backtest_pipeline/REGISTRO_TEST.md` r.171 (voce S5v, la sedia **970913**)
dichiara il contratto **PF 1,57 · DD 1,17% · n 155** su questa stessa sedia.
Quel contratto viene da un binario che, per quanto misurato qui, **non e' piu'
quello in campo oggi** (differenza di 1 colonna/input, causa non chiusa).
🔴 **Non e' un DD fantasma nuovo e non tocca il rischio vivo per costruzione**
(il PF cambia di pochi punti, non il segno), ma e' un contratto che va
RIPRODOTTO sul binario di oggi prima di fidarsene per un'altra decisione.

## Cosa manca (certificato di morte incompleto, non "morto")

1. Isolare la causa dei 3 candidati restanti (differenza di binario).
2. Riprodurre la cella viva (`InpSLBufferPips` al valore in campo) sul binario
   di oggi e riscrivere PF/DD/n nel censimento contratti.
3. Decidere se la voce S5v di `REGISTRO_TEST.md` resta valida o va marcata
   `[DA RIPRODURRE]` fino al punto 2.

Costo per il punto 1-2: una singola passata sul banco (non un round a griglia),
perche' la cella e' gia' nota — dichiarato dall'agente come lavoro a parte, non
fatto qui per non uscire dal perimetro del compito assegnato oggi.
