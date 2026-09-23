# 📐 COME SI LEGGE R239 — **congelato mentre la corsa gira, a numeri IGNOTI**

> Claudio ha lanciato R239 e è andato a dormire. Questo foglio si scrive **adesso**, prima che
> esista un solo numero. 🔴 È la terza volta che serve in due giorni, e le prime due hanno
> funzionato: sui 13 round e su R238 il criterio scritto prima ha retto **senza dover essere
> toccato**. Il contrario — scegliere la soglia dopo aver visto il PF — è il difetto del 10/09
> e la **classe 689** (*"scritto prima rende un cancello ONESTO, non VALIDO"*).

**Corsa**: `DESKTOP-H4D7CAJ` · pin `876ec042` · 4 file · 8 celle · **16 passate** · M5 tick reali ·
`-Deposito 100000` · `-Spread` non passato (**incognita dichiarata**).

---

## 0️⃣ SI GUARDA QUESTO PER PRIMO — **il cancello di determinismo, già pagato**

La cella **LONG+SHORT** di `R239a` e quella di `R239b` sono **la stessa configurazione**: stessi pin,
cambia **solo il magic** (`764250` / `764251`). Idem `R239c` / `R239d` (`764252` / `764253`).

# 🔴 Devono coincidere AL CENTESIMO. Se non coincidono, il banco non è deterministico e NESSUNA lettura di questo round vale.

🟢 Precedente che dice che è un controllo serio e non un rito: su R238 le celle "spenta" hanno
riprodotto R236a/b con **8 numeri su 8 a 5 decimali**.

---

## 1️⃣ POI L'ANCORA — e con la clausola che il cancello ha imposto

La cella **LUNGO PURO** è la sedia `770101` / `770202` **sui parametri** (confrontati riga per riga
coi `.set` FTMO: combaciano tutti, compreso `InpRiskPercent=2.00`).
🔴 **Ma il banco non è il campo**, e tre cose differiscono: **feed** (BCM `D30EUR`/`U30USD` contro
FTMO `GER40`/`US30`), **deposito** (100.000 contro saldo vivo ~78.242), **magic**.
👉 **Una somiglianza mancata va addebitata PRIMA a quelle tre, non al motore.**

---

## 2️⃣ LA BANDA — e metà di essa NON è un invariante

```
n(L+S) <= nC + nL        <- GARANTITO dal codice (InpAllowReverse=false, r.1028)
max(nC,nL) <= n(L+S)     <- NON GARANTITO
```
🔴 Il motivo: `gPhase = PH_PLACED` scatta quando il LIMIT è **PIAZZATO**, non **RIEMPITO**. Se il
lato che rompe per primo piazza e poi **scade inevaso** (`InpPendingExpiryMin=120`), la cella L+S
perde la giornata mentre la cella pura dell'altro lato può averla presa.
👉 **`n(L+S)` sotto `max(nC,nL)` NON prova che il banco sia rotto.** Va letto, non usato come allarme.

### Il residuo
`nC + nL − n(L+S)` = il fill del lato **non preso per primo** → sempre `>= 0`, ed è un **LIMITE
INFERIORE** delle giornate a doppia rottura. **Non è il conteggio.**

---

## 3️⃣ IL TEST VERO — **sul DAX lo short SOSTITUISCE, non somma**

Sul DAX i cinque filtri sono spenti → `TrendBias()=0` → tutti e due i lati validi. Quindi la cella
L+S **non è "la sedia + il corto"**: è la sedia a cui **il corto ruba giornate**.

| esito | lettura, congelata PRIMA |
|---|---|
| **`PF(L+S) > PF(lungo puro)`** e residuo > 0 | 🟢 il corto **aggiunge valore** dove ruba: è il caso che vale una misura in più |
| **`PF(L+S) ≈ PF(lungo puro)`** (±0,03) | ⚪ il corto **è neutro**: prende giornate che valevano quanto quelle che toglie |
| **`PF(L+S) < PF(lungo puro)`** | 🔴 il corto **ruba giornate che il lungo vinceva**. 👉 **NON si scrive "il corto non funziona"**: si guarda `PF(corto puro)` da solo, che è l'unica cella che misura il corto **senza cannibalizzazione** |

🔴 **Questa terza riga è la trappola della notte.** Il risultato comodo (*"visto? lo short peggiora,
teniamo il long"*) e il risultato vero (*"lo short ha preso il posto di long vincenti, ma da solo
vale"*) danno **lo stesso PF sulla cella L+S**. Si distinguono **solo** guardando la cella pura.

**Sul Dow non c'è cannibalizzazione**: `InpUseEmaFilter=true` su H4 congela `gBias` → un solo lato
al giorno → le celle pure stanno su **giornate disgiunte**. Lì il confronto è diretto.

---

## 4️⃣ IL RISCHIO — si legge **a qualunque n** (Emendamento B)

Si riportano **DD di tutte e quattro le celle** per simbolo. 🔴 E la domanda che conta per una sedia
viva: **accendere il corto alza o abbassa il DD?** Se lo abbassa, è un guadagno **reale anche se il
PF non si muove** — ed è l'unica cosa di questo round che si legge senza soglie di campione.

---

## 🔴 5️⃣ COSA NON SI SCRIVE, QUALUNQUE NUMERO ESCA

**Nessuna promozione e nessuno spegnimento**, per **tre ragioni vere** (la quarta, *"il merito è
impossibile per aritmetica"*, era **FALSA** ed è stata tolta: il tetto è ~182 posizioni, cioè
**sopra** 150, e in uscite fa ~177 col fattore **1,40** misurato):

1. 🔴 **Il costo NON passa sul DAX**: `33,0×` sulla geometria viva (`56,1 idx [MIS] n=2`), contro la
   frontiera. 🟢 Sul **Dow passa**: `123,8 idx [MISURATO] n=446 → 61,9×`, e **41,3× al p95**.
2. 🔴 **`770101` e `770202` stanno operando sulla challenge.** Ogni cambio in campo è **di Claudio**.
3. 🔴 Su **corto puro** e **L+S** l'`n` sarà molto più basso, e sul Dow **il filtro EMA dimezza le
   giornate**.

E resta fuori: il **40×** sul corto (**SOSPESO**: il `56,1` è la mediana di **due gambe LONG**), la
**falsificazione per contatori** (le passate girano in `Optimization=1`, sugli agenti, dove le
`Print` non si leggono), lo **spread** (incognita), il **regime** (21 mesi, un solo toro).

---

## 🚦 L'ORDINE IN CUI SI APRE LO ZIP
1. `RIEPILOGO_R239.txt` → **rc** e **CATENA COMPLETA 4 su 4**
2. `NON_PROMUOVIBILE.txt` → prima di qualunque numero
3. **Il cancello di determinismo** (§0) — se salta, si ferma tutto qui
4. Il **Dow** (`R239c/d`), dove non c'è cannibalizzazione: è il confronto pulito
5. Solo allora il **DAX** (`R239a/b`), con la regola del §3
6. I **DD** di tutte e otto le celle
