from io import BytesIO
from urllib.request import urlopen
from zipfile import ZipFile

filepath = "./.external_zip_url"
with open(filepath, mode="r", encoding="utf8") as file:
    zip_urls = file.readlines()

# Download each ZIP file and extract it in .external folder
for zip_url in zip_urls:
    with urlopen(zip_url) as zip_url_opened:
        with ZipFile(BytesIO(zip_url_opened.read())) as zfile:
            zfile.extractall("./.external")
