from reportlab.lib.pagesizes import A4
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.units import mm
out='GOLD_REAPER_RIEPILOGO_TEST_2026-10-26.pdf'
ss=getSampleStyleSheet()
H1=ParagraphStyle('H1',parent=ss['Heading1'],fontSize=16,spaceAfter=6)
H2=ParagraphStyle('H2',parent=ss['Heading2'],fontSize=12,spaceBefore=10,spaceAfter=4)
B=ParagraphStyle('B',parent=ss['BodyText'],fontSize=9,leading=12)
S=ParagraphStyle('S',parent=B,fontSize=8,leading=10,textColor=colors.HexColor('#444444'))
C=ParagraphStyle('C',parent=B,fontSize=8,leading=10)
def P(t,st=B): return Paragraph(t,st)
def T(rows,widths,head=True):
    data=[[P(str(c),C) for c in r] for r in rows]
    t=Table(data,colWidths=[w*mm for w in widths],repeatRows=1 if head else 0)
    st=[('GRID',(0,0),(-1,-1),0.3,colors.grey),('VALIGN',(0,0),(-1,-1),'TOP'),('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3)]
    if head: st.append(('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e8eef7')))
    t.setStyle(TableStyle(st)); return t
doc=SimpleDocTemplate(out,pagesize=A4,leftMargin=15*mm,rightMargin=15*mm,topMargin=14*mm,bottomMargin=14*mm,title='The Gold Reaper - riepilogo dei test',author='Claudio Spadaro')
E=[]
E.append(P('The Gold Reaper MT5 - riepilogo di tutti i test fatti',H1))
E.append(P('Aggiornato al 26/10/2026. EA di terzi dal MQL5 Market (versione demo, gira solo nello Strategy Tester); venditore: Wim. Tutti i test sono sul tester del PC di backtest con BCM Markets (server UTC+1 fisso), XAUUSD, leva 1:100, nessun conto reale toccato, nessun guardiano esterno. Un backtest non e un risultato dal vivo (nessuna slippage reale, nessun requote). Dove un dato viene dal venditore o da terzi e scritto come DICHIARATO. Criteri e previsioni di ogni test sono stati scritti prima di vedere i numeri; il codice dei lettori e nel repository del progetto (branch lavoro, cartella report e backtest_pipeline).',B))
E.append(P('1. Impostazioni usate',H2))
E.append(P('<b>Set di Claudio (quello usato quasi ovunque):</b> TradeFrequency=2, MaxAllowedDD=9.0, PropFirmMaxDailyDD=4.0, OnlyUp=false; tutti gli altri input al default (StartLots 0,01, filtri NFP, nove strategie, FridayStopHour=25 = nessuno stop del venerdi). <b>Default dell\'EA:</b> TradeFrequency=5, MaxAllowedDD=30, PropFirmMaxDailyDD=0, OnlyUp=true. File .ex5 con SHA256 AB636AF9E912F6A0...F7E4 (stessa impronta prima e dopo ogni passata). Il tester riusa l\'ultimo set di input salvato: ogni passata e stata verificata leggendo gli input nel report prima dei numeri.',B))
E.append(P('2. I test, in ordine',H2))
rows=[['Test','Condizioni','Risultato'],
['Luglio 2026, default (16/10)','5.000 EUR, tick reali 100%, 1 mese','Netto -66,83 (-1,3%), PF 0,60, 33 operazioni, DD equity 4,35%. Un mese: descrittivo.'],
['Luglio-settembre 2026, default (17/10)','3 tranche mensili indipendenti da 5.000','PF aggregato 3,72 (per mese 0,60 / 4,00 / 8,44); lotti vivi 0,06 / 0,22 / 0,14.'],
['21 mesi a tranche mensili, default','21 tranche da 5.000, gen 2025 - set 2026','+7.963,73 complessivi, 1.019 operazioni, lotti fino a 0,06 (somma di mesi indipendenti, NON una corsa continua).'],
['21 mesi continui, set di Claudio, 5.000','01/01/2025-01/10/2026, H1, tick reali','Netto +3.969,57 (+79,4%), PF 2,88, 791 operazioni, 74,7% vincenti, DD equity 4,77% dal picco (2,67% dal deposito), lotti 0,01-0,02, 11 posizioni insieme al massimo, 18 mesi positivi su 21.'],
['21 mesi continui, set di Claudio, 80.000 (20/10)','stessa finestra, 80.000 EUR','Netto +59.796 (+74,7%), PF 2,89, stesse 791 operazioni, DD equity 3.854 EUR (2,97% dal picco, 4,8% degli 80.000), lotti 0,07-0,42, peggior giorno -1.514 (1,9%), 18/21 mesi positivi; meta 1 +44.626, meta 2 +15.171; netto/costo 27 volte.'],
['Stress di latenza (22/10)','80.000, ritardo di esecuzione 200 ms e 1.000 ms','200 ms: +59.620 (-0,3%); 1.000 ms: +59.068 (-1,2%), DD 5,1%; nessuno stop out. Regge il ritardo fisso.'],
['Giorni a rischio FTMO (26/10)','80.000, sul solo realizzato','0 giorni con perdita >= 3%; peggior giorno -1,2% del saldo a inizio giorno (-1.514 EUR, 23/04/2026; pari all\'1,9% degli 80.000 iniziali). Limite inferiore: FTMO misura sull\'equity.'],
['Costi extra (slippage + spread), ipotesi','80.000, +0,15 / +0,30 / +0,60 USD per oncia a giro','Netto 58.158 / 56.579 / 53.421, PF 2,83 / 2,76 / 2,61. Margine di costo (extra che azzera il netto): 5,68 USD/oz, il secondo piu alto fra i 12 EA confrontati (dopo SomaGold, 6,06). Gli extra sono IPOTESI: la demo BCM non simula slippage e quella dell\'oro sul reale non e misurata.'],
['Primi 12 mesi da 80.000 (2025)','sfida FTMO simulata','+27.985 (+35%), PF 2,62, DD realizzato 3,3%, +10% raggiunto il 23/04/2025, nessuna violazione (0 giorni >= 3%).'],
]
E.append(T(rows,[42,48,90]))
E.append(P('3. Tre anni di regime diverso (80.000 EUR, Modello 1 = OHLC 1 minuto, H1)',H2))
E.append(P('Anni scelti con regola scritta prima dai soli prezzi D1: 2013 ribasso (-28%), 2018 laterale (-1,7%), 2020 rialzo (+24,6%). Il 2025 e la calibrazione (Modello 1 contro tick reali).',B))
E.append(T([['Anno','Netto','PF','DD equity','Giorni >=3% / 4% / 5%','Peggior giorno / mese'],
['2013 SHORT','+21.757 (+27,2%)','1,63','5.621','3 / 1 / 0','-4,6% (-3.697) / -3,3%'],
['2018 LATERALE','+13.535 (+16,9%)','1,51','5.504','0 / 0 / 0','-2,2% / -2,0%'],
['2020 LONG','+20.388 (+25,5%)','1,87','3.839','0 / 0 / 0','-1,6% / -2,3%'],
['2025 (calibrazione)','+30.457 (+38,1%)','2,77','3.077','0 / 0 / 0','-1,1% / -2,0%']],[28,30,12,22,36,52]))
E.append(P('Calibrazione 2025: OK (rapporto Modello 1 su tick reali 1,08; correlazione mensile 0,99). Esito sul criterio scritto (PROP-ANNI: netto > 0 in tutti e tre gli anni, DD equity <= 8.000 EUR, nessuno stop out, nessun giorno >= 5%): <b>superato</b>. Nota: nel 2013 un giorno a -4,6%, sopra il 4% della protezione interna e a 0,4 punti dal 5% di FTMO.',B))
E.append(P('4. Correlazione con altri EA del pacchetto (risultati giornalieri)',H2))
E.append(P('Con Gold Trade Pro 0,51-0,56, Goldbot One 0,41-0,46, The Gold Phantom 0,55-0,58 (tutte sopra la soglia 0,30 che ci eravamo dati; 4 coppie su 6 del pacchetto sopra 0,50). Gold Reaper + Goldbot One insieme a 80.000 (somma dei due test): netto +70.970 con Goldbot a step 6000, drawdown del saldo 4,5%, massimo rigoroso dell\'equity 8,8%; peggior giorno lo stesso per entrambi (23/03/2026).',B))
E.append(P('5. Cosa dice il venditore o una recensione di terzi (DICHIARATO, non nostro)',H2))
E.append(P('Recensione indipendente (blog MQL5, v4.6): 8 strategie di breakout sull\'oro con ordini pendenti; backtest a 0,01 lotti su 4.000 USD, feb 2020-set 2026: +9.578 USD, DD storico peggiore 8,46%; stress test su 1.000 scenari: 664 superano il DD storico, P95 14,3%, P99 17,9%. Il rendimento dichiarato dal venditore (+312% su Myfxbook) NON e stato replicato da noi. Dati live di blog commerciali (DD 30-41%, PF 1,08): NON verificati, fonte promozionale. Il set di Claudio non contiene i parametri delle singole strategie, quindi lo stop loss iniziale e il meccanismo non sono leggibili (e un .ex5).',B))
E.append(P('6. Limiti e cose NON verificate',H2))
for t in ['<b>Protezioni interne:</b> il set ha MaxAllowedDD=9 e PropFirmMaxDailyDD=4: possono chiudere il flottante come un guardiano; dal report non si vede se siano intervenute. Una prova a protezioni spente non e ancora stata fatta.',
'<b>OnlyUp</b> (di default acceso): il lotto non scende dopo le perdite; nel set di Claudio e spento (false).',
'<b>Soglia di struttura:</b> alla lettera non passa la regola "al massimo 10 posizioni insieme e rapporto lotti <= 3" (11 posizioni; rapporto lotti 6,0 a 80.000 contro 2,0 a 5.000): resta una violazione formale da accettare o no.',
'<b>Tick reali sull\'oro solo dal 10/07/2024:</b> i test sul 2013, 2018 e 2020 sono a OHLC 1 minuto (calibrati sul 2025, rapporto 1,08); a quei prezzi (1.200-2.000 USD) il confronto con oggi non e perfetto.',
'<b>Un solo anno laterale su sette</b> negli ultimi 20 (11 rialzo, 7 laterali, 2 ribasso): i tre anni sono un controllo a campione, non una prova.',
'<b>Orologio:</b> BCM e UTC+1 fisso; filtri news e GMT dell\'EA nel tester non sono simulabili (il calendario non esiste); da verificare sul server vero.',
'<b>Slippage:</b> non misurata (la demo BCM riempie esattamente al prezzo dell\'ordine); sul reale va misurata.',
'<b>Mai provato dal vivo:</b> regola di casa, dopo un eventuale acquisto, almeno 4 settimane su demo prima di qualsiasi reale.']:
    E.append(P('- '+t,B))
E.append(P('7. Come replicare il controllo (per chi ha un altro broker)',H2))
E.append(P('Strategy Tester MT5, Expert The Gold Reaper MT5 (demo dal Market), XAUUSD, H1, 01/01/2025-01/10/2026, "Ogni tick basato su tick reali" (qualita storico 100%), ritardo nessuno, ottimizzazione spenta, leva 1:100, deposito 5.000 (o 80.000) nella valuta del conto. Impostare a mano i quattro input del set (TradeFrequency=2, MaxAllowedDD=9.0, PropFirmMaxDailyDD=4.0, OnlyUp=false) e <b>aprire il report e leggere gli input prima dei numeri</b>: il tester riusa l\'ultimo set salvato. Non aspettarsi lo stesso numero (broker, feed e spread diversi): e un controllo incrociato, non una prova.',B))
E.append(P('Nessuna indicazione di acquisto, lotto o taglia: sono decisioni di Claudio. Documento preparato da Claude Code a partire dai report del repository del progetto.',S))
doc.build(E)
print('ok')
