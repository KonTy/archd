import requests
from bs4 import BeautifulSoup

def get_google_finance_price(symbol):
    url = f"https://www.google.com/finance/quote/{symbol}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }

    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, 'lxml')

    try:
        # The class name for the price may change, inspect the HTML for the most up-to-date class name
        price = soup.find('div', {'class': 'YMlKec fxKbKc'}).text
        return price
    except AttributeError:
        return None

# Example usage
symbol = "MSFT:NASDAQ"
price = get_google_finance_price(symbol)
if price:
    print(f"The current price of {symbol} is {price}")
else:
    print(f"Failed to retrieve the price for {symbol}")
