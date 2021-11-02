-- -----------------------------------------------------
-- Table Viveros
-- -----------------------------------------------------
DROP TABLE IF EXISTS Viveros;

CREATE TABLE IF NOT EXISTS Viveros (
  Ubicación VARCHAR(40) NOT NULL,
  PRIMARY KEY (Ubicación));


-- -----------------------------------------------------
-- Table Empleados
-- -----------------------------------------------------
DROP TABLE IF EXISTS Empleados;

CREATE TABLE IF NOT EXISTS Empleados (
  Nombre_y_apellidos VARCHAR(45) NOT NULL,
  Salario INT NULL,
  Número_SS VARCHAR(15) NULL,
  PRIMARY KEY (Nombre_y_apellidos));


-- -----------------------------------------------------
-- Table Trabaja_en
-- -----------------------------------------------------
DROP TABLE IF EXISTS Trabaja_en;

CREATE TABLE IF NOT EXISTS Trabaja_en (
  Fecha_de_Inicio DATE NOT NULL,
  Fecha_de_Finalización DATE NOT NULL,
  Empleados_Nombre_y_apellidos VARCHAR(45) NOT NULL,
  PRIMARY KEY (Fecha_de_Inicio, Fecha_de_Finalización),
  CONSTRAINT fk_Trabaja_en_Empleados1
    FOREIGN KEY (Empleados_Nombre_y_apellidos)
    REFERENCES Empleados (Nombre_y_apellidos)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table Zonas
-- -----------------------------------------------------
DROP TABLE IF EXISTS Zonas;

CREATE TABLE IF NOT EXISTS Zonas (
  idZonas INT NOT NULL,
  Trabaja_en_Fecha_de_Inicio DATE NOT NULL,
  Trabaja_en_Fecha_de_Finalización DATE NOT NULL,
  PRIMARY KEY (idZonas),
  CONSTRAINT fk_Zonas_Trabaja_en1
    FOREIGN KEY (Trabaja_en_Fecha_de_Inicio , Trabaja_en_Fecha_de_Finalización)
    REFERENCES Trabaja_en (Fecha_de_Inicio , Fecha_de_Finalización)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table Ubicado_en
-- -----------------------------------------------------
DROP TABLE IF EXISTS Ubicado_en;

CREATE TABLE IF NOT EXISTS Ubicado_en (
  Viveros_Ubicación VARCHAR(40) NOT NULL,
  Zonas_idZonas INT NOT NULL,
  PRIMARY KEY (Viveros_Ubicación, Zonas_idZonas),
  CONSTRAINT fk_Viveros_has_Zonas_Viveros
    FOREIGN KEY (Viveros_Ubicación)
    REFERENCES Viveros (Ubicación)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Viveros_has_Zonas_Zonas1
    FOREIGN KEY (Zonas_idZonas)
    REFERENCES Zonas (idZonas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table Productos
-- -----------------------------------------------------
DROP TABLE IF EXISTS Productos;

CREATE TABLE IF NOT EXISTS Productos (
  Código INT NOT NULL,
  Stock INT NULL,
  Precio DECIMAL NULL,
  PRIMARY KEY (Código));


-- -----------------------------------------------------
-- Table Se_asigna
-- -----------------------------------------------------
DROP TABLE IF EXISTS Se_asigna;

CREATE TABLE IF NOT EXISTS Se_asigna (
  Zonas_idZonas INT NOT NULL,
  Productos_Código INT NOT NULL,
  Cantidad INT NOT NULL,
  PRIMARY KEY (Zonas_idZonas, Productos_Código, Cantidad),
  CONSTRAINT fk_Zonas_has_Productos_Zonas1
    FOREIGN KEY (Zonas_idZonas)
    REFERENCES Zonas (idZonas)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Zonas_has_Productos_Productos1
    FOREIGN KEY (Productos_Código)
    REFERENCES Productos (Código)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table Cliente_Club
-- -----------------------------------------------------
DROP TABLE IF EXISTS Cliente_Club;

CREATE TABLE IF NOT EXISTS Cliente_Club (
  DNI VARCHAR(9) NOT NULL,
  Crédito_mensual DECIMAL NULL,
  Email VARCHAR(45) NULL,
  Nombre_y_apellidos VARCHAR(60) NULL,
  PRIMARY KEY (DNI));


-- -----------------------------------------------------
-- Table Pedido
-- -----------------------------------------------------
DROP TABLE IF EXISTS Pedido;

CREATE TABLE IF NOT EXISTS Pedido (
  Productos_Código INT NOT NULL,
  Cliente_Club_DNI VARCHAR(9) NOT NULL,
  Código_de_Venta INT NOT NULL,
  Coste DECIMAL NULL,
  Empleados_Nombre_y_apellidos VARCHAR(45) NOT NULL,
  PRIMARY KEY (Productos_Código, Cliente_Club_DNI, Código_de_Venta, Empleados_Nombre_y_apellidos),
  CONSTRAINT fk_Productos_has_Cliente_Club_Productos1
    FOREIGN KEY (Productos_Código)
    REFERENCES Productos (Código)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Productos_has_Cliente_Club_Cliente_Club1
    FOREIGN KEY (Cliente_Club_DNI)
    REFERENCES Cliente_Club (DNI)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_Pedido_Empleados1
    FOREIGN KEY (Empleados_Nombre_y_apellidos)
    REFERENCES Empleados (Nombre_y_apellidos)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


START TRANSACTION;
INSERT INTO Viveros (Ubicación) VALUES ('Arona_Casco');
INSERT INTO Viveros (Ubicación) VALUES ('Las_Rosas');
INSERT INTO Viveros (Ubicación) VALUES ('La_Laguna');

COMMIT;


-- -----------------------------------------------------
-- Data for table Empleados
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Empleados (Nombre_y_apellidos, Salario, Número_SS) VALUES ('Pepe_Rodríguez_Bethencourt', 1200, '23498J1231A');
INSERT INTO Empleados (Nombre_y_apellidos, Salario, Número_SS) VALUES ('Alonso_Cabrera_Pinto', 1500, '98631H3215G');
INSERT INTO Empleados (Nombre_y_apellidos, Salario, Número_SS) VALUES ('Marta_Rodríguez_Morao', 1700, '35321T2132B');

COMMIT;


-- -----------------------------------------------------
-- Data for table Trabaja_en
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Trabaja_en (Fecha_de_Inicio, Fecha_de_Finalización, Empleados_Nombre_y_apellidos) VALUES ('01-02-2021', '01-10-2021', 'Pepe_Rodríguez_Bethencourt');
INSERT INTO Trabaja_en (Fecha_de_Inicio, Fecha_de_Finalización, Empleados_Nombre_y_apellidos) VALUES ('01-03-2021', '01-05-2021', 'Alonso_Cabrera_Pinto');
INSERT INTO Trabaja_en (Fecha_de_Inicio, Fecha_de_Finalización, Empleados_Nombre_y_apellidos) VALUES ('01-12-2020', '01-07-2021', 'Marta_Rodríguez_Morao');

COMMIT;


-- -----------------------------------------------------
-- Data for table Zonas
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Zonas (idZonas, Trabaja_en_Fecha_de_Inicio, Trabaja_en_Fecha_de_Finalización) VALUES (0002, '01-03-2021', '01-05-2021');
INSERT INTO Zonas (idZonas, Trabaja_en_Fecha_de_Inicio, Trabaja_en_Fecha_de_Finalización) VALUES (0003, '01-12-2020', '01-07-2021');
INSERT INTO Zonas (idZonas, Trabaja_en_Fecha_de_Inicio, Trabaja_en_Fecha_de_Finalización) VALUES (0001, '01-02-2021', '01-10-2021');

COMMIT;


-- -----------------------------------------------------
-- Data for table Ubicado_en
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Ubicado_en (Viveros_Ubicación, Zonas_idZonas) VALUES ('Arona_Casco', 0001);
INSERT INTO Ubicado_en (Viveros_Ubicación, Zonas_idZonas) VALUES ('Las_Rosas', 0002);
INSERT INTO Ubicado_en (Viveros_Ubicación, Zonas_idZonas) VALUES ('La_Laguna', 0003);

COMMIT;


-- -----------------------------------------------------
-- Data for table Productos
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Productos (Código, Stock, Precio) VALUES (1001, 15, 3.99);
INSERT INTO Productos (Código, Stock, Precio) VALUES (1002, 15, 14.05);
INSERT INTO Productos (Código, Stock, Precio) VALUES (1003, 15, 49.99);

COMMIT;


-- -----------------------------------------------------
-- Data for table Se_asigna
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Se_asigna (Zonas_idZonas, Productos_Código, Cantidad) VALUES (0001, 1001, 2);
INSERT INTO Se_asigna (Zonas_idZonas, Productos_Código, Cantidad) VALUES (0002, 1002, 4);
INSERT INTO Se_asigna (Zonas_idZonas, Productos_Código, Cantidad) VALUES (0003, 1003, 8);

COMMIT;


-- -----------------------------------------------------
-- Data for table Cliente_Club
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Cliente_Club (DNI, Crédito_mensual, Email, Nombre_y_apellidos) VALUES ('75312547L', 557, 'anapalomares@gmail.com', 'Ana_Palomares_Zeta');
INSERT INTO Cliente_Club (DNI, Crédito_mensual, Email, Nombre_y_apellidos) VALUES ('45632178T', 235, 'fernandopitti@gmail.com', 'Fernando_Pitti_Luis');
INSERT INTO Cliente_Club (DNI, Crédito_mensual, Email, Nombre_y_apellidos) VALUES ('98654321X', 743, 'helenmoody@gmail.com', 'Helen_Moody');

COMMIT;


-- -----------------------------------------------------
-- Data for table Pedido
-- -----------------------------------------------------
START TRANSACTION;
INSERT INTO Pedido (Productos_Código, Cliente_Club_DNI, Código_de_Venta, Coste, Empleados_Nombre_y_apellidos) VALUES (1001, '75312547L', 2001, 186.35, 'Pepe_Rodríguez_Bethencourt');
INSERT INTO Pedido (Productos_Código, Cliente_Club_DNI, Código_de_Venta, Coste, Empleados_Nombre_y_apellidos) VALUES (1002, '45632178T', 2002, 75.13, 'Alonso_Cabrera_Pinto');
INSERT INTO Pedido (Productos_Código, Cliente_Club_DNI, Código_de_Venta, Coste, Empleados_Nombre_y_apellidos) VALUES (1003, '98654321X', 2003, 25.45, 'Marta_Rodríguez_Morao');

COMMIT;
