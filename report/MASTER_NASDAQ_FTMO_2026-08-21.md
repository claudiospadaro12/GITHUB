# 🔎 `Master Nasdaq FTMO MT5` v4.6 — terzo file sul Nasdaq, e' un ANIMALE diverso

_21/08/2026 notte. Fonte: `.set` (`masternasdaq4_6m5mt5.set`) + screenshot della
pagina prodotto MQL5 Market mandati da Claudio ("*questo e' il preset di un
altro*"). Nessun `.mq5`/`.ex5`: lettura dal `.set` + dalla scheda del venditore._

| | |
|---|---|
| Nome | **Master Nasdaq FTMO MT5**, v4.6 (agg. 07/02/2026) |
| Autore | **Yudi Sri Warsito** ("Esperti", verificato) |
| Prezzo | 60 USD (affitto 30 USD/anno) |
| Recensioni | 5 stelle, **6 recensioni** — campione piu' robusto degli altri due file |
| Pubblicato | 23/01/2024 — prodotto **maturo**, 989 demo scaricate |

---

## 🚨 NON E' UN ORB. E' UN PANIERE DI 10 STRATEGIE INDIPENDENTI IN PARALLELO

Diego e Artemis erano varianti dello stesso meccanismo (range di apertura +
pendenti). **Questo e' tutta un'altra categoria**: il `.set` ha **10 blocchi
`EA_1`...`EA_10`**, ognuno con la propria combinazione di 2 medie mobili
(fast/slow, TF indipendenti fra loro — si vedono valori H1/H4/D1 mischiati:
`16385`..`16392` sono codici TF interi MT5), RSI, divergenza (momentum/AO/CCI/
bears-bulls a seconda del blocco), un pattern a "candle_ID", ATR per SL e TP,
e una **finestra oraria propria in GMT** (quasi tutte 13:00-21:00 o
14:00-19:00/21:00 GMT).

La scheda del venditore lo conferma senza ambiguita': *"Questo EA dispone di
10 strategie, pertanto e' possibile che diverse operazioni vengano eseguite
SIMULTANEAMENTE."*

📌 **Conseguenza pratica**: non e' "un ingresso alla volta". Sono **10 sistemi
indipendenti** che possono aprire posizioni **nello stesso momento**, ognuno
col suo `max_buy_order`/`max_sell_order` (0, 1 o 2 per blocco). Il rischio
aggregato istantaneo **non e' quello di un trade**: e' la somma di quanti dei
10 sottosistemi decidono di entrare insieme — un profilo di rischio che il
nostro cap C1 (3,25% di rischio aperto simultaneo) e il Guardian **non
possono controllare dall'interno**, perche' e' codice loro, non nostro:
`ABTG_GuardiaIngresso` non viene chiamata da un EA esterno.

---

## 🟢 QUELLO CHE IL VENDITORE DICHIARA A SUO FAVORE

- *"Nessuna griglia. Nessuna martingala."* — dichiarato esplicitamente,
  **coerente col `.set`**: ogni blocco ha `ATR_Multiplier_SL/TP` fisso,
  nessun moltiplicatore di lotto dopo una perdita, nessun layer di recovery
  come nell'Artemis. **Non verificato nel codice, ma nessun indizio contrario
  nei parametri.**
- **Rischio percentuale basso di default**: `Risk_Percent=0.4` (range 0,4-0,5
  suggerito nel file).
- **Ingresso con SL/TP via ATR** su ogni blocco — stessa direzione gia'
  misurata da R55/R88 come utile (stop legato alla volatilita', non fisso).

## 🔴 QUELLO CHE PESA CONTRO, E VA DETTO SUBITO

1. **"Propfirm e FTMO non piu' supportati, mi dispiace."** — parola del
   venditore stesso, in cima alla descrizione. Per un progetto il cui **unico
   obiettivo e' passare una prop**, un EA che l'autore stesso ha smesso di
   garantire per quell'uso e' un problema dichiarato, non un dettaglio.
   Non sappiamo **perche'** l'abbia ritirato (violava una regola? troppi
   reclami? scelta commerciale?) — ma il fatto che l'abbia scritto lui stesso
   pesa piu' di qualunque nostra ipotesi.
2. **Il fuso e' in GMT, non verificato su BCM**. A differenza di Diego
   (ambiguo IT/server) e di Artemis (dichiara autodetect), qui il riferimento
   e' fisso: bisogna misurare **l'offset vero di BCM da GMT** prima di fidarsi
   di una sola delle 10 finestre orarie — altrimenti si ripete lo stesso
   errore di classe gia' visto due volte oggi.
3. **10 sistemi indipendenti = 10 volte la superficie da capire**, prima di
   poter dire qualunque cosa sul rischio combinato. Non e' un "prendo
   un'idea e la provo sul nostro motore" come per Artemis: qui **o si prende
   tutto il pacchetto, o niente** — i 10 blocchi non sono separabili senza il
   sorgente.

---

## ➡️ VERDETTO OPERATIVO: **fuori perimetro di R97**

R97 e' nato per una domanda stretta ("lo stop largo del nostro ORB trasferisce
al Nasdaq?"). Questo file **non e' un ORB e non e' scomponibile in un singolo
numero da prendere in prestito** come e' stato per Artemis. Farlo entrare in
R97 snaturerebbe la domanda del round.

**Se Claudio vuole esplorarlo**, e' per costruzione una **decisione a parte**:
comprare/testare un EA esterno completo (60 USD, o demo gratuita prima), con
tutti i limiti di un prodotto senza sorgente (si misura il comportamento, non
si legge la logica) e con l'avvertenza dell'autore sulla prop scritta a
verbale **prima** di qualunque test. Non entra nei criteri di R97.

## 📋 Se un giorno si vuole procedere comunque
1. Demo gratuita esiste (`Demo gratuita` sulla scheda) — si puo' misurare
   **senza comprare**.
2. Prima misura: l'offset GMT reale di BCM, con lo stesso metodo gia'
   proposto per Diego/Artemis (guardare a che ora locale/server apre la
   finestra sul grafico).
3. Il conteggio delle posizioni **simultanee possibili** (somma dei
   `max_buy_order`+`max_sell_order` di tutti i 10 blocchi) va fatto **prima**
   di stimare qualunque rischio aggregato — e' un calcolo di cinque minuti sul
   `.set`, non serve il tester.
