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






    .board{
        width: 75%;
        margin: 60px auto;
        height: 500px;
        background: #fff;
        /*box-shadow: 10px 10px #ccc,-10px 20px #ddd;*/
    }
    .board .nav-tabs {
        position: relative;
        /* border-bottom: 0; */
        /* width: 80%; */
        margin: 40px auto;
        margin-bottom: 0;
        box-sizing: border-box;

    }

    .board > div.board-inner{
        background: #fafafa url(http://subtlepatterns.com/patterns/geometry2.png);
        background-size: 30%;
    }

    p.narrow{
        width: 60%;
        margin: 10px auto;
    }

    .liner{
        height: 2px;
        background: #ddd;
        position: absolute;
        width: 80%;
        margin: 0 auto;
        left: 0;
        right: 0;
        top: 50%;
        z-index: 1;
    }

    .nav-tabs > li.active > a, .nav-tabs > li.active > a:hover, .nav-tabs > li.active > a:focus {
        color: #555555;
        cursor: default;
        /* background-color: #ffffff; */
        border: 0;
        border-bottom-color: transparent;
    }

    span.round-tabs{
        width: 70px;
        height: 70px;
        line-height: 70px;
        display: inline-block;
        border-radius: 100px;
        background: white;
        z-index: 2;
        position: absolute;
        left: 0;
        text-align: center;
        font-size: 25px;
    }

    span.round-tabs.one{
        color: rgb(34, 194, 34);border: 2px solid rgb(34, 194, 34);
    }

    li.active span.round-tabs.one{
        background: #fff !important;
        border: 2px solid #ddd;
        color: rgb(34, 194, 34);
    }

    span.round-tabs.two{
        color: #febe29;border: 2px solid #febe29;
    }

    li.active span.round-tabs.two{
        background: #fff !important;
        border: 2px solid #ddd;
        color: #febe29;
    }

    span.round-tabs.three{
        color: #3e5e9a;border: 2px solid #3e5e9a;
    }

    li.active span.round-tabs.three{
        background: #fff !important;
        border: 2px solid #ddd;
        color: #3e5e9a;
    }

    span.round-tabs.four{
        color: #f1685e;border: 2px solid #f1685e;
    }

    li.active span.round-tabs.four{
        background: #fff !important;
        border: 2px solid #ddd;
        color: #f1685e;
    }

    span.round-tabs.five{
        color: #999;border: 2px solid #999;
    }

    li.active span.round-tabs.five{
        background: #fff !important;
        border: 2px solid #ddd;
        color: #999;
    }

    .nav-tabs > li.active > a span.round-tabs{
        background: #fafafa;
    }
    .nav-tabs > li {
        width: 20%;
    }
    /*li.active:before {
        content: " ";
        position: absolute;
        left: 45%;
        opacity:0;
        margin: 0 auto;
        bottom: -2px;
        border: 10px solid transparent;
        border-bottom-color: #fff;
        z-index: 1;
        transition:0.2s ease-in-out;
    }*/
    .nav-tabs > li:after {
        content: " ";
        position: absolute;
        left: 45%;
        opacity:0;
        margin: 0 auto;
        bottom: 0px;
        border: 5px solid transparent;
        border-bottom-color: #ddd;
        transition:0.1s ease-in-out;

    }
    .nav-tabs > li.active:after {
        content: " ";
        position: absolute;
        left: 45%;
        opacity:1;
        margin: 0 auto;
        bottom: 0px;
        border: 10px solid transparent;
        border-bottom-color: #ddd;

    }
    .nav-tabs > li a{
        width: 70px;
        height: 70px;
        margin: 20px auto;
        border-radius: 100%;
        padding: 0;
    }

    .nav-tabs > li a:hover{
        background: transparent;
    }

    .tab-content{
    }
    .tab-pane{
        position: relative;
        padding-top: 50px;
    }
    .tab-content .head{
        font-family: 'Roboto Condensed', sans-serif;
        font-size: 25px;
        text-transform: uppercase;
        padding-bottom: 10px;
    }
    .btn-outline-rounded{
        padding: 10px 40px;
        margin: 20px 0;
        border: 2px solid transparent;
        border-radius: 25px;
    }

    .btn.green{
        background-color:#5cb85c;
        /*border: 2px solid #5cb85c;*/
        color: #ffffff;
    }



    @media( max-width : 585px ){

        .board {
            width: 90%;
            height:auto !important;
        }
        span.round-tabs {
            font-size:16px;
            width: 50px;
            height: 50px;
            line-height: 50px;
        }
        .tab-content .head{
            font-size:20px;
        }
        .nav-tabs > li a {
            width: 50px;
            height: 50px;
            line-height:50px;
        }

        .nav-tabs > li.active:after {
            content: " ";
            position: absolute;
            left: 35%;
        }

        .btn-outline-rounded {
            padding:12px 20px;
        }
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


%{--<section style="background:#efefe9;">--}%
    <div class="container">
        <div class="row">
            <div class="board">
                <!-- <h2>Welcome to IGHALO!<sup>™</sup></h2>-->
                <div class="board-inner">
                    <ul class="nav nav-tabs" id="myTab">
                        <div class="liner"></div>
                        <li class="active">
                            <a href="#home" data-toggle="tab" title="welcome">
                                <span class="round-tabs one">
                                    <i class="glyphicon glyphicon-home"></i>
                                </span>
                            </a></li>

                        <li><a href="#profile" data-toggle="tab" title="profile">
                            <span class="round-tabs two">
                                <i class="glyphicon glyphicon-user"></i>
                            </span>
                        </a>
                        </li>
                        <li><a href="#messages" data-toggle="tab" title="bootsnipp goodies">
                            <span class="round-tabs three">
                                <i class="glyphicon glyphicon-gift"></i>
                            </span> </a>
                        </li>

                        <li><a href="#settings" data-toggle="tab" title="blah blah">
                            <span class="round-tabs four">
                                <i class="glyphicon glyphicon-comment"></i>
                            </span>
                        </a></li>

                        <li><a href="#doner" data-toggle="tab" title="completed">
                            <span class="round-tabs five">
                                <i class="glyphicon glyphicon-ok"></i>
                            </span> </a>
                        </li>

                    </ul></div>

                <div class="tab-content">
                    <div class="tab-pane fade in active" id="home">

                        <h3 class="head text-center">Welcome to Bootsnipp<sup>™</sup> <span style="color:#f48260;">♥</span></h3>
                        <p class="narrow text-center">
                            Lorem ipsum dolor sit amet, his ea mollis fabellas principes. Quo mazim facilis tincidunt ut, utinam saperet facilisi an vim.
                        </p>

                        <p class="text-center">
                            <a href="" class="btn btn-success btn-outline-rounded green"> start using bootsnipp <span style="margin-left:10px;" class="glyphicon glyphicon-send"></span></a>
                        </p>
                    </div>
                    <div class="tab-pane fade" id="profile">
                        <h3 class="head text-center">Create a Bootsnipp<sup>™</sup> Profile</h3>
                        <p class="narrow text-center">
                            Lorem ipsum dolor sit amet, his ea mollis fabellas principes. Quo mazim facilis tincidunt ut, utinam saperet facilisi an vim.
                        </p>

                        <p class="text-center">
                            <a href="" class="btn btn-success btn-outline-rounded green"> create your profile <span style="margin-left:10px;" class="glyphicon glyphicon-send"></span></a>
                        </p>

                    </div>
                    <div class="tab-pane fade" id="messages">
                        <h3 class="head text-center">Bootsnipp goodies</h3>
                        <p class="narrow text-center">
                            Lorem ipsum dolor sit amet, his ea mollis fabellas principes. Quo mazim facilis tincidunt ut, utinam saperet facilisi an vim.
                        </p>

                        <p class="text-center">
                            <a href="" class="btn btn-success btn-outline-rounded green"> start using bootsnipp <span style="margin-left:10px;" class="glyphicon glyphicon-send"></span></a>
                        </p>
                    </div>
                    <div class="tab-pane fade" id="settings">
                        <h3 class="head text-center">Drop comments!</h3>
                        <p class="narrow text-center">
                            Lorem ipsum dolor sit amet, his ea mollis fabellas principes. Quo mazim facilis tincidunt ut, utinam saperet facilisi an vim.
                        </p>

                        <p class="text-center">
                            <a href="" class="btn btn-success btn-outline-rounded green"> start using bootsnipp <span style="margin-left:10px;" class="glyphicon glyphicon-send"></span></a>
                        </p>
                    </div>
                    <div class="tab-pane fade" id="doner">
                        <div class="text-center">
                            <i class="img-intro icon-checkmark-circle"></i>
                        </div>
                        <h3 class="head text-center">thanks for staying tuned! <span style="color:#f48260;">♥</span> Bootstrap</h3>
                        <p class="narrow text-center">
                            Lorem ipsum dolor sit amet, his ea mollis fabellas principes. Quo mazim facilis tincidunt ut, utinam saperet facilisi an vim.
                        </p>
                    </div>
                    <div class="clearfix"></div>
                </div>

            </div>
        </div>
    </div>
%{--</section>--}%






<script type="text/javascript">

    $(function(){
        $('a[title]').tooltip();
    });


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