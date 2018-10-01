<%@ page import="docentes.Indicador" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!indicadorInstance}">
    <elm:notFound elem="Indicador" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmIndicador" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${indicadorInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: indicadorInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <div class="col-md-6">
                    <g:textField name="codigo" maxlength="15" required="" class="allCaps form-control required" value="${indicadorInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: indicadorInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripción
                </label>
                <div class="col-md-6">
                    <g:textArea name="descripcion" cols="40" rows="5" style="resize: none; width: 400px; height: 100px" maxlength="255" required="" class="form-control required" value="${indicadorInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: indicadorInstance, field: 'estandar', 'error')} ">
            <span class="grupo">
                <label for="estandar" class="col-md-2 control-label text-info">
                    Estandar
                </label>
                <div class="col-md-6">
                    <g:select id="estandar" name="estandar.id" from="${docentes.Estandar.list()}" optionKey="id" optionValue="codigo" required="" value="${indicadorInstance?.estandar?.id}" class="many-to-one form-control"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: indicadorInstance, field: 'variables', 'error')} ">
            <span class="grupo">
                <label for="variables" class="col-md-2 control-label text-info">
                    Variables
                </label>
                <div class="col-md-8">
                    <g:select id="variables" name="variables.id" from="${docentes.Variables.list()}" optionKey="id" optionValue="descripcion" required="" value="${indicadorInstance?.variables?.id}" class="many-to-one form-control"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmIndicador").validate({
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