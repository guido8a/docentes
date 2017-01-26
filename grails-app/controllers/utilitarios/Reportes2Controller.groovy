package utilitarios


import docentes.Escuela
import docentes.Facultad
import docentes.Periodo
import docentes.Profesor
import docentes.Variables

import com.itextpdf.text.Image;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.*;

import com.itextpdf.text.*

import com.itextpdf.text.Document;

import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfTemplate;
import com.itextpdf.text.pdf.PdfWriter;


class Reportes2Controller {

    def dbConnectionService

    def index() { }

    private static int[] arregloEnteros(array) {
        int[] ia = new int[array.size()]
        array.eachWithIndex { it, i ->
            ia[i] = it.toInteger()
        }

        return ia
    }

    private static void addCellTabla(PdfPTable table, paragraph, params) {
        PdfPCell cell = new PdfPCell(paragraph);
        if (params.height) {
            cell.setFixedHeight(params.height.toFloat());
        }
        if (params.border) {
            cell.setBorderColor(params.border);
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

    def recomendaciones () {


//        println "reporteRecomendaciones $params"
        def periodo = Periodo.get(params.periodo)
        def profesor = Profesor.get(params.profe)


        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte recomendaciones profesores");
        document.addSubject("Generado por el sistema");
        document.addKeywords("reporte, docentes, profesores");
        document.addAuthor("Docentes");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        preface.add(new Paragraph("Reporte", fontTitulo));

        Paragraph parrafoUniversidad = new Paragraph("UNIVERSIDAD", fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + Facultad.get(params.facultad).nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoProfesor = new Paragraph("PROFESOR: " + profesor?.nombre + " " + profesor?.apellido, fontTitulo)
        parrafoProfesor.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo = new Paragraph("Recomendaciones", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoProfesor)
        document.add(lineaTitulo)
        document.add(lineaVacia)

        def sql =  "select * from informe(${profesor?.id},${periodo?.id})"

//        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsTdBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        /* ************************************************************* HEADER PLANILLA ***************************************************************************/
        PdfPTable tablaD = new PdfPTable(2);
        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([90, 10]))

        addCellTabla(tablaD, new Paragraph("Descripción", fontTitulo), prmsCrBorder)
        addCellTabla(tablaD, new Paragraph("Grado", fontTitulo), prmsCrBorder)


        res.eachWithIndex { p , j ->

            addCellTabla(tablaD, new Paragraph(p.rcmndscr, fontThUsar), prmsTdNoBorder)
            addCellTabla(tablaD, new Paragraph(p.ref, fontThUsar), prmsCrBorder)

        }

        document.add(tablaD);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'prueba')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def botella () {


        println "reporteBotella $params"

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)
//        def profesor = Profesor.get(params.profe)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        fontNormalBold.setColor(BaseColor.BLUE)

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte cuello de botella");
        document.addSubject("Generado por el sistema");
        document.addKeywords("reporte, docentes, profesores");
        document.addAuthor("Docentes");
        document.addCreator("Tedein SA");

        Paragraph preface = new Paragraph();
        preface.add(new Paragraph("Reporte", fontTitulo));

        Paragraph parrafoUniversidad = new Paragraph("UNIVERSIDAD", fontTitulo)
        parrafoUniversidad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph parrafoFacultad = new Paragraph("FACULTAD: " + facultad.nombre, fontTitulo)
        parrafoFacultad.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

//        Paragraph parrafoProfesor = new Paragraph("PROFESOR: " + profesor?.nombre + " " + profesor?.apellido, fontTitulo)
//        parrafoProfesor.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaTitulo = new Paragraph("Cuellos de botella", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
//        document.add(parrafoProfesor)
        document.add(lineaTitulo)
        document.add(lineaVacia)

        def sql =  "select * from cuellos(${facultad?.id},${periodo?.id}) ORDER BY prof"

        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorderAzul = [border: BaseColor.BLUE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        /* ************************************************************* HEADER PLANILLA ***************************************************************************/
//        PdfPTable tablaC = new PdfPTable(2);
//        tablaC.setWidthPercentage(100);
//        tablaC.setWidths(arregloEnteros([70, 30]))

//        PdfPTable tablaD = new PdfPTable(3);
//        tablaD.setWidthPercentage(100);
//        tablaD.setWidths(arregloEnteros([60, 10, 30]))

        def varProf
        def varMate

        res.eachWithIndex { p , j ->

//            println("------> " + j)

            if(p?.prof != varProf){
                PdfPTable tablaC = new PdfPTable(2);
                tablaC.setWidthPercentage(100);
                tablaC.setWidths(arregloEnteros([63, 37]))

                addCellTabla(tablaC, new Paragraph("Profesor: " + p?.prof, fontNormalBold), prmsIzBorder)
                addCellTabla(tablaC, new Paragraph("Curso: " + p?.crso, fontNormalBold), prmsIzBorder)
                document.add(tablaC);
            }

            if(p?.mate != varMate){
                PdfPTable tablaD = new PdfPTable(3);
                tablaD.setWidthPercentage(100);
                tablaD.setWidths(arregloEnteros([50,13,37 ]))

                addCellTabla(tablaD, new Paragraph("Asignatura: " + p?.mate, fontNormalBold), prmsIzBorder)
                addCellTabla(tablaD, new Paragraph(" Paralelo: " + p?.prll, fontNormalBold), prmsIzBorder)
                addCellTabla(tablaD, new Paragraph(" Tipo: " + p?.tipo, fontNormalBold), prmsIzBorder)

                document.add(tablaD);

                PdfPTable tablaF = new PdfPTable(2);
                tablaF.setWidthPercentage(100);
                tablaF.setWidths(arregloEnteros([85, 15]))

                addCellTabla(tablaF, new Paragraph("Causa", fontNormalBold2), prmsCrBorder)
                addCellTabla(tablaF, new Paragraph("Frecuencias", fontNormalBold2), prmsCrBorder)

                document.add(tablaF);

            }



            PdfPTable tablaE = new PdfPTable(2);
            tablaE.setWidthPercentage(100);
            tablaE.setWidths(arregloEnteros([85, 15]))

//            addCellTabla(tablaE, new Paragraph("Causa", fontNormalBold), prmsTdNoBorder)
//            addCellTabla(tablaE, new Paragraph("Frecuencias", fontNormalBold), prmsTdNoBorder)

            addCellTabla(tablaE, new Paragraph(p?.causa, fontThUsar), prmsIzBorder)
            addCellTabla(tablaE, new Paragraph(numero(p?.frec,0), fontThUsar), prmsCrBorder)
            document.add(tablaE);

            varProf = p.prof
            varMate = p.mate

//            document.
        }

//        document.add(tablaD);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'prueba')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)


    }
}