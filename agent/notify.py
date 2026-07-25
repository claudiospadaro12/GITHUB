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


def send_email(settings: config.Settings, subject: str, html_body: str,
               attachments: list[str] | None = None) -> None:
    """Invia il report HTML all'indirizzo configurato.
    `attachments`: lista di percorsi file (es. il PDF) da allegare."""
    settings.require_email()

    msg = EmailMessage()
    msg["Subject"] = subject
    msg["From"] = settings.smtp_user
    msg["To"] = settings.email_to
    msg.set_content(_plain_text_fallback(html_body))
    msg.add_alternative(html_body, subtype="html")

    import os
    for path in (attachments or []):
        if not path or not os.path.exists(path):
            continue
        with open(path, "rb") as fh:
            data = fh.read()
        name = os.path.basename(path)
        if name.lower().endswith(".pdf"):
            msg.add_attachment(data, maintype="application", subtype="pdf", filename=name)
        else:
            msg.add_attachment(data, maintype="application", subtype="octet-stream", filename=name)

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
