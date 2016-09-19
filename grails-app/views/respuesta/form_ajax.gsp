<%@ page import="docentes.Respuesta" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!respuestaInstance}">
    <elm:notFound elem="Respuesta" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmRespuesta" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${respuestaInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: respuestaInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Codigo
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="3" required="" class="allCaps form-control required" value="${respuestaInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: respuestaInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" maxlength="20" required="" class="allCaps form-control required" value="${respuestaInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: respuestaInstance, field: 'valor', 'error')} ">
            <span class="grupo">
                <label for="valor" class="col-md-2 control-label text-info">
                    Valor
                </label>
                <div class="col-md-6">
                    <g:field name="valor" type="number" value="${fieldValue(bean: respuestaInstance, field: 'valor')}" class="number form-control  required" required=""/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmRespuesta").validate({
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