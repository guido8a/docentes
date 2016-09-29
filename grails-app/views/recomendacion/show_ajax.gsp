
<%@ page import="docentes.Recomendacion" %>

<g:if test="${!recomendacionInstance}">
    <elm:notFound elem="Recomendacion" genero="o" />
</g:if>
<g:else>

    <g:if test="${recomendacionInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripcion
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${recomendacionInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>