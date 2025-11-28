
// importa os bibliotecas necessários
const serialport = require('serialport');
const express = require('express');
const mysql = require('mysql2');

// constantes para configurações
const SERIAL_BAUD_RATE = 9600;
const SERVIDOR_PORTA = 3300;

// habilita ou desabilita a inserção de dados no banco de dados
const HABILITAR_OPERACAO_INSERIR = true;

// função para comunicação serial
const serial = async (
    valoresSensorAnalogico,
    valoresSensorDigital,
) => {

    // conexão com o banco de dados MySQL
    let poolBancoDados = mysql.createPool(
        {
            host: 'localhost',
            user: 'aluno', // NAO USAR O ROOT, CRIAR UM USUARIO
            password: 'Sptech#2024',
            database: 'termotech',
            port: 3307
        }
    ).promise();

    // lista as portas seriais disponíveis e procura pelo Arduino
    const portas = await serialport.SerialPort.list();
    const portaArduino = portas.find((porta) => porta.vendorId == 2341 && porta.productId == 43);
    if (!portaArduino) {
        throw new Error('O arduino não foi encontrado em nenhuma porta serial');
    }

    // configura a porta serial com o baud rate especificado
    const arduino = new serialport.SerialPort(
        {
            path: portaArduino.path,
            baudRate: SERIAL_BAUD_RATE
        }
    );

    // evento quando a porta serial é aberta
    arduino.on('open', () => {
        console.log(`A leitura do arduino foi iniciada na porta ${portaArduino.path} utilizando Baud Rate de ${SERIAL_BAUD_RATE}`);
    });

    // processa os dados recebidos do Arduino
    arduino.pipe(new serialport.ReadlineParser({ delimiter: '\r\n' })).on('data', async (data) => {
        console.log(data);
        // const agora = new Date();
        // const horaFormatada = agora.toISOString().slice(0,19).replace('T', ' ');
        // ADICIONAR A DATA E HORARIO PELO JAVASCRIPT!!!

        // armazena os valores dos sensores nos arrays correspondentes

        // insere os dados no banco de dados (se habilitado)
        if (HABILITAR_OPERACAO_INSERIR) {
            var lista_empresa = await poolBancoDados.execute(
                'SELECT * FROM empresa'
            )

            var lista_empresa_formatada = lista_empresa[0]

            if (lista_empresa_formatada.length > 0) {
                for (var i = 0; i < lista_empresa_formatada.length; i++) {
                    var empresa_atual = lista_empresa_formatada[i];
                    console.log("Empresa: ", empresa_atual);

                    var id_empresa = empresa_atual.idEmpresa

                    var lista_minas = await poolBancoDados.execute(
                        `SELECT * FROM mina WHERE fkEmpresa = ${id_empresa}`
                    )

                    var lista_minas_formatada = lista_minas[0]
                    console.log(lista_minas_formatada);
                    if (lista_minas_formatada.length > 0) {
                        for (var j = 0; j < lista_minas_formatada.length; j++) {
                            var mina_atual = lista_minas_formatada[j];

                            var id_mina = mina_atual.idMina
                            var temperatura_alerta_mina = mina_atual.temperaturaAlerta

                            var lista_sensores = await poolBancoDados.execute(
                                `SELECT * FROM sensor WHERE fkMina = ${id_mina}`
                            )
                            var lista_sensores_formatada = lista_sensores[0]
                            console.log(lista_sensores_formatada);
                            if (lista_sensores_formatada.length > 0) {
                                for (var k = 0; k < lista_sensores_formatada.length; k++) {
                                    var sensor_atual = lista_sensores_formatada[k];

                                    var id_sensor = sensor_atual.idSensor;
                                    var temperatura = data * (Math.random() * 10)
                                    
                                    console.log(temperatura);

                                    var alerta = 0
                                    if (temperatura >= temperatura_alerta_mina) {
                                        alerta = 1
                                    }

                                    await poolBancoDados.execute(
                                        `INSERT INTO coletaDados (fkSensor, temperatura, alerta) VALUES (?,?,?)`,
                                        [id_sensor, temperatura, alerta]
                                    )
                                }
                            } else {
                                break
                            }

                        }
                    } else {
                        break
                    }

                }
            }
        }

    });

    // evento para lidar com erros na comunicação serial
    arduino.on('error', (mensagem) => {
        console.error(`Erro no arduino (Mensagem: ${mensagem}`)
    });
}

// função para criar e configurar o servidor web
const servidor = (
    valoresSensorAnalogico,
    valoresSensorDigital
) => {
    const app = express();

    // configurações de requisição e resposta
    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });

    // inicia o servidor na porta especificada
    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API executada com sucesso na porta ${SERVIDOR_PORTA}`);
    });

    // define os endpoints da API para cada tipo de sensor
    app.get('/sensores/analogico', (_, response) => {
        return response.json(valoresSensorAnalogico);
    });
    app.get('/sensores/digital', (_, response) => {
        return response.json(valoresSensorDigital);
    });
}

// função principal assíncrona para iniciar a comunicação serial e o servidor web
(async () => {
    // arrays para armazenar os valores dos sensores
    const valoresSensorAnalogico = [];
    const valoresSensorDigital = [];

    // inicia a comunicação serial
    await serial(
        valoresSensorAnalogico,
        valoresSensorDigital
    );

    // inicia o servidor web
    servidor(
        valoresSensorAnalogico,
        valoresSensorDigital
    );
})();