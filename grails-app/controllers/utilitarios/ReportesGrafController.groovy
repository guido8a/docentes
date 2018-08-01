package utilitarios

import docentes.Escuela
import docentes.Facultad
import docentes.Periodo
import docentes.Profesor
import docentes.ReporteEncuesta
import grails.converters.JSON

class ReportesGrafController {
    def dbConnectionService

    def index() {
    }

    def clasificar() {
        println "clasificar $params"
        def cn = dbConnectionService.getConnection()

        def periodo = Periodo.get(params.periodo)
        def facultad
        def facultadId
        if(params.facl.toInteger()) {
            facultad = Facultad.get(params.facl).nombre
            facultadId = "${params.facl}"
        } else {
            facultad = "Todas las Facultades"
            facultadId = "%"
        }

        def sql
        def data = [:]
        def rcmn = 0
        def totl = 0

        def subtitulo = ''
        def pattern1 = "###.##%"

        sql = "select count(distinct (rpec.prof__id, dcta__id)) cnta, clase from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' and tpen__id = 2" +
                "group by clase order by clase"
        println "sql: $sql"
        cn.eachRow(sql.toString()) { d ->
            data[d.clase] = d.cnta
            totl += d.cnta
        }

        sql = "select count(distinct (rpec.prof__id,dcta__id)) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' and con_rcmn > 0 and tpen__id = 2"
        println "sql: $sql"
        rcmn = cn.rows(sql.toString())[0].cnta
        println "data: $data, rc: $rcmn, totl: $totl"
        subtitulo = "PROFESORES POR DESEMPEÑO"
        render "${data.A?:0}_${data.B?:0}_${data.C?:0}_${facultad}_${rcmn}_${totl-rcmn}_RECOMENDACIONES"
    }

    def dialogo_ajax () {

//        println("entro " + params)

        def periodo = Periodo.get(params.periodo)
        def facultad
        def facultadId
        def cn = dbConnectionService.getConnection()
        def res
        def sql

        if(params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = "Todas las Facultades"
            facultadId = "%"
        }


        if(params.tipo == '1'){
            sql = "select escldscr, profnmbr, profapll, proftitl, dctaprll, matedscr, clase " +
                    "from rpec, prof, escl, dcta, mate " +
                    "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
                    "facl__id::varchar ilike '${facultadId}' and dcta.dcta__id = rpec.dcta__id and " +
                    "mate.mate__id = dcta.mate__id and clase = '${params.etiqueta}' and rpec.prdo__id = ${periodo.id} and " +
                    "tpen__id = 2 " +
                    "group by escldscr, profnmbr, profapll, proftitl, dctaprll, matedscr, clase " +
                    "order by clase"
        }else{
            sql = "select rpec.prof__id, dctaprll, matedscr, escldscr, " +
                    "prof.prof__id, profnmbr, profapll from rpec, " +
                    "prof, escl, mate, dcta where prof.prof__id = rpec.prof__id " +
                    "and escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' " +
                    "and con_rcmn > 0 and tpen__id = 2 and dcta.dcta__id = rpec.dcta__id " +
                    "and mate.mate__id = dcta.mate__id group by rpec.prof__id, prof.prof__id, dctaprll, profnmbr, profapll, matedscr, escldscr;"
        }

        res = cn.rows(sql.toString())

        return [indice: params.indice, etiqueta: params.etiqueta, valor: params.valor, profesores: res, tipo: params.tipo]

    }


    def estrategias() {

    }

    def estrategiaData() {
        println "estrategiaData $params"
        def cn = dbConnectionService.getConnection()

        def periodo = Periodo.get(params.periodo)
        def facultad
        def facultadId
        if(params.facl.toInteger()) {
            facultad = Facultad.get(params.facl).nombre
            facultadId = "${params.facl}"
        } else {
            facultad = "Todas las Facultades"
            facultadId = "%"
        }

        def sql
        def data = [:]
        data.facultad = facultad

        sql = "select avg(promedio) prom from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' and " +
                "tpen__id = 2 and prdo__id = ${params.prdo}"
        println "sql: $sql"
        data.promedio = cn.rows(sql.toString())[0].prom * 100

        sql = "select count(prof.prof__id) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' and " +
                "prdo__id = ${params.prdo} and tpen__id = 2 "
        println "sql prof: $sql"
        data.prof = cn.rows(sql.toString())[0].cnta

        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "facl__id::varchar ilike '${facultadId}' and tndn.prdo__id = ${params.prdo} and tndnptnv > 0 and " +
                "tpen__id = 2"
        println "sql ptnv: $sql"
        data.ptnv = cn.rows(sql.toString())[0].cnta / data.prof * 100

        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "facl__id::varchar ilike '${facultadId}' and tndn.prdo__id = ${params.prdo} and tndnccbb > 0 and " +
                "tpen__id = 2"
        println "sql ccbb: $sql"
        data.ccbb = cn.rows(sql.toString())[0].cnta / data.prof * 100

        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "facl__id::varchar ilike '${facultadId}' and tndn.prdo__id = ${params.prdo} and tndnfcex > 0 and " +
                "tpen__id = 2"
        println "sql fcex: $sql"
        data.fcex = cn.rows(sql.toString())[0].cnta / data.prof * 100

        sql = "select count(*) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' and " +
                "con_rcmn > 0 and tpen__id = 2 and prdo__id = ${params.prdo}"
        println "sql rcmn: $sql"
        data.rcmn = cn.rows(sql.toString())[0].cnta / data.prof * 100

        println "data: $data"

        def datos = data

        /* se envía el mapa como objeto JSON */
        render datos as JSON
    }

    def resultados() {

    }

    def resultadosData() {
        println "estrategiaData $params"
        def cn = dbConnectionService.getConnection()

        def periodo = Periodo.get(params.periodo)

        def sql
        def data = [:]
        def facultades = []
//        def matriz = []
        def fila = []

        sql = "select avg(promedio)::numeric(5,2) prom, tpen__id, facl.facl__id, facldscr from rpec, prof, escl, facl " +
                "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
                "facl.facl__id = escl.facl__id and tpen__id in (1,2,3,5) and prdo__id = ${params.prdo} " +
                "group by tpen__id, facldscr, facl.facl__id order by facl.facl__id, facldscr, tpen__id"
        println "sql: $sql"
        def datos = cn.rows(sql.toString())
        println datos
        def txto = ""
        def tx = ""
        def fc = ""
        def facl = datos.facl__id.unique()
        def tpen = datos.tpen__id.unique()
        for(i in facl) {
            for(j in tpen) {
                fc = "${datos.find{it.facl__id == i}.facldscr}"
                tx = "${datos.find{it.facl__id == i && it.tpen__id == j}?.prom?:0}"
                txto += txto? "_$tx" : tx
            }
            facultades.add(fc)
            fila.add(txto)
//            data[i] = [fc, txto]
//            matriz.add([i, fc, txto])
            txto = ""
        }

//        println "matriz: ${matriz.join('_')}"

        data.cnta = facultades.size()
        data.facl = facultades.join("_")
        data.vlor = fila.join("_")

        println "data: $data"

        /* se envía el mapa como objeto JSON */
        render data as JSON
//        render matriz.join("_")
    }



}
