-- SALA MÁS RESERVADA

SELECT r.nombre_sala, SUM(r.nombre_sala IS NOT NULL) AS total_reservas
FROM reserva r
JOIN sala s ON r.nombre_sala = s.nombre_sala 
GROUP BY r.nombre_sala
ORDER BY total_reservas DESC
LIMIT 1;

--TURNOS MÁS DEMANDADOS

SELECT t.id_turno, COUNT(r.id_turno) AS total_reservas
FROM turno t
JOIN reserva r ON t.id_turno = r.id_turno
GROUP BY t.id_turno
ORDER BY total_reservas DESC

--PROMEDIO DE PARTICIPANTES POR SALA

SELECT r.nombre_sala, AVG(cantidad_participantes) AS promedio_participantes
From (
    SELECT COUNT(r.id_reserva) AS cantidad_participantes
    FROM reserva r
    JOIN participante_reserva pr ON r.id_reserva = pr.id_reserva
    GROUP BY r.id_reserva
) as subconsulta
GROUP BY r.nombre_sala;

--CANTIDAD DE RESERVAS POR FACULTAD Y PROGRAMA ACADÉMICO

SELECT fa.nombre as Facultad, pa.nombre_programa as Carrera, COUNT(r.id_reserva) as Cantidad_Reservas
FROM reserva r 
JOIN participante_reserva pr ON pr.id_reserva = r.id_reserva
JOIN participante_programa_academico ppa ON ppa.ci_participante = pr.ci_participante
JOIN programa_academico pa ON pa.nombre_programa = ppa.nombre_programa
JOIN facultad fa ON fa.id_facultad = pa.id_facultad
GROUP BY fa.nombre, pa.nombre_programa
ORDER BY Cantidad_Reservas DESC

