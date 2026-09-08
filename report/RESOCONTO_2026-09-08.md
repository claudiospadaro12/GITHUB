# 📋 RESOCONTO DEL 08/09/2026

> # ⏳ **23 GIORNI AL 1° OTTOBRE**
> Claudio stamattina: _"dai primi d'ottobre vorrei iniziare la challenge"_ +
> carta bianca. Da oggi ogni lavoro vale in proporzione a quanto avvicina una
> **sedia schierabile** a quella data.

**30 commit.** Sette agenti, tutti consegnati. Claudio ha guidato: **zero
stringhe lanciate da lui**, e il lavoro non si è fermato.

---

## 🔴 LE QUATTRO COSE CHE CI AVREBBERO FATTO MALE, TROVATE OGGI

### 1. 🐞 Il volume poteva essere il DOPPIO del dichiarato — **15 sorgenti**
`lotPend` era calcolato **prima** che il pavimento del lotto minimo alzasse
`lotMkt`: volume totale `totLot + volMin`. **Già pagato in campo**: DIARIO del
20/08, **1,42% su un contratto da 1,0%**. Corretto in tutti e 15 (13 + 2
`standalone/`), versioni 1.00 → 1.01.
🟢 **Nessuno dei 15 girava sul conto reale.** 🔴 **Non ha effetto finché le 7
sedie vive non vengono ricompilate e ricaricate: è una firma di Claudio.**

### 2. 👁️ Il canarino del Guardian era **CIECO da due giorni**
Dal **06/09 14:22** (v1.12, che rinominò 5 GV con `_V2`) lo strumento che
verifica la nostra unica protezione cercava i **nomi vecchi**. Vedeva solo
`FAILED`.
🧨 La peggiore: **`BLOCKDAY`**, il blocco duro — avrebbe stampato *"0 = spenta"*
**anche a bandiera alzata**. E poiché le GV vecchie **persistono**, poteva
stampare **numeri vecchi come attuali**.
✅ Ora i sei nomi si costruiscono in **un punto solo** (erano 7 copie a mano:
ecco perché il rename ne lasciò indietro sei), e c'è una **spia nuova** che
grida se trova popolati i nomi vecchi.

### 3. 🩸 Il nostro Guardian misura una giornata **diversa da quella di FTMO**
Noi partiamo dall'**equità**, FTMO dal **saldo** alle 00:00. Con −0,8%
flottante al reset su 100k: pavimento FTMO **95.000**, nostro **94.200**.
⚠️ **Ma non è una svista**: è il fix del 06/09 per il **credito non
prelevabile** del conto reale. Quindi non si torna al bilancio — Guardian
**v1.14** con modo dichiarato (`InpDailyBaseline`), **opt-in e no-op di
default**. Reale = equità · FTMO = saldo · FundingPips = max.

### 4. 🔪 Lo script dello storico spegneva **TUTTI** i terminali
Due punti, non uno (righe 222 e 413). Sul VPS avrebbe chiuso **il terminale del
conto reale con posizioni aperte**. Ora **chiusura chirurgica**, con la lista
di chi resta vivo (PID + percorso) stampata **prima e dopo**.

---

## ✅ COSA È AVANZATO VERSO IL 1° OTTOBRE

| | |
|---|---|
| **Passo 6** del quarto MT5 | ✅ **CHIUSO** — il driver impara `-TerminaleBacktest`, muore in 5 casi, **dichiara sempre** quale ha scelto |
| **EA nuovo** `ABTG_ImpulsoApertura` | ✅ scritto, magic **769800** (verificato libero) — è quello che tira fuori **DAX SHORT e NASDAQ LONG nativamente** |
| **Piano datato** | ✅ `PIANO_CHALLENGE_OTTOBRE.md`, costruito **all'indietro** dal 1° ottobre |
| **Regolamenti prop** | ✅ verificati: **FTMO non ha limite di tempo** → slittare costa zero. Escluse Alpha Capital (EA vietati) e The5ers High Stakes |
| **Coda del runner** | da 4 a **7 righe**, tutte a cancelli G1+G2 passati con controprova |

## 🎯 IL NUMERO CHE DECIDE TUTTO
**8 candidate alla squadra, ne passa i quattro requisiti UNA.** Il collo di
bottiglia **non è il rendimento**: è che **sei su otto rischiano fino al doppio
di quello che dichiarano**. Col 2×, cinque gambe fanno **6,50%** e **sfondano
il muro giornaliero del −5% coi soli stop**.
👉 **5 sedie se il rischio è verificato, 2 altrimenti. Oggi siamo a 2.**

---

## ⏸️ COSA ASPETTA CLAUDIO (in ordine)
1. 🟡 **La riga dello storico** (verificata, approvata, appuntata a `ec4f6c4`) →
   sblocca l'**ancora R119** → poi **i round girano ogni notte sul VPS da soli**.
2. 🟡 **F7 + ricarico** delle 7 sedie col fix del lotto → porta R4 da 2 a 5.
3. 🟡 **PostNews EURUSD**: `InpRiskPercent` 3.0 → **1.30** (EURJPY già fatto).
4. 🟢 **Firma** sul modo baseline del Guardian, quando si sceglie la prop.

## 🌙 STANOTTE, 03:30, da solo
`CODA_01-04` (la foto) · **`CODA_05`** (i `.chr` sono freschi o vecchi? +
calendario news) · **`CODA_06`** (quale albero di sorgenti è compilato) ·
**`CODA_07`** (il **Desktop del VPS**, portato a me senza che Claudio mandi
niente).
