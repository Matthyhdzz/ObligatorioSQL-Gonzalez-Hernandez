
CREATE DATABASE IF NOT EXISTS salas_ucu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE salas_ucu;

CREATE TABLE salas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  edificio VARCHAR(50) NOT NULL,
  capacidad INT NOT NULL,
  tipo ENUM('Uso libre','Posgrado','Docentes') NOT NULL
);

INSERT INTO salas (nombre, edificio, capacidad, tipo) VALUES
('Sala 101', 'A', 8, 'Uso libre'),
('Sala 202', 'B', 10, 'Posgrado'),
('Sala 303', 'C', 6, 'Docentes');
