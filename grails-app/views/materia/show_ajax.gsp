
<%@ page import="docentes.Materia" %>

<g:if test="${!materiaInstance}">
    <elm:notFound elem="Materia" genero="o" />
</g:if>
<g:else>

    <g:if test="${materiaInstance?.escuela}">
        <div class="row">
            <div class="col-md-2 text-info">
                Escuela
            </div>

            <div class="col-md-6">
                ${materiaInstance?.escuela?.nombre?.encodeAsHTML()}
            </div>

        </div>
    </g:if>

    <g:if test="${materiaInstance?.codigo}">
        <div class="row">
            <div class="col-md-2 text-info">
                Código
            </div>
            
            <div class="col-md-6">
                <g:fieldValue bean="${materiaInstance}" field="codigo"/>
            </div>
            
        </div>
    </g:if>
    
    <g:if test="${materiaInstance?.nombre}">
        <div class="row">
            <div class="col-md-2 text-info">
                Nombre
            </div>
            
            <div class="col-md-6">
                <g:fieldValue bean="${materiaInstance}" field="nombre"/>
            </div>
            
        </div>
    </g:if>
    

    
</g:else>