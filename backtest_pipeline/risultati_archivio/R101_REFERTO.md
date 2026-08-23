# R101 — REFERTO (PARZIALE): l'ablazione dei filtri su Dow e DAX

_Corsa del 23/08/2026, avvio 21:59, pin `e4c1afac63f0d094e7895d5f0626a183c43f0566`,
modo CORSA, tick reali (modello 4), finestra 2024.09.26→2026.06.30, split 40/60
(IS fino al 2025.06.09, OOS dal 2025.06.10 — le stesse di R88/R97/R98).
Rischio nei file prova: 1,00%. **In campo sul 100k è 0,65%: ogni DD di questo
referto si converte ×0,65 prima di confrontarlo col forward** (criteri par. 2.4).
Giudizio compilato a mano sopra la tabella del driver + i 22 CSV del zip
`R101_ABLAZIONE_CORSA_20260823_2159.zip`, come previsto dai criteri
("i cancelli li applica il referto del round, non il driver")._

**STATO: PARZIALE.** Famiglia DOW completa e giudicata (10 celle).
Famiglia DAX ferma al metro per un **difetto del driver** (checklist 64,
sotto): i 9 gradini DAX non sono mai partiti. Il round si chiude quando
torna il zip della ripresa `-SoloEa DAX`.

---

## 1. Il gate G0: i due metri si riproducono? SÌ, TUTTI E DUE.

| famiglia | atteso agli atti | misurato | gemelli | verdetto |
|---|---|---|---|---|
| DOW (770202) | PF 1.270 · DD 4.39% · n 130 | PF 1.270 · DD 4.39% · n 130 | IDENTICI | ✅ **RIPRODOTTO al centesimo** |
| DAX (770101) | PF 1.400 · DD 7.23% · n non agli atti | PF 1.397 · DD 7.23% · n OOS 270 | IDENTICI | ✅ **RIPRODOTTO NEI FATTI** (PF dentro la tolleranza firmata ±0,01; DD esatto) — ma il DRIVER l'ha bocciato per il difetto sotto |

**Adjudicazione del falso rosso DAX.** Il driver ha scritto `NON RIPRODOTTO —
n OOS 270 contro -1 agli atti`. Ma `-1` era il SENTINELLA "n non agli atti"
(il n del DAX per questa finestra non è mai stato misurato prima: lo misura
questa corsa, come dichiarato nei criteri), e la guardia che doveva saltare
il confronto era scritta nel codice. Il verdetto di questo referto, coi
criteri firmati alla mano: **G0 DAX = RIPRODOTTO**. Il n misurato adesso
(IS 175 / OOS 270) entra agli atti come metro delle prossime corse.

**Adjudicazione delle 5 celle "SALTATA DAL DRIVER"** (DOW 00–04): i CSV
c'erano già dal lancio delle 20:xx della stessa serata, stesso pin
`e4c1afac`, stessa macchina, stessi file prova — il driver li ha
onestamente marcati "non di questo lancio". **Sono validi e li giudico**:
stesso codice, stessa serata, riproducibilità dimostrata dal metro G0.

## 2. Il difetto che ha fermato il DAX (checklist 64 — classe NUOVA)

`F "DAX" ... 7.23 -1 "..."`: un argomento posizionale **negativo** a una
funzione PowerShell con parametri non tipizzati arriva come **stringa**
`"-1"` (i positivi arrivano interi; solo i negativi diventano stringhe).
E `"stringa" -gt 0` è un confronto di **stringhe** culture-aware, il cui
esito dipende dall'OS: su **Windows PowerShell 5.1** (NLS, il PC di
backtest) il trattino è ignorabile → `"-1" -gt "0"` confronta `"1"` con
`"0"` → **VERO** → il gate sull'n si è applicato quando non doveva. Su
pwsh/Linux (ICU, dove il verificatore aveva ESEGUITO davvero i gate) →
FALSO → il difetto era invisibile. È la prima classe che passa
un'esecuzione reale del verificatore e cade solo sull'OS di destinazione.
**Fix**: parametri tipizzati (`[int]$n`, `[double]$pf`) + cast sul posto
nei confronti col sentinella. Riprodotto, corretto, agli atti.

## 3. La tabella madre COMPLETA (IS+OOS, compilata dai CSV — §5.1 dei criteri)

Il costo del filtro = profitto OOS della viva − profitto OOS della cella
(euro all'1% su 100k). "op tolte" = n viva − n cella (OOS). Gemelli
IDENTICI in tutti i 22 CSV. Peggior giornata: −1,02% (Dow) / −1,08%
(DAX) in quasi tutte le celle — è lo stesso giorno, il filtro non lo evita.

### DOW (viva OOS: +6.721,93 € · PF 1,270 · DD 4,39% · n 130)

| gradino | IS: prof · PF · DD · n | OOS: prof · PF · DD · n | ΔPF OOS | ΔDD OOS | costo € OOS | op tolte |
|---|---|---|---:|---:|---:|---:|
| 00_viva (metro) | +2.812 · 1,222 · 5,67 · 74 | +6.722 · 1,270 · 4,39 · 130 | — | — | — | — |
| 01_ema (TOGLIE l'EMA H4) | **−2.274 · 0,920 · 10,85** · 139 | +8.860 · 1,193 · 7,01 · 214 | −0,077 | **+2,61** | −2.138 (guadagna di più ma peggio) | −84 (ne AGGIUNGE) |
| 02_volumi | +1.266 · 1,236 · 3,14 · 31 | +5.138 · **1,543** · **2,83** · 56 | **+0,273** | **−1,57** | 1.584 | 74 |
| 03_atr | +2.812 · 1,222 · 5,67 · 74 | +6.722 · 1,270 · 4,39 · 130 | 0,000 | 0,00 | **0** | **0** |
| 04_corso_or | +1.266 · 1,236 · 3,14 · 31 | +5.138 · 1,543 · 2,83 · 56 | +0,273 | −1,57 | 1.584 | 74 |
| 05_supertrend3 | **+315 · 1,042** · 2,91 · 36 | +6.935 · **1,557** · 4,23 · 72 | +0,287 | −0,16 | −213 | 58 |
| 06_correlazione | +1.694 · 1,134 · 5,67 · 68 | +4.335 · 1,184 · 4,90 · 112 | −0,086 | +0,51 | 2.387 | 18 |
| 07_vwap | **+6.440 · 2,152** · 2,80 · 47 | +4.096 · 1,278 · **3,36** · 77 | +0,007 | −1,04 | 2.626 | 53 |
| 08_tondi | +2.627 · 1,333 · 2,84 · 86 | +4.804 · 1,213 · 4,87 · 147 | −0,057 | +0,48 | 1.918 | −17 (ne aggiunge: è gestione, non filtro) |
| 09_corso_pieno | +1.791 · 1,531 · 3,14 · 20 | +1.041 · 1,197 · 2,32 · **26** | −0,073 | −2,08 | 5.681 | 104 |

### DAX (solo il metro: i gradini sono in ripresa)

| gradino | IS: prof · PF · DD · n | OOS: prof · PF · DD · n |
|---|---|---|
| 00_viva (metro) | +3.789 · 1,126 · 5,44 · **175** | +18.030 · 1,397 · 7,23 · 270 |

**Nota che pesa:** il DAX ha **n IS 175 ≥ 150** — è l'unica delle due
famiglie su cui l'Emendamento regola A permette di giudicare il MERITO.
Sul Dow (IS 74, OOS 130) il merito resta SOSPESO: tutto il par. 4 è
INDIZI, come firmato (G4).

## 4. La lettura gradino per gradino — DOW (indizi, in attesa di G3 dal DAX)

- **01_ema — il filtro EMA H4 PAGA, e tanto.** Senza EMA l'IS va in
  **perdita** (−2.274 €, PF 0,920, DD 10,85%): il filtro trasforma un
  motore che perde in uno che guadagna nella finestra IS, e nell'OOS
  taglia 2,6 punti di DD al costo di parte del profitto. G2 boccia la
  rimozione su tutta la linea. **La cella viva esce CONFERMATA** — primo
  risultato solido del round.
- **02_volumi — l'indizio più interessante del round.** PF OOS 1,543
  (+0,273) e DD 2,83% (−1,57): meglio su ENTRAMBI gli assi di G2, e n
  OOS 56 passa G1 (≥30). Anche l'IS migliora su PF e DD. Il prezzo è
  metà del campione (74 op tolte) e 1.584 € di profitto assoluto.
  **Candidato Dow-side. Il verdetto vero lo dà G3**: se sul DAX lo
  stesso filtro va nella stessa direzione, è un candidato da firma;
  se va al contrario, è la finestra fortunata (criteri par. 4.1 — con
  18 confronti sulla stessa finestra qualcuno esce verde per caso).
- **03_atr — il filtro nullo, e questa È una misura.** Identico alla
  viva **al centesimo**, IS e OOS: la soglia del corso (ATR ≥ 1,0×
  media 20) **non toglie nemmeno un trade** sulla nostra geometria.
  Il "filtro ATR" del corso, applicato alla lettera, qui non esiste.
- **04_corso_or — è 02 sotto altro nome.** Identico a 02_volumi al
  centesimo: con l'ATR che non filtra niente, la combinata misura solo
  i volumi. Nessuna informazione aggiuntiva.
- **05_supertrend3 — il ribaltone IS/OOS, la lezione di R98.** OOS
  bellissimo (PF 1,557), ma l'IS dice il CONTRARIO (PF 1,042, profitto
  +315 €): lo stesso specchio che in R98 smascherò il rumore di regime.
  Da solo non è un candidato; G3 sul DAX decide se c'è qualcosa.
- **06_correlazione — COSTA.** PF −0,086, DD +0,51: peggiora entrambi
  gli assi togliendo solo 18 operazioni. Indizio di bocciatura netta.
- **07_vwap — il caso strano (l'unico non-corso).** IS spettacolare
  (PF 2,152, DD 2,80) e OOS alla pari della viva (ΔPF +0,007) con DD
  migliore (−1,04). Tecnicamente passa G2, ma il ΔPF OOS è zero virgola:
  quello che il VWAP migliora davvero è l'IS. Curioso, non convincente;
  G3 e l'eventuale replica su altra finestra prima di pensarci.
- **08_tondi — COSTA, e non è un filtro.** n SALE a 147 (è una gestione:
  i tondi come primo obiettivo cambiano le uscite), PF −0,057,
  DD +0,48. Il corso qui, sulla nostra geometria, peggiora.
- **09_corso_pieno — NON MISURABILE, come scritto PRIMA dei numeri.**
  n OOS 26 < 30 (G1). La checklist del corso applicata alla lettera
  NON PRODUCE UN CAMPIONE giudicabile sopra il nostro motore. Nessuna
  soglia si abbassa per farla "funzionare". (E per la cronaca, senza
  valore di verdetto: PF 1,197, sotto la viva.)

## 5. Cosa NON dice questo referto (dichiarato)

- **G3 non è ancora applicabile**: serve la tabella DAX. Ogni "candidato"
  del par. 4 è un mezzo giudizio.
- **G5: nessuna promozione.** Le due sedie girano sul 100k: qualunque
  cambio al forward è una firma successiva con referto suo.
- La finestra è UN regime (21 mesi di indici in salita) e questo OOS è
  già stato guardato molte volte. È il motivo per cui G3 esiste.
- Nessuna misura di spread, regime, walk-forward nuovo.

## 6. La ripresa (in mano a Claudio)

Driver corretto (cast numerici sul gate, checklist 64), nuovo pin, riga
`-SoloEa DAX` verificata dal verificatore. Il metro DAX rigira (2 CSV,
è il denominatore) e poi i 9 gradini: 20 passate. Al ritorno del zip:
tabella DAX nel par. 3, G3 gradino per gradino (tranne il gradino 01,
asimmetrico per firma: si legge come due misure separate), e il referto
passa da PARZIALE a CHIUSO.
