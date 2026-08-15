# ✅ PRIMA DI MANDARE UNA RIGA DI LANCIO — quattro controlli, sempre

_Scritto il 15/08/2026 dopo che Claudio ha detto "stai facendo troppi
errori". Aveva ragione: sette righe di lancio sbagliate in una sera, e il
filo comune era sempre lo stesso — **avevo mandato la riga senza aprire lo
script a cui puntava**._

**Questa non e' una promessa: e' una lista da eseguire.** Nessuna riga esce
prima di averla passata tutta.

---

## 1. 📖 APRO LO SCRIPT. Ogni volta, anche se l'ho scritto io un'ora fa.

Non "mi ricordo cosa fa". **Lo leggo.** Sei errori su sette di quella sera
sarebbero morti qui.

## 2. 🔍 Cerco i DIFETTI GEMELLI

Se ho appena corretto un difetto in uno script, **lo cerco in tutti gli altri
prima di mandare qualunque riga**. Il 15/08 la trappola dei "60 secondi di
silenzio = ha finito" e' stata corretta in `prepara_broker_esterno.ps1` la
mattina e ha colpito `scarica_storico.ps1` la sera, uccidendo quattro corse.

Grep secchi da fare:
```
fermoDa -ge        (euristiche del silenzio)
Desktop            (la raccolta, punto 2 della regola delle righe di lancio)
```

## 3. 🎯 Il file dei parametri e' quello GIUSTO?

Una riga puo' essere sintatticamente perfetta e puntare alla cosa sbagliata.
Il 15/08 la riga R58 puntava a `prove\ABTG_PTE.txt`, che e' una **griglia da
16 celle**, mentre serviva **la cella viva congelata**. Sarebbero state ore di
tick reali per produrre una tabella da cui scegliere — cioe' l'ottimizzazione
che i nostri Spearman vietano.

**Domanda secca: questa riga CERCA o VERIFICA?** E il file che le passo fa la
stessa cosa?

## 4. 🔒 Il SHA contiene davvero la correzione che sto annunciando?

Il 15/08 ho mandato una riga dicendo "questa ha la guardia mercato-chiuso",
pinnata a un commit **precedente** a quella guardia.

```
git log --oneline -1 -- <il file che sto pinnando>
```
Se il commit del file e' piu' vecchio del SHA che scrivo, **il SHA e' buono**.
Se e' piu' nuovo, sto mentendo. Nel dubbio: **HEAD**.

---

## ⚙️ E due regole di traffico, sempre valide

**UNA MACCHINA, UN LAVORO.** Il PC di backtest ha **un solo MT5**. Prima di
mandare una riga che apre MT5, dichiaro cosa deve essere finito prima. Il
15/08 ho scritto "sono due macchine diverse e non si pestano i piedi": falso,
ed e' il tipo di frase che fa ammazzare una corsa da tre ore.

**Se lo script puo' spegnere qualcosa, lo dico nella riga stessa**, non in
fondo al messaggio.

---

> **Il criterio con cui giudicare questa lista**: se la prossima riga di
> lancio e' sbagliata, il problema non e' che manca un controllo — e' che non
> l'ho eseguita.
