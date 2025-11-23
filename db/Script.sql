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
);

CREATE TABLE participante (
    ci INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    FOREIGN KEY (correo) REFERENCES login(correo)
);

CREATE TABLE participante_programa_academico (
    id_alumno_programa INT AUTO_INCREMENT PRIMARY KEY,
    ci_participante INT NOT NULL,
    nombre_programa VARCHAR(100) NOT NULL,
    rol ENUM('alumno','docente') NOT NULL,
    FOREIGN KEY (ci_participante) REFERENCES participante(ci),
    FOREIGN KEY (nombre_programa) REFERENCES programa_academico(nombre_programa)
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
    tipo_sala ENUM('libre','posgrado','docente') NOT NULL,
    PRIMARY KEY (nombre_sala, edificio),
    FOREIGN KEY (edificio) REFERENCES edificio(nombre_edificio)
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
    estado ENUM('activa','cancelada','sin_asistencia','finalizada') NOT NULL,
    FOREIGN KEY (nombre_sala, edificio) REFERENCES sala(nombre_sala, edificio),
    FOREIGN KEY (id_turno) REFERENCES turno(id_turno)
);

CREATE TABLE reserva_participante (
    ci_participante INT NOT NULL,
    id_reserva INT NOT NULL,
    fecha_solicitud_reserva DATE NOT NULL,
    asistencia BOOLEAN,
    PRIMARY KEY (ci_participante, id_reserva),
    FOREIGN KEY (ci_participante) REFERENCES participante(ci),
    FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
);

CREATE TABLE sancion_participante (
    id_sancion INT AUTO_INCREMENT PRIMARY KEY,
    ci_participante INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    FOREIGN KEY (ci_participante) REFERENCES participante(ci)
);

INSERT INTO login VALUES
('ana@ucu.edu.uy','1234'),
('juan@ucu.edu.uy','abcd'),
('carla@ucu.edu.uy','pass'),
('docente@ucu.edu.uy','admin'),
('maria@ucu.edu.uy','123'),
('pedro@ucu.edu.uy','xyz');

INSERT INTO facultad (nombre) VALUES
('Ingeniería'),
('Psicología'),
('Derecho');

INSERT INTO programa_academico VALUES
('Ingeniería en Informática',1,'grado'),
('Psicología',2,'grado'),
('Derecho Penal',3,'posgrado');

INSERT INTO participante VALUES
(12345678,'Ana','Pérez','ana@ucu.edu.uy'),
(87654321,'Juan','Rodríguez','juan@ucu.edu.uy'),
(45671234,'Carla','Fernández','carla@ucu.edu.uy'),
(11112222,'Carlos','López','docente@ucu.edu.uy'),
(22223333,'María','Gómez','maria@ucu.edu.uy'),
(33334444,'Pedro','Silva','pedro@ucu.edu.uy');

INSERT INTO participante_programa_academico VALUES
(1,12345678,'Ingeniería en Informática','alumno'),
(2,87654321,'Psicología','alumno'),
(3,45671234,'Psicología','alumno'),
(4,11112222,'Derecho Penal','docente'),
(5,22223333,'Ingeniería en Informática','alumno'),
(6,33334444,'Derecho Penal','docente');

INSERT INTO edificio VALUES
('Edificio Central','Av 8 de Octubre','Montevideo'),
('Campus Pocitos','Bvar España','Montevideo'),
('Sede Centro','18 de Julio','Montevideo');

INSERT INTO sala VALUES
('Sala 101','Edificio Central',30,'libre'),
('Sala 102','Edificio Central',25,'libre'),
('Sala Docente 1','Campus Pocitos',20,'docente'),
('Sala 201','Sede Centro',40,'libre'),
('Sala 202','Sede Centro',20,'posgrado');

INSERT INTO turno (hora_inicio,hora_fin) VALUES
('08:00','09:00'),
('09:00','10:00'),
('10:00','11:00'),
('11:00','12:00');

INSERT INTO reserva VALUES
(1,'Sala 101','Edificio Central','2025-11-03',1,'activa'),
(2,'Sala 101','Edificio Central','2025-11-04',2,'finalizada'),
(3,'Sala 102','Edificio Central','2025-11-03',1,'sin_asistencia'),
(4,'Sala Docente 1','Campus Pocitos','2025-11-05',2,'finalizada'),
(5,'Sala 201','Sede Centro','2025-11-03',1,'cancelada'),
(6,'Sala 202','Sede Centro','2025-11-03',1,'activa'),
(7,'Sala 202','Sede Centro','2025-11-04',3,'finalizada');

INSERT INTO reserva_participante VALUES
(12345678,1,'2025-10-31',TRUE),
(87654321,1,'2025-10-31',TRUE),
(12345678,2,'2025-10-30',FALSE),
(11112222,2,'2025-10-30',TRUE),
(45671234,3,'2025-10-30',FALSE),
(87654321,3,'2025-10-30',FALSE),
(11112222,4,'2025-10-29',TRUE),
(12345678,6,'2025-10-28',TRUE),
(33334444,7,'2025-10-28',TRUE),
(22223333,7,'2025-10-28',FALSE);

INSERT INTO sancion_participante VALUES
(1,45671234,'2025-10-01','2025-10-31'),
(2,87654321,'2025-09-15','2025-10-15'),
(3,33334444,'2025-09-10','2025-10-10');
