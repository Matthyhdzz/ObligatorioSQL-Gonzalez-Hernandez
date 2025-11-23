from flask import jsonify
from app import app
from db import get_connection


# 1) Salas más reservadas
@app.route("/reportes/salas-mas-reservadas")
def salas_mas_reservadas():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT r.nombre_sala, r.edificio, COUNT(*) AS total_reservas
        FROM reserva r
        GROUP BY r.nombre_sala, r.edificio
        ORDER BY total_reservas DESC;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 2) Turnos más demandados
@app.route("/reportes/turnos-mas-demandados")
def turnos_mas_demandados():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            t.id_turno,
            t.hora_inicio,
            t.hora_fin,
            COUNT(r.id_reserva) AS total_reservas
        FROM turno t
        LEFT JOIN reserva r ON r.id_turno = t.id_turno
        GROUP BY t.id_turno, t.hora_inicio, t.hora_fin
        ORDER BY total_reservas DESC;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 3) Promedio de participantes por sala
@app.route("/reportes/promedio-participantes")
def promedio_participantes():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            sub.nombre_sala,
            sub.edificio,
            AVG(sub.cant_participantes) AS promedio_participantes
        FROM (
            SELECT 
                r.id_reserva,
                r.nombre_sala,
                r.edificio,
                COUNT(rp.ci_participante) AS cant_participantes
            FROM reserva r
            JOIN reserva_participante rp 
                ON rp.id_reserva = r.id_reserva
            GROUP BY r.id_reserva, r.nombre_sala, r.edificio
        ) AS sub
        GROUP BY sub.nombre_sala, sub.edificio
        ORDER BY promedio_participantes DESC;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 4) Reservas por carrera y facultad
@app.route("/reportes/reservas-carrera-facultad")
def reservas_carrera_facultad():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            fa.nombre AS facultad,
            pa.nombre_programa AS carrera,
            COUNT(DISTINCT r.id_reserva) AS cantidad_reservas
        FROM reserva r
        JOIN reserva_participante rp 
            ON rp.id_reserva = r.id_reserva
        JOIN participante_programa_academico ppa 
            ON ppa.ci_participante = rp.ci_participante
        JOIN programa_academico pa 
            ON pa.nombre_programa = ppa.nombre_programa
        JOIN facultad fa 
            ON fa.id_facultad = pa.id_facultad
        GROUP BY fa.nombre, pa.nombre_programa
        ORDER BY cantidad_reservas DESC;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 5) Ocupación de salas por edificio
@app.route("/reportes/ocupacion-edificios")
def ocupacion_edificios():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            e.nombre_edificio AS edificio,
            COUNT(r.id_reserva) AS reservas_realizadas,
            (COUNT(r.id_reserva) / (SELECT COUNT(*) FROM turno)) * 100 AS porcentaje_ocupacion
        FROM edificio e
        LEFT JOIN sala s ON s.edificio = e.nombre_edificio
        LEFT JOIN reserva r 
            ON r.nombre_sala = s.nombre_sala AND r.edificio = s.edificio
        GROUP BY e.nombre_edificio
        ORDER BY porcentaje_ocupacion DESC;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 6) Reservas y asistencias por rol
@app.route("/reportes/reservas-asistencias-rol")
def reservas_asistencias_rol():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            ppa.rol,
            COUNT(r.id_reserva) AS total_reservas,
            SUM(CASE WHEN rp.asistencia = TRUE THEN 1 ELSE 0 END) AS asistencias
        FROM participante_programa_academico ppa
        JOIN reserva_participante rp ON rp.ci_participante = ppa.ci_participante
        JOIN reserva r ON r.id_reserva = rp.id_reserva
        GROUP BY ppa.rol;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 7) Sanciones por rol
@app.route("/reportes/sanciones-rol")
def sanciones_rol():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT 
            ppa.rol,
            COUNT(s.id_sancion) AS total_sanciones
        FROM sancion_participante s
        JOIN participante_programa_academico ppa 
            ON ppa.ci_participante = s.ci_participante
        GROUP BY ppa.rol;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 8) Uso de reservas
@app.route("/reportes/uso-reservas")
def uso_reservas():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            (SUM(CASE WHEN r.estado = 'finalizada' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS porcentaje_usadas,
            (SUM(CASE WHEN r.estado IN ('cancelada','sin_asistencia') THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS porcentaje_no_usadas
        FROM reserva r;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 9-A Participantes con más reservas activas
@app.route("/reportes/top-participantes-activos")
def top_participantes_activos():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            p.ci,
            p.nombre,
            p.apellido,
            COUNT(r.id_reserva) AS reservas_activas
        FROM participante p
        JOIN reserva_participante rp ON rp.ci_participante = p.ci
        JOIN reserva r ON r.id_reserva = rp.id_reserva
        WHERE r.estado = 'activa'
        GROUP BY p.ci
        ORDER BY reservas_activas DESC;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 9-B Salas con más faltas
@app.route("/reportes/salas-mas-faltas")
def salas_mas_faltas():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            r.nombre_sala,
            r.edificio,
            COUNT(*) AS faltas
        FROM reserva r
        WHERE r.estado = 'sin_asistencia'
        GROUP BY r.nombre_sala, r.edificio
        ORDER BY faltas DESC;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)


# 9-C Programas con más sanciones
@app.route("/reportes/programas-mas-sanciones")
def programas_mas_sanciones():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT
            pa.nombre_programa,
            COUNT(s.id_sancion) AS sanciones
        FROM participante_programa_academico ppa
        JOIN programa_academico pa ON pa.nombre_programa = ppa.nombre_programa
        JOIN sancion_participante s ON s.ci_participante = ppa.ci_participante
        GROUP BY pa.nombre_programa
        ORDER BY sanciones DESC;
    """)

    data = cursor.fetchall()
    cursor.close()
    conn.close()

    return jsonify(data)
