# 📏 CLASSE 591 RIMISURATA — **il difetto era vero, ma la correzione va nel verso OPPOSTO**

**22/09/2026 sera** · nasce da un rilievo del cancello sui file prova `backtest_pipeline/prove/R210a_bias_h4_DAXSUPERTREND_D30EUR.txt`

## 🔴 IL DIFETTO, ed era mio
Per scegliere il TF di `DAX_M3_Supertrend` avevo misurato la **distanza mediana
prezzo -> linea Supertrend su TUTTE le barre**, e da li' il rapporto con lo spread
(**51,9x** su H1). 🔴 **Ma l'EA entra SOLO sulle barre di FLIP**, e lo stop lo mette **li'**:
misurare su tutte le barre significa misurare una popolazione che l'EA non incontra mai.

## 🧪 LA RIMISURA — e la mia intuizione era sbagliata
Avevo scritto che il numero era *«quasi certamente una SOVRASTIMA»*, ragionando che su una
barra di flip il prezzo ha appena attraversato la linea e quindi le sta vicino.
🔴 **Falso, e il motivo e' geometrico**: su un flip la linea **salta dall'altra parte** —
passa dalla banda alta alla bassa (o viceversa) — quindi la distanza diventa **circa la
LARGHEZZA PIENA della banda**, non il residuo piccolo.

| TF | TUTTE le barre | **SOLO barre di FLIP** | n flip | frontiera 40x |
|---|---|---|---:|---|
| **M30** | 62,40 pt = 35,3x 🔴 | **102,69 pt = 58,1x** | 952 | 🟢 **PASSA** |
| **H1** | 91,78 pt = 51,9x | **151,81 pt = 85,9x** | 488 | 🟢 passa |
| H4 | 160,57 pt = 90,8x | **244,10 pt = 138,1x** | 183 | 🟢 passa |

> ### 🟢 **Correggendo il difetto il caso si RAFFORZA: H1 passa da 51,9x a 85,9x.**
> 🔴 **E cambia una mia esclusione: M30, che avevo escluso PER COSTO a 35,3x, in realta'
> sta a 58,1x e NON e' escluso.** Avevo chiuso una porta con un numero sbagliato.

## 📌 Cosa si porta a casa
1. Il rilievo del cancello era **giusto**: misuravo la popolazione sbagliata.
2. 🔴 **Ma la direzione dell'errore l'avevo indovinata al contrario**, e l'avevo scritta nel
   messaggio di commit come se fosse ovvia. **Non si dichiara il verso di un errore senza
   misurarlo**: e' un'ipotesi travestita da conseguenza.
3. 🟢 Il verso buono non salva il metodo: il numero **51,9x** resta **sbagliato**, e va
   sostituito ovunque compaia — anche se quello giusto e' piu' comodo.

🔵 Niente toccato in campo.
