CREATE TABLE TB_Enfermedades (
    ID_Enfermedad INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Enfermedad VARCHAR2(50) NOT NULL UNIQUE
);
    
CREATE TABLE TB_Medicamentos (
    ID_Medicamento INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Medicamento VARCHAR2(100) NOT NULL UNIQUE
);

CREATE TABLE TB_Pacientes (
    ID_Paciente INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Nombres VARCHAR2(50) NOT NULL,
    Apellidos VARCHAR2(50) NOT NULL,
    Edad INT CHECK(Edad > 0) NOT NULL,
    Num_Habitación INT NOT NULL,
    Num_Cama INT NOT NULL
);

CREATE TABLE TB_Recetas (
    ID_Receta INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Aplicación INT NOT NULL CHECK (Aplicación > 0),
    ID_Medicamento INT NOT NULL,
    ID_Paciente INT NOT NULL,

    --Constraints----------------------

    CONSTRAINT FK_Receta_Medicamento FOREIGN KEY (ID_Medicamento)
    REFERENCES TB_Medicamentos (ID_Medicamento)
    ON DELETE CASCADE,

    CONSTRAINT FK_Receta_Paciente FOREIGN KEY (ID_Paciente)
    REFERENCES TB_Pacientes (ID_Paciente)
    ON DELETE CASCADE
);

CREATE TABLE TB_Expedientes(
    ID_Expediente INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Paciente INT NOT NULL,
    ID_Enfermedad INT NOT NULL,
    
    --Constraints-----------------------
    
    CONSTRAINT FK_Expediente_Paciente FOREIGN KEY (ID_Paciente)
    REFERENCES TB_Pacientes (ID_Paciente)
    ON DELETE CASCADE,
    
    CONSTRAINT FK_Expediente_Enfermedad FOREIGN KEY (ID_Enfermedad)
    REFERENCES TB_Enfermedades (ID_Enfermedad)
    ON DELETE CASCADE
);
/* -TRIGGERS- *****************************************************************/
/*CREATE OR REPLACE TRIGGER TRIG_DELT_Pacientes
BEFORE DELETE ON TB_Pacientes
FOR EACH ROW
BEGIN
DELETE FROM TB_Expedientes WHERE ID_Paciente = :NEW.ID_Paciente;
DELETE FROM TB_Recetas WHERE ID_Paciente = :NEW.ID_Paciente;
END TRIG_DELT_Pacientes;
/
*/


CREATE OR REPLACE PROCEDURE PROC_DELT_Pacientes
(var_ID_Paciente IN TB_Pacientes.ID_Paciente%TYPE)
IS
BEGIN
DELETE FROM TB_Expedientes WHERE ID_Paciente = var_ID_Paciente;
DELETE FROM TB_Recetas WHERE ID_Paciente = var_ID_Paciente;
DELETE FROM TB_Pacientes WHERE ID_Paciente = var_ID_Paciente;
COMMIT WORK;
END PROC_DELT_Pacientes;
/

CREATE OR REPLACE PROCEDURE PROC_INST_Pacientes (
    var_Nombres IN TB_Pacientes.Nombres%TYPE,
    var_Apellidos IN TB_Pacientes.Apellidos%TYPE,
    var_Edad IN TB_Pacientes.Edad%TYPE,
    var_Num_Habitación IN TB_Pacientes.Num_Habitación%TYPE,
    var_Num_Cama IN TB_Pacientes.Num_Cama%TYPE,
    var_Medicamento IN TB_Medicamentos.ID_Medicamento%TYPE,
    var_Enfermedad IN TB_Enfermedades.ID_Enfermedad%TYPE
    
)
IS
BEGIN
INSERT INTO TB_Pacientes(Nombres, Apellidos, Edad, Num_Habitación, Num_Cama)
VALUES (var_Nombres, var_Apellidos, var_Edad, var_Num_Habitación, var_Num_Cama);

INSERT INTO TB_Recetas(ID_Paciente, ID_Medicamento)
VALUES ((SELECT ID_Paciente FROM(SELECT ID_Paciente FROM TB_Pacientes ORDER BY ID_Paciente DESC)WHERE ROWNUM = 1), var_Medicamento);

INSERT INTO TB_Expedientes(ID_Paciente, ID_Enfermedad)
VALUES ((SELECT ID_Paciente FROM (SELECT ID_Paciente FROM TB_Pacientes ORDER BY ID_Paciente DESC) WHERE ROWNUM = 1), var_Enfermedad);

COMMIT WORK;
END PROC_INST_Pacientes;
/
/*
BEGIN
PROC_INST_Pacientes(?,?,?,?,?);
END;


BEGIN 
PROC_DELT_Pacientes(?);
END;
*/
INSERT INTO TB_Pacientes(Nombres, Apellidos, Edad, Num_Cama, Num_Habitación)
VALUES ('Alejandro','Murcia', '17', '5','71');
INSERT INTO TB_Pacientes(Nombres, Apellidos, Edad, Num_Cama, Num_Habitación)
VALUES ('Michelle','Rosales', '17', '48','31');

INSERT INTO TB_Enfermedades(Enfermedad) VALUES ('Gripe');
INSERT INTO TB_Enfermedades(Enfermedad) VALUES ('Covid-19');
INSERT INTO TB_Enfermedades(Enfermedad) VALUES ('Dengue');
INSERT INTO TB_Enfermedades(Enfermedad) VALUES ('Alcheimer');
INSERT INTO TB_Enfermedades(Enfermedad) VALUES ('Resfriado Común');

INSERT INTO TB_Medicamentos(Medicamento) VALUES ('Clorfeniramina');
INSERT INTO TB_Medicamentos(Medicamento) VALUES ('Acetaminofén');
INSERT INTO TB_Medicamentos(Medicamento) VALUES ('Ibuprofeno');
INSERT INTO TB_Medicamentos(Medicamento) VALUES ('Loratadina');
INSERT INTO TB_Medicamentos(Medicamento) VALUES ('Jarabe para la tos');

INSERT INTO TB_Recetas(Aplicación, ID_Medicamento, id_paciente)
VALUES (6, 1,1);
INSERT INTO TB_Recetas(Aplicación, ID_Medicamento, id_paciente)
VALUES (8, 2,1);
INSERT INTO TB_Recetas(Aplicación, ID_Medicamento, id_paciente)
VALUES (12, 3,1);

INSERT INTO TB_Recetas(Aplicación, ID_Medicamento, id_paciente)
VALUES (8, 4,2);
INSERT INTO TB_Recetas(Aplicación, ID_Medicamento, id_paciente)
VALUES (8, 2,2);

INSERT INTO TB_Expedientes(ID_Paciente, ID_Enfermedad)
VALUES (1,1);
INSERT INTO TB_Expedientes(ID_Paciente, ID_Enfermedad)
VALUES (1,3);

INSERT INTO TB_Expedientes(ID_Paciente, ID_Enfermedad)
VALUES (2,5);

COMMIT;

Select * from tb_Pacientes;

/*
DROP TABLE TB_Expedientes CASCADE CONSTRAINTS;
DROP TABLE TB_Recetas CASCADE CONSTRAINTS;
DROP PROCEDURE PROC_DELT_PACIENTES;
DROP TABLE TB_Pacientes CASCADE CONSTRAINTS;
DROP TABLE TB_Medicamentos CASCADE CONSTRAINTS;
DROP TABLE TB_Enfermedades CASCADE CONSTRAINTS;*/