# BREAKING BAND (Fasciano) — riassunto operativo per chi la sta codificando
_Preparato il 13/08/2026 da chi l'ha gia' implementata, testata e portata
in forward. Da incollare all'assistente che scrive il codice._

## 1. LA DIREZIONE IN FASE 3 (il punto che ti serve confermato)
Due pattern DISTINTI, mai confonderli:

**CONTINUAZIONE (≈ "In-Bulge")**
- Bulge ribassista (espansione delle bande con impulso in GIU'):
  il prezzo ritraccia in SU fino a toccare la **banda OPPOSTA**
  (la superiore) → entrata **SHORT**, si riprende la discesa.
- Bulge rialzista: specchio esatto → tocco della banda inferiore
  → entrata **LONG**.
- Regola di morte (dalla guida): la continuazione MUORE se il prezzo
  torna sulla banda dell'impulso prima del segnale.

**INVERSIONE (≈ "Post-Bulge")**
- Stesso bulge ribassista, ma a espansione ESAURITA (le bande si
  stanno richiudendo): il **retest della banda dell'IMPULSO**
  (l'inferiore) → entrata **LONG**, contro l'impulso morente.
- Specchio per il bulge rialzista → SHORT sul retest della superiore.

Target (gestione "Leonardo pura"): la **mediana** (SMA20 delle
Bollinger). Semplice e misurabile; le varianti a doppio TP vengono dopo.

## 2. DUE PUNTI DOVE LA GUIDA SI CONTRADDICE (scelte da dichiarare)
1. "Bande in chiusura" per la continuazione: in un punto la guida lo
   pretende, in un altro mostra esempi in piena espansione. Scelta
   nostra: parametro on/off, cosi' si misura invece di discutere.
2. Fine della fase bulge: "larghezza sotto la soglia" vs "esaurimento
   dell'espansione". Scelta nostra: esaurimento (la larghezza smette
   di crescere), perche' la soglia fissa tagliava fuori meta' dei casi.

## 3. LE TRE TRAPPOLE GIA' PAGATE (risparmiatele)
1. **Invalidazione troppo severa**: 1 candela contraria da 1,0x ATR
   uccideva il 99% delle inversioni. La guida dice "candelE impulsivE"
   (PLURALE) e ~1,5x: servono piu' candele E piu' grandi.
2. **Direzione dal colore della prima candela** del bulge: sbagliato.
   La direzione si prende dal MOVIMENTO NETTO dell'intera espansione.
3. **Tetto di durata auto-colpente**: un limite fisso di N candele
   sulla fase, combinato con le altre condizioni, matematicamente non
   lasciava sopravvivere quasi nessun setup. Controlla che i tuoi
   filtri non si annullino a vicenda: un contatore diagnostico che
   stampa DOVE muore ogni setup (quanti bulge visti → quanti passano
   il filtro X → quanti arrivano all'entrata) vale oro.

## 4. COSA DICONO I NOSTRI NUMERI (walk-forward, tick reali)
- La direzione descritta al punto 1 e' CONFERMATA dai test: su un
  cambio la sola CONTINUAZIONE ha reso fuori campione con PF ~3,9;
  un altro ha retto col combinato (PF ~1,75).
- MA: su un terzo cambio la CONTINUAZIONE faceva PF ~88 IN campione
  e 0,44 FUORI. **La strategia e' reale, la profittabilita' e'
  specifica del simbolo**: va misurata mercato per mercato, mai
  assunta.
- L'In-Bulge (continuazione) e' il pattern PIU' rischioso dei due,
  come dice lo stesso Fasciano: entra quando l'espansione e' ancora
  viva e puo' travolgerti.

## 5. IL METODO (senza questo, i punti sopra non salvano)
1. Criteri di promozione scritti PRIMA di vedere i numeri.
2. Dividi il periodo: in-sample per scegliere, out-of-sample per
   giudicare — e l'OOS non si riguarda per riscegliere.
3. MAI prendere la cella migliore dell'ottimizzazione: si prende il
   CENTRO di una regione di celle buone. La migliore in-sample e'
   stata la peggiore out-of-sample piu' volte di quante ne possiamo
   contare.
4. Verdetti solo a tick reali (spread e riempimenti veri); l'OHLC
   serve solo a fare una prima scrematura di frequenza.
5. Prima demo piccola in forward, poi taglie vere. Nessuna eccezione.

_Nota finale: le soglie numeriche (moltiplicatori di larghezza, ATR,
durate) NON sono nel vangelo di Fasciano — sono tarature. Le nostre
sono state scelte per massimizzare la FREQUENZA dei setup (mai il
profitto!) e ricalibrate sul nostro broker. Sul tuo broker/simboli
vanno ricalibrate allo stesso modo._
