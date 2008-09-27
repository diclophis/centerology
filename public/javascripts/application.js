// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Event.observe(window, 'load', function () {
  $$("#finding_tag_list").each(function(element) {
    var fieldId = element.id;
    var completions = document.createElement('div');
    completions.id = fieldId + '_auto_complete';
    completions.className = 'completions';
    completions.style.display = 'none';
    element.parentNode.insertBefore(completions, element.nextSibling);
    after_update = function(input,selection) {
      selected_tags = input.value.gsub(/[^a-zA-Z0-9]+/, " ").split(" ").uniq();
      selected_tags.each(function(selected_tag) {
        t = $(selected_tag + '_tag');
        if (t) {
          t.addClassName('selected');
        }
      });
      input.value = selected_tags.join(" ") + " ";
    };
    tags = $$('a.tag').collect(function(a) {
      Event.observe(a, 'click', function(click) {
        if (a.hasClassName("selected")) {
          element.value = element.value.gsub(/[^a-zA-Z0-9]+/, " ").split(" ").uniq().without(a.innerHTML).join(" ");
          a.removeClassName("selected");
        } else {
          element.value += a.innerHTML;
        }
        after_update(element, null);
      });
      return a.innerHTML;
    });
    completer = new Autocompleter.Local(element, completions, tags, {
      tokens: [' '],
      afterUpdateElement: after_update
    });
  });
});
