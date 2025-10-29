CREATE DATABASE termotech;

USE termotech;

show tables;

CREATE TABLE empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT, -- ID da Empresa (Autoincrementado)
    nomeFantasia VARCHAR(100), -- Nome fantasia da Empresa
	razaoSocial VARCHAR(100), -- Razão Social da Empresa
    cnpj CHAR(14) UNIQUE NOT NULL, -- CNPJ da Empresa
    cep CHAR(9), -- CEP da Empresa 
    numero VARCHAR(6), -- Número do endereço da Empresa
    complemento VARCHAR(100), -- Complemento
    emailResponsavel VARCHAR(100), -- Email do responsável para envio do token
    token VARCHAR(45)
);

INSERT INTO empresa VALUES
	(DEFAULT, 'Copper Cotia', 'Cobre Cia', '54808068000120', '06725120', '50', null, 'copper_cotia@email.com', '30102025'),
	(DEFAULT, 'Cobre Nosso', 'Mineradoras SA', '88614491000101', '02614100', '170', '10o andar', 'cobre_nosso@email.com', 'sprint2');

CREATE TABLE usuario (
	idUsuario INT PRIMARY KEY AUTO_INCREMENT, -- ID do Usuário (Autoincrementado)
    nome VARCHAR(200),
    telefone CHAR(11) NOT NULL,
    email VARCHAR(255) NOT NULL, -- Email para login do usuário
    senha VARCHAR(255) NOT NULL, -- Senha de acesso do usuário
    fkEmpresa INT, -- Será utilizado para pegar dados de email e senha da tabela empresa para verificar o login
    CONSTRAINT fkEmpresaUsuario
		FOREIGN KEY (fkEmpresa)
			REFERENCES empresa(idEmpresa)
	) AUTO_INCREMENT = 100;
    
INSERT INTO usuario VALUES
	(DEFAULT, 'Julia Lopes', '11987654321', 'julia@gmail.com', 'julia123', 1),
	(DEFAULT, 'Fernando Brandão', '11987654320', 'brandao@gmail.com', '12345678aA@', 1),
	(DEFAULT, 'João Dias', '11987654322', 'joao@gmail.com', 'Joao#2025', 2);
    
    CREATE TABLE mina(
		idMina INT PRIMARY KEY AUTO_INCREMENT,
        fkEmpresa INT,
        latitude DECIMAL(10,6),
        longitude DECIMAL(10,6),
        CONSTRAINT fkEmpresaMina
			FOREIGN KEY (fkEmpresa)
				REFERENCES empresa(idEmpresa)
) AUTO_INCREMENT = 300;

select * from mina;

INSERT INTO mina VALUES
	(DEFAULT, 1, '-19.810300' , '-42.863221'),
	(DEFAULT, 1, '-6.710625', '-52.706971'),
	(DEFAULT, 2, '-17.646297', '-43.170836'),
	(DEFAULT, 2, '-13.712354', '-50.070253');

CREATE TABLE sensor (
	idSensor INT PRIMARY KEY AUTO_INCREMENT, -- ID do Sensor
    fkMina INT,
    setor VARCHAR(45),
    statusS VARCHAR(50), -- Status se está funcionando
	CONSTRAINT fkMinaSensor
			FOREIGN KEY (fkMina)
				REFERENCES mina(idMina),
	CONSTRAINT chkStatus
		CHECK (statusS IN ('funcionando', 'manutenção', 'parado')) 
) AUTO_INCREMENT = 500;

INSERT INTO sensor VALUES 
	(DEFAULT, 300, '1A', 'funcionando'),
	(DEFAULT, 300, '1A', 'funcionando'),
	(DEFAULT, 301, '2A', 'funcionando'),
	(DEFAULT, 301, '2A','funcionando'),
	(DEFAULT, 301, '2B', 'funcionando'),
	(DEFAULT, 302, '5A','funcionando'),
	(DEFAULT, 303, '1B','funcionando');
    
    select * from sensor;
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
) AUTO_INCREMENT = 700;


SHOW TABLES;

select * from coletaDados;
select * from sensor;
select * from mina;
select * from empresa;
select * from usuario;

SELECT nomeFantasia AS 'Nome da Empresa',
		cnpj AS CNPJ,
        idMina AS Mina,
        setor AS 'Setor da mina',
        idSensor AS Sensor,
        temperatura AS Temperatura,
        dataHoraColeta AS 'Data e hora da coleta',
        alerta AS Alerta
			FROM empresa JOIN mina ON mina.fkEmpresa = idEmpresa
				JOIN sensor ON fkMina = idMina
				JOIN coletaDados ON fkSensor = idSensor;
                
SELECT 	nomeFantasia AS 'Nome da Empresa',
		cnpj AS CNPJ,
        idMina AS Mina,
        idSensor AS Sensor,
        temperatura AS Temperatura,
        dataHoraColeta AS 'Data e hora da coleta',
        alerta AS Alerta
			FROM usuario JOIN empresa 
            ON usuario.fkEmpresa = empresa.idEmpresa
				JOIN mina ON mina.fkEmpresa = idEmpresa
					JOIN sensor ON fkMina = idMina
						JOIN coletaDados ON fkSensor = idSensor;
