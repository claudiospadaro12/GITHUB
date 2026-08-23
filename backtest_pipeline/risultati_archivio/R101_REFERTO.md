# R101 — REFERTO CHIUSO: l'ablazione dei filtri su Dow e DAX

_Round firmato il 23/08/2026 ("SI AD ENTRAMBE, FIRMO L'ABLAZIONE SU DOW E
DAX" + "FIRMO TUTTE E 6 CON LE PROPOSTE"), nel contesto della richiesta
esplicita di Claudio: **"VOGLIO MIGLIORARE GLI EA SUL CONTO DA 100K SU
APERTURA DOW ED APERTURA DAX. DOBBIAMO FARCELA"**._

_Due corse, stessa serata del 23/08, pin `3c39326e7ae9bfa02e19c11c9c5062e414044907`
(la prima al pin `e4c1afac`, che differisce SOLO per il fix checklist 64 al
driver — EA e file prova byte-identici, verificato con git diff):
zip `R101_ABLAZIONE_CORSA_20260823_2159.zip` (DOW completo + metro DAX) e
`R101_ABLAZIONE_SOLODAX_20260823_2314.zip` (i 9 gradini DAX). Tick reali
(modello 4), finestra 2024.09.26→2026.06.30, split 40/60 (IS fino al
2025.06.09, OOS dal 2025.06.10 — le stesse di R88/R97/R98). Rischio nei file
prova 1,00%; **in campo sul 100k è 0,65%: ogni DD di questo referto si
converte ×0,65 prima del confronto col forward** (criteri par. 2.4).
Gemelli IDENTICI in tutti i 40 CSV. Giudizio compilato a mano sopra i CSV,
come previsto dai criteri ("i cancelli li applica il referto del round")._

---

## 1. G0 — i due metri si riproducono? SÌ, TUTTI E DUE.

| famiglia | atteso agli atti | misurato | verdetto |
|---|---|---|---|
| DOW (770202) | PF 1.270 · DD 4.39% · n 130 | PF 1.270 · DD 4.39% · n 130 | ✅ RIPRODOTTO al centesimo |
| DAX (770101) | PF 1.400 · DD 7.23% · n non agli atti | PF 1.397 · DD 7.23% · n OOS 270 | ✅ RIPRODOTTO (PF dentro ±0,01 firmato; DD esatto; il n entra agli atti ADESSO: IS 175 / OOS 270) |

**Storia del round, agli atti:** la prima corsa fermò il DAX a un **falso
rosso** su G0 — il sentinella `-1` ("n non agli atti") letto come STRINGA e
`"-1" -gt 0` VERO su Windows PowerShell 5.1 (NLS) — **checklist 64**, classe
nuova: la prima che passa un'esecuzione reale del verificatore (pwsh/Linux,
dove è FALSO) e cade solo sull'OS di destinazione. Driver corretto (parametri
tipizzati + cast), la ripresa `-SoloEa DAX` ha adjudicato G0 col gate giusto.

**Adjudicazione delle celle "SALTATA DAL DRIVER"** (DOW 00–04 nel primo zip;
DAX 00–05 nel secondo): CSV prodotti nella STESSA serata, stesso pin
(differenze tra i due pin solo nel driver, non negli EA/prove), stessa
macchina. Il driver li marca onestamente "non di questo lancio": **sono
validi e sono giudicati qui**.

## 2. La tabella madre COMPLETA (IS+OOS dai 40 CSV — §5.1 dei criteri)

Costo € = profitto OOS della viva − profitto OOS della cella (all'1% su
100k). "op tolte" = n viva − n cella (OOS; negativo = ne aggiunge). Peggior
giornata: −1,02% su quasi tutte le celle Dow / −1,06÷−1,08% sul DAX — **è lo
stesso giorno: nessun filtro lo evita.**

### DOW (viva OOS: +6.722 € · PF 1,270 · DD 4,39% · n 130)

| gradino | IS: prof · PF · DD · n | OOS: prof · PF · DD · n | ΔPF OOS | ΔDD OOS | costo € | op tolte |
|---|---|---|---:|---:|---:|---:|
| 00_viva (metro) | +2.812 · 1,222 · 5,67 · 74 | +6.722 · 1,270 · 4,39 · 130 | — | — | — | — |
| 01_ema (TOGLIE EMA H4) | **−2.274 · 0,920 · 10,85** · 139 | +8.860 · 1,193 · 7,01 · 214 | −0,077 | +2,61 | −2.138 | −84 |
| 02_volumi | +1.266 · 1,236 · 3,14 · 31 | +5.138 · **1,543 · 2,83** · 56 | **+0,273** | **−1,57** | 1.584 | 74 |
| 03_atr | = viva al centesimo | = viva al centesimo | 0 | 0 | 0 | 0 |
| 04_corso_or | = 02_volumi al centesimo | = 02_volumi al centesimo | +0,273 | −1,57 | 1.584 | 74 |
| 05_supertrend3 | **+315 · 1,042** · 2,91 · 36 | +6.935 · 1,557 · 4,23 · 72 | +0,287 | −0,16 | −213 | 58 |
| 06_correlazione | +1.694 · 1,134 · 5,67 · 68 | +4.335 · **1,184 · 4,90** · 112 | **−0,086** | **+0,51** | 2.387 | 18 |
| 07_vwap | **+6.440 · 2,152** · 2,80 · 47 | +4.096 · 1,278 · 3,36 · 77 | +0,007 | −1,04 | 2.626 | 53 |
| 08_tondi | +2.627 · 1,333 · 2,84 · 86 | +4.804 · 1,213 · 4,87 · 147 | −0,057 | +0,48 | 1.918 | −17 |
| 09_corso_pieno | +1.791 · 1,531 · 3,14 · 20 | +1.041 · 1,197 · 2,32 · **26** | −0,073 | −2,08 | 5.681 | 104 |

### DAX (viva OOS: +18.030 € · PF 1,397 · DD 7,23% · n 270)

| gradino | IS: prof · PF · DD · n | OOS: prof · PF · DD · n | ΔPF OOS | ΔDD OOS | costo € | op tolte |
|---|---|---|---:|---:|---:|---:|
| 00_viva (metro) | +3.789 · 1,126 · 5,44 · 175 | +18.030 · 1,397 · 7,23 · 270 | — | — | — | — |
| 01_ema (METTE EMA 14/200 H1) | **+477 · 1,022** · 6,40 · 128 | +12.032 · **1,502 · 5,15** · 149 | +0,105 | −2,08 | 5.997 | 121 |
| 02_volumi | +5.321 · **1,466 · 2,64** · 68 | +9.323 · **1,550 · 4,63** · 96 | **+0,153** | **−2,60** | 8.706 | 174 |
| 03_atr | = viva al centesimo | = viva al centesimo | 0 | 0 | 0 | 0 |
| 04_corso_or | = 02_volumi al centesimo | = 02_volumi al centesimo | +0,153 | −2,60 | 8.706 | 174 |
| 05_supertrend3 | **+1.301 · 1,077** · 4,78 · 90 | +8.389 · 1,553 · 4,60 · 95 | +0,156 | −2,64 | 9.640 | 175 |
| 06_correlazione | +7.060 · 1,491 · 3,13 · 105 | +15.176 · **1,536 · 5,49** · 171 | **+0,138** | **−1,74** | 2.853 | 99 |
| 07_vwap | **+9.281 · 1,619** · 3,25 · 107 | +8.530 · 1,337 · 5,20 · 160 | −0,061 | −2,03 | 9.500 | 110 |
| 08_tondi | +5.448 · 1,200 · 4,44 · 175 | +13.041 · 1,307 · 7,04 · 251 | −0,090 | −0,20 | 4.989 | 19 |
| 09_corso_pieno | +3.436 · 2,132 · 2,50 · 26 | +2.547 · 1,408 · 3,33 · **28** | +0,011 | −3,90 | 15.483 | 242 |

## 3. G3 — IL CANCELLO CROSS-MERCATO, gradino per gradino

_(È il cancello che in R46 fermò un candidato da +31%. Con 18 confronti
sulla stessa finestra, qualcuno esce verde per caso: G3 è il filtro del
caso. Il gradino 01 è asimmetrico per firma e si legge come due misure
separate.)_

| gradino | DOW dice | DAX dice | G3 | verdetto |
|---|---|---|---|---|
| **02_volumi** | **MEGLIO** (PF +0,273, DD −1,57 — e anche l'IS migliora) | **MEGLIO** (PF +0,153, DD −2,60 — e anche l'IS migliora) | ✅ **COERENTE, sui due mercati E sulle due finestre** | 🟢 **L'UNICO CANDIDATO DEL ROUND** |
| 03_atr | filtro NULLO (identico al centesimo) | filtro NULLO (identico al centesimo) | ✅ coerente | la soglia del corso (ATR≥1,0×media20) **non toglie un trade su nessuno dei due indici**: misura, non opinione |
| 04_corso_or | ≡ 02_volumi | ≡ 02_volumi | ✅ coerente | con l'ATR nullo, la combinata È i volumi: zero informazione aggiuntiva |
| 05_supertrend3 | OOS meglio (+0,287) MA **IS peggio** (1,042 vs 1,222) | OOS meglio (+0,156) MA **IS peggio** (1,077 vs 1,126) | ⚠️ coerente… nel RIBALTONE | il filtro aiuta nel periodo OOS e danneggia nell'IS **su entrambi i mercati**: dipende dal REGIME, non dal mercato. Non è un candidato: è la lezione di R98 in doppia copia |
| 06_correlazione | **PEGGIO** (PF −0,086, DD +0,51) | **MEGLIO** (PF +0,138, DD −1,74) | ❌ **INCOERENTE** | **BOCCIATO DA G3** — lo scenario esatto per cui il cancello esiste |
| 07_vwap | PF piatto (+0,007), DD meglio | **PF peggio** (−0,061), DD meglio | ❌ incoerente sul PF | niente candidato (G2 sul DAX fallisce). L'IS spettacolare del Dow (PF 2,152) resta una curiosità agli atti |
| 08_tondi | PEGGIO (PF −0,057, DD +0,48) | PEGGIO (PF −0,090, DD −0,20) | ✅ coerente… in NEGATIVO | i numeri tondi come 1° obiettivo **COSTANO su entrambi gli indici**. Il corso qui, sulla nostra geometria, peggiora |
| 09_corso_pieno | n=26 < 30 | n=28 < 30 | — | **NON MISURABILE su entrambi** — esattamente come scritto PRIMA dei numeri: la checklist del corso applicata alla lettera non produce un campione giudicabile |

**Gradino 01 (asimmetrico, due misure separate):**
- **DOW — togliere l'EMA H4: NO.** Senza, l'IS va in perdita (−2.274 €, PF
  0,920, DD 10,85). Il filtro PAGA: **la cella viva del Dow esce CONFERMATA.**
- **DAX — mettere l'EMA 14/200 H1: NO.** L'OOS migliora (PF 1,502, DD 5,15)
  ma l'IS **crolla** (+477 €, PF 1,022): stesso ribaltone del gradino 05.
  Un filtro che vale solo in metà della storia non entra in una sedia viva.

## 4. IL CANDIDATO — 02_volumi (VOLUMI ≥ 1,5× media 20, dal corso)

L'unico che passa TUTTI i cancelli: G1 (n OOS 56 e 96, ≥30), G2 (PF su E DD
giù, su entrambi i mercati), G3 (stessa direzione ovunque, IS comprese).

**Cosa fa, in soldi (all'1%):** taglia circa metà delle operazioni
(Dow 130→56, DAX 270→96) tenendo le migliori: PF 1,543/1,550, DD 2,83%/4,63%.
**Il prezzo è il profitto assoluto**: −1.584 € sul Dow e −8.706 € sul DAX
nell'OOS. Meno soldi, molto più puliti.

**Le tre onestà scritte accanto al candidato:**
1. **Il campione filtrato è sottile**: 56 e 96 op OOS sono sotto i 150
   dell'Emendamento — il candidato è MISURATO, ma il suo merito pieno no.
2. **Un solo regime**: 21 mesi di indici in salita. G3 toglie il caso di
   mercato, non il caso di regime.
3. **Non è una gemella affiancabile**: la cella filtrata opera un
   SOTTOINSIEME dei trade della viva — girare entrambe raddoppierebbe
   proprio i trade filtrati. Se mai entrasse, è una SOSTITUZIONE con
   contratto riscritto, non una sedia in più.

**G5, come firmato: QUESTO ROUND NON PROMUOVE NIENTE.** Il forward delle due
sedie del 100k non si tocca. Se Claudio vuole portare avanti il candidato,
la strada onesta è: (a) prova di regime / walk-forward sul gemello volumi,
poi (b) firma di sostituzione con contratto nuovo. Proposta pronta a
richiesta.

## 5. Cosa questo round ha DATO oltre al candidato

- ✅ **Le due celle vive escono CONFERMATE dalla prova più dura**: 16
  varianti contro, e nessuna le batte in modo coerente. Il lavoro che le ha
  costruite (R46, R54) regge.
- 📏 **Tre misure definitive sul metodo del corso** applicato alla nostra
  geometria: il filtro ATR è NULLO (soglia mai attiva), i numeri tondi
  COSTANO, il "corso pieno" NON PRODUCE UN CAMPIONE (n 26 e 28).
- 📖 **Checklist 64** (e, dal ramo R102 della stessa serata, la 65):
  la famiglia "PowerShell converte da solo" ora ha tre membri censiti.
- 🔢 Il **n del metro DAX entra agli atti**: IS 175 / OOS 270 sulla
  finestra R88 (prima non era mai stato misurato per finestra).

## 6. Cosa NON dice (dichiarato)

Nessuna misura di spread o slippage; nessun walk-forward nuovo; un solo
regime di mercato; il merito del Dow resta SOSPESO per campione (n IS 74);
la peggior giornata (−1,0/−1,1% all'1%) è comune a tutte le celle: i filtri
non proteggono dal giorno peggiore, riducono la frequenza degli altri.

_Referti driver grezzi agli atti: `R101_REFERTO_DRIVER_20260823_2159.txt`
(CORSA) e `R101_REFERTO_DRIVER_SOLODAX_20260823_2314.txt` (ripresa DAX)._
