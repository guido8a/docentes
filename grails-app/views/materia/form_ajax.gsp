<%@ page import="docentes.Materia" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!materiaInstance}">
    <elm:notFound elem="Materia" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmMateria" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${materiaInstance?.id}" />

        %{--<div class="form-group ${hasErrors(bean: materiaInstance, field: 'escuela', 'error')} ">--}%
            %{--<span class="grupo">--}%
                %{--<label class="col-md-2 control-label text-info">--}%
                    %{--Escuela--}%
                %{--</label>--}%
                %{--<div class="col-md-10">--}%
                    %{--<g:select id="escuela" name="escuela.id" from="${docentes.Escuela.list()}" optionKey="id" required="" value="${materiaInstance?.escuela?.id}" class="many-to-one form-control"/>--}%
                    %{--<g:hiddenField name="escuela.id" value="${escuela?.id} "/>--}%
                    %{--<g:textField name="escuelaTexto" value="${escuela?.nombre}" class="many-to-one form-control" readonly=""/>--}%
                %{--</div>--}%

            %{--</span>--}%
        %{--</div>--}%



        <div class="form-group ${hasErrors(bean: materiaInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <div class="col-md-3">
                    <g:textField name="codigo" maxlength="16" required="" class="allCaps form-control required" value="${materiaInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: materiaInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <div class="col-md-10">
                    <g:textField name="nombre" maxlength="127" required="" class="form-control required" value="${materiaInstance?.nombre}"/>
                </div>
                
            </span>
        </div>
        
        %{--<div class="form-group ${hasErrors(bean: materiaInstance, field: 'escuela', 'error')} ">--}%
            %{--<span class="grupo">--}%
                %{--<label for="escuela" class="col-md-2 control-label text-info">--}%
                    %{--Escuela--}%
                %{--</label>--}%
                %{--<div class="col-md-6">--}%
                    %{--<g:select id="escuela" name="escuela.id" from="${docentes.Escuela.list()}" optionKey="id" required="" value="${materiaInstance?.escuela?.id}" class="many-to-one form-control"/>--}%
                %{--</div>--}%
                %{----}%
            %{--</span>--}%
        %{--</div>--}%
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmMateria").validate({
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