package utilitarios

import com.itextpdf.awt.DefaultFontMapper
import com.itextpdf.text.BaseColor
import com.itextpdf.text.Document
import com.itextpdf.text.Element
import com.itextpdf.text.Font
import com.itextpdf.text.Image
import com.itextpdf.text.PageSize
import com.itextpdf.text.Paragraph
import com.itextpdf.text.pdf.PdfContentByte
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.pdf.PdfPTable
import com.itextpdf.text.pdf.PdfTemplate
import com.itextpdf.text.pdf.PdfWriter
import docentes.Escuela
import docentes.Facultad
import docentes.Periodo
import docentes.Profesor
import docentes.ReporteEncuesta
import docentes.Universidad
import grails.converters.JSON
import groovy.json.JsonBuilder
import org.apache.poi.ss.usermodel.HorizontalAlignment
import org.jfree.chart.ChartFactory
import org.jfree.chart.JFreeChart
import org.jfree.chart.plot.CategoryPlot
import org.jfree.chart.plot.PlotOrientation
import org.jfree.chart.renderer.category.BarRenderer
import org.jfree.data.category.CategoryDataset
import org.jfree.data.category.DefaultCategoryDataset

import java.awt.Color
import java.awt.Graphics2D
import java.awt.geom.Rectangle2D

class ReportesGrafController extends seguridad.Shield {
    def dbConnectionService

    def index() {
    }

    def clasificar() {
        println "clasificar $params"
        def cn = dbConnectionService.getConnection()

        def periodo = Periodo.get(params.prdo)
        def facultad
        def facultadId
        if (params.facl) {
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

        sql = "select count(distinct (rpec.prof__id, dcta__id)) cnta, clase from rpec, prof, escl " +
                "where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and rpec.facl__id::varchar ilike '${facultadId}' and tpen__id = 2 and " +
                "univ__id = ${params.univ} and escl.escl__id = ${params.escl} " +
                "group by clase order by clase"
        println "sql: $sql"
        cn.eachRow(sql.toString()) { d ->
            data[d.clase] = d.cnta
            totl += d.cnta
        }

        sql = "select count(distinct (rpec.prof__id, dcta__id)) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and rpec.facl__id::varchar ilike '${facultadId}' and con_rcmn > 0 and tpen__id = 2 and " +
                "univ__id = ${params.univ} and escl.escl__id = ${params.escl}"
//        println "sql: $sql"
        rcmn = cn.rows(sql.toString())[0].cnta
//        println "data: $data, rc: $rcmn, totl: $totl"
        subtitulo = "PROFESORES POR DESEMPEÑO"

        /* para demostración */
//        render "60_71_28_Todas las Facultades_43_159_RECOMENDACIONES"
        render "${data.A?:0}_${data.B?:0}_${data.C?:0}_${facultad}_${rcmn}_${totl-rcmn}_RECOMENDACIONES"
    }

    def dialogo_ajax() {

//        println("entro " + params)

        def periodo = Periodo.get(params.periodo)
        def facultad
        def facultadId
        def cn = dbConnectionService.getConnection()
        def res
        def sql

        if (params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = "Todas las Facultades"
            facultadId = "%"
        }


        if (params.tipo == '1') {
            sql = "select escldscr, profnmbr, profapll, proftitl, dctaprll, matedscr, clase " +
                    "from rpec, prof, escl, dcta, mate " +
                    "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
                    "facl__id::varchar ilike '${facultadId}' and dcta.dcta__id = rpec.dcta__id and " +
                    "mate.mate__id = dcta.mate__id and clase = '${params.etiqueta}' and rpec.prdo__id = ${periodo.id} and " +
                    "tpen__id = 2 " +
                    "group by escldscr, profnmbr, profapll, proftitl, dctaprll, matedscr, clase " +
                    "order by clase"
        } else {
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

        def periodo = Periodo.get(params.prdo)
        def facultad
        def facultadId
        def evaluados
        if (params.escl.toInteger()) {
            facultad = "${Facultad.get(params.facl).nombre} - ${Escuela.get(params.escl).nombre}"
        }

        def sql
        def data = [:]
        data.facultad = facultad

        sql = "select count(distinct(rpec.prof__id, dcta__id)) cnta from rpec, prof " +
                "where prof.prof__id = rpec.prof__id and " +
                "prof.escl__id = ${params.escl} and tpen__id = 2 and prdo__id = ${params.prdo}"
        println "evaluados: $sql"
        evaluados = (cn.rows(sql.toString())[0]?.cnta ?: 0) * 100

        sql = "select avg(promedio) prom from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and rpec.escl__id = ${params.escl} and " +
                "tpen__id = 2 and prdo__id = ${params.prdo}"
        println "promedio: $sql"
        data.promedio = (cn.rows(sql.toString())[0]?.prom ?: 0) * 100
        data.promedio = Math.round(data.promedio * 100)/100

        sql = "select count(distinct(prof.prof__id, rpec.dcta__id)) cnta from rpec, prof, escl " +
                "where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and rpec.escl__id = ${params.escl} and " +
                "prdo__id = ${params.prdo} and tpen__id = 2 "
        println "prof: $sql"
        data.prof = cn.rows(sql.toString())[0].cnta

        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "rpec.escl__id = ${params.escl} and tndn.prdo__id = ${params.prdo} and tndnptnv > 0 and " +
                "tpen__id = 2"
        println "ptnv: $sql"
        if (data.prof) {
            data.ptnv = cn.rows(sql.toString())[0].cnta / data.prof * 100
        } else {
            data.ptnv = 0
        }
        data.ptnv = Math.round(data.ptnv * 100)/100

        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "rpec.escl__id = ${params.escl} and tndn.prdo__id = ${params.prdo} and tndnccbb > 0 and " +
                "tpen__id = 2"
        println "ccbb: $sql"
        if (data.prof) {
            data.ccbb = cn.rows(sql.toString())[0].cnta / data.prof * 100
        } else {
            data.ccbb = 0
        }
        data.ccbb = Math.round(data.ccbb * 100)/100


        sql = "select count(*) cnta from tndn, rpec where tndn.prof__id = rpec.prof__id and " +
                "rpec.escl__id = ${params.escl} and tndn.prdo__id = ${params.prdo} and tndnfcex > 0 and " +
                "tpen__id = 2"
        println "fcex: $sql"
        if (data.prof) {
            data.fcex = cn.rows(sql.toString())[0].cnta / data.prof * 100
        } else {
            data.fcex = 0
        }
        data.fcex = Math.round(data.fcex * 100)/100


        sql = "select count(*) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = prof.escl__id and rpec.escl__id = ${params.escl} and " +
                "con_rcmn > 0 and tpen__id = 2 and prdo__id = ${params.prdo}"
        println "rcmn: $sql"
        if (data.prof) {
            data.rcmn = cn.rows(sql.toString())[0].cnta / data.prof * 100
        } else {
            data.rcmn = 0
        }
        data.rcmn = Math.round(data.rcmn * 100)/100

        println "data: $data"
//        println "data: ${data as JSON}"

        /** valores para demostración **/
//        data = [facultad: "Todas las Facultades", promedio: 84.8, prof: 14, ptnv: 17.1, ccbb: 34.2, fcex: 31.1, rcmn: 42.8]

        render data as JSON
    }

    def tipoEncuesta() {

    }

    def tipoEncuestaData() {
        println "tipoEncuestaData $params"
        def cn = dbConnectionService.getConnection()
        def sql
        def data = [:]

/*
        sql = "select avg(promedio)::numeric(5,2) prom, rpec.tpen__id, tpendscr, facl.facl__id, facldscr " +
                "from rpec, prof, escl, facl, tpen " +
                "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
                "facl.facl__id = escl.facl__id and rpec.tpen__id in (1,2,3,5) and prdo__id = ${params.prdo} and " +
                "tpen.tpen__id = rpec.tpen__id " +
                "group by rpec.tpen__id, facldscr, facl.facl__id, tpendscr order by facl.facl__id, tpendscr, rpec.tpen__id"
*/
        sql = "select avg(promedio)::numeric(5,2) prom, rpec.tpen__id, tpendscr, escl.escl__id, escldscr " +
                "from rpec, prof, escl, tpen " +
                "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
                "rpec.tpen__id in (1,2,3,5) and prdo__id = ${params.prdo} and escl.facl__id = ${params.facl} and " +
                "tpen.tpen__id = rpec.tpen__id " +
                "group by rpec.tpen__id, escldscr, escl.escl__id, tpendscr order by escl.escl__id, tpendscr, rpec.tpen__id"
        println "sql: $sql"
        def datos = cn.rows(sql.toString())
//        println datos
        def txto = ""
        def tx = ""
        def te = ""
        def facl = datos.escl__id.unique()
        def facultades = datos.escldscr.unique()
        def tpen = datos.tpen__id.unique()
//        println "facl: $facl"
//        println "tpen: $tpen"
        for (i in tpen) {
            for (j in facl) {
                te = "${datos.find { it.tpen__id == i }.tpendscr}"
                tx = "${datos.find { it.escl__id == j && it.tpen__id == i }?.prom ?: 0}"
                txto += txto ? "_$tx" : tx
            }
            data[i] = [tpen: te, valor: txto]
            txto = ""
        }

//        println "datos: ${data as JSON}"

        /* se envía el mapa como objeto JSON */
        def respuesta = "${facultades.join('_')}||${data as JSON}"
        println respuesta
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

//        sql = "select avg(ddsc)::numeric(5,2) ddsc, avg(ddac)::numeric(5,2) ddac, avg(ddhd)::numeric(5,2) ddhd, " +
//                "avg(ddci)::numeric(5,2) ddci, avg(dcni)::numeric(5,2) dcni, avg(d_ea)::numeric(5,2) d_ea, " +
//                "facl.facl__id, facldscr " +
//                "from rpec, prof, escl, facl " +
//                "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
//                "facl.facl__id = escl.facl__id and rpec.tpen__id = 2 and prdo__id = ${params.prdo} " +
//                "group by facldscr, facl.facl__id order by facl.facl__id"


        sql = "select avg(ddsc)::numeric(5,2) ddsc, avg(ddac)::numeric(5,2) ddac, avg(ddhd)::numeric(5,2) ddhd, " +
                "avg(ddci)::numeric(5,2) ddci, avg(dcni)::numeric(5,2) dcni, avg(d_ea)::numeric(5,2) d_ea, " +
                "facl.facl__id, facldscr, escl.escl__id, escldscr " +
                "from rpec, prof, escl, facl " +
                "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
                "facl.facl__id = escl.facl__id and rpec.tpen__id = 2 and prdo__id = ${params.prdo} and escl.facl__id = ${params.facl} " +
                "group by facldscr, escldscr, facl.facl__id, escl.escl__id order by facl.facl__id"


        println "sql: $sql"
        def datos = cn.rows(sql.toString())
//        println datos
        def txto = ""
        def tx_ddsc, tx_ddac, tx_ddhd, tx_ddci, tx_dcni, tx_d_ea
        def tx_1, tx_2, tx_3, tx_4, tx_5, tx_6
        tx_1 = ""; tx_2 = ""; tx_3 = ""; tx_4 = ""; tx_5 = ""; tx_6 = "";
        def facl = datos.facl__id.unique()
        def facultades = datos.facldscr.unique()
        def escuelas = datos.escldscr.unique()
        def escl = datos.escl__id.unique()

//        println "facl: $facl"
//        println "tpen: $tpen"

//        for (j in facl) {
        for (j in escl) {
//            tx_ddsc = "${datos.find { it.facl__id == j }?.ddsc ?: 0}"
//            tx_ddac = "${datos.find { it.facl__id == j }?.ddac ?: 0}"
//            tx_ddhd = "${datos.find { it.facl__id == j }?.ddhd ?: 0}"
//            tx_ddci = "${datos.find { it.facl__id == j }?.ddci ?: 0}"
//            tx_dcni = "${datos.find { it.facl__id == j }?.dcni ?: 0}"
//            tx_d_ea = "${datos.find { it.facl__id == j }?.d_ea ?: 0}"
            tx_ddsc = "${datos.find { it.escl__id == j }?.ddsc ?: 0}"
            tx_ddac = "${datos.find { it.escl__id == j }?.ddac ?: 0}"
            tx_ddhd = "${datos.find { it.escl__id == j }?.ddhd ?: 0}"
            tx_ddci = "${datos.find { it.escl__id == j }?.ddci ?: 0}"
            tx_dcni = "${datos.find { it.escl__id == j }?.dcni ?: 0}"
            tx_d_ea = "${datos.find { it.escl__id == j }?.d_ea ?: 0}"
            tx_1 += tx_1 ? "_$tx_ddsc" : tx_ddsc
            tx_2 += tx_2 ? "_$tx_ddac" : tx_ddac
            tx_3 += tx_3 ? "_$tx_ddhd" : tx_ddhd
            tx_4 += tx_4 ? "_$tx_ddci" : tx_ddci
            tx_5 += tx_5 ? "_$tx_dcni" : tx_dcni
            tx_6 += tx_6 ? "_$tx_d_ea" : tx_d_ea
        }

        data[1] = [vrbl: 'DSC', valor: tx_1]
        data[2] = [vrbl: 'DAC', valor: tx_2]
        data[3] = [vrbl: 'DHD', valor: tx_3]
        data[4] = [vrbl: 'DCI', valor: tx_4]
        data[5] = [vrbl: 'CNI', valor: tx_5]
        data[6] = [vrbl: 'EA', valor: tx_6]

//        println "datos: ${data as JSON}"

        /* se envía el mapa como objeto JSON */
//        def respuesta = "${facultades.join('_')}||${data as JSON}"
        def respuesta = "${escuelas.join('_')}||${data as JSON}"
//        println "respuesta variables " + respuesta
        render respuesta
    }

    def competencias() {

    }

    def cmptData() {
//        println "variablesData $params"
        def cn = dbConnectionService.getConnection()
        def sql
        def data = [:]

        sql = "select row_number() over (order by tipo desc) nmro, tipo, cmpt, profpcnt, estdpcnt from competencias(41,1)"
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

        for (j in facl) {
            tx_ddsc = "${datos.find { it.facl__id == j }?.ddsc ?: 0}"
            tx_ddac = "${datos.find { it.facl__id == j }?.ddac ?: 0}"
            tx_ddhd = "${datos.find { it.facl__id == j }?.ddhd ?: 0}"
            tx_ddci = "${datos.find { it.facl__id == j }?.ddci ?: 0}"
            tx_dcni = "${datos.find { it.facl__id == j }?.dcni ?: 0}"
            tx_d_ea = "${datos.find { it.facl__id == j }?.d_ea ?: 0}"
            tx_1 += tx_1 ? "_$tx_ddsc" : tx_ddsc
            tx_2 += tx_2 ? "_$tx_ddac" : tx_ddac
            tx_3 += tx_3 ? "_$tx_ddhd" : tx_ddhd
            tx_4 += tx_4 ? "_$tx_ddci" : tx_ddci
            tx_5 += tx_5 ? "_$tx_dcni" : tx_dcni
            tx_6 += tx_6 ? "_$tx_d_ea" : tx_d_ea
        }

        data[1] = [vrbl: 'DSC', valor: tx_1]
        data[2] = [vrbl: 'DAC', valor: tx_2]
        data[3] = [vrbl: 'DHD', valor: tx_3]
        data[4] = [vrbl: 'DCI', valor: tx_4]
        data[5] = [vrbl: 'CNI', valor: tx_5]
        data[6] = [vrbl: 'EA', valor: tx_6]

//        println "datos: ${data as JSON}"

        /* se envía el mapa como objeto JSON */
//        def respuesta = "${facultades.join('_')}||${data as JSON}"

//        def antes = '{"1":{"vrbl":"DSC","valor":"0.74_0.98"},"2":{"vrbl":"DAC","valor":"0.90_0.95"},"3":{"vrbl":"DHD","valor":"0.79_0.99"},"4":{"vrbl":"DCI","valor":"0.82_0.97"},"5":{"vrbl":"CNI","valor":"0.81_0.99"},"6":{"vrbl":"EA","valor":"0.84_0.98"}}'
        def respuesta = "${facultades.join('_')}||${data as JSON}"
        render respuesta
    }

    def periodo_ajax() {

        def universidad = Universidad.get(params.universidad)
        def periodos = Periodo.findAllByUniversidad(universidad)

        return [periodos: periodos]
    }

    def facultad_ajax() {
        def universidad = Universidad.get(params.universidad)
        def facultades = Facultad.findAllByUniversidad(universidad, [sort: 'nombre', order: 'asc'])

        return [facultades: facultades, universidad: universidad]
    }

    def competenciasGraf() {

    }

    def facultadSel_ajax() {

        def universidad = Universidad.get(params.universidad)
        def facultades = Facultad.findAllByUniversidad(universidad, [sort: 'nombre', order: 'asc'])

        return [facultades: facultades, universidad: universidad]
    }

    def escuelas_ajax() {

        def facultad = Facultad.get(params.facultad)
        def escuelas = Escuela.findAllByFacultad(facultad, [sort: 'nombre', order: 'asc'])

        return [escuelas: escuelas]
    }


    def competenciasData_ajax() {

//        println("params com" + params)
        def escuela = Escuela.get(params.escuela)
        def periodo = Periodo.get(params.prdo)
        def cn = dbConnectionService.getConnection()
        def sql
        def data = [:]
        def la

        sql = "select * from competencias(${escuela?.id}, ${periodo?.id})"
//        println "sql: $sql"
        def datos = cn.rows(sql.toString())

        datos.each {
            la = it.cmpt.substring(0, 8) + "..."
//            data.put((it.tipo + "_" + it.cmpt), ((it.estdpcnt + 1)/2 + "_" + (it.profpcnt + 1)/2))
            data.put((it.tipo + "_" + it.cmpt), it.estdpcnt + "_" + it.profpcnt )
        }

//        println "--> $data"

        def respuesta = "${data as JSON}"

        render respuesta
    }




    static CategoryDataset createDataset(datos, tipo) {

        final String P = "Profesores";
        final String E = "Estudiantes";

        final DefaultCategoryDataset dataset =
                new DefaultCategoryDataset( );

        def parts1 = []
        def parts2 = []

        def tam = datos.size()
        def ges = []
        def ees = []

        tam.times{
            ges.add('G' + (it + 1))
            ees.add('E' + (it + 1))
        }

        datos.eachWithIndex { q, k ->

//            println("q " + q + " k " + k)

            for (int i = datos.size() - 1; i > -1; i--) {
                parts1[k] = q.value.split("_")
                parts2[k] = q.key

                if(tipo == '1'){
                    dataset.addValue( parts1[k][0].toDouble() , E ,  ges[k]);
                    dataset.addValue( parts1[k][1].toDouble() , P ,  ges[k]);
                }else{
                    dataset.addValue( parts1[k][0].toDouble() , E ,  ees[k]);
                    dataset.addValue( parts1[k][1].toDouble() , P ,  ees[k]);
                }
            }

        }
        return dataset;
    }



    public static JFreeChart crearBarChart(titulo, datos, tipo) {

//        println("---- " + datos)

        DefaultCategoryDataset dataSet = new DefaultCategoryDataset();
        DefaultCategoryDataset dataSet2 = new DefaultCategoryDataset();

        JFreeChart chart = ChartFactory.createBarChart(
                "${titulo}", "Competencia", "Valor",
                createDataset(datos, tipo), PlotOrientation.VERTICAL, false, true, false);

        return chart;
    }


    def competenciasReporteGeneral () {


//        println "profesoresClases $params"

        def escuela = Escuela.get(params.escuela)
        def periodo = Periodo.get(params.periodo)
        def cn = dbConnectionService.getConnection()
        def sql
        def data = [:]
        def la
        def textos = []

        sql = "select * from competencias(${escuela?.id}, ${periodo?.id})"
//        println "sql: $sql"

        def datos = cn.rows(sql.toString())

        Font fontTitulo = new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTtlo = new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD);

        def facultad = escuela?.facultad?.nombre
        def universidad = escuela?.facultad?.universidad

        def tipo = params.tipo
        def subtitulo = ''
        def tituloArchivo = ''


        switch(tipo){
            case '1':
                data = [:]
                cn.eachRow(sql.toString()) { d ->
                    if(d.tipo == 'G'){
                        data.put((d.cmpt), d.estdpcnt + "_" + d.profpcnt )
                        textos.add(d.cmpt)
                    }
                }
//                println "data: $data"
                subtitulo = "COMPETENCIAS GENERALES"
                tituloArchivo = "competenciasGenerales"
                break;
            case '2':
                data = [:]
                cn.eachRow(sql.toString()) { d ->
                    if(d.tipo == 'E'){
                        data.put((d.cmpt), d.estdpcnt + "_" + d.profpcnt )
                        textos.add(d.cmpt)
                    }
                }
//                println "data: $data"
                subtitulo = "COMPETENCIAS ESPECÍFICAS"
                tituloArchivo = "competenciasEspecificas"
                break;
        }


        def baos = new ByteArrayOutputStream()

        Document document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();

        Paragraph parrafoUniversidad = new Paragraph("UNIVERSIDAD " + universidad?.nombre?.toUpperCase(), fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)
        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + facultad, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)
        Paragraph linea = new Paragraph(" ", fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)

        Paragraph titulo = new Paragraph(subtitulo, fontTtlo)
        titulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(linea)
//        document.add(titulo)

        def chart = crearBarChart(subtitulo,data,tipo)
        def ancho = 500
        def alto = 300

        try {

            PdfContentByte contentByte = pdfw.getDirectContent();

            Paragraph parrafo1 = new Paragraph();
            Paragraph parrafo2 = new Paragraph();

            PdfTemplate template = contentByte.createTemplate(ancho, alto);
            PdfTemplate template2 = contentByte.createTemplate(ancho, alto/10);
            Graphics2D graphics2d = template.createGraphics(ancho, alto, new DefaultFontMapper());
            Graphics2D graphics2d2 = template2.createGraphics(ancho, alto/10, new DefaultFontMapper());
            Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, ancho, alto);

            //color
            CategoryPlot plot = chart.getCategoryPlot();
            BarRenderer renderer = (BarRenderer) plot.getRenderer();
            Color color = new Color(79, 129, 189);
            renderer.setSeriesPaint(0, color);

            chart.draw(graphics2d, rectangle2d);

            graphics2d.dispose();
            Image chartImage = Image.getInstance(template);
            parrafo1.add(chartImage);

            graphics2d2.dispose();
            Image chartImage3 = Image.getInstance(template2);
            parrafo2.add(chartImage3);

            document.add(parrafo1)
            document.add(parrafo2)


        } catch (Exception e) {
            e.printStackTrace();
        }

        float[] columnas = [20,80]

        PdfPTable table = new PdfPTable(columnas); // 3 columns.
        table.setWidthPercentage(100);
        PdfPTable table2 = new PdfPTable(columnas); // 3 columns.
        table2.setWidthPercentage(100);

        PdfPCell cell1 = new PdfPCell(new Paragraph("Símbolo"))
        PdfPCell cell2 = new PdfPCell(new Paragraph("Competencia"));

        cell1.setHorizontalAlignment(Element.ALIGN_CENTER)
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER)
        cell1.setVerticalAlignment(Element.ALIGN_CENTER)
        cell2.setVerticalAlignment(Element.ALIGN_CENTER)

        cell1.setBackgroundColor(BaseColor.LIGHT_GRAY)
        cell2.setBackgroundColor(BaseColor.LIGHT_GRAY)

        table.addCell(cell1);
        table.addCell(cell2);

        def tam = textos.size()

        tam.times{
            table2.addCell(crearCelda(tipo, 'G' + (it + 1), 'E' + (it + 1)))
            table2.addCell(crearCeldaTexto(textos[it]))
        }

        document.add(table);
        document.add(table2);

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + tituloArchivo)
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def crearCelda (tipo,g,e) {
        PdfPCell cell = new PdfPCell(new Paragraph(tipo == '1' ? g : e));
        cell.setHorizontalAlignment(Element.ALIGN_CENTER)
        return cell
    }

    def crearCeldaTexto (txt) {
        PdfPCell cell = new PdfPCell(new Paragraph(txt));
        return cell
    }


}
