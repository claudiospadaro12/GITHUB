"""Invio del report via email (SMTP, es. Gmail)."""

from __future__ import annotations

import smtplib
import ssl
from email.message import EmailMessage

from . import config


def _plain_text_fallback(html: str) -> str:
    """Fallback testuale minimale per i client che non renderizzano HTML."""
    return (
        "Il tuo client email non mostra l'HTML.\n"
        "Apri il messaggio in un client che supporta l'HTML per leggere il report.\n"
    )


def send_email(settings: config.Settings, subject: str, html_body: str) -> None:
    """Invia il report HTML all'indirizzo configurato."""
    settings.require_email()

    msg = EmailMessage()
    msg["Subject"] = subject
    msg["From"] = settings.smtp_user
    msg["To"] = settings.email_to
    msg.set_content(_plain_text_fallback(html_body))
    msg.add_alternative(html_body, subtype="html")

    context = ssl.create_default_context()
    if settings.smtp_port == 465:
        with smtplib.SMTP_SSL(settings.smtp_host, settings.smtp_port, context=context) as server:
            server.login(settings.smtp_user, settings.smtp_password)
            server.send_message(msg)
    else:
        # STARTTLS (es. porta 587)
        with smtplib.SMTP(settings.smtp_host, settings.smtp_port) as server:
            server.starttls(context=context)
            server.login(settings.smtp_user, settings.smtp_password)
            server.send_message(msg)
