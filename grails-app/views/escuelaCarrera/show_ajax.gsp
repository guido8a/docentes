
<%@ page import="docentes.EscuelaCarrera" %>

<g:if test="${!escuelaCarreraInstance}">
    <elm:notFound elem="EscuelaCarrera" genero="o" />
</g:if>
<g:else>

    <g:if test="${escuelaCarreraInstance?.escuela}">
        <div class="row">
            <div class="col-md-2 text-info">
                Escuela
            </div>
            
            <div class="col-md-8">
                ${escuelaCarreraInstance?.escuela?.nombre?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${escuelaCarreraInstance?.carrera}">
        <div class="row">
            <div class="col-md-2 text-info">
                Carrera
            </div>
            
            <div class="col-md-8">
                ${escuelaCarreraInstance?.carrera?.descripcion?.encodeAsHTML()}
            </div>
            
        </div>
    </g:if>
    
</g:else>