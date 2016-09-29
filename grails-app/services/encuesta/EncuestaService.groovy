package encuesta

import docentes.Encuesta
import docentes.Periodo
import grails.transaction.Transactional

@Transactional
class EncuestaService {
    def dbConnectionService

    /** si el estudiante ha realizado ono la ponePregunta FE **/
    def periodActual() {
        def cn = dbConnectionService.getConnection()
        def rt = 0
        def tx = "select prdo__id from auxl"
        rt = cn.rows(tx.toString())[0].prdo__id
        cn.close()
        return Periodo.get(rt)
    }

    /** si el estudiante ha realizado ono la ponePregunta FE **/
    boolean factoresDeExito(estd, prdo) {
        def cn = dbConnectionService.getConnection()
        def rt = false
        def tx = "select count(*) cnta from encu, teti, tpen where prdo__id = ${prdo} and " +
                "estd__id = ${estd} and teti.teti__id = encu.teti__id and tpen.tpen__id = teti.tpen__id and " +
                "tpencdgo = 'FE' and encuetdo = 'C' and prdo__id = ${prdo} "
        try {
            rt = (cn.rows(tx.toString())[0].cnta > 0)
        }
        catch (e) {
            println e.getMessage()
        }
        cn.close()
        return rt
    }


    /**
     * Materrias en las que se ha matriculado el alumno
     * @return
     */
    def materias(estd, prdo) {
        def cn = dbConnectionService.getConnection()
        def tx = "select matedscr, matr.dcta__id from matr, dcta, mate " +
                "where prdo__id = ${prdo} and estd__id = '${estd}' and " +
                "dcta.dcta__id = matr.dcta__id and mate.mate__id = dcta.mate__id"
        def rg = []
//        println " a ejecutar: lstaMaterias:!!!  ${tx}"
        cn.eachRow(tx) { d ->
            rg.add([id: d.dcta__id, dscr: d.matedscr])
        }
        return rg
        cn.close()
    }

    def totalPreguntas(tpen) {
        def cn = dbConnectionService.getConnection()
        def tx = "select count(*) cnta from prte where tpen__id = $tpen"
        def cnta = cn.rows(tx.toString())[0]?.cnta  //retorna conteo
        return cnta
        cn.close()
    }

    def encuestaEnCurso(informante, tpif, tpen, estd=0, dcta=0, par=0, drtv=0, prdo){
//        println "encuestaEnCurso: $informante, $tpif, $tpen, $estd, $dcta, par: $par"
        def cn = dbConnectionService.getConnection()
        def tx = ""
        switch (tpen) {
            case 4: //FE
                tx = "select encu__id from encu, teti where prdo__id = ${prdo} and " +
                        "encu.estd__id = ${informante} and " +
                        "teti.teti__id = encu.teti__id and teti.tpen__id = $tpen and tpif__id = $tpif"
                break
            case 2: //DC
                tx = "select encu__id from encu, teti where prdo__id = ${prdo} and " +
                        "encu.estd__id = ${informante} and " +
                        "teti.teti__id = encu.teti__id and teti.tpen__id = $tpen and tpif__id = $tpif and " +
                        "estd__id = $informante and dcta__id = $dcta"
                break
            case 1: //AD
                tx = "select encu__id from encu, teti where prdo__id = ${prdo} and " +
                        "encu.prof__id = ${informante} and " +
                        "teti.teti__id = encu.teti__id and teti.tpen__id = $tpen and tpif__id = $tpif"
                break
            case 5: //PAR
                tx = "select encu__id from encu, teti where prdo__id = ${prdo} and " +
                        "encu.prof__id = ${informante} and " +
                        "teti.teti__id = encu.teti__id and teti.tpen__id = $tpen and tpif__id = $tpif and " +
                        "prof_par = $par"
                break
            case 3: //DI
                tx = "select encu__id from encu, teti where prdo__id = ${prdo} and " +
                        "encu.prof__id = ${informante} and " +
                        "teti.teti__id = encu.teti__id and teti.tpen__id = $tpen and tpif__id = $tpif and " +
                        "profdrtv = $drtv"
                break
            default:
                tx = "select 0"
        }
//        println "encuestaEnCurso sql: $tx"
        def encu__id = cn.rows(tx.toString())[0]?.encu__id
        cn.close()
        if(encu__id) {
            return Encuesta.get(encu__id)
        } else {
            return null
        }

    }

    def preguntaActual(encu) {
        def cn = dbConnectionService.getConnection()
        def tx = "select coalesce(max(prtenmro), 0) nmro from encu, dtec, prte " +
                "where encu.encu__id = $encu and dtec.encu__id = encu.encu__id and " +
                "prte.prte__id = dtec.prte__id"
//        println "seleccionaPregunta sql: $tx"
        def nmro = cn.rows(tx.toString())[0]?.nmro
        cn.close()
        nmro
    }

    def tipoPregunta(actual, tpen) {
        def cn = dbConnectionService.getConnection()
        // si es asignatura, debe tener es respuesta como alternativa
        def tx = "select rppg.rppg__id from prte, rppg, resp " +
                "where tpen__id = $tpen and prtenmro = $actual and rppg.preg__id = prte.preg__id and " +
                "resp.resp__id = rppg.resp__id and respcdgo = 'ASG'"
//        println "seleccionaPregunta sql: $tx"

        def rppg = cn.rows(tx.toString())[0]?.rppg__id
        if(rppg) {
            return "Asgn_${rppg}"
        } else {
            tx = "select count(*) cnta from prte, prit " +
                    "where tpen__id = $tpen and prtenmro = $actual and prit.preg__id = prte.preg__id"
//            println "seleccionaPregunta sql: $tx"
            def cnta = cn.rows(tx.toString())[0]?.cnta
            cn.close()
            if(cnta > 1) {
                return "Prit"
            } else {
                return "Normal"
            }
        }
    }


    def itemsPregunta(pregunta) {
        def cn = dbConnectionService.getConnection()
        def tx = "select prit__id id, pritdscr dscr from prte, prit " +
                "where prte.prte__id = $pregunta and prit.preg__id = prte.preg__id " +
                "order by prit__id * random()"
//        println "itemsPregunta sql: $tx"
        def resp = cn.rows(tx.toString())
        cn.close()
        resp
    }

    def poneFinalizado(encu) {
        def cn = dbConnectionService.getConnection()
        def tx = "update encu set encuetdo = 'C' where encu__id = $encu"
//        println "finalizaEncu: $tx"
        cn.execute(tx.toString())
    }

    def autoevaluacion(prof, prdo) {
        def cn = dbConnectionService.getConnection()
        def rt = false
        def tx = "select count(*) cnta from encu, teti, tpen where prdo__id = ${prdo} and " +
                "prof__id = ${prof} and " +
                "teti.teti__id = encu.teti__id and tpen.tpen__id = teti.tpen__id and tpencdgo = 'AD' and " +
                "encuetdo = 'C'"
        try {
            rt = (cn.rows(tx.toString())[0].cnta > 0)
        }
        catch (e) {
            println e.getMessage()
        }
        cn.close()
        rt
    }

    def esAsignatura(rppg) {
        def cn = dbConnectionService.getConnection()
        def rt = false
        def tx = "select resp__id from rppg where rppg__id = ${rppg}"
        try {
            rt = (cn.rows(tx.toString())[0].resp__id == 1)
        }
        catch (e) {
            println e.getMessage()
        }
        cn.close()
        rt
    }

}