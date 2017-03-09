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
import com.itextpdf.text.pdf.PdfWriter
import org.fusesource.jansi.Ansi
import org.xhtmlrenderer.css.parser.property.PrimitivePropertyBuilders;


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
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLDITALIC);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)


        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte de Cuellos de Botella");
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

        Paragraph lineaTitulo = new Paragraph("Cuellos de Botella", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
//        document.add(parrafoProfesor)
        document.add(lineaTitulo)
        document.add(lineaVacia)

//        def sql =  "select * from cuellos(${facultad?.id},${periodo?.id}) ORDER BY prof"
        def sql =  "select * from cuellos(${facultad?.id},${periodo?.id}) where cllo = 'S' and tipo like '%CUELLO%' order by prof"

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
                tablaC.setWidths(arregloEnteros([63, 37]))

                addCellTabla(tablaC, new Paragraph("Profesor: " + p?.prof, fontNormalBold3), prmsIzBorder)
                addCellTabla(tablaC, new Paragraph("Curso: " + p?.crso, fontNormalBold3), prmsIzBorder)
                document.add(tablaC);
            }

            if(p?.mate != varMate){
                PdfPTable tablaD = new PdfPTable(3);
                tablaD.setWidthPercentage(100);
                tablaD.setWidths(arregloEnteros([50,13,37 ]))

                addCellTabla(tablaD, new Paragraph("Asignatura: " + p?.mate, fontNormalBold), prmsIzBorder2)
                addCellTabla(tablaD, new Paragraph(" Paralelo: " + p?.prll, fontNormalBold), prmsIzBorder2)
                addCellTabla(tablaD, new Paragraph(" Tipo: " + p?.tipo, fontNormalBold), prmsIzBorder2)

                document.add(tablaD);

                PdfPTable tablaF = new PdfPTable(2);
                tablaF.setWidthPercentage(100);
                tablaF.setWidths(arregloEnteros([85, 15]))

                addCellTabla(tablaF, new Paragraph("Causa", fontNormalBold4), prmsCrBorder)
                addCellTabla(tablaF, new Paragraph("Frecuencias", fontNormalBold4), prmsCrBorder)

                document.add(tablaF);

            }

            PdfPTable tablaE = new PdfPTable(2);
            tablaE.setWidthPercentage(100);
            tablaE.setWidths(arregloEnteros([85, 15]))

            addCellTabla(tablaE, new Paragraph(p?.causa, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaE, new Paragraph(numero(p?.frec,0), fontThUsar), prmsCrBorder)
            document.add(tablaE);

            varProf = p.prof
            varMate = p.mate

        }

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'prueba')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def potencia () {

//        println "reportePotencia $params"

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)


        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLDITALIC);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)


        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte de Factores de Potenciación");
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

        Paragraph lineaTitulo = new Paragraph("Factores de Potenciación", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
//        document.add(parrafoProfesor)
        document.add(lineaTitulo)
        document.add(lineaVacia)

//        def sql =  "select * from cuellos(${facultad?.id},${periodo?.id}) ORDER BY prof"
        def sql =  "select * from cuellos(${facultad?.id},${periodo?.id}) where cllo = 'S' and tipo like '%POTENCIA%' order by facl,prof,mate"

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
                tablaC.setWidths(arregloEnteros([63, 37]))

                addCellTabla(tablaC, new Paragraph("Profesor: " + p?.prof, fontNormalBold3), prmsIzBorder)
                addCellTabla(tablaC, new Paragraph("Curso: " + p?.crso, fontNormalBold3), prmsIzBorder)
                document.add(tablaC);
            }

            if(p?.mate != varMate){
                PdfPTable tablaD = new PdfPTable(3);
                tablaD.setWidthPercentage(100);
                tablaD.setWidths(arregloEnteros([50,13,37 ]))

                addCellTabla(tablaD, new Paragraph("Asignatura: " + p?.mate, fontNormalBold), prmsIzBorder2)
                addCellTabla(tablaD, new Paragraph(" Paralelo: " + p?.prll, fontNormalBold), prmsIzBorder2)
                addCellTabla(tablaD, new Paragraph(" Tipo: " + p?.tipo, fontNormalBold), prmsIzBorder2)

                document.add(tablaD);

                PdfPTable tablaF = new PdfPTable(2);
                tablaF.setWidthPercentage(100);
                tablaF.setWidths(arregloEnteros([85, 15]))

                addCellTabla(tablaF, new Paragraph("Causa", fontNormalBold4), prmsCrBorder)
                addCellTabla(tablaF, new Paragraph("Frecuencias", fontNormalBold4), prmsCrBorder)

                document.add(tablaF);

            }

            PdfPTable tablaE = new PdfPTable(2);
            tablaE.setWidthPercentage(100);
            tablaE.setWidths(arregloEnteros([85, 15]))

            addCellTabla(tablaE, new Paragraph(p?.causa, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaE, new Paragraph(numero(p?.frec,0), fontThUsar), prmsCrBorder)
            document.add(tablaE);

            varProf = p.prof
            varMate = p.mate

        }

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'prueba')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

    def exito () {

//        println "reporteExito $params"

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)


        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLDITALIC);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)


        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte de Factores de Éxito");
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

        Paragraph lineaTitulo = new Paragraph("Factores de Éxito", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
//        document.add(parrafoProfesor)
        document.add(lineaTitulo)
        document.add(lineaVacia)

        def sql =  "select * from f_exito(${facultad?.id},${periodo?.id}) ORDER BY facl, prof, mate"

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
                tablaC.setWidths(arregloEnteros([63, 37]))

                addCellTabla(tablaC, new Paragraph("Profesor: " + p?.prof, fontNormalBold3), prmsIzBorder)
                addCellTabla(tablaC, new Paragraph("Curso: " + p?.crso, fontNormalBold3), prmsIzBorder)
                document.add(tablaC);
            }

            if(p?.mate != varMate){
                PdfPTable tablaD = new PdfPTable(3);
                tablaD.setWidthPercentage(100);
                tablaD.setWidths(arregloEnteros([50,13,37 ]))

                addCellTabla(tablaD, new Paragraph("Asignatura: " + p?.mate, fontNormalBold), prmsIzBorder2)
                addCellTabla(tablaD, new Paragraph(" Paralelo: " + p?.prll, fontNormalBold), prmsIzBorder2)
                addCellTabla(tablaD, new Paragraph(" Tipo: " + p?.tipo, fontNormalBold), prmsIzBorder2)

                document.add(tablaD);

                PdfPTable tablaF = new PdfPTable(2);
                tablaF.setWidthPercentage(100);
                tablaF.setWidths(arregloEnteros([85, 15]))

                addCellTabla(tablaF, new Paragraph("Causa", fontNormalBold4), prmsCrBorder)
                addCellTabla(tablaF, new Paragraph("Frecuencias", fontNormalBold4), prmsCrBorder)

                document.add(tablaF);

            }

            PdfPTable tablaE = new PdfPTable(2);
            tablaE.setWidthPercentage(100);
            tablaE.setWidths(arregloEnteros([85, 15]))

            addCellTabla(tablaE, new Paragraph(p?.causa, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaE, new Paragraph(numero(p?.frec,0), fontThUsar), prmsCrBorder)
            document.add(tablaE);

            varProf = p.prof
            varMate = p.mate

        }

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'prueba')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def clasificacion () {

        //        println "reporteClasificacion $params"

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)


        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold4 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLDITALIC);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)


        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte Factores de éxito");
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

        Paragraph lineaTitulo = new Paragraph("Factores de éxito", fontTitulo )
        lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(lineaTitulo)
        document.add(lineaVacia)

        def sql = "select facldscr, profapll||' '||profnmbr prof, clase from rpec, prof, escl, facl where prof.prof__id = rpec.prof__id and escl.escl__id = prof.escl__id and facl.facl__id = escl.facl__id and clase is not null order by facldscr, profapll;"

        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bg: new BaseColor(95, 113, 132)]
        def prmsIzBorder2 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder4 = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_CENTER,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder3 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorderAzul = [border: BaseColor.BLUE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        PdfPTable tablaD = new PdfPTable(3);
        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([50,40,10]))

        addCellTabla(tablaD, new Paragraph("Asignatura", fontNormalBold), prmsIzBorder4)
        addCellTabla(tablaD, new Paragraph("Profesor", fontNormalBold), prmsIzBorder4)
        addCellTabla(tablaD, new Paragraph("Clase", fontNormalBold), prmsIzBorder4)


        res.eachWithIndex { p , j ->
            addCellTabla(tablaD, new Paragraph(p?.facldscr, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaD, new Paragraph(p?.prof, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaD, new Paragraph(p?.clase, fontThUsar), prmsCrBorder)

        }
        document.add(tablaD);
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'clasificacion')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)


    }

    def encuesta () {

        //        println "reporteClasificacion $params"

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)
        def profesor = Profesor.get(params.profe)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontTitulo2 = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)
        fontNormalBold2.setColor(new BaseColor(30, 68, 177))
        fontTitulo2.setColor(BaseColor.LIGHT_GRAY)

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte encuesta");
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

        Paragraph parrafoProfesor = new Paragraph("PROFESOR: " + profesor?.apellido + " " + profesor?.nombre, fontTitulo)
        parrafoProfesor.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        def titulo = ''
        def ban = 0

        switch(params.tipo){
            case '1':
                titulo="Autoevaluación Docentes"
                ban = 1
                break;
            case '2':
                titulo="Evaluación de Desempeño Docente"
                ban = 1
                break;
            case '3':
                titulo="Evaluación Directivo a Docente"
                break;
            case '5':
                titulo="Evaluación de Pares"
                break;
        }


        Paragraph uso = new Paragraph("(SOLO PARA USO INTERNO)", fontTitulo2)
        uso.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoProfesor)
        document.add(uso)

        def sql

        if(ban == 1){
            sql =  "select encu__id, profapll||' '||profnmbr prof, matedscr, crsodscr, dctaprll from encu, prof, dcta, mate, crso where encuetdo = 'C' and encu.prof__id = ${profesor?.id} and prof.prof__id = encu.prof__id and teti__id = ${params.tipo} and dcta.dcta__id = encu.dcta__id and  mate.mate__id = dcta.mate__id and crso.crso__id = dcta.crso__id;"
        }else{
            sql = "select encu__id, profapll||' '||profnmbr prof from encu, prof where encuetdo = 'C' and encu.prof__id = ${profesor?.id} and prof.prof__id = encu.prof__id and teti__id = ${params.tipo};"
        }

//        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bg: new BaseColor(95, 113, 132)]
        def prmsIzBorder2 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder4 = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_CENTER,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder3 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder5 = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        def sql2
        def variable
        def sumatoria = 0
        def mate = ''
        def crso = ''
        def para = ''
        res.each {p->

            Paragraph lineaTitulo = new Paragraph(titulo, fontTitulo )
            lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

            Paragraph lineaEncuesta = new Paragraph("Encuesta N°: " + p?.encu__id, fontTitulo )
            lineaEncuesta.setAlignment(com.lowagie.text.Element.ALIGN_RIGHT);

            if(ban == 1){
                mate = p?.matedscr
                crso = p?.crsodscr
                para = p?.dctaprll
            }

            Paragraph lineaMateria = new Paragraph(mate + ": " + crso + " - " + para, fontTitulo )
            lineaMateria.setAlignment(com.lowagie.text.Element.ALIGN_RIGHT);

            document.add(lineaTitulo)
            document.add(lineaEncuesta)
            if(ban == 1){
                document.add(lineaMateria)
            }
            document.add(lineaVacia)

            sql2 = "select * from encuesta(${p?.encu__id}) ORDER BY vrbl__id;"
//            println("sql2  " + sql2)
            def res2 = cn2.rows(sql2.toString());

            res2.each {q->

                if(res2.first().nmro == q?.nmro){
                    PdfPTable tablaD = new PdfPTable(1);
                    tablaD.setWidthPercentage(100);
                    tablaD.setWidths(arregloEnteros([100]))
                    addCellTabla(tablaD, new Paragraph("Pregunta: " + q.preg, fontNormalBold), prmsIzBorder3)
                    document.add(tablaD);
                    PdfPTable tablaF = new PdfPTable(2);
                    tablaF.setWidthPercentage(100);
                    tablaF.setWidths(arregloEnteros([85, 15]))
                    addCellTabla(tablaF, new Paragraph("Respuesta: " + q.resp, fontThUsar), prmsIzBorder3)
                    addCellTabla(tablaF, new Paragraph("Valor: " + q.vlor, fontThUsar), prmsCrBorder)
                    document.add(tablaF);
                    sumatoria += q?.vlor
                }else{
                    if((q?.vrbldscr != variable)){

                        PdfPTable tablaT = new PdfPTable(2);
                        tablaT.setWidthPercentage(100);
                        tablaT.setWidths(arregloEnteros([85,15]))
                        addCellTabla(tablaT, new Paragraph("TOTAL VARIABLE: " + variable, fontNormalBold2), prmsIzBorder3)
                        addCellTabla(tablaT, new Paragraph(numero(sumatoria,2), fontNormalBold2), prmsIzBorder5)
                        document.add(tablaT);

                        sumatoria = 0
                    }

                    PdfPTable tablaD = new PdfPTable(1);
                    tablaD.setWidthPercentage(100);
                    tablaD.setWidths(arregloEnteros([100]))
                    addCellTabla(tablaD, new Paragraph("Pregunta: " + q.preg, fontNormalBold), prmsIzBorder3)
                    document.add(tablaD);
                    PdfPTable tablaF = new PdfPTable(2);
                    tablaF.setWidthPercentage(100);
                    tablaF.setWidths(arregloEnteros([85, 15]))
                    addCellTabla(tablaF, new Paragraph("Respuesta: " + q.resp, fontThUsar), prmsIzBorder3)
                    addCellTabla(tablaF, new Paragraph("Valor: " + q.vlor, fontThUsar), prmsCrBorder)
                    document.add(tablaF);
                    sumatoria += q.vlor

                    if( res2.last().nmro == q.nmro){

                        PdfPTable tablaT = new PdfPTable(2);
                        tablaT.setWidthPercentage(100);
                        tablaT.setWidths(arregloEnteros([85,15]))
                        addCellTabla(tablaT, new Paragraph("TOTAL VARIABLE: " + q.vrbldscr, fontNormalBold2), prmsIzBorder3)
                        addCellTabla(tablaT, new Paragraph(numero(sumatoria,2), fontNormalBold2), prmsIzBorder5)
                        document.add(tablaT);
                    }
                }
                variable = q?.vrbldscr
            }
        }

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'encuestaEvaluacionDesempeno')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def factores () {

        //        println "reporteClasificacion $params"

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontTitulo2 = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)
        fontNormalBold2.setColor(new BaseColor(30, 68, 177))
        fontTitulo2.setColor(BaseColor.LIGHT_GRAY)

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte encuesta factores");
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


//        def titulo = ''
//
//        switch(params.tipo){
//            case '1':
//                titulo="Autoevaluación Docentes"
//                break;
//            case '2':
//                titulo="Evaluación de Desempeño Docente"
//                break;
//            case '3':
//                titulo="Evaluación Directivo a Docente"
//                break;
//            case '5':
//                titulo="Evaluación de Pares"
//                break;
//        }


        Paragraph uso = new Paragraph("(SOLO PARA USO INTERNO)", fontTitulo2)
        uso.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(uso)

        /*todo: facultad!*/
        def sql = "select encu__id from encu where encuetdo = 'C' and teti__id = 4;"

//        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bg: new BaseColor(95, 113, 132)]
        def prmsIzBorder2 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder4 = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_CENTER,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder3 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder5 = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        def sql2
        def variable
        def sumatoria = 0

        res.each {p->

//            Paragraph lineaTitulo = new Paragraph(titulo, fontTitulo )
//            lineaTitulo.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);
//
            Paragraph lineaEncuesta = new Paragraph("Encuesta N°: " + p?.encu__id, fontTitulo )
            lineaEncuesta.setAlignment(com.lowagie.text.Element.ALIGN_RIGHT);
//
//            document.add(lineaTitulo)
            document.add(lineaEncuesta)
            document.add(lineaVacia)

            sql2 = "select * from encuesta(${p?.encu__id}) ORDER BY vrbl__id;"
//            println("sql2  " + sql2)
            def res2 = cn2.rows(sql2.toString());

            res2.each {q->

                if(res2.first().nmro == q?.nmro){
                    PdfPTable tablaD = new PdfPTable(1);
                    tablaD.setWidthPercentage(100);
                    tablaD.setWidths(arregloEnteros([100]))
                    addCellTabla(tablaD, new Paragraph("Pregunta: " + q.preg, fontNormalBold), prmsIzBorder3)
                    document.add(tablaD);
                    PdfPTable tablaF = new PdfPTable(2);
                    tablaF.setWidthPercentage(100);
                    tablaF.setWidths(arregloEnteros([85, 15]))
                    addCellTabla(tablaF, new Paragraph("Respuesta: " + q.resp, fontThUsar), prmsIzBorder3)
                    addCellTabla(tablaF, new Paragraph("Valor: " + q.vlor, fontThUsar), prmsCrBorder)
                    document.add(tablaF);
                    sumatoria += q?.vlor
                }else{
                    if((q?.vrbldscr != variable)){

                        PdfPTable tablaT = new PdfPTable(2);
                        tablaT.setWidthPercentage(100);
                        tablaT.setWidths(arregloEnteros([85,15]))
                        addCellTabla(tablaT, new Paragraph("TOTAL VARIABLE: " + variable, fontNormalBold2), prmsIzBorder3)
                        addCellTabla(tablaT, new Paragraph(numero(sumatoria,2), fontNormalBold2), prmsIzBorder5)
                        document.add(tablaT);

                        sumatoria = 0
                    }

                    PdfPTable tablaD = new PdfPTable(1);
                    tablaD.setWidthPercentage(100);
                    tablaD.setWidths(arregloEnteros([100]))
                    addCellTabla(tablaD, new Paragraph("Pregunta: " + q.preg, fontNormalBold), prmsIzBorder3)
                    document.add(tablaD);
                    PdfPTable tablaF = new PdfPTable(2);
                    tablaF.setWidthPercentage(100);
                    tablaF.setWidths(arregloEnteros([85, 15]))
                    addCellTabla(tablaF, new Paragraph("Respuesta: " + q.resp, fontThUsar), prmsIzBorder3)
                    addCellTabla(tablaF, new Paragraph("Valor: " + q.vlor, fontThUsar), prmsCrBorder)
                    document.add(tablaF);
                    sumatoria += q.vlor

                    if( res2.last().nmro == q.nmro){

                        PdfPTable tablaT = new PdfPTable(2);
                        tablaT.setWidthPercentage(100);
                        tablaT.setWidths(arregloEnteros([85,15]))
                        addCellTabla(tablaT, new Paragraph("TOTAL VARIABLE: " + q.vrbldscr, fontNormalBold2), prmsIzBorder3)
                        addCellTabla(tablaT, new Paragraph(numero(sumatoria,2), fontNormalBold2), prmsIzBorder5)
                        document.add(tablaT);
                    }
                }
                variable = q?.vrbldscr
            }
        }

        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'encuestaFactoresExito')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)

    }

    def cargarDatos (){

    }



    def evaluacionesProfe () {

        //        println "reporteClasificacion $params"

        def periodo = Periodo.get(params.periodo)
        def facultad = Facultad.get(params.facultad)

        def baos = new ByteArrayOutputStream()
        Font fontTitulo = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontTitulo2 = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font fontThUsar = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.NORMAL);
        Font fontNormalBold = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold2 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);
        Font fontNormalBold3 = new Font(Font.FontFamily.TIMES_ROMAN, 10, Font.BOLD);

        fontNormalBold.setColor(new BaseColor(70, 88, 107))
        fontNormalBold3.setColor(BaseColor.WHITE)
        fontNormalBold2.setColor(new BaseColor(30, 68, 177))
        fontTitulo2.setColor(BaseColor.LIGHT_GRAY)

        Document document
        document = new Document(PageSize.A4);
        def pdfw = PdfWriter.getInstance(document, baos);

        document.open();
        PdfContentByte cb = pdfw.getDirectContent();
        document.addTitle("Reporte evaluaciones de profesores");
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

        Paragraph parrafoEva = new Paragraph("EVALUACIONES AL PROFESOR", fontTitulo)
        parrafoEva.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph uso = new Paragraph("(SOLO PARA USO INTERNO)", fontTitulo2)
        uso.setAlignment(com.lowagie.text.Element.ALIGN_CENTER);

        Paragraph lineaVacia = new Paragraph(" ", fontTitulo)

        document.add(parrafoUniversidad)
        document.add(parrafoFacultad)
        document.add(parrafoEva)
        document.add(uso)
        document.add(lineaVacia)


        def sql = "select * from evaluaciones(${facultad?.id},${periodo?.id});"

//        println("---> " + sql)

        def cn = dbConnectionService.getConnection()
        def cn2 = dbConnectionService.getConnection()
        def res = cn.rows(sql.toString());

        def prmsTdNoBorder = [border: BaseColor.WHITE, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE, bg: new BaseColor(95, 113, 132)]
        def prmsIzBorder2 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder4 = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_CENTER,bg: BaseColor.LIGHT_GRAY]
        def prmsIzBorder3 = [border: BaseColor.BLACK, align: Element.ALIGN_LEFT, valign: Element.ALIGN_MIDDLE]
        def prmsIzBorder5 = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]
        def prmsNmBorder = [border: BaseColor.BLACK, align: Element.ALIGN_RIGHT, valign: Element.ALIGN_MIDDLE]
        def prmsCrBorder = [border: BaseColor.BLACK, align: Element.ALIGN_CENTER, valign: Element.ALIGN_MIDDLE]

        def sql2
        def variable
        def sumatoria = 0

        PdfPTable tablaD = new PdfPTable(6);
        tablaD.setWidthPercentage(100);
        tablaD.setWidths(arregloEnteros([50,10,10,10,10,10]))

        addCellTabla(tablaD, new Paragraph("Profesor", fontTitulo), prmsIzBorder4)
        addCellTabla(tablaD, new Paragraph("Estu.", fontTitulo), prmsIzBorder4)
        addCellTabla(tablaD, new Paragraph("Auto.", fontTitulo), prmsIzBorder4)
        addCellTabla(tablaD, new Paragraph("Pares.", fontTitulo), prmsIzBorder4)
        addCellTabla(tablaD, new Paragraph("Dire.", fontTitulo), prmsIzBorder4)
        addCellTabla(tablaD, new Paragraph("Total", fontTitulo), prmsIzBorder4)

        res.each {p->

            addCellTabla(tablaD, new Paragraph(p?.prof, fontThUsar), prmsIzBorder3)
            addCellTabla(tablaD, new Paragraph(numero(p?.estd_ev,2), fontThUsar), prmsCrBorder)
            addCellTabla(tablaD, new Paragraph(numero(p?.auto_ev,2), fontThUsar), prmsCrBorder)
            addCellTabla(tablaD, new Paragraph(numero(p?.pars_ev,2), fontThUsar), prmsCrBorder)
            addCellTabla(tablaD, new Paragraph(numero(p?.dire_ev,2), fontThUsar), prmsCrBorder)
            addCellTabla(tablaD, new Paragraph(numero(p?.totl_ev,2), fontThUsar), prmsCrBorder)

        }

        document.add(tablaD)
        document.close();
        pdfw.close()
        byte[] b = baos.toByteArray();
        response.setContentType("application/pdf")
        response.setHeader("Content-disposition", "attachment; filename=" + 'evaluacionesPorProfesor')
        response.setContentLength(b.length)
        response.getOutputStream().write(b)
    }

}
