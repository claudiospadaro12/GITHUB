# Bartiromo, video yDB8 "Operativita' XAU 90% oggettiva sulla liquidita'" (07/2026, 21 min): analisi di fedelta' (21/11/2026)

Fonte: trascrizione completa (21.852 caratteri, sottotitoli automatici YouTube: possibili errori di trascrizione). Nessuno screenshot disponibile: i numeri sui grafici e i "pallini verdi" non sono visibili. Il video dice di basarsi su **"la conferma che abbiamo visto due video fa"** e sulla sua nozione di liquidita': **quei video non sono stati letti per questa analisi** (probabili: i due video di agosto 2026 sulla selezione dello sbilanciamento).
## 1. Sintesi e contesto
- **Mercato:** XAU/USD. **TF:** conferma su **H1**, esecuzione su **M5/M15/M30** (order block o zona nel TF basso). **Orari:** conferme valide solo se la candela H1 **chiude alle 14:00, 15:00 o al massimo 16:00** (ora del suo grafico, non dichiarata: si presume ora italiana; il video non lo dice).
- **Filosofia:** price action + liquidita' (rejection su un massimo/minimo "di liquidita'"), intraday/scalp, "un trade al giorno" (intro), "limite giornaliero di trade" (chiusura). Dichiara 90% oggettiva: **solo il target e' soggettivo**.
- **Statistica dichiarata:** ultimi 10 giorni operativi (luglio 2026), 10 trade: 6 target, 3 stop, 1 unfilled; "win rate 60%", RR medio "3,8-4,3". Campione manuale, target scelto a occhio a posteriori.
## 2. Regole esatte (come dette nel video)
- **Setup:** il prezzo e' su un **massimo** (per i short) o un **minimo** (per i long) ("siamo su un massimo / su un minimo"); nel video e' un massimo/minimo di liquidita' (e' un livello che il prezzo ha preso o sta per prendere).
- **Conferma SHORT (su un massimo):** candela **H1 chiusa** ribassista: **engulfing o doji** ("candela piena a ribasso" o doji). **LONG (su un minimo):** candela H1 chiusa rialzista: engulfing o doji. Solo se chiude alle **14, 15 o 16**. Se la chiusura e' fuori orario o non e' engulfing/doji: nessun trade (esempio: "ha fatto la candela ribassista? No, non ci posizioniamo").
- **Ingresso:** (a) **doji:** direttamente **alla chiusura della candela H1** ("non c'e' bisogno di scendere"); (b) **engulfing (o candela estesa):** si scende su **M5/M15/M30**, si cerca una zona/order block e si entra con ordine **"un pelino piu' in alto (short) rispetto alla chiusura"**, aspettando il **test** dell'entrata nella candela H1 successiva. Se l'ordine non scatta = "unfilled", si cancella. Un esempio entra "dentro il movimento, sul punto interno" della candela (zona interna non definita).
- **Stop loss:** estremo della candela di conferma proiettato a **-0,27 / -0,30 di Fibonacci** (Fibonacci tracciato **dal massimo al minimo della candela di conferma**, verso l'esterno dal lato dello stop; per i short sopra il massimo). Nella doji "stoppettino piu' piccolo". **Un esempio cita "lo stop sopra lo 0,382 del massimo"** (contraddizione/ambiguita': e' un livello diverso).
- **Take profit:** **soggettivo**: "livello di liquidita'" (massimo/minimo precedente non ripreso, "movimento sell to buy" che va riempito, "fine gap", ecc.). **Niente RR fisso:** raccomanda cautela ("non cercate situazioni troppo onerose").
- **Gestione:** **niente break even** ("lo eviterei"); nessun trailing ne' parzializzazioni citati; trade tenuto fino a stop o target (durata: poche ore, "sfrutta la sessione operativa").
- **Money management:** rischio per trade non dichiarato in questo video; "dandovi sempre un limite giornaliero di trade da prendere" (numero non detto; intro: un trade al giorno).
## 3. Ambiguita' e discrezionalita' (con la domanda da chiarire)
1. **Quale massimo/minimo conta come "liquidita'"?** (giorno precedente, asiatico, swing H1, M15?) -> *"Dammi la definizione scritta (finestra, TF, quante barre) del livello che deve essere stato preso o toccato"*. **E' il filtro centrale e non e' nel video** (rimanda a video precedenti).
2. **Il livello deve essere sweepato (superato) dalla candela di conferma, o basta "esserci vicino"?** Un esempio dice di aspettare "l'aggressione del punto liquido".
3. **Engulfing: definizione esatta?** (corpo che ingloba il corpo precedente? anche le ombre?) e **doji: soglia corpo/range?** ("doji imprecisa" citata).
4. **Fibonacci dello stop: -0,27, -0,30 o 0,382?** e su quale range (candela di conferma sola o con ombre)?
5. **Ingresso su engulfing:** quanto sopra la chiusura ("un pelino")? su quale TF/zona (order block M15 vs M5)? **Durata dell'ordine pendente** (fino a quando? una candela H1?) e cosa significa "unfilled".
6. **Orario:** 14-16 e' ora italiana, di server broker o altro? E la "candela che chiude alle 16" vale solo come eccezione ("massimo alle 16")?
7. **Target:** il suo e' discrezionale: serve una regola (RR fisso? primo livello opposto di liquidita'?) altrimenti non e' replicabile al 100%.
8. **Piu' trade al giorno / re-entry:** quanti al giorno (nel video fa re-entry dopo uno stop il giorno stesso), si puo' entrare long e short lo stesso giorno?
9. **Rischio per trade e limite giornaliero:** non detti.
10. **Filtri di contesto citati ma non definiti:** "candelina con spike sotto e sopra, non forte al rialzo", "non entrare se la situazione non ti fa impazzire", ordine delle zone, "non mi azzarderei con RR grande se lo sbilanciamento c'e' gia' stato".
## 4. Cosa e' codificabile e cosa no
- **Codificabile alla lettera:** candela H1 chiusa alle 14/15/16 ora X, engulfing o doji (definizione da fissare), ingresso (doji al close; engulfing con limit), stop a un Fibonacci esterno della candela, nessun break even, uscita a stop/target.
- **Non codificabile senza una regola che nel video manca:** il livello di liquidita' (setup), il take profit, la zona di ingresso nel TF basso. Mettere queste tre cose come `input` non e' "fedelta' assoluta": il comportamento dell'EA dipenderebbe da definizioni NOSTRE.
## 5. Flusso (pseudocodice con input)
```
ogni chiusura H1 con ora in {14,15,16} (InpOraIT1..3, offset server InpOffsetServer):
  se ho gia' InpMaxTradeGiorno -> esci
  livelli = DefinizioneLiquidita(InpModoLiquidita)   // NON NEL VIDEO: input
  short: high_candela > un livello (InpSweep) E candela ribassista E (engulfing OR doji(InpDojiPct))
  long: simmetrico
  stop = estremo +/- InpFibo * range_candela       // video: 0,27 / 0,30
  entrata: doji -> a mercato al close; engulfing -> pending a close +/- InpRitrFrac*range, scade dopo InpScadenzaMin
  target = InpTargetR * rischio   // NON NEL VIDEO: input (target soggettivo)
  nessun break even; chiusura forzata InpOraChiusura
```
## Stato
Test gia' fatto (21/11, `BARTIROMO_REGOLE_CRITERI_2026-11-21.md`): versione NOSTRA con livelli oggettivi (PDH/PDL, asiatico, Londra), ritracciamento 25% e target 1R/1,5R/2R: oro 2004-2026 PF IS 0,79-0,82, OOS 0,88-0,95, win rate 1R 49%. Le definizioni 1, 3, 4, 5 e 7 qui sopra sono scelte nostre, non sue.

## 6. Video MWZ3 (08/08/2026) e qouD (16/08/2026): cosa e' il "punto liquido" per lui
Letti MWZ3 (19.635 car.) e qouD (18.296 car.): lunghi ma discorsivi, **nessuna definizione numerica**.
- **Punto liquido (da D1/H4/H1):** massimo/minimo di un movimento "impulso-ritracciamento-impulso", origine di una rottura di struttura; e' piu' "pulito" se **raggruppa massimi/minimi sottostanti, ha accanto un'inefficienza (imbalance/FVG)** e **non e' stato ancora preso** ("e' appoggiato senza prenderlo", "calamita vivente"). Lo definisce "la parte piu' complicata di tutto il video... con tanta applicazione, con tanta visione dei miei video".
- **Regola operativa:** (1) trovare il punto liquido su D1/H4/H1, (2) chiedersi **se e' stato preso**; se si', cerca **price action dal lato opposto** (costruzione ribassista dopo sbilanciamento di un massimo) su M15/M5 e si posiziona (anche "alla chiusura della candela H1 con stop un pelino piu' in alto"); se no, cerca una **"liquidita' nemica"** opposta che il prezzo deve prendere prima, poi riparte. **Target = il punto liquido successivo** (soggettivo).
- **Multi-TF:** selezione H4/H1/M15, esecuzione M5/M1/M15. Orario: cita "l'orario non era perfetto" (nessun elenco di orari). 
- **Esito sull'oggettivita':** la selezione del livello, la scelta dello "sbilanciamento corretto", la zona di ingresso e il target sono **discrezionali per sua stessa ammissione** (non codificabili alla lettera). Il "90% oggettiva" del video yDB8 vale solo per candela di conferma + stop; il filtro che decide se il trade c'e' e' il punto liquido, che non lo e'. Per questo **non e' possibile un EA fedele**: ogni versione sarebbe una nostra interpretazione (come il test del 21/11, PF 0,79-0,95).
- Rimandato nei video: lo "schemino" (non visibile), le liste di step, i video del Discord/one-to-one (a pagamento). Non presenti nelle trascrizioni.
