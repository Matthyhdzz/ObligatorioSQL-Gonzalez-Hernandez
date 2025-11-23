DROP DATABASE IF EXISTS salas_ucu;
CREATE DATABASE salas_ucu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE salas_ucu;


CREATE TABLE login (
    correo VARCHAR(100) PRIMARY KEY,
    contrasena VARCHAR(255) NOT NULL
);


CREATE TABLE facultad (
    id_facultad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);


CREATE TABLE programa_academico (
    nombre_programa VARCHAR(100) PRIMARY KEY,
    id_facultad INT NOT NULL,
    tipo ENUM('grado', 'posgrado') NOT NULL,
    FOREIGN KEY (id_facultad) REFERENCES facultad(id_facultad)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE participante (
    ci INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    FOREIGN KEY (correo) REFERENCES login(correo)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE participante_programa_academico (
    id_alumno_programa INT AUTO_INCREMENT PRIMARY KEY,
    ci_participante INT NOT NULL,
    nombre_programa VARCHAR(100) NOT NULL,
    rol ENUM('alumno', 'docente') NOT NULL,
    FOREIGN KEY (ci_participante) REFERENCES participante(ci)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nombre_programa) REFERENCES programa_academico(nombre_programa)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE edificio (
    nombre_edificio VARCHAR(100) PRIMARY KEY,
    direccion VARCHAR(200) NOT NULL,
    departamento VARCHAR(50) NOT NULL
);


CREATE TABLE sala (
    nombre_sala VARCHAR(100) NOT NULL,
    edificio VARCHAR(100) NOT NULL,
    capacidad INT NOT NULL,
    tipo_sala ENUM('libre', 'posgrado', 'docente') NOT NULL,
    PRIMARY KEY (nombre_sala, edificio),
    FOREIGN KEY (edificio) REFERENCES edificio(nombre_edificio)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE turno (
    id_turno INT AUTO_INCREMENT PRIMARY KEY,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL
);


CREATE TABLE reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    nombre_sala VARCHAR(100) NOT NULL,
    edificio VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    id_turno INT NOT NULL,
    estado ENUM('activa', 'cancelada', 'sin_asistencia', 'finalizada') NOT NULL,
    FOREIGN KEY (nombre_sala, edificio) REFERENCES sala(nombre_sala, edificio)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE reserva_participante (
    ci_participante INT NOT NULL,
    id_reserva INT NOT NULL,
    fecha_solicitud_reserva DATE NOT NULL,
    asistencia BOOLEAN DEFAULT NULL,
    PRIMARY KEY (ci_participante, id_reserva),
    FOREIGN KEY (ci_participante) REFERENCES participante(ci)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE sancion_participante (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    ci_participante INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    FOREIGN KEY (ci_participante) REFERENCES participante(ci)
        ON UPDATE CASCADE ON DELETE CASCADE
);


INSERT INTO login (correo, contrasena) VALUES
('ana@ucu.edu.uy', '1234'),
('juan@ucu.edu.uy', 'abcd'),
('carla@ucu.edu.uy', 'pass'),
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
(45671234, 'Carla', 'Fernández', 'carla@ucu.edu.uy'),
(11112222, 'Carlos', 'López', 'docente@ucu.edu.uy');

INSERT INTO participante_programa_academico (ci_participante, nombre_programa, rol) VALUES
(12345678, 'Ingeniería en Informática', 'alumno'),
(87654321, 'Psicología', 'alumno'),
(45671234, 'Psicología', 'alumno'),
(11112222, 'Derecho Penal', 'docente'); 

INSERT INTO edificio (nombre_edificio, direccion, departamento) VALUES
('Edificio Central', 'Av. 8 de Octubre 2738', 'Montevideo'),
('Campus Pocitos', 'Bvar. España 1234', 'Montevideo'),
('Sede Centro', '18 de Julio 1020', 'Montevideo');

INSERT INTO turno (hora_inicio, hora_fin) VALUES
('08:00:00', '09:00:00'),
('09:00:00', '10:00:00'),
('10:00:00', '11:00:00'),
('11:00:00', '12:00:00');

INSERT INTO reserva (nombre_sala, edificio, fecha, id_turno, estado) VALUES
('Sala 101', 'Edificio Central', '2025-11-03', 1, 'activa'),
('Sala 102', 'Edificio Central', '2025-11-04', 2, 'finalizada'),
('Sala Docente 1', 'Campus Pocitos', '2025-11-05', 2, 'activa'),
('Sala 201', 'Sede Centro', '2025-11-03', 1, 'cancelada');

INSERT INTO reserva_participante (ci_participante, id_reserva, fecha_solicitud_reserva, asistencia) VALUES
(12345678, 1, '2025-10-31', TRUE),
(45671234, 1, '2025-10-31', FALSE),
(87654321, 2, '2025-10-30', FALSE),
(11112222, 2, '2025-10-30', TRUE),
(11112222, 3, '2025-10-30', TRUE),
(45671234, 3, '2025-10-30', TRUE),
(12345678, 4, '2025-10-28', FALSE);


INSERT INTO sancion_participante (ci_participante, fecha_inicio, fecha_fin) VALUES
(87654321, '2025-11-05', '2025-12-05');

