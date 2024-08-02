"""Quickly test Odoo API."""
import xmlrpc.client
import os
from urllib.parse import quote_plus
from logging import getLogger

logger = getLogger(__name__)

# Get env variables
HOST = os.getenv("ODOO_HOST")
DATABASE = os.getenv("ODOO_DATABASE")
USERNAME = os.getenv("ODOO_USERNAME")
PASSWORD = quote_plus(str(
    os.getenv("ODOO_API_KEY")
    ))


# Auth
def authenticate_user(host, database, username, password):
    common = xmlrpc.client.ServerProxy('{}/xmlrpc/2/common'.format(host))
    uid = common.authenticate(database, username, password, {})
    return uid


# Logging and result
logger.info(f"Username: {USERNAME}")
logger.info(f"Last 5 characters of API key is: {PASSWORD[-5:]}")
uid = authenticate_user(HOST, DATABASE, USERNAME, PASSWORD)
if uid:
    logger.info("Authentication successful ✅")
else:
    logger.error("Authentication failed.")  # Can improve to log error code
