#!/usr/bin/env python3
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.units import mm
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, KeepTogether
OUT='/home/user/GITHUB/report/MESSAGGIO_PER_MASSIMO_2026-11-14.pdf'
ss=getSampleStyleSheet()
B=ParagraphStyle('B',parent=ss['Normal'],fontName='Helvetica',fontSize=9.2,leading=12.4)
S=ParagraphStyle('S',parent=B,fontSize=8.1,leading=10.6,textColor=colors.HexColor('#444444'))
H1=ParagraphStyle('H1',parent=ss['Title'],fontName='Helvetica-Bold',fontSize=16,leading=19,alignment=0,spaceAfter=2)
H2=ParagraphStyle('H2',parent=B,fontName='Helvetica-Bold',fontSize=11,leading=14,spaceBefore=8,spaceAfter=3,textColor=colors.HexColor('#1f3a5f'))
BL=ParagraphStyle('BL',parent=B,leftIndent=11,bulletIndent=2)
def P(t,st=B): return Paragraph(t,st)
def L(t): return Paragraph(t,BL,bulletText='-')
def cell(t,fs=8.1,bold=False):
    return Paragraph(('<b>%s</b>'%t) if bold else str(t),ParagraphStyle('c',parent=B,fontSize=fs,leading=fs+2.4))
def table(rows,widths,head=True,colors_=None):
    t=Table([[cell(c,bold=(head and i==0)) for c in r] for i,r in enumerate(rows)],colWidths=[w*mm for w in widths],repeatRows=1 if head else 0)
    st=[('GRID',(0,0),(-1,-1),0.4,colors.HexColor('#999999')),('VALIGN',(0,0),(-1,-1),'TOP'),
        ('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3),('TOPPADDING',(0,0),(-1,-1),2),('BOTTOMPADDING',(0,0),(-1,-1),2)]
    if head: st.append(('BACKGROUND',(0,0),(-1,0),colors.HexColor('#e6edf5')))
    if colors_: st+=colors_
    t.setStyle(TableStyle(st)); return t
E=[]
E.append(P('Messaggio per Massimo: set del Reaper e le tue due combinazioni',H1))
E.append(P('Da Claudio (tramite il suo Claude) - 14/11/2026 - STIME DA BACKTEST (tester BCM, 80.000 EUR, XAUUSD, Modello 1), non previsioni ne garanzie. Nessuna indicazione su lotti, taglie o acquisti. Non controllato da altri.',S))

E.append(P('1. Prima cosa: due PDF di ieri sono sbagliati, non usarli',H2))
E.append(P('Avevo calcolato i fallimenti partendo solo da gennaio-marzo di ogni anno: questo nascondeva le giornate peggiori di fine anno (31/12/2013, 17/07/2013, 09/11/2020). Rifatti su tutte le partenze: lo "Schema A e B" fallisce 7,8% e 8,6% (non 0%); il rialzo a L1 dopo i giorni minimi fallisce 28%; il Reaper L0 da solo 17-23%. <b>Vale solo il PDF "Reaper tabella definitiva v2".</b> Rimangono a 0% nel tester i set Prop di P1, P3, P4 e la tua Combo A.'))

E.append(P('2. Il tuo set del Reaper e lo stesso che ho testato?',H2))
E.append(P('I parametri letti da F7 (TradeFrequency moderate, Total DD 9, Daily DD 4, Randomization 50, Friday stop 25, magic 8000, Fake Breakout Medium) coincidono con <b>gold_reaper_propfirm.set (livello L0 Prop)</b>, il file di Wim del 29/10: TradeFrequency=2, MaxAllowedDD=9, PropFirmMaxDailyDD=4, Randomization=50. Non ho confrontato ogni altro input. Per confermarlo con certezza, sul tuo PC:'))
E.append(P('<font face="Courier" size="8">(Get-FileHash "&lt;percorso&gt;\\gold_reaper_propfirm.set" -Algorithm SHA256).Hash.Substring(0,16)</font>',B))
E.append(P('Deve dare <b>29AA6B1C3319D9F0</b>. "Moderate" e l\'opzione TradeFrequency (0 = extreme conservative, 1 conservative, <b>2 moderate</b>, 3 intense, 4 extreme, 5 auto); nei report del tester con valore 2 aprono solo le strategie 1-7. Anche il set Combo (L3) ha TradeFrequency 2: cambia la taglia (MaxAllowedDD 3 contro 9).'))

E.append(P('3. Le tue due combinazioni: tempi, rischio, rendimento (stime del tester)',H2))
E.append(table([
 ['', 'Conto 1: Combo A (Goldbot Prop + Gold Phantom Gradino 1)','Conto 2: Gold Reaper L0 da solo'],
 ['Tempo per le due fasi','<b>198 giorni</b> (112 + 86), circa 6,5 mesi; 85% arriva al target nella finestra','circa <b>150-160 giorni</b> senza costi; 6-7 mesi con i costi; 26% non finisce nella finestra'],
 ['Fallimenti (tutte le partenze, costi centrali / doppi)','<b>0%</b> nel tester','<b>17,3% / 23,3%</b>: concentrati nel 2013 (circa 68-74% delle partenze di quell\'anno), 0% negli altri tre anni'],
 ['Netto annuo (80.000 EUR, con costi)','circa <b>23.000 EUR</b> (stima mia: 27.100 senza costi extra FTMO)','<b>17.489 EUR</b> (24.579 senza costi extra)'],
 ['Dopo la correzione tick (Modello 1 sovrastima il netto 8-17%)','circa 19.000-21.000 EUR','circa 14.500-16.000 EUR'],
 ['Peggior giorno / giorni oltre il 4,5%','-4,69% nel 2013 / nessuno','-6,0% nel 2013 / 4, tutti nel 2013'],
 ['Prova di stress (DD +15% / +35%)','fallimenti 10,8% / 27,8%','gia alto di base'],
],[40,75,65],colors_=[('BACKGROUND',(1,1),(1,-1),colors.HexColor('#e6f3e8')),('BACKGROUND',(2,1),(2,-1),colors.HexColor('#fbefc4'))]))
E.append(P('La tua "Combo A" e la parte oro di P1 (Goldbot L0 + Phantom L1), <b>non</b> lo "schema A" scartato. Per confronto, la P4 di Claudio (Reaper Combo + Goldbot + Daytrade Pro) fa le due fasi in circa 145-173 giorni con 0% di fallimenti nel tester.',S))

E.append(P('4. Il tuo "set veloce / moderate / L3": sono file diversi',H2))
E.append(table([
 ['Livello','File del set','TradeFrequency / MaxAllowedDD','Tester'],
 ['<b>L0 Prop</b> (il tuo, "veloce")','gold_reaper_propfirm.set','2 (moderate) / 9','circa 160 giorni, fallisce 17%'],
 ['L1','gold_reaper_15%maxrisk.set','5 (auto) / 15','circa 96 giorni, fallisce 28%'],
 ['L2 Medium','gold_reaper_default.set','5 (auto) / 30','circa 32 giorni, fallisce 64%'],
 ['<b>L3 Combo</b> (sicuro, lentissimo)','Gold_reaper_propfirm_combo_3GOLD.set','2 (moderate) / 3','circa 554 giorni, 0%'],
 ['"Moderato" di Wim','gold_reaper_live_signal_settings.set','2 / 30 (+ FakeOut 2, NFP 100/60)','non e un livello nostro: rischio sopra L1'],
],[44,55,43,38]))
E.append(P('Il "moderate" di cui parlavate coincide quindi con L0: non esiste un livello intermedio tra L0 e L3 nei nostri test.',S))

E.append(P('5. Il Guardian a 4,3% / 9,3% copre il -6% del 2013?',H2))
E.append(L('<b>Non posso confermarlo</b>: il Guardian non e simulato nel tester. Se la perdita sale gradualmente, taglia a -4,3% prima del -5%. Se l\'oro fa un salto di qualche punto in pochi secondi, puo non bastare. Nel test lo stesso limite giornaliero interno del set (4%) non ha impedito giorni a -6%: non so spiegare perche.'))
E.append(L('Sui conti FTMO: <b>InpStartBalance=80000</b> (non 100000), <b>InpDailyResetHour=1</b> (il reset FTMO e a mezzanotte italiana, cioe le 01:00 del server FTMO, che e ora italiana +1). Il preset BCM demo usa 0.'))

E.append(P('6. Cose nuove dai Termini FTMO (1 novembre 2026) e dai siti',H2))
E.append(L('<b>Tetto 400.000 USD</b> sul capitale iniziale di tutti i conti di un titolare e parti collegate (cl. 5.8.5(c), 6.3). Con due conti da 80.000 EUR sei sotto; oltre 4 conti da 80k si supera.'))
E.append(L('<b>Cl. 7.2.1</b>: vietato fare trade "in coordinamento" con terzi. Voi siete persone diverse con conti e licenze proprie: scambiarsi analisi va bene, far partire gli stessi set negli stessi momenti puo essere letto come coordinamento. <b>Cl. 7.8</b>: una violazione puo far chiudere tutti i conti collegati. <b>Cl. 7.5</b>: FTMO guarda lotti, numero di posizioni ed esposizione cumulata su un simbolo (tutto il vostro portafoglio e oro).'))
E.append(L('<b>Quando raggiungi il +10% o il +5%</b>: chiudi tutte le posizioni <b>e gli ordini pendenti</b> prima di chiedere la valutazione (cl. 5.8.6). Gli EA di Wim lavorano con ordini pendenti.'))
E.append(L('Perdita giornaliera 5%, ricalcolata alle 00:00 CE(S)T; perdita totale 10% statica; minimo 4 giorni. Limite ufficiale di 2.000 richieste al server al giorno (probabilmente comprendono le modifiche di SL/TP: non misurato).'))
E.append(L('MT5, URL da consentire (Strumenti, Opzioni, Expert Advisors): forexeasolutions.org, forexeasolutions.services, tradewithwim.com (secondo dove hai comprato), worldtimeserver.com, nfs.faireconomy.media. Licenze: 10 per EA (non e dichiarato come le conta Wim). Supporto Wim solo lun-ven 9-17 CET.'))

E.append(P('7. Cosa NON e misurato',H2))
E.append(P('Guardian; spread, slippage e stop out di FTMO; tick reali per il 2013 (non esistono dati); Phantom dal vivo (nel segnale di Wim ha profit factor 1,07 contro 2,9 nel tester 2025; test a tick reali sul 2026 non ancora fatto); Daytrade Pro (non ha flottante); un solo percorso per anno su 4 anni (zero fallimenti su circa 8 finestre semestrali = limite superiore al 95% di circa 35%). La mia stima personale, non calcolata, di perdere per i limiti di perdita: Combo A circa 5-15%, Reaper L0 da solo circa 17-25%.'))
E.append(P('Fonti: report/REAPER_SOLO_2026-11-13.md, CONFRONTO_P1_P3_P4_CON_A_B_2026-11-13.md, SOGLIE_4_5_E_9_5_ALTRI_SETTAGGI_2026-11-12.md, PROBABILITA_FALLIRE_STRESS_2026-11-14.md, FTMO_TERMINI_LETTI_2026-11-14.md, NOVITA_EXPERT_DISCORD_2026-11-14.md.',S))
SimpleDocTemplate(OUT,pagesize=A4,leftMargin=15*mm,rightMargin=15*mm,topMargin=13*mm,bottomMargin=13*mm,title='Messaggio per Massimo 14/11/2026',author='Claude (per Claudio)').build(E)
print(OUT)
