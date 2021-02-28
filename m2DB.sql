CREATE TABLE usuario (
    userNombre VARCHAR2(30) NOT NULL,
    userApellido VARCHAR2(30) NOT NULL,
    userFeNaci DATE,
    userRun NUMBER(9) NOT NULL,
    tipo_usuario VARCHAR2(50)
);
ALTER TABLE usuario ADD CONSTRAINT usuario_pk PRIMARY KEY (
userRun );
ALTER TABLE usuario ADD CONSTRAINT cx_tipo_usuairio
CHECK ( tipo_usuario IN ( 'Cliente', 'Profesional', 'Administrativo'));
 -- GRUPAL 5;
-- PREGUNTA 1 Y 2
-- CREACION DE TABLAS, PK, FK Y CONSTRAINT NO NULL 
-- cliente, capacitacion, accidente, asistentes
CREATE TABLE cliente (
    rutcliente NUMBER(9) NOT NULL,
    telefono VARCHAR2(20) NOT NULL,
    afp VARCHAR2(30),
    sistemasalud NUMBER(2),
    direccion VARCHAR2(70),
    comuna VARCHAR2(50),
    edad NUMBER(3) NOT NULL
);
ALTER TABLE cliente ADD CONSTRAINT clente_pk PRIMARY KEY (
rutcliente );

CREATE TABLE capacitacion (
 idcapacitacion NUMBER(9) NOT NULL,
 fecha DATE,
 hora DATE,
 lugar VARCHAR2(50) NOT NULL,
 duracion NUMBER(3),
 cantidadasistentes NUMBER(5) NOT NULL,
 Cliente_rutcliente NUMBER(9) NOT NULL
);
ALTER TABLE capacitacion ADD CONSTRAINT capacitacion_pk PRIMARY KEY (
idcapacitacion );
ALTER TABLE capacitacion
 ADD CONSTRAINT capacitacion_cliente_fk FOREIGN KEY (
cliente_rutcliente)
 REFERENCES cliente ( rutcliente );
 
CREATE TABLE asistentes (
 idasistente NUMBER(9) NOT NULL,
 nombres VARCHAR2(100) NOT NULL,
 edad NUMBER(3) NOT NULL,
 Capacitacion_idcapacitacion NUMBER(9) NOT NULL
);
ALTER TABLE asistentes ADD CONSTRAINT asistentes_pk PRIMARY KEY (
idasistente );
ALTER TABLE asistentes
 ADD CONSTRAINT asistentes_capacitacion_fk FOREIGN KEY (
capacitacion_idcapacitacion )
 REFERENCES capacitacion ( idcapacitacion );
 
 CREATE TABLE accidente (
 accidenteid NUMBER(9) NOT NULL,
 dia DATE,
 hora DATE,
 lugar VARCHAR2(50) NOT NULL,
 origen VARCHAR2(100),
 consecuencias VARCHAR2(100),
 Cliente_rutcliente NUMBER(9) NOT NULL
 );
 ALTER TABLE accidente ADD CONSTRAINT accidente_pk PRIMARY KEY (
accidenteid);
ALTER TABLE accidente
 ADD CONSTRAINT accidente_cliente_fk FOREIGN KEY (
rutcliente)
 REFERENCES cliente ( rutcliente );
 ALTER TABLE accidente DROP CONSTRAINT accidente_cliente_fk;
--PREGUNTA 3
 --CREAR SECUENCIA
 CREATE SEQUENCE asis_sc
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
 CREATE SEQUENCE cap_sc 
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
 CREATE SEQUENCE acc_sc
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
--AUTONUMBER PK CAPACITACION
CREATE OR REPLACE TRIGGER TRIGGERCAP
BEFORE INSERT ON capacitacion
FOR EACH ROW
  WHEN (new.idcapacitacion IS NULL)
BEGIN
  :new.idcapacitacion := cap_sc.NEXTVAL;
END;
/
--AUTONUMBER PK ASISTENTES 
CREATE OR REPLACE TRIGGER TRIGGERASIST
BEFORE INSERT ON asistentes
FOR EACH ROW
  WHEN (new.idasistente IS NULL)
BEGIN
  :new.idasistente := asis_sc.NEXTVAL;
END;
/
--AUTONUMBER PK ACCIDENTE
CREATE OR REPLACE TRIGGER TRIGGERACC
BEFORE INSERT ON accidente
FOR EACH ROW
  WHEN (new.accidenteid IS NULL)
BEGIN
  :new.accidenteid:= acc_sc.NEXTVAL;
END;
/
--PREGUNTA 3
ALTER TABLE cliente ADD CONSTRAINT UK_telefono
UNIQUE (telefono);
-- PREGUNTA 4
ALTER TABLE cliente ADD CONSTRAINT CX_sistemasalud
CHECK (sistemasalud IN (1,2));

------------------------------------------------------------------
--GRUPAL 6
------------------------------------------------------------------
-- MODIFICANDO TABLA CLIENTE - nombres
ALTER TABLE cliente RENAME COLUMN nombres to clinombres;
ALTER TABLE cliente RENAME COLUMN apellidos to cliapellidos;
ALTER TABLE cliente RENAME COLUMN telefono to clitelefono;
ALTER TABLE cliente RENAME COLUMN afp to cliafp;
ALTER TABLE cliente RENAME COLUMN sistemasalud to clisistemasalud;
ALTER TABLE cliente RENAME COLUMN direccion to clidireccion;
ALTER TABLE cliente RENAME COLUMN comuna to clicomuna;
ALTER TABLE cliente RENAME COLUMN edad to cliedad;
-- MODIFICO RESTRICCION NULL
ALTER TABLE cliente MODIFY (clidireccion NULL);
ALTER TABLE cliente MODIFY (clicomuna NULL);
--CLICOMUNA
ALTER TABLE cliente MODIFY clidireccion VARCHAR2(100);
ALTER TABLE cliente MODIFY ( cliapellidos VARCHAR2(50) );

-- AJUSTE TABLA CAPACITACION: TABLA_NAME
ALTER TABLE capacitacion RENAME COLUMN fecha to capfecha;
ALTER TABLE capacitacion RENAME COLUMN hora TO caphora;
ALTER TABLE capacitacion RENAME COLUMN lugar to caplugar;
ALTER TABLE capacitacion RENAME COLUMN duracion to capduracion;
-- RESTRICCIONES Y DROP
ALTER TABLE capacitacion MODIFY ( capfecha NOT NULL );
ALTER TABLE capacitacion MODIFY ( capduracion NUMBER(4));
ALTER TABLE capacitacion DROP COLUMN cantidadasistentes;

ALTER TABLE accidente RENAME COLUMN idaccidente to accidenteid;
ALTER TABLE accidente RENAME COLUMN dia to accifecha;
ALTER TABLE accidente RENAME COLUMN hora to accihora;
ALTER TABLE accidente RENAME COLUMN lugar to accilugar;
ALTER TABLE accidente RENAME COLUMN origen to acciorigen;
ALTER TABLE accidente RENAME COLUMN consecuencias to acciconsecuencias;

-- MODIFICACION NOT NULL
ALTER TABLE accidente MODIFY ( accifecha NOT NULL);
ALTER TABLE accidente MODIFY ( accilugar NOT NULL);
ALTER TABLE accidente MODIFY ( acciorigen NOT NULL);
-- TAMAÑOS
ALTER TABLE accidente MODIFY ( accilugar VARCHAR2(150));
-- TABLA ASISTENTES: NUEVAS COLUMNAS
ALTER TABLE asistentes ADD (
    asistcorreo VARCHAR2(70), 
    asisttelefono VARCHAR2(20)
    );
ALTER TABLE asistentes RENAME COLUMN nombres to asistnombrecompleto;
ALTER TABLE asistentes RENAME COLUMN edad to asistedad;

-- NUEVA TABLA VISITAS
CREATE TABLE visita (
 idvisita NUMBER(9) NOT NULL,
 visfecha DATE NOT NULL,
 vishora DATE,
 vilugar VARCHAR2(50) NOT NULL,
 viscomentarios VARCHAR2(250) NOT NULL,
 Cliente_rutcliente NUMBER(9) NOT NULL
 );
 ALTER TABLE visita ADD CONSTRAINT visita_pk PRIMARY KEY (
idvisita);
ALTER TABLE visita
 ADD CONSTRAINT visita_cliente_fk FOREIGN KEY (
cliente_rutcliente)
 REFERENCES cliente ( rutcliente );

------------------------------------------------------------------
--GRUPAL 8
------------------------------------------------------------------

CREATE TABLE chequeo (
    idchequeo NUMBER(5) NOT NULL,
    chenombre VARCHAR2(30) NOT NULL
) ;
 ALTER TABLE chequeo ADD CONSTRAINT chequeo_pk PRIMARY KEY (
idchequeo);

CREATE TABLE registroChequeo (
    idRegistroChequeo NUMBER(8) NOT NULL,
    visita_idvisita NUMBER(9) NOT NULL,
    chequeo_idchequeo NUMBER(5) NOT NULL ,
    estadoCumplimiento VARCHAR2(15) NOT NULL-- cumple, cumple con observaciones, no cumple)
);
 ALTER TABLE registroChequeo ADD CONSTRAINT registroChequeo_pk PRIMARY KEY (
idRegistroChequeo );
ALTER TABLE registroChequeo 
 ADD CONSTRAINT registroChequeo_visita_fk FOREIGN KEY (
visita_idvisita)
 REFERENCES visita ( idvisita );
 ALTER TABLE registroChequeo 
 ADD CONSTRAINT registroChequeo_chequeo_fk FOREIGN KEY (
chequeo_idchequeo)
 REFERENCES chequeo ( idchequeo );
-- RESTRINGIENDO INPUT ESTADOCUMPLIMIENTO
ALTER TABLE registroChequeo ADD CONSTRAINT ck_estadoCumplimiento
CHECK ( estadoCumplimiento IN ( 'Cumple', 'Cumple con observaciones', 'No cumple'));

CREATE TABLE administrativo (
runAdm NUMBER(9) NOT NULL,
admCorreo VARCHAR2(30) ,
admArea VARCHAR2(20)
);
ALTER TABLE administrativo ADD CONSTRAINT administrativo_pk PRIMARY KEY (
runAdm );
CREATE TABLE profesional (
    runProfesional NUMBER(9),
    proTelefono VARCHAR2(30) ,
    proTitulo VARCHAR2(30) ,
    proProyecto VARCHAR2(30)
);  -- asociar a un usuario fk como adm y cliente
ALTER TABLE profesional ADD CONSTRAINT profesional_pk PRIMARY KEY (
runProfesional );
 -- FK USUARIO_CLIENTE

 ALTER TABLE USUARIO 
 ADD CONSTRAINT usuario_cliente_fk FOREIGN KEY (
cliente_rutCliente)
 REFERENCES cliente ( rutCliente );
-- 1 cliente : 1 usuario
-- FK USUARIO_ADM
ALTER TABLE usuario 
 ADD CONSTRAINT usuario_administrativo_fk FOREIGN KEY (
administrativo_runAdm)
 REFERENCES administrativo ( runAdm );
-- FK USUARIO_PROFESIONAL 
 ALTER TABLE usuario 
 ADD CONSTRAINT usuario_profesional_fk FOREIGN KEY (
profesional_runProfesional )
 REFERENCES profesional ( runProfesional );
 -- CREAR SEQ Y TRIG PARA NUEVAS PK VISITA, REG CHEQUEO
 -- CHEQUEO DADO QUE ES UNA TABLA MUY PEQUEÑA NO LE CREAREMOS UN TRIGGER
 CREATE SEQUENCE visita_sc
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
CREATE SEQUENCE regchequeo_sc
    START WITH 0
    MINVALUE 0
    MAXVALUE 100;
--AUTONUMBER PK VISITA
CREATE OR REPLACE TRIGGER TRIGGERVIS
BEFORE INSERT ON visita
FOR EACH ROW
  WHEN (new.idvisita IS NULL)
BEGIN
  :new.idvisita := visita_sc.NEXTVAL;
END;
/
--AUTONUMBER PK REGISTRO CHEQUEO
CREATE OR REPLACE TRIGGER TRIGGERREG
BEFORE INSERT ON registroChequeo
FOR EACH ROW
  WHEN (new.idRegistroChequeo IS NULL)
BEGIN
  :new.idRegistroChequeo := regChequeo_sc.NEXTVAL;
END;
/

------------------------------------------------------------------
--FINAL MODULO 2
------------------------------------------------------------------
CREATE TABLE pago (
    idpago NUMBER(6) NOT NULL, -- autoincremental
    fechaPago DATE, 
    montoPago NUMBER(12),
    mesPago VARCHAR2(15),
    añoPago NUMBER(4),
    cliente_rutCliente NUMBER(9) 
);
ALTER TABLE pago
ADD CONSTRAINT cliente_pago_fk FOREIGN KEY (
cliente_rutCliente)
REFERENCES cliente (rutCliente);

CREATE TABLE asesoria (
idasesoria NUMBER(4),
asesFechaRealizacion DATE,
asesMotivoSolicita VARCHAR2(100),
profesional_rutProfesional NUMBER(9)
);
--fk a profesional
ALTER TABLE asesoria
ADD CONSTRAINT profesional_asesoria_fk FOREIGN KEY (
profesional_rutProfesional)
REFERENCES profesional (runProfesional);
CREATE TABLE actividadMejora (
	idactividadMejora NUMBER(6) NOT NULL, -- AUTOINCREMENTAL
	amTitulo VARCHAR2(50),
	amDescripcion VARCHAR2(250),
	amPlazoRes NUMBER (3) -- dias
);
-- AUTOINCREMENTAL IDAMEJORA
CREATE SEQUENCE act_sc
   START WITH 0
    MINVALUE 0
    MAXVALUE 100;
CREATE OR REPLACE TRIGGER TRIGGERACT
BEFORE INSERT ON actividadMejora
FOR EACH ROW
  WHEN (new.idactividadMejora IS NULL)
BEGIN
  :new.idactividadMejora := act_sc.NEXTVAL;
END;
/
select * from usuarios;
--------------------------------------------------------------------------
-----INSERCION DE DATOS EN TABLAS---
--TABLA USUARIOS
select * from usuario;
INSERT INTO usuario
VALUES ('MARCELO', 'MARTINEZ', TO_DATE('10-11-1980','DD-MM-YYYY'), 111, '' );
INSERT INTO USUARIO VALUES ( 'ALEXANDER', 'PEREZ', TO_DATE('30-09-1999','DD-MM-YYYY'), 222, '');
INSERT INTO USUARIO VALUES ( 'MARGARITA', 'MENESES', TO_DATE('30-08-1980','DD-MM-YYYY'), 333, '');
INSERT INTO USUARIO VALUES ( 'MOISES', 'LOPEZ', TO_DATE('21-09-1995','DD-MM-YYYY'), 444, '');
INSERT INTO USUARIO VALUES ( 'RUBEN', 'CARRASCO', TO_DATE('22-10-1996','DD-MM-YYYY'), 555, '');
INSERT INTO USUARIO VALUES ( 'GLORIA', 'DOOGLAS', TO_DATE('23-11-1997','DD-MM-YYYY'), 666, '');
INSERT INTO USUARIO VALUES ( 'JAIME', 'SOTO', TO_DATE('24-12-1998','DD-MM-YYYY'), 777, '');
INSERT INTO USUARIO VALUES ( 'FLOR', 'GONZALEZ', TO_DATE('25-01-1997','DD-MM-YYYY'), 888, '');
INSERT INTO USUARIO VALUES ( 'ROSA', 'ESPINOZA', TO_DATE('26-02-1996','DD-MM-YYYY'), 999, '');

--TABLA CLIENTE
INSERT INTO  CLIENTE VALUES (111, '33344455', 'CAPITALCA', 1, 'LOS ABEDULES #44', 'MACUL', 1);
INSERT INTO  CLIENTE VALUES (222, 'RAMON ARNOLDO', 'MARTINEZ LUENGO', '36667755', 'PROPROVIDA', 2, 'LOS ZORZALES #54', 'BUIN', 2);
INSERT INTO  CLIENTE VALUES (333, 'PAMELA ANDREA', 'FRITZ KKOPP', '5555455', 'MOMODELO', 1, 'LAS ACACIAS #784', 'VALPARAISO',3);
--alter table profesional drop constraint profesional_pk;
--TABLA PROFESIONAL
INSERT INTO  PROFESIONAL VALUES (444, 'ARQUITECTO', 'ARQUITECTURA EDIFICIO');
INSERT INTO  PROFESIONAL VALUES (555, 'MEDICO', 'VACUNACION');
INSERT INTO  PROFESIONAL VALUES (666, 'PERIODISTA', 'RELACIONES PUBLICAS');
select * from profesional;
--TABLA ADMINISTRATIVO
INSERT INTO  ADMINISTRATIVO VALUES (777, 'KERR@GMAIL.PK', 'OFICINAS');
INSERT INTO  ADMINISTRATIVO VALUES (888, 'POSTR@GMAIL.PK', 'RRHH');
INSERT INTO  ADMINISTRATIVO VALUES (999, 'TREKOP@GMAIL.PK', 'RECEPCION');

--TABLA ACCIDENTE
INSERT INTO  ACCIDENTE VALUES ('', TO_DATE('10-10-2019','DD-MM-YYYY'),TO_DATE('12:00','HH24:MI'),'SALA DE MAQUINAS', 'MALA MANIPULACION', 'CORTE MANO IZQUIERDA', 111);
INSERT INTO  ACCIDENTE VALUES ('',  TO_DATE('05-09-2019','DD-MM-YYYY'),TO_DATE('13:00','HH24:MI'),'RECEPCION', 'CAIDA ESCALERA', 'ESGUINCE PIE DERECHO', 222);
INSERT INTO  ACCIDENTE VALUES ('', TO_DATE('10-08-2019','DD-MM-YYYY'),TO_DATE('11:50','HH24:MI'),'CASINO', 'TALLARIN EN EL OJO', 'OJO IRRITADO', 333);

--TABLA VISITA

INSERT INTO  VISITA VALUES (1, TO_DATE('05-09-2020','DD-MM-YYYY'),TO_DATE('13:00','HH24:MI'), 'OFICINAS', 'CLIENTE CONFORME', 12334555);
INSERT INTO  VISITA VALUES (2, TO_DATE('10-10-2020','DD-MM-YYYY'),TO_DATE('11:00','HH24:MI'), 'OFICINAS', 'CLIENTE CON PROBLEMAS TECNICOS', 22334555);
INSERT INTO  VISITA VALUES (3, TO_DATE('10-09-2020','DD-MM-YYYY'),TO_DATE('10:50','HH24:MI'), 'OFICINAS', 'CLIENTE CON DUDAS SOBRE PRESUPUESTO', 23555666);

--TABLA CAPACITACION
   
INSERT INTO  CAPACITACION VALUES ( 100,TO_DATE('10-11-2020','DD-MM-YYYY'),TO_DATE('12:00','HH24:MI'), 'OFICINA PRINCIPAL', 120, 12334555);
INSERT INTO  CAPACITACION VALUES ( TO_DATE('12-12-2020','DD-MM-YYYY'),TO_DATE('10:00','HH24:MI'), 'SALA CAPACITACIONES', 60, 23555666);
INSERT INTO  CAPACITACION VALUES ( TO_DATE('09-09-2020','DD-MM-YYYY'),TO_DATE('11:00','HH24:MI'), 'OFICINA PRINCIPAL', 70, 22334555);

--TABLA ASISTENTES
INSERT INTO  ASISTENTES VALUES (1, 'RAMON ARNOLDO MARTINEZ LUENGO', 43, 'RALUE@GMAIL.PK', '36667755', 3);
INSERT INTO  ASISTENTES VALUES (2, 'AGUSTIN SERAFIN SERAFINI FILI', 33, 'SERAFINI@GMAIL.PK', '33344455', 1);
INSERT INTO  ASISTENTES VALUES (3, 'PAMELA ANDREA FRITZ KKOPP', 55, 'KKOPP@GMAIL.PK', '5555455', 2);

--TABLA CHEQUEOS .
INSERT INTO  CHEQUEO VALUES (1, 'REVISION COMPUERTAS');
INSERT INTO  CHEQUEO VALUES (2, 'REVISION ESTRUCTURA');
INSERT INTO  CHEQUEO VALUES (3, 'REVISION SEGURIDAD');

--TABLA REGISTRO CHEQUEO
INSERT INTO  REGISTROCHEQUEO VALUES (1, 3, 'SI cumple');
INSERT INTO  REGISTROCHEQUEO VALUES (2, 2, 'Cumple con observasiones');
INSERT INTO  REGISTROCHEQUEO VALUES (3, 1, 'No cumple');

--TABLA REGISTRO PAGOS IDENTIFICADOR EN BLANCO PARA QUE FUNCIONE AUTOINCREMENTO
INSERT INTO  REGISTROPAGOS VALUES ('', TO_DATE('11-11-2020','DD-MM-YYYY'), 220000, 'NOVIEMBRE', '2020', 22334555);
INSERT INTO  REGISTROPAGOS VALUES ('', TO_DATE('08-10-2020','DD-MM-YYYY'), 300000, 'OCTUBRE', '2020', 12334555);
INSERT INTO  REGISTROPAGOS VALUES ('', TO_DATE('11-10-2020','DD-MM-YYYY'), 500000, 'OCTUBRE', '2020', 23555666);

--TABLA ASESORIAS
INSERT INTO  ASESORIAS VALUES (1, TO_DATE('22-01-2012','DD-MM-YYYY'), 'BALANCE', 4);
INSERT INTO  ASESORIAS VALUES (2, TO_DATE('30-01-2010','DD-MM-YYYY'), 'AUDITORIA', 5);
INSERT INTO  ASESORIAS VALUES (3, TO_DATE('15-10-2020','DD-MM-YYYY'), 'ARQUEO CAJA', 6);

--TABLA MEJORAS SE DEJA EN BLANCO EL PRIMER VALOR IDMEJORA PARA QUE FUNCIONE EL AUTOINCREMENTO
INSERT INTO  MEJORAS VALUES('', 'ORDENAMIENTO','ORDENAMIENTO LIBROS CONTABLES', 3, 1);
INSERT INTO  MEJORAS VALUES('', 'REVISION','REVISION DE INFRAESTRUCTURA', 2, 2);
INSERT INTO  MEJORAS VALUES('', 'PLANIFICACION','PLANIFICACION DE REUNIONES SEMANALES', 5, 3);

-- CONSULTA A
SELECT ASISTNOMBRECOMPLETO, ASISTEDAD, ASISTCORREO
FROM ASISTENTES
WHERE CAPACITACION_IDCAPACITACION IN (
   SELECT IDCAPACITACION
  FROM CAPACITACION
  WHERE (CLIENTE_RUTCLIENTE = 12334555));
  ---------------------------consulta B----------------------------  
  
  SELECT REGISTRO_IDCHEQUEO,  CUMPLECHEQUEO, OBSERVACIONES
FROM REGISTROCHEQUEO
WHERE REGISTRO_IDVISITA IN (
  SELECT IDVISITA
  FROM VISITA
  WHERE Cliente_rutcliente IN (
    SELECT rutcliente
    FROM CLIENTE
    WHERE CLICOMUNA = 'VALPARAISO'));
  
    ---------------------------consulta C----------------------------     
SELECT 
    AC.IDACCIDENTE,AC.ACCIFECHA, AC.ACCIHORA, AC.ACCILUGAR, AC.ACCIORIGEN, 
    AC.ACCICONSECUENCIAS,CLI.CLINOMBRES,CLI.CLIAPELLIDOS,CLI.RUTCLIENTE,CLI.CLITELEFONO
FROM
    ACCIDENTE AC INNER JOIN CLIENTE CLI
ON  CLI.RUTCLIENTE=AC.CLIENTE_RUTCLIENTE;

