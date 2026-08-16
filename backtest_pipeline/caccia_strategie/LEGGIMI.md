# `caccia_strategie/` — i dossier della caccia fuori casa

Ci scrive l'agente **`cacciatore-strategie`** (`.claude/agents/`). Un file per
battuta di caccia: `CACCIA_<AAAA-MM-GG>.md`.

## Cosa c'e' dentro un dossier

1. **Cosa e' stato sfogliato**, fonte per fonte, con l'esito del **controllo
   positivo**. Una fonte che non risponde si dichiara nulla: un buco scritto
   vale piu' di una lista che sembra completa.
2. **I promossi**, con la scheda compilata (tesi, meccanica, gestione del
   rischio, bandiere rosse, costo di porting, punteggio).
3. **Gli scartati**, con una riga di motivo a testa — servono a **non
   ricercarli il giro dopo**. E' la parte che rende la caccia cumulativa.
4. **Cosa non si e' potuto vedere.**

## Le due regole che rendono questi file utili

- 🔴 **I numeri dichiarati dagli autori non contano.** Broker ignoto, periodo
  ignoto, quasi sempre OHLC e senza costi. Si riportano solo etichettati
  "dichiarato dall'autore, NON verificato", e non pesano sul punteggio.
- 🎯 **Si raccoglie la MECCANICA e la TESI, mai il risultato.** Il precedente
  e' `REFERTO_ALTA_VELOCITA_V1.md`: manuale di 38 pagine tradotto in un EA che
  compila al primo colpo e va **rosso 8 su 8 ai tick reali**. La macchina si
  traduce, l'edge no — il verdetto lo da' il nostro imbuto.

## Da qui in poi

Il candidato numero uno esce con un file prova in `backtest_pipeline/prove/`,
con **ipotesi e criteri scritti PRIMA dei numeri**. Da li' e' un round normale:
screening OHLC, poi verdetto a tick reali, poi il portafoglio.
