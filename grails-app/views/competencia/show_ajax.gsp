
<%@ page import="docentes.Competencia" %>

<g:if test="${!competenciaInstance}">
    <elm:notFound elem="Competencia" genero="o" />
</g:if>
<g:else>

    <g:if test="${competenciaInstance?.carrera}">
        <div class="row">
            <div class="col-md-2 text-info">
                Carrera
            </div>

            <div class="col-md-10">
                ${competenciaInstance?.carrera?.descripcion?.encodeAsHTML()}
            </div>

        </div>
    </g:if>

    <g:if test="${competenciaInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripción
            </div>
            
            <div class="col-md-10">
               ${competenciaInstance?.descripcion}
            </div>
            
        </div>
    </g:if>
    

    
</g:else>