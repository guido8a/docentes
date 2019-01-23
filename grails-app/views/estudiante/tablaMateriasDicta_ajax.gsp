<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 21/01/19
  Time: 15:30
--%>

<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/09/16
  Time: 11:42
--%>

<g:if test="${materias}">
    <div class="row-fluid"  style="width: 99.7%;height: 350px;overflow-y: auto;float: right; margin-top: -15px">
        <div class="span12">
            <div style="width: 100%; height: 350px;">
                <table class="table table-condensed table-bordered table-striped" style="font-size: 11px">
                    <tbody>
                    <g:each in="${materias}" var="materia">
                        <tr data-id="${materia.id}">
                            <td style="width: 7%">${materia?.materia?.codigo}</td>
                            <td style="width: 31%">${materia?.materia?.nombre}</td>
                            <td style="width: 6%">${materia?.curso?.nombre}</td>
                            <td style="width: 6%">${materia?.paralelo}</td>
                            <td style="width: 20%">${materia?.profesor?.nombre + " " + materia?.profesor?.apellido}</td>
                            <td style="width: 12%">${materia?.escuela?.nombre}</td>
                            <td style="width: 5%"><a href="#" class="btn btn-success btnAgregarMateria" data-id="${materia.id}" data-nombre="${materia?.materia?.nombre}" data-cod="${materia?.materia?.codigo}"  title="Agregar materia al alumno">
                                <i class="fa fa-check"></i>
                            </a></td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</g:if>
<g:else>
    <div class="row-fluid"  style="width: 99.7%;height: 350px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 100%; height: 350px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <tr>
                        <td style="width: 100%"><div class="text-info text-center not-found"><i class="fa-2x pull-center text-shadow">No existen registros.</i></div></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</g:else>

<script type="text/javascript">

    $(".btnAgregarMateria").click(function () {
        var id = $(this).data("id")    ;
        var nombre = $(this).data("cod") + " - " + $(this).data("nombre");
        $("#materiaId").val(id);
        $("#materiasEstudiante").val(nombre);
        $("#materiasEstudiante").attr("title",nombre);
        bootbox.hideAll();
    });

</script>

