# 🏁 R113 — REFERTO DEL ROUND: LA PROVA DI REGIME DICE "NON CONCLUSIVA" — MA HA MISURATO DUE COSE CHE NESSUNO SAPEVA

_Corsa: 27/08/2026 07:30-07:35 (5,4 min), banco OHLC su M1 (modello 1),
NASUSD_EXT, pin `9ddf37b`. Esito driver: **OK — 18/18 celle, 0 problemi,
0 rilievi**, G0-A ovunque, gemelli identici. Criteri FIRMATI ("FIRMO
R113", 27/08 notte). Zip agli atti: `R113_REGIME_CORSA_20260827_0730.zip`.
Vale tutto il § 1 dei criteri: dati di un ALTRO broker, si legge la
FORMA, mai i numeri fini; spread del banco **NON MISURATO** (potrebbe
essere senza attrito — checklist 89), dichiarato e non dedotto._

## ⚖️ LA GRIGLIA IPOTESI-S, SPUNTATA A MANO (era pre-dichiarata: non si tocca)

- [ ] CONFERMATA — richiedeva short PF≥1,10 con n≥20 in ORSO **e** CROLLO_ANNO → **in ORSO lo short ha fatto ZERO operazioni**, in CROLLO_ANNO una. Non soddisfabile.
- [ ] SMENTITA — richiedeva PF<0,90 con n≥20 nelle stesse → idem, campioni inesistenti.
- [ ] MOTORE PER TUTTE LE STAGIONI — no (TORO: short n 6, rosso).
- [x] **NON CONCLUSIVA** — _"campioni sottili/non misurati dove serviva il verdetto"_: è la casella esatta, e si spunta senza forzare niente.

**La domanda "lo short vive nelle discese?" resta aperta — ma per una
ragione che NESSUNO aveva previsto, ed è la scoperta vera del round.**

## 🔍 SCOPERTA n.1 — SU QUESTO FEED, IL MOTORE NEL 2020-2022 QUASI NON ESISTE

| finestra | n metro (uscite) | al mese |
|---|---:|---:|
| TORO 2021 (12 mesi) | 8 | 0,7 |
| ORSO 2022 (10 mesi) | 7 | 0,7 |
| CROLLO_ANNO 2020 (12 mesi) | 5 | 0,4 |
| LATERALE 2015-16 (18 mesi) | 55 | 3,1 |
| VECCHIA 2011-12 (24 mesi) | 94 | 3,9 |
| _(contesto: R110 su BCM 2025-26)_ | _(96 in 12,7 mesi)_ | _(~7,5)_ |

**Nell'anno dell'orso 2022 — la finestra per cui questo round esisteva —
il lato short non ha aperto NEMMENO UNA operazione.** Il verdetto sul
"short nelle discese" non è né sì né no: è _"questo motore le discese
non le tradda proprio"_ (su questo feed). E il crollo di frequenza
2020-2022 contro il 2011-2016 E contro l'epoca BCM è un fatto nuovo.

**[NON MISURATO] Feed o epoca?** Le due spiegazioni candidate — (a) il
feed HistData ha una geometria H1 diversa che spegne i segnali; (b) il
motore era davvero quasi muto in quelle epoche — qui non si distinguono.
**La misura che le separa esiste ed è economica**: la finestra di
SOVRAPPOSIZIONE 2024.09→2026.06 girata su _EXT e confrontata con gli n
di R110 sul BCM nativo (stesse date, stesso motore, due feed). 3 celle,
~2 minuti di banco. Proposta come coda del round (criteri lampo, firma
lampo) — finché non gira, ogni lettura delle finestre recenti porta
questa riserva.

## 🔍 SCOPERTA n.2 — IL LATERALE È ROSSO, CON CAMPIONE PIENO. È il risultato più solido del round

**LATERALE_NAS 2015-2016: tutte e tre le celle in perdita con merito
misurabile** — metro PF 0,664 (n 55), long 0,626 (n 34), short 0,729
(n 21). Non è rumore: è l'unico posto del round dove i campioni reggono
il verdetto pieno, e dice che **il rimbalzo sul Supertrend, senza un
trend che lo sorregga, paga il conto** — da entrambi i lati. Coerente
con la natura del motore, ma da oggi è misurato, non intuito. (Sempre
con l'asterisco del banco: forma, non numeri fini.)

## 🛡️ LA CORSIA DEL RISCHIO — 16 anni, NESSUNA segnalazione

Soglia G2 (DD > 2× metro E > 20%) in F1/F2/F5: **mai nemmeno
avvicinata** — DD massimo dell'intero round 1,81% (laterale), CROLLO
2020 passato con DD 0,37%, VECCHIA 2011-12 con 1,66%. **Su 16 anni di
storia questo motore non è mai esploso: si spegne o sanguina piano, non
salta.** Per la sedia viva 970913 nessuna revisione: il suo profilo
prop-friendly (DD più basso del parco) esce CONFERMATO dalla corsia del
rischio — che era l'unica cosa che la regola B permetteva di giudicare
sul vecchio, ed è un giudizio buono.

## 📌 LETTURE FINI E A REGISTRO

- **PF 0,000 con profitto positivo** (F0 long +378, F3 long +415, F2
  long +63): è l'output di MT5 quando NON ci sono perdite (perdita lorda
  zero) — su campioni da 2-4 uscite. NON è la nostra sentinella n/d e
  NON è "ha perso tutto": va letto "tutte vincenti, campione minuscolo".
  Da annotare per i prossimi referti (parente della checklist 66).
- Unità: n in USCITE, ~2 uscite ≈ 1 posizione (R112) — i "94" di
  VECCHIA sono ~47 posizioni in 24 mesi.
- Magic 7635xx bruciati. G5 rispettato: nessuna cella si muove.
- Il vincolo di frequenza per la challenge: anche nelle finestre grasse
  (_EXT 2011-16) il motore fa 3-4 uscite/mese — la conferma che la
  frequenza per la challenge non verrà mai da questa famiglia, già
  scritta in R111 per la BB, vale anche qui.
- Costo del round: **5,4 minuti di banco** per chiudere una domanda mal
  posta e aprirne una migliore (feed vs epoca) con la sonda già pronta.
