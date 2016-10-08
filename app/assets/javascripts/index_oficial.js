

$(document).ready(function() {
$('#startDatePicker').datetimepicker({
           format: 'dd/mm/yyyy'
       })
       .on('changeDate', function(e) {
           // Revalidate the start date field
           $('#eventForm').bootstrapValidator('revalidateField', 'startDate');
       });

   $('#endDatePicker').datetimepicker({
           format: 'DD/MM/YYYY'
       })
       .on('changeDate', function(e) {
           $('#eventForm').bootstrapValidator('revalidateField', 'endDate');
       });

   $('#eventForm')
       .bootstrapValidator({
           framework: 'bootstrap',
           icon: {
               valid: 'glyphicon glyphicon-ok',
               invalid: 'glyphicon glyphicon-remove',
               validating: 'glyphicon glyphicon-refresh'
           },
           fields: {
               name: {
                   validators: {
                       notEmpty: {
                           message: 'The name is required'
                       }
                   }
               },
               startDate: {
                   validators: {
                       notEmpty: {
                           message: 'The start date is required'
                       },
                       date: {
                           format: 'DD/MM/YYYY',
                           max: 'endDate',
                           message: 'La fecha inicial no es valida'
                       }
                   }
               },
               endDate: {
                   validators: {
                       notEmpty: {
                           message: 'The end date is required'
                       },
                       date: {
                           format: 'DD/MM/YYYY',
                           min: 'startDate',
                           message: 'La fecha final no es valida'
                       }
                   }
               }
           }
       })
       .on('success.field.fv', function(e, data) {
           if (data.field === 'startDate' && !data.fv.isValidField('endDate')) {
               // We need to revalidate the end date
               data.fv.revalidateField('endDate');
           }

           if (data.field === 'endDate' && !data.fv.isValidField('startDate')) {
               // We need to revalidate the start date
               data.fv.revalidateField('startDate');
           }
       });
});
