jQuery ($) ->
  updateNavigationActive =->
    location = document.location.href
    currentPage =
      if location.match(/about/)
        'about'
      else if location.match(/mypage/)
        'mypage'
      else
        ''
    $("\##{currentPage}").addClass('active')

  updateNavigationActive()


  if (flash = $(".flash-container")).length > 0
    flash.click -> $(@).fadeOut()
    flash.show()
    setTimeout (-> flash.fadeOut()), 3000
