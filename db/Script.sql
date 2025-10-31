
CREATE DATABASE IF NOT EXISTS salas_ucu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE salas_ucu;


CREATE TABLE login (
    correo VARCHAR(50) PRIMARY KEY NOT NULL,
    contraseña VARCHAR(255) NOT NULL
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
