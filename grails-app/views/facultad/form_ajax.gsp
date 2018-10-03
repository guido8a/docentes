<%@ page import="docentes.Facultad" %>

<script type="text/javascript" src="${resource(dir: 'js', file: 'ui.js')}"></script>
<g:if test="${!facultadInstance}">
    <elm:notFound elem="Facultad" genero="o" />
</g:if>
<g:else>
    <g:form class="form-horizontal" name="frmFacultad" role="form" action="save" method="POST">
        <g:hiddenField name="id" value="${facultadInstance?.id}" />
        
        <div class="form-group ${hasErrors(bean: facultadInstance, field: 'codigo', 'error')} ">
            <span class="grupo">
                <label for="codigo" class="col-md-2 control-label text-info">
                    Código
                </label>
                <div class="col-md-3">
                    <g:textField name="codigo" id="codigoId" maxlength="8" required="" class="allCaps form-control required" value="${facultadInstance?.codigo}"/>
                </div>
                
            </span>
        </div>
        
        <div class="form-group ${hasErrors(bean: facultadInstance, field: 'nombre', 'error')} ">
            <span class="grupo">
                <label for="nombre" class="col-md-2 control-label text-info">
                    Nombre
                </label>
                <div class="col-md-10">
                    <g:textField name="nombre" maxlength="127" required="" class="allCaps form-control required" value="${facultadInstance?.nombre}"/>
                </div>
                
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: facultadInstance, field: 'universidad', 'error')} ">
            <span class="grupo">
                <label for="universidad" class="col-md-2 control-label text-info">
                    Universidad
                </label>
                <div class="col-md-10">
                    <g:if test="${session.perfil.codigo == 'ADMG'}">
                        <g:select name="universidad" from="${docentes.Universidad.list().sort{it.nombre}}" optionKey="id" optionValue="nombre" value="${facultadInstance?.universidad?.id}" class="form-control required"/>
                    </g:if>
                    <g:else>
                        <g:select name="universidad" from="${docentes.Universidad.list().sort{it.nombre}}" optionKey="id" optionValue="nombre" value="${facultadInstance?.universidad?.id}" class="uni form-control required"/>
                    </g:else>
                </div>

            </span>
        </div>
        
    </g:form>

    <script type="text/javascript">

        if("${session.perfil.codigo != 'ADMG'}"){
            $(".uni").attr("disabled", true)
        }

        var validator = $("#frmFacultad").validate({
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
                        url : "${createLink(action: 'validar_codigo_ajax')}",
                        type: "post",
                        data: {
                            cod: $("#codigoId").val(),
                            id: '${facultadInstance?.id}'

                        }
                    }
                }
            },
            messages      : {
                codigo : {
                    remote: "Ya existe el código de facultad"
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