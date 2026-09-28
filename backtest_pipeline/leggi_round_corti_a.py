#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
leggi_round_corti_a.py -- 27/09/2026

LETTORE della raccolta ROUND_CORTI_A_<data> (riga RIGA_ROUND_CORTI_A_R250_R258_R259,
PASS 202505d6). Applica i criteri CONGELATI nei file di testa e stampa un referto in
Markdown da incollare. NON promuove, NON archivia, NON propone taglie.

  R250  testa prove/R250a_orologio_R245_d0_A_U30USD.txt (par. 5-11): PIN dal CSV, G1, G0
        contro R247 (765271/765273 dal pin), G2, S1, S2, zone Q/Q2/Qc (r250_bande_attese),
        conferma A col veto di A+B, rischio (Emendamento B), lati, costo descrittivo, e la
        CURVA IN FASE col metodo di R255 par. 7/9 (R1/R2/R3, verdetto asimmetrico classe 804)
        -- quest'ultima e' [DERIVATA]: la testa R250a par. 9 NON fissa soglie, quindi SEGNALA e non
        boccia mai (classe 885); lo scarto di saldo si stampa scomposto (classe 876).
  R258  testa prove/R258a_londra_T_GBPUSD_ora8_UK_TESTA.txt par. 7: E0/P0/F0/F1/G1/T1/X1/S1,
        S2 e C-COMM dalla corsa singola (classe 844), K1 dalla scansione di F, R1 DD_fisso
        <= 5,0 per gamba, M1-M4 solo con n OOS >= 150, righe designate, H1/H2/H3 con la
        soglia dell'ora 0,40/0,33/0,28/0,11 per n, attese del par. 6.2 e "cosa NON misura" par. 9.
  R259  teste prove/R259_nightly_*_PIN.txt + report/NIGHTLY_SEI_SIMBOLI_2026-09-26.md par. 4:
        D0 prima data M1, S0 ancora a zero, S1 op/feriale IS/OOS in 0,5-2,0, S2 n<150, S3 DD,
        S4 frontiera del costo (dal referto, NON dalla raccolta), S5 screening + molteplicita'.

Regole: ogni numero con la sua fonte (file della raccolta); etichette [MISURATO] (letto da un
file della raccolta) / [DERIVATO] (calcolato da numeri misurati o preso da un referto) /
[NON VERIFICABILE] (file assente o illeggibile). Posizioni contate per position_id.
Il certificato di morte NON si scrive da un round solo.
Cancello del 27/09 (strato 2): raccolta cercata prima di leggere (872), NULLI della riga UNITI e prova
verificata sullo SHA del pin (873) tranne il P0 letto dalla riga su colonne spostate dalla virgola di
InpNewsCurrencies (883), PROMOSSA solo dopo M4 e M3 sospeso = INDIZIO (874), X1/T1/PG/S1 con la forma
della riga e della testa (875), ancora S0 per simbolo (884), DERIVATO che non boccia (885).
28/09: i CSV si leggono col parser RFC 4180 del modulo csv (spezza_campi). Formato VECCHIO (binario al pin
02c70e17, lo zip di riga A): la virgola di InpNewsCurrencies=GBP,USD aggiunge campi -> ricucitura su
InpNewsCurrencies come prima, esenzione 883 SOLO con campi in eccesso (n_ricucite) E P0 del lettore VERDE.
Formato NUOVO (scrittore OptFrame di a66dcb07, "GBP,USD" fra virgolette, interne raddoppiate): valori interi
senza virgolette residue, NESSUNA ricucitura, NESSUNA esenzione: il P0 della riga vale. Autotest 20/20.

Uso:
  python3 backtest_pipeline/leggi_round_corti_a.py <cartella_raccolta_estratta> [--out referto.md] [--senza-bande]
  python3 backtest_pipeline/leggi_round_corti_a.py --autotest [cartella_fixture]
"""
import collections
import csv
import datetime as dt
import hashlib
import html
import io
import os
import re
import shutil
import statistics as st
import sys
import tempfile

QUI = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QUI)
import r250_bande_attese as r250  # noqa: E402  zone, S1, G1, S2, bande, conferma (testa R250a par. 5-7)

DEPOSITO = 10000.0
# cartella delle fixture dell'autotest: MAI un percorso di macchina cablato (cancello 27/09)
SCRATCH_DEFAULT = os.path.join(tempfile.gettempdir(), 'lettori_corti_a_fixture')

# ----------------------------------------------------------------------------- i 36 job
# Copiati dalla tabella $J della riga (RIGA_ROUND_CORTI_A_R250_R258_R259.txt): tag, EA, simbolo,
# file prova, modello, asse, valori dell'asse, blocco, ora, feriali IS/OOS, magic gemelli, finestra.
def _j(r, t, e, s, p, m, ax, av, blk, **k):
    d = dict(r=r, t=t, e=e, s=s, p=p, m=m, ax=ax, av=av, blk=blk)
    d.update(k)
    return d


F_T = ['0', '10', '20', '30', '40', '50', '60', '70']
JOBS = [
    _j('R250', 'R250a', 'ABTG_Nasdaq_Apertura_US', 'U30USD', 'R250a_orologio_R245_d0_A_U30USD.txt', 4, 'InpMagic', ['765301', '765351'], 'A', fin='A', clk='d0', g1='765301', g2='765351'),
    _j('R250', 'R250b', 'ABTG_Nasdaq_Apertura_US', 'U30USD', 'R250b_orologio_R245_d0_B_U30USD.txt', 4, 'InpMagic', ['765302', '765352'], 'B', fin='B', clk='d0', g1='765302', g2='765352'),
    _j('R250', 'R250c', 'ABTG_Nasdaq_Apertura_US', 'U30USD', 'R250c_orologio_R245_meno1h_A_U30USD.txt', 4, 'InpMagic', ['765303', '765353'], 'A', fin='A', clk='m1h', g1='765303', g2='765353'),
    _j('R250', 'R250d', 'ABTG_Nasdaq_Apertura_US', 'U30USD', 'R250d_orologio_R245_meno1h_B_U30USD.txt', 4, 'InpMagic', ['765304', '765354'], 'B', fin='B', clk='m1h', g1='765304', g2='765354'),
    _j('R250', 'R250e', 'ABTG_Nasdaq_Apertura_US', 'U30USD', 'R250e_orologio_R245_piu1h_A_U30USD.txt', 4, 'InpMagic', ['765305', '765355'], 'A', fin='A', clk='p1h', g1='765305', g2='765355'),
    _j('R250', 'R250f', 'ABTG_Nasdaq_Apertura_US', 'U30USD', 'R250f_orologio_R245_piu1h_B_U30USD.txt', 4, 'InpMagic', ['765306', '765356'], 'B', fin='B', clk='p1h', g1='765306', g2='765356'),
    _j('R258', 'R258a', 'ABTG_Londra_ORB', 'GBPUSD', 'R258a_londra_T_GBPUSD_ora8_UK_TESTA.txt', 4, 'InpMinRangePips', F_T, 'T', ora=8, fis=207, foos=311),
    _j('R258', 'R258b', 'ABTG_Londra_ORB', 'GBPUSD', 'R258b_londra_T_GBPUSD_ora7_PDF.txt', 4, 'InpMinRangePips', F_T, 'T', ora=7, fis=207, foos=311),
    _j('R258', 'R258c', 'ABTG_Londra_ORB', 'GBPUSD', 'R258c_londra_T_GBPUSD_ora9.txt', 4, 'InpMinRangePips', F_T, 'T', ora=9, fis=207, foos=311),
    _j('R258', 'R258g', 'ABTG_Londra_ORB', 'GBPUSD', 'R258g_londra_G_GBPUSD_M30_gemelle.txt', 4, 'InpMagic', ['795840', '795890'], 'G', ora=8, fis=207, foos=311),
    _j('R258', 'R258u', 'ABTG_Londra_ORB', 'GBPUSD', 'R258u_londra_B_GBPUSD_ora8_buffer_F70.txt', 4, 'InpBufferPips', ['1', '3', '5'], 'B', ora=8, fis=207, foos=311, fdes=70),
    _j('R258', 'R258w', 'ABTG_Londra_ORB', 'GBPUSD', 'R258w_londra_D_GBPUSD_ora8_durata.txt', 4, 'InpRangeStartMin', ['0', '30'], 'D', ora=8, fis=207, foos=311),
    _j('R258', 'R258i', 'ABTG_Londra_ORB', 'GBPUSD', 'R258i_londra_F_GBPUSD_ora7_stagioni.txt', 4, 'InpMinRangePips', F_T, 'F', ora=7, fis=150, foos=110),
    _j('R258', 'R258j', 'ABTG_Londra_ORB', 'GBPUSD', 'R258j_londra_F_GBPUSD_ora8_stagioni.txt', 4, 'InpMinRangePips', F_T, 'F', ora=8, fis=150, foos=110),
    _j('R258', 'R258k', 'ABTG_Londra_ORB', 'GBPUSD', 'R258k_londra_F_GBPUSD_ora9_stagioni.txt', 4, 'InpMinRangePips', F_T, 'F', ora=9, fis=150, foos=110),
    _j('R258', 'R258d', 'ABTG_Londra_ORB', 'EURUSD', 'R258d_londra_T_EURUSD_ora8_UK.txt', 4, 'InpMinRangePips', F_T, 'T', ora=8, fis=207, foos=311),
    _j('R258', 'R258e', 'ABTG_Londra_ORB', 'EURUSD', 'R258e_londra_T_EURUSD_ora7_PDF.txt', 4, 'InpMinRangePips', F_T, 'T', ora=7, fis=207, foos=311),
    _j('R258', 'R258f', 'ABTG_Londra_ORB', 'EURUSD', 'R258f_londra_T_EURUSD_ora9.txt', 4, 'InpMinRangePips', F_T, 'T', ora=9, fis=207, foos=311),
    _j('R258', 'R258h', 'ABTG_Londra_ORB', 'EURUSD', 'R258h_londra_G_EURUSD_M30_gemelle.txt', 4, 'InpMagic', ['795841', '795891'], 'G', ora=8, fis=207, foos=311),
    _j('R258', 'R258v', 'ABTG_Londra_ORB', 'EURUSD', 'R258v_londra_B_EURUSD_ora8_buffer_F50.txt', 4, 'InpBufferPips', ['1', '3', '5'], 'B', ora=8, fis=207, foos=311, fdes=50),
    _j('R258', 'R258x', 'ABTG_Londra_ORB', 'EURUSD', 'R258x_londra_D_EURUSD_ora8_durata.txt', 4, 'InpRangeStartMin', ['0', '30'], 'D', ora=8, fis=207, foos=311),
    _j('R258', 'R258l', 'ABTG_Londra_ORB', 'EURUSD', 'R258l_londra_F_EURUSD_ora7_stagioni.txt', 4, 'InpMinRangePips', F_T, 'F', ora=7, fis=150, foos=110),
    _j('R258', 'R258m', 'ABTG_Londra_ORB', 'EURUSD', 'R258m_londra_F_EURUSD_ora8_stagioni.txt', 4, 'InpMinRangePips', F_T, 'F', ora=8, fis=150, foos=110),
    _j('R258', 'R258n', 'ABTG_Londra_ORB', 'EURUSD', 'R258n_londra_F_EURUSD_ora9_stagioni.txt', 4, 'InpMinRangePips', F_T, 'F', ora=9, fis=150, foos=110),
    _j('R258', 'R258r', 'ABTG_Londra_ORB', 'EURUSD', 'R258r_londra_L_EURUSD_ora7_OHLC_screening.txt', 1, 'InpMinRangePips', F_T, 'L', ora=7, fis=2153, foos=2154),
    _j('R258', 'R258s', 'ABTG_Londra_ORB', 'EURUSD', 'R258s_londra_L_EURUSD_ora8_OHLC_screening.txt', 1, 'InpMinRangePips', F_T, 'L', ora=8, fis=2153, foos=2154),
    _j('R258', 'R258t', 'ABTG_Londra_ORB', 'EURUSD', 'R258t_londra_L_EURUSD_ora9_OHLC_screening.txt', 1, 'InpMinRangePips', F_T, 'L', ora=9, fis=2153, foos=2154),
    _j('R258', 'R258o', 'ABTG_Londra_ORB', 'GBPUSD', 'R258o_londra_L_GBPUSD_ora7_OHLC_screening.txt', 1, 'InpMinRangePips', F_T, 'L', ora=7, fis=2153, foos=2154),
    _j('R258', 'R258p', 'ABTG_Londra_ORB', 'GBPUSD', 'R258p_londra_L_GBPUSD_ora8_OHLC_screening.txt', 1, 'InpMinRangePips', F_T, 'L', ora=8, fis=2153, foos=2154),
    _j('R258', 'R258q', 'ABTG_Londra_ORB', 'GBPUSD', 'R258q_londra_L_GBPUSD_ora9_OHLC_screening.txt', 1, 'InpMinRangePips', F_T, 'L', ora=9, fis=2153, foos=2154),
    _j('R259', 'R259_AUDUSD', 'ABTG_Nightly', 'AUDUSD', 'R259_nightly_AUDUSD_PIN.txt', 1, 'InpBlockNightActive', ['0', '1'], 'N', fis=979, foos=977, anc='1', m1='2019.01.02'),
    _j('R259', 'R259_USDJPY', 'ABTG_Nightly', 'USDJPY', 'R259_nightly_USDJPY_PIN.txt', 1, 'InpBlockNightActive', ['0', '1'], 'N', fis=979, foos=977, anc='1', m1='2019.01.02'),
    _j('R259', 'R259_XAUUSD', 'ABTG_Nightly', 'XAUUSD', 'R259_nightly_XAUUSD_PIN.txt', 1, 'InpMaxNightVolPips', ['0', '45'], 'N', fis=183, foos=276, anc='45', m1='2024.09.26'),
    _j('R259', 'R259_XAGUSD', 'ABTG_Nightly', 'XAGUSD', 'R259_nightly_XAGUSD_PIN.txt', 1, 'InpMaxNightVolPips', ['0', '45'], 'N', fis=183, foos=276, anc='45', m1='2024.09.26'),
    _j('R259', 'R259_D30EUR', 'ABTG_Nightly', 'D30EUR', 'R259_nightly_D30EUR_PIN.txt', 1, 'InpMaxNightVolPips', ['0', '45'], 'N', fis=183, foos=276, anc='45', m1='2024.09.26'),
    _j('R259', 'R259_U30USD', 'ABTG_Nightly', 'U30USD', 'R259_nightly_U30USD_PIN.txt', 1, 'InpMaxNightVolPips', ['0', '45'], 'N', fis=183, foos=276, anc='45', m1='2024.09.26'),
]
JOB = {j['t']: j for j in JOBS}

# SHA256 del file prova AL PIN, copiati dalla tabella $J della riga (campo hp): la prova si verifica
# contro QUESTI, da dovunque venga (raccolta o repo), classe 873. Estratti e ricontrollati il 27/09
# contro prove/ a HEAD (36 su 36 uguali).
HP = {
    'R250a': 'B666863F0E9D30E174DF29E69F4B22CC20524FAEF0A3DA283E17F280E6F0F62D', 'R250b': 'A8B12619D7A5BD42D3969A114C879B6713DE7C1C0462A6901150B8A8387109C1',
    'R250c': '274CA11B00EDAAF7CB9FE38CC22B696BF985D40E18255D4C61F4681622B0632F', 'R250d': 'DBC325DAE516AC1CEF94298322077C273F7E8036A2D34D04AE755C0780D0E11C',
    'R250e': '5DD25BB699BF6EC3C2BCFEE9587B217533065B7E5A2243195BF169C22B143C04', 'R250f': '2B1483704D2434D79E0351E970245B6C29C7E4DFA588DDBD5CB5063A943BE1EF',
    'R258a': '4F6DBD4E7D161557FC12CA3A8DA4DD53753B93050E4DB05AB606EC1C928732CF', 'R258b': 'B8AEB4050A0879D51807822AC2D1615E2BD4AEC7CA0F4A690E1775C4D9B865FB',
    'R258c': 'D047D132DC3B57FD66671881A07F8E1F14072201CDCE0427E1018447DD62C243', 'R258g': '8E72F8699082F71529A14D47D978AA17DFBF0560731AE076C0D3BC9A1C44010B',
    'R258u': '079AB1F3FE9D8C513622D066F566A62F64F0A22228E676980E7090AD689B8FD7', 'R258w': '90639684C3C69F4CAE6FEA30746E6A92B2D2D0CA166C90488775147D94C0CA4D',
    'R258i': '6F429991E9C87192E319104BE84285D6CDEC6FE33CCA2C28335EFBF3E1F6AE21', 'R258j': '8999363367A758278F916A39F35FA32565B86C8019EE70455D22FF006C8F026B',
    'R258k': 'B76108610DDAD0249BC7C0A508583C3C6847FED4567BA97CB9CE53FEE9D5A0E5', 'R258d': 'F521FE111A490D294562A9FC80A263519125108EADF16837BBE50315E2EA4BDD',
    'R258e': 'B0E3661E154DBA5366F779CAD7DBF7A8F1AECB8A9049B84E599D524984BA60F0', 'R258f': '1A21A6E7158057DAC8F0903A21D19AC24391BDCA17283625D5C105535F8CC74E',
    'R258h': 'FB33EA8A91662B881ABF6B7415D3BD5D5BF7DBC91FF58920005E5565B085F893', 'R258v': '323D161A99281C23DD90B182CAE83488BC2812E590487841575ACAA224E86D75',
    'R258x': 'DDC68F9DA4C7AAA9DC691926D2F48600985F2691E98F00C1F9CE8B331241C701', 'R258l': '47E9748378BBE6F248B47F238A908859D2DD56928A959A21679C111E957ABB08',
    'R258m': 'EEC7E9308C3041740019C6494BE03F69DAF98F20B0A549C224AABA91E283F6B4', 'R258n': '914C164E766C40BA945AFBB08DB684C7A645FDB305315D9199BA57B98B13450C',
    'R258r': '9F954CC168D07FD5FDFC972E4874B3E24419BBCD97E702F3FB3C0EEFC313E9BD', 'R258s': '4116FBD25FA8A2869BAF669D902344D1C031D63CDC40F7A6F42C2C8ADDC87AF7',
    'R258t': 'CE833F2A83EF63E0D73C46667679C9D280DD7A16AC82032A0D71AFDAC4EEFCF2', 'R258o': '8F1F66B5488034042295B85035BBC5A962D1D840B9065A661A5ED090F4479E34',
    'R258p': '7662ACD0CC958B9D0495B3C06B4F818278EE8A6A118D4C0581A6F1B0CB4C9982', 'R258q': '82B5EB66598363E2A85E6E29574A8FA73FA3E39EF68FD85A97900AFEE1AD39CF',
    'R259_AUDUSD': '1A5E346255E02F22223036852F3790213E9041AB90ACA119BA13BE2AC0AC387B', 'R259_USDJPY': 'A7DDF7310FA5871E4AFA04403E9DB5B46094EA4F4D515DFFD1D27CFE4191630A',
    'R259_XAUUSD': 'A05F8BD1A30B6A82125A9DF8C322747A7C772A25E9936EA7E85F5960597BE5FC', 'R259_XAGUSD': 'D8267FA9F8ACFDA3D6329B1DD0C4581F34D7567D2A955AF6FA88E927FB050374',
    'R259_D30EUR': '463344E881F62746B0A36335EA0901D31DF80B1D7F2BB1D058DAA8A702DCF1FE', 'R259_U30USD': '4368D91E6AB448FBC24BD9156560F5E1C0C32F2959D75348F87665FDA349B078',
}
# R259 S0 (classe 884): l'ancora d'ARCHIVIO della cella ancora, PER SIMBOLO (riga: aIS/aOOS/aPr/aPF/aDD; teste par. 3).
# XAGUSD NON e' 0/0: e' IS 0 / OOS 4 con Profit 50.82, PF 1.26185, DD 1.6582 (testa R259 XAGUSD par. 3).
# Tolleranze della riga: Profit 0,05, PF 0,00005, Equity DD % 0,01.
R259_ANCORA = {'R259_AUDUSD': (0, 0, None), 'R259_USDJPY': (0, 0, None), 'R259_XAUUSD': (0, 0, None),
               'R259_XAGUSD': (0, 4, dict(Profit=50.82, PF=1.26185, DD=1.6582)),
               'R259_D30EUR': (0, 0, None), 'R259_U30USD': (0, 0, None)}

# R250: la testa (par. 5.0) chiede QUESTE colonne uguali al pin in ogni riga dei CSV letti
R250_PIN_COLS = ('InpSessionHour', 'InpSessionMin', 'InpCloseHour', 'InpCloseMin', 'InpEmaSlow', 'InpTP1_R', 'InpFilterTF')
R250_ANCORE_CSV = {  # testa par. 5.2 = REFERTO_R247 G0
    'IS': dict(Trades=154, PF=1.25176, Profit=1180.94, DD=7.1002, PG=-1.1046),
    'OOS': dict(Trades=197, PF=1.48894, Profit=2961.61, DD=6.8640, PG=-1.1958),
}
R250_ARCH = {'A': 'archivio_R247_pertrade_765271.csv', 'B': 'archivio_R247_pertrade_765273.csv'}
R250_D0 = {'A': 'R250a', 'B': 'R250b'}
R250_PRIMA_CHIUSURA_B = dt.date(2025, 7, 1)
R3_SOGLIA = -1.10          # R255a par. 9 / R251-R252: soglia di casa della peggior giornata
E_EFF_R255 = 0.1266        # R255a par. 7: errore della ricomposizione a 10000 (pavimento simulato)

# R258: costo all-in (testa par. 7, K1) e soglie
R258_COSTO = {'GBPUSD': 0.840, 'EURUSD': 0.664}     # spread mediano h07-12 + commissione MISURATA (pip)
R258_X_OK, R258_X_MIN = 40.0, 13.3
R258_R1_MAX = 5.0
R258_M1, R258_M2 = 1.10, 0.80
R258_DESIGNATE = {'R258a': 70, 'R258d': 50}          # b=3, F designato
R258_P_NOEDGE = {150: 0.30, 233: 0.24, 300: 0.22}    # testa par. 7-8 (P che un motore senza edge passi M1)
R258_GRID = [0, 10, 20, 30, 40, 50, 60, 70]
R258_TF_LINK = {'R258g': 'R258a', 'R258h': 'R258d'}          # T1: g/h contro la riga F=0 di a/d
R258_X1 = [('R258u', 'InpBufferPips', 3.0, 'R258a', 70), ('R258v', 'InpBufferPips', 3.0, 'R258d', 50),
           ('R258w', 'InpRangeStartMin', 0.0, 'R258a', 0), ('R258x', 'InpRangeStartMin', 0.0, 'R258d', 0)]
R258_ORE = {('GBPUSD', 'T'): {7: 'R258b', 8: 'R258a', 9: 'R258c'}, ('EURUSD', 'T'): {7: 'R258e', 8: 'R258d', 9: 'R258f'},
            ('GBPUSD', 'F'): {7: 'R258i', 8: 'R258j', 9: 'R258k'}, ('EURUSD', 'F'): {7: 'R258l', 8: 'R258m', 9: 'R258n'},
            ('GBPUSD', 'L'): {7: 'R258o', 8: 'R258p', 9: 'R258q'}, ('EURUSD', 'L'): {7: 'R258r', 8: 'R258s', 9: 'R258t'}}
R258_S2_LO, R258_S2_HI = '08:00:00', '17:00:59'      # C-COMM = R258a (ora 8): uscite dentro 08:00-17:00
CL844_K = (1.0, 3.0)                                # classe 844: meta' commissione sull'ingresso, EUR/lotto

# R259: frontiera del costo dal referto NIGHTLY par. 4.3 (NON e' nella raccolta: si dichiara)
R259_COSTO = {
    'AUDUSD': ('[NON MISURATO] spread h05 fuori dal logger; ATR(14,H1) alle 05:00 [NON MISURATO]', 'non promuovibile finche non misurato'),
    'USDJPY': ('spread h05 0,3 pip (P95 1,0) [MISURATO altrove]; serve stop >= 12 pip; ATR [NON MISURATO]', 'non promuovibile finche non misurato'),
    'XAUUSD': ('spread h05 0,25 USD; stop ~12,8 USD [DERIVATO, grossolano] -> ~51x', 'sopra il 40x MA non e un ATR misurato'),
    'XAGUSD': ('[NON MISURATO] (snapshot 0,041 USD non e una mediana)', 'non promuovibile finche non misurato'),
    'D30EUR': ('spread h05 2,8 punti; stop 51,5-58,5 [DERIVATO] -> 18,4-20,9x', 'ESCLUSO PER COSTO alla gestione di default'),
    'U30USD': ('spread h05 2,0 punti (P95 3,0); stop 78,05-88,25 [MISURATO altrove] -> 39,0-44,1x (26-29x al P95)', 'FRAGILE, a cavallo del 40x'),
}
R259_DORMIENTI = '0,586-1,049 (cella 0 di R220a-d, 8 finestre d archivio, 6 sotto 1: referto par. 4.2, NON nella raccolta)'


# ----------------------------------------------------------------------------- utilita'
def num(x):
    try:
        return float(str(x).strip())
    except (TypeError, ValueError):
        return None


def f2(x, n=2):
    return 'n/d' if x is None else ('%.*f' % (n, x))


NOTA_RICUCITE = ' (%d con virgola in un input stringa, ricucite su InpNewsCurrencies)'
NOTA_RFC4180 = ' (%d con campi fra virgolette RFC 4180, letti dal parser csv: nessuna ricucitura)'


def spezza_campi(ln):
    """UNA riga di CSV OptFrame -> lista di campi col parser RFC 4180 del modulo csv (28/09/2026).
    Formato VECCHIO (binario al pin 02c70e17): nessuna virgoletta, la virgola di InpNewsCurrencies=GBP,USD
    aggiunge campi -> il parser spezza come ln.split(',') e la ricucitura resta ad allinea_riga.
    Formato NUOVO (scrittore OptFrame di a66dcb07, RFC 4180): i valori con virgola/virgolette stanno fra
    virgolette doppie con le interne raddoppiate ("GBP,USD" / "R258A LDN ""GBPUSD"" H8"): il parser li
    rende interi e SENZA virgolette residue, e il numero di campi coincide con l intestazione.
    Ritorna la lista dei campi (None se il parser non legge la riga)."""
    try:
        return next(csv.reader([ln]))
    except (csv.Error, StopIteration):
        return None


def n_ricucite(nota):
    """numero di righe RICUCITE dichiarato nella nota di leggi_csv_opt (0 se la nota non lo dice).
    E la condizione (a) dell esenzione classe 883: il CSV ha DAVVERO righe con piu campi dell intestazione."""
    m = re.search(r'\((\d+) con virgola in un input stringa, ricucite su InpNewsCurrencies\)', nota or '')
    return int(m.group(1)) if m else 0


def leggi_csv_opt(path):
    """CSV di OptFrame (virgola). Ritorna (righe, note). Righe: dict colonna -> valore (float se numerico).
    Le righe duplicate per Pass (quirk visto nell'archivio Nightly) si tengono tutte e si annotano.
    Legge tutti e due i formati (vedi spezza_campi): la nota dice quante righe sono state RICUCITE (formato
    vecchio, campi in eccesso) e quante lette fra virgolette (formato nuovo, NESSUNA ricucitura)."""
    if not os.path.isfile(path):
        return None, 'ASSENTE'
    if os.path.getsize(path) == 0:
        return [], '0 byte'
    with open(path, encoding='utf-8', errors='replace', newline='') as fh:
        txt = fh.read()
    rows = []
    righe = [x for x in txt.splitlines() if x.strip()]
    hcampi = spezza_campi(righe[0])
    if hcampi is None:
        return None, 'intestazione non leggibile dal parser csv'
    hdr = [h.strip() for h in hcampi]
    if 'Trades' not in hdr:
        return None, 'intestazione senza Trades'
    ricuciti, quotate = 0, 0
    for ln in righe[1:]:
        campi, ric = allinea_riga(hdr, ln)
        ricuciti += ric
        if campi is None:
            grezzi = spezza_campi(ln)
            return None, 'riga con %s campi contro %d colonne, non ricucibile' % ('n/d' if grezzi is None else len(grezzi), len(hdr))
        if ric == 0 and '"' in ln:
            quotate += 1
        d = {}
        for k, v in zip(hdr, campi):
            fv = num(v)
            d[k] = fv if fv is not None else v.strip()
        rows.append(d)
    return rows, '%d righe' % len(rows) + (NOTA_RICUCITE % ricuciti if ricuciti else '') + (NOTA_RFC4180 % quotate if quotate else '')


STRINGHE_CON_VIRGOLA = ('InpNewsCurrencies',)


def allinea_riga(hdr, ln):
    """OptFrame al pin 02c70e17 scrive i valori degli input come sono: 'InpNewsCurrencies=GBP,USD' mette una
    virgola DENTRO la riga e sposta le colonne che seguono (InpComment, InpMagic...). Se la riga ha piu campi
    dell intestazione, i campi in eccesso si ricuciono dentro InpNewsCurrencies. Ritorna (campi, n_ricuciti).
    Una riga del formato NUOVO (valori fra virgolette RFC 4180) esce dal parser gia con il numero giusto di
    campi: NESSUNA ricucitura (n_ricuciti = 0), il valore e intero e senza virgolette."""
    campi = spezza_campi(ln)
    if campi is None:
        return None, 0
    if len(campi) == len(hdr):
        return campi, 0
    extra = len(campi) - len(hdr)
    if extra > 0:
        for col in STRINGHE_CON_VIRGOLA:
            if col in hdr:
                i = hdr.index(col)
                campi = campi[:i] + [','.join(campi[i:i + extra + 1])] + campi[i + extra + 1:]
                return campi, 1
    return None, 0


def leggi_pt(path):
    """per-trade di ExportTrades (punto e virgola). Righe: d, t, ct, net, pid, tipo, vol, px, magic."""
    if not os.path.isfile(path):
        return None
    out = []
    with open(path, encoding='utf-8', errors='replace', newline='') as fh:
        for r in csv.DictReader(fh, delimiter=';'):
            try:
                out.append(dict(d=dt.datetime.strptime(r['close_time'][:10], '%Y.%m.%d').date(),
                                t=r['close_time'][11:], ct=r['close_time'], net=float(r['net_profit']),
                                pid=r['position_id'], tipo=int(r['deal_type']), vol=r['volume'],
                                volf=float(r['volume']), px=r['price'], magic=r['magic']))
            except (KeyError, ValueError):
                return None
    return out


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, 'rb') as fh:
        for blk in iter(lambda: fh.read(1 << 16), b''):
            h.update(blk)
    return h.hexdigest().upper()


def leggi_pin(rac, job):
    """pin del file prova: prima dalla raccolta (ROUND_<tag>/<p>), se manca dal repo (prove/<p>), dichiarandolo.
    In tutti e due i casi il file si verifica contro lo SHA256 del pin scritto nella riga (HP, classe 873):
    SHA diverso -> pin NON usabili (None), la fonte lo dice."""
    for base, fonte in ((os.path.join(rac, 'ROUND_' + job['t'], job['p']), 'raccolta'),
                        (os.path.join(QUI, 'prove', job['p']), 'repo (NON nella raccolta)')):
        if os.path.isfile(base):
            sha = sha256_file(base)
            if HP.get(job['t']) and sha != HP[job['t']]:
                return None, None, 'prova da %s con SHA256 DIVERSO DAL PIN (%s... contro %s...)' % (fonte, sha[:8], HP[job['t']][:8])
            fonte = fonte + ', SHA256 = pin'
            pins, asse = {}, None
            with open(base, encoding='utf-8', errors='replace') as fh:
                for ln in fh:
                    ln = ln.strip()
                    if not ln or ln.startswith('#') or ln.startswith('@') or '=' not in ln:
                        continue
                    k, v = ln.split('=', 1)
                    parti = v.split('||')
                    if len(parti) == 5 and parti[4].strip().upper() == 'Y':
                        asse = k.strip()
                        continue
                    pins[k.strip()] = parti[0].strip()
            return pins, asse, fonte
    return None, None, 'ASSENTE'


# ----------------------------------------------------------------------------- raccolta e RIEPILOGO della riga
TAG_RE = r'(?:R25[08][a-z]|R259_[A-Z0-9]{6})'
MOTIVI_INIZIO = ('rc 1', 'MOTORE DIVERSO', 'prova ', 'PIN DEL FILE PROVA', 'E0', 'ASSE DIVERSO', 'P0 ', 'C0 ', 'G1 ', 'S1',
                 'F0 ', 'F1 ', 'T1 ', 'X1 ', 'S0 ', 'S2 ')


def conta_cartelle(d):
    return sum(1 for j in JOBS if os.path.isdir(os.path.join(d, 'ROUND_' + j['t'])))


def trova_raccolta(rac):
    """classe 872: un percorso sbagliato NON diventa un round NULLO. Si contano PRIMA le cartelle attese:
    zero cartelle ROUND_<tag> e nessun RIEPILOGO -> si scende di UN livello solo se li' c'e' UNA raccolta,
    dichiarandolo; altrimenti ci si ferma con un errore, mai un referto."""
    rac = os.path.abspath(rac)
    if not os.path.isdir(rac):
        raise SystemExit('ERRORE: %s non e una cartella (serve la raccolta ROUND_CORTI_A_<data> estratta dallo zip)' % rac)
    if conta_cartelle(rac) > 0 or os.path.isfile(os.path.join(rac, 'RIEPILOGO_ROUND_CORTI_A.txt')):
        return rac, None
    figli = [os.path.join(rac, x) for x in sorted(os.listdir(rac)) if os.path.isdir(os.path.join(rac, x))]
    buoni = [f for f in figli if conta_cartelle(f) > 0 or os.path.isfile(os.path.join(f, 'RIEPILOGO_ROUND_CORTI_A.txt'))]
    if len(buoni) == 1:
        return buoni[0], 'la cartella passata (%s) non e la raccolta: letta la sua sottocartella %s (scesa di UN livello, classe 872)' % (rac, os.path.basename(buoni[0]))
    raise SystemExit('ERRORE (classe 872): in %s nessuna cartella ROUND_R250..R259 e nessun RIEPILOGO_ROUND_CORTI_A.txt; sottocartelle con una raccolta: %d (%s). Passare la cartella ROUND_CORTI_A_<data> estratta. NESSUN referto scritto.'
                     % (rac, len(buoni), ', '.join(os.path.basename(b) for b in buoni) or 'nessuna'))


def spezza_motivi(testo):
    """i motivi di un NULLO della riga sono uniti con '; ', ma alcuni motivi contengono '; ' al loro interno:
    un frammento apre un motivo nuovo solo se comincia con una parola-chiave nota."""
    out = []
    for fr in testo.split('; '):
        if not out or fr.startswith(MOTIVI_INIZIO):
            out.append(fr)
        else:
            out[-1] = out[-1] + '; ' + fr
    return out


def leggi_riepilogo(rac):
    """RIEPILOGO_ROUND_CORTI_A.txt della riga: FILE NULLI (con motivi), FILE SALTATI, FILE NON NULLI, G0 di R250,
    classe 166. Serve a UNIRE i NULLI che solo la riga vede (motore, prova, rc 1, C0, freschezza) a quelli
    ricalcolati dal lettore (classe 873)."""
    RP = dict(presente=False, nulli={}, saltati={}, nonnulli=None, g0={}, c166=None, righe=[])
    p = os.path.join(rac, 'RIEPILOGO_ROUND_CORTI_A.txt')
    if not os.path.isfile(p):
        return RP
    RP['presente'] = True
    with open(p, encoding='utf-8', errors='replace') as fh:
        righe = [x.rstrip() for x in fh]
    RP['righe'] = righe
    for r in righe:
        if r.startswith('FILE NULLI') or r.startswith('FILE SALTATI'):
            corpo = r.split('): ', 1)[1] if '): ' in r else ''
            dest = RP['nulli'] if r.startswith('FILE NULLI') else RP['saltati']
            if corpo.strip() in ('', 'nessuno'):
                continue
            for m in re.finditer(r'(' + TAG_RE + r') \((.*?)\)(?= \| ' + TAG_RE + r' \(|\s*$)', corpo):
                dest[m.group(1)] = spezza_motivi(m.group(2)) if dest is RP['nulli'] else m.group(2)
        elif r.startswith('FILE NON NULLI'):
            corpo = r.split(': ', 1)[1] if ': ' in r else ''
            RP['nonnulli'] = set() if corpo.strip() == 'NESSUNO' else {x.strip() for x in corpo.split(',') if x.strip()}
        elif r.startswith('R250 G0 RIPRODUZIONE'):
            corpo = r.split('): ', 1)[1] if '): ' in r else ''
            for m in re.finditer(r'(R250[ab]) (VERDE|ROSSO|NON VERIFICABILE)', corpo):
                RP['g0'][m.group(1)] = m.group(2)
        elif r.startswith('CLASSE 166'):
            RP['c166'] = r.split('): ', 1)[1] if '): ' in r else r
    return RP


def motivi_riga(RP, tag):
    return RP['nulli'].get(tag, []) if RP else []


# ----------------------------------------------------------------------------- posizioni e curve (metodo R255 par. 7)
def posizioni(rows):
    """raggruppa per position_id DENTRO la corsa; ordine per primo deal."""
    pos = collections.OrderedDict()
    for r in sorted(rows, key=lambda r: (r['ct'], r['pid'])):
        pos.setdefault(r['pid'], []).append(r)
    out = []
    for pid, ds in pos.items():
        out.append(dict(pid=pid, deals=ds, ct0=ds[0]['ct'], ct1=ds[-1]['ct'], net=sum(x['net'] for x in ds),
                        vol=sum(x['volf'] for x in ds), data=ds[-1]['d'], tipo=ds[-1]['tipo']))
    out.sort(key=lambda p: p['ct0'])
    return out


def ribasa(pos_corsa):
    """metodo A: r = net / saldo della SUA corsa prima del primo deal della posizione."""
    tutti = sorted((d for p in pos_corsa for d in p['deals']), key=lambda d: d['ct'])
    for p in pos_corsa:
        b = DEPOSITO + sum(d['net'] for d in tutti if d['ct'] < p['ct0'])
        p['B_corsa'] = b
        p['r_deals'] = [d['net'] / b for d in p['deals']]
    return pos_corsa


def curva(pos, metodo):
    """statistiche a saldo chiuso (deposito 10000, denominatore FISSO per il DD: classe 550;
    peggior giornata = P/L chiuso del giorno / saldo della curva a inizio giornata: R255a par. 9 R3)."""
    saldo = picco = DEPOSITO
    dd = 0.0
    giorni = collections.OrderedDict()
    saldo_inizio = {}
    serie = serie_max = 0
    profit = gain = loss = 0.0
    for p in sorted(pos, key=lambda p: p['ct0']):
        prima = saldo
        nets = [r * prima for r in p['r_deals']] if metodo == 'A' else [d['net'] for d in p['deals']]
        pnet = sum(nets)
        p['net_curva_' + metodo] = pnet
        saldo_inizio.setdefault(p['data'], prima)
        for n in nets:
            saldo += n
            picco = max(picco, saldo)
            dd = min(dd, saldo - picco)
        profit += pnet
        if pnet > 0:
            gain += pnet
        elif pnet < 0:
            loss += -pnet
        giorni[p['data']] = giorni.get(p['data'], 0.0) + pnet
        if pnet < 0:
            serie += 1
            serie_max = max(serie_max, serie)
        else:
            serie = 0
    pegg, pegg_d = 0.0, None
    for g, v in giorni.items():
        q = v / saldo_inizio[g] * 100.0
        if q < pegg:
            pegg, pegg_d = q, g
    n = len(pos)
    return dict(n=n, deal=sum(len(p['deals']) for p in pos), profit=profit,
                pf=(gain / loss if loss > 0 else (float('inf') if gain > 0 else None)),
                ep=(profit / n if n else 0.0), dd_eur=-dd, dd_pct=-dd / DEPOSITO * 100.0,
                pegg_pct=pegg, pegg_giorno=pegg_d, serie=serie_max, saldo=saldo)


def dd_chiuso(rows):
    """DD del saldo chiuso in % del deposito (minorante dell'equity DD), dai deal in ordine di chiusura."""
    saldo = picco = DEPOSITO
    dd = 0.0
    for r in sorted(rows, key=lambda r: r['ct']):
        saldo += r['net']
        picco = max(picco, saldo)
        dd = min(dd, saldo - picco)
    return -dd / DEPOSITO * 100.0


def peggior_giornata(rows):
    """peggior P/L chiuso di giornata in % del saldo a inizio giornata (come 'Peggior Giornata %' dell'EA, ma a chiuso)."""
    saldo = DEPOSITO
    giorni = collections.OrderedDict()
    inizio = {}
    for r in sorted(rows, key=lambda r: r['ct']):
        inizio.setdefault(r['d'], saldo)
        giorni[r['d']] = giorni.get(r['d'], 0.0) + r['net']
        saldo += r['net']
    if not giorni:
        return None, None
    g = min(giorni, key=lambda k: giorni[k] / inizio[k])
    return giorni[g] / inizio[g] * 100.0, g


# ============================================================================= R250
def r250_leggi(rac, senza_bande=False, RP=None):
    """Ritorna (righe markdown, esito strutturato)."""
    L, E = [], dict(stato={}, g0={}, s1={}, s2={}, g2={}, pin={}, zone={}, conferma={}, fase={}, note=[], riga={})
    forma = []   # divergenze di FORMA fra riga e testa (classe 875): si stampano, non si nascondono
    ea, sym = 'ABTG_Nasdaq_Apertura_US', 'U30USD'
    L.append('## R250 -- OROLOGIO O STAGIONE per il candidato #1 (testa `prove/R250a_orologio_R245_d0_A_U30USD.txt`)')
    L.append('')
    L.append('Criteri: par. 5.0 PIN dal CSV, 5.1 G1, 5.2 G0 (solo d0), 5.3 G2, 5.4 S1, 5.5 S2, 5.6 chi vota; par. 6-7 zone e conferma; par. 8 n; par. 9 rischio; par. 10 lati; par. 11 costo. Tolleranze G1/G0: Trades identici, PF alla 4a decimale, |dProfit| <= 0,05, |dDD| <= 0,01, net per riga entro 0,01.')
    L.append('')
    # --- archivi R247 (dal pin, copiati nella raccolta)
    arch, arch_pos, ref = {}, {}, {}
    for k, nome in R250_ARCH.items():
        rows = leggi_pt(os.path.join(rac, nome))
        arch[k] = rows
        if rows is None:
            L.append('- [NON VERIFICABILE] archivio `%s` assente o illeggibile: G0 e riferimenti della finestra %s non si leggono.' % (nome, k))
            continue
        pos = r250.per_stagione(rows)
        arch_pos[k] = pos
        ref[k] = r250.riferimenti(pos, r250.feriali(*r250.FIN[k]))
        a = r250.ANCORE[k]
        somma = round(sum(r['net'] for r in rows), 2)
        ok = (len(rows) == a['deal'] and len({r['pid'] for r in rows}) == a['deal'] and abs(somma - a['somma']) < 0.005
              and ref[k]['nE'] == a['nE'] and ref[k]['nI'] == a['nI'] and round(ref[k]['pE'], 3) == a['pfE'] and round(ref[k]['pI'], 3) == a['pfI'])
        L.append('- [MISURATO] archivio R247 finestra %s `%s`: %d deal = %d position_id, somma %.2f; estate n %d PF %.4f, inverno n %d PF %.4f; D = %.4f, Df = %.4f -> ancore (testa par. 6): %s'
                 % (k, nome, len(rows), len({r['pid'] for r in rows}), somma, ref[k]['nE'], ref[k]['pE'], ref[k]['nI'], ref[k]['pI'], ref[k]['D'], ref[k]['Df'], 'OK' if ok else 'ROSSO (numeri diversi dalle ancore di r250_bande_attese)'))
        E['note'].append(('ancora_' + k, ok))
    if 'A' in ref and 'B' in ref:
        posAB = r250.unisci(arch_pos['A'], arch_pos['B'])
        fA, fB = r250.feriali(*r250.FIN['A']), r250.feriali(*r250.FIN['B'])
        ref['AB'] = r250.riferimenti(posAB, (fA[0] + fB[0], fA[1] + fB[1]))
        arch_pos['AB'] = posAB
    L.append('')
    # --- per file: CSV, per-trade, cancelli
    dati = {}
    L.append('### R250 -- catena per file (par. 5.0 PIN, 5.1 G1, 5.4 S1, 5.2 G0, 5.5 S2)')
    L.append('')
    L.append('| file | orologio/finestra | CSV _IS | CSV _OOS | PIN dal CSV | G1 CSV | G1 per-trade | S1 | G0 | S2 (giorni comuni / opposti) | VALIDO |')
    L.append('|---|---|---|---|---|---|---|---|---|---|---|')
    for j in [x for x in JOBS if x['r'] == 'R250']:
        t = j['t']
        cart = os.path.join(rac, 'ROUND_' + t)
        p_is = os.path.join(cart, '%s_%s_IS_%s.csv' % (ea, sym, t))
        p_oos = os.path.join(cart, '%s_%s_OOS_%s.csv' % (ea, sym, t))
        ris, nis = leggi_csv_opt(p_is)
        roos, noos = leggi_csv_opt(p_oos)
        pt1 = leggi_pt(os.path.join(rac, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (ea, sym, j['g1'])))
        pt2 = leggi_pt(os.path.join(rac, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (ea, sym, j['g2'])))
        pins, asse, fonte_pin = leggi_pin(rac, j)
        d = dict(job=j, ris=ris, roos=roos, pt1=pt1, pt2=pt2, pins=pins, fonte_pin=fonte_pin)
        # E0 della finestra: A = _IS 2 righe Trades>0 e _OOS 0 righe (classe 766); B = tutte e due 2 righe Trades>0
        csv_letti = []
        e0 = ris is not None and len(ris) == 2 and all((r.get('Trades') or 0) > 0 for r in ris)
        if e0:
            csv_letti.append(('IS', ris))
        if j['fin'] == 'A':
            # gamba OOS DEGENERE: _OOS a 0 byte o ASSENTE (la riga accetta tutti e due, classe 766)
            e0 = e0 and ((roos is None and noos == 'ASSENTE') or (roos is not None and len(roos) == 0))
        else:
            e0b = roos is not None and len(roos) == 2 and all((r.get('Trades') or 0) > 0 for r in roos)
            e0 = e0 and e0b
            if e0b:
                csv_letti.append(('OOS', roos))
        # 5.0 PIN dal CSV
        if pins is None:
            pin_txt = '[NON VERIFICABILE] prova: ' + fonte_pin
            pin_ok = False
        else:
            manc, div, nconf = [], [], 0
            for gamba, rows in csv_letti:
                for i, r in enumerate(rows):
                    for c in R250_PIN_COLS:
                        if c not in r:
                            manc.append(c)
                            continue
                        nconf += 1
                        if num(pins.get(c)) is None or abs(num(r[c]) - num(pins[c])) > 1e-6:
                            div.append('%s %s riga %d: %s contro pin %s' % (gamba, c, i + 1, r[c], pins.get(c)))
                    nconf += 1
                    att = [j['g1'], j['g2']]
                    if 'InpMagic' not in r:
                        manc.append('InpMagic')
                    elif str(int(r['InpMagic'])) not in att:
                        div.append('%s InpMagic riga %d: %s non e %s' % (gamba, i + 1, r['InpMagic'], '/'.join(att)))
            pin_ok = e0 and not manc and not div
            pin_txt = ('VERDE (%d confronti, pin da %s)' % (nconf, fonte_pin)) if pin_ok else ('ROSSO: ' + '; '.join(sorted(set(manc)) + div)[:200] if (manc or div) else 'ROSSO: CSV non leggibile')
        # 5.1 G1
        def rowdict(r):
            return dict(Trades=r.get('Trades'), PF=r.get('Profit Factor'), Profit=r.get('Profit'), DD=r.get('Equity DD %'))
        g1csv = 'NON VERIFICABILE'
        if e0:
            g1csv = 'PASS'
            for gamba, rows in csv_letti:
                if r250.g1_csv(rowdict(rows[0]), rowdict(rows[1])) != 'PASS':
                    g1csv = 'NULLO (%s)' % gamba
                pa, pb = rows[0].get('Profit Factor'), rows[1].get('Profit Factor')
                if num(pa) is not None and num(pb) is not None and ((round(pa, 4) == round(pb, 4)) != (abs(pa - pb) <= 0.00005 + 1e-12)):
                    forma.append('%s G1 %s: PF %s / %s -- testa (r250.g1_csv, "alla quarta decimale" = arrotondamento) e riga (|delta| <= 0,00005) danno esiti DIVERSI; vale la testa, lo si scrive' % (t, gamba, pa, pb))
        g1pt = 'NON VERIFICABILE'
        if pt1 is not None and pt2 is not None:
            es, mot = r250.g1_pertrade(pt1, pt2)
            g1pt = es + ((' ' + mot) if mot else '')
        # 5.4 S1 (contro il d0 della STESSA finestra)
        s1 = ('NON VERIFICABILE', 'per-trade assente')
        if pt1 is not None:
            d0 = dati.get(R250_D0[j['fin']])
            rows_d0 = d0['pt1'] if (d0 and j['clk'] != 'd0') else None
            s1 = r250.s1(pt1, j['clk'], rows_d0)
        # 5.2 G0 (solo d0)
        g0 = None
        if j['clk'] == 'd0':
            probl = []
            if not e0:
                probl.append('E0')
            for gamba, rows in csv_letti:
                a = R250_ANCORE_CSV[gamba]
                for i, r in enumerate(rows):
                    if int(r.get('Trades') or -1) != a['Trades']:
                        probl.append('%s Trades %s' % (gamba, r.get('Trades')))
                    if round(r.get('Profit Factor') or 0, 4) != round(a['PF'], 4):
                        probl.append('%s PF %s' % (gamba, r.get('Profit Factor')))
                    if (round(r.get('Profit Factor') or 0, 4) == round(a['PF'], 4)) != (abs((r.get('Profit Factor') or 0) - a['PF']) <= 0.00005 + 1e-12):
                        forma.append('%s G0 %s: PF %s contro %s -- testa (quarta decimale) e riga (|delta| <= 0,00005) DIVERGONO; vale la testa' % (t, gamba, r.get('Profit Factor'), a['PF']))
                    if abs((r.get('Profit') or 0) - a['Profit']) > r250.TOL_PROFIT + 1e-9:
                        probl.append('%s Profit %s' % (gamba, r.get('Profit')))
                    if abs((r.get('Equity DD %') or 0) - a['DD']) > r250.TOL_DD + 1e-9:
                        probl.append('%s DD %s' % (gamba, r.get('Equity DD %')))
                    # PG: la testa non ne fissa la forma; la riga usa |delta| <= 0,00005 (classe 875: la stessa forma)
                    if num(r.get('Peggior Giornata %')) is None or abs(r['Peggior Giornata %'] - a['PG']) > 0.00005 + 1e-9:
                        probl.append('%s PG %s' % (gamba, r.get('Peggior Giornata %')))
            ak = arch.get(j['fin'])
            if pt1 is None or ak is None:
                probl.append('per-trade o archivio assente')
            else:
                es, mot = r250.g1_pertrade(pt1, ak)
                if es != 'PASS':
                    probl.append('per-trade %s contro archivio: %s' % (j['g1'], mot))
                elif j['fin'] == 'B' and min(r['d'] for r in pt1) < R250_PRIMA_CHIUSURA_B:
                    probl.append('prima chiusura %s < 2025.07.01' % min(r['d'] for r in pt1))
            g0 = 'VERDE' if not probl else 'ROSSO (' + '; '.join(probl)[:220] + ')'
            E['g0'][t] = 'VERDE' if not probl else 'ROSSO'
            gr = (RP or {}).get('g0', {}).get(t)
            if gr == 'ROSSO' and E['g0'][t] == 'VERDE':
                E['g0'][t] = 'ROSSO'
                g0 = 'ROSSO (la RIGA lo scrive ROSSO, il lettore VERDE: vale il ROSSO, classe 873)'
        # 5.5 S2
        s2txt = 'n/a'
        if j['clk'] != 'd0' and pt1 is not None and dati.get(R250_D0[j['fin']], {}).get('pt1') is not None:
            com, opp = r250.s2(dati[R250_D0[j['fin']]]['pt1'], pt1)
            s2txt = '%d / %d' % (com, opp)
            E['s2'][t] = opp
        valido = bool(pin_ok and g1csv == 'PASS' and g1pt == 'PASS' and s1[0] == 'VERDE')
        rm = motivi_riga(RP, t)
        E['riga'][t] = rm
        if rm:
            valido = False     # classe 873: i NULLI della riga (motore, prova, rc 1, C0, S1 identita) si UNISCONO
        E['stato'][t] = 'VALIDO' if valido else 'NON VALIDO'
        E['s1'][t] = s1[0]
        E['pin'][t] = pin_ok
        d.update(valido=valido, csv_letti=csv_letti)
        dati[t] = d
        L.append('| %s | %s / %s | %s | %s | %s | %s | %s | %s %s | %s | %s | **%s** |' % (
            t, j['clk'], j['fin'], nis, noos, pin_txt, g1csv, g1pt, s1[0], s1[1], (g0 or 'n/a (non d0)'), s2txt,
            E['stato'][t] + ((' (NULLO DELLA RIGA: ' + '; '.join(rm)[:180] + ')') if rm else '')))
    L.append('')
    for x in forma:
        L.append('- DIVERGENZA DI FORMA (classe 875): ' + x)
    L.append('Fonti: `ROUND_<tag>/%s_%s_IS|OOS_<tag>.csv` [MISURATO], `PERTRADE/abtg_trades_%s_%s_<magic>.csv` [MISURATO], pin dal file prova. S1 sulle celle spostate confronta anche l identita col d0 della stessa finestra (per-trade identico = ROSSO). S2 informativo: opposti > 0 -> ogni zona si scrive "orologio + candela".' % (ea, sym, ea, sym))
    L.append('')
    # --- 5.3 G2
    L.append('### R250 -- G2 coerenza fra finestre (par. 5.3) e classe 844 (k = (somma net - Profit) / somma volumi, atteso 0 su U30USD)')
    L.append('')
    for a_, b_ in (('R250a', 'R250b'), ('R250c', 'R250d'), ('R250e', 'R250f')):
        da, db = dati[a_], dati[b_]
        if not (da['valido'] and db['valido']):
            L.append('- %s/%s: NON VERIFICABILE (un membro non VALIDO non certifica l altro, classe 781)' % (a_, b_))
            E['g2'][(a_, b_)] = 'NON VERIFICABILE'
            continue
        ptA, isB, isA = da['pt1'], db['ris'][0], da['ris'][0]
        n = len(ptA)
        somma = sum(r['net'] for r in ptA)
        volt = sum(r['volf'] for r in ptA)
        k844 = (somma - isB['Profit']) / volt if volt > 0 else None
        ok1 = n == int(isB['Trades']) and abs(somma - isB['Profit']) <= 0.005 * (n + 1) + 1e-9
        ok2 = r250.g1_csv(dict(Trades=isA['Trades'], PF=isA['Profit Factor'], Profit=isA['Profit'], DD=isA['Equity DD %']),
                          dict(Trades=isB['Trades'], PF=isB['Profit Factor'], Profit=isB['Profit'], DD=isB['Equity DD %'])) == 'PASS'
        E['g2'][(a_, b_)] = 'PASS' if (ok1 and ok2) else 'ROSSO'
        L.append('- %s/%s: per-trade A %d deal contro Trades _IS di B %d, somma %.2f contro Profit %.2f (tolleranza %.3f) -> %s; CSV _IS A = _IS B -> %s; k(844) = %s EUR/lotto [DERIVATO] -> **%s**'
                 % (a_, b_, n, int(isB['Trades']), somma, isB['Profit'], 0.005 * (n + 1), 'ok' if ok1 else 'ROSSO', 'ok' if ok2 else 'ROSSO', f2(k844, 3), E['g2'][(a_, b_)]))
    L.append('')
    # --- par. 6-7 zone e conferma
    L.append('### R250 -- zone Q/Q2/Qc e conferma (par. 6-7, r250_bande_attese.py; riferimenti = archivi R247 se G0 VERDE)')
    L.append('')
    stato, g0m = E['stato'], E['g0']
    mis, dettagli = {}, {}
    for camp, cells in (('A', dict(m1h=['R250c'], p1h=['R250e'])), ('AB', dict(m1h=['R250c', 'R250d'], p1h=['R250e', 'R250f']))):
        m = {}
        for lato, key_pf, key_n, stag in (('m1h', 'pf_m', 'n_m', 'E'), ('p1h', 'pf_p', 'n_p', 'I')):
            if all(dati[c]['valido'] for c in cells[lato]):
                pos = r250.unisci(*[r250.per_stagione(dati[c]['pt1']) for c in cells[lato]])
                m[key_pf] = r250.pf_pos(pos[stag])
                m[key_n] = len(pos[stag])
                altra = 'I' if stag == 'E' else 'E'
                dettagli[(camp, lato)] = dict(pf=m[key_pf], n=m[key_n], pf_altra=r250.pf_pos(pos[altra]), n_altra=len(pos[altra]))
        mis[camp] = m
    zone = {}
    for camp in ('A', 'AB'):
        if camp not in ref:
            zone[camp] = None
            continue
        s, z = r250.verdetto(stato, g0m, ref[camp], mis[camp], camp)
        zone[camp] = (s, z)
        E['zone'][camp] = z
        L.append('**Campione %s** (riferimenti d0: estate PF %.4f n %d, inverno PF %.4f n %d, D %.4f, Df %.4f; feriali E %d / I %d)' % (
            camp, ref[camp]['pE'], ref[camp]['nE'], ref[camp]['pI'], ref[camp]['nI'], ref[camp]['D'], ref[camp]['Df'], ref[camp]['fE'], ref[camp]['fI']))
        L.append('')
        for lato, nome in (('m1h', '-1h d ESTATE (vota)'), ('p1h', '+1h d INVERNO (vota)')):
            dd = dettagli.get((camp, lato))
            if dd:
                L.append('- [MISURATO] cella %s: PF %.4f su n %d posizioni; l altra stagione (stampata, NON vota): PF %.4f su n %d' % (nome, dd['pf'], dd['n'], dd['pf_altra'], dd['n_altra']))
            else:
                L.append('- cella %s: NON LEGGIBILE (file non VALIDO o G0 non VERDE)' % nome)
        L.append('- statistiche: ' + ', '.join('%s=%s' % (k, f2(s[k], 3)) for k in ('Q', 'Q2', 'Qc', 'S', 'Qf', 'Qf2', 'Qfc', 'Sf')))
        L.append('- zone: ' + ', '.join('%s %s' % (k, z[k]) for k in r250.ZONATE) + '; congiunta PF: %s; congiunta FREQ: %s' % (z['congiunta_PF'], z['congiunta_FREQ']))
        sg = r250.soglie(ref[camp])
        L.append('- soglie in unita della cella [DERIVATO]: PF -1h estate STAGIONE se <= %.4f, OROLOGIO se >= %.4f; PF +1h inverno OROLOGIO se <= %.4f, STAGIONE se >= %.4f; posizioni -1h STAGIONE se <= %.2f / OROLOGIO se >= %.2f; +1h OROLOGIO se <= %.2f / STAGIONE se >= %.2f'
                 % (sg['pf_m_stag'], sg['pf_m_orol'], sg['pf_p_orol'], sg['pf_p_stag'], sg['n_m_stag'], sg['n_m_orol'], sg['n_p_orol'], sg['n_p_stag']))
        L.append('')
    if zone.get('A') and zone.get('AB'):
        for stt in ('Qc', 'Qfc'):
            c = r250.conferma(zone['A'][1][stt], zone['AB'][1][stt])
            E['conferma'][stt] = c
            L.append('- **VERDETTO DI CONFERMA %s (par. 7.1: zona di A, scritta solo se A+B concorda; A+B e VETO, mai conferma): %s**' % ('PF' if stt == 'Qc' else 'FREQUENZA', c))
    elif zone.get('A'):
        for stt in ('Qc', 'Qfc'):
            c = r250.conferma(zone['A'][1][stt], 'NON LEGGIBILE')
            E['conferma'][stt] = c
            L.append('- **VERDETTO DI CONFERMA %s: %s**' % ('PF' if stt == 'Qc' else 'FREQUENZA', c))
    else:
        E['conferma'] = {'Qc': 'NON LEGGIBILE', 'Qfc': 'NON LEGGIBILE'}
        L.append('- **VERDETTO DI CONFERMA: NON LEGGIBILE** (archivi o G0 mancanti: classe 750)')
    s2tot = sum(v for v in E['s2'].values())
    L.append('- S2 (par. 5.5): giorni in verso opposto dal 2024.11.15 = %d -> %s' % (s2tot, 'ogni zona si legge come scritta (candela H4 esclusa per costruzione)' if s2tot == 0 else 'ogni zona si scrive "orologio + candela"'))
    L.append('- n e pavimento 150 (par. 8): sulla A ogni casella sta sotto 150 -> il verdetto e una lettura CAUSALE, "INDIZIO a n<150", ne promozione ne bocciatura.')
    if not senza_bande and 'A' in ref and 'AB' in ref:
        for camp in ('A', 'AB'):
            b = r250.bande(arch_pos[camp], ref[camp])
            L.append('- bande p10-p50-p90 del PF sotto le due ipotesi (bootstrap sugli archivi, seme 250) campione %s [DERIVATO]: -1h estate H_S n%d [%.2f; %.2f; %.2f] H_O n%d [%.2f; %.2f; %.2f]; +1h inverno H_S n%d [%.2f; %.2f; %.2f] H_O n%d [%.2f; %.2f; %.2f]'
                     % (camp, b['m1h_estate']['nS'], *b['m1h_estate']['S'], b['m1h_estate']['nO'], *b['m1h_estate']['O'],
                        b['p1h_inverno']['nS'], *b['p1h_inverno']['S'], b['p1h_inverno']['nO'], *b['p1h_inverno']['O']))
    L.append('')
    # --- par. 9 rischio, par. 10 lati, par. 11 costo
    L.append('### R250 -- rischio (par. 9, Emendamento B, a qualunque n), lati (par. 10), costo descrittivo (par. 11)')
    L.append('')
    L.append('| file | gamba | Equity DD % CSV | Peggior Giornata % CSV | DD saldo chiuso % (per-trade) | pegg. giornata chiusa % estate / inverno | lati: uscite di lunghi E/I, di corti E/I |')
    L.append('|---|---|---|---|---|---|---|')
    for t, d in dati.items():
        for gamba, rows in d['csv_letti']:
            r = rows[0]
            pt = d['pt1']
            if pt is None:
                L.append('| %s | %s | %s | %s | n/d | n/d | n/d |' % (t, gamba, f2(r.get('Equity DD %'), 4), f2(r.get('Peggior Giornata %'), 4)))
                continue
            # il per-trade e della gamba che gira per SECONDA: A -> IS, B -> OOS (testa par. 3)
            if (d['job']['fin'] == 'A' and gamba != 'IS') or (d['job']['fin'] == 'B' and gamba != 'OOS'):
                L.append('| %s | %s | %s | %s | (per-trade = altra gamba) | | |' % (t, gamba, f2(r.get('Equity DD %'), 4), f2(r.get('Peggior Giornata %'), 4)))
                continue
            pE = [x for x in pt if r250.stagione(x['d']) == 'E']
            pI = [x for x in pt if r250.stagione(x['d']) == 'I']
            pgE = peggior_giornata(pE)[0]
            pgI = peggior_giornata(pI)[0]
            lE = sum(1 for x in pE if x['tipo'] == 1)
            lI = sum(1 for x in pI if x['tipo'] == 1)
            L.append('| %s | %s | %s | %s | %.4f | %s / %s | %d/%d, %d/%d |' % (
                t, gamba, f2(r.get('Equity DD %'), 4), f2(r.get('Peggior Giornata %'), 4), dd_chiuso(pt), f2(pgE, 4), f2(pgI, 4), lE, lI, len(pE) - lE, len(pI) - lI))
    L.append('')
    L.append('Riferimenti per la lettura, NON soglie di questo round (testa par. 9): pausa Guardian 4,0% al giorno, muro statico FTMO 10%. Lati: deal_type 1 = chiude un lungo, 0 = chiude un corto (descrittivo, n per lato e stagione molto sotto 150).')
    for fin in ('A', 'B'):
        d0 = dati.get(R250_D0[fin])
        for c in [x for x in JOBS if x['r'] == 'R250' and x['fin'] == fin and x['clk'] != 'd0']:
            dc = dati.get(c['t'])
            if not (d0 and dc and d0['pt1'] and dc['pt1']):
                continue
            v0 = {r['d']: r['volf'] for r in d0['pt1']}
            vc = {r['d']: r['volf'] for r in dc['pt1']}
            com = [g for g in v0 if g in vc and vc[g] > 0]
            if com:
                rapp = st.median(v0[g] / vc[g] for g in com)
                L.append('- [DERIVATO] costo (par. 11, lettura a costo zero, NON un cancello 40x): rapporto mediano dei volumi d0/%s sui %d giorni comuni della finestra %s = %.3f (~ inverso del rapporto degli stop, sporcato dal passo 0,1 lotti a deposito 10000)' % (c['clk'], len(com), fin, rapp))
    L.append('- costo 40x in pre-mercato (-1h): [NON MISURATO] (testa par. 11): le celle -1h sono STRUMENTI, ESCLUSE PER COSTO come candidate finche il range delle 8:30 NY non e misurato.')
    L.append('')
    # --- curva in fase (metodo R255 par. 7/9), R1/R2/R3 asimmetrici
    L.append('### R250 -- CURVA IN FASE e R1/R2/R3 [DERIVATO: metodo di R255a par. 7 e 9; la testa R250a par. 9 NON fissa soglie -- e una LETTURA, non un cancello del round: un DERIVATO puo solo SEGNALARE, MAI bocciare]')
    L.append('')
    L.append('Curve per finestra (posizioni per position_id, stagione USA per data di chiusura): IN FASE (cash NY tutto l anno) = d0 d ESTATE + (+1h) d INVERNO; PRE-MERCATO (8:30 NY tutto l anno) = (-1h) d ESTATE + d0 d INVERNO; CONTROLLO = d0 intero (il BCM a ora fissa, = il contratto R247). Metodo A ribasato (r = net / saldo della SUA corsa) e B denaro. Riferimenti R1 (finestra A) e R2 (finestra B) = DD a saldo chiuso della curva CONTROLLO della stessa finestra (il contratto della cella), con e_eff = %.4f (R255a par. 7, pavimento simulato, NON misurato su questo motore): SEGNALAZIONE se min(A,B) x (1-e) > S; SOTTO IL CONTROLLO se max(A,B) x (1+e) <= S; NON RISOLTO altrimenti. R3 peggior giornata >= %.2f%% (soglia di casa; se il CONTROLLO d0 della finestra fa peggio, il riferimento e il SUO numero) sui metodi A e B. NESSUNA di queste parole e un verdetto: la testa R250a par. 9 scrive "riferimenti per la lettura (NON soglie di questo round)" -- una SEGNALAZIONE va a Claudio come domanda, non come BOCCIATA (il muro vero resta il Guardian 4,0%% e il 10%% FTMO, par. 9). Il rispetto si scrive "sotto il CONTROLLO su n = X" (classe 804: la P che un motore senza edge lo rispetti NON e data). SCARTO DI SALDO (classe 876): la curva in fase MESCOLA due corse (d0 e cella spostata); lo scarto |saldo della corsa / saldo della curva - 1| contiene PER COSTRUZIONE l utile dell altra stagione della corsa, quindi si stampa scomposto: COSTRUZIONE = corsa contro curva in denaro (B), RIBASAMENTO = curva B contro curva A (quello che la regola d ufficio di R255 vuole misurare).' % (E_EFF_R255, R3_SOGLIA))
    L.append('')
    for fin in ('A', 'B'):
        d0, dm, dp = (dati.get(x) for x in (R250_D0[fin], 'R250c' if fin == 'A' else 'R250d', 'R250e' if fin == 'A' else 'R250f'))
        if not (d0 and d0['valido'] and E['g0'].get(R250_D0[fin]) == 'VERDE'):
            L.append('- finestra %s: NON LEGGIBILE (d0 non VALIDO o G0 non VERDE)' % fin)
            E['fase'][fin] = None
            continue
        p0 = ribasa(posizioni(d0['pt1']))
        ctrl = curva(list(p0), 'B')
        S = ctrl['dd_pct']
        L.append('- finestra %s, CONTROLLO d0 [MISURATO dal per-trade %s]: n %d, Profit %.2f, PF %.4f, DD chiuso %.2f%% (= tetto R%s), pegg. giornata %s%% (%s), serie %d' % (
            fin, d0['job']['g1'], ctrl['n'], ctrl['profit'], ctrl['pf'] or 0, S, '1' if fin == 'A' else '2', f2(ctrl['pegg_pct']), ctrl['pegg_giorno'], ctrl['serie']))
        for nome, cella_E, cella_I in (('IN FASE (cash NY)', d0, dp), ('PRE-MERCATO (8:30 NY)', dm, d0)):
            if not (cella_E and cella_I and cella_E['valido'] and cella_I['valido']):
                L.append('  - %s: NON LEGGIBILE (cella spostata non VALIDA)' % nome)
                continue
            pE = [p for p in ribasa(posizioni(cella_E['pt1'])) if r250.stagione(p['data']) == 'E']
            pI = [p for p in ribasa(posizioni(cella_I['pt1'])) if r250.stagione(p['data']) == 'I']
            fase = sorted(pE + pI, key=lambda p: p['ct0'])
            cA, cB = curva(fase, 'A'), curva(fase, 'B')
            # scarto di saldo massimo (lettera di R255a par. 7) e la sua SCOMPOSIZIONE (classe 876)
            saldoA = saldoB = DEPOSITO
            scarti, costr, ribas = [], [], []
            for p in fase:
                scarti.append(abs(p['B_corsa'] / saldoA - 1.0))
                costr.append(abs(p['B_corsa'] / saldoB - 1.0))
                ribas.append(abs(saldoB / saldoA - 1.0))
                saldoA += p['net_curva_A']
                saldoB += p['net_curva_B']
            scarto = max(scarti) if scarti else 0.0
            sc_costr = max(costr) if costr else 0.0
            sc_ribas = max(ribas) if ribas else 0.0
            lo, hi = min(cA['dd_pct'], cB['dd_pct']), max(cA['dd_pct'], cB['dd_pct'])
            if lo * (1 - E_EFF_R255) > S:
                r12 = 'SEGNALAZIONE [DERIVATA]: DD sopra quello del CONTROLLO (min(A,B) x (1-e) = %.2f%% > %.2f%%) -- NON una bocciatura (testa R250a par. 9: nessuna soglia), va a Claudio come domanda' % (lo * (1 - E_EFF_R255), S)
            elif hi * (1 + E_EFF_R255) <= S:
                r12 = 'sotto il CONTROLLO su n = %d posizioni [DERIVATO]' % cA['n']
            else:
                r12 = 'NON RISOLTO [DERIVATO] (classe 550)'
            if scarto > 0.10 and 0.8 * S <= hi <= 1.2 * S and not r12.startswith('SEGNALAZIONE'):
                r12 = 'NON RISOLTO d ufficio [DERIVATO] (lettera di R255a par. 7: scarto di saldo %.1f%% > 10%%; di cui RIBASAMENTO %.1f%%: %s)' % (
                    scarto * 100, sc_ribas * 100, 'l eccesso e la COSTRUZIONE (utile dell altra stagione nella corsa), non il lotto' if sc_ribas <= 0.10 else 'il ribasamento da solo supera il 10%')
            # R3: riferimento = la soglia di casa, ma MAI piu severo del riferimento stesso: min(-1,10; pegg. giornata del CONTROLLO)
            s3 = min(R3_SOGLIA, ctrl['pegg_pct'])
            pmin = min(cA['pegg_pct'], cB['pegg_pct'])
            r3 = ('SEGNALAZIONE [DERIVATA]: peggior giornata %.2f%% sotto il riferimento %.2f%% -- NON una bocciatura (testa R250a par. 9)' % (pmin, s3)) if pmin < s3 - 1e-9 else 'sopra il riferimento su n = %d (riferimento %.2f%%) [DERIVATO]' % (cA['n'], s3)
            E['fase'][(fin, nome)] = dict(r12=r12, r3=r3, n=cA['n'], ddA=cA['dd_pct'], ddB=cB['dd_pct'], scarto=scarto, costr=sc_costr, ribas=sc_ribas)
            L.append('  - %s: n %d (%d estate + %d inverno), metodo A: Profit %.2f PF %.4f DD %.2f%% pegg %s%% serie %d | metodo B: Profit %.2f PF %.4f DD %.2f%% pegg %s%% serie %d | scarto di saldo max %.1f%% (lettera), scomposto (fattori, non addendi): COSTRUZIONE %.1f%% e RIBASAMENTO %.1f%% (classe 876) | **R%s %s** | **R3 %s**'
                     % (nome, cA['n'], len(pE), len(pI), cA['profit'], cA['pf'] or 0, cA['dd_pct'], f2(cA['pegg_pct']), cA['serie'],
                        cB['profit'], cB['pf'] or 0, cB['dd_pct'], f2(cB['pegg_pct']), cB['serie'], scarto * 100, sc_costr * 100, sc_ribas * 100, '1' if fin == 'A' else '2', r12, r3))
    L.append('')
    L.append('- MERITO sulla curva in fase: SOSPESO per aritmetica (n < 150 in ogni finestra, par. 8). Nessuna proposta di taglia. Il certificato di morte NON si scrive da un round solo.')
    L.append('')
    return L, E


# ============================================================================= R258
def delta_ora(n):
    if n is None or n < 150:
        return None
    return 0.40 if n < 233 else (0.33 if n < 300 else (0.28 if n < 1900 else 0.11))


def p_noedge_m1(n):
    ks = sorted(R258_P_NOEDGE)
    if n <= ks[0]:
        return R258_P_NOEDGE[ks[0]]
    if n >= ks[-1]:
        return R258_P_NOEDGE[ks[-1]]
    for a, b in zip(ks, ks[1:]):
        if a <= n <= b:
            return R258_P_NOEDGE[a] + (R258_P_NOEDGE[b] - R258_P_NOEDGE[a]) * (n - a) / (b - a)


def dd_fisso(row):
    """DD_fisso% = |Profit / RF| / 100 a deposito 10000 (testa par. 7). Profit 0 -> None."""
    pr, rf = row.get('Profit'), row.get('Recovery Factor')
    if pr is None or rf is None or rf == 0 or pr == 0:
        return None
    return abs(pr / rf) / 100.0


def riga_asse(rows, ax, val, tol=1e-6):
    for r in rows or []:
        v = num(r.get(ax))
        if v is not None and abs(v - val) <= tol:
            return r
    return None


def k1(trades_by_f, F, b, sym):
    """K1 dalla scansione di F (testa par. 7): F* = il piu grande G >= F della griglia con
    Trades(G) >= 0,5 x Trades(F); stop mediano in [F*/2+b, (F*+10)/2+b). Ritorna (esito, F*, lo, hi, x_lo, x_hi)."""
    c = R258_COSTO[sym]
    tF = trades_by_f.get(F)
    if tF is None or tF <= 0:
        return 'NON CALCOLABILE', None, None, None, None, None
    fs = max(G for G in R258_GRID if G >= F and trades_by_f.get(G) is not None and trades_by_f[G] >= 0.5 * tF)
    lo = fs / 2.0 + b
    hi = (fs + 10) / 2.0 + b
    xlo, xhi = lo / c, hi / c
    if fs == 70:
        es = 'AMMESSA' if xlo >= R258_X_OK else ('FRAGILE' if xlo > R258_X_MIN else 'NON RISOLTA (tetto della griglia, solo limite inferiore) -> ESCLUSA')
    elif xlo >= R258_X_OK:
        es = 'AMMESSA'
    elif xhi <= R258_X_MIN:
        es = 'ESCLUSA PER COSTO'
    elif xlo > R258_X_MIN and xhi < R258_X_OK:
        es = 'FRAGILE'
    elif xlo <= R258_X_MIN:
        es = 'NON RISOLTA -> ESCLUSA PER COSTO (scavalca il 13,3x)'
    else:
        es = 'NON RISOLTA -> FRAGILE (scavalca il 40x)'
    return es, fs, lo, hi, xlo, xhi


def leggi_htm_deals(path):
    """Report del tester (HTML, spesso UTF-16): tabella dei deal con Time / Direction / Commission / Volume / Profit.
    Ritorna (deals, header_trovato)."""
    if not os.path.isfile(path):
        return None, False
    by = open(path, 'rb').read()
    txt = None
    for enc in ('utf-8', 'utf-16', 'cp1252'):
        try:
            t = by.decode(enc)
        except UnicodeDecodeError:
            continue
        if re.search(r'<t[dr]', t, re.I):
            txt = t
            break
    if txt is None:
        return [], False
    idx = {}
    deals = []
    for tr in re.finditer(r'(?is)<tr[^>]*>(.*?)</tr>', txt):
        celle = [html.unescape(re.sub(r'<[^>]+>', '', c)).replace(chr(160), ' ').replace(chr(8201), ' ').strip()
                 for c in re.findall(r'(?is)<t[dh][^>]*>(.*?)</t[dh]>', tr.group(1))]
        if len(celle) < 8:
            continue
        if not idx:
            low = [c.lower() for c in celle]
            cand = {}
            for i, h in enumerate(low):
                if h in ('time', 'ora', 'orario'):
                    cand['t'] = i
                if h in ('direction', 'direzione'):
                    cand['dir'] = i
                if h in ('commission', 'commissione', 'commissioni'):
                    cand['comm'] = i
                if h in ('profit', 'profitto', 'utile'):
                    cand['prof'] = i
                if h in ('volume', 'volumi'):
                    cand['vol'] = i
            if all(k in cand for k in ('t', 'dir', 'comm')):
                idx = cand
            continue
        if len(celle) <= max(idx['t'], idx['dir'], idx['comm']):
            continue
        m = re.match(r'^(\d{4}\.\d{2}\.\d{2}) (\d{2}:\d{2}:\d{2})$', celle[idx['t']])
        if not m:
            continue
        dr = celle[idx['dir']].lower().strip()
        if dr not in ('in', 'out', 'in/out'):
            continue
        d = dict(d=m.group(1), t=m.group(2), dir=dr, comm=num(re.sub(r'[^0-9.\-]', '', celle[idx['comm']])))
        d['prof'] = num(re.sub(r'[^0-9.\-]', '', celle[idx['prof']])) if 'prof' in idx and len(celle) > idx['prof'] else None
        d['vol'] = num(re.sub(r'[^0-9.\-]', '', celle[idx['vol']])) if 'vol' in idx and len(celle) > idx['vol'] else None
        deals.append(d)
    return deals, bool(idx)


def r258_leggi(rac, RP=None):
    L, E = [], dict(nullo={}, k1={}, r1={}, esito={}, h1={}, h2={}, h3={}, ccomm=None, s2=None, m1={})
    ea = 'ABTG_Londra_ORB'
    L.append('## R258 -- LONDRA ORB ALL ORA GIUSTA (testa `prove/R258a_londra_T_GBPUSD_ora8_UK_TESTA.txt` par. 7-9)')
    L.append('')
    L.append('Catena E0/P0/F0/F1/G1/T1/X1/S1 (un cancello rosso = file NULLO, non vota); S2 e C-COMM sulla corsa singola; K1 costo dalla scansione di F (c all-in GBPUSD 0,840 / EURUSD 0,664 pip; 40x di lavoro, 13,3x duro); R1 DD_fisso% = |Profit/RF|/100 <= 5,0 in ogni gamba; M1-M4 SOLO blocco T con Trades OOS >= 150; righe designate R258a b=3 F=70 e R258d b=3 F=50; ora: H1/H2/H3 con delta(n) 0,40 / 0,33 / 0,28 / 0,11 (n<150: NON LEGGIBILE).')
    L.append('')
    dati = {}
    # --- lettura CSV e pin
    for j in [x for x in JOBS if x['r'] == 'R258']:
        t = j['t']
        sfx = '' if j['m'] == 4 else '_ohlc'
        cart = os.path.join(rac, 'ROUND_' + t)
        ris, nis = leggi_csv_opt(os.path.join(cart, '%s_%s_IS%s_%s.csv' % (ea, j['s'], sfx, t)))
        roos, noos = leggi_csv_opt(os.path.join(cart, '%s_%s_OOS%s_%s.csv' % (ea, j['s'], sfx, t)))
        pins, asse, fonte = leggi_pin(rac, j)
        dati[t] = dict(job=j, ris=ris, roos=roos, nis=nis, noos=noos, pins=pins, fonte=fonte, mot=[], saltato=False,
                       ricucito=(n_ricucite(nis) + n_ricucite(noos)) > 0)   # condizione (a) della classe 883: righe con campi in ECCESSO
        # SALTATO esiste SOLO per il blocco L (prerequisito M1 dal 2008): un file T/G/B/D/F senza cartella e NULLO
        if ris is None and roos is None and not os.path.isdir(cart):
            if j['blk'] == 'L':
                dati[t]['saltato'] = True
            else:
                dati[t]['mot'].append('cartella ROUND_%s ASSENTE (non un blocco L: NON e un salto, e un nullo)' % t)
    # --- catena per file
    L.append('### R258 -- catena per file')
    L.append('')
    L.append('| file | blocco/simbolo/ora | CSV _IS | CSV _OOS | E0 | P0 (confronti) | F0 | F1 | G1 | esito catena |')
    L.append('|---|---|---|---|---|---|---|---|---|---|')
    for t, d in dati.items():
        j = d['job']
        if d['saltato']:
            L.append('| %s | %s/%s/%s | ASSENTE | ASSENTE | - | - | - | - | - | **SALTATO** (cartella assente: blocco L senza prerequisito M1 o job non lanciato; NON un nullo di catena) |' % (t, j['blk'], j['s'], j.get('ora', '')))
            E['nullo'][t] = 'SALTATO'
            continue
        nr = len(j['av'])
        e0 = True
        for gamba, rows in (('IS', d['ris']), ('OOS', d['roos'])):
            if rows is None or len(rows) != nr:
                e0 = False
                d['mot'].append('E0 %s %s' % (gamba, 'assente' if rows is None else '%d righe (attese %d)' % (len(rows), nr)))
                continue
            for r in rows:
                if num(r.get('InpMinRangePips')) == 0 and (r.get('Trades') or 0) <= 0:
                    e0 = False
                    d['mot'].append('E0 %s riga F=0 con Trades 0' % gamba)
        # P0: tutti i pin numerici del file (non asse) uguali in ogni riga; asse coi valori attesi
        p0txt, p0ok = 'NON VERIFICABILE (prova: %s)' % d['fonte'], False
        if d['pins'] is not None and e0:
            nconf, div = 0, []
            for gamba, rows in (('IS', d['ris']), ('OOS', d['roos'])):
                vals = []
                for i, r in enumerate(rows):
                    for k, v in d['pins'].items():
                        pv = num(v)
                        if pv is None:
                            continue           # pin stringa (InpNewsFile, InpNewsCurrencies, InpComment): la riga non li confronta
                        nconf += 1
                        if k not in r:
                            div.append('%s riga %d colonna %s ASSENTE nel CSV' % (gamba, i + 1, k))
                            continue
                        if num(r[k]) is None or abs(num(r[k]) - pv) > 1e-6:
                            div.append('%s riga %d %s=%s (pin %s)' % (gamba, i + 1, k, r[k], v))
                    vals.append(num(r.get(j['ax'])))
                att = sorted(float(x) for x in j['av'])
                if sorted(v for v in vals if v is not None) != att:
                    div.append('%s asse %s = %s (attesi %s)' % (gamba, j['ax'], vals, att))
            p0ok = not div
            p0txt = ('VERDE (%d confronti, pin da %s)' % (nconf, d['fonte'])) if p0ok else ('ROSSO: ' + '; '.join(div)[:200])
            if not p0ok:
                d['mot'].append('P0')
        elif d['pins'] is None:
            d['mot'].append('P0 non verificabile')
        # F0
        f0 = 'n/a'
        if e0:
            f0ok = True
            for gamba, rows, fer in (('IS', d['ris'], j['fis']), ('OOS', d['roos'], j['foos'])):
                for r in rows:
                    tr = r.get('Trades') or 0
                    if tr > fer:
                        f0ok = False
                        d['mot'].append('F0 %s Trades %d > feriali %d (D8)' % (gamba, tr, fer))
                    if num(r.get('InpMinRangePips')) == 0 and tr < 0.30 * fer:
                        f0ok = False
                        d['mot'].append('F0 %s riga F=0 Trades %d < 0,30 x %d' % (gamba, tr, fer))
            f0 = 'VERDE' if f0ok else 'ROSSO'
        # F1 (T, F, L)
        f1 = 'n/a'
        if e0 and j['blk'] in ('T', 'F', 'L'):
            f1ok = True
            for gamba, rows in (('IS', d['ris']), ('OOS', d['roos'])):
                seq = [(num(r.get('InpMinRangePips')), r.get('Trades') or 0) for r in rows]
                seq.sort()
                tr = [x[1] for x in seq]
                if any(tr[i + 1] > tr[i] for i in range(len(tr) - 1)) or not any(tr[i + 1] < tr[i] for i in range(len(tr) - 1)):
                    f1ok = False
                    d['mot'].append('F1 %s: Trades in F %s (non decrescente o senza un calo stretto)' % (gamba, tr))
            f1 = 'VERDE' if f1ok else 'ROSSO'
        # G1 (G)
        g1 = 'n/a'
        if e0 and j['blk'] == 'G':
            g1ok = True
            for gamba, rows in (('IS', d['ris']), ('OOS', d['roos'])):
                a, b = rows[0], rows[1]
                for c in ('Profit', 'Profit Factor', 'Recovery Factor', 'Equity DD %', 'Trades'):
                    if num(a.get(c)) is None or num(b.get(c)) is None or abs(num(a[c]) - num(b[c])) > 1e-6:
                        g1ok = False
                        d['mot'].append('G1 %s %s: %s contro %s' % (gamba, c, a.get(c), b.get(c)))
            g1 = 'VERDE' if g1ok else 'ROSSO'
        d['e0'] = e0
        # classe 873: i NULLI della riga si UNISCONO. Eccezione DICHIARATA (classe 883): nel formato VECCHIO
        # (binario al pin 02c70e17) la virgola dentro InpNewsCurrencies=GBP,USD sposta di un campo le colonne
        # che la seguono (InpComment, InpMagic, InpMaxSpread, InpVerbose) e Import-Csv della riga SCARTA il
        # campo in piu': il P0 della riga (e l'ASSE InpMagic del blocco G) e' letto su colonne SPOSTATE.
        # Si esenta SOLO se (a) il CSV ha DAVVERO righe con piu' campi dell'intestazione (ricucito, contate da
        # n_ricucite) E (b) il P0 del lettore sulle colonne ricucite e' VERDE; ogni altro motivo della riga vale.
        # Formato NUOVO (scrittore RFC 4180 di a66dcb07): i campi coincidono, Import-Csv legge giusto, quindi
        # NESSUNA esenzione: il P0 della riga vale (28/09/2026).
        d['riga_esenti'] = []
        for m in motivi_riga(RP, t):
            spost = d['ricucito'] and p0ok and (m.startswith('P0 PIN DAL CSV') or (m.startswith('ASSE DIVERSO') and j['blk'] == 'G'))
            if spost:
                d['riga_esenti'].append(m)
            else:
                d['mot'].append('RIGA: ' + m)
        L.append('| %s | %s/%s/%s | %s | %s | %s | %s | %s | %s | %s | %s |' % (
            t, j['blk'], j['s'], j.get('ora', ''), d['nis'], d['noos'], 'VERDE' if e0 else 'ROSSO', p0txt, f0, f1, g1,
            ('**NULLO**: ' + '; '.join(d['mot'])[:200] if d['mot'] else 'passa')
            + ((' | NULLO della riga NON unito (colonne spostate dalla virgola di InpNewsCurrencies, classe 883; P0 del lettore VERDE sulle colonne ricucite): ' + '; '.join(d['riga_esenti'])[:160]) if d['riga_esenti'] else '')))
    L.append('')
    # --- T1, X1, S1 (incrociati)
    L.append('### R258 -- controlli incrociati T1 (TF inerte), X1 (identita fra file), S1 (l ora morde)')
    L.append('')

    # "al centesimo" (testa par. 7 T1/X1) con la STESSA forma della riga (X1C): Trades identici, PF entro 0,00005,
    # Profit e Equity DD % entro 0,005 -- NON 0,01 sul PF, che lascerebbe passare due PF diversi (classe 875)
    X1C = (('Trades', 1e-6), ('Profit Factor', 0.00005), ('Profit', 0.005), ('Equity DD %', 0.005))

    def uguale_cent(a, b):
        return all(num(a.get(c)) is not None and num(b.get(c)) is not None and abs(num(a[c]) - num(b[c])) <= tol + 1e-9 for c, tol in X1C)

    t1_ko = False
    for g, a in R258_TF_LINK.items():
        dg, da = dati[g], dati[a]
        if not (dg.get('e0') and da.get('e0')):
            L.append('- T1 %s contro %s: NON VERIFICABILE (E0)' % (g, a))
            continue
        ok = True
        for gamba, rg, ra in (('IS', dg['ris'], da['ris']), ('OOS', dg['roos'], da['roos'])):
            r0 = riga_asse(ra, 'InpMinRangePips', 0)
            if r0 is None or not all(uguale_cent(x, r0) for x in rg):
                ok = False
        L.append('- T1 %s (M30) = riga F=0 di %s (M5), Profit/PF/Trades/DD al centesimo, IS e OOS: **%s**%s' % (g, a, 'VERDE' if ok else 'ROSSO', '' if ok else ' -> l EA dipende dal grafico contro il sorgente: TUTTO il round NULLO fino a diagnosi'))
        if not ok:
            t1_ko = True
    for (u, axn, axv, a, F) in R258_X1:
        du, da = dati[u], dati[a]
        if not (du.get('e0') and da.get('e0')):
            L.append('- X1 %s contro %s: NON VERIFICABILE (E0)' % (u, a))
            continue
        ok = True
        for gamba, ru, ra in (('IS', du['ris'], da['ris']), ('OOS', du['roos'], da['roos'])):
            x, y = riga_asse(ru, axn, axv), riga_asse(ra, 'InpMinRangePips', F)
            if x is None or y is None or not uguale_cent(x, y):
                ok = False
        L.append('- X1 riga %s=%s di %s = riga F=%d di %s, al centesimo IS e OOS: **%s**%s' % (axn, axv, u, F, a, 'VERDE' if ok else 'ROSSO', '' if ok else ' -> un pin non e arrivato: i due file NULLI'))
        if not ok:
            dati[u]['mot'].append('X1')
            dati[a]['mot'].append('X1')
    for (symb, blk), ore in R258_ORE.items():
        ds = {h: dati[tag] for h, tag in ore.items()}
        if not all(x.get('e0') for x in ds.values()):
            L.append('- S1 %s blocco %s: NON VERIFICABILE (E0 su almeno un file d ora)' % (symb, blk))
            continue
        ko = set()
        for gamba in ('ris', 'roos'):
            rr = {h: riga_asse(ds[h][gamba], 'InpMinRangePips', 0) for h in ds}
            for h1, h2 in ((7, 8), (8, 9), (7, 9)):
                a, b = rr[h1], rr[h2]
                if a is None or b is None or (a.get('Trades') == b.get('Trades') and abs((a.get('Profit') or 0) - (b.get('Profit') or 0)) < 1e-6):
                    ko.add((h1, h2))
        # testa par. 7 S1: "Uguali = pin non arrivati -> QUEI file NULLI": solo i file delle coppie uguali (classe 875)
        nulli_s1 = sorted({h for c in ko for h in c})
        L.append('- S1 %s blocco %s: righe b=3 F=0 delle tre ore differiscono a due a due in Trades o Profit in ogni gamba: **%s**%s' % (
            symb, blk, 'VERDE' if not ko else 'ROSSO', '' if not ko else ' -> coppie uguali %s: pin d ora non arrivati, NULLI i file delle ore %s' % (sorted(ko), nulli_s1)))
        for h in nulli_s1:
            ds[h]['mot'].append('S1 ora')
    # --- C-COMM e S2
    L.append('')
    L.append('### R258 -- C-COMM (il tester addebita la commissione forex?) e S2 (uscite dentro la giornata), corsa singola R258a b=3 F=0')
    L.append('')
    # la riga copia il report per NOME 'CCOMM_R258*.htm*' (il tester puo scrivere .htm o .html): si cerca uguale
    cc_dir = os.path.join(rac, 'CCOMM_R258')
    cc_rep = sorted(x for x in (os.listdir(cc_dir) if os.path.isdir(cc_dir) else []) if re.match(r'(?i)^CCOMM_R258.*\.html?$', x))
    deals, hdr = leggi_htm_deals(os.path.join(cc_dir, cc_rep[0] if cc_rep else 'CCOMM_R258.htm'))
    ccomm_ok, s2_ko = False, False
    if deals is None:
        L.append('- [NON VERIFICABILE] `CCOMM_R258/CCOMM_R258.htm` assente: C-COMM NON VERIFICATO -> M1 si scrive LORDO DI COMMISSIONE e NESSUNA riga puo essere promossa.')
        E['ccomm'] = 'NON VERIFICATO'
    elif not hdr or not deals:
        L.append('- [NON VERIFICABILE] report letto ma %s: C-COMM NON VERIFICATO.' % ('intestazione Commissione non trovata' if not hdr else 'zero deal'))
        E['ccomm'] = 'NON VERIFICATO'
    else:
        ncm = sum(1 for x in deals if x['comm'] is not None and abs(x['comm']) > 1e-6)
        scm = sum(x['comm'] for x in deals if x['comm'] is not None)
        ins = [x for x in deals if x['dir'] == 'in' and x['vol'] and x['comm'] is not None and x['vol'] > 0]
        kk = [abs(x['comm']) / x['vol'] for x in ins]
        ccomm_ok = ncm > 0
        E['ccomm'] = 'VERDE' if ccomm_ok else 'ROSSO'
        L.append('- [MISURATO] `CCOMM_R258/CCOMM_R258.htm`: deal letti %d (ingressi %d, uscite %d), deal con commissione != 0: %d, somma commissioni %.2f -> **%s**' % (
            len(deals), sum(1 for x in deals if x['dir'] == 'in'), sum(1 for x in deals if x['dir'] != 'in'), ncm, scm,
            'VERDE: il tester ADDEBITA la commissione' if ccomm_ok else 'ROSSO: commissione ZERO su tutti i deal -> ogni PF di R258 e LORDO di ~0,54/0,46 pip a operazione, M1 si scrive LORDO DI COMMISSIONE e NESSUNA riga puo essere promossa'))
        if kk:
            kmed = st.median(kk)
            in_banda = CL844_K[0] <= kmed <= CL844_K[1]
            L.append('- [DERIVATO] classe 844 (meta commissione sull INGRESSO): k mediano sugli ingressi = %.3f EUR/lotto (n %d, min %.3f max %.3f), banda attesa [%.0f; %.0f] -> %s' % (
                kmed, len(kk), min(kk), max(kk), CL844_K[0], CL844_K[1], 'in banda' if in_banda else 'FUORI BANDA: si dichiara (la commissione c e, ma non e quella misurata in casa)'))
        else:
            L.append('- classe 844: colonna Volume o deal d ingresso non trovati nel report -> k per lotto [NON VERIFICABILE]')
        fuori = [x for x in deals if x['dir'] != 'in' and (x['t'] < R258_S2_LO or x['t'] > R258_S2_HI)]
        s2_ko = bool(fuori)
        E['s2'] = 'KO' if s2_ko else 'VERDE'
        L.append('- S2 uscite fuori %s-%s: %d%s -> **%s**' % (R258_S2_LO, R258_S2_HI, len(fuori), (' (prima: %s %s)' % (fuori[0]['d'], fuori[0]['t'])) if fuori else '', 'KO: tutto R258 NULLO fino a diagnosi (riga, riepilogo)' if s2_ko else 'VERDE'))
    for t, d in dati.items():
        if d['saltato']:
            continue
        if t1_ko:
            d['mot'].append('T1 KO (round)')
        if s2_ko:
            d['mot'].append('S2 KO (C-COMM)')
        E['nullo'][t] = 'NULLO' if d['mot'] else 'passa'
    L.append('')
    # --- K1, R1, M1-M4, esiti per riga. DUE PASSATE (classe 874): prima le misure di ogni riga, poi M4
    #     sui file B, e SOLO DOPO la parola dell'esito, che dipende da M4 per le righe designate.
    L.append('### R258 -- per riga: scansione di F, K1 costo, R1 rischio, M1-M4 merito, esito (testa par. 7)')
    L.append('')
    L.append('| file | riga | Trades IS/OOS (quota feriali) | Profit IS/OOS | PF IS/OOS | RF OOS | DD_fisso% IS/OOS | K1 (F*, stop mediano, x) | R1 | M1-M4 | esito |')
    L.append('|---|---|---|---|---|---|---|---|---|---|---|')
    lordo = '' if ccomm_ok else ' LORDO DI COMMISSIONE (C-COMM %s)' % E['ccomm']
    righe_m = []
    for t, d in dati.items():
        j = d['job']
        if d['saltato'] or not d.get('e0'):
            continue
        # scansione di F per K1: dal file stesso (T/F/L) o dal file T dello stesso simbolo/ora 8 (G/B/D, via T1/X1)
        srcF = d if j['blk'] in ('T', 'F', 'L') else dati['R258a' if j['s'] == 'GBPUSD' else 'R258d']
        tf = {}
        if srcF.get('e0'):
            for G in R258_GRID:
                a_, b_ = riga_asse(srcF['ris'], 'InpMinRangePips', G), riga_asse(srcF['roos'], 'InpMinRangePips', G)
                if a_ is not None and b_ is not None:
                    tf[G] = (a_.get('Trades') or 0) + (b_.get('Trades') or 0)
        for ri, ro in zip(sorted(d['ris'], key=lambda r: num(r.get(j['ax'])) or 0), sorted(d['roos'], key=lambda r: num(r.get(j['ax'])) or 0)):
            axv = num(ri.get(j['ax']))
            F = int(num(ri.get('InpMinRangePips')) or 0)
            bb = num(ri.get('InpBufferPips'))
            bb = 3.0 if bb is None else bb
            es_k1, fs, lo, hi, xlo, xhi = k1(tf, F, bb, j['s']) if tf else ('NON CALCOLABILE', None, None, None, None, None)
            E['k1'][(t, axv)] = es_k1
            ddI, ddO = dd_fisso(ri), dd_fisso(ro)
            tI, tO = int(ri.get('Trades') or 0), int(ro.get('Trades') or 0)
            # R1 (testa par. 7): una VIOLAZIONE vale in QUALUNQUE gamba e a qualunque n; il rispetto a n < 150
            # si scrive "NON VIOLATO su n", mai "RISPETTATO" (classe 804); una gamba NON CALCOLABILE non
            # nasconde la violazione dell'altra.
            viol = [g for g, x in (('IS', ddI), ('OOS', ddO)) if x is not None and x > R258_R1_MAX]
            if j['blk'] == 'L':
                r1 = 'screening' + (' ALLARME DI REGIME' if viol else '')
            elif viol:
                r1 = 'VIOLATO (%s)' % '/'.join(viol)
            elif ddI is None or ddO is None:
                r1 = 'NON CALCOLABILE in una gamba (Profit 0: si legge l Equity DD %%), l altra non violata'
            elif tI >= 150 and tO >= 150:
                r1 = 'RISPETTATO'
            else:
                r1 = 'NON VIOLATO su n = %d/%d' % (tI, tO)
            if j['blk'] == 'D' and r1.startswith('VIOLATO'):
                r1 = r1 + ' [blocco D: R1 della testa vale per T, G, F -- segnalato, non boccia]'
            E['r1'][(t, axv)] = r1
            pfI, pfO, rfO = ri.get('Profit Factor'), ro.get('Profit Factor'), ro.get('Recovery Factor')
            mtxt, m12, m3 = 'n/a', None, None
            if j['blk'] in ('T', 'B') and tO >= 150:
                m1 = (pfO or 0) >= R258_M1
                m2 = (rfO or 0) >= R258_M2
                m3 = 'VERDE' if (tI >= 150 and (pfI or 0) >= 1.0) else ('ROSSO' if tI >= 150 else 'SOSPESO (n IS < 150)')
                mtxt = 'M1 %s%s (P senza edge a n %d: %.2f) M2 %s M3 %s' % ('VERDE' if m1 else 'ROSSO', lordo, tO, p_noedge_m1(tO), 'VERDE' if m2 else 'ROSSO', m3)
                m12 = m1 and m2
                E['m1'][(t, axv)] = m1
            elif j['blk'] in ('T', 'B'):
                mtxt = 'sospeso (n OOS %d < 150)' % tO
            righe_m.append(dict(t=t, j=j, ri=ri, ro=ro, axv=axv, F=F, b=bb, es_k1=es_k1, fs=fs, lo=lo, hi=hi, xlo=xlo, xhi=xhi,
                                ddI=ddI, ddO=ddO, tI=tI, tO=tO, r1=r1, mtxt=mtxt, m12=m12, m3=m3, pfI=pfI, pfO=pfO, rfO=rfO))
    # --- M4 sui file B (altopiano b=1/3/5, mai il picco), PRIMA degli esiti
    m4 = {}
    for tb, tdes in (('R258u', 'R258a'), ('R258v', 'R258d')):
        d = dati[tb]
        if not d.get('e0') or d['mot']:
            m4[tdes] = ('NON LEGGIBILE', 'file %s nullo o E0 rosso' % tb)
            continue
        passa = {}
        for bv in (1.0, 3.0, 5.0):
            r1v = E['r1'].get((tb, bv), '')
            passa[bv] = (not r1v.startswith('VIOLATO')) and not r1v.startswith('NON CALCOLABILE') and r1v != '' and E['m1'].get((tb, bv), False)
        if all(passa.values()):
            m4[tdes] = ('VERDE', 'b=1, b=3, b=5 passano TUTTE R1 e M1 -> vince il CENTRO b=3')
        elif any(passa.values()) and not passa[3.0]:
            m4[tdes] = ('BORDO', 'un BORDO sporge da solo (%s) -> DIREZIONE INDICATA, NON UNA CONFIGURAZIONE' % ', '.join('b=%g' % k for k, v in passa.items() if v))
        elif passa[3.0]:
            m4[tdes] = ('NON ALTOPIANO', 'solo %s passano R1 e M1: nessun altopiano (servono tutte e tre)' % ', '.join('b=%g' % k for k, v in passa.items() if v))
        else:
            m4[tdes] = ('ROSSO', 'nessuna riga passa R1 e M1 (o n OOS < 150: merito sospeso)')
        m4[tb] = m4[tdes]
    E['m4'] = m4
    # --- esiti, in quest'ordine (testa par. 7): NULLO, BOCCIATA PER RISCHIO, ESCLUSA PER COSTO, SOSPESA, INDIZIO, PROMOSSA
    for rm in righe_m:
        t, j, d = rm['t'], rm['j'], dati[rm['t']]
        es_k1, r1, tO, F, bb = rm['es_k1'], rm['r1'], rm['tO'], rm['F'], rm['b']
        designata = (t in R258_DESIGNATE and abs(bb - 3.0) < 1e-6 and F == R258_DESIGNATE[t]) or (j['blk'] == 'B' and abs(bb - 3.0) < 1e-6)
        if d['mot']:
            es = 'NULLO'
        elif r1.startswith('VIOLATO') and j['blk'] != 'D':
            es = 'BOCCIATA PER RISCHIO'
        elif 'ESCLUSA' in es_k1:
            es = 'ESCLUSA PER COSTO'
        elif j['blk'] == 'L':
            es = 'SCREENING (nessun verdetto)'
        elif j['blk'] in ('G', 'D', 'F'):
            es = 'MAPPA (nessun merito: blocco %s)' % j['blk']
        elif tO < 150:
            es = 'SOSPESA (n OOS %d < 150: merito sospeso, rischio %s)' % (tO, r1)
        elif not rm['m12'] or rm['m3'] == 'ROSSO':
            es = 'NON PASSA IL MERITO (M1/M2/M3 rosso a n OOS %d): mappa, non promuovibile' % tO
        elif rm['m3'] != 'VERDE':
            es = 'INDIZIO FAVOREVOLE (M1, M2 verdi; M3 sospeso: n IS < 150)'
        else:
            mv = m4.get(t, ('NON LEGGIBILE', 'M4 non applicabile'))[0] if designata else None
            if not designata:
                es = 'INDIZIO FAVOREVOLE (riga non designata: DIREZIONE INDICATA per il round dopo)'
            elif es_k1 != 'AMMESSA':
                es = 'INDIZIO FAVOREVOLE (K1 %s, non AMMESSA)' % es_k1
            elif not ccomm_ok:
                es = 'INDIZIO FAVOREVOLE (C-COMM %s: M1 LORDO DI COMMISSIONE)' % E['ccomm']
            elif mv != 'VERDE':
                es = 'NON PROMOSSA: M4 %s (%s)' % (mv, m4.get(t, ('', ''))[1])
            else:
                es = 'PROMOSSA AL PASSO SUCCESSIVO (mai in campo: prima D3/D4, orologio per data, firma di Claudio)'
        E['esito'][(t, rm['axv'])] = es
        qI, qO = rm['tI'] / j['fis'], tO / j['foos']
        ri, ro = rm['ri'], rm['ro']
        L.append('| %s | %s=%g | %d/%d (%.2f/%.2f) | %s/%s | %s/%s | %s | %s/%s | %s | %s | %s | **%s** |' % (
            t, j['ax'], rm['axv'], rm['tI'], tO, qI, qO, f2(ri.get('Profit')), f2(ro.get('Profit')), f2(rm['pfI'], 4), f2(rm['pfO'], 4), f2(rm['rfO'], 3), f2(rm['ddI']), f2(rm['ddO']),
            ('%s (F* %s, stop [%s; %s) pip = %s-%sx)' % (es_k1, rm['fs'], f2(rm['lo'], 1), f2(rm['hi'], 1), f2(rm['xlo'], 1), f2(rm['xhi'], 1))) if rm['fs'] is not None else es_k1, r1, rm['mtxt'], es))
    L.append('')
    L.append('Fonti: `ROUND_<tag>/%s_<simbolo>_IS|OOS[_ohlc]_<tag>.csv` [MISURATO]; K1, DD_fisso e quote [DERIVATO]. Per G/B/D la scansione di F viene dal file T dello stesso simbolo all ora 8 (identita T1/X1). Blocco L: screening, il DD su gambe di 8 anni NON si confronta col muro.' % ea)
    for tb in ('R258u', 'R258v'):
        L.append('- M4 %s (altopiano, mai il picco; decide la PROMOZIONE della riga designata %s): **%s** -- %s' % (tb, 'R258a F=70' if tb == 'R258u' else 'R258d F=50', m4.get(tb, m4.get('R258a' if tb == 'R258u' else 'R258d'))[0], m4.get(tb, m4.get('R258a' if tb == 'R258u' else 'R258d'))[1]))
    L.append('')
    # --- H1 / H2 / H3
    L.append('### R258 -- L ORA: H1 (ora fissa, blocco T), H2 (in fase, blocco F), H3 (screening, blocco L)')
    L.append('')
    for symb in ('GBPUSD', 'EURUSD'):
        ore = R258_ORE[(symb, 'T')]
        rows = {}
        for h, tag in ore.items():
            d = dati[tag]
            if d.get('e0') and not d['mot']:
                rows[h] = (riga_asse(d['ris'], 'InpMinRangePips', 0), riga_asse(d['roos'], 'InpMinRangePips', 0))
        for X, Y in ((8, 7), (9, 8)):
            if X not in rows or Y not in rows or None in rows[X] or None in rows[Y]:
                L.append('- H1 %s %d contro %d: NON LEGGIBILE (file nullo o riga F=0 assente)' % (symb, X, Y))
                E['h1'][(symb, X, Y)] = 'NON LEGGIBILE'
                continue
            (xi, xo), (yi, yo) = rows[X], rows[Y]
            nmin = min(int(xo['Trades'] or 0), int(yo['Trades'] or 0))
            dl = delta_ora(nmin)
            dpf = (xo['Profit Factor'] or 0) - (yo['Profit Factor'] or 0)
            if dl is None:
                v = 'NON LEGGIBILE (n OOS minimo %d < 150)' % nmin
            elif dpf >= dl and (xo['Profit'] or 0) > (yo['Profit'] or 0) and (xi['Profit Factor'] or 0) > (yi['Profit Factor'] or 0):
                v = '%d BATTE %d' % (X, Y)
            else:
                v = 'L ORA NON DECIDE (entro il rumore)'
            E['h1'][(symb, X, Y)] = v
            L.append('- H1 %s ora %d contro %d (righe b=3 F=0): PF OOS %s - %s = %+.3f contro delta(n=%d) = %s; Profit OOS %s / %s; PF IS %s / %s -> **%s**' % (
                symb, X, Y, f2(xo['Profit Factor'], 4), f2(yo['Profit Factor'], 4), dpf, nmin, f2(dl), f2(xo['Profit']), f2(yo['Profit']), f2(xi['Profit Factor'], 4), f2(yi['Profit Factor'], 4), v))
        # H2
        oreF = R258_ORE[(symb, 'F')]
        rf = {}
        for h, tag in oreF.items():
            d = dati[tag]
            if d.get('e0') and not d['mot']:
                rf[h] = (riga_asse(d['ris'], 'InpMinRangePips', 0), riga_asse(d['roos'], 'InpMinRangePips', 0))

        def comp(estate, inverno):
            gl_tot = gp_tot = 0.0
            for r in (estate, inverno):
                pf = r.get('Profit Factor')
                if pf is None or abs(pf - 1.0) < 0.005:
                    return None
                gl = (r.get('Profit') or 0) / (pf - 1.0)
                gl_tot += gl
                gp_tot += pf * gl
            return gp_tot / gl_tot if gl_tot else None
        if all(h in rf and None not in rf[h] for h in (7, 8, 9)):
            lon = (rf[8][0], rf[9][1])   # estate ora 8 (IS) + inverno ora 9 (OOS)
            pdf = (rf[7][0], rf[8][1])   # estate ora 7 + inverno ora 8
            pfL, pfP = comp(*lon), comp(*pdf)
            nL = int(lon[0]['Trades'] or 0) + int(lon[1]['Trades'] or 0)
            nP = int(pdf[0]['Trades'] or 0) + int(pdf[1]['Trades'] or 0)
            dl = delta_ora(min(nL, nP))
            if pfL is None or pfP is None:
                v = 'NON CALCOLABILE (|PF - 1| < 0,005 in una gamba)'
            elif dl is None:
                v = 'NON LEGGIBILE (n composto < 150)'
            elif (lon[0]['Profit'] or 0) > (pdf[0]['Profit'] or 0) and (lon[1]['Profit'] or 0) > (pdf[1]['Profit'] or 0) and pfL - pfP >= dl:
                v = 'LONDRA IN FASE BATTE IL PDF IN FASE (al massimo INDIZIO: una sola finestra annua)'
            else:
                v = 'L ORA IN FASE NON DECIDE (entro il rumore o Profit non migliore in tutte e due le stagioni)'
            E['h2'][symb] = v
            L.append('- H2 %s: LONDRA IN FASE (estate ora 8 + inverno ora 9) Profit %s + %s, PF composto %s su n %d; PDF IN FASE (estate ora 7 + inverno ora 8) Profit %s + %s, PF composto %s su n %d; delta %s -> **%s**' % (
                symb, f2(lon[0]['Profit']), f2(lon[1]['Profit']), f2(pfL, 4), nL, f2(pdf[0]['Profit']), f2(pdf[1]['Profit']), f2(pfP, 4), nP, f2(dl), v))
        else:
            E['h2'][symb] = 'NON LEGGIBILE'
            L.append('- H2 %s: NON LEGGIBILE (un file del blocco F nullo o assente)' % symb)
        # H3
        oreL = R258_ORE[(symb, 'L')]
        rl = {}
        for h, tag in oreL.items():
            d = dati[tag]
            if d.get('e0') and not d['mot']:
                rl[h] = (riga_asse(d['ris'], 'InpMinRangePips', 0), riga_asse(d['roos'], 'InpMinRangePips', 0))
        if all(h in rl and None not in rl[h] for h in (7, 8, 9)):
            ordI = sorted((7, 8, 9), key=lambda h: rl[h][0]['Profit Factor'] or 0)
            ordO = sorted((7, 8, 9), key=lambda h: rl[h][1]['Profit Factor'] or 0)
            gapI = min((rl[ordI[i + 1]][0]['Profit Factor'] or 0) - (rl[ordI[i]][0]['Profit Factor'] or 0) for i in range(2))
            gapO = min((rl[ordO[i + 1]][1]['Profit Factor'] or 0) - (rl[ordO[i]][1]['Profit Factor'] or 0) for i in range(2))
            v = 'l effetto dell ora HA UNA STORIA (stesso ordine 2008-16 e 2016-24, scarti >= 0,11)' if (ordI == ordO and gapI >= 0.11 and gapO >= 0.11) else 'nessuna storia stabile dell ora (ordine diverso o scarti < 0,11)'
            E['h3'][symb] = v
            L.append('- H3 %s (screening OHLC, dice se l effetto ha una storia, non se paga): PF IS per ora %s; PF OOS per ora %s -> %s' % (
                symb, ', '.join('%d: %s' % (h, f2(rl[h][0]['Profit Factor'], 3)) for h in (7, 8, 9)), ', '.join('%d: %s' % (h, f2(rl[h][1]['Profit Factor'], 3)) for h in (7, 8, 9)), v))
        else:
            E['h3'][symb] = 'NON LEGGIBILE'
            L.append('- H3 %s: NON LEGGIBILE (blocco L saltato, nullo o assente)' % symb)
    L.append('')
    # --- attese par. 6.2 e cosa NON misura par. 9
    L.append('### R258 -- le attese dichiarate prima (par. 6.2) contro i numeri, e cosa il round NON misura (par. 9)')
    L.append('')
    for symb in ('GBPUSD', 'EURUSD'):
        for h, tag in R258_ORE[(symb, 'T')].items():
            d = dati[tag]
            if not d.get('e0'):
                continue
            a0, o0 = riga_asse(d['ris'], 'InpMinRangePips', 0), riga_asse(d['roos'], 'InpMinRangePips', 0)
            if a0 is None or o0 is None:
                continue
            Fq = 60 if symb == 'GBPUSD' else 50
            aq, oq = riga_asse(d['ris'], 'InpMinRangePips', Fq), riga_asse(d['roos'], 'InpMinRangePips', Fq)
            tot0 = (a0['Trades'] or 0) + (o0['Trades'] or 0)
            totq = ((aq['Trades'] or 0) + (oq['Trades'] or 0)) if (aq and oq) else None
            es_k1, fs = k1({G: ((riga_asse(d['ris'], 'InpMinRangePips', G) or {}).get('Trades') or 0) + ((riga_asse(d['roos'], 'InpMinRangePips', G) or {}).get('Trades') or 0) for G in R258_GRID}, 0, 3.0, symb)[:2]
            L.append('- %s ora %d [DERIVATO]: (A) innesco b=3 F=0 = %.0f%% dei feriali IS / %.0f%% OOS (atteso 75-97%%); (B) quota di giornate operate con W >= %d pip (~ soglia 40x all-in) = %s (atteso < 10%% all ora 7, < 20%% all ora 8); (C) riga F=0: K1 %s con F* %s (atteso FRAGILE o ESCLUSA); (D) W(ora 8) > W(ora 7) si legge su F* qui sopra' % (
                symb, h, 100.0 * (a0['Trades'] or 0) / d['job']['fis'], 100.0 * (o0['Trades'] or 0) / d['job']['foos'], Fq, ('%.1f%%' % (100.0 * totq / tot0)) if (totq is not None and tot0) else 'n/d', es_k1, fs))
    L.append('- NON misurato da R258 (par. 9, dichiarato): la curva IN FASE riga per riga (D1: solo per gambe, H2, su UN anno); orari d uscita, peggior giornata e serie perdente (R2/R3 [NON MISURABILI], D1); il filtro notizie e la verifica S/R del PDF; la gestione dell uscita (R216a); i due lati separati; requote/rifiuti/spread storico; il giorno esatto del cambio d orologio (26 feriali IS ambigui); l orologio BCM prima del 2018; la frequenza di FAMIGLIA.')
    L.append('- Cosa chiude il candidato (par. 7): se su GBPUSD E EURUSD le righe F=0 delle tre ore hanno PF OOS < 1,00 con Trades OOS >= 150 e K1 FRAGILE o ESCLUSO -> in REGISTRO_TEST con PF, n, DD e cancello; il certificato resta NON ANCORA MISURATO finche manca il p.3 (R216a). Nessuna proposta di taglia.')
    L.append('')
    return L, E


# ============================================================================= R259
def r259_leggi(rac, RP=None):
    L, E = [], dict(d0={}, s0={}, s1={}, verdetto={}, pf={})
    ea = 'ABTG_Nightly'
    L.append('## R259 -- NIGHTLY sui sei simboli mai misurati (teste `prove/R259_nightly_*_PIN.txt` par. 5-6; `report/NIGHTLY_SEI_SIMBOLI_2026-09-26.md` par. 4)')
    L.append('')
    L.append('Screening a -Modello 1 (OHLC: ottimista sul PF di 1,72x-3,51x, sottostima il DD): NESSUNA promozione esce da qui. In ordine: D0 prima data M1 sul disco (STORICO_R259.csv, decide PrimaDataLocale), S0 ancora a zero, S1 cella di misura (0 operazioni = storico, non edge; op/feriale IS/OOS in 0,5-2,0), S2 n<150, S3 DD > 10% @1%, S4 frontiera del costo (dal referto par. 4.3, NON nella raccolta), S5 PF >= 1,10 in tutte e due le finestre (+ molteplicita ~25% su sei simboli).')
    L.append('')
    # STORICO
    stor = {}
    ps = os.path.join(rac, 'STORICO', 'STORICO_R259.csv')
    if os.path.isfile(ps):
        with open(ps, encoding='utf-8', errors='replace', newline='') as fh:
            for r in csv.DictReader(fh):
                if (r.get('Timeframe') or '').strip() == 'M1':
                    stor[(r.get('Simbolo') or '').strip()] = r
    else:
        L.append('- [NON VERIFICABILE] `STORICO/STORICO_R259.csv` assente: D0 non si legge per nessun simbolo (allora S1 a zero operazioni resta "storico o motore", indistinguibile).')
    L.append('| simbolo | D0 M1 sul disco (serve <=) | cella ancora (S0) | cella misura Trades IS/OOS (op/feriale) | S1 rapporto IS/OOS | Profit IS/OOS | PF IS/OOS | Equity DD % IS/OOS (S3) | DD_fisso% IS/OOS | S2 | S4 costo (referto) | S5 | verdetto |')
    L.append('|---|---|---|---|---|---|---|---|---|---|---|---|---|')
    for j in [x for x in JOBS if x['r'] == 'R259']:
        t, symb = j['t'], j['s']
        cart = os.path.join(rac, 'ROUND_' + t)
        ris, nis = leggi_csv_opt(os.path.join(cart, '%s_%s_IS_ohlc_%s.csv' % (ea, symb, t)))
        roos, noos = leggi_csv_opt(os.path.join(cart, '%s_%s_OOS_ohlc_%s.csv' % (ea, symb, t)))
        # D0
        sr = stor.get(symb)
        if sr is None:
            d0 = 'NON VERIFICABILE'
        else:
            pl = (sr.get('PrimaDataLocale') or '').strip()[:10]
            d0 = ('SODDISFATTO (disco dal %s, barre %s)' % (pl, sr.get('Barre'))) if (re.match(r'^\d{4}\.\d{2}\.\d{2}', pl) and pl <= j['m1']) else ('NON SODDISFATTO (disco dal %s, serve <= %s)' % (pl or '?', j['m1']))
        E['d0'][symb] = d0.split(' ')[0]
        if ris is None or roos is None:
            L.append('| %s | %s | [NON VERIFICABILE] CSV %s / %s | | | | | | | | %s | | **NON LETTO (CSV assenti)** |' % (symb, d0, nis, noos, R259_COSTO[symb][1]))
            E['verdetto'][symb] = 'NON LETTO'
            continue
        anc = float(j['anc'])
        aI, aO = riga_asse(ris, j['ax'], anc), riga_asse(roos, j['ax'], anc)
        mI, mO = riga_asse(ris, j['ax'], 0.0), riga_asse(roos, j['ax'], 0.0)
        if aI is None or aO is None or mI is None or mO is None:
            L.append('| %s | %s | righe attese (%s = %s e 0) non trovate nei CSV (%s / %s) | | | | | | | | %s | | **NON LETTO** |' % (symb, d0, j['ax'], j['anc'], nis, noos, R259_COSTO[symb][1]))
            E['verdetto'][symb] = 'NON LETTO'
            continue
        tAI, tAO = int(aI.get('Trades') or 0), int(aO.get('Trades') or 0)
        # S0: la cella ancora riproduce l'ARCHIVIO del SUO simbolo (testa par. 3; XAGUSD = 0/4 con numeri)
        xI, xO, xnum = R259_ANCORA[t]
        s0ok = (tAI == xI and tAO == xO)
        s0det = ''
        if s0ok and xnum:
            dv = [c for c, v, col, tol in (('Profit', xnum['Profit'], 'Profit', 0.05), ('PF', xnum['PF'], 'Profit Factor', 0.00005), ('DD', xnum['DD'], 'Equity DD %', 0.01))
                  if num(aO.get(col)) is None or abs(num(aO.get(col)) - v) > tol + 1e-9]
            if dv:
                s0ok = False
                s0det = ', OOS diverso dall archivio in ' + '/'.join(dv)
        s0 = ('VERDE (%d/%d = archivio%s)' % (tAI, tAO, ', Profit/PF/DD OOS entro le tolleranze della riga' if xnum else '')) if s0ok else \
             'ROSSO (%d/%d contro archivio %d/%d%s): ROUND NON LETTO finche non si sa perche' % (tAI, tAO, xI, xO, s0det)
        E['s0'][symb] = 'VERDE' if s0ok else 'ROSSO'
        tI, tO = int(mI.get('Trades') or 0), int(mO.get('Trades') or 0)
        qI, qO = tI / j['fis'], tO / j['foos']
        if tI == 0 or tO == 0:
            s1 = 'KO: cella di misura a 0 in %s -> NON e senza edge: storico M1 o motore che non riempie (prima D0)' % ('IS e OOS' if (tI == 0 and tO == 0) else ('IS' if tI == 0 else 'OOS'))
            E['s1'][symb] = 'ZERO'
        else:
            rap = qI / qO
            s1 = ('%.2f ok' % rap) if 0.5 <= rap <= 2.0 else ('%.2f FUORI 0,5-2,0: sospetto troncamento (classe 590), prima il disco' % rap)
            E['s1'][symb] = 'ok' if 0.5 <= rap <= 2.0 else 'FUORI'
        pfI, pfO = mI.get('Profit Factor'), mO.get('Profit Factor')
        ddI, ddO = mI.get('Equity DD %'), mO.get('Equity DD %')
        s2 = 'sospeso' if (tI < 150 or tO < 150) else 'leggibile'
        # S3 "DD > 10% @1%, deposito 10000": si guardano Equity DD % (relativo al picco) E DD a deposito fisso
        # |Profit/RF|/100 (classe 550); se dicono cose diverse si scrive quale ha deciso (il piu severo: Emendamento B)
        dfI, dfO = dd_fisso(mI), dd_fisso(mO)
        eq10 = any(x is not None and x > 10.0 for x in (ddI, ddO))
        fx10 = any(x is not None and x > 10.0 for x in (dfI, dfO))
        s3 = ('fuori per RISCHIO alla gestione di default' + ('' if eq10 else ' (dal DD a deposito fisso: l Equity DD % relativo sta sotto il 10%)')) if (eq10 or fx10) else 'DD <= 10%'
        s5 = 'screening PASSATO (molteplicita ~25%: un simbolo verde da solo non e un edge)' if (pfI is not None and pfO is not None and pfI >= 1.10 and pfO >= 1.10 and tI > 0 and tO > 0) else 'no'
        E['pf'][symb] = (pfI, pfO, tI, tO)
        # verdetto per simbolo con le tre ipotesi; i NULLI della riga (E0, S0, S1, motore, prova, rc 1) vengono PRIMA (classe 873)
        rmot = motivi_riga(RP, t)
        _pp, _aa, fonte9 = leggi_pin(rac, j)
        if _pp is None:
            rmot = rmot + ['prova del lettore: ' + fonte9]     # SHA diverso dal pin o prova assente (classe 873)
        if rmot:
            v = 'NULLO DELLA RIGA O DELLA PROVA (%s): i numeri qui sono DIAGNOSI, non votano' % '; '.join(rmot)[:200]
        elif E['s0'][symb] == 'ROSSO':
            v = 'ROUND NON LETTO (S0)'
        elif E['s1'][symb] != 'ok' or d0.startswith('NON'):
            v = 'NON ANCORA MISURATO (prima il disco: D0/S1)'
        elif s2 == 'sospeso':
            v = 'NON ANCORA MISURATO (n < 150 in una finestra: merito sospeso; rischio letto: %s)' % s3
        elif s5 != 'no':
            v = 'INDIZIO di edge SOLO A SCREENING (serve tick reale + costo misurato; H_nullo passa per caso ~4,7%% per simbolo); S4 costo: %s; rischio: %s' % (R259_COSTO[symb][1], s3)
        elif pfO is not None and pfO < 1.10:
            v = 'NIENTE a questa gestione (PF OOS %.3f < 1,10 con n %d): scarto SENZA seconda griglia d ingresso, resta aperta solo l uscita (stadio 2) -- NON un certificato di morte' % (pfO, tO)
        else:
            v = 'lettura mista (PF IS < 1,10 con OOS >= 1,10): screening non passato, merito letto'
        E['verdetto'][symb] = v
        L.append('| %s | %s | %s | %d/%d (%.3f/%.3f) | %s | %s/%s | %s/%s | %s/%s (%s) | %s/%s | %s | %s: %s | %s | **%s** |' % (
            symb, d0, s0, tI, tO, qI, qO, s1, f2(mI.get('Profit')), f2(mO.get('Profit')), f2(pfI, 4), f2(pfO, 4), f2(ddI, 2), f2(ddO, 2), s3,
            f2(dd_fisso(mI)), f2(dd_fisso(mO)), s2, R259_COSTO[symb][0], R259_COSTO[symb][1], s5, v))
    L.append('')
    L.append('Fonti: `ROUND_R259_<simbolo>/%s_<simbolo>_IS|OOS_ohlc_R259_<simbolo>.csv` [MISURATO]; `STORICO/STORICO_R259.csv` [MISURATO]; frontiera del costo [DERIVATO dal referto par. 4.3, NON misurabile dalla raccolta: l ATR(14,H1) alle 05:00 sta nei log degli agenti, che il driver non raccoglie].' % ea)
    L.append('')
    L.append('Le tre ipotesi, dichiarate prima (referto par. 4.2) [STIMA]:')
    L.append('- H_NULLO (nessun edge, binomiale +1,28R/-1R, p 43,86%): PF mediano 1,006, banda 95% 0,66-1,50 a n=100 e 0,80-1,26 a n=300; P(PF >= 1,10) 0,30 a n 100, 0,20 a n 300; P(PF >= 1,10 in IS E OOS) ~4,7% per simbolo -> su sei simboli P(almeno uno verde per caso) ~25%.')
    L.append('- H_PDF (sui mercati attivi di notte il fade peggiora): PF(AUDUSD, USDJPY) <= PF dei dormienti %s. Se vengono MEGLIO, la lista nera del PDF e falsificata su BCM.' % R259_DORMIENTI)
    for symb in ('AUDUSD', 'USDJPY'):
        p = E['pf'].get(symb)
        if p and p[1] is not None and p[3] > 0:
            L.append('  - %s: PF OOS %.3f su n %d contro il tetto dei dormienti 1,049 -> %s' % (symb, p[1], p[3], 'MEGLIO dei dormienti (H_PDF contraddetta a screening)' if p[1] > 1.049 else 'NON meglio dei dormienti (H_PDF non contraddetta)'))
    L.append('- H_EDGE (PF vero 1,20): P(PF misurato >= 1,10) 72% a n 150 e 79% a n 300, ma DD > 10 R su 300 operazioni 82 volte su 100: il cancello S3 a 1% giudica la TAGLIA, non l edge (e la taglia la firma Claudio: nessuna proposta qui).')
    L.append('- Il certificato di morte NON si scrive da questo round: il p.3 (uscita ad asse, stadio 2) resta vuoto, e lo stadio 2 si scrive solo sui simboli che passano S0 e S1.')
    L.append('')
    return L, E


# ============================================================================= riepilogo e referto
def riepilogo(RP):
    L = []
    if not RP['presente']:
        L.append('- **[NON VERIFICABILE] `RIEPILOGO_ROUND_CORTI_A.txt` ASSENTE: classe 166 (motore = pin) NON VERIFICATA, SHA della prova solo dal lettore, rc 1 / C0 / freschezza dei CSV NON VERIFICATI. I NULLI della riga NON sono uniti: ogni esito qui sotto vale SOLO se la riga non li ha annullati (classe 873).**')
        return L
    chiavi = ('data:', 'fine:', 'pin :', 'ROUND PARTITI', 'CLASSE 166', 'CARTELLE ATTESE', 'PERTRADE R250', 'ARCHIVI R247', 'PREREQUISITO M1', 'CORSA SINGOLA', 'FILE SALTATI', 'FILE NON NULLI', 'R250 G0', 'R258 CONTROLLI')
    for r in RP['righe']:
        if any(r.startswith(k) for k in chiavi):
            L.append('- [MISURATO, riga] `%s`' % (r if len(r) <= 600 else r[:600] + ' ...[tagliata qui, intera nel file]'))
    L.append('- [MISURATO, riga] FILE NULLI della riga: %d%s' % (len(RP['nulli']), '' if RP['nulli'] else ' (nessuno)'))
    for tag, mot in RP['nulli'].items():
        L.append('  - %s: %s' % (tag, '; '.join(mot)))
    return L


def referto(rac, senza_bande=False):
    rac, nota = trova_raccolta(rac)
    RP = leggi_riepilogo(rac)
    L = ['# REFERTO ROUND CORTI A -- lettura della raccolta `%s`' % os.path.basename(rac), '',
         'Generato da `backtest_pipeline/leggi_round_corti_a.py` il %s. Criteri CONGELATI nei file di testa (R250a par. 5-11, R258a par. 7-9, R259 par. 5-6 + referto NIGHTLY par. 4). Etichette: [MISURATO] letto da un file della raccolta, [DERIVATO] calcolato o preso da un referto, [NON VERIFICABILE] file assente. NESSUNA proposta di taglia; nessuna promozione in campo; il certificato di morte non si scrive da un round solo.' % dt.date.today().isoformat(), '',
         'Cartelle ROUND_<tag> trovate: %d su %d.%s' % (conta_cartelle(rac), len(JOBS), (' ' + nota) if nota else ''), '',
         '## 0. Il RIEPILOGO della riga (cosa e uscito, non il verdetto) e i NULLI della riga UNITI a quelli del lettore (classe 873)', '']
    L += riepilogo(RP)
    L.append('')
    l1, e1 = r250_leggi(rac, senza_bande, RP)
    l2, e2 = r258_leggi(rac, RP)
    l3, e3 = r259_leggi(rac, RP)
    # divergenze riga/lettore, per nome (si stampano tutte e due le direzioni)
    div = []
    if RP['presente'] and RP['nonnulli'] is not None:
        for j in JOBS:
            t = j['t']
            let_nullo = (e1['stato'].get(t) == 'NON VALIDO') if j['r'] == 'R250' else \
                        (e2['nullo'].get(t) == 'NULLO') if j['r'] == 'R258' else \
                        (not str(e3['verdetto'].get(t.split('_')[1], '')).startswith(('INDIZIO', 'NIENTE', 'lettura mista', 'NON ANCORA')))
            riga_nullo = t in RP['nulli']
            if let_nullo and not riga_nullo and t not in RP['saltati']:
                div.append('- %s: NON NULLO per la riga, NULLO / NON VALIDO / NON LETTO per il lettore (il lettore e piu severo: vedi il motivo nella sua tabella)' % t)
            if riga_nullo and j['r'] == 'R258' and e2['nullo'].get(t) != 'NULLO':
                div.append('- %s: NULLO per la riga, NON nullo per il lettore -- motivi della riga NON uniti perche letti su colonne spostate dalla virgola di InpNewsCurrencies (classe 883): %s' % (t, '; '.join(RP['nulli'][t])[:220]))
    L += l1 + l2 + l3
    L += ['## DIVERGENZE fra la riga e il lettore (per nome)', ''] + (div or ['- nessuna' if RP['presente'] else '- NON VERIFICABILE (RIEPILOGO assente)']) + ['']
    L += ['## NON LEGGIBILE DALLO SCRIPT (da fare a mano nel referto)', '',
          '- R250: il 40x in pre-mercato (par. 11) e il range delle 8:30 NY; ogni conseguenza per FTMO (par. 7.2, [INFERITA]); la lettura dei LOG_TESTER; la classe 166 (SHA256 del motore) la verifica SOLO la riga: qui si UNISCONO i suoi NULLI.',
          '- R258: C-COMM se il report .htm non ha la tabella dei deal con Time/Direction/Commission; lo spread STORICO 2024-26 del tester; l orologio prima del 2018; la frequenza di famiglia; D3/D4 (difetti da campo) e la firma di Claudio prima di ogni passo.',
          '- R259: l ATR(14,H1) alle 05:00 (log degli agenti, non raccolti) e quindi la frontiera del costo per simbolo (S4 e presa dal referto, non dai dati); lo spread h05 di AUDUSD e XAGUSD; i per-trade (l EA non li scrive): separare le notti col box spostato dall orologio; il muro tick per AUDUSD/USDJPY/metalli.',
          '- Tutto: la decisione (firme di Claudio: taglie, sedie, conto reale) e la data del cambio d ora; il REGISTRO_TEST si aggiorna a mano con PF, n, DD e cancello.']
    return '\n'.join(L), dict(r250=e1, r258=e2, r259=e3, riepilogo=RP)


# ============================================================================= FIXTURE (autotest)
def _scrivi(path, righe):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w', encoding='ascii', newline='') as fh:
        fh.write('\r\n'.join(righe) + ('\r\n' if righe else ''))


def _pt_righe(rows, magic):
    out = ['close_time;symbol;magic;position_id;deal_type;volume;price;net_profit']
    for r in rows:
        out.append('%s;U30USD;%s;%s;%d;%s;%s;%.2f' % (r['ct'], magic, r['pid'], r['tipo'], r['vol'], r['px'], r['net']))
    return out


def _csv_da_righe(header, rows_vals):
    return [','.join(header)] + [','.join(str(v) for v in vals) for vals in rows_vals]


def _stat_pt(rows):
    """Profit, PF, EqDD (dal saldo chiuso, come minorante), Peggior giornata, Trades per un per-trade sintetico."""
    gp = sum(r['net'] for r in rows if r['net'] > 0)
    gl = -sum(r['net'] for r in rows if r['net'] < 0)
    pf = gp / gl if gl > 0 else 0.0
    prof = sum(r['net'] for r in rows)
    dd = dd_chiuso(rows)
    pg = peggior_giornata(rows)[0] or 0.0
    return prof, pf, dd, pg, len(rows)


def _shift(rows, ore, fattore_E=1.0, fattore_I=1.0, lato='vinc'):
    """cella spostata sintetica: close_time +- ore, net moltiplicato (vincenti o perdenti) per stagione."""
    out = []
    for r in rows:
        ct = dt.datetime.strptime(r['ct'], '%Y.%m.%d %H:%M:%S') + dt.timedelta(hours=ore)
        f = fattore_E if r250.stagione(r['d']) == 'E' else fattore_I
        net = r['net']
        if (lato == 'vinc' and net > 0) or (lato == 'perd' and net < 0):
            net = net * f
        out.append(dict(r, ct=ct.strftime('%Y.%m.%d %H:%M:%S'), t=ct.strftime('%H:%M:%S'), d=ct.date(), net=round(net, 2)))
    return out


def costruisci_fixture(base, scenario='pulito'):
    """Raccolta finta con la struttura della riga. R250 dagli archivi VERI di R247 (per-trade) e dal CSV di R245b
    (ancora, Pass 3); R258/R259 CSV finti con le colonne del driver."""
    rac = os.path.join(base, 'ROUND_CORTI_A_' + scenario)
    if os.path.isdir(rac):
        shutil.rmtree(rac)
    os.makedirs(rac)
    arch_dir = os.path.join(QUI, 'risultati_archivio')
    # ---- R250
    ea, sym = 'ABTG_Nasdaq_Apertura_US', 'U30USD'
    ptA = leggi_pt(os.path.join(arch_dir, 'R247', 'PERTRADE', 'abtg_trades_%s_%s_765271.csv' % (ea, sym)))
    ptB = leggi_pt(os.path.join(arch_dir, 'R247', 'PERTRADE', 'abtg_trades_%s_%s_765273.csv' % (ea, sym)))
    assert ptA and ptB, 'archivi R247 non trovati nel repo'
    _scrivi(os.path.join(rac, 'archivio_R247_pertrade_765271.csv'), _pt_righe(ptA, '765271'))
    _scrivi(os.path.join(rac, 'archivio_R247_pertrade_765273.csv'), _pt_righe(ptB, '765273'))
    # CSV di R247 (colonne del driver, asse InpMagic) come stampo; ancora Pass 3 di R245b letta e verificata
    r245, _ = leggi_csv_opt(os.path.join(arch_dir, 'R245', 'ROUND_R245b', '%s_%s_IS_R245b.csv' % (ea, sym)))
    anc245 = riga_asse(r245, 'InpEmaSlow', 200)
    with open(os.path.join(arch_dir, 'R247', 'ROUND_R247a', '%s_%s_IS_R247a.csv' % (ea, sym)), encoding='utf-8', newline='') as fh:
        r247is = [x.rstrip('\r\n') for x in fh if x.strip()]
    with open(os.path.join(arch_dir, 'R247', 'ROUND_R247b', '%s_%s_OOS_R247b.csv' % (ea, sym)), encoding='utf-8', newline='') as fh:
        r247oos = [x.rstrip('\r\n') for x in fh if x.strip()]
    hdr = r247is[0].split(',')
    iMagic, iProf, iPF, iDD, iPG, iTr, iRF, iEP = (hdr.index(k) for k in ('InpMagic', 'Profit', 'Profit Factor', 'Equity DD %', 'Peggior Giornata %', 'Trades', 'Recovery Factor', 'Expected Payoff'))
    assert abs(float(r247is[1].split(',')[iProf]) - anc245['Profit']) < 1e-6, 'il CSV di R247a non e la cella Pass 3 di R245b'

    def riga_csv(stampo, magic, stat=None, pins=None):
        v = stampo.split(',')
        v[iMagic] = magic
        for c in (R250_PIN_COLS if pins else ()):
            if c in hdr and c in pins:
                v[hdr.index(c)] = pins[c]
        if stat is not None:
            prof, pf, dd, pg, n = stat
            v[iProf], v[iPF], v[iDD], v[iPG], v[iTr] = '%.2f' % prof, '%.5f' % pf, '%.4f' % dd, '%.4f' % pg, str(n)
            v[iRF] = '%.5f' % (prof / (dd * 100.0) if dd > 0 else 0.0)
            v[iEP] = '%.5f' % (prof / n if n else 0.0)
        return ','.join(v)
    celle = {}
    for j in [x for x in JOBS if x['r'] == 'R250']:
        src = ptA if j['fin'] == 'A' else ptB
        if j['clk'] == 'd0':
            rows = list(src)
        else:
            # H_OROLOGIO esatta: -1h d estate come il d0 d inverno (vincenti x pI/pE), +1h d inverno come il d0 d estate (perdenti x pI/pE)
            pos = r250.per_stagione(src)
            ref = r250.riferimenti(pos, r250.feriali(*r250.FIN[j['fin']]))
            q = ref['pI'] / ref['pE']
            rows = _shift(src, -1, fattore_E=q, lato='vinc') if j['clk'] == 'm1h' else _shift(src, +1, fattore_I=q, lato='perd')
        if scenario == 'g0_rosso' and j['t'] == 'R250a':
            rows = [dict(r) for r in rows]
            rows[0]['net'] = rows[0]['net'] + 0.05
        celle[j['t']] = rows
        _scrivi(os.path.join(rac, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (ea, sym, j['g1'])), _pt_righe(rows, j['g1']))
        _scrivi(os.path.join(rac, 'PERTRADE', 'abtg_trades_%s_%s_%s.csv' % (ea, sym, j['g2'])), _pt_righe(rows, j['g2']))
    for j in [x for x in JOBS if x['r'] == 'R250']:
        cart = os.path.join(rac, 'ROUND_' + j['t'])
        os.makedirs(cart)
        # copia del file prova dal repo (pin)
        shutil.copyfile(os.path.join(QUI, 'prove', j['p']), os.path.join(cart, j['p']))   # byte per byte, come Copy-Item del driver (SHA = pin)
        # gamba IS = finestra A (righe dell archivio A o della cella A), gamba OOS = finestra B
        tA = j['t'] if j['fin'] == 'A' else j['t'][:-1] + chr(ord(j['t'][-1]) - 1)
        rowsA = celle[tA]
        statA = None if j['clk'] == 'd0' else _stat_pt(rowsA)
        if scenario == 'g0_rosso' and j['t'] == 'R250a':
            statA = _stat_pt(rowsA)
        pins_j = leggi_pin(rac, j)[0]
        is_rows = [riga_csv(r247is[1], j['g1'], statA, pins_j), riga_csv(r247is[2], j['g2'], statA, pins_j)]
        _scrivi(os.path.join(cart, '%s_%s_IS_%s.csv' % (ea, sym, j['t'])), [r247is[0]] + is_rows)
        if j['fin'] == 'A':
            open(os.path.join(cart, '%s_%s_OOS_%s.csv' % (ea, sym, j['t'])), 'wb').close()
        else:
            statB = None if j['clk'] == 'd0' else _stat_pt(celle[j['t']])
            oos_rows = [riga_csv(r247oos[1], j['g1'], statB, pins_j), riga_csv(r247oos[2], j['g2'], statB, pins_j)]
            _scrivi(os.path.join(cart, '%s_%s_OOS_%s.csv' % (ea, sym, j['t'])), [r247oos[0]] + oos_rows)
        _scrivi(os.path.join(cart, 'REFERTO_ROUND_%s.txt' % j['t']), ['REFERTO ROUND (fixture)', 'tetto barre     : MaxBars=100000000'])
    # ---- R258
    import math
    import random
    rnd = random.Random(258)
    ea2 = 'ABTG_Londra_ORB'
    W_MED = {('GBPUSD', 7): 20.0, ('GBPUSD', 8): 32.0, ('GBPUSD', 9): 28.0, ('EURUSD', 7): 14.0, ('EURUSD', 8): 22.4, ('EURUSD', 9): 19.6}
    if scenario == 'k1_fallito':
        W_MED[('GBPUSD', 8)] = 8.0
    PF_OOS = {('GBPUSD', 7): 0.95, ('GBPUSD', 8): 1.05, ('GBPUSD', 9): 0.98, ('EURUSD', 7): 0.97, ('EURUSD', 8): 1.02, ('EURUSD', 9): 0.99}
    PF_IS = {k: v - 0.03 for k, v in PF_OOS.items()}
    if scenario == 'promossa':
        # la riga designata GBPUSD F=70 con n OOS >= 150 (canale largo), PF e RF alti, DD basso: deve arrivare a
        # PROMOSSA solo se M4 (R258u b=1/3/5) e verde -- contro-esempio della classe 874 (b)
        W_MED[('GBPUSD', 8)] = 150.0
        PF_OOS[('GBPUSD', 8)], PF_IS[('GBPUSD', 8)] = 1.60, 1.50
    if scenario in ('h1_010', 'h1_045'):
        PF_OOS[('GBPUSD', 7)] = 1.00
        PF_OOS[('GBPUSD', 8)] = 1.00 + (0.10 if scenario == 'h1_010' else 0.45)
        PF_IS[('GBPUSD', 7)] = 0.98
        PF_IS[('GBPUSD', 8)] = 1.05

    def quota_w(F, med):
        # W lognormale, sigma 0,5: P(W >= F)
        if F <= 0:
            return 1.0
        z = (math.log(F) - math.log(med)) / 0.5
        return 0.5 * math.erfc(z / math.sqrt(2))

    def riga_stat(n, pf, seed):
        """Profit, PF, RF, DD coerenti: Profit = n x 6 x (pf - 1) EUR circa, DD 3-4%."""
        prof = round(n * 6.0 * (pf - 1.0) + rnd.uniform(-3, 3), 2)
        if prof == 0:
            prof = 0.5
        dd_eur = round((300.0 + 40.0 * seed) * (0.5 if scenario == 'promossa' else 1.0), 2)
        rf = prof / dd_eur
        return prof, pf, rf, dd_eur / 100.0
    pins258 = {}
    for j in [x for x in JOBS if x['r'] == 'R258']:
        pins, asse, _ = leggi_pin(os.path.join(base, '_nessuna'), j)
        pins258[j['t']] = (pins, asse)

    def csv258(j, gamba, fer):
        pins, asse = pins258[j['t']]
        inp = [k for k in pins.keys() if k != asse]
        hdr = ['Pass', 'Profit', 'Expected Payoff', 'Profit Factor', 'Recovery Factor', 'Sharpe Ratio', 'Equity DD %', 'Trades'] + inp + [asse]
        vals = []
        # riferimento: la riga (b=3, F) del file T ora 8 dello stesso simbolo -> stesse cifre per T1/X1
        key = (j['s'], j.get('ora', 8))
        med = W_MED[key]
        base_pf = (PF_IS if gamba == 'IS' else PF_OOS)[key]
        if j['blk'] == 'F':
            base_pf = base_pf + (0.02 if gamba == 'IS' else 0.06)
        if j['blk'] == 'L':
            base_pf = base_pf - 0.05 + (0.0 if gamba == 'IS' else 0.01)
        for i, av in enumerate(j['av']):
            F = float(av) if j['ax'] == 'InpMinRangePips' else (float(j.get('fdes', 0)) if j['blk'] == 'B' else 0.0)
            b = float(av) if j['ax'] == 'InpBufferPips' else 3.0
            n = int(round(0.85 * fer * quota_w(F, med)))
            if j['blk'] == 'D' and av == '30':
                n = int(round(n * 0.9))
            pf = base_pf - 0.004 * (F / 10.0) + (0.002 * (b - 3.0)) + (0.01 if (j['blk'] == 'D' and av == '30') else 0.0)
            sd = int(F / 10) + int(b) + (11 if j['blk'] == 'D' and av == '30' else 0)
            rnd.seed(hash((j['s'], j.get('ora', 8), gamba, F, b, j['blk'] in ('F', 'L'), sd)) & 0xffff)
            prof, pf, rf, dd = riga_stat(n, pf, sd)
            row = [str(i), '%.2f' % prof, '%.5f' % (prof / n if n else 0), '%.5f' % pf, '%.5f' % rf, '0.10000', '%.4f' % dd, str(n)]
            for k in hdr[8:]:
                row.append(av if k == asse else pins.get(k, '0'))
            vals.append(row)
        return _csv_da_righe(hdr, vals)
    # per T1/X1 le righe di g/u/w devono essere identiche a quelle di a: costruisco prima a/d e poi copio
    csv_cache = {}
    for j in [x for x in JOBS if x['r'] == 'R258']:
        for gamba, fer in (('IS', j['fis']), ('OOS', j['foos'])):
            csv_cache[(j['t'], gamba)] = csv258(j, gamba, fer)

    def copia_riga(dst_tag, dst_ax, dst_val, src_tag, F, gamba):
        src = csv_cache[(src_tag, gamba)]
        sh = src[0].split(',')
        sr = [allinea_riga(sh, r)[0] for r in src[1:]]
        iF = sh.index('InpMinRangePips')
        srow = [r for r in sr if abs(float(r[iF]) - F) < 1e-6][0]
        dst = csv_cache[(dst_tag, gamba)]
        dh = dst[0].split(',')
        dr = [allinea_riga(dh, r)[0] for r in dst[1:]]
        iA = dh.index(dst_ax)
        for r in dr:
            if abs(float(r[iA]) - dst_val) < 1e-6:
                for c in ('Profit', 'Expected Payoff', 'Profit Factor', 'Recovery Factor', 'Equity DD %', 'Trades'):
                    r[dh.index(c)] = srow[sh.index(c)]
        csv_cache[(dst_tag, gamba)] = [dst[0]] + [','.join(r) for r in dr]
    for gamba in ('IS', 'OOS'):
        for mg in ('795840', '795890'):
            copia_riga('R258g', 'InpMagic', float(mg), 'R258a', 0, gamba)
        for mg in ('795841', '795891'):
            copia_riga('R258h', 'InpMagic', float(mg), 'R258d', 0, gamba)
        copia_riga('R258u', 'InpBufferPips', 3.0, 'R258a', 70, gamba)
        copia_riga('R258v', 'InpBufferPips', 3.0, 'R258d', 50, gamba)
        copia_riga('R258w', 'InpRangeStartMin', 0.0, 'R258a', 0, gamba)
        copia_riga('R258x', 'InpRangeStartMin', 0.0, 'R258d', 0, gamba)
    for j in [x for x in JOBS if x['r'] == 'R258']:
        cart = os.path.join(rac, 'ROUND_' + j['t'])
        os.makedirs(cart)
        shutil.copyfile(os.path.join(QUI, 'prove', j['p']), os.path.join(cart, j['p']))   # byte per byte, come Copy-Item del driver (SHA = pin)
        sfx = '' if j['m'] == 4 else '_ohlc'
        for gamba in ('IS', 'OOS'):
            _scrivi(os.path.join(cart, '%s_%s_%s%s_%s.csv' % (ea2, j['s'], gamba, sfx, j['t'])), csv_cache[(j['t'], gamba)])
        _scrivi(os.path.join(cart, 'REFERTO_ROUND_%s.txt' % j['t']), ['REFERTO ROUND (fixture)'])
    # C-COMM htm (UTF-16 come i report del tester)
    righe_htm = ['<html><body><table>', '<tr><th>Time</th><th>Deal</th><th>Symbol</th><th>Type</th><th>Direction</th><th>Volume</th><th>Price</th><th>Order</th><th>Commission</th><th>Swap</th><th>Profit</th><th>Balance</th><th>Comment</th></tr>']
    k844 = 2.30
    for i in range(20):
        g = dt.date(2024, 7, 8) + dt.timedelta(days=7 * (i // 5) + (i % 5))
        vol = 0.5 + 0.1 * (i % 4)
        for dr, tt, prof in (('in', '08:07:00', 0.0), ('out', '11:25:00', round(20.0 - 3.0 * (i % 7), 2))):
            righe_htm.append('<tr><td>%s %s</td><td>%d</td><td>GBPUSD</td><td>buy</td><td>%s</td><td>%.2f</td><td>1.27000</td><td>%d</td><td>%.2f</td><td>0.00</td><td>%.2f</td><td>10000.00</td><td></td></tr>' % (
                g.strftime('%Y.%m.%d'), tt, 2 * i + (dr == 'out'), dr, vol, 2 * i, -k844 * vol, prof))
    righe_htm.append('</table></body></html>')
    os.makedirs(os.path.join(rac, 'CCOMM_R258'))
    with open(os.path.join(rac, 'CCOMM_R258', 'CCOMM_R258.htm'), 'wb') as fh:
        fh.write('\n'.join(righe_htm).encode('utf-16'))
    _scrivi(os.path.join(rac, 'CCOMM_R258', 'CCOMM_R258.ini'), ['[Tester]', 'Expert=ABTG_Londra_ORB.ex5', 'Symbol=GBPUSD'])
    # STORICO
    _scrivi(os.path.join(rac, 'STORICO', 'STORICO_R258L.csv'), ['Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto', 'GBPUSD,M1,6000000,2008.01.02,1999.01.04,COMPLETO', 'EURUSD,M1,6000000,2008.01.02,1999.01.04,COMPLETO'])
    stor = ['Simbolo,Timeframe,Barre,PrimaDataLocale,PrimaDataServer,Verdetto']
    for s, d in (('AUDUSD', '2019.01.02'), ('USDJPY', '2019.01.02'), ('XAUUSD', '2024.09.26'), ('XAGUSD', '2025.02.28'), ('D30EUR', '2024.09.26'), ('U30USD', '2024.09.26')):
        stor.append('%s,M1,2000000,%s,%s,COMPLETO' % (s, d, d))
    _scrivi(os.path.join(rac, 'STORICO', 'STORICO_R259.csv'), stor)
    # ---- R259
    ea3 = 'ABTG_Nightly'
    MIS = {'AUDUSD': (400, 380, 0.95, 1.02, 14.2, 12.8), 'USDJPY': (350, 300, 1.15, 1.12, 8.1, 7.4), 'XAUUSD': (80, 120, 1.30, 0.90, 6.0, 9.0),
           'XAGUSD': (20, 100, 1.10, 1.00, 4.0, 11.0), 'D30EUR': (70, 110, 0.85, 0.92, 9.5, 12.5), 'U30USD': (75, 115, 1.05, 1.12, 7.0, 6.5)}
    for j in [x for x in JOBS if x['r'] == 'R259']:
        pins, asse, _ = leggi_pin(os.path.join(base, '_nessuna'), j)
        inp = [asse] + [k for k in pins.keys() if k != asse]
        hdr = ['Pass', 'Profit', 'Expected Payoff', 'Profit Factor', 'Recovery Factor', 'Sharpe Ratio', 'Equity DD %', 'Trades'] + inp
        cart = os.path.join(rac, 'ROUND_' + j['t'])
        os.makedirs(cart)
        shutil.copyfile(os.path.join(QUI, 'prove', j['p']), os.path.join(cart, j['p']))   # byte per byte, come Copy-Item del driver (SHA = pin)
        nI, nO, pfI, pfO, ddI, ddO = MIS[j['s']]
        for gamba, n, pf, dd in (('IS', nI, pfI, ddI), ('OOS', nO, pfO, ddO)):
            vals = []
            for i, av in enumerate(j['av']):
                if av == j['anc']:
                    tr = 3 if (scenario == 's0_trade' and j['s'] == 'AUDUSD') else 0
                    prof, pfv, rf, ddv = (-30.0, 0.0, -0.3, 1.0) if tr else (0.0, 0.0, 0.0, 0.0)
                    xI, xO, xnum = R259_ANCORA[j['t']]
                    if xnum and gamba == 'OOS' and scenario != 'xag_00':
                        # l'archivio di XAGUSD (testa par. 3): IS 0 / OOS 4, Profit 50.82, PF 1.26185, DD 1.6582
                        tr, prof, pfv, ddv = xO, xnum['Profit'], xnum['PF'], xnum['DD']
                        rf = prof / (ddv * 100.0)
                    row = [str(i), '%.2f' % prof, '0.00000', '%.5f' % pfv, '%.5f' % rf, '0.00000', '%.4f' % ddv, str(tr)]
                else:
                    prof = round(n * 4.0 * (pf - 1.0), 2) or 1.0
                    row = [str(i), '%.2f' % prof, '%.5f' % (prof / n), '%.5f' % pf, '%.5f' % (prof / (dd * 100.0)), '0.10000', '%.4f' % dd, str(n)]
                for k in inp:
                    row.append(av if k == asse else pins.get(k, '0'))
                vals.append(row)
            _scrivi(os.path.join(cart, '%s_%s_%s_ohlc_%s.csv' % (ea3, j['s'], gamba, j['t'])), _csv_da_righe(hdr, vals))
        _scrivi(os.path.join(cart, 'REFERTO_ROUND_%s.txt' % j['t']), ['REFERTO ROUND (fixture)'])
    # RIEPILOGO con le ETICHETTE VERE della riga (RIGA_ROUND_CORTI_A_R250_R258_R259.txt, 202505d6)
    _scrivi(os.path.join(rac, 'RIEPILOGO_ROUND_CORTI_A.txt'), [
        'RIEPILOGO ROUND CORTI A -- fixture ' + scenario, 'data: 2026-09-28 09:00:00', 'pin : 02c70e17eef870c26ef47b81942a0eb23d82aba8',
        'ROUND PARTITI (rc diverso da 1, non saltati): 36 su 36   SALTATI: 0',
        'CLASSE 166 (EA e include arrivano dal RAMO lavoro, non dal pin; SHA256 dopo ogni job: ...): MOTORE = PIN in tutti i 36 round partiti',
        'FILE SALTATI (non lanciati: prerequisito M1 del blocco L non soddisfatto; NON sono nulli di catena, escono dai conteggi perche non hanno numeri; R258o: si scrive un file NUOVO con la data misurata): nessuno',
        'FILE NULLI (rc 1, motore o prova diversi dal pin, E0, asse o P0, C0, G1, S1, F0, F1, T1, X1, S0, S2; escono da OGNI conteggio, classi 772/775/781): nessuno',
        'FILE NON NULLI, per nome: ' + ', '.join(j['t'] for j in JOBS),
        'R250 G0 RIPRODUZIONE DI R247 (solo d0: a = CSV _IS 154 / 1.25176 / 1180.94 / 7.1002 e per-trade 765301 = 765271 (file par. 5.2); b = anche _OOS; VERDE o ROSSO, classe 750): R250a VERDE | R250b VERDE'])
    if scenario == 'rfc4180':
        _riquota_rfc4180(rac)
    return rac


def _riquota_rfc4180(rac):
    """scenario rfc4180 (28/09/2026): gli STESSI CSV di R258 della fixture pulita riscritti come li scrive il
    binario compilato da HEAD (scrittore OptFrame di a66dcb07, RFC 4180): "GBP,USD" fra virgolette, InpComment
    con virgolette interne raddoppiate ("R258A LDN ""GBPUSD"" H8"), ogni altro campo byte per byte com era.
    csv.QUOTE_MINIMAL quota esattamente i campi con virgola/virgolette/a-capo, come OptFrame_CsvField."""
    for j in [x for x in JOBS if x['r'] == 'R258']:
        cart = os.path.join(rac, 'ROUND_' + j['t'])
        for nome in sorted(os.listdir(cart)):
            if not nome.endswith('.csv'):
                continue
            path = os.path.join(cart, nome)
            rr = open(path, encoding='ascii').read().splitlines()
            h = rr[0].split(',')
            iC = h.index('InpComment')
            buf = io.StringIO()
            w = csv.writer(buf, quoting=csv.QUOTE_MINIMAL, lineterminator='\n')
            w.writerow(h)
            for ln in rr[1:]:
                c, _ = allinea_riga(h, ln)
                c[iC] = c[iC].replace(j['s'], '"%s"' % j['s'])
                w.writerow(c)
            _scrivi(path, buf.getvalue().splitlines())


NULLI_T10 = ('R250c (S1: per-trade IDENTICO al d0 R250a (la manopola dell orario NON ha morso: pin non arrivato))'
             ' | R258a (MOTORE DIVERSO DAL PIN)'
             ' | R258b (P0 PIN DAL CSV _IS DIVERSO (24 valori: InpMagic=[R258B LDN GBPUSD H7] atteso 795807 InpMaxSpread=[795807] atteso 0 InpVerbose=[0] atteso 1); P0 PIN DAL CSV _OOS DIVERSO (24 valori: InpMagic=[R258B LDN GBPUSD H7] atteso 795807))'
             ' | R258g (ASSE DIVERSO nel _IS [NaN/NaN] attesi 795840/795890; P0 PIN DAL CSV _IS DIVERSO (6 valori: InpMaxSpread=[795840] atteso 0))'
             ' | R258e (E0: CSV NON BUONI (_IS fresco 8 righe (attese 8; Trades>0 su 8; righe F=0 a zero 0), _OOS ASSENTE O VECCHIO); P0 PIN DAL CSV _IS DIVERSO (1 valori: InpMagic=[x] atteso 795817))'
             ' | R259_USDJPY (S0 KO: ancora (cella 1) Trades IS 2 / OOS 0 contro archivio 0 / 0 -> ROUND NON LETTO (binario diverso dal sorgente citato, o dati diversi))')
# formato NUOVO (T19): il P0 della riga e LEGITTIMO (Import-Csv legge giusto le colonne quotate): pin diverso davvero
NULLI_T19 = ('R258b (P0 PIN DAL CSV _IS DIVERSO (1 valori: InpMagic=[795808] atteso 795807); P0 PIN DAL CSV _OOS DIVERSO (1 valori: InpMagic=[795808] atteso 795807))'
             ' | R258g (ASSE DIVERSO nel _IS [795840/795891] attesi 795840/795890)')


def _riepilogo_con_nulli(rp, nul):
    righe = open(rp, encoding='ascii').read().splitlines()
    righe = [('FILE NULLI (rc 1, motore o prova diversi dal pin, E0, asse o P0, C0, G1, S1, F0, F1, T1, X1, S0, S2; escono da OGNI conteggio, classi 772/775/781): ' + nul) if r.startswith('FILE NULLI') else
             (r.replace('R250b VERDE', 'R250b ROSSO (per-trade 765302 contro archivio 765273 riga 3 diversa)') if r.startswith('R250 G0') else r) for r in righe]
    _scrivi(rp, righe)


def autotest(base):
    os.makedirs(base, exist_ok=True)
    esiti = {}
    for sc in ('pulito', 'g0_rosso', 'k1_fallito', 's0_trade', 'h1_010', 'h1_045'):
        rac = costruisci_fixture(base, sc)
        txt, E = referto(rac, senza_bande=True)
        with open(os.path.join(base, 'REFERTO_%s.md' % sc), 'w', encoding='utf-8') as fh:
            fh.write(txt)
        esiti[sc] = E
        print('  fixture %-11s -> %s (%d righe di referto)' % (sc, rac, txt.count('\n')))
    P, F = esiti['pulito'], esiti['g0_rosso']
    # T1 caso pulito: G0 VERDE, 6 file VALIDI, conferma OROLOGIO sul PF (H_OROLOGIO costruita esatta), S2 = 0
    assert P['r250']['g0'] == {'R250a': 'VERDE', 'R250b': 'VERDE'}, P['r250']['g0']
    assert all(v == 'VALIDO' for v in P['r250']['stato'].values()), P['r250']['stato']
    assert P['r250']['conferma']['Qc'] == 'OROLOGIO', P['r250']['conferma']
    assert P['r250']['zone']['A']['Qfc'] == 'STAGIONE', P['r250']['zone']['A']   # frequenza invariata per costruzione: Qf = 0
    assert all(v == 0 for v in P['r250']['s2'].values()), P['r250']['s2']
    assert all(v == 'PASS' for v in P['r250']['g2'].values()), P['r250']['g2']
    # la fixture gonfia le perdite d inverno della +1h (x pI/pE): la curva IN FASE deve essere SEGNALATA (DD sopra
    # il controllo) ma MAI "BOCCIATA": la testa R250a par. 9 non fissa soglie, il blocco e [DERIVATO] (cancello 27/09)
    assert P['r250']['fase'][('A', 'IN FASE (cash NY)')]['r12'].startswith('SEGNALAZIONE'), P['r250']['fase']
    assert P['r250']['fase'][('A', 'PRE-MERCATO (8:30 NY)')]['r12'].startswith('sotto il CONTROLLO'), P['r250']['fase']
    assert P['r250']['fase'][('A', 'PRE-MERCATO (8:30 NY)')]['r3'].startswith('sopra il riferimento'), P['r250']['fase']
    t250 = open(os.path.join(base, 'REFERTO_pulito.md'), encoding='utf-8').read().split('## R258')[0]
    assert 'BOCCIATA' not in t250.replace('BOCCIATA,', '').replace('ne bocciatura', '').replace('una bocciatura', '').replace('MAI bocciare', '').replace('non come BOCCIATA', ''), 'R250: un DERIVATO scritto come BOCCIATA'
    # classe 876: lo scarto d ufficio della PRE-MERCATO B e COSTRUZIONE, e il referto lo scompone
    fb = P['r250']['fase'][('B', 'PRE-MERCATO (8:30 NY)')]
    assert fb['scarto'] > 0.10 and fb['ribas'] <= 0.10 and 'COSTRUZIONE' in fb['r12'], fb
    # T2 G0 rosso: R250a ROSSO, verdetto NON LEGGIBILE (classe 750)
    assert F['r250']['g0']['R250a'] == 'ROSSO' and F['r250']['g0']['R250b'] == 'VERDE', F['r250']['g0']
    assert F['r250']['conferma']['Qc'] == 'NON LEGGIBILE', F['r250']['conferma']
    assert F['r250']['fase']['A'] is None
    # T3 R258 pulito: nessun nullo, C-COMM verde, designata GBPUSD F=70 AMMESSA, F=0 FRAGILE, H1 non decide
    assert all(v == 'passa' for v in P['r258']['nullo'].values()), {k: v for k, v in P['r258']['nullo'].items() if v != 'passa'}
    assert P['r258']['ccomm'] == 'VERDE' and P['r258']['s2'] == 'VERDE'
    assert P['r258']['k1'][('R258a', 70.0)] == 'AMMESSA', P['r258']['k1'][('R258a', 70.0)]
    assert P['r258']['k1'][('R258a', 0.0)] == 'FRAGILE', P['r258']['k1'][('R258a', 0.0)]
    assert P['r258']['h1'][('GBPUSD', 8, 7)] == 'L ORA NON DECIDE (entro il rumore)', P['r258']['h1']
    # T4 K1 fallito: riga F=0 di R258a ESCLUSA PER COSTO (W mediano 8 pip), designata resta AMMESSA per costruzione
    K = esiti['k1_fallito']['r258']
    assert 'ESCLUSA' in K['k1'][('R258a', 0.0)], K['k1'][('R258a', 0.0)]
    assert K['esito'][('R258a', 0.0)] == 'ESCLUSA PER COSTO', K['esito'][('R258a', 0.0)]
    assert K['k1'][('R258a', 70.0)] in ('AMMESSA', 'NON CALCOLABILE'), K['k1'][('R258a', 70.0)]   # con W mediano 8 pip la riga F=70 puo avere 0 Trades
    # T5 contro-esempio dell ora (R258_rumore.py): +0,10 sta DENTRO il rumore (delta 0,33 a n 233-299), +0,45 esce
    H = esiti['h1_010']['r258']['h1']
    assert H[('GBPUSD', 8, 7)] == 'L ORA NON DECIDE (entro il rumore)', H
    H2 = esiti['h1_045']['r258']['h1']
    assert H2[('GBPUSD', 8, 7)] == '8 BATTE 7', H2
    # T6 R259 pulito: S0 verde ovunque; AUDUSD "niente a questa gestione"; USDJPY screening passato; XAUUSD sospeso; XAGUSD S1 fuori banda e D0 non soddisfatto
    R = P['r259']
    assert all(v == 'VERDE' for v in R['s0'].values()), R['s0']
    assert R['verdetto']['AUDUSD'].startswith('NIENTE a questa gestione'), R['verdetto']['AUDUSD']
    assert R['verdetto']['USDJPY'].startswith('INDIZIO di edge SOLO A SCREENING'), R['verdetto']['USDJPY']
    assert 'n < 150' in R['verdetto']['XAUUSD'], R['verdetto']['XAUUSD']
    assert R['s1']['XAGUSD'] == 'FUORI' and R['d0']['XAGUSD'] == 'NON' and R['verdetto']['XAGUSD'].startswith('NON ANCORA MISURATO'), (R['s1'], R['d0'], R['verdetto'])
    # T7 S0 che fa trade: AUDUSD ROUND NON LETTO, gli altri intatti
    S = esiti['s0_trade']['r259']
    assert S['s0']['AUDUSD'] == 'ROSSO' and S['verdetto']['AUDUSD'] == 'ROUND NON LETTO (S0)', (S['s0'], S['verdetto'])
    assert S['verdetto']['USDJPY'] == R['verdetto']['USDJPY']
    # T8 mai una proposta di taglia, mai "morto" nel referto pulito
    txt = open(os.path.join(base, 'REFERTO_pulito.md'), encoding='utf-8').read().lower()
    assert 'taglia proposta' not in txt and 'lotti consigliati' not in txt and 'morto' not in txt.replace('certificato di morte', '')
    # ---------------------------------------------------------------- contro-esempi del cancello del 27/09
    # T9 (classe 872): cartella madre con UNA raccolta -> si scende di un livello e lo si dichiara; cartella madre
    #    con PIU raccolte o vuota -> errore, MAI un referto di NULLI
    solo = os.path.join(base, '_madre_una')
    if os.path.isdir(solo):
        shutil.rmtree(solo)
    os.makedirs(solo)
    shutil.copytree(os.path.join(base, 'ROUND_CORTI_A_pulito'), os.path.join(solo, 'ROUND_CORTI_A_2026-09-27'))
    txtm, Em = referto(solo, senza_bande=True)
    assert 'scesa di UN livello' in txtm and Em['r250']['stato'] == P['r250']['stato'], 'T9 madre con una raccolta'
    for cattiva in (base, os.path.join(base, '_vuota')):
        os.makedirs(cattiva, exist_ok=True)
        try:
            referto(cattiva, senza_bande=True)
            raise AssertionError('T9: %s ha prodotto un referto' % cattiva)
        except SystemExit as e:
            assert 'classe 872' in str(e), e
    # T10 (classe 873 + 880): NULLI della riga uniti; P0/ASSE della riga su colonne SPOSTATE non uniti (e dichiarati);
    #     prova con SHA diverso dal pin -> P0 NON VERIFICABILE -> NULLO; G0 ROSSO della riga vince sul VERDE del lettore
    rac = costruisci_fixture(base, 'riga_nulli')
    rp = os.path.join(rac, 'RIEPILOGO_ROUND_CORTI_A.txt')
    _riepilogo_con_nulli(rp, NULLI_T10)
    with open(os.path.join(rac, 'ROUND_R258c', JOB['R258c']['p']), 'ab') as fh:
        fh.write(b'# un byte in piu dopo il pin\n')
    txtr, Er = referto(rac, senza_bande=True)
    assert Er['r250']['stato']['R250c'] == 'NON VALIDO' and Er['r250']['stato']['R250e'] == 'VALIDO', Er['r250']['stato']
    assert Er['r250']['g0']['R250b'] == 'ROSSO' and Er['r250']['g0']['R250a'] == 'VERDE', Er['r250']['g0']
    N = Er['r258']['nullo']
    assert N['R258a'] == 'NULLO' and N['R258b'] == 'passa' and N['R258g'] == 'passa' and N['R258c'] == 'NULLO' and N['R258e'] == 'NULLO', N
    assert 'classe 883' in txtr and 'R258b: NULLO per la riga, NON nullo per il lettore' in txtr, 'T10: esenzione non dichiarata'
    assert Er['r259']['verdetto']['USDJPY'].startswith('NULLO DELLA RIGA'), Er['r259']['verdetto']['USDJPY']
    assert Er['r258']['esito'][('R258a', 70.0)] == 'NULLO', Er['r258']['esito'][('R258a', 70.0)]
    # T11 (S0 XAGUSD = archivio 0/4 con numeri): VERDE nel pulito; una cella ancora a 0/0 e ROSSO
    assert P['r259']['s0']['XAGUSD'] == 'VERDE', P['r259']['s0']
    X = referto(costruisci_fixture(base, 'xag_00'), senza_bande=True)[1]['r259']
    assert X['s0']['XAGUSD'] == 'ROSSO' and X['verdetto']['XAGUSD'] == 'ROUND NON LETTO (S0)', (X['s0'], X['verdetto'])
    # T12 (classe 874 b): PROMOSSA solo DOPO M4. Designata con M1-M3 verdi e M4 verde -> PROMOSSA; si rompe b=1 di
    #     R258u (PF OOS 1,00) -> M4 non verde -> la stessa riga NON e promossa
    rac = costruisci_fixture(base, 'promossa')
    Q = referto(rac, senza_bande=True)[1]['r258']
    assert Q['esito'][('R258a', 70.0)].startswith('PROMOSSA'), Q['esito'][('R258a', 70.0)]

    def mod_csv(path, ax, val, cambi):
        rr = open(path, encoding='ascii').read().splitlines()
        h = rr[0].split(',')
        out = [rr[0]]
        for ln in rr[1:]:
            c, _ = allinea_riga(h, ln)
            if abs(float(c[h.index(ax)]) - val) < 1e-6:
                for k, v in cambi.items():
                    c[h.index(k)] = v
            out.append(','.join(c))
        _scrivi(path, out)
    mod_csv(os.path.join(rac, 'ROUND_R258u', 'ABTG_Londra_ORB_GBPUSD_OOS_R258u.csv'), 'InpBufferPips', 1.0, {'Profit Factor': '1.00000'})
    Q2 = referto(rac, senza_bande=True)[1]['r258']
    assert Q2['m4']['R258a'][0] == 'NON ALTOPIANO', Q2['m4']
    assert Q2['esito'][('R258a', 70.0)].startswith('NON PROMOSSA: M4'), Q2['esito'][('R258a', 70.0)]
    # T13 (M3 SOSPESO non e una bocciatura, classe 874 c): n IS 140 sulla designata (e sulla sua gemella X1) -> INDIZIO
    for f, ax, v in (('ROUND_R258a/ABTG_Londra_ORB_GBPUSD_IS_R258a.csv', 'InpMinRangePips', 70.0), ('ROUND_R258u/ABTG_Londra_ORB_GBPUSD_IS_R258u.csv', 'InpBufferPips', 3.0)):
        mod_csv(os.path.join(rac, f), ax, v, {'Trades': '140'})
    Q3 = referto(rac, senza_bande=True)[1]['r258']
    assert Q3['nullo']['R258a'] == 'passa' and Q3['esito'][('R258a', 70.0)].startswith('INDIZIO FAVOREVOLE (M1, M2 verdi; M3 sospeso'), (Q3['nullo']['R258a'], Q3['esito'][('R258a', 70.0)])
    # T14 (R1): Profit IS = 0 (DD_fisso non calcolabile) e DD_fisso OOS 6% sulla stessa riga -> VIOLATO (OOS),
    #     BOCCIATA PER RISCHIO; e una riga a n < 150 che rispetta si scrive NON VIOLATO, mai RISPETTATO
    rac = costruisci_fixture(base, 'r1_gamba')
    mod_csv(os.path.join(rac, 'ROUND_R258b', 'ABTG_Londra_ORB_GBPUSD_IS_R258b.csv'), 'InpMinRangePips', 10.0, {'Profit': '0.00', 'Recovery Factor': '0.00000'})
    pth = os.path.join(rac, 'ROUND_R258b', 'ABTG_Londra_ORB_GBPUSD_OOS_R258b.csv')
    rr = leggi_csv_opt(pth)[0]
    prof = riga_asse(rr, 'InpMinRangePips', 10.0)['Profit']
    mod_csv(pth, 'InpMinRangePips', 10.0, {'Recovery Factor': '%.5f' % (prof / 600.0)})
    R1 = referto(rac, senza_bande=True)[1]['r258']
    assert R1['r1'][('R258b', 10.0)] == 'VIOLATO (OOS)' and R1['esito'][('R258b', 10.0)] == 'BOCCIATA PER RISCHIO', (R1['r1'][('R258b', 10.0)], R1['esito'][('R258b', 10.0)])
    assert P['r258']['r1'][('R258i', 0.0)].startswith('NON VIOLATO su n'), P['r258']['r1'][('R258i', 0.0)]   # blocco F: n IS/OOS < 150
    assert all(not v.startswith('RISPETTATO') for k, v in P['r258']['r1'].items() if k[0] in ('R258i', 'R258j', 'R258k', 'R258l', 'R258m', 'R258n')), 'RISPETTATO a n < 150'
    # T15 (D0 R259 al limite esatto): disco dal 2024.09.26 = SODDISFATTO, dal 2024.09.27 = NON; AUDUSD 2019.01.02 = SODDISFATTO
    assert P['r259']['d0']['XAUUSD'] == 'SODDISFATTO' and P['r259']['d0']['AUDUSD'] == 'SODDISFATTO', P['r259']['d0']
    ps = os.path.join(rac, 'STORICO', 'STORICO_R259.csv')
    _scrivi(ps, [x.replace('XAUUSD,M1,2000000,2024.09.26', 'XAUUSD,M1,2000000,2024.09.27').replace('AUDUSD,M1,2000000,2019.01.02', 'AUDUSD,M1,2000000,2019.01.03') for x in open(ps, encoding='ascii').read().splitlines()])
    D = referto(rac, senza_bande=True)[1]['r259']
    assert D['d0']['XAUUSD'] == 'NON' and D['d0']['AUDUSD'] == 'NON' and D['verdetto']['XAUUSD'].startswith('NON ANCORA MISURATO (prima il disco'), (D['d0'], D['verdetto']['XAUUSD'])
    # T16 (C-COMM): k = 5 EUR/lotto (fuori [1;3]) -> C-COMM VERDE e k DICHIARATO fuori banda (la testa chiede solo
    #     commissione != 0); commissione ZERO -> ROSSO, M1 LORDO e nessuna PROMOSSA anche sulla designata perfetta
    rac = costruisci_fixture(base, 'promossa')
    ph = os.path.join(rac, 'CCOMM_R258', 'CCOMM_R258.htm')
    h16 = open(ph, 'rb').read().decode('utf-16')
    open(ph, 'wb').write(re.sub(r'<td>(-\d+\.\d+)</td><td>0\.00</td>', lambda m: '<td>%.2f</td><td>0.00</td>' % (float(m.group(1)) / 2.30 * 5.0), h16).encode('utf-16'))
    txtc, Ec = referto(rac, senza_bande=True)
    assert Ec['r258']['ccomm'] == 'VERDE' and 'FUORI BANDA' in txtc, 'T16 k fuori banda'
    open(ph, 'wb').write(re.sub(r'<td>(-\d+\.\d+)</td><td>0\.00</td>', '<td>0.00</td><td>0.00</td>', h16).encode('utf-16'))
    Ec2 = referto(rac, senza_bande=True)[1]['r258']
    assert Ec2['ccomm'] == 'ROSSO' and Ec2['esito'][('R258a', 70.0)].startswith('INDIZIO FAVOREVOLE (C-COMM ROSSO'), (Ec2['ccomm'], Ec2['esito'][('R258a', 70.0)])
    # T17 (ricucitura, punto 3 del cancello): solo quando serve; una riga con UN campo in meno non si ricuce
    hh = ['a', 'InpNewsCurrencies', 'InpComment', 'InpMagic']
    assert allinea_riga(hh, '1,GBP,USD,C,7') == (['1', 'GBP,USD', 'C', '7'], 1)
    assert allinea_riga(hh, '1,,C,7') == (['1', '', 'C', '7'], 0)
    assert allinea_riga(hh, '1,USD,C,7') == (['1', 'USD', 'C', '7'], 0)
    assert allinea_riga(hh, '1,C,7') == (None, 0)
    # T18 (28/09, formato NUOVO RFC 4180 di a66dcb07): gli stessi CSV di R258 con "GBP,USD" fra virgolette e InpComment
    #     con virgolette interne raddoppiate -> valori IDENTICI al formato vecchio ricucito (senza virgolette residue),
    #     ZERO ricuciture, ZERO esenzioni 883, P0 confrontato normalmente (stesso numero di confronti, VERDE)
    racq = costruisci_fixture(base, 'rfc4180')
    txtq, Eq = referto(racq, senza_bande=True)
    with open(os.path.join(base, 'REFERTO_rfc4180.md'), 'w', encoding='utf-8') as fh:
        fh.write(txtq)
    racp = os.path.join(base, 'ROUND_CORTI_A_pulito')
    ncsv = 0
    for j in [x for x in JOBS if x['r'] == 'R258']:
        for nome in sorted(os.listdir(os.path.join(racq, 'ROUND_' + j['t']))):
            if not nome.endswith('.csv'):
                continue
            ncsv += 1
            rq, nq = leggi_csv_opt(os.path.join(racq, 'ROUND_' + j['t'], nome))
            rp_, np_ = leggi_csv_opt(os.path.join(racp, 'ROUND_' + j['t'], nome))
            assert n_ricucite(nq) == 0 and 'ricucite' not in nq and 'RFC 4180' in nq and n_ricucite(np_) == len(rp_) > 0, (nome, nq, np_)
            assert len(rq) == len(rp_) and all(a.get('InpNewsCurrencies') == 'GBP,USD' for a in rq), nome
            for a, b in zip(rq, rp_):
                assert a['InpComment'] == b['InpComment'].replace(j['s'], '"%s"' % j['s']) and '""' not in a['InpComment'], (nome, a['InpComment'])
                assert {k: v for k, v in a.items() if k != 'InpComment'} == {k: v for k, v in b.items() if k != 'InpComment'}, (nome, a, b)
    assert ncsv == 48, ncsv   # 24 file R258 x IS/OOS
    assert Eq['r258']['nullo'] == P['r258']['nullo'] and Eq['r258']['esito'] == P['r258']['esito'] and Eq['r258']['k1'] == P['r258']['k1'], 'T18 esiti diversi fra i due formati'
    assert 'classe 883' not in txtq and 'ricucite' not in txtq and txtq.count('letti dal parser csv: nessuna ricucitura') == 48, 'T18 nota del formato nuovo'
    txtp = open(os.path.join(base, 'REFERTO_pulito.md'), encoding='utf-8').read()
    def norm(t):   # via la nota del CSV (con qualunque conteggio) e il nome della fixture: il resto dev essere IDENTICO
        t = re.sub(r' \(\d+ con (virgola in un input stringa, ricucite su InpNewsCurrencies|campi fra virgolette RFC 4180, letti dal parser csv: nessuna ricucitura)\)', '', t)
        return t.replace('_rfc4180', '_pulito').replace('fixture rfc4180', 'fixture pulito')
    assert norm(txtq) == norm(txtp), 'T18: il referto del formato nuovo differisce da quello del vecchio oltre la nota del CSV'
    assert re.search(r'\| R258a \| T/GBPUSD/8 \| 8 righe \(8 con campi fra virgolette RFC 4180[^|]*\| 8 righe[^|]*\| VERDE \| VERDE \(\d+ confronti', txtq), 'T18 P0 non confrontato normalmente'
    # T19 (formato NUOVO + NULLI della riga): il P0 della riga e LEGITTIMO -> si UNISCE (classe 873), NESSUNA esenzione 883,
    #     anche col P0 del lettore VERDE (a); e con il pin DAVVERO diverso nel CSV il P0 del lettore e ROSSO da solo (b)
    _riepilogo_con_nulli(os.path.join(racq, 'RIEPILOGO_ROUND_CORTI_A.txt'), NULLI_T19)
    txt19, E19 = referto(racq, senza_bande=True)
    N19 = E19['r258']['nullo']
    assert N19['R258b'] == 'NULLO' and N19['R258g'] == 'NULLO' and N19['R258a'] == 'passa', N19
    assert 'classe 883' not in txt19 and 'NON unito' not in txt19 and 'RIGA: P0 PIN DAL CSV _IS DIVERSO (1 valori: InpMagic=[795808]' in txt19, 'T19: esenzione 883 scattata sul formato NUOVO'
    assert E19['r258']['esito'][('R258b', 10.0)] == 'NULLO' and E19['r258']['esito'][('R258a', 70.0)] == P['r258']['esito'][('R258a', 70.0)], E19['r258']['esito'][('R258b', 10.0)]
    pb = os.path.join(racq, 'ROUND_R258b', 'ABTG_Londra_ORB_GBPUSD_IS_R258b.csv')
    rr = open(pb, encoding='ascii').read().splitlines()
    hb = rr[0].split(',')
    assert rr[1].count('"') >= 6 and ',"GBP,USD",' in rr[1], rr[1][-160:]
    _scrivi(pb, [rr[0]] + [ln.replace(',795807,', ',795808,') for ln in rr[1:]])
    assert 'InpMagic' in hb and leggi_csv_opt(pb)[0][0]['InpMagic'] == 795808.0
    txt19b, E19b = referto(racq, senza_bande=True)
    riga_b = [ln for ln in txt19b.splitlines() if ln.startswith('| R258b |')][0]
    assert E19b['r258']['nullo']['R258b'] == 'NULLO' and 'ROSSO: IS riga 1 InpMagic=795808.0 (pin 795807)' in riga_b and 'classe 883' not in txt19b, riga_b[:300]
    # T20 (contro-esempi del 28/09): (a) formato VECCHIO con DUE campi in eccesso (pin GBP,USD,EUR): ricuciti tutti e due
    #     su InpNewsCurrencies, InpMagic al suo posto; (b) formato NUOVO con InpComment che contiene una virgola E
    #     virgolette: letto INTERO, stesso numero di campi, zero ricuciture; tutti e due anche da FILE
    assert allinea_riga(hh, '1,GBP,USD,EUR,C,7') == (['1', 'GBP,USD,EUR', 'C', '7'], 1)
    assert allinea_riga(hh, '1,"GBP,USD",C,7') == (['1', 'GBP,USD', 'C', '7'], 0)
    assert allinea_riga(hh, '1,"GBP,USD","R258A, LDN ""GBPUSD"" H8",7') == (['1', 'GBP,USD', 'R258A, LDN "GBPUSD" H8', '7'], 0)
    h20 = 'Pass,Profit,Trades,InpNewsCurrencies,InpComment,InpMagic'
    p20 = os.path.join(base, '_t20_vecchio.csv')
    _scrivi(p20, [h20, '0,1.50,12,GBP,USD,EUR,R258A LDN GBPUSD H8,795807'])
    r20, n20 = leggi_csv_opt(p20)
    assert r20[0]['InpNewsCurrencies'] == 'GBP,USD,EUR' and r20[0]['InpComment'] == 'R258A LDN GBPUSD H8' and r20[0]['InpMagic'] == 795807.0 and r20[0]['Trades'] == 12.0, r20
    assert n20 == '1 righe' + NOTA_RICUCITE % 1 and n_ricucite(n20) == 1, n20
    p21 = os.path.join(base, '_t20_nuovo.csv')
    _scrivi(p21, [h20, '0,1.50,12,"GBP,USD","R258A, LDN ""GBPUSD"" H8",795807'])
    r21, n21 = leggi_csv_opt(p21)
    assert r21[0]['InpNewsCurrencies'] == 'GBP,USD' and r21[0]['InpComment'] == 'R258A, LDN "GBPUSD" H8' and r21[0]['InpMagic'] == 795807.0 and r21[0]['Trades'] == 12.0, r21
    assert n21 == '1 righe' + NOTA_RFC4180 % 1 and n_ricucite(n21) == 0, n21
    print('AUTOTEST: 20/20 PASS (fixture e referti in %s)' % base)
    return True


def main():
    if '--autotest' in sys.argv:
        args = [a for a in sys.argv[1:] if a != '--autotest']
        base = args[0] if args else SCRATCH_DEFAULT
        sys.exit(0 if autotest(base) else 1)
    args = [a for a in sys.argv[1:] if not a.startswith('--')]
    if not args:
        print(__doc__)
        sys.exit(2)
    out = None
    if '--out' in sys.argv:
        out = sys.argv[sys.argv.index('--out') + 1]
        args = [a for a in args if a != out]
    txt, _ = referto(args[0], senza_bande='--senza-bande' in sys.argv)
    if out:
        with open(out, 'w', encoding='utf-8') as fh:
            fh.write(txt)
        print('referto scritto in %s (%d righe)' % (out, txt.count('\n')))
    else:
        print(txt)


if __name__ == '__main__':
    main()
