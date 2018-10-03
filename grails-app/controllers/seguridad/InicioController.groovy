package seguridad

import docentes.Universidad

class InicioController extends seguridad.Shield {
    def dbConnectionService
//    def diasLaborablesService

    def index() {
        def cn = dbConnectionService.getConnection()
        def prms = []
        def ctrl = "'Pregunta', 'Profesor', 'Estudiante', 'Procesos', 'Reportes'"
        def acciones = "'list', 'cargarDatos', 'reportesEvaluacion', 'reportes'"
        def tx = "select ctrlnmbr||'_'||accnnmbr accion from prms, accn, ctrl " +
                "where prfl__id = ${Prfl.findByNombre(session.perfil.toString()).id} and " +
                "accn.accn__id = prms.accn__id and ctrl.ctrl__id = accn.ctrl__id and " +
                "ctrlnmbr in (${ctrl}) and accnnmbr in (${acciones})"
        println "$tx"
        cn.eachRow(tx) { d ->
            prms << d.accion
        }
        cn.close()
        def univ = Universidad.get(session.usuario.universidad.id)

        println "prms: $prms"
        /* define urls */
        def m_preg, m_prof, m_estd, m_proc, m_rprt, m_prcs, m_eval
        m_preg = prms.contains("Pregunta_list")? g.createLink(controller:"pregunta", action:"list") : "#"
        m_prof = prms.contains("Profesor_list")? g.createLink(controller:"profesor", action:"list") : "#"
        m_estd = prms.contains("Estudiante_list")? g.createLink(controller:"estudiante", action:"list") : "#"
        m_prcs = prms.contains("Procesos_cargarDatos")? g.createLink(controller:"procesos", action:"cargarDatos") : "#"
        m_rprt = prms.contains("Reportes_reportes")? g.createLink(controller:"reportes", action:"reportes") : "#"
        m_eval = prms.contains("Reportes_reportesEvaluacion")? g.createLink(controller:"reportes", action:"reportesEvaluacion") : "#"

        m_rprt = m_rprt == '#'? m_eval : m_rprt    /* pone el reporte que le corresponde */

//        return [prms: prms, empr: empr]
        return [m_preg: m_preg, m_prof: m_prof, m_estd: m_estd, m_prcs: m_prcs, m_rprt: m_rprt, univ: univ]

    }

    def parametros = {

        if (session.usuario.puedeAdmin) {
            return []
        } else {
            flash.message = "Está tratando de ingresar a un pantalla restringida para su perfil. Está acción será registrada."
            response.sendError(403)
        }
    }
}
