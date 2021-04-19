#!/usr/bin/python3
# -*- coding: utf-8 -*-
#
# <xbar.title>Coinbase Prices</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>c0state</xbar.author>
# <xbar.author.github>c0state</xbar.author.github>
# <xbar.desc>Coinbase Spot Prices</xbar.desc>
# <xbar.dependencies>python</xbar.dependencies>
# <xbar.abouturl>https://github.com/matryer/xbar-plugins</xbar.abouturl>

import urllib.request
from json import JSONDecoder

# --------------------------------------------------

FONT = "| font=Menlo"

# --------------------------------------------------

hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
       'Accept-Encoding': 'none',
       'Accept-Language': 'en-US,en;q=0.8',
       'Connection': 'keep-alive'}

for ccy in ('BTC', 'ETH', 'LTC'):
    request = urllib.request.Request(
        url=f"https://api.coinbase.com/v2/prices/{ccy}-USD/spot",
        headers=hdr,
    )
    response = urllib.request.urlopen(request).read().decode('utf-8')
    decoded_response = JSONDecoder().decode(str(response))

    print(
        ccy, ":", f"${float(decoded_response['data']['amount']):.2f}".rjust(10), FONT, sep=""
    )
