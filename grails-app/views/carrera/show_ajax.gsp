
<%@ page import="docentes.Carrera" %>

<g:if test="${!carreraInstance}">
    <elm:notFound elem="Carrera" genero="o" />
</g:if>
<g:else>

    <g:if test="${carreraInstance?.descripcion}">
        <div class="row">
            <div class="col-md-2 text-info">
                Descripción
            </div>
            
            <div class="col-md-8">
                <g:fieldValue bean="${carreraInstance}" field="descripcion"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>