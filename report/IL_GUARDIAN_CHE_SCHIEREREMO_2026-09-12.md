# 🛡️ IL GUARDIAN CHE SCHIEREREMO IL 1 OTTOBRE — quanto costa, in numeri

**Sabato 12/09/2026 sera. 19 giorni alla challenge.** Referto di **sola
lettura**. 🛑 **Nessun EA, preset, parametro, magic, grafico o sedia toccato.
Nessun backtest eseguito. `CODA.txt` non aperto. Nessuna riga mandata al VPS.**
Taglie, parametri di rischio, protezioni e conto reale restano **firma di
Claudio**.

> 🚦 **CANCELLO, dichiarato.** Il cancello deterministico
> (`controlla_riga.py --oggetto md`) l'ho girato io sul file e l'esito e' in
> §9. Il **secondo strato — l'agente `controllo-preventivo` — NON posso
> invocarlo: lo lancia il coordinatore.** Fino a quel PASS questo referto non
> e' passato dal cancello intero, e lo scrivo invece di darlo per fatto.

---

# 0. 🥇 LA RISPOSTA IN SETTE RIGHE

1. 🟢 **NON avere il C2 il 1 ottobre costa ZERO.** Non "poco": **zero**, e
   provato in **quattro modi indipendenti** (§3). Il piu' forte e' algebrico:
   il super-cluster `AZIONARIO` proposto a **3,5%** e' **piu' largo del cap C1
   a 3,25%** che e' gia' acceso, e il rischio di un cluster e' per costruzione
   **un sottoinsieme** del rischio totale. 👉 **Un tetto a 3,5% dentro un tetto
   a 3,25% non puo' mordere mai, su nessun conto.**
2. 🔢 **E in unita' di sedia:** C2 a 3,0% scatta alla **5ª sedia da 0,65%**
   (4x0,65 = 2,60% sotto; 5x0,65 = 3,25% sopra). C1 a 3,25% scatta alla
   **5ª**. **La stessa sedia.** Protezione aggiuntiva: **0 sedie**.
3. 📉 **E costa zero anche accenderlo:** sul forward vero delle due sedie,
   **57 ingressi, 0 rifiutati** a taglia di contratto, a 1,00% e perfino con
   `770101` al 2%. 🟢 **Il pavimento di frequenza di 1,00 op/giorno per
   famiglia non viene sfiorato.** Non e' l'`A1` di stamattina (che perdeva il
   56,0% delle giornate): **il C2 conta il RISCHIO, non le teste.**
4. 🔴 **MA HO TROVATO UN QUARTO MODO IN CUI IL C2 E' SPENTO, e nessuno lo
   aveva contato: NESSUN EA LO LEGGE.** 100 punti di chiamata di
   `ABTG_GuardiaIngresso` in **70 EA**, e **zero** passano `cluster_mappa`.
   👉 Anche con Guardian a 19 input, preset firmato e mappa incollata, **nessun
   ingresso verrebbe rifiutato**: il C2 sarebbe **un log, non una rete**.
5. 🔴 **E LA PROTEZIONE CHE MANCA DAVVERO NON E' IL C2: e' `InpDailyBaseline`.**
   Su una prop che misura la giornata dal **SALDO** (FTMO) il nostro pavimento
   e' **piu' basso del loro** quando al reset c'e' flottante negativo — 800 EUR
   su 100k a −0,8%, numero gia' in casa. **Misurato stasera: 4 posizioni su 21
   di `771531` attraversano le 23:00 server.** `770101`: **0 su 36**.
6. 🔴 **E LA PRIMA SEDIA NON LEGGE IL GUARDIAN, PER NIENTE.** Il binario di
   `ABTG_EMA200` in campo e' del **04/08** e **non ha l'input
   `InpUsaGuardian`**: niente pausa morbida B1, niente cap C1, niente C2. E
   gira sul **piccolo 50503392**, dove **nessun Guardian gira** (giornale
   dell'11 e del 12/09: *"GUARDIAN: nessuna riga"*). **Due fail-open
   indipendenti sulla stessa sedia.**
7. 🎯 **E il §8 di `INDURIMENTO` si chiude stasera, senza chiedere niente a
   Claudio**: le "due foto" che gli avevo chiesto **erano gia' su disco**
   (`CODA_08` del 12/09, 03:31). **L'ipotesi "770101 gira al 2% LEGACY" e'
   FALSIFICATA**: in campo porta **`InpRiskPercent=1.0`**. §7.

---

# 1. 🔬 CHE COSA GIRA IN CAMPO OGGI — per nome, per versione, per COMMIT

Tutto da `backtest_pipeline/coda/referti/CODA_0*_20260912_033002.log` (runner
del 12/09, 03:30) incrociato con `git show` sui blob del repo. **Due segnali
indipendenti che convergono**: la `#property version` **e** il conteggio righe,
con lo scarto costante di **+1 riga** (la copia in campo ha una riga in piu',
coerente con una copia e non con un file diverso).

## 1.1 🛡️ Il Guardian, cartella dati per cartella dati — **SEI**, non "il VPS"

| cartella dati | programma | conto | versione | righe | **commit** | input | batte? |
|---|---|---|---|---:|---|---:|---|
| `215D85D7…` | `C:\Program Files\BCM Markets MT5 Terminal` | **50503392** piccolo | **1.10** | 414 | **`a53820e`** 18/08 | **15** | 🔴 **NO** |
| `73B7A242…` | `C:\Program Files\Pepperstone MetaTrader 5` | — | **1.10** | 414 | **`a53820e`** | **15** | — (nessun `.ex5`) |
| `857385E4…` | `C:\Program Files\Tickmill Europe MT5 Terminal` | — | **1.10** | 414 | **`a53820e`** | **15** | — (nessun `.ex5`) |
| `BCA8AD18…` | `C:\Program Files\BCM Markets MT5 Terminal -V3` | **50504263** 100k | **1.11** | 468 | **`1f4c92b`** 19/08 | **16** | 🟢 **SI** |
| `E23E1504…` | `C:\BCM_Reale` | **10105439** reale | **1.12** | 513 | **`1b6a095`** 06/09 | **16** | 🟢 **SI** |
| `04C7A32B…` | `C:\MT5_Backtest` | **50504400** | *assente* | — | — | — | — |
| *il repo di oggi* | — | — | *1.14* | *899* | *`a21d0c0`* 08/09 | *19* | — |

🚨 **E una cosa che la versione fa vedere e le righe no**: sui terminali a
**1.10** l'`.ex5` e' datato **09/08**, il sorgente accanto **18/08**. Il
sorgente e' stato copiato **senza ricompilare**: gira un codice ancora piu'
vecchio di quello che si legge. Due dei tre non hanno nemmeno un `.ex5`.

## 1.2 🔴 GLI INPUT CHE MANCANO, **ELENCATI PER NOME**

| versione in campo | input | **manca, per nome** |
|---|---:|---|
| **1.10** (piccolo, Pepperstone, Tickmill) | 15 | `InpDailyBaseline` · `InpMaxClusterRiskPct` · `InpClusterMappa` · `InpAutotest` |
| **1.11** (100k 50504263) | 16 | `InpDailyBaseline` · `InpMaxClusterRiskPct` · `InpClusterMappa` |
| **1.12** (reale 10105439) | 16 | `InpDailyBaseline` · `InpMaxClusterRiskPct` · `InpClusterMappa` |

🟢 **Nessuna regressione al contrario**: non c'e' una sola manopola che il campo
abbia e il repo no. Il campo e' un **sottoinsieme puro**, in tutte e tre.

## 1.3 ✏️ CORREZIONE a `IL_GUARDIAN_IN_CAMPO_2026-09-12.md` §2

Quel referto scrive, di `InpDailyBaseline`:

> *"e' un campo che la firma del cap C2 richiede: oggi il binario non lo
> accetterebbe"*

🔴 **FALSO, e l'ho verificato riga per riga.** `InpDailyBaseline` **non ha
niente a che fare col C2**: `ABTG_Guardian.mq5` r.94-127 (il perche'), r.147
(la dichiarazione), r.597-604 (la diagnostica), r.613 e r.719 (i due punti dove
viene usata). E' il **modo della baseline giornaliera** — `0=EQUITA'`,
`1=SALDO` (FTMO), `2=MAX(saldo,equita)` (FundingPips) — nato dal dossier
`report/REGOLAMENTI_PROP_2026-09-08.md` §3.1. **Il C2 non lo legge mai.**

👉 **E la correzione cambia le PRIORITA', non solo una frase**: quella manopola
non e' un accessorio del cluster, e' **il difetto piu' caro dei tre** (§4).

## 1.4 🪑 E LA STESSA DERIVA SULLE **DUE SEDIE** — si', e su una e' grave

| sedia | dove gira | versione | righe | **commit** | input mancanti **per nome** |
|---|---|---|---:|---|---|
| **770101** `ABTG_DAX_Apertura_EU` | **10105439** reale | 1.01 | 2368 | **`9638318`** 02/09 | 🟢 **nessuno — e' il repo di oggi** |
| **770101** | **50504263** 100k | **1.01** | 2361 | **`d83c196`** 19/08 | 🟢 nessuno (96 su 96) 🔴 **ma `ABTG_DEF_RISK` vale `2.0` invece di `1.0`** |
| **770101** | **50503392** piccolo | 1.00 | 2133 | **`3af47ed`** 08/08 | 🔴 `InpAllowReverse` · **`InpUsaGuardian`** · `DEF_RISK 2.0` |
| **771531** `ABTG_EMA200` | **50503392** piccolo, **e solo li'** | 1.00 | 487 | **`344a11b`** 04/08 | 🔴 **`InpUsaGuardian`** · `InpLogImbuto` |

> ## 🔴 **LA RIGA CHE PESA DI PIU' DI TUTTE**
> `ABTG_EMA200` in campo ha **486 righe contro 690** del repo (**−29,6%**) ed e'
> **precedente** a `3af47ed` (fix di sizing, 08/08), a `26a1856` (il filo del
> Guardian) e a `0953846`. **Non ha l'input `InpUsaGuardian`**: quel binario
> **non interroga il Guardian nemmeno per sbaglio**. E la sedia sta sul
> **50503392**, dove **il Guardian non gira affatto**.
> 👉 **La prima sedia del 1 ottobre oggi e' senza pausa morbida, senza C1 e
> senza C2 — e non perche' manchi una manopola al Guardian, ma perche' manca
> all'EA.** Il C2 e' l'ultimo dei suoi problemi.

📌 **E la lezione "la versione non basta" si ripete qui, testuale**: sul 100k
`770101` dice **1.01** come il repo, ha **96 input su 96** come il repo, e
porta il **doppio** del rischio di default compilato. **Versione + righe
identificano il commit; per sapere se la differenza MORDE serve il diff.**

---

# 2. 🔑 IL PERNO: COME IL CODICE DEFINISCE UN CLUSTER — **non lo definisce**

Letto, non intuito: `ABTG_PausaGuardian.mqh` **r.1333-1391**
(`ABTG_ClusterParse_Calc`) e **r.1398-1444** (`ABTG_SimboloNelCluster_Calc`).

- Il parser legge **una stringa**: `NOME=SYM,SYM;NOME2:3.5=SYM3`. Nome in
  maiuscolo, tetto proprio opzionale dopo `:`, jolly finale `*` come prefisso.
- **Nel codice non c'e' NESSUN simbolo cablato.** Nessun `U30USD`, nessun
  `D30EUR`, nessuna euristica "gli indici stanno insieme".
- Default `InpClusterMappa = ""` → `gClN=0` → **zero cluster, nessuna lettura,
  nessuna decisione** (r.630-637).

> ## 👉 **D30EUR e U30USD sono lo stesso cluster? IL CODICE NON LO DICE, E NON PUO' DIRLO.**
> Lo sono **se e solo se** lo dice una riga che **Claudio non ha ancora
> firmato**. L'unica proposta agli atti (`report/CLUSTER_PROPOSTA.md`, 🟠
> **PROPOSTA, NON FIRMATA**) risponde: **NO** a 3,0% (`AZ_EU` e `AZ_US`
> separati, perche' sessioni diverse — 08:00 contro 14:30 server), **SI** a
> **3,5%** dentro il super-cluster `AZIONARIO`.

⚠️ **E il confine del controllo, dichiarato nel sorgente stesso** (r.89-93):
C2 somma **solo le posizioni con SL**, **dall'ingresso** se `InpRiskMode=0`, e
**non conta i pendenti**. E' un **limite inferiore** del rischio impegnato.

---

# 3. 🔢 QUANTO COSTA NON AVERE IL C2 — **ZERO**, e in quattro modi indipendenti

## 3.1 🧮 PROVA ALGEBRICA — e da sola basterebbe

`ABTG_Guardian.mq5` r.385-412 (`OpenRiskPct`, C1) e r.434-462 (`ClusterRiskPct`,
C2) usano **le identiche convenzioni**, dichiarate nel commento r.428-433:
stessa distanza, stesse esclusioni, stessa equity al denominatore. L'unica
differenza e' il **filtro di appartenenza**. Quindi, per costruzione:

```
rischio_cluster  <=  rischio_totale        (sempre, per qualunque mappa)
```

- **C1 blocca a `>= 3,25%`** (r.789), e blocca **TUTTI i nuovi ingressi del
  conto**, senza filtro di simbolo.
- **C2 `AZIONARIO` bloccherebbe a `>= 3,5%`** (proposta), **solo sui suoi
  simboli**.

> ### 🔴 Se il cluster arriva a 3,5%, il totale e' **almeno** 3,5% — cioe' gia' sopra 3,25%. **C1 ha gia' bloccato tutto, compresi quei simboli.**
> ## 👉 **Il super-cluster `AZIONARIO` a 3,5% e' MATEMATICAMENTE MORTO finche' C1 e' acceso a 3,25%. Protezione aggiuntiva: 0,00 punti, su QUALSIASI conto, in QUALSIASI scenario.**

🎯 E su un portafoglio **di soli indici** — che e' esattamente il portafoglio
del 1 ottobre — la disuguaglianza diventa **un'uguaglianza**: `AZIONARIO`
contiene ogni simbolo del conto, quindi `rischio_cluster == rischio_totale`.

## 3.2 🔢 PROVA ARITMETICA — in unita' di sedia da 0,65%

| sedie vive da 0,65% | rischio aperto | C2 a **3,0%** | C1 a **3,25%** |
|---:|---:|---|---|
| 3 | 1,95% | libero | libero |
| 4 | 2,60% | libero | libero |
| **5** | **3,25%** | 🔴 **scatta** | 🔴 **scatta** |

> ## 👉 **Scattano alla STESSA sedia.** In unita' da 0,65% — l'unita' su cui il C1 e' stato tarato ("5 SL vivi da 0,65%") — **il C2 a 3,0% non anticipa il C1 nemmeno di mezza sedia.**

La finestra in cui il C2 agisce e il C1 no e' l'intervallo **[3,00% ; 3,25%)**,
largo **0,25 punti**. Con passi da 0,65% **non ci si atterra mai**.

## 3.3 🪑 PROVA STRUTTURALE — le due sedie non arrivano nemmeno a meta' strada

Letto dal sorgente (e gia' agli atti in `INDURIMENTO` §6):

| sedia | max posizioni insieme | prova | rischio aperto max |
|---|---:|---|---:|
| `770101` | **1** | `InpOneTradePerDay=true` · r.644 `tetto=1` con `InpAllowReverse=false` · r.595-602 guardia anti-duplicato | 1 x taglia |
| `771531` | **2** | r.322 `if(HasPosition() \|\| HasPending()) return;` · r.359-365 `riskPct = InpRiskPercent/nOrders` | 2 x (taglia/2) = 1 x taglia |

| taglia per sedia | rischio `AZIONARIO` max | tetto 3,5% | tetto 3,0% |
|---|---:|---|---|
| **0,65%** (la taglia di sopravvivenza) | **1,30%** | 🟢 37% del tetto | 🟢 43% |
| 1,00% (la taglia del banco) | 2,00% | 🟢 57% | 🟢 67% |
| 2,00% (l'ipotesi LEGACY, poi falsificata in §7) | 2,65% | 🟢 76% | 🟢 88% |

🔴 **Perche' questo NON e' l'errore del 10/09 ("inerte su una finestra troppo
corta")**: con `InpRiskMode=0` — **il valore FIRMATO in tutti e due i preset** —
il numero del C2 si misura dalla distanza **ingresso→SL**, quindi **non dipende
dal prezzo**. 👉 **Nessun crollo, nessun gap, nessuna notte puo' farlo salire.**
Il tetto e' invalicabile **per costruzione**, non per campione.
*(`InpRiskMode=1` misurerebbe dal prezzo corrente ed e' un'altra grandezza:
non e' la firma, e va rifatto se un giorno lo diventasse.)*

## 3.4 📊 PROVA EMPIRICA — sul forward vero, e su tutto il conto

`data/statements/trades_auto.csv` (demo **50503392**, 1.303 posizioni, letto
col separatore **`;`**) e `trades_100k.csv`. Ricostruita la linea del tempo
apertura→chiusura e sommato il rischio nominale per cluster, istante per
istante, con la mappa **proposta**:

| insieme | posizioni | picco `AZ_EU` | picco `AZ_US` | picco `AZIONARIO` | **volte sopra il tetto** |
|---|---:|---:|---:|---:|---:|
| **le due sedie**, demo 50503392 | 57 | **1,300%** | 0,650% | **1,300%** | 🟢 **0** |
| tutto il demo 50503392, tutti i magic | 1.303 | 4,550% | 4,225% | 5,200% | 🔴 7 / 8 / 17 |
| tutto il 100k 50504263 | 29 | 0,650% | 1,300% | 1,300% | 🟢 **0** |

🟢 **E la squadra intera del 100k non ci arriva nemmeno in teoria:** 5 sedie a
0,65% + ORB a 0,30% = **2,90%** di `AZIONARIO` massimo possibile, contro 3,5%.

📌 **La riga di mezzo va letta bene, ed e' la piu' onesta delle tre**: sul
piccolo il tetto sarebbe stato superato — **ma da 14 magic sparsi, dall'oro a
mano (magic 0) e da cinque DAX diversi**, non dalle due sedie. **E' la prova
che il C2 serve a un conto largo. Il conto del 1 ottobre ne ha due.**

---

# 4. ⚖️ E QUANTO COSTA **AVERLO** — 0 operazioni su 57

La domanda giusta, quella che stamattina ha smascherato l'`A1` (che sembrava
gratis e **perdeva il 56,0% delle giornate**). Simulato il cancello del C2 sul
forward vero: per ogni ingresso, il rischio aperto del suo cluster **prima** di
lui; se `>= tetto`, l'ingresso e' rifiutato.

| scenario | ingressi | **rifiutati** | % |
|---|---:|---:|---:|
| le due sedie, taglia di **contratto** (0,65% · 0,325% a gamba) | 57 | **0** | **0,0%** |
| le due sedie a **1,00%** (0,50% a gamba) | 57 | **0** | 0,0% |
| le due sedie con `770101` al **2%** | 57 | **0** | 0,0% |
| il **100k**, tutti i magic a 0,65% | 29 | **0** | 0,0% |
| **tutto il demo 50503392**, 14 magic, tutti a 0,65% | 1.303 | **8** | 0,6% |

👉 **Il C2 non tocca la frequenza.** Il pavimento firmato il 07/09 — **1,00
operazione/giorno per FAMIGLIA** — non viene sfiorato: **zero operazioni perse**
in ognuno degli scenari delle due sedie.

🟢 **E perche' non esplode come l'`A1`:** l'`A1` contava le **teste** (14 magic
sullo stesso simbolo), il C2 conta il **RISCHIO in % di equity**. Con sedie da
0,65% servono **cinque stop vivi** per saturarlo. **Non e' lo stesso conto, e
il numero lo dimostra: 0,6% contro 56,0%.**

---

# 5. 🔴 IL QUARTO MODO IN CUI IL C2 E' SPENTO — e nessuno lo aveva contato

`CLAUDE.md` e i referti di oggi ne elencano **tre**: default `0`, nessun preset
lo valorizza, la versione in campo non ha la manopola. **Ce n'e' un quarto, ed
e' il piu' pesante.**

**Come funziona il C2, riga per riga:**

| dove | cosa fa |
|---|---|
| `ABTG_Guardian.mq5` r.816-853 | calcola il rischio per cluster, e per ogni cluster saturo **scrive una GlobalVariable** col timestamp. 🔴 **Non chiude niente e non blocca niente da solo.** |
| `ABTG_PausaGuardian.mqh` r.1456-1472 | `ABTG_ClusterSaturo()` legge quella bandiera… **ma solo se le viene passata una `mappa`** |
| `ABTG_PausaGuardian.mqh` r.1665-1717 | il blocco `1-quater` dentro `ABTG_GuardiaIngresso`: `if(StringLen(cluster_mappa)>0)`. **A mappa vuota non legge niente e non decide niente.** |

**E `cluster_mappa` e' il PENULTIMO argomento della funzione, con default `""`**
(r.1587-1598). Misurato su tutto l'albero `mql5/`:

| misura | valore |
|---|---:|
| punti di chiamata di `ABTG_GuardiaIngresso` | **100** |
| EA che la chiamano | **70** |
| chiamate che passano **`cluster_mappa`** | 🔴 **0** |
| EA con un input di mappa cluster | 🔴 **0** (solo il Guardian ce l'ha) |
| chiamate che passano `tetto_simbolo_lato` (il cap P0 del 02/09) | 🔴 **0** |

> ## 🔴 **QUINDI: anche con il Guardian a 19 input, il preset firmato e la mappa incollata, NESSUN INGRESSO VERREBBE RIFIUTATO.** Il C2 scriverebbe nel giornale e sul pannello, e basta. **Sarebbe un allarme, non una rete.**

👉 **E cambia la proposta**: portare il C2 in campo **non e' "una compilazione
del Guardian"**. Sono **due** compilazioni (Guardian **e** i due EA) piu' una
riga di codice per EA, piu' la mappa **in due posti** che devono coincidere
(l'include lo dice da solo, r.1689-1694: se divergono, sui cluster che il
Guardian non conosce **il tetto non protegge**, e lo scrive nel giornale).

---

# 6. 💰 QUELLO CHE COSTA DAVVERO — in ordine di prezzo misurato

Il C2 costa zero. **Questi no.** Ordinati per quanto pesano sul 1 ottobre.

### 🥇 1. 🔴 `771531` NON LEGGE IL GUARDIAN — e sul suo conto il Guardian non c'e'
| prova | valore |
|---|---|
| binario in campo | `344a11b`, **04/08/2026**, 486 righe contro 690 |
| input `InpUsaGuardian` | 🔴 **assente dal binario** (51 input contro 53) |
| conferma indipendente | il `.chr` (`CODA_08`) **non riporta `InpUsaGuardian`**: coerente, l'EA non ce l'ha |
| colonna `GUARD` del runner (grep indipendente) | 🔴 **`no`** |
| Guardian sul suo terminale (**50503392**) | 🔴 **"GUARDIAN: nessuna riga"**, 11/09 **e** 12/09, su un giornale da 432 righe (quindi non e' un log vuoto) |

**Cosa perde, per nome:** la **pausa morbida B1 a −4,0%**, il **cap C1 a
3,25%**, e ovviamente il C2. 🔴 **E la pausa morbida NON e' inerte come i
cap**: `771531` non ha limite di operazioni al giorno
(`InpMaxTradesPerDay=0`, letto dal `.chr`) e in campo ha fatto **fino a 4
gambe perdenti in un giorno**. E' esattamente la sedia per cui il freno
giornaliero e' stato firmato.

🟢 **La buona notizia, e va detta:** i **muri duri** (−4,9% giorno, −9,9%
totale) **non passano dall'EA**. Il Guardian chiude da solo, di qualsiasi
magic (`InpAction=0` + `InpCloseAllMagics=true`). **Dove il Guardian gira, la
rete dura c'e' — anche sotto un EA che non lo interroga.** Sul piccolo, pero',
non gira.

### 🥈 2. 🔴 `InpDailyBaseline` ASSENTE IN TUTTE E TRE LE VERSIONI IN CAMPO
Il nostro pavimento giornaliero parte dall'**EQUITA'**; FTMO dal **SALDO** alle
00:00 CE(S)T, FundingPips dal **MAX(saldo, equita)**. Con flottante **negativo**
al reset la nostra equity e' **piu' bassa** del saldo: **il nostro pavimento
scende, il loro no.** 🔴 **Siamo piu' PERMISSIVI della prop** — la challenge
puo' essere gia' violata mentre il Guardian e' ancora "in pausa morbida".
Numero gia' in casa (`REGOLAMENTI_PROP_2026-09-08.md` §3.1): 100k a **−0,8%**
flottante al reset → pavimento FTMO **95.000**, nostro **94.200**, **800 EUR**.

**Quanto ci riguarda, misurato stasera sui per-trade veri:**

| sedia | posizioni aperte **attraverso le 23:00 server** | su totale | P/L del gruppo |
|---|---:|---:|---:|
| `770101` | **0** | 36 | — |
| **`771531`** | 🔴 **4** | 21 | −13,63 |

Durata massima di `771531` in campo: **2 giorni, 9h 32m** (28/08 → 31/08,
attraverso un weekend). `770101`: **4h 30m**, e chiude alle 17:30.
👉 **Il buco della baseline riguarda il 19,0% delle posizioni della PRIMA
sedia e lo 0% della seconda.** ⚠️ Il flottante **al momento del reset** resta
`[NON MISURATO]`: servirebbe il tick, e i per-trade non lo portano.

### 🥉 3. 🟠 `ABTG_DEF_RISK 2.0` sul 100k
Il binario di `770101` sul **50504263** e' `d83c196` (19/08), **prima del fix
C4 del 02/09**: il default compilato di `InpRiskPercent` e' **2,0%**, il doppio
del contratto e della riga rossa **A4**. 🟢 **Oggi e' coperto**: il `.chr`
porta `InpRiskPercent=0.65`. 🔴 **Un click su "Ripristina" nella finestra degli
input lo riporta a 2,0%** — che e' **3,08 volte** la taglia di sopravvivenza.
E' esattamente il difetto che il fix C4 ha chiuso sul reale, e che sul 100k non
e' mai arrivato.

### 4. 🟢 CHE COSA INVECE E' VIVO E FUNZIONA
- **C1 a 3,25%**: implementato **e** acceso in **tutti e due** i preset
  (`ABTG_Guardian_FTMO_2Step.set` e `conto_reale/ABTG_Guardian_REALE.set`).
- **Pausa morbida 4,0% · emergenza 4,9% e 9,9% · reset 23**: in **tutti e due**
  i preset, e presenti **anche nelle versioni in campo** (1.10/1.11/1.12 le
  hanno tutte e quattro).
- Il Guardian **batte** sul 100k e sul reale (riga di stato dell'11/09, `pausa=off
  cap=off`, stato OK).
- 🟢 **Il meccanismo dei cap funziona**: e' il C2 che non e' stato acceso, non la
  macchina che manca.

---

# 7. 🎯 E IL §8 DI `INDURIMENTO` SI CHIUDE STASERA — il file era gia' li'

`INDURIMENTO_PROP_DUE_SEDIE_2026-09-12.md` §8 chiedeva a Claudio **due foto**
dentro MT5 per capire se `770101` gira col preset **LEGACY al 2%**, e diceva:
*"Non posso chiuderla io"*. 🔴 **Si poteva: le due foto erano gia' su disco**,
scritte dal runner alle **03:31 del 12/09** in
`backtest_pipeline/coda/referti/CODA_08_preset_dai_chr_20260912_033002.log`.
📌 **E' la classe del 10/09 un'altra volta: il file che aveva la risposta era
nella stessa cartella e nessuno l'ha aperto.**

| sedia | terminale | `InpRiskPercent` | altri parametri chiesti |
|---|---|---:|---|
| `770101` D30EUR `chart30.chr` | **50503392** piccolo | **1.0** | `InpTP1_ClosePct=50.0` · `InpCloseHour=17` · `InpOneTradePerDay=true` · `InpAllowShort=false` · `InpAllowReverse` **assente** (il binario non ha l'input) · `InpUsaGuardian` **assente** |
| `771531` U30USD `chart33.chr` | **50503392** piccolo | **1.0** | `InpUseOrder2=true` · `InpMaxTradesPerDay=0` · `InpAllowShort=true` · `InpUsaGuardian` **assente** |
| `770101` D30EUR `chart01.chr` | **50504263** 100k | **0.65** | `InpUsaGuardian=true` 🟢 |
| `770101` D30EUR `chart01.chr` | **10105439** reale | **0.65** | `InpUsaGuardian=true` 🟢 |

> ## 🔴 **L'IPOTESI "770101 GIRA AL 2% LEGACY" E' FALSIFICATA.** In campo porta **1,0%**.
> 🟢 **E sul 100k e sul reale porta 0,65% + `InpUsaGuardian=true`: esattamente il contratto.**

🔴 **Ma la discrepanza di §8 NON si chiude: peggiora di spiegazione.** Con
**tutte e due a `InpRiskPercent=1.0`** sullo stesso conto, il rapporto atteso
fra uno stop pieno di `770101` e un **segnale** completo di `771531` e'
**1,00**. Misurato: **2,60**. 🔴 **Il rapporto non e' spiegato dall'input di
rischio.**

**Il candidato rimasto, e si legge nel diff:** `771531` gira `344a11b`,
**precedente** al fix di sizing `3af47ed` (08/08). Il vecchio `LotByRisk()`
calcolava la perdita per lotto dal **tick value nudo**; il fix la prende da
`OrderCalcProfit`, *"perche' su 225JPY il tick value arriva non convertito in
valuta conto: il lotto usciva ~0 e finiva SEMPRE al minimo"*. Su `U30USD`
quotato in dollari su un conto in euro **il tick value non convertito e'
esattamente il caso che il fix descrive**.
⚠️ **`[NON MISURATO]`**: la conversione da sola non spiega un 2,60x, e non ho
l'equity istante per istante. **Il verso pero' torna: `771531` sotto-dimensiona.**

---

# 8. 📋 LA PROPOSTA — in ordine di esecuzione, e **NON APPLICO NIENTE**

🔴 Preset, taglie, parametri di rischio e protezioni sono **firma di Claudio**.
Il perimetro del runner e' **sola lettura**. Qui c'e' l'ordine, non il gesto.

### 🚦 GRADINO 0 — le due cose che valgono piu' del C2, e costano meno
| # | cosa | chi | costo | perche' prima |
|---|---|---|---|---|
| **0a** | **Non schierare `771531` con il binario del 04/08.** Ricompilare `ABTG_EMA200` dal repo **su un terminale di prova**, verificare che compaia `InpUsaGuardian`, e metterlo a **`true`** | 👨‍🔧 lavoro + ✍️ firma | 1 compilazione | senza questo la prima sedia **non ha ne' pausa ne' cap**, e nessun tetto per cluster potra' mai toccarla |
| **0b** | **Creare il preset che oggi non esiste**: `ABTG_EMA200_U30USD_H1_771531.set` con `InpRiskPercent=0.65` e `InpUsaGuardian=true`. Oggi l'unico e' `mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set`, che porta **1.0** e **non ha** `InpUsaGuardian` | ✍️ **firma di Claudio** (e' una taglia) | 1 file | lo 0,65% e' la condizione di sopravvivenza del portafoglio (p99 9,40% contro 12,17%) |
| **0c** | **Un Guardian sul terminale delle due sedie**, qualunque esso sia il 1 ottobre, col preset firmato | ✍️ firma + 👨‍🔧 | 1 grafico | i muri duri 4,9/9,9 sono l'unica protezione che funziona **anche** sotto un EA che non li legge |

### 🟠 GRADINO 1 — `InpDailyBaseline`, se la prop misura dal saldo
| # | cosa | chi |
|---|---|---|
| 1a | **Confermare con la prop, per iscritto**, come calcola il muro giornaliero (saldo alle 00:00 / equity / max). E' gia' in `DOMANDE_SUPPORTO_PROP.md` | 🙋 **Claudio** |
| 1b | Se la risposta e' **saldo** o **max**: portare in campo il Guardian **v1.14** (l'unico che ha l'input) e mettere `InpDailyBaseline=1` (FTMO) o `=2` (FundingPips) | ✍️ firma + 👨‍🔧 |
| 1c | 🔴 **Sul conto REALE `InpDailyBaseline` deve restare `0`**: il credito broker non prelevabile riaprirebbe il bug del 06/09. **Modo diverso su conto diverso, e va scritto nel preset** | ✍️ firma |

### 🟢 GRADINO 2 — il C2, e qui la raccomandazione e' **NON farlo adesso**
| # | cosa | chi | quando |
|---|---|---|---|
| 2a | **Firmare la mappa** di `report/CLUSTER_PROPOSTA.md` (o la sua variante) | ✍️ Claudio | 🟢 **quando serve** |
| 2b | 🔴 **Rivedere il tetto di `AZIONARIO`: 3,5% e' piu' largo di C1 3,25% e non puo' mordere mai.** Se lo si vuole vivo deve stare **sotto** 3,25% | ✍️ Claudio | prima di 2c |
| 2c | Portare in campo il Guardian **v1.14** e valorizzare `InpMaxClusterRiskPct` + `InpClusterMappa` | 👨‍🔧 | dopo 2a/2b |
| 2d | 🔴 **Aggiungere `cluster_mappa` alla chiamata di `ABTG_GuardiaIngresso` nei due EA**, con la **stessa** stringa del Guardian, e ricompilarli | 👨‍🔧 | dopo 2c |
| 2e | Collaudo enforcement (`backtest_pipeline/attese_cluster.txt`), mai "sembra funzionare" | 👨‍🔧 | dopo 2d |

> ## 🎯 **LA RACCOMANDAZIONE, e la scrivo col numero:**
> **Con DUE sedie da 0,65% il C2 non puo' mordere: 1,30% contro un tetto di
> 3,0-3,5%.** Farlo adesso costa **cinque passi, due ricompilazioni e un
> collaudo** per **zero punti di protezione** — e ogni compilazione su un EA
> vivo e' un rischio vero, a 19 giorni dalla partenza.
> 👉 **Il C2 diventa una protezione VERA alla QUARTA sedia sullo stesso
> cluster** (4 x 0,65% = 2,60%, a un passo dal tetto). **Quello e' il momento,
> e non e' il 1 ottobre.**
> ⚠️ **Ma la mappa va firmata PRIMA**, perche' firmarla di fretta il giorno in
> cui serve e' come tararla guardando chi colpisce — e quello e' esattamente il
> difetto che la regola di ripensamento del 18/08 vieta.

### 🧪 E SERVE UNA MISURA PRIMA? — **per il C2, NO, e lo dichiaro**
🚫 **Non ho scritto nessun file prova, e non ne serve nessuno per questa
domanda.** Il verdetto del C2 e' chiuso da **algebra** (§3.1), **aritmetica**
(§3.2), **lettura del sorgente** (§3.3) e **57 ingressi veri** (§3.4). **Un
backtest non aggiungerebbe niente, e a 19 giorni dalla challenge il tempo
macchina vale piu' di una conferma.**

Le due misure che servono **non sono backtest**:
- **M1 — il rapporto 2,60x di `771531`** si chiude confrontando il lotto che i
  **due binari** producono sulla stessa distanza: e' un confronto, non una
  griglia. `[DA PROPORRE come round, non come prova]`
- **M2 — il flottante al reset** si chiude solo con i tick. `[NON MISURATO]`

E una **lettura** che costa trenta secondi, con il bersaglio dichiarato:

🖥️ **Terminale bersaglio: finestra PowerShell sul VPS.** 🛑 **Non apre e non
tocca nessun MT5**: non tocca `50503392`, non tocca `50504263`, non tocca
`10105439`, non tocca `50504400`, non tocca Pepperstone ne' Tickmill. Legge e
stampa.

```powershell
Get-Process terminal64 | Select-Object Id, MainWindowTitle, Path | Format-Table -AutoSize
```

---

# 9. 🧪 IL CONTRO-ESEMPIO — costruito da me, contro la MIA conclusione

La conclusione principale e' *"non avere il C2 costa zero"*. **Ecco le quattro
misure che la farebbero cadere, e cosa hanno dato.**

| # | ipotesi alternativa che mi smonterebbe | come l'ho provata | esito |
|---|---|---|---|
| 1 | **"Lo zero e' un artefatto: le due sedie non si sovrappongono mai, quindi non e' il tetto che le salva"** | contate le sovrapposizioni vere: nella finestra comune (14/08→04/09, **16 giorni feriali**) hanno aperto **entrambe in 6 giorni**, ma posizioni **contemporaneamente aperte in UNO solo** (27/08) | ⚠️ **VERA come critica dell'empirico** — e per questo l'empirico **non e' la mia prova principale**. La prova strutturale (§3.3) assume **sovrapposizione totale** e da' comunque **1,30% contro 3,5%** |
| 2 | **"Il limite di 1 e 2 posizioni viene dal PRESET, non dal codice: cambia il preset e il tetto si raggiunge"** | 🔴 **VERA, e l'ho trovata nei dati**: il 29/07/2026 `770101` ha avuto **DUE posizioni D30EUR aperte insieme** (pid 2933138 e 2933140, stesso secondo) **e il 22/07 ha operato su NASUSD**, in **SELL** — configurazioni che i preset di oggi vietano | ⚠️ **VERA e dichiarata.** Ma anche cosi': 3 posizioni x 1,0% (la taglia in campo) = **3,00%**, sotto il tetto `AZIONARIO` 3,5%, e sotto C1 3,25%. **Il verdetto non si ribalta.** 👉 **E il limite resta: il mio numero vale per la configurazione firmata, non per qualunque configurazione** |
| 3 | **"Lo storico non contiene un crollo: il C2 serve per il giorno fuori campione"** | 🔴 **Questa la prendo sul serio, ed e' l'errore che ho gia' pagato oggi.** Ma: con `InpRiskMode=0` (**il valore firmato**) il numero del C2 e' la distanza **ingresso→SL**, **indipendente dal prezzo**. E `ClusterRiskPct` (r.440-459) **non guarda mai il prezzo corrente** in quel modo | ❌ **SMENTITA, e non su una finestra: su un'identita'.** Nessuno scenario di mercato puo' alzare quel numero. 🔴 **E c'e' di peggio per il C2: non chiude niente** (r.816-853 scrive solo una GlobalVariable). **In un crollo le posizioni aperte restano aperte.** Il crollo lo ferma il 9,9%, non il cluster |
| 4 | **"Il numero torna troppo bene: sara' vero per costruzione"** | 🔴 **Si', ed e' proprio il punto — e lo dico invece di nasconderlo.** `rischio_cluster <= rischio_totale` **e' un'identita'**, e con tetto_cluster (3,5%) > tetto_totale (3,25%) il C2 e' dominato **per costruzione** | ✅ **CONFERMATO come identita' algebrica, non come misura.** 👉 **Ed e' esattamente per questo che vale piu' di un backtest: un'identita' non ha campione, non ha regime e non ha coda.** |

### 🚫 E il contro-esempio che **NON** sono riuscito a costruire
**Non ho trovato nessuno scenario in cui il C2 al 3,0% morde PRIMA del C1 a
3,25% con sedie da 0,65%.** La finestra esiste (**[3,00% ; 3,25%)**, larga 0,25
punti) ma con passi da 0,65% **non e' raggiungibile**: si passa da 2,60% a
3,25%. 👉 **Se qualcuno trova una taglia firmata che ci atterra, la mia
conclusione cade.** Le taglie che ci atterrerebbero sono **1,50%-1,62% per
sedia**: sopra la riga rossa **A4** (mai sopra l'1%).

### 🚦 IL CANCELLO, esito

Girato da me il cancello deterministico sul file, con l'oggetto dichiarato
(`controlla_riga.py`, oggetto `md`, bersaglio questo referto):

| | |
|---|---|
| **ESITO** | 🟢 **nessun difetto meccanico — EXIT 0 = PASS** |
| PASSATI (2) | **[blocco r.473] la riga PowerShell e' certificata di SOLA LETTURA** (lista bianca, classe 173: nessuno script scaricato, nessun cmdlet fuori lista, nessun operatore di chiamata) · 2 blocchi trovati, 1 controllato come riga di lancio |
| RILIEVI (1) | **[225]** la prosa nomina terminali e conti vietati in 14 righe. **Non e' un difetto**: e' un documento che dichiara cosa NON si tocca, quindi quei nomi ci devono stare. Riletti a occhio: sono tutti descrittivi, e **nessun saldo, equita' o P/L di `10105439` o `50504263` compare nel file** |
| BLOCCANTI | **0** |

🔴 **Il secondo strato — l'agente `controllo-preventivo` — NON l'ho invocato: non
posso. Lo lancia il coordinatore.** Fino a quel PASS, niente di qui va al VPS.

---

# 10. 🕳️ COSA QUESTO REFERTO **NON** COPRE — elencato per nome

1. 🔴 **Il contenuto dei binari `.ex5`**: leggo il `.mq5` accanto piu' la data
   di compilazione. Sui tre Guardian a 1.10 l'`.ex5` e' **piu' vecchio** del
   sorgente (09/08 contro 18/08): quello che gira e' **ancora piu' indietro**
   di quello che ho letto.
2. 🔴 **Il flottante al momento del reset** delle 4 posizioni notturne di
   `771531`: `[NON MISURATO]`, servono i tick.
3. 🔴 **L'attribuzione del 2,60x** di §7: `[NON MISURATO]`, ho il candidato e il
   verso, non la prova.
4. 🔴 **Quale conto ospitera' le due sedie il 1 ottobre**: non esiste ancora, e
   nessuna misura qui dice quale Guardian ci finira' sopra.
5. 🔴 **La mappa dei cluster**: e' una **proposta non firmata**. Tutti i numeri
   di cluster di questo referto valgono **per quella mappa**. Con una mappa
   diversa i picchi cambiano — 🟢 **ma non il verdetto di §3.1, che non dipende
   dalla mappa**: vale per qualunque cluster con tetto sopra 3,25%.
6. 🔴 **I pendenti**: C1 e C2 non li contano (buco B6, dichiarato nel sorgente).
   Nel caso peggiore le due sedie hanno **1,30%** di rischio potenziale
   invisibile a tutti e due i cap.

---

# 11. 🏁 LA RISPOSTA SECCA

> # 🔴 **NO.**
> ## **Le due sedie del 1 ottobre NON sono protette come abbiamo firmato.**

**Ma non per il motivo che pensavamo, e la differenza vale il referto:**

| protezione firmata | stato reale il 12/09 | costa? |
|---|---|---|
| **C1 3,25%** (18/08) | 🟢 implementato, acceso in **tutti e due** i preset | — |
| **Pausa 4,0% · 4,9% · 9,9% · reset 23** (18/08) | 🟢 in campo su **tutte e tre** le versioni; i muri duri chiudono **da soli**, di qualsiasi magic | — |
| **C2 cluster 3,0%** (07/09) | 🔴 spento in **QUATTRO** modi (default · nessun preset · non c'e' in campo · **nessun EA lo legge**) | 🟢 **ZERO** — e provato in quattro modi |
| 🔴 **`InpUsaGuardian` su `771531`** | 🔴 **non esiste nel binario in campo**, e sul suo conto **nessun Guardian gira** | 🔴 **la prima sedia oggi e' senza pausa morbida e senza cap** |
| 🔴 **`InpDailyBaseline`** | 🔴 assente in **tutte e tre** le versioni in campo | 🔴 su una prop che misura dal saldo, **il nostro pavimento e' piu' basso del loro**: 4/21 posizioni di `771531` attraversano il reset |
| 🟠 **A4 "mai sopra l'1%"** | 🟠 rispettata in campo (1,0%), ma **1,54x il contratto** di `770101` sul piccolo, e `DEF_RISK 2.0` a un click di distanza sul 100k | 🟠 |

## 🎯 E LA BUSSOLA, che e' la seconda meta' del lavoro
**Questo referto non consegna una sedia: consegna un ponteggio, e lo dichiaro.**
Ma consegna anche **due cose che avvicinano il 1 ottobre**:
- 🟢 **toglie dal piano un lavoro che NON serve** (portare il C2 in campo:
  cinque passi, due ricompilazioni, zero punti di protezione) — e a 19 giorni
  **togliere lavoro inutile vale quanto aggiungerne di utile**;
- 🔴 **mette al suo posto il lavoro che serve davvero**, che costa **una
  compilazione e un preset**, ed e' il gradino 0.

🟢 **E una cosa e' andata benissimo**: il **C1 al 3,25%**, la **pausa morbida**
e i **due muri duri** sono **vivi, accesi e in campo** sui due conti dove un
Guardian gira. **La macchina delle protezioni funziona.** Il problema non e'
mai stato il meccanismo: e' **una sedia che non l'ha mai incontrato**.

---

*Tutto ricavato dal repo e dai referti del runner, in **sola lettura**. Nessun
accesso al VPS, nessun terminale toccato, nessun backtest lanciato, nessun
preset, parametro o magic modificato. Nessun saldo, equita' o P/L dei conti
`10105439` e `50504263` e' riportato.*

**Fonti aperte e ricontate:** `mql5/Experts/ABTG_Guardian.mq5` (r.84-127,
147, 165-166, 185-191, 385-412, 434-472, 626-652, 775-853, 874-899) ·
`mql5/Include/ABTG_PausaGuardian.mqh` (r.1333-1391, 1398-1444, 1456-1472,
1485-1501, 1587-1598, 1599-1750) · `mql5/Experts/ABTG_EMA200.mq5` ·
`mql5/Experts/ABTG_DAX_Apertura_EU.mq5` · `mql5/Presets/ABTG_Guardian_FTMO_2Step.set` ·
`mql5/Presets/conto_reale/ABTG_Guardian_REALE.set` ·
`mql5/Presets/ABTG_DAX_Apertura_EU_D30EUR_M5_770101_100K.set` ·
`mql5/Presets/sedie_piccolo/recupero2/sedia_ABTG_EMA200_771531.set` ·
`data/statements/trades_auto.csv` e `trades_100k.csv` (separatore **`;`**) ·
`backtest_pipeline/coda/referti/CODA_01/03/06/08/09_20260912_033002.log` ·
`report/CLUSTER_PROPOSTA.md` · `report/FIRME_2026-08-18.md` ·
`report/FIRME_2026-09-07.md` · `report/REGOLAMENTI_PROP_2026-09-08.md` ·
`report/IL_GUARDIAN_IN_CAMPO_2026-09-12.md` ·
`report/IL_CAMPO_SEDIA_PER_SEDIA_2026-09-12.md` ·
`report/IL_CAMPO_E_FERMO_A_AGOSTO_2026-09-11.md` ·
`report/INDURIMENTO_PROP_DUE_SEDIE_2026-09-12.md` ·
`report/LA_SECONDA_SEDIA_2026-09-12.md` ·
commit `a53820e` `1f4c92b` `1b6a095` `cdb2037` `a21d0c0` `344a11b` `3af47ed`
`26a1856` `d83c196` `9638318` `872dba8`.
