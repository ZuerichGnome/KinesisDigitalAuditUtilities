"""

Copyright 2022 Kinesis AG.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

- - - - - - - - - - - - - - - -

Notes:

* This file demostrates the basic usage of the Kinesis Public API.
* You will require a privateKey and publicKey from https://kms.kinesis.money/settings/api-keys
* Please note these are production endpoints and you are trading on your real account.

"""

import requests
import time
import pandas as pd
from   datetime import timezone
import datetime
import hmac
import hashlib
import html
import json
import sys

from random import randint
from time import sleep



"""
Global variables
"""

base_url   = 'https://client-api.kinesis.money'













def getNonce ():

    dt            = datetime.datetime.now(timezone.utc)
    utc_time      = dt.replace(tzinfo=timezone.utc)
    utc_timestamp = round(utc_time.timestamp() * 1000)

    return str(utc_timestamp)

def getAuthHeader(method, url, content=''):

    nonce    = getNonce()
    message  = str(nonce) + str(method) + str(url) + str(content)
    message  = message.encode(encoding='UTF-8',errors='strict')

    byte_key = bytes(privateKey, 'UTF-8')
    xsig     = hmac.new(byte_key, message, hashlib.sha256).hexdigest().upper()

    headers = {
            "x-nonce": nonce,
            "x-api-key": publicKey,
            "x-signature": xsig
            }

    if method != 'DELETE':
        headers["Content-Type"] = "application/json"

    return headers



def getOHLC(pair, fromDate='2015-01-01T00:00:00.000Z', toDate='2022-03-31T00:00:00.000Z', timeFrame='60'):

    url         = '/v1/exchange/ohlc/' + pair
    headersAuth = getAuthHeader('GET', url)
    payload     = {'timeFrame': timeFrame,
            'fromDate': fromDate,
            'toDate': toDate
        }

    try:
        response = requests.get(base_url + url, headers=headersAuth, params=payload)

    except:
        return response

    return response


def set_pandas_display_options() -> None:
    """Set pandas display options."""
    # https://stackoverflow.com/questions/19124601/pretty-print-an-entire-pandas-series-dataframe
    # Ref: https://stackoverflow.com/a/52432757/
    display = pd.options.display

    display.max_columns = 20
    display.max_rows = 600
    display.max_colwidth = 199
    display.width = 1000
#	display.float_format = lambda x: '{10.2f}'.format(x)  # set as needed
    # display.precision = 2  # set as needed
    # display.float_format = lambda x: '{:,.2f}'.format(x)  # set as needed



"""
Main app
"""


def main():

    print ('Get-volume-inside-OHLC-from-a-given-hardcoded-date.py')
    
    try:
# last runs produced:
#        inputDate = '01-01-2022'
#        2022-04-05T00:00:00.000Z

 		set_pandas_display_options()

        inputDate = '01-01-2022'

        date_format = '%d-%m-%Y'

        for i in range(578):
            date = datetime.datetime.strptime(inputDate, date_format) + datetime.timedelta(days = i )
            ohlc = getOHLC('KAG_USD',date,date,1440).json()
            df   = pd.DataFrame(ohlc)
            print(df)
#            sleep(randint(1,2))

    except:
        print('Unable to get OHLC')

    exit()

if __name__ == "__main__":
    main()



