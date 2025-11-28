// importa os bibliotecas necessários
const express = require('express');
const mysql = require('mysql2');

// constantes para configurações
const SERVIDOR_PORTA = 3300;

// habilita ou desabilita a inserção de dados no banco de dados
const HABILITAR_OPERACAO_INSERIR = true;

// função que simula dados do Arduino
async function simulador(
    valoresSensorAnalogico,
    valoresSensorDigital
) {

    // conexão com o banco de dados MySQL
    let poolBancoDados = mysql.createPool({
        host: 'localhost',
        user: 'aluno',
        password: 'Sptech#2024',
        database: 'termotech',
        port: 3307
    }).promise();

    console.log("Simulador iniciado. Gerando valores aleatórios...");

    // intervalo que simula envio do Arduino

    // gera valores aleatórios


    // insere no banco, se habilitado
    if (HABILITAR_OPERACAO_INSERIR) {
        var lista_empresa = await poolBancoDados.execute(
            'SELECT * FROM empresa'
        )

        var lista_empresa_formatada = lista_empresa[0]


        for (var i = 0; i < lista_empresa_formatada.length; i++) {
            var empresa_atual = lista_empresa_formatada[i];
            console.log("Empresa: ", empresa_atual);

            var id_empresa = empresa_atual.idEmpresa

            var lista_minas = await poolBancoDados.execute(
                `SELECT * FROM mina WHERE fkEmpresa = ${id_empresa}`
            )

            var lista_minas_formatada = lista_minas[0]
            console.log(lista_minas_formatada);

            for (var j = 0; j < lista_minas_formatada.length; j++) {
                var mina_atual = lista_minas_formatada[j];

                var id_mina = mina_atual.idMina
                var temperatura_alerta_mina = mina_atual.temperaturaAlerta

                var lista_sensores = await poolBancoDados.execute(
                    `SELECT * FROM sensor WHERE fkMina = ${id_mina}`
                )
                var lista_sensores_formatada = lista_sensores[0]
                console.log(lista_sensores_formatada);

                for (var k = 0; k < lista_sensores_formatada.length; k++) {
                    var sensor_atual = lista_sensores_formatada[k];

                    var id_sensor = sensor_atual.idSensor;
                    var temperatura = 30 +(Math.random() * (11) - 5)
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



            }




        }
    }
}



setInterval(() => {
    simulador()
}, 5000);

// função para criar e configurar o servidor web
function servidor(valoresSensorAnalogico, valoresSensorDigital) {
    const app = express();

    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });

    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API executada com sucesso na porta ${SERVIDOR_PORTA}`);
    });

    app.get('/sensores/analogico', (_, response) => {
        return response.json(valoresSensorAnalogico);
    });

    app.get('/sensores/digital', (_, response) => {
        return response.json(valoresSensorDigital);
    });
}

// função principal
(async () => {
    const valoresSensorAnalogico = [];
    const valoresSensorDigital = [];

    // inicia simulador ao invés da serial
    simulador(
        valoresSensorAnalogico,
        valoresSensorDigital
    );

    // inicia servidor
    servidor(
        valoresSensorAnalogico,
        valoresSensorDigital
    );
})();

