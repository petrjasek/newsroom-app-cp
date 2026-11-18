import logging
import requests

from bson import ObjectId
from flask import current_app as app


logger = logging.getLogger(__name__)
session = requests.Session()


def send_notification(
    event: str, *, email: str, company: ObjectId | str | None
) -> None:
    url = app.config.get("CEM_URL", "")
    apikey = app.config.get("CEM_APIKEY", "")
    if not url or not apikey:
        logger.warning("CEM is not configured")
        return
    logger.info("Sending notification to CEM for %s", event)
    headers = {"x-api-key": apikey, "Content-Type": "application/json"}
    payload = {
        "type": event,
        "object_id": email,
        "platform": app.config.get("CEM_PLATFORM"),
    }
    if company:
        payload["company"] = str(company)
    try:
        resp = session.patch(
            url,
            json=payload,
            headers=headers,
            timeout=int(app.config.get("CEM_TIMEOUT", 10)),
            verify=bool(app.config.get("CEM_VERIFY_TLS", True)),
        )
        resp.raise_for_status()
    except requests.exceptions.RequestException as err:
        logger.error(err)
    else:
        logger.info("Notification sent to CEM for %s", event)
