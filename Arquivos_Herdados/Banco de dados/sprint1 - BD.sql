-- Criando o banco de dados
CREATE DATABASE sprint;

-- Selecionando o banco de dados
USE sprint;

/*
Este script SQL contém as seguintes tabelas
- Empresa: 
- Administrador 
- Sensor 
- Maquinário 
- Temperatura 
- Projetos 
*/

-- Empresa
/*
Tabela empresa

Contém:

- ID (idEmpresa)
- Nome Fantasia (nomeFantasiaEmpresa)
- Razão Social (razaoSocialEmpresa)
- E-mail (emailEmpresa)
- Nome do Funcionário Responsável pela Empresa (nomeFuncionarioResponsavelEmpresa)
- Sobrenome do "                             " (sobrenomeFuncionarioResponsavelEmpresa)
- Hash da senha (senhaHash)
- CNPJ da Empresa (cnpjEmpresa)
- LogradouroEmpresa (logradouroEmpresa)
- Tradução para português brasileiro (traducaoBrEmpresa)
- Quantidade de empregados da Empresa (qtdEmpregadosEmpresa)
- Quantidade de máquinas da Empresa (qtdMaquinariosEmpresa)
- Estado da Empresa (ufEmpresa)
- Município da Empresa (municipioEmpresa)
- Telefone de contato da Empresa (telefoneEmpresa)
*/
CREATE TABLE empresa (
	idEmpresa INT PRIMARY KEY AUTO_INCREMENT, -- ID da Empresa (Autoincrementado)
    nomeFantasiaEmpresa VARCHAR(60), -- Nome Fantasia da Empresa
	razaoSocialEmpresa VARCHAR(50), -- Razão Social da Empresa
	emailEmpresa VARCHAR(80) UNIQUE NOT NULL, -- E-mail da Empresa
	nomeFuncionarioResponsavelEmpresa VARCHAR(100), -- Nome do funcionário responsável da Empresa
	sobrenomeFuncionarioResponsavelEmpresa VARCHAR(100), -- Sobrenome do funcionário responsável da Empresa
	senhaHash VARCHAR(255) NOT NULL, -- Hash da senha de acesso da Empresa
	cnpjEmpresa CHAR(14) UNIQUE NOT NULL, -- CNPJ da Empresa
	logradouroEmpresa VARCHAR(200), -- Endereço da Empresa
	traducaoBrEmpresa TINYINT DEFAULT 0, -- Se os dados são traduzidos ou não
		CONSTRAINT chkTraducao CHECK(traducaoBrEmpresa IN(0, 1)), -- Regra de tradução (0 = Não; 1 = Sim)
	qtdEmpregadosEmpresa INT, -- Quantidade de funcionários da Empresa
	qtdMaquinariosEmpresa INT, -- Quantidade de máquinas da Empresa
	ufEmpresa CHAR(2), -- Unidade Federativa da Empresa
	municipioEmpresa VARCHAR(50), -- Município da Empresa
	telefoneEmpresa VARCHAR(25) -- Telefone de contato da Empresa
);

DESC empresa;

INSERT INTO empresa VALUES 
(default,'Rochas Silva Ltda.', 'Rochas Silva','contato@rochassilva.com.br','Carlos','Lacerda','RocSlv15#156','66972964000100','Av. Dr. Carlos Fagundes, 512',0, 462, 96, 'SP', 'Piedade','1548562114'),
(default,'Santos Ores SA', 'Santos Mineradores', 'santos.ores@gmail.com','Julia','Jardim','OrSstos123$#','66149125000196','Rua Domingos Olímpio, 1290',0,320,42,'MG', 'Ouro Preto','3152687931'),
(default,'Prime Zone Ltda','Prime Zone','contato@primezone.com.br','Guilherme','Bento','!@64ZnPme','67127016000130','Al. Tocantins, 3102',1,745,201,'SP',' Botucatu','1442156987');

SELECT * FROM empresa;

SELECT * FROM empresa ORDER BY qtdMaquinariosEmpresa;

SELECT idEmpresa, nomeFantasiaEmpresa, razaoSocialEmpresa, ufEmpresa, municipioEmpresa FROM empresa 
	WHERE ufEmpresa != 'MG';
 
-- Administrador
/*
Tabela Administrador

Contém:

- ID do Adm (idAdm)
- Nome do Adm (nomeAdm)
- E-mail do Adm (emailAdm)
- Hash da senha do Adm (hashSenhaAdm)
- Telefone de contato do Adm (telefoneAdm)
*/
CREATE TABLE adm (
	idAdm INT PRIMARY KEY AUTO_INCREMENT, -- ID do Adm
	nomeAdm VARCHAR (100), -- Nome do Adm
	emailAdm VARCHAR(80) UNIQUE, -- E-mail do Adm
	hashSenhaAdm VARCHAR(25), -- Hash da senha do Adm
	telefoneAdmin VARCHAR(11) -- Telefone de contato do Adm
);

DESC adm;

INSERT INTO adm VALUES 
(default, 'Romeu Alves' , 'romeu_almes@admin.com.br','Miner!#412$','11927329683');

SELECT nomeAdm AS nome, emailAdm AS Email, telefoneAdmin AS Contato FROM adm;

-- Sensores
/*
Tabela de Sensores

Contém:

- ID do Sensor (idSensor)
- Modelo do Sensor (modeloSensor)
- Modelo da Placa Arduino (placaSensor)
- Estado de funcionamento do Sensor (estadoSensor)
- Empresa que usa o Sensor (empresaSensor)
*/
CREATE TABLE sensor (
	idSensor INT PRIMARY KEY AUTO_INCREMENT, -- ID do Sensor
	modeloSensor VARCHAR(40) NOT NULL, -- Modelo do sensor
	placaSensor VARCHAR(40) NOT NULL, -- Modelo de placa do sensor
	estadoSensor TINYINT NOT NULL, -- Estado do sensor
		CONSTRAINT chkFuncionamento CHECK(estadoSensor IN(0, 1)), -- Regra para o estado do sensor (0 = Desligado/Reparo/Atualização e 1 = Funcionando)
	empresaSensor VARCHAR(60) -- Empresa que está usando o sensor
);

DESC sensor;

INSERT INTO sensor VALUES
(default, 'LM35','Arduino Uno R3' , 1, 'Prime Zone'),
(default,'DHT11','Arduino Uno R3',0, 'Santos Ores');

SELECT * FROM sensor;

-- Maquinários
/*
Tabela de maquinários

Contém: 

- ID do Maquinário (idMaquinario)
- Nome do Maquinário (nomeMaquinario)
- Modelo (modeloMaquinario)
- Responsável (responsavelMaquinario)
- Tempo de operação do maquinário (tempoOperacaoMaquinario)
- Status (statuss)
- Data de início de uso (dataInicio)
- Peso em toneladas de material descarregado (pesoDescarregado)
*/
CREATE TABLE maquinario (
	idMaquinario INT PRIMARY KEY AUTO_INCREMENT, -- ID da Máquina
	nomeMaquinario VARCHAR(50) NOT NULL, -- Nome da Máquina
	modeloMaquinario VARCHAR(30), -- Modelo da Máquina
	responsavelMaquinario VARCHAR(100) UNIQUE, -- Responsável pela Máquina
	tempoOperacaoMaquinario TIME, -- Tempo de Operação da Máquina
	statuss VARCHAR(50), -- Status da Máquina
		CONSTRAINT chkStatus CHECK(statuss IN('OPERANDO', 'MANUTENÇÃO','OBSOLETO')), -- Regra para status da Máquina
	dataInicio DATE NOT NULL, -- Data de Início de uso da Máquina
	pesoDescarregado DECIMAL(5,2) -- Peso em toneladas de material descarregado
);

DESC maquinario;

INSERT INTO maquinario VALUES
(default,'ESCAVADEIRA A CABO','FINTYUN','LUÃ CHAVES','00:02:12','OPERANDO','2025-08-27',000.00),
(default,'PA CARREGADEIRA','FURLAN','GABRIEL SENNA','49:06:35','OBSOLETO','2025-05-19',324.52),
(default,'BUCKET WHELL','SANDVIK','MATHEUS CAMPOS','19:26:51','OPERANDO','2025-07-30',000.00),
(default,'PA CARREGADEIRA','SANDVIK','LUIZ FELIPE','62:48:57','OPERANDO','2025-07-12',954.00),
(default,'ESCAVADEIRA DE ARRASTO','FINTYUN','MARLEY SANTOS','55:10:41','MANUTENCAO','2025-03-07',710.61);

SELECT * FROM maquinario;

SELECT * FROM maquinario ORDER BY modeloMaquinario DESC;

SELECT * FROM maquinario
		WHERE statuss LIKE 'OP%' AND pesoDescarregado >= 500;

-- Temperatura
CREATE TABLE temperaturas (
	idSensor INT PRIMARY KEY AUTO_INCREMENT,
	tempMax DECIMAL(5,2) NOT NULL, -- Temperatura do local
	tempMin DECIMAL(5,2) NOT NULL, 
	tempMedia DECIMAL(5,2) NOT NULL, 
	horaColeta DATETIME DEFAULT current_timestamp, -- Data e Hora da temperatura
	localColeta VARCHAR(100),
	qtdSensor INT,
	funcionamento TINYINT, -- Irá constar se o sensor está funcionando ou não, necessitando de reparos/atualizações ou não, 0 é quebrado/reparo/atualização e 1 é funcionando
		CONSTRAINT chkSituacao CHECK(funcionamento IN(0, 1)),
	empresaSensor VARCHAR(60) -- Cita a empresa cujo o sensor de tal modelo está lá sua quantidade
);

INSERT INTO temperaturas VALUES
(default, 35.45, 25.14, 30.54, default,'Vale do Jequitinhonha', 10 , 1, 'Santos Ores'),
(default, 33.01, 26.74 , 29.14, default, 'Valo do Tico-Tico',9,1,'Santos Ores'),
(default, 00.00 ,00.00,00.00,default,'',15,0,'Prime Zone');

DESC temperaturas;

SELECT * FROM temperaturas;

-- Projetos
CREATE TABLE projetos (
	idProjeto INT PRIMARY KEY AUTO_INCREMENT,
	nomeResponsavel VARCHAR(150),
	empresaProj VARCHAR(150),
	municipio VARCHAR(150),
	referencia VARCHAR(100),
	dtInicio DATETIME,
	previsao DATE
);

DESC projetos;

INSERT INTO projetos VALUES

(default,'Carlos Lacerda Silva', 'Rocha Silva' , 'Ouro Preto', 'Quadrilátero Ferrífero', '2025-08-17','2026-01-03'),
(default,'Diego Jota','Santos Ores SA','Brumadinho','Mina Tico-Tico','2025-09-01','2026-03-27'),
(default,'Diego Jota','Santos Ores SA','Niterói','Mina Morro Vermelho','2025-07-15','2025-12-13');

SELECT * FROM projetos;

SELECT * FROM projetos 
	WHERE dtInicio < '2026-01-01';


