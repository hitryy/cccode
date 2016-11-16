function change_language(el) {
    var selected_language = el.options[el.selectedIndex].value
    var codemirror_language_mode = "";
    var default_code = "";

    switch(selected_language) {
        case 'C':
            codemirror_language_mode = "text/x-csrc";
            default_code = "int main() {\n\treturn 0;\n}"
            break;
        case 'C++':
            codemirror_language_mode = "text/x-c++src";
            default_code = "#include <iostream>\n\nusing namespace std;\n\nint main() {\n\tcout << \"Hello, world\";\n\treturn 0;\n}"
            break;
        case 'HTML':
            codemirror_language_mode = "text/html";
            break;
    };

    this.window.codemirror_editor['code_editor'].setOption("mode", codemirror_language_mode)
    this.window.codemirror_editor['code_editor'].setValue(default_code)
}