CREATE DATABASE termotech;

USE termotech;
show tables;

CREATE TABLE empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT, -- ID da Empresa (Autoincrementado)
	razaoSocial VARCHAR(50), -- Razão Social da Empresa
	emailResponsavel VARCHAR(80) UNIQUE NOT NULL, -- E-mail da Empresa
	nomeResponsavel VARCHAR(100), -- Nome do funcionário responsável da Empresa
	telefoneResponsavel CHAR(11), -- Telefone de contato da Empresa
	cnpj CHAR(14) UNIQUE NOT NULL, -- CNPJ da Empresa
	cep CHAR(9) -- CEP da Empresa 
);

INSERT INTO empresa VALUES
	(DEFAULT, null, 'responsavel@email.com', 'João', null, '12345678912345', null);

CREATE TABLE usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT, -- ID do Usuário (Autoincrementado)
    nome VARCHAR(200),
    senha VARCHAR(255) NOT NULL, -- Senha de acesso da Empresa
	email VARCHAR(255) NOT NULL,
    telefone CHAR(11) NOT NULL,
    fkEmpresa INT, -- Será utilizado para pegar dados de email e senhaHash da tabela empresa para verificar o login
    CONSTRAINT fkEmpresaUsuario
		FOREIGN KEY (fkEmpresa)
			REFERENCES empresa(idEmpresa)
	);
    CREATE TABLE mina(
		idMina INT PRIMARY KEY AUTO_INCREMENT,
        latitude DECIMAL(10,6),
        longitude DECIMAL(10,6),
        fkEmpresa INT,
        CONSTRAINT fkEmpresaMina
			FOREIGN KEY (fkEmpresa)
				REFERENCES empresa(idEmpresa)
);

INSERT INTO mina VALUES
	(1, null, null, 1);

CREATE TABLE sensor (
	idSensor INT PRIMARY KEY AUTO_INCREMENT, -- ID do Sensor
    fkMina INT,
    statusS VARCHAR(50),
	CONSTRAINT fkMinaSensor
			FOREIGN KEY (fkMina)
				REFERENCES mina(idMina)                
);

INSERT INTO sensor VALUES 
	(DEFAULT, 1, 'funcionando');
    
CREATE TABLE coletaDados (
	idColeta INT AUTO_INCREMENT,
    fkSensor INT,
    CONSTRAINT pkSensorDados
		PRIMARY KEY (idColeta, fkSensor),
    CONSTRAINT fkSensorDados
			FOREIGN KEY (fkSensor)
				REFERENCES sensor(idSensor),
    temperatura DECIMAL(3,1),
	dataHoraColeta DATETIME DEFAULT current_timestamp, -- Data e Hora da temperatura (PEGAR DA API COM JAVASCRIPT)
    alerta TINYINT
);

SHOW TABLES;

select * from coletaDados;
select * from sensor;
select * from coletaDados;

truncate table coletaDados;

INSERT INTO coletaDados (temperatura) VALUES
(17);