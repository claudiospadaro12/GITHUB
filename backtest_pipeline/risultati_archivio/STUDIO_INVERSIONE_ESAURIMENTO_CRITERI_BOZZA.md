# 🔄 CRITERI — MOTORE D'INVERSIONE DA ESAURIMENTO [BOZZA — DA FIRMARE]

> **Stato: FIRMATA il 30/08/2026** (Claudio: "FIRMO", coi default proposti).
> **VALORI BLOCCATI**: E1 = giornata che ha speso >= **1.0x l'ADR a 14 giorni**;
> E2 = livello = **massimo/minimo del giorno prima + estremo di seduta**; E3 =
> **2-3 barre a range calante** al livello (spento nel baseline, acceso in
> ablazione); prova di regime = **Nasdaq PRIMA**, DAX/Dow dopo se regge; criteri
> di lettura §5 CONFERMATI. Da qui nascono i file prova e la riga.
>
> Nata dalla sua idea del
> 30/08: _"un ordine su un livello quando il prezzo, partito in direzione
> contraria, sta finendo la benzina e torna indietro."_ Ripulita dalla trappola
> (NON e' una riparazione/mediazione: e' un motore d'inversione A SE', a rischio
> normale). Congelata guardando SOLO la storia gia' misurata; i numeri vengono
> DOPO la firma. Regola delle due fasi.

## 0) DA DOVE NASCE (il fatto misurato, non l'opinione)
- **L'esaurimento e' un segnale REALE, gia' visto in casa**: nel crollo 2020
  (FASE 2, per-trade) lo short del drive-following ha fatto **+1.587/trade** —
  catturava proprio l'esaurimento della spinta e l'inversione. La coda
  dell'esaurimento esiste.
- **MA il fade "normale" e' MORTO** (R108/R109: DD 44-68%, peggior giornata
  -9.72%; R95 sweep+reclaim 30/30 in perdita). Quindi la tesi NON e' "faddiamo i
  range": e' l'opposto. **Il fade di casa muore sui range ordinari; l'edge, se
  c'e', e' sugli ESTREMI di esaurimento** (mosse che hanno gia' speso troppo).
- **Conseguenza di disegno**: il motore deve accendersi SOLO su esaurimento
  ESTREMO (mossa giornaliera gia' quasi completa + livello), non sul rientro di
  ogni ranging. E' proprio la selettivita' che separa questo dai fade caduti.

## 1) LA DOMANDA (una sola, onesta)
> **Esiste una condizione di ESAURIMENTO ESTREMO — misurabile al momento, senza
> guardare avanti — che rende l'inversione a un livello un motore (aspettativa
> per trade positiva, DD sotto il muro), e NON l'ennesimo fade morto?**

Se la risposta e' NO (l'inversione da esaurimento non batte la moneta / muore
come i fade), il verdetto onesto e': "l'esaurimento e' raccoglibile solo dentro
il drive-following short (crolli), non come motore a se'" — e si chiude.

## 2) LA MECCANICA (congelata PRIMA dei numeri, [DA FIRMARE le soglie])
Tutto STANDALONE: nessuna posizione da "riparare", nessuna mediazione, nessun
raddoppio. Ingresso singolo, stop vero.

- **E1 — Benzina finita**: la mossa direzionale della giornata ha gia' speso
  >= k della sua ampiezza tipica. Misura candidata: (range del giorno finora) >=
  k x (ADR, average daily range su N giorni). Ipotesi: oltre una certa quota di
  ADR consumato, la probabilita' di continuazione cala. `[k, N DA FIRMARE]`.
- **E2 — Il livello**: l'inversione si arma SOLO a un livello dichiarato (non nel
  vuoto). Candidati: estremo di seduta / massimo-minimo del giorno prima / round
  number / swing HTF. `[QUALE livello DA FIRMARE]`.
- **E3 — Perdita di spinta (conferma)**: momentum che cala al livello. Candidati:
  N barre a range decrescente / divergenza / volume in calo. `[QUALE DA FIRMARE]`.
- Ingresso: sull'inversione (contro la mossa esausta), **a rischio 0.65%** (o la
  taglia di casa), **SL con PAVIMENTO OBBLIGATORIO (R109), mai 0**. Uscita: TP a
  un obiettivo di rientro (verso la media/VWAP) + gestione, **senza inseguire una
  coda** (l'inversione punta al rientro, non al trend nuovo).
- Si accende UNA feature interruttore alla volta (ablazione a stella): E1 da solo,
  poi E2, poi E3. Baseline = inversione nuda al livello senza filtro esaurimento.

## 3) COSA LO SEPARA DAI FADE CADUTI (il cancello che deve passare PER PRIMO)
Ogni cella passa la lista dei caduti (REGISTRO_TEST.md) PRIMA di entrare:
R108/R109 (fade M15/M30 morti), R95 (sweep+reclaim), R101 gradino 07 (VWAP).
**La tesi e' che E1 (esaurimento estremo) sia la variabile che quei round NON
avevano**: loro faddavano range ordinari; qui si entra SOLO quando la benzina e'
finita. Se col filtro esaurimento acceso il risultato e' identico ai fade morti
-> e' lo stesso motore, e si chiude onestamente.

## 4) LA VALIDAZIONE (dove si giudica)
- **Due fasi**: criteri congelati qui. Screening OHLC su storico ESTERNO
  (NASUSD_EXT 2017-2020, che CONTIENE il crollo 2020 e l'orso Q4-2018 — gli
  estremi di esaurishment piu' ricchi). Poi conferma a TICK sulla cassaforte BCM
  2024.09->2026 (tick reali confermati, 166M; spread 1.7 pti indice agli atti).
- **La prova decisiva e' il 2020**: il crollo-giu e la ripresa-V sono i due piu'
  grandi esaurimenti, uno per lato. Se il motore non li prende, non e' lui.
- **Lettura per REGIME** (il totale diluisce): toro/orso/laterale/crollo.
- **Prova di regime cross-simbolo**: Nasdaq PRIMA (dove abbiamo l'anatomia e i
  dati); DAX/Dow dopo se regge. `[se includere DAX/Dow DA FIRMARE]`.

## 5) CRITERI DI LETTURA (cosa decide, congelato)
- **DECIDE**: l'aspettativa per trade, con coerenza fra i sotto-periodi.
- **RISCHIO mai sospeso (regola B)**: DD e peggior giornata contro il muro prop,
  SEMPRE. Un'inversione entra CONTRO una mossa forte: il rischio di "coltello che
  cade" e' il pericolo n.1 -> il pavimento SL e la peggior giornata sono
  load-bearing.
- **CAMPIONE**: >= 150 trade per il merito; sotto, merito sospeso, rischio sempre.
- **VINCE** solo se una cella da aspettativa/trade positiva e STABILE, con DD
  sotto il muro, E batte il precedente fade morto. Un solo periodo/simbolo = non
  dimostrato.

## 6) COSA NON SI FA
- ❌ NIENTE riparazione / mediazione / raddoppio su posizione aperta. E' un
  motore a se', ingresso singolo. (E' il punto di tutta la conversazione: il DD
  non si abbassa aggiungendo rischio dove si perde.)
- ❌ Niente griglia sulle soglie per inseguire un picco (Seconda Caccia).
- ❌ Non si tocca il forward: e' un round nuovo, una MISURA.

---
**[FIRMA CLAUDIO]**: le soglie di §2 (k/N dell'esaurimento E1, quale livello E2,
quale conferma E3), se la prova di regime include DAX/Dow, e la conferma dei
criteri di lettura §5. Da qui nascono i file prova e la riga — non prima.
