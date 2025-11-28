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

module.exports = {
  buscarMinaPorEmpresa,
  cadastrar_mina
}