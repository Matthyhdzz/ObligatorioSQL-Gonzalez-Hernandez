from flask import Flask, jsonify
from flask_cors import CORS
from db import get_connection

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return jsonify({"mensaje": "API de Salas de Estudio funcionando"})

@app.route('/sala', methods=['GET'])
def obtener_salas():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM sala;")
        salas = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(salas)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
@app.route('/participante', methods=['GET'])
def obtener_participantes():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM participante;")
        participantes = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(participantes)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/sancion_participante', methods=['GET'])
def obtener_sanciones():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM sancion_participante;")
        sancion_participante = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(sancion_participante)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
