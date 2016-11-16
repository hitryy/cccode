function change_language(el) {
    var selected_language = el.options[el.selectedIndex].value;
    var editor_content = this.window.codemirror_editor['code_editor'].getValue();
    var language_mode = "";
    var default_code = "";

    switch(selected_language) {
        case 'C++':
            language_mode = "text/x-c++src";
            default_code = default_cpp_code()
            break;
        case 'C':
            language_mode = "text/x-csrc";
            default_code = default_c_code()
            break;
        case 'C++ (Windows)':
            language_mode = "text/x-c++src";
            default_code = default_cpp_code();
            break;
        default:
            default_code = editor_content
    };

    this.window.codemirror_editor['code_editor'].setOption("mode", language_mode)

    if (editor_content == default_cpp_code() || editor_content == default_c_code() || editor_content == "") {
        this.window.codemirror_editor['code_editor'].setValue(default_code)
    }
}

function default_cpp_code() {
    code = "\#include <iostream>\n\nusing namespace std;\n\nint main() {\n\tcout << \"Hello, world\";\n\treturn 0;\n}"
    return code;
}

function default_c_code() {
    code = "int main() {\n\treturn 0;\n}";
    return code;
}