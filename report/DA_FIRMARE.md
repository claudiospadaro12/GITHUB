# ✍️ COSA DEVE DECIDERE E FIRMARE CLAUDIO
_Aggiornato: 08/09/2026, sera. **23 giorni al 1° ottobre.**_

Tre tipi di riga, e sono diversi:
- 🖊️ **FIRMA** — una decisione. La prendi tu, io non posso.
- 🖱️ **MANO** — un lavoro manuale su MT5 che solo tu puoi fare.
- 📏 **MISURA** — un numero che manca. Nessuna decisione, serve solo il dato.

---

# 🔴 URGENTI — bloccano la strada verso il 1° ottobre

## 1. 🖱️ RICOMPILARE E RICARICARE LE 7 SEDIE COL FIX DEL LOTTO
**Cosa**: il bug del lotto è corretto in **15 sorgenti**, ma sui terminali gira
l'`.ex5`, non il sorgente. Finché non ricompili, quelle sedie **rischiano fino
al doppio del dichiarato**.
**Dove**: 6 sul piccolo **50503392** (`C:\Program Files\BCM Markets MT5 Terminal`),
1 sul 100k **50504263** (`... -V3`). 🟢 **Nessuna sul reale.**
**Perché è tuo**: ricompilare **cambia il volume** delle sedie vive. È la taglia,
e la taglia è una tua firma.
**Quanto vale**: porta il requisito R4 da **2 sedie a 5**. Senza, il piano di
ottobre resta a **2 sedie schierabili**.
📄 `report/FIX_LOTTO_PENDENTE_2026-09-08.md`

## 2. 🖱️ POSTNEWS EURUSD: `InpRiskPercent` **3.0 → 1.30**
**Stato**: EURJPY l'hai aperto e visto; **EURUSD (magic 771202) resta a 3.0**.
**Dove**: piccolo **50503392**, grafico **EURUSD M5**. Solo quel numero, nessun preset.
**Perché**: 3.0 significa **1,50% per gamba stoppata** (la size si calcola su
`InpRiskRefSLpips=50` mentre lo stop vero è 25). 1.30 = **0,65%**, la taglia firmata il 18/08.
📄 `report/FIRMA_POSTNEWS_130_2026-09-08.md`

## 3. 🖊️ LA BCE DEL 10/09: si arma o no?
**Il fatto**: nel calendario ci sono **3 righe USD** (residuo NFP) e **ZERO righe
BCE**. Così com'è, giovedì **non spara niente** — ed è il comportamento corretto.
**Due decisioni distinte**:
   a) **si arma?** Scrivere la riga BCE in `abtg_news.csv` è **fuori dal perimetro
      firmato del runner**: o lo fai tu, o si firma un allargamento;
   b) **con quale coppia?** Solo **EURJPY** (preset già collaudato) oppure **anche
      EURUSD** (preset nuovo `ABTG_PostNews_ECB_EURUSD.set`, magic 771202, **mai girato**).
⚠️ Se la risposta è "non si arma", va detto: è una decisione, non una dimenticanza.

---

# 🟠 IMPORTANTI — decidono la forma della challenge

## 4. 🖊️ QUALE PROP, E QUANDO SI PAGA
**Proposta**: **FTMO 2-Step 100k, conto SWING** (540€, promo 439€, rimborsati al 100%).
Muri **statici**, reset già allineato al nostro, e lo Swing chiude da solo i due
meccanismi che **non abbiamo**: filtro news e chiusura weekend.
**Riserva**: FundingPips 2 Step Standard.
🔴 **Prima di pagare, due numeri vanno confermati da te sul sito o dal supporto**:
   1. il muro totale è **statico o trailing**? (tutte le nostre misure assumono statico);
   2. il confine della giornata si calcola su **saldo** o **equity**, e a che ora?
⚠️ Il dossier è `[LETTO-VIA-SEARCH]`: il proxy blocca i siti delle prop, quindi
**nessuna pagina è stata aperta**. Verificabile in 30 secondi da browser.
💰 **Spendere soldi resta tuo, sempre.**
📄 `report/REGOLAMENTI_PROP_2026-09-08.md`

## 5. 🖊️ GUARDIAN: quale baseline giornaliera per quale conto
Il Guardian misura la giornata dall'**equità**; **FTMO dal saldo** alle 00:00.
Su 100k con −0,8% flottante al reset: pavimento FTMO 95.000, **il nostro 94.200**.
È pronto `InpDailyBaseline` (0=equità · 1=saldo · 2=max), **opt-in e spento**.
| conto | modo giusto | perché |
|---|---|---|
| **REALE** | **0 = equità** (come oggi) | il credito broker non prelevabile |
| **prop FTMO** | **1 = saldo** | è FTMO l'arbitro, non noi |
| FundingPips/The5ers | 2 = max | il loro regolamento |
👉 Si firma **quando si sceglie la prop** (punto 4). Non prima.
📄 `report/GUARDIAN_BASELINE_GIORNALIERA_2026-09-08.md`

## 6. 🖊️ IL RIPESCAGGIO: quali dei 7 entrano in coda, e con che priorità
**Il candidato di testa**: `SuperWave DAX H4` (magic **770512**) — PF 1,28,
**DD 3,3% a tick**, n 56. EA già compilato, magic già assegnato, e la **gemella
770511 (Dow H1) è già viva** sul piccolo con PF 1,52 su n 227.
**Domanda secca**: va in **corsia demo** sul piccolo 50503392, o resta fermo?
⚠️ n=56 → **merito sospeso**. Il suo valore è che **costa pochissimo provarlo**.
Soglia di rischio da dichiarare se si accende: **DD forward > 3,3% → revisione immediata**.
📄 `report/RIPESCAGGIO_FREQUENZA_2026-09-08.md`

---

# 🟡 DA DECIDERE CON CALMA — nessuna scadenza stretta

## 7. 🖊️ ALLARGARE IL PERIMETRO DEL RUNNER AI ROUND NOTTURNI
Oggi il runner è **sola lettura**: un round contiene 6 dei 24 divieti e verrebbe
**rifiutato** (verificato). Per farlo girare di notte servirebbe una firma nuova.
**Forma minima che proporrei**, non "apriamo tutto":
   1. una **seconda coda** `CODA_ROUND.txt`, separata;
   2. può eseguire **UN SOLO script** appuntato all'hash, nient'altro mai;
   3. `-TerminaleBacktest` **cablato** su `C:\MT5_Backtest`, non parametrizzabile;
   4. **finestra 00:00-06:30** server, quando le sedie non lavorano;
   5. **canarino sul forward**: se i terminali vivi perdono colpi, la coda si spegne da sola;
   6. il conto reale **fuori da tutto**, come oggi.
💡 Vale **un round a notte senza che tu ci sia**. Te lo scrivo per bene quando dici.

## 8. 🖊️ IL TICKMILL: si staccano i due EA non nostri?
`Gold_Ichimoku_TK_ATR_EA` (magic 250604) e `BREAKOUT_EA_JPY_v3` sono ancora
attaccati su un terminale **fermo dal 20/07**, che occupa **12,08 GB**.

## 9. 🖊️ CAP C2 PER CLUSTER — firmato il 07/09, **implementato ma SPENTO**
La mappa dei cluster è **una scelta tua** e non sta in nessun preset.
Finché non si accende, è **un'intenzione, non una protezione**, e va detto ogni
volta che si cita.

---

# 📏 MISURE CHE MANCANO (nessuna firma, solo il dato)
| # | cosa | perché serve |
|---|---|---|
| 10 | **saldo del piccolo 50503392** | lì molte sedie girano all'**1,0%**, non allo 0,65%: senza il saldo i suoi numeri non si riscalano |
| 11 | **conferma che i 3 agenti del tester** siano sul terminale da backtest | se il tetto sta sul terminale sbagliato **non protegge niente** |
| 12 | **profondità a tick di XAUUSD** | senza, **nessun verdetto di merito sull'oro** è possibile, per nessun candidato |
| 13 | **frequenza di `SuperWave NASUSD H1`** | è il numero che porterebbe la famiglia SuperWave sopra il pavimento di 1,00 |

---

## 🟢 E QUELLO CHE **NON** DEVI DECIDERE
Tutto il resto lo porto avanti io: cacce, round, censimenti, correzioni,
referti, la coda notturna di sola lettura. Se serve una tua firma **te la
chiedo con il numero di conto e la cartella in chiaro**, come oggi.
