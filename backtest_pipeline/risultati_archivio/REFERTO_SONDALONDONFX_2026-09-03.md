# 🏹 SONDA LONDONFX — PASSO 0, verdetto della corsa del 03/09/2026

Corsa: 03/09 08:56 (pin `dba950a`, driver v3), EURUSD lead, 2 TF x 6 celle
(2 UsaRsi x 3 OraInizio), Modello 2, finestra 2024.09.26->2026.06.30.
Collaudi: PROBLEMI 0, autotest 0/16 su 2/2, determinismo su 3 coppie,
cablaggio e sottoinsieme OK, PipEco/PipPti giusti. Corsa PULITA.

## ⚡ IL VERDETTO IN QUATTRO RIGHE
**PRIMO CANDIDATO DELLA MISSIONE FREQUENZA A PASSARE IL PASSO 0.** Su
EURUSD M15 col filtro RSI il motore fa **2,0-2,3 segnali/giorno PER LATO**
con MFE mediana **10-13,4 pip** (F2 ben sopra 6) e RR indicativo 0,90-1,14
(H8 passa ovunque). E il filtro RSI qui **FILTRA DAVVERO: taglia il 73-77%**
degli segnali nudi — l'esatto opposto del V8 (9-13%).

## I numeri chiave (per riga, mai aggregati)
- **La riga regina: EUR_M15, RSI acceso, ora 8 (= sessione di Londra esatta):
  LONG 2,26 sig/gg, MFE 13,4 / MAE 11,8 pip, RR 1,136, WR necessario 50,3%.**
- M15 con RSI: 12/12 righe VIVE su tutte e tre le ore (4/6/8).
- M5: ora 8 VIVO, ora 6 misto, ora 4 SOSPESO (F2 in fascia 3-6 pip,
  spread non misurato). Il gradiente F6 dice: il motore respira meglio
  sull'orizzonte piu' lungo.
- Ablazione F1-bis: M15 nudo 3.860/3.857 -> con RSI 1.028/979 (-73%);
  M5 11.904/11.797 -> 2.783/2.645 (-77%). **Il filtro E' il lavoro.**
- F4 (taglia flotta): M15 con RSI ~2,2/gg = gestibile; M5 senza RSI
  (26/gg, 44,85% rischio aperto) inutilizzabile a taglia piena — gia'
  scritto nei numeri, nessuna sorpresa dopo.

## Le tre onesta' dichiarate (dal referto, non da me)
1. MFE ~ MAE quasi ovunque: la GEOMETRIA da sola non regala nulla — l'RR
   e' indicazione con limiti superiori su entrambi i lati. Il passo 0
   conta OCCASIONI: il merito lo decide SOLO il tick (R57).
2. F5: il nostro short RSI e' piu' permissivo dell'autore (20 vs 10) —
   lo short passa F1 anche per questo, da ricordare alla lettura.
3. La fascia SOSPESA di M5 dipende dallo SPREAD MAI MISURATO — il Code
   Base 74148 (SPREAD_FLOTTA) e' citato per l'ennesima volta: misurarlo
   scioglie i SOSPESO in un verso o nell'altro.

## 🛤️ I prossimi passi (proposta, decide Claudio)
1. **Corsa gemella GBPUSD** (aggiuntiva dichiarata nel prova, stesso pin).
2. **SPREAD_FLOTTA finalmente in campo** (pin c5dbd68 v2, gia' pronto):
   scioglie i SOSPESO di TUTTE le sonde e da' il margine vero su F2.
3. **Il round a TICK REALI su EURUSD M15 ora=8** (pavimento tick misurato
   2024.07.05 -> finestra 2024.10->2026.06 fattibile su tick veri):
   criteri da congelare PRIMA, e l'ablazione a 3 motori del prova
   (canale nudo / canale+RSI / allineamento 5 medie) per la domanda
   "il contenitore e' l'edge?".

---

## 🇬🇧 09:16 — LA GEMELLA GBPUSD: ANCORA PIU' FORTE. **24/24 RIGHE VIVE**

Corsa GBPUSD (pin `4671be3`, driver v4 con -Simbolo, override dichiarato nel
referto riga per riga). PROBLEMI 0, collaudi tutti verdi (PipEco 0,00010
confermato anche sul Cable), determinismo/cablaggio/sottoinsieme OK.

- **TUTTE le 24 righe passano i tre cancelli** (2 TF x 3 ore x 2 lati x RSI
  on/off) — su EURUSD le vive erano 19/24 (M5 ora 4-6 sospese).
- Il Cable e' piu' largo dell'euro e si sente: **M15 con RSI: 2,2-2,4
  segnali/giorno per lato, MFE mediana 12,6-16,3 pip** (vs 10-13,4 EURUSD);
  M5 con RSI ~6,2-6,7/gg, MFE 6,6-9,3.
- Ablazione: il filtro RSI taglia il **76%** (12.184 -> 2.877 su M5) —
  identico comportamento del lead: il filtro lavora su entrambi i simboli.
- Onesta' costante: MAE >= MFE su quasi tutte le righe M15 (RR 0,88-1,00
  lato long): la geometria resta simmetrica, il MERITO resta da misurare
  a tick (R57). ATR mediano sessione 5,34 (M5) / 8,58 (M15) pip.

**VERDETTO DEL PASSO 0 COMPLETO: il candidato LondonFx passa su ENTRAMBE le
gambe (EURUSD 19/24, GBPUSD 24/24) e si presenta al round a tick con due
simboli.** Prossimi passi invariati: SPREAD_FLOTTA (74148) per sciogliere i
sospesi EURUSD e dare il margine F2 vero; criteri del round a tick da
congelare PRIMA; ablazione a 3 motori nel contenitore.
