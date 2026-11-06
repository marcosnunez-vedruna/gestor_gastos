drop database if exists student_pocket_and_loop;

CREATE SCHEMA IF NOT EXISTS student_pocket_and_loop DEFAULT CHARACTER SET utf8mb4;
USE student_pocket_and_loop;

-- 1. Usuarios y autenticación

CREATE TABLE IF NOT EXISTS usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido1 VARCHAR(100) NOT NULL,
  apellido2 VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  centro_educativo VARCHAR(150) DEFAULT 'Santa Joaquina de Vedruna',
  es_verificado boolean DEFAULT "FALSE",
  rol ENUM('ESTUDIANTE', 'ADMINISTRADOR') NOT NULL DEFAULT 'ESTUDIANTE',
  nivel_acceso VARCHAR(50),
  fecha_registro DATE DEFAULT (current_date)
);

-- 2. Control financiero

CREATE TABLE IF NOT EXISTS categorias_financieras (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE,
  icono VARCHAR(50) DEFAULT NULL,
  color_hex VARCHAR(7) DEFAULT NULL
);


CREATE TABLE IF NOT EXISTS anuncios_material (
  id_anuncio INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  id_categoria INT NOT NULL,
  titulo VARCHAR(120) NOT NULL,
  descripcion TEXT,
  precio DECIMAL(10,2) NOT NULL,
  estado_articulo ENUM('NUEVO', 'COMO NUEVO', 'EN BUEN ESTADO', 'EN CONDICIONES ACEPTABLES', 'LO HA DADO TODO') NOT NULL,
  estado_publicacion ENUM('DISPONIBLE', 'RESERVADO', 'VENDIDO') DEFAULT 'DISPONIBLE',
  fecha_publicacion DATE DEFAULT (current_date),
  url_imagen VARCHAR(255),
  FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
  FOREIGN KEY (id_categoria) REFERENCES categorias_financieras (id_categoria) ON DELETE RESTRICT
);

-- 3. Mercado Academico

CREATE TABLE IF NOT EXISTS categorias_material (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE IF NOT EXISTS movimientos_financieros (
  id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  id_categoria INT NOT NULL,
  tipo ENUM('INGRESO', 'GASTO') NOT NULL,
  cantidad DECIMAL(10,2) NOT NULL,
  fecha DATETIME DEFAULT (current_date),
  descripcion VARCHAR(255),
  FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
  FOREIGN KEY (id_categoria) REFERENCES categorias_financieras (id_categoria) ON DELETE RESTRICT
);

-- -----------------------------------------------------
-- Table `student_pocket_and_loop`.`objetivos_ahorro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS objetivos_ahorro (
  id_objetivo INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  cantidad_meta DECIMAL(10,2) NOT NULL,
  cantidad_ahorrada DECIMAL(10,2) NULL DEFAULT '0.00',
  fecha_limite DATE,
  FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- Table `student_pocket_and_loop`.`presupuestos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS presupuestos (
  id_presupuesto INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  id_categoria INT NOT NULL,
  cantidad DECIMAL(10,2) NOT NULL,
  periodo ENUM('SEMANAL', 'MENSUAL') DEFAULT 'MENSUAL',
  fecha_inicio DATE NOT NULL DEFAULT (current_date),
  fecha_fin DATE NOT NULL DEFAULT (current_date() + interval 1 month),
  FOREIGN KEY (id_usuario) REFERENCES usuarios (id_usuario) ON DELETE CASCADE,
  FOREIGN KEY (id_categoria) REFERENCES categorias_financieras (id_categoria) ON DELETE CASCADE
  );