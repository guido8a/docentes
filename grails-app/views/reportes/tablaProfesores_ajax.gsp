<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/01/17
  Time: 12:49
--%>

<div class="row-fluid" style="width: 99.7%;height: 300px;overflow-y: auto;float: right;">
    <div class="span12">
        <div style="width: 1060px; height: 300px;">
            <table class="table table-condensed table-bordered table-striped">
                <tbody>
                <g:each in="${profesores}" var="profesor" status="j">
                    <tr data-id="${profesor.id}">
                        <td style="width: 5%">${profesor?.cedula}</td>
                        <td style="width: 18%">${profesor?.nombre}</td>
                        <td style="width: 17%">${profesor?.apellido}</td>
                        <td style="width: 5%">${profesor?.titulo}</td>
                        <td style="width: 20%; text-align: center">
                            <g:if test="${pantalla == '1'}">
                                <button class="btn btn-info btnAlumnos" type="button"
                                    ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor, alumnos, periodo)?.promedio > 0 ? '' : 'disabled'}
                                        data-id="${profesor.id}" data-tipo="1" title="Evaluación Alumnos">
                                    <i class="fa fa-bell-o"></i>
                                </button>
                                <button class="btn btn-info btnAlumnos" type="button"
                                    ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor, auto, periodo)?.promedio > 0 ? '' : 'disabled'}
                                        data-id="${profesor.id}" data-tipo="2" title="Auto Evaluación">
                                    <i class="fa fa-bell-slash-o"></i>
                                </button>
                                <button class="btn btn-info btnAlumnos" type="button"
                                    ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor, directivos, periodo)?.promedio > 0 ? '' : 'disabled'}
                                        data-id="${profesor.id}" data-tipo="3" title="Evaluación Directivos">
                                    <i class="fa fa-user"></i>
                                </button>
                                <button class="btn btn-info btnAlumnos" type="button"
                                    ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor, pares, periodo)?.promedio > 0 ? '' : 'disabled'}
                                        data-id="${profesor.id}" data-tipo="4" title="Evaluación Pares">
                                    <i class="fa fa-male"></i>
                                </button>
                                <button class="btn btn-info btnAlumnos" type="button"
                                        data-id="${profesor.id}" data-tipo="5"
                                    ${docentes.ReporteEncuesta.findByProfesorAndPeriodoAndTipoEncuesta(profesor, periodo, total) ? '' : 'disabled'}
                                        title="Promedio General">
                                    <i class="fa fa-star-o"></i>
                                </button>
                            </g:if>
                            <g:elseif test="${pantalla == '2'}">
                                <button class="btn btn-warning btnRecomendaciones" data-id="${profesor.id}"
                                        type="button"
                                    ${docentes.ReporteEncuesta.findByProfesorAndPeriodoAndRecomendacionGreaterThan(profesor, periodo, 0) ? '' : 'disabled'}>
                                    <i class="fa fa-star" title="Recomendaciones"></i></button>

                            </g:elseif>
                            <g:else>
                                <a href="#" class="btn btn-success btnEncuestaDC"
                                   data-id="${profesor.id}" title="Evaluación de Desempeño Docente">
                                    <i class="fa fa-bell-o"></i>
                                </a>
                                <a href="#" class="btn btn-success btnEncuestaAD"
                                   data-id="${profesor.id}" title="Autoevaluación Docentes">
                                    <i class="fa fa-bell-slash-o"></i>
                                </a>
                                <a href="#" class="btn btn-success btnEncuestaDI"
                                   data-id="${profesor.id}" title="Evaluación Directivo a Docente">
                                    <i class="fa fa-user"></i>
                                </a>
                                <a href="#" class="btn btn-success btnEncuestaPR"
                                   data-id="${profesor.id}" title="Evaluación de Pares">
                                    <i class="fa fa-male"></i>
                                </a>
                            </g:else>
                            <g:if test="${pantalla == '1'}">
                                <a href="#" class="btn btn-success btnIM"  data-id="${profesor.id}" data-nom="${profesor?.apellido + " " + profesor?.nombre}" title="Enviar por correo al profesor">
                                    <i class="fa fa-envelope"></i>
                                </a>
                            </g:if>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(".btnIM").click(function () {
        var idProfe = $(this).data('id');
        var nomProfe = $(this).data('nom');
        var perio = ${periodo?.id};

        bootbox.confirm("<i class='fa fa-exclamation-triangle fa-3x text-danger text-shadow'></i> Está seguro de enviar este reporte al profesor " + "<b style='color: rgba(63,113,186,0.9)'>" + nomProfe + "</b>" + "?", function (result) {
            if (result) {
                %{--location.href = "${createLink(controller: 'reportes', action: 'reporteEnviarProfesores')}?profesor=" + idProfe + "&periodo=" + perio--}%

                openLoader("Enviando...");
                $.ajax({
                    type: 'POST',
                    url: "${createLink(controller: 'reportes', action: 'reporteEnviarProfesores')}",
                    data:{
                        profesor: idProfe,
                        periodo: perio
                    },
                    success: function (msg){
                        closeLoader();
                        var parts = msg.split("_");
                        if(parts[0] == 'ok'){
                            log("Email enviado correctamente", "success")
                        }else{
                            log(parts[1], "error")
                        }
                    }
                });



            }
        });
    });

    $(".btnAlumnos").click(function () {
        var idProfe = $(this).data('id');
        var perio = ${periodo?.id};
        var tipo = $(this).data('tipo');
        location.href = "${createLink(controller: 'reportes', action: 'desempenoAlumnos')}?profe=" + idProfe + "&periodo=" + perio + "&tipo=" + tipo
    });

    $(".btnRecomendaciones").click(function () {
        var idProfe = $(this).data('id');
        var periodo = ${periodo?.id};
        var facul = ${facultad?.id};
        location.href = "${createLink(controller: 'reportes2', action: 'recomendaciones')}?profe=" + idProfe + "&periodo=" + periodo + "&facultad=" + facul
    });

    $(".btnEncuestaDC").click(function () {
        var idProfe = $(this).data('id');
        var periodo = ${periodo?.id};
        var facul = ${facultad?.id};
        location.href = "${createLink(controller: 'reportes2', action: 'encuesta')}?profe=" + idProfe + "&periodo=" + periodo + "&facultad=" + facul + "&tipo=" + 2
    });

    $(".btnEncuestaDI").click(function () {
        var idProfe = $(this).data('id');
        var periodo = ${periodo?.id};
        var facul = ${facultad?.id};
        location.href = "${createLink(controller: 'reportes2', action: 'encuesta')}?profe=" + idProfe + "&periodo=" + periodo + "&facultad=" + facul + "&tipo=" + 3
    });

    $(".btnEncuestaPR").click(function () {
        var idProfe = $(this).data('id');
        var periodo = ${periodo?.id};
        var facul = ${facultad?.id};
        location.href = "${createLink(controller: 'reportes2', action: 'encuesta')}?profe=" + idProfe + "&periodo=" + periodo + "&facultad=" + facul + "&tipo=" + 5
    });

    $(".btnEncuestaAD").click(function () {
        var idProfe = $(this).data('id');
        var periodo = ${periodo?.id};
        var facul = ${facultad?.id};
        location.href = "${createLink(controller: 'reportes2', action: 'encuesta')}?profe=" + idProfe + "&periodo=" + periodo + "&facultad=" + facul + "&tipo=" + 1
    });

    $("#btnMail").click(function () {

    });




</script>