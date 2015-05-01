
$("#baptism_section").hide();
$("#mate_section").hide();
$("#student_section").hide();
$("#employee_section").hide();

$("#devoted_status_id").change(function() {
  var status = this.options[this.selectedIndex].text;

  if (status == 'Baptisé'){
    $("#baptism_section").show('slow');
  }
  else{
    $("#baptism_section").hide('slow');
  }
});

$("#devoted_marital_status_id").change(function() {
  var marital_status = this.options[this.selectedIndex].text;
  var marital_status_list = ['Marié (e)', 'Fiancé (e)', 'Concubin (e)', 'Veuf (ve)']

  if ($.inArray(marital_status, marital_status_list) > -1 ){
    $("#mate_section").show('slow');
  }
  else{
    $("#mate_section").hide('slow');
  }
});

$("#devoted_social_status_id").change(function() {
  var status = this.options[this.selectedIndex].text;

  if (status == 'Elève'){
    $("#student_section").show('slow');
    $("#employee_section").hide('slow');
  }
  if (status == 'Employé'){
    $("#student_section").hide('slow');
    $("#employee_section").show('slow');
  }
});
