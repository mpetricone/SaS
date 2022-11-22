require("jquery")
function InputMonitor(input, action) {
  this.input = input;
  this.action = action;
}

InputMonitor.attach = function() {
  $(this.input).on("input", () => {
    if ($(this.input).val().length > 1) {
      this.action($(this.input).val())
    }
  });
}

export function Searcher(input, outputList, url, displayValue) {
  InputMonitor.call(this, input, this.runSearch)
  this.outputList = outputList;
  this.url = url;
  this.displayValue = displayValue;
}

Searcher.prototype = Object.create(InputMonitor)

Searcher.prototype.runSearch = function(searchData) {
  $.ajax({
    url: this.url,
    dataType: 'json',
    data: { search_name: searchData },
    success: this.updateList,
    error: this.onError,
    context: this
  });
}

Searcher.prototype.addToList = function(item) {
  $(this.outputList).append("<option value='"+item.id+"'>"+this.displayValue(item)+"</option>");
}

Searcher.prototype.updateList = function(data) {
  $(this.outputList).empty();
  for (let i of data) {
    this.addToList(i);
  }
}

Searcher.prototype.onError = function(data, msg, e) {
  alert("There was a problem Searching. Please try again later.")
}

