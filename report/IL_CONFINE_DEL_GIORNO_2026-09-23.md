# 🕛 IL CONFINE DEL GIORNO — il nostro contro il loro

**23/09/2026** · perimetro `/home/user/GITHUB`, branch `lavoro` · **SOLA LETTURA**: nessun round,
nessuna riga verso Claudio, nessun preset toccato, nessuna sedia toccata, **nessuna soglia
proposta**. Tutto quello che c'è qui sotto è letto in repo o calcolato dai numeri in repo.

---

# 🔴 LA RISPOSTA, IN UNA RIGA

> ## L'**ORA** coincide — **scarto 0 h 00 min, e la misura c'è**. La **GRANDEZZA da cui parte il conteggio NO**: FTMO parte dal **SALDO** delle 00:00, noi dall'**EQUITÀ** — e con **400 € di flottante negativo** aperto su quel confine il cuscino di 0,5% **è esattamente zero**. E dal **25/10/2026** anche l'ora torna **indecidibile**, perché il repo dice **due cose diverse** sul fuso invernale di FTMO.

Tradotto in tre righe operative:

| domanda | risposta | stato |
|---|---|---|
| I due confini cadono alla **stessa ora**? | **SÌ**, oggi. `InpDailyResetHour=1` sul server FTMO **= 00:00 CE(S)T**, al minuto | ✅ **MISURATO** (`DeltaServerGMT=+03:00`, 20/09 17:08) |
| Il valore `=1` è davvero **sul grafico** in campo? | il preset in repo ce l'ha; il passaggio era **un passo a mano** e **nessun artefatto in repo lo certifica** | 🟠 **[NON VERIFICATO IN CAMPO]** |
| I due confini partono dalla **stessa grandezza**? | **NO.** FTMO = **saldo**; Guardian = **equità** (e il binario pinnato non ha nemmeno la manopola per cambiarlo) | 🔴 **MISURATO nel codice** |
| Dal **25/10/2026** l'ora regge? | **indecidibile**: due referti di casa si contraddicono sul fuso invernale FTMO | 🔴 **[NON MISURATO]** |

🟢 **E la buona notizia, subito**: il muro **statico del 10%** — `totalDD = gStart − eq`
(`ABTG_Guardian.mq5` r.743) — **non dipende dal confine del giorno per niente**. Tutto questo
referto riguarda **solo** il muro giornaliero. Che però, per il Monte Carlo delle 242 giornate,
è **quello che ci uccide nel 18,2% dei casi contro l'11,5%**.

---

# 1. 🔎 IL NOSTRO CONFINE — la catena completa, file:riga

## 1.1 Dove nasce il "giorno"

| passo | file : riga | cosa fa |
|---|---|---|
| chiave del giorno | `mql5/Experts/ABTG_Guardian.mq5` **r.194** | `DayKey(t) = s.year*1000 + s.day_of_year` |
| giorno "prop" | **r.199-205** `PropDayKey()` | `t = TimeCurrent()` · `shifted = t − InpDailyResetHour*3600` · `return DayKey(shifted)` |
| l'input | **r.133** | `input int InpDailyResetHour = 0;  // Ora SERVER in cui azzera il contatore giornaliero` |
| scadenza della pausa | **r.212-221** `NextResetTime()` | stessa ora, sulla data di `TimeCurrent()`, `+86400` se già passata |

🕐 **Su QUALE orologio**: `TimeCurrent()` — quindi **ora SERVER del broker a cui l'EA è
attaccato**, cioè **il server FTMO**, non Windows e non BCM. ✅ È l'orologio giusto.
⚠️ Ma `TimeCurrent()` **non è un orologio: è il timestamp dell'ultimo tick** — vedi §5.3.

📐 **Quali valori può prendere `InpDailyResetHour`**: `int`, senza vincoli sull'input;
`PropDayKey()` (r.203) lo usa **grezzo**, `NextResetTime()` (r.215) lo pinza a `[0,23]`.
👉 Un valore fuori scala si comporterebbe **in due modi diversi** nelle due funzioni. Non è il
nostro caso (vale 1) ma è una asimmetria da sapere.

🟢 **Controllo che è passato**: `year*1000 + day_of_year` è monotòna e senza collisioni
(doy ≤ 365 < 1000), quindi **niente bug di capodanno**. E `NextResetTime()` è coerente con
`PropDayKey()` a tutte le ore che ho provato a mano (00:30 → 01:00 di oggi; 02:00 → 01:00 di
domani). ✅

## 1.2 Dove nasce la **baseline** (la grandezza), e qui casca l'asino

| passo | file : riga | cosa fa |
|---|---|---|
| lettura conto | **r.706-707** | `bal = ACCOUNT_BALANCE` · `eq = ACCOUNT_EQUITY` |
| cambio giorno | **r.714-727** | se `PropDayKey()` è cambiato → `GV_DAYSTART = BaselineGiorno_Calc(bal,eq,InpDailyBaseline)`, e **azzera `GV_BLOCKDAY` e la pausa** |
| la funzione | **r.235-240** | `modo 1 → bal` · `modo 2 → max(bal,eq)` · **`0` e qualunque altro → `eq`** |
| l'input | **r.135** | `input int InpDailyBaseline = 0;  // 0=EQUITA' (come oggi) . 1=SALDO (FTMO) . 2=MAX` |
| il conto | **r.733 / r.738 / r.742 / r.745 / r.750** | `dayStart=GV_DAYSTART` · `dailyLimit=InpDailyLossPct/100*gStart` · `dailyLoss=dayStart−eq` · `dailyPct=100*dailyLoss/gStart` · `breachDaily=(dailyLoss>=dailyLimit)` |
| l'ancora | **r.572** | `if(InpStartBalance>0) gStart=InpStartBalance;` |

🔴 **`InpDailyBaseline` NON è in nessun preset.** Verificato a macchina su **tutti** i `.set` di
`mql5/Presets/` e `mql5/Presets/FTMO/`: l'unica occorrenza in tutto l'albero dei preset è **una
riga di commento** in `ABTG_Guardian_50504263_779001_VIVO.set` r.22, che lo elenca fra le
manopole **mancanti dal binario**. 👉 **Vale il default: `0` = EQUITÀ.**

🔴 **E nel binario che schieriamo la manopola non esiste proprio.** Il pin del Guardian per il
volo è **`d884f7e1`, 498 righe, v1.12** (`report/SCHIERAMENTO_FTMO_2026-09-20.md` r.185 ·
`report/LE_2000_RICHIESTE_2026-09-20.md` r.100). Letto a `git show`:

```
d884f7e1:mql5/Experts/ABTG_Guardian.mq5 r.307   GlobalVariableSet(GV_DAYSTART,eq);   // v1.12: baseline giornaliera = EQUITA'
d884f7e1:mql5/Experts/ABTG_Guardian.mq5 r.378   GlobalVariableSet(GV_DAYSTART,eq);   // v1.12: EQUITA', non bilancio
```

**Cablata. Nessun input, nessuna scelta.** La v1.14 con il modo esiste a HEAD ma
`report/GUARDIAN_BASELINE_GIORNALIERA_2026-09-08.md` §6 dichiara che **non è compilata**, e il
pin del volo è più vecchio di lei. 👉 Cambiare baseline **non è mettere un numero in un `.set`:
è una ricompilazione della rete di sicurezza del conto**, più una firma di Claudio.

## 1.3 I valori **dei preset veri** — e i due Guardian non sono lo stesso Guardian

🪟 **`mql5/Presets/ABTG_Guardian_FTMO_2Step.set`** → il conto **FTMO `541452707`** (`C:\FTMO`):

| input | valore | in EURO su 80.000 | confronto col muro FTMO |
|---|---:|---:|---|
| `InpStartBalance` | **80000** | — | = Initial Simulated Capital |
| `InpDailyResetHour` | **1** | — | 🟢 ora 1 server FTMO = **00:00 CE(S)T** |
| `InpDailyLossPct` | **4.5** | **3.600 €** | muro 4.000 € → **cuscino 400 €** |
| `InpDailyPausePct` | **3.5** | 2.800 € | pausa morbida (blocca gli ingressi, **non chiude**) |
| `InpTotalDDPct` | **9.3** | 7.440 € | muro 8.000 € → cuscino 560 € |
| `InpMaxOpenRiskPct` | **4.00** | 3.200 € | cap C1 ≈ 2 posizioni a 2,00% |
| `InpAction` | **0** | — | CHIUDI + BLOCCA |
| `InpDailyBaseline` | **ASSENTE** | — | 🔴 default **0 = EQUITÀ** (e assente dal binario) |

🪟 **`mql5/Presets/ABTG_Guardian_50504263_779001_VIVO.set`** → **un'altra macchina e un altro
server**: BCM 100k `50504263`, `BCM Markets MT5 Terminal -V3`. Porta `InpDailyResetHour=**23**`,
`InpStartBalance=100000`, `4.9 / 9.9 / 4.0 / 3.25`. 🔴 **Non confondere i due**: `23` è l'ora
BCM (BCM = UTC+1 → 23:00 BCM = 00:00 CEST), `1` è l'ora FTMO (UTC+3 → 01:00 = 00:00 CEST).
**Sono lo stesso istante scritto in due fusi.** Un `23` finito sul terminale FTMO sarebbe un
reset **2 ore in anticipo**: vedi il contro-esempio al §6.1.

📂 **Altri preset Guardian in `mql5/Presets/FTMO/`: NESSUNO.** Quella cartella contiene 10 `.set`
di sedie + `SpreadLogger` + `TradeExporter`. Il Guardian FTMO sta in `mql5/Presets/`.

---

# 2. 📜 IL LORO CONFINE — testo citato, non parafrasato

Fonte in repo: **`docs/REGOLAMENTO_FTMO_2026-09-20.md` r.135-143**, che cita
`https://academy.ftmo.com/lesson/maximum-daily-loss/`:

> «The Maximum Daily Loss Limit is **recalculated daily at 00:00 CE(S)T** as the difference between
> the account balance recorded at 00:00 CE(S)T of the current day and the Maximum Daily Loss
> Amount, which is **5% of the Initial Simulated Capital**.»
> «On the first day, the account balance used for the calculation is the Initial Simulated Capital.»
> «The rule is based on **equity**, not only on closed results, and includes both the results of
> closed positions and the **floating P/L of open positions**, as well as **commissions and swaps**.»

E `docs/REGOLAMENTO_FTMO_2026-08.md` §2, stessa sostanza più un'annotazione che pesa:

> «The Maximum Daily Loss rule establishes a limit below which your account **equity**
> (Balance + Open Positions P/L ± Swaps – Commissions) cannot drop.»
> ⚠️ *«Il riferimento è il BALANCE delle 00:00, non max(balance,equity): se a mezzanotte hai
> floating loss aperti, il limite del giorno parte comunque dal balance.»*

E `report/REGOLAMENTI_PROP_2026-09-08.md` r.80, colonna FTMO, aggiunge il pezzo sul campionamento:

> «Limite = **saldo registrato alle 00:00 CE(S)T − 5% dell'iniziale**. Include **P/L flottante,
> swap e commissioni**: il vincolo è sull'**EQUITY**, e conta **il punto più basso toccato, anche
> per una frazione di secondo**»

## 🔴 IL CANALE DI LETTURA, e va detto ogni volta
Nessuna di queste righe è una citazione **certificata parola-per-parola**: il proxy di rete nega
`ftmo.com`, `academy.ftmo.com`, `help.ftmo.com` e `web.archive.org` con **403 su CONNECT**
(controllo positivo eseguito e tabellato in `docs/REGOLAMENTO_FTMO_2026-09-20.md` §0). Sono
**`[LETTO-VIA-SEARCH]`**. 👉 Il regolamento **in repo** risponde a tutte e quattro le domande
del mandato (ora / fuso / grandezza / flottante) — ma **con quella riserva sopra**.

## ✅ Quello che il regolamento dice, punto per punto

| domanda del mandato | risposta FTMO | stato |
|---|---|---|
| a che **ora** si azzera | **00:00** | ✅ citato |
| su quale **fuso** | **CE(S)T** (= ora italiana, ora di Praga) | ✅ citato |
| su quale **grandezza** si calcola il livello | **il SALDO (balance) registrato alle 00:00** | ✅ citato, ed **esplicitamente NON `max(saldo,equità)`** |
| le **posizioni aperte** contano | **SÌ**: la regola è sull'**equity**, flottante + swap + commissioni inclusi | ✅ citato |
| con che **granularità** si misura | **il punto più basso toccato, anche per una frazione di secondo** | ✅ citato |

🔴 **`[NON DOCUMENTATO IN REPO]`, e va chiesto al supporto**:
1. **al cambio d'ora del 25/10/2026, il server MT5 di FTMO passa a GMT+2 insieme all'Europa, oppure resta a GMT+3 fino al DST americano del 01/11 (o tutto l'inverno)?** — è la domanda che decide §4;
2. «balance recorded at 00:00» = il **saldo puro**, oppure il saldo **più il flottante** di quell'istante (cioè l'equità)? Il testo dice balance, ma il caso "posizione aperta a cavallo di mezzanotte" **non è trattato esplicitamente** in nessuna riga che abbiamo;
3. se il limite del giorno risulta **più alto** del saldo attuale (flottante positivo a mezzanotte), il livello si alza o resta ancorato al saldo?

👉 Le ho aggiunte a **`report/DOMANDE_SUPPORTO_PROP.md`** (blocco nuovo del 23/09), che era fermo
al 13/08 e **non conteneva nessuna domanda sul confine del giorno**.

---

# 3. 🕐 IL FUSO — il conto, con la misura sotto

## 3.1 La misura che abbiamo

`report/PREVOLO_IL_VERDETTO_2026-09-20.md`, da `PREVOLO_FTMO_specifiche.csv` prodotto il
**20/09/2026 alle 17:08:07** dal terminale FTMO **`541452707`** a mercato **aperto**:

| campo | valore |
|---|---|
| `DeltaServerGMT_hhmm` | **+03:00** |
| `Scarto_vs_atteso_hhmm` | ✅ **+00:00** |

Quindi **FTMO = UTC+3** oggi. E BCM = UTC+1 (**regola di casa**, *ora italiana −1* — 🟠 questa
resta un'**assunzione dichiarata**, non una misura di quella sera: lo dice il referto stesso).
→ **FTMO = BCM + 2** ✅, che è la rimappatura con cui sono stati generati i 10 preset.

## 3.2 A che ora, in ora server FTMO, scatta il nostro reset

```
InpDailyResetHour = 1  (ora server FTMO)
1:00 server − 3 h  =  22:00 UTC
22:00 UTC + 2 h    =  00:00 CEST        ← il confine FTMO, al minuto
```
### ✅ **Scarto oggi: 0 h 00 min.** La finestra di disallineamento **non esiste**.

## 3.3 🔴 E dal 25/10/2026 il repo dice DUE cose diverse

| referto | riga | che cosa afferma sul server FTMO | conseguenza sull'ora 1 |
|---|---|---|---|
| `docs/REGOLAMENTO_FTMO_2026-08.md` §10 | — | «GMT+2 **inverno** / GMT+3 estate» | 🟢 resta 00:00 CET |
| `docs/REGOLAMENTO_FTMO_2026-09-20.md` | r.190-193 | «GMT+3 d'estate e GMT+2 d'inverno… i due si muovono insieme» | 🟢 resta 00:00 CET |
| **`report/REGOLAMENTI_PROP_2026-09-08.md`** | **r.106** | «Server MetaTrader **GMT+3**; il muro è misurato in ora di Praga → **lo scarto server↔regola è 2 ore d'inverno, 1 ora d'estate**» | 🔴 **diventa 23:00 CET: 1 ora in ANTICIPO** |

👉 *«2 ore d'inverno»* si ottiene **solo** se il server resta a **UTC+3 anche d'inverno**. È
l'opposto degli altri due. **Tutti e tre citano le stesse pagine FTMO.** Il repo **non decide**.

E `report/PRESET_FTMO_OROLOGIO_2026-09-20.md` §8 + `report/PIANO_CHALLENGE_OTTOBRE.md` r.155-163
avevano già messo in calendario la **misura del 25/10** — ma per gli `InpSessionHour` delle sedie.
🔴 **Nessuno dei due collega quella misura al confine del giorno del Guardian**, che è la cosa
che costa di più. Questo referto lo collega.

---

# 4. 🧮 LA FINESTRA DI DISALLINEAMENTO, e **chi ci opera dentro**

## 4.1 Le due ipotesi, in ora server FTMO

| ipotesi | dal 25/10 al 01/11 (e forse tutto l'inverno) | reset Guardian | confine FTMO | **finestra** |
|---|---|---|---|---|
| **A** — server segue il DST **europeo** (2 referti su 3) | server UTC+2 | 01:00 = **00:00 CET** | 00:00 CET | 🟢 **0 h** |
| **B** — server resta **UTC+3** (`REGOLAMENTI_PROP` r.106, e il caso "DST americano") | server UTC+3 | 01:00 = **23:00 CET** | 00:00 CET = **02:00 server** | 🔴 **1 h: 01:00 → 02:00 server** |

🔴 **Nell'ipotesi B il verso è quello cattivo: il Guardian azzera PRIMA.** Meccanismo, letto nel
codice (r.714-721 a HEAD, r.374-381 nel pin v1.12): al cambio di `PropDayKey()` il Guardian
riscrive `GV_DAYSTART` **e azzera `GV_BLOCKDAY` e la pausa**. Quindi alle 01:00 server:

- il Guardian **dimentica** la perdita già fatta nella giornata FTMO ancora in corso;
- **sblocca** il lockdown d'emergenza eventualmente scattato;
- **scade** la pausa morbida (che era stata messa proprio a `NextResetTime()`, r.777/780).

📉 **Il caso peggiore, coi numeri veri del preset**: durante il giorno FTMO D il Guardian ferma
tutto a **3.600 €** di perdita (4,5%) e blocca. Alle 01:00 server (23:00 CET) **sblocca e
riparte**, convinto di avere di nuovo 3.600 € di spazio. FTMO invece è ancora nel giorno D con
**solo 400 € residui** prima dei 4.000. 👉 **Basta una perdita di 401 € in quell'ora per fallire
la challenge con il Guardian che non muove un dito.** Il cap C1 a 4,00% (3.200 €) **non lo
impedisce**: è otto volte più largo di quei 400 €.

## 4.2 Chi può avere qualcosa in mano fra le 01:00 e le 02:00 server

Letto nei dieci `.set` di `mql5/Presets/FTMO/`, non a memoria:

| sedia | finestra oraria (ora server FTMO) | **dentro 01:00-02:00?** |
|---|---|---|
| `770101` DAX Apertura | `InpSessionHour=10:00` · `InpCloseHour=19` · `InpCloseAtEnd=true` | ❌ no |
| `770202` Dow Apertura | `16:30` · chiude `19` | ❌ no |
| `770260` Nasdaq RETEST | `16:30` · chiude `19` | ❌ no |
| `770411` MaxMin DAX Short | box `01:00-06:59` · piazza `09` · cutoff `10` · chiude `19` | 🟠 il **box si forma lì**, ma è **sola misura di prezzo**: nessun ordine, nessuna posizione |
| `770402` MaxMin ORO | idem — **NON schierata** (`SCHIERAMENTO_FTMO_2026-09-20.md` §6.2) | n/a |
| `771202`/`771203`/`771204` PostNews | `21` / `15` / `16` — e comunque **non aprono**: calendario scaduto, `InpRestrictToNews=true` | ❌ no |
| 🔴 **`771531` EMA200 DOW H1** | **`InpUseCutoff=false`** e **`InpFridayClose=false`** → **nessun filtro orario, nessuna chiusura forzata, mai** | 🔴 **SÌ, può** |
| 🔴 **`770511` SuperWave DOW H1** | **`InpUseTimeWindow=false`** (`InpStartHour=0`, `InpEndHour=24`) e **nel sorgente non esiste nessuna ora di chiusura** | 🔴 **SÌ, può** |

Verificato nei sorgenti, non dedotto dai `.set`:
- `mql5/Experts/ABTG_EMA200.mq5` r.279 `if(!InpFridayClose) return(false);` e r.449
  `if(!InpUseCutoff) return;` → **con i due `false` del preset FTMO, entrambi i rami sono inerti**.
  (Lo conferma in modo indipendente `report/CONTRATTI_DELLE_SEDIE_FTMO_2026-09-20.md` r.84:
  *«`InpCutoffHour` 19→21 e `InpFridayCloseHour` 20→22, 🟢 tutte e due INERTI»*.)
- `mql5/Experts/ABTG_SuperWave_DOW_H1_Ottimizzato.mq5` r.315
  `if(InpUseTimeWindow && (...)){ ... return; }` → **con `false` il filtro non gira**.

### 👉 **Quindi: nell'ipotesi A il disallineamento non esiste. Nell'ipotesi B esiste e MORDE su due sedie su sei** — e sono proprio le due **DOW H1** che tengono posizioni multi-barra.

## 4.3 📐 Quanto spesso teniamo qualcosa su quel confine — **la misura che ho potuto fare**

`data/statements/trades_100k.csv` (BCM 100k `50504263`, **36 posizioni reali**). Confine FTMO
= 00:00 CE(S)T = **23:00 ora server BCM**. Contate a macchina:

| magic | attraversano il confine | totale | |
|---|---:|---:|---|
| `770101` DAX Apertura | **0** | 16 | ✅ |
| `770202` Dow Apertura | **0** | 3 | ✅ |
| `770411` MaxMin DAX Short | **0** | 4 | ✅ |
| `770611` ORB Dow | **0** | 8 | ✅ (non in rosa FTMO) |
| `770901` SupertrendReversal 225JPY | 🔴 **3** | 5 | **non in rosa FTMO** |
| **totale** | **3 (8,3%)** | **36** | durata media 181 min, max **3.065 min (51 h)** |

Le tre attraversate: `2026.08.27 18:00 → 08.28 06:53` (+84,96) · `2026.09.11 20:00 → 09.13 23:05`
(+445,99) · `2026.09.16 20:00 → 09.16 23:37` (**−155,04**).

🔴 **E il buco è esattamente dove serve**: in quel campione **`771531` e `770511` non compaiono
affatto**. Le due uniche sedie della rosa FTMO che *possono* stare a cavallo del confine sono le
due per cui **non esiste nessun per-trade in repo** — `report/IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md`
lo dice da sé (M7: *«il quinto per-trade»* di `770511` è ancora da produrre). 👉 La loro frequenza
di attraversamento e il loro flottante a mezzanotte sono **`[NON MISURATO]`**.

---

# 5. 🟢 E LA STESSA DOMANDA SUL 4,5% — il margine dello 0,5% **non è misurato su una grandezza confrontabile**

## 5.1 Il conto, in euro

| | **FTMO** | **Guardian** |
|---|---|---|
| ancora del giorno | **saldo** alle 00:00 CE(S)T | **equità** al reset (r.742 `dayStart−eq`, con `dayStart=eq` del pin v1.12 r.307/378) |
| quanto si sottrae | **4.000 €** (5% di 80.000) | **3.600 €** (4,5% di `gStart=80000`, r.738 + r.572) |
| contro che cosa si confronta | **equity istantanea**, flottante+swap+commissioni | **equity istantanea** (`ACCOUNT_EQUITY`, r.707) |
| campionamento | **ogni frazione di secondo** | **1 volta al secondo** (`EventSetTimer(1)`, r.657) |

✅ **Il lato "adesso" coincide**: leggiamo la stessa grandezza che leggono loro, flottante incluso.
🔴 **Il lato "ancora" no.** Sia `B` il saldo a mezzanotte e `X` il **flottante negativo** aperto in
quell'istante:

```
pavimento FTMO      = B − 4.000
pavimento Guardian  = (B − X) − 3.600
il Guardian scatta PRIMA   ⟺   B − X − 3.600  >  B − 4.000   ⟺   X < 400 €
```

### 🔴 **A X = 400 € il cuscino è ESATTAMENTE ZERO. Oltre, il Guardian è più PERMISSIVO di FTMO.**

E 400 € **non è un numero grande**:
- = **0,50%** di 80.000;
- = **0,25 R** alla taglia firmata `InpRiskPercent=2.00` (1 R = 1.600 €);
- = un flottante negativo di **un quarto** di uno stop pieno su **una sola** posizione.

Con **due** posizioni aperte (il massimo consentito dal cap C1 a 4,00%), il flottante combinato
a mezzanotte può valere fino a **3.200 €**: lì il "cuscino" di 400 € è **−2.800 €**, cioè il
Guardian scatterebbe **2.800 € dopo** il fallimento.

🟢 **Il verso opposto è sicuro**: con flottante **positivo** `Y` a mezzanotte il pavimento
Guardian è `B + Y − 3.600`, più stretto di FTMO di `400 + Y`. Scatta presto → costa
un'occasione, non la challenge.

## 5.2 La pausa morbida al 3,5% non tappa il buco

`InpDailyPausePct=3.5` = 2.800 €. Precede la violazione FTMO finché `X < 1.200 €` (= 0,75 R).
Ma la pausa **blocca solo i NUOVI ingressi** (`SetPausa`, r.777): **non chiude niente**. Su una
perdita che matura sul flottante di una posizione già aperta, **non fa nulla**.

## 5.3 🟠 Due erosioni in più, dichiarate

1. **`TimeCurrent()` non è un orologio.** È il timestamp dell'ultimo tick ricevuto. Se il grafico
   su cui sta il Guardian non riceve tick all'istante del reset, **il reset arriva tardi**.
   Direzione: **conservativa** (il Guardian continua a contare il giorno vecchio dentro il nuovo →
   scatta presto → costa un'occasione, non la challenge). 🔴 **Ma è la stessa trappola già pagata
   in casa** — classe 479, `report/NOTTE_2026-09-20.md` r.115-121: *«la colonna Ora non è un
   orologio… chiuso con `TimeTradeServer()`, che il terminale calcola e vale a mercato fermo»*. Il
   Guardian usa ancora `TimeCurrent()`. E **su quale simbolo sta il suo grafico non è pinnato da
   nessuna parte**: `report/PACCHETTO_SCHIERAMENTO_PROP_2026-09-21.md` r.206 dice *«un grafico
   qualsiasi»* → **la durata dello stallo è `[NON MISURATO]` perché il simbolo non è deciso**.
2. **Il campionamento.** FTMO conta *«il punto più basso toccato, anche per una frazione di
   secondo»*; il Guardian guarda **una volta al secondo**. Un minimo che vive meno di un secondo,
   o un gap, **viola senza che il Guardian abbia una mano da giocare**. Già dichiarato
   nell'intestazione del preset (*«nessuno chiude attraverso un gap»*): lo ripeto perché fa parte
   dello **stesso** margine dello 0,5%, non è una cosa a parte.

---

# 6. 🧪 IL CONTRO-ESEMPIO — ho provato a rompere la mia conclusione

La conclusione dell'**ora** è *«coincidono»*. Quindi devo costruire lo scenario in cui **non**
coincidono e far vedere che non si verifica. Ne ho costruiti **quattro**.

## 6.1 ✅ Contro-esempio 1: *«e se l'ora giusta non fosse 1?»* — **la misura discrimina**

L'ipotesi alternativa non è "un numero a caso": è **il valore che il preset portava prima**, cioè
`InpDailyResetHour=23` (ora BCM), che `report/SCHIERAMENTO_FTMO_2026-09-20.md` r.205 segnala
testualmente come **«`23` — NON RIMAPPATO, va messo a `1` A MANO»**.

```
ipotesi 1 (nostra) : 01:00 server − 3 h = 22:00 UTC = 00:00 CEST   ← confine FTMO
ipotesi 23 (alt.)  : 23:00 server − 3 h = 20:00 UTC = 22:00 CEST   ← 2 ORE PRIMA
```
👉 Le due ipotesi atterrano a **2 ore di distanza**. Un errore di misura del delta dovrebbe valere
**due ore intere** per confonderle, e il delta è misurato al quarto d'ora (`+03:00`, scarto
`+00:00`). ✅ **La misura discrimina: la banda non è compatibile con l'alternativa.**

🔴 **MA il contro-esempio ne fa uscire uno nuovo, e questo NON lo so rompere**: che sul grafico
attaccato ci sia davvero `1` e non `23` dipende da **un passo a mano**
(`report/NOTTE_2026-09-20.md` r.142, passo 9: *«la riga te lo stampa: `BCM 23 -> FTMO 1`»*).
**In repo non esiste nessun artefatto** — log, foto dei `.chr`, referto — **che certifichi che il
valore in campo è 1.** Il `.set` in repo dice 1; il grafico è un'altra cosa (è esattamente la
lezione di `ABTG_Guardian_50504263_779001_VIVO.set`: *«NON ESISTEVA. La rete di sicurezza viveva
solo dentro un file `chart*.chr`»*). → **`[NON VERIFICATO IN CAMPO]`**, §7.

## 6.2 ❌ Contro-esempio 2: il DST — **non riesco a romperlo, e vince lui**

Cercata la prova che il disallineamento di fine ottobre è innocuo. **Non l'ho trovata**: il repo
si contraddice (§3.3) e nessuna delle tre righe è una misura nostra. 👉 La conclusione onesta è
*«coincidono OGGI»*, non *«coincidono»*. **Il contro-esempio ha vinto sulla mia prima stesura**,
che diceva "coincidono" senza data.

## 6.3 ❌ Contro-esempio 3: cercare la **guardia a monte** che rende innocua l'ipotesi B

Come chiede il mandato, ho cercato la prova che il disallineamento **non morde**. Tre candidate,
tutte e tre cadute:

| candidata | perché NON salva |
|---|---|
| *«a quell'ora non opera nessuno»* | ❌ falso: `771531` e `770511` non hanno **nessun** filtro orario (§4.2, verificato nei sorgenti) |
| *«il cap C1 limita il danno»* | ❌ il cap è **3.200 €**, il residuo FTMO nel caso peggiore è **400 €**: otto volte più largo |
| *«la pausa morbida resta attiva»* | ❌ la pausa è messa con scadenza `NextResetTime()` (r.777) — cioè **alla stessa ora sbagliata**: scade insieme al reset |

🟢 **Una sola attenuante, ed è vera**: il muro **statico del 10%** non ha confini giornalieri
(`totalDD = gStart − eq`, r.743, con `gStart=80000` fisso) → **resta in piedi intatto** anche
nell'ipotesi B. La rete non sparisce: si buca **solo** sul giornaliero.

🟠 **E una possibile attenuante che NON posso verificare**: se `US30.cash` fosse **in pausa di
mercato** fra le 01:00 e le 02:00 server, la finestra sarebbe vuota di fatto. In repo ci sono
misure di spread **solo** per le ore 09 e 10 (`report/SPREAD_APERTURA_FTMO_2026-09-21.md` r.48).
**Gli orari di sessione di `US30.cash` sul server FTMO sono `[NON MISURATO]`.** 👉 È la misura
**più economica** che chiuderebbe la questione, e la nomino al §7.

## 6.4 ✅ Contro-esempio 4: *«e se il preset FTMO in realtà impostasse la baseline al saldo?»*

Verificato a macchina, non a memoria: `grep -n "InpDailyBaseline" mql5/Presets/*.set
mql5/Presets/FTMO/*.set` restituisce **una sola riga, ed è un commento** (in
`ABTG_Guardian_50504263_779001_VIVO.set` r.22, che lo elenca fra le manopole **assenti dal
binario**). E il pin del volo `d884f7e1` **non ha proprio l'input**. ✅ Il difetto del §5 è reale,
non un'assunzione mia.

---

# 7. 🔴 NON COPERTO — per nome

| # | che cosa | perché non è coperto | la via più corta |
|---|---|---|---|
| **N1** | **Il fuso del server FTMO dal 25/10/2026** | il repo afferma **due cose incompatibili** (§3.3), entrambe `[LETTO-VIA-SEARCH]` | una lettura di `TimeTradeServer()−TimeGMT()` **prima e dopo** la notte del 25/10 sul terminale FTMO — 2 numeri. Oppure la domanda scritta al supporto (§2) |
| **N2** | **Che `InpDailyResetHour` valga davvero `1` sul grafico attaccato** | era un **passo a mano**; nessun log, nessuna foto dei `.chr`, nessun referto in repo lo certifica | una riga di **sola lettura** sul terminale FTMO `541452707` (`C:\FTMO`) che rilegge il `.chr` del Guardian — 🔴 **che passa dal cancello prima di uscire** |
| **N3** | **Quante volte `771531` e `770511` tengono posizioni sul confine, e con che flottante** | **non esiste nessun per-trade** in repo per quelle due sedie (`IL_PIANO_DEGLI_OTTO_GIORNI_2026-09-23.md`, M6/M7) | è **già in calendario** (VEN 25/09, `770511` a 80.000 con export per-trade): basta che chi legge quei CSV **conti anche gli attraversamenti delle 00:00 CE(S)T** |
| **N4** | **Gli orari di sessione di `US30.cash` sul server FTMO** (01:00-02:00 è mercato aperto?) | in repo ci sono spread solo per le ore 09 e 10 | il logger di spread gira già: serve solo **leggerlo sulle ore 00-03** |
| **N5** | **Su quale SIMBOLO sta il grafico del Guardian** | `PACCHETTO_SCHIERAMENTO_PROP` dice *«un grafico qualsiasi»* | senza questo, la durata dello stallo di `TimeCurrent()` (§5.3) non è calcolabile |
| **N6** | **Se FTMO consideri "balance at 00:00" = saldo puro anche con posizioni aperte** | il testo dice *balance*, ma il caso a cavallo **non è trattato** in nessuna riga citata | domanda 2 del blocco nuovo in `DOMANDE_SUPPORTO_PROP.md` |
| **N7** | **Il lato BCM del cambio d'ora** | verifica **M9** di `PRESET_FTMO_OROLOGIO_2026-09-20.md`, **mai chiusa** | stessa lettura di N1, sull'altro terminale |
| **N8** | **Se la v1.14 (col modo baseline) compili e giri** | `GUARDIAN_BASELINE_GIORNALIERA_2026-09-08.md` §6: **non è compilata**; e il pin del volo è la **v1.12** | una compilazione al banco, **fuori** dal terminale che opera |

---

# 8. 🙋 LE DOMANDE PER CLAUDIO — **domande, non proposte**

Il mio mandato porta la **misura**. Le tre cose che ne escono e che **solo Claudio firma**:

1. 🔴 **Il cuscino di 400 € (0,5%) è calcolato su un'ancora diversa dalla loro.** A flottante
   negativo ≥ 400 € sul confine, il Guardian è **più permissivo** di FTMO. **Che cosa si fa non lo
   decido io**: le strade che la misura rende visibili sono tre — lasciare com'è accettando che il
   cuscino valga solo sulle notti **piatte**; cambiare la **grandezza** (`InpDailyBaseline`, che
   però **non è nel binario in campo**: è una ricompilazione della rete di sicurezza, N8);
   cambiare il **numero**. 🚫 **Non propongo nessuna delle tre.**
2. 🔴 **N1 è una scadenza con una data**: il 25/10 cade **dentro** la challenge. Se vince
   l'ipotesi B, il confine si sposta di un'ora **su due sedie su sei**. La misura costa due numeri
   e cinque minuti — ma **è un'azione su un terminale**, quindi è una riga che passa dal cancello.
3. 🟠 **N2 è il buco più economico di tutti**: sapere se in campo c'è `1` o `23` è **una lettura**.
   Finché non è letto, tutto il §3 descrive **il preset in repo**, non la rete che gira.

---

## 📌 Come si legge questo referto fra un mese
- Il **muro del 10%** non c'entra niente con tutto questo. ✅
- L'**ora** del muro giornaliero è giusta **oggi**, e la misura che lo dice ha una data:
  20/09/2026 17:08.
- La **grandezza** da cui parte il conteggio **non è la loro**, e non lo è **per progetto**
  (fix del 06/09 sul conto reale col credito): non è un bug da riparare di nascosto, è una
  **scelta di conto** che su FTMO **non è mai stata fatta**.
- Tutto il resto è in §7, **per nome**.

---
*Scritto il 23/09/2026. Sola lettura: nessun EA, nessun preset, nessuna sedia, nessun round.
Le righe di codice sono lette a `git show`/`sed` nel repo, non riprese dai referti. Le citazioni
FTMO sono `[LETTO-VIA-SEARCH]` e lo dichiarano. Dove manca un numero c'è `[NON MISURATO]`.*
