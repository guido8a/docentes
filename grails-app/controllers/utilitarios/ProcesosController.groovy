package utilitarios

import com.google.common.collect.Iterables
import docentes.Periodo
import org.apache.poi.xssf.usermodel.XSSFCell
import org.apache.poi.xssf.usermodel.XSSFRow
import org.apache.poi.xssf.usermodel.XSSFSheet
import org.apache.poi.xssf.usermodel.XSSFWorkbook
import org.springframework.dao.DataIntegrityViolationException
import jxl.Cell
import jxl.Sheet
import jxl.Workbook
import jxl.WorkbookSettings

import java.text.DecimalFormat


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
            case '9':
                tabla = "Todo"
                break
        }
        println "tabla: $tabla"
        return [tipo: params.tipo, tabla: tabla]
    }

    def botones_ajax() {
//        println "params: $params"
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
        def univ = params.universidad
        def prdo = params.periodo
        def cn = dbConnectionService.getConnection()
        def path = servletContext.getRealPath("/") + "xlsData/"   //web-app/archivos
        new File(path).mkdirs()

        def f = request.getFile('file')  //archivo = name del input type file
        if (f && !f.empty) {
            def fileName = f.getOriginalFilename() //nombre original del archivo
            def ext

            def parts = fileName.split("\\.")
            println("parts " + parts)
            fileName = ""
            parts.eachWithIndex { obj, i ->
                if (i < parts.size() - 1) {
                    fileName += obj
                } else {
                    ext = obj
                }
            }

            def htmlInfo = "", errores = "", doneHtml = ""
            def cntanmro = 0
            def cntadscr = 0

            // archivos excel xls
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

                def file = new File(pathFile)
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
//                        println row*.getContents()
//                        println row.length

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
                            case 'Todo':
                                def rslt = cargaDatos(row)
                                errores += rslt.errores
                                contador += rslt.cnta
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
                    str += "<h3>Errores al cargar el archivo de datos</h3>"
                    str += "<ol>" + errores + "</ol>"
                }

                redirect(action: 'mensajeUpload', params: [html: str])

            } else if (ext == 'xlsx') {

                fileName = params.tipoTabla
                def fn = fileName
                fileName = fileName + "." + ext

                def pathFile = path + fileName
                def src = new File(pathFile)

                def ij = 1
                while (src.exists()) {
                    pathFile = path + fn + "_" + ij + "." + ext
                    src = new File(pathFile)
                    ij++
                }

                f.transferTo(new File(pathFile))

                InputStream ExcelFileToRead = new FileInputStream(pathFile);
                XSSFWorkbook wb = new XSSFWorkbook(ExcelFileToRead);

                XSSFWorkbook test = new XSSFWorkbook();

                XSSFSheet sheet = wb.getSheetAt(0);
                XSSFRow row;
                XSSFCell cell;

                Iterator rows = sheet.rowIterator();

                while (rows.hasNext()) {
                    row = (XSSFRow) rows.next()
                    Iterator cells = row.cellIterator()
//                    def rgst = cells.toList()
                    def rgst = []
                    while (cells.hasNext()) {
                        cell = (XSSFCell) cells.next()
                        if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
                            rgst.add( new DecimalFormat('#').format(cell.getNumericCellValue()))
                        } else {
                            rgst.add(cell.getStringCellValue())
                        }
                    }

//                    def cont = 0
//                    while (cells.hasNext()) {
//                        cells.next()
//                        cont++
//                    }
//                    println("cont " + cont)
//                    if (cont == 14) {
//                        println("cell " + row.getCell(1) + "")
//                    }

                    switch (tipo) {
                        case 'Facultades':
                            def rslt = cargarDatosFacultades(univ, rgst)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                        case 'Escuelas':
                            def rslt = cargarDatosEscuelas(rgst)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                        case 'Profesores':
                            def rslt = cargarDatosProfesor(rgst)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                        case 'Estudiantes':
                            def rslt = cargarDatosEstudiante(rgst)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                        case 'Materias':
                            def rslt = cargarDatosMaterias(rgst)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                        case 'Cursos':
                            def rslt = cargarDatosCursos(rgst)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                        case 'Materias que se dictan':
                            def rslt = cargarDatosDictan(rgst, params.periodo)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                        case 'Matriculados por materia':
                            def rslt = cargarDatosMatriculados(rgst, params.periodo)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                        case 'Todo':
                            def rslt = cargaDatos(univ, rgst, prdo)
                            errores += rslt.errores
                            contador += rslt.cnta
                            break
                    }
                } //sheet ! hidden
//                println "...$errores"
//                println "...$contador"
                htmlInfo += "<p>Se han procesado $contador registros</p>"

                if (contador > 0) {
                    doneHtml = "<div class='alert alert-success'>Se ha verificado correctamente $contador registros</div>"
                    doneHtml += "<p>Existen $cntanmro registros con código repetido y, </p>"
                    doneHtml += "<p>existen $cntadscr registros con nombre repetido</p>"
                }

                def str = htmlInfo
                str += doneHtml
                if (errores != "") {
                    str += "<h3>Errores al cargar el archivo de datos</h3>"
                    str += "<ol>" + errores + "</ol>"
                }

//                println "fin....."
                redirect(action: 'mensajeUpload', params: [html: str])


            } else {
                flash.message = "Seleccione un archivo Excel con extensión xls o xlsx para ser procesado"
                redirect(action: 'validar')
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'validar')
        }
    }

    /**
     * Carga datos del archivo único
     */
    def cargaDatos(univ, row, prdo) {
        def sql = ""
        def cdgo = ""
        def dscr = ""
        def actual_id = 0
        def errores = ""
        def cnta = 0
        def cn = dbConnectionService.getConnection()

//        println "cargar datos.... ${row.size()}"
        if ((row.size() > 13) && row[7]) {
//                            println "procesa datos.. Estudiante: ${row[0]}"
            def estdcdgo = row[0].toString().trim()
            def estdapll = row[1].toString().trim()
            def estdnmbr = row[2].toString().trim()
            def facl = row[3].toString().trim()
            def escl = row[4].toString().trim()
            def mate = row[5].toString().trim()
            def matecdgo = row[6].toString().trim()
            def crso = row[7].toString().trim()
            def prll = row[8].toString().trim()
            def profcdla = row[9].toString().trim()
            def profnmbr = row[10].toString().trim()
            def profapll = row[11].toString().trim()
            def profsexo = row[12].toString().toUpperCase().trim()
            def proftitl = row[13].toString().trim()
//            println "sexo: ${profsexo}"
            if ((mate != "MATERIA") && (profsexo in ['M', 'F'])) {      // no es el título
//                println "procesa facultades"
                def facl__id = datosFacl(univ, facl.toUpperCase(),null)             // crea facultad
//                println "procesa escuelas"
                def escl__id = datosEscl(escl.toUpperCase(), facl__id, null)   // crea escuela
//                println "procesa materias"
                def mate__id = datosMate(matecdgo, mate, univ, escl__id)   // crea escuela
//                println "procesa profesores"
                def prof__id = datosProf(profcdla, profnmbr, profapll, profsexo, proftitl, univ, escl__id)   // crea porf
                def estd__id = datosEstd(estdcdgo, estdnmbr, estdapll, univ)   // crea estd
                def crso__id = datosCrso(crso)   // crea estd
//                def dcta__id = datosDcta(prof__id, mate__id, crso__id, prdo__id, prll)   // todo: params.prdo
                def dcta__id = datosDcta(prof__id, mate__id, crso__id, prdo, prll)   // todo: params.prdo
                def matr__id = datosMatr(estd__id, dcta__id)
//                println "---> ids: ${facl__id}, ${escl__id}, ${mate__id}"
                cnta++
            } else if (row[7] && (row[5] != "MATERIA")) {
                errores += "<li>datos: ${row.size()}:  ${row}</li>"
//                println "datos: ${row.size()}:  ${row}"
            }

        } else if (row[7] && (row[5] != "MATERIA")) {
            errores += "<li>Datos: ${row.size()}:  ${row}</li>"
//            println "xxxxx long: ${row.size()}:  ${row}"
        } //row ! empty
        return [errores: errores, cnta: cnta]
    }

    def datosFacl(univ, dscr, cod) {
        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def sql = ""
        def sql2 = ""
        def cdgo = ""
        def sqlWh = " and univ__id = ${univ}"
        def actual_id = 0
        def repetido

        if(dscr != 'FACULTAD' && cod != 'CÓDIGO'){
            if (dscr?.size() < 9) {
//            sql = "select facl__id, faclcdgo, facldscr from facl where faclcdgo = '${dscr}'"
//                sql = "select facl__id, faclcdgo, facldscr from facl where facldscr = '${dscr}'"
                cdgo = cod ?: dscr
                dscr = dscr
            } else {
//            sql = "select escl__id, faclcdgo, facldscr from facl where facldscr = '${dscr}'"
//                sql = "select facl__id, faclcdgo, facldscr from facl where facldscr = '${dscr}'"
                cdgo = cod ?: dscr[0..7].trim()
                dscr = dscr
            }

            sql2 = "select faclcdgo from facl where faclcdgo = '${cod}' and univ__id = '${univ}'"

            sql = "select facl__id, faclcdgo, facldscr from facl where facldscr = '${dscr}' and faclcdgo= '${cdgo}'"

            repetido = cn2.rows(sql2.toString())[0]?.faclcdgo

            sql += sqlWh
            actual_id = cn.rows(sql.toString())[0]?.facl__id
            def facldscr = cn.rows(sql.toString())[0]?.facldscr
            def faclcdgo = cn.rows(sql.toString())[0]?.faclcdgo

            if(!repetido){
                if (!actual_id) {
                    println "---> inserta facultad: ${cdgo}"
                    sql = "insert into facl(facl__id, faclcdgo, facldscr, univ__id) " +
                            "values (default, '${cdgo}', '${dscr}', ${univ})"
                    actual_id = cn.executeInsert(sql.toString())[0][0]
                } else if (faclcdgo != cdgo && facldscr != dscr) {
                    sql = "update facl set faclcdgo = '${cdgo}', facldscr = '${dscr}' where facl__id = ${actual_id}"
                    cn.execute(sql.toString())
                }
            }
        }

        return actual_id
    }

    def datosEscl(dscr, facl, cod) {
        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def sql = ""
        def sql2 = ""
        def cdgo = ""
        def reg
        def actual_id = 0
        def repetido


        if(dscr != 'DEPENDENCIA' && cod != 'CÓDIGO' && facl != 'FACULTAD'){
            if (dscr?.size() < 9) {
//            sql = "select escl__id, esclcdgo, escldscr from escl where esclcdgo = '${dscr}' and facl__id = ${facl}"
//                sql = "select escl__id, esclcdgo, escldscr from escl where escldscr = '${dscr}' and facl__id = ${facl}"
                cdgo = cod ?: dscr
                dscr = dscr
            } else {
                cdgo = cod ?: dscr[0..7].trim()
                dscr = dscr
            }

            sql = "select escl__id, esclcdgo, escldscr from escl where escldscr = '${dscr}' and facl__id = ${facl} and esclcdgo = '${cdgo}'"

            sql2 = "select esclcdgo from escl where esclcdgo = '${cdgo}' and facl__id = ${facl}"

            repetido = cn2.rows(sql2.toString())[0]?.esclcdgo
//            println "sql: $sql2 \n-->$repetido"

            reg = cn.rows(sql.toString())[0]
            actual_id = reg?.escl__id

            if(!repetido){
                if (!actual_id) {
                    println "---> inserta escuela: ${cdgo}"
                    sql = "insert into escl(escl__id, facl__id, esclcdgo, escldscr) " +
                            "values (default, ${facl}, '${cdgo}', '${dscr}')"
                    actual_id = cn.executeInsert(sql.toString())[0][0]
                } else if (reg.esclcdgo != cdgo && reg.escldscr != dscr) {
                    sql = "update escl set esclcdgo = '${cdgo}', escldscr = '${dscr}' where escl__id = ${actual_id}"
                    cn.execute(sql.toString())
                }else if(reg.esclcdgo != cdgo){
                    sql = "update escl set esclcdgo = '${cdgo}' where escl__id = ${actual_id}"
                    cn.execute(sql.toString())
                }
            }

        }

        return actual_id
    }

    def datosMate(cdgo, dscr, univ, escl) {
        println "datosMate: univ: $univ, escl: $escl"
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def mate_id = 0
        def actual_id = 0

        if(cdgo != 'Código' && escl != 'Escuela'){
            sql = "select mtes__id, matecdgo, matedscr from mate, mtes " +
//                    "where matecdgo = '${cdgo.trim()}'"
                    "where mate.mate__id = mtes.mate__id and matecdgo = '${cdgo.trim()}' and escl__id = ${escl} and " +
                    "univ__id = ${univ}"
            reg = cn.rows(sql.toString())[0]
            println "mate --> $sql \n ${reg} \nescl: $escl"
            actual_id = reg?.mtes__id
            if (!actual_id) {
                println "---> inserta materia: ${cdgo}"
                sql = "insert into mate(mate__id, univ__id, matecdgo, matedscr) " +
                        "values (default, ${univ}, '${cdgo}', '${dscr}')"
                mate_id = cn.executeInsert(sql.toString())[0][0]

                /** inserta materiasEscuela **/
                println "---> inserta materiaEscuela: ${mate_id}, escl: $escl"
                sql = "insert into mtes(mtes__id, mate__id, escl__id) " +
                        "values (default, ${mate_id}, ${escl})"
                actual_id = cn.executeInsert(sql.toString())[0][0]
            } else if (reg.matedscr != dscr) {
                /** no se debería actualizar el nombre d ela materia **/
                sql = "update mate set matedscr = '${dscr}' where mate__id = ${actual_id}"
                cn.execute(sql.toString())
            }
        }
        println"---> mtes__id: ${actual_id}"
        return actual_id
    }

    def datosProf(cdla, nmbr, apll, sexo, titl, univ, escl) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def cnta = 0
        def prof_id = 0
        def actual_id = 0

        if(cdla != 'Cédula' && nmbr != 'NOMBRES' && apll !='APELLIDOS' && sexo !='SEXO' && titl != 'TÍTULO'){
            sql = "select pfes__id, profnmbr, profapll, proftitl from pfes, prof " +
                    "where prof.prof__id = pfes.prof__id and profcdla = '${cdla}' and " +
                    "escl__id = ${escl} and univ__id = ${univ}"
//        println "sql: $sql"
            reg = cn.rows(sql.toString())[0]
            actual_id = reg?.pfes__id
            if (!actual_id) {
                println "---> inserta profesor: ${nmbr}"
                sql = "insert into prof(prof__id, univ__id, profcdla, profnmbr, profapll, " +
                        "profsexo, proftitl, profetdo, profeval) " +
                        "values (default, ${univ}, '${cdla}', '${nmbr}', '${apll}', " +
                        "'${sexo}', '${titl ?: ''}', 'N', 'N')"
                prof_id = cn.executeInsert(sql.toString())[0][0]
                /** inserta profesorEscuela **/
                println "---> inserta profEscuela: ${prof_id}"
                sql = "insert into pfes(pfes__id, prof__id, escl__id) " +
                        "values (default, ${prof_id}, ${escl})"
                actual_id = cn.executeInsert(sql.toString())[0][0]

            } else if (reg.profnmbr != nmbr || reg.profapll != apll) {
                sql = "update prof set profnmbr = '${nmbr}', profapll = '${apll}' where prof__id = ${actual_id}"
                cn.execute(sql.toString())
                println "corrige: ${cdla} de ${reg.profnmbr} ${reg.profapll} a ${nmbr} ${apll}"
            }
        }
        println"---> pfes__id: ${actual_id}"
        return actual_id
    }

    def datosEstd(cdgo, nmbr, apll, univ) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def cnta = 0
        def actual_id = 0

        if(cdgo != 'Cédula' && nmbr != 'NOMBRES' && apll != 'APELLIDOS'){
            sql = "select estd__id, estdnmbr, estdapll from estd " +
                    "where estdcdla = '${cdgo}'"
//        println "sql: $sql"
            reg = cn.rows(sql.toString())[0]
            actual_id = reg?.estd__id
            if (!actual_id) {
                println "---> inserta estd: ${nmbr}"
                sql = "insert into estd(estd__id, univ__id, estdcdla, estdnmbr, estdapll) " +
                        "values (default, ${univ}, '${cdgo}', '${nmbr}', '${apll}')"
                actual_id = cn.executeInsert(sql.toString())[0][0]
            } else if (reg.estdnmbr != nmbr || reg.estdapll != apll) {
                sql = "update estd set estdnmbr = '${nmbr}', estdapll = '${apll}' where estd__id = ${actual_id}"
                cn.execute(sql.toString())
                println "corrige estd: ${cdgo} de ${reg.estdnmbr} ${reg.estdapll} a ${nmbr} ${apll}"
            }
        }

        return actual_id
    }

    def datosCrso(crso) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def cnta = 0
        def actual_id = 0

        sql = "select crso__id, crsodscr from crso where crsodscr = '${crso}'"
//        println "sql: $sql"
        reg = cn.rows(sql.toString())[0]
        actual_id = reg?.crso__id
        if (!actual_id) {
            println "---> inserta crso: ${crso}"
            sql = "insert into crso(crso__id, crsodscr) values (default, '${crso}')"
            actual_id = cn.executeInsert(sql.toString())[0][0]
        }
        return actual_id
    }

    def datosIngresoCrso(cdgo, nmbr) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def cnta = 0
        def actual_id = 0

        if(cdgo != 'Código'){
            sql = "select crso__id, crsodscr, crsocdgo from crso where crsocdgo = '${cdgo}'"
//        println "sql: $sql"
            reg = cn.rows(sql.toString())[0]
            actual_id = reg?.crso__id
            if (!actual_id) {
                println "---> inserta crso: ${nmbr}"
                sql = "insert into crso(crso__id, crsodscr, crsocdgo) values (default, '${nmbr}', '${cdgo}')"
                actual_id = cn.executeInsert(sql.toString())[0][0]
            }else if (reg.crsocdgo != cdgo || reg.crsodscr != nmbr) {
                sql = "update crso set crsodscr = '${nmbr}', crsocdgo = '${cdgo}' where crso__id = ${actual_id}"
                cn.execute(sql.toString())
                println "corrige crso: ${cdgo} de ${reg.crsocdgo} ${reg.crsodscr} a ${cdgo} ${nmbr}"
            }
        }
        return actual_id
    }


    def datosDcta(prof, mate, crso, prdo, prll) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def cnta = 0
        def actual_id = 0

        if(prll != 'PARALELO'){
            sql = "select dcta__id, dctaprll from dcta where pfes__id = ${prof} and mtes__id = ${mate} and " +
                    "crso__id = ${crso} and prdo__id = ${prdo} and dctaprll = ${prll}"
//        println "sql: $sql"
            reg = cn.rows(sql.toString())[0]
            actual_id = reg?.dcta__id
            if (!actual_id) {
                println "---> inserta dcta: ${prll}"
                sql = "insert into dcta(dcta__id, pfes__id, mtes__id, crso__id, prdo__id, dctaprll) " +
                        "values (default, ${prof}, ${mate}, ${crso}, ${prdo}, ${prll} )"
                actual_id = cn.executeInsert(sql.toString())[0][0]
            }
        }

        return actual_id
    }

    def datosMatr(estd, dcta) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def cnta = 0
        def actual_id = 0

        sql = "select matr__id from matr where estd__id = ${estd} and dcta__id = ${dcta}"
//        println "sql: $sql"
        reg = cn.rows(sql.toString())[0]
        actual_id = reg?.matr__id
        if (!actual_id) {
            println "---> inserta matr: ${dcta}"
            sql = "insert into matr(matr__id, estd__id, dcta__id) " +
                    "values (default, ${estd}, ${dcta})"
            actual_id = cn.executeInsert(sql.toString())[0][0]
        }
        return actual_id
    }


    def procesar() {

    }

    /** Ejecuta función: desempeño **/
    def progreso() {
        println "$params"
        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def retorna = ""
        def sql = "select facl.facl__id, facldscr, count(*) cnta from encu, prof, escl, facl, dcta " +
                "where encu.prdo__id = ${params.periodo} and " +
                "prof.prof__id = encu.prof__id and dcta.prof__id = prof.prof__id and escl.escl__id = dcta.escl__id and " +
                "facl.facl__id = escl.facl__id and encu.teti__id = 2 group by facl.facl__id, facldscr order by facldscr"

        println "sql: $sql"

        cn.eachRow(sql.toString()) { d ->
            render(d.facl__id + "_" + d.cnta + "_" + d.facldscr + "*")
        }
    }

    /** Ejecuta función: tendencias **/
    def tendencia() {
//        println "$params"
        def cn = dbConnectionService.getConnection()
        def cn1 = dbConnectionService.getConnection()
        def retorna = ""
        def sql = "select facl.facl__id, facldscr, count(*) cnta from encu, estd, matr, dcta, prof, escl, facl " +
                "where encu.prdo__id = ${params.periodo} and estd.estd__id = encu.estd__id and " +
                "matr.estd__id = estd.estd__id and dcta.dcta__id = matr.dcta__id and encu.teti__id = 4 and " +
                "encuetdo = 'C' and prof.prof__id = dcta.prof__id and escl.escl__id = dcta.escl__id and " +
                "facl.facl__id = escl.facl__id " +
                "group by facl.facl__id, facldscr order by facldscr"

        println "sql: $sql"


        cn.eachRow(sql.toString()) { d ->
            render(d.facl__id + "_" + d.cnta + "_" + d.facldscr + "*")
        }
    }

    def procesaFacl() {
        println "$params"
        def partes = params.arreglo.split("_")
        def total = params.total.toInteger()
//        def regla = (partes[1].toInteger()*100/total)
        def regla = (params.parcial.toInteger() * 100 / total)
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

    def procesaTndn() {
        println "procesaTndn: $params"
        def partes = params.arreglo.split("_")
        def total = params.total.toInteger()
        def regla = (params.parcial.toInteger() * 100 / total)

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

    def descripcion_ajax() {
        def partes = params.parte.split("_")
        def facultad = partes[2]
        return [facultad: facultad]
    }

    def totales() {
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

//    public static void readXLSXFile() throws IOException
//    def readXLSXFile() {
//
//        def path = servletContext.getRealPath("/")
//        InputStream ExcelFileToRead = new FileInputStream(path + "xlsData/espol.xlsx");
//        XSSFWorkbook wb = new XSSFWorkbook(ExcelFileToRead);
//
//        XSSFWorkbook test = new XSSFWorkbook();
//
//        XSSFSheet sheet = wb.getSheetAt(0);
//        XSSFRow row;
//        XSSFCell cell;
//
//        Iterator rows = sheet.rowIterator();
//
//        while (rows.hasNext()) {
//            row = (XSSFRow) rows.next();
//            Iterator cells = row.cellIterator();
//            while (cells.hasNext()) {
//                cell = (XSSFCell) cells.next();
//
//                if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
//                    System.out.print(cell.getStringCellValue() + " ");
//                } else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
//                    System.out.print(cell.getNumericCellValue() + " ");
//                } else {
//                    //U Can Handel Boolean, Formula, Errors
//                }
//            }
//            System.out.println();
//        }
//
//    }

    def cargarDatosFacultades (univ, row) {

        def errores = ""
        def cnta = 0

        if (row.size() == 2) {
            def cod = row[0].toString().trim()
            def facl = row[1].toString().trim()
            def facl__id = datosFacl(univ, facl.toUpperCase(), cod.toUpperCase())
            cnta++
        }else{
            errores += "<li>No ingreso la cantidad correcta de columnas en el archivo: ${row[0] ?: row[1]} - número de columnas: ${row.size()} </li>"
        }

        return [errores: errores, cnta: cnta]
    }

    def cargarDatosEscuelas (row) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def errores = ""
        def cnta = 0
        def facultadId = 0

        if (row.size() == 3) {
            def facl = row[2].toString().trim()
            sql = "select facl__id from facl where faclcdgo = '${facl}'"
            facultadId = cn.rows(sql.toString())[0]?.facl__id
            def cod = row[0].toString().trim()
            def escu = row[1].toString()
            def escu__id = datosEscl(escu.toUpperCase(),facultadId, cod.toUpperCase())
            cnta++
        }else{
            errores += "<li>No ingreso la cantidad correcta de columnas en el archivo: ${row[0] ?: row[1]} - número de columnas: ${row.size()} </li>"
        }

        return [errores: errores, cnta: cnta]
    }

    def cargarDatosProfesor(row){

        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def sql = ""
        def sql2 = ""
        def errores = ""
        def cnta = 0
        def facultadId = 0
        def escuelaId = 0

        if (row.size() == 7) {
            def facl = row[0].toString().trim()
            sql = "select facl__id from facl where faclcdgo = '${facl}'"
            facultadId = cn.rows(sql.toString())[0]?.facl__id
            def escu = row[1].toString().trim()
            sql2 = "select escl__id from escl where esclcdgo = '${escu}'"
            escuelaId = cn2.rows(sql2.toString())[0]?.escl__id

            def cedula = row[2].toString().trim()
            def nombres = row[3].toString()
            def apellidos = row[4].toString()
            def sexo = row[5].toString()[0]
            def titulo = row[6].toString()
            def profesor = datosProf(cedula, nombres.toUpperCase(), apellidos.toUpperCase(), sexo.toUpperCase(), titulo.toUpperCase(), escuelaId)

            cnta++
        }else{
            errores += "<li>No ingreso la cantidad correcta de columnas en el archivo: ${row[0] ?: row[1]} - número de columnas: ${row.size()} </li>"
        }

        return [errores: errores, cnta: cnta]
    }

    def cargarDatosEstudiante(row){

        def errores = ""
        def cnta = 0

        if (row.size() == 3) {
            def cedula = row[0].toString().trim()
            def nombres = row[1].toString()
            def apellidos = row[2].toString()

            def estudiante = datosEstd(cedula, nombres.toUpperCase(), apellidos.toUpperCase())

            cnta++
        }else{
            errores += "<li>No ingreso la cantidad correcta de columnas en el archivo: ${row[0] ?: row[1]} - número de columnas: ${row.size()} </li>"
        }

        return [errores: errores, cnta: cnta]
    }

    def cargarDatosMaterias (row){

        def cn = dbConnectionService.getConnection()
        def sql = ""
        def escuelaId = 0

        def errores = ""
        def cnta = 0

        if (row.size() == 4) {

            def codigo = row[0].toString().trim()
            def nombre = row[1].toString().replace("'",'')
            def escuela = row[3].toString()

            sql = "select escl__id  from escl where esclcdgo='${escuela}'"
            escuelaId = cn.rows(sql.toString())[0]?.escl__id

            def materia = datosMate(codigo, nombre.toUpperCase(), escuelaId)

            cnta++
        }else{
            errores += "<li>No ingreso la cantidad correcta de columnas en el archivo: ${row[0] ?: row[1]} - número de columnas: ${row.size()} </li>"
        }

        return [errores: errores, cnta: cnta]
    }

    def cargarDatosCursos (row) {
        def errores = ""
        def cnta = 0

        if (row.size() == 2) {
            def codigo = row[0].toString().trim()
            def nombre = row[1].toString()

            def curso = datosIngresoCrso(codigo, nombre.toUpperCase())

            cnta++
        }else{
            errores += "<li>No ingreso la cantidad correcta de columnas en el archivo: ${row[0] ?: row[1]} - número de columnas: ${row.size()} </li>"
        }

        return [errores: errores, cnta: cnta]
    }

    def cargarDatosDictan(row, periodo){

        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def sql = ""
        def sql2 = ""
        def cursoId = 0
        def materiaId = 0

        def errores = ""
        def cnta = 0

        if (row.size() == 4) {

            def cedula = row[0].toString().trim()
            def materia = row[1].toString()
            def curso = row[2].toString()
            def paralelo = row[3].toString()

            sql = "select crso__id from crso where crsocdgo='${curso}'"
            cursoId = cn.rows(sql.toString())[0]?.crso__id
            sql2 = "select mate__id from mate where matecdgo = '${materia}'"
            materiaId = cn2.rows(sql2.toString())[0]?.mate__id

            def dictan = datosDcta(cedula, materiaId, cursoId, periodo, paralelo.toUpperCase())

            cnta++
        }else{
            errores += "<li>No ingreso la cantidad correcta de columnas en el archivo: ${row[0] ?: row[1]} - número de columnas: ${row.size()} </li>"
        }

        return [errores: errores, cnta: cnta]
    }

    def cargarDatosMatriculados(row, periodo){
        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def cn3 = dbConnectionService.getConnection()
        def cn4 = dbConnectionService.getConnection()
        def cn5 = dbConnectionService.getConnection()
        def sql = ""
        def sql2 = ""
        def sql3 = ""
        def sql4 = ""
        def sql5 = ""
        def cursoId = 0
        def materiaId = 0
        def estudianteId = 0
        def profesorId = 0
        def dictaId = 0

        def errores = ""
        def cnta = 0

        if (row.size() == 5) {

            def cedulaE = row[0].toString().trim()
            def cedulaP = row[1].toString().trim()
            def materia = row[2].toString()
            def curso = row[3].toString()
            def paralelo = row[4].toString()

            sql3 = "select estd__id from estd where estdcdla = '${cedulaE}'"
            estudianteId = cn3.rows(sql3.toString())[0]?.estd__id
            sql = "select crso__id from crso where crsocdgo='${curso}'"
            cursoId = cn.rows(sql.toString())[0]?.crso__id
            sql2 = "select mate__id from mate where matecdgo = '${materia}'"
            materiaId = cn2.rows(sql2.toString())[0]?.mate__id
            sql4 = "select prof__id from prof where profcdla = '${cedulaP}'"
            profesorId = cn4.rows(sql4.toString())[0]?.prof__id
            sql5 = "select dcta__id from dcta where prof__id = ${profesorId} and mate__id = ${materiaId} and crso__id = ${cursoId} and prdo__id = ${periodo} and dctaprll = ${paralelo}"
            dictaId = cn5.rows(sql5.toString())[0]?.dcta__id

            def dictan = datosMatr(estudianteId, dictaId)

            cnta++
        }else{
            errores += "<li>No ingreso la cantidad correcta de columnas en el archivo: ${row[0] ?: row[1]} - número de columnas: ${row.size()} </li>"
        }

        return [errores: errores, cnta: cnta]
    }

}
