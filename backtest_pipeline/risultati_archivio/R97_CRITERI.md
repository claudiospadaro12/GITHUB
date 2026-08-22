# ⚖️ R97 — L'ORB A STOP LARGO, SUL NASDAQ — ✅ FIRMATO DA CLAUDIO IL 21/08/2026

_Scritto il 21/08/2026, a numeri di R97 **mai visti** (nessuna passata girata).
Nasce dalla strada **(b)** firmata da Claudio lo stesso giorno su
`ABTG_Nasdaq_Apertura_US` (`FIRMA_2026-08-21_DUE_SEDIE.md`) e dall'approvazione
esplicita, in chat: *"VA BENE, PROCEDI, ANALIZZIAMO"*, sulla proposta di
misurare l'idea "stop largo + TP a piu' R con parziali" **sul nostro ORB**,
non su un EA nuovo._

---

## 0. 🚫 REGOLA ZERO — cosa questo round NON e'

- **NON riaccende `ABTG_Nasdaq_Apertura_US`** (magic 770201). Quella sedia
  resta spenta: aveva un motore proprio (breakout/retest), gia' misurato e
  scartato (tick reali 31/07 PF 0,82 · DD 17%; walk-forward 05/08: 19/20
  celle OOS negative). Riprovare lo stesso motore con altri numeri sarebbe
  il difetto gia' pagato — *"filtro/motore appiccicato, 0 successi su 5"*.
- **Misura un motore DIVERSO e gia' vindicato altrove**: `ABTG_ORB_Ottimizzato`
  (magic 770611 live sul Dow), sullo **stop all'estremo opposto del range**
  (`InpSLMode=0` OPPRANGE), la famiglia che **R88 ha gia' trovato migliore
  sul Dow** per drawdown e PF OOS — semplicemente mai provata su NASUSD.
- **NON e' una promozione al primo giro**: lo scan e' OHLC quando possibile,
  a tick reali per il verdetto (regola di casa, R57). Il round puo' al
  massimo produrre una **proposta motivata** per un round di deploy separato.
- **I file di Diego e di Artemis restano fonte d'ispirazione dichiarata, mai
  codice**: nessun numero di quei due file entra nei cancelli qui sotto senza
  essere prima **misurato da noi**.

---

## 1. 🎯 LA DOMANDA — una sola

> ### **"Lo stop all'estremo opposto del range (con buffer), che su U30USD dimezza il drawdown mantenendo un PF OOS piu' alto (R88), fa la stessa cosa su NASUSD?"**

Non e' *"il Nasdaq in apertura ha un edge"* in generale — quella domanda l'ha
gia' posta e chiusa (negativamente) `ABTG_Nasdaq_Apertura_US`. Qui la domanda
e' piu' stretta e piu' onesta: **un meccanismo che sappiamo funzionare meglio
in un posto, funziona anche altrove?**

**Falsificazione**: se su NASUSD la famiglia OPPRANGE non batte la geometria
di riferimento (HALFRANGE, quella live sul Dow) ne' sul DD ne' sul PF OOS, la
tesi **non si generalizza al Nasdaq** e il capitolo si chiude qui, senza
seconda caccia (non e' un motore morto: e' un motore che non trasferisce).

---

## 2. 🪟 LA FINESTRA — identica a R88, per lo stesso motivo

| voce | valore | fonte |
|---|---|---|
| simbolo / TF | **NASUSD · M5** | stesso TF di esecuzione dell'ORB |
| storico | **`@DAQUANDO 2024.09.26`** | `REFERTO_SONDA_STORICO_17-08.md`: NASUSD **misurato COMPLETO** dalla stessa data di U30USD |
| fine | `2026.06.30` | come R88 |
| split | **40/60** | `walkforward_generico.ps1` default |
| IS | 2024.09.26 → 2025.06.09 | identico a R88, stesso calcolo |
| OOS | 2025.06.10 → 2026.06.30 | identico a R88 |
| deposito | **100.000** | per confrontare col riferimento R88 alla pari |

### 2.1 🐤 IL CANARINO — sospetto MERITO, dichiarato PRIMA come in R88

La sonda del 17/08 misura che `ABTG_Nasdaq_Apertura_US` su NASUSD ha bisogno
di **~3,2 anni** per 150+150 operazioni, contro gli **1,8 disponibili**. Non
e' garantito che l'ORB abbia la stessa frequenza di quell'EA (motori diversi),
ma **il vincolo di finestra e' lo stesso di R88** (muro dei tick al
2024.09.26): se `-SoloControllo` mostra un n IS sotto ~100, **il giudizio di
MERITO e' sospeso** esattamente come in R88 (Emendamento, regola A) — il
round si legge per **RISCHIO** e come **diagnosi di trasferibilita'**, non
come promozione. Va scritto a referto **prima** di guardare un solo numero,
non dopo.

### 2.2 Il regime contenuto
Stesso regime di R88: Dow/Nasdaq 2024-2026, fase **prevalentemente
rialzista**. R97 misura *trasferibilita' del meccanismo dentro un regime*,
non robustezza di regime — quella e' un altro round (Emendamento, regola C).

---

## 3. 📐 LA CONVERSIONE DEI PUNTI — PASSO 0 OBBLIGATORIO, non assunta

R88 ha dovuto **correggere una premessa sbagliata** (1 punto indice = 10 point
MT5, era in realta' 100) leggendola da `REFERTO_ROUND55_SLIPPAGE.md`. **Per
NASUSD questo numero non e' agli atti da nessuna parte.**

> ### 🛑 GATE: prima di lanciare una sola passata, si misura quanti PUNTI MT5 valgono 1 punto indice su NASUSD a BCM.
> Si legge da `SYMBOL_POINT` e `SYMBOL_DIGITS` del simbolo (due righe di
> script, non serve il tester), o da un trade reale gia' in log (il "ORB OTT"
> non gira su NASUSD, ma qualunque EA con SL/TP su NASUSD in `CENSIMENTO_ORDINI.md`
> basta). **Senza questo numero, l'asse `InpSLBufferPts` di R97 e' cieco**: si
> rischia di ripetere l'errore di fattore 10 gia' pagato una volta.

---

## 4. 🔬 LE CELLE — poche, mirate, nessuna griglia larga

A differenza di R88 (tre assi, 136 passate, esplorazione ampia), qui la
domanda e' gia' ristretta: **si confronta la famiglia vincitrice di R88
contro il riferimento live**, non si riparte da zero.

| cella | `InpSLMode` | `InpSLBufferPts` | `InpTPMode`/`InpTP_R` | perche' |
|---|---|---|---|---|
| **R97-rif** (riferimento) | 3 HALFRANGE | 0 | range × 1,5 | e' la geometria della sedia LIVE sul Dow: stesso motore, per isolare "cambia mercato" da "cambia geometria" |
| **R97a** | 0 OPPRANGE | 0 | R × 2,0 | la cella base della famiglia vincitrice di R88 |
| **R97b** 🥇 | 0 OPPRANGE | 500 pt MT5 **misurati** (§3), non assunti | R × 1,5 | la cella che in R88 ha dato il **miglior compromesso DD/PF** (3,84% DD, PF 1,84 OOS) |
| **R97c** | 0 OPPRANGE | 500 pt MT5 misurati | R × 2,0 | seconda migliore di R88, per conferma |

**4 celle, non 48**: R88 ha gia' fatto l'esplorazione dell'asse; qui si
verifica se il punto gia' trovato **trasferisce**, non si riesplora da capo.
Se serve un'esplorazione piu' larga su NASUSD, e' un round successivo che
parte da QUESTI numeri, non uno scan alla cieca.

### 4.1 🟣 LA CELLA ISPIRATA DA ARTEMIS/DIEGO — quinta, opzionale, dichiarata come tale

> **[DICHIARATO, NON ANCORA DECISO]**: sia Diego che Artemis puntano a un
> TP **vicino 1:1** invece che 1,5-2R. Se Claudio la vuole dentro, si aggiunge:

| cella | `InpSLMode` | `InpSLBufferPts` | `InpTPMode`/`InpTP_R` | perche' |
|---|---|---|---|---|
| **R97d** (opzionale) | 0 OPPRANGE | 500 pt misurati | R × 1,0 | l'idea esterna, misurata col NOSTRO motore invece che fidandosi del loro |

Se questa cella entra, **il cancello S3 (§5) si applica anche a lei** — non
ha un trattamento di favore per venire da fuori.

---

## 5. 🚪 I CANCELLI — presi da R88, SENZA modifiche (stessa famiglia di motore, stesso mercato-tipo)

Riuso deliberato dei 4 cancelli di R88, per confrontabilita' diretta:

| # | cancello | soglia |
|---|---|---|
| **S1** | DD OOS | **<= 7,00%** |
| **S2** | PF OOS | **>= 1,40** |
| **S3** | IS | profit > 0 **e** PF IS >= 1,10 |
| **S4** | campione | n OOS >= 95 · n IS >= 57 — **soggetto al canarino §2.1**: se il canarino scatta, S4 non boccia da solo, sospende il MERITO |

### 🔴 Bocciatura secca (identica a R88)
- **DD OOS > 2× il riferimento HALFRANGE misurato in R97-rif** (invece che un
  numero assoluto pre-R97: si scopre dopo `R97-rif`, PRIMA di leggere a/b/c/d)
- **profitto netto <= 0 in OOS**

⚠️ **Applicazione dichiarata dell'Emendamento (regola B), stavolta FIN
DALL'INIZIO** (la tensione che R88 ha lasciato aperta si chiude qui, per il
round dopo, come promesso): se il canarino di finestra scatta, **il RISCHIO
(DD, in entrambe le finestre) e' il criterio che decide**, il PF IS diventa
lettura di contesto — esattamente come R88 ha proposto retroattivamente ma
non applicato a se stesso.

---

## 6. 📋 COSA PUO' USCIRE, E COSA NO

- **Puo' uscire**: una proposta motivata di aprire un round di **deploy**
  (nuova sedia NASUSD, magic nuovo, mai 770201) con la geometria che vince.
- **NON puo' uscire**: nessuna sedia accesa direttamente da questo round.
  Fra la proposta e il deploy c'e' sempre un passaggio a tick reali con
  criteri propri (regola R57).
- **NON puo' uscire**: nessun giudizio sul motore breakout/retest di
  `ABTG_Nasdaq_Apertura_US` — quello resta scartato per conto suo, con le sue
  misure, indipendentemente da come va R97.

---

## ✍️ FIRMA DI CLAUDIO — 21/08/2026

> ## ✅ FIRMATO IN CHAT: **"FIRMIAMO R97, POI ANALIZZIAMO QUESTI EA BENE"** — 21/08/2026.
> Firma raccolta **a numeri di R97 mai visti** (nessuna passata girata).
> Regola confermata: *i criteri si cambiano prima dei numeri, non dopo* — se
> un numero uscito suggerisse un criterio migliore, quel criterio vale **dal
> round dopo**.

Coperto dalla firma, punto per punto:

- **(a) Le 4 celle del §4** — `R97-rif` (HALFRANGE, riferimento live),
  `R97a`/`R97b`/`R97c` (famiglia OPPRANGE, trasferita identica da R88).
  **`R97d`** (la cella ispirata da Diego/Artemis, TP 1:1) **resta ESCLUSA per
  ora**: era segnata `[DICHIARATO, NON ANCORA DECISO]` e la firma di oggi non
  la nomina — entra solo con un'approvazione a parte, quando "analizziamo
  questi EA bene" avra' chiarito se l'idea del TP 1:1 merita davvero una
  quinta cella o va rivista alla luce di quell'analisi.
- **(b) I cancelli §5**, riusati identici da R88 (S1-S4 + bocciatura secca).
- **(c) Il gate del PASSO 0** (§3): la conversione punti-MT5/punto-indice su
  NASUSD si misura **prima** di lanciare una sola passata. Nessuna passata
  parte senza quel numero agli atti.
- **(d) L'Emendamento regola B fin dall'inizio** (§5, ultimo blocco): se il
  canarino di finestra scatta (probabile, vedi §2.1), il RISCHIO decide, il
  PF IS resta lettura di contesto — applicato da subito, non dopo aver visto
  i numeri come in R88.

**Prossimo passo, per ordine esplicito di Claudio**: PRIMA il PASSO 0 (gate
§3) quando si vorra' lanciare R97, ma **SUBITO ORA** l'analisi approfondita
dei tre file esterni (Diego, Artemis, Master Nasdaq FTMO) — vedi i tre
referti dedicati. Quell'analisi puo' ancora cambiare `R97d` o aggiungere
un R97-bis: **cambia il round successivo, non questo**, per la stessa regola
della firma.
