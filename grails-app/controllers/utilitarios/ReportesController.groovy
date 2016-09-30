package utilitarios

import docentes.Periodo

class ReportesController {

    def dbConnectionService

    def index() { }

    def profesNoEvaluados () {

        println("params " + params)

        def periodo
        def cn = dbConnectionService.getConnection()
        def sql
        def tipo = params.tipo
        def titulo
        if(params.periodo){
            periodo = Periodo.get(params.periodo)
        }else{
            periodo = null
        }

        switch(tipo){
            case '1':
                sql = "select escldscr, profcdla, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                        "from dcta, mate, prof, crso, escl " +
                        "where dcta.prdo__id = '${periodo?.id}' and crso.crso__id = dcta.crso__id and prof.prof__id = dcta.prof__id and " +
                        "mate.mate__id = dcta.mate__id and prof.prof__id not in ( " +
                        "select prof__id from encu where prof__id is not null and prdo__id = '${periodo?.id}') and " +
                        "escl.escl__id = prof.escl__id " +
                        "order by escldscr, profapll, profnmbr"
                titulo = "Profesores que NO han sido evaluados por los alumnos"
                break;
             case '2':
                 sql = "select escldscr, profcdla, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                         "from dcta, mate, prof, crso, escl " +
                         "where dcta.prdo__id = '${periodo?.id}' and crso.crso__id = dcta.crso__id and prof.prof__id = dcta.prof__id and " +
                         "mate.mate__id = dcta.mate__id and prof.prof__id in ( " +
                         "select prof__id from encu where prof__id is not null and prdo__id = '${periodo?.id}') and " +
                         "escl.escl__id = prof.escl__id " +
                         "order by escldscr, profapll, profnmbr"
                 titulo = "Profesores que han sido evaluados por los alumnos"
                 break;
            case '3':
                sql = "select escldscr, profcdla, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                       "from dcta, mate, prof, crso, escl " +
                        "where dcta.prdo__id = '${periodo?.id}' and crso.crso__id = dcta.crso__id and prof.prof__id = dcta.prof__id and " +
                        "mate.mate__id = dcta.mate__id and prof.prof__id in ( " +
                        "select prof__id from encu where prof__id is not null and prdo__id = '${periodo?.id}' and teti__id = 1) and " +
                        "escl.escl__id = prof.escl__id " +
                        "order by escldscr, profapll, profnmbr"
                titulo = "Profesores que NO han realizado su autoevaluación"
                break;
            case '4':
                sql = "select escldscr, profcdla, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                        "from dcta, mate, prof, crso, escl " +
                        "where dcta.prdo__id = '${periodo?.id}' and crso.crso__id = dcta.crso__id and prof.prof__id = dcta.prof__id and " +
                        "mate.mate__id = dcta.mate__id and prof.prof__id not in ( " +
                        "select prof__id from encu where prof__id is not null and prdo__id = '${periodo?.id}' and teti__id = 1) and " +
                        "escl.escl__id = prof.escl__id " +
                        "order by escldscr, profapll, profnmbr"
                titulo = "Profesores que han realizado su autoevaluación"
                break;
            case '5':
                sql = "select escldscr, estdcdla, estdnmbr||' '||estdapll profesor, matedscr, crsodscr, dctaprll " +
                    "from dcta, mate, estd, crso, escl, matr " +
                    "where dcta.prdo__id = '${periodo?.id}' and crso.crso__id = dcta.crso__id and estd.estd__id = matr.estd__id and " +
                    "dcta.dcta__id = matr.dcta__id and " +
                    "mate.mate__id = dcta.mate__id and estd.estd__id in ( " +
                    "select estd__id from encu where estd__id is not null and prdo__id = '${periodo?.id}' and teti__id = 2) and " +
                    "escl.escl__id = mate.escl__id " +
                    "order by escldscr, estdapll, estdnmbr"
                titulo = "Estudiantes que han realizado la evaluación"
                break;
            case '6':
                sql = "select escldscr, estdcdla, estdnmbr||' '||estdapll profesor, matedscr, crsodscr, dctaprll " +
                        "from dcta, mate, estd, crso, escl, matr " +
                        "where dcta.prdo__id = '${periodo?.id}' and crso.crso__id = dcta.crso__id and estd.estd__id = matr.estd__id and " +
                        "dcta.dcta__id = matr.dcta__id and " +
                        "mate.mate__id = dcta.mate__id and estd.estd__id not in ( " +
                        "select estd__id from encu where estd__id is not null and prdo__id = '${periodo?.id}' and teti__id = 2) and " +
                        "escl.escl__id = mate.escl__id " +
                        "order by escldscr, estdapll, estdnmbr"
                titulo = "Estudiantes que no han realizado la evaluación"
                break;

        }


        def res = cn.rows(sql.toString());
        def escuelas = res.escldscr.unique()

//        println("escuelas " + escuelas)
//        println("sql " + sql)

        return [res: res, escuelas: escuelas, titulo: titulo]
    }

    def reportes () {

    }

    def periodo_ajax () {

    }
}
