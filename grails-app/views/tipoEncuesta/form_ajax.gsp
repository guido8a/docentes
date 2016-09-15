<%@ page import="docentes.TipoEncuesta" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!tipoEncuestaInstance}">
    <elm:notFound elem="TipoEncuesta" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmTipoEncuesta" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${tipoEncuestaInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: tipoEncuestaInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" required="" class="allCaps form-control required" value="${tipoEncuestaInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: tipoEncuestaInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <div class="col-md-6">
                    <g:textField name="descripcion" required="" class="allCaps form-control required" value="${tipoEncuestaInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: tipoEncuestaInstance, field: 'estado', 'error')} ">
            <span class="grupo">
                <label for="estado" class="col-md-2 control-label text-info">
                    Estado
                </label>
                <div class="col-md-6">
                    <g:select name="estado" from="${tipoEncuestaInstance.constraints.estado.inList}" class="form-control" value="${tipoEncuestaInstance?.estado}" valueMessagePrefix="tipoEncuesta.estado"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmTipoEncuesta").validate({
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