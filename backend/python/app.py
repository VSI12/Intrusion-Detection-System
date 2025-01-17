from flask import Flask

app = Flask(__name__)

@app.route('/')
def home():
    return "Welcome to the Intrusion Detection System!"

if __name__ == '__main__':
    app.run(debug=True)