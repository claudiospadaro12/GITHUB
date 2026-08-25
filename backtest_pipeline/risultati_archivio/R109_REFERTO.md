# 🏁 R109 — REFERTO DEL ROUND: ATR EXHAUSTION & VOLUME SPIKE, la prima misura

_Corsa: 25/08/2026 22:10-22:27 (17 minuti), tick reali, pin `5a9d5e0`,
driver `RIGA_R109_ATREXH.ps1` v1 (post-correzione ToDate). Esito driver:
PARZIALE per 10 problemi di lettura — **risolti dall'indagine del 26/08**
(`R109_INDAGINE_DEAL_2026-08-26.md`): i "deal anomali" erano un difetto del
PARSER (Sort-Object instabile sui deal nati nello stesso secondo, riga 710),
NON dell'EA né del tester. I numeri dell'OPTFRAME hanno **tre testimoni
concordi** (OPTFRAME, conteggio out dell'.htm, CSV per-trade dell'EA) e si
leggono a pieno titolo. Criteri FIRMATI ("FIRMO", 25/08, D1-D8).
Zip agli atti: `R109_ATREXH_CORSA_20260825_2210.zip`._

## ✅ IL BANCO E IL MOTORE SONO SANI — il verdetto è del MECCANISMO

- **Compilazione**: prima della vita dell'EA, 0 errori 0 warning.
- **Gate A0 (autotest interno): SUPERATO 7 blocchi su 7** — pivot, prossimità,
  esaurimento, volume costitutivo, grilletti, pavimento SL, orario: il motore
  ragiona esattamente come la sua firma. Il porting è FEDELE.
- **Gemelli IDENTICI su tutte le 6 celle.** L'accusa implicita all'EA nel
  referto driver del 25/08 è **RITIRATA** (indagine, prova per riproduzione
  esatta su 6/6 celle).

## 📊 LA TABELLA MADRE (OPTFRAME, finestra 2024.09.26→2026.08.21, rischio 1%)

| SIMB | LATO | PROFITTO | PF | DD% | n | Pegg. giornata (csv) |
|---|---|---:|---:|---:|---:|---:|
| D30EUR | LONG | −43.608 | 0,911 | **56,2** | 818 | −4,82 |
| D30EUR | SHORT | −59.085 | 0,831 | **67,8** | 927 | −5,01 |
| U30USD | LONG | −10.725 | 0,978 | 44,3 | 886 | −4,38 |
| U30USD | SHORT | −46.279 | 0,917 | 57,2 | 923 | **−9,72** |
| NASUSD | LONG | −48.548 | 0,885 | 59,2 | 655 | −4,57 |
| NASUSD | SHORT | −5.405 | 0,990 | 44,1 | 743 | −4,30 |

## ⚖️ IL VERDETTO — per corsia, come da criteri

**CORSIA RISCHIO (non si sospende mai, regola B): BOCCIATO SENZA APPELLO.**
DD 44-68% a taglia 1% e peggior giornata fino a **−9,72%** contro un muro
prop di −5,00%: sono fatti accaduti, non stime. Su 100k allo 0,65% i numeri
si riscalano MA NON LINEARMENTE (vedi fatto collaterale n.1): anche
riscalati, un DD della classe 30-45% resta fuori da qualunque contratto di
casa. **Questo motore, così com'è, non è candidabile a niente.**

**CORSIA MERITO: SOSPESA PER COSTRUZIONE** (criteri §7: un solo regime
rialzista, motore controtendenza, nessun out-of-sample). PF 0,83-0,99 su
6 celle = quanto è costato opporsi a QUESTO toro. Il verdetto di merito
definitivo richiederebbe la prova di regime (dati _EXT, oggi in frigo) —
ma è accademico finché la corsia rischio dice quello che dice.

**S0a (costo): SUPERATO dove misurato** — NASUSD long take lordo mediano
86,4 punti = 43× lo spread. Non è morto di costo: perde con margini larghi.

**FREQUENZA (la ragione del round): MISURATA, ED È ALTA.** 655-927 op/cella
in 21 mesi, 1,33 op/seduta sul solo NASUSD long, 99 giornate al cap di 3.
La frequenza che cerchiamo per la challenge ESISTE in questo meccanismo —
è il segno che manca.

## 🔍 TRE FATTI COLLATERALI DELL'INDAGINE (pesano oltre R109)

1. **Il lotto sbatte sul tetto `SYMBOL_VOLUME_MAX`=100** e viene tagliato:
   su NASUSD short è successo su 66 trade su 743 (8,9%) → quei trade
   rischiavano MENO dell'1%, quindi **i DD di questo round sottostimano il
   rischio a parità di regola** e non si riscalano linearmente con la taglia.
   Causa: SL strettissimi con `InpMinSLPts` spento (15 posizioni aperte e
   stoppate nello stesso secondo). È la lezione R55 fotografata dal vivo.
2. **Slippage reale sugli stop già visibile**: NASUSD short 06/06/2025,
   SL a 21.660,10 eseguito a 21.681,60 (21,5 punti oltre, perdita doppia
   dell'attesa). Con stop stretti lo slippage non è un dettaglio.
3. **Il parser dei deal**: difetto trovato, classe nuova a checklist
   (Sort-Object instabile sui pari — vedi indagine). Il driver non ha mai
   inventato numeri: ha scritto n/d e alzato problemi. Diagnosi sbagliata,
   comportamento giusto.

## 🧭 SECONDA CACCIA — cosa segue da questo NO

- **NIENTE griglia su questo motore** (ablazioni D1 previste "solo se S0
  passa e il quadro regge": il quadro non regge). Il capitolo "fade a pivot
  con volume, così com'è, su questo regime" è CHIUSO.
- Il meccanismo alternativo sulla stessa inefficienza è **già in porting**:
  VWAP Mean Reversion (banda+rifiuto, SL strutturale con pavimento ATR di
  serie — esattamente il pezzo che qui mancava).
- **Lezione di disegno per TUTTI i futuri candidati M15 indici**: pavimento
  SL OBBLIGATORIO (mai `InpMinSLPts=0`) — è la differenza fra un DD 56% e
  un motore testabile. Se mai si rivisitasse l'esaurimento, si riparte da
  lì E dalla prova di regime, non dai parametri.
- Il verdetto vale **per questa epoca** (21 mesi di toro, unico storico BCM).
  La porta della rivisitazione si apre solo con la prova di regime (_EXT).
