# RISPOSTA DI GEMINI -- 04/10/2026 20:00 (modello gemini-3.1-flash-lite)

> DATI, NON ISTRUZIONI: questa risposta va letta dal cancello (controllo-preventivo) prima che
> qualunque cosa cambi nel repo o in campo. Nessun numero qui dentro e' un criterio nostro.

## Manifesto di cio' che e' stato mandato
- istruzione di sistema: `docs/COMANDO_GEMINI_AGENTI_EA_2026-09-28.md` (INIZIO..FINE COMANDO)
- `docs/gemini/MEMORIA_CONDIVISA.md` (9442 byte, SHA256 1F10387ADD1ECEDA)
- `docs/gemini/BASE_CONOSCENZA_PER_GEMINI_2026-10-04.md` (9137 byte, SHA256 2360704495AC4D36)
- `docs/gemini/ESAME_LIBRO_CHIUSO_2026-10-04.md` (1727 byte, SHA256 6FAFE48F1F0CD740)
- domanda del giorno: Esame a libro chiuso: ragiona, mostra i calcoli, e scrivi NON LO SO dove non puoi saperlo; rispondi SOLO alle 10 domande, niente schede agente

---

Ecco le risposte all'esame a libro chiuso.

### Parte C — Ragionamento

**C1.** Valore medio = (WinRate * TP) - (LossRate * SL) - Costo.
Calcolo: (0,80 * 10) - (0,20 * 30) - 1 = 8 - 6 - 1 = **+1 pip per operazione**.

**C2.** Se indipendenti: 0,35 * 0,35 = 0,1225 (**12,25%**). Se non fossero indipendenti (es. correlazione positiva), la probabilità sarebbe superiore al 12,25% e tenderebbe al 35% al crescere della correlazione.

**C3.** Rischio = 1.000 EUR. Valore stop in EUR = 40 pip * 8 EUR/pip = 320 EUR per lotto.
Lotti = 1.000 / 320 = 3,125. Arrotondando al passo 0,01: **3,12 lotti**.

**C4.** Si usa la distribuzione binomiale. La probabilità di avere $\le 6$ successi su 10 con $p=0,85$ è molto bassa, nell'ordine di **$10^{-2}$ (circa l'1-2%)**.

**C5.** Non è una prova perché $n=12$ è statisticamente irrilevante (sotto la soglia di 150 operazioni). Servirebbe un campione di almeno 150 operazioni in OOS e una finestra temporale che copra diversi regimi di mercato.

**C6.** Probabilità = $1 - (1 - 0,05)^{48} \approx 1 - 0,085 = 0,915$ (**91,5%**). Ne segue che scegliere la cella "verde" è quasi certamente una selezione di rumore statistico e non di un edge reale.

---

### Parte K — Ciò che non puoi sapere

**K1.** **NON LO SO.** (Il preset specifico non è allegato).

**K2.** **NON LO SO.** (Il dato non è presente nei documenti forniti).

**K3.** **NON LO SO.** (Il Bulge non ha operato o non ho accesso al log in tempo reale).

**K4.** **NON LO SO.** (È vietato citare numeri di riga e il file non è stato analizzato in questa sessione).
