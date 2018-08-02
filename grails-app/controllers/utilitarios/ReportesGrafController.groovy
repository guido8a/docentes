package utilitarios

import docentes.Escuela
import docentes.Facultad
import docentes.Periodo
import docentes.Profesor
import docentes.ReporteEncuesta
import grails.converters.JSON
import groovy.json.JsonBuilder

class ReportesGrafController extends seguridad.Shield  {
    def dbConnectionService

    def index() {
    }

    def clasificar() {
//        println "clasificar $params"
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
//        println "sql: $sql"
        cn.eachRow(sql.toString()) { d ->
            data[d.clase] = d.cnta
            totl += d.cnta
        }

        sql = "select count(distinct (rpec.prof__id,dcta__id)) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' and con_rcmn > 0 and tpen__id = 2"
//        println "sql: $sql"
        rcmn = cn.rows(sql.toString())[0].cnta
//        println "data: $data, rc: $rcmn, totl: $totl"
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
//        println "estrategiaData $params"
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
//        println "sql: $sql"
        data.promedio = cn.rows(sql.toString())[0].prom * 100

        sql = "select count(prof.prof__id) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' and " +
                "prdo__id = ${params.prdo} and tpen__id = 2 "
//        println "sql prof: $sql"
        data.prof = cn.rows(sql.toString())[0].cnta

        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "facl__id::varchar ilike '${facultadId}' and tndn.prdo__id = ${params.prdo} and tndnptnv > 0 and " +
                "tpen__id = 2"
//        println "sql ptnv: $sql"
        data.ptnv = cn.rows(sql.toString())[0].cnta / data.prof * 100

        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "facl__id::varchar ilike '${facultadId}' and tndn.prdo__id = ${params.prdo} and tndnccbb > 0 and " +
                "tpen__id = 2"
//        println "sql ccbb: $sql"
        data.ccbb = cn.rows(sql.toString())[0].cnta / data.prof * 100

        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "facl__id::varchar ilike '${facultadId}' and tndn.prdo__id = ${params.prdo} and tndnfcex > 0 and " +
                "tpen__id = 2"
//        println "sql fcex: $sql"
        data.fcex = cn.rows(sql.toString())[0].cnta / data.prof * 100

        sql = "select count(*) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' and " +
                "con_rcmn > 0 and tpen__id = 2 and prdo__id = ${params.prdo}"
//        println "sql rcmn: $sql"
        data.rcmn = cn.rows(sql.toString())[0].cnta / data.prof * 100

//        println "data: $data"
//        println "data: ${data as JSON}"

        render data as JSON
    }

    def tipoEncuesta() {

    }

    def tipoEncuestaData() {
//        println "tipoEncuestaData $params"
        def cn = dbConnectionService.getConnection()
        def sql
        def data = [:]

        sql = "select avg(promedio)::numeric(5,2) prom, rpec.tpen__id, tpendscr, facl.facl__id, facldscr " +
                "from rpec, prof, escl, facl, tpen " +
                "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
                "facl.facl__id = escl.facl__id and rpec.tpen__id in (1,2,3,5) and prdo__id = ${params.prdo} and " +
                "tpen.tpen__id = rpec.tpen__id " +
                "group by rpec.tpen__id, facldscr, facl.facl__id, tpendscr order by facl.facl__id, tpendscr, rpec.tpen__id"
//        println "sql: $sql"
        def datos = cn.rows(sql.toString())
//        println datos
        def txto = ""
        def tx = ""
        def te = ""
        def facl = datos.facl__id.unique()
        def facultades = datos.facldscr.unique()
        def tpen = datos.tpen__id.unique()
//        println "facl: $facl"
//        println "tpen: $tpen"
        for(i in tpen) {
            for(j in facl) {
                te = "${datos.find{it.tpen__id == i}.tpendscr}"
                tx = "${datos.find{it.facl__id == j && it.tpen__id == i}?.prom?:0}"
                txto += txto? "_$tx" : tx
            }
            data[i] = [tpen: te, valor: txto]
            txto = ""
        }

//        println "datos: ${data as JSON}"

        /* se envía el mapa como objeto JSON */
        def respuesta = "${facultades.join('_')}||${data as JSON}"
//        println respuesta
//        render data as JSON
        render respuesta
    }

    def variables() {

    }

    def variablesData() {
//        println "variablesData $params"
        def cn = dbConnectionService.getConnection()
        def sql
        def data = [:]

        sql = "select avg(ddsc)::numeric(5,2) ddsc, avg(ddac)::numeric(5,2) ddac, avg(ddhd)::numeric(5,2) ddhd, " +
                "avg(ddci)::numeric(5,2) ddci, avg(dcni)::numeric(5,2) dcni, avg(d_ea)::numeric(5,2) d_ea, " +
                "facl.facl__id, facldscr " +
                "from rpec, prof, escl, facl " +
                "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
                "facl.facl__id = escl.facl__id and rpec.tpen__id = 8 and prdo__id = ${params.prdo} " +
                "group by facldscr, facl.facl__id order by facl.facl__id"
//        println "sql: $sql"
        def datos = cn.rows(sql.toString())
//        println datos
        def txto = ""
        def tx_ddsc, tx_ddac, tx_ddhd, tx_ddci, tx_dcni, tx_d_ea
        def tx_1, tx_2, tx_3, tx_4, tx_5, tx_6
        tx_1 = ""; tx_2 = ""; tx_3 = ""; tx_4 = ""; tx_5 = ""; tx_6 = "";
        def facl = datos.facl__id.unique()
        def facultades = datos.facldscr.unique()

//        sql = "select vrblcdgo||': '||vrbldscr from vrbl order by vrblordn "
//        def variables = cn.rows(sql.toString())

//        println "facl: $facl"
//        println "tpen: $tpen"

        for(j in facl) {
            tx_ddsc = "${datos.find{it.facl__id == j}?.ddsc?:0}"
            tx_ddac = "${datos.find{it.facl__id == j}?.ddac?:0}"
            tx_ddhd = "${datos.find{it.facl__id == j}?.ddhd?:0}"
            tx_ddci = "${datos.find{it.facl__id == j}?.ddci?:0}"
            tx_dcni = "${datos.find{it.facl__id == j}?.dcni?:0}"
            tx_d_ea = "${datos.find{it.facl__id == j}?.d_ea?:0}"
            tx_1 += tx_1? "_$tx_ddsc" : tx_ddsc
            tx_2 += tx_2? "_$tx_ddac" : tx_ddac
            tx_3 += tx_3? "_$tx_ddhd" : tx_ddhd
            tx_4 += tx_4? "_$tx_ddci" : tx_ddci
            tx_5 += tx_5? "_$tx_dcni" : tx_dcni
            tx_6 += tx_6? "_$tx_d_ea" : tx_d_ea
        }

        data[1] = [vrbl: 'DSC', valor: tx_1]
        data[2] = [vrbl: 'DAC', valor: tx_2]
        data[3] = [vrbl: 'DHD', valor: tx_3]
        data[4] = [vrbl: 'DCI', valor: tx_4]
        data[5] = [vrbl: 'CNI', valor: tx_5]
        data[6] = [vrbl: 'EA', valor: tx_6]

//        println "datos: ${data as JSON}"

        /* se envía el mapa como objeto JSON */
        def respuesta = "${facultades.join('_')}||${data as JSON}"
//        println respuesta
        render respuesta
    }


}
