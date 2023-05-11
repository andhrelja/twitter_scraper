import importlib.resources
import json

version_path = importlib.resources.files(__package__) / 'version.json'
with open(version_path) as f:
    version_obj = json.load(f)
__version__ = version_obj['version']
print("twitter_scraper {}".format(__version__))
