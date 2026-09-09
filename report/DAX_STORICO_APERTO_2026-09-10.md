# 🔓 IL DAX 2010-2018 È PULITO — **nove anni nuovi, e dentro ci sono TRE ORSI**

**Corsa**: `RIGA_DIAGNOSI_DAX.ps1 -EstendiIndietro -AnnoDa 2010 -AnnoA 2026`
**Macchina**: PC di backtest `DESKTOP-H4D7CAJ` (utente `Master`) · **durata 5,14 min**
**Pin** `ea86458b` · `histdata_m1.py` HD-M1-v4, **autotest 11/11** · canarino di ritmo **VERDE**
🛑 **Nessun simbolo importato, MT5 mai aperto, cancello ZERO ancora CHIUSO.** Qui c'e' solo un referto.

---

## 🟢 IL RISULTATO: **9 ANNI SANI, ZERO ECCEZIONI**

| anno | barre | fuori banda | densita' | classe |
|---|---:|---:|---:|---|
| 2010 | 26.866 | **0** | 58,1 | ✅ **SANO** |
| 2011 | 213.706 | **0** | 59,3 | ✅ **SANO** |
| 2012 | 211.671 | **0** | 59,3 | ✅ **SANO** |
| 2013 | 210.927 | **0** | 59,2 | ✅ **SANO** |
| 2014 | 209.954 | **0** | 58,9 | ✅ **SANO** |
| 2015 | 211.996 | **0** | 59,5 | ✅ **SANO** |
| 2016 | 213.764 | **0** | 59,6 | ✅ **SANO** |
| 2017 | 206.648 | **0** | 59,3 | ✅ **SANO** |
| 2018 | 213.273 | **0** | 59,3 | ✅ **SANO** |

**Finestra modale identica per tutti e nove** (02:00-15:00 ora di New York = 07:00-20:00 server
BCM), **DST seguito correttamente**, `ALLARME banda: no` nove volte su nove.

## 🐻 E DENTRO CI SONO I RIBASSI CHE NON ABBIAMO MAI POTUTO MISURARE
Range di prezzo **misurato dai dati**, anno per anno:
| anno | minimo | massimo | ampiezza |
|---|---:|---:|---:|
| **2011** | **4.965,00** | 7.623,00 | **−34,9%** dal massimo |
| **2015** | **9.300,50** | 12.428,50 | **−25,2%** |
| **2018** | **10.276,91** | 13.594,25 | **−24,4%** |

⚠️ **Onesta' sulla lettura**: il referto da' **minimo e massimo dell'anno, non il loro ORDINE**.
Che in quei tre anni il massimo venga PRIMA del minimo e' storia nota, **ma da questi dati non
e' misurato**: si legge quando si guarda la serie. Le ampiezze sopra sono **range**, non
drawdown dimostrati.

---

## 🔴 E LA DIAGNOSI DEL BUCO 2020-2023 È **DEFINITIVA** — non e' sporcizia, e' **un altro strumento**

Guarda i prezzi che lo strumento ha misurato:
| anno | minimo | massimo | il DAX in quell'anno stava a... |
|---|---:|---:|---|
| 2021 | **3.461,05** | **4.414,09** | 13.000 - 16.300 |
| 2022 | **3.247,34** | **4.395,06** | 11.900 - 16.300 |
| 2020 | 2.906,95 | 13.827,30 | (miscela) |
| 2023 | 3.793,09 | 17.003,40 | (miscela) |

👉 **Un indice che vive fra 3.200 e 4.400 punti NON E' IL DAX.** E' un altro sottostante
(l'ordine di grandezza e' quello dell'Euro Stoxx 50 o dell'S&P 500 — **quale sia esattamente
NON e' misurato qui**).
**Questo spiega tutto**: l'85,257% di barre fuori banda del 2022, e il famoso minimo di
**2.906,95** che il 18/08 aveva fatto bocciare l'intero file. **Non era un errore di scala:
erano i prezzi giusti di un altro strumento.**
📌 Il cambio si vede al mese: `2020-05 = 00:00` → **`2020-06 = 02:00`**, e da li' i prezzi
crollano di ordine di grandezza.

---

## 🎖️ E LO STRUMENTO HA FATTO UNA COSA CHE VA SCRITTA: **ha bocciato la PROPRIA soglia**

Testuale, dal referto:
> *"ATTENZIONE ALLA SOGLIA, NON AI DATI: il controllo positivo `nsxusd` — che e' la serie
> **PROMOSSA** — ha densita' minima **42,0**, cioe' anche LUI sotto la soglia 55,0. Vuol dire
> che sotto soglia ci sta il FEED (HistData non scrive i minuti senza scambi), non il DAX:
> **i 7 anni marcati MARCIO per densita' NON sono un verdetto valido.**"*

🟡 Quindi **2019, 2024, 2025, 2026 sono "MARCIO" per una soglia sbagliata**: hanno
**zero barre fuori banda** e prezzi giusti (2019: 10.386-13.457). Vanno **riletti** con
`-SogliaDensita` poco sotto 42,0, **dichiarando il valore usato**.
⚠️ Ma il 2019 ha anche **207 buchi > 60 minuti**: quello e' un dato **reale**, non un
artefatto della soglia, e va guardato a parte.

## 🚦 E DUE DOMANDE RESTANO **SOSPESE**, dichiarate dallo strumento stesso
- **Q1** (scala/valuta o spazzatura?): *"NON concludo. I giorni sporchi sono piu' di quanti
  lo strumento ne elenchi (**350 oltre il taglio dei 40**), e il taglio e' sbilanciato verso
  le giornate intere: qualunque conclusione qui sarebbe un artefatto del troncamento."*
- **Q2** (convenzione o buchi?): la risposta *"buchi di feed"* poggia sulla **stessa soglia
  bocciata**, quindi va rifatta insieme al punto sopra.

---

## ⚠️ IL PALETTO CHE RESTA, e non e' piccolo
🔴 **2010-2018 usa la finestra `02:00-15:00`; 2019 e 2024-2026 usano `00:00-23:00`.**
**Sono due convenzioni di seduta diverse.** I nove anni sono **coerenti fra loro** — ed e'
quello che serve per una prova di regime **su quei nove anni** — ma **non si incollano** ai
recenti senza dichiarare che si stanno mettendo insieme due registrazioni diverse.

🔴 **E vale sempre la D-C firmata: `USO = SOLO_PROVA_REGIME`.** Questi dati **non sono BCM**:
niente spread vero, niente orari del broker. Servono a rispondere a *"il motore SOPRAVVIVE a
un orso?"* — **non** a produrre un contratto (DD promesso, frequenza). E per usarli
davvero **serve una firma a parte**, che oggi non c'e'.

---

## 🎯 I PROSSIMI DUE PASSI, in ordine
1. **Rilanciare con `-SogliaDensita 41.0`** (poco sotto il 42,0 del controllo positivo,
   valore **dichiarato**): recupera potenzialmente **2019 + 2024-2026** e chiude Q2.
   ⏱️ Pochi minuti, nessun nuovo scarico.
2. **Poi la firma di Claudio** per portare i 9 anni sani in una prova di regime sul DAX.
   E' una decisione sua: i dati esterni si usano solo con `D-C` gia' firmata **e** una firma
   d'uso specifica.
