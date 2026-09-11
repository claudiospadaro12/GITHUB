# ✅ RUNNER v3 — COLLAUDATO DA ME, 45 CASI SU 45. E il tappo **non è ancora tolto**

**Girato da me**, non creduto dal riassunto dell'agente:

| prova | esito |
|---|---|
| parser PowerShell vero (`Parser::ParseFile`) | 🟢 **0 errori di sintassi** |
| `pwsh -File runner_abtg.ps1 -CollaudoCancelli` | 🟢 **45 giusti, 0 sbagliati** · `EXIT=0` |
| byte non-ASCII | 🟢 **0** |
| regressione su **108 `.ps1`** veri, prelude v2 contro v3 | 🟢 **differenze di esito: ZERO** |

---

## 🔧 E CORREGGO IL MIO STESSO ALLARME, quello che ho dato a Claudio due volte

Avevo scritto: *"graffe **249 contro 248**, sbilanciate di una — in un `.ps1`
che di notte avvia processi, la differenza non si indovina"*.

🔴 **Il conteggio era vero e non voleva dire niente: quelle graffe stanno dentro
stringhe.** Il parser è l'autorità, il mio `grep` no.
👉 **Ho usato una misura di FORMA dove serviva la SEMANTICA.** È la **classe 230**,
e l'avevo già pagata oggi. Due volte nella stessa giornata.

---

## 🏗️ COM'È FATTO — due corsie, mai una lista di deroghe

| | corsia **LETTURA** | corsia **ROUND** |
|---|---|---|
| marcatore | `RUNNER_SOLA_LETTURA` | `RUNNER_ROUND_BACKTEST` |
| divieti attivi | **29** | **33** |
| tutti e due i marcatori | 🚫 **RIFIUTATO** — l'ambiguità non si interpreta | idem |

🚪 **G3, il cancello POSITIVO**: un round deve **nominare il banco IN CODICE**
(`C:\MT5_Backtest` o il conto `50504400`) — non in un commento. E ogni variabile
usata come bersaglio dev'essere assegnata a **quel percorso letterale**, o a un
`Join-Path` su una già approvata. **Riassegnazione = squalifica permanente.**

🆕 **G4, che non esisteva**: gli **argomenti** della riga di coda. Fino alla v2
arrivavano allo script **senza nessun controllo** — ed è esattamente da lì che un
round prende il bersaglio.

### 🎯 Il buco del 100k è chiuso — **ma NON con la stringa che avevo proposto io**
Avevo detto *"aggiungi `-V3`"*. 🔴 **Sarebbe stato un disastro**: il `-V3` nudo
compare in **27 righe legittime** che lo usano per **ESCLUDERE** il 100k
(`-notlike "*-V3*"`), e `-match` in PowerShell è **case-insensitive**, quindi
avrebbe preso anche `HD-M1-v3`, `DUKA-M1-v3`, `R93-LANCIO-v3`.
👉 **Avrebbe bocciato le guardie, cioè il codice scritto bene.**
Forma usata: **`MT5 Terminal -V3`** (il nome vero della cartella) + `50504263` +
l'hash della cartella dati, **misurato** da `CODA_03`, non dedotto.

---

# 🔴 MA IL TAPPO NON È TOLTO — e va detto subito

## Il buco **strutturale**: il codice che gira davvero **non passa dal cancello**

Un round è fatto così: lo script in coda **scarica** `walkforward_generico.ps1` e
`RIGA_ROUND_VPS.ps1` da un pin, e li **lancia**. 🔴 **Il cancello legge solo lo
script in coda.** Tutto ciò che fa il driver — chiudere processi, scrivere,
cancellare — è **fuori**.

## E la conseguenza immediata, **misurata da me**

`RIGA_ROUND_VPS.ps1` contiene su **righe eseguibili** `[MISURATO]`:

| stringa vietata | righe eseguibili |
|---|---:|
| `Remove-Item` | **5** |
| `BCM_Reale` · `10105439` · `Copy-Item` | **2** ciascuna |
| `50504263` · `Stop-Process` · `Set-Content` | **1** ciascuna |

**Quasi tutte dentro le sue stesse GUARDIE** — cioè il codice che *protegge*.
Ma lo scanner del runner è **a sottostringa** e **non sa distinguere una guardia
da un bersaglio**. *(`controlla_riga.py` lo sa fare con `in_una_guardia()`:
quella clemenza qui **non è stata copiata, e apposta**.)*

> ## 🔴 **Tradotto: oggi NESSUNO script di round passa il cancello. L'allargamento è implementato, collaudato — e non ha ancora fatto girare un round.**
> Serve una **riga sottile nuova** che dichiari il banco, scarichi il driver e lo
> lanci. **Non esiste, e va scritta.**

---

## 🕳️ E GLI ALTRI BUCHI, dichiarati — questo elenco vale più del codice
1. 🔴 **Scritture senza vincolo di destinazione**: in ROUND si può scrivere
   **ovunque**. Un percorso raggiunto per **enumerazione**
   (`$env:APPDATA\MetaQuotes\Terminal\*`) non è bloccato: si potrebbe
   sovrascrivere un EA o un preset di una sedia viva.
2. 🔴 **`Stop-Process` protegge meno di quanto sembri**: vietato **nello script in
   coda**, non nel driver. Il wrapper può passare `-ChiudiBacktest` (stringa
   innocua) e lo `Stop-Process` lo fa il driver, fuori dal cancello. *(Lì è
   filtrato per percorso, r.309-333 — ma è **una protezione del driver, non del
   cancello**.)*
3. 🟠 **G3 non segue il flusso dei dati**: `Start-Process powershell.exe
   -ArgumentList $arg` passa senza che il cancello sappia cosa c'è in `$arg`.
4. 🟠 **Il cancello controlla un PERCORSO, non un CONTO.** Nessuno verifica che il
   terminale in `C:\MT5_Backtest` sia davvero loggato sul **50504400**.
5. 🟠 **Contro un avversario determinato non tiene** (`"5050"+"4263"`, base64).
   Modello di minaccia dichiarato: **il nostro stesso errore**, non un attaccante.
6. 🔴 **Non è mai girato su Windows PowerShell 5.1.** Qui è `pwsh 7.4.6` su Linux.
   **La prova è il giro sul VPS.**
7. 📄 **Documenti non allineati**: `PERIMETRO_RUNNER.md` descrive ancora la sola
   lettura e parla di *"23 modelli"*; l'intestazione di `CODA.txt` dice
   *"24 divieti"* e *"OGNI script DEVE contenere `# RUNNER_SOLA_LETTURA`"*.
   **Da aggiornare prima di installare.**

---

## 🚦 COSA MANCA PRIMA DI INSTALLARE
1. 🔴 **la riga sottile** che faccia passare un round dal cancello (senza, la
   corsia è un cancello che non fa passare nessuno);
2. 📄 allineare `PERIMETRO_RUNNER.md` e l'intestazione di `CODA.txt`;
3. 🖥️ girare `-CollaudoCancelli` **sul VPS**, su PowerShell 5.1;
4. 🎯 **primo giro con UNA sola riga, guardando.**

> ## 🔥 Il cancello è fatto bene, e l'agente ha provato a romperlo prima di consegnarlo: tre casi insidiosi passavano la sua prima stesura e sono rifiutati dalla finale. **Ma un cancello collaudato non è un round girato**, e questo va scritto come sta.
