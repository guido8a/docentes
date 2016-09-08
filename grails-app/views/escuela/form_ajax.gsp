<%@ page import="docentes.Escuela" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!escuelaInstance}">
    <elm:notFound elem="Escuela" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmEscuela" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${escuelaInstance?.id}" />


        <div class="form-group ${hasErrors(bean: escuelaInstance, field: 'facultad', 'error')} ">
            <span class="grupo">
                <label for="facultad" class="col-md-2 control-label text-info">
                    Facultad
                </label>
                <div class="col-md-10">
                    <g:select id="facultad" name="facultad.id" from="${docentes.Facultad.list()}" optionKey="id" optionValue="nombre" required="" value="${escuelaInstance?.facultad?.id}" class="many-to-one form-control"/>
                </div>

            </span>
        </div>


        <div class="form-group ${hasErrors(bean: escuelaInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <div class="col-md-3">
                    <g:textField name="codigo" maxlength="8" id="codigoEscuela" required="" class="allCaps form-control required" value="${escuelaInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: escuelaInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <div class="col-md-10">
                    <g:textField name="nombre" maxlength="127" required="" class="allCaps form-control required" value="${escuelaInstance?.nombre}"/>
                </div>
                
            </span>
        </div>
        

        
    </g:form>

    <script type="text/javascript">
        var validator = $("#frmEscuela").validate({
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
            },
            rules         : {
                codigo : {
                    remote: {
                        url : "${createLink(action: 'validar_codigoEscuela_ajax')}",
                        type: "post",
                        data: {
                            cod: $("#codigoEscuela").val(),
                            id: '${escuelaInstance?.id}'

                        }
                    }
                }
            },
            messages      : {
                codigo : {
                    remote: "Ya existe el código de escuela"
                }
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