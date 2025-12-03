var minaModel = require("../models/minaModel");

function buscarMinaPorEmpresa(req, res) {
  var id_empresa = req.params.empresaId;
  console.log("ESSE É OP ID DA EMPRES: ", id_empresa);


  minaModel.buscarMinaPorEmpresa(id_empresa).then((resultado) => {
    if (resultado.length > 0) {
      res.status(200).json(resultado);
    } else {
      res.status(204).send("ERRO NA VOLTA DO CONTROLLER");
    }
  }).catch(function (erro) {
    console.log(erro);
    console.log("Houve um erro ao buscar as minas: ", erro.sqlMessage);
    res.status(500).json(erro.sqlMessage);
  });
}


function cadastrar_mina(req, res) {
  var idEmpresa = req.body.idEmpresaServer
  var longitude = req.body.longitudeServer
  var latitude = req.body.latitudeServer
  var temperaturaAlerta = req.body.temperaturaAlertaServer

  if (idEmpresa == undefined) {
    res.status(400).send("idEmpresa está undefined!");
  } else if (longitude == undefined) {
    res.status(400).send("longitude está undefined!");
  } else if (latitude == undefined) {
    res.status(400).send("latitude está undefined!");
  } else if (temperaturaAlerta == undefined) {
    res.status(400).send("temperaturaAlerta está undefined!");
  } else {


    minaModel.cadastrar_mina(idEmpresa, longitude, latitude, temperaturaAlerta)
      .then((resultado) => {
        res.status(201).json(resultado);
        
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar o cadastro! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}
function cadastrar_sensores(req, res) {
  var fkMina = req.body.fkMinaServer

  if (fkMina == undefined) {
    res.status(400).send("ID da mina está undefined!");
  }  else {
    minaModel.cadastrar_sensores(fkMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar o cadastro! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}
function listar_sensores(req, res) {
  var fkMina = req.params.minaId
  if (fkMina == undefined) {
    res.status(400).send("ID da mina está undefined!");
  }  else {
    minaModel.listar_sensores(fkMina)
      .then((resultado) => {
        res.status(201).json(resultado);
        
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar o cadastro! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}
function buscar_kpi_qte_alertas_sensor(req, res) {
  var idSensor = req.params.idSensor
  var idMina = req.params.idMina
  if (idSensor == undefined) {
    res.status(400).send("ID do sensor está undefined!");
  }  else {
    minaModel.buscar_kpi_qte_alertas_sensor(idSensor, idMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela kpi_qte_alertas_sensor! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}
function buscar_kpi_sensor_mais_alertas(req, res) {
  var idMina = req.params.idMina
  if (idMina == undefined) {
    res.status(400).send("ID do sensor está undefined!");
  }  else {
    minaModel.buscar_kpi_sensor_mais_alertas(idMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela kpi_qte_alertas_sensor! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}
function buscar_kpi_temperatura_media(req, res) {
  var idMina = req.params.idMina
  if (idMina == undefined) {
    res.status(400).send("ID do sensor está undefined!");
  }  else {
    minaModel.buscar_kpi_temperatura_media(idMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela kpi_qte_alertas_sensor! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}
function buscar_kpi_produtividade_media(req, res) {
  var idMina = req.params.idMina
  if (idMina == undefined) {
    res.status(400).send("ID do sensor está undefined!");
  }  else {
    minaModel.buscar_kpi_produtividade_media(idMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela kpi_qte_alertas_sensor! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}

function obterDadosGraficoTemperaturaSensores(req, res) {
  var idMina = req.params.idMina
  if (idMina == undefined) {
    res.status(400).send("ID do sensor está undefined!");
  }  else {
    minaModel.obterDadosGraficoTemperaturaSensores(idMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela kpi_qte_alertas_sensor! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}





function obterDadosGraficoAlertasSensores(req, res) {
  var idMina = req.params.idMina
  if (idMina == undefined) {
    res.status(400).send("ID do sensor está undefined!");
  }  else {
    minaModel.obterDadosGraficoAlertasSensores(idMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela kpi_qte_alertas_sensor! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}


function obterDadosGraficoProducaoXTemperatura(req, res) {
  var idSensor = req.params.idSensor
  if (idSensor == undefined) {
    res.status(400).send("ID do sensor está undefined!");
  }  else {
    minaModel.obterDadosGraficoProducaoXTemperatura(idSensor)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela kpi_qte_alertas_sensor! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}
function obterDadosGraficoMinMedMax(req, res) {
  var idSensor = req.params.idSensor
  if (idSensor == undefined) {
    res.status(400).send("ID do sensor está undefined!");
  }  else {
    minaModel.obterDadosGraficoMinMedMax(idSensor)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela kpi_qte_alertas_sensor! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}


function grafico_producao_tempo_real(req, res) {
  var idMina = req.params.idMina
  if (idMina == undefined) {
    res.status(400).send("ID do mina está undefined!");
  }  else {
    minaModel.grafico_producao_tempo_real(idMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela grafico_producao_tempo_real! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}


function grafico_min_med_max(req, res) {
  var idMina = req.params.idMina
  if (idMina == undefined) {
    res.status(400).send("ID do mina está undefined!");
  }  else {
    minaModel.grafico_min_med_max(idMina)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar a buscar pela grafico_min_med_max! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}


module.exports = {
  buscarMinaPorEmpresa,
  cadastrar_mina,
  cadastrar_sensores,
  listar_sensores,
  buscar_kpi_qte_alertas_sensor,
  buscar_kpi_sensor_mais_alertas,
  buscar_kpi_temperatura_media,
  buscar_kpi_produtividade_media,
  obterDadosGraficoTemperaturaSensores,
  obterDadosGraficoAlertasSensores,
  obterDadosGraficoProducaoXTemperatura,
  obterDadosGraficoMinMedMax,
  grafico_producao_tempo_real,
  grafico_min_med_max
}
