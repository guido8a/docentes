package utilitarios

class ReportesController {

    def dbConnectionService

    def index() { }

    def profesNoEvaluados () {

        def cn = dbConnectionService.getConnection()

        def sql = "select profcdla, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                "from dcta, mate, prof, crso " +
                "where dcta.prdo__id = 1 and crso.crso__id = dcta.crso__id and prof.prof__id = dcta.prof__id and " +
                "mate.mate__id = dcta.mate__id and prof.prof__id not in ( " +
                "select prof__id from encu where prof__id is not null)"

        def res = cn.rows(sql.toString());

//        println("sql " + sql)

        return [res: res]
    }

    def reportes () {

    }
}
