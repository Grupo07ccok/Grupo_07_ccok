CREATE DATABASE termotech;

USE termotech;
show tables;

CREATE TABLE empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT, -- ID da Empresa (Autoincrementado)
    nomeFantasia VARCHAR(60), -- Nome Fantasia da Empresa
	razaoSocial VARCHAR(50), -- Razão Social da Empresa
	emailResponsavel VARCHAR(80) UNIQUE NOT NULL, -- E-mail da Empresa
	nomeResponsavel VARCHAR(100), -- Nome do funcionário responsável da Empresa
	cnpj CHAR(14) UNIQUE NOT NULL, -- CNPJ da Empresa
	logradouro VARCHAR(200), -- Endereço da Empresa 
	qtdEmpregados INT, -- Quantidade de funcionários da Empresa
	estadoEmpresa CHAR(2), -- Unidade Federativa da Empresa
	municipio VARCHAR(50), -- Município da Empresa
	telefoneResponsavel VARCHAR(25) -- Telefone de contato da Empresa
);
CREATE TABLE usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT, -- ID do Usuário (Autoincrementado)
    nome VARCHAR(200),
    senhaHash VARCHAR(255) NOT NULL, -- Hash da senha de acesso da Empresa
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
        cidade VARCHAR(70),
        estado CHAR(2),
        pais VARCHAR(50),
        qtdSensor INT,
        tempMax DECIMAL(5,2) NOT NULL, -- Temperatura do local
		tempMin DECIMAL(5,2) NOT NULL,
		tempMedia DECIMAL(5,2) NOT NULL,
        fkEmpresa INT,
        CONSTRAINT fkEmpresaMina
			FOREIGN KEY (fkEmpresa)
				REFERENCES empresa(idEmpresa)
);
CREATE TABLE sensor (
	idSensor INT PRIMARY KEY AUTO_INCREMENT, -- ID do Sensor
    fkMina INT,
	latitude DECIMAL(10,6),
	longitude DECIMAL(10,6),
    profundidade DECIMAL(10,6),
    statusS VARCHAR(50),
	CONSTRAINT fkMinaSensor
			FOREIGN KEY (fkMina)
				REFERENCES mina(idMina)                
);
CREATE TABLE coletaDados (
	idColeta INT PRIMARY KEY AUTO_INCREMENT,
    fkSensor INT,
    CONSTRAINT fkSensorDados
			FOREIGN KEY (fkSensor)
				REFERENCES sensor(idSensor),
    temperatura DECIMAL(2,0),
	horaColeta DATETIME DEFAULT current_timestamp, -- Data e Hora da temperatura (PEGAR DA API COM JAVASCRIPT)
	localColeta VARCHAR(100),
    alerta TINYINT,
	funcionamento TINYINT, -- Irá constar se o sensor está funcionando ou não, necessitando de reparos/atualizações ou não, 0 é quebrado/reparo/atualização e 1 é funcionando
		CONSTRAINT chkSituacao CHECK(funcionamento IN(0, 1)),
	sensorAnalogico FLOAT
);

SHOW TABLES;

select * from coletaDados;
truncate table coletaDados;