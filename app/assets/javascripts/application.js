// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require jquery
//= require jquery_ujs
//= require materialize-sprockets
//= require_tree .

//= require codemirror
//= require codemirror/modes/xml
//= require codemirror/modes/javascript
//= require codemirror/modes/htmlmixed
//= require codemirror/modes/clike

window.codemirror_editor = {};

$(function() {
    $('#code_editor').each(function () {
        var $el = $(this);

        codemirror_editor[$el.attr('id')] = CodeMirror.fromTextArea($el[0],
            {
                mode: "text/x-c++src",
                tabMode: "indent",
                textWrapping: false,
                lineNumbers: true,
            });
    });
});

function setDefaultCode() {
    this.window.codemirror_editor['code_editor'].setValue("#include <iostream>\nusing namespace std;\n\nint main() {\n\tcout << \"Hello, world\";\n\treturn 0;\n}")
}