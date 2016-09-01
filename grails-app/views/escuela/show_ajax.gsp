
<%@ page import="docentes.Escuela" %>

<g:if test="${!escuelaInstance}">
    <elm:notFound elem="Escuela" genero="o" />
</g:if>
<g:else>

    <g:if test="${escuelaInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Codigo
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${escuelaInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${escuelaInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nombre
            </div>
            
            <div class="col-md-3">
                <g:fieldValue bean="${escuelaInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${escuelaInstance?.facultad}">
        <div class="row">
            <div class="col-md-2 text-info">
                Facultad
            </div>
            
            <div class="col-md-3">
                ${escuelaInstance?.facultad?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>