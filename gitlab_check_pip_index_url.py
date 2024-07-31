import requests
import os

PIP_INDEX_URL = os.getenv("PIP_INDEX_URL")
print(PIP_INDEX_URL)
# PIP_INDEX_URL="https://__token__:${GENERATED_TOKEN}@${GITLAB_BASE_URL}"

response = requests.get(PIP_INDEX_URL)

if response.status_code == 200:
    print("PIP_INDEX_URL is working.")
else:
    print("Failed to access. Status code:", response.status_code)
