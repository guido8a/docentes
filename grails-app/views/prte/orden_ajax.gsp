<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 23/09/16
  Time: 12:24
--%>

<g:form class="form-horizontal" name="frmOrden" role="form" action="save" method="POST">
    <div class="row">
        <div class="col-md-1 negrilla control-label">Código : </div>
        <div class="col-md-2">
            <g:textField name="codigoE_name" id="codigoE" class="form-control" value="${pregunta?.codigo}" readonly="true"/>
        </div>

        <div class="col-md-1 negrilla control-label">Pregunta: </div>
        <div class="col-md-6">
            <g:textField name="preguntaE_name" id="preguntaE" class="form-control" value="${pregunta?.descripcion}" readonly="true" title="${pregunta?.descripcion}"/>
        </div>

        <div class="col-md-1 negrilla control-label">Orden: </div>
        <div class="col-md-1">
            <g:textField name="ordenE_name" id="ordenE" class="form-control required number" maxlength="4" value=""/>
        </div>
    </div>
</g:form>


<script type="text/javascript">
    var validator = $("#frmOrden").validate({
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
</script>