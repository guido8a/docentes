<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 02/09/16
  Time: 12:51
--%>

<g:if test="${materias}">
    <div class="row-fluid"  style="width: 99.7%;height: 285px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 100%; height: 400px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <g:each in="${materias}" var="materia">
                        <tr data-id="${materia.id}">
                            <td style="width: 23%">${materia?.codigo}</td>
                            <td style="width: 66%">${materia?.nombre}</td>
                            <td style="width: 11%; text-align: center">
                                <a href="#" class="btn btn-success btnSeleccionar" data-id="${materia?.id}" data-nombre="${materia?.nombre}" data-cod="${materia?.codigo}">
                                    <i class="fa fa-check"></i>
                                </a>

                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="panel panel-info col-md-12" style="margin-top: 10px" >
        <div class="panel-heading">
            * Máxima cantidad de registros en pantalla 20
        </div>
    </div>
</g:if>
<g:else>
    <div class="row-fluid"  style="width: 99.7%;height: 200px;overflow-y: auto;float: right;">
        <div class="span12">
            <div style="width: 100%; height: 100px;">
                <table class="table table-condensed table-bordered table-striped">
                    <tbody>
                    <tr>
                        <td style="width: 100%"><div class="text-info text-center not-found"><i class="fa-2x pull-center text-shadow fa fa-close"> No existen registros.</i></div></td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</g:else>

<script type="text/javascript">

    $(".btnSeleccionar").click(function () {
        var id = $(this).data("id");
        var nombre = $(this).data("cod") + " - " + $(this).data("nombre");
        $("#materiaId").val(id);
        $("#materiasProfesor").val(nombre);
        $("#materiasProfesor").attr("title",nombre);
        bootbox.hideAll()
    });

</script>