package utilitarios

import com.itextpdf.awt.DefaultFontMapper
import com.itextpdf.awt.PdfGraphics2D
import com.itextpdf.text.pdf.PdfContentByte
import com.itextpdf.text.pdf.PdfPCell
import com.itextpdf.text.pdf.PdfPCellEvent
import com.itextpdf.text.pdf.PdfPTable
import com.itextpdf.text.pdf.PdfTemplate
import com.itextpdf.text.pdf.codec.Base64
import docentes.Dictan
import docentes.Escuela
import docentes.Facultad
import docentes.Periodo
import docentes.Profesor
import docentes.ReporteEncuesta
import docentes.TipoEncuesta
import docentes.Universidad
import docentes.Variables
import org.jfree.chart.plot.CategoryPlot
import org.jfree.chart.plot.PiePlot
import org.jfree.chart.plot.PlotOrientation
import org.jfree.chart.renderer.category.BarRenderer
import org.jfree.chart.title.Title
import org.jfree.data.category.DefaultCategoryDataset
import seguridad.Persona

import java.awt.BasicStroke
import java.awt.Color
import java.awt.Graphics2D
import java.awt.Image
import java.awt.Paint
import java.awt.Stroke
import java.awt.geom.Rectangle2D
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO


import org.jfree.chart.ChartFactory
import org.jfree.chart.JFreeChart
import org.jfree.chart.labels.StandardPieSectionLabelGenerator
import org.jfree.chart.plot.PiePlot
import org.jfree.data.general.DefaultPieDataset

import org.codehaus.groovy.grails.commons.*
import com.itextpdf.text.Image;
import com.itextpdf.text.Document;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.*;

import com.itextpdf.text.*



import java.awt.Dimension;
import javax.swing.JPanel;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.SpiderWebPlot;
import org.jfree.chart.title.LegendTitle;
import org.jfree.chart.title.TextTitle;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.ui.*;

import com.itextpdf.awt.PdfGraphics2D;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfTemplate;
import com.itextpdf.text.pdf.PdfWriter;

import java.awt.Graphics2D;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException
import java.text.DecimalFormat
import java.text.FieldPosition
import java.text.NumberFormat
import java.text.ParsePosition;



class ReportesController extends seguridad.Shield {
//class ReportesController {

    def dbConnectionService
    def mailService

    def index() { }

    def asignaturas () {
//        println "asignaturas $params"

        def periodo = Periodo.get(params.periodo)
        def cn = dbConnectionService.getConnection()
        def sql
        def tipo = params.tipo
        def titulo

        sql = "select matedscr, profnmbr||' '||profapll profesor, crsodscr||' '|| dctaprll curso, escldscr " +
                "from prof, mate, crso, escl, dcta " +
                "where dcta.prdo__id = '${params.periodo}' and crso.crso__id = dcta.crso__id and dcta.prof__id = prof.prof__id and " +
                "mate.mate__id = dcta.mate__id and prof.prof__id not in ( " +
                "select prof__id from encu where prof__id is not null and prdo__id = '${params.periodo}' and teti__id = 2 and " +
                "dcta__id = dcta.dcta__id) and " +
                "escl.escl__id = dcta.escl__id and escl.escl__id = ${params.escl} " +
                "order by escldscr, profapll, profnmbr"

        titulo = "Asignaturas que Faltan por Evaluar los Estudiantes"

//        println "sql: $sql"

        def res = cn.rows(sql.toString());
        def escuelas = res.escldscr.unique()
        def facultad = Facultad.get(params.facl)

        return [res: res, escuelas: escuelas, titulo: titulo, periodo: periodo, facultad: facultad]
    }

    def profesNoEvaluados () {
//        println "profesNoEvaluados $params"

        def periodo = Periodo.get(params.periodo)
        def cn = dbConnectionService.getConnection()
        def sql
        def tipo = params.tipo
        def titulo

        switch(tipo){
            case '1':
                titulo = "Profesores que NO han sido evaluados por los alumnos"

                sql = "select escldscr, profcdla, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                        "from dcta, mate, prof, crso, escl, matr " +
                        "where dcta.prdo__id = '${params.periodo}' and crso.crso__id = dcta.crso__id and " +
                        "mate.mate__id = dcta.mate__id and matr.dcta__id = dcta.dcta__id and prof.prof__id = dcta.prof__id and " +
                        "dcta.prof__id not in (select prof__id from encu " +
                        "where prof__id is not null and prdo__id = '${params.periodo}') and " +
                        "escl.escl__id = dcta.escl__id and facl__id = ${params.facl} " +
                        "group by escldscr, profcdla, profnmbr, profapll, matedscr, crsodscr, dctaprll " +
                        "order by escldscr, profapll, profnmbr"

                break;
            case '2':
                titulo = "Profesores que han sido evaluados por los alumnos"

                sql = "select * from evaluados(${params.facl}, ${params.periodo}) where semi > 0 or pcnt > 0"
                break;
            case '3':  // profesores que NO han realizado su autoevaluación
                titulo = "Profesores que NO han realizado su autoevaluación"

                sql = "select escldscr, profcdla, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                        "from dcta, mate, prof, crso, escl, matr " +
                        "where dcta.prdo__id = '${params.periodo}' and crso.crso__id = dcta.crso__id and " +
                        "mate.mate__id = dcta.mate__id and dcta.dcta__id = matr.dcta__id and prof.prof__id = dcta.prof__id and " +
                        "dcta.dcta__id not in (select distinct dcta__id from encu " +
                        "where prdo__id = '${params.periodo}' and teti__id = 1 and dcta__id is not null order by 1) and " +
                        "escl.escl__id = dcta.escl__id and facl__id = ${params.facl} " +
                        "group by escldscr, profcdla, profnmbr, profapll, matedscr, crsodscr, dctaprll " +
                        "order by escldscr, profapll, profnmbr"

                break;
            case '4':  // profesores que YA han realizado su autoevaluación
                titulo = "Profesores que han realizado su autoevaluación"

                sql = "select escldscr, profcdla, profnmbr||' '||profapll profesor, matedscr, crsodscr, dctaprll " +
                        "from dcta, mate, prof, crso, escl " +
                        "where dcta.prdo__id = '${params.periodo}' and crso.crso__id = dcta.crso__id and " +
                        "prof.prof__id = dcta.prof__id and mate.mate__id = dcta.mate__id and " +
                        "dcta.dcta__id in (select distinct dcta__id from encu " +
                        "where prdo__id = '${params.periodo}' and teti__id = 1 and dcta__id is not null order by 1) and " +
                        "escl.escl__id = dcta.escl__id and facl__id = ${params.facl} " +
                        "order by escldscr, profapll, profnmbr"
                break;

            case '5':
                titulo = "Estudiantes que han realizado la evaluación"

                sql = "select escldscr, estdcdla, estdnmbr||' '||estdapll profesor, matedscr, crsodscr, dctaprll " +
                        "from dcta, mate, estd, crso, escl, matr " +
                        "where dcta.prdo__id = '${params.periodo}' and crso.crso__id = dcta.crso__id and " +
                        "estd.estd__id = matr.estd__id and dcta.dcta__id = matr.dcta__id and " +
                        "mate.mate__id = dcta.mate__id and estd.estd__id in ( " +
                        "select estd__id from encu where estd__id is not null and prdo__id = '${params.periodo}' and teti__id = 2) and " +
                        "escl.escl__id = dcta.escl__id and facl__id = ${params.facl} " +
                        "order by escldscr, estdapll, estdnmbr"
                break;
            case '6':
                titulo = "Estudiantes que no han realizado la evaluación"

                sql = "select escldscr, estdcdla, estdnmbr||' '||estdapll profesor, matedscr, crsodscr, dctaprll " +
                        "from dcta, mate, estd, crso, escl, matr " +
                        "where dcta.prdo__id = '${params.periodo}' and crso.crso__id = dcta.crso__id and " +
                        "estd.estd__id = matr.estd__id and dcta.dcta__id = matr.dcta__id and " +
                        "mate.mate__id = dcta.mate__id and estd.estd__id not in ( " +
                        "select estd__id from encu where estd__id is not null and prdo__id = '${params.periodo}' and teti__id = 2) and " +
                        "escl.escl__id = dcta.escl__id and escl.escl__id = ${params.escl} " +
                        "order by escldscr, estdapll, estdnmbr"
                break;
        }

        println "sql: $sql"

        def res = cn.rows(sql.toString());
        def escuelas = res.escldscr.unique()
        def facultad = Facultad.get(params.facl)

//        println("escuelas " + escuelas)
//        println("sql " + sql)

        return [res: res, escuelas: escuelas, titulo: titulo, facultad: facultad, periodo: periodo]
    }

    def profesEvaluados () {

//        println "profesEvaluados $params"

        def periodo = Periodo.get(params.periodo)
        def cn = dbConnectionService.getConnection()

        def titulo = "Profesores que han sido evaluados por los alumnos"
        def sql = "select * from evaluados(${params.facl}, ${params.periodo}) where semi > 0 or pcnt > 0"

        def res = cn.rows(sql.toString());
        def facultad = Facultad.get(params.facl)

        return [res: res, titulo: titulo, facultad: facultad, periodo: periodo]

    }

    def reportes () {

    }

    def reportesEvaluacion () {

    }

    def reportesGraf () {

    }

    def periodo_ajax () {

    }

    def facultad_ajax () {
//        println "facultad_ajax params: $params"
        def escl = Escuela.findAllByFacultad(Facultad.get(params.facl), [sort: 'nombre'])
        [escuelas: escl]
    }


    public JFreeChart getChart() {
        DefaultPieDataset dataset = new DefaultPieDataset();
        dataset.setValue("One", new Double(43.2));
        dataset.setValue("Two", new Double(10.0));
        dataset.setValue("Three", new Double(27.5));
        dataset.setValue("Four", new Double(17.5));
        dataset.setValue("Five", new Double(11.0));
        dataset.setValue("Six", new Double(19.4));

        //use the ChartFactory to create a pie chart
        JFreeChart chart = ChartFactory.createPieChart("Pastel", dataset, true, true, false);

        return chart;
    }



//    private static CategoryDataset createDataset()
//    {
//        String s = "Desempeño";
//        String s3 = "D-DSC";
//        String s4 = "D-DAC";
//        String s5 = "D-DHD";
//        String s6 = "D-DCI";
//        String s7 = "D-CNI";
//        String s8 = "D-EA";
//        DefaultCategoryDataset defaultcategorydataset = new DefaultCategoryDataset();
//        defaultcategorydataset.addValue(5, s, s3);
//        defaultcategorydataset.addValue(4.8, s, s4);
//        defaultcategorydataset.addValue(3.6, s, s5);
//        defaultcategorydataset.addValue(5, s, s6);
//        defaultcategorydataset.addValue(2.45, s, s7);
//        defaultcategorydataset.addValue(4.45, s, s8);
//        return defaultcategorydataset;
//    }

    private static CategoryDataset createDataset(titulo,valor1, valor2, valor3, valor4, valor5, valor6)
    {

        def patternDecimal = "###.##%"
        def percentform1 = new DecimalFormat(patternDecimal)

        def v1 = percentform1.format(valor1)
        def v2 = percentform1.format(valor2)
        def v3 = percentform1.format(valor3)
        def v4 = percentform1.format(valor4)
        def v5 = percentform1.format(valor5)
        def v6 = percentform1.format(valor6)

        String s = titulo;
        String s3 = "IC (${v1}) ";
        String s4 = "DAC (${v2})";
        String s5 = "DHA (${v3})";
        String s6 = "IF (${v4})";
        String s7 = "NI (${v5})";
        String s8 = "EA (${v6})";

        DefaultCategoryDataset defaultcategorydataset = new DefaultCategoryDataset();
        defaultcategorydataset.addValue(valor1, s, s3);
        defaultcategorydataset.addValue(valor2, s, s4);
        defaultcategorydataset.addValue(valor3, s, s5);
        defaultcategorydataset.addValue(valor4, s, s6);
        defaultcategorydataset.addValue(valor5, s, s7);
        defaultcategorydataset.addValue(valor6, s, s8);

        return defaultcategorydataset;
    }

    private static CategoryDataset createDataset2(titulo, titulo2, valor1, valor2, valor3, valor4, valor5, valor6, valor7, valor8, valor9 , valor10, valor11, valor12)
    {

        def patternDecimal = "###.##%"
        def percentform1 = new DecimalFormat(patternDecimal)

        def v1 = percentform1.format(valor1)
        def v2 = percentform1.format(valor2)
        def v3 = percentform1.format(valor3)
        def v4 = percentform1.format(valor4)
        def v5 = percentform1.format(valor5)
        def v6 = percentform1.format(valor6)

        String s = titulo;
        String s2 = titulo2;
        String s3 = "IC(${valor1}-${valor7}) ";
        String s4 = "DAC(${valor2}-${valor8})";
        String s5 = "DHA(${valor3}-${valor9})";
        String s6 = "IF(${valor4}-${valor10})";
        String s7 = "NI(${valor5}-${valor11})";
        String s8 = "EA(${valor6}-${valor12})";

        DefaultCategoryDataset defaultcategorydataset = new DefaultCategoryDataset();
        defaultcategorydataset.addValue(valor1, s, s3);
        defaultcategorydataset.addValue(valor2, s, s4);
        defaultcategorydataset.addValue(valor3, s, s5);
        defaultcategorydataset.addValue(valor4, s, s6);
        defaultcategorydataset.addValue(valor5, s, s7);
        defaultcategorydataset.addValue(valor6, s, s8);

        defaultcategorydataset.addValue(valor7, s2, s3);
        defaultcategorydataset.addValue(valor8, s2, s4);
        defaultcategorydataset.addValue(valor9, s2, s5);
        defaultcategorydataset.addValue(valor10, s2, s6);
        defaultcategorydataset.addValue(valor11, s2, s7);
        defaultcategorydataset.addValue(valor12, s2, s8);

        return defaultcategorydataset;
    }

    private static JFreeChart createChart(CategoryDataset categorydataset,titulo)
    {
        SpiderWebPlot spiderwebplot = new SpiderWebPlot(categorydataset);

        Stroke dashed =  new BasicStroke(1.5f,BasicStroke.CAP_BUTT, BasicStroke.JOIN_MITER, 10.0f);

//        spiderwebplot.setSeriesPaint(0, Color.GREEN);
//        spiderwebplot.setSeriesPaint(0, new Color(61, 72, 84));
        spiderwebplot.setSeriesPaint(0, new Color(13, 123, 220)); //color del texto del eje
        spiderwebplot.setSeriesOutlinePaint(new Color(13, 123, 220))
        spiderwebplot.setSeriesOutlineStroke(0,new BasicStroke(4.0f))
        spiderwebplot.setBaseSeriesOutlineStroke(dashed)
//        spiderwebplot.setSeriesOutlineStroke(0, new BasicStroke(4.0f,BasicStroke.CAP_BUTT,BasicStroke.JOIN_MITER,10.0f))
//        spiderwebplot.setLabelPaint(new Color(13, 123, 220))
//        spiderwebplot.setLabelPaint(new Color(0, 43, 120))  //color del texto del eje
        spiderwebplot.setLabelPaint(new Color(0, 43, 120))  //color del texto del eje
//        spiderwebplot.setBackgroundPaint(Color.LIGHT_GRAY)
        spiderwebplot.setOutlinePaint(new Color(13, 123, 220))  //linea del gráfico
//        spiderwebplot.setAxisLinePaint(Color.RED)
        spiderwebplot.setAxisLinePaint(new Color(64,64,64))  //línea del eje

        spiderwebplot.setLabelFont(new java.awt.Font("Serif", Font.NORMAL, 8))

        JFreeChart jfreechart = new JFreeChart(titulo, TextTitle.DEFAULT_FONT, spiderwebplot, false);
//        LegendTitle legendtitle = new LegendTitle(spiderwebplot);
//        legendtitle.setPosition(RectangleEdge.BOTTOM);
//        jfreechart.addSubtitle(legendtitle);
        return jfreechart;
    }

    private static JFreeChart creaPastel(titulo, data) {

        DefaultPieDataset datos = new DefaultPieDataset();
        data.each(){
            datos.setValue(it.key, it.value)
        }

//        JFreeChart jfreechart = ChartFactory.createPieChart3D(
        JFreeChart chart = ChartFactory.createPieChart(
                titulo,      // title
                datos,       // data
                false,       // incluye legenda bajo el gráfico
                false,
                false);
        return chart;
    }

    private static JFreeChart creaBarras(titulo, data) {

//        DefaultPieDataset datos = new DefaultPieDataset();
//        data.each(){
//            datos.setValue(it.key, it.value)
//        }


//        CategoryDataset dataset = createDataset();

        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        // Population in 2005
        dataset.addValue(10, "USA", "2005");
        dataset.addValue(15, "India", "2005");
        dataset.addValue(20, "China", "2005");

        // Population in 2010
        dataset.addValue(15, "USA", "2010");
        dataset.addValue(20, "India", "2010");
        dataset.addValue(25, "China", "2010");

        // Population in 2015
        dataset.addValue(20, "USA", "2015");
        dataset.addValue(25, "India", "2015");
        dataset.addValue(30, "China", "2015");



        JFreeChart chart=ChartFactory.createBarChart(
                "Bar Chart Example | BORAJI.COM", //Chart Title
                "Year", // Category axis
                "Population in Million", // Value axis
                dataset,
                PlotOrientation.VERTICAL,
                true,true,false
        );

        return chart
    }


    private CategoryDataset createDatasetB() {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        // Population in 2005
        dataset.addValue(10, "USA", "2005");
        dataset.addValue(15, "India", "2005");
        dataset.addValue(20, "China", "2005");

        // Population in 2010
        dataset.addValue(15, "USA", "2010");
        dataset.addValue(20, "India", "2010");
        dataset.addValue(25, "China", "2010");

        // Population in 2015
        dataset.addValue(20, "USA", "2015");
        dataset.addValue(25, "India", "2015");
        dataset.addValue(30, "China", "2015");

        return dataset;
    }


    private static int[] arregloEnteros(array) {
        int[] ia = new int[array.size()]
        array.eachWithIndex { it, i ->
            ia[i] = it.toInteger()
        }

        return ia
    }

//    private static void addCellTabla(com.lowagie.text.pdf.PdfPTable table, paragraph, params) {
    private static void addCellTabla(PdfPTable table, paragraph, params) {
        PdfPCell cell = new PdfPCell(paragraph);
        if (params.height) {
            cell.setFixedHeight(params.height.toFloat());
        }
        if (params.border) {
            cell.setBorderColor(params.border);
//            cell.setBorderColor(BaseColor.WHITE);
        }
        if (params.bg) {
            cell.setBackgroundColor(params.bg);
        }
        if (params.colspan) {
            cell.setColspan(params.colspan);
        }
        if (params.align) {
            cell.setHorizontalAlignment(params.align);
        }
        if (params.valign) {
            cell.setVerticalAlignment(params.valign);
        }
        if (params.w) {
            cell.setBorderWidth(params.w);
            cell.setUseBorderPadding(true);
        }
        if (params.bwl) {
            cell.setBorderWidthLeft(params.bwl.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwb) {
            cell.setBorderWidthBottom(params.bwb.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwr) {
            cell.setBorderWidthRight(params.bwr.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bwt) {
            cell.setBorderWidthTop(params.bwt.toFloat());
            cell.setUseBorderPadding(true);
        }
        if (params.bcl) {
            cell.setBorderColorLeft(params.bcl);
        }
        if (params.bcb) {
            cell.setBorderColorBottom(params.bcb);
        }
        if (params.bcr) {
            cell.setBorderColorRight(params.bcr);
        }
        if (params.bct) {
            cell.setBorderColorTop(params.bct);
        }
        if (params.padding) {
            cell.setPadding(params.padding.toFloat());
        }
        if (params.pl) {
            cell.setPaddingLeft(params.pl.toFloat());
        }
        if (params.pr) {
            cell.setPaddingRight(params.pr.toFloat());
        }
        if (params.pt) {
            cell.setPaddingTop(params.pt.toFloat());
        }
        if (params.pb) {
            cell.setPaddingBottom(params.pb.toFloat());
        }
        if(params.color){
            cell.setBackgroundColor(params.color)
        }

        table.addCell(cell);
    }


    private String numero(num, decimales, cero) {
        if (num == 0 && cero.toString().toLowerCase() == "hide") {
            return " ";
        }
        if (decimales == 0) {
            return formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec")
        } else {
            def format
            if (decimales == 2) {
                format = "##,##0"
            } else if (decimales == 3) {
                format = "##,###0"
            }
            return formatNumber(number: num, minFractionDigits: decimales, maxFractionDigits: decimales, locale: "ec", format: format)
        }
    }

    private String numero(num, decimales) {
        return numero(num, decimales, "show")
    }

    private String numero(num) {
        return numero(num, 3)
    }


    def colores (valorX,valorY,pdfw,cb){
        float x = valorX;
        float y = valorY + (360-valorX);
//        float y = 1100;
        float side = 10;
        PdfShading axial = PdfShading.simpleAxial(pdfw,x,y,(x+side).toFloat(), y, new BaseColor(209,124,71), new BaseColor(74, 126, 152))
        PdfShadingPattern shading = new PdfShadingPattern(axial);
        cb.closePathFillStroke();

        return shading
    }



    def reporteVariables() {
//        println "reporteVariables $params"

        def periodo = Periodo.get(params.periodo)
        def escuela = Escuela.get(params.escl)

        def tipo = Variables.get(params.tipo)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontTt = new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);

        Document document
        document = new Document(PageSize.A4.rotate());
//        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte desempeño profesores");
        document.addSubject("Generado por el sistema");
        document.addKeywords("reporte, docentes, profesores");
        document.addAuthor("Docentes");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        preface.add(new Paragraph("Reporte", fontTitulo));

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + (Facultad.get(params.facl)?.nombre ?: ''), fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo1 = new Paragraph("ESCUELA: " + (escuela?.nombre ?: ''), fontTitulo)
        lineaTitulo1.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo = new Paragraph("Reporte desempeño profesores en: " + tipo?.descripcion, fontTitulo)
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(lineaTitulo1)
        document.add(lineaTitulo)
        document.add(lineaVacia)

        def val
        def sql

//        println("tipo " + tipo?.codigo)

        switch(tipo?.codigo){
            case 'CNI':
//                sql = "select profnmbr||' '||profapll profesor, esclcdgo, dcni, matedscr, crsodscr, dctaprll " +
//                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
//                        "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
//                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
//                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id " +
//                        "order by dcni DESC"
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, dcni, matedscr, crsodscr, dctaprll " +
                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
                        "where prof.prof__id = rpec.prof__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id and " +
                        "escl.escl__id = dcta.escl__id order by dcni DESC, profapll, matedscr"

                val = 'dcni'
                break;
            case 'DAC':
//                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddac, matedscr, crsodscr, dctaprll " +
//                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
//                        "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
//                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
//                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id " +
//                        "order by ddac DESC"
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddac, matedscr, crsodscr, dctaprll " +
                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
                        "where prof.prof__id = rpec.prof__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id and " +
                        "escl.escl__id = dcta.escl__id order by ddac DESC, profapll, matedscr"
                val = 'ddac'
                break;
            case 'DCI':
//                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddci, matedscr, crsodscr, dctaprll " +
//                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
//                        "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
//                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
//                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id " +
//                        "order by ddci DESC"
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddci, matedscr, crsodscr, dctaprll " +
                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
                        "where prof.prof__id = rpec.prof__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id and " +
                        "escl.escl__id = dcta.escl__id order by ddci DESC, profapll, matedscr"
                val = 'ddci'

                break;
            case 'DHD':
//                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddhd, matedscr, crsodscr, dctaprll " +
//                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
//                        "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
//                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
//                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id " +
//                        "order by ddhd DESC"
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddhd, matedscr, crsodscr, dctaprll " +
                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
                        "where prof.prof__id = rpec.prof__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id " +
                        "order by ddhd DESC, profapll, matedscr"
                val = 'ddhd'

                break;
            case 'DSC':
//                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddsc, matedscr, crsodscr, dctaprll " +
//                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
//                        "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
//                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
//                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id " +
//                        "order by ddsc DESC"
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddsc, matedscr, crsodscr, dctaprll " +
                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
                        "where prof.prof__id = rpec.prof__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id and " +
                        "escl.escl__id = dcta.escl__id order by ddsc DESC, profapll, matedscr"
                val = 'ddsc'

                break;
            case 'EA':
//                sql = "select profnmbr||' '||profapll profesor, esclcdgo, d_ea, matedscr, crsodscr, dctaprll " +
//                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
//                        "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
//                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
//                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id " +
//                        "order by d_ea DESC"
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, d_ea, matedscr, crsodscr, dctaprll " +
                        "from rpec, prof, escl, tpen, dcta, crso, mate " +
                        "where prof.prof__id = rpec.prof__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "rpec.prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' and " +
                        "dcta.dcta__id = rpec.dcta__id and crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id and " +
                        "escl.escl__id = dcta.escl__id order by d_ea DESC, profapll, matedscr"
                val = 'd_ea'
                break;
        }

//        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

//        PdfPTable tablaD = new PdfPTable(6);
        PdfPTable tablaD = new PdfPTable(5);
        tablaD.setWidthPercentage(100);
//        tablaD.setWidths(arregloEnteros([25, 15, 25, 15, 15, 5]))
        tablaD.setWidths(arregloEnteros([30,  40, 8, 14, 5]))

        addCellTabla(tablaD, new Paragraph("Profesor", fontTitulo), prmsCrBorder)
//        addCellTabla(tablaD, new Paragraph("Escuela", fontTitulo), prmsCrBorder)
        addCellTabla(tablaD, new Paragraph("Materia", fontTitulo), prmsCrBorder)
        addCellTabla(tablaD, new Paragraph("Curso - Par.", fontTt), prmsCrBorder)
        addCellTabla(tablaD, new Paragraph("Desempeño", fontTitulo), prmsCrBorder)
        addCellTabla(tablaD, new Paragraph("%", fontTitulo), prmsCrBorder)

        PdfPTable table = new PdfPTable(1);
        table.setTotalWidth(450);

        res.eachWithIndex { p , j ->

            addCellTabla(tablaD, new Paragraph(p.profesor, fontThUsar), prmsTdNoBorder)
            addCellTabla(tablaD, new Paragraph(p.matedscr, fontThUsar), prmsTdNoBorder)
            addCellTabla(tablaD, new Paragraph(p.crsodscr + " - " + p.dctaprll, fontThUsar), prmsTdNoBorder)

            def valor
            switch(tipo?.codigo){
                case 'CNI':
                    valor = ((p.dcni).toDouble()*100).toInteger()
                    break;
                case 'DAC':
                    valor = ((p.ddac).toDouble()*100).toInteger()
                    break;
                case 'DCI':
                    valor = ((p.ddci).toDouble()*100).toInteger()
                    break;
                case 'DHD':
                    valor = ((p.ddhd).toDouble()*100).toInteger()
                    break;
                case 'DSC':
                    valor = ((p.ddsc).toDouble()*100).toInteger()
                    break;
                case 'EA':
                    valor = ((p.d_ea).toDouble()*100).toInteger()
                    break;
            }

            PdfTemplate template = cb.createTemplate(700, 150);

            def valorFinal = 740*(valor/100)
            valorFinal = 740 - valorFinal
//            valor = 740*(valor/100)
//            valor = 740 - valor



//            PdfShadingPattern shading = colores(valor, 740, pdfw, cb)
            PdfShadingPattern shading = colores(valorFinal, 740, pdfw, cb)

            template.setShadingFill(shading)

            template.rectangle(20,20,1100,70);

            template.fill();
            Image img = Image.getInstance(template);
            img.setRotationDegrees(180)

//            Chunk chunk = new Chunk(img, 6, 1);
            Chunk chunk = new Chunk(img, 6, -2);

            PdfPCell cell1 = new PdfPCell();
            cell1.setPaddingTop(4);
            cell1.addElement(chunk)

            tablaD.addCell(cell1)

//            addCellTabla(tablaD, new Paragraph(numero(p.ddsc*100, 2), fontThUsar), prmsNmBorder)
            addCellTabla(tablaD, new Paragraph(numero(valor, 2), fontThUsar), prmsNmBorder)

        }

        document.add(tablaD);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'reporte_' + new Date().format("dd-MM-yyyy") + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    public static JFreeChart generateBarChart() {
        DefaultCategoryDataset dataSet = new DefaultCategoryDataset();
        dataSet.setValue(791, "Population", "1750 AD");
        dataSet.setValue(978, "Population", "1800 AD");
        dataSet.setValue(1262, "Population", "1850 AD");
        dataSet.setValue(1650, "Population", "1900 AD");
        dataSet.setValue(2519, "Population", "1950 AD");
        dataSet.setValue(6070, "Population", "2000 AD");

        JFreeChart chart = ChartFactory.createBarChart(
                "World Population growth", "Year", "Population in millions",
                dataSet, PlotOrientation.VERTICAL, false, true, false);

        return chart;
    }

    public static JFreeChart generatePieChart() {
        DefaultPieDataset dataSet = new DefaultPieDataset();
        dataSet.setValue("China", 19.64);
        dataSet.setValue("India", 17.3);
        dataSet.setValue("United States", 4.54);
        dataSet.setValue("Indonesia", 3.4);
        dataSet.setValue("Brazil", 2.83);
        dataSet.setValue("Pakistan", 2.48);
        dataSet.setValue("Bangladesh", 2.38);

        JFreeChart chart = ChartFactory.createPieChart(
                "World Population by countries", dataSet, true, true, false);

        return chart;
    }


    def grafica() {
        def baos = new ByteArrayOutputStream()
//        PdfWriter writer = null;

        Document document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        def chart = generateBarChart()
        def chart2 = generatePieChart()
        def chart3 = createChart(createDataset());
        def ancho = 500
        def alto = 300

        try {
//            writer = PdfWriter.getInstance(document, new FileOutputStream("prueba.pdf"));
            document.open();
//            PdfContentByte contentByte = writer.getDirectContent();
            PdfContentByte contentByte = pdfw.getDirectContent();

            Paragraph parrafo1 = new Paragraph();
            Paragraph parrafo2 = new Paragraph();


            PdfTemplate template = contentByte.createTemplate(ancho, alto);
            PdfTemplate template2 = contentByte.createTemplate(ancho, alto/10);
            Graphics2D graphics2d = template.createGraphics(ancho, alto, new DefaultFontMapper());
            Graphics2D graphics2d2 = template2.createGraphics(ancho, alto/10, new DefaultFontMapper());
            Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, ancho, alto);
            Rectangle2D rectangle2d2 = new Rectangle2D.Double(0, 0, ancho, alto/10);

            chart.draw(graphics2d, rectangle2d);

            graphics2d.dispose();
            Image chartImage = Image.getInstance(template);
            parrafo1.add(chartImage);


//            chart2.draw(graphics2d2, rectangle2d2);
//            graphics2d2.dispose();
//            Image chartImage2 = Image.getInstance(template2);
//            parrafo2.add(chartImage2);


            chart3.draw(graphics2d2, rectangle2d2);
            graphics2d2.dispose();
            Image chartImage3 = Image.getInstance(template2);
            parrafo2.add(chartImage3);


            document.add(parrafo1)
            document.add(parrafo2)
            document.add(parrafo2)
            document.add(parrafo2)



//            contentByte.addTemplate(template, 20, 350);

        } catch (Exception e) {
            e.printStackTrace();
        }

        PdfPTable table = new PdfPTable(3); // 3 columns.

        PdfPCell cell1 = new PdfPCell(new Paragraph("Cell 1"));
        PdfPCell cell2 = new PdfPCell(new Paragraph("Cell 2"));
        PdfPCell cell3 = new PdfPCell(new Paragraph("Cell 3"));

        PdfPTable nestedTable = new PdfPTable(1);
        nestedTable.setWidthPercentage(51);
        nestedTable.addCell(new Paragraph("Nested Cell 1"));

        cell3.addElement(nestedTable);
        cell3.setHorizontalAlignment(Element.ALIGN_LEFT);
        cell3.setVerticalAlignment(Element.ALIGN_MIDDLE);

        table.addCell(cell1);
        table.addCell(cell2);
        table.addCell(cell3);

        document.add(table);

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'prueba')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    public static JFreeChart crearBarChart(titulo,datos) {

//        println("---- " + datos)

        DefaultCategoryDataset dataSet = new DefaultCategoryDataset();

        datos.each{ l->
            dataSet.setValue(l.value, "Clase", l.key)
        }
        JFreeChart chart = ChartFactory.createBarChart(
                "${titulo}", "Clase", "Valor",
                dataSet, PlotOrientation.VERTICAL, false, true, false);

        return chart;
    }

    def informes () {

    }

    def desempeno () {
        def facultad =  Facultad.get(params.facultad)
        def periodo = Periodo.get(params.periodo)
        def escuelaNombre = Escuela.get(params.escl)?.nombre

        if(session.perfil.codigo == 'ADMG') {
//            println ".... univ: ${facultad.universidad.id}"
            session.univ = facultad.universidad.id
        }
        return [facultad: facultad, periodo: periodo, pantalla: params.pantalla, escuela: params.escl, nombre: escuelaNombre]
    }

    def poligonos () {
        def facultades = Facultad.findAllByUniversidad(session.usuario.universidad)
        def escuelas   = Escuela.findAllByFacultad(facultades.first())
        def periodo = Periodo.get(params.periodo)
        def escuelaNombre = Escuela.get(params.escl)?.nombre

        if(session.perfil.codigo == 'ADMG') {
//            println ".... univ: ${facultad.universidad.id}"
            session.univ = facultad.universidad.id
        }
        return [facultad: facultades, escl: escuelas, periodo: periodo,
                pantalla: params.pantalla, escuela: params.escl, nombre: escuelaNombre]
    }

    def graficoProf_ajax() {
//        println "graficoProf_ajax: $params"
        def cn = dbConnectionService.getConnection()
        def prsn = Persona.get(session.usuario.id)
        def sql
        if(params.mate != '-1') {
            sql = "select rpec.prof__id id, matedscr, profnmbr||' '||profapll profesor, crsodscr||' '|| dctaprll curso, " +
                    "rpec.dcta__id " +
                    "from rpec, prof, mate, crso, dcta " +
                    "where rpec.prdo__id = ${params.prdo} and tpen__id = 2 and " +
                    "dcta.dcta__id = rpec.dcta__id and prof.prof__id = rpec.prof__id and " +
                    "crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id and " +
                    "mate.mate__id = ${params.mate} " +
                    // "and prof.profcdla ilike '${params.cedula}%' " +
                    "order by profapll, profnmbr"
        } else {
            sql = "select rpec.prof__id id, matedscr, profnmbr||' '||profapll profesor, crsodscr||' '|| dctaprll curso, " +
                    "rpec.dcta__id " +
                    "from rpec, prof, mate, crso, dcta " +
                    "where rpec.escl__id = ${params.escl} and rpec.prdo__id = ${params.prdo} and tpen__id = 2 and " +
                    "dcta.dcta__id = rpec.dcta__id and prof.prof__id = rpec.prof__id and " +
                    "crso.crso__id = dcta.crso__id and mate.mate__id = dcta.mate__id and " +
                    "prof.profnmbr ilike '%${params.nombres}%' and prof.profapll ilike '%${params.apellidos}%' " +
                    // "and prof.profcdla ilike '${params.cedula}%' " +
                    "order by profapll, profnmbr"
        }
//        println "sql: $sql"

        def prof = cn.rows(sql.toString())

        def profesor = []
        def dc, ad
        def pp

        prof.each { p ->
            pp = p
            sql = "select ddsc*100 ddsc, ddac*100 ddac, ddhd*100 ddhd, ddci*100 ddci, dcni*100 dcni, d_ea*100 d_ea, tpen__id, prof__id " +
                    "from rpec " +
                    "where rpec.escl__id = ${params.escl} and rpec.prdo__id = ${params.prdo} and tpen__id = 2 and " +
                    "prof__id = ${p.id} and dcta__id = ${p.dcta__id}"
//            println "sql2: $sql"
            dc = "0_0_0_0_0_0"
            cn.eachRow(sql.toString()) { d ->
                dc = "${d.ddsc}_${d.ddac}_${d.ddhd}_${d.ddci}_${d.dcni}_${d.d_ea}"
            }
            sql = "select ddsc*100 ddsc, ddac*100 ddac, ddhd*100 ddhd, ddci*100 ddci, dcni*100 dcni, d_ea*100 d_ea " +
                    "from rpec " +
                    "where rpec.escl__id = ${params.escl} and rpec.prdo__id = ${params.prdo} and tpen__id = 1 and " +
                    "prof__id = ${p.id} limit 1"
            ad = "0_0_0_0_0_0"
            cn.eachRow(sql.toString()) { d ->
                ad = "${d.ddsc}_${d.ddac}_${d.ddhd}_${d.ddci}_${d.dcni}_${d.d_ea}"
            }
            pp["dc"] = dc
            pp["ad"] = ad
            profesor.add(pp)
//            dicta.add(p?.dcta__id)
        }

        sql = "select estdmini, estdoptm from auxl, prdo where univ__id = ${prsn.universidad.id} and " +
                "prdo.prdo__id = auxl.prdo__id"
//        println "sql: $sql"
        def minMax = cn.rows(sql.toString())
//        println "min.... $minMax"
//        println "prof: ${profesor[0]}---${profesor[1]}"

        def periodo = Periodo.get(params.prdo)
        [prof: profesor, minimo: minMax.estdmini, optimo: minMax.estdoptm, periodo: periodo]
    }

    def tablaProfesores_ajax () {

//        println "tablaProfesores_ajax ---> $params"

        params.nombres = "%" + params.nombres + '%'
        params.apellidos = "%" + params.apellidos + '%'
        params.cedula = params.cedula + '%'

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)
        def escuelaProfesor = Escuela.get(params.escuela)

        def profesores = ReporteEncuesta.withCriteria {

            eq("escuela", escuelaProfesor)
            eq("periodo",periodo)

            profesor{

                and{
                    ilike("cedula", params.cedula)
                    ilike("nombre", params.nombres)
                    ilike("apellido", params.apellidos)
                }

                order("nombre","asc")
            }
        }

        def alumnos = TipoEncuesta.findByCodigo("DC")
        def auto = TipoEncuesta.findByCodigo("AD")
        def directivos = TipoEncuesta.findByCodigo("DI")
        def pares = TipoEncuesta.findByCodigo("PR")
        def promedio = TipoEncuesta.findByCodigo("FE")
        def total = TipoEncuesta.findByCodigo("TT")

        def pantalla = params.pantalla

        return [profesores: profesores?.profesor?.unique(), alumnos: alumnos, auto: auto, directivos: directivos, pares: pares,
                promedio: promedio, periodo: periodo, total: total, pantalla: pantalla, facultad: facultad, escuela: escuelaProfesor]
    }

    def desempenoAlumnos () {

//        println("params alum " + params)


        Font fontNormal = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormal8 = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTitulo = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]

        def profesor = Profesor.get(params.profe)
        def periodo = Periodo.get(params.periodo)
        def escuelaP = Escuela.get(params.escl)
        def facultadP = Facultad.get(params.facu)
        def alumnos = TipoEncuesta.findByCodigo("DC")
        def auto = TipoEncuesta.findByCodigo("AD")
        def directivos = TipoEncuesta.findByCodigo("DI")
        def pares = TipoEncuesta.findByCodigo("PR")
        def totales = TipoEncuesta.findByCodigo("TT")
//        def rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,encuestaAlumnos,periodo)
        def baos = new ByteArrayOutputStream()
        Document document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        def tipo = params.tipo
        def subtitulo = ''
        def rpec
        def pattern1 = "###.##%"
        def percentform = new DecimalFormat(pattern1)



        switch(tipo){
            case '1':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,alumnos,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Alumnos)"
                break;
            case '2':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,auto,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Autoevaluación)"
                break;
            case '3':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,directivos,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Evaluación Directivos)"
                break;
            case '4':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,pares,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Evaluación por Pares)"
                break;
            case '5':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,totales,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Total)"
                break;
        }

        document.open();

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoProfesor = new Paragraph("PROFESOR: " + profesor?.nombre + " " + profesor?.apellido, fontTitulo)
        parrafoProfesor.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + facultadP?.nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoEscuela = new Paragraph("ESCUELA:" + escuelaP?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
//        Paragraph parrafoPromedio = new Paragraph("PROMEDIO: " + ((rpec?.promedio*100)) + "%", fontNormal)
        Paragraph parrafoPromedio = new Paragraph("PROMEDIO: " + (percentform.format(rpec?.promedio)), fontNormal)
        document.add(parrafoUniversidad)
        document.add(parrafoProfesor)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
        document.add(parrafoPromedio)

        def chart3 = createChart( createDataset("Referencias: ",rpec.ddsc, rpec.ddac, rpec.ddhd, rpec.ddci,rpec.dcni, rpec.d_ea), subtitulo);
        def ancho = 540
        def alto = 540

        try {

            PdfContentByte contentByte = pdfw.getDirectContent();

            Paragraph parrafo1 = new Paragraph();
            Paragraph parrafo2 = new Paragraph();

            PdfTemplate template = contentByte.createTemplate(ancho, alto);
            PdfTemplate template2 = contentByte.createTemplate(ancho, alto);
            Graphics2D graphics2d = template.createGraphics(ancho, alto, new DefaultFontMapper());
            Graphics2D graphics2d2 = template2.createGraphics(ancho, alto, new DefaultFontMapper());
            Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, ancho, alto);
            Rectangle2D rectangle2d2 = new Rectangle2D.Double(0, 0, ancho, alto);

            chart.draw(graphics2d, rectangle2d);

            graphics2d.dispose();
            Image chartImage = Image.getInstance(template);
            parrafo1.add(chartImage);

            chart3.draw(graphics2d2, rectangle2d2);
            graphics2d2.dispose();
            Image chartImage3 = Image.getInstance(template2);
            parrafo2.add(chartImage3);

            document.add(parrafo2)


        } catch (Exception e) {
            e.printStackTrace();
        }

        //pie
        PdfPTable tablaD = new PdfPTable(3);

        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([49, 2, 49]))
        addCellTabla(tablaD, new Paragraph("REFERENCIAS:", fontNormal), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontTitulo), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontTitulo), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('DSC')?.sigla ?: '') + ": " + (Variables.findByCodigo('DSC')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('DCI')?.sigla ?: '') + ": " + (Variables.findByCodigo('DCI')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('DAC')?.sigla ?: '') + ": " + (Variables.findByCodigo('DAC')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('CNI')?.sigla ?: '') + ": " + (Variables.findByCodigo('CNI')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('DHD')?.sigla ?: '') + ": " + (Variables.findByCodigo('DHD')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('EA')?.sigla ?: '') + ": " + (Variables.findByCodigo('EA')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)

        document.add(tablaD);

        document.close();
        pdfw.close()

        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'desempenoAcademico_alumnos' + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def reportePoligonos () {

//        println("params rp " + params)

        Font fontNormal = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormal8 = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTitulo = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]

        def profesor = Profesor.get(params.profe)
        def periodo = Periodo.get(params.periodo)
        def escuela = Escuela.get(params.escl)
        def dicta = Dictan.get(params.dicta)

        def t1 = profesor.nombre.split(" ")
        def t2 = profesor.apellido.split(" ")

        def alumnos = TipoEncuesta.findByCodigo("DC")
        def auto = TipoEncuesta.findByCodigo("AD")
        def directivos = TipoEncuesta.findByCodigo("DI")
        def pares = TipoEncuesta.findByCodigo("PR")
        def totales = TipoEncuesta.findByCodigo("TT")
        def baos = new ByteArrayOutputStream()
        Document document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        def tipo = params.tipo
        def subtitulo = ''
        def rpec
        def pattern1 = "###.##%"
        def percentform = new DecimalFormat(pattern1)

        document.open();

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoProfesor = new Paragraph("PROFESOR: " + profesor?.nombre + " " + profesor?.apellido, fontTitulo)
        parrafoProfesor.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + dicta?.escuela?.facultad?.nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoEscuela = new Paragraph("ESCUELA:" + dicta?.escuela?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
//        Paragraph parrafoPromedio = new Paragraph("PROMEDIO: " + (percentform.format(rpec?.promedio)), fontNormal)
        document.add(parrafoUniversidad)
        document.add(parrafoProfesor)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
//        document.add(parrafoPromedio)

//        def sql = "select ddsc*100 ddsc, ddac*100 ddac, ddhd*100 ddhd, ddci*100 ddci, dcni*100 dcni, d_ea*100 d_ea, tpen__id, prof__id\n" +
//                "from rpec where rpec.escl__id = ${escuela?.id} and rpec.prdo__id = ${periodo?.id} and tpen__id = 1 and prof__id = ${profesor?.id} and dcta__id = ${dicta?.id};"

        def  sql = "select ddsc*100 ddsc, ddac*100 ddac, ddhd*100 ddhd, ddci*100 ddci, dcni*100 dcni, d_ea*100 d_ea " +
                "from rpec " +
                "where rpec.escl__id = ${escuela?.id} and rpec.prdo__id = ${periodo?.id} and tpen__id = 1 and " +
                "prof__id = ${profesor?.id} limit 1"

//        println("sql " + sql)

//        def sql1 = "select ddsc*100 ddsc, ddac*100 ddac, ddhd*100 ddhd, ddci*100 ddci, dcni*100 dcni, d_ea*100 d_ea, tpen__id, prof__id\n" +
//                "from rpec where rpec.escl__id = ${escuela?.id} and rpec.prdo__id = ${periodo?.id} and tpen__id = 2 and prof__id = ${profesor?.id} and dcta__id = ${dicta?.id};"
        def sql1 = "select ddsc*100 ddsc, ddac*100 ddac, ddhd*100 ddhd, ddci*100 ddci, dcni*100 dcni, d_ea*100 d_ea, tpen__id, prof__id " +
                "from rpec " +
                "where rpec.escl__id = ${escuela?.id} and rpec.prdo__id = ${periodo?.id} and tpen__id = 2 and " +
                "prof__id = ${profesor?.id} and dcta__id = ${dicta?.id}"

//        println("sql1 " + sql1)

        def cn = dbConnectionService.getConnection()
        def res = cn.firstRow(sql.toString());

        def cn2 = dbConnectionService.getConnection()
        def res2 = cn2.firstRow(sql1.toString());

//        println("1 " + res)
//        println("2 " + res2)


        def chart3 = createChart( createDataset2("Titulo 1", "Titulo 2", res?.ddsc ?: 0, res?.ddac ?: 0, res?.ddhd ?: 0, res?.ddci ?: 0, res?.dcni ?: 0, res?.d_ea ?: 0, res2?.ddsc ?: 0, res2?.ddac ?: 0, res2?.ddhd ?: 0, res2?.ddci ?: 0, res2?.dcni ?: 0, res2?.d_ea ?: 0 ), subtitulo);
        def ancho = 540
        def alto = 540

        try {

            PdfContentByte contentByte = pdfw.getDirectContent();

            Paragraph parrafo1 = new Paragraph();
            Paragraph parrafo2 = new Paragraph();

            PdfTemplate template = contentByte.createTemplate(ancho, alto);
            PdfTemplate template2 = contentByte.createTemplate(ancho, alto);
            Graphics2D graphics2d = template.createGraphics(ancho, alto, new DefaultFontMapper());
            Graphics2D graphics2d2 = template2.createGraphics(ancho, alto, new DefaultFontMapper());
            Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, ancho, alto);
            Rectangle2D rectangle2d2 = new Rectangle2D.Double(0, 0, ancho, alto);


            chart.draw(graphics2d, rectangle2d);

            graphics2d.dispose();
            Image chartImage = Image.getInstance(template);
            parrafo1.add(chartImage);

            chart3.draw(graphics2d2, rectangle2d2);
            graphics2d2.dispose();
            Image chartImage3 = Image.getInstance(template2);
            parrafo2.add(chartImage3);

            document.add(parrafo2)


        } catch (Exception e) {
            e.printStackTrace();
        }

        //pie
        PdfPTable tablaD = new PdfPTable(3);

        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([49, 2, 49]))
        addCellTabla(tablaD, new Paragraph("REFERENCIAS:", fontNormal), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontTitulo), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontTitulo), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('DSC')?.sigla ?: '') + ": " + (Variables.findByCodigo('DSC')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('DCI')?.sigla ?: '') + ": " + (Variables.findByCodigo('DCI')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('DAC')?.sigla ?: '') + ": " + (Variables.findByCodigo('DAC')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('CNI')?.sigla ?: '') + ": " + (Variables.findByCodigo('CNI')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('DHD')?.sigla ?: '') + ": " + (Variables.findByCodigo('DHD')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph((Variables.findByCodigo('EA')?.sigla ?: '') + ": " + (Variables.findByCodigo('EA')?.descripcion ?: ''), fontNormal8), prmsTdNoBorder)

        document.add(tablaD);

        document.close();
        pdfw.close()

        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'desempeno_' + t1[0] + "_" + t1[1] + "_" + t2[0] + "_" + t2[1] + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }


    def desempenoAlumnosMail (prof, per) {

//        println("params alum " + params)


        Font fontNormal = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormal8 = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontTitulo = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]

        def profesor = Profesor.get(prof)
        def periodo = Periodo.get(per)
        def alumnos = TipoEncuesta.findByCodigo("DC")
        def auto = TipoEncuesta.findByCodigo("AD")
        def directivos = TipoEncuesta.findByCodigo("DI")
        def pares = TipoEncuesta.findByCodigo("PR")
        def totales = TipoEncuesta.findByCodigo("TT")

        def baos = new ByteArrayOutputStream()
        Document document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);
        def tipo = params.tipo
        def subtitulo = ''
        def rpec
        def pattern1 = "###.##%"
        def percentform = new DecimalFormat(pattern1)



        switch(tipo){
            case '1':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,alumnos,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Alumnos)"
                break;
            case '2':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,auto,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Autoevaluación)"
                break;
            case '3':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,directivos,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Evaluación Directivos)"
                break;
            case '4':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,pares,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Evaluación por Pares)"
                break;
            case '5':
                rpec = ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,totales,periodo)
                subtitulo = "INFORME DEL DESEMPEÑO ACADÉMICO (Total)"
                break;
        }

        document.open();

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoProfesor = new Paragraph("PROFESOR: " + profesor?.nombre + " " + profesor?.apellido, fontTitulo)
        parrafoProfesor.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + profesor?.escuela?.facultad?.nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoEscuela = new Paragraph("ESCUELA:" + profesor?.escuela?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
        Paragraph parrafoPromedio = new Paragraph("PROMEDIO: " + (percentform.format(rpec?.promedio)), fontNormal)
        document.add(parrafoUniversidad)
        document.add(parrafoProfesor)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
        document.add(parrafoPromedio)

        def chart3 = createChart( createDataset("Referencias: ",rpec.ddsc, rpec.ddac, rpec.ddhd, rpec.ddci,rpec.dcni, rpec.d_ea), subtitulo);
        def ancho = 540
        def alto = 540

        try {

            PdfContentByte contentByte = pdfw.getDirectContent();

            Paragraph parrafo1 = new Paragraph();
            Paragraph parrafo2 = new Paragraph();

            PdfTemplate template = contentByte.createTemplate(ancho, alto);
            PdfTemplate template2 = contentByte.createTemplate(ancho, alto);
            Graphics2D graphics2d = template.createGraphics(ancho, alto, new DefaultFontMapper());
            Graphics2D graphics2d2 = template2.createGraphics(ancho, alto, new DefaultFontMapper());
            Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, ancho, alto);
            Rectangle2D rectangle2d2 = new Rectangle2D.Double(0, 0, ancho, alto);

            chart.draw(graphics2d, rectangle2d);

            graphics2d.dispose();
            Image chartImage = Image.getInstance(template);
            parrafo1.add(chartImage);

            chart3.draw(graphics2d2, rectangle2d2);
            graphics2d2.dispose();
            Image chartImage3 = Image.getInstance(template2);
            parrafo2.add(chartImage3);

            document.add(parrafo2)


        } catch (Exception e) {
            e.printStackTrace();
        }

        //pie
        PdfPTable tablaD = new PdfPTable(3);

        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([49, 2, 49]))
        addCellTabla(tablaD, new Paragraph("REFERENCIAS:", fontNormal), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontTitulo), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontTitulo), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph("DSC: INTEGRACIÓN DE CONOCIMIENTOS", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("DCI: INVESTIGACIÓN FORMATIVA", fontNormal8), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph("DAC: DESAROLLO DE ACTITUDES Y VALORES", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("CNI: NORMATIVIDAD INSTITUCIONAL", fontNormal8), prmsTdNoBorder)

        addCellTabla(tablaD, new Paragraph("DHD: DESARROLLO DE HABILIDADES Y DESTREZAS", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("", fontNormal8), prmsTdNoBorder)
        addCellTabla(tablaD, new Paragraph("EA: EVALUACIÓN DEL APRENDIZAJE", fontNormal8), prmsTdNoBorder)

        document.add(tablaD);

        document.close();
        pdfw.close()
        return baos

    }

    def variables_ajax () {
        def factores = Variables.findByCodigo('FE')
        def botella = Variables.findByCodigo('CCB')
        def competencia = Variables.findByCodigo('CP')
        def variables = Variables.list() - factores - botella - competencia

        return [variables: variables]
    }


    def reporteTotalesDesempeno () {

//        println "reporteTotalDes $params"

        def tipo = Variables.get(params.tipo)
        def periodo = Periodo.get(params.periodo)
        def escuela = Escuela.get(params.escl)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontTitulo2 = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        fontTitulo2.setColor(255,255,255)
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte desempeño profesores");
        document.addSubject("Generado por el sistema");
        document.addKeywords("reporte, docentes, profesores");
        document.addAuthor("Docentes");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        preface.add(new Paragraph("Reporte", fontTitulo));

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + Facultad.get(params.facl).nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoEscuela = new Paragraph("ESCUELA: " + escuela?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo = new Paragraph(tipo?.descripcion, fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaSubTitulo = new Paragraph("TOTAL GENERAL", fontTitulo )
        lineaSubTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
        document.add(lineaTitulo)
        document.add(lineaSubTitulo)
        document.add(lineaVacia)

        def val
        def sql



        switch(tipo?.codigo){
            case 'CNI':
//                sql = "select profnmbr||' '||profapll profesor, esclcdgo, dcni from rpec, prof, escl, tpen " +
//                        "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
//                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'TT' order by profapll, profnmbr"
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, dcni from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'TT' order by profapll, profnmbr"

                val = 'dcni'

                break;
            case 'DAC':
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddac from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'TT' order by profapll, profnmbr"

                val = 'ddac'
                break;
            case 'DCI':
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddci from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'TT' order by profapll, profnmbr"

                val = 'ddsc'

                break;
            case 'DHD':
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddhd from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'TT' order by profapll, profnmbr"

                val = 'ddhd'

                break;
            case 'DSC':
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddsc from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'TT' order by profapll, profnmbr"

                val = 'ddsc'

                break;
            case 'EA':
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, d_ea from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'TT' order by profapll, profnmbr"

                val = 'd_ea'
                break;
        }

//        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());
        BaseColor colorAzul = new BaseColor(50, 96, 144)

        def prmsTdNoBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorderAzul = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, color: colorAzul]

        /* ************************************************************* HEADER PLANILLA ***************************************************************************/
        PdfPTable tablaD = new PdfPTable(4);
        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([37, 35, 20, 6]))

        addCellTabla(tablaD, new Paragraph("Profesor", fontTitulo2), prmsCrBorderAzul)
        addCellTabla(tablaD, new Paragraph("Escuela", fontTitulo2), prmsCrBorderAzul)
        addCellTabla(tablaD, new Paragraph("Desempeño", fontTitulo2), prmsCrBorderAzul)
        addCellTabla(tablaD, new Paragraph("%", fontTitulo2), prmsCrBorderAzul)

        PdfPTable table = new PdfPTable(1);
        table.setTotalWidth(450);

        res.eachWithIndex { p , j ->


            addCellTabla(tablaD, new Paragraph(p.profesor, fontThUsar), prmsTdNoBorder)
            addCellTabla(tablaD, new Paragraph(Escuela.findByCodigo(p.esclcdgo).nombre, fontThUsar), prmsTdNoBorder)

//            def valor = ((p.ddsc).toDouble()*100).toInteger()
            def valor
            switch(tipo?.codigo){
                case 'CNI':
                    valor = ((p.dcni).toDouble()*100).toInteger()
                    break;
                case 'DAC':
                    valor = ((p.ddac).toDouble()*100).toInteger()
                    break;
                case 'DCI':
                    valor = ((p.ddci).toDouble()*100).toInteger()
                    break;
                case 'DHD':
                    valor = ((p.ddhd).toDouble()*100).toInteger()
                    break;
                case 'DSC':
                    valor = ((p.ddsc).toDouble()*100).toInteger()
                    break;
                case 'EA':
                    valor = ((p.d_ea).toDouble()*100).toInteger()
                    break;
            }

            PdfTemplate template = cb.createTemplate(700, 150);

            def valorFinal = 740*(valor/100)
            valorFinal = 740 - valorFinal
            PdfShadingPattern shading = colores(valorFinal, 740, pdfw, cb)
            template.setShadingFill(shading)
            template.rectangle(20,20,1100,70);
            template.fill();

            Image img = Image.getInstance(template);
            img.setRotationDegrees(180)
            Chunk chunk = new Chunk(img, 6, -2);

            PdfPCell cell1 = new PdfPCell();
            cell1.setPaddingTop(4);
            cell1.addElement(chunk)
            tablaD.addCell(cell1)
            addCellTabla(tablaD, new Paragraph(numero(valor, 2), fontThUsar), prmsNmBorder)

        }

        document.add(tablaD);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'totalesDesempeñoAcademico' + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)


    }


    def reporteOrdenamiento () {

//        println "reporteOrdenamiento $params"

        def tipo = Variables.get(params.tipo)
        def periodo = Periodo.get(params.periodo)
        def escuela = Escuela.get(params.escl)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte desempeño profesores");
        document.addSubject("Generado por el sistema");
        document.addKeywords("reporte, docentes, profesores");
        document.addAuthor("Docentes");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        preface.add(new Paragraph("Reporte", fontTitulo));

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + Facultad.get(params.facl).nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoEscuela = new Paragraph("ESCUELA: " + escuela?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo = new Paragraph("Reporte: " + tipo?.descripcion, fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
        document.add(lineaTitulo)
        document.add(lineaVacia)

        def val
        def sql

        switch(tipo?.codigo){
            case 'CNI':
//                sql = "select profnmbr||' '||profapll profesor, esclcdgo, dcni from rpec, prof, escl, tpen " +
//                        "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
//                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' order by dcni DESC"
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, dcni from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' order by dcni DESC"

                val = 'dcni'

                break;
            case 'DAC':

                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddac from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' order by ddac DESC"
                val = 'ddac'
                break;
            case 'DCI':

                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddci from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' order by ddci DESC"
                val = 'ddsc'

                break;
            case 'DHD':

                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddhd from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' order by ddhd DESC"
                val = 'ddhd'

                break;
            case 'DSC':
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, ddsc from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' order by ddsc DESC"
                val = 'ddsc'

                break;
            case 'EA':
                sql = "select profnmbr||' '||profapll profesor, esclcdgo, d_ea from rpec, prof, escl, tpen " +
                        "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and rpec.facl__id = ${params.facl} and escl.escl__id = ${params.escl} and " +
                        "prdo__id = ${params.periodo} and tpen.tpen__id = rpec.tpen__id and tpencdgo = 'DC' order by d_ea DESC"
                val = 'd_ea'
                break;
        }

//        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        /* ************************************************************* HEADER PLANILLA ***************************************************************************/
        PdfPTable tablaD = new PdfPTable(4);
        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([37, 35, 20, 6]))

        addCellTabla(tablaD, new Paragraph("Profesor", fontTitulo), prmsCrBorder)
        addCellTabla(tablaD, new Paragraph("Escuela", fontTitulo), prmsCrBorder)
        addCellTabla(tablaD, new Paragraph("Desempeño", fontTitulo), prmsCrBorder)
        addCellTabla(tablaD, new Paragraph("%", fontTitulo), prmsCrBorder)

        PdfPTable table = new PdfPTable(1);
        table.setTotalWidth(450);

        res.eachWithIndex { p , j ->


            addCellTabla(tablaD, new Paragraph(p.profesor, fontThUsar), prmsTdNoBorder)
            addCellTabla(tablaD, new Paragraph(Escuela.findByCodigo(p.esclcdgo).nombre, fontThUsar), prmsTdNoBorder)

//            def valor = ((p.ddsc).toDouble()*100).toInteger()
            def valor
            switch(tipo?.codigo){
                case 'CNI':
                    valor = ((p.dcni).toDouble()*100).toInteger()
                    break;
                case 'DAC':
                    valor = ((p.ddac).toDouble()*100).toInteger()
                    break;
                case 'DCI':
                    valor = ((p.ddci).toDouble()*100).toInteger()
                    break;
                case 'DHD':
                    valor = ((p.ddhd).toDouble()*100).toInteger()
                    break;
                case 'DSC':
                    valor = ((p.ddsc).toDouble()*100).toInteger()
                    break;
                case 'EA':
                    valor = ((p.d_ea).toDouble()*100).toInteger()
                    break;
            }

            PdfTemplate template = cb.createTemplate(700, 150);

            def valorFinal = 740*(valor/100)
            valorFinal = 740 - valorFinal
            PdfShadingPattern shading = colores(valorFinal, 740, pdfw, cb)
            template.setShadingFill(shading)
            template.rectangle(20,20,1100,70);
            template.fill();

            Image img = Image.getInstance(template);
            img.setRotationDegrees(180)
            Chunk chunk = new Chunk(img, 6, -2);

            PdfPCell cell1 = new PdfPCell();
            cell1.setPaddingTop(4);
            cell1.addElement(chunk)
            tablaD.addCell(cell1)
            addCellTabla(tablaD, new Paragraph(numero(valor, 2), fontThUsar), prmsNmBorder)

        }

        document.add(tablaD);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'ordenamientoPorVariables' + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def recomendacion () {
        def facultad =  Facultad.get(params.facultad)
        def periodo = Periodo.get(params.periodo)
        return [facultad: facultad, periodo: periodo]
    }


    def profesoresClases_old() {
//        println "profesoresClases $params"
        def cn = dbConnectionService.getConnection()

        Font fontNormal = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormal8 = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL);
        Font font12 = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontTitulo = new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTtlo = new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD);

        def periodo = Periodo.get(params.periodo)
        def facultad
        def facultadId
        if(params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = "Todas las Facultades"
            facultadId = "%"
        }

        def sql
        def data = [:]

        def baos = new ByteArrayOutputStream()
        Document document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        def tipo = params.tipo
        def subtitulo = ''
        def pattern1 = "###.##%"



        switch(tipo){
            case '1':
                sql = "select count(distinct (rpec.prof__id, dcta__id)) cnta, clase from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                        "escl.escl__id = prof.escl__id and rpec.facl__id::varchar ilike '${facultadId}' and tpen__id = 2" +
                        "group by clase order by clase"


//                println "sql: $sql"
                data = [:]
                cn.eachRow(sql.toString()) { d ->
                    data["Profeso-res ${d.clase}: ${d.cnta}"] = d.cnta
                }
//                println "data: $data"
                subtitulo = "PROFESORES POR DESEMPEÑO"
                break;
        }

        document.open();

        Paragraph parrafoUniversidad = new Paragraph("UNIVERSIDAD", fontTitulo)
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
        document.add(linea)
        document.add(titulo)
        document.add(linea)

        def chart = creaPastel("", data);
//        def chart = creaBarras('', data);
        def ancho =  440  //540
        def alto =  440   //540
        document.add(linea)

        try {

            PdfContentByte contentByte = pdfw.getDirectContent()

            Paragraph parrafo1 = new Paragraph()
            PdfTemplate template = contentByte.createTemplate(ancho, alto)
            Graphics2D graphics2d = template.createGraphics(ancho, alto, new DefaultFontMapper())
            Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, ancho, alto)

            PiePlot ColorConfigurator = (PiePlot) chart.getPlot()
            ColorConfigurator.setBackgroundAlpha(0f)

            chart.draw(graphics2d, rectangle2d)
            graphics2d.dispose()
            Image chartImage = Image.getInstance(template)
            chartImage.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)        // centrado

            parrafo1.add(chartImage)

            document.add(parrafo1)


        } catch (Exception e) {
            e.printStackTrace()
        }

        //pie
//        def prmt = Auxiliares.findByPeriodo(periodo)
//
//        document.add(linea)
//        Paragraph refe = new Paragraph("Referencia:", fontTitulo)
//        Paragraph claseA = new Paragraph("La clase 'A' corresponde a un desempeño académico igual " +
//                "o superior a ${prmt?.optimo}", font12)
//        Paragraph claseB = new Paragraph("La clase 'B' corresponde a un desempeño académico menor " +
//                "a ${prmt?.optimo} y mayor o igual a ${prmt?.minimo}", font12)
//        Paragraph claseC = new Paragraph("La clase 'C' corresponde a un desempeño académico menor " +
//                "a ${prmt?.minimo}", font12)
//
//        document.add(refe)
//        document.add(claseA)
//        document.add(claseB)
//        document.add(claseC)
//
//        document.close()
        pdfw.close()
        byte[] b = baos.toByteArray()
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'desempenoAcademico_alumnos')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }



    def profesoresClases () {

//        println "profesoresClases $params"

        def cn = dbConnectionService.getConnection()

        Font fontNormal = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormal8 = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL);
        Font font12 = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontTitulo = new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTtlo = new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD);

        def periodo = Periodo.get(params.periodo)
        def escuela = Escuela.get(params.escl)
        def facultad
        def facultadId
        if(params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = "Todas las Facultades"
            facultadId = "%"
        }

        def universidad = Universidad.get(params.univ)

        def sql
        def data = [:]

        def tipo = params.tipo
        def subtitulo = ''
        def pattern1 = "###.##%"

        switch(tipo){
            case '1':
                sql = "select count(distinct (rpec.prof__id, dcta__id)) cnta, clase from rpec, prof, escl " +
                        "where prof.prof__id = rpec.prof__id and " +
                        "escl.escl__id = rpec.escl__id and rpec.facl__id::varchar ilike '${facultadId}' and tpen__id = 2 and " +
                        "univ__id = ${params.univ} and escl.escl__id = ${params.escl} " +
                        "group by clase order by clase"

//                println "sql: $sql"
                data = [:]
                def av
                def bv
                def cv
                def data2 = [:]

                cn.eachRow(sql.toString()) { d ->
                    data.put(d.clase, d.cnta)
                    if(d?.clase == 'A'){
                        av = d.cnta
                    }
                    data.put(d.clase, d.cnta)
                    if(d?.clase == 'B'){
                        bv = d.cnta
                    }
                    data.put(d.clase, d.cnta)
                    if(d?.clase == 'C'){
                        cv=d.cnta
                    }
                }


                if(!data.containsKey('A')){
                    data2.clear()
                    data2.put('A',0)
                    data2.put("B",bv)
                    data2.put("C",cv)

                    av = 0
                }

                if(!data.containsKey('B')){
                    data2.clear()
                    data2.put("A",av)
                    data2.put('B',0)
                    data2.put("C",cv)

                    bv = 0
                }

                if(!data.containsKey('C')){
                    data2.clear()
                    data2.put("A",av)
                    data2.put('B',bv)
                    data2.put('C',0)
                }

//                println "data: $data"
//                println("data 2 " + data2)

//                data = data2

                subtitulo = "PROFESORES POR DESEMPEÑO"
                break;
        }

        def baos = new ByteArrayOutputStream()

        Document document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();

        Paragraph parrafoUniversidad = new Paragraph("UNIVERSIDAD: " + universidad?.nombre?.toUpperCase(), fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)
        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + facultad, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)
        Paragraph parrafoEscuela = new Paragraph("ESCUELA: " + escuela?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)
        Paragraph linea = new Paragraph(" ", fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
        document.add(linea)

        def chart = crearBarChart(subtitulo,data)
        def chart2 = generatePieChart()
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

        PdfPTable table = new PdfPTable(2); // 3 columns.
        PdfPTable table2 = new PdfPTable(2); // 3 columns.

        PdfPCell cell1 = new PdfPCell(new Paragraph("Clase"));
        PdfPCell cell2 = new PdfPCell(new Paragraph("Valor"));

        cell1.setHorizontalAlignment(Element.ALIGN_CENTER)
        cell2.setHorizontalAlignment(Element.ALIGN_CENTER)
        cell1.setVerticalAlignment(Element.ALIGN_CENTER)
        cell2.setVerticalAlignment(Element.ALIGN_CENTER)

        cell1.setBackgroundColor(BaseColor.LIGHT_GRAY)
        cell2.setBackgroundColor(BaseColor.LIGHT_GRAY)

        table.addCell(cell1);
        table.addCell(cell2);

        data.eachWithIndex{ o,h->
            PdfPCell cell3 = new PdfPCell(new Paragraph(o.key + ""));
            PdfPCell cell4 = new PdfPCell(new Paragraph(o.value + ""));
            cell3.setHorizontalAlignment(Element.ALIGN_CENTER)
            cell4.setHorizontalAlignment(Element.ALIGN_CENTER)
            cell3.setVerticalAlignment(Element.ALIGN_CENTER)
            cell4.setVerticalAlignment(Element.ALIGN_CENTER)

            table2.addCell(cell3);
            table2.addCell(cell4);
        }

        document.add(table);
        document.add(table2);

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'desempenoAcademico_alumnos' + ".pdf" )
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def cuellosBotella () {

        def periodo = Periodo.get(params.periodo)

        def cn = dbConnectionService.getConnection()
        def facultad
        def facultadId
        def escuela = Escuela.get(params.escl)


        if(params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = ""
            facultadId = "%"
        }

        def sql = "select rpec.prof__id, dctaprll, cb_causa, matedscr, prof.prof__id, profnmbr, profapll  " +
                "from rpec, prof, escl, mate, dcta where prof.prof__id = rpec.prof__id " +
                "and escl.escl__id = rpec.escl__id and rpec.facl__id::varchar ilike '${facultadId}' " +
                "and cb_matr is not null and dcta.dcta__id = rpec.dcta__id and mate.mate__id = dcta.mate__id " +
                "and cb_tipo = 'A' group by rpec.prof__id, prof.prof__id, dctaprll, profnmbr, profapll, matedscr, cb_causa";

        def res = cn.rows(sql.toString())

//        println("Res " + res)

        return[facultad: facultad, res: res,periodo: periodo, escuela: escuela]
    }

    def potenciadores () {

        def periodo = Periodo.get(params.periodo)

        def cn = dbConnectionService.getConnection()
        def facultad
        def facultadId
        def escuela = Escuela.get(params.escl)


        if(params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = ""
            facultadId = "%"
        }

        def sql = "select rpec.prof__id, dctaprll, matedscr, cb_causa, prof.prof__id, profnmbr, profapll " +
                "from rpec, prof, escl, mate, dcta where prof.prof__id = rpec.prof__id " +
                "and escl.escl__id = rpec.escl__id and rpec.facl__id::varchar ilike '${facultadId}' " +
                "and cb_matr is not null and dcta.dcta__id = rpec.dcta__id and mate.mate__id = dcta.mate__id " +
                "and cb_tipo = 'B' group by rpec.prof__id, prof.prof__id, dctaprll, profnmbr, profapll, matedscr, cb_causa";

        def res = cn.rows(sql.toString())

//        println("Res " + res)

        return[facultad: facultad, res: res, periodo: periodo, escuela: escuela]
    }

    def recomendaciones () {

        def periodo = Periodo.get(params.periodo)

        def cn = dbConnectionService.getConnection()
        def facultad
        def facultadId
        def escuela = Escuela.get(params.escuela)


        if(params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = ""
            facultadId = "%"
        }

        def sql = "select rpec.prof__id, dctaprll, matedscr, escldscr, " +
                "prof.prof__id, profnmbr, profapll from rpec, " +
                "prof, escl, mate, dcta where prof.prof__id = rpec.prof__id " +
                "and escl.escl__id = rpec.escl__id and rpec.facl__id::varchar ilike '${facultadId}' " +
                "and con_rcmn > 0 and tpen__id = 2 and dcta.dcta__id = rpec.dcta__id " +
                "and mate.mate__id = dcta.mate__id group by rpec.prof__id, prof.prof__id, dctaprll, profnmbr, profapll, matedscr, escldscr;"

        def res = cn.rows(sql.toString())

//        println("Res " + res)

        return[facultad: facultad, res: res,periodo: periodo, escuela: escuela]

    }


    def recomendacionesGrafico() {
        println "profesoresClases $params"
        def cn = dbConnectionService.getConnection()

        Font fontNormal = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormal8 = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL);
        Font font12 = new Font(Font.FontFamily.TIMES_ROMAN, 12, Font.NORMAL);
        Font fontTitulo = new Font(Font.FontFamily.TIMES_ROMAN, 14, Font.BOLD);
        Font fontTtlo = new Font(Font.FontFamily.TIMES_ROMAN, 18, Font.BOLD);

        def periodo = Periodo.get(params.periodo)
        def universidad = Universidad.get(params.univ)
        def escuela = Escuela.get(params.escl)
        def facultad
        def facultadId
        if(params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = "Todas las Facultades"
            facultadId = "%"
        }

        def sql
        def data = [:]
        def data2 = [:]

        def baos = new ByteArrayOutputStream()
        Document document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        def tipo = params.tipo
        def subtitulo = ''
        def pattern1 = "###.##%"

        def totl = 0
        def cuenta = 0

        def sql2 = "select count(distinct (rpec.prof__id, dcta__id)) cnta, clase from rpec, prof, escl " +
                "where prof.prof__id = rpec.prof__id and " +
                "escl.escl__id = rpec.escl__id and rpec.facl__id::varchar ilike '${facultadId}' and tpen__id = 2 and " +
                "univ__id = ${params.univ} and escl.escl__id = ${params.escl} " +
                "group by clase order by clase"

//        def sql2 = "select count(distinct (rpec.prof__id, dcta__id)) cnta, clase from rpec, prof, escl, pfes " +
//                "where prof.prof__id = rpec.prof__id and " +
//                "pfes.escl__id = escl.escl__id and pfes.prof__id = prof.prof__id and rpec.facl__id::varchar ilike '${facultadId}' and tpen__id = 2 and " +
//                "prof.univ__id = ${params.univ} and escl.escl__id = ${params.escl} " +
//                "group by clase order by clase"

        cn.eachRow(sql2.toString()) { d ->
            data2[d.clase] = d.cnta
            totl += d.cnta
        }

//        println("total " + totl)

        switch(tipo){
            case '1':

                sql = "select count(distinct (rpec.prof__id, dcta__id)) cnta from rpec, prof, escl where prof.prof__id = rpec.prof__id and " +
                        "rpec.escl__id = escl.escl__id and rpec.facl__id::varchar ilike '${facultadId}' and con_rcmn > 0 and tpen__id = 2 and " +
                        "rpec.univ__id = ${params.univ} and escl.escl__id = ${params.escl}"

//                println "sql: $sql"

                data = [:]
                cn.eachRow(sql.toString()) { d ->
                    data["Con recomendaciones: ${d.cnta}"] = d.cnta
                    cuenta = d.cnta
                }

                data["Sin recomendaciones: ${totl - cuenta}"] = (totl - cuenta)
                subtitulo = "Recomendaciones"
                break;
        }

//        println("data " + data)

        document.open();

        Paragraph parrafoUniversidad = new Paragraph("UNIVERSIDAD: " + universidad?.nombre?.toUpperCase(), fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)
        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + facultad, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)
        Paragraph parrafoEscuela = new Paragraph("ESCUELA: " + escuela?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)
        Paragraph linea = new Paragraph(" ", fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
        document.add(linea)

        Paragraph titulo = new Paragraph(subtitulo, fontTtlo)
        titulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)

        document.add(titulo)
        document.add(linea)

        def chart = creaPastel("", data);
        def ancho =  440  //540
        def alto =  440   //540
        document.add(linea)

        try {

            PdfContentByte contentByte = pdfw.getDirectContent()

            Paragraph parrafo1 = new Paragraph()
            PdfTemplate template = contentByte.createTemplate(ancho, alto)
            Graphics2D graphics2d = template.createGraphics(ancho, alto, new DefaultFontMapper())
            Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, ancho, alto)

            PiePlot ColorConfigurator = (PiePlot) chart.getPlot()
            ColorConfigurator.setBackgroundAlpha(0f)

            chart.draw(graphics2d, rectangle2d)
            graphics2d.dispose()
            Image chartImage = Image.getInstance(template)
            chartImage.setAlignment(com.lowagie.text.Element.ALIGN_CENTER)        // centrado

            parrafo1.add(chartImage)
            document.add(parrafo1)

        } catch (Exception e) {
            e.printStackTrace()
        }

        //pie
        def prmt = Auxiliares.findByPeriodo(periodo)

        document.add(linea)

        document.close()
        pdfw.close()
        byte[] b = baos.toByteArray()
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'recomendaciones' + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteDesempeno () {

//        println("params --- " + params)

        def cn = dbConnectionService.getConnection()
        def facultad
        def facultadId
        def periodo = Periodo.get(params.periodo)
        def escuela = Escuela.get(params.escuela)

        if(params.facultad.toInteger()) {
            facultad = Facultad.get(params.facultad).nombre
            facultadId = "${params.facultad}"
        } else {
            facultad = ""
            facultadId = "%"
        }

        def sql = "select escldscr, profnmbr, profapll, proftitl, dctaprll, matedscr, clase, prof.prof__id " +
                "from rpec, prof, escl, dcta, mate " +
                "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and " +
                "rpec.escl__id = ${params.escuela} and dcta.dcta__id = rpec.dcta__id and " +
                "mate.mate__id = dcta.mate__id and clase is not null and rpec.prdo__id = ${periodo.id} and " +
                "tpen__id = 2 " +
                "group by escldscr, profnmbr, profapll, proftitl, dctaprll, matedscr, clase, prof.prof__id " +
                "order by clase"

//        println("sql " + sql )

        def res = cn.rows(sql.toString())

        return[facultad: facultad, res: res, periodo: periodo, escuela: escuela]
    }

    def reporteTipoEncuesta () {

        def periodo = Periodo.get(params.periodo)

        def cn = dbConnectionService.getConnection()
        def sql
        def data1 = [:]
        def data2 = [:]
        def data3 = [:]
        def data4 = [:]

        sql = "select avg(promedio)::numeric(5,2) prom, rpec.tpen__id, tpendscr, facl.facl__id, facldscr, escl.escl__id, escldscr " +
                "from rpec, prof, escl, facl, tpen " +
                "where prof.prof__id = rpec.prof__id and escl.escl__id = rpec.escl__id and " +
                "facl.facl__id = escl.facl__id and rpec.tpen__id in (1,2,3,5) and prdo__id = ${params.periodo} and " +
                "tpen.tpen__id = rpec.tpen__id " +
                "group by rpec.tpen__id, facldscr, facl.facl__id, tpendscr, escl.escl__id, escldscr order by facl.facl__id, tpendscr, rpec.tpen__id"

//        println("sql " + sql)

        def datos = cn.rows(sql.toString())


        datos.each {

            def cod = TipoEncuesta.get(it.tpen__id).codigo.trim()

            switch (cod) {
                case 'AD':
                    data1.put((it.facl__id + "_" + it.escldscr),it.prom)
                    break
                case 'DC':
                    data2.put((it.facl__id + "_" + it.escldscr),it.prom)
                    break
                case 'DI':
                    data3.put((it.facl__id + "_" + it.escldscr),it.prom)
                    break
                case 'PR':
                    data4.put((it.facl__id + "_" + it.escldscr),it.prom)
                    break
            }
        }

        def ord1 = data1.sort { a,b -> b.key <=> a.key }
        def ord2 = data2.sort { a,b -> b.key <=> a.key }
        def ord3 = data3.sort { a,b -> b.key <=> a.key }
        def ord4 = data4.sort { a,b -> b.key <=> a.key }


//        println("1 " + data1 + " 2 " + data2 + " 3 " + data3 + " 4 " + data4)

        return[datos1: ord1, datos2: ord2, datos3: ord3, datos4: ord4, periodo: periodo]

    }

    def escuelas_ajax () {
        def facultad = Facultad.get(params.facl)
        def escuelas = Escuela.findAllByFacultad(facultad)
        return[escuelas: escuelas]
    }

    def reporteDesempenoVariables () {

        def periodo = Periodo.get(params.periodo)

        def cn = dbConnectionService.getConnection()
        def sql
        def data = [:]
        def ord
        def d = []
        def facultad = []
        def data1 = [:]
        def data2 = [:]
        def data3 = [:]
        def data4 = [:]
        def data5 = [:]
        def data6 = [:]

//        sql = "select avg(ddsc)::numeric(5,2) ddsc, avg(ddac)::numeric(5,2) ddac, avg(ddhd)::numeric(5,2) ddhd, " +
//                "avg(ddci)::numeric(5,2) ddci, avg(dcni)::numeric(5,2) dcni, avg(d_ea)::numeric(5,2) d_ea, " +
//                "facl.facl__id, facldscr " +
//                "from rpec, prof, escl, facl " +
//                "where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and " +
//                "facl.facl__id = escl.facl__id and rpec.tpen__id = 8 and prdo__id = ${params.periodo} " +
//                "group by facldscr, facl.facl__id order by facl.facl__id"


        sql = "select avg(d_ea)::numeric(5,2) d_ea, avg(ddsc)::numeric(5,2) ddsc, avg(ddhd)::numeric(5,2) ddhd, avg(ddac)::numeric(5,2) ddac, avg(ddci)::numeric(5,2) ddci, avg(dcni)::numeric(5,2) dcni, " +
                "facldscr||' - '||escldscr nombre from rpec, facl, " +
                "escl where facl.facl__id = rpec.facl__id and escl.escl__id = rpec.escl__id " +
                "and tpen__id = 2 and prdo__id = ${params.periodo} group by facldscr, escldscr;"


//        println "sql: $sql"

        def datos = cn.rows(sql.toString())

//        println("datos " + datos)

        def tx_ddsc, tx_ddac, tx_ddhd, tx_ddci, tx_dcni, tx_d_ea
        def tx_1, tx_2, tx_3, tx_4, tx_5, tx_6
//        def facl = datos.facl__id.unique()

//        for(j in facl) {
//            tx_ddsc = "${datos.find{it.facl__id == j}?.ddsc?:0}"
//            tx_ddac = "${datos.find{it.facl__id == j}?.ddac?:0}"
//            tx_ddhd = "${datos.find{it.facl__id == j}?.ddhd?:0}"
//            tx_ddci = "${datos.find{it.facl__id == j}?.ddci?:0}"
//            tx_dcni = "${datos.find{it.facl__id == j}?.dcni?:0}"
//            tx_d_ea = "${datos.find{it.facl__id == j}?.d_ea?:0}"
//
//            data[1] = [vrbl: 'INTEGRACIÓN DE CONOCIMIENTOS', valor: tx_ddsc]
//            data[2] = [vrbl: 'DESARROLLO DE ACTITUDES Y VALORES', valor: tx_ddac]
//            data[3] = [vrbl: 'DESARROLLO DE HABILIDADES Y DESTREZAS', valor: tx_ddhd]
//            data[4] = [vrbl: 'INVESTIGACIÓN FORMATIVA', valor: tx_ddci]
//            data[5] = [vrbl: 'NORMATIVIDAD INSTITUCIONAL', valor: tx_dcni]
//            data[6] = [vrbl: 'EVALUACIÓN DE APRENDIZAJE', valor: tx_d_ea]

//            ord = data.sort { a,b -> b.value.valor <=> a.value.valor }
//
//            d += ord
//        }

        datos.each{
            data1.put(it.nombre, it.ddsc)
            data2.put(it.nombre, it.ddac)
            data3.put(it.nombre, it.ddhd)
            data4.put(it.nombre, it.ddci)
            data5.put(it.nombre, it.dcni)
            data6.put(it.nombre, it.d_ea)
        }


//        println("data1 " + data1)
//        println("data2 " + data2)

//        return [datos: datos, periodo: periodo, data: d, fac: facl]
        return [periodo: periodo, data1: data1, data2: data2, data3: data3, data4: data4, data5: data5, data6: data6]
    }

    def reporteEnviarProfesores() {

        println("params rp " + params)

        def pl = new ByteArrayOutputStream()
        byte[] b
        def pdfs = []  /** pdfs a armar en el nuevo documento **/
        def contador = 0
        def periodo = Periodo.get(params.periodo)
        def profesor = Profesor.get(params.profesor)
        FileOutputStream fos = null

        def pathPdf = servletContext.getRealPath("/") + "pdf/"
        def archivo = pathPdf + "desempeno_" + "${profesor?.cedula ?: 'sinCC'}" + "_" + "${new Date().format("dd-MM-yyyy")}" + ".pdf"

        def alumnos = TipoEncuesta.findByCodigo("DC")
        def auto = TipoEncuesta.findByCodigo("AD")
        def directivos = TipoEncuesta.findByCodigo("DI")
        def pares = TipoEncuesta.findByCodigo("PR")
        def promedio = TipoEncuesta.findByCodigo("FE")
        def total = TipoEncuesta.findByCodigo("TT")

        if(profesor?.mail){


            if(docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor, alumnos, periodo)?.promedio > 0){
                params.tipo = '1'
                pl = desempenoAlumnosMail(profesor?.id, periodo?.id)
                pdfs.add(pl.toByteArray())
                contador++
            }

            if(docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor, auto, periodo)?.promedio > 0){
                params.tipo = '2'
                pl = desempenoAlumnosMail(profesor?.id, periodo?.id)
                pdfs.add(pl.toByteArray())
                contador++
            }

            if(docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor, directivos, periodo)?.promedio > 0){
                params.tipo = '3'
                pl = desempenoAlumnosMail(profesor?.id, periodo?.id)
                pdfs.add(pl.toByteArray())
                contador++
            }

            if(docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor, pares, periodo)?.promedio > 0){
                params.tipo = '4'
                pl = desempenoAlumnosMail(profesor?.id, periodo?.id)
                pdfs.add(pl.toByteArray())
                contador++
            }

            if(docentes.ReporteEncuesta.findByProfesorAndPeriodoAndTipoEncuesta(profesor, periodo, total)){
                params.tipo = '5'
                pl = desempenoAlumnosMail(profesor?.id, periodo?.id)
                pdfs.add(pl.toByteArray())
                contador++
            }

            if(contador >= 1) {
                def baos = new ByteArrayOutputStream()
                com.lowagie.text.Document document
                document = new com.lowagie.text.Document(com.lowagie.text.PageSize.A4);

                def pdfw = com.lowagie.text.pdf.PdfWriter.getInstance(document, baos);
                document.open();
                com.lowagie.text.pdf.PdfContentByte cb = pdfw.getDirectContent();

                pdfs.each {f ->
                    com.lowagie.text.pdf.PdfReader reader = new com.lowagie.text.pdf.PdfReader(f);
                    for (int i = 1; i <= reader.getNumberOfPages(); i++) {
                        //nueva página
                        document.newPage();
                        //importa la página "i" de la fuente "reader"
                        com.lowagie.text.pdf.PdfImportedPage page = pdfw.getImportedPage(reader, i);
                        //añade página
                        cb.addTemplate(page, 0, 0);
                    }
                }
                document.close();

                b = baos.toByteArray();
                fos = new FileOutputStream(archivo);
                fos.write(b);
                fos.close();

            } else {
                b = pl.toByteArray();
            }


            //descomentar para imprimir

//        response.setContentType("application/pdf")
//        response.setHeader("Content-disposition", "attachment; filename=${'desempeno_' + profesor?.cedula}")
//        response.setContentLength(b.length)
//        response.getOutputStream().write(b)


            //envio de email  al profesor

            def mailTedein = "informacion@tedein.com.ec"
            def mailTedein2 = "${profesor?.mail}"
            def errores = ''

            def fileGuardar = new File(archivo)

            try{
                mailService.sendMail {
                    multipart true
                    to mailTedein2
                    subject "Reporte de desempeño"
                    body "Desempeño profesor"
                    attachBytes "desempeno_" + "${profesor?.cedula ?: 'sinCC'}" + "_" + "${new Date().format("dd-MM-yyyy")}" + ".pdf",'application/pdf', fileGuardar.readBytes()
                }

                fileGuardar.delete()

            }catch (e){
                println("Error al enviar el mail" + e)
                errores += e
            }

            if(errores == ''){
                render "ok"
            }else{
                render "no_Error al enviar el mail"
            }
        }else{
            render "no_El profesor seleccionado no tiene email"
        }

    }


    def reporteProfesoresXCuello () {

//        println("params " + params)

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)
        def escuela = Escuela.get(params.escl)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontTitulo2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte de Profesores por Cuellos de Botella");
        document.addSubject("Generado por el sistema");
        document.addKeywords("reporte, docentes, profesores");
        document.addAuthor("Docentes");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        preface.add(new Paragraph("Reporte", fontTitulo));

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + facultad.nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoEscuela = new Paragraph("ESCUELA: " + escuela?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo = new Paragraph("Profesores por Cuellos de Botella", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo2 = new Paragraph("Causa: " + params.causa, fontTitulo )
        lineaTitulo2.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
        document.add(lineaTitulo)
        document.add(lineaTitulo2)
        document.add(lineaVacia)

        def sql =  "select * from cuellos(${facultad?.id},${escuela?.id},${periodo?.id}) where cllo = 'S' and tipo like '%CUELLO%' and causa = '${params.causa}' order by prof"

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsIzBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bg: new BaseColor(95, 113, 132)]
        def prmsIzBorder2 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsCentro = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder3 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        PdfPTable tablaD = new PdfPTable(4);
        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([35,35,10,20]))

        addCellTabla(tablaD, new Paragraph("Profesor", fontNormalBold), prmsCentro)
        addCellTabla(tablaD, new Paragraph("Asignatura", fontNormalBold), prmsCentro)
        addCellTabla(tablaD, new Paragraph("Paralelo", fontNormalBold), prmsCentro)
        addCellTabla(tablaD, new Paragraph("Tipo", fontNormalBold), prmsCentro)

        res.eachWithIndex { p , j ->
            addCellTabla(tablaD, new Paragraph(p?.prof, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaD, new Paragraph(p?.mate, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaD, new Paragraph(p?.prll + " ", fontThUsar), prmsCrBorder)
            addCellTabla(tablaD, new Paragraph(p?.tipo, fontThUsar), prmsIzBorder3)
        }

        Paragraph textoFinal = new Paragraph("Cuello Moderado: respuestas seleccionadas = Frecuentemente", fontTitulo2)
        Paragraph textoFinal2 = new Paragraph("Cuello Exagerado: respuestas seleccionadas = Siempre", fontTitulo2)

        document.add(tablaD)
        document.add(textoFinal)
        document.add(textoFinal2)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'profesoresXCuellosDeBotella' + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def reporteProfesoresXPotencia () {
        //        println("params " + params)

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)
        def escuela = Escuela.get(params.escl)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontTitulo2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontTitulo10 = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 8, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte de Profesores por Potenciadores");
        document.addSubject("Generado por el sistema");
        document.addKeywords("reporte, docentes, profesores");
        document.addAuthor("Docentes");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        preface.add(new Paragraph("Reporte", fontTitulo));

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + facultad.nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoEscuela = new Paragraph("ESCUELA: " + escuela?.nombre, fontTitulo)
        parrafoEscuela.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo = new Paragraph("Profesores por Potenciadores de Nivel", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo2 = new Paragraph("Causa: " + params.factor, fontTitulo10 )
        lineaTitulo2.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoEscuela)
        document.add(lineaTitulo)
        document.add(lineaTitulo2)
        document.add(lineaVacia)

        def sql =  "select * from cuellos(${facultad?.id},${escuela?.id},${periodo?.id}) where cllo = 'S' and tipo like '%POTENCIA%' and causa = '${params.factor}' order by prof"

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsIzBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bg: new BaseColor(95, 113, 132)]
        def prmsIzBorder2 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsCentro = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder3 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        PdfPTable tablaD = new PdfPTable(4);
        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([35,35,10,20]))

        addCellTabla(tablaD, new Paragraph("Profesor", fontNormalBold), prmsCentro)
        addCellTabla(tablaD, new Paragraph("Asignatura", fontNormalBold), prmsCentro)
        addCellTabla(tablaD, new Paragraph("Paralelo", fontNormalBold), prmsCentro)
        addCellTabla(tablaD, new Paragraph("Tipo", fontNormalBold), prmsCentro)

        res.eachWithIndex { p , j ->
            addCellTabla(tablaD, new Paragraph(p?.prof, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaD, new Paragraph(p?.mate, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaD, new Paragraph(p?.prll + " ", fontThUsar), prmsCrBorder)
            addCellTabla(tablaD, new Paragraph(p?.tipo, fontThUsar), prmsIzBorder3)
        }

        Paragraph textoFinal = new Paragraph("Potenciador Moderado: respuestas seleccionadas = Frecuentemente", fontTitulo2)
        Paragraph textoFinal2 = new Paragraph("Potenciador Exagerado: respuestas seleccionadas = Siempre", fontTitulo2)

        document.add(tablaD)
        document.add(textoFinal)
        document.add(textoFinal2)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'profesoresXPotenciadores' + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def grafico_ajax () {

//        println("params g " + params)

        def profesorP = Profesor.get(params.profesor)
        def periodo = Periodo.get(params.periodo)
        def escuela = Escuela.get(params.escuela)
        def dicta = Dictan.get(params.dicta)
        def vrbl = Variables.findAllBySiglaIsNotNull([sort: 'orden'])

        def cn = dbConnectionService.getConnection()
        def prsn = Persona.get(session.usuario.id)
        def sql

        def profesor = []
        def dc, ad
        def pp

        pp = profesorP

        sql = "select ddsc*100 ddsc, ddac*100 ddac, ddhd*100 ddhd, ddci*100 ddci, dcni*100 dcni, d_ea*100 d_ea, tpen__id, prof__id " +
                "from rpec " +
                "where rpec.escl__id = ${escuela?.id} and rpec.prdo__id = ${periodo?.id} and tpen__id = 2 and " +
                "prof__id = ${profesorP?.id} and dcta__id = ${dicta?.id}"

        dc = "0_0_0_0_0_0"
        cn.eachRow(sql.toString()) { d ->
            dc = "${d.ddsc}_${d.ddac}_${d.ddhd}_${d.ddci}_${d.dcni}_${d.d_ea}"
        }

        sql = "select ddsc*100 ddsc, ddac*100 ddac, ddhd*100 ddhd, ddci*100 ddci, dcni*100 dcni, d_ea*100 d_ea " +
                "from rpec " +
                "where rpec.escl__id = ${escuela?.id} and rpec.prdo__id = ${periodo?.id} and tpen__id = 1 and " +
                "prof__id = ${profesorP?.id} limit 1"
        ad = "0_0_0_0_0_0"
        cn.eachRow(sql.toString()) { d ->
            ad = "${d.ddsc}_${d.ddac}_${d.ddhd}_${d.ddci}_${d.dcni}_${d.d_ea}"
        }

//            println("dc " + dc)

//            pp["dc"] = dc
//            pp["ad"] = ad
        profesor.add(dc)
        profesor.add(ad)

        sql = "select estdmini, estdoptm from auxl, prdo where univ__id = ${prsn.universidad.id} and " +
                "prdo.prdo__id = auxl.prdo__id"
//        println "sql: $sql"
        def minMax = cn.rows(sql.toString())
//        println "min.... $minMax"

//        println "prof: ${profesor[0]}---${profesor[1]}"
        [prof: profesor, minimo: minMax.estdmini, optimo: minMax.estdoptm, vrbl: vrbl]

    }


    def reporteSubareas () {

//        println("params " + params)

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)
        def escuela = Escuela.get(params.escl)
        def variable = Variables.get(params.tipo)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLDITALIC);

        Font times10bold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font times10normal = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)


        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte de Desempeño de subareas");
        document.addSubject("Generado por el sistema");
        document.addKeywords("reporte, docentes, profesores");
        document.addAuthor("Docentes");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        preface.add(new Paragraph("Reporte", fontTitulo));

        Paragraph parrafoUniversidad = new Paragraph(periodo?.universidad?.nombre?.toUpperCase() ?: '', fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + facultad.nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo1 = new Paragraph("ESCUELA: " + (escuela?.nombre ?: ''), fontTitulo)
        lineaTitulo1.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaSubtitulo = new Paragraph("ÁREA: " + variable.descripcion, fontNormalBold )
        lineaSubtitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo = new Paragraph("Desempeño por Subáreas", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(lineaTitulo1)
        document.add(lineaTitulo)
        document.add(lineaSubtitulo)
        document.add(lineaVacia)

//        def sql =  "select * from f_exito(${facultad?.id},${escuela?.id},${periodo?.id}) ORDER BY facl, prof, mate"

        def sql = "select * from subareas(${facultad?.id},${escuela?.id},${periodo?.id},${variable?.id}) order by prof, mate, pcnt desc;"

        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bg: new BaseColor(95, 113, 132)]
        def prmsIzBorder2 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder3 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorderAzul = [border: BaseColor.BLUE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]


        def varProf
        def varMate

        res.eachWithIndex { p , j ->

            if(p?.prof != varProf){
                PdfPTable tablaC = new PdfPTable(2);
                tablaC.setWidthPercentage(100);
                tablaC.setWidths(arregloEnteros([70, 30]))

                addCellTabla(tablaC, new Paragraph("Profesor: " + p?.prof, fontNormalBold3), prmsIzBorder)
                addCellTabla(tablaC, new Paragraph("Curso: " + p?.crso, fontNormalBold3), prmsIzBorder)
                document.add(tablaC);

                varMate = null
            }


            if(p?.mate != varMate){
                PdfPTable tablaD = new PdfPTable(2);
                tablaD.setWidthPercentage(100);
                tablaD.setWidths(arregloEnteros([70,30 ]))

                addCellTabla(tablaD, new Paragraph("Asignatura: " + p?.mate, fontNormalBold), prmsIzBorder2)
                addCellTabla(tablaD, new Paragraph(" Paralelo: " + p?.prll, fontNormalBold), prmsIzBorder2)
                addCellTabla(tablaD, new Paragraph("  ", fontNormalBold), prmsIzBorder2)

                document.add(tablaD);

                PdfPTable tablaF = new PdfPTable(2);
                tablaF.setWidthPercentage(100);
                tablaF.setWidths(arregloEnteros([87, 13]))

                addCellTabla(tablaF, new Paragraph("Subárea", fontNormalBold4), prmsCrBorder)
                addCellTabla(tablaF, new Paragraph("% de Insatisfacción", fontNormalBold4), prmsCrBorder)

                document.add(tablaF);

            }

            PdfPTable tablaE = new PdfPTable(2);
            tablaE.setWidthPercentage(100);
            tablaE.setWidths(arregloEnteros([87, 13]))

            Paragraph causa = new Paragraph()
            causa.setAlignment(Element.ALIGN_JUSTIFIED)
            causa.add(new Paragraph(p?.causa,times10normal))
            causa.add(new Chunk(" (Pregunta: ", times10bold))
            causa.add(new Chunk(p?.preg + ")", times10normal))

            addCellTabla(tablaE, causa, prmsIzBorder3)
            addCellTabla(tablaE, new Paragraph(numero(p?.pcnt,0), fontThUsar), prmsCrBorder)
            document.add(tablaE);

            varProf = p.prof
            varMate = p.mate

        }

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'desempenoXSubarea' + ".pdf")
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def escuelasCom_ajax () {
        def facultad = Facultad.get(params.facultad)
        def periodo = Periodo.get(params.periodo)
        def escuelas = Escuela.findAllByFacultad(facultad, [sort: 'nombre', order: 'asc'])

        return [escuelas: escuelas, periodo: periodo]
    }

    def asignatura_ajax() {

//        println("params as " + params )

        def cn = dbConnectionService.getConnection()
        def escuelas = Escuela.get(params.escuela)
        def periodo = Periodo.get(params.periodo)
        def sql = "select distinct mate.mate__id id, matedscr materia from mate, prof, dcta " +
                "where dcta.mate__id in (select mate__id from dcta " +
                "  where escl__id = ${escuelas?.id} and dcta.dcta__id in (select dcta__id from rpec where tpen__id = 2 and " +
                "  prdo__id = ${periodo?.id} and escl__id = ${escuelas?.id}) " +
                "  group by mate__id having count(*) > 1) and mate.mate__id = dcta.mate__id and " +
                "  prof.prof__id = dcta.prof__id " +
                "order by matedscr"
        def materias = cn.rows(sql.toString())


        return[materias: materias]
    }


}
