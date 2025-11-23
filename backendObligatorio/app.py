from flask import Flask, jsonify, request
from flask_cors import CORS
from db import get_connection

app = Flask(__name__)
CORS(app)


@app.route('/')
def home():
    return jsonify({"mensaje": "API de Salas de Estudio funcionando"})



@app.route('/participantes', methods=['GET'])
def obtener_participantes():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM participante;")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/participantes', methods=['POST'])
def crear_participante():
    try:
        data = request.json

        ci = data.get('ci')
        nombre = data.get('nombre')
        apellido = data.get('apellido')
        correo = data.get('correo')
        contrasena = data.get('contrasena')

        
        if not all([ci, nombre, apellido, correo, contrasena]):
            return jsonify({"error": "Faltan campos obligatorios"}), 400

        conn = get_connection()
        cursor = conn.cursor()

       
        cursor.execute("""
            INSERT INTO login (correo, contrasena)
            VALUES (%s, %s)
        """, (correo, contrasena))

      
        cursor.execute("""
            INSERT INTO participante (ci, nombre, apellido, correo)
            VALUES (%s, %s, %s, %s)
        """, (ci, nombre, apellido, correo))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"mensaje": "Participante creado correctamente"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/participantes/<int:ci>', methods=['PUT'])
def actualizar_participante(ci):
    try:
        data = request.json

        nombre = data.get('nombre')
        apellido = data.get('apellido')
        correo = data.get('correo')
        contrasena = data.get('contrasena')

        if not all([nombre, apellido, correo]):
            return jsonify({"error": "Faltan campos obligatorios"}), 400

        conn = get_connection()
        cursor = conn.cursor()

        
        cursor.execute("""
            UPDATE participante 
            SET nombre = %s, apellido = %s, correo = %s
            WHERE ci = %s
        """, (nombre, apellido, correo, ci))

        
        if contrasena:
            cursor.execute("""
                UPDATE login
                SET contrasena = %s
                WHERE correo = %s
            """, (contrasena, correo))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"mensaje": "Participante actualizado correctamente"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/participantes/<int:ci>', methods=['DELETE'])
def eliminar_participante(ci):
    try:
        conn = get_connection()
        cursor = conn.cursor()

       
        cursor.execute("SELECT correo FROM participante WHERE ci = %s", (ci,))
        resultado = cursor.fetchone()

        if not resultado:
            return jsonify({"error": "Participante no encontrado"}), 404

        correo = resultado[0]

        cursor.execute("DELETE FROM participante WHERE ci = %s", (ci,))

        
        cursor.execute("DELETE FROM login WHERE correo = %s", (correo,))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"mensaje": "Participante eliminado correctamente"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500




@app.route('/salas', methods=['GET'])
def obtener_salas():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM sala;")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/salas', methods=['POST'])
def crear_sala():
    return jsonify({"estado": "falta implementar"})



@app.route('/sanciones', methods=['GET'])
def obtener_sanciones():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM sancion_participante;")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/sanciones', methods=['POST'])
def crear_sancion_manual():
    return jsonify({"estado": "falta implementar"})


@app.route('/reservas', methods=['GET'])
def obtener_reservas():
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute("SELECT * FROM reserva;")
        data = cursor.fetchall()
        cursor.close()
        conn.close()
        return jsonify(data)
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/reservas', methods=['POST'])
def crear_reserva():
    try:
        data = request.json

        nombre_sala = data.get("nombre_sala")
        edificio = data.get("edificio")
        fecha = data.get("fecha")
        id_turno = data.get("id_turno")
        participantes = data.get("participantes")

        if not all([nombre_sala, edificio, fecha, id_turno, participantes]):
            return jsonify({"error": "Faltan datos obligatorios"}), 400

        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

    
        # VALIDACIÓN 1: Sala existe y obtener capacidad y el tipo
        cursor.execute("""
            SELECT * FROM sala
            WHERE nombre_sala = %s AND edificio = %s
        """, (nombre_sala, edificio))
        sala = cursor.fetchone()

        if not sala:
            return jsonify({"error": "La sala no existe"}), 404

        capacidad = sala["capacidad"]
        tipo_sala = sala["tipo_sala"]  # libre / posgrado / docente

        if len(participantes) > capacidad:
            return jsonify({"error": "Se supera la capacidad de la sala"}), 400

    
        # VALIDACIÓN 2: Turno existe
        cursor.execute("""
            SELECT * FROM turno WHERE id_turno = %s
        """, (id_turno,))
        turno = cursor.fetchone()

        if not turno:
            return jsonify({"error": "El turno no existe"}), 404

        # VALIDACIÓN 3: Todos los participantes existen
        for ci in participantes:
            cursor.execute("""
                SELECT * FROM participante WHERE ci = %s
            """, (ci,))
            if not cursor.fetchone():
                return jsonify({"error": f"El participante {ci} no existe"}), 404

        # VALIDACIÓN 4: Sanciones activas
        for ci in participantes:
            cursor.execute("""
                SELECT * FROM sancion_participante
                WHERE ci_participante = %s
                AND CURDATE() BETWEEN fecha_inicio AND fecha_fin
            """, (ci,))
            if cursor.fetchone():
                return jsonify({"error": f"El participante {ci} está sancionado"}), 403

       
        # VALIDACIÓN 5: Tipo de sala (posgrado / docente)
        for ci in participantes:
            cursor.execute("""
                SELECT rol FROM participante_programa_academico
                WHERE ci_participante = %s
            """, (ci,))
            rol = cursor.fetchone()["rol"]

            if tipo_sala == "posgrado" and rol != "docente":
                return jsonify({"error": f"La sala es de posgrado. {ci} no puede reservar"}), 403

            if tipo_sala == "docente" and rol != "docente":
                return jsonify({"error": f"La sala es de docentes. {ci} no puede reservar"}), 403

        # VALIDACIÓN 6: Máximo 3 reservas activas por semana
        for ci in participantes:
            cursor.execute("""
                SELECT COUNT(*) AS total FROM reserva r
                JOIN reserva_participante rp ON rp.id_reserva = r.id_reserva
                WHERE rp.ci_participante = %s
                AND r.estado = 'activa'
                AND WEEK(r.fecha) = WEEK(%s)
            """, (ci, fecha))
            if cursor.fetchone()["total"] >= 3:
                return jsonify({"error": f"El participante {ci} ya tiene 3 reservas activas esta semana"}), 403

        # VALIDACIÓN 7: Máximo 2 horas por día
        for ci in participantes:
            cursor.execute("""
                SELECT COUNT(*) AS total FROM reserva r
                JOIN reserva_participante rp ON rp.id_reserva = r.id_reserva
                WHERE rp.ci_participante = %s
                AND r.fecha = %s
            """, (ci, fecha))
            if cursor.fetchone()["total"] >= 2:
                return jsonify({"error": f"El participante {ci} ya tiene 2h reservadas ese día"}), 403

        # CREAR RESERVA
        cursor.execute("""
            INSERT INTO reserva (nombre_sala, edificio, fecha, id_turno, estado)
            VALUES (%s, %s, %s, %s, 'activa')
        """, (nombre_sala, edificio, fecha, id_turno))
        id_reserva = cursor.lastrowid


        # INSERTAR PARTICIPANTES
        for ci in participantes:
            cursor.execute("""
                INSERT INTO reserva_participante (ci_participante, id_reserva, fecha_solicitud_reserva, asistencia)
                VALUES (%s, %s, CURDATE(), 'false')
            """, (ci, id_reserva))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"mensaje": "Reserva creada correctamente", "id_reserva": id_reserva}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/reservas/<int:id_reserva>/asistencia', methods=['PUT'])
def registrar_asistencia(id_reserva):
    try:
        data = request.json
        ci = data.get("ci")
        asistencia = data.get("asistencia")

        if ci is None or asistencia is None:
            return jsonify({"error": "Faltan datos"}), 400

        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute("""
            UPDATE reserva_participante
            SET asistencia = %s
            WHERE id_reserva = %s AND ci_participante = %s
        """, (asistencia, id_reserva, ci))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"mensaje": "Asistencia registrada"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route('/reservas/<int:id_reserva>/cancelar', methods=['PUT'])
def cancelar_reserva(id_reserva):
    try:
        conn = get_connection()
        cursor = conn.cursor()

        cursor.execute("SELECT * FROM reserva WHERE id_reserva = %s", (id_reserva,))
        reserva = cursor.fetchone()
        if not reserva:
            return jsonify({"error": "Reserva no encontrada"}), 404

        cursor.execute("""
            UPDATE reserva
            SET estado = 'cancelada'
            WHERE id_reserva = %s
        """, (id_reserva,))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"mensaje": "Reserva cancelada correctamente"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500



@app.route('/reservas/<int:id_reserva>/finalizar', methods=['PUT'])
def finalizar_reserva(id_reserva):
    try:
        conn = get_connection()
        cursor = conn.cursor(dictionary=True)

        # Marcamos reserva como finalizada
        cursor.execute("""
            UPDATE reserva
            SET estado = 'finalizada'
            WHERE id_reserva = %s
        """, (id_reserva,))

        # Obtenemos las asistencias
        cursor.execute("""
            SELECT ci_participante, asistencia 
            FROM reserva_participante
            WHERE id_reserva = %s
        """, (id_reserva,))
        asistentes = cursor.fetchall()

        # Si nadie asistió se aplica una sanción automática
        nadie_asistio = all(a["asistencia"] == 'false' for a in asistentes)

        if nadie_asistio:
            for a in asistentes:
                cursor.execute("""
                    INSERT INTO sancion_participante (ci_participante, fecha_inicio, fecha_fin)
                    VALUES (%s, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 30 DAY))
                """, (a["ci_participante"],))

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"mensaje": "Reserva finalizada correctamente"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(debug=True, port=5000)
