
<%@ page import="docentes.Facultad" %>

<g:if test="${!facultadInstance}">
    <elm:notFound elem="Facultad" genero="o" />
</g:if>
<g:else>

    <g:if test="${facultadInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${facultadInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${facultadInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${facultadInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>