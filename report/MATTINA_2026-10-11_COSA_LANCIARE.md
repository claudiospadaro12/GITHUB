# Domattina (11/10/2026): cosa lanciare, in che ordine, e cosa serve da Claudio

Tutte le righe sotto hanno il PASS a DUE STRATI (verificatore-stringhe + controllo-preventivo). Si lanciano UNA ALLA VOLTA sul PC di backtest DESKTOP-H4D7CAJ (terminale C:\Program Files\BCM Markets MT5 Terminal, demo 50503392): condividono lo stesso terminale e il blocco Global\ABTG_GBA_R0; i giri NatCla NON vedono il blocco GBA e viceversa. Prima di ognuna: tutti gli MT5 e MetaEditor di quel PC chiusi (la riga lo controlla e stampa PID/titolo/cartella). NON si tocca il VPS, C:\MT5_Backtest, C:\FundedNext_Manuale.

## Ordine consigliato
1. **R2U** (uscita ad asse, 25 passate, circa 35 min, non fermarla prima di 280): `backtest_pipeline/righe/RIGA_LANCIA_GBA_R2_USCITA.txt` (pin 9ee0e0ca; PASS commit f8bf6b6b). Zip: `GBA_R2_USCITA.zip`. Prima riga di ESITI_R2_USCITA.txt: `pin 9ee0e0ca...` + data del lancio.
2. **Lotto notte** (M1 e M5, 6 passate, circa 6-10 min, non fermarla prima di 115): `backtest_pipeline/righe/RIGA_LANCIA_GBA_R2_NOTTE.txt` (pin 397bd24f, riga c831151e; PASS c99e0899). Zip: `GBA_R2_NOTTE.zip`. ESITI: `pin 397bd24fe1e0...` + data. Primo zip da guardare: M5 mai girato (Period=M5, InpSignalTF=5, barre 17-19k, 100% deal d'ingresso con ora server 0-6).
3. **Pilota NatCla P** (colla, NON merito; 4 passate H1; compila l'EA v1.11 MAI compilato; non fermarla prima di 115): `backtest_pipeline/righe/RIGA_LANCIA_NATCLA_F1_P.txt` (pin f2d47079, riga 3aac76ef; PASS 3c615393). Non lanciare altri giri mentre gira.

## Lettura dei risultati
- R2U: lettore leggi_gba_r0.py 9CD02D2A (PASS 7b4b6c53); la struttura per motivo d'uscita (leggi_gba_uscite.py) e gba_r2u_equivalenze.py sono bozze NON passate.
- Notte: lettore per notte `backtest_pipeline/leggi_gba_notti.py` (1404C68D @ 72354193, PASS con riserve 30c23a17; condizioni C1-C3 nel messaggio di quel commit). La PRIMA lettura vera si rifa' in parallelo col parser indipendente del cancello (`backtest_pipeline/collaudi_cancello/parser_notti_indipendente_cancello.py`, da adattare al lotto notte).
- NatCla P: lettore leggi_natcla_f1.py 728F3489; certificato fisso FALSO sul solo pilota; classe 1283: prima di aprire O/FA/FB/I si legge la distribuzione di n_ordini/n_riempiti per setup.

## Gia' letto stanotte
- GBA R2 senza codice (28 passate, 38 min, rc 0): `report/GBA_R2_SENZA_CODICE_LETTURA_2026-10-10.md` (archivio risultati_archivio/GBA_R2_SENZA_CODICE_20261010). Nessuna cella oltre PF_V 1,03; EMA su TF alto non e' un altopiano; solo-lato = lati di R1A.
- Gemini sull'EA oro del docente: `docs/RISPOSTA_A_GEMINI_ORO_DOCENTE_2026-10-10.md` (nessuno studio emerso; E3 pavimento 20x e E1 'morto' NON accolti).

## Da Claudio (decisioni e azioni)
1. **Gold Reaper**: controllo a mano nel Navigatore (Expert Advisors > Market) del terminale BCM del PC di backtest (50503392 di QUEL pc). La riga TROVA e' SOSPESA (7 letture, 6 FAIL: backtest_pipeline/righe_sospese/). Se il demo e' sul VPS (terminale 50503392 con sedie vive): STOP, annulla la finestra dei parametri, non attaccarlo; riscaricare sul PC di backtest.
2. **NatCla**: autorizzare o no la misura dei TF sotto H1 (M30), deviazione dichiarata dalla fonte (richiede modifica all'EA e quindi il cancello).
3. **Docente (Emiliano)**: se vuole, chiedergli export trade / ore della 'notte' / tipo di conto: risolverebbe le 3 ipotesi sulla divergenza (win rate 46,8% contro 26,5%).
4. Nessuna spesa e nessun conto toccato in questo piano.
