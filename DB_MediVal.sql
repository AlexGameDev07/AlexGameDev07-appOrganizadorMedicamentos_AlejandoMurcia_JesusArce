CREATE TABLE TB_Enfermedades (
    ID_Enfermedad INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Enfermedad VARCHAR2(50) NOT NULL UNIQUE
);
    
CREATE TABLE TB_Habitaciones (
    Num_Habitación INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Piso VARCHAR2(20) NOT NULL,
    Num_Cama INT NOT NULL UNIQUE
);

CREATE TABLE TB_Medicamentos (
    ID_Medicamento INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Medicamento VARCHAR2(100) NOT NULL,
    Hora_Aplicación VARCHAR2(50) NOT NULL
);

CREATE TABLE TB_Pacientes (
    ID_Paciente INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    Nombres VARCHAR2(50) NOT NULL,
    Apellidos VARCHAR2(50) NOT NULL,
    Edad INT CHECK(Edad > 0) NOT NULL,
    Num_Habitación INT NOT NULL UNIQUE,

    --Constraints------------------
    CONSTRAINT FK_Paciente_Habitación FOREIGN KEY (Num_Habitación)
    REFERENCES TB_Habitaciones (Num_Habitación)
    ON DELETE CASCADE
);

CREATE TABLE TB_Expedientes (
    ID_Expediente INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ID_Paciente INT NOT NULL,
    ID_Enfermedad INT NOT NULL,

    --Constraints-------------------

    CONSTRAINT FK_Expediente_Paciente FOREIGN KEY (ID_Paciente)
    REFERENCES TB_Pacientes (ID_Paciente)
    ON DELETE CASCADE,

    CONSTRAINT FK_Expediente_Enfermedad FOREIGN KEY (ID_Enfermedad) 
    REFERENCES TB_Enfermedades (ID_Enfermedad)
    ON DELETE CASCADE
);

CREATE TABLE TB_Recetas (
    ID_Receta INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
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

BEGIN 
PROC_DELT_Pacientes(1);
END;


DROP TABLE TB_Recetas;
DROP TABLE TB_Expedientes;
DROP TABLE TB_Pacientes;
DROP TABLE TB_Medicamentos;
DROP TABLE TB_Habitaciones;
DROP TABLE TB_Enfermedades;