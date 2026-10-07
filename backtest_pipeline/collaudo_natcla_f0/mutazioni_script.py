#!/usr/bin/env python3
# -*- coding: ascii -*-
"""
mutazioni_script.py -- il COLLAUDO DEL COLLAUDO della batteria di NATCLA_F0_PASSATE.ps1: ogni mutante cambia UNA riga dello script (sulla copia che il banco lancia, in una cartella temporanea FUORI
dal repo: classe 1159) e lo scenario che dovrebbe vederla deve diventare ROSSO. Per ogni mutante gira UNO scenario mirato (il piu' economico che dovrebbe prenderlo), non tutta la batteria.
Un mutante che sopravvive e' un controllo dello script che la batteria non guarda. Esce 1 se un mutante sopravvive o se uno scenario NON e' verde sullo script non mutato.
Uso: python3 -I backtest_pipeline/collaudo_natcla_f0/mutazioni_script.py [--solo D28]
"""
import os, sys, tempfile, shutil

QD = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, QD)
import banco as B
import battery as T


def prova_mut(f):
    return lambda b: f(b.decode("ascii")).encode("ascii")


# ---- gli scenari: ognuno ritorna True se lo script si e' comportato BENE
def sc_pilota_ok(r):
    m = T.manifest(T.zip_di(r["c"])) if T.zip_di(r["c"]) else []
    return T.rc_di(r["p"]) == "0" and len(m) == 8 and all(x["stato"] == "OK" for x in m)


def sc_pilota_ini(r):
    la = T.lanci(r["sd"])
    return (len(la) == 8 and all("Optimization=0 Model=1 Live=false Dll=false SoloConta=true" in x for x in la) and all("Magic=0 " in x for x in la)
            and [x.split("Modalita=")[1].split(" Magic")[0] for x in la] == ["0 TF=16385", "2 TF=16385"] * 4)


def sc_si_ferma(r):
    return T.rc_di(r["p"]) != "0" and not T.lanci(r["sd"]) and T.zip_di(r["c"]) is None


def sc_ko_una(fault_msg):
    def f(r):
        z = T.zip_di(r["c"])
        m = T.manifest(z) if z else []
        uno = [x for x in m if x["simbolo"] == "EURUSD" and x["config"] == "AUDIO_H1"]
        return len(m) == 8 and len(uno) == 1 and uno[0]["stato"] == "KO" and fault_msg in uno[0]["motivi"] and T.rc_di(r["p"]) == "3"
    return f


def sc_tetto(r):
    z = T.zip_di(r["c"])
    m = T.manifest(z) if z else []
    return len(m) == 8 and all(x["stato"] == "NON_LANCIATA" for x in m) and not T.lanci(r["sd"])


def sc_timeout(r):
    z = T.zip_di(r["c"])
    m = T.manifest(z) if z else []
    return len(m) == 2 and all(x["stato"] == "KO" and "timeout" in x["motivi"] for x in m) and os.path.exists(os.path.join(r["sd"], "simlog", "sim_closemainwindow.txt"))


def sc_noclose(r):
    z = T.zip_di(r["c"])
    m = T.manifest(z) if z else []
    return len(m) == 2 and m[1]["stato"] == "NON_LANCIATA" and len(T.lanci(r["sd"])) == 1


def sc_vecchi(r):
    ds = os.path.join(r["c"], "Users", "Master", "Desktop")
    el = os.listdir(ds)
    return any(x.startswith("NATCLA_F0_PILOTA_VECCHIO_") for x in el) and any(x.startswith("NATCLA_F0_PILOTA_VECCHIA_") for x in el)


def sc_ex5(r):
    return sc_si_ferma(r) and ".ex5 NON prodotto" in (r["p"].stdout + r["p"].stderr)


def sc_due_ok(r):
    z = T.zip_di(r["c"])
    m = T.manifest(z) if z else []
    la = T.lanci(r["sd"])
    return T.rc_di(r["p"]) == "0" and len(m) == 2 and all(x["stato"] == "OK" for x in m) and [x.split("TF=")[1].split(" Magic")[0] for x in la] == ["16388", "16408"]


def sc_unita(r):
    z = T.zip_di(r["c"])
    m = T.manifest(z) if z else []
    return [x["stato"] for x in m if x["simbolo"] == "EURUSD"] == ["KO", "KO"] and "1 u" in m[0]["motivi"]


def sc_rc3(r):
    return T.rc_di(r["p"]) == "3"


TF_ALTI = lambda t: t.replace("simboli=EURUSD,GBPUSD,XAUUSD,U30USD configs=AUDIO_H1,M2_H1", "simboli=EURUSD configs=AUDIO_H4,AUDIO_D1")
SOLO1 = lambda t: t.replace("simboli=EURUSD,GBPUSD,XAUUSD,U30USD configs=AUDIO_H1,M2_H1", "simboli=EURUSD,GBPUSD configs=AUDIO_H1")
TETTO0 = lambda t: t.replace("@F0-LOTTO nome=PILOTA tetto_min=40", "@F0-LOTTO nome=PILOTA tetto_min=0")

# (nome, vecchio, nuovo, scenario(kwargs per banco), predicato, volte)
MUTANTI = [
    ("D01 AllowLiveTrading=true", "AllowLiveTrading=false`r`nAllowDllImport", "AllowLiveTrading=true`r`nAllowDllImport", {}, sc_pilota_ini),
    ("D02 Modello 4 invece di 1", 'Period=" + $cfg.periodo + "`r`nModel=1`r`n', 'Period=" + $cfg.periodo + "`r`nModel=4`r`n', {}, sc_pilota_ini),
    ("D03 Optimization=1", '"Optimization=0`r`nFromDate=', '"Optimization=1`r`nFromDate=', {}, sc_pilota_ini),
    ("D04 magic automatico tolto (InpMagic=1)", "[void]$righeIn.Add('InpMagic=0')", "[void]$righeIn.Add('InpMagic=1')", {}, sc_pilota_ini),
    ("D05 modalita della configurazione non sostituita", "if($pp[0] -eq 'InpModalita'){ $val = $cfg.modalita }", "if($pp[0] -eq 'InpModalita'){ $val = $val }", {}, sc_pilota_ini),
    ("D06 TF della configurazione non sostituito (lotto con H4 e D1)", "if($pp[0] -eq 'InpTF'){ $val = $cfg.tf }", "if($pp[0] -eq 'InpTF'){ $val = $val }", dict(muta={B.F_PROVA: prova_mut(TF_ALTI)}), sc_due_ok),
    ("D07 guardia macchina tolta", "if($env:COMPUTERNAME -ne 'DESKTOP-H4D7CAJ'){", "if($false){", dict(macchina="VMI3047753"), sc_si_ferma),
    ("D08 guardia MT5 aperto tolta", "if((@(Get-Process -Name terminal64, metaeditor64 -ErrorAction SilentlyContinue)).Count -gt 0){", "if($false){", dict(mt5_vivo="terminal64"), sc_si_ferma),
    ("D09 guardia sedie attaccate tolta", "if($conEA.Count -gt 0){ throw", "if($false){ throw", dict(chr=[{}, {"ea": "ABTG_Qualcosa"}]), sc_si_ferma),
    ("D10 installazione non censita ammessa", "if($ignote.Count -gt 0){", "if($false){", dict(altra_inst=True), sc_si_ferma),
    ("D11 mutex ignorato", "if(-not $preso){", "if($false){", dict(mutex_occupato=True), sc_si_ferma),
    ("D12 SHA256 non confrontato", "if($hh -ne $ck[1]){ throw", "if($false){ throw", dict(sha_override={"ea": "0" * 64}), sc_si_ferma),
    ("D13 InpSoloConta=true non preteso", "if($pinH['InpSoloConta'] -ne 'true'){ throw", "if($false){ throw", dict(muta={B.F_PROVA: prova_mut(lambda t: t.replace("InpSoloConta=true", "InpSoloConta=false"))}), sc_si_ferma),
    ("D14 tetto di minuti ignorato", "if($abort -or $minDa -ge $tettoMin){", "if($abort){", dict(muta={B.F_PROVA: prova_mut(TETTO0)}), sc_tetto),
    ("D15 AVVIO: versione non controllata", "if($G['v'].Value -ne $VERSIONE_ATTESA){", "if($false){", dict(scen=dict(falli={"EURUSD_AUDIO_H1": "avvio_ver"})), sc_ko_una("versione EA")),
    ("D16 AVVIO: solo conta non controllato", "if($G['sc'].Value -ne 'SI'){", "if($false){", dict(scen=dict(falli={"EURUSD_AUDIO_H1": "solo_no"})), sc_ko_una("solo conta")),
    ("D17 AVVIO: unita non controllata", "if([math]::Abs((Num $G['u'].Value) - $uAtt) -gt 1e-9){", "if($false){", dict(scen=dict(unita={"EURUSD": "1.0"})), sc_unita),
    ("D18 VERIFICA ADX Wilder accettata", "if($adxV -ne 'MetaQuotes'){", "if($false){", dict(scen=dict(falli={"EURUSD_AUDIO_H1": "wilder"})), sc_ko_una("Wilder")),
    ("D19 CSV vecchio accettato (freschezza)", "if($it.LastWriteTime -ge $tDa){ return $it }", "if($true){ return $it }", dict(scen=dict(falli={"EURUSD_AUDIO_H1": "csv_vecchio"})), sc_ko_una("NON trovato fresco")),
    ("D20 finestra girata non confrontata", "$mf.Groups['a'].Value -eq $DATA_A -and", "$true -and", dict(scen=dict(falli={"EURUSD_AUDIO_H1": "finestra"})), sc_ko_una("finestra girata DIVERSA")),
    ("D21 log vecchio riletto dall'inizio (fotografia ignorata)", "if($foto.ContainsKey($f.FullName)){ $off = [long]$foto[$f.FullName] }", "$off = 0", dict(log_vecchio=True), sc_pilota_ok),
    ("D22 zip vecchio cancellato invece che rinominato", "Move-Item -LiteralPath $zip -Destination (Join-Path $dsk ('NATCLA_F0_' + $Lotto + '_VECCHIO_' + $stampa + '.zip')) -Force", "Remove-Item -LiteralPath $zip -Force", dict(desktop_vecchio=True), sc_vecchi),
    ("D23 rc 0 sempre", "\nexit 3", "\nexit 0", dict(scen=dict(falli={"EURUSD_AUDIO_H1": "nocsv"})), sc_rc3),
    ("D24 CSV senza intestazione accettato", "if(-not $cc.Header){", "if($false){", dict(scen=dict(falli={"EURUSD_AUDIO_H1": "csv_senza_header"})), sc_ko_una("senza intestazione")),
    ("D25 CloseMainWindow tolto (timeout senza chiusura)", "try{ [void]$p.CloseMainWindow() }catch{ }", "", dict(timeout_min=1, no_exit=True, sleep_reale=True, muta={B.F_PROVA: prova_mut(SOLO1)}), sc_timeout),
    ("D26 terminale che non si chiude: il lotto prosegue", "if(-not $p.HasExited){ $abort = $true;", "if($false){ $abort = $true;", dict(timeout_min=1, no_exit=True, no_close=True, sleep_reale=True, muta={B.F_PROVA: prova_mut(SOLO1)}), sc_noclose),
    ("D27 nome del CSV con il magic sbagliato", "$nomeCsv = 'natcla_setup_' + $sim.nome + '_' + $cfg.magic + '.csv'", "$nomeCsv = 'natcla_setup_' + $sim.nome + '_' + $cfg.modalita + '.csv'", {}, sc_pilota_ok),
    ("D28 .ex5 non atteso (compilazione fallita in silenzio: nessun .ex5, log con 0 errori)", "if(-not (Test-Path -LiteralPath $ex5)){\n  try{", "if($false){\n  try{", dict(scen=dict(compile_fallisce=True, compile_silenzioso=True)), sc_ex5),
    ("D30 log con errori ignorato (.ex5 c'e' ma il log dice errori)", "if($compErr -gt 0){ throw", "if($false){ throw", dict(scen=dict(compile_errori_con_ex5=True)), sc_si_ferma),
    ("D29 AVVIO rifiutato dall'EA non visto", "if($rr -match 'AVVIO RIFIUTATO|ERRORE|INIT_FAILED|FALLITA'){", "if($false){", dict(scen=dict(falli={"EURUSD_AUDIO_H1": "rifiutato"})), sc_ko_una("AVVIO RIFIUTATO")),
]


def main():
    solo = sys.argv[sys.argv.index("--solo") + 1] if "--solo" in sys.argv else None
    base = tempfile.mkdtemp(prefix="mut_script_")
    sorg = open(B.SCRIPT, "rb").read().decode("ascii")
    vivi, nuovi = [], 0
    try:
        # baseline: ogni scenario e' verde sullo script NON mutato (una volta per tipo di kwargs)
        print("baseline (script non mutato):")
        base_ok = True
        for nome, a, b, kw, pred in MUTANTI:
            if pred is None or (solo and not nome.startswith(solo)):
                continue
            r = T.scenario("b", base, **kw)
            ok = pred(r)
            print("  %s %s" % ("OK  " if ok else "ROSSO", nome))
            base_ok = base_ok and ok
        if not base_ok:
            print("uno scenario e' rosso sullo script NON mutato: il mutante non avrebbe senso")
            return 1
        print("mutanti:")
        for nome, a, b, kw, pred in MUTANTI:
            if pred is None or (solo and not nome.startswith(solo)):
                continue
            n = sorg.count(a)
            if n != 1:
                print("  ANCORA NON TROVATA o NON UNICA (%d): %s" % (n, nome))
                vivi.append(nome)
                continue
            kw2 = dict(kw)
            kw2["muta_script"] = (lambda aa, bb: (lambda t: t.decode("ascii").replace(aa, bb).encode("ascii")))(a, b)
            r = T.scenario("m", base, **kw2)
            preso = not pred(r)
            print("  %s %s" % ("PRESO   " if preso else "SOPRAVVISSUTO", nome))
            if not preso:
                vivi.append(nome)
        print("MUTANTI: %d, sopravvissuti %d" % (len([m for m in MUTANTI if m[4] is not None]), len(vivi)))
        return 1 if vivi else 0
    finally:
        shutil.rmtree(base, ignore_errors=True)


if __name__ == "__main__":
    sys.exit(main())
