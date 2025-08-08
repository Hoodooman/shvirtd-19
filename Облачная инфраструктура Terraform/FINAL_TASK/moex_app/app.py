from flask import Flask, render_template, request, jsonify
import requests
from datetime import datetime
import os
from dotenv import load_dotenv
import MySQLdb
from MySQLdb import Error

load_dotenv()  # Загрузка переменных окружения

app = Flask(__name__)

# Конфигурация MySQL
MYSQL_CONFIG = {
    'host': os.getenv('MYSQL_HOST'),
    'port': int(os.getenv('MYSQL_PORT', 3306)),
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PASSWORD'),
    'database': os.getenv('MYSQL_DATABASE'),
	'ssl_mode': 'REQUIRED',
}


def get_db_connection():
    """Establish connection to MySQL database"""
    try:
        conn = MySQLdb.connect(**MYSQL_CONFIG)
        return conn
    except:
        print(f"Error connecting to MySQL")
        raise
    

def add_quote(data):

    if not data:
        return {'error': 'No data provided'}
    
    # Validate data
    required_fields = ['ticker', 'last_price']
    if not all(field in data for field in required_fields):
        return {'error': 'Missing required fields'}
    
    conn = None
    cursor = None
    try:
        conn = get_db_connection()
        if not conn:
            return {'error': 'Could not connect to database'}
        
        cursor = conn.cursor()
        
        # Prepare data for insertion
        quote_time = data.get('now', datetime.utcnow())
        last_price = float(data['last_price']) if data['last_price'] != "N/A" else None
        price_change = float(data.get('change', 0)) if data.get('change', 0) != "N/A" else 0
        
        # Insert data
        query = """
        INSERT INTO stock_quotes (ticker, quote_time, last_price, price_change, currency)
        VALUES (%s, %s, %s, %s, %s)
        """
        values = (
            data['ticker'],
            quote_time,
            last_price,
            price_change,
            data.get('currency', 'RUB')
        )
        
        cursor.execute(query, values)
        conn.commit()
        return {'status': 'success', 'message': 'Quote added successfully'}

    except:
        print(f"Database error")
        raise
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()        

# Функция для получения данных с MOEX
def get_moex_data(ticker):
    try:
        url = f"https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities/{ticker}.json"
        response = requests.get(url)
        response.raise_for_status()
        data = response.json()
        
        market_data = data['marketdata']['data']
        
        if market_data:
            now = datetime.now()
            last_price = market_data[0][12] if market_data[0][12] is not None else "N/A"
            price_change = market_data[0][13] if market_data[0][13] is not None else "N/A"

            return {
                'ticker': ticker.upper(),
                'now': now,
                'last_price': last_price,
                'change': price_change,
                'currency': 'RUB'
            }
        return None
    except requests.exceptions.RequestException as e:
        print(f"Request error: {e}")
        return None
    except Exception as e:
        print(f"Error processing MOEX data: {e}")
        return None


@app.route('/', methods=['GET', 'POST'])
def index():
    ticker = request.form.get('ticker', 'SBER').strip() if request.method == 'POST' else 'SBER'
    data = get_moex_data(ticker)
    
    if data:
        add_quote_result = add_quote(data)
        if 'error' in add_quote_result:
            print(f"Failed to save quote: {add_quote_result['error']}")

    return render_template('index.html', data=data, ticker='SBER')
    
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)