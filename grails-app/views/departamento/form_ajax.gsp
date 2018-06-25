<%@ page import="seguridad.Departamento" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!departamentoInstance}">
    <elm:notFound elem="Departamento" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmDepartamento" role="form" action="save_ajax" method="POST">
        <g:hiddenField name="id" value="${departamentoInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'padre', 'error')} ">
            <span class="grupo">
                <label for="padre" class="col-md-2 control-label text-info">
                    Padre
                </label>
                <div class="col-md-6">
                    <g:select id="padre" name="padre.id" from="${seguridad.Departamento.list()}" optionKey="id" value="${departamentoInstance?.padre?.id}" class="many-to-one form-control" noSelection="['null': '']"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="15" required="" class="allCaps form-control required" value="${departamentoInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <div class="col-md-6">
                    <g:textField name="nombre" maxlength="127" required="" class="form-control required" value="${departamentoInstance?.nombre}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'telefono', 'error')} ">
            <span class="grupo">
                <label for="telefono" class="col-md-2 control-label text-info">
                    Teléfono
                </label>
                <div class="col-md-6">
                    <g:textField name="telefono" maxlength="62" class="allCaps number form-control" value="${departamentoInstance?.telefono}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'extension', 'error')} ">
            <span class="grupo">
                <label for="extension" class="col-md-2 control-label text-info">
                    Extensión
                </label>
                <div class="col-md-3">
                    <g:textField name="extension" maxlength="7" class="allCaps number form-control" value="${departamentoInstance?.extension}"/>
                </div>
                
            </span>
        </div>
        %{----}%
        %{--<div class="form-group ${hasErrors(bean: departamentoInstance, field: 'direccion', 'error')} ">--}%
            %{--<span class="grupo">--}%
                %{--<label for="direccion" class="col-md-2 control-label text-info">--}%
                    %{--Direccion--}%
                %{--</label>--}%
                %{--<div class="col-md-6">--}%
                    %{--<g:textArea name="direccion" cols="40" rows="5" maxlength="255" class="allCaps form-control" value="${departamentoInstance?.direccion}"/>--}%
                %{--</div>--}%
                %{----}%
            %{--</span>--}%
        %{--</div>--}%
        %{----}%
        %{--<div class="form-group ${hasErrors(bean: departamentoInstance, field: 'estado', 'error')} ">--}%
            %{--<span class="grupo">--}%
                %{--<label for="estado" class="col-md-2 control-label text-info">--}%
                    %{--Estado--}%
                %{--</label>--}%
                %{--<div class="col-md-6">--}%
                    %{--<g:textField name="estado" maxlength="1" class="allCaps form-control" value="${departamentoInstance?.estado}"/>--}%
                %{--</div>--}%
                %{----}%
            %{--</span>--}%
        %{--</div>--}%
        
        <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'activo', 'error')} ">
            <span class="grupo">
                <label for="activo" class="col-md-2 control-label text-info">
                    Activo
                </label>
                <div class="col-md-2">
                    %{--<g:field name="activo" type="number" value="${departamentoInstance.activo}" class="digits form-control required" required="" />--}%
                    <g:select name="activo" from="${['SI','NO']}" class="form-control required" value="${departamentoInstance?.activo == 1 ? 'SI' : 'NO'}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: departamentoInstance, field: 'orden', 'error')} ">
            <span class="grupo">
                <label for="orden" class="col-md-2 control-label text-info">
                    Orden
                </label>
                <div class="col-md-2">
                    %{--<g:field name="orden" type="number" value="${departamentoInstance.orden}" class="digits form-control required" required=""/>--}%
                    <g:textField name="orden" value="${departamentoInstance?.orden}" class="number form-control required" maxlength="2"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmDepartamento").validate({
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