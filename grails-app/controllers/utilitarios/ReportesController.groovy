package utilitarios

import com.itextpdf.text.pdf.codec.Base64
import com.lowagie.text.Element
import com.lowagie.text.Font
import com.lowagie.text.PageSize
import com.lowagie.text.Paragraph
import com.lowagie.text.pdf.PdfContentByte
import com.lowagie.text.pdf.PdfPTable
import docentes.Escuela
import docentes.Periodo
import java.awt.image.*

import javax.swing.JPanel;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.general.PieDataset;
import org.jfree.ui.ApplicationFrame;
import org.jfree.ui.RefineryUtilities;



import org.jfree.chart.ChartFactory

import org.jfree.chart.ChartPanel

import org.jfree.chart.JFreeChart

import org.jfree.chart.plot.PlotOrientation

import org.jfree.chart.plot.XYPlot

import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer

import org.jfree.ui.ApplicationFrame

import org.jfree.ui.RefineryUtilities

import org.jfree.data.category.DefaultCategoryDataset

import java.awt.Color
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.data.general.DefaultPieDataset;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfWriter;

import com.itextpdf.text.Document;
import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfWriter;

import java.io.FileOutputStream;


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
        def escuela
        if(params.periodo){
            periodo = Periodo.get(params.periodo)
        }else{
            periodo = null
        }

        if(params.escuela){
            escuela = Escuela.get(params.escuela)
        }else{
            escuela = null
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
                    "where dcta.prdo__id = '${periodo?.id}' and escl.escl__id = '${escuela?.id}' and crso.crso__id = dcta.crso__id and estd.estd__id = matr.estd__id and " +
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
                        "where dcta.prdo__id = '${periodo?.id}' and escl.escl__id = '${escuela?.id}' and crso.crso__id = dcta.crso__id and estd.estd__id = matr.estd__id and " +
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

    def facultad_ajax () {

    }

    def prueba () {

    }




//        def getChart() {
//
//            println("entro")
//
//            def dataset = createDataset()
//
//            def chart = createChart(dataset)
//
//            println("chart " + chart)
//
//            render chart
//
//
////            return chart
//
//        }


//
//        def createDataset(){
//
//            DefaultCategoryDataset dataset = new DefaultCategoryDataset();
//
//            dataset.addValue(212, "Classes", "JDK 1.0");
//
//            dataset.addValue(504, "Classes", "JDK 1.1");
//
//            dataset.addValue(1520, "Classes", "SDK 1.2");
//
//            dataset.addValue(1842, "Classes", "SDK 1.3");
//
//            dataset.addValue(2991, "Classes", "SDK 1.4");
//
//            return dataset
//
//        }



//        def createChart(dataset){
//
//            JFreeChart chart = ChartFactory.createLineChart(
//
//                    "Java Standard Class Library", // chart title
//
//                    "Release", // domain axis label
//
//                    "Class Count", // range axis label
//
//                    dataset, // data
//
//                    PlotOrientation.VERTICAL, // orientation
//
//                    false, // include legend
//
//                    true, // tooltips
//
//                    false // urls
//
//            )
//
//            return chart
//
//        }





    public JFreeChart getChart() {
        //create dummy data
        //taken from http://www.java2s.com/Code/Java/Chart/JFreeChartPieChartDemo1.htm
        DefaultPieDataset dataset = new DefaultPieDataset();
        dataset.setValue("One", new Double(43.2));
        dataset.setValue("Two", new Double(10.0));
        dataset.setValue("Three", new Double(27.5));
        dataset.setValue("Four", new Double(17.5));
        dataset.setValue("Five", new Double(11.0));
        dataset.setValue("Six", new Double(19.4));

        //use the ChartFactory to create a pie chart
        JFreeChart chart =
                ChartFactory.createPieChart(
                        "Dummy Data", dataset, true, true, false);
        return chart;
    }


//    public void create(OutputStream outputStream) throws DocumentException, IOException {
//        println("entro create")
//        Document document = null;
//        PdfWriter writer = null;
//
//        try {
//            //instantiate document and writer
//            document = new Document();
////            writer = PdfWriter.getInstance(document, outputStream);
//
//            PdfWriter wr = PdfWriter.getInstance(document,
//                    new FileOutputStream("Image.pdf"));
//
//            //open document
//            document.open();
//
//            //add image
//            int width = 300;
//            int height = 300;
//            JFreeChart chart = getChart();
//            BufferedImage bufferedImage = chart.createBufferedImage(width, height);
//            Image image = Image.getInstance(wr, bufferedImage, 1.0f);
//            document.add(image);
//
//            //release resources
//            document.close();
//            println("document "  + document)
////            document = null;
//
////            writer.close();
////            writer = null;
//        } catch(DocumentException de) {
//            println("de ")
//            throw de;
//        } catch (IOException ioe) {
//            println("ioe ")
//            throw ioe;
//        } finally {
//            //release resources
////            if(null != document) {
////                try { document.close(); }
////                catch(Exception ex) { }
////            }
////
////            if(null != writer) {
////                try { writer.close(); }
////                catch(Exception ex) { }
////            }
//        }
//    }



//    public static void main(String[] args) throws FileNotFoundException, DocumentException, IOException {
//        (new ReportesController()).create(
//                new FileOutputStream(
//                        new File("demo.pdf")));
//    }

    def nn() {

//        def k = main()

       def k =  new ReportesController().create(new FileOutputStream(new File("demo.pdf")))

        println("k " + k)

        return false

    }

    def reportedePrueba() {
//        def planilla = Planilla.get(params.id)
//        def obra = planilla.contrato.oferta.concurso.obra
//        def contrato = planilla.contrato

//        def detalles = DetallePlanillaCosto.findAllByPlanilla(planilla)

        def baos = new ByteArrayOutputStream()
//        def name = "planilla_" + new Date().format("ddMMyyyy_hhmm") + ".pdf";
//
        Font fontTituloGad = new Font(Font.TIMES_ROMAN, 12, Font.BOLD);
//        Font info = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL)
//        Font fontTh = new Font(Font.TIMES_ROMAN, 9, Font.BOLD);
//        Font fontTd = new Font(Font.TIMES_ROMAN, 9, Font.NORMAL);
//        Font fontThFirmas = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
//        Font fontThUsar = new Font(Font.TIMES_ROMAN, 10, Font.BOLD);
//        Font fontTdUsar = new Font(Font.TIMES_ROMAN, 10, Font.NORMAL);
//        Font fontResumen = new Font(Font.TIMES_ROMAN, 11, Font.BOLD);
//
//        def prmsTablaHead = [bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
//        def prmsTabla = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
//        def centrado  = [border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
//        def prmsTablaNum = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
//
//        def logoPath = servletContext.getRealPath("/") + "images/logo_gadpp_reportes.png"
//        com.lowagie.text.Image logo = com.lowagie.text.Image.getInstance(logoPath);
//        logo.setAlignment(com.lowagie.text.Image.LEFT | com.lowagie.text.Image.TEXTWRAP)

        com.lowagie.text.Document document
//        document = new com.lowagie.text.Document(PageSize.A4.rotate());
        document = new com.lowagie.text.Document(PageSize.A4);
        def pdfw = com.lowagie.text.pdf.PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Planillas de la obra ");
        document.addSubject("Generado por el sistema Janus");
        document.addKeywords("reporte, janus, planillas");
        document.addAuthor("Janus");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
//        addEmptyLine(preface, 1);
//        preface.setAlignment(Element.ALIGN_CENTER);
        preface.add(new Paragraph("Reporte jfreechart de prueba", fontTituloGad));
//        preface.add(new Paragraph("PLANILLA DE ${planilla.tipoPlanilla.nombre.toUpperCase()} DE LA OBRA " + obra.nombre, fontTituloGad));
//        addEmptyLine(preface, 1);
//        Paragraph preface2 = new Paragraph();
//        preface2.add(new Paragraph("Generado por el usuario: " + session.usuario + "   el: " + new Date().format("dd/MM/yyyy hh:mm"), info))
//        addEmptyLine(preface2, 1);
//        document.add(logo)


//        PdfWriter writer = PdfWriter.getInstance(document,new FileOutputStream("Image.pdf"));
//
//        PdfWriter wr = PdfWriter.getInstance(document,
//                    new FileOutputStream("Image.pdf"));


        int width = 300;
        int height = 300;
        JFreeChart chart = getChart();
        BufferedImage bufferedImage = chart.createBufferedImage(width, height);
//        Image image = Image.getInstance(bufferedImage);
        document.add(bufferedImage);




        document.add(preface);
//        document.add(preface2);

//        def prmsTdNoBorder = [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
//        def prmsTdBorder = [border: Color.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
//        def prmsNmBorder = [border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]

        /* ************************************************************* HEADER PLANILLA ***************************************************************************/
//        PdfPTable tablaHeaderPlanilla = new PdfPTable(5);
//        tablaHeaderPlanilla.setWidthPercentage(100);
//        tablaHeaderPlanilla.setWidths(arregloEnteros([12, 24, 10, 12, 24]))
//        tablaHeaderPlanilla.setWidthPercentage(100);
//
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("Obra", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph(obra.nombre, fontTdUsar), [border: Color.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, colspan: 4])
//
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("Lugar", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph((obra.lugar?.descripcion ?: ""), fontTdUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("Planilla", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph(planilla.numero, fontTdUsar), prmsTdNoBorder)
//
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("Ubicación", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph(obra.parroquia?.nombre + " - Cantón " + obra.parroquia?.canton?.nombre, fontTdUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("Monto contrato", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph(numero(planilla.contrato.monto, 2), fontTdUsar), prmsTdNoBorder)
//
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("Contratista", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph(planilla.contrato.oferta.proveedor.nombre, fontTdUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("Fecha", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph(fechaConFormato(planilla.fechaPresentacion, "dd-MMM-yyyy"), fontTdUsar), prmsTdNoBorder)
//
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("Plazo", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph(numero(planilla.contrato.plazo, 0) + " días", fontTdUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("", fontThUsar), prmsTdNoBorder)
//        addCellTabla(tablaHeaderPlanilla, new Paragraph("", fontTdUsar), prmsTdNoBorder)
//
//        document.add(tablaHeaderPlanilla);
        /* ************************************************************* FIN HEADER PLANILLA ***************************************************************************/

        /* ************************************************************* TABLA DE DATOS ***************************************************************************/
//        def tabla = new PdfPTable(8);
//        tabla.setWidthPercentage(100);
//        tabla.setWidths(arregloEnteros([10, 40, 10, 10, 10, 10, 10, 10]))
//        tabla.setWidthPercentage(100);
//        tabla.setSpacingAfter(1f);
//        tabla.setSpacingBefore(10f);
//
//        addCellTabla(tabla, new Paragraph("Factura N.", fontTh), prmsTablaHead)
//        addCellTabla(tabla, new Paragraph("Descripción del rubro", fontTh), prmsTablaHead)
//        addCellTabla(tabla, new Paragraph("U.", fontTh), prmsTablaHead)
//        addCellTabla(tabla, new Paragraph("Cantidad", fontTh), prmsTablaHead)
//        addCellTabla(tabla, new Paragraph("Valor sin IVA", fontTh), prmsTablaHead)
//        addCellTabla(tabla, new Paragraph("Valor con IVA", fontTh), prmsTablaHead)
////        addCellTabla(tabla, new Paragraph("% de indirectos (" + numero(detalles[0].indirectos, 0) + "%)", fontTh), prmsTablaHead)
//        addCellTabla(tabla, new Paragraph("% de indirectos (" + contrato?.indirectos + "%)", fontTh), prmsTablaHead)
//        addCellTabla(tabla, new Paragraph("Valor total", fontTh), prmsTablaHead)
//
//        def total = 0
//        def totalSinIva = 0
//        def totalConIva = 0
//        def totalIndirectos = 0

//        detalles.each { det ->
////            def tot = det.montoIndirectos + det.montoIva
//            def tot = det.monto + det.montoIndirectos
//            total += tot
//            totalSinIva += det.monto
//            totalConIva += det.montoIva
//            totalIndirectos += det.montoIndirectos
//
//            addCellTabla(tabla, new Paragraph(det.factura, fontTd), prmsTabla)
//            addCellTabla(tabla, new Paragraph(det.rubro, fontTd), prmsTabla)
//            addCellTabla(tabla, new Paragraph(det.unidad.codigo, fontTd), centrado)
//            addCellTabla(tabla, new Paragraph(numero(det.cantidad,2), fontTd), prmsTablaNum)
//            addCellTabla(tabla, new Paragraph(numero(det.monto, 2), fontTd), prmsTablaNum)
//            addCellTabla(tabla, new Paragraph(numero(det.montoIva, 2), fontTd), prmsTablaNum)
//            addCellTabla(tabla, new Paragraph(numero(det.montoIndirectos, 2), fontTd), prmsTablaNum)
//            addCellTabla(tabla, new Paragraph(numero(tot, 2), fontTd), prmsTablaNum)
//        }
//        addCellTabla(tabla, new Paragraph("TOTALES", fontTh), [bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE, colspan: 4])
//        addCellTabla(tabla, new Paragraph(numero(totalSinIva, 2), fontTh), [bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tabla, new Paragraph(numero(totalConIva, 2), fontTh), [bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tabla, new Paragraph(numero(totalIndirectos, 2), fontTh), [bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tabla, new Paragraph(numero(total, 2), fontTh), [bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE])
//        document.add(tabla)
        /* ************************************************************* FIN TABLA DE DATOS ***************************************************************************/

        /* ************************************************************* TABLAS DE RESUMEN ***************************************************************************/
//        def tablaResumen1 = new PdfPTable(2);
//        tablaResumen1.setWidthPercentage(100);
//        tablaResumen1.setWidths(arregloEnteros([80, 20]))
//        tablaResumen1.setSpacingAfter(1f);
//        tablaResumen1.setSpacingBefore(10f);
//
//        def totalCostoPorcentaje = totalConIva+totalIndirectos
//
//        addCellTabla(tablaResumen1, new Paragraph("TOTAL OBRAS BAJO LA MODALIDAD COSTO + PORCENTAJE (NO INCLUYE IVA)", fontResumen), [padding: 5, bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tablaResumen1, new Paragraph(numero(total, 2), fontResumen), [padding: 5, border: 2, bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
////        addCellTabla(tablaResumen1, new Paragraph(numero(totalCostoPorcentaje, 2), fontResumen), [padding: 5, border: 2, bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//
//        document.add(tablaResumen1)
//
//        def tablaResumen2 = new PdfPTable(2);
//        tablaResumen2.setWidthPercentage(100);
//        tablaResumen2.setWidths(arregloEnteros([80, 20]))
//        tablaResumen2.setSpacingAfter(1f);
//        tablaResumen2.setSpacingBefore(10f);
//
//        def porcentaje = total / contrato.monto
//
//        addCellTabla(tablaResumen2, new Paragraph("% TOTAL OBRAS ADICIONALES NO CONTRACTUALES", fontResumen), [padding: 5, bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tablaResumen2, new Paragraph(numero(porcentaje*100, 2) + " %", fontResumen), [padding: 5, border: 2, bg: Color.LIGHT_GRAY, border: Color.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//
//        document.add(tablaResumen2)
        /* ************************************************************* FIN TABLAS DE RESUMEN ***************************************************************************/

        /* ************************************************************* TABLA DE FIRMAS ***************************************************************************/
//        def tablaFirmas = new PdfPTable(3);
//        tablaFirmas.setWidthPercentage(100);
//
//        def fiscalizador = planilla.fiscalizador
//        def strFiscalizador = nombrePersona(fiscalizador) + "\nFiscalizador"
//        tablaFirmas.setWidths(arregloEnteros([40, 20, 40]))
//
//        addCellTabla(tablaFirmas, new Paragraph("", fontThFirmas), [height: 50, border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tablaFirmas, new Paragraph("", fontThFirmas), [height: 50, bwb: 1, bcb: Color.BLACK, border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tablaFirmas, new Paragraph("", fontThFirmas), [height: 50, border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//
//        addCellTabla(tablaFirmas, new Paragraph("", fontThFirmas), [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tablaFirmas, new Paragraph(strFiscalizador, fontThFirmas), [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//        addCellTabla(tablaFirmas, new Paragraph("", fontThFirmas), [border: Color.WHITE, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE])
//
//        document.add(tablaFirmas)
        /* ************************************************************* FIN TABLA DE FIRMAS ***************************************************************************/

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'prueba')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }






}
