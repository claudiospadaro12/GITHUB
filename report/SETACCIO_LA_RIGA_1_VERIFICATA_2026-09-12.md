# 🔬 LA RIGA N.1 DEL SETACCIO, VERIFICATA DA ME — **regge, ma è CONDIZIONATA**

**Il candidato**: `770101` DAX Apertura (**conto REALE**), `InpTP1_ClosePct`
**50 → 0** — cioè **spegnere la chiusura parziale**.
**Fonte**: `risultati_prove/aperture_r46/ABTG_DAX_Apertura_EU_D30EUR_OOS_r46a.csv`

---

## ✅ 1. IL NUMERO RIPORTATO È ESATTO — ricontato da me

Coppia che differisce **per quella sola manopola**, con `InpTrailMode=1`
(= la configurazione viva):

| | parziale **50%** | parziale **SPENTO** |
|---|---:|---:|
| Profit | 18.029,58 | 🟢 **23.607,28** (+31%) |
| Profit Factor | 1,39709 | 🟢 **1,49140** |
| Drawdown | 7,2328% | 🟢 **6,2719%** |
| Trades | 270 | **193** |

🎯 **E il dubbio che R120 aveva lasciato aperto si chiude**: il *"−27% di
campione"* **non era una perdita di operazioni**. Le 270 sono **uscite**
(193 posizioni × 1,40 per via del parziale); senza parziale sono **193 uscite
= 193 posizioni**. 👉 **193 = 193: non si perde un'operazione.**

---

# 🔴 2. MA NELLO STESSO FILE CI SONO **ALTRE TRE COPPIE**, E NON SONO D'ACCORDO

Il setaccio ne aveva riportata **una**. Cercandole tutte:

| coppia | 50% → spento | esito |
|---|---|---|
| r.2/3 *(config VIVA)* | PF 1,397 → **1,491** · DD 7,23 → **6,27** | 🟢 **meglio** |
| r.4/5 | Profit **+1.951 → −1.834** · PF 1,028 → **0,974** | 🔴 **peggio** |
| r.6/8 | PF 1,026 → **0,875** · DD 8,74 → **22,50%** | 🔴 **disastro** |
| r.7/9 | idem | 🔴 **disastro** |

> ## 🔴 **La stessa identica modifica va da +31% di profitto a un drawdown del 22,50%, a seconda di COME È CONFIGURATA L'USCITA.**
> **Non è una manopola buona: è una manopola CONDIZIONATA.**

## ⚖️ 3. IL VERDETTO ONESTO, e non è una firma

🟢 **Nella configurazione viva il numero è buono e ricontato.**
🔴 **Ma il file stesso dimostra che quel segno non è stabile.** La regola di
casa chiede i **vicini**: qui i vicini **sull'asse del parziale** non esistono
(0 e 50, il 25 e il 75 **mai misurati**), e i vicini **sull'altro asse**
**si ribaltano**.

### 👉 Quindi: **NON è da firmare. È da MISURARE.**
Serve un round suo: `InpTP1_ClosePct` su **0 · 25 · 50 · 75** × la
configurazione d'uscita viva, **in IS e in OOS**. Piccolo, e risponde davvero.

🔴 **E c'è un motivo in più per non avere fretta: questa sedia è sul conto
REALE.** La differenza fra *"in una configurazione va meglio"* e *"va meglio"*
lì si paga in euro.

---

## 🏅 4. IL METODO DEL SETACCIO, INVECE, HA RETTO — e va detto

Il confronto è fatto **dentro un solo CSV**, quindi finestra, modello, deposito
e build sono **identici per costruzione**. 👉 È esattamente la protezione che
ieri ci è mancata, quando due round che misuravano **due sedie diverse** ci
sono costati mezza giornata.

🧪 **E si è fermato da solo su una trappola**: aveva trovato una conferma
perfetta per questa stessa riga in un altro file — e l'ha **rifiutata**,
perché su 71 manopole **sei** erano diverse (`InpAllowShort`, `InpUseGapFill`,
le due EMA, `InpFilterTF`, `InpConfirmMode`). **Misurava un'altra sedia.**

✅ **Controprova**: girato alla cieca, ha **ritrovato quattro celle già
giudicate** da referti umani (R15, R44, TRAILING_SOGLIA, R120) arrivando agli
**stessi verdetti**.

---

## 🕳️ 5. I TRE BUCHI CHE PESANO PIÙ DELLA CLASSIFICA

1. 🔴 **`770250` Nasdaq: la cella viva NON è MAI stata misurata.** Dista **8
   manopole su 70** da ogni corsa d'archivio. 👉 Il round di gestione del 09/09
   **misurava un'altra configurazione.**
2. 🔴 **`770402` MaxMin Oro**: distanza 4. **Mai misurata.**
   🔴 **`771203` PostNews USDJPY**: **zero** corse di quell'EA su quel simbolo.
3. 🟡 **`770411`**: dista **una sola** manopola, ed è `InpMaxSpread` **500 in
   campo contro 0** in tutte le 34 corse = **filtro spento**.
   👉 **Tutti i numeri d'archivio di quella sedia sono un LIMITE SUPERIORE.**

## ⚪ E DOVE LA RISPOSTA È "VA BENE COSÌ"
Sull'**ingresso** della `770101`, in OOS, `InpRangeMinutes=35` è **il massimo
di 12 valori** e `InpBufferPoints=500` **il massimo di 15**. 👉 Le "migliorie"
che il setaccio aveva sputato venivano **tutte dal solo IS**. **La cella viva
è quella giusta.**

> ## 🔥 Su 320 celle candidate, **75 con campione sufficiente, 10 che valgono qualcosa, 3 già respinte** — e la n.1 non è una firma: è un round da fare. **Il valore del setaccio non è avere trovato una cella d'oro: è avere spazzato via 310 illusioni in una notte.**
