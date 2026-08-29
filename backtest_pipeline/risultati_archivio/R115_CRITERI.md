# 🧪 R115 — LEVA REVERSE (DAX) + ESTENSIONE RETEST (Nasdaq, Dow) — CRITERI **FIRMATI**

> 🖊️ **FIRMATO — Claudio, 29/08/2026.** Firma con UNA scelta esplicita di
> perimetro: **GEOMETRIA NATIVA per simbolo** (NON la geometria-DAX sugli
> US). Bozza scritta lo stesso giorno, PRIMA di qualunque numero, dalla
> sessione agente. Il lucchetto e' TOLTO: il driver, che legge questo file
> al pin, ora trova "FIRMATI" e la corsa vera puo' partire. Il MECCANISMO
> del cancello resta com'e' (se un domani ricomparisse la stringa del
> lucchetto — scritta spezzata `[DA` + `FIRMARE]` per non richiuderlo per
> sbaglio in una citazione — la corsa vera si fermerebbe con exit 2).
>
> **La scelta della firma, spiegata:** e' il **test EQUO** — "esiste un
> edge retest su QUESTO simbolo, al suo meglio?" — non un confronto a
> geometria costante. Cosi' un eventuale FALLITO su Nasdaq/Dow non si puo'
> liquidare come "gli avevo messo i parametri del DAX": ogni simbolo gira
> con la geometria della sua sedia viva.

---

## 0. 🎯 LA DOMANDA — DUE MISURE, UN SOLO PACCHETTO

Il **DAX Apertura EU** gira in forward col **RETEST** (`InpEntryMode=2`,
`InpAllowReverse=false`): e' l'**unico motore apertura in utile OOS con
campione vero** (+392,96 / PF 1,065 / 244 trade — cella viva 770101,
`prove/R103_ABTG_DAX_Apertura_EU_D30EUR_770101.txt`). Due spinte, a
criteri congelati PRIMA dei numeri:

- **(a) LEVA REVERSE sul DAX** — `InpAllowReverse` false (attuale) vs true.
  Col reverse, dopo il primo ciclo l'EA sorveglia il **lato OPPOSTO**
  (tetto rigido **2 cicli/giorno**, solo RETEST, mai due posizioni vive
  insieme, secondo ciclo solo da flat — conto HEDGING). **La cattura
  extra vale il rischio?**
- **(b) ESTENSIONE a NASDAQ e DOW** — il RETEST alla **GEOMETRIA NATIVA di
  ciascun simbolo** (firma 29/08) su Nasdaq Apertura US e Dow Apertura US,
  OOS, per vedere se l'edge del retest esiste su quei simboli **al loro
  meglio**. Non e' un confronto a geometria costante col DAX: e' il test
  equo per ciascuno.

**QUESTA E' UNA MISURA, NON UN ROUND CHE PROMUOVE.** Non tocca il forward
(G5), non promuove nessuna sedia. Magic **VERGINI** (blocco 766xxx).

---

## 1. ⚠️ IL PARAGRAFO PIU' IMPORTANTE — IL TRANELLO DEL REVERSE, MISURATO NEL SORGENTE

`ABTG_DAX_Apertura_EU.mq5`, righe 472-475 (LETTE, non ricordate):

> `if(InpAllowReverse && !(InpAllowLong && InpAllowShort))`
> `   ABTGLog("...il secondo ciclo puo' partire solo se il lato mancante`
> `   e' abilitato. Cosi' com'e', quasi mai.");`

**La sedia viva DAX e' LONG-ONLY** (`InpAllowShort=false`, artefatto della
770101). Quindi `InpAllowReverse=true` **DA SOLO NON FA NIENTE**: il
secondo ciclo, che e' uno SHORT, non puo' armarsi se lo short e' vietato.
Accendere il reverse sulla sedia viva senza abilitare lo short sarebbe
un interruttore decorativo — la classe di errore di R114 (leva 15 ignorata
in silenzio) e del checklist 84.

**Conseguenza sul disegno dell'A/B (dichiarata):** il reverse si misura a
**TRE celle**, non due, per non cambiare due cose insieme:

| cella | InpAllowLong | InpAllowShort | InpAllowReverse | cos'e' |
|---|---|---|---|---|
| `DAX_00_vivo`    | true | **false** | false | la 770101 VIVA, tale e quale (BASELINE del forward) |
| `DAX_01_bilat`   | true | **true**  | false | due lati, NIENTE reverse |
| `DAX_02_reverse` | true | **true**  | **true** | reverse ACCESO |

- **L'A/B "a UNA variabile" e' `01` vs `02`**: cambia SOLO
  `InpAllowReverse`. E' il reverse PURO.
- **`00` vs `01`** isola il costo del solo **primo ciclo SHORT** (che il
  reverse tira dentro per forza).
- **`00` vs `02`** e' la domanda operativa vera: "se accendo il reverse
  in forward (che vuol dire abilitare short + reverse), cosa cambia?".

Il verdetto sul reverse si LEGGE dai tre numeri insieme; dichiararne uno
senza gli altri due non vuol dire niente.

---

## 2. 🔩 PERIMETRO — 7 celle, 3 EA, 3 simboli

| id | EA | simbolo | lato | magic gemelli |
|---|---|---|---|---|
| DAX_00_vivo    | ABTG_DAX_Apertura_EU   | D30EUR | LONG (vivo)     | 766010/766011 |
| DAX_01_bilat   | ABTG_DAX_Apertura_EU   | D30EUR | LONG+SHORT      | 766020/766021 |
| DAX_02_reverse | ABTG_DAX_Apertura_EU   | D30EUR | L+S+REVERSE     | 766030/766031 |
| NAS_00_long    | ABTG_Nasdaq_Apertura_US| NASUSD | LONG            | 766110/766111 |
| NAS_01_short   | ABTG_Nasdaq_Apertura_US| NASUSD | SHORT           | 766120/766121 |
| DOW_00_long    | ABTG_Dow_Apertura_US   | U30USD | LONG            | 766210/766211 |
| DOW_01_short   | ABTG_Dow_Apertura_US   | U30USD | SHORT           | 766220/766221 |

**Geometria — NATIVA per simbolo (firma 29/08).** Comune a tutte e 7: retest
`InpEntryMode=2`, parziale 50%, `InpRiskPercent=0.65` (taglia uniforme, per
DD comparabile — dichiarato, NON e' la taglia nativa US), mai overnight,
RoundLevels/News OFF. La GEOMETRIA (range, buffer, offset, filtro trend,
chiusura) e' quella della **sedia viva di ogni simbolo**, letta dai config:

| | RangeMode | RangeMin | LevelTF | Buffer | Offset | filtro EMA | chiusura server | fonte |
|---|---|---|---|---|---|---|---|---|
| **DAX** (D30EUR)   | 0 (apertura) | 35 | — | 500  | 200 | OFF      | 17:30 | 770101 vivo (R103) |
| **Dow** (U30USD)   | 0 (apertura) | 35 | — | 1000 | 400 | ON (H4, 1/50) | 17:30 | **770202 vivo** (R103, gia' retest) |
| **Nasdaq** (NASUSD)| 2 (candela H1 prec.) | 15 | H1 | 300 | 0 | ON (H4, 1/50) | 20:45 | preset live `ABTG_Nasdaq_Apertura_US.set` + overlay H4 |

- **Dow**: la sedia viva 770202 **e' gia' un retest** — la geometria non e'
  inventata, e' quella misurata in R103.
- **Nasdaq**: la sedia viva e' **BREAKOUT**, non retest. Quindi
  `InpEntryMode=2` e `InpRetestOffsetPts=0` sono **[INFERITO]** (nessun
  valore retest vivo su Nasdaq); il resto della geometria (RangeMode 2,
  RangeMin 15, LevelTF H1, buffer 300, filtro H4, chiusura 20:45) e'
  quella del preset vivo. **Cambia** il simbolo, l'ora di sessione, la
  geometria nativa, il lato e (sul solo DAX) il reverse.

**⚖️ REGOLA DEI DUE LATI (25/08):** sugli indici si misurano SEMPRE long
E short. Per questo Nasdaq e Dow hanno un file per lato. Il DAX vivo e'
long-only per contratto, e le sue tre celle nascono dalla domanda (a).

---

## 3. 🕐 FUSO ORARIO — ORA SERVER, DICHIARATA PER SIMBOLO (regola di casa, difetto gia' pagato)

Il server BCM e' **1 ORA INDIETRO** dall'ora italiana.

| simbolo | apertura IT | − 1 h | **ora SERVER (negli .ini)** | InpSessionHour / Min |
|---|---|---|---|---|
| D30EUR (DAX)      | 09:00 | 08:00 | **08:00 server** | 8 / 0 |
| NASUSD (Nasdaq)   | 15:30 | 14:30 | **14:30 server** | 14 / 30 |
| U30USD (Dow)      | 15:30 | 14:30 | **14:30 server** | 14 / 30 |

Chiusura/flat 17:30 server per tutte e tre (= DAX vivo; = Dow vivo).
Il driver **rifiuta** (throw) un file prova con `InpSessionHour=9` (DAX) o
`=15` (US): sarebbe l'ora italiana, da cestinare. Il giro a vuoto stampa
l'ora server usata per ogni simbolo.

---

## 4. 📐 BANCO, FINESTRA, IS/OOS

- **Modello 4 (TICK REALI)**, deposito 100.000, Spread=0 scritto nell'ini
  (spread corrente, dichiarato — NON misurato, NON uno stress).
- **TF: M5** — il TF con cui girano le sedie apertura vive (D30EUR M5,
  NASUSD M5, U30USD M5; FLOTTA_ATTIVA + DEPLOY_GUARDIANO_100K).
- **Finestra: 2024.09.26 → 2026.06.30 (21 mesi).** Il pavimento 2024.09.26
  e' il **tetto tick misurato** dalla sonda del 17/08 (il broker BCM non
  ha storico indici prima; verdetto COMPLETO). NON e' una scelta.
  ⚠️ Il giro a vuoto DEVE ristampare la prima data tick vera per simbolo:
  se un simbolo parte dopo, si DICHIARA e si adegua.
- **IS/OOS: split 40/60** (FrazioneIS=0.40 del driver generico, LO STESSO
  di R101/R103 da cui viene il metro del DAX vivo):
  - **IS  2024.09.26 → 2025.06.09** (~8,5 mesi)
  - **OOS 2025.06.10 → 2026.06.30** (~12,5 mesi, il pezzo piu' grosso)
- ⚠️ **UN SOLO REGIME, 21 mesi.** La PROVA DI REGIME (regola C, quattro
  finestre toro/orso/laterale/crollo) NON e' eseguibile: il disco non
  arriva prima del 2024.09.26. Dichiarato, non nascosto.

---

## 5. ⚖️ CRITERI DI LETTURA — CONGELATI PRIMA DEI NUMERI

**Cosa DECIDE (per cella):**
1. **PF OOS** contro il pavimento di casa **1,10**.
2. **Aspettativa per trade** (netto medio / n) — un motore che non copre
   il proprio costo non passa, per quanto alto sia il PF su pochi trade.
3. **DD OOS** contro il muro prop, riletto a taglia — e la **peggior
   giornata**.

**Per il REVERSE (a) — la regola specifica:**
- La **cattura extra** del reverse (`02` vs `01`: piu' trade, piu'
  profitto) **NON deve peggiorare ne' il DD ne' la peggior giornata**.
  Se `02` cattura di piu' MA alza il DD o la peggior giornata sopra `01`,
  il reverse **non passa** — la valvola e' il RISCHIO, non il MERITO.
- Il reverse aggiunge un SECONDO ciclo lo stesso giorno: la **peggior
  giornata** e' la metrica che lo giudica per prima (due perdite in un
  giorno).

**Per l'ESTENSIONE (b):**
- Il retest "regge oltre il DAX" **solo se** su Nasdaq/Dow fa PF OOS
  ≥ 1,10 con DD sotto il muro. **Prior MISURATO da rileggere**
  (`CACCIA_MOTORE_APERTURE.md`, 02/08): il retest a un'altra geometria
  usci' **Dow 0,94 · Nasdaq 0,73 (DD 27%) · DAX 0,79**, BOCCIATO. Se
  anche a **geometria nativa** + finestra-OOS il Nasdaq rifa' un DD del
  genere, **e' un rischio, e il rischio si legge sempre**.

**⚖️ CAMPIONE SOTTILE → MERITO SOSPESO, RISCHIO SEMPRE (valvola R59):**
se `n(OOS) < 150` (soglia della REGOLA DELLA FINESTRA, emendamento 16/08),
la cella **NON riceve un verdetto di MERITO** — ma il DD e la peggior
giornata si leggono lo stesso, perche' sono **fatti accaduti**. Con ~244
trade DAX sui 21 mesi pieni, l'OOS al 60% e' **vicino alla soglia**: la
sospensione del merito e' probabile, e va dichiarata cella per cella.

**🚫 NIENTE PICCO:** questo round non sceglie celle da una griglia (non
c'e' griglia). Ma la regola di casa resta scritta: un numero si legge col
suo metro (baseline `00`/`01`) accanto, mai da solo.

---

## 6. 🧾 COSA IL ROUND NON FA (dichiarato)
- NON tocca i `.mq5` (zero righe di MQL5: reverse e retest sono
  interruttori gia' nel sorgente).
- NON tocca il forward, NON promuove, NON spegne nessuna sedia.
- NON misura lo spread (Spread=0 dichiarato).
- NON misura il margine prop (e' il buco di R114, si chiude sui simboli
  della prop, non qui).
- NON fa la prova di regime (disco insufficiente, § 4).
