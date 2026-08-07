# REFERTO — Trailing: TF × soglia (`InpTrailStartR`) — notte 07-08/08/2026

Prima prova girata col **driver generico** (`walkforward_generico.ps1`), griglia 5×5:
`InpTrailTF` M1→M5 × `InpTrailStartR` {0 · 0,25 · 0,50 · 0,75 · 1,00}. Geometria del
candidato validato: RETEST · range 35 · buffer 500 · offset 200 · **SOLO LONG** · 1%.
50 pass a tick reali. CSV in `risultati_prove/ABTG_DAX_Apertura_EU/`.

## 0. Controllo di sanità — passato, con una spiegazione dovuta

La cella M5/soglia 0 doveva riprodurre la FASE M: +1800,19 · PF 1,423 · DD 6,72% · 256 trade.
Ha dato **+1810,72 · PF 1,415 · DD 6,71% · 270 trade**. Non al centesimo — e la causa è stata
**trovata, non ipotizzata**: le finestre della FASE M erano tagliate a mano (OOS dal
**01/07/2025**), il driver generico taglia al 40% dei giorni (OOS dal **10/06/2025**). Tre
settimane di OOS in più → ~14 trade in più, +10,53 €. Configurazione confrontata **parametro
per parametro** con i pin della FASE M: nessuna differenza che agisca (divergono solo i
parametri EMA di un filtro **spento**). ✅ La tabella si legge.

📌 *Nota di metodo per i confronti futuri: i numeri del driver generico e quelli dei referti
delle fasi non coincidono al centesimo per costruzione (finestre diverse). Confrontare
run dello stesso driver, o passare `-FrazioneIS` per allineare le finestre.*

## 1. L'ipotesi di ieri sera è SBAGLIATA — e lo dice la regola scritta prima

Nel file prova, ieri sera, **prima di qualsiasi numero**:

> *«Se questo massimo intermedio NON c'è — se la colonna a 0 è già la migliore — allora
> l'ipotesi di stasera è SBAGLIATA, e lo scrivo qui adesso perché non ci sia modo di
> raccontarla diversamente dopo.»*

È successo esattamente questo.

### OOS — profitto (righe = TF del trailing, colonne = soglia in R)

| | 0,00 | 0,25 | 0,50 | 0,75 | 1,00 |
|---|---:|---:|---:|---:|---:|
| M1 | **+1139,64** | +1083,09 | +477,43 | +270,35 | +173,07 |
| M2 | **+1865,70** | +1689,19 | +770,75 | +632,23 | +528,78 |
| M3 | **+1861,04** | +1593,71 | +975,81 | +690,92 | +523,98 |
| M4 | **+2155,58** | +1576,85 | +715,52 | +579,54 | +262,76 |
| M5 | **+1810,72** | +1635,86 | +1020,05 | +656,35 | +258,67 |

**La colonna a 0 vince in tutte e cinque le righe, e il profitto scende in modo monotono
lungo l'asse della soglia in ogni riga.** Sulla riga M5 (quella accesa): PF da 1,415 a
1,031, DD da 6,71% a 9,93%. La soglia non protegge: **taglia**.

### E in campione dice l'esatto contrario

| IS | 0,00 | 1,00 |
|---|---:|---:|
| M1 | −241,55 | **+938,03** |
| M2 | −594,63 | **+1172,94** |
| M3 | −48,76 | **+1136,48** |
| M4 | +604,29 | **+1094,53** |
| M5 | +380,71 | **+1162,01** |

In campione la soglia 1,0 è la **migliore in tutte e cinque le righe**. Fuori campione è la
**peggiore in tutte e cinque**. Spearman IS→OOS per riga: −0,60 · −0,90 · −0,70 · −0,30 ·
−0,60; globale sulle 25 celle **−0,44**. **È l'ottavo ribaltamento IS→OOS misurato.**
Scegliere sull'IS avrebbe portato a M2/soglia 1,0 (+1172,94 in campione): fuori campione fa
+528,78 contro i +1865,70 della soglia 0 sulla stessa riga — **1337 € lasciati sul tavolo.**

## 2. Come si leggono, allora, le tre uscite miserabili di ieri

Le tre uscite del trailing a +0,043 R in 17 secondi restano **vere**. Ma la griglia dice che
sono il **costo visibile di un meccanismo che nel complesso paga**: il trailing armato subito,
su questa geometria, protegge più di quanto taglia. Le giornate in cui chiude a niente si
vedono; le giornate in cui ha salvato il grosso non si vedono — ma stanno nei 671 € e nei
3,2 punti di drawdown di differenza fra soglia 0 e soglia 0,50 sulla riga M5.

## 3. Criterio 2 — cambiare timeframe? No.

Serviva una cella OOS: +10% su M5/0, DD non peggiore, vicini migliori. L'unica sopra il +10%
è **M4/0: +2155,58 (+19%) ma DD 7,88% contro 6,71%** → bocciata dalla regola (b), scritta
prima. Nessun'altra cella arriva al +10%.

## 4. Decisione — dalle regole pre-dichiarate, non dal gusto

**NON SI TOCCA NIENTE.** La configurazione accesa (M5, trailing armato subito) è la cella
migliore della sua riga fuori campione, e nessuna alternativa passa i criteri. Sul VPS non
serve nemmeno ricompilare: `InpTrailStartR` ha default 0 = il comportamento che ha appena
vinto il confronto. **La leva resta nel codice, misurata: la risposta è zero.**

La voce «soglia del trailing» si chiude qui: aperta dalla pagella del 07/08, misurata la
notte stessa, chiusa dalla condizione di falsificazione scritta prima del test.
