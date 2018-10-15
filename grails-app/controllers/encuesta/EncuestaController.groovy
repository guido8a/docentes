package encuesta

import docentes.Dictan
import docentes.Encuesta
import docentes.Estudiante
import docentes.Periodo
import docentes.Profesor
import docentes.Teti
import docentes.TipoEncuesta
import docentes.TipoInformante
import docentes.Universidad
import groovy.time.TimeCategory

class EncuestaController {
    def encuestaService
    def dbConnectionService

    def beforeInterceptor = [action: this.&auth, except: ['inicio', 'ingreso']]

    private auth() {
        if (!session.informanteId) {
//            println"............------------"
            flash.message = 'Usted ha permanecido demasiado tiempo inactivo por lo que debe volver a ejecutar la Encuesta'
            render "<script type='text/javascript'> window.location.href = '${createLink(action:'inicio')}' </script>"
//            redirect(action: 'inicio')
            return false
        }
    }

    def index() {
        redirect (action: "inicio", params: params)
    }

    def inicio() {
        if(session.informanteId) session.invalidate()

    }

    def ingreso() {
        println "ingreso: $params"
        session.tipoPersona = params.tipo

        if(!params.cdla) {
            redirect(action: "inicio", params: params)
            return
        }

/*
        session.periodo = encuestaService.periodActual()
        if(!session.periodo) {
            flash.message = "No se ha definido un periodo de evaluación"
            redirect(action: "inicio", params: params)
            return
        }
*/

        if (params.tipo == 'E') {
//            session.modulo = "prof" //??
            if ((existeEstudiante(params.cdla))) {
                redirect(action: "previa", params: params)
                return
            } else {
//                println "---------------- No matriculado"
                flash.message = "El número de cédula proporcionado no se halla registrado en el sistema, como matriculado en alguna materia"
                redirect(action: "inicio", params: params)
            }
        } else if (params.tipo == 'P') {
            if (existeProfesor(params.cdla)) {
                println "si existe profesor"
                redirect(action: "previaDc", params: params)
                return
            } else {
                flash.message = "Usted no está registrado en el sistema como Docente"
                redirect(action: "inicio", params: params)
                return
            }

        }
    }

    /**
     * Si es estudiante muestra Iniciar Evaluación (ponePregunta FE) o tabla de materias para evaluar
     */
    def previa() {
        if(session?.tipoEncuesta?.codigo in ['PR', 'DI', 'AD']){
            redirect action: 'previaDc'
            return
        }
        def cn = dbConnectionService.getConnection()
        def tx = ""
        def univ = Universidad.get(session.univ)
        def logo = g.resource(dir: 'images/univ', file: univ.logo, absolute: true)
        session.encuesta = 0
        println "universidad: ${logo}"
//        println "ponePregunta tipo: ${session.tipoPersona}, ponePregunta: ${session.encuesta}, params: $params, id: ${session.informanteId}, pr: ${session.periodo.id}"

        if(encuestaService.factoresDeExito(session.informanteId, session.prdo)) { //si ya se ha completado FE muestra materias
//            println "ya completo FE"
            def matr
            tx = "select matr.dcta__id, matedscr, profnmbr||' ' ||profapll profesor, crsodscr, dctaprll, prof.prof__id " +
                    "from matr, dcta, crso, mate, prof " +
                    "where prdo__id = ${session.prdo} and dcta.dcta__id = matr.dcta__id and " +
                    "crso.crso__id = dcta.crso__id and " +
                    "mate.mate__id = dcta.mate__id and prof.prof__id = dcta.prof__id and " +
                    "estd__id = ${session.informanteId} and dcta.dcta__id not in " +
                    "(select dcta__id from encu where estd__id = ${session.informanteId} and dcta__id is not null and " +
                    "encuetdo = 'C' and prdo__id = ${session.prdo} ) order by profnmbr"
            println "previa: $tx"
            matr = cn.rows(tx.toString())
            println "matr: $matr, logo: $logo, universidad: ${univ.nombre}"
            [matr: matr, logo: logo, universidad: univ.nombre]
        } else {
            [logo: logo, universidad: univ.nombre]
        }
    }

    /**
     * Pantalla para autoevaluación de profesores
     */
    def previaAd() {
        def cn = dbConnectionService.getConnection()
        def tx = ""
        def univ = Universidad.get(session.univ)
        def logo = g.resource(dir: 'images/univ', file: univ.logo, absolute: true)
        session.encuesta = 0

        def matr
        tx = "select dcta.dcta__id, matedscr, profnmbr||' ' ||profapll profesor, crsodscr, dctaprll, prof.prof__id " +
                    "from dcta, crso, mate, prof " +
                    "where prdo__id = ${session.prdo} and " +
                    "crso.crso__id = dcta.crso__id and " +
                    "mate.mate__id = dcta.mate__id and prof.prof__id = dcta.prof__id and " +
                    "dcta.prof__id = ${session.informanteId} and dcta.dcta__id not in " +
                    "(select dcta__id from encu where prof__id = ${session.informanteId} and dcta__id is not null and " +
                    "encuetdo = 'C' and prdo__id = ${session.prdo} and teti__id = 1) order by profnmbr"
            println "previa: $tx"
            matr = cn.rows(tx.toString())
            [matr: matr, logo: logo, universidad: univ.nombre]
    }

    /**
     * Muestra todas las opciones: Autoevaluación y Evaluación por Pares si es par o no lo ha hecho, o lista de profesores para evaluar Pares o Directivos
     */
    def previaDc() {
        def cn = dbConnectionService.getConnection()
        def tx = ""
        def univ = Universidad.get(session.univ)
        def logo = g.resource(dir: 'images/univ', file: univ.logo, absolute: true)
        session.encuesta = 0
        def auto = encuestaService.autoevaluacion(session.informanteId, session.prdo)
        println "auto: $auto, periodo: ${session.prdo}, univ: ${session.univ}"
        [auto: auto, pares: session.par, drtv: session.directivo, logo: logo, universidad: univ.nombre]

    }


    def encuestaFE() {
        println("entro encuesta FE" + params)
        //encuesta(tpen__id, tpif__id, prof__id, dcta__id)
        encuesta(4, 1, 0, 0, 0)
    }

    def encuestaDC() {
//        println "encuestaDC $params"
        //encuesta(tpen__id, tpif__id, prof__id, dcta__id)
        encuesta(2, 1, params.prof__id, params.dcta__id, 0)
    }

    def encuestaAD() {
//        println "encuestaAD $params, tipo: ${session.tipoPersona}, prof: ${session.informanteId}"
        //encuesta(tpen__id, tpif__id, prof__id, dcta__id, profeval)
        encuesta(1, 2, params.prof__id, params.dcta__id, 0)  //1: estudiante, 2: profesor
    }

    def encuestaPR() {
//        println "encuestaPR $params, tipo: ${session.tipoPersona}, prof: ${session.informanteId}"
        //encuesta(tpen__id, tpif__id, prof__id, dcta__id, profeval)
        encuesta(5, 2, session.informanteId, 0, params.prof__id)  //1: estudiante, 2: profesor
    }

    def encuestaDR() {
//        println "encuestaDR $params, tipo: ${session.tipoPersona}, prof: ${session.informanteId}"
        //encuesta(tpen__id, tpif__id, prof__id, dcta__id, profeval)
        encuesta(3, 2, session.informanteId, 0, params.prof__id)  //1: estudiante, 2: profesor
    }


    def encuesta(tpen__id, tpif__id, prof__id, dcta__id, profeval) {
        println "encuesta persona: ${session.tipoPersona}, tipo: ${tpen__id} ponePregunta: ${session.encuesta}, " +
                "params: $params, id: ${session.informanteId}, pr: ${session.prdo}"
        def creado = false
        def tpen = TipoEncuesta.get(tpen__id)
        def total = encuestaService.totalPreguntas(tpen__id)  //total preguntas de la ponePregunta id
        def encu
        def periodo = Periodo.get(session.prdo)

        def actual = 0
        if(tpen__id == 5) {  //PARES (informante, tpif, tpen, estd=0, dcta=0, par, drtv=0, prdo)
            encu = encuestaService.encuestaEnCurso(session.informanteId, tpif__id, tpen.id, 0, 0, profeval, 0, session.prdo)

        } else if(tpen__id == 3) { //directivos (informante, tpif, tpen, estd=0, dcta=0, par=0, drtv, prdo)
            encu = encuestaService.encuestaEnCurso(session.informanteId, tpif__id, tpen.id, 0, 0, 0, profeval, session.prdo)

        } else if(tpen__id == 4) { // factores de éxito (informante, tpif, tpen, estd=0, dcta=0, par=0, drtv=0, prdo)
            encu = encuestaService.encuestaEnCurso(session.informanteId, tpif__id, tpen.id, 0, 0, 0, 0, session.prdo)
        } else { // Evaluación al docente y autoevaluacion: (informante, tpif, tpen, estd, dcta, par=0, drtv=0, prdo)
            encu = encuestaService.encuestaEnCurso(session.informanteId, tpif__id, tpen.id, session.informanteId, dcta__id, 0,0, session.prdo)
        }

        println "encuesta en curso: ${encu?.id}, tpen: ${tpen__id}"
        if(encu == null) {  // se debe crear la ponePregunta
            actual = 1
            encu = new Encuesta()
            switch (tpen__id) {
                case 4: //FE
                    encu.estudiante = Estudiante.get(session.informanteId)
                    encu.teti = Teti.findByTipoEncuestaAndTipoInformante(tpen, TipoInformante.findByCodigo(session.tipoPersona))
                    encu.fecha = new Date()
                    encu.estado = 'N'
                    encu.periodo = periodo
                    break
                case 2: //DC
                    encu.estudiante = Estudiante.get(session.informanteId)
                    encu.teti = Teti.findByTipoEncuestaAndTipoInformante(tpen, TipoInformante.findByCodigo(session.tipoPersona))
                    encu.fecha = new Date()
                    encu.estado = 'N'
                    encu.profesor = Profesor.get(prof__id)
                    encu.materiaDictada =  Dictan.get(dcta__id)
                    encu.periodo = periodo
                    break
                case 1: //AD
                    encu.teti = Teti.findByTipoEncuestaAndTipoInformante(tpen, TipoInformante.findByCodigo(session.tipoPersona))
                    encu.fecha = new Date()
                    encu.estado = 'N'
                    encu.profesor = Profesor.get(session.informanteId)
                    encu.materiaDictada =  Dictan.get(dcta__id)
                    encu.periodo = periodo
                    break
                case 5: //PR
                    encu.teti = Teti.findByTipoEncuestaAndTipoInformante(tpen, TipoInformante.findByCodigo(session.tipoPersona))
                    encu.fecha = new Date()
                    encu.estado = 'N'
                    encu.par = Profesor.get(session.informanteId)
                    encu.profesor = Profesor.get(profeval)
                    encu.periodo = periodo
                    break
                case 3: //DR
                    encu.teti = Teti.findByTipoEncuestaAndTipoInformante(tpen, TipoInformante.findByCodigo(session.tipoPersona))
                    encu.fecha = new Date()
                    encu.estado = 'N'
                    encu.directivo = Profesor.get(session.informanteId)
                    encu.profesor = Profesor.get(profeval)
                    encu.periodo = periodo
                    break
            }

            try{
//                println "inicia save"
                encu.save(flush: true)
//                println "creando ponePregunta.. ok"
                creado = true
            } catch (e){
//                println "****** $e"
                println("error al crear ponePregunta: " + encu.errors)
            }
            if(creado) {
                encu.refresh()
//                println "-->Continua con encu: ${encu.id}, actual: $actual"
                session.total = total
                session.encuesta = encu
                session.tipoEncuesta = tpen
                if(tpen__id == 4) session.materias = encuestaService.materias(session.informanteId, session.prdo)
                ponePregunta(actual, total, encu, tpen)
            }
        } else {
            actual  = encuestaService.preguntaActual(encu.id) + 1
            println "va a ponePregunta con encu: ${encu.id}, actual: $actual, total: ${total}"
            if(actual <= total) { //continuar con la ponePregunta
                session.total = total
                session.encuesta = encu
                session.tipoEncuesta = tpen
                if(tpen__id == 4) session.materias = encuestaService.materias(session.informanteId, session.prdo)
                ponePregunta(actual, total, encu, tpen)
            } else {
                // ya ha terminado la ponePregunta
                session.encuesta = encu
                session.tipoEncuesta = encu.teti.tipoEncuesta
                finalizaEncuesta(encu.id)
            }
        }
    }



        /**
     * tipo de ponePregunta: FE id: 4
     * tipo de informante: estudiante: 1, profesor: 2
     * seleccina pregunta que toca e invoca la acción correspondiente al tipo
     */
    def ponePregunta(actual, total, encu, tpen) {
        println "----> $actual, $total, $encu, $tpen"
        def pruebasInicio = new Date()
        def pruebasFin


        def tipoPregunta = encuestaService.tipoPregunta(actual, tpen.id)
        def pregunta = ""
        def preg
        def resp = [1]  //respuesta si está en un pregunta anterior y asignatura 0:no existe
        def rp = []

//        println "tipo de pregunta: $tipoPregunta"

        preg = seleccionaPregunta(tpen.id, actual)
        actual   = preg[0]
        pregunta = preg[1]  // id:dscr
        rp = preg[2]        // id:dscr
//        resp = [1, 877, null]    // id:rppg, id:dcta__id, id:prit__id lo ya contestado
        resp = preg[3]

//        println "encu: $encu \nactual: $actual \nmax: $total \npregunta: $pregunta \nrp: $rp \nresp: $resp \nmaterias: $matr"
//        println " -----> pregunta: $pregunta"
//        println " respondido ${resp}"

        pruebasFin = new Date()
        println "tiempo ejecución ponePregunta: ${TimeCategory.minus(pruebasFin, pruebasInicio)}"


        switch (tipoPregunta.split('_')[0]) {
            case 'Asgn':
//                println "-----------------> asgn materias: ${session.materias}"
                render (view: 'preguntaAsgn',
                        model: [tpen: tpen, encu: encu.id, actual: actual, total: total, pregunta: pregunta, rp: rp, resp: resp,
                                materias: session.materias, asgn: tipoPregunta.split('_')[1]])
                break
            case 'Prit':
//                println "-----------------> prit"
                def prit = encuestaService.itemsPregunta(pregunta.id)
                render (view: 'preguntaPrit',
                        model: [tpen: tpen, encu: encu.id, actual: actual, total: total, pregunta: pregunta, rp: rp, resp: resp,
                                prit: prit])
                break
            case 'Normal':
//                println "-----------------> normal"
                if(encu?.profesor){
                    render (view: 'pregunta',
                            model: [tpen: tpen, encu: encu.id, actual: actual, total: total, pregunta: pregunta, rp: rp,
                                    resp: resp, profesor: encu?.profesor?.nombre + ' ' + encu.profesor.apellido, materia: encu.materiaDictada?.materia?.nombre])
                } else {
                    render (view: 'pregunta',
                            model: [tpen: tpen, encu: encu.id, actual: actual, total: total, pregunta: pregunta, rp: rp,
                                    resp: resp])
                }
                break
/*
            default:
                println "-----------------> default"
                render (view: 'preguntaPrit',
                        model: [tpen: tpen, encu: encu.id, actual: actual, total: total, pregunta: pregunta, rp: rp, resp: resp,
                                prit: [[id:1, dscr:'uno'],[id:2, dscr:'dos'],[id:3, dscr:'tres']]])
*/
        }
    }


    boolean existeEstudiante(cdla) {
//        println "existeEstudiante $cdla"
        def cn = dbConnectionService.getConnection()
        def tx = "select estd.estd__id, estdnmbr||' '||estdapll estudiante, estd.univ__id, prdo.prdo__id " +
                "from estd, matr, dcta, prdo " +
                "where estdcdla = '${cdla}' and matr.estd__id = estd.estd__id and dcta.dcta__id = matr.dcta__id and " +
                "prdo.prdo__id = dcta.prdo__id and now() between prdofcin and coalesce(prdofcfn, now()) limit 1"
        println "sql: $tx"
        try {
            cn.eachRow(tx) { d ->
//                println "retorna cnta: ${d.cnta}"
                session.informanteId = d.estd__id
                session.informante = d.estudiante
                session.univ = d.univ__id
                session.prdo = d.prdo__id
            }
        }
        catch (e) {
            println e.getMessage()
        }
        cn.close()
        return (session.informanteId != null)
    }

    boolean existeProfesor(cdla) {
        def cn = dbConnectionService.getConnection()
        def rt = false
        def tx = "select prof.prof__id, profnmbr||' '||profapll profesor, profeval, univ__id, prdo.prdo__id " +
                "from prof, matr, dcta, prdo " +
                "where profcdla = '${cdla}' and dcta.prof__id = prof.prof__id and dcta.dcta__id = matr.dcta__id and " +
                "  prdo.prdo__id = dcta.prdo__id and " +
                "  now() between prdofcin and coalesce(prdofcfn, now()) limit 1"
        println "sql: $tx"
        try {
            cn.eachRow(tx) { d ->
                session.informanteId = d.prof__id
                session.informante = d.profesor
                session.par = d.profeval == 'P'
                session.directivo = d.profeval == 'S'
                session.univ = d.univ__id
                session.prdo = d.prdo__id
            }
        }
        catch (e) {
            println e.getMessage()
        }
        cn.close()
        return (session.informanteId != null)
    }

    def preguntaAsgn() {
    }

    def anterior() {
        println "params anterior: $params"
        def cn = dbConnectionService.getConnection()
        def actual = params.actual.toInteger() - 1
        def tx = "select teti__id from encu where encu__id = ${params.encu__id}"
        println "anterior sql: $tx"
        if((cn.rows(tx.toString())[0]?.teti__id == 4) && params.actual.toInteger() == 3) {
            tx = "select count(*) cnta from encu, dtec where encu.encu__id = ${params.encu__id} and " +
                    "dtec.encu__id = encu.encu__id and prte__id = 68"
            if(cn.rows(tx.toString())[0]?.cnta == 0)
                actual--
        }

        ponePregunta(actual, session.total, session.encuesta, session.tipoEncuesta)
    }


    /** registra respuesta de preguntaAsgn
    * repuestas: rppg__id
    * materia:   dcta__id
    * preg__id:  prte__id  **/
    def respuestaAsgn() {
        println "respuestaAsgn: $params"
        def cn = dbConnectionService.getConnection()
        def dtec
        def tx = "select rppg__id, pregcdgo from rppg, prte, preg where prte__id = ${params.preg__id} and " +
                "rppg.preg__id = prte.preg__id and resp__id <> 1 and preg.preg__id = prte.preg__id"
        def tx2 = ""
        def resp = cn.rows(tx.toString())[0]?.rppg__id
        def preg = cn.rows(tx.toString())[0]?.pregcdgo.trim()
        println "respuesta sql: $tx"

//        def asignatura = encuestaService.esAsignatura(params.respuestas)
        def asignatura = params.materia != '-1'
        def respuestas = asignatura? 1 : resp

        println "asignatura: $asignatura, respuestas: $respuestas"
        tx = "select dtec__id from dtec, prte where encu__id = ${params.encu__id} and " +
                "prte.prte__id = dtec.prte__id and prte.prte__id = ${params.preg__id} and tpen__id = ${params.tpen__id}"
//        println "respuestaAsgn sql: $tx"
        dtec = cn.rows(tx.toString())[0]?.dtec__id
        // si contesta Asignatura:
        if(asignatura) {
//            println "actualiza cuando respuesta es asignatura: ${params.respuestas} == 1"
            if(dtec) {
                tx = "update dtec set rppg__id = ${respuestas}, dcta__id = ${params.materia} " +
                        "where dtec__id = ${dtec}"
            } else {
                tx = "insert into dtec(prte__id, rppg__id, encu__id, dcta__id) " +
                        "values(${params.preg__id}, ${respuestas}, ${params.encu__id}, ${params.materia})"
            }
        } else {
            if(dtec) {
                tx = "update dtec set rppg__id = ${respuestas}, dcta__id = null where dtec__id = ${dtec}"
            } else {
                tx = "insert into dtec(prte__id, rppg__id, encu__id) " +
                        "values(${params.preg__id}, ${respuestas}, ${params.encu__id})"
            }
            println "preg: <<${preg}>>"
            if(preg == 'CCB-1'){
                tx2 = "select count(*) cnta from dtec where encu__id = ${params.encu__id} and prte__id = 68"
                if(cn.rows(tx2.toString())[0]?.cnta) {
                    tx2 = "delete from dtec where encu__id = ${params.encu__id} and prte__id = 68"
                    tx2 = "insert into dtec(prte__id, rppg__id, encu__id) " +
                            "values(${params.preg__id}, ${respuestas}, ${params.encu__id})"
                } else {

                }
                params.actual = params.actual.toInteger() + 1
            } else {
                tx2 = ""
            }
        }
        try {
            cn.execute(tx.toString())
            if(tx2) cn.execute(tx2.toString())
        }
        catch (e) {
            println e.getMessage()
        }
//        println "... sql: $tx"
        cn.close()
        //llamar al a siguiente pregunta
        def actual = params.actual.toInteger() + 1

        if(actual > session.total) {// ya ha terminado la ponePregunta
            finalizaEncuesta(session.encuesta.id)
        } else {
//            if(params.materia == '-1'){
//                ponePregunta((actual + 1), session.total, session.encuesta, session.tipoEncuesta)
//            }else{
                ponePregunta(actual, session.total, session.encuesta, session.tipoEncuesta)
//            }

        }
    }

    /** registra respuesta de preguntaPrit
    * repuestas: rppg__id
    * materia:   dcta__id
    * preg__id:  prte__id  **/
    def respuestaPrit() {
//        println "encuestaPrit: $params"
        def cn = dbConnectionService.getConnection()
        def dtec
        //igual que en respuestaAsgn
        def tx = "select dtec__id from dtec, prte where encu__id = ${params.encu__id} and " +
                "prte.prte__id = dtec.prte__id and prte.prte__id = ${params.preg__id} and tpen__id = ${params.tpen__id}"
//        println "respuestaAsgn sql: $tx"
        dtec = cn.rows(tx.toString())[0]?.dtec__id

        //siempre se responde causa y respuesta
        if(dtec) {
            tx = "update dtec set rppg__id = ${params.respuestas}, prit__id = ${params.causas}, dcta__id = null where dtec__id = ${dtec}"
        } else {
            tx = "insert into dtec(prte__id, rppg__id, encu__id, prit__id) " +
                   "values(${params.preg__id}, ${params.respuestas}, ${params.encu__id}, ${params.causas})"
        }
        try {
            cn.execute(tx.toString())
        }
        catch (e) {
            println e.getMessage()
        }
//        println "... sql: $tx"
        cn.close()
        //llamar al a siguiente pregunta
        def actual = params.actual.toInteger() + 1

        if(actual > session.total) {// ya ha terminado la ponePregunta
            finalizaEncuesta(session.encuesta.id)
        } else {
            ponePregunta(actual, session.total, session.encuesta, session.tipoEncuesta)
        }
    }

    /** registra respuesta de preguntaPrit
    * repuestas: rppg__id
    * materia:   dcta__id
    * preg__id:  prte__id  **/
    def respuesta() {
//        println "respuesta: $params"
        def cn = dbConnectionService.getConnection()
        def dtec
        //igual que en respuestaAsgn
        def tx = "select dtec__id from dtec, prte where encu__id = ${params.encu__id} and " +
                "prte.prte__id = dtec.prte__id and prte.prte__id = ${params.preg__id} and tpen__id = ${params.tpen__id}"
//        println "respuesta sql: $tx"
        dtec = cn.rows(tx.toString())[0]?.dtec__id

        //siempre se responde causa y respuesta
        if(dtec) {
            tx = "update dtec set rppg__id = ${params.respuestas} where dtec__id = ${dtec}"
        } else {
            tx = "insert into dtec(prte__id, rppg__id, encu__id) " +
                   "values(${params.preg__id}, ${params.respuestas}, ${params.encu__id})"
        }
        try {
            cn.execute(tx.toString())
        }
        catch (e) {
            println e.getMessage()
        }
//        println "... sql: $tx"
        cn.close()
        //llamar al a siguiente pregunta
        def actual = params.actual.toInteger() + 1

        if(actual > session.total) {// ya ha terminado la ponePregunta
            finalizaEncuesta(session.encuesta.id)
        } else {
            ponePregunta(actual, session.total, session.encuesta, session.tipoEncuesta)
        }
    }



    /**
    def preg = seleccionaPregunta(4, actual)
     * @param tpen:  tipo de ponePregunta
     * @param actual: número de la pregunta actual, 0: iniciio
    actual = preg[0]    // numero de pregunta prtenmro
    pregunta = preg[1]  // id:dscr
    rp = preg[2]        // id:dscr
    */
    def seleccionaPregunta(tpen, actual){
        def cn = dbConnectionService.getConnection()
        def txpreg = ""
        txpreg = tpen == 1? "replace(upper(pregdscr), 'EL DOCENTE', 'USTED')" : "pregdscr"

        def tx = "select prte__id, prtenmro, prte.preg__id id, ${txpreg} dscr " +
                "from preg, prte " +
                "where tpen__id = ${tpen} and prtenmro >= ${actual} and preg.preg__id = prte.preg__id " +
                "order by prtenmro limit 1"
        def preg = []
        def resp = []
        def rp = [:]
        def contestado = []
//        println " a ejecutar seleccionaPregunta: ${tx}"

        def prte = cn.rows(tx.toString())[0]
//        println "dscr: ${prte.dscr}"
        prte.dscr = tpen == 1? prte.dscr.replaceAll('EL PROFESOR', 'USTED') : prte.dscr


        preg.add(prte.prtenmro)
        preg.add([id: prte.prte__id, dscr: prte.dscr])   //prte__id y pregunta respectiva

        tx = "select rppg.rppg__id id, respdscr dscr from rppg, resp " +
                "where rppg.preg__id = ${prte.id} and resp.resp__id = rppg.resp__id order by rppgvlor desc"
//        println "++seleccionaPregunta: ${tx}"
        cn.eachRow(tx.toString()) { d ->
            rp = [:]
            rp.id = d.id
            rp.dscr = d.dscr
            resp.add(rp)
        }
        preg.add(resp)

        tx = "select rppg__id, dcta__id, prit__id from dtec, prte where encu__id = ${session.encuesta.id} and " +
                "prte.prte__id = dtec.prte__id and prtenmro = ${actual} and tpen__id = ${tpen}"
//        println "++seleccionaPregunta: ${tx}"
        cn.eachRow(tx.toString()) { d ->
            contestado = [d.rppg__id?:0, d.dcta__id?:0, d.prit__id?:0]
        }
        if(!contestado) {
            preg.add([0,0,0])
        } else {
            preg.add(contestado)
        }


//        println "+++++ resp: $resp"
        cn.close()
//        println "+++++++ contestado: $contestado"
        return preg
    }

    def finalizaEncuesta(encu) {
        println "llega encu: $encu, tipo: ${session?.tipoPersona} encuesta: ${session?.tipoEncuesta?.codigo}"
        encuestaService.poneFinalizado(encu)

        if(session.tipoPersona == 'E' && (session.tipoEncuesta.codigo == 'FE')){
            //continuar con evaluacion a profesores
            redirect action: 'previa'
        } else if(session.tipoPersona == 'E' && (session.tipoEncuesta.codigo == 'DC')) {
            //continuar con evaluacion a profesores
            redirect action: 'previa'
        } else if(session.tipoPersona == 'P' && (session.tipoEncuesta.codigo in ['PR', 'DI'])) {
            //continuar con evaluacion a profesores
            redirect action: 'previaDc'
        } else if(session.tipoPersona == 'P' && (session.tipoEncuesta.codigo in ['AD'])) {
            //continuar con evaluacion a profesores
            def auto = encuestaService.autoevaluacion(session.informanteId, session.prdo)
            println "auto: $auto"
            if(auto) {
                redirect action: 'previaAd'
            } else {
                redirect action: 'previaDc'
            }
        }
    }

    def buscarProfesor() {
        render view: 'buscador'
    }

    def docentes() {
//        println "........ $params"
        def titl = ""
        def univ = Universidad.get(session.univ)
        def logo = g.resource(dir: 'images/univ', file: univ.logo, absolute: true)
        if(params.tipo == 'PR') {
            titl = "Evaluación de Pares"
        } else if(params.tipo == 'DR') {
            titl = "Evaluación del Directivo al Docente"
        }
        [titulo: titl, logo: logo, universidad: univ.nombre]
    }

    def tablaProfesores() {
        println "buscar .. $params, sesión: ${session.par}"
        def cn = dbConnectionService.getConnection()
        def sql = " "
        def resultado = []
        def msg = ""

        if(session.par) { // si puede evaluar PARES
            sql = "select dcta.prof__id id, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                    "from dcta, mate, prof, crso " +
                    "where prdo__id = ${session.prdo} and (profnmbr ilike '%${params.buscar}%' or profapll ilike '%${params.buscar}%') and " +
                    "crso.crso__id = dcta.crso__id and prof.prof__id = dcta.prof__id and " +
                    "mate.mate__id = dcta.mate__id and dcta.prof__id not in (" +
                    "select prof__id from encu where prof_par is not null and prdo__id = ${session.prdo} and " +
//                    "dcta__id <> dcta.dcta__id and encuetdo = 'C' ) and " +
                    "encuetdo = 'C' ) and " +
                    "prof.prof__id <> ${session.informanteId} and dcta.dcta__id in (select distinct dcta__id from matr)"
        } else { // puede evaluar como DIRECTIVO
            sql = "select dcta.prof__id id, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                    "from dcta, mate, prof, crso " +
                    "where prdo__id = ${session.prdo} and (profnmbr ilike '%${params.buscar}%' or profapll ilike '%${params.buscar}%') and " +
                    "crso.crso__id = dcta.crso__id and prof.prof__id = dcta.prof__id and " +
                    "mate.mate__id = dcta.mate__id and dcta.prof__id not in (" +
                    "select prof__id from encu where profdrtv is not null and prdo__id = ${session.prdo} and encuetdo = 'C') and " +
                    "prof.prof__id <> ${session.informanteId} and dcta.dcta__id in (select distinct dcta__id from matr)"
        }

        println "...sql: $sql"
        resultado = cn.rows(sql.toString())

        if(resultado?.size() > 20){
            resultado = resultado[0..19]
            msg = "<div class='alert-danger' style='margin-top:-20px; diplay:block; height:25px;margin-bottom: 20px;'>" +
                    " <i class='fa fa-warning fa-2x pull-left'></i> Su búsqueda ha generado más de 20 resultados. " +
                    "Use más palabras para especificar mejor la búsqueda.</div>"
        }

        cn.close()

        return [bases: resultado, msg: msg]

    }

    def prueba () {
        ponePregunta(2,7, Encuesta.get(130364), TipoEncuesta.get(4))
    }

}
