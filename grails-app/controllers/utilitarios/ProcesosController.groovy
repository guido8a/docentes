package utilitarios

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

            //codigo antiguo

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

            } else {
                if(ext == 'xlsx'){

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

//                    switch (tipo) {
//                        case 'Facultades':
//                            if (row.length >= 2) {
//                                def faclnmro = row[0].getContents()
//                                def facldscr = row[1].getContents()
//                                if (faclnmro != "CODIGO") {  // no es el título
//                                    if (cn.rows("select count(*) cnta from facl where faclcdgo = '${faclnmro}'".toString())[0].cnta > 0) {
//                                        cntanmro++
//                                    }
//                                    if (cn.rows("select count(*) cnta from facl where facldscr = '${facldscr}'".toString())[0].cnta > 0) {
//                                        cntadscr++
//                                    }
//                                    contador++
//                                }
//                            } //row ! empty
//                            break
//                        case 'Escuelas':
//                            if (row.length >= 3) {
//                                def esclnmro = row[0].getContents()
//                                def escldscr = row[1].getContents()
//                                def faclnmro = row[2].getContents()
//                                if (faclnmro != "CODIGO") {  // no es el título
//                                    if (cn.rows("select count(*) cnta from escl where esclcdgo = '${esclnmro}' and " +
//                                            "facl__id = (select facl__id from facl where faclcdgo = '${faclnmro}')".toString())[0].cnta > 0) {
//                                        cntanmro++
//                                    }
//                                    if (cn.rows("select count(*) cnta from escl where escldscr = '${escldscr}' and " +
//                                            "facl__id = (select facl__id from facl where faclcdgo = '${faclnmro}')".toString())[0].cnta > 0) {
//                                        cntadscr++
//                                    }
//                                    contador++
//                                }
//                            } //row ! empty
//                            break
//                        case 'Todo':
//                            def rslt = cargaDatos(row)
//                            errores += rslt.errores
//                            contador += rslt.cnta
//                            break
//                    }



            InputStream ExcelFileToRead = new FileInputStream(pathFile);
            XSSFWorkbook wb = new XSSFWorkbook(ExcelFileToRead);

            XSSFWorkbook test = new XSSFWorkbook();

            XSSFSheet sheet = wb.getSheetAt(0);
            XSSFRow row;
            XSSFCell cell;

            Iterator rows = sheet.rowIterator();

            while (rows.hasNext())
            {
                row=(XSSFRow) rows.next();
                Iterator cells = row.cellIterator();



//                println("ssss "  + cells.size())


                if(cells.size().toString() == '13'){

//                    cell=(XSSFCell) cells.next();

                    println("cell " + row.getCell(1)+ ""  )


//                    if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
//                    {
//                        System.out.print(cell.getStringCellValue()+" ");
//                    }
//                    else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC)
//                    {
//                        System.out.print(cell.getNumericCellValue()+" ");
//                    }
                }
//
//                while (cells.hasNext())
//                {
//                    cell=(XSSFCell) cells.next();



//                    if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
//                    {
//                        System.out.print(cell.getStringCellValue()+" ");
//                    }
//                    else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC)
//                    {
//                        System.out.print(cell.getNumericCellValue()+" ");
//                    }
//                    else
//                    {
//                    }
//                }
//                System.out.println();
            }

                }else{
                    flash.message = "Seleccione un archivo Excel con extensión xls o xlsx para ser procesado"
                    redirect(action: 'validar')
                }
            }
        } else {
            flash.message = "Seleccione un archivo para procesar"
            redirect(action: 'validar')
        }
    }

    /**
     * Carga datos del archivo único
     */
    def cargaDatos(univ, row) {
        def sql = ""
        def cdgo = ""
        def dscr = ""
        def actual_id = 0
        def errores = ""
        def cnta = 0
        def cn = dbConnectionService.getConnection()

        if ((row.length > 12) && row[7].getContents()) {
//                            println "procesa datos.. Estudiante: ${row[0].getContents()}"
            def estdcdgo = row[0].getContents()
            def estdapll = row[1].getContents()
            def estdnmbr = row[2].getContents()
            def facl = row[3].getContents()
            def escl = row[4].getContents()
            def mate = row[5].getContents()
            def matecdgo = row[6].getContents()
            def crso = row[7].getContents()
            def prll = row[8].getContents()
            def profnmbr = row[9].getContents()
            def profapll = row[10].getContents()
            def profsexo = row[11].getContents().toUpperCase().trim()
            def proftitl = row[12].getContents()
//                            println "sexo: ${profsexo}"
            if ((mate != "MATERIA") && (profsexo in ['M', 'F'])) {      // no es el título
              println "procesa facultades"
                def facl__id = datosFacl(univ, facl.toUpperCase())             // crea facultad
                println "procesa escuelas"
                def escl__id = datosEscl(escl.toUpperCase(), facl__id)   // crea escuela
                println "procesa materias"
                def mate__id = datosMate(matecdgo, mate, escl__id)   // crea escuela
                println "procesa profesores"
                def prof__id = datosProf(profnmbr, profapll, profsexo, proftitl, escl__id)   // crea escuela
                println "---> ids: ${facl__id}, ${escl__id}, ${mate__id}"
                cnta++
            } else if (row[7].getContents() && (row[5].getContents() != "MATERIA")) {
                errores += "<li>datos: ${row.length}:  ${row*.getContents()}</li>"
                println "datos: ${row.length}:  ${row*.getContents()}"
            }

        } else if (row[7].getContents() && (row[5].getContents() != "MATERIA")) {
            errores += "<li>Datos: ${row.length}:  ${row*.getContents()}</li>"
            println "xxxxx long: ${row.length}:  ${row*.getContents()}"
        } //row ! empty
        return [errores: errores, cnta: cnta]
    }

    def datosFacl(univ, dscr) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def cdgo = ""
        def sqlWh = " and univ__id = ${univ}"
        def actual_id = 0

        if (dscr?.size() < 9) {
            sql = "select facl__id, faclcdgo, facldscr from facl where faclcdgo = '${dscr}'" //todo: + universidad...
            cdgo = dscr
            dscr = dscr
        } else {
            sql = "select escl__id, faclcdgo, facldscr from facl where facldscr = '${dscr}'"
            cdgo = dscr[0..7].trim()
            dscr = dscr
        }
        sql += sqlWh
        actual_id = cn.rows(sql.toString())[0]?.facl__id
        def facldscr = cn.rows(sql.toString())[0]?.facldscr
        def faclcdgo = cn.rows(sql.toString())[0]?.faclcdgo
        if (!actual_id) {
            println "---> inserta facultad: ${cdgo}"
            sql = "insert into facl(facl__id, faclcdgo, facldscr) values (default, '${cdgo}', '${dscr}')"
            actual_id = cn.executeInsert(sql.toString())[0][0]
        } else if (faclcdgo != cdgo && facldscr != dscr){
            sql = "update facl set faclcdgo = '${cdgo}', facldscr = '${dscr}' where facl__id = ${actual_id}"
            cn.execute(sql.toString())
        }
        return actual_id
    }

    def datosEscl(dscr, facl) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def cdgo = ""
        def reg
        def actual_id = 0

        if (dscr?.size() < 9) {
            sql = "select escl__id, esclcdgo, escldscr from escl " +
                    "where esclcdgo = '${dscr}' and facl__id = ${facl}" //todo: + universidad...
            cdgo = dscr
            dscr = dscr
        } else {
            sql = "select escl__id, esclcdgo, escldscr from escl where escldscr = '${dscr}' and facl__id = ${facl}"
            cdgo = dscr[0..7].trim()
            dscr = dscr
        }
        reg = cn.rows(sql.toString())[0]
        actual_id = reg?.escl__id
        if (!actual_id) {
            println "---> inserta escuela: ${cdgo}"
            sql = "insert into escl(escl__id, facl__id, esclcdgo, escldscr) " +
                    "values (default, ${facl}, '${cdgo}', '${dscr}')"
            actual_id = cn.executeInsert(sql.toString())[0][0]
        } else if (reg.esclcdgo != cdgo && reg.escldscr != dscr) {
            sql = "update escl set esclcdgo = '${cdgo}', escldscr = '${dscr}' where escl__id = ${actual_id}"
            cn.execute(sql.toString())
        }
        return actual_id
    }

    def datosMate(cdgo, dscr, escl) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def actual_id = 0

        sql = "select mate__id, matecdgo, matedscr from mate " +
                "where matecdgo = '${cdgo}' and escl__id = ${escl}" //todo: + universidad...
        reg = cn.rows(sql.toString())[0]
        actual_id = reg?.mate__id
        if (!actual_id) {
            println "---> inserta materia: ${cdgo}"
            sql = "insert into mate(mate__id, escl__id, matecdgo, matedscr) " +
                    "values (default, ${escl}, '${cdgo}', '${dscr}')"
            actual_id = cn.executeInsert(sql.toString())[0][0]
        } else if (reg.matedscr != dscr) {
            sql = "update mate set matedscr = '${dscr}' where mate__id = ${actual_id}"
            cn.execute(sql.toString())
        }
        return actual_id
    }

    def datosProf(nmbr, apll, sexo, titl, escl) {
        def cn = dbConnectionService.getConnection()
        def sql = ""
        def reg
        def cnta = 0
        def actual_id = 0

        sql = "select prof__id, profnmbr, profapll, proftitl from prof " +
                "where profnmbr = '${nmbr}' and profapll = '${apll}' and escl__id = ${escl}" //todo: + universidad...
        println "sql: $sql"
        reg = cn.rows(sql.toString())[0]
        actual_id = reg?.prof__id
        sql = "select count(*) cnta from prof, escl, facl where escl.escl__id = prof.escl__id and" +
                "facl.facl__id = escl.facl__id and univ__id = 1"
        println "cnta: $sql"
        if (!actual_id) {
            println "---> inserta profesor: ${nmbr}"
            sql = "insert into prof(prof__id, escl__id, profcdla, profnmbr, profapll, " +
                    "profsexo, proftitl, profetdo, profeval) " +
                    "values (default, ${escl}, '${cdgo}', '${dscr}')"
            actual_id = cn.executeInsert(sql.toString())[0][0]
        } else if (reg.matedscr != dscr) {
            sql = "update mate set matedscr = '${dscr}' where mate__id = ${actual_id}"
            cn.execute(sql.toString())
        }
        return actual_id
    }


    def procesar() {

    }

    /** Ejecuta función: desempeño **/
    def progreso() {
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
                "encuetdo = 'C' and prof.prof__id = dcta.prof__id and escl.escl__id = prof.escl__id and " +
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
    def readXLSXFile()
    {

        def path = servletContext.getRealPath("/")
        InputStream ExcelFileToRead = new FileInputStream(path + "xlsData/espol.xlsx");
        XSSFWorkbook wb = new XSSFWorkbook(ExcelFileToRead);

        XSSFWorkbook test = new XSSFWorkbook();

        XSSFSheet sheet = wb.getSheetAt(0);
        XSSFRow row;
        XSSFCell cell;

        Iterator rows = sheet.rowIterator();

        while (rows.hasNext())
        {
            row=(XSSFRow) rows.next();
            Iterator cells = row.cellIterator();
            while (cells.hasNext())
            {
                cell=(XSSFCell) cells.next();

                if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
                {
                    System.out.print(cell.getStringCellValue()+" ");
                }
                else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC)
                {
                    System.out.print(cell.getNumericCellValue()+" ");
                }
                else
                {
                    //U Can Handel Boolean, Formula, Errors
                }
            }
            System.out.println();
        }

    }


}
