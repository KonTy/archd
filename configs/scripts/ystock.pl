import yfinance as yf
import pandas as pd

# Define your portfolio with stock symbols, quantities, and buy dates
portfolio = pd.DataFrame({
    'symbol': ['AAPL', 'MSFT', 'GOOGL'],  # Stock symbols
    'quantity': [10, 5, 8],  # Quantity owned for each stock
    'buy_date': ['2022-01-01', '2021-06-01', '2023-01-01']  # Buy dates
})

def get_price_on_date(ticker, date):
    try:
        # Retrieve historical data including splits
        stock_data = ticker.history(start='1900-01-01', end=pd.Timestamp.now().strftime('%Y-%m-%d'))
        if stock_data.empty:
            raise ValueError(f"No data available for the specified range")

        # Convert index to datetime and reset index for comparison
        stock_data.index = pd.to_datetime(stock_data.index).tz_localize(None)
        stock_data = stock_data.reset_index()

        # Convert buy_date to datetime and make timezone-naive
        buy_date = pd.to_datetime(date).tz_localize(None)

        # Find the closest available date to the buy date
        closest_date = stock_data[stock_data['Date'] <= buy_date]['Date'].max()

        if pd.isna(closest_date):
            raise ValueError(f"No data available before {date}")

        # Get the closing price for the closest date
        close_price = stock_data[stock_data['Date'] == closest_date]['Close'].iloc[0]

        # Adjust for stock splits
        split_factor = stock_data[stock_data['Date'] <= closest_date]['Splits'].prod()
        adjusted_price = close_price * split_factor

        return adjusted_price
    except Exception as e:
        print(f"An error occurred while fetching price for {ticker.ticker} on {date}: {e}")
        return None

def get_current_price(ticker):
    try:
        # Retrieve the most recent price
        stock_data = ticker.history(period='1d')
        if stock_data.empty:
            raise ValueError("No data available for the specified period")
        return stock_data['Close'].iloc[-1]
    except Exception as e:
        print(f"An error occurred while fetching current price for {ticker.ticker}: {e}")
        return None

def get_portfolio_value(portfolio):
    portfolio['buy_price'] = None
    portfolio['current_price'] = None
    portfolio['value'] = None
    portfolio['percentage_change'] = None

    for idx, row in portfolio.iterrows():
        try:
            ticker = yf.Ticker(row['symbol'])
            buy_price = get_price_on_date(ticker, row['buy_date'])
            current_price = get_current_price(ticker)
            print(f"{row['symbol']} buy_price: {buy_price}, current_price: {current_price}")  # Debugging statement
            if buy_price is not None and current_price is not None:
                percentage_change = ((current_price - buy_price) / buy_price) * 100
                portfolio.at[idx, 'buy_price'] = buy_price
                portfolio.at[idx, 'current_price'] = current_price
                portfolio.at[idx, 'value'] = current_price * row['quantity']
                portfolio.at[idx, 'percentage_change'] = percentage_change
            else:
                portfolio.at[idx, 'buy_price'] = 'N/A'
                portfolio.at[idx, 'current_price'] = 'N/A'
                portfolio.at[idx, 'value'] = 'N/A'
                portfolio.at[idx, 'percentage_change'] = 'N/A'
        except Exception as e:
            print(f"An error occurred for {row['symbol']}: {e}")
            portfolio.at[idx, 'buy_price'] = 'Error'
            portfolio.at[idx, 'current_price'] = 'Error'
            portfolio.at[idx, 'value'] = 'Error'
            portfolio.at[idx, 'percentage_change'] = 'Error'

    # Calculate total portfolio value, ignoring 'N/A' or 'Error'
    valid_values = pd.to_numeric(portfolio['value'], errors='coerce')
    portfolio['total_value'] = valid_values.sum()

    return portfolio

# Print the portfolio value
def print_portfolio_summary(portfolio):
    print("Portfolio Summary:")
    print(portfolio)
    total_value = portfolio['total_value'].sum()
    print(f"\nTotal Portfolio Value: ${total_value:.2f}" if pd.notna(total_value) else "Total Portfolio Value: Data unavailable")

if __name__ == "__main__":
    portfolio = get_portfolio_value(portfolio)
    print_portfolio_summary(portfolio)
