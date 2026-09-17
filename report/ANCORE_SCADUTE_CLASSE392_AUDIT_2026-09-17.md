# 🕵️ AUDIT — verdetti che poggiano su ancore scadute (classe 392), 17/09/2026

> Nato dalla classe NUOVA 392 (`CHECKLIST_RIGA_DI_LANCIO.md`): il commit
> `3af47ed9` (08/08/2026 11:48:56 UTC, "fix sizing su 41 EA: OrderCalcProfit
> al posto del tick value nudo") e il suo parente `872dba82` (08/09, pavimento
> lotto minimo, 15 EA) hanno cambiato come si calcola il volume degli ordini.
> Un CSV d'ancora prodotto PRIMA di quel commit, su uno di quegli EA, non è un
> banco sporco: è un contratto di ancoraggio scaduto. Questo audit cerca
> verdetti "bocciato/morto" in `REGISTRO_TEST.md` che si appoggiano a una di
> quelle ancore scadute. **Sola lettura: zero preset toccati, zero EA
> ricompilati, zero round rilanciati. La decisione su cosa fare resta di
> Claudio.**

---

## 🟢 IL CONTO REALE 10105439 NON È COLPITO

Verificato, non assunto: sul reale girano `ABTG_DAX_Apertura_EU` (770101) e
`ABTG_ORB_Ottimizzato` (770611).
- `ABTG_ORB_Ottimizzato.mq5` **non è** nella lista dei 41/15 EA toccati.
- `ABTG_DAX_Apertura_EU.mq5` **è** nella lista, ma gira su D30EUR (valuta di
  profitto EUR = valuta del conto): il fix è algebricamente un no-op su quel
  simbolo — **[INFERENZA]**, non misurata da qui (richiede leggere
  `SYMBOL_CURRENCY_PROFIT` su MT5). Confermato anche da
  `report/DISALLINEAMENTO_CAMPO_v2_2026-09-12.md` (binario del reale allineato
  a HEAD, quindi ha già il fix) e da `report/FIX_LOTTO_PENDENTE_2026-09-08.md`
  r.181 ("terminale REALE — nessuna sedia colpita" per `872dba82`).

## 🚨 IL CASO PIÙ IMPORTANTE: `SupertrendReversal` 225JPY (Nikkei) — probabilmente vivo, oggi marcato morto

- `REGISTRO_TEST.md` r.396: *"PF ~2, DD 0,2%, profitto irrisorio (~€50, lotto
  JPY minuscolo)"* — scartato per taglia del contratto.
- `REGISTRO_TEST.md` r.2531-2532 (12/09, il certificato di morte): stesso
  verdetto, stessa causa dichiarata.
- 🔴 **Ma un round POST-FIX esiste già dal 09/08** (`report/DIARIO.md`,
  round 5): a deposito 100k col sizing corretto, **H2+H3+H4 aggregato OOS
  +4225,85 su 113 trade, PF 1,54-1,65, DD max 1,01%**. Verdetto scritto quel
  giorno: *"il fix ha morso e il Nikkei torna candidato: tutti e tre i criteri
  scritti prima sono passati."* Cella di riferimento: **H2** (+1863,34 · PF
  1,653 · DD 0,88% · 50 trade OOS).
- **`REGISTRO_TEST.md` e `risultati_archivio/CLASSIFICHE.md` non hanno mai
  recepito questo numero.** Portano il verdetto morto da 39 giorni.
  `CLASSIFICHE.md` r.41/r.82/r.97 arriva a citare il **DD 0,14%** (il sintomo
  del bug, lotto incollato al minimo) come una **virtù prop-grade** ("DD più
  basso, candidato prop-grade").
- ⚠️ **Verbali in conflitto sul binario in campo**: `DIARIO.md` 08/08
  pomeriggio dice "ricompilato sul VPS, il Nikkei ora gira col lotto vero";
  `DIARIO.md` 09/08 e `CLASSIFICA_WEEKEND.md` r.44 dicono "sul VPS gira ancora
  il codice vecchio a lotto minimo". Sedie coinvolte: **770924** (piccolo
  50503392) e **770901** (100k 50504263). **[NON VERIFICABILE da qui]** —
  serve una lettura del campo.

👉 **Costo per chiudere questo caso: zero passate di tester.** Il numero c'è
già (`R5_Nikkei_sizing_fix.txt` / `REFERTO_ROUND5_NIKKEI.md`), manca solo
propagarlo nei registri e verificare quale binario gira davvero in campo.

## ⚠️ ALTRI DUE CASI DA SAPERE

- **`Dow_Apertura` U30USD** (registro r.377): morto a PF 0,997 (quasi in
  pari) su un'ancora del 26/07 pre-fix. Un round post-fix diverso (R47c/R54a)
  legge PF OOS 1,27 / IS 1,22 — **non è una controprova di causa** (sono
  cambiati anche altri parametri, InpEntryMode incluso), ma è il miglior
  esempio in repo che un "morto" pre-fix su un simbolo non-EUR oggi può
  leggere un'altra storia.
- **Tutto il fronte 100GBP (FTSE)**: quattro verdetti negativi (`Apertura`,
  `SupRev` H1/H4, `MaxMinNotte`), **zero CSV post-fix in repo**. Valuta di
  profitto GBP, mai rimisurati.

## 🟠 SEDIE VIVE IL CUI BADGE "VALIDATO" (`FLOTTA_ATTIVA.md`) POGGIA SU UN'ANCORA PRE-FIX

`770924`/`770901` (225JPY, il caso sopra) · `770922` (XAGUSD) · `770923`
(D30EUR) · `970913`/`770925` (NASUSD) · i cinque gemelli `EMA200` H4
(`771511-771515`, due dei quali su AUDJPY/GBPJPY — valuta di profitto JPY,
la stessa famiglia del bug confermato). Attenuante su questi ultimi: **0
posizioni dal 30/03**, nessun rischio si è materializzato finora.

Anche `ABTG_EMA200` **771531** (la prima sedia, già nota per due fail-open —
Guardian assente nel binario in campo, nessun Guardian sul piccolo 50503392)
si aggiunge un **terzo fail-open**: il binario in campo (`344a11b`, 04/08)
precede `3af47ed9` — verificato con `git merge-base --is-ancestor`.

## 📊 NUMERI DELL'AUDIT

| misura | valore |
|---|---:|
| EA toccati da `3af47ed9` | 41 |
| File toccati da `872dba82` | 15 |
| CSV d'archivio pre-fix su EA della lista (verificato ancestor) | 456, su 30/41 EA |
| Righe di verdetto negativo/qualificato pre-fix in `REGISTRO_TEST.md` | 33 |
| Verdetti della tabella "dieci scarti col numero" (12/09) verificati pre-fix | 10 su 10 |
| Coppie EA+simbolo con SOLO ancora scaduta in repo (mai rimisurate) | 26 (lista completa sotto) |

**Contro-esempio costruito e verificato** (per non generalizzare troppo): la
firma grave del bug (DD quasi nullo, lotto incollato al minimo) compare
**solo** su 225JPY fra i dieci scarti certificati del 12/09 (DD 0,22%/0,12%);
gli altri nove hanno DD 2-16%, lotti che scalavano normalmente. La forma
lieve (fattore di conversione sbagliato senza toccare il pavimento del lotto)
è invisibile nell'archivio e sposta il verdetto solo dove il margine è già
sottile — non "tutto il pre-fix va rifatto", ma "ogni verdetto stretto su
questi EA va riletto prima di fidarsene".

### Le 26 coppie EA+simbolo con solo ancora scaduta (mai rimisurate)

`Apertura`: 100GBP · E50EUR · SPXUSD — `GoldenCross`: 100GBP · 200AUD ·
225JPY · AUDJPY · E50EUR · F40EUR · GBPJPY · SPXUSD — `Live5m`: D30EUR —
`MaxMinNotte`: 100GBP · E50EUR · F40EUR — `PTE`: XAUUSD — `SupRev`: 100GBP ·
225JPY · D30EUR · E50EUR · F40EUR — `SuperWave`: D30EUR —
`SupertrendInvert`: XAUUSD — `SupertrendReversal`: 100GBP · 200AUD · AUDJPY
· D30EUR · E50EUR · F40EUR · GBPUSD · NASUSD · SPXUSD · U30USD — `WOL`:
XAUUSD.

*(Un CSV "post-fix" in questa mappa vuol dire solo che esiste — non che sia
sullo stesso TF/configurazione del verdetto originale.)*

## 🎯 Il verdetto, senza ammorbidire niente

Non dico che questi motori sono buoni. Dico che **33 verdetti pre-fix, tutti
e dieci i certificati di morte del 12/09, e 26 coppie EA+simbolo** poggiano
su un binario che non esiste più — vanno riletti prima di fidarsene, non
sono automaticamente promossi. E per il certificato di morte manca comunque
il resto (gestione dell'uscita ad asse, simboli gemelli, TF cambiato).

**Nessuna azione eseguita**: nessun preset cambiato, nessun EA ricompilato,
nessun round rilanciato. Il passo più economico è propagare il numero già
esistente di R5 sul Nikkein nei registri — zero passate di tester — e
verificare quale binario gira davvero sui terminali 50503392/50504263 per
quella sedia.
