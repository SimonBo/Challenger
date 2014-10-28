jQuery ->
  $('#query').autocomplete
    source: $('#query').data('autocomplete-source')

  $('#user-ranking').dataTable()