#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
R262_R263_GENERA.py -- 26/09/2026 -- genera gli 11 file prova di R262 e R263
(il candidato "770201" = Dow BREAKOUT a due lati, range 15', U30USD M5,
EA ABTG_Nasdaq_Apertura_US). ASCII puro.

  R262a-d : l'asse InpEmaSlow OLTRE 260 (160..320), rischio 1%, banco R245
  R263a-d : il DD MISURATO a rischio 2% (non riscalato), InpEmaSlow 160..260
  R263e/f : il PER-TRADE a 2% della cella centrale (IS / OOS), gemelle G1
  R263g   : l'asse InpRiskPercent 1,00..2,00 sulla cella centrale

DA DOVE VENGONO I NUMERI (nessuno ricopiato a mano):
  - i 96 pin: prove/R245b_emaslow_bordo_TP050_U30USD.txt (PASS del cancello,
    girato il 24/09 sul pin f489a621; EA e include IDENTICI a HEAD 26/09);
  - le ancore G0: risultati_archivio/R245/ROUND_R245{a,b,c,d}/*.csv e
    risultati_archivio/R248/ROUND_R248a/*_IS_R248a.csv (letti qui sotto).

USO:  python3 backtest_pipeline/prove/R262_R263_GENERA.py            (scrive)
      python3 backtest_pipeline/prove/R262_R263_GENERA.py --verifica (non
            scrive: rigenera in memoria e confronta byte per byte)
      python3 backtest_pipeline/prove/R262_R263_GENERA.py --centro 220 0.50
            (SOLO se R262 sposta il centro: rigenera R263e/f/g sulla cella
            nuova PRIMA del lancio di R263; tutto il resto resta uguale)
"""
import csv
import glob
import os
import sys

QUI = os.path.dirname(os.path.abspath(__file__))
PIPE = os.path.dirname(QUI)
BASE = os.path.join(QUI, 'R245b_emaslow_bordo_TP050_U30USD.txt')
ARCH245 = os.path.join(PIPE, 'risultati_archivio', 'R245')
ARCH248 = os.path.join(PIPE, 'risultati_archivio', 'R248', 'ROUND_R248a')

TP = [('a', '0.33', 'TP033'), ('b', '0.50', 'TP050'),
      ('c', '0.67', 'TP067'), ('d', '0.84', 'TP084')]
# blocchi magic VERGINI al 26/09/2026: grep -rIlE "\b766[34][0-9]{2}\b" su
# /home/user (repo + 8 worktree .claude) e /tmp = 0 file; git grep su
# refs/heads + refs/remotes = 0 file. (7662xx NON e' vergine: 54 file.)
MAGIC_R262 = {'a': 766301, 'b': 766302, 'c': 766303, 'd': 766304}
MAGIC_R263 = {'a': 766401, 'b': 766402, 'c': 766403, 'd': 766404}
MAGIC_R263E = (766411, 766412)
MAGIC_R263F = (766413, 766414)
MAGIC_R263G = 766421

CENTRO_EMA = '200'
CENTRO_TP = '0.50'


# ---------------------------------------------------------------------------
def leggi_base():
    testo = open(BASE, encoding='ascii').read().splitlines()
    i0 = next(i for i, l in enumerate(testo) if l.startswith('@SIMBOLO'))
    i1 = next(i for i, l in enumerate(testo) if l.startswith("# --- L'ASSE"))
    blocco = testo[i0:i1]
    nomi = [l.split('=', 1)[0] for l in blocco if l.startswith('Inp')]
    assert len(nomi) == len(set(nomi)) == 96, len(nomi)
    return blocco


def csv_righe(pat):
    f = glob.glob(pat)
    assert len(f) == 1, pat
    return list(csv.DictReader(open(f[0], encoding='utf-8-sig')))


def ancore_r245():
    """{(lettera, finestra, ema): riga} dai CSV di R245a-d."""
    out = {}
    for L, _tp, _s in TP:
        for W in ('IS', 'OOS'):
            for r in csv_righe(os.path.join(ARCH245, 'ROUND_R245' + L,
                                            '*_%s_R245%s.csv' % (W, L))):
                out[(L, W, int(r['InpEmaSlow']))] = r
    return out


def ancora_r248():
    r = csv_righe(os.path.join(ARCH248, '*_IS_R248a.csv'))
    assert len(r) == 2 and r[0]['Profit'] == r[1]['Profit']
    return r[0]


# ---------------------------------------------------------------------------
def blocco_pin(base, tp, rischio, magic, date, togli=()):
    """ricostruisce il blocco dei pin di R245b cambiando SOLO: date,
    InpTP1_R, InpRiskPercent, InpMagic (o toglie le righe in 'togli',
    che diventano l'asse in fondo), e il commento di testa del blocco."""
    out = []
    salta_commento = False
    for l in base:
        if l.startswith('@DAQUANDO'):
            out.append('@DAQUANDO ' + date[0]); continue
        if l.startswith('@FINOA'):
            out.append('@FINOA    ' + date[1]); continue
        if l.startswith('@FRAZIONEIS'):
            out.append('@FRAZIONEIS ' + date[2]); continue
        if l.startswith("# --- 75 pin LETTI"):
            salta_commento = True
            out.append("# --- 75 pin LETTI DAL CSV D'ARCHIVIO (via R245b, PASS del cancello, girato")
            out.append("#     il 24/09): valore COSTANTE su tutte e 80 le righe di")
            out.append("#     risultati_archivio/Dow_Apertura/dow_walkforward_{IS,OOS}.csv. Forma 1/0")
            out.append("#     dei bool come il lanciatore dell'archivio (dow_apertura.ps1). Eccezioni")
            out.append("#     DICHIARATE: InpMagic (blocchi vergini 7663xx/7664xx, generatore),")
            out.append("#     InpNewsCurrencies OMESSO (stringa vuota nel CSV = default compilato r.296),")
            out.append("#     e le righe che QUESTO file cambia: vedi l'intestazione.")
            continue
        if salta_commento:
            if l.startswith('#'):
                continue
            salta_commento = False
        if l.startswith('InpTP1_R='):
            if 'InpTP1_R' in togli: continue
            out.append('InpTP1_R=' + tp); continue
        if l.startswith('InpRiskPercent='):
            if 'InpRiskPercent' in togli: continue
            out.append('InpRiskPercent=' + rischio); continue
        if l.startswith('InpMagic='):
            if 'InpMagic' in togli: continue
            out.append('InpMagic=' + str(magic)); continue
        if l.startswith('InpEmaSlow='):
            raise AssertionError('InpEmaSlow nel blocco: atteso solo come asse')
        out.append(l)
    return out


def tab_ancore(anc, L, emas, campi=True):
    r = []
    r.append('#       EmaSlow finestra  Trades  Profit     PF        EqDD %%   PeggGiorn %%'.replace('%%', '%'))
    for e in emas:
        for W in ('IS', 'OOS'):
            x = anc[(L, W, e)]
            r.append('#        %3d    %-4s     %3s    %8s   %7s   %7s   %s' % (
                e, W, x['Trades'], x['Profit'], x['Profit Factor'],
                x['Equity DD %'], x['Peggior Giornata %']))
    return r


# ---------------------------------------------------------------------------
BARRA = '# ' + '=' * 74

TESTA_R262 = r"""
#  >>> LA DOMANDA, UNA SOLA
#  R245 (24/09, report/REFERTO_R245_2026-09-24.md) ha GIA' esteso l'asse
#  InpEmaSlow a 220/240/260 e ha trovato: altopiano 160-260 (6 valori su
#  7), centro 200 per la regola congelata (pari 200/220, vince il piu'
#  basso), bordo SINISTRO chiuso da una misura (140 cade su n IS 147),
#  bordo DESTRO ANCORA APERTO (260 passa). R262 chiede SOLO: DOVE FINISCE
#  L'ALTOPIANO A DESTRA? Asse 160..320 passo 20 (9 celle), per ognuno dei
#  quattro InpTP1_R delle 11 celle buone, sullo stesso banco di R245.
#  >>> NOTA PER CHI HA SCRITTO LA RICHIESTA: il "R262 = 220/240/260" del
#      referto CHI_E_PIU_VICINO_AL_CAMPO (24/09 mattina) E' GIA' GIRATO come
#      R245 alle 15:09 dello stesso giorno. Rifarlo sarebbe un duplicato.
#      Qui si fa il ramo "se l'altopiano lo richiede, 280/300": lo richiede.
#  >>> Non promuove niente. Non tocca taglie, preset, sedie o conti.
#  >>> GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ (firma del 21/09).
#      MAI sul VPS, MAI sul banco 50504400 (C:\MT5_Backtest), MAI su un
#      terminale di conto (50503392, 50504263, 10105439, 541452707 FTMO).
#
""" + BARRA + r"""
#  1. QUALE EA -- ABTG_Nasdaq_Apertura_US, NON ABTG_Dow_Apertura_US
""" + BARRA + r"""
#  L'archivio del 770201 l'ha prodotto dow_apertura.ps1 r.37:
#  $EA="ABTG_Nasdaq_Apertura_US" (R245a par. 1: chiuso dal lanciatore e
#  dal magic 770201 = ABTG_DEF_MAGIC r.38 di QUESTO sorgente). La sedia che
#  vola (770202) e' un ALTRO EA (ABTG_Dow_Apertura_US, RETEST 35', long).
#  Il controllo del file si fa quindi con --ea ABTG_Nasdaq_Apertura_US.mq5
#  (riga '# EA:' in fondo): controllarlo contro ABTG_Dow_Apertura_US.mq5
#  vorrebbe dire misurare 98 pin contro un sorgente da 81 input.
#  BINARIO: git diff f489a621 HEAD (26/09, HEAD 75a70f23) su
#  mql5/Experts/ABTG_Nasdaq_Apertura_US.mq5 e mql5/Include/
#  ABTG_PausaGuardian.mqh = VUOTO. SHA256 a HEAD:
#    ABTG_Nasdaq_Apertura_US.mq5  7f243cac18ec5c955c1df5b8f0ce0cb2af564adaf2b88e3a8f79f798c59af744
#    ABTG_PausaGuardian.mqh       3ec971152e85e0082488cc4243ff45ae09948c191d52ab96050b48f94641a737
#  Classe 166: dopo ogni job SHA256 contro questi; diverso = file NULLO.
#
""" + BARRA + r"""
#  2. FINESTRE, MODELLO, BANCO -- quelli del walk-forward originale
""" + BARRA + r"""
#  Walk-forward originale: backtest_pipeline/dow_apertura.ps1, fase
#  "walkforward", r.250-253: IS 2024.09.26 -> 2025.06.30, OOS 2025.07.01
#  -> 2026.06.30 (al commit 511cc977 l'IS era scritto 2024.01.01, ma lo
#  storico BCM di U30USD PARTE dal 2024.09.26: R245a par. 3). Modello:
#  Model=4 = TICK REALI (r.269; i CSV d'archivio NON hanno una colonna
#  modello: il modello si legge nel lanciatore). Deposit=10000 (r.275).
#  Qui: @DAQUANDO 2024.09.26 @FINOA 2026.06.30 @FRAZIONEIS 0.4322 =
#  IDENTICO a R245 (642 giorni x 0,4322 = 277 -> gamba IS fino al
#  2025.06.30, R245a par. 3). Stesse date al giorno di R245.
#  >>> VINCOLI DELLA RIGA (non imponibili dal file, classe 692):
#   -Deposito 10000 (= R245 = archivio; NON 100000: l'ancora G0 e' a
#    10000), -Modello 4, -Spread NON passato, niente -FrazioneIS,
#    PC DI BACKTEST DESKTOP-H4D7CAJ.
#  >>> OROLOGIO: A ORA FISSA, E VA DETTO. I CSV d'archivio hanno
#   InpSessionHour=14 e InpSessionMin=30 su 80 righe su 80: il walk-
#   forward era a 14:30 BCM TUTTO L'ANNO. BCM sugli indici e' UTC+1 fisso
#   (report/OROLOGIO_BCM_2026-09-24.md): 14:30 BCM = 9:30 EDT d'estate USA
#   (la cash) ma 8:30 EST d'inverno USA (UN'ORA PRIMA della cash, sui dati
#   delle 8:30 ET). R262 resta a ora fissa APPOSTA: e' la condizione per
#   riprodurre R245/l'archivio (G0). La versione IN FASE e' il PASSO DOPO
#   e NON e' scritta qui. Per la CELLA CENTRALE la domanda "orologio o
#   stagione" ce l'ha gia' R250 (prove/R250a-f, scritti e con PASS, NON
#   girati): e' lui il primo round in fase da lanciare, non una copia di
#   R262. Una versione in fase dell'ASSE (coppie 14:30/15:30 ricomposte
#   dal per-trade come prove/R255a par. 6-7) ha senso SOLO dopo R250.
#
""" + BARRA + r"""
#  3. L'ANCORA G0 -- AL CENTESIMO, contro R245 (stesso binario)
""" + BARRA + r"""
#  L'asse parte da 160, non da 280, APPOSTA: le celle 160..260 sono gia'
#  misurate da R245 SULLO STESSO BINARIO (diff vuoto, par. 1), stesso PC,
#  stesso deposito, stesse date. Devono tornare ALLA CIFRA.
#  LE ANCORE DI QUESTO FILE (R245, InpTP1_R di questo file; lette dal CSV
#  dal generatore, non ricopiate):
@@ANCORE@@
#  (fonte: backtest_pipeline/risultati_archivio/R245/ROUND_R245@@L@@/*.csv)
#  TRE ESITI, congelati ora (confronto sulle stringhe del CSV):
#   G0-VERDE: nelle 12 celle d'ancora di questo file (6 EmaSlow x IS/OOS)
#     Trades IDENTICO e Profit, PF, Equity DD %, Peggior Giornata % uguali
#     ALLA CIFRA stampata. Sui 4 file = 48 celle. -> R245 e R262 si leggono
#     INSIEME.
#   G0-GIALLO: Trades identico in 48/48, qualche cifra di soldi diversa
#     (cause possibili NON di codice: revisione dello storico tick o del
#     cambio EURUSD sul PC di backtest). -> R262 si legge SOLO al suo
#     interno (160..320 tutto da questa corsa): e' per questo che l'asse
#     parte da 160 e non da 280 (con 280..320 soli un GIALLO lascerebbe il
#     blocco a meta' fra due corse; R245 ha misurato una deriva di soldi
#     fino a 0,023 di PF e 1,7 punti di DD, e TP 0,84 a 160 passa l'IS di
#     soli 0,018: il blocco si sarebbe potuto spostare per deriva).
#   G0-ROSSO: Trades diverso anche in UNA sola cella d'ancora. -> prima il
#     perche', poi la lettura; nessuna selezione finche' non e' scritto.
#  E L'ARCHIVIO DEL 05/08 (dow_walkforward_{IS,OOS}.csv) NON E' L'ANCORA,
#  ed e' MISURATO che non lo puo' essere: la cella EmaSlow 200 / TP 0,50
#  d'archivio vale IS PF 1,25785 n 154 DD 6,6643 Profit 1114,76 e OOS PF
#  1,51158 n 197 DD 5,4638 Profit 2582,59; R245 sullo stesso input ha dato
#  IS 1,25176 / 154 / 7,1002 / 1180,94 e OOS 1,48894 / 197 / 6,8640 /
#  2961,61. n identico in 32/32 ancore, soldi fuori in 32/32: G0 GIALLO di
#  R245 (REFERTO_R245 par. 1), causa indiziata CalcLotByRisk r.2045
#  (OrderCalcProfit, commit 3af47ed9 dell'08/08). Chiedere "l'archivio al
#  centesimo" oggi vorrebbe dire chiedere un ROSSO sicuro: l'ancora al
#  centesimo e' R245, che e' il binario che verrebbe schierato. Quella
#  della cella 200 / TP 0,50 sta nella tabella G0 di R262b (IS 154 /
#  1180.94 / 1.25176 / 7.1002 / -1.1046 ; OOS 197 / 2961.61 / 1.48894 /
#  6.8640 / -1.1958).
#
""" + BARRA + r"""
#  4. n IN POSIZIONI, E IL SEME DELL'EMA IN IS
""" + BARRA + r"""
#  InpTP1_ClosePct=0 (pin): un deal di uscita per posizione, Trades =
#  POSIZIONI (R245a par. 5, verificato; n invariante sulle 4 TP in R245
#  48 celle su 48). Il pavimento n >= 150 si applica com'e'.
#  SEME: prima del 2024.09.26 BCM non ha barre, quindi nell'IS l'EMA H4
#  parte senza storia e nei primi giorni il bias vale 0 -> due pendenti
#  in OCO (il filtro TACE). MISURATO da R245 par. 4 col residuo
#  n(lungo) + n(corto) - n(due lati): IS 5/5/7/11/11/13/14 da 140 a 260,
#  OOS 0 in 7/7. Oltre 260 [DERIVATO lineare, +1 ogni 20 da 200-260]:
#  ~15 / ~16 / ~17 giornate a 280 / 300 / 320, cioe' ~10-11% delle ~160
#  posizioni IS. IL SEME RENDE LE CELLE IS PIU' SIMILI FRA LORO: spinge
#  verso H1. Quindi un "passa" IS a 280-320 e' una prova PIU' DEBOLE di un
#  "passa" a 200; l'OOS (9 mesi di storia davanti) e' pulito ed e' li'
#  che una chiusura dell'altopiano si vedrebbe davvero.
#  Si FERMA a 320 per questo: oltre, l'IS diventa sempre piu' "due lati
#  senza filtro" e smette di misurare il filtro che si sta tarando.
#
""" + BARRA + r"""
#  5. L'ATTESA, SCRITTA PRIMA DEI NUMERI -- e il contro-esempio
""" + BARRA + r"""
#  Quello che R245 dice gia' (stesso binario, 160..260):
#   - TP 0,50: PF IS 1,297/1,313/1,252/1,259/1,265/1,291, OOS 1,315/
#     1,343/1,489/1,481/1,479/1,488; DD 6,4-8,2%; n IS 153-158, OOS 197-201.
#   - TP 0,84 cade sull'IS da 200 in su (1,039-1,063); TP 0,33 cade sul DD
#     OOS a 160/180 (10,40%). Ogni valore 160-260 passa 3 TP su 4.
#   - l'OOS ha uno SCALINO fra 180 e 200 (1,34 -> 1,49 a TP 0,50) e poi e'
#     PIATTO fino a 260 (1,479-1,489).
#  H1 "l'altopiano continua" -- predice su 280/300/320, per ogni TP:
#     n IS 158-161 ; n OOS 201-204 ; n invariante fra le 4 TP
#     TP 0,33/0,50/0,67: PF IS in [1,20 ; 1,40], PF OOS in [1,40 ; 1,56]
#     TP 0,84: PF IS in [1,00 ; 1,10] (cade come a 200-260), OOS [1,45;1,60]
#     Equity DD % in [5,5 ; 10,0] in tutte e due le finestre (R245 arriva a
#     9,54 a 240/TP 0,84 IS)
#     -> 280, 300, 320 passano 3 TP su 4 ciascuno.
#  H2 "l'altopiano si chiude a destra": a un valore >= 280, almeno DUE
#     delle TP 0,33/0,50/0,67 cadono (PF IS o OOS < 1,10, o DD > 10,00%).
#  LA MIA PREVISIONE, dichiarata: H1, cioe' ALTOPIANO APERTO FINO A 320.
#  Perche': da 200 a 260 l'OOS e' piatto al terzo decimale e l'IS sale
#  (1,252 -> 1,291); il seme (par. 4) spinge l'IS verso l'uguaglianza.
#  >>> IL CONTRO-ESEMPIO CHE MI SONO COSTRUITO CONTRO (classe 178):
#   (a) Con H1 vera, il risultato piu' probabile e' "aperto fino a 320":
#       NESSUN centro nuovo. Il round allora NON serve a spostare la cella:
#       serve a dire che InpEmaSlow e' una manopola QUASI INERTE da 200 a
#       320 (una manopola piatta per un fattore 1,6 non va tarata). E' un
#       risultato, non un fallimento, ma va detto PRIMA che e' il probabile.
#   (b) I CANCELLI NON VEDONO lo scalino OOS: se a 280-320 l'OOS tornasse
#       al livello 160-180 (~1,31-1,34), tutto resterebbe sopra 1,10 e H1
#       "passerebbe", ma la sporgenza 200-260 sarebbe rumore. Si CITA
#       quindi la MEDIANA del blocco, MAI la cella 200 (come R245a par. 8b).
#   (c) Un DD > 10,00% a TP 0,33 da solo NON chiude niente (3 su 4 basta).
#   (d) Le 4 TP hanno le STESSE entrate (classe 742): "3 su 4" misura la
#       robustezza dell'USCITA, non vale come 4 prove.
#
""" + BARRA + r"""
#  6. SOGLIE E SELEZIONE -- la regola di R245a par. 9, CONGELATA li' e
#     riscritta qui senza cambiarne una virgola sul pezzo che serve
""" + BARRA + r"""
#  Per cella, IS E OOS, a rischio 1% (pin):
#   C-a PF >= 1,10   C-b Trades >= 150 (POSIZIONI)   C-c Equity DD % <= 10,00
#  Un valore v di InpEmaSlow PASSA se almeno 3 delle 4 TP (file a-d)
#  passano C-a, C-b, C-c in tutte e due le finestre. Il BLOCCO e' la corsa
#  CONTIGUA di valori che passano e che contiene 180; il bordo SINISTRO
#  resta 140 misurato da R245 (n IS 147 = proprieta' degli ingressi, n e'
#  invariante fra binari e depositi: R245 G0 e R248 G0). Il CENTRO e' il
#  punto medio del blocco; si sceglie il valore di griglia piu' vicino; a
#  PARITA' vince il valore PIU' BASSO. Il centro e' "interno" solo con
#  almeno UN vicino che passa per lato.
#  ESITI POSSIBILI, scritti prima (con 160 e 180 che passano come in R245):
#     280 NON passa          -> blocco 160-260 -> punto medio 210 -> pari
#                               200/220 -> 200 : CENTRO 200, altopiano
#                               CHIUSO da tutte e due le parti (R245
#                               confermato, e il bordo destro diventa una
#                               misura).
#     280 si', 300 no        -> blocco 160-280 -> 220.
#     300 si', 320 no        -> blocco 160-300 -> 230 -> pari 220/240 -> 220.
#     320 PASSA              -> blocco 160-320 APERTO A DESTRA ->
#                               >>> SELEZIONE NON POSSIBILE su questo asse:
#                               la regola "centro dell'altopiano" non ha un
#                               referente, e l'asse NON si estende oltre
#                               (par. 4, seme). Si scrive: "nessun centro;
#                               InpEmaSlow quasi inerte in 160-320". La
#                               bozza FTMO resta a 200 con l'etichetta
#                               "VALORE INTERNO a un altopiano aperto, NON
#                               centro", e nessuno puo' citarlo come centro.
#     un buco (es. 280 no, 300 si') -> il blocco e' la corsa contigua che
#                               contiene 180; il valore isolato si scrive
#                               a parte e NON entra.
#     160 o 180 NON passano (solo con G0 non verde) -> si rifa' il blocco
#                               su R262 da solo e si scrive perche'.
#  E' MEGLIO DEL DEFAULT? Il default e' 200 (default COMPILATO, r.240 del
#  sorgente, e centro di R245). Regola A9 di casa: un vantaggio < 0,10 di
#  PF su una cella non e' un vantaggio. Se il centro si sposta a 220/240,
#  e' "migliore nel merito" SOLO se la mediana del PF OOS delle TP 0,50 e
#  0,67 al nuovo centro supera quella a 200 di >= 0,10. Atteso: NO (R245:
#  1,489/1,442 a 200 contro 1,481/1,454 a 220). Allora si scrive: "il 200
#  va bene; lo spostamento e' solo di REGOLA". Ed e' un risultato.
#
""" + BARRA + r"""
#  7. IL COSTO (cancello C-d) -- ricopiato con la fonte, NON rifatto
""" + BARRA + r"""
#  stop BREAKOUT = range(15') + 2 x buffer = 119,75 + 4,00 = 123,75 punti
#  indice (range mediano [MISURATO, n=446] su risultati_archivio/
#  studio_apertura/Studio_U30USD.csv; buffer 200 pt letto nel CSV).
#  Spread U30USD all'ora 14 BCM: 3,00 (logger vivo, prudente) / 2,00
#  (archivio tick). stop/spread = 41,3x prudente, 61,9x all'archivio,
#  contro il pavimento 40x. FONTE: report/CHI_E_PIU_VICINO_AL_CAMPO_
#  2026-09-24.md par. 3.1-B; rifatto sul file grezzo in R245a par. 6
#  (41,25x) che aggiunge: 212 giornate su 446 (47,5%) hanno lo stop sotto
#  120,0 idx, cioe' sotto 40x a spread 3,00. AL PELO sulla mediana.
#  R262 non tocca lo stop (nessuna manopola dello stop si muove).
#
""" + BARRA + r"""
#  8. IL TEMPO MACCHINA -- col numero MISURATO su questo EA
""" + BARRA + r"""
#  Lo 0,085 min/passata del referto CHI_E_PIU_VICINO NON e' una misura:
#  e' l'uscita di una formula tarata su un altro EA (R245a par. 10, lo
#  dimostra). La misura su QUESTO EA, QUESTO simbolo, QUESTA finestra, a
#  tick reali, sul PC di backtest: R245 = 6 file, 84 passate, 28 minuti
#  (15:09-15:37, RIEPILOGO_R245.txt) = 0,333 min/passata = 4,67 min per
#  file da 14 passate.
#  R262: 4 file x 9 celle x 2 finestre = 72 passate -> ~24 min (4 x ~6,0).
#  Tetto 40 min; oltre 60 la corsa si FERMA e si guarda perche'.
#
""" + BARRA + r"""
#  9. COSA R262 NON CAMBIA -- e perche' NON e' il primo round da lanciare
""" + BARRA + r"""
#  Nessun esito di R262 rende il candidato schierabile. Le cose che lo
#  fermano, per nome, e nessuna dipende da InpEmaSlow:
#   1. R248 (report/REFERTO_R248_2026-09-25.md): nella finestra vergine
#      01/07-18/09/2026 il centro ha fatto DD 8,38% a 1%, sopra il p95
#      (7,31%) della sua promessa: ramo "REVISIONE PRIMA DI QUALUNQUE
#      SCHIERAMENTO, ne' al posto ne' accanto a 770202, finche' la causa
#      non e' scritta". Causa [NON SEPARATA] fra sfortuna e regime
#      (report/R245_IL_DD_DELLA_FINESTRA_VERGINE_2026-09-25.md).
#   2. IL MERITO E' D'INVERNO (report/IL_MERITO_E_D_INVERNO_2026-09-25.md):
#      estate PF 0,982 su 199 posizioni, inverno 1,800 su 152, il 102% del
#      netto e' invernale, cioe' quando 14:30 BCM = 8:30 ET (pre-mercato).
#      Su FTMO un preset a 16:30 FTMO arma alle 9:30 NY = la cella ESTIVA.
#      Lo misura R250 (scritto, non girato).
#   3. LA TAGLIA: a 2% il DD della cella centrale e' ~12-14% [DERIVATO
#      lineare, classe 547], sopra il muro statico FTMO 10%. La misura e'
#      R263. La firma e' di Claudio.
#   4. SOVRAPPOSIZIONE con 770202 (REFERTO_R247): stessa giornata nel 96%
#      dei giorni di 770202, stesso verso 91 su 92: "PARZIALE".
#   5. Griglia H4 di FTMO sfasata di 2 ore: [NON MISURATO].
#  PRIORITA' PROPOSTA (decide Claudio): R250 -> R263g -> R262 -> R263a-d.
#
""" + BARRA + r"""
#  10. I BUCHI, DICHIARATI
""" + BARRA + r"""
#   1. Il seme in IS a 280-320 e' [DERIVATO], non misurato: R262 NON ha i
#      file per lato (costerebbero altri 2 file, ~12 min). Se il blocco
#      arriva a 320 e serve il numero, si scrivono dopo.
#   2. Un solo simbolo, un broker, 21 mesi, OOS in un regime solo (toro):
#      Emendamento C. La finestra vergine (R248) e' la sola prova in piu'.
#   3. Ora fissa: vale tutto il par. 2. Nessun numero di R262 descrive la
#      sedia su FTMO.
#   4. Il tempo per file a 18 passate e' [NON MISURATO]: R245 ne aveva 14.
#
#  QUESTO ROUND NON PROMUOVE, NON ARCHIVIA, NON TOCCA TAGLIE NE' SEDIE.
"""

TESTA_R263 = r"""
#  >>> LA DOMANDA, UNA SOLA
#  A che drawdown arriva DAVVERO il candidato 770201 alla taglia che vola
#  sulla challenge FTMO (2,00%, firma di Claudio del 20/09 per le SEDIE IN
#  CAMPO), misurato dal tester e NON riscalato dall'1%? Oggi il numero e'
#  solo [DERIVATO lineare, classe 547]: "a 2% ~12-14%, sopra il muro 10%"
#  (CHI_E_PIU_VICINO par. 3.1-C, REFERTO_R245 par. 6, REFERTO_R247 (b)).
#  Il riscalamento lineare ignora due cose che il tester invece fa:
#  (i) il lotto si calcola sul SALDO (capitale composto), (ii) il lotto si
#  arrotonda al passo e sbatte sul tetto SYMBOL_VOLUME_MAX.
#  >>> UNA CORSA A 2% NON E' UNA PROPOSTA DI TAGLIA. E' una misura, e resta
#      tale solo finche' nessuno la legge come un permesso. La taglia e' di
#      Claudio. Nessuna riga di questo round tocca preset, sedie o conti.
#  >>> GIRA SOLO SUL PC DI BACKTEST DESKTOP-H4D7CAJ. MAI sul VPS, MAI sul
#      banco 50504400 (C:\MT5_Backtest), MAI su un terminale di conto
#      (50503392, 50504263, 10105439, 541452707 FTMO).
#
""" + BARRA + r"""
#  1. IL DISEGNO: 7 FILE, UNA VARIABILE PER FILE
""" + BARRA + r"""
#   file   cosa                                   asse                 magic
#   R263a  TP 0,33 a rischio 2%                   InpEmaSlow 160..260  766401
#   R263b  TP 0,50 a rischio 2%                   InpEmaSlow 160..260  766402
#   R263c  TP 0,67 a rischio 2%                   InpEmaSlow 160..260  766403
#   R263d  TP 0,84 a rischio 2%                   InpEmaSlow 160..260  766404
#   R263e  PER-TRADE centro @@CE@@/@@CT@@, tranche IS, 2%      InpMagic gemelle     766411/766412
#   R263f  PER-TRADE centro @@CE@@/@@CT@@, finestre R245b, 2%  InpMagic gemelle     766413/766414
#   R263g  centro @@CE@@/@@CT@@, CURVA DD(taglia)              InpRiskPercent 1..2  766421
#  a-d = le 24 celle del blocco 160-260 di R245 (tutte e 11 le "celle
#  buone" del referto CHI_E_PIU_VICINO + le colonne 220/240/260 di R245)
#  alla taglia di campo: e' il numero "quante celle stanno sotto il muro a
#  2%" MISURATO. Le colonne 280-320 di R262 NON ci sono: servono solo se
#  R262 allarga il blocco, e allora si aggiunge un file (buco 1).
#  PERCHE' IL PER-TRADE SOLO SUL CENTRO: il per-trade e' UNO per magic
#  (classe 455): in un file con asse EmaSlow sopravvive solo quello
#  dell'ultima cella. Per averlo su 24 celle servirebbero 48 file. Il CSV
#  di ottimizzazione da' GIA' Equity DD % e Peggior Giornata % misurati per
#  cella: e' quella la misura del DD a 2%. Il per-trade (e/f) serve alla
#  sola cella che andrebbe in campo: DD a saldo chiuso giorno per giorno,
#  peggior giornata chiusa, e QUANTE posizioni sbattono sul tetto di lotto.
#  R263g: la stessa cella, cinque taglie. E' la CURVA che Claudio usa per
#  firmare (a quale taglia il DD misurato tocca il 10%), e porta l'unica
#  ANCORA NUMERICA a deposito 100000 che esiste (par. 3).
#
""" + BARRA + r"""
#  2. IL BANCO -- DEPOSITO 100000, e perche'
""" + BARRA + r"""
#  >>> VINCOLI DELLA RIGA (classe 692): -Deposito 100000 (NON 10000 come
#   R245/R262: e' la taglia del conto FTMO 541452707, challenge 100k),
#   -Modello 4 (tick reali), -Spread NON passato, niente -FrazioneIS,
#   PC DI BACKTEST DESKTOP-H4D7CAJ. R262 e R263 sono quindi DUE RIGHE
#   DIVERSE (deposito diverso).
#  PERCHE' 100000: a 10000 il lotto a passo 0,1 si arrotonda in basso e
#  d'estate ogni uscita pesa ~6,6% in meno (MISURATO in report/R245_IL_DD_
#  DELLA_FINESTRA_VERGINE_2026-09-25.md par. 2: frazione di lotto 0,934 a
#  10.000, 0,991 a 100.000). Sulla stessa cella a 1%: Equity DD OOS 6,8640%
#  a 10000 (R245b) contro 7,0104% a 100000 (R248a gamba IS) = x1,021.
#  VALUTA: il tester gira in EUR (banco di casa). Il conto FTMO e' in EUR
#  [INFERITO da report/SCHIERAMENTO_FTMO_2026-09-20.md r.391: margine
#  GER40.cash in EUR senza cambio]. U30USD e' in USD: ogni P/L passa dal
#  cambio, come in campo.
#  IL TETTO DEL LOTTO: SYMBOL_VOLUME_MAX di U30USD su BCM = 100 (dichiarato
#  in report/PIANO_PROP.md r.926, analisi dial par. avvertenza (a); R109 ha
#  misurato il taglio su NASUSD: 66 trade su 743). Nel per-trade di R247 a
#  1%/10000 le posizioni con volume > 5,0 lotti sono 3 su 154 (IS) e 4 su
#  197 (OOS); > 4,0 lotti 7 e 8. A 2%/100000 il lotto e' ~20 volte quello
#  (piu' il saldo che cresce piu' in fretta): [DERIVATO] fra 3 e 7 (IS) e
#  fra 4 e 8 (OOS) posizioni sbattono sul tetto di 100 e rischiano MENO
#  del 2%. Su FTMO (US30.cash) il tetto e' [NON MISURATO].
#  IL MARGINE: con lotto <= 100 e U30USD ~44.000 [ordine di grandezza] il
#  nozionale e' ~4,4 milioni USD (~3,8 milioni EUR); a leva 1:100 ~38.000
#  EUR di margine su 100.000: sotto. Ma
#  il tasso di margine del simbolo nel tester e' [NON MISURATO]: se fosse
#  piu' alto un ordine potrebbe essere RIFIUTATO ("not enough money") e n
#  scendere. Per questo il G0 su n e' a una via (par. 3).
#
""" + BARRA + r"""
#  3. I CANCELLI, CONGELATI PRIMA DEI NUMERI -- si guardano PER PRIMI
""" + BARRA + r"""
#  P0 PIN (classe 780): in ogni riga di ogni CSV la colonna InpRiskPercent
#     vale 2 (a-f) o il valore dell'asse (g), InpEmaSlow e InpTP1_R quelli
#     del file. E' il cancello che vede un "2%" non arrivato: se il pin non
#     morde il tester gira al default compilato ABTG_DEF_RISK = 2.0 (r.47)
#     -- che qui COINCIDE col valore voluto, quindi P0 si legge per a-f
#     insieme a G0-SOLDI qui sotto, e per g e' decisivo.
#  G0-n (a-d, e, f): Trades di ogni cella <= Trades della stessa cella
#     (EmaSlow, TP, finestra) in R245. VERDE = uguale in tutte. Un DEFICIT
#     e' ammesso SOLO se il log del tester porta altrettanti rifiuti
#     ("not enough money" / "no money"): allora si scrive "la taglia 2%
#     non e' eseguibile in quelle giornate" (ed e' un risultato). Un
#     ECCESSO, o un deficit senza rifiuti, = ROSSO. Le ancore n (R245):
@@NANC@@
#  G0-SOLDI (g, l'unica ancora numerica a 100000 che esiste): la cella
#     InpRiskPercent=1.00, gamba OOS (2025.07.01 -> 2026.06.30), deve
#     riprodurre ALLA CIFRA la gamba IS di R248a (stessi FromDate/ToDate,
#     stesso deposito 100000, stesso binario 4d142cbb = HEAD):
#        Trades @@A48_T@@   Profit @@A48_P@@   PF @@A48_PF@@   Equity DD % @@A48_DD@@
#        Peggior Giornata % @@A48_PG@@
#     (fonte: risultati_archivio/R248/ROUND_R248a/*_IS_R248a.csv, 2 righe
#     gemelle identiche). VERDE = alla cifra. GIALLO = Trades uguale e
#     soldi diversi (revisione dati sul PC: allora TUTTO R263 si legge al
#     suo interno). ROSSO = Trades diverso.
#  G1-INCROCIATO (gratis, esatto per codice: il magic in tester lo legge
#     solo la guardia A4, che vede solo i deal della passata):
#     cella 2.00 di R263g == cella @@CE@@ di R263@@LC@@, IS e OOS, alla cifra;
#     CSV di R263e (gamba IS) e di R263f (gamba OOS) == la stessa cella.
#     Tre corse, stessi input: diverso = il banco non e' deterministico
#     e NESSUN numero di R263 si legge.
#  G1 gemelle (e, f): le due righe del CSV identiche; i due per-trade
#     identici riga per riga salvo la colonna magic.
#  G0-STRUTTURA (e, f): il per-trade a 2% ha le STESSE posizioni del
#     per-trade a 1% di R247 (risultati_archivio/R247/PERTRADE/
#     abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_765271.csv per e,
#     _765273.csv per f): close_time, deal_type e price IDENTICI riga per
#     riga (volume e net_profit NO: taglia e deposito diversi). Stop, TP e
#     trailing non dipendono dal lotto. Una riga in piu' = ROSSO; una riga
#     in meno solo con un rifiuto nel log (G0-n).
#     >>> Lo strumento che fa QUESTO confronto riga per riga NON ESISTE in
#     repo (r247_sovrapposizione.py fa G0 contro il CSV e la parte (b),
#     non il confronto fra due per-trade): sono ~20 righe di Python di
#     sola lettura da scrivere PRIMA di leggere e/f. Buco dichiarato.
#  C0 PER-TRADE (e, f): quattro file abtg_trades_ABTG_Nasdaq_Apertura_US_
#     U30USD_7664{11,12,13,14}.csv da %APPDATA%\MetaQuotes\Terminal\Common\
#     Files, LastWriteTime >= inizio corsa (un file vecchio non vale), e la
#     riga deve DIRE A VOCE quanti ne ha trovati su 4 (classe 754).
#     I per-trade di a-d e g NON si leggono (un magic per file con un asse
#     di parametro: resta solo l'ultima cella, classe 455).
#
""" + BARRA + r"""
#  4. L'ATTESA, SCRITTA PRIMA DEI NUMERI -- con la banda e il contro-esempio
""" + BARRA + r"""
#  IL CONTO (e' una DERIVAZIONE, la scrivo per poterla smentire):
#   (i)  capitale composto: una serie che a 1% fa DD d1 = 1 - 0,99^k, a
#        2% fa 1 - 0,98^k, non 2 x d1. A d1 = 7% il rapporto e' 0,969; a
#        d1 = 10,4% e' 0,950. Fattore g in [0,95 ; 0,97].
#   (ii) deposito 10000 -> 100000: x1,021 MISURATO sulla cella centrale
#        OOS a 1% (par. 2); d'estate fino a x1,06 (lotto 0,934 -> 0,991).
#        Fattore in [1,00 ; 1,06].
#   (iii) tetto di 100 lotti: puo' solo ABBASSARE il DD. Fattore <= 1.
#  ==> DD misurato(2%, 100000) = DD R245(1%, 10000) x [1,80 ; 2,10].
#  PER CELLA (a-d): banda = Equity DD % della stessa cella in R245 (sono
#  le tabelle d'ancora di R262a-d, stesso CSV) x [1,80 ; 2,10]; non la
#  ricopio qui per non avere due copie. Il DD 1% piu' BASSO fra le 24
#  celle, preso come il
#  peggiore delle due finestre, e' 6,8354% (EmaSlow 260 / TP 0,50, IS):
#  x 1,80 = 12,30%. ==> ATTESA: 0 CELLE SU 24 sotto il muro statico del
#  10% a 2%, in tutte e due le finestre. Peggior Giornata a 2%: ~2 x
#  (-1,08 ; -1,20) = da -2,0 a -2,5%: DENTRO il muro giornaliero del 5%.
#  PER-TRADE (e/f): DD a saldo chiuso di R247 a 1%/10000 = 6,38% (IS) e
#  5,94% (OOS) (REFERTO_R247 (b)) -> a 2%/100000 in [11,5 ; 13,4] (IS) e
#  [10,7 ; 12,5] (OOS). Posizioni al tetto di 100 lotti: IS 3-7, OOS 4-8.
#  CURVA (g), per finestra, DD(r) = DD(1%, 100000) x r x g(r):
#     OOS, DD(1%) = 7,0104 (ancora):  1,25 -> ~8,7 ; 1,50 -> ~10,3 ;
#                                     1,75 -> ~11,9 ; 2,00 -> ~13,5
#     IS,  DD(1%) ~7,25 [DERIVATO 7,1002 x 1,021, NON MISURATO a 100000]:
#                                     1,25 -> ~9,0 ; 1,50 -> ~10,6 ;
#                                     1,75 -> ~12,3 ; 2,00 -> ~13,9
#  ==> ATTESA: 1,00 e 1,25 SOTTO il 10% in tutte e due le finestre; 1,75 e
#  2,00 SOPRA; 1,50 [NON RISOLTO a priori] (la banda lo mette a cavallo).
#  Il muro cade fra 1,25 e 1,50 (lineare: 1,38 IS / 1,43 OOS).
#  >>> IL CONTRO-ESEMPIO (classe 178): che cosa produrrebbe l'ALTRA
#      spiegazione, cioe' "il 2% del tester non e' il 2%"? Se il pin
#      InpRiskPercent non arrivasse, a-f girerebbero al default compilato
#      2.0 (r.47): STESSO numero, invisibile. Per questo il G0-SOLDI sta
#      su R263g, dove la cella 1.00 E' diversa dal default: se g esce
#      piatto su tutto l'asse (DD uguale da 1,00 a 2,00) il pin non morde
#      e R263 e' NULLO. E se una cella di a-d esce SOTTO il 10%, la prima
#      ipotesi da escludere non e' "il motore regge": e' il tetto di lotto
#      o un pin, da leggere nel per-trade e in P0. Serve un rapporto
#      < 1,46 sulla cella migliore: fuori banda di quasi il 20%.
#
""" + BARRA + r"""
#  5. LE SOGLIE -- LEGGONO il rischio, NON promuovono
""" + BARRA + r"""
#   C-c MURO STATICO FTMO: Equity DD % <= 10,00, IS E OOS, a 2%.
#   MURO GIORNALIERO FTMO (informativo, a qualunque n, Emendamento B):
#   Peggior Giornata % >= -5,00. E sul per-trade (e/f) la peggior giornata
#   a SALDO CHIUSO dallo script r247_sovrapposizione.py parte (b) con
#   --deposito-nuovo 100000 (la chiusura del giorno e' un MINORANTE del
#   flottante intraday).
#   Il MERITO non si rilegge qui: PF e n a 2% sono gli stessi ingressi di
#   R245 (G0-n); il PF puo' spostarsi solo per il peso dei lotti.
#  Qualunque esito: "a 2% il candidato sta / non sta sotto il muro, con
#  questo numero". NIENTE DI PIU'. La taglia e' una firma di Claudio.
#
""" + BARRA + r"""
#  6. OROLOGIO -- A ORA FISSA 14:30 BCM, come R245 e l'archivio
""" + BARRA + r"""
#  Stesso discorso di R262a par. 2: il walk-forward era a 14:30 BCM tutto
#  l'anno (CSV d'archivio, 80/80 righe); d'inverno USA 14:30 BCM = 8:30
#  ET. R263 resta a ora fissa per legarsi alle ancore (R245, R247, R248).
#  Il DD IN FASE (coppie 14:30/15:30 ricomposte dal per-trade come
#  prove/R255a par. 6-7) e' il passo dopo, e ha senso solo dopo R250.
#
""" + BARRA + r"""
#  7. IL TEMPO MACCHINA -- ritmi MISURATI su questo EA
""" + BARRA + r"""
#   R263a-d: 4 file x 6 celle x 2 finestre = 48 passate; al ritmo di R245
#            (28 min / 84 passate = 0,333 min/passata; 4,67 min per file
#            da 14) -> ~16 min.
#   R263e/f: 2 file x 2 gemelle x 2 gambe (una degenere in e) = 8
#            passate; R247 (stesso disegno, stessa cella) = 3 min per 2
#            file; R248 = 4 min -> ~3-4 min.
#   R263g:   1 file x 5 celle x 2 finestre = 10 passate -> ~4 min.
#   TOTALE R263 ~24 min (tetto 40; oltre 60 si ferma e si guarda).
#
""" + BARRA + r"""
#  8. I BUCHI, DICHIARATI
""" + BARRA + r"""
#   1. Colonne 280-320: se R262 allarga il blocco, serve un R263h (stesso
#      disegno di a-d, asse 280..320, ~4 file). NON scritto.
#   2. Il confronto per-trade riga per riga (G0-STRUTTURA): strumento da
#      scrivere (par. 3).
#   3. SYMBOL_VOLUME_MAX e tasso di margine di US30.cash su FTMO: [NON
#      MISURATI]. Il tester misura il tetto BCM (100).
#   4. Slippage: il tester non lo fa; a 20-100 lotti sullo stop d'apertura
#      R109 ha misurato 21,5 punti su uno stop Nasdaq reale: il DD vero puo'
#      essere PIU' profondo di quello misurato qui.
#   5. Ora fissa (par. 6): nessun numero di R263 descrive FTMO a 16:30.
#   6. Il Guardian (pausa 3,5% / emergenza) non e' nel tester
#      (InpUsaGuardian=0 come R245): a 2% trasformerebbe DD temporanei in
#      perdite chiuse (PIANO_PROP C7 avvertenza (c)). [NON MODELLATO]
#   7. Un simbolo, 21 mesi, un regime per finestra (Emendamento C).
#
#  QUESTO ROUND NON PROMUOVE, NON ARCHIVIA, NON PROPONE TAGLIE, NON TOCCA
#  PRESET NE' SEDIE.
"""


# ---------------------------------------------------------------------------
def intesta(titolo, righe_extra):
    out = [BARRA]
    out += ['#  ' + t for t in titolo]
    out.append(BARRA)
    out += righe_extra
    return out


def scrivi(nome, righe, uscite):
    testo = '\n'.join(righe) + '\n'
    testo.encode('ascii')
    uscite[nome] = testo


def genera(centro_ema, centro_tp):
    base = leggi_base()
    anc = ancore_r245()
    a48 = ancora_r248()
    uscite = {}
    LC = [L for L, tp, _s in TP if tp == centro_tp][0]
    WF = ('2024.09.26', '2026.06.30', '0.4322')

    # ---------------- R262a-d
    for L, tp, sig in TP:
        nome = 'R262%s_emaslow_oltre260_%s_U30USD.txt' % (L, sig)
        tit = ['R262%s -- DOVE FINISCE A DESTRA L\'ALTOPIANO DI InpEmaSlow DEL "770201"' % L,
               'ABTG_Nasdaq_Apertura_US su U30USD M5 -- TICK REALI -- DUE LATI',
               'InpTP1_R = %s -- rischio 1%% -- deposito 10000 -- magic %d' % (tp, MAGIC_R262[L])]
        if L == 'a':
            tit.append("QUESTO E' IL FILE DI TESTA DEL ROUND: qui sta TUTTO il ragionamento.")
            tit.append('R262b-d rimandano qui e portano solo le loro differenze.')
            corpo = TESTA_R262.strip('\n').split('\n')
        else:
            corpo = ['#',
                     '#  >>> TUTTO IL RAGIONAMENTO STA IN R262a (file di testa del round):',
                     '#      domanda, EA, finestre e modello, ancora G0, seme dell\'EMA,',
                     '#      attesa H1/H2 col contro-esempio, soglie, regola di selezione,',
                     '#      costo, tempo, priorita\' e buchi.',
                     '#  Questo file e\' IDENTICO a R262a riga per riga TRANNE DUE PIN:',
                     '#      InpTP1_R = %s   (R262a: 0.33)' % tp,
                     '#      InpMagic = %d  (R262a: %d)' % (MAGIC_R262[L], MAGIC_R262['a']),
                     '#  Con InpTP1_ClosePct=0 InpTP1_R fissa SOLO il TP finale (3 x',
                     '#  InpTP1_R, r.1694): n deve uscire IDENTICO a R262a cella per cella.',
                     '#  LE ANCORE G0 DI QUESTO FILE (R245%s, stesso binario, alla cifra):' % L,
                     '@@ANCORE@@',
                     '#  (fonte: backtest_pipeline/risultati_archivio/R245/ROUND_R245%s/*.csv)' % L,
                     '#  VINCOLI DELLA RIGA: -Deposito 10000, -Modello 4, -Spread non',
                     '#  passato, PC DI BACKTEST DESKTOP-H4D7CAJ (mai il VPS).',
                     '#  TEMPO: ~6 min per questo file (R262a par. 8).',
                     '#']
        tab = tab_ancore(anc, L, [160, 180, 200, 220, 240, 260])
        corpo2 = []
        for r in corpo:
            if r.strip() == '@@ANCORE@@':
                corpo2 += tab
            else:
                corpo2.append(r.replace('@@L@@', L))
        righe = intesta(tit, corpo2)
        righe += ['#  QUESTO FILE NON PROMUOVE, NON ARCHIVIA, NON TOCCA TAGLIE NE\' SEDIE.',
                  '#  EA: ABTG_Nasdaq_Apertura_US', BARRA, '']
        righe += blocco_pin(base, tp, '1', MAGIC_R262[L], WF)
        righe += ["# --- L'ASSE, unico: InpEmaSlow 160..320 passo 20 = 9 celle.",
                  '#     160..260 = ANCORE G0 (R245, stesso binario); 280/300/320 = NUOVE.',
                  '#     Il bordo sinistro 140 e\' gia\' MISURATO da R245 (n IS 147).',
                  'InpEmaSlow=200||160||20||320||Y', BARRA]
        scrivi(nome, righe, uscite)

    # ---------------- R263a-d
    nanc = ['#       EmaSlow   n IS (R245)   n OOS (R245)   [uguali nelle 4 TP]']
    for e in [160, 180, 200, 220, 240, 260]:
        ns = set((anc[(L, 'IS', e)]['Trades'], anc[(L, 'OOS', e)]['Trades']) for L, _t, _s in TP)
        assert len(ns) == 1, (e, ns)
        n_is, n_oos = ns.pop()
        nanc.append('#        %3d        %3s            %3s' % (e, n_is, n_oos))
    rep = {'@@CE@@': centro_ema, '@@CT@@': centro_tp, '@@LC@@': LC,
           '@@A48_T@@': a48['Trades'], '@@A48_P@@': a48['Profit'],
           '@@A48_PF@@': a48['Profit Factor'], '@@A48_DD@@': a48['Equity DD %'],
           '@@A48_PG@@': a48['Peggior Giornata %']}

    def sost(righe):
        out = []
        for r in righe:
            if r.strip() == '@@NANC@@':
                out += nanc
                continue
            for k, v in rep.items():
                r = r.replace(k, v)
            out.append(r)
        return out

    for L, tp, sig in TP:
        nome = 'R263%s_dd2pct_bordo_%s_U30USD.txt' % (L, sig)
        tit = ['R263%s -- IL DD MISURATO A RISCHIO 2%% (NON RISCALATO) DEL "770201"' % L,
               'ABTG_Nasdaq_Apertura_US su U30USD M5 -- TICK REALI -- DUE LATI',
               'InpTP1_R = %s -- InpRiskPercent = 2 -- deposito 100000 -- magic %d' % (tp, MAGIC_R263[L])]
        if L == 'a':
            tit.append("QUESTO E' IL FILE DI TESTA DI R263: qui sta TUTTO il ragionamento")
            tit.append('di R263a-g. Gli altri sei portano solo le loro differenze.')
            corpo = sost(TESTA_R263.strip('\n').split('\n'))
        else:
            corpo = ['#',
                     '#  >>> TUTTO IL RAGIONAMENTO STA IN R263a (file di testa di R263).',
                     '#  Questo file e\' IDENTICO a R263a riga per riga TRANNE DUE PIN:',
                     '#      InpTP1_R = %s   (R263a: 0.33)' % tp,
                     '#      InpMagic = %d  (R263a: %d)' % (MAGIC_R263[L], MAGIC_R263['a']),
                     '#  CONTRO R262%s (stessa TP) cambiano: InpRiskPercent 1 -> 2, il' % L,
                     '#  magic, e l\'asse 160..260 invece di 160..320. E il DEPOSITO della',
                     '#  riga: 100000 qui, 10000 in R262.',
                     '#  ANCORE G0-n e attesa: R263a par. 3-4 (n per EmaSlow uguale nelle 4',
                     '#  TP). Le bande di DD si calcolano dalle ancore EqDD %% di R262%s x' % L,
                     '#  [1,80 ; 2,10] (R263a par. 4). Attesa: 0 celle su 6 sotto il 10%.',
                     '#  VINCOLI DELLA RIGA: -Deposito 100000, -Modello 4, -Spread non',
                     '#  passato, PC DI BACKTEST DESKTOP-H4D7CAJ (mai il VPS).',
                     '#  TEMPO: ~4 min per questo file (R263a par. 7).',
                     '#']
        righe = intesta(tit, corpo)
        righe += ['#  QUESTO FILE NON PROMUOVE, NON PROPONE TAGLIE, NON TOCCA PRESET NE\' SEDIE.',
                  '#  EA: ABTG_Nasdaq_Apertura_US', BARRA, '']
        righe += blocco_pin(base, tp, '2', MAGIC_R263[L], WF)
        righe += ["# --- L'ASSE, unico: InpEmaSlow 160..260 passo 20 = 6 celle = il blocco di",
                  '#     R245 (le 11 celle buone del referto CHI_E_PIU_VICINO + 220/240/260).',
                  'InpEmaSlow=200||160||20||260||Y', BARRA]
        scrivi(nome, righe, uscite)

    # ---------------- R263e / R263f (per-trade del centro)
    for L, (m1, m2), date, cosa in (
            ('e', MAGIC_R263E, ('2024.09.26', '2025.06.30', '1.0'), 'TRANCHE IS'),
            ('f', MAGIC_R263F, WF, 'FINESTRE DI R245b (per-trade = gamba OOS)')):
        nome = 'R263%s_dd2pct_pertrade_centro_%s_U30USD.txt' % (L, 'IS' if L == 'e' else 'OOS')
        tit = ['R263%s -- PER-TRADE A RISCHIO 2%% DELLA CELLA CENTRALE, %s' % (L, cosa),
               'ABTG_Nasdaq_Apertura_US su U30USD M5 -- TICK REALI -- DUE LATI',
               'InpEmaSlow = %s, InpTP1_R = %s, InpRiskPercent = 2 -- deposito 100000' % (centro_ema, centro_tp),
               'magic gemelle %d / %d (asse tecnico: G1 + un per-trade per gemella)' % (m1, m2)]
        if L == 'e':
            spec = ['#  COME ISOLA L\'IS (disegno di R247a par. 3, MISURATO funzionante in',
                    '#  R247: "la gamba degenere non ha sovrascritto niente, 0 righe"):',
                    '#     @DAQUANDO 2024.09.26 @FINOA 2025.06.30 @FRAZIONEIS 1.0',
                    '#     -> gamba IS 2024.09.26 -> 2025.06.30 (= gamba IS di R245b/R263%s)' % LC,
                    '#     -> gamba OOS DEGENERE (FromDate > ToDate): CSV _OOS a 0 byte e',
                    '#        rc 2 del runner ATTESI (come R242a/R247a). Il guasto vero e\' rc 1.',
                    '#  ANCORA STRUTTURA: per-trade R247a 765271 (154 righe, 2024.09.30 ->',
                    '#  2025.06.27). ANCORA CSV: cella %s di R263%s gamba IS (G1-INCROCIATO).' % (centro_ema, LC)]
        else:
            spec = ['#  FINESTRE: IDENTICHE a R245b/R263%s (FRAZIONEIS 0.4322). Il per-trade' % LC,
                    '#  che resta e\' quello della gamba che gira PER SECONDA = OOS 2025.07.01',
                    '#  -> 2026.06.30 (R247a par. 2, misurato su 772505).',
                    '#  ANCORA STRUTTURA: per-trade R247b 765273 (197 righe, 2025.07.01 ->',
                    '#  2026.06.29). ANCORA CSV: cella %s di R263%s, IS e OOS (G1-INCROCIATO).' % (centro_ema, LC)]
        corpo = ['#',
                 '#  >>> IL RAGIONAMENTO, I CANCELLI (P0, G0-n, G1, G0-STRUTTURA, C0) E',
                 '#      L\'ATTESA STANNO IN R263a par. 1-4. Qui solo le differenze.',
                 '#  COSA MISURA: il DD a SALDO CHIUSO giorno per giorno, la peggior',
                 '#  giornata chiusa e le posizioni al TETTO di 100 lotti, a 2%, sulla',
                 '#  sola cella che andrebbe in campo (%s / %s = centro di R245).' % (centro_ema, centro_tp),
                 '#  Lettura: python3 backtest_pipeline/r247_sovrapposizione.py --nuovo',
                 '#  <per-trade>@100000 --deposito-nuovo 100000 (parte (b)); tetto: righe',
                 '#  con volume = 100.00; G0-STRUTTURA con lo strumento da scrivere.',
                 '#  ATTESA (R263a par. 4): DD saldo chiuso %s; al tetto %s posizioni.' % (
                     ('[11,5 ; 13,4] %', '3-7') if L == 'e' else ('[10,7 ; 12,5] %', '4-8')),
                 '#  SE R262 SPOSTA IL CENTRO: questo file si rigenera PRIMA del lancio',
                 '#  con  python3 backtest_pipeline/prove/R262_R263_GENERA.py --centro',
                 '#  <EmaSlow> <TP1_R>  (cambia solo i due pin; le ancore STRUTTURA di',
                 '#  R247 valgono SOLO per 200/0.50: con un altro centro G0-STRUTTURA',
                 '#  non ha ancora e si scrive).'] + spec + [
                 '#  MAGIC: rg "7664[0-9][0-9]" = 0 su disco e su tutti i rami (26/09).',
                 '#  Nuovi e non 765271-4 di R247: il tester ha una cache per passata e',
                 '#  con un magic gia\' usato il per-trade potrebbe non rinascere.',
                 '#  C0: la riga raccoglie abtg_trades_ABTG_Nasdaq_Apertura_US_U30USD_',
                 '#  %d.csv e _%d.csv (LastWriteTime >= inizio corsa).' % (m1, m2),
                 '#  VINCOLI DELLA RIGA: -Deposito 100000, -Modello 4, -Spread non',
                 '#  passato, PC DI BACKTEST DESKTOP-H4D7CAJ (mai il VPS).',
                 '#  TEMPO: ~1,5-2 min (R247: 3 min per 2 file; R248: 4 min).',
                 '#']
        righe = intesta(tit, corpo)
        righe += ['#  QUESTO FILE NON PROMUOVE, NON PROPONE TAGLIE, NON TOCCA PRESET NE\' SEDIE.',
                  '#  EA: ABTG_Nasdaq_Apertura_US', BARRA, '']
        righe += blocco_pin(base, centro_tp, '2', None, date, togli=('InpMagic',))
        righe += ['InpEmaSlow=' + centro_ema,
                  "# --- L'ASSE, unico e TECNICO: le due gemelle sul magic (G1).",
                  'InpMagic=%d||%d||1||%d||Y' % (m1, m1, m2), BARRA]
        scrivi(nome, righe, uscite)

    # ---------------- R263g (curva DD(taglia))
    nome = 'R263g_dd_asse_rischio_centro_U30USD.txt'
    tit = ['R263g -- LA CURVA DD(TAGLIA) DELLA CELLA CENTRALE, MISURATA',
           'ABTG_Nasdaq_Apertura_US su U30USD M5 -- TICK REALI -- DUE LATI',
           'InpEmaSlow = %s, InpTP1_R = %s -- deposito 100000 -- magic %d' % (centro_ema, centro_tp, MAGIC_R263G),
           'ASSE: InpRiskPercent 1,00 / 1,25 / 1,50 / 1,75 / 2,00']
    corpo = ['#',
             '#  >>> IL RAGIONAMENTO, I CANCELLI E L\'ATTESA STANNO IN R263a par. 1-4.',
             '#  COSA MISURA: a quale taglia il DD MISURATO della cella che andrebbe in',
             '#  campo tocca il muro statico del 10%, nelle due finestre. E\' la curva',
             '#  su cui Claudio firma. NON e\' una proposta: nessun valore dell\'asse e\'',
             '#  "consigliato", e il file non ne sceglie nessuno.',
             '#  PERCHE\' SI LEGGE PER PRIMO: porta l\'unica ancora numerica a 100000',
             '#  (cella 1.00, gamba OOS = gamba IS di R248a, alla cifra, R263a par.',
             '#  3 G0-SOLDI) e la prova che il pin del rischio MORDE (contro-esempio',
             '#  di R263a par. 4: un asse piatto = pin non arrivato = R263 NULLO).',
             '#  G1-INCROCIATO: cella 2.00 == cella %s di R263%s (IS e OOS).' % (centro_ema, LC),
             '#  ATTESA (R263a par. 4): 1,00 e 1,25 sotto il 10% in tutte e due le',
             '#  finestre; 1,75 e 2,00 sopra; 1,50 [NON RISOLTO a priori]. Il muro',
             '#  fra 1,25 e 1,50 (lineare 1,38 IS / 1,43 OOS).',
             '#  SE R262 SPOSTA IL CENTRO: si rigenera col generatore (--centro);',
             '#  allora il G0-SOLDI non ha ancora (R248a e\' su 200/0.50) e si scrive.',
             '#  MAGIC: rg "7664[0-9][0-9]" = 0 su disco e su tutti i rami (26/09).',
             '#  VINCOLI DELLA RIGA: -Deposito 100000, -Modello 4, -Spread non',
             '#  passato, PC DI BACKTEST DESKTOP-H4D7CAJ (mai il VPS).',
             '#  TEMPO: ~4 min (R263a par. 7).',
             '#']
    righe = intesta(tit, corpo)
    righe += ['#  QUESTO FILE NON PROMUOVE, NON PROPONE TAGLIE, NON TOCCA PRESET NE\' SEDIE.',
              '#  EA: ABTG_Nasdaq_Apertura_US', BARRA, '']
    righe += blocco_pin(base, centro_tp, None, MAGIC_R263G, WF, togli=('InpRiskPercent',))
    righe += ['InpEmaSlow=' + centro_ema,
              "# --- L'ASSE, unico: InpRiskPercent 1,00..2,00 passo 0,25 = 5 celle.",
              'InpRiskPercent=1.0||1.0||0.25||2.0||Y', BARRA]
    scrivi(nome, righe, uscite)
    return uscite


def main():
    args = sys.argv[1:]
    ce, ct = CENTRO_EMA, CENTRO_TP
    if '--centro' in args:
        i = args.index('--centro')
        ce, ct = args[i + 1], args[i + 2]
        assert ct in [t for _l, t, _s in TP], ct
    uscite = genera(ce, ct)
    if '--verifica' in args:
        ko = 0
        for nome, testo in sorted(uscite.items()):
            p = os.path.join(QUI, nome)
            ok = os.path.exists(p) and open(p, encoding='ascii').read() == testo
            print(('OK   ' if ok else 'DIVERSO ') + nome)
            ko += 0 if ok else 1
        sys.exit(1 if ko else 0)
    for nome, testo in sorted(uscite.items()):
        with open(os.path.join(QUI, nome), 'w', encoding='ascii', newline='\n') as f:
            f.write(testo)
        print('scritto ' + nome)


if __name__ == '__main__':
    main()
