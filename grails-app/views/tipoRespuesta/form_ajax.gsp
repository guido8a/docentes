<%@ page import="docentes.TipoRespuesta" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoRespuestaInstance}">
    <elm:notFound elem="TipoRespuesta" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmTipoRespuesta" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${tipoRespuestaInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: tipoRespuestaInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <div class="col-md-2">
                    <g:textField name="codigo" required="" class="allCaps form-control required" value="${tipoRespuestaInstance?.codigo}" maxlength="1"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: tipoRespuestaInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" maxlength="12" required="" class="allCaps form-control required" value="${tipoRespuestaInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmTipoRespuesta").validate({
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