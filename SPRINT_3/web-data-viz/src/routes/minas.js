var express = require("express");
var router = express.Router();

var minasController = require("../controllers/minaController");

router.get("/listar_minas/:empresaId", function (req, res) {
  minasController.buscarMinaPorEmpresa(req, res);
});

router.post("/cadastrar", function (req, res) {
  minasController.cadastrar_mina(req, res);
})
router.post("/cadastrar_sensores", function (req, res) {
  minasController.cadastrar_sensores(req, res);
})

router.get("/listar_sensores/:minaId", function (req, res) {
  minasController.listar_sensores(req, res);
});
router.get("/buscar_kpi_qte_alertas_sensor/:idSensor/:idMina", function (req, res) {
  minasController.buscar_kpi_qte_alertas_sensor(req, res);
});
router.get("/buscar_kpi_sensor_mais_alertas/:idMina", function (req, res) {
  minasController.buscar_kpi_sensor_mais_alertas(req, res);
});
router.get("/buscar_kpi_temperatura_media/:idMina", function (req, res) {
  minasController.buscar_kpi_temperatura_media(req, res);
});
router.get("/buscar_kpi_produtividade_media/:idMina", function (req, res) {
  minasController.buscar_kpi_produtividade_media(req, res);
});
router.get("/obterDadosGraficoTemperaturaSensores/:idMina", function (req, res) {
  minasController.obterDadosGraficoTemperaturaSensores(req, res);
});
router.get("/obterDadosGraficoAlertasSensores/:idMina", function (req, res) {
  minasController.obterDadosGraficoAlertasSensores(req, res);
});
router.get("/obterDadosGraficoProducaoXTemperatura/:idSensor", function (req, res) {
  minasController.obterDadosGraficoProducaoXTemperatura(req, res);
});

router.get("/obterDadosGraficoMinMedMax/:idSensor", function (req, res) {
  minasController.obterDadosGraficoMinMedMax(req, res);
});
module.exports = router;