# R83 — IL DUELLO DEGLI INGRESSI: **IL RETEST VINCE SUL DAX** (la config della sedia viva e' incoronata dalla misura). **NIENTE salva il Nasdaq.** La stessa regola cambia segno tra mercati.

_19/08/2026. Corsa notturna del 18/08 (raccolta 22:30, commit di riferimento
`2458b33`). Nasce da FIRMA 6 ("SI, FIRMO R83BIS"): UN solo EA,
`ABTG_Apertura_3Ingressi.mq5`, tre modalita' d'ingresso a parita' ASSOLUTA di
tutto il resto. NASUSD e D30EUR, M15, modello **4 = tick reali** (PASSO 0
promosso: tick dal 2024.09.26 per entrambi), deposito 10.000, rischio pinnato
1%/op, `InpSlippagePts=0` dichiarato. Finestra `2024.09.26 → 2026.06.30`,
IS fino al 2025.06.09, OOS dal 2025.06.10 [VERIFICATO per-trade]. Criteri
congelati PRIMA in `prove/R83_INGRESSI_CRITERI.md`. CSV in `r83_csv/`.
Igiene: **14 CSV attesi / 0 mancanti**, gemelli magic identici in tutti gli
aggregati e in tutte le serie per-trade [VERIFICATO con diff in fase di
referto]._

## 🐤 I due canarini di equivalenza — la garanzia che il duello misura SOLO l'ingresso

Senza questi due, il duello non conta (criteri §4). Tutti e due PROMOSSI, e
riverificati per questo referto con confronto Python riga per riga:

**(a) N0 (EA nuovo, mod. 0 STOP) = cella A di R84 (EA vivo del Nasdaq)**
[VERIFICATO]: aggregati identici a ogni decimale (IS +686,35 / PF 1,25367 /
156 op; OOS −795,03 / 0,87315 / 291 op) e **TUTTI i 291 trade OOS identici**
— orario al secondo, volume, prezzo, profitto — al netto del solo magic.

**(b) D1 (EA nuovo, mod. 1 RETEST) = V (sedia viva `ABTG_DAX_Apertura_EU`,
magic di prova della 770101)** [VERIFICATO]: IS 282,12 / 1,07810 / 197; OOS
999,42 / 1,18776 / 311 — identici a ogni decimale, e **TUTTI i 311 trade OOS
identici** al netto del magic. Due core diversi (il fork viene dal core
Nasdaq, la sedia viva e' il core DAX): stessi trade.

> Il fork e' un clone fedele di ENTRAMBI i motori vivi. Le differenze fra le
> celle qui sotto sono quindi **effetto dell'ingresso e di nient'altro** —
> e' esattamente la garanzia che i criteri pretendevano prima di leggere.

## 📊 Il duello sul DAX (D30EUR, apertura 8:00 server, range 35', buffer 500)

[VERIFICATO dai CSV; PF tot ricavato per aritmetica dai due aggregati →
[INFERITO], stessa derivazione controprovata di R84]

| cella | modalita' | IS Profit/PF/n | OOS Profit/PF/n | OOS DD% | OOS serie peggiore | PF tot | n tot |
|---|---|---|---|---:|---:|---:|---:|
| D0 | 0 STOP | +204 / 1,047 / 220 | +251 / 1,041 / 325 | 13,26 | −555,35 | 1,043 | 545 |
| **D1** | **1 RETEST (baseline = sedia viva)** | **+282 / 1,078 / 197** | **+999 / 1,188 / 311** | **10,60** | −510,56 | **1,143** | 508 |
| D2 | 2 CONFERMA (codice nuovo) | −767 / 0,804 / 212 | −83 / 0,984 / 322 | 8,69 | −278,10 | 0,907 | 534 |

**Lettura coi criteri congelati (§6):** la baseline del DAX e' il retest
(la sedia viva gira gia' cosi'). Nessuna sfidante la batte, e non di poco:

- **D0 stop**: coerente (+/+) ma PF tot 1,043 = **−0,100** sotto la baseline
  e DD OOS peggiore di +2,7pp → fuori su due cancelli. E attenzione: la 0
  correva col **vantaggio dichiarato** dello slippage a zero (criteri §7) e
  ha perso lo stesso → **il giro 2 con slippage e' inutile**, il retest ha
  vinto nonostante l'handicap a favore dell'avversaria.
- **D2 conferma**: negativa in tutte e due le meta'. Unico pregio misurato:
  il DD piu' basso (8,7%) e la serie perdente piu' corta (−278).
- **D1 retest**: unica modalita' positiva in ENTRAMBE le meta', PF tot
  1,143, OOS +999 con DD 10,6% a rischio 1%.

**🏆 La config della sedia viva 770101 e' INCORONATA dalla misura.** La
divergenza **#15 dell'audit di fedelta'** (documenti del corso: ordini STOP;
campo: RETEST — `ANALISI_PIANI_APERTURA_2026-08-18`, richiamata nella
cronaca PASSO 7) **si chiude a favore del campo**: quello che il campo
faceva "in divergenza dal manuale" e', misurato ad armi pari, la migliore
delle tre regole su questo mercato e questa finestra.

## 📊 Il duello sul Nasdaq (NASUSD, apertura 14:30 server, candela H1 prec., buffer 200)

| cella | modalita' | IS Profit/PF/n | OOS Profit/PF/n | OOS DD% | OOS serie peggiore | PF tot | n tot |
|---|---|---|---|---:|---:|---:|---:|
| N0 | 0 STOP (baseline) | +686 / 1,254 / 156 | −795 / 0,873 / 291 | 17,07 | −376,55 | 0,988 | 447 |
| N1 | 1 RETEST | −178 / 0,947 / 187 | **−2.411 / 0,624 / 303** | **29,14** | −391,47 | 0,734 | 490 |
| N2 | 2 CONFERMA (codice nuovo) | −942 / 0,705 / 198 | −92 / 0,978 / 313 | **6,18** | −189,78 | 0,861 | 511 |

**Lettura coi criteri congelati:** **nessuna modalita' e' positiva.** Nessuna
sfidante batte la baseline (che a sua volta ha il segno ribaltato fra le
meta'), quindi zero vincitori — esito previsto come legittimo dal §6.5.

- **N1 retest: il disastro del round.** OOS −2.411, PF 0,62, DD 29,1%. La
  regola d'oro del DAX e' la peggiore del Nasdaq (autopsia sotto).
- **N2 conferma: "la meno peggio", nel solo senso del rischio.** OOS PF 0,978
  col DD piu' piccolo di tutto il round (6,2%) e la serie perdente piu'
  corta — ma resta negativa in tutte e due le meta' (IS 0,705). Un modo piu'
  educato di non guadagnare, non un edge.
- **Con R84 il verdetto sull'apertura US e' UNANIME**: 9 celle di filtri
  (R84) + 3 stili d'ingresso (R83) = **12 configurazioni, 12 OOS negative**.
  L'apertura US non ha edge su questa finestra a prescindere da ingresso e
  filtri. Terzo verdetto indipendente sulla 770201, che resta spenta.

## 🔬 Autopsia per-trade del retest Nasdaq — mille tagli o code?

[VERIFICATO sul per-trade OOS `pertrade_r83n1_777020.csv`, 303 trade]

- Win rate **73,9%** — vince spesso, come le altre (N0: 76,3%).
- **Vincita media +17,86** contro **perdita media −82,20**: il payoff e'
  rotto. Le perdite sono quasi tutte **stop pieni**: 74 su 78 sotto i −30,
  peggiore singola **−103,84** ≈ 1R (rischio 1% su 10.000).
- **NIENTE code**: nessuna perdita oltre il rischio disegnato, peggior
  giornata **−1,13%**, serie peggiore −391,47 (4 stop di fila). Il cap di
  rischio ha tenuto sempre.
- **11 mesi su 13 negativi** in OOS: emorragia costante, non un incidente.

**Verdetto dell'autopsia: morte per mille tagli — ma tagli da 1R INTERO.**
Il DD 29,1% e' puro accumulo di stop pieni (~−1R l'uno) non ripagati da
vincite che valgono in media 0,2R. Confronto misurato con lo stop (N0):
stesso ordine di win rate, ma vincita media +24,65 contro +17,86 e 12
perdite in piu' (78 vs 66) — sul Nasdaq il retest compra un ingresso che
paga sistematicamente meno quando vince. Il perche' meccanico (dove riempie
il limit rispetto allo stop su QUESTA apertura) non e' stato isolato qui:
[INCERTO], servirebbe un'analisi dedicata dei prezzi d'ingresso.

Nota misurata sul **no-fill temuto** (criteri §6.2): non si e' visto. Sul
Nasdaq il retest ha fatto PIU' trade dello stop (303 vs 291, offset 0), sul
DAX 311 vs 325 (−14). Il costo del limit su queste aperture non e' il
campione: e' il prezzo.

## 🌍 La scoperta trasversale

**La STESSA regola d'ingresso cambia segno tra mercati** [VERIFICATO]:

| modalita' | DAX (OOS) | Nasdaq (OOS) |
|---|---:|---:|
| retest | **+999 (PF 1,19)** — la migliore | **−2.411 (PF 0,62)** — la peggiore |
| stop | +251 (PF 1,04) | −795 (PF 0,87) |
| conferma | −83 (PF 0,98) | −92 (PF 0,98) |

E' la lezione PTE (GBPUSD si', USDJPY no) ribadita sugli indici: **non
esiste "l'ingresso giusto" in astratto** — esiste l'accoppiata
regola+mercato. Qualunque futura estensione delle aperture a un altro
indice dovra' rifare il duello, non ereditare il retest del DAX.

## 🏁 Verdetto (coi cancelli congelati)

1. **DAX: nessuna sfidante batte la baseline.** Il retest — cioe' la config
   con cui la sedia viva 770101 gira in campo — domina su PF totale, OOS e
   coerenza fra le meta'. La divergenza #15 e' chiusa a favore del campo.
   **Nulla da cambiare sulla sedia viva.**
2. **Nasdaq: zero modalita' positive.** Con R84, verdetto unanime: l'apertura
   US non ha edge su questa finestra. La 770201 resta spenta.
3. **Il round PROPONE e non promuove.** Nessuna sedia nuova si accende, come
   scritto nei criteri (§6.6): un eventuale passaggio in forward richiede
   prova di regime, walk-forward, contratto DD+frequenza e firma di Claudio
   — e comunque **max UNA modalita' per mercato** (posizioni correlate, cap
   C1 3,25%).
4. **L'EA `ABTG_Apertura_3Ingressi` resta in armeria, COLLAUDATO**: canarini
   di equivalenza passati al decimale su entrambi i core, autotest modalita'
   2 sei-su-sei (PASSO 1b). E' uno strumento di misura pronto per il
   prossimo duello, non una sedia.

## ⚠️ Limiti dichiarati

- **Un regime e mezzo** (niente 2020, niente 2022): R83 misura riempimento e
  stile d'ingresso, MAI la robustezza di regime. Anche la vittoria del
  retest sul DAX e' vittoria su QUESTA finestra.
- **Slippage a zero su tutte le celle** (asimmetria dichiarata, criteri §7):
  avvantaggiava la modalita' 0, che ha perso comunque su entrambi i mercati
  → nessun giro 2 necessario.
- La modalita' 2 ("chiude oltre il livello") e' codice nuovo: collaudato
  nell'autotest e nel tester, mai in forward.
- PF sul campione intero derivato per aritmetica dagli aggregati [INFERITO],
  controprova al centesimo sul per-trade della cella A/N0.

## 📎 Tracciabilita'

- Criteri: `backtest_pipeline/prove/R83_INGRESSI_CRITERI.md` (congelati 18/08 sera)
- Firma: `report/FIRME_2026-08-18.md` — FIRMA 6
- CSV: `backtest_pipeline/risultati_archivio/r83_csv/` (14 aggregati + 14
  per-trade OOS + `REFERTO_RACCOLTA_R83.txt`, commit `2458b33`)
- EA del round: `mql5/Experts/ABTG_Apertura_3Ingressi.mq5` (compilato 0/0,
  `r83_compilazione_2026-08-18.txt`)
- Cronaca della corsa: `REFERTO_R83_R84_PREPARAZIONE.md`, PASSO 0-5 e 7
- Round gemello della stessa notte: `REFERTO_ROUND84_ABLAZIONE.md`
