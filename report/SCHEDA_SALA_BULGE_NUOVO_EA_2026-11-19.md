# Scheda "Sala del Consiglio V2" - Bulge: nuovo EA dai report di aprile (BOZZA da approvare, 19/11/2026)

```yaml
NOME_PROGETTO: "Bulge-Nuovo: EA forex mean-reversion H1 ricreato dai due report del tester di aprile (1% e 3%)"
BRIEF: "Digerire i due Excel (268 operazioni, 5 cross, H1, 2022-2026, 40% tick reali) e il demo reale (699 operazioni, PF 0,76); capire da dove viene la curva; rifare la stessa prova col motore corretto (ABTG_Bulge_S v5.20, segnale su barra chiusa); se il vantaggio regge, ricreare un EA con regole scritte e criteri congelati."
OBIETTIVO_PRINCIPALE: "Un EA forex proprio che passi i criteri su dati NON usati per sceglierne simboli e parametri. La curva dell'Excel e un riferimento, non un bersaglio da ottimizzare."
DESTINATARI: "Claudio (demo BCM 50503392, eventuale prop FTMO dopo forward)"
DELIVERABLE_RICHIESTI: "(0) anatomia dei dati degli Excel; (1) ciclo 0: stessa prova col motore corretto; (2) criteri e previsioni congelati PRIMA dei numeri; (3) SOLO se il ciclo 0 conferma: specifica + variante MQL5 nuova (gli originali non si toccano) + righe di test; (4) referto."
MATERIALI_DISPONIBILI: "BULGE MULTI SIGNAL CLAUDIO 1%/3%.xlsx; ABTG_Bulge_S/TS/F5, BULGE_MASTER; report/BULGE_ANALISI_FORWARD; sala-del-consiglio/breaking_band; dati BCM forex 2013-2025 a 1 minuto; riga di test collaudata (modello 14ea)"
VINCOLI: "solo tester/demo; VPS e reale 10105439 non toccati; nessun consiglio su lotti/taglie; server BCM GMT+1 fisso; gli _Ottimizzato girano in parallelo agli originali, mai in sostituzione; push solo sul branch claude/verifica-siti-caccia-strategie-v5pzqv; economia di crediti"
CRITERI_DI_SUCCESSO: "Su periodi/simboli non usati per la scelta: >=100 operazioni; PF in R >= 1,3; % vincenti >= pareggio + 5 punti; nessun anno > 50% del profitto; DD equity <= 10% a rischio 1%; stesso segno su >=3 simboli su 5; plateau dei parametri; poi forward demo."
X_AGENTI_TOTALI: 5
MODALITA_AGENTI: "AUTO"
MAX_CICLI_DI_REVISIONE: 2
SOGLIA_QUALITA: 90
RICERCA_ESTERNA: "NO"
BUDGET_EXTRA: 0
```

**Fasi e peso (stima):** Fase 0 = ciclo 0, nessun agente: una riga sul tester (20-40 minuti) + referto. Fase 1 (la sala con 5 agenti) parte SOLO se la Fase 0 conferma un vantaggio.
