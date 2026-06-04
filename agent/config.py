"""Configurazione centrale dell'agente di analisi di mercato.

Tutti i segreti (chiavi API, credenziali email) si leggono da variabili
d'ambiente — in locale tramite un file `.env`, in CI tramite i GitHub Secrets.
Nessun segreto deve mai finire nel codice o nel repository.
"""

from __future__ import annotations

import os
from dataclasses import dataclass, field

# Fuso orario di riferimento per l'orario di invio del report.
TIMEZONE = "Europe/Rome"
SEND_HOUR = 7  # 07:00 ora italiana

# Modello Claude usato per la sintesi del report.
MODEL = "claude-opus-4-8"

# --- Strumenti monitorati (ticker Yahoo Finance) --------------------------
# L'ordine qui determina l'ordine nelle tabelle del report.
INDICES: dict[str, str] = {
    "DAX (Germania)": "^GDAXI",
    "S&P 500 (USA)": "^GSPC",
    "Nasdaq 100 (USA)": "^NDX",
    "Nikkei 225 (Giappone)": "^N225",
    "FTSE MIB (Italia)": "FTSEMIB.MI",
}

COMMODITIES: dict[str, str] = {
    "Oro (XAU/USD)": "GC=F",
}

FOREX: dict[str, str] = {
    "EUR/USD": "EURUSD=X",
    "GBP/USD": "GBPUSD=X",
    "USD/JPY": "USDJPY=X",
    "USD/CHF": "USDCHF=X",
    "AUD/USD": "AUDUSD=X",
    "USD/CAD": "USDCAD=X",
    "EUR/JPY": "EURJPY=X",
    "Indice Dollaro (DXY)": "DX-Y.NYB",
}


@dataclass
class Settings:
    """Impostazioni risolte dall'ambiente al momento dell'esecuzione."""

    anthropic_api_key: str = field(
        default_factory=lambda: os.getenv("ANTHROPIC_API_KEY", "")
    )

    # Email (SMTP)
    smtp_host: str = field(default_factory=lambda: os.getenv("SMTP_HOST", "smtp.gmail.com"))
    smtp_port: int = field(default_factory=lambda: int(os.getenv("SMTP_PORT", "465")))
    smtp_user: str = field(default_factory=lambda: os.getenv("SMTP_USER", ""))
    smtp_password: str = field(default_factory=lambda: os.getenv("SMTP_PASSWORD", ""))
    email_to: str = field(
        default_factory=lambda: os.getenv("EMAIL_TO", os.getenv("SMTP_USER", ""))
    )

    # Comportamento
    force_run: bool = field(default_factory=lambda: os.getenv("FORCE_RUN") == "1")
    dry_run: bool = field(default_factory=lambda: os.getenv("DRY_RUN") == "1")

    def require_anthropic(self) -> None:
        if not self.anthropic_api_key:
            raise RuntimeError(
                "ANTHROPIC_API_KEY non impostata. Configurala come variabile "
                "d'ambiente o GitHub Secret."
            )

    def require_email(self) -> None:
        missing = [
            name
            for name, value in {
                "SMTP_USER": self.smtp_user,
                "SMTP_PASSWORD": self.smtp_password,
                "EMAIL_TO": self.email_to,
            }.items()
            if not value
        ]
        if missing:
            raise RuntimeError(
                "Credenziali email mancanti: " + ", ".join(missing) + ". "
                "Vedi il README per la configurazione."
            )
