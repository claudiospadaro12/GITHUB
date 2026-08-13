# TESI — GAP-FILL DEL WEEKEND (scritta PRIMA di qualunque numero, 13/08/2026)

## La fonte (e quanto e' completa)
Emiliano, live 19.04: i gap di apertura domenicale "si devono
riallineare" — EURUSD ~25 pip tipici, coppie yen ~13, DAX 1,5-2,5%.
E' il 🥇 delle novita' del CATALOGO_STRATEGIE_CORSO: nessun nostro EA
lo copre. **Fonte PARZIALE**: il principio e' chiaro (mean reversion
del gap verso la chiusura del venerdi'), ingresso/stop/tempi NON sono
specificati dal corso. Tutto cio' che segue sotto "SCELTA NOSTRA" e'
nostro e va trattato come parametro da misurare, non come verita'.

## Il meccanismo (ipotesi)
Il gap del weekend e' un dislivello di prezzo SENZA scambi: nessun
volume l'ha costruito, quindi nessun volume lo difende. La chiusura
del venerdi' e' l'ultimo prezzo "vero" contrattato: il mercato tende a
tornarci per riprezzare in continuita' (fill). ATTESA: il fill e' un
fenomeno RAPIDO o non e' — se il gap non chiude nelle prime ore/giorni,
e' un gap di rottura (news, repricing) e insistere e' controtrend puro.

## Meccanica dell'EA (ABTG_GapFill)
- **GUIDA (dal corso)**: direzione SEMPRE contro il gap, target il
  riallineamento (chiusura del venerdi').
- **SCELTA NOSTRA — misura**: gap = primo prezzo della nuova settimana
  vs close dell'ultima barra della settimana precedente (rilevato dal
  cambio-settimana sulle barre del grafico, robusto ai diversi orari di
  apertura per simbolo: forex domenica sera server, indici lunedi').
- **SCELTA NOSTRA — filtro dimensione**: gap minimo E massimo in
  frazioni di ATR(D1,14): sotto il minimo lo spread si mangia tutto;
  sopra il massimo e' un gap di rottura (news) e il riallineamento non
  e' piu' il caso base. Entrambi parametrici, 0=off.
- **SCELTA NOSTRA — target parametrico**: % del gap da riempire
  (50/75/100). Il 100% = fill pieno alla chiusura del venerdi'.
- **SCELTA NOSTRA — stop**: multiplo del gap oltre l'apertura (1,0x =
  rischio simmetrico al gap) oppure ATR — parametrico.
- **SCELTA NOSTRA — time-stop**: se il fill non arriva entro N ore,
  flat. Coerente con l'ipotesi "rapido o niente". Parametrico.
- Un ciclo a settimana per simbolo, rischio % sul conto, magic/commento
  standard, export OnTester (stesso binario degli altri EA) + funnel
  diagnostico `[GAP-FUNNEL]` (settimane osservate → gap sopra soglia →
  entrate → fill / time-stop / SL) per l'autopsia se resta muto.

## Le trappole dichiarate subito
1. **Lo spread della riapertura**: alla domenica sera lo spread e'
   enorme proprio quando l'EA vuole entrare. L'OHLC NON lo vede →
   l'OHLC serve SOLO per frequenza/screening, i verdetti SOLO a tick
   reali (regola di sempre, qui vale doppio).
2. **Asimmetria dei simboli**: il gap forex (domenica 23:00 server) e
   il gap indici (riapertura lunedi') sono fenomeni diversi per orario
   e liquidita'. Lo scan multi-simbolo dira' CHI ce l'ha, senza
   presumerlo.
3. **Pochi eventi**: ~52 settimane/anno per simbolo, meno i gap sotto
   soglia. Campioni piccoli PER SIMBOLO sono strutturali: il giudizio
   vero sara' di FAMIGLIA (piu' simboli sommati), come per la BB.

## La trafila (imbuto standard, nessuno sconto)
scan multi-simbolo (OHLC, frequenza+segno) → eventuale CAL se muto →
tick reali sui vivi → walk-forward con criteri congelati AL MOMENTO del
round (prima dei numeri, come R33) → eventuale vivaio. Qualunque esito:
referto. Se il principio di Emiliano non regge ai numeri, si scrive e
si archivia — il corso ha i racconti, noi i numeri.
