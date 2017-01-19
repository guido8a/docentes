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
                <g:each in="${profesores}" var="profesor">
                    <tr data-id="${profesor.id}">
                        <td style="width: 5%">${profesor?.cedula}</td>
                        <td style="width: 18%">${profesor?.nombre}</td>
                        <td style="width: 17%">${profesor?.apellido}</td>
                        <td style="width: 5%">${profesor?.titulo}</td>
                        <td style="width: 20%; text-align: center">
                            <a href="#" class="btn btn-info btnAlumnos"
                                ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,alumnos,periodo)?.promedio > 0 ? '' : 'disabled='}
                               data-id="${profesor.id}"  title="Evaluación Alumnos">
                                <i class="fa fa-dashboard"></i>
                            </a>
                            <a href="#" class="btn btn-info btnAuto"
                                ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,auto,periodo)?.promedio > 0 ? '' : 'disabled='}
                               data-id="${profesor.id}"  title="Auto Evaluación">
                                <i class="fa fa-car"></i>
                            </a>
                            <a href="#" class="btn btn-info btnDirectivos"
                                ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,directivos,periodo)?.promedio > 0 ? '' : 'disabled='}
                               data-id="${profesor.id}"  title="Evaluación Directivos">
                                <i class="fa fa-star"></i>
                            </a>
                            <a href="#" class="btn btn-info btnPares"
                                ${docentes.ReporteEncuesta.findByProfesorAndTipoEncuestaAndPeriodo(profesor,pares,periodo)?.promedio > 0 ? '' : 'disabled='}
                               data-id="${profesor.id}"  title="Evaluación Pares">
                                <i class="fa fa-cubes"></i>
                            </a>
                            <a href="#" class="btn btn-info btnPromedio"
                               data-id="${profesor.id}"
                                ${docentes.ReporteEncuesta.findAllByProfesorAndPeriodo(profesor,periodo)?.size() == 4 ? '' : 'disabled='}  title="Promedio General">
                                <i class="fa fa-pie-chart"></i>
                            </a>
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
         location.href="${createLink(controller: 'reportes', action: 'desempenoAlumnos')}?profe=" + idProfe + "&periodo=" + perio
    });


</script>