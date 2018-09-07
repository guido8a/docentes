package utilitarios

import docentes.Periodo
import org.springframework.dao.DataIntegrityViolationException
import jxl.Cell
import jxl.Sheet
import jxl.Workbook
import jxl.WorkbookSettings

class ProcesosController extends seguridad.Shield {
    def dbConnectionService

    def cargarDatos() {

    }

    def formato_ajax() {
        def tabla = ""
        switch (params.tipo) {
            case '1':
                tabla = "Facultades"
                break
            case '2':
                tabla = "Escuelas"
                break
            case '3':
                tabla = "Profesores"
                break
            case '4':
                tabla = "Estudiantes"
                break
            case '5':
                tabla = "Materias"
                break
            case '6':
                tabla = "Cursos"
                break
            case '7':
                tabla = "Materias que se dictan"
                break
            case '8':
                tabla = "Matriculados por materia"
                break
        }
        println "tabla: $tabla"
        return [tipo: params.tipo, tabla: tabla]
    }

    def botones_ajax() {
        println "params: $params"
        return [boton: params.boton]
    }

    def periodos_ajax() {

    }

    def mensajeUpload() {
        println "params.html: $params"
        return [html: params.html]
    }

    def borrarDatos() {
        println "borrarDatos: $params"
        def cn = dbConnectionService.getConnection()
        def prdo = Periodo.get(params.id)
        def msg = ""
        def b_matr = 0
        def b_dcta = 0

        try {
            b_matr = cn.rows("select count(*) cnta from matr where dcta__id in (select dcta__id from dcta where prdo__id = ${prdo.id})")[0].cnta
            b_dcta = cn.rows("select count(*) cnta from dcta where prdo__id = ${prdo.id}")[0].cnta
            cn.execute("delete from matr where dcta__id in (select dcta__id from dcta where prdo__id = ${prdo.id})")
            cn.execute("delete from dcta where prdo__id = ${prdo.id}")
            msg = "ok_Se ha borrado <strong>${b_dcta} </strong>registros de Materias dictadas y <strong>${b_matr}</strong> " +
                    "Estudiantes Matriculados del Periodo: ${prdo.nombre}"
        } catch (e) {
            println "error: $e"
            msg = "error_No se pudo borrar los registros de Materias dictadas y Estudiantes Matriculados del Periodo: \"${prdo.nombre}\""
        }
/*
        flash.message = "Se ha borrado todos los regsitros de Facultades, Escuelas, Profesores, Materials, Cursos, " +
                "Materias que se dictan, Estudiantes y Estudiantes Matriculados"
        flash.tipo = "error"
*/
        render msg
    }

    /**
     * Para cada registro en el archivo se valida cuantos códigos nuevos hay y cuantos repetidos.
     */
    def validar2() {
        println "validar: $params"
        def cn = dbConnectionService.getConnection()
        def prdo = Periodo.get(params.id)
        def msg = ""
        def b_matr = 0
        def b_dcta = 0

        try {
//            b_matr = cn.rows("select count(*) cnta from facl where dcta__id in (select dcta__id from dcta where prdo__id = ${prdo.id})")[0].cnta
//            b_dcta = cn.rows("select count(*) cnta from dcta where prdo__id = ${prdo.id}")[0].cnta
//            cn.execute("delete from matr where dcta__id in (select dcta__id from dcta where prdo__id = ${prdo.id})")
//            cn.execute("delete from dcta where prdo__id = ${prdo.id}")
//            msg = "ok_Se ha borrado <strong>${b_dcta} </strong>registros de Materias dictadas y <strong>${b_matr}</strong> " +
//                    "Estudiantes Matriculados del Periodo: ${prdo.nombre}"
//            cargaArchivo()
        } catch (e) {
            println "error: $e"
            msg = "error_No se pudo borrar los registros de Materias dictadas y Estudiantes Matriculados del Periodo: \"${prdo.nombre}\""
        }
        render msg
    }

    /**
     * Para cada registro en el archivo se valida cuantos códigos nuevos hay y cuantos repetidos.
     */
    def validar() {
        println "cargaArchivo.. $params"
        def contador = 0
        def tipo = params.tipoTabla
        def cn = dbConnectionService.getConnection()
        def path = servletContext.getRealPath("/") + "xlsData/"   //web-app/archivos
        new File(path).mkdirs()

        def f = request.getFile('file')  //archivo = name del input type file
        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }

            if (ext == "xls") {
                fileName = params.tipoTabla
                def fn = fileName
                fileName = fileName + "." + ext

                def pathFile = path + fileName
                def src = new File(pathFile)

                def i = 1
                while (src.exists()) {
                    pathFile = path + fn + "_" + i + "." + ext
                    src = new File(pathFile)
                    i++
                }

                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo nombre

                //********* procesar excel ***********
                def htmlInfo = "", errores = "", doneHtml = ""
                def file = new File(pathFile)
                def cntanmro = 0
                def cntadscr = 0
                WorkbookSettings ws = new WorkbookSettings();
                ws.setEncoding("Cp1252");
                Workbook workbook = Workbook.getWorkbook(file, ws)

                // ------------------- carga registros -----------------
                def sheet = 0
                Sheet s = workbook.getSheet(sheet)  // procesa solo la primera página
                if (!s.getSettings().isHidden()) {
                    println "hoja: ${s.getName()} sheet: $sheet, registros: ${s.getRows()}"
                    htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                    Cell[] row = null

                    s.getRows().times { j ->
                        row = s.getRow(j)
                        println row*.getContents()
                        println row.length

                        switch (tipo) {
                            case 'Facultades':
                                if (row.length >= 2) {
                                    def faclnmro = row[0].getContents()
                                    def facldscr = row[1].getContents()
                                    if (faclnmro != "CODIGO") {  // no es el título
                                        if (cn.rows("select count(*) cnta from facl where faclcdgo = '${faclnmro}'".toString())[0].cnta > 0) {
                                            cntanmro++
                                        }
                                        if (cn.rows("select count(*) cnta from facl where facldscr = '${facldscr}'".toString())[0].cnta > 0) {
                                            cntadscr++
                                        }
                                        contador++
                                    }
                                } //row ! empty
                                break
                            case 'Escuelas':
                                if (row.length >= 3) {
                                    def esclnmro = row[0].getContents()
                                    def escldscr = row[1].getContents()
                                    def faclnmro = row[2].getContents()
                                    if (faclnmro != "CODIGO") {  // no es el título
                                        if (cn.rows("select count(*) cnta from escl where esclcdgo = '${esclnmro}' and " +
                                                "facl__id = (select facl__id from facl where faclcdgo = '${faclnmro}')".toString())[0].cnta > 0) {
                                            cntanmro++
                                        }
                                        if (cn.rows("select count(*) cnta from escl where escldscr = '${escldscr}' and " +
                                                "facl__id = (select facl__id from facl where faclcdgo = '${faclnmro}')".toString())[0].cnta > 0) {
                                            cntadscr++
                                        }
                                        contador++
                                    }
                                } //row ! empty
                                break
                        }
                    } //rows.each
                } //sheet ! hidden
                htmlInfo += "<p>Se han procesado $contador registros</p>"



                if (contador > 0) {
                    doneHtml = "<div class='alert alert-success'>Se ha verificado correctamente $contador registros</div>"
                    doneHtml += "<p>Existen $cntanmro registros con código repetido y, </p>"
                    doneHtml += "<p>existen $cntadscr registros con nombre repetido</p>"
                }

                def str = htmlInfo
                str += doneHtml
                if (errores != "") {
                    str += "<ol>" + errores + "</ol>"
                }

                redirect(action: 'mensajeUpload', params: [html: str])

            } else {
                flash.message = "Seleccione un archivo Excel xls para procesar (archivos xlsx deben ser convertidos a xls primero)"
                redirect(action: 'validar')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'validar')
//            println "NO FILE"
        }
    }

    /**
     * Carga datos del archivo único
     */
    def cargarUnico() {
        println "cargaArchivo.. $params"
        def contador = 0
        def tipo = params.tipoTabla
        def cn = dbConnectionService.getConnection()
        def path = servletContext.getRealPath("/") + "xlsData/"   //web-app/archivos
        new File(path).mkdirs()

        def f = request.getFile('file')  //archivo = name del input type file
        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            def parts = fileName.split("\\.")
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }

            if (ext == "xls") {
                fileName = params.tipoTabla
                def fn = fileName
                fileName = fileName + "." + ext

                def pathFile = path + fileName
                def src = new File(pathFile)

                def i = 1
                while (src.exists()) {
                    pathFile = path + fn + "_" + i + "." + ext
                    src = new File(pathFile)
                    i++
                }

                f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo nombre

                //********* procesar excel ***********
                def htmlInfo = "", errores = "", doneHtml = ""
                def file = new File(pathFile)
                def cntanmro = 0
                def cntadscr = 0
                WorkbookSettings ws = new WorkbookSettings();
                ws.setEncoding("Cp1252");
                Workbook workbook = Workbook.getWorkbook(file, ws)

                // ------------------- carga registros -----------------
                def sheet = 0
                Sheet s = workbook.getSheet(sheet)  // procesa solo la primera página
                if (!s.getSettings().isHidden()) {
                    println "hoja: ${s.getName()} sheet: $sheet, registros: ${s.getRows()}"
                    htmlInfo += "<h2>Hoja " + (sheet + 1) + ": " + s.getName() + "</h2>"
                    Cell[] row = null

                    s.getRows().times { j ->
                        row = s.getRow(j)
                        println row*.getContents()
                        println row.length

                        switch (tipo) {
                            case 'Facultades':
                                if (row.length >= 2) {
                                    def faclnmro = row[0].getContents()
                                    def facldscr = row[1].getContents()
                                    if (faclnmro != "CODIGO") {  // no es el título
                                        if (cn.rows("select count(*) cnta from facl where faclcdgo = '${faclnmro}'".toString())[0].cnta > 0) {
                                            cntanmro++
                                        }
                                        if (cn.rows("select count(*) cnta from facl where facldscr = '${facldscr}'".toString())[0].cnta > 0) {
                                            cntadscr++
                                        }
                                        contador++
                                    }
                                } //row ! empty
                                break
                            case 'Escuelas':
                                if (row.length >= 3) {
                                    def esclnmro = row[0].getContents()
                                    def escldscr = row[1].getContents()
                                    def faclnmro = row[2].getContents()
                                    if (faclnmro != "CODIGO") {  // no es el título
                                        if (cn.rows("select count(*) cnta from escl where esclcdgo = '${esclnmro}' and " +
                                                "facl__id = (select facl__id from facl where faclcdgo = '${faclnmro}')".toString())[0].cnta > 0) {
                                            cntanmro++
                                        }
                                        if (cn.rows("select count(*) cnta from escl where escldscr = '${escldscr}' and " +
                                                "facl__id = (select facl__id from facl where faclcdgo = '${faclnmro}')".toString())[0].cnta > 0) {
                                            cntadscr++
                                        }
                                        contador++
                                    }
                                } //row ! empty
                                break
                        }
                    } //rows.each
                } //sheet ! hidden
                htmlInfo += "<p>Se han procesado $contador registros</p>"



                if (contador > 0) {
                    doneHtml = "<div class='alert alert-success'>Se ha verificado correctamente $contador registros</div>"
                    doneHtml += "<p>Existen $cntanmro registros con código repetido y, </p>"
                    doneHtml += "<p>existen $cntadscr registros con nombre repetido</p>"
                }

                def str = htmlInfo
                str += doneHtml
                if (errores != "") {
                    str += "<ol>" + errores + "</ol>"
                }

                redirect(action: 'mensajeUpload', params: [html: str])

            } else {
                flash.message = "Seleccione un archivo Excel xls para procesar (archivos xlsx deben ser convertidos a xls primero)"
                redirect(action: 'validar')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'validar')
//            println "NO FILE"
        }
    }


    def procesar () {

    }

    /** Ejecuta función: desempeño **/
    def progreso () {
//        println "$params"
        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def retorna = ""
        def sql = "select facl.facl__id, facldscr, count(*) cnta from encu, prof, escl, facl " +
                "where encu.prdo__id = ${params.periodo} and " +
                "prof.prof__id = encu.prof__id and escl.escl__id = prof.escl__id and " +
                "facl.facl__id = escl.facl__id and encu.teti__id = 2 group by facl.facl__id, facldscr order by facldscr"

        println "sql: $sql"

        cn.eachRow(sql.toString()) { d ->
            render (d.facl__id + "_" + d.cnta + "_" + d.facldscr + "*")
        }
    }

    /** Ejecuta función: tendencias **/
    def tendencia () {
//        println "$params"
        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def retorna = ""
        def sql = "select facl.facl__id, facldscr, count(*) cnta from encu, estd, matr, dcta, prof, escl, facl " +
                "where encu.prdo__id = ${params.periodo} and estd.estd__id = encu.estd__id and " +
                "matr.estd__id = estd.estd__id and dcta.dcta__id = matr.dcta__id and encu.teti__id = 4 and " +
                "encuetdo = 'C' and prof.prof__id = dcta.prof__id and escl.escl__id = prof.escl__id and " +
                "facl.facl__id = escl.facl__id " +
                "group by facl.facl__id, facldscr order by facldscr"

        println "sql: $sql"

        cn.eachRow(sql.toString()) { d ->
            render (d.facl__id + "_" + d.cnta + "_" + d.facldscr + "*")
        }
    }

    def procesaFacl () {
        println "$params"
        def partes = params.arreglo.split("_")
        def total = params.total.toInteger()
//        def regla = (partes[1].toInteger()*100/total)
        def regla = (params.parcial.toInteger()*100/total)
//        println("regla " + regla)

        sleep(1000)

        def cn = dbConnectionService.getConnection()
        def sql = "select * from desempeno(${partes[0]}, ${params.periodo})"
        def sql1 = "select * from tiene_rcmn(${partes[0]}, ${params.periodo})"
//        println "sql: $sql"

        try {
            cn.execute(sql.toString())
            cn.execute(sql1.toString())
            render regla
        } catch (e) {
            println "error $e"
            render "error"
        }
    }

    def procesaTndn () {
        println "procesaTndn: $params"
        def partes = params.arreglo.split("_")
        def total = params.total.toInteger()
        def regla = (params.parcial.toInteger()*100/total)

        sleep(1000)

        /* procesa tendencias */
        def cn = dbConnectionService.getConnection()
        def sql = "select * from tendencias(${partes[0]}, ${params.periodo})"
//        println "sql: $sql"

        try {
            cn.execute(sql.toString())
            render regla
        } catch (e) {
            println "error $e"
            render "error"
        }
    }

    def descripcion_ajax () {
        def partes = params.parte.split("_")
        def facultad = partes[2]
        return [facultad: facultad]
    }

    def totales () {
        println "totales: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "select * from ajustar(${params.id})"
        try {
            cn.execute(sql.toString())
        } catch (e) {
            println "error $e"
        }

        sql = "select * from totales(${params.id})"
        println "sql totales: $sql"
        try {
            cn.execute(sql.toString())
//            redirect controller: 'inicio', action: 'index'
            redirect action: 'procesar'
        } catch (e) {
            println "error $e"
            render "error"
        }
    }


}
