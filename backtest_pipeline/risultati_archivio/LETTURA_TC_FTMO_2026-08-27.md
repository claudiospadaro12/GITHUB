# 📄 LETTURA — FTMO Challenge Terms and Conditions (PDF ufficiale, 22 pagine, aggiornato 4/08/2026)

_Fonte: PDF scaricato da Claudio direttamente dal sito FTMO — primo documento
legale [VERIFICATO] della storia del dossier (non più [LETTO-VIA-SEARCH]).
Letto integralmente da Claude: clausole 1-21 + definizioni._

## 🎯 Cosa NON contiene (va detto subito)
Questo documento è il **contratto legale generale**, non il regolamento
tecnico della challenge. Le percentuali dei muri, la distinzione
Standard/Swing, la lista delle Forbidden Trading Practices, le regole
gap/news/weekend **NON sono scritte qui dentro** — sono su pagine del sito
richiamate come link "here" (mai risolti in questo PDF). Restano da
verificare con gli screenshot del cruscotto, come da piano.

## ✅ Le 4 cose utili trovate, verificate

### 1. 🔴 Il diritto di recesso (14 giorni) si estingue al PRIMO trade
> _"your withdrawal right applies only before you open your first simulated
> trade... when you open the first simulated trade... you thus express your
> consent that the Services... are to be provided in full and will cause you
> to lose your right to withdraw"_ (12.1)

**Conferma esattamente la disciplina che stiamo già seguendo**: zero trade
finché non è tutto pronto e firmato. Un solo trade di troppo (anche per
sbaglio, anche di test) brucia il diritto di rimborso.

### 2. 🆕 Fee di conversione valuta: 0,7% FLAT su ogni posizione in valuta diversa dal conto
> _"a flat adjustment fee of 0.7% from the realised profit and loss at the
> moment the position is closed will be applied... reduces a realised profit
> and increases a realised loss"_ (5.3.4)

🔴 **Rilevante per il DAX**: la sonda di stasera ha misurato `CURRENCY_MARGIN;EUR`
su GER40 mentre il conto è in USD. Questo 0,7% è un costo aggiuntivo,
certo e automatico, su OGNI chiusura DAX — da aggiungere al conto economico
della sedia, non solo la conversione del margine.

### 3. 🆕 "Risk per Trade Idea" — l'equivalente FTMO del cap aggregato Fintokei
Definizione ufficiale (Clausola 21):
> _"the total exposure in a specific symbol (or **correlated symbols**) on
> your account during a given moment or within a specific time period,
> measured as a percentage of your initial Simulated Capital, whereas the
> associated risk is determined by the **maximum drawdown of realised or
> unrealised loss** of the positions linked to the same trade idea."_

FTMO si riserva (7.6.6) di **"enforce the limitation on Risk per Trade Idea
to the maximum limit we determine, acting reasonably"** — discrezionale,
percentuale NON dichiarata in questo documento.

🔴 **Perché ci riguarda direttamente**: è concentrazione per **simbolo o
simboli correlati**, non per l'intero conto (diverso dal 3% aggregato TOTALE
di Fintokei). Le nostre coppie **gemelle originale+OTT** (stesso simbolo,
stesso segnale, DAX Apertura EU + OTT) sono **esattamente** la definizione
di "positions linked to the same trade idea" — il caso che questa clausola
descrive parola per parola. Va controllato quanto vale il limite reale (non
è in questo PDF) prima del deploy.

### 4. Meccaniche minori ma da registrare
- **Conto disattivato per inattività**: 0 trade per 30 giorni consecutivi,
  OPPURE perdita fra 8-10% del capitale iniziale per oltre 30 giorni (13.2.3)
  — non ci riguarda con una flotta attiva.
- **FTMO usa strumenti di intelligenza artificiale** nel supporto tecnico
  (14.1) — nota di colore, non operativa.
- **Limite aggregato $400.000** per persona/entità/strategia su tutto il
  gruppo FTMO (5.8.5c, 6.3) — coerente con quanto già noto.

## ➡️ Cosa resta da fare (invariato dal piano)
Gli screenshot del cruscotto (Trading Objectives, natura del muro totale,
reset, leva/tipo conto, Forbidden Practices) restano necessari: questo PDF
non li sostituisce. In più, ora sappiamo di cercare ANCHE la percentuale
reale del "Risk per Trade Idea" nelle FAQ/objectives, se dichiarata.
