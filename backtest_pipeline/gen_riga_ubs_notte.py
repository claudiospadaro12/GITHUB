#!/usr/bin/env python3
"""UBS INDICI passata di fumo (derivata da gen_riga_ubs_cft2.py). UBS C FOREX a tick reali (derivata da gen_riga_ubs_cf.py): 7 set x (M1, M4) sul 2025, lotto fisso 0,1, 14 passate."""
import re, sys, os
os.chdir(os.path.dirname(os.path.abspath(__file__)))
s = open('gen_riga_ubs_u2.py', encoding='utf-8').read()
a = s.index("U2SETS = ["); b = s.index("N = len(runs)")
IMP = {'J001': '', 'J002': '', 'J003': '', 'J004': '', 'J005': '', 'J006': '', 'J007': '', 'J008': '', 'J009': '', 'J010': '', 'J011': '', 'J012': '', 'J013': '', 'J014': '', 'J015': '', 'J016': '', 'J017': '', 'J018': '', 'J019': '', 'J020': '', 'J021': '', 'J022': '', 'J023': '', 'J024': '', 'J025': '', 'J026': '', 'J027': '', 'J028': '', 'J029': '', 'J030': '', 'J031': '', 'J032': '', 'J033': '', 'J034': '', 'J035': '', 'J036': '', 'J037': '', 'J038': '', 'J039': '', 'J040': '', 'J041': '', 'J042': '', 'J043': '', 'J044': '', 'J045': '', 'J046': '', 'J047': '', 'J048': '', 'J049': '', 'J050': '', 'J051': '', 'J052': '', 'J053': '', 'J054': '', 'J055': '', 'J056': '', 'J057': '', 'J058': '', 'J059': '', 'J060': '', 'J061': '', 'J062': '', 'J063': '', 'J064': '', 'J065': '', 'J066': '', 'J067': '', 'J068': '', 'J069': '', 'J070': '', 'J071': '', 'J072': '', 'J073': '', 'J074': '', 'J075': '', 'J076': '', 'J077': '', 'J078': '', 'J079': '', 'J080': '', 'J081': '', 'J082': '', 'J083': '', 'J084': '', 'J085': '', 'J086': '', 'J087': '', 'J088': '', 'J089': '', 'J090': '', 'J091': '', 'J092': '', 'J093': '', 'J094': '', 'J095': '', 'J096': '', 'J097': '', 'J098': ''}
FX = [('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J001_AUDUSD_D1_DaytradePro_AUDUSD.set', 'AUDUSD', 'J001'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J002_EURJPY_D1_DaytradePro_EURJPY.set', 'EURJPY', 'J002'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J003_EURJPY_D1_DaytradePro_EURJPY.set', 'EURJPY', 'J003'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J004_EURUSD_D1_9637068_storyG_eurusd_f356_d1_storyg.set', 'EURUSD', 'J004'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J005_EURUSD_D1_9637069_storyG_eurusd_g357_d1_storyg.set', 'EURUSD', 'J005'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J006_EURUSD_D1_9637071_storyG_eurusd_o3515_d1_storyg.set', 'EURUSD', 'J006'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J007_EURUSD_D1_9637072_storyG_eurusd_p3516_d1_storyg.set', 'EURUSD', 'J007'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J008_EURUSD_D1_DaytradePro_EURUSD.set', 'EURUSD', 'J008'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J009_EURUSD_D1_eurusd_a.set', 'EURUSD', 'J009'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J010_EURUSD_D1_eurusd_b.set', 'EURUSD', 'J010'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J011_EURUSD_D1_eurusd_c.set', 'EURUSD', 'J011'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J012_EURUSD_D1_eurusd_d.set', 'EURUSD', 'J012'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J013_EURUSD_H1_eurusd_H1_SL14.set', 'EURUSD', 'J013'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J014_EURUSD_H1_eurusd_H1_SL17.set', 'EURUSD', 'J014'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J015_EURUSD_H1_eurusd_H1_SL18.set', 'EURUSD', 'J015'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J016_EURUSD_H1_eurusd_H1_SL22.set', 'EURUSD', 'J016'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J017_EURUSD_H4_9637070_storyG_eurusd_h368_h4_storyg.set', 'EURUSD', 'J017'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J018_GBPJPY_D1_DaytradePro_GBPJPY.set', 'GBPJPY', 'J018'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J019_GBPUSD_D1_DaytradePro_GBPUSD.set', 'GBPUSD', 'J019'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J020_GBPUSD_D1_gbpusd_a.set', 'GBPUSD', 'J020'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J021_GBPUSD_H1_gbpusd_H1.set', 'GBPUSD', 'J021'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J022_NZDUSD_D1_DaytradePro_NZDUSD.set', 'NZDUSD', 'J022'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J023_USDCAD_D1_DaytradePro_USDCAD.set', 'USDCAD', 'J023'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J024_USDJPY_D1_9637034_Till_UBS-USDJPY-D1-HJP09.set', 'USDJPY', 'J024'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J025_USDJPY_D1_9637035_Till_UBS-USDJPY-D1-HJP10.set', 'USDJPY', 'J025'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J026_USDJPY_D1_9637057_hangsan_1.set', 'USDJPY', 'J026'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J027_USDJPY_D1_9637058_hangsan_4.set', 'USDJPY', 'J027'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J028_USDJPY_D1_9637059_hangsan_JPYc.set', 'USDJPY', 'J028'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J029_USDJPY_D1_9637061_hangsan_b.set', 'USDJPY', 'J029'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J030_USDJPY_D1_9637062_hangsan_bojpy1.set', 'USDJPY', 'J030'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J031_USDJPY_D1_9637063_hangsan_bojpy3.set', 'USDJPY', 'J031'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J032_USDJPY_D1_9637064_hangsan_bojpy4.set', 'USDJPY', 'J032'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J033_USDJPY_D1_9637073_storyG_usdjpy_a341_d1_storyg.set', 'USDJPY', 'J033'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J034_USDJPY_D1_9637074_storyG_usdjpy_d343_d1_storyg.set', 'USDJPY', 'J034'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J035_USDJPY_D1_9637075_storyG_usdjpy_e345_d1_storyg.set', 'USDJPY', 'J035'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J036_USDJPY_D1_9637076_storyG_usdjpy_g347_d1_storyg.set', 'USDJPY', 'J036'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J037_USDJPY_D1_DaytradePro_USDJPY.set', 'USDJPY', 'J037'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J038_USDJPY_H1_usdjpy_H1_SL22.set', 'USDJPY', 'J038'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J039_USDJPY_H4_9637060_hangsan_R3.set', 'USDJPY', 'J039'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J040_USDJPY_H4_usdjpy_H4_SL14.set', 'USDJPY', 'J040'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J041_XAGUSD_D1_9637065_hangsan_DS.set', 'XAGUSD', 'J041'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J042_XAGUSD_D1_9637066_hangsan_Kg.set', 'XAGUSD', 'J042'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J043_XAGUSD_H4_9637067_hangsan_SILVERR3.set', 'XAGUSD', 'J043'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J044_EURJPY_D1_DaytradePro_EURJPY_old.set', 'EURJPY', 'J044'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J045_EURUSD_D1_eurusd_f356_d1_storyg.set', 'EURUSD', 'J045'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J046_EURUSD_D1_eurusd_g357_d1_storyg.set', 'EURUSD', 'J046'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J047_EURUSD_D1_eurusd_o3515_d1_storyg.set', 'EURUSD', 'J047'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J048_EURUSD_D1_eurusd_p3516_d1_storyg.set', 'EURUSD', 'J048'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J049_EURUSD_D1_eurusd_f356_d1_storyg.set', 'EURUSD', 'J049'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J050_EURUSD_D1_eurusd_p3516_d1_storyg.set', 'EURUSD', 'J050'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J051_EURUSD_H1_2025_advscalper_eurusd_h1-tomasw-grid.set', 'EURUSD', 'J051'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J052_EURUSD_H4_eurusd_h368_h4_storyg.set', 'EURUSD', 'J052'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J053_EURUSD_H4_eurusd_h368_h4_storyg.set', 'EURUSD', 'J053'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'M15', 'J054_EURUSD_M15_EURUSD_M15_VolBrk_C10.set', 'EURUSD', 'J054'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'M15', 'J055_EURUSD_M15_EURUSD_M15_VolBrk_C20.set', 'EURUSD', 'J055'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'M15', 'J056_EURUSD_M15_EURUSD_M15_VolBrk_C35.set', 'EURUSD', 'J056'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'M15', 'J057_EURUSD_M15_EURUSD_M15_VolBrk_C37.set', 'EURUSD', 'J057'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'M15', 'J058_EURUSD_M15_EURUSD_M15_VolBrk_C55.set', 'EURUSD', 'J058'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'M15', 'J059_EURUSD_M15_EURUSD_M15_VolBrk_C63.set', 'EURUSD', 'J059'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J060_GBPJPY_D1_DaytradePro_GBPJPYold.set', 'GBPJPY', 'J060'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J061_USDJPY_D1_JPY_1_.set', 'USDJPY', 'J061'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J062_USDJPY_D1_JPY_2_.set', 'USDJPY', 'J062'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J063_USDJPY_D1_JPY_3_.set', 'USDJPY', 'J063'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J064_USDJPY_D1_JPY_4_.set', 'USDJPY', 'J064'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J065_USDJPY_D1_JPY_5_.set', 'USDJPY', 'J065'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J066_USDJPY_D1_JPY_6_.set', 'USDJPY', 'J066'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J067_USDJPY_D1_JPY_7_.set', 'USDJPY', 'J067'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J068_USDJPY_D1_UBS-USDJPY-D1-HJP09.set', 'USDJPY', 'J068'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J069_USDJPY_D1_UBS-USDJPY-D1-HJP10.set', 'USDJPY', 'J069'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J070_USDJPY_D1_usdjpy_a341_d1_storyg.set', 'USDJPY', 'J070'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J071_USDJPY_D1_usdjpy_d343_d1_storyg.set', 'USDJPY', 'J071'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J072_USDJPY_D1_usdjpy_e345_d1_storyg.set', 'USDJPY', 'J072'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J073_USDJPY_D1_usdjpy_g347_d1_storyg.set', 'USDJPY', 'J073'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J074_USDJPY_H1_UBS-USDJPY-H1-SPD-20260903-02.set', 'USDJPY', 'J074'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J075_USDJPY_H1_usdjpy17.set', 'USDJPY', 'J075'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J076_USDJPY_H1_usdjpy_H1_SL30.set', 'USDJPY', 'J076'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J077_USDJPY_H1_usdjpy_H1_SL30.set', 'USDJPY', 'J077'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J078_USDJPY_H4_R3_148.set', 'USDJPY', 'J078'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J079_USDJPY_H4_R3_148.set', 'USDJPY', 'J079'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J080_USDJPY_H4_usdjpy_H4_SL17.set', 'USDJPY', 'J080'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J081_USDJPY_H4_usdjpy_H4_SL17.set', 'USDJPY', 'J081'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J082_XAGUSD_D1_4d1xag.set', 'XAGUSD', 'J082'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J083_XAGUSD_D1_DS_149.set', 'XAGUSD', 'J083'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J084_XAGUSD_D1_Kg_150.set', 'XAGUSD', 'J084'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J085_XAGUSD_D1_XAG_2_.set', 'XAGUSD', 'J085'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J086_XAGUSD_D1_XAG_3_.set', 'XAGUSD', 'J086'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J087_XAGUSD_D1_XAG_4_.set', 'XAGUSD', 'J087'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J088_XAGUSD_D1_XAUGUSD_D1_C463_STORYG_KillPending-Open_Friday_2.set', 'XAGUSD', 'J088'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J089_XAGUSD_D1_XAUGUSD_D1_D464_STORYG_KillPending-Open_Friday_2.set', 'XAGUSD', 'J089'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J090_XAGUSD_D1_XAUGUSD_D1_G467_STORYG_KillPending-Open_Friday_2.set', 'XAGUSD', 'J090'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'D1', 'J091_XAGUSD_D1_XAUGUSD_D1_H468_STORYG_KillPending-Open_Friday_2.set', 'XAGUSD', 'J091'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H1', 'J092_XAGUSD_H1_4h1xag.set', 'XAGUSD', 'J092'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J093_XAGUSD_H4_10h4xag.set', 'XAGUSD', 'J093'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J094_XAGUSD_H4_4h4xag.set', 'XAGUSD', 'J094'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J095_XAGUSD_H4_5h4xag.set', 'XAGUSD', 'J095'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J096_XAGUSD_H4_8h4xag.set', 'XAGUSD', 'J096'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J097_XAGUSD_H4_SILVERR3_151.set', 'XAGUSD', 'J097'), ('UBS_NOTTE_SET.zip', '2020', '2026.11.01', 'H4', 'J098_XAGUSD_H4_XAG_1_.set', 'XAGUSD', 'J098')]
assert len(FX) == 98
nuovo = ("IMP = " + repr(IMP) + "\n"
         "ZNEW = 'UBS_NOTTE_SET.zip'\n"
         "FX = " + repr(FX) + "\n"
         "LOTS = {}\n"
         "SYMS = []; MODS = []\n"
         "for zipn, anno, fine, per, rel, sym, tag in FX:\n"
         "    for mod in ('1',):\n"
         "        runs.append((EA, zipn, anno, fine, per, rel, 'Risk=0:i;StartLots=0.1:d;ForceSymbol=' + sym + ':s;' + IMP[tag], 'UBSNT_%s_M%s_100000_%s' % (tag, mod, anno), 100000)); SYMS.append(sym); MODS.append(mod)\n")
s = s[:a] + nuovo + s[b:]
assert s.count("q(['1'] * N)") == 1
s = s.replace("q(['1'] * N)", "q(MODS)")
assert s.count("q(['XAUUSD'] * N)") == 1
s = s.replace("q(['XAUUSD'] * N)", "q(SYMS)")
assert s.count("assert N == 18") == 1
s = s.replace("assert N == 18", "assert N == 98")
s = s.replace("RIGA_LANCIA_UBS_U2.txt", "RIGA_LANCIA_UBS_NOTTE.txt").replace("ANNO_ORO_GRADINI_UBSU2_", "ANNO_ORO_GRADINI_UBSNOTTE_")
i = s.index("testa = ("); j = s.index('t = t[:i] + "Write-Host')
testa = ('testa = ("UBS REPLICA NOTTURNA (FASE R1): 98 set NON ORO (USDJPY, EURUSD, argento, altri forex) di Wim e degli utenti provati COSI COME SONO, senza ottimizzare, XAUUSD escluso, dal 01/01/2020 al 31/10/2026 (il periodo dell Excel dei PF), Modello 1, deposito 100000 EUR, lotto fisso 0,1, EA Ultimate_Breakout_EA_WSC_V9.5. Si confronta il PF nostro con quello dichiarato nell Excel (criteri: report/UBS_REPLICA_CRITERI_2026-11-25.md). Serve UBS_NOTTE_SET.zip sul Desktop. Mi mandi lo zip ANNO_ORO_GRADINI_UBSNOTTE_<data>. Il terminale PRINCIPALE BCM CHIUSO, il PC acceso e in carica tutta la notte, niente in stop o sospensione. EA e set di Wim: ricerca, fuori dal progetto prop. NON collaudata da agenti: passata SOLO dal cancello meccanico.")\n')
s = s[:i] + testa + s[j:]
pass
s = s.replace("TEMPO: circa 1-3 ore (\" + str(N) + \" passate: 9 set su 13 anni, 2 bracci;", "TEMPO: 98 passate su 6,8 anni a barre da 1 minuto: da 2 a 10 minuti ciascuna, stima 6-12 ore (tutta la notte), timeout 90 minuti per passata; (\" + str(N) + \" passate;")
sys.argv = ['gen_riga_ubs_cft_tmp.py'] + sys.argv[1:]
exec(compile(s, 'gen_riga_ubs_cp_tmp', 'exec'))
# --- patch post-generazione: ricerca del set per PERCORSO (GOLDTRADEPRO_E.set esiste due volte in V9.0), controllo per ogni passata sul SUO zip, entrambi gli zip obbligatori
_p = 'righe/RIGA_LANCIA_UBS_NOTTE.txt'
_t = open(_p, encoding='ascii').read()
def P(a_, b_, n=1):
    global _t
    assert _t.count(a_) == n, (_t.count(a_), a_[:90])
    _t = _t.replace(a_, b_)
P("if($zpath.Count -lt 1){ Write-Host 'MI FERMO: Ultimate-Breakout-System-Set-Files.zip non si trova sul Desktop, in Download o in Documenti di questo PC. Mettilo li (e un file di Wim, lo stesso che mi hai mandato) e rilancia. Nessun tester e partito.' -ForegroundColor Red; return }; ",
  "if($zpath.Count -lt @($ZIPR | Select-Object -Unique).Count){ Write-Host 'MI FERMO: manca almeno uno dei DUE zip dei set (Ultimate-Breakout-System-Set-Files.zip, UPDATED_SETS_UBS_V9_0.zip) sul Desktop, in Download o in Documenti di questo PC. Mettili li (file di Wim, gli stessi che mi hai mandato) e rilancia. Nessun tester e partito.' -ForegroundColor Red; return }; ")
P("foreach($sn in @($SETR | Select-Object -Unique)){ $gg=@(Get-ChildItem -LiteralPath $zpath[$ZIPR[0]] -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq $sn }); if($gg.Count -ne 1){ Write-Host ('MI FERMO: nel pacchetto il set ' + $sn + ' risulta ' + $gg.Count + ' volte (ne serve UNA). Nessun tester e partito.') -ForegroundColor Red; return } }; ",
  "for($k=0; $k -lt $SETR.Count; $k++){ $sn=$SETR[$k]; $gg=@(Get-ChildItem -LiteralPath $zpath[$ZIPR[$k]] -Recurse -File -ErrorAction SilentlyContinue | Where-Object { $_.FullName.EndsWith('\\' + $sn) }); if($gg.Count -ne 1){ Write-Host ('MI FERMO: nel pacchetto ' + $ZIPR[$k] + ' il set ' + $sn + ' risulta ' + $gg.Count + ' volte (ne serve UNA). Nessun tester e partito.') -ForegroundColor Red; return } }; ")
P("Where-Object { $_.Name -eq $SETR[$vi] }", "Where-Object { $_.FullName.EndsWith('\\' + $SETR[$vi]) }")
_t = _t.replace('DUE zip dei set (Ultimate-Breakout-System-Set-Files.zip, UPDATED_SETS_UBS_V9_0.zip)', 'zip dei set (UBS_NOTTE_SET.zip sul Desktop)')
_t = _t.replace('deposito 80000 o 3745 EUR a seconda della passata', 'deposito 80000 EUR').replace('Se Ultimate-Breakout-System-Set-Files.zip non si trova, la riga si FERMA', 'Se uno dei due zip dei set non si trova, la riga si FERMA')
assert '3745' not in _t
open(_p, 'w', encoding='ascii').write(_t)
print('patch ok', len(_t), 'passate 6')

_t2 = open('righe/RIGA_LANCIA_UBS_NOTTE.txt', encoding='ascii').read()
assert _t2.count("$TO=240;") == 1
_t2 = _t2.replace("$TO=240;", "$TO=300;").replace("timeout 240 minuti", "timeout 300 minuti")
open('righe/RIGA_LANCIA_UBS_NOTTE.txt', 'w', encoding='ascii').write(_t2)
print('TO 300 ok', len(_t2))

# --- patch idx0: la variabile del ciclo $sn collideva con $SN (nome dello script del tester): PowerShell non distingue le maiuscole
import re as _re
_t3 = open('righe/RIGA_LANCIA_UBS_NOTTE.txt', encoding='ascii').read()
_n = len(_re.findall(r'\$sn\b', _t3)); assert _n >= 2, _n
_t3 = _re.sub(r'\$sn\b', '$snm', _t3)
open('righe/RIGA_LANCIA_UBS_NOTTE.txt', 'w', encoding='ascii').write(_t3)
print('sn->snm', _n)

_t4 = open('righe/RIGA_LANCIA_UBS_NOTTE.txt', encoding='ascii').read()
assert _t4.count("[int]$nfail[$n] -ge 2") == 1
_t4 = _t4.replace("[int]$nfail[$n] -ge 2", "[int]$nfail[$n] -ge 99")
open('righe/RIGA_LANCIA_UBS_NOTTE.txt', 'w', encoding='ascii').write(_t4)
print('skip-dopo-2-KO disattivato')

_t5 = open('righe/RIGA_LANCIA_UBS_NOTTE.txt', encoding='ascii').read()
assert _t5.count("$TO=300;") == 1
_t5 = _t5.replace("$TO=300;", "$TO=90;").replace("timeout 300 minuti", "timeout 90 minuti")
open('righe/RIGA_LANCIA_UBS_NOTTE.txt', 'w', encoding='ascii').write(_t5)
print('TO 40 ok')

print('deposito 100000 mantenuto')

# --- GUARDIA SELETTIVA (22/11): la riga convive con un'ottimizzazione nel portatile C:\MT5_BCM_Opt; conta solo i processi del terminale PRINCIPALE
import re as _re2
_t7 = open('righe/RIGA_LANCIA_UBS_NOTTE.txt', encoding='ascii').read()
_pat = _re2.compile(r"@\(Get-Process -Name (terminal64,metaeditor64,metatester64|terminal64,metaeditor64) -ErrorAction SilentlyContinue\)")
_n = len(_pat.findall(_t7)); assert _n >= 4, _n
_t7 = _pat.sub(lambda m: "@(Get-Process -Name %s -ErrorAction SilentlyContinue | Where-Object { Mio $_ })" % m.group(1), _t7)
assert _t7.count("Get-Process -Name terminal64") == _t7.count("Where-Object { Mio $_ }")
assert _t7.count("ANNO80K_WIM_TESTER.ps1") == 1
_t7 = _t7.replace("ANNO80K_WIM_TESTER.ps1", "ANNO80K_WIM_TESTER_SEL.ps1")
_f = "function Mio($p){ (-not $p.Path) -or $p.Path.StartsWith('C:\\Program Files\\BCM Markets MT5 Terminal\\',[StringComparison]::OrdinalIgnoreCase) }; "
assert _t7.startswith("& { ")
_t7 = "& { " + _f + _t7[len("& { "):]
open('righe/RIGA_LANCIA_UBS_NOTTE.txt', 'w', encoding='ascii').write(_t7)
print('guardia selettiva: sostituzioni', _n)

# --- FIX 25/11 sera: IMP vuoto lasciava un ';' finale in -Imposti: lo script del tester spezza sui ';', trova una voce vuota e va in throw (rc 1, prima del tester) su TUTTE le 98 passate.
_t9 = open('righe/RIGA_LANCIA_UBS_NOTTE.txt', encoding='ascii').read()
_n9 = _t9.count(":s;'")
assert _n9 == 98, _n9
_t9 = _t9.replace(":s;'", ":s'")
open('righe/RIGA_LANCIA_UBS_NOTTE.txt', 'w', encoding='ascii').write(_t9)
print('fix ";" finale in -Imposti: 98 voci')
