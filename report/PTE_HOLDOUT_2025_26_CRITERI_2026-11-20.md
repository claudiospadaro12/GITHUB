# PTE (H4) sul periodo mai toccato 2025-01-01 -> 2026-11-19: criteri PRIMA dei numeri (20/11/2026)

**Perche':** nel test 2013-2024 (`PTE_WOL_FOREX_CRITERI_2026-11-20.md`) PTE e' stato perdente in 2013-2020 (PF 0,76) e positivo in 2021-2024 (PF 1,31): l'ipotesi, nata DOPO i numeri, e' che dal 2021 il regime di mercato favorisca la strategia. Il 2025-26 non e' mai stato usato: e' l'unico controllo pulito e si fa **una sola volta**.
**Prova:** `ABTG_PTE` H4 invariato (stesso sorgente e stessi default del test precedente, `InpVerbose=false`), 28 cross forex, 2025-01-01 -> 2026-11-19, BCM portabile, Modello 1. Stesso metodo di analisi: serie giornaliere dei 28 cross sommate, R = rendimento / 1%.
## Previsioni
- PF pooled > 1,2: **35%**; PF tra 0,95 e 1,2: **30%**; PF < 0,95: **35%**.
- Operazioni (giorni con uscite) pooled: 150-350: **70%**.
## Regole di esito (fissate ora)
- **Ipotesi CONFERMATA** solo se PF pooled > 1,2 **e** IC90 inferiore del R medio > 0 **e** almeno 15 cross su 28 con PF > 1.
- **NON CONFERMATA** se PF pooled <= 1,0. Tra 1,0 e 1,2 oppure IC90 che include 0: **INCONCLUSIVA** (non si dichiara conferma).
- Anche se confermata: PTE resta **non candidato** (IS 2013-2020 PF 0,76, 4 anni su 12 positivi); si aprirebbe una scheda nuova "PTE dal 2021" con criteri nuovi, **non** si usa il 2025-26 per scegliere altro. Il periodo e' esaurito dopo questa passata (resta un solo uso). Nessun consiglio di taglie.

## RISULTATO (28 passate ricevute 20/11, nessun errore; serie giornaliere dei 28 cross sommate, R = rendimento / 1%)
- **Pooled 2025-01-01 -> 2026-11-19: n 224 giorni con uscite, R +0,026, PF 1,07, IC90 inferiore -0,070, win 59%.** Per anno: 2025 PF 0,89 (n 118, R -0,05); 2026 PF 1,34 (n 106, R +0,11, IC90 inf -0,02). Cross con PF > 1: **12 su 28** (soglia 15). Tester: 373 operazioni, netto +6.349 EUR sommato sui 28 conti da 100k.
- **Esito secondo le regole scritte prima: INCONCLUSIVA** (PF tra 1,0 e 1,2, IC90 che include zero, 12 cross su 28 invece di 15). **L'ipotesi "PTE funziona dal 2021" NON e' confermata**; non e' nemmeno smentita (PF > 1,0). Il periodo 2025-26 e' ora esaurito per PTE.
- Previsioni: PF > 1,2 (35%): no; PF 0,95-1,2 (30%): **si'**; operazioni 150-350 (70%): si' (224).
- Quadro complessivo PTE sui 28 cross: 2013-2020 PF 0,76; 2021-2024 PF 1,31; 2025-26 PF 1,07. Media pesata su 12 anni intorno a 1,0: **nessun vantaggio dimostrato**. Prossimo passo, se si vuole: fedelta' dell'EA ai documenti di Emiliano (non ottimizzazione).
