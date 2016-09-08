
<%@ page import="docentes.Curso" %>

<g:if test="${!cursoInstance}">
    <elm:notFound elem="Curso" genero="o" />
</g:if>
<g:else>

    <g:if test="${cursoInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${cursoInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>