<%@ page import="docentes.Recomendacion" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!recomendacionInstance}">
    <elm:notFound elem="Recomendacion" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmRecomendacion" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${recomendacionInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: recomendacionInstance, field: 'descripcion', 'error')} ">
            <span class="grupo">
                <label for="descripcion" class="col-md-2 control-label text-info">
                    Descripcion
                </label>
                <div class="col-md-6">
                    <g:textArea name="descripcion" cols="40" rows="5" maxlength="255" required="" class="allCaps form-control required" value="${recomendacionInstance?.descripcion}"/>
                </div>
                
            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmRecomendacion").validate({
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