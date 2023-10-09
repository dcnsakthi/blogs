Exporting Microsoft Purview Data Assets using the REST API

Exporting Data Assets from Microsoft Purview using the REST API in Python enables a streamlined process to retrieve structured metadata and asset information. By leveraging the REST API and Python, users can effortlessly access and export Data Assets, ensuring a programmatic and efficient approach. The powerful combination of the REST API and Python empowers users with flexibility and automation capabilities, facilitating the extraction of Microsoft Purview Data Assets and seamless integration with various data management and analytics workflows.



I performed a sample search on the Microsoft Purview governance portal using "*" as the keyword to generate a list of all data assets. The accompanying screenshot from the Purview portal serves as a reference.





The generated CSV file shown below is the output obtained from Microsoft Purview using the REST API.





Here's a guide on exporting data assets from Microsoft Purview using the REST API in Python.



To access Microsoft Purview through the Python SDK, please ensure that you install the following PyPI libraries:

pip install azure-identity
pip install azure-purview-scanning
pip install azure-purview-administration
pip install azure-purview-catalog
pip install azure-purview-account
pip install azure-core
pip install pandas


Important

Your endpoint value will be different depending on which Microsoft Purview portal you are using. Endpoint for the classic Microsoft Purview governance portal: https://{your_purview_account_name}.purview.azure.com/ Endpoint for the New Microsoft Purview portal: https://api.purview-service.microsoft.com

Scan endpoint for the classic Microsoft Purview governance portal: https://{your_purview_account_name}.scan.purview.azure.com/ Endpoint for the New Microsoft Purview portal: https://api.scan.purview-service.microsoft.com 



To create a Service Principal and grant Data Reader or Data Curator access to the Service Principal at the Microsoft Purview Collection Level, please refer to the instructions provided [here].

keywords = "*"
tenant_id = "<Please update the Microsoft Purview tenant ID here>"
client_id = "<Please provide the updated Service Principal client ID that has access to the Microsoft Purview account>"
client_secret = "<Please update the Service Principal client secret for the aforementioned client ID>"
purview_endpoint = "https://<Please provide the name of the Microsoft Purview account>.purview.azure.com/"
purview_scan_endpoint = "https://<Please provide the name of the Microsoft Purview account>.scan.purview.azure.com/"


Retrieve the entire notebook file from [GitHub].

from azure.purview.catalog import PurviewCatalogClient
from azure.identity import ClientSecretCredential 
from azure.core.exceptions import HttpResponseError
import pandas as pd
from pandas.io.json import json_normalize

keywords = "*"
export_csv_path = "purview_search_export.csv"

keywords = "*"
tenant_id = "<Please update the Microsoft Purview tenant ID here>"
client_id = "<Please provide the updated Service Principal client ID that has access to the Microsoft Purview account>"
client_secret = "<Please update the Service Principal client secret for the aforementioned client ID>"
purview_endpoint = "https://<Please provide the name of the Microsoft Purview account>.purview.azure.com/"
purview_scan_endpoint = "https://<Please provide the name of the Microsoft Purview account>.scan.purview.azure.com/"

def get_credentials():
	credentials = ClientSecretCredential(client_id=client_id, client_secret=client_secret, tenant_id=tenant_id)
	return credentials

def get_catalog_client():
	credentials = get_credentials()
	client = PurviewCatalogClient(endpoint=purview_endpoint, credential=credentials, logging_enable=True)
	return client

body_input={
	"keywords": keywords
}

try:
	catalog_client = get_catalog_client()
except ValueError as e:
	print(e)

try:
	response = catalog_client.discovery.query(search_request=body_input)
	df = pd.DataFrame(response)
	jdf = pd.json_normalize(df.value)
	jdf.to_csv(export_csv_path, index=False)
except HttpResponseError as e:
	print(e)


The provided Python notebook or script is capable of exporting the following set of columns in the output CSV file.



endorsement	collectionId	updateTime	name
description	displayText	label	sensitivityLabelId
objectType	isIndexed	assetType	@search.score
updateBy	qualifiedName	createBy	owner
id	entityType	createTime	classification


Additional Reference: Exploring Purview’s REST API with Python (microsoft.com)
