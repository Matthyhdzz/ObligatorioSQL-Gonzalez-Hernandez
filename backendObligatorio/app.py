from flask import Flask, jsonify
from flask_cors import CORS
from db import get_connection

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return jsonify({"mensaje": "API de Salas de Estudio funcionando"})

@app.route('/salas', methods=['GET'])
def obtener_salas():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM salas;")
        salas = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(salas)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
