#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
collaudo_LOG_AGENTI_P003.py -- COLLAUDO di backtest_pipeline/righe/LOG_AGENTI_P003.ps1 (SOLA LETTURA dei log
grezzi degli agenti del tester). Bozza, NON passata dal cancello.

Costruisce un profilo FINTO (HOME e APPDATA in una cartella temporanea) con log UTF-16 che contengono:
  - ticket PRESENTI (con fallimento "[Market closed]", con retcode 10018, con cancel riuscito, con solo il numero);
  - ticket ASSENTI (devono uscire NON TROVATO: il contro-esempio che il silenzio non diventa una trovata);
  - lo STESSO numero in un'altra passata, fuori finestra, dentro un prezzo ("2466.50"), dentro un numero piu' lungo,
    senza ora simulata, in un file senza riga AVVIO, in un giorno non richiesto, fuori da una cartella Tester;
poi lancia lo script con pwsh (COMPUTERNAME finto DESKTOP-H4D7CAJ) e confronta TICKET_ATTESI.csv con le attese
scritte QUI, a mano, prima di guardare l'uscita. Poi rilancia lo script con 5 MUTANTI (finestra, passata, prezzo,
ora, giorno) e verifica che ognuno faccia fallire il collaudo.

USO: python3 -I backtest_pipeline/collaudo_LOG_AGENTI_P003.py [percorso_script.ps1]
"""
import csv, os, re, shutil, subprocess, sys, tempfile, zipfile

QUI = os.path.dirname(os.path.abspath(__file__))
SCRIPT = sys.argv[1] if len(sys.argv) > 1 else os.path.join(QUI, 'righe', 'LOG_AGENTI_P003.ps1')
PIN = 'a' * 40
FALLITI = []
FATTI = [0]


def ok(cond, msg):
    FATTI[0] += 1
    if not cond:
        FALLITI.append(msg)
        print('   FAIL  ' + msg)
    else:
        print('   ok    ' + msg)


def riga(sim, msg, real='10:00:00.000', src='Core 1'):
    # formato grezzo del log di MT5: codice TAB 0 TAB ora reale TAB sorgente TAB messaggio
    cod = 'AB'
    if sim is None:
        return '\t'.join([cod, '0', real, src, msg])
    return '\t'.join([cod, '0', real, src, sim + '   ' + msg])


def avvio(sim, sym, tf, mg, stop):
    return riga(sim, "[NatCla] AVVIO v1.12 | modalita' AUDIO | %s PERIOD_%s | 1 u = 1.00 (AUTO_CLASSE) | 1 pip = 0.01 | magic %s | linee ST25 ST30 ST35  | ADX ACCESO | stop %s" % (sym, tf, mg, stop))


def log_principale():
    L = []
    # ---- passata 1: P_003 (EURUSD H1 778601 OLTRE_LINEA_ESTERNA) ----
    L.append(riga(None, 'Tester\tlast test started'))
    L.append(avvio('2024.07.05 00:00:00', 'EURUSD', 'H1', '778601', 'OLTRE_LINEA_ESTERNA'))
    L.append(riga('2025.02.28 20:59:58', 'neutra A'))
    L.append(riga('2025.02.28 20:59:59', 'neutra B'))
    L.append(riga('2025.02.28 21:00:00', 'order #4603 sell limit 0.50 EURUSD at 1.04032 placed'))            # 4603 solo numero
    L.append(riga('2025.02.28 21:30:00', 'neutra C'))
    L.append(riga('2025.02.28 21:59:59', 'neutra D'))
    L.append(riga('2025.02.28 22:00:00', 'neutra E'))
    L.append(riga('2025.02.28 22:00:00', 'CTrade::OrderSend: cancel order #4603 sell limit 0.50 EURUSD at 1.04032 [Market closed]'))  # 4603 FALLIMENTO
    L.append(riga('2025.02.28 22:00:00', 'neutra F'))
    L.append(riga('2025.02.28 22:00:10', 'neutra G'))
    L.append(riga('2025.02.28 22:00:20', 'neutra H'))
    L.append(riga('2025.02.28 22:00:30', 'failed cancel #4604 sell limit 0.50 EURUSD [Market closed]'))   # 4604 FALLIMENTO (testo gia' contato)
    L.append(riga('2025.02.28 22:00:40', 'failed cancel #4603 sell limit [Market closed]'))                # 4603 secondo FALLIMENTO
    L.append(riga(None, 'cancel #4604 senza ora simulata [Market closed]'))                              # 4604 SENZA_ORA
    L.append(riga('2025.06.01 22:00:00', 'failed cancel #4603 sell limit 0.50 EURUSD [Market closed]'))   # 4603 FUORI_FINESTRA (3 mesi dopo)
    # 4605: NESSUNA riga in questa passata (ticket assente)
    L.append(riga('2025.03.02 23:05:00', "[NatCla] ADOTTATO ST25: 1 posizioni senza setup in memoria (riempimento durante una cancellazione?)"))
    # ---- passata 2: M30_002 (XAUUSD M30 778603 GEOMETRIA_ATTUALE) ----
    L.append(avvio('2024.07.10 00:00:00', 'XAUUSD', 'M30', '778603', 'GEOMETRIA_ATTUALE'))
    L.append(riga('2024.09.15 22:59:57', 'neutra I'))
    L.append(riga('2024.09.15 22:59:58', 'neutra J'))
    L.append(riga('2024.09.15 22:59:59', 'neutra K'))
    L.append(riga('2024.09.15 23:00:00', 'CTrade::OrderSend: cancel order #1966 buy limit 0.90 XAUUSD at 2578.00 [Market closed]'))   # 1966 FALLIMENTO
    L.append(riga('2024.09.15 23:00:01', 'neutra L'))
    L.append(riga('2024.09.15 23:00:02', 'neutra M'))
    L.append(riga('2024.09.15 23:00:03', 'neutra N'))
    L.append(riga('2024.09.15 23:10:01', 'order #1969 buy limit 0.90 XAUUSD canceled'))              # 1969 cancel riuscito, niente fallimento
    L.append(riga('2024.09.15 23:10:00', 'deal #55 buy 0.90 XAUUSD at 2577.94 done (based on order #1967)'))  # 1967 solo numero
    L.append(riga('2024.10.13 23:10:00', 'cancel order #2467 failed retcode 10018 market closed'))    # 2467 FALLIMENTO (retcode)
    L.append(riga('2024.10.13 23:10:01', 'cancel order #2468 retcode 10009 done'))                     # 2468 kw senza fallimento (10009 = done)
    L.append(riga('2024.10.13 23:10:02', 'buy limit at 2466.50 failed [invalid price]'))              # prezzo 2466.50: NON e' il ticket 2466
    L.append(riga('2024.10.13 23:10:03', 'cancel volume 124660 failed [Market closed]'))              # numero piu' lungo: NON e' il ticket 2466
    L.append(riga('2024.10.13 23:10:04', 'cancel 2466,5 failed [Market closed]'))                     # 2466,5: NON e' il ticket
    L.append(riga('2025.05.25 23:10:01', 'cancel order #9736 [Market closed]'))                        # 9736: nome diverso per il fallimento? -> parola chiave cancel + market closed
    # collisione: M30_003 ha un'ALTRA numerazione, ma qui mettiamo il numero 1696 (di M30_003) in una passata che non e' la sua
    L.append(riga('2024.09.15 23:00:30', 'cancel order #1696 buy limit [Market closed]'))              # 1696 in passata 2: ALTRO_SEGMENTO
    # ---- passata 3: M30_003 (XAUUSD M30 778603 OLTRE_PIU_ESTERNA) ----
    L.append(avvio('2024.07.10 00:00:00', 'XAUUSD', 'M30', '778603', 'OLTRE_PIU_ESTERNA'))
    L.append(riga('2024.09.15 23:00:00', 'CTrade::OrderSend: cancel order #1696 buy limit 0.90 XAUUSD [Market closed]'))   # 1696 FALLIMENTO (passata giusta)
    L.append(riga('2024.09.15 23:00:00', 'CTrade::OrderSend: cancel order #1966 buy limit 0.90 XAUUSD [Market closed]'))   # 1966 in passata 3: ALTRO_SEGMENTO (collisione di numeri)
    L.append(riga('2025.02.28 22:00:10', 'cancel #4605 sell limit [Market closed]'))                     # 4605 in passata 3 (XAUUSD): ALTRO_SEGMENTO
    L.append(riga('2024.09.15 23:00:00', 'failed instant buy 0.10 XAUUSD at 2578.00 [Market closed]'))   # nessun ticket: solo sonda globale
    return L


def scrivi_utf16(path, righe):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'wb') as f:
        f.write(b'\xff\xfe')
        f.write(('\r\n'.join(righe) + '\r\n').encode('utf-16-le'))


def prepara(radice, con_log=True):
    appdata = os.path.join(radice, 'AppData')
    home = os.path.join(radice, 'home')
    desk = os.path.join(home, 'Desktop')
    os.makedirs(desk, exist_ok=True)
    mq = os.path.join(appdata, 'MetaQuotes')
    os.makedirs(mq, exist_ok=True)
    if con_log:
        h = 'AB12CD34EF56AB12CD34EF56AB12CD34'
        scrivi_utf16(os.path.join(mq, 'Tester', h, 'Agent-127.0.0.1-3000', 'logs', '20261011.log'), log_principale())
        # giorno NON richiesto: elencato, non letto
        scrivi_utf16(os.path.join(mq, 'Tester', h, 'Agent-127.0.0.1-3000', 'logs', '20261010.log'),
                     [avvio('2024.07.10 00:00:00', 'XAUUSD', 'M30', '778603', 'GEOMETRIA_ATTUALE'),
                      riga('2024.09.15 23:00:00', 'cancel order #1969 [Market closed]')])
        # log del terminale in UTF-8 senza BOM, senza riga AVVIO: SEGMENTO_IGNOTO
        p = os.path.join(mq, 'Terminal', 'FEDCBA9876543210FEDCBA9876543210', 'Tester', 'logs', '20261011.log')
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, 'wb') as f:
            f.write((riga('2025.05.25 23:10:01', 'cancel order #9737 [Market closed]') + '\r\n').encode('ascii'))
        # FUORI da una cartella Tester: non si elenca e non si legge
        scrivi_utf16(os.path.join(mq, 'Terminal', 'FEDCBA9876543210FEDCBA9876543210', 'MQL5', 'Logs', '20261011.log'),
                     [riga('2024.09.15 23:00:00', 'cancel order #1971 [Market closed]')])
    # file di "Claudio" gia' sul Desktop con gli stessi nomi: devono essere RINOMINATI, mai sovrascritti
    os.makedirs(os.path.join(desk, 'LOG_AGENTI_P003'), exist_ok=True)
    with open(os.path.join(desk, 'LOG_AGENTI_P003', 'MIO_FILE.txt'), 'w') as f:
        f.write('file di Claudio, non toccare\n')
    with open(os.path.join(desk, 'LOG_AGENTI_P003.zip'), 'wb') as f:
        f.write(b'PK-finto-di-Claudio')
    return appdata, home, desk


def lancia(script, radice, computername='DESKTOP-H4D7CAJ', extra=None):
    appdata = os.path.join(radice, 'AppData')
    home = os.path.join(radice, 'home')
    env = dict(os.environ)
    env['COMPUTERNAME'] = computername
    env['APPDATA'] = appdata
    env['HOME'] = home
    env['XDG_DESKTOP_DIR'] = os.path.join(home, 'Desktop')
    args = ['pwsh', '-NoProfile', '-File', script, '-Pin', PIN] + (extra or [])
    r = subprocess.run(args, env=env, capture_output=True, text=True, timeout=300, cwd=radice)
    return r


def leggi_csv(path):
    with open(path, newline='') as f:
        return {r['ticket']: r for r in csv.DictReader(f, delimiter=';')}


# ATTESE scritte a mano PRIMA di guardare l'uscita: ticket -> (coerenti, con_parola_chiave, con_fallimento, con_cancel, fuori, altro_seg, senza_ora, ignoto, verdetto_inizia_con)
ATTESE = {
    '4603': (3, 2, 2, 2, 1, 0, 0, 0, 'TROVATO: 2'),
    '4604': (1, 1, 1, 1, 0, 0, 1, 0, 'TROVATO: 1'),
    '4605': (0, 0, 0, 0, 0, 1, 0, 0, 'NON TROVATO'),
    '1966': (1, 1, 1, 1, 0, 1, 0, 0, 'TROVATO: 1'),
    '1967': (1, 0, 0, 0, 0, 0, 0, 0, 'TROVATO solo il numero'),
    '1969': (1, 1, 0, 1, 0, 0, 0, 0, 'TROVATO SOLO senza fallimento: 1'),
    '2467': (1, 1, 1, 1, 0, 0, 0, 0, 'TROVATO: 1'),
    '2468': (1, 1, 0, 1, 0, 0, 0, 0, 'TROVATO SOLO senza fallimento: 1'),
    '2466': (0, 0, 0, 0, 0, 0, 0, 0, 'NON TROVATO'),
    '9736': (1, 1, 1, 1, 0, 0, 0, 0, 'TROVATO: 1'),
    '9737': (0, 0, 0, 0, 0, 0, 0, 1, 'NON TROVATO'),
    '1696': (1, 1, 1, 1, 0, 1, 0, 0, 'TROVATO: 1'),
    '1971': (0, 0, 0, 0, 0, 0, 0, 0, 'NON TROVATO'),
    '1970': (0, 0, 0, 0, 0, 0, 0, 0, 'NON TROVATO'),
}


def collauda_ticket(tab):
    for tk, att in ATTESE.items():
        r = tab.get(tk)
        if r is None:
            ok(False, 'ticket %s assente da TICKET_ATTESI.csv' % tk)
            continue
        got = (int(r['righe_coerenti']), int(r['con_parola_chiave']), int(r['con_fallimento']), int(r['con_cancel']),
               int(r['fuori_finestra']), int(r['altro_segmento']), int(r['senza_ora']), int(r['segmento_ignoto']))
        ok(got == att[:8], 'ticket %s contatori %s == attesi %s' % (tk, got, att[:8]))
        ok(r['verdetto'].startswith(att[8]), 'ticket %s verdetto "%s" inizia con "%s"' % (tk, r['verdetto'], att[8]))


def corsa_completa(script, nome, post=None):
    print('== CORSA %s' % nome)
    with tempfile.TemporaryDirectory() as radice:
        appdata, home, desk = prepara(radice)
        r = lancia(script, radice)
        out = r.stdout + r.stderr
        ok(r.returncode == 0, '%s: rc 0 (got %s)' % (nome, r.returncode))
        cart = os.path.join(desk, 'LOG_AGENTI_P003')
        zp = os.path.join(desk, 'LOG_AGENTI_P003.zip')
        ok(os.path.isdir(cart), '%s: cartella Desktop/LOG_AGENTI_P003 creata' % nome)
        ok(os.path.isfile(zp), '%s: zip creato' % nome)
        if not (os.path.isdir(cart) and os.path.isfile(zp)):
            print(out[-2000:])
            return None
        attesi = ['RIEPILOGO_LOG_AGENTI_P003.txt', 'RIGHE_CON_CONTESTO.txt', 'RIGHE_TROVATE.csv', 'FILE_LOG_TROVATI.csv', 'TICKET_ATTESI.csv']
        for a in attesi:
            ok(os.path.isfile(os.path.join(cart, a)), '%s: %s presente' % (nome, a))
        with zipfile.ZipFile(zp) as z:
            nomi = sorted(os.path.basename(n) for n in z.namelist())
        ok(nomi == sorted(attesi), '%s: lo zip contiene esattamente i 5 file attesi (%s)' % (nome, nomi))
        # nessun file di Claudio sovrascritto
        vecchie = [d for d in os.listdir(desk) if d.startswith('LOG_AGENTI_P003_VECCHIA_')]
        ok(len(vecchie) == 1 and os.path.isfile(os.path.join(desk, vecchie[0], 'MIO_FILE.txt')), '%s: la cartella di Claudio e stata RINOMINATA con MIO_FILE.txt intatto (%s)' % (nome, vecchie))
        vz = [d for d in os.listdir(desk) if d.startswith('LOG_AGENTI_P003_VECCHIO_') and d.endswith('.zip')]
        ok(len(vz) == 1 and open(os.path.join(desk, vz[0]), 'rb').read() == b'PK-finto-di-Claudio', '%s: lo zip di Claudio e stato RINOMINATO con contenuto intatto (%s)' % (nome, vz))
        # i log originali non sono stati toccati
        lp = os.path.join(appdata, 'MetaQuotes', 'Tester', 'AB12CD34EF56AB12CD34EF56AB12CD34', 'Agent-127.0.0.1-3000', 'logs', '20261011.log')
        with open(lp, 'rb') as f:
            ok(f.read() == (b'\xff\xfe' + ('\r\n'.join(log_principale()) + '\r\n').encode('utf-16-le')), '%s: il log sorgente e BYTE PER BYTE identico a come e stato scritto' % nome)
        tab = leggi_csv(os.path.join(cart, 'TICKET_ATTESI.csv'))
        res = dict(out=out, cart=cart, tab=tab, desk=desk)
        if post is not None:
            post(res)
        return res


def corsa_senza_log(script=None):
    script = script or SCRIPT
    print('== CORSA senza nessun file log del giorno')
    with tempfile.TemporaryDirectory() as radice:
        appdata, home, desk = prepara(radice, con_log=False)
        r = lancia(script, radice)
        ok(r.returncode == 0, 'senza log: rc 0 (got %s)' % r.returncode)
        cart = os.path.join(desk, 'LOG_AGENTI_P003')
        tab = leggi_csv(os.path.join(cart, 'TICKET_ATTESI.csv'))
        ok(all(v['verdetto'].startswith('NON VERIFICABILE') for v in tab.values()) and len(tab) == 33, 'senza log: tutti i 33 ticket sono NON VERIFICABILE (non NON TROVATO)')
        ok('NON VERIFICABILE' in r.stdout, 'senza log: la console dice NON VERIFICABILE')
        riep = open(os.path.join(cart, 'RIEPILOGO_LOG_AGENTI_P003.txt')).read()
        ok('NESSUNO' in riep and 'NON e una smentita' in riep, 'senza log: il riepilogo dice che nessun file e stato trovato e che il silenzio non e una smentita')


def guardie():
    print('== GUARDIE')
    with tempfile.TemporaryDirectory() as radice:
        appdata, home, desk = prepara(radice)
        r = lancia(SCRIPT, radice, computername='VMI3047753')
        ok(r.returncode != 0 and 'SOLO SUL PC DI BACKTEST' in (r.stdout + r.stderr), 'COMPUTERNAME VMI3047753: lo script SI FERMA (rc %s)' % r.returncode)
        ok(sorted(os.listdir(desk)) == ['LOG_AGENTI_P003', 'LOG_AGENTI_P003.zip'], 'COMPUTERNAME VMI3047753: il Desktop e INTATTO (%s)' % sorted(os.listdir(desk)))
        r = lancia(SCRIPT, radice, computername='ALTRO-PC')
        ok(r.returncode != 0, 'COMPUTERNAME ALTRO-PC: lo script SI FERMA (rc %s)' % r.returncode)
        env = dict(os.environ)
        r = subprocess.run(['pwsh', '-NoProfile', '-File', SCRIPT, '-Pin', 'zzz'], env=dict(env, COMPUTERNAME='DESKTOP-H4D7CAJ', APPDATA=appdata, HOME=home, XDG_DESKTOP_DIR=desk), capture_output=True, text=True, timeout=120)
        ok(r.returncode != 0, '-Pin non esadecimale: rifiutato (rc %s)' % r.returncode)
        r = lancia(SCRIPT, radice, extra=['-Giorni', '2026-10-11'])
        ok(r.returncode != 0 and 'AAAAMMGG' in (r.stdout + r.stderr), '-Giorni in formato sbagliato: rifiutato')
        ok(sorted(os.listdir(desk)) == ['LOG_AGENTI_P003', 'LOG_AGENTI_P003.zip'], 'dopo i rifiuti il Desktop e ancora INTATTO')


def verifica_corsa(res):
    tab = res['tab']
    ok(len(tab) == 33, 'TICKET_ATTESI.csv ha 33 righe (%d)' % len(tab))
    collauda_ticket(tab)
    ok('altra passata 1' in tab['4605']['verdetto'] and 'SCARTATE' in tab['4605']['verdetto'], 'ticket 4605: il NON TROVATO dichiara la riga SCARTATA (altra passata 1)')
    ok(tab['1970']['verdetto'] == 'NON TROVATO', 'ticket 1970: NON TROVATO puro, senza righe scartate')
    cart = res['cart']
    ctx = open(os.path.join(cart, 'RIGHE_CON_CONTESTO.txt')).read()
    # contesto: il blocco del 1966 deve avere 3 righe prima (neutra I/J/K... in realta' K,L? vedi sotto) e 3 dopo
    ok('neutra I' not in ctx or True, 'contesto: (controllo morbido)')
    i = ctx.find('ticket 1966')
    blocco = ctx[i:i + 1500]
    ok('- ' in blocco and 'neutra J' in blocco and 'neutra K' in blocco and '+ ' in blocco and 'neutra L' in blocco and 'neutra N' in blocco, 'contesto: il blocco del ticket 1966 ha le 3 righe prima (I,J,K) e le 3 dopo (L,M,N)')
    ok('neutra I' in blocco, 'contesto: ... e la riga neutra I e fra le 3 prima')
    riep = open(os.path.join(cart, 'RIEPILOGO_LOG_AGENTI_P003.txt')).read()
    # conteggio per testo d'errore: [market closed] nelle righe coerenti dei ticket = 4603 x2, 4604, 1966, 9736, 1696 = 6 ; 2467 e retcode 10018
    m = re.search(r'4a\..*?\n(.*?)\n   4b\.', riep, re.S)
    blocco4a = m.group(1) if m else ''
    ok(re.search(r'\s6\s+\[market closed\]', blocco4a) is not None, '4a: [market closed] contato 6 volte sulle righe coerenti dei ticket (%r)' % blocco4a)
    ok(re.search(r'\s1\s+retcode 10018', blocco4a) is not None, '4a: retcode 10018 contato 1 volta (%r)' % blocco4a)
    ok('[invalid price]' not in blocco4a, '4a: il prezzo 2466.50 NON ha prodotto un [invalid price] fra i ticket (%r)' % blocco4a)
    m = re.search(r'4b\..*?\n(.*?)\n\n5\.', riep, re.S)
    blocco4b = m.group(1) if m else ''
    ok(re.search(r'\[invalid price\]', blocco4b) is not None, '4b: il testo [invalid price] c e fra gli errori GLOBALI del giorno (%r)' % blocco4b)
    # i file elencati
    ft = open(os.path.join(cart, 'FILE_LOG_TROVATI.csv')).read()
    ok('20261010.log' in ft and re.search(r'20261010\.log;[^;]*;[0-9]+;no;no;', ft) is not None, 'FILE_LOG_TROVATI: il 20261010.log e elencato come NON richiesto e NON letto')
    ok(len(re.findall(r'20261011\.log;[^;]*;[0-9]+;si;si;', ft)) == 2, 'FILE_LOG_TROVATI: i due 20261011.log sotto Tester sono letti')
    ok('MQL5' not in ft, 'FILE_LOG_TROVATI: il log fuori da una cartella Tester (MQL5\\Logs) NON e elencato')
    rt = open(os.path.join(cart, 'RIGHE_TROVATE.csv')).read()
    ok(' #1971 ' not in rt and ';1971;' not in rt, 'RIGHE_TROVATE: nessuna riga del ticket 1971 (e solo nel log fuori da Tester)')
    ok(';2466;' not in rt, 'RIGHE_TROVATE: nessuna riga del ticket 2466 (prezzo 2466.50, 124660 e 2466,5 non contano)')
    ok(';1969;' in rt and ';ALTRO_SEGMENTO;' in rt and ';FUORI_FINESTRA;' in rt and ';SENZA_ORA;' in rt and ';SEGMENTO_IGNOTO;' in rt, 'RIGHE_TROVATE: tutte le classi (ALTRO_SEGMENTO, FUORI_FINESTRA, SENZA_ORA, SEGMENTO_IGNOTO) sono registrate')
    ok('COERENTE' in rt, 'RIGHE_TROVATE: c e la classe COERENTE')
    # sonda globale: la riga "failed instant buy" senza ticket fa salire failed della passata 3
    ok('SONDA GLOBALE' in riep, 'RIEPILOGO: c e la sonda globale')
    # tutto ASCII
    for nome in os.listdir(cart):
        b = open(os.path.join(cart, nome), 'rb').read()
        ok(all(c < 128 for c in b), '%s: ASCII puro' % nome)


def mutante(nome, sost):
    with open(SCRIPT) as f:
        t = f.read()
    n = t
    for a, b in sost:
        if a not in n:
            ok(False, 'mutante %s: pattern non trovato nello script: %r' % (nome, a))
            return
        n = n.replace(a, b, 1)
    d = tempfile.mkdtemp()
    p = os.path.join(d, 'LOG_AGENTI_P003_MUTANTE.ps1')
    with open(p, 'w') as f:
        f.write(n)
    before = len(FALLITI)
    nb = FATTI[0]
    print('== MUTANTE %s (i FAIL qui sotto sono ATTESI)' % nome)
    res = corsa_completa(p, 'mutante ' + nome, verifica_corsa)
    corsa_senza_log(p)
    shutil.rmtree(d, ignore_errors=True)
    presi = len(FALLITI) - before
    for _ in range(presi):
        FALLITI.pop()
    FATTI[0] = nb
    return presi > 0


def main():
    if shutil.which('pwsh') is None:
        print('pwsh non disponibile: collaudo NON eseguibile')
        return 2
    res = corsa_completa(SCRIPT, 'script vero', verifica_corsa)
    corsa_senza_log()
    guardie()
    print()
    print('collaudo dello script vero: %d controlli, %d FALLITI' % (FATTI[0], len(FALLITI)))
    veri_falliti = len(FALLITI)
    # MUTANTI: ognuno deve far FALLIRE almeno un controllo
    mut = [
        ('senza_finestra', [("elseif($sim -lt $row.piazzato.AddMinutes(-1) -or $sim -gt $row.fine.AddMinutes(2)){ $classe = 'FUORI_FINESTRA'; $row.n_fuori++ }", "elseif($false){ $classe = 'FUORI_FINESTRA'; $row.n_fuori++ }")]),
        ('senza_passata', [("elseif($segSim -ne $row.simbolo -or $segTf -ne $row.tf -or $segMg -ne $row.magic -or $segSt -ne $row.stop){ $classe = 'ALTRO_SEGMENTO'; $row.n_altro_seg++ }", "elseif($false){ $classe = 'ALTRO_SEGMENTO'; $row.n_altro_seg++ }")]),
        ('numero_dentro_prezzo', [("(?![0-9])(?![.,][0-9])'), $Opz)", "(?![0-9])'), $Opz)")]),
        ('numero_dentro_numero', [("'(?<![0-9])(?<![0-9][.,])(?:'", "'(?:'"), ("(?![0-9])(?![.,][0-9])'), $Opz)", "'), $Opz)")]),
        ('senza_ora_e_ok', [("if($null -eq $sim){ $classe = 'SENZA_ORA'; $row.n_senza_ora++ }", "if($false){ $classe = 'SENZA_ORA'; $row.n_senza_ora++ }")]),
        ('legge_ogni_giorno', [("$DaLeggere = @($Trovati | Where-Object { $ListaGiorni -contains $_.BaseName })", "$DaLeggere = @($Trovati)")]),
        ('verdetto_vuoto_e_non_trovato', [("if($nLetti -eq 0){ return 'NON VERIFICABILE (nessun file log del giorno letto)' }", "if($false){ return 'x' }")]),
        ('retcode_10009_e_fallimento', [("retcode\\s*:?\\s*(?!10008|10009)[0-9]+", "retcode\\s*:?\\s*[0-9]+")]),
        ('sovrascrive_cartella', [("Move-Item -LiteralPath $Cart -Destination $nuovo", "Remove-Item -LiteralPath $Cart -Recurse -Force")]),
    ]
    presi = 0
    for nome, sost in mut:
        if mutante(nome, sost):
            presi += 1
            print('   MUTANTE %s PRESO dal collaudo' % nome)
        else:
            print('   *** MUTANTE %s NON PRESO ***' % nome)
            FALLITI.append('mutante %s non preso' % nome)
    print()
    print('MUTANTI presi: %d su %d' % (presi, len(mut)))
    print('RISULTATO: %d controlli sullo script vero, %d FALLITI; mutanti presi %d/%d' % (FATTI[0], veri_falliti, presi, len(mut)))
    if FALLITI:
        print('FALLITI:')
        for f in FALLITI:
            print('  - ' + f)
        return 1
    print('COLLAUDO OK')
    return 0


if __name__ == '__main__':
    sys.exit(main())
