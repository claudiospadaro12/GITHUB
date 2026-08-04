# 🎯 PIANO PROP + CONTO PERSONALE — la rotta (brief Claudio, 02/08/2026)

> **La priorità n°1 è la PROP** (le prop), più di ogni altra cosa. Poi il conto personale.
> _"Dobbiamo farcela. È molto importante. Prendiamoci il tempo necessario."_ → metodo sui numeri, senza fretta.

---

## ⭐ PRINCIPIO GUIDA (Claudio, 04/08) — vale SEMPRE, soprattutto per la PROP e i TF alti
**Portare a casa il profitto, anche se poco. Se il prezzo si gira, meglio incassare/proteggere che ridare indietro.**
→ BE appena in profitto · parziale · trailing. **Consistenza > massimizzare.** Un vincitore non deve mai diventare perdente.
Per la prop questo conta doppio: **DD basso + costanza** fanno passare la challenge, non i colpi grossi.
_(Nota onesta: proteggere il profitto evita di ridare indietro, ma NON crea l'edge — serve comunque un ingresso/selezione con vantaggio. Le due cose insieme, dati 03/08.)_

## 1) 🏆 PROP — priorità massima

### Profilo EA prop ideale (parole di Claudio)
- **TF preferito: H1.** L'H4 spesso è troppo lento.
- **Durata trade:** chiusura **in giornata o max 2 gg**; accettabile fino a **4 gg**. Un mese è troppo. **Weekend OK** (si può tenere).
- **Gestione voluta:** **parziale + stop in pari + trailing** → **profitti COSTANTI**. Accetta di lasciare sul tavolo i "runner" (giorni in cui il prezzo corre tanto) in cambio di **costanza**.
- **Metrica che comanda:** **DD BASSO** + robustezza (è ciò che fa passare una challenge).

### ✅ Candidati che GIÀ rientrano nel profilo (validati tick reali)
| EA | Simbolo | TF | PF | DD% | Durata trade | Note |
|---|---|---|---|---|---|---|
| **SupRev H1** | Nasdaq | H1 | 1,40 | **1,2** | ~intraday/1gg | ⭐ il più vicino all'ideale |
| SupRev H4 | Nikkei | H4 | 1,05 | **0,14** | ~7h (reversal) | DD bassissimo (ma H4) |
| SupRev H4 | Oro | H4 | 1,46 | 1,2 | ~7h | chiude in giornata |
| GoldenCross H4 | USDCHF | H4 | ~2,6 | 1,9 | — | robusto |
| EMA200 H4 | 200AUD/SPX | H4 | 1,4-1,6 | 1,4-1,9 | — | il motore più robusto |

**Insight:** i motori **reversal (SupRev)** chiudono in fretta (7h-1gg) → sono i più adatti al vincolo "1-2 giorni". Il TF H1 accorcia ancora.

### ⏱️ Durata dei trade (dato 04/08, da `trades_auto.csv`) — perché H1 > H4 per la prop
- H4 swing (SupRev/GoldenCross/EMA200) **non hanno uscita a tempo**: chiudono solo su TP/SL/trailing → tengono **giorni** (posizioni del 29-31/07 ancora aperte = normale, non bug; +weekend ~2,5gg fermi).
- Durata media misurata: **STREV Nasdaq H1 = 1,7gg**, EMA200 ~1gg, SupRev oro chiusi ~5-11h; la coda lunga (still-open) è ~1 settimana.
- ⚠️ H4 = capitale bloccato + **gap del weekend** = scomodo per prop. **H1 = rotazione ~1-2gg** → preferito.
- 🔲 DA FARE: misurare la **durata media H4 completa** (aperti+chiusi) su Claudio manda le posizioni aperte / statement completo.

### 🧲 PRINCIPIO (intuizione Claudio 04/08): più tempo aperto = più il bias può girarsi
Un H4 tenuto giorni attraversa più cambi di bias → un +2R può tornare in perdita. Rimedio = **proteggere il profitto**:
- **BE** appena in profitto → un vincitore non diventa più perdente (nel peggio esci a pari).
- **Trailing** → se il bias si gira, esci in profitto invece di ridare tutto.
- ⚖️ La QUADRA è la **distanza**: troppo stretta = taglia presto (problema 03/08); troppo larga = ridà indietro (questo punto). Sono i due lati dello stesso bottone → è ciò che misura la FASE B "-Fase distanze".
- **Weekend**: rischio gap del lunedì → valutare `InpFridayClose` (opt-in) sugli EA prop.
- H1 riduce il tempo di esposizione → meno cambi di bias attraversati.

### 🔧 IDEA Claudio 04/08 — trailing "in H4", non in M1 (da testare sugli EA swing prop)
- **BE non negoziabile**: appena in profitto (dopo +1R o 1 candela H4 chiusa a favore) SL a pari → dopo giorni in profitto NON si perde più.
- **Trailing su base H4/H1** (`InpTrailMode=PREVBAR`, `InpTrailTF=H4` o H1): segue il minimo/massimo della candela H4 → dà respiro, non taglia sul rumore (errore 03/08 = trailing M1 su trade grosso).
- ⚖️ Cautela: su H4 i ritracciamenti in PUNTI sono grandi → il trailing H4 "ridà indietro" di più. Largo vs stretto = si decide sui numeri (fase distanze), non a intuito.
- TEST prop: BE@1R + trailing H4/H1 **vs** trailing stretto → su SupRev/GoldenCross/EMA200 (i validati H4/H1).

### 📋 Piano d'attacco PROP (in ordine)
1. **Validare a TICK REALI in H1** i motori sul TF che preferisci (l'H1 è poco esplorato):
   - **GoldenCross H1** ⬅️ primo: OHLC fortissimi (Oro 2,01 · USDJPY 1,97 · GBPUSD 1,78), tick reali H1 mai fatti.
   - SupRev H1 / EMA200 H1 su simboli scelti.
2. **Filtro DURATA:** d'ora in poi misuro la durata media trade di ogni candidato → tengo solo chi chiude entro ~2 gg (dal report reale o dai backtest per-deal).
3. **Walk-forward IS/OOS** sui finalisti H1 (anti-overfit) — ultimo cancello prima del dry-run.
4. **Dry-run sul demo 100k + Guardian** (FTMO 2-Step): si simula la challenge con i finalisti.
   - NB: FTMO 2-Step non ha limite di tempo → l'H4 lento sarebbe ammesso, ma tu preferisci H1 per costanza e rotazione del capitale. Seguiamo la tua preferenza.

---

## 2) 💻 CONTO PERSONALE — aperture M5
- **Puntare sulle aperture M5** (tua scelta).
- Motore: **confronto STOP vs RETEST** in corso (tick reali) → si sceglie quello che regge i costi.
- **Gestione = parziale + BE + trailing** (già come la vuoi tu): il **fix gestione per-ticket** del 01/08 fa scattare parziale/BE su OGNI posizione → profitti più costanti, niente più +800→−700.
- Filosofia: **accontentarsi del bottino "normale"** (parziale/BE/trailing) per avere **profitti costanti**, senza inseguire i massimi.

---

## 3) 🧭 Come lavoriamo
- **Osservazione:** tutta la flotta accesa sul demo fino alla **quadra del mese** (per il dataset completo).
- **Pagella per-EA settimanale** (magic/commento) → a fine mese si decide EA per EA: edge / bug / rumore.
- **Prendersi il tempo.** Niente scorciatoie: si promuove un EA solo quando i numeri (tick reali + walk-forward + dry-run) lo confermano.

_Obiettivo realistico: NON 52 EA buoni, ma pochi robusti e poco correlati — anche 1 solo EA prop-grade è un successo._

---

## 4) 💰 QUANTO VALGONO GLI STESSI TRADE SU 100k (calcolo del 03/08)

Domanda di Claudio sulle 4 posizioni aperte del 03/08 (2 CAC + 2 Oro, floating +108,24 €).
Cambio ricavato dai P&L stessi: **EUR/USD ≈ 1,1520** [VERIFICATO — 45,79/39,75 e 46,22/40,13 danno lo stesso numero].

| Posizione | EA | Lotti oggi | Se arriva al TP (oggi) | Lotti su 100k | **Se arriva al TP su 100k** |
|---|---|---|---|---|---|
| CAC #2943866 | SupRev CAC H4 Ott (`L 1/3`) | 0,10 | +24,88 € | 1,66 | **+413 €** |
| CAC #2943869 | SupRev CAC H4 Ott | 0,10 | +24,88 € | 1,66 | **+413 €** |
| Oro #2957063 | SupRev **Multi** (`S 2/3`) | 0,01 | +52,81 € | **0,32** | **+1 690 €** |
| Oro #2958388 | SupRev (`S 1/3`) | 0,01 | +77,34 € | **0,32** | **+2 475 €** |
| | | | **≈ +178 € = 2,96%** | | **≈ +4 990 € = 5,0%** |

⚠️ **Non è una proporzione: 100k non rende 16,7× ma ~28×.** Il motivo è il punto sotto.

### Il rischio NON è l'1% che pensiamo — sull'oro è la metà

Tutti e tre gli EA hanno `InpRiskPercent = 1.0` [VERIFICATO nel sorgente]. Ma `LotByRisk()` fa
`lot = MathFloor(lot/step)*step` e sull'oro, con un conto piccolo, il lotto teorico cade **sotto 0,02**:

- stop oro = 35,74 $ per 0,01 lotti = **31,02 €**
- 1% di ~6 000 € = 60 € → lotto teorico **0,019** → arrotondato giù a **0,01**
- rischio reale = **0,52%, non 1%**

Su 100k il lotto teorico è 0,32 e l'arrotondamento non morde più: rischio **0,99%**, cioè quello vero.
**Sul conto piccolo l'oro rischia (e rende) la metà del previsto.** Il CAC no: a 0,10-0,30 lotti l'arrotondamento è irrilevante.

📐 Dal vincolo di arrotondamento si ricava anche il saldo: **fra 3 102 € e 6 204 €** [INFERITO], coerente con i ~6k a registro.

### Il numero che conta per la prop

Al momento dell'ingresso c'erano **tre famiglie aperte insieme**: CAC 1% + Oro 1% + Oro 1% = **3% simultaneo**.
Il limite giornaliero FTMO è **−5%**. E le due posizioni oro sono **due EA diversi sullo stesso simbolo, stessa direzione**: non è diversificazione, è **una posizione doppia** — lo stesso difetto visto sul Nasdaq il 03/08 (tre EA, direzioni opposte, netto −30,60).

→ Prima del dry-run serve un **tetto di rischio di flotta** (esposizione aggregata, non solo per-trade). Il `ABTG_Guardian` oggi guarda il DD del conto, non il rischio aperto contemporaneamente.

### Nota sul CAC
`SupRev CAC` è nella lista **scartati** (OHLC PF 7,37 → tick reali **0,96**). Che oggi sia in profitto non lo riabilita: è esattamente il caso in cui un trade buono non è un dato.
