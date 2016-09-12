
<%@ page import="docentes.Estudiante" %>

<g:if test="${!estudianteInstance}">
    <elm:notFound elem="Estudiante" genero="o" />
</g:if>
<g:else>

    <g:if test="${estudianteInstance?.cedula}">
        <div class="row">
            <div class="col-md-2 text-info">
                Cédula
            </div>
            
            <div class="col-md-2">
                <g:fieldValue bean="${estudianteInstance}" field="cedula"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${estudianteInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nombre
            </div>
            
            <div class="col-md-10">
                <g:fieldValue bean="${estudianteInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${estudianteInstance?.apellido}">
        <div class="row">
            <div class="col-md-2 text-info">
                Apellido
            </div>
            
            <div class="col-md-10">
                <g:fieldValue bean="${estudianteInstance}" field="apellido"/>
            </div>
            
        </div>
    </g:if>
    
</g:else>