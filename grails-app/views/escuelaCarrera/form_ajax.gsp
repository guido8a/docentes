<%@ page import="docentes.EscuelaCarrera" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!escuelaCarreraInstance}">
    <elm:notFound elem="EscuelaCarrera" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmEscuelaCarrera" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${escuelaCarreraInstance?.id}" />

        <g:if test="${session.perfil.codigo == 'ADMG'}">
            <label class="col-md-2">Universidad:</label>
            <div class="col-md-12">
                <g:select name="universidadF_name" id="universidadIdF" optionKey="id" optionValue="nombre"
                          class="form-control" from="${docentes.Universidad.findAllByNombreNotEqual("Todas",[sort: 'nombre', order: 'asc'])}" value="${escuelaCarreraInstance?.escuela?.facultad?.universidad?.id}"/>
            </div>
        </g:if>
        <g:else>

            <label class="col-md-2">Universidad:</label>
            <div class="col-md-12">
                <g:select name="universidadF_name" id="universidadIdF" optionKey="id" optionValue="nombre"
                          class="form-control"
                          from="${(seguridad.Persona.get(session.usuario.id).universidad)}" value="${escuelaCarreraInstance?.escuela?.facultad?.universidad?.id}"/>
            </div>
        </g:else>

        <label class="col-md-2" style="margin-top: 10px; margin-left: 20px">Facultad:</label>

        <div class="col-md-12" id="divFacultadForm">

        </div>

        <label class="col-md-2" style="margin-top: 10px; margin-left: 20px">Escuela:</label>

        <div class="col-md-12" id="divEscuelaForm">

        </div>

    %{--<div class="form-group ${hasErrors(bean: escuelaCarreraInstance, field: 'escuela', 'error')} ">--}%
    %{--<span class="grupo">--}%
    %{--<label for="escuela" class="col-md-2 control-label text-info">--}%
    %{--Escuela--}%
    %{--</label>--}%
    %{--<div class="col-md-10">--}%
    %{--<g:select id="escuela" name="escuela.id" from="${docentes.Escuela.list()}" optionKey="id"--}%
    %{--optionValue="nombre" required="" value="${escuelaCarreraInstance?.escuela?.id}" class="many-to-one form-control"/>--}%
    %{--</div>--}%
    %{----}%
    %{--</span>--}%
    %{--</div>--}%

        <div class="form-group ${hasErrors(bean: escuelaCarreraInstance, field: 'carrera', 'error')} ">
            <span class="grupo">
                <label class="col-md-2 text-info" style="margin-top: 10px; margin-left: 20px">Carrera:</label>
                <div class="col-md-12">
                    <g:select id="carrera" name="carrera.id" from="${docentes.Carrera.list()}" optionKey="id"
                              optionValue="descripcion" required="" value="${escuelaCarreraInstance?.carrera?.id}" class="form-control" style="width: 530px; margin-left: 15px"/>
                </div>

            </span>
        </div>
    </g:form>

    <script type="text/javascript">


        cargarFacultadF($("#universidadIdF").val(), '${escuelaCarreraInstance?.id}');

        $("#universidadIdF").change(function () {
            var id = $("#universidadIdF option:selected").val();
            cargarFacultadF(id, null);
        });


        function cargarFacultadF (id, escXCarr) {
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'escuelaCarrera', action: 'facultad_ajax')}',
                data:{
                    universidad: id,
                    xCarr: escXCarr
                },
                success: function (msg){
                    $("#divFacultadForm").html(msg)
                }
            });
        }


        var validator = $("#frmEscuelaCarrera").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
            }
        });
        $(".form-control").keydown(function (ev) {
            if (ev.keyCode == 13) {
                submitForm();
                return false;
            }
            return true;
        });
    </script>

</g:else>