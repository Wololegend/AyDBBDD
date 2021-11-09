-- Disparador 1: Email

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

-- CREACIÓN DE TABLAS --

--      Viveros
DROP TABLE IF EXISTS Viveros;

CREATE TABLE IF NOT EXISTS Viveros (
  Ubicación VARCHAR(40) NOT NULL,
  PRIMARY KEY (Ubicación));


--      Empleados       --
DROP TABLE IF EXISTS Empleados;

CREATE TABLE IF NOT EXISTS Empleados (
  Nombre_y_apellidos VARCHAR(45) NULL,
  DNI VARCHAR(9) NOT NULL,
  Salario INT NULL,
  Número_SS VARCHAR(15) NULL,
  Dirección VARCHAR(90) NULL,
  PRIMARY KEY (DNI));


--      Trabaja_en      --
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

--      Zonas       --
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


--      Ubicado_en      --
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


--      Productos       --
DROP TABLE IF EXISTS Productos;

CREATE TABLE IF NOT EXISTS Productos (
  Código INT NOT NULL,
  Stock INT NULL,
  Precio DECIMAL NULL,
  PRIMARY KEY (Código));


--      Se_asigna       --
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


--      Cliente_Club        --
DROP TABLE IF EXISTS Cliente_Club;

CREATE TABLE IF NOT EXISTS Cliente_Club (
  Nombre_y_apellidos VARCHAR(45) NULL
  DNI VARCHAR(9) NOT NULL,
  Crédito_mensual DECIMAL NULL,
  Email TEXT NULL,
  Nombre_y_apellidos VARCHAR(60) NULL,
  Dirección VARCHAR(90) NULL,
  PRIMARY KEY (DNI));


--      Pedido      --
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


-- DEFINICIÓN DE FUNCIONES --
CREATE OR REPLACE FUNCTION crear_email(IN dom text) RETURNS trigger AS $$
    BEGIN
        IF new.Email IS NULL THEN
            DECLARE mail text := concat(substring(new.Nombre_y_apellidos from 2 for 4), CONCAT('@', dom));

            INSERT INTO Cliente_Club(DNI, Crédito_mensual, Email, Nombre_y_apellidos)
            VALUES (new.DNI, new.Crédito_mensual, mail, new.Nombre_y_apellidos);
        END IF;
    END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_direccion_empleados() RETURNS trigger AS $$
	BEGIN
		IF (SELECT Nombre_y_apellidos
			FROM Empleados
			WHERE (Nombre_y_apellidos = new.Nombre_y_apellidos) AND (Dirección = new.Dirección)) IS NOT NULL THEN

				DELETE FROM Empleados
				WHERE (Nombre_y_apellidos = new.Nombre_y_apellidos) AND (Dirección = new.Dirección);

				RAISE NOTICE 'Una persona no puede vivir en dos direcciones.';
		END IF;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_direccion_clientes() RETURNS trigger AS $$
	BEGIN
		IF (SELECT Nombre_y_apellidos
			FROM Cliente_Club
			WHERE (Nombre_y_apellidos = new.Nombre_y_apellidos) AND (Dirección = new.Dirección)) IS NOT NULL THEN

				DELETE FROM Cliente_Club
				WHERE (Nombre_y_apellidos = new.Nombre_y_apellidos) AND (Dirección = new.Dirección);

				RAISE NOTICE 'Una persona no puede vivir en dos direcciones.';
		END IF;
	END;
$$ LANGUAGE plpgsql;


-- DEFINICIÓN DE TRIGGERS --
CREATE TRIGGER trigger_crear_email_before_insert BEFORE INSERT ON Cliente_Club
FOR EACH ROW EXECUTE PROCEDURE crear_email('gmail.com');

CREATE TRIGGER trigger_comprobar_dirección_empleados AFTER INSERT ON Empleados
FOR EACH ROW EXECUTE PROCEDURE check_direccion_empleados();

CREATE TRIGGER trigger_comprobar_dirección_clientes AFTER INSERT ON Empleados
FOR EACH ROW EXECUTE PROCEDURE check_direccion_empleados();