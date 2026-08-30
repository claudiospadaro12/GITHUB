# CACCIA — motore per il BUCO POMERIDIANO US, TF basso, intraday flat-EOD — 30/08/2026

## LA RIGA CHE CONTA
> Su **~40 candidati censiti** su 3 fonti (MQL5 Code Base, TradingView, ricerche
> mirate su GitHub/paper), **UNO letto per intero nel sorgente** (1237 righe,
> scaricato e disassemblato riga per riga), **ZERO PROVA SUBITO, UNO IN CODA**.
> Il candidato in coda e' il **ramo reversal del "Price Action Day Trader" di
> l2carbon** (Code Base 68704): pin bar di rifiuto a un livello S/R rolling,
> con uno **scaffold di gestione gia' pulito** (rischio %, cap perdita
> giornaliera, flat EOD, SL vero, zero bandiere rosse).
>
> **La scoperta che vale piu' del candidato: il BUCO POMERIDIANO US — nominato
> come TESI da tre cacce (Dow 30/08, paper 30/08, 28/08 par.5.7) — NON ha un
> motore open-source PRONTO.** Le ricerche mirate ("afternoon reversal",
> "power hour", "last hour close") restituiscono (a) momentum multi-TF (caduto
> R98), (b) prodotti MQL5 **Market a pagamento senza sorgente** (fuori
> perimetro). Il motore per quel buco **va costruito**, e questo EA e' il
> miglior mattone disponibile per costruirlo: uno scaffold nativo-MQL5 sano +
> un trigger di rifiuto-al-livello da isolare.

---

## 0. CONTROLLO POSITIVO — fonte per fonte
| fonte | esito | prova |
|---|---|---|
| `mql5.com/en/code` (ricerca experts intraday reversal) | PASSA | titoli/URL reali riconoscibili: 74137 "003 Weekly Day Reversal" (gia' nel SETACCIO), 68704 l2carbon, 43252 "Reversal Strategy" |
| download sorgente Code Base (`/code/download/68704`) | PASSA | HTTP 200, ZIP reale 7.426 byte -> `Daily_Price_Action_EA.mq5` 1237 righe, letto |
| TradingView (ricerca scripts) | PASSA (indiretto) | URL reali (leebaez11 Mean Reversion, Power Hour Money Strategy) |
| WebSearch GitHub/paper afternoon-reversal | PASSA | URL reali, ma nessun EA open-source dedicato al buco (vedi sotto) |
| pagina TradingView `script/cx0kTprU` (leebaez11) | **NULLA** | HTTP 404 sulla fetch diretta -> sorgente NON letto, candidato NON valutabile, dichiarato |

---

## 1. IL PROMOSSO (IN CODA) — ramo REVERSAL di "Price Action Day Trader" (l2carbon, Code Base 68704)

```
NOME            Price Action Intraday Trading - Expert for MT5  (ramo reversal)
FONTE / URL     mql5.com/en/code/68704  (file Daily_Price_Action_EA.mq5, 1237 righe)
AUTORE / DATA   l2carbon - 2026.01.30
LICENZA         NON dichiarata nel sorgente (#property copyright "Price Action
                Day Trader"). Code Base = sorgente scaricabile/studiabile, ma
                senza MIT/BSD esplicito il riuso in un derivato committato e'
                INCERTO -> attribuzione obbligatoria + verifica termini prima
                di distribuire. [VERIFICATO leggendo l'header del sorgente]
RIGHE / INPUT   1237 righe; ~22 input. Il RAMO utile ne usa ~6.

TESI IN UNA RIGA
  "Un pin bar di rifiuto a un livello S/R strutturale recente segnala
   esaurimento: si entra nel verso del rifiuto (short a resistenza / long a
   supporto). Il livello + il wick SONO il motore, non un filtro appiccicato."

MECCANICA   ingresso: su barra 1 CHIUSA, pin bar (wick>=ratio*corpo) il cui
            estremo tocca un massimo/minimo delle ultime ~20 barre (IsAtSupport/
            IsAtResistance, righe 460-489). uscita: TP = R:R * SL + breakeven +
            trailing; FLAT a fine giornata (CloseAtEndOfDay). stop: reale al
            broker (request.sl, OrderSend righe 673-723).
GESTIONE    rischio % dell'equity (CalculateLotSize righe 882-912, via tick
            value/size -> SCALABILE a 100k), SL VERO, cap perdita giornaliera
            3% (CheckDailyLossLimit righe 203-213), max 1 posizione, flat EOD.
BANDIERE ROSSE  NESSUNA. Grep negativo su Multiplier/grid/martingale/averaging/
            recovery/hedge/iCustom/WebRequest/#import/DLL. SL vero, non virtuale.
            Decide su barra CHIUSA (index 1) -> niente repaint/look-ahead.
COSTO DI PORTING  ZERO di linguaggio (gia' MQL5). Costo = CHIRURGIA: isolare il
            solo ramo reversal (buttare engulfing/inside-bar pro-trend + il gate
            MA20/50), sostituire lo StopLossPips FISSO con SL strutturale +
            pavimento R109, tarare la fascia pomeridiana in ora server. ~mezza
            giornata; meta' (rischio %, cap giornaliero, flat EOD) si riusa.

PUNTEGGIO (0-2)
  [1] semplicita': il motore-nel-suo-insieme e' MISTO (3 pattern + gate MA);
      il ramo reversal isolato e' semplice, ma va ESTRATTO -> mezzo punto.
  [1] il filtro E' il motore: SI per il ramo reversal (livello+wick); ma
      nell'EA cosi' com'e' il reversal e' UNO dei tre rami -> non costitutivo.
  [2] tesi di mercato scrivibile: SI (esaurimento a livello, una riga).
  [2] riempie un BUCO: fascia POMERIDIANA US vuota + lato SHORT + reversal.
  [0] testabile senza riscritture: NO, va costruito l'EA isolando il ramo.

VERDETTO   IN CODA (6/10).
PERCHE'    scaffold nativo-MQL5 sano e trigger di rifiuto-al-livello DIVERSO
           dai caduti; ma e' parziale doppione del CRT (stessa famiglia
           wick-reject), va operato di chirurgia, e la licenza e' incerta.
```

### In ottica PROP (riga d'obbligo)
Cap perdita giornaliera 3% gia' nel codice (da stringere al nostro 5% di muro,
anzi meglio), flat EOD = zero rischio overnight, rischio % scalabile a 100k.
**Il nodo prop vero e' la SCORRELAZIONE dal CRT Turtle Soup**: se i giorni-segnale
coincidono (entrambi wick-reject reversal su indice M15), accenderli insieme NON
aggiunge nulla e concentra il DD. Va MISURATO in banco: se coincide -> si tiene
solo il CRT (piu' pulito, MIT). Rischio giornaliero da sorvegliare: piu' pin bar
lo stesso pomeriggio = concentrazione, non diversificazione.

### Perche' NON e' un caduto (passato per REGISTRO_TEST.md e i referti)
- NON e' ORB/breakout nudo (fada un livello, non lo insegue): capitolo breakout
  M5 chiuso, ma questo non e' breakout.
- NON e' fade NUDO (R42/R60/R108/R109): non deviazione dalla media, ma rifiuto
  con wick a un livello S/R strutturale.
- NON e' momentum intraday (R98): trigger di reversal, non di continuazione.
- NON e' sweep+reclaim forex (R95): indice, e il livello e' uno swing lookback,
  non la candela adiacente.
- NON e' VWAP-reversion (P1) ne' Model B (nessuna macchina a scoring -> rischio
  "Alta Velocita'" basso).
- PARZIALE DOPPIONE del CRT Turtle Soup (famiglia wick-reject) -> dichiarato, la
  scorrelazione decide se sopravvive.

---

## 2. LA TESI CHE VALE PIU' DEL CANDIDATO — il buco pomeridiano non ha un motore pronto
Ricerche mirate ("power hour reversal", "afternoon reversal 3pm", "last hour
close mean reversion", "US30/Nasdaq afternoon fade EA source"):
- **Power Hour Money Strategy** (TradingView, kr): allineamento multi-TF
  (mese/settimana/giorno/ora tutti verdi = long) = **MOMENTUM**, non reversal ->
  e' il motore di R98, gia' caduto a tick (lordo -0.31 pt/op su 410). SCARTO.
- **Nasdaq Super Scalper / US30 Morning Break / ORB Master / US30 Scalper**
  (tutti MQL5 **Market**): a pagamento, **senza sorgente** -> §1-B, fuori
  perimetro (non applicabile il setaccio, niente backtest nostro). SCARTO.
- **leebaez11 Mean Reversion** (TradingView): pagina 404 sulla fetch -> sorgente
  non letto -> non valutabile. Dichiarato.
> **Conclusione, coerente con la caccia Dow 30/08 e paper 30/08: per la fascia
> pomeridiana US non esiste un EA open-source pronto; il motore va COSTRUITO.**
> Il mattone migliore trovato oggi e' lo scaffold 68704 + il suo trigger
> rifiuto-al-livello, da isolare e ritarare sulla fascia pomeridiana.

---

## 3. GLI SCARTATI — una riga di motivo a testa
| candidato | fonte | perche' SCARTO |
|---|---|---|
| Power Hour Money Strategy | TradingView (kr) | allineamento multi-TF = momentum = R98 caduto |
| Nasdaq Super Scalper / US30 Morning Break Scalper / ORB Master / US30 Dow Scalper | MQL5 **Market** | a pagamento, **niente sorgente** -> setaccio non applicabile |
| 003 - Weekly Day Reversal (74137) | MQL5 Code Base | gia' setacciato (D_LATERALE/E_CROLLO/F_SHORT), e' effetto giorno-della-settimana daily, non intraday TF basso |
| SMT Divergence NASDAQ vs SP500 (Market 173223) | MQL5 Market | INDICATORE (niente entry/exit) + richiede secondo feed sincronizzato nel tester |
| leebaez11 Mean Reversion Strategy | TradingView | pagina 404 -> sorgente NON letto, non valutabile (dichiarato, non sostituito con memoria) |
| Trend Reversal (aharontzadik1, 25316) | MQL5 Code Base | **MT4**, non MT5; fuori pipeline |
| geektrade-strategies / Salikha003 PineScripts | GitHub | collezioni didattiche generiche (crypto/forex), nessun motore per il buco pomeridiano indici |

---

## 4. COSA NON HO POTUTO VEDERE (dichiarato, non sostituito con la memoria)
- **Sorgente di leebaez11 Mean Reversion**: pagina TradingView 404 sulla fetch.
  Non valutato. Da riprovare con URL diverso o access aperto.
- **Termini di licenza precisi del Code Base 68704**: il sorgente non dichiara
  licenza; i termini di riuso Code Base per un derivato committato sono da
  verificare (INCERTO). Marcato nel FONTE.txt archiviato.
- **@DAQUANDO reale di NASUSD**: assunto 2024.09.26 (muro tick BCM indici,
  misurato ripetutamente nelle cacce precedenti) ma da CONFERMARE con
  `scarica_storico.ps1 -Simboli "NASUSD" -SoloReferto` prima di lanciare.
- **Spread pomeridiano NASUSD**: NON misurato (logger Code Base 74148 mai usato)
  -> PASSO 0 load-bearing prima di qualunque PF.
- **Numeri di performance dell'autore**: l'EA non ne dichiara di credibili e
  comunque non peserebbero (regola 7). Nessuno usato.

---

## 5. LA DOMANDA A CUI IL PRIMO TEST DEVE RISPONDERE
**"Il pin bar di rifiuto a un livello S/R rolling, isolato dal resto del motore e
ristretto alla FASCIA POMERIDIANA US (lato SHORT), ha edge su NASUSD M15 a tick
reali — ed e' SCORRELATO dal CRT Turtle Soup (perde in giorni diversi), o e' lo
stesso trade e va scartato a favore del CRT?"**
- PASSO 0: confermare @DAQUANDO NASUSD + misurare spread pomeridiano + contare
  le operazioni nella sola fascia (rischio campione sottile).
- Se coincide col CRT -> doppione, si tiene il CRT (MIT, piu' pulito).
- Se scorrelato e con edge -> secondo motore reversal, che copre la fascia
  pomeridiana (oggi vuota) col rischio notturno zero.

---
_Sorgente letto e archiviato:
`caccia_strategie/biblioteca/sorgenti/PriceActionDayTrader_l2carbon_MQL5CodeBase/`
(PriceActionDayTrader_68704.mq5 + FONTE.txt). Attribuzione da riportare in testa
a qualunque .mq5 derivato: "Ramo reversal da 'Price Action Day Trader' di
l2carbon, MQL5 Code Base 68704." File prova: `prove/ABTG_PinRejectRev.txt`._
