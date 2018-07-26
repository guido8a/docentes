package utilitarios

import docentes.Facultad
import docentes.Periodo

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

        def subtitulo = ''
        def pattern1 = "###.##%"

        sql = "select count(*) cnta, clase from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' " +
                "group by clase order by clase"
        println "sql: $sql"
        cn.eachRow(sql.toString()) { d ->
            data[d.clase] = d.cnta
        }

        sql = "select count(*) cnta, clase from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' " +
                "group by clase order by clase"
        println "sql: $sql"
        cn.eachRow(sql.toString()) { d ->
            data[d.clase] = d.cnta
        }
        println "data: $data"
        subtitulo = "PROFESORES POR DESEMPEÑO"
        render "${data.A?:0}_${data.B?:0}_${data.C?:0}_${facultad}_${data.C?:0}_${data.A?:0}_RECOMENDACIONES"
    }

    def tabla_ajax () {
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

        sql = "select count(*) cnta, clase from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' " +
                "group by clase order by clase"
        cn.eachRow(sql.toString()) { d ->
            data[d.clase] = d.cnta
        }

        sql = "select count(*) cnta, clase from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and facl__id::varchar ilike '${facultadId}' " +
                "group by clase order by clase"
        cn.eachRow(sql.toString()) { d ->
            data[d.clase] = d.cnta
        }

        return[data: data]
    }
}
