
DROP DATABASE IF EXISTS salas_ucu;
CREATE DATABASE salas_ucu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE salas_ucu;


CREATE TABLE login (
    correo VARCHAR(50) PRIMARY KEY NOT NULL,
    contrasena VARCHAR(255) NOT NULL
);

CREATE TABLE facultad (
    id_facultad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE programa_academico (
    nombre_programa VARCHAR(50) PRIMARY KEY,
    id_facultad INT,
    tipo ENUM('grado', 'posgrado'),
    FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
);

CREATE TABLE participante (
    ci INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    correo VARCHAR(50),
    FOREIGN KEY (correo) REFERENCES login(correo)
);

CREATE TABLE participante_programa_academico (
    id_alumno_programa INT AUTO_INCREMENT PRIMARY KEY,
    ci_participante INT,
    nombre_programa VARCHAR(50),
    rol ENUM('alumno', 'docente'),
    FOREIGN KEY (ci_participante) REFERENCES participante(ci),
    FOREIGN KEY (nombre_programa) REFERENCES programa_academico(nombre_programa)
);

CREATE TABLE edificio (
    nombre_edificio VARCHAR(50) PRIMARY KEY,
    direccion VARCHAR(100),
    departamento VARCHAR(50)
);

CREATE TABLE sala (
    nombre_sala VARCHAR(50),
    edificio VARCHAR(50),
    capacidad INT,
    tipo_sala ENUM('libre', 'posgrado', 'docente'),
    PRIMARY KEY (nombre_sala, edificio),
    FOREIGN KEY (edificio) REFERENCES edificio(nombre_edificio)
);

CREATE TABLE turno (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    hora_inicio DATETIME,
    hora_fin DATETIME
);

CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sala VARCHAR(50),
    edificio VARCHAR(50),
    fecha DATE,
    id_turno INT,
    estado ENUM('activa', 'cancelada', 'sin asistencia', 'finalizada'),
    FOREIGN KEY (nombre_sala, edificio) REFERENCES sala(nombre_sala, edificio),
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno)
);

CREATE TABLE reserva_participante (
    ci_participante INT,
    id_reserva INT,
    fecha_solicitud_reserva DATE,
    asistencia ENUM('true', 'false'),
    PRIMARY KEY (ci_participante, id_reserva),
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva),
    FOREIGN KEY (ci_participante) REFERENCES participante(ci)
);

CREATE TABLE sancion_participante (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    ci_participante INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (ci_participante) REFERENCES participante(ci)
);

INSERT INTO login (correo, contrasena) VALUES
('ana@ucu.edu.uy', '1234'),
('juan@ucu.edu.uy', 'abcd'),
('docente@ucu.edu.uy', 'admin');

INSERT INTO facultad (nombre) VALUES
('Ingeniería'),
('Ciencias Humanas'),
('Derecho');

INSERT INTO programa_academico (nombre_programa, id_facultad, tipo) VALUES
('Ingeniería en Informática', 1, 'grado'),
('Psicología', 2, 'grado'),
('Derecho Penal', 3, 'posgrado');

INSERT INTO participante (ci, nombre, apellido, correo) VALUES
(12345678, 'Ana', 'Pérez', 'ana@ucu.edu.uy'),
(87654321, 'Juan', 'Rodríguez', 'juan@ucu.edu.uy'),
(11112222, 'Carlos', 'López', 'docente@ucu.edu.uy');

INSERT INTO participante_programa_academico (ci_participante, nombre_programa, rol) VALUES
(12345678, 'Ingeniería en Informática', 'alumno'),
(87654321, 'Psicología', 'alumno'),
(11112222, 'Ingeniería en Informática', 'docente');

INSERT INTO edificio (nombre_edificio, direccion, departamento) VALUES
('Edificio Central', 'Av. 8 de Octubre 2738', 'Montevideo'),
('Campus Pocitos', 'Bvar. Espana 1234', 'Montevideo');

INSERT INTO sala (nombre_sala, edificio, capacidad, tipo_sala) VALUES
('Sala 101', 'Edificio Central', 30, 'libre'),
('Sala 102', 'Edificio Central', 20, 'posgrado'),
('Sala Docente 1', 'Campus Pocitos', 10, 'docente');

INSERT INTO turno (hora_inicio, hora_fin) VALUES
('2025-11-01 08:00:00', '2025-11-01 10:00:00'),
('2025-11-01 10:00:00', '2025-11-01 12:00:00');

INSERT INTO reserva (nombre_sala, edificio, fecha, id_turno, estado) VALUES
('Sala 101', 'Edificio Central', '2025-11-03', 1, 'activa'),
('Sala 102', 'Edificio Central', '2025-11-04', 2, 'finalizada');

INSERT INTO reserva_participante (ci_participante, id_reserva, fecha_solicitud_reserva, asistencia) VALUES
(12345678, 1, '2025-10-31', 'true'),
(11112222, 1, '2025-10-31', 'true'),
(87654321, 2, '2025-10-30', 'false');

INSERT INTO sancion_participante (ci_participante, fecha_inicio, fecha_fin) VALUES
(87654321, '2025-11-05', '2025-11-20');