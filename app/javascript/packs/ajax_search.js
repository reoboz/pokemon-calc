$('.js-search').on('change', function(){
  $.ajax({
    type: 'get',
    url: '/ajax/search',
    dataType: 'json',
    data: "name="+$('.js-search').val(),
    success: function(result) {

    }
  })
})