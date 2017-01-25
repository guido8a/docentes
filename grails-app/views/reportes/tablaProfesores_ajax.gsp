<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 16/01/17
  Time: 12:49
--%>

<div class="row-fluid"  style="width: 99.7%;height: 300px;overflow-y: auto;float: right;">
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
                                <a href="#" class="btn btn-info btnAlumnos"
                                    ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,alumnos,periodo)?.promedio > 0 ? '' : 'disabled='}
                                   data-id="${profesor.id}" data-tipo="1" title="Evaluación Alumnos">
                                    <i class="fa fa-dashboard"></i>
                                </a>
                                <a href="#" class="btn btn-info btnAlumnos"
                                    ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,auto,periodo)?.promedio > 0 ? '' : 'disabled='}
                                   data-id="${profesor.id}" data-tipo="2"  title="Auto Evaluación">
                                    <i class="fa fa-car"></i>
                                </a>
                                <a href="#" class="btn btn-info btnAlumnos"
                                    ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,directivos,periodo)?.promedio > 0 ? '' : 'disabled='}
                                   data-id="${profesor.id}" data-tipo="3" title="Evaluación Directivos">
                                    <i class="fa fa-star"></i>
                                </a>
                                <a href="#" class="btn btn-info btnAlumnos"
                                    ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,pares,periodo)?.promedio > 0 ? '' : 'disabled='}
                                   data-id="${profesor.id}" data-tipo="4" title="Evaluación Pares">
                                    <i class="fa fa-cubes"></i>
                                </a>
                                <a href="#" class="btn btn-info btnAlumnos"
                                   data-id="${profesor.id}" data-tipo="5"
                                    ${docentes.ReporteEncuesta.findByProfesorAndPeriodoAndTipoEncuesta(profesor,periodo, total) ? '' : 'disabled='}  title="Promedio General">
                                    <i class="fa fa-pie-chart"></i>
                                </a>
                            </g:if>
                            <g:else>
                                <a href="#" class="btn btn-warning btnRecomendaciones"
                                   data-id="${profesor.id}" ${existe[j] == '1' ? '' : 'disabled='}  title="Recomendaciones">
                                    <i class="fa fa-star"></i>
                                </a>
                            </g:else>
                        </td>
                    </tr>
                </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    $(".btnAlumnos").click(function () {
        var idProfe = $(this).data('id');
        var perio = ${periodo?.id};
        var tipo = $(this).data('tipo');
        location.href="${createLink(controller: 'reportes', action: 'desempenoAlumnos')}?profe=" + idProfe + "&periodo=" + perio + "&tipo=" + tipo
    });

    $(".btnRecomendaciones").click(function () {
        var idProfe = $(this).data('id');
        var periodo = ${periodo?.id};
        var facul = ${facultad?.id};
        location.href="${createLink(controller: 'reportes2', action: 'recomendaciones')}?profe=" + idProfe + "&periodo=" + periodo + "&facultad=" + facul
    });


</script>