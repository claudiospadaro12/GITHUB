# ✂️ POTATURA DELLA CODA — PROPOSTA PRONTA PER LA FIRMA (17/09/2026)

> **Preparata, NON eseguita.** `CODA.txt` non è stata toccata. Il perimetro del
> runner è sola lettura: **questa è una decisione di Claudio.**
>
> Il perché sta in `report/IL_PEDAGGIO_DELLA_CODA_2026-09-17.md`: `-Rifai` è
> cablato (`RIGA_ROUND_VPS.ps1` r.649), quindi il runner **rifà ogni notte i
> round già misurati**. Prova diretta: `r127a` girato due notti di fila con
> uscita 0 (8.245 s il 15/09, 5.728 s il 16/09).

---

## 🎯 LA DECISIONE IN UNA RIGA

**Potare 72 righe già misurate → si liberano 10,91 h di macchina a notte.**
La coda attiva passa da **127 a 55 righe**. Marcia indietro: **un `sed` solo**,
e torna byte-identico (collaudato su copia).

## 📐 IL CRITERIO, dichiarato prima dei numeri

Potabile = **il round ha già prodotto i suoi CSV**:

| esito | significato | potabile? |
|---|---|---|
| **uscita 0** | `ROUND GIRATO`, numeri prodotti | ✅ sì (50 round, 8,10 h) |
| **uscita 3** | `ROUND GIRATO CON RILIEVI` — i numeri **ci sono**, non è un fallimento | ✅ sì (12 round, 1,09 h) |
| **uscita 2 + `@FRAZIONEIS 1.0`** | l'OOS non può esistere per costruzione (classe 395); il CSV **IS** c'è | ✅ sì (10 round, 1,72 h) |
| **uscita 2 senza `@FRAZIONEIS 1.0`** | fallimento vero | ❌ no |
| **mai in un referto** | deve ancora girare | ❌ no (41 round) |

➕ **Clausola aggiunta in corsa, e ha morso**: un round lanciato con
`-SoloControllo` **gira a vuoto e non produce nessun CSV**, anche se esce 0.

## 🔴 CIÒ CHE RESTA IN CODA, e perché

- **`cemad02`** (r.485, 122 s) — uscita 2 con `@FRAZIONEIS 0.002`: la gamba OOS
  **doveva** esistere. È **l'unico fallimento vero** delle ultime notti. Rigira.
- **`canfrz`** (r.449, 13 s) — la riga porta `-SoloControllo`: gira a vuoto.
  Prova indipendente: nella foto del Desktop del 16/09 ci sono **56 cartelle
  `ROUND_*`** e **nessuna `ROUND_canfrz`**, benché sia girato quattro notti.
  È il canarino della `@FRAZIONEIS`: resta, costa 13 secondi.
- **I 41 mai girati** (da `r163a`/`r164a` fino a `r178a`) — intatti.

## ⚠️ QUATTRO ROUND SEGNALATI A PARTE — ancora pre-fix di sizing

`r133c` · `r139a` · `r154a` · `r155a`. Le loro **ancore** sono CSV anteriori al
commit `3af47ed9` (08/08/2026 11:48 UTC, il fix del lotto su 41 EA — **classe
392**). 🟡 **Sfumatura onesta**: questi quattro **hanno girato sul binario
nuovo**, quindi i loro numeri sono validi — scaduto è il **metro** con cui si
confrontano. Potarli non perde nulla, **ma se decidi di rifare l'ancora vanno
rilanciati apposta**. (`r139a` è su AUDJPY, valuta di profitto JPY: la famiglia
in cui il bug del sizing è confermato.)

🔎 Per **37 round su 72** il CSV d'ancora citato non è tracciato nel repo →
**[NON MISURATO]** se sia pre- o post-fix.

## 🛡️ LA PROVA CHE I NUMERI NON SI PERDONO

| forza | round | tempo | come è provato |
|---|---:|---:|---|
| **T1** | 35 | 6,99 h | CSV **nel repo** |
| **T2** | 20 | 1,56 h | cartella `ROUND_*` **coi byte** nella foto Desktop del 16/09 |
| **T3** | 17 | 2,36 h | solo la riga del referto (il driver verifica *"CSV attesi: 2, presenti: 2"*) |

I 17 di T3 sono **tutti e soli** quelli girati per la prima volta la notte del
16/09, cioè **dopo** la foto delle 03:31: l'assenza è spiegata dall'orologio.

> 💡 **OPZIONE PRUDENTE, se preferisci**: potare oggi solo i **55 di T1+T2**
> (**8,55 h** liberate) e i 17 di T3 domani mattina, quando la foto
> `CODA_07_desktop` del 17/09 li elencherà coi byte. Costa zero e chiude il
> dubbio con una prova doppia.

## 🔁 LA PROCEDURA — non si cancella niente, si commenta in posto

🪟 **Bersaglio: nessun terminale MT5.** Si esegue nel repo. Nessun EA, nessun
preset, nessun conto. Il runner legge **solo** `CODA.txt` (`runner_abtg.ps1`
r.96). ⚠️ La corsa del **17/09 in corso non è toccata** (il runner scarica la
coda una volta alle 03:30): la potatura agisce sulla corsa del **18/09**.

**È il metodo già usato in casa**: `CODA.txt` r.138-171 — *"r133a RITIRATA DALLA
CODA IL 12/09/2026 … La riga è qui sotto, pronta: si toglie il '# ' davanti."*
Pin e argomenti restano dove sono: **zero rischio di ricopiare male 40
caratteri esadecimali.**

Lo script completo (creazione dello storico + potatura + verifica coi numeri
attesi) è nel referto dell'agente; qui la parte che conta, **la marcia
indietro**:

```bash
# tutte le righe
sed -i 's/^# POTATA 2026-09-17 //' backtest_pipeline/coda/CODA.txt

# un round solo (esempio r127a)
sed -i '/-Etichetta r127a /s/^# POTATA 2026-09-17 //' backtest_pipeline/coda/CODA.txt
```

✅ **Collaudato su copia** (`CODA.txt` non toccata): attive 127 → 55, potate 72,
storico 72 righe; `sed` inverso → `cmp` con l'originale **identico byte per
byte**.

📈 **E la lista cresce da sola**: stanotte girano anche i 41 mai girati. Appena
arriva il referto del 17/09 si rilancia lo stesso criterio con le etichette
nuove.
