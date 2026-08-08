# 🔬 REFERTO ROUND 8 — ORB "come da manuale": l'ultima spiaggia, misurata

_Girato l'08/08/2026 notte su richiesta di Claudio, dopo il confronto fra il codice e
i documenti del sito ABTG (ToolKit 05 "ORB Apertura America" + Webinar 02/03/2026).
Driver generico, tick reali, M5, NASUSD, 2024.09.26 → 2026.06.30, taglio 40%.
File prova: `R8_ORB_come_da_manuale.txt` (ipotesi e contro-ipotesi scritte prima)._

## Le incongruenze trovate (codice vs documenti)

L'EA live NON fa la strategia dei documenti: range = 5' di PRE-mercato invece dei
30' DOPO l'apertura (14:30→15:00 server); ingresso al tocco con pendenti STOP — che
il ToolKit chiama testualmente **l'errore n. 1** — invece che su chiusura M5
confermata con corpo ampio; filtro EMA 9/21 ("REGOLA D'ORO") spento; filtro volume
spento; "un solo trade a sessione" dichiarato ma scollegato (bug corretto in R7).
In più l'indicatore V05 sul grafico usa una TERZA definizione di range
(09:00–09:14:59, 15 minuti a orari europei, sul grafico del Dow).
**La strategia documentata non era mai stata misurata.** Questo round la misura.

## I numeri (config da manuale: OR 30', chiusura confermata, corpo 50%, EMA 9/21)

| TP / volume | IS | OOS |
|---|---:|---:|
| 1,5R / **volume ON** | +914,94 · PF 1,456 · 182 | **+78,87 · PF 1,032 · 190** |
| 2,0R / **volume ON** | +1069,09 · PF 1,491 · 177 | **+59,04 · PF 1,023 · 185** |
| 1,5R / volume OFF | +43,99 · PF 1,017 · 254 | −141,98 · PF 0,965 · 391 |
| 2,0R / volume OFF | +210,55 · PF 1,074 · 248 | −64,04 · PF 0,984 · 381 |

## Le due verità, insieme

1. **Il manuale ha ragione sui filtri.** Il filtro volume (+50% sulla rottura)
   migliora tutti e quattro i confronti, uniformemente, in entrambe le finestre;
   la geometria giusta più i filtri portano l'ORB da «perde forte» (config live:
   IS −1477 · DD 24,8%) a «non perde» (DD 4–5%). I fakeout esistono e i filtri
   li tagliano davvero. Le due celle volume-ON sono positive in entrambe le
   finestre con campioni giudicabili (185–190 trade OOS).
2. **Ma "non perdere" non è un edge.** Fuori campione restano 40 centesimi a
   trade (PF 1,02–1,03): pareggio. Il criterio prop (PF ≥ 1,10 OOS) è lontano,
   il crollo IS→OOS (PF 1,46→1,03) dice che il brillare in campione era in gran
   parte adattamento, e la contro-ipotesi pre-dichiarata — la FASE M aveva già
   misurato che il breakout sul Nasdaq non paga (19/20 celle rosse) — regge
   anche nella versione da manuale.

## Verdetto (dai criteri pre-dichiarati in R8)

La condizione «una cella verde → guardare il vicinato prima di qualsiasi
entusiasmo» si è verificata: il vicinato sull'asse TP è verde, quello sull'asse
volume è rosso, e l'ampiezza dell'edge residuo è indistinguibile dallo zero.
**La conferma del round 7 resta: candidato allo spegnimento.** La versione da
manuale non vale il deploy (pareggio non paga il rischio), ma il round lascia
due cose vere e misurate: (a) se mai si vorrà un ORB, la base difendibile è
QUESTA config, non quella live; (b) il filtro volume è l'unico ingrediente che
ha migliorato tutto, ovunque — un'informazione che può servire agli altri EA
della famiglia apertura.

**Il caso ORB si chiude qui: tre round (R7a, R7b, R8), 12 celle a tick reali,
zero edge sfruttabile. La decisione di spegnere resta a Claudio.**

## Dove sono i numeri

`backtest_pipeline/risultati_prove/ABTG_ORB/*_r8.csv` (accanto a r7a/r7b e FASE 0).
