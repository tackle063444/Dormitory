document.addEventListener("DOMContentLoaded", function () {
    $(document).on("click", ".add_list", function (event) {
      event.preventDefault();
      $(this).nestedFields("addFields");
    });
  
    $(document).on("click", ".remove-list", function (event) {
      event.preventDefault();
      $(this).nestedFields("removeFields");
    });
  });
  