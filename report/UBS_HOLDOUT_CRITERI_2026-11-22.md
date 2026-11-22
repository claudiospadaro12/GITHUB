# Hold-out dei set US30 volatility M15 (22/11/2026, scritto PRIMA dei numeri)
Passo "fuori campione" della guida di Wim per i set US30, aperto UNA volta. Solo tester/demo; nessun consiglio su lotti o taglie.
- **Finestra:** `U30USD_T` (clone a tick reali) dal **26/09/2024** (inizio dello storico BCM del Dow) al **31/12/2024**; la riga usa -Anno 2024 / -Fine 2025.01.01 ma i dati partono dal 26/09: prima non ci sono barre (nessuna operazione possibile). Modello 4, M15, lotto 0,1, 100000 EUR, parametri di Wim non toccati.
- **Set:** `g` (vincolante) e gli altri 5 US30 (U3V12, U3V08, a, b, c) come informativi. 6 passate; contatore di campagna +6.
- **Cancello V4:** PF > 1,0 se operazioni >= 8; profitto netto > 0. `g` passa V4 solo se entrambi. Per gli altri, il verdetto precedente non cambia.
- **Previsioni (scritte ora):** P-1 `g` supera V4: 60%. P-2 `g` ha almeno 12 operazioni nella finestra: 70%. P-3 PF di `g` nel hold-out >= 1,5: 35%. P-4 almeno 4 dei 6 set con PF > 1: 55%.
- **Limiti:** circa 3 mesi (potere statistico basso), un solo regime (rialzo post-elezioni USA); l'hold-out non e indipendente dagli altri test sul 2025-26 per il regime di mercato. Se un solo set passa V4 non basta a dichiararlo robusto.
