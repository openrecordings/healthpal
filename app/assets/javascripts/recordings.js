// TODO: Used across controllers, should be kept elsewhere

// Register editable fields
$(document).ready(function() {
    ['text', 'provider', 'patient_identifier'].forEach(function(c){
        var field = $('.edit_' + c);
        if(field.length > 0) {
            field.editable({
                type: 'text',
                name: c,
                mode: 'inline',
                inputclass: 'editable-input',
                value: '',
                placeholder: $(field[0]).text() // All of the same kind of field have same placeholders
            });
        }
    });
});
