<%--
  Created by IntelliJ IDEA.
  User: gato
  Date: 07/02/17
  Time: 11:34
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title></title>
    <style type="text/css">

    .progress {
        height: 35px;

    }
    .progress .skill {
        font: normal 12px "Open Sans Web";
        line-height: 35px;
        padding: 0;
        margin: 0 0 0 20px;
        text-transform: uppercase;
    }
    .progress .skill .val {
        float: right;
        font-style: normal;
        margin: 0 20px 0 0;
    }

    .progress-bar {
        text-align: center;
        transition-duration: 3s;
        font-weight: bold;
        color: #0b0b0b;
    }


    </style>
</head>

<body>

%{--<div class="progress">--}%
%{--<div class="progress-bar progress-bar-success" style="width: 35%">--}%
%{--<span class="sr-only">35% Complete (success)</span>--}%
%{--</div>--}%
%{--<div class="progress-bar progress-bar-warning progress-bar-striped" style="width: 20%">--}%
%{--<span class="sr-only">20% Complete (warning)</span>--}%
%{--</div>--}%
%{--<div class="progress-bar progress-bar-danger" style="width: 10%">--}%
%{--<span class="sr-only">10% Complete (danger)</span>--}%
%{--</div>--}%
%{--</div>--}%

%{--<div class="container">--}%
    %{--<div class="row">--}%
        %{--<h2>Animated Bootstrap Progress Bars by <a href="http://gridgum.com/author/agez" target="_blank">agez</a></h2>--}%
        %{--<!-- Skill Bars -->--}%
        %{--<div class="progress skill-bar ">--}%
            %{--<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100">--}%
                %{--<span class="skill">HTML <i class="val">100%</i></span>--}%
            %{--</div>--}%
        %{--</div>--}%

        %{--<div class="progress skill-bar">--}%
            %{--<div class="progress-bar progress-bar-info" role="progressbar" aria-valuenow="90" aria-valuemin="0" aria-valuemax="100" >--}%
                %{--<span class="skill">CSS<i class="val">90%</i></span>--}%
            %{--</div>--}%
        %{--</div>--}%

        %{--<div class="progress skill-bar">--}%
            %{--<div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100">--}%
                %{--<span class="skill">JavaScript<i class="val">75%</i></span>--}%
            %{--</div>--}%
        %{--</div>--}%

        %{--<div class="progress skill-bar">--}%
            %{--<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="55" aria-valuemin="0" aria-valuemax="100">--}%
                %{--<span class="skill">Photoshop<i class="val">55%</i></span>--}%
            %{--</div>--}%
        %{--</div>--}%

    %{--</div>--}%
%{--</div>--}%

<div class="panel panel-info col-md-12" style="margin-top: 20px" >
    <div class="panel-heading">
        <h3 class="panel-title" style="height: 35px; padding-left: 10px; padding-right: 110px">
            <div class="col-md-7" style="float: left">
                Procesamiento de las encuestas
            </div>

            <div class="col-md-4"> <g:select name="periodo_name" id="periodoId" optionKey="id" optionValue="nombre"
                                             class="form-control" from="${docentes.Periodo.list([sort: 'nombre', order: 'asc'])}"/> </div>

        </h3>
    </div>
    <div class="panel-body">

        <div class="progress progress-striped active">
            <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100">  <span class="fill" data-percentage="50"></span></div>
        </div>

        <div class="container">
            <div class="row">

                <button type="button" class="btn btn-success btnCargar2"><i class="fa fa-check"></i> Iniciar el Proceso</button>

            </div>
        </div>



    </div>
</div>




<script type="text/javascript">


    $(".btnCargar2").click(function () {
        $.ajax({
            type:'POST',
            async: false,
            url: "${createLink(controller: 'reportes2', action: 'progreso')}",
            data:{

            },
            success: function (msg){

                if(msg == 1){
                    $('.progress-bar').css('width', 10+'%').attr('aria-valuenow', 10).text(10 + " %");
                    setTimeout(function () {

                        $.ajax({
                            type: 'POST',
                            async: false,
                            url:"${createLink(controller: 'reportes2', action: 'progreso')}",
                            data:{},
                            success: function (msg) {
                                if (msg == 1) {
                                    $('.progress-bar').css('width', 40 + '%').attr('aria-valuenow', 40).addClass('progress-bar-warning').text(40 + " %");
                                    setTimeout(function () {
                                        $.ajax({
                                            type: 'POST',
                                            url:"${createLink(controller: 'reportes2', action: 'progreso')}",
                                            data:{},
                                            success: function (msg){
                                                if(msg == 1){
                                                    $('.progress-bar').css('width', 100+'%').attr('aria-valuenow', 100).removeClass('progress-bar-warning').addClass('progress-bar-success').text(100 + " %");
                                                }
                                            }

                                        });


                                    },3000)
                                }
                            }
                        });

                    },5000)

                }

            }
        })
    });

    $('input').on('click', function(){
        var valeur = 0;
        $('input:checked').each(function(){
            if ( $(this).attr('value') > valeur )
            {
                valeur =  $(this).attr('value');
            }
        });
        $('.progress-bar').css('width', valeur+'%').attr('aria-valuenow', valeur);
    });


    $(document).ready(function() {
        $('.progress .progress-bar').css("width",
                function() {
                    return $(this).attr("aria-valuenow") + "%";
                }
        )
    });


    var waitingDialog = waitingDialog || (function ($) {
                'use strict';

// Creating modal dialog's DOM
                var $dialog = $(
                        '<div class="modal fade" data-backdrop="static" data-keyboard="false" tabindex="-1" role="dialog" aria-hidden="true" style="padding-top:15%; overflow-y:visible;">' +
                        '<div class="modal-dialog modal-m">' +
                        '<div class="modal-content">' +
                        '<div class="modal-header"><h3 style="margin:0;"></h3></div>' +
                        '<div class="modal-body">' +
                        '<div class="progress progress-striped active" style="margin-bottom:0;"><div class="progress-bar" style="width: 100%"></div></div>' +
                        '</div>' +
                        '</div></div></div>');

                return {
                    /**
                     * Opens our dialog
                     * @param message Custom message
                     * @param options Custom options:
                     * 				  options.dialogSize - bootstrap postfix for dialog size, e.g. "sm", "m";
                     * 				  options.progressType - bootstrap postfix for progress bar type, e.g. "success", "warning".
                     */
                    show: function (message, options) {
// Assigning defaults
                        if (typeof options === 'undefined') {
                            options = {};
                        }
                        if (typeof message === 'undefined') {
                            message = 'Loading';
                        }
                        var settings = $.extend({
                            dialogSize: 'm',
                            progressType: '',
                            onHide: null // This callback runs after the dialog was hidden
                        }, options);

// Configuring dialog
                        $dialog.find('.modal-dialog').attr('class', 'modal-dialog').addClass('modal-' + settings.dialogSize);
                        $dialog.find('.progress-bar').attr('class', 'progress-bar');
                        if (settings.progressType) {
                            $dialog.find('.progress-bar').addClass('progress-bar-' + settings.progressType);
                        }
                        $dialog.find('h3').text(message);
// Adding callbacks
                        if (typeof settings.onHide === 'function') {
                            $dialog.off('hidden.bs.modal').on('hidden.bs.modal', function (e) {
                                settings.onHide.call($dialog);
                            });
                        }
// Opening dialog
                        $dialog.modal();
                    },
                    /**
                     * Closes dialog
                     */
                    hide: function () {
                        $dialog.modal('hide');
                    }
                };

            })(jQuery);



    $(".btnCargar").click(function () {
        waitingDialog.show("cargando....")
    });



</script>

</body>
</html>