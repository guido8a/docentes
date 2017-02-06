<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 03/02/17
  Time: 10:40
--%>

<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js/vendor', file: 'jquery.ui.widget.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js/imgResize', file: 'load-image.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js/imgResize', file: 'canvas-to-blob.min.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js', file: 'jquery.iframe-transport.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js', file: 'jquery.fileupload.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js', file: 'jquery.fileupload-process.js')}"></script>
<script src="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/js', file: 'jquery.fileupload-image.js')}"></script>
<link href="${resource(dir: 'js/plugins/jQuery-File-Upload-9.5.6/css', file: 'jquery.fileupload.css')}" rel="stylesheet">

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Cargar Datos</title>
    <style type="text/css">

        .conBorde {
            border: 1px;
            border-color: #5c6e80;
            border-style: solid;
        }

    </style>

</head>

<body>
<div class="col-md-3" id="botones">

</div>

<div class="col-md-8">
    <div class="panel panel-primary">
        <div class="panel-heading">Formato de los archivos Excel (.xls)</div>
        <div class="panel-body" id="formato">

        </div>
    </div>
</div>

<div class="col-md-8">
    <div class="panel panel-primary">
        <div class="panel-heading">Seleccionar Archivo</div>
        <div class="panel-body">
                <span class="btn btn-info fileinput-button" style="position: relative">
                    %{--<i class="glyphicon glyphicon-plus"></i>--}%
                    %{--<span>Seleccionar archivo</span>--}%
                    <input type="file" name="file" multiple="" id="archi" class="archivo">
                </span>
        </div>
    </div>
</div>


<script type="text/javascript">

    cargarBotones(1);

    function cargarBotones (boton) {
        $.ajax({
           type: 'POST',
            url: '${createLink(controller: 'reportes2', action: 'botones_ajax')}',
            data: {
                boton: boton
            },
            success: function (msg){
            $("#botones").html(msg)
            }
        });
    }

    cargarFormato(1);

    function cargarFormato (tipo) {
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'reportes2', action: 'formato_ajax')}",
            data:{
               tipo: tipo
            },
            success: function (msg) {
                $("#formato").html(msg)
            }
        })
    }


    %{--$(".archivo").click(function () {--}%
        %{--var idA = $(this).data('id');--}%
        %{--var prea = $(this).data('pre');--}%
        %{--//        $('#file').fileupload({--}%
        %{--$('.archivo').fileupload({--}%

            %{--url              : '${createLink(action:'uploadFile')}?id=' + idA + "&pre=" + prea,--}%
            %{--dataType         : 'json',--}%
            %{--maxNumberOfFiles : 3,--}%
            %{--ida: $(this).data("id"),--}%
            %{--acceptFileTypes  : /(\.|\/)(jpe?g|png)$/i--}%
%{--//            ,--}%
%{--//            maxFileSize      : 10000000 // 1 MB--}%
        %{--}).on('fileuploadadd', function (e, data) {--}%
%{--//                    console.log("fileuploadadd");--}%
            %{--openLoader("Cargando");--}%
            %{--data.context = $('<div/>').appendTo('#files');--}%
            %{--$.each(data.files, function (index, file) {--}%
                %{--var node = $('<p/>')--}%
                        %{--.append($('<span/>').text(file.name));--}%
                %{--if (!index) {--}%
                    %{--node--}%
                            %{--.append('<br>');--}%
                %{--}--}%
                %{--node.appendTo(data.context);--}%
            %{--});--}%
        %{--}).on('fileuploadprocessalways', function (e, data) {--}%
%{--//                    console.log("fileuploadprocessalways");--}%
            %{--var index = data.index,--}%
                    %{--file = data.files[index],--}%
                    %{--node = $(data.context.children()[index]);--}%
            %{--if (file.preview) {--}%
                %{--node--}%
                        %{--.prepend('<br>')--}%
                        %{--.prepend(file.preview);--}%
            %{--}--}%
            %{--if (file.error) {--}%
                %{--node--}%
                        %{--.append('<br>')--}%
                        %{--.append($('<span class="text-danger"/>').text(file.error));--}%
            %{--}--}%
            %{--if (index + 1 === data.files.length) {--}%
                %{--data.context.find('button')--}%
                        %{--.text('Upload')--}%
                        %{--.prop('disabled', !!data.files.error);--}%
            %{--}--}%
        %{--}).on('fileuploadprogressall', function (e, data) {--}%
            %{--var progress = parseInt(data.loaded / data.total * 100, 10);--}%
            %{--$('#progress .progress-bar').css(--}%
                    %{--'width',--}%
                    %{--progress + '%'--}%
            %{--);--}%
        %{--}).on('fileuploaddone', function (e, data) {--}%
            %{--cargarImagen(${objetivoInstance?.id});--}%

%{--//        setTimeout(function () {--}%
%{--//            $('#progress .progress-bar').css(--}%
%{--//                    'width',--}%
%{--//                    0 + '%'--}%
%{--//            );--}%
%{--//        }, 700);--}%
            %{--setTimeout(function () {--}%
                %{--cargarAcordeon();--}%
            %{--}, 1000);--}%
        %{--}).on('fileuploadfail', function (e, data) {--}%
            %{--closeLoader();--}%
            %{--$.each(data.files, function (index, file) {--}%
                %{--var error = $('<span class="text-danger"/>').text('File upload failed.');--}%
                %{--$(data.context.children()[index])--}%
                        %{--.append('<br>')--}%
                        %{--.append(error);--}%
            %{--});--}%
        %{--});--}%


    %{--});--}%


</script>


</body>
</html>