#!/usr/bin/python3

# -*- coding: utf-8 -*-

# <xbar.title>Coinbase Prices</xbar.title>
# <xbar.version>v1.0</xbar.version>
# <xbar.author>c0state</xbar.author>
# <xbar.author.github>c0state</xbar.author.github>
# <xbar.desc>Coinbase Spot Prices</xbar.desc>
# <xbar.dependencies>python</xbar.dependencies>
# <xbar.abouturl>https://github.com/matryer/xbar-plugins</xbar.abouturl>

import datetime
import urllib.request
from json import JSONDecoder

# --------------------------------------------------

FIAT_CCY = "USD"
FONT = "font=Menlo"
DROPPED_COLOR = "color=red"
INCREASED_COLOR = "color=green"

# --------------------------------------------------

hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11',
       'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
       'Accept-Charset': 'ISO-8859-1,utf-8;q=0.7,*;q=0.3',
       'Accept-Encoding': 'none',
       'Accept-Language': 'en-US,en;q=0.8',
       'Connection': 'keep-alive'}

for crypto_ccy in ('BTC', 'ETH', 'LTC', 'ADA'):
    today_price_date = datetime.datetime.utcnow().strftime('%Y-%m-%d')
    prior_price_date = (datetime.datetime.utcnow() - datetime.timedelta(days=1)).strftime('%Y-%m-%d')

    prior_price_request = urllib.request.Request(
        url=f"https://api.coinbase.com/v2/prices/{crypto_ccy}-{FIAT_CCY}/spot?date={prior_price_date}",
        headers=hdr,
    )
    prior_price_response = urllib.request.urlopen(prior_price_request).read().decode('utf-8')
    prior_price_decoded_response = JSONDecoder().decode(str(prior_price_response))

    request = urllib.request.Request(
        url=f"https://api.coinbase.com/v2/prices/{crypto_ccy}-{FIAT_CCY}/spot?date={today_price_date}",
        headers=hdr,
    )
    response = urllib.request.urlopen(request).read().decode('utf-8')
    decoded_response = JSONDecoder().decode(str(response))

    prior_price = float(prior_price_decoded_response['data']['amount'])
    today_price = float(decoded_response['data']['amount'])
    price_dropped = (today_price - prior_price) < 0
    movement_color = DROPPED_COLOR if price_dropped else INCREASED_COLOR
    print(
        f"{crypto_ccy}:${today_price:.2f}".rjust(10), FONT, movement_color, "dropdown=true", sep="|"
    )
