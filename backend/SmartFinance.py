from flask import Flask, send_file
from flask_restful import Resource, Api
import yfinance as yf
from fbprophet import Prophet
import io
import matplotlib.pyplot as plt
import json
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)
api = Api(app)

header = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36'  
}

def getPredict(stock_num, n_period):
    ticket = yf.Ticker(stock_num+'.HK')
    df = ticket.history(period="5Y")

    df['Date']=df.index
    data = df[['Close','Date']].copy()
    data = data.rename(columns={"Date":"ds","Close":"y"})

    img = io.BytesIO()
    prophet = Prophet(daily_seasonality=True)
    prophet.fit(data)
    future = prophet.make_future_dataframe(periods=n_period)
    prediction = prophet.predict(future)
    prophet.plot(prediction)

    plt.xlabel("Date")
    plt.ylabel("Close Price")
    plt.savefig(img, format='png')
    plt.close()
    img.seek(0)
    return img

def getDescription(stock_num):
    ticket = yf.Ticker(stock_num+'.HK')
    info = ticket.info
    res = {'shortName':str(info['shortName']),
        'sector':str(info['sector']),
        'industry':str(info['industry']),
        'fullTimeEmployees':str(info['fullTimeEmployees']),
        'city':str(info['city']),
        'country':str(info['country']),
        'phone':str(info['phone']),
        'fax':str(info['fax']),
        'website':str(info['website']),
        'address1':str(info['address1'])
        }
    return res

def searchStock(stock_num):
    dictionary = {}
    ticket = yf.Ticker(stock_num+'.HK')
    info = ticket.info
    dictionary["Name"] = str(info['shortName'])
    price_counter = 2
    price_url = 'https://finance.yahoo.com/quote/'+stock_num+'.HK?p='+stock_num+'.HK&.tsrc=fin-srch'
    search_req = requests.get(price_url, headers = header)
    search_soup = BeautifulSoup(search_req.text, "html.parser")
    price_tag = 'div.D\(ib\).Mend\(20px\) span.Trsdu\(0\.3s\)'
    stock_price = search_soup.select(price_tag)
    for price in stock_price:
        if price_counter == 2:
            dictionary["Price"] = price.text
            price_counter -= 1
        else:
            dictionary["ChangeInPrice"] = price.text

    info_counter = 0
    info_url = 'https://finance.yahoo.com/quote/'+stock_num+'.HK?p='+stock_num+'.HK&.tsrc=fin-srch'
    search_req = requests.get(info_url, headers = header)
    search_soup = BeautifulSoup(search_req.text, "html.parser")
    info_value_tag = 'td.Ta\(end\).Fw\(600\).Lh\(14px\)'
    stock_info_value = search_soup.select(info_value_tag)
    for value in stock_info_value:
            info_counter += 1
            if (info_counter == 1):
                dictionary["PreviousClose"] = value.text
            if (info_counter == 2):
                dictionary["OpenPrice"] = value.text
            if (info_counter == 3):
                dictionary["Bid"] = value.text
            if (info_counter == 4):
                dictionary["Ask"] = value.text
            if (info_counter == 5):
                dictionary["DaysRange"] = value.text
            if (info_counter == 6):
                dictionary["fivetwoWeekrange"] = value.text
            if (info_counter == 7):
                dictionary["Volume"] = value.text
            if (info_counter == 8):
                dictionary["AvgVolume"] = value.text
            if (info_counter == 9):
                dictionary["MarketCap"] = value.text
            if (info_counter == 10):
                dictionary["Beta"] = value.text
            if (info_counter == 11):
                dictionary["PEratio"] = value.text
            if (info_counter == 12):
                dictionary["EPS"] = value.text
            if (info_counter == 13):
                dictionary["EarningsDate"] = value.text
            if (info_counter == 14):
                dictionary["Forward"] = value.text
            if (info_counter == 15):
                dictionary["ExDiv"] = value.text
            if (info_counter == 16):
                dictionary["YearTarget"] = value.text
    return dictionary

def plotGraph(stock_num, periods, intervals):
    ticket = yf.Ticker(stock_num+'.HK')
    df = ticket.history(period=periods, interval=intervals)

    df['Date']=df.index
    data = df[['Close','Date']].copy()

    img = io.BytesIO()
    data['Close'].plot()
    plt.xlabel("Date")
    plt.ylabel("Close Price")
    plt.title(stock_num + ".HK, " + "period:" + periods + ", interval:" + intervals)
    plt.savefig(img, format='png')
    plt.close()
    img.seek(0)
    return img

class Graph(Resource):
    def get(self, stock_num, periods, intervals):
        result = plotGraph(stock_num, periods, intervals)
        return send_file(result, mimetype='image/png')

class Search(Resource):
    def get(self, stock_num):
        result = searchStock(stock_num)
        return result

class Description(Resource):
    def get(self, stock_num):
        result = getDescription(stock_num)
        return result

class Predict(Resource):
    def get(self, stock_num, n_period):
        BytesIO = getPredict(stock_num, n_period)
        return send_file(BytesIO, mimetype='image/png')

class Home(Resource):
    def get():
        return "Welcome"

api.add_resource(Home,'/')
api.add_resource(Predict,'/predict/<string:stock_num>/<int:n_period>')
api.add_resource(Description,'/description/<string:stock_num>')
api.add_resource(Search,'/search/<string:stock_num>')
api.add_resource(Graph,'/graph/<string:stock_num>/<string:periods>/<string:intervals>')

if __name__ == '__main__':
    app.run(debug=True)