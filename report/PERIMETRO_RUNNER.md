# ✍️ PERIMETRO DEL RUNNER — da firmare prima di installarlo

Nasce dalla domanda di Claudio del 07/09/2026:
> _"Ma puoi lanciarle tu le stringhe per me? Fammi firmare qualcosa che mi
> assumo la responsabilità della firma."_

## 🔌 Perché una firma da sola non bastava — e cosa serviva davvero

Claude gira in un container nel cloud; il VPS di Claudio è un'altra macchina e
fra i due **non c'è nessun collegamento**. Nessuna firma crea un cavo di rete.

Ma **metà del cavo esiste già ed è in produzione**: `pubblica_trades.ps1` gira
sul VPS come attività pianificata alle 22:45 e carica i CSV sul repo via API
GitHub, col token che sta sul VPS. Prova, nei commit del repo:

```
8b68fcf  2026-09-04  Aggiornamento automatico trades (2026-09-04 22:45)
1f02d2e  2026-09-03  Aggiornamento automatico trades (2026-09-03 22:45)
```

👉 Mancava il **verso opposto**: scaricare una coda ed eseguirla.
`backtest_pipeline/runner_abtg.ps1` è quel verso.

---

## ⚠️ E VA DETTO PRIMA DI TUTTO IL RESTO

**Questo è l'oggetto più pericoloso che il progetto abbia mai costruito.**
Uno script che, di notte, senza nessuno davanti, **scarica del codice da
internet e lo esegue** su una macchina dove girano tre terminali con posizioni
vive — di cui uno con **soldi veri**.

Non è un dettaglio da mettere in fondo. È il motivo per cui esistono i cancelli
e per cui il perimetro qui sotto è stretto.

---

## ✅ COSA IL RUNNER PUÒ FARE

| | |
|---|---|
| 📖 | leggere log, `.chr`, CSV, referti |
| 🔢 | contare, misurare, incrociare |
| 📝 | scrivere **il proprio referto** e i log delle corse |
| ☁️ | pubblicare quei referti sul repo, sotto `backtest_pipeline/coda/referti/` |

## ❌ COSA IL RUNNER NON PUÒ FARE — e non è una promessa, è codice

| | |
|---|---|
| 💶 | **toccare in qualunque modo il conto REALE 10105439** |
| 📈 | aprire, chiudere o modificare posizioni e ordini |
| 🔌 | attaccare o staccare EA, aprire grafici, applicare template |
| ⚙️ | cambiare un parametro di rischio |
| 🗑️ | cancellare, spostare o sovrascrivere file |
| 🏃 | avviare processi (MT5 compreso) |
| ⏰ | registrare o cancellare attività pianificate |
| 🧨 | eseguire testo arbitrario (`Invoke-Expression`, `DownloadString`) |

## 🚪 I DUE CANCELLI — indipendenti, in AND, tutti e due codice

**G1 — IL MARCATORE.** Uno script entra in coda solo se contiene la riga
`# RUNNER_SOLA_LETTURA`. È un **opt-in deliberato**: qualcuno deve averla
scritta apposta in quel file. Uno script nuovo non entra per sbaglio.

**G2 — LA SCANSIONE DEI DIVIETI.** Il sorgente viene letto **riga per riga**
(saltando i commenti) e cercato per **23 modelli** che corrispondono ai divieti
qui sopra. Se ne compare **uno solo**, lo script è **RIFIUTATO**, il motivo
finisce nel referto, e **la coda prosegue** con gli altri.

E prima ancora dei due cancelli, il runner rifiuta:
- un **pin** che non sia uno SHA da 40 esadecimali;
- un percorso fuori da `backtest_pipeline/righe/` o che non finisca in `.ps1`.

> ### 🧪 COLLAUDABILE, E VA COLLAUDATO SULLA MACCHINA DOVE VIVRÀ
> `runner_abtg.ps1 -CollaudoCancelli` fa girare G1 e G2 su **11 casi finti** —
> buoni e cattivi — e dice per ognuno cosa avrebbe deciso. Non serve rete, non
> serve MT5, non tocca niente.
> **Va lanciato sul VPS PRIMA di installare l'attività pianificata.**
> Se dice anche un solo `KO`, non si installa.

## 🕐 Quando gira
Una volta al giorno, **03:30 ora VPS** (mercati fermi, nessun EA che opera).
Si toglie in qualunque momento con `schtasks /Delete /TN ABTG_Runner /F`.

---

## 📜 COSA SI STA FIRMANDO, IN UNA RIGA

> **Il VPS può eseguire da solo, di notte, script di SOLA LETTURA presi dalla
> coda del branch `lavoro`, e pubblicarne i referti sul repo.**
> Niente che apra, chiuda, modifichi o tocchi una posizione, un EA o un
> parametro. Niente che riguardi il conto reale.

**Il perimetro si allarga solo con una firma nuova. Mai di corsa, mai "tanto
è demo".**

---

## ✍️ FIRMA

- [ ] **Claudio**, data: ________
- [x] `-CollaudoCancelli` lanciato sul VPS: **11 su 11 giusti** — **07/09/2026, ore 22:46** ✅

_Senza tutte e due le caselle, il runner non si installa._

### Esito del collaudo, per esteso (07/09/2026 22:46, VPS)
```
[OK ] BUONO: legge e stampa                    -> G1 e G2 passati
[OK ] CATTIVO: manca il marcatore              -> G1: manca 'RUNNER_SOLA_LETTURA'
[OK ] CATTIVO: tocca il REALE                  -> G2: 'BCM_Reale'
[OK ] CATTIVO: nomina il conto reale           -> G2: '10105439'
[OK ] CATTIVO: scrive un file                  -> G2: 'Set-Content'
[OK ] CATTIVO: cancella                        -> G2: 'Remove-Item'
[OK ] CATTIVO: esegue testo                    -> G2: 'Invoke-Expression'
[OK ] CATTIVO: avvia un processo               -> G2: 'terminal64.exe'
[OK ] CATTIVO: -EseguiDavvero                  -> G2: 'EseguiDavvero'
[OK ] BUONO: il divieto e' in un COMMENTO      -> G1 e G2 passati
[OK ] CATTIVO: sorgente vuoto                  -> G0: sorgente vuoto
COLLAUDO: 11 giusti, 0 sbagliati su 11
```

---

## 🔎 UNA CONSEGUENZA DI PROGETTO, SCOPERTA COL COLLAUDO

Il divieto `Set-Content` / `Out-File` / `Copy-Item` **rifiuta quasi tutte le
righe di casa esistenti**, perché quasi tutte scrivono il proprio referto su
file. Non e' un difetto del cancello: e' il progetto giusto, e la soluzione
non e' allargare il perimetro.

👉 **Nella coda gli script STAMPANO, non scrivono.** Il runner cattura lo
standard output di ognuno, lo salva come log e **lo pubblica lui** sul repo.
Quindi per la coda servono **varianti snelle** delle righe esistenti — che
stampano e basta. È lavoro onesto, non un allentamento.

**Nessuna riga entra in coda finché non ha una variante che stampa.**
